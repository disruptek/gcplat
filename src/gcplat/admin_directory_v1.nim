
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597437): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdminChannelsStop_597705 = ref object of OpenApiRestCall_597437
proc url_AdminChannelsStop_597707(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdminChannelsStop_597706(path: JsonNode; query: JsonNode;
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
  var valid_597819 = query.getOrDefault("fields")
  valid_597819 = validateParameter(valid_597819, JString, required = false,
                                 default = nil)
  if valid_597819 != nil:
    section.add "fields", valid_597819
  var valid_597820 = query.getOrDefault("quotaUser")
  valid_597820 = validateParameter(valid_597820, JString, required = false,
                                 default = nil)
  if valid_597820 != nil:
    section.add "quotaUser", valid_597820
  var valid_597834 = query.getOrDefault("alt")
  valid_597834 = validateParameter(valid_597834, JString, required = false,
                                 default = newJString("json"))
  if valid_597834 != nil:
    section.add "alt", valid_597834
  var valid_597835 = query.getOrDefault("oauth_token")
  valid_597835 = validateParameter(valid_597835, JString, required = false,
                                 default = nil)
  if valid_597835 != nil:
    section.add "oauth_token", valid_597835
  var valid_597836 = query.getOrDefault("userIp")
  valid_597836 = validateParameter(valid_597836, JString, required = false,
                                 default = nil)
  if valid_597836 != nil:
    section.add "userIp", valid_597836
  var valid_597837 = query.getOrDefault("key")
  valid_597837 = validateParameter(valid_597837, JString, required = false,
                                 default = nil)
  if valid_597837 != nil:
    section.add "key", valid_597837
  var valid_597838 = query.getOrDefault("prettyPrint")
  valid_597838 = validateParameter(valid_597838, JBool, required = false,
                                 default = newJBool(true))
  if valid_597838 != nil:
    section.add "prettyPrint", valid_597838
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

proc call*(call_597862: Call_AdminChannelsStop_597705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_597862.validator(path, query, header, formData, body)
  let scheme = call_597862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597862.url(scheme.get, call_597862.host, call_597862.base,
                         call_597862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597862, url, valid)

proc call*(call_597933: Call_AdminChannelsStop_597705; fields: string = "";
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
  var query_597934 = newJObject()
  var body_597936 = newJObject()
  add(query_597934, "fields", newJString(fields))
  add(query_597934, "quotaUser", newJString(quotaUser))
  add(query_597934, "alt", newJString(alt))
  add(query_597934, "oauth_token", newJString(oauthToken))
  add(query_597934, "userIp", newJString(userIp))
  add(query_597934, "key", newJString(key))
  if resource != nil:
    body_597936 = resource
  add(query_597934, "prettyPrint", newJBool(prettyPrint))
  result = call_597933.call(nil, query_597934, nil, nil, body_597936)

var adminChannelsStop* = Call_AdminChannelsStop_597705(name: "adminChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/admin/directory_v1/channels/stop",
    validator: validate_AdminChannelsStop_597706, base: "/admin/directory/v1",
    url: url_AdminChannelsStop_597707, schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesList_597975 = ref object of OpenApiRestCall_597437
proc url_DirectoryChromeosdevicesList_597977(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryChromeosdevicesList_597976(path: JsonNode; query: JsonNode;
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
  var valid_597992 = path.getOrDefault("customerId")
  valid_597992 = validateParameter(valid_597992, JString, required = true,
                                 default = nil)
  if valid_597992 != nil:
    section.add "customerId", valid_597992
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
  var valid_597993 = query.getOrDefault("fields")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "fields", valid_597993
  var valid_597994 = query.getOrDefault("pageToken")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "pageToken", valid_597994
  var valid_597995 = query.getOrDefault("quotaUser")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "quotaUser", valid_597995
  var valid_597996 = query.getOrDefault("alt")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = newJString("json"))
  if valid_597996 != nil:
    section.add "alt", valid_597996
  var valid_597997 = query.getOrDefault("query")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "query", valid_597997
  var valid_597998 = query.getOrDefault("orgUnitPath")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "orgUnitPath", valid_597998
  var valid_597999 = query.getOrDefault("oauth_token")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "oauth_token", valid_597999
  var valid_598000 = query.getOrDefault("userIp")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "userIp", valid_598000
  var valid_598002 = query.getOrDefault("maxResults")
  valid_598002 = validateParameter(valid_598002, JInt, required = false,
                                 default = newJInt(100))
  if valid_598002 != nil:
    section.add "maxResults", valid_598002
  var valid_598003 = query.getOrDefault("orderBy")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = newJString("annotatedLocation"))
  if valid_598003 != nil:
    section.add "orderBy", valid_598003
  var valid_598004 = query.getOrDefault("key")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "key", valid_598004
  var valid_598005 = query.getOrDefault("projection")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_598005 != nil:
    section.add "projection", valid_598005
  var valid_598006 = query.getOrDefault("sortOrder")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_598006 != nil:
    section.add "sortOrder", valid_598006
  var valid_598007 = query.getOrDefault("prettyPrint")
  valid_598007 = validateParameter(valid_598007, JBool, required = false,
                                 default = newJBool(true))
  if valid_598007 != nil:
    section.add "prettyPrint", valid_598007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598008: Call_DirectoryChromeosdevicesList_597975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all Chrome OS Devices of a customer (paginated)
  ## 
  let valid = call_598008.validator(path, query, header, formData, body)
  let scheme = call_598008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598008.url(scheme.get, call_598008.host, call_598008.base,
                         call_598008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598008, url, valid)

proc call*(call_598009: Call_DirectoryChromeosdevicesList_597975;
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
  var path_598010 = newJObject()
  var query_598011 = newJObject()
  add(query_598011, "fields", newJString(fields))
  add(query_598011, "pageToken", newJString(pageToken))
  add(query_598011, "quotaUser", newJString(quotaUser))
  add(query_598011, "alt", newJString(alt))
  add(query_598011, "query", newJString(query))
  add(query_598011, "orgUnitPath", newJString(orgUnitPath))
  add(query_598011, "oauth_token", newJString(oauthToken))
  add(query_598011, "userIp", newJString(userIp))
  add(query_598011, "maxResults", newJInt(maxResults))
  add(query_598011, "orderBy", newJString(orderBy))
  add(path_598010, "customerId", newJString(customerId))
  add(query_598011, "key", newJString(key))
  add(query_598011, "projection", newJString(projection))
  add(query_598011, "sortOrder", newJString(sortOrder))
  add(query_598011, "prettyPrint", newJBool(prettyPrint))
  result = call_598009.call(path_598010, query_598011, nil, nil, nil)

var directoryChromeosdevicesList* = Call_DirectoryChromeosdevicesList_597975(
    name: "directoryChromeosdevicesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/devices/chromeos",
    validator: validate_DirectoryChromeosdevicesList_597976,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesList_597977,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesMoveDevicesToOu_598012 = ref object of OpenApiRestCall_597437
proc url_DirectoryChromeosdevicesMoveDevicesToOu_598014(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryChromeosdevicesMoveDevicesToOu_598013(path: JsonNode;
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
  var valid_598015 = path.getOrDefault("customerId")
  valid_598015 = validateParameter(valid_598015, JString, required = true,
                                 default = nil)
  if valid_598015 != nil:
    section.add "customerId", valid_598015
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
  var valid_598016 = query.getOrDefault("fields")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "fields", valid_598016
  var valid_598017 = query.getOrDefault("quotaUser")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "quotaUser", valid_598017
  var valid_598018 = query.getOrDefault("alt")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = newJString("json"))
  if valid_598018 != nil:
    section.add "alt", valid_598018
  assert query != nil,
        "query argument is necessary due to required `orgUnitPath` field"
  var valid_598019 = query.getOrDefault("orgUnitPath")
  valid_598019 = validateParameter(valid_598019, JString, required = true,
                                 default = nil)
  if valid_598019 != nil:
    section.add "orgUnitPath", valid_598019
  var valid_598020 = query.getOrDefault("oauth_token")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "oauth_token", valid_598020
  var valid_598021 = query.getOrDefault("userIp")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "userIp", valid_598021
  var valid_598022 = query.getOrDefault("key")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = nil)
  if valid_598022 != nil:
    section.add "key", valid_598022
  var valid_598023 = query.getOrDefault("prettyPrint")
  valid_598023 = validateParameter(valid_598023, JBool, required = false,
                                 default = newJBool(true))
  if valid_598023 != nil:
    section.add "prettyPrint", valid_598023
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

proc call*(call_598025: Call_DirectoryChromeosdevicesMoveDevicesToOu_598012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Move or insert multiple Chrome OS Devices to organizational unit
  ## 
  let valid = call_598025.validator(path, query, header, formData, body)
  let scheme = call_598025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598025.url(scheme.get, call_598025.host, call_598025.base,
                         call_598025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598025, url, valid)

proc call*(call_598026: Call_DirectoryChromeosdevicesMoveDevicesToOu_598012;
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
  var path_598027 = newJObject()
  var query_598028 = newJObject()
  var body_598029 = newJObject()
  add(query_598028, "fields", newJString(fields))
  add(query_598028, "quotaUser", newJString(quotaUser))
  add(query_598028, "alt", newJString(alt))
  add(query_598028, "orgUnitPath", newJString(orgUnitPath))
  add(query_598028, "oauth_token", newJString(oauthToken))
  add(query_598028, "userIp", newJString(userIp))
  add(path_598027, "customerId", newJString(customerId))
  add(query_598028, "key", newJString(key))
  if body != nil:
    body_598029 = body
  add(query_598028, "prettyPrint", newJBool(prettyPrint))
  result = call_598026.call(path_598027, query_598028, nil, nil, body_598029)

var directoryChromeosdevicesMoveDevicesToOu* = Call_DirectoryChromeosdevicesMoveDevicesToOu_598012(
    name: "directoryChromeosdevicesMoveDevicesToOu", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/moveDevicesToOu",
    validator: validate_DirectoryChromeosdevicesMoveDevicesToOu_598013,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesMoveDevicesToOu_598014,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesUpdate_598047 = ref object of OpenApiRestCall_597437
proc url_DirectoryChromeosdevicesUpdate_598049(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryChromeosdevicesUpdate_598048(path: JsonNode;
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
  var valid_598050 = path.getOrDefault("deviceId")
  valid_598050 = validateParameter(valid_598050, JString, required = true,
                                 default = nil)
  if valid_598050 != nil:
    section.add "deviceId", valid_598050
  var valid_598051 = path.getOrDefault("customerId")
  valid_598051 = validateParameter(valid_598051, JString, required = true,
                                 default = nil)
  if valid_598051 != nil:
    section.add "customerId", valid_598051
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
  var valid_598052 = query.getOrDefault("fields")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "fields", valid_598052
  var valid_598053 = query.getOrDefault("quotaUser")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "quotaUser", valid_598053
  var valid_598054 = query.getOrDefault("alt")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = newJString("json"))
  if valid_598054 != nil:
    section.add "alt", valid_598054
  var valid_598055 = query.getOrDefault("oauth_token")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "oauth_token", valid_598055
  var valid_598056 = query.getOrDefault("userIp")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "userIp", valid_598056
  var valid_598057 = query.getOrDefault("key")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "key", valid_598057
  var valid_598058 = query.getOrDefault("projection")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_598058 != nil:
    section.add "projection", valid_598058
  var valid_598059 = query.getOrDefault("prettyPrint")
  valid_598059 = validateParameter(valid_598059, JBool, required = false,
                                 default = newJBool(true))
  if valid_598059 != nil:
    section.add "prettyPrint", valid_598059
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

proc call*(call_598061: Call_DirectoryChromeosdevicesUpdate_598047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Chrome OS Device
  ## 
  let valid = call_598061.validator(path, query, header, formData, body)
  let scheme = call_598061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598061.url(scheme.get, call_598061.host, call_598061.base,
                         call_598061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598061, url, valid)

proc call*(call_598062: Call_DirectoryChromeosdevicesUpdate_598047;
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
  var path_598063 = newJObject()
  var query_598064 = newJObject()
  var body_598065 = newJObject()
  add(query_598064, "fields", newJString(fields))
  add(query_598064, "quotaUser", newJString(quotaUser))
  add(query_598064, "alt", newJString(alt))
  add(path_598063, "deviceId", newJString(deviceId))
  add(query_598064, "oauth_token", newJString(oauthToken))
  add(query_598064, "userIp", newJString(userIp))
  add(path_598063, "customerId", newJString(customerId))
  add(query_598064, "key", newJString(key))
  add(query_598064, "projection", newJString(projection))
  if body != nil:
    body_598065 = body
  add(query_598064, "prettyPrint", newJBool(prettyPrint))
  result = call_598062.call(path_598063, query_598064, nil, nil, body_598065)

var directoryChromeosdevicesUpdate* = Call_DirectoryChromeosdevicesUpdate_598047(
    name: "directoryChromeosdevicesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesUpdate_598048,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesUpdate_598049,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesGet_598030 = ref object of OpenApiRestCall_597437
proc url_DirectoryChromeosdevicesGet_598032(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryChromeosdevicesGet_598031(path: JsonNode; query: JsonNode;
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
  var valid_598033 = path.getOrDefault("deviceId")
  valid_598033 = validateParameter(valid_598033, JString, required = true,
                                 default = nil)
  if valid_598033 != nil:
    section.add "deviceId", valid_598033
  var valid_598034 = path.getOrDefault("customerId")
  valid_598034 = validateParameter(valid_598034, JString, required = true,
                                 default = nil)
  if valid_598034 != nil:
    section.add "customerId", valid_598034
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
  var valid_598035 = query.getOrDefault("fields")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "fields", valid_598035
  var valid_598036 = query.getOrDefault("quotaUser")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "quotaUser", valid_598036
  var valid_598037 = query.getOrDefault("alt")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = newJString("json"))
  if valid_598037 != nil:
    section.add "alt", valid_598037
  var valid_598038 = query.getOrDefault("oauth_token")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "oauth_token", valid_598038
  var valid_598039 = query.getOrDefault("userIp")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "userIp", valid_598039
  var valid_598040 = query.getOrDefault("key")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "key", valid_598040
  var valid_598041 = query.getOrDefault("projection")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_598041 != nil:
    section.add "projection", valid_598041
  var valid_598042 = query.getOrDefault("prettyPrint")
  valid_598042 = validateParameter(valid_598042, JBool, required = false,
                                 default = newJBool(true))
  if valid_598042 != nil:
    section.add "prettyPrint", valid_598042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598043: Call_DirectoryChromeosdevicesGet_598030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Chrome OS Device
  ## 
  let valid = call_598043.validator(path, query, header, formData, body)
  let scheme = call_598043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598043.url(scheme.get, call_598043.host, call_598043.base,
                         call_598043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598043, url, valid)

proc call*(call_598044: Call_DirectoryChromeosdevicesGet_598030; deviceId: string;
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
  var path_598045 = newJObject()
  var query_598046 = newJObject()
  add(query_598046, "fields", newJString(fields))
  add(query_598046, "quotaUser", newJString(quotaUser))
  add(query_598046, "alt", newJString(alt))
  add(path_598045, "deviceId", newJString(deviceId))
  add(query_598046, "oauth_token", newJString(oauthToken))
  add(query_598046, "userIp", newJString(userIp))
  add(path_598045, "customerId", newJString(customerId))
  add(query_598046, "key", newJString(key))
  add(query_598046, "projection", newJString(projection))
  add(query_598046, "prettyPrint", newJBool(prettyPrint))
  result = call_598044.call(path_598045, query_598046, nil, nil, nil)

var directoryChromeosdevicesGet* = Call_DirectoryChromeosdevicesGet_598030(
    name: "directoryChromeosdevicesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesGet_598031,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesGet_598032,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesPatch_598066 = ref object of OpenApiRestCall_597437
proc url_DirectoryChromeosdevicesPatch_598068(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryChromeosdevicesPatch_598067(path: JsonNode; query: JsonNode;
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
  var valid_598069 = path.getOrDefault("deviceId")
  valid_598069 = validateParameter(valid_598069, JString, required = true,
                                 default = nil)
  if valid_598069 != nil:
    section.add "deviceId", valid_598069
  var valid_598070 = path.getOrDefault("customerId")
  valid_598070 = validateParameter(valid_598070, JString, required = true,
                                 default = nil)
  if valid_598070 != nil:
    section.add "customerId", valid_598070
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
  var valid_598071 = query.getOrDefault("fields")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "fields", valid_598071
  var valid_598072 = query.getOrDefault("quotaUser")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "quotaUser", valid_598072
  var valid_598073 = query.getOrDefault("alt")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = newJString("json"))
  if valid_598073 != nil:
    section.add "alt", valid_598073
  var valid_598074 = query.getOrDefault("oauth_token")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "oauth_token", valid_598074
  var valid_598075 = query.getOrDefault("userIp")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "userIp", valid_598075
  var valid_598076 = query.getOrDefault("key")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "key", valid_598076
  var valid_598077 = query.getOrDefault("projection")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_598077 != nil:
    section.add "projection", valid_598077
  var valid_598078 = query.getOrDefault("prettyPrint")
  valid_598078 = validateParameter(valid_598078, JBool, required = false,
                                 default = newJBool(true))
  if valid_598078 != nil:
    section.add "prettyPrint", valid_598078
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

proc call*(call_598080: Call_DirectoryChromeosdevicesPatch_598066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Chrome OS Device. This method supports patch semantics.
  ## 
  let valid = call_598080.validator(path, query, header, formData, body)
  let scheme = call_598080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598080.url(scheme.get, call_598080.host, call_598080.base,
                         call_598080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598080, url, valid)

proc call*(call_598081: Call_DirectoryChromeosdevicesPatch_598066;
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
  var path_598082 = newJObject()
  var query_598083 = newJObject()
  var body_598084 = newJObject()
  add(query_598083, "fields", newJString(fields))
  add(query_598083, "quotaUser", newJString(quotaUser))
  add(query_598083, "alt", newJString(alt))
  add(path_598082, "deviceId", newJString(deviceId))
  add(query_598083, "oauth_token", newJString(oauthToken))
  add(query_598083, "userIp", newJString(userIp))
  add(path_598082, "customerId", newJString(customerId))
  add(query_598083, "key", newJString(key))
  add(query_598083, "projection", newJString(projection))
  if body != nil:
    body_598084 = body
  add(query_598083, "prettyPrint", newJBool(prettyPrint))
  result = call_598081.call(path_598082, query_598083, nil, nil, body_598084)

var directoryChromeosdevicesPatch* = Call_DirectoryChromeosdevicesPatch_598066(
    name: "directoryChromeosdevicesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesPatch_598067,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesPatch_598068,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesAction_598085 = ref object of OpenApiRestCall_597437
proc url_DirectoryChromeosdevicesAction_598087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryChromeosdevicesAction_598086(path: JsonNode;
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
  var valid_598088 = path.getOrDefault("customerId")
  valid_598088 = validateParameter(valid_598088, JString, required = true,
                                 default = nil)
  if valid_598088 != nil:
    section.add "customerId", valid_598088
  var valid_598089 = path.getOrDefault("resourceId")
  valid_598089 = validateParameter(valid_598089, JString, required = true,
                                 default = nil)
  if valid_598089 != nil:
    section.add "resourceId", valid_598089
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
  var valid_598090 = query.getOrDefault("fields")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "fields", valid_598090
  var valid_598091 = query.getOrDefault("quotaUser")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "quotaUser", valid_598091
  var valid_598092 = query.getOrDefault("alt")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = newJString("json"))
  if valid_598092 != nil:
    section.add "alt", valid_598092
  var valid_598093 = query.getOrDefault("oauth_token")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "oauth_token", valid_598093
  var valid_598094 = query.getOrDefault("userIp")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "userIp", valid_598094
  var valid_598095 = query.getOrDefault("key")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "key", valid_598095
  var valid_598096 = query.getOrDefault("prettyPrint")
  valid_598096 = validateParameter(valid_598096, JBool, required = false,
                                 default = newJBool(true))
  if valid_598096 != nil:
    section.add "prettyPrint", valid_598096
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

proc call*(call_598098: Call_DirectoryChromeosdevicesAction_598085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take action on Chrome OS Device
  ## 
  let valid = call_598098.validator(path, query, header, formData, body)
  let scheme = call_598098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598098.url(scheme.get, call_598098.host, call_598098.base,
                         call_598098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598098, url, valid)

proc call*(call_598099: Call_DirectoryChromeosdevicesAction_598085;
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
  var path_598100 = newJObject()
  var query_598101 = newJObject()
  var body_598102 = newJObject()
  add(query_598101, "fields", newJString(fields))
  add(query_598101, "quotaUser", newJString(quotaUser))
  add(query_598101, "alt", newJString(alt))
  add(query_598101, "oauth_token", newJString(oauthToken))
  add(query_598101, "userIp", newJString(userIp))
  add(path_598100, "customerId", newJString(customerId))
  add(query_598101, "key", newJString(key))
  add(path_598100, "resourceId", newJString(resourceId))
  if body != nil:
    body_598102 = body
  add(query_598101, "prettyPrint", newJBool(prettyPrint))
  result = call_598099.call(path_598100, query_598101, nil, nil, body_598102)

var directoryChromeosdevicesAction* = Call_DirectoryChromeosdevicesAction_598085(
    name: "directoryChromeosdevicesAction", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{resourceId}/action",
    validator: validate_DirectoryChromeosdevicesAction_598086,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesAction_598087,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesList_598103 = ref object of OpenApiRestCall_597437
proc url_DirectoryMobiledevicesList_598105(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryMobiledevicesList_598104(path: JsonNode; query: JsonNode;
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
  var valid_598106 = path.getOrDefault("customerId")
  valid_598106 = validateParameter(valid_598106, JString, required = true,
                                 default = nil)
  if valid_598106 != nil:
    section.add "customerId", valid_598106
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
  var valid_598107 = query.getOrDefault("fields")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "fields", valid_598107
  var valid_598108 = query.getOrDefault("pageToken")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = nil)
  if valid_598108 != nil:
    section.add "pageToken", valid_598108
  var valid_598109 = query.getOrDefault("quotaUser")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = nil)
  if valid_598109 != nil:
    section.add "quotaUser", valid_598109
  var valid_598110 = query.getOrDefault("alt")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = newJString("json"))
  if valid_598110 != nil:
    section.add "alt", valid_598110
  var valid_598111 = query.getOrDefault("query")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "query", valid_598111
  var valid_598112 = query.getOrDefault("oauth_token")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "oauth_token", valid_598112
  var valid_598113 = query.getOrDefault("userIp")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = nil)
  if valid_598113 != nil:
    section.add "userIp", valid_598113
  var valid_598114 = query.getOrDefault("maxResults")
  valid_598114 = validateParameter(valid_598114, JInt, required = false,
                                 default = newJInt(100))
  if valid_598114 != nil:
    section.add "maxResults", valid_598114
  var valid_598115 = query.getOrDefault("orderBy")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = newJString("deviceId"))
  if valid_598115 != nil:
    section.add "orderBy", valid_598115
  var valid_598116 = query.getOrDefault("key")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "key", valid_598116
  var valid_598117 = query.getOrDefault("projection")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_598117 != nil:
    section.add "projection", valid_598117
  var valid_598118 = query.getOrDefault("sortOrder")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_598118 != nil:
    section.add "sortOrder", valid_598118
  var valid_598119 = query.getOrDefault("prettyPrint")
  valid_598119 = validateParameter(valid_598119, JBool, required = false,
                                 default = newJBool(true))
  if valid_598119 != nil:
    section.add "prettyPrint", valid_598119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598120: Call_DirectoryMobiledevicesList_598103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all Mobile Devices of a customer (paginated)
  ## 
  let valid = call_598120.validator(path, query, header, formData, body)
  let scheme = call_598120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598120.url(scheme.get, call_598120.host, call_598120.base,
                         call_598120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598120, url, valid)

proc call*(call_598121: Call_DirectoryMobiledevicesList_598103; customerId: string;
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
  var path_598122 = newJObject()
  var query_598123 = newJObject()
  add(query_598123, "fields", newJString(fields))
  add(query_598123, "pageToken", newJString(pageToken))
  add(query_598123, "quotaUser", newJString(quotaUser))
  add(query_598123, "alt", newJString(alt))
  add(query_598123, "query", newJString(query))
  add(query_598123, "oauth_token", newJString(oauthToken))
  add(query_598123, "userIp", newJString(userIp))
  add(query_598123, "maxResults", newJInt(maxResults))
  add(query_598123, "orderBy", newJString(orderBy))
  add(path_598122, "customerId", newJString(customerId))
  add(query_598123, "key", newJString(key))
  add(query_598123, "projection", newJString(projection))
  add(query_598123, "sortOrder", newJString(sortOrder))
  add(query_598123, "prettyPrint", newJBool(prettyPrint))
  result = call_598121.call(path_598122, query_598123, nil, nil, nil)

var directoryMobiledevicesList* = Call_DirectoryMobiledevicesList_598103(
    name: "directoryMobiledevicesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/devices/mobile",
    validator: validate_DirectoryMobiledevicesList_598104,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesList_598105,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesGet_598124 = ref object of OpenApiRestCall_597437
proc url_DirectoryMobiledevicesGet_598126(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryMobiledevicesGet_598125(path: JsonNode; query: JsonNode;
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
  var valid_598127 = path.getOrDefault("customerId")
  valid_598127 = validateParameter(valid_598127, JString, required = true,
                                 default = nil)
  if valid_598127 != nil:
    section.add "customerId", valid_598127
  var valid_598128 = path.getOrDefault("resourceId")
  valid_598128 = validateParameter(valid_598128, JString, required = true,
                                 default = nil)
  if valid_598128 != nil:
    section.add "resourceId", valid_598128
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
  var valid_598129 = query.getOrDefault("fields")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "fields", valid_598129
  var valid_598130 = query.getOrDefault("quotaUser")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = nil)
  if valid_598130 != nil:
    section.add "quotaUser", valid_598130
  var valid_598131 = query.getOrDefault("alt")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = newJString("json"))
  if valid_598131 != nil:
    section.add "alt", valid_598131
  var valid_598132 = query.getOrDefault("oauth_token")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = nil)
  if valid_598132 != nil:
    section.add "oauth_token", valid_598132
  var valid_598133 = query.getOrDefault("userIp")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "userIp", valid_598133
  var valid_598134 = query.getOrDefault("key")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "key", valid_598134
  var valid_598135 = query.getOrDefault("projection")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_598135 != nil:
    section.add "projection", valid_598135
  var valid_598136 = query.getOrDefault("prettyPrint")
  valid_598136 = validateParameter(valid_598136, JBool, required = false,
                                 default = newJBool(true))
  if valid_598136 != nil:
    section.add "prettyPrint", valid_598136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598137: Call_DirectoryMobiledevicesGet_598124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Mobile Device
  ## 
  let valid = call_598137.validator(path, query, header, formData, body)
  let scheme = call_598137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598137.url(scheme.get, call_598137.host, call_598137.base,
                         call_598137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598137, url, valid)

proc call*(call_598138: Call_DirectoryMobiledevicesGet_598124; customerId: string;
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
  var path_598139 = newJObject()
  var query_598140 = newJObject()
  add(query_598140, "fields", newJString(fields))
  add(query_598140, "quotaUser", newJString(quotaUser))
  add(query_598140, "alt", newJString(alt))
  add(query_598140, "oauth_token", newJString(oauthToken))
  add(query_598140, "userIp", newJString(userIp))
  add(path_598139, "customerId", newJString(customerId))
  add(query_598140, "key", newJString(key))
  add(path_598139, "resourceId", newJString(resourceId))
  add(query_598140, "projection", newJString(projection))
  add(query_598140, "prettyPrint", newJBool(prettyPrint))
  result = call_598138.call(path_598139, query_598140, nil, nil, nil)

var directoryMobiledevicesGet* = Call_DirectoryMobiledevicesGet_598124(
    name: "directoryMobiledevicesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}",
    validator: validate_DirectoryMobiledevicesGet_598125,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesGet_598126,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesDelete_598141 = ref object of OpenApiRestCall_597437
proc url_DirectoryMobiledevicesDelete_598143(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryMobiledevicesDelete_598142(path: JsonNode; query: JsonNode;
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
  var valid_598144 = path.getOrDefault("customerId")
  valid_598144 = validateParameter(valid_598144, JString, required = true,
                                 default = nil)
  if valid_598144 != nil:
    section.add "customerId", valid_598144
  var valid_598145 = path.getOrDefault("resourceId")
  valid_598145 = validateParameter(valid_598145, JString, required = true,
                                 default = nil)
  if valid_598145 != nil:
    section.add "resourceId", valid_598145
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
  var valid_598146 = query.getOrDefault("fields")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "fields", valid_598146
  var valid_598147 = query.getOrDefault("quotaUser")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = nil)
  if valid_598147 != nil:
    section.add "quotaUser", valid_598147
  var valid_598148 = query.getOrDefault("alt")
  valid_598148 = validateParameter(valid_598148, JString, required = false,
                                 default = newJString("json"))
  if valid_598148 != nil:
    section.add "alt", valid_598148
  var valid_598149 = query.getOrDefault("oauth_token")
  valid_598149 = validateParameter(valid_598149, JString, required = false,
                                 default = nil)
  if valid_598149 != nil:
    section.add "oauth_token", valid_598149
  var valid_598150 = query.getOrDefault("userIp")
  valid_598150 = validateParameter(valid_598150, JString, required = false,
                                 default = nil)
  if valid_598150 != nil:
    section.add "userIp", valid_598150
  var valid_598151 = query.getOrDefault("key")
  valid_598151 = validateParameter(valid_598151, JString, required = false,
                                 default = nil)
  if valid_598151 != nil:
    section.add "key", valid_598151
  var valid_598152 = query.getOrDefault("prettyPrint")
  valid_598152 = validateParameter(valid_598152, JBool, required = false,
                                 default = newJBool(true))
  if valid_598152 != nil:
    section.add "prettyPrint", valid_598152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598153: Call_DirectoryMobiledevicesDelete_598141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Mobile Device
  ## 
  let valid = call_598153.validator(path, query, header, formData, body)
  let scheme = call_598153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598153.url(scheme.get, call_598153.host, call_598153.base,
                         call_598153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598153, url, valid)

proc call*(call_598154: Call_DirectoryMobiledevicesDelete_598141;
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
  var path_598155 = newJObject()
  var query_598156 = newJObject()
  add(query_598156, "fields", newJString(fields))
  add(query_598156, "quotaUser", newJString(quotaUser))
  add(query_598156, "alt", newJString(alt))
  add(query_598156, "oauth_token", newJString(oauthToken))
  add(query_598156, "userIp", newJString(userIp))
  add(path_598155, "customerId", newJString(customerId))
  add(query_598156, "key", newJString(key))
  add(path_598155, "resourceId", newJString(resourceId))
  add(query_598156, "prettyPrint", newJBool(prettyPrint))
  result = call_598154.call(path_598155, query_598156, nil, nil, nil)

var directoryMobiledevicesDelete* = Call_DirectoryMobiledevicesDelete_598141(
    name: "directoryMobiledevicesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}",
    validator: validate_DirectoryMobiledevicesDelete_598142,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesDelete_598143,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesAction_598157 = ref object of OpenApiRestCall_597437
proc url_DirectoryMobiledevicesAction_598159(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryMobiledevicesAction_598158(path: JsonNode; query: JsonNode;
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
  var valid_598160 = path.getOrDefault("customerId")
  valid_598160 = validateParameter(valid_598160, JString, required = true,
                                 default = nil)
  if valid_598160 != nil:
    section.add "customerId", valid_598160
  var valid_598161 = path.getOrDefault("resourceId")
  valid_598161 = validateParameter(valid_598161, JString, required = true,
                                 default = nil)
  if valid_598161 != nil:
    section.add "resourceId", valid_598161
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
  var valid_598162 = query.getOrDefault("fields")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "fields", valid_598162
  var valid_598163 = query.getOrDefault("quotaUser")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "quotaUser", valid_598163
  var valid_598164 = query.getOrDefault("alt")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = newJString("json"))
  if valid_598164 != nil:
    section.add "alt", valid_598164
  var valid_598165 = query.getOrDefault("oauth_token")
  valid_598165 = validateParameter(valid_598165, JString, required = false,
                                 default = nil)
  if valid_598165 != nil:
    section.add "oauth_token", valid_598165
  var valid_598166 = query.getOrDefault("userIp")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = nil)
  if valid_598166 != nil:
    section.add "userIp", valid_598166
  var valid_598167 = query.getOrDefault("key")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "key", valid_598167
  var valid_598168 = query.getOrDefault("prettyPrint")
  valid_598168 = validateParameter(valid_598168, JBool, required = false,
                                 default = newJBool(true))
  if valid_598168 != nil:
    section.add "prettyPrint", valid_598168
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

proc call*(call_598170: Call_DirectoryMobiledevicesAction_598157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take action on Mobile Device
  ## 
  let valid = call_598170.validator(path, query, header, formData, body)
  let scheme = call_598170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598170.url(scheme.get, call_598170.host, call_598170.base,
                         call_598170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598170, url, valid)

proc call*(call_598171: Call_DirectoryMobiledevicesAction_598157;
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
  var path_598172 = newJObject()
  var query_598173 = newJObject()
  var body_598174 = newJObject()
  add(query_598173, "fields", newJString(fields))
  add(query_598173, "quotaUser", newJString(quotaUser))
  add(query_598173, "alt", newJString(alt))
  add(query_598173, "oauth_token", newJString(oauthToken))
  add(query_598173, "userIp", newJString(userIp))
  add(path_598172, "customerId", newJString(customerId))
  add(query_598173, "key", newJString(key))
  add(path_598172, "resourceId", newJString(resourceId))
  if body != nil:
    body_598174 = body
  add(query_598173, "prettyPrint", newJBool(prettyPrint))
  result = call_598171.call(path_598172, query_598173, nil, nil, body_598174)

var directoryMobiledevicesAction* = Call_DirectoryMobiledevicesAction_598157(
    name: "directoryMobiledevicesAction", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}/action",
    validator: validate_DirectoryMobiledevicesAction_598158,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesAction_598159,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsInsert_598192 = ref object of OpenApiRestCall_597437
proc url_DirectoryOrgunitsInsert_598194(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryOrgunitsInsert_598193(path: JsonNode; query: JsonNode;
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
  var valid_598195 = path.getOrDefault("customerId")
  valid_598195 = validateParameter(valid_598195, JString, required = true,
                                 default = nil)
  if valid_598195 != nil:
    section.add "customerId", valid_598195
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
  var valid_598196 = query.getOrDefault("fields")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "fields", valid_598196
  var valid_598197 = query.getOrDefault("quotaUser")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = nil)
  if valid_598197 != nil:
    section.add "quotaUser", valid_598197
  var valid_598198 = query.getOrDefault("alt")
  valid_598198 = validateParameter(valid_598198, JString, required = false,
                                 default = newJString("json"))
  if valid_598198 != nil:
    section.add "alt", valid_598198
  var valid_598199 = query.getOrDefault("oauth_token")
  valid_598199 = validateParameter(valid_598199, JString, required = false,
                                 default = nil)
  if valid_598199 != nil:
    section.add "oauth_token", valid_598199
  var valid_598200 = query.getOrDefault("userIp")
  valid_598200 = validateParameter(valid_598200, JString, required = false,
                                 default = nil)
  if valid_598200 != nil:
    section.add "userIp", valid_598200
  var valid_598201 = query.getOrDefault("key")
  valid_598201 = validateParameter(valid_598201, JString, required = false,
                                 default = nil)
  if valid_598201 != nil:
    section.add "key", valid_598201
  var valid_598202 = query.getOrDefault("prettyPrint")
  valid_598202 = validateParameter(valid_598202, JBool, required = false,
                                 default = newJBool(true))
  if valid_598202 != nil:
    section.add "prettyPrint", valid_598202
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

proc call*(call_598204: Call_DirectoryOrgunitsInsert_598192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add organizational unit
  ## 
  let valid = call_598204.validator(path, query, header, formData, body)
  let scheme = call_598204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598204.url(scheme.get, call_598204.host, call_598204.base,
                         call_598204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598204, url, valid)

proc call*(call_598205: Call_DirectoryOrgunitsInsert_598192; customerId: string;
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
  var path_598206 = newJObject()
  var query_598207 = newJObject()
  var body_598208 = newJObject()
  add(query_598207, "fields", newJString(fields))
  add(query_598207, "quotaUser", newJString(quotaUser))
  add(query_598207, "alt", newJString(alt))
  add(query_598207, "oauth_token", newJString(oauthToken))
  add(query_598207, "userIp", newJString(userIp))
  add(path_598206, "customerId", newJString(customerId))
  add(query_598207, "key", newJString(key))
  if body != nil:
    body_598208 = body
  add(query_598207, "prettyPrint", newJBool(prettyPrint))
  result = call_598205.call(path_598206, query_598207, nil, nil, body_598208)

var directoryOrgunitsInsert* = Call_DirectoryOrgunitsInsert_598192(
    name: "directoryOrgunitsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customerId}/orgunits",
    validator: validate_DirectoryOrgunitsInsert_598193,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsInsert_598194,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsList_598175 = ref object of OpenApiRestCall_597437
proc url_DirectoryOrgunitsList_598177(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryOrgunitsList_598176(path: JsonNode; query: JsonNode;
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
  var valid_598178 = path.getOrDefault("customerId")
  valid_598178 = validateParameter(valid_598178, JString, required = true,
                                 default = nil)
  if valid_598178 != nil:
    section.add "customerId", valid_598178
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
  var valid_598179 = query.getOrDefault("fields")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "fields", valid_598179
  var valid_598180 = query.getOrDefault("quotaUser")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "quotaUser", valid_598180
  var valid_598181 = query.getOrDefault("alt")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = newJString("json"))
  if valid_598181 != nil:
    section.add "alt", valid_598181
  var valid_598182 = query.getOrDefault("orgUnitPath")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = newJString(""))
  if valid_598182 != nil:
    section.add "orgUnitPath", valid_598182
  var valid_598183 = query.getOrDefault("type")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = newJString("all"))
  if valid_598183 != nil:
    section.add "type", valid_598183
  var valid_598184 = query.getOrDefault("oauth_token")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "oauth_token", valid_598184
  var valid_598185 = query.getOrDefault("userIp")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "userIp", valid_598185
  var valid_598186 = query.getOrDefault("key")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "key", valid_598186
  var valid_598187 = query.getOrDefault("prettyPrint")
  valid_598187 = validateParameter(valid_598187, JBool, required = false,
                                 default = newJBool(true))
  if valid_598187 != nil:
    section.add "prettyPrint", valid_598187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598188: Call_DirectoryOrgunitsList_598175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all organizational units
  ## 
  let valid = call_598188.validator(path, query, header, formData, body)
  let scheme = call_598188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598188.url(scheme.get, call_598188.host, call_598188.base,
                         call_598188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598188, url, valid)

proc call*(call_598189: Call_DirectoryOrgunitsList_598175; customerId: string;
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
  var path_598190 = newJObject()
  var query_598191 = newJObject()
  add(query_598191, "fields", newJString(fields))
  add(query_598191, "quotaUser", newJString(quotaUser))
  add(query_598191, "alt", newJString(alt))
  add(query_598191, "orgUnitPath", newJString(orgUnitPath))
  add(query_598191, "type", newJString(`type`))
  add(query_598191, "oauth_token", newJString(oauthToken))
  add(query_598191, "userIp", newJString(userIp))
  add(path_598190, "customerId", newJString(customerId))
  add(query_598191, "key", newJString(key))
  add(query_598191, "prettyPrint", newJBool(prettyPrint))
  result = call_598189.call(path_598190, query_598191, nil, nil, nil)

var directoryOrgunitsList* = Call_DirectoryOrgunitsList_598175(
    name: "directoryOrgunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/orgunits",
    validator: validate_DirectoryOrgunitsList_598176, base: "/admin/directory/v1",
    url: url_DirectoryOrgunitsList_598177, schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsUpdate_598225 = ref object of OpenApiRestCall_597437
proc url_DirectoryOrgunitsUpdate_598227(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryOrgunitsUpdate_598226(path: JsonNode; query: JsonNode;
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
  var valid_598228 = path.getOrDefault("customerId")
  valid_598228 = validateParameter(valid_598228, JString, required = true,
                                 default = nil)
  if valid_598228 != nil:
    section.add "customerId", valid_598228
  var valid_598229 = path.getOrDefault("orgUnitPath")
  valid_598229 = validateParameter(valid_598229, JString, required = true,
                                 default = nil)
  if valid_598229 != nil:
    section.add "orgUnitPath", valid_598229
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
  var valid_598230 = query.getOrDefault("fields")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "fields", valid_598230
  var valid_598231 = query.getOrDefault("quotaUser")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = nil)
  if valid_598231 != nil:
    section.add "quotaUser", valid_598231
  var valid_598232 = query.getOrDefault("alt")
  valid_598232 = validateParameter(valid_598232, JString, required = false,
                                 default = newJString("json"))
  if valid_598232 != nil:
    section.add "alt", valid_598232
  var valid_598233 = query.getOrDefault("oauth_token")
  valid_598233 = validateParameter(valid_598233, JString, required = false,
                                 default = nil)
  if valid_598233 != nil:
    section.add "oauth_token", valid_598233
  var valid_598234 = query.getOrDefault("userIp")
  valid_598234 = validateParameter(valid_598234, JString, required = false,
                                 default = nil)
  if valid_598234 != nil:
    section.add "userIp", valid_598234
  var valid_598235 = query.getOrDefault("key")
  valid_598235 = validateParameter(valid_598235, JString, required = false,
                                 default = nil)
  if valid_598235 != nil:
    section.add "key", valid_598235
  var valid_598236 = query.getOrDefault("prettyPrint")
  valid_598236 = validateParameter(valid_598236, JBool, required = false,
                                 default = newJBool(true))
  if valid_598236 != nil:
    section.add "prettyPrint", valid_598236
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

proc call*(call_598238: Call_DirectoryOrgunitsUpdate_598225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Organization Unit
  ## 
  let valid = call_598238.validator(path, query, header, formData, body)
  let scheme = call_598238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598238.url(scheme.get, call_598238.host, call_598238.base,
                         call_598238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598238, url, valid)

proc call*(call_598239: Call_DirectoryOrgunitsUpdate_598225; customerId: string;
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
  var path_598240 = newJObject()
  var query_598241 = newJObject()
  var body_598242 = newJObject()
  add(query_598241, "fields", newJString(fields))
  add(query_598241, "quotaUser", newJString(quotaUser))
  add(query_598241, "alt", newJString(alt))
  add(query_598241, "oauth_token", newJString(oauthToken))
  add(query_598241, "userIp", newJString(userIp))
  add(path_598240, "customerId", newJString(customerId))
  add(path_598240, "orgUnitPath", newJString(orgUnitPath))
  add(query_598241, "key", newJString(key))
  if body != nil:
    body_598242 = body
  add(query_598241, "prettyPrint", newJBool(prettyPrint))
  result = call_598239.call(path_598240, query_598241, nil, nil, body_598242)

var directoryOrgunitsUpdate* = Call_DirectoryOrgunitsUpdate_598225(
    name: "directoryOrgunitsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsUpdate_598226,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsUpdate_598227,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsGet_598209 = ref object of OpenApiRestCall_597437
proc url_DirectoryOrgunitsGet_598211(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryOrgunitsGet_598210(path: JsonNode; query: JsonNode;
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
  var valid_598212 = path.getOrDefault("customerId")
  valid_598212 = validateParameter(valid_598212, JString, required = true,
                                 default = nil)
  if valid_598212 != nil:
    section.add "customerId", valid_598212
  var valid_598213 = path.getOrDefault("orgUnitPath")
  valid_598213 = validateParameter(valid_598213, JString, required = true,
                                 default = nil)
  if valid_598213 != nil:
    section.add "orgUnitPath", valid_598213
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
  var valid_598214 = query.getOrDefault("fields")
  valid_598214 = validateParameter(valid_598214, JString, required = false,
                                 default = nil)
  if valid_598214 != nil:
    section.add "fields", valid_598214
  var valid_598215 = query.getOrDefault("quotaUser")
  valid_598215 = validateParameter(valid_598215, JString, required = false,
                                 default = nil)
  if valid_598215 != nil:
    section.add "quotaUser", valid_598215
  var valid_598216 = query.getOrDefault("alt")
  valid_598216 = validateParameter(valid_598216, JString, required = false,
                                 default = newJString("json"))
  if valid_598216 != nil:
    section.add "alt", valid_598216
  var valid_598217 = query.getOrDefault("oauth_token")
  valid_598217 = validateParameter(valid_598217, JString, required = false,
                                 default = nil)
  if valid_598217 != nil:
    section.add "oauth_token", valid_598217
  var valid_598218 = query.getOrDefault("userIp")
  valid_598218 = validateParameter(valid_598218, JString, required = false,
                                 default = nil)
  if valid_598218 != nil:
    section.add "userIp", valid_598218
  var valid_598219 = query.getOrDefault("key")
  valid_598219 = validateParameter(valid_598219, JString, required = false,
                                 default = nil)
  if valid_598219 != nil:
    section.add "key", valid_598219
  var valid_598220 = query.getOrDefault("prettyPrint")
  valid_598220 = validateParameter(valid_598220, JBool, required = false,
                                 default = newJBool(true))
  if valid_598220 != nil:
    section.add "prettyPrint", valid_598220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598221: Call_DirectoryOrgunitsGet_598209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Organization Unit
  ## 
  let valid = call_598221.validator(path, query, header, formData, body)
  let scheme = call_598221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598221.url(scheme.get, call_598221.host, call_598221.base,
                         call_598221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598221, url, valid)

proc call*(call_598222: Call_DirectoryOrgunitsGet_598209; customerId: string;
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
  var path_598223 = newJObject()
  var query_598224 = newJObject()
  add(query_598224, "fields", newJString(fields))
  add(query_598224, "quotaUser", newJString(quotaUser))
  add(query_598224, "alt", newJString(alt))
  add(query_598224, "oauth_token", newJString(oauthToken))
  add(query_598224, "userIp", newJString(userIp))
  add(path_598223, "customerId", newJString(customerId))
  add(path_598223, "orgUnitPath", newJString(orgUnitPath))
  add(query_598224, "key", newJString(key))
  add(query_598224, "prettyPrint", newJBool(prettyPrint))
  result = call_598222.call(path_598223, query_598224, nil, nil, nil)

var directoryOrgunitsGet* = Call_DirectoryOrgunitsGet_598209(
    name: "directoryOrgunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsGet_598210, base: "/admin/directory/v1",
    url: url_DirectoryOrgunitsGet_598211, schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsPatch_598259 = ref object of OpenApiRestCall_597437
proc url_DirectoryOrgunitsPatch_598261(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryOrgunitsPatch_598260(path: JsonNode; query: JsonNode;
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
  var valid_598262 = path.getOrDefault("customerId")
  valid_598262 = validateParameter(valid_598262, JString, required = true,
                                 default = nil)
  if valid_598262 != nil:
    section.add "customerId", valid_598262
  var valid_598263 = path.getOrDefault("orgUnitPath")
  valid_598263 = validateParameter(valid_598263, JString, required = true,
                                 default = nil)
  if valid_598263 != nil:
    section.add "orgUnitPath", valid_598263
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
  var valid_598264 = query.getOrDefault("fields")
  valid_598264 = validateParameter(valid_598264, JString, required = false,
                                 default = nil)
  if valid_598264 != nil:
    section.add "fields", valid_598264
  var valid_598265 = query.getOrDefault("quotaUser")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = nil)
  if valid_598265 != nil:
    section.add "quotaUser", valid_598265
  var valid_598266 = query.getOrDefault("alt")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = newJString("json"))
  if valid_598266 != nil:
    section.add "alt", valid_598266
  var valid_598267 = query.getOrDefault("oauth_token")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "oauth_token", valid_598267
  var valid_598268 = query.getOrDefault("userIp")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = nil)
  if valid_598268 != nil:
    section.add "userIp", valid_598268
  var valid_598269 = query.getOrDefault("key")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = nil)
  if valid_598269 != nil:
    section.add "key", valid_598269
  var valid_598270 = query.getOrDefault("prettyPrint")
  valid_598270 = validateParameter(valid_598270, JBool, required = false,
                                 default = newJBool(true))
  if valid_598270 != nil:
    section.add "prettyPrint", valid_598270
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

proc call*(call_598272: Call_DirectoryOrgunitsPatch_598259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Organization Unit. This method supports patch semantics.
  ## 
  let valid = call_598272.validator(path, query, header, formData, body)
  let scheme = call_598272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598272.url(scheme.get, call_598272.host, call_598272.base,
                         call_598272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598272, url, valid)

proc call*(call_598273: Call_DirectoryOrgunitsPatch_598259; customerId: string;
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
  var path_598274 = newJObject()
  var query_598275 = newJObject()
  var body_598276 = newJObject()
  add(query_598275, "fields", newJString(fields))
  add(query_598275, "quotaUser", newJString(quotaUser))
  add(query_598275, "alt", newJString(alt))
  add(query_598275, "oauth_token", newJString(oauthToken))
  add(query_598275, "userIp", newJString(userIp))
  add(path_598274, "customerId", newJString(customerId))
  add(path_598274, "orgUnitPath", newJString(orgUnitPath))
  add(query_598275, "key", newJString(key))
  if body != nil:
    body_598276 = body
  add(query_598275, "prettyPrint", newJBool(prettyPrint))
  result = call_598273.call(path_598274, query_598275, nil, nil, body_598276)

var directoryOrgunitsPatch* = Call_DirectoryOrgunitsPatch_598259(
    name: "directoryOrgunitsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsPatch_598260,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsPatch_598261,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsDelete_598243 = ref object of OpenApiRestCall_597437
proc url_DirectoryOrgunitsDelete_598245(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryOrgunitsDelete_598244(path: JsonNode; query: JsonNode;
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
  var valid_598246 = path.getOrDefault("customerId")
  valid_598246 = validateParameter(valid_598246, JString, required = true,
                                 default = nil)
  if valid_598246 != nil:
    section.add "customerId", valid_598246
  var valid_598247 = path.getOrDefault("orgUnitPath")
  valid_598247 = validateParameter(valid_598247, JString, required = true,
                                 default = nil)
  if valid_598247 != nil:
    section.add "orgUnitPath", valid_598247
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
  var valid_598248 = query.getOrDefault("fields")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = nil)
  if valid_598248 != nil:
    section.add "fields", valid_598248
  var valid_598249 = query.getOrDefault("quotaUser")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "quotaUser", valid_598249
  var valid_598250 = query.getOrDefault("alt")
  valid_598250 = validateParameter(valid_598250, JString, required = false,
                                 default = newJString("json"))
  if valid_598250 != nil:
    section.add "alt", valid_598250
  var valid_598251 = query.getOrDefault("oauth_token")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = nil)
  if valid_598251 != nil:
    section.add "oauth_token", valid_598251
  var valid_598252 = query.getOrDefault("userIp")
  valid_598252 = validateParameter(valid_598252, JString, required = false,
                                 default = nil)
  if valid_598252 != nil:
    section.add "userIp", valid_598252
  var valid_598253 = query.getOrDefault("key")
  valid_598253 = validateParameter(valid_598253, JString, required = false,
                                 default = nil)
  if valid_598253 != nil:
    section.add "key", valid_598253
  var valid_598254 = query.getOrDefault("prettyPrint")
  valid_598254 = validateParameter(valid_598254, JBool, required = false,
                                 default = newJBool(true))
  if valid_598254 != nil:
    section.add "prettyPrint", valid_598254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598255: Call_DirectoryOrgunitsDelete_598243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove Organization Unit
  ## 
  let valid = call_598255.validator(path, query, header, formData, body)
  let scheme = call_598255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598255.url(scheme.get, call_598255.host, call_598255.base,
                         call_598255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598255, url, valid)

proc call*(call_598256: Call_DirectoryOrgunitsDelete_598243; customerId: string;
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
  var path_598257 = newJObject()
  var query_598258 = newJObject()
  add(query_598258, "fields", newJString(fields))
  add(query_598258, "quotaUser", newJString(quotaUser))
  add(query_598258, "alt", newJString(alt))
  add(query_598258, "oauth_token", newJString(oauthToken))
  add(query_598258, "userIp", newJString(userIp))
  add(path_598257, "customerId", newJString(customerId))
  add(path_598257, "orgUnitPath", newJString(orgUnitPath))
  add(query_598258, "key", newJString(key))
  add(query_598258, "prettyPrint", newJBool(prettyPrint))
  result = call_598256.call(path_598257, query_598258, nil, nil, nil)

var directoryOrgunitsDelete* = Call_DirectoryOrgunitsDelete_598243(
    name: "directoryOrgunitsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsDelete_598244,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsDelete_598245,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasInsert_598292 = ref object of OpenApiRestCall_597437
proc url_DirectorySchemasInsert_598294(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectorySchemasInsert_598293(path: JsonNode; query: JsonNode;
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
  var valid_598295 = path.getOrDefault("customerId")
  valid_598295 = validateParameter(valid_598295, JString, required = true,
                                 default = nil)
  if valid_598295 != nil:
    section.add "customerId", valid_598295
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
  var valid_598296 = query.getOrDefault("fields")
  valid_598296 = validateParameter(valid_598296, JString, required = false,
                                 default = nil)
  if valid_598296 != nil:
    section.add "fields", valid_598296
  var valid_598297 = query.getOrDefault("quotaUser")
  valid_598297 = validateParameter(valid_598297, JString, required = false,
                                 default = nil)
  if valid_598297 != nil:
    section.add "quotaUser", valid_598297
  var valid_598298 = query.getOrDefault("alt")
  valid_598298 = validateParameter(valid_598298, JString, required = false,
                                 default = newJString("json"))
  if valid_598298 != nil:
    section.add "alt", valid_598298
  var valid_598299 = query.getOrDefault("oauth_token")
  valid_598299 = validateParameter(valid_598299, JString, required = false,
                                 default = nil)
  if valid_598299 != nil:
    section.add "oauth_token", valid_598299
  var valid_598300 = query.getOrDefault("userIp")
  valid_598300 = validateParameter(valid_598300, JString, required = false,
                                 default = nil)
  if valid_598300 != nil:
    section.add "userIp", valid_598300
  var valid_598301 = query.getOrDefault("key")
  valid_598301 = validateParameter(valid_598301, JString, required = false,
                                 default = nil)
  if valid_598301 != nil:
    section.add "key", valid_598301
  var valid_598302 = query.getOrDefault("prettyPrint")
  valid_598302 = validateParameter(valid_598302, JBool, required = false,
                                 default = newJBool(true))
  if valid_598302 != nil:
    section.add "prettyPrint", valid_598302
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

proc call*(call_598304: Call_DirectorySchemasInsert_598292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create schema.
  ## 
  let valid = call_598304.validator(path, query, header, formData, body)
  let scheme = call_598304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598304.url(scheme.get, call_598304.host, call_598304.base,
                         call_598304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598304, url, valid)

proc call*(call_598305: Call_DirectorySchemasInsert_598292; customerId: string;
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
  var path_598306 = newJObject()
  var query_598307 = newJObject()
  var body_598308 = newJObject()
  add(query_598307, "fields", newJString(fields))
  add(query_598307, "quotaUser", newJString(quotaUser))
  add(query_598307, "alt", newJString(alt))
  add(query_598307, "oauth_token", newJString(oauthToken))
  add(query_598307, "userIp", newJString(userIp))
  add(path_598306, "customerId", newJString(customerId))
  add(query_598307, "key", newJString(key))
  if body != nil:
    body_598308 = body
  add(query_598307, "prettyPrint", newJBool(prettyPrint))
  result = call_598305.call(path_598306, query_598307, nil, nil, body_598308)

var directorySchemasInsert* = Call_DirectorySchemasInsert_598292(
    name: "directorySchemasInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customerId}/schemas",
    validator: validate_DirectorySchemasInsert_598293,
    base: "/admin/directory/v1", url: url_DirectorySchemasInsert_598294,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasList_598277 = ref object of OpenApiRestCall_597437
proc url_DirectorySchemasList_598279(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectorySchemasList_598278(path: JsonNode; query: JsonNode;
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
  var valid_598280 = path.getOrDefault("customerId")
  valid_598280 = validateParameter(valid_598280, JString, required = true,
                                 default = nil)
  if valid_598280 != nil:
    section.add "customerId", valid_598280
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
  var valid_598281 = query.getOrDefault("fields")
  valid_598281 = validateParameter(valid_598281, JString, required = false,
                                 default = nil)
  if valid_598281 != nil:
    section.add "fields", valid_598281
  var valid_598282 = query.getOrDefault("quotaUser")
  valid_598282 = validateParameter(valid_598282, JString, required = false,
                                 default = nil)
  if valid_598282 != nil:
    section.add "quotaUser", valid_598282
  var valid_598283 = query.getOrDefault("alt")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = newJString("json"))
  if valid_598283 != nil:
    section.add "alt", valid_598283
  var valid_598284 = query.getOrDefault("oauth_token")
  valid_598284 = validateParameter(valid_598284, JString, required = false,
                                 default = nil)
  if valid_598284 != nil:
    section.add "oauth_token", valid_598284
  var valid_598285 = query.getOrDefault("userIp")
  valid_598285 = validateParameter(valid_598285, JString, required = false,
                                 default = nil)
  if valid_598285 != nil:
    section.add "userIp", valid_598285
  var valid_598286 = query.getOrDefault("key")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = nil)
  if valid_598286 != nil:
    section.add "key", valid_598286
  var valid_598287 = query.getOrDefault("prettyPrint")
  valid_598287 = validateParameter(valid_598287, JBool, required = false,
                                 default = newJBool(true))
  if valid_598287 != nil:
    section.add "prettyPrint", valid_598287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598288: Call_DirectorySchemasList_598277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all schemas for a customer
  ## 
  let valid = call_598288.validator(path, query, header, formData, body)
  let scheme = call_598288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598288.url(scheme.get, call_598288.host, call_598288.base,
                         call_598288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598288, url, valid)

proc call*(call_598289: Call_DirectorySchemasList_598277; customerId: string;
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
  var path_598290 = newJObject()
  var query_598291 = newJObject()
  add(query_598291, "fields", newJString(fields))
  add(query_598291, "quotaUser", newJString(quotaUser))
  add(query_598291, "alt", newJString(alt))
  add(query_598291, "oauth_token", newJString(oauthToken))
  add(query_598291, "userIp", newJString(userIp))
  add(path_598290, "customerId", newJString(customerId))
  add(query_598291, "key", newJString(key))
  add(query_598291, "prettyPrint", newJBool(prettyPrint))
  result = call_598289.call(path_598290, query_598291, nil, nil, nil)

var directorySchemasList* = Call_DirectorySchemasList_598277(
    name: "directorySchemasList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/schemas",
    validator: validate_DirectorySchemasList_598278, base: "/admin/directory/v1",
    url: url_DirectorySchemasList_598279, schemes: {Scheme.Https})
type
  Call_DirectorySchemasUpdate_598325 = ref object of OpenApiRestCall_597437
proc url_DirectorySchemasUpdate_598327(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectorySchemasUpdate_598326(path: JsonNode; query: JsonNode;
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
  var valid_598328 = path.getOrDefault("schemaKey")
  valid_598328 = validateParameter(valid_598328, JString, required = true,
                                 default = nil)
  if valid_598328 != nil:
    section.add "schemaKey", valid_598328
  var valid_598329 = path.getOrDefault("customerId")
  valid_598329 = validateParameter(valid_598329, JString, required = true,
                                 default = nil)
  if valid_598329 != nil:
    section.add "customerId", valid_598329
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
  var valid_598330 = query.getOrDefault("fields")
  valid_598330 = validateParameter(valid_598330, JString, required = false,
                                 default = nil)
  if valid_598330 != nil:
    section.add "fields", valid_598330
  var valid_598331 = query.getOrDefault("quotaUser")
  valid_598331 = validateParameter(valid_598331, JString, required = false,
                                 default = nil)
  if valid_598331 != nil:
    section.add "quotaUser", valid_598331
  var valid_598332 = query.getOrDefault("alt")
  valid_598332 = validateParameter(valid_598332, JString, required = false,
                                 default = newJString("json"))
  if valid_598332 != nil:
    section.add "alt", valid_598332
  var valid_598333 = query.getOrDefault("oauth_token")
  valid_598333 = validateParameter(valid_598333, JString, required = false,
                                 default = nil)
  if valid_598333 != nil:
    section.add "oauth_token", valid_598333
  var valid_598334 = query.getOrDefault("userIp")
  valid_598334 = validateParameter(valid_598334, JString, required = false,
                                 default = nil)
  if valid_598334 != nil:
    section.add "userIp", valid_598334
  var valid_598335 = query.getOrDefault("key")
  valid_598335 = validateParameter(valid_598335, JString, required = false,
                                 default = nil)
  if valid_598335 != nil:
    section.add "key", valid_598335
  var valid_598336 = query.getOrDefault("prettyPrint")
  valid_598336 = validateParameter(valid_598336, JBool, required = false,
                                 default = newJBool(true))
  if valid_598336 != nil:
    section.add "prettyPrint", valid_598336
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

proc call*(call_598338: Call_DirectorySchemasUpdate_598325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update schema
  ## 
  let valid = call_598338.validator(path, query, header, formData, body)
  let scheme = call_598338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598338.url(scheme.get, call_598338.host, call_598338.base,
                         call_598338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598338, url, valid)

proc call*(call_598339: Call_DirectorySchemasUpdate_598325; schemaKey: string;
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
  var path_598340 = newJObject()
  var query_598341 = newJObject()
  var body_598342 = newJObject()
  add(query_598341, "fields", newJString(fields))
  add(query_598341, "quotaUser", newJString(quotaUser))
  add(query_598341, "alt", newJString(alt))
  add(path_598340, "schemaKey", newJString(schemaKey))
  add(query_598341, "oauth_token", newJString(oauthToken))
  add(query_598341, "userIp", newJString(userIp))
  add(path_598340, "customerId", newJString(customerId))
  add(query_598341, "key", newJString(key))
  if body != nil:
    body_598342 = body
  add(query_598341, "prettyPrint", newJBool(prettyPrint))
  result = call_598339.call(path_598340, query_598341, nil, nil, body_598342)

var directorySchemasUpdate* = Call_DirectorySchemasUpdate_598325(
    name: "directorySchemasUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasUpdate_598326,
    base: "/admin/directory/v1", url: url_DirectorySchemasUpdate_598327,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasGet_598309 = ref object of OpenApiRestCall_597437
proc url_DirectorySchemasGet_598311(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectorySchemasGet_598310(path: JsonNode; query: JsonNode;
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
  var valid_598312 = path.getOrDefault("schemaKey")
  valid_598312 = validateParameter(valid_598312, JString, required = true,
                                 default = nil)
  if valid_598312 != nil:
    section.add "schemaKey", valid_598312
  var valid_598313 = path.getOrDefault("customerId")
  valid_598313 = validateParameter(valid_598313, JString, required = true,
                                 default = nil)
  if valid_598313 != nil:
    section.add "customerId", valid_598313
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
  var valid_598314 = query.getOrDefault("fields")
  valid_598314 = validateParameter(valid_598314, JString, required = false,
                                 default = nil)
  if valid_598314 != nil:
    section.add "fields", valid_598314
  var valid_598315 = query.getOrDefault("quotaUser")
  valid_598315 = validateParameter(valid_598315, JString, required = false,
                                 default = nil)
  if valid_598315 != nil:
    section.add "quotaUser", valid_598315
  var valid_598316 = query.getOrDefault("alt")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = newJString("json"))
  if valid_598316 != nil:
    section.add "alt", valid_598316
  var valid_598317 = query.getOrDefault("oauth_token")
  valid_598317 = validateParameter(valid_598317, JString, required = false,
                                 default = nil)
  if valid_598317 != nil:
    section.add "oauth_token", valid_598317
  var valid_598318 = query.getOrDefault("userIp")
  valid_598318 = validateParameter(valid_598318, JString, required = false,
                                 default = nil)
  if valid_598318 != nil:
    section.add "userIp", valid_598318
  var valid_598319 = query.getOrDefault("key")
  valid_598319 = validateParameter(valid_598319, JString, required = false,
                                 default = nil)
  if valid_598319 != nil:
    section.add "key", valid_598319
  var valid_598320 = query.getOrDefault("prettyPrint")
  valid_598320 = validateParameter(valid_598320, JBool, required = false,
                                 default = newJBool(true))
  if valid_598320 != nil:
    section.add "prettyPrint", valid_598320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598321: Call_DirectorySchemasGet_598309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve schema
  ## 
  let valid = call_598321.validator(path, query, header, formData, body)
  let scheme = call_598321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598321.url(scheme.get, call_598321.host, call_598321.base,
                         call_598321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598321, url, valid)

proc call*(call_598322: Call_DirectorySchemasGet_598309; schemaKey: string;
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
  var path_598323 = newJObject()
  var query_598324 = newJObject()
  add(query_598324, "fields", newJString(fields))
  add(query_598324, "quotaUser", newJString(quotaUser))
  add(query_598324, "alt", newJString(alt))
  add(path_598323, "schemaKey", newJString(schemaKey))
  add(query_598324, "oauth_token", newJString(oauthToken))
  add(query_598324, "userIp", newJString(userIp))
  add(path_598323, "customerId", newJString(customerId))
  add(query_598324, "key", newJString(key))
  add(query_598324, "prettyPrint", newJBool(prettyPrint))
  result = call_598322.call(path_598323, query_598324, nil, nil, nil)

var directorySchemasGet* = Call_DirectorySchemasGet_598309(
    name: "directorySchemasGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasGet_598310, base: "/admin/directory/v1",
    url: url_DirectorySchemasGet_598311, schemes: {Scheme.Https})
type
  Call_DirectorySchemasPatch_598359 = ref object of OpenApiRestCall_597437
proc url_DirectorySchemasPatch_598361(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectorySchemasPatch_598360(path: JsonNode; query: JsonNode;
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
  var valid_598362 = path.getOrDefault("schemaKey")
  valid_598362 = validateParameter(valid_598362, JString, required = true,
                                 default = nil)
  if valid_598362 != nil:
    section.add "schemaKey", valid_598362
  var valid_598363 = path.getOrDefault("customerId")
  valid_598363 = validateParameter(valid_598363, JString, required = true,
                                 default = nil)
  if valid_598363 != nil:
    section.add "customerId", valid_598363
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
  var valid_598364 = query.getOrDefault("fields")
  valid_598364 = validateParameter(valid_598364, JString, required = false,
                                 default = nil)
  if valid_598364 != nil:
    section.add "fields", valid_598364
  var valid_598365 = query.getOrDefault("quotaUser")
  valid_598365 = validateParameter(valid_598365, JString, required = false,
                                 default = nil)
  if valid_598365 != nil:
    section.add "quotaUser", valid_598365
  var valid_598366 = query.getOrDefault("alt")
  valid_598366 = validateParameter(valid_598366, JString, required = false,
                                 default = newJString("json"))
  if valid_598366 != nil:
    section.add "alt", valid_598366
  var valid_598367 = query.getOrDefault("oauth_token")
  valid_598367 = validateParameter(valid_598367, JString, required = false,
                                 default = nil)
  if valid_598367 != nil:
    section.add "oauth_token", valid_598367
  var valid_598368 = query.getOrDefault("userIp")
  valid_598368 = validateParameter(valid_598368, JString, required = false,
                                 default = nil)
  if valid_598368 != nil:
    section.add "userIp", valid_598368
  var valid_598369 = query.getOrDefault("key")
  valid_598369 = validateParameter(valid_598369, JString, required = false,
                                 default = nil)
  if valid_598369 != nil:
    section.add "key", valid_598369
  var valid_598370 = query.getOrDefault("prettyPrint")
  valid_598370 = validateParameter(valid_598370, JBool, required = false,
                                 default = newJBool(true))
  if valid_598370 != nil:
    section.add "prettyPrint", valid_598370
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

proc call*(call_598372: Call_DirectorySchemasPatch_598359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update schema. This method supports patch semantics.
  ## 
  let valid = call_598372.validator(path, query, header, formData, body)
  let scheme = call_598372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598372.url(scheme.get, call_598372.host, call_598372.base,
                         call_598372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598372, url, valid)

proc call*(call_598373: Call_DirectorySchemasPatch_598359; schemaKey: string;
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
  var path_598374 = newJObject()
  var query_598375 = newJObject()
  var body_598376 = newJObject()
  add(query_598375, "fields", newJString(fields))
  add(query_598375, "quotaUser", newJString(quotaUser))
  add(query_598375, "alt", newJString(alt))
  add(path_598374, "schemaKey", newJString(schemaKey))
  add(query_598375, "oauth_token", newJString(oauthToken))
  add(query_598375, "userIp", newJString(userIp))
  add(path_598374, "customerId", newJString(customerId))
  add(query_598375, "key", newJString(key))
  if body != nil:
    body_598376 = body
  add(query_598375, "prettyPrint", newJBool(prettyPrint))
  result = call_598373.call(path_598374, query_598375, nil, nil, body_598376)

var directorySchemasPatch* = Call_DirectorySchemasPatch_598359(
    name: "directorySchemasPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasPatch_598360, base: "/admin/directory/v1",
    url: url_DirectorySchemasPatch_598361, schemes: {Scheme.Https})
type
  Call_DirectorySchemasDelete_598343 = ref object of OpenApiRestCall_597437
proc url_DirectorySchemasDelete_598345(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectorySchemasDelete_598344(path: JsonNode; query: JsonNode;
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
  var valid_598346 = path.getOrDefault("schemaKey")
  valid_598346 = validateParameter(valid_598346, JString, required = true,
                                 default = nil)
  if valid_598346 != nil:
    section.add "schemaKey", valid_598346
  var valid_598347 = path.getOrDefault("customerId")
  valid_598347 = validateParameter(valid_598347, JString, required = true,
                                 default = nil)
  if valid_598347 != nil:
    section.add "customerId", valid_598347
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
  var valid_598348 = query.getOrDefault("fields")
  valid_598348 = validateParameter(valid_598348, JString, required = false,
                                 default = nil)
  if valid_598348 != nil:
    section.add "fields", valid_598348
  var valid_598349 = query.getOrDefault("quotaUser")
  valid_598349 = validateParameter(valid_598349, JString, required = false,
                                 default = nil)
  if valid_598349 != nil:
    section.add "quotaUser", valid_598349
  var valid_598350 = query.getOrDefault("alt")
  valid_598350 = validateParameter(valid_598350, JString, required = false,
                                 default = newJString("json"))
  if valid_598350 != nil:
    section.add "alt", valid_598350
  var valid_598351 = query.getOrDefault("oauth_token")
  valid_598351 = validateParameter(valid_598351, JString, required = false,
                                 default = nil)
  if valid_598351 != nil:
    section.add "oauth_token", valid_598351
  var valid_598352 = query.getOrDefault("userIp")
  valid_598352 = validateParameter(valid_598352, JString, required = false,
                                 default = nil)
  if valid_598352 != nil:
    section.add "userIp", valid_598352
  var valid_598353 = query.getOrDefault("key")
  valid_598353 = validateParameter(valid_598353, JString, required = false,
                                 default = nil)
  if valid_598353 != nil:
    section.add "key", valid_598353
  var valid_598354 = query.getOrDefault("prettyPrint")
  valid_598354 = validateParameter(valid_598354, JBool, required = false,
                                 default = newJBool(true))
  if valid_598354 != nil:
    section.add "prettyPrint", valid_598354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598355: Call_DirectorySchemasDelete_598343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schema
  ## 
  let valid = call_598355.validator(path, query, header, formData, body)
  let scheme = call_598355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598355.url(scheme.get, call_598355.host, call_598355.base,
                         call_598355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598355, url, valid)

proc call*(call_598356: Call_DirectorySchemasDelete_598343; schemaKey: string;
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
  var path_598357 = newJObject()
  var query_598358 = newJObject()
  add(query_598358, "fields", newJString(fields))
  add(query_598358, "quotaUser", newJString(quotaUser))
  add(query_598358, "alt", newJString(alt))
  add(path_598357, "schemaKey", newJString(schemaKey))
  add(query_598358, "oauth_token", newJString(oauthToken))
  add(query_598358, "userIp", newJString(userIp))
  add(path_598357, "customerId", newJString(customerId))
  add(query_598358, "key", newJString(key))
  add(query_598358, "prettyPrint", newJBool(prettyPrint))
  result = call_598356.call(path_598357, query_598358, nil, nil, nil)

var directorySchemasDelete* = Call_DirectorySchemasDelete_598343(
    name: "directorySchemasDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasDelete_598344,
    base: "/admin/directory/v1", url: url_DirectorySchemasDelete_598345,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesInsert_598393 = ref object of OpenApiRestCall_597437
proc url_DirectoryDomainAliasesInsert_598395(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryDomainAliasesInsert_598394(path: JsonNode; query: JsonNode;
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
  var valid_598396 = path.getOrDefault("customer")
  valid_598396 = validateParameter(valid_598396, JString, required = true,
                                 default = nil)
  if valid_598396 != nil:
    section.add "customer", valid_598396
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
  var valid_598397 = query.getOrDefault("fields")
  valid_598397 = validateParameter(valid_598397, JString, required = false,
                                 default = nil)
  if valid_598397 != nil:
    section.add "fields", valid_598397
  var valid_598398 = query.getOrDefault("quotaUser")
  valid_598398 = validateParameter(valid_598398, JString, required = false,
                                 default = nil)
  if valid_598398 != nil:
    section.add "quotaUser", valid_598398
  var valid_598399 = query.getOrDefault("alt")
  valid_598399 = validateParameter(valid_598399, JString, required = false,
                                 default = newJString("json"))
  if valid_598399 != nil:
    section.add "alt", valid_598399
  var valid_598400 = query.getOrDefault("oauth_token")
  valid_598400 = validateParameter(valid_598400, JString, required = false,
                                 default = nil)
  if valid_598400 != nil:
    section.add "oauth_token", valid_598400
  var valid_598401 = query.getOrDefault("userIp")
  valid_598401 = validateParameter(valid_598401, JString, required = false,
                                 default = nil)
  if valid_598401 != nil:
    section.add "userIp", valid_598401
  var valid_598402 = query.getOrDefault("key")
  valid_598402 = validateParameter(valid_598402, JString, required = false,
                                 default = nil)
  if valid_598402 != nil:
    section.add "key", valid_598402
  var valid_598403 = query.getOrDefault("prettyPrint")
  valid_598403 = validateParameter(valid_598403, JBool, required = false,
                                 default = newJBool(true))
  if valid_598403 != nil:
    section.add "prettyPrint", valid_598403
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

proc call*(call_598405: Call_DirectoryDomainAliasesInsert_598393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a Domain alias of the customer.
  ## 
  let valid = call_598405.validator(path, query, header, formData, body)
  let scheme = call_598405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598405.url(scheme.get, call_598405.host, call_598405.base,
                         call_598405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598405, url, valid)

proc call*(call_598406: Call_DirectoryDomainAliasesInsert_598393; customer: string;
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
  var path_598407 = newJObject()
  var query_598408 = newJObject()
  var body_598409 = newJObject()
  add(query_598408, "fields", newJString(fields))
  add(query_598408, "quotaUser", newJString(quotaUser))
  add(query_598408, "alt", newJString(alt))
  add(query_598408, "oauth_token", newJString(oauthToken))
  add(query_598408, "userIp", newJString(userIp))
  add(query_598408, "key", newJString(key))
  add(path_598407, "customer", newJString(customer))
  if body != nil:
    body_598409 = body
  add(query_598408, "prettyPrint", newJBool(prettyPrint))
  result = call_598406.call(path_598407, query_598408, nil, nil, body_598409)

var directoryDomainAliasesInsert* = Call_DirectoryDomainAliasesInsert_598393(
    name: "directoryDomainAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/domainaliases",
    validator: validate_DirectoryDomainAliasesInsert_598394,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesInsert_598395,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesList_598377 = ref object of OpenApiRestCall_597437
proc url_DirectoryDomainAliasesList_598379(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryDomainAliasesList_598378(path: JsonNode; query: JsonNode;
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
  var valid_598380 = path.getOrDefault("customer")
  valid_598380 = validateParameter(valid_598380, JString, required = true,
                                 default = nil)
  if valid_598380 != nil:
    section.add "customer", valid_598380
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
  var valid_598381 = query.getOrDefault("fields")
  valid_598381 = validateParameter(valid_598381, JString, required = false,
                                 default = nil)
  if valid_598381 != nil:
    section.add "fields", valid_598381
  var valid_598382 = query.getOrDefault("quotaUser")
  valid_598382 = validateParameter(valid_598382, JString, required = false,
                                 default = nil)
  if valid_598382 != nil:
    section.add "quotaUser", valid_598382
  var valid_598383 = query.getOrDefault("alt")
  valid_598383 = validateParameter(valid_598383, JString, required = false,
                                 default = newJString("json"))
  if valid_598383 != nil:
    section.add "alt", valid_598383
  var valid_598384 = query.getOrDefault("parentDomainName")
  valid_598384 = validateParameter(valid_598384, JString, required = false,
                                 default = nil)
  if valid_598384 != nil:
    section.add "parentDomainName", valid_598384
  var valid_598385 = query.getOrDefault("oauth_token")
  valid_598385 = validateParameter(valid_598385, JString, required = false,
                                 default = nil)
  if valid_598385 != nil:
    section.add "oauth_token", valid_598385
  var valid_598386 = query.getOrDefault("userIp")
  valid_598386 = validateParameter(valid_598386, JString, required = false,
                                 default = nil)
  if valid_598386 != nil:
    section.add "userIp", valid_598386
  var valid_598387 = query.getOrDefault("key")
  valid_598387 = validateParameter(valid_598387, JString, required = false,
                                 default = nil)
  if valid_598387 != nil:
    section.add "key", valid_598387
  var valid_598388 = query.getOrDefault("prettyPrint")
  valid_598388 = validateParameter(valid_598388, JBool, required = false,
                                 default = newJBool(true))
  if valid_598388 != nil:
    section.add "prettyPrint", valid_598388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598389: Call_DirectoryDomainAliasesList_598377; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the domain aliases of the customer.
  ## 
  let valid = call_598389.validator(path, query, header, formData, body)
  let scheme = call_598389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598389.url(scheme.get, call_598389.host, call_598389.base,
                         call_598389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598389, url, valid)

proc call*(call_598390: Call_DirectoryDomainAliasesList_598377; customer: string;
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
  var path_598391 = newJObject()
  var query_598392 = newJObject()
  add(query_598392, "fields", newJString(fields))
  add(query_598392, "quotaUser", newJString(quotaUser))
  add(query_598392, "alt", newJString(alt))
  add(query_598392, "parentDomainName", newJString(parentDomainName))
  add(query_598392, "oauth_token", newJString(oauthToken))
  add(query_598392, "userIp", newJString(userIp))
  add(query_598392, "key", newJString(key))
  add(path_598391, "customer", newJString(customer))
  add(query_598392, "prettyPrint", newJBool(prettyPrint))
  result = call_598390.call(path_598391, query_598392, nil, nil, nil)

var directoryDomainAliasesList* = Call_DirectoryDomainAliasesList_598377(
    name: "directoryDomainAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/domainaliases",
    validator: validate_DirectoryDomainAliasesList_598378,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesList_598379,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesGet_598410 = ref object of OpenApiRestCall_597437
proc url_DirectoryDomainAliasesGet_598412(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryDomainAliasesGet_598411(path: JsonNode; query: JsonNode;
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
  var valid_598413 = path.getOrDefault("domainAliasName")
  valid_598413 = validateParameter(valid_598413, JString, required = true,
                                 default = nil)
  if valid_598413 != nil:
    section.add "domainAliasName", valid_598413
  var valid_598414 = path.getOrDefault("customer")
  valid_598414 = validateParameter(valid_598414, JString, required = true,
                                 default = nil)
  if valid_598414 != nil:
    section.add "customer", valid_598414
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
  var valid_598415 = query.getOrDefault("fields")
  valid_598415 = validateParameter(valid_598415, JString, required = false,
                                 default = nil)
  if valid_598415 != nil:
    section.add "fields", valid_598415
  var valid_598416 = query.getOrDefault("quotaUser")
  valid_598416 = validateParameter(valid_598416, JString, required = false,
                                 default = nil)
  if valid_598416 != nil:
    section.add "quotaUser", valid_598416
  var valid_598417 = query.getOrDefault("alt")
  valid_598417 = validateParameter(valid_598417, JString, required = false,
                                 default = newJString("json"))
  if valid_598417 != nil:
    section.add "alt", valid_598417
  var valid_598418 = query.getOrDefault("oauth_token")
  valid_598418 = validateParameter(valid_598418, JString, required = false,
                                 default = nil)
  if valid_598418 != nil:
    section.add "oauth_token", valid_598418
  var valid_598419 = query.getOrDefault("userIp")
  valid_598419 = validateParameter(valid_598419, JString, required = false,
                                 default = nil)
  if valid_598419 != nil:
    section.add "userIp", valid_598419
  var valid_598420 = query.getOrDefault("key")
  valid_598420 = validateParameter(valid_598420, JString, required = false,
                                 default = nil)
  if valid_598420 != nil:
    section.add "key", valid_598420
  var valid_598421 = query.getOrDefault("prettyPrint")
  valid_598421 = validateParameter(valid_598421, JBool, required = false,
                                 default = newJBool(true))
  if valid_598421 != nil:
    section.add "prettyPrint", valid_598421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598422: Call_DirectoryDomainAliasesGet_598410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a domain alias of the customer.
  ## 
  let valid = call_598422.validator(path, query, header, formData, body)
  let scheme = call_598422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598422.url(scheme.get, call_598422.host, call_598422.base,
                         call_598422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598422, url, valid)

proc call*(call_598423: Call_DirectoryDomainAliasesGet_598410;
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
  var path_598424 = newJObject()
  var query_598425 = newJObject()
  add(path_598424, "domainAliasName", newJString(domainAliasName))
  add(query_598425, "fields", newJString(fields))
  add(query_598425, "quotaUser", newJString(quotaUser))
  add(query_598425, "alt", newJString(alt))
  add(query_598425, "oauth_token", newJString(oauthToken))
  add(query_598425, "userIp", newJString(userIp))
  add(query_598425, "key", newJString(key))
  add(path_598424, "customer", newJString(customer))
  add(query_598425, "prettyPrint", newJBool(prettyPrint))
  result = call_598423.call(path_598424, query_598425, nil, nil, nil)

var directoryDomainAliasesGet* = Call_DirectoryDomainAliasesGet_598410(
    name: "directoryDomainAliasesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domainaliases/{domainAliasName}",
    validator: validate_DirectoryDomainAliasesGet_598411,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesGet_598412,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesDelete_598426 = ref object of OpenApiRestCall_597437
proc url_DirectoryDomainAliasesDelete_598428(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryDomainAliasesDelete_598427(path: JsonNode; query: JsonNode;
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
  var valid_598429 = path.getOrDefault("domainAliasName")
  valid_598429 = validateParameter(valid_598429, JString, required = true,
                                 default = nil)
  if valid_598429 != nil:
    section.add "domainAliasName", valid_598429
  var valid_598430 = path.getOrDefault("customer")
  valid_598430 = validateParameter(valid_598430, JString, required = true,
                                 default = nil)
  if valid_598430 != nil:
    section.add "customer", valid_598430
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
  var valid_598431 = query.getOrDefault("fields")
  valid_598431 = validateParameter(valid_598431, JString, required = false,
                                 default = nil)
  if valid_598431 != nil:
    section.add "fields", valid_598431
  var valid_598432 = query.getOrDefault("quotaUser")
  valid_598432 = validateParameter(valid_598432, JString, required = false,
                                 default = nil)
  if valid_598432 != nil:
    section.add "quotaUser", valid_598432
  var valid_598433 = query.getOrDefault("alt")
  valid_598433 = validateParameter(valid_598433, JString, required = false,
                                 default = newJString("json"))
  if valid_598433 != nil:
    section.add "alt", valid_598433
  var valid_598434 = query.getOrDefault("oauth_token")
  valid_598434 = validateParameter(valid_598434, JString, required = false,
                                 default = nil)
  if valid_598434 != nil:
    section.add "oauth_token", valid_598434
  var valid_598435 = query.getOrDefault("userIp")
  valid_598435 = validateParameter(valid_598435, JString, required = false,
                                 default = nil)
  if valid_598435 != nil:
    section.add "userIp", valid_598435
  var valid_598436 = query.getOrDefault("key")
  valid_598436 = validateParameter(valid_598436, JString, required = false,
                                 default = nil)
  if valid_598436 != nil:
    section.add "key", valid_598436
  var valid_598437 = query.getOrDefault("prettyPrint")
  valid_598437 = validateParameter(valid_598437, JBool, required = false,
                                 default = newJBool(true))
  if valid_598437 != nil:
    section.add "prettyPrint", valid_598437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598438: Call_DirectoryDomainAliasesDelete_598426; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Domain Alias of the customer.
  ## 
  let valid = call_598438.validator(path, query, header, formData, body)
  let scheme = call_598438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598438.url(scheme.get, call_598438.host, call_598438.base,
                         call_598438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598438, url, valid)

proc call*(call_598439: Call_DirectoryDomainAliasesDelete_598426;
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
  var path_598440 = newJObject()
  var query_598441 = newJObject()
  add(path_598440, "domainAliasName", newJString(domainAliasName))
  add(query_598441, "fields", newJString(fields))
  add(query_598441, "quotaUser", newJString(quotaUser))
  add(query_598441, "alt", newJString(alt))
  add(query_598441, "oauth_token", newJString(oauthToken))
  add(query_598441, "userIp", newJString(userIp))
  add(query_598441, "key", newJString(key))
  add(path_598440, "customer", newJString(customer))
  add(query_598441, "prettyPrint", newJBool(prettyPrint))
  result = call_598439.call(path_598440, query_598441, nil, nil, nil)

var directoryDomainAliasesDelete* = Call_DirectoryDomainAliasesDelete_598426(
    name: "directoryDomainAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domainaliases/{domainAliasName}",
    validator: validate_DirectoryDomainAliasesDelete_598427,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesDelete_598428,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainsInsert_598457 = ref object of OpenApiRestCall_597437
proc url_DirectoryDomainsInsert_598459(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryDomainsInsert_598458(path: JsonNode; query: JsonNode;
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
  var valid_598460 = path.getOrDefault("customer")
  valid_598460 = validateParameter(valid_598460, JString, required = true,
                                 default = nil)
  if valid_598460 != nil:
    section.add "customer", valid_598460
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
  var valid_598461 = query.getOrDefault("fields")
  valid_598461 = validateParameter(valid_598461, JString, required = false,
                                 default = nil)
  if valid_598461 != nil:
    section.add "fields", valid_598461
  var valid_598462 = query.getOrDefault("quotaUser")
  valid_598462 = validateParameter(valid_598462, JString, required = false,
                                 default = nil)
  if valid_598462 != nil:
    section.add "quotaUser", valid_598462
  var valid_598463 = query.getOrDefault("alt")
  valid_598463 = validateParameter(valid_598463, JString, required = false,
                                 default = newJString("json"))
  if valid_598463 != nil:
    section.add "alt", valid_598463
  var valid_598464 = query.getOrDefault("oauth_token")
  valid_598464 = validateParameter(valid_598464, JString, required = false,
                                 default = nil)
  if valid_598464 != nil:
    section.add "oauth_token", valid_598464
  var valid_598465 = query.getOrDefault("userIp")
  valid_598465 = validateParameter(valid_598465, JString, required = false,
                                 default = nil)
  if valid_598465 != nil:
    section.add "userIp", valid_598465
  var valid_598466 = query.getOrDefault("key")
  valid_598466 = validateParameter(valid_598466, JString, required = false,
                                 default = nil)
  if valid_598466 != nil:
    section.add "key", valid_598466
  var valid_598467 = query.getOrDefault("prettyPrint")
  valid_598467 = validateParameter(valid_598467, JBool, required = false,
                                 default = newJBool(true))
  if valid_598467 != nil:
    section.add "prettyPrint", valid_598467
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

proc call*(call_598469: Call_DirectoryDomainsInsert_598457; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a domain of the customer.
  ## 
  let valid = call_598469.validator(path, query, header, formData, body)
  let scheme = call_598469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598469.url(scheme.get, call_598469.host, call_598469.base,
                         call_598469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598469, url, valid)

proc call*(call_598470: Call_DirectoryDomainsInsert_598457; customer: string;
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
  var path_598471 = newJObject()
  var query_598472 = newJObject()
  var body_598473 = newJObject()
  add(query_598472, "fields", newJString(fields))
  add(query_598472, "quotaUser", newJString(quotaUser))
  add(query_598472, "alt", newJString(alt))
  add(query_598472, "oauth_token", newJString(oauthToken))
  add(query_598472, "userIp", newJString(userIp))
  add(query_598472, "key", newJString(key))
  add(path_598471, "customer", newJString(customer))
  if body != nil:
    body_598473 = body
  add(query_598472, "prettyPrint", newJBool(prettyPrint))
  result = call_598470.call(path_598471, query_598472, nil, nil, body_598473)

var directoryDomainsInsert* = Call_DirectoryDomainsInsert_598457(
    name: "directoryDomainsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/domains",
    validator: validate_DirectoryDomainsInsert_598458,
    base: "/admin/directory/v1", url: url_DirectoryDomainsInsert_598459,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainsList_598442 = ref object of OpenApiRestCall_597437
proc url_DirectoryDomainsList_598444(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryDomainsList_598443(path: JsonNode; query: JsonNode;
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
  var valid_598445 = path.getOrDefault("customer")
  valid_598445 = validateParameter(valid_598445, JString, required = true,
                                 default = nil)
  if valid_598445 != nil:
    section.add "customer", valid_598445
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
  var valid_598446 = query.getOrDefault("fields")
  valid_598446 = validateParameter(valid_598446, JString, required = false,
                                 default = nil)
  if valid_598446 != nil:
    section.add "fields", valid_598446
  var valid_598447 = query.getOrDefault("quotaUser")
  valid_598447 = validateParameter(valid_598447, JString, required = false,
                                 default = nil)
  if valid_598447 != nil:
    section.add "quotaUser", valid_598447
  var valid_598448 = query.getOrDefault("alt")
  valid_598448 = validateParameter(valid_598448, JString, required = false,
                                 default = newJString("json"))
  if valid_598448 != nil:
    section.add "alt", valid_598448
  var valid_598449 = query.getOrDefault("oauth_token")
  valid_598449 = validateParameter(valid_598449, JString, required = false,
                                 default = nil)
  if valid_598449 != nil:
    section.add "oauth_token", valid_598449
  var valid_598450 = query.getOrDefault("userIp")
  valid_598450 = validateParameter(valid_598450, JString, required = false,
                                 default = nil)
  if valid_598450 != nil:
    section.add "userIp", valid_598450
  var valid_598451 = query.getOrDefault("key")
  valid_598451 = validateParameter(valid_598451, JString, required = false,
                                 default = nil)
  if valid_598451 != nil:
    section.add "key", valid_598451
  var valid_598452 = query.getOrDefault("prettyPrint")
  valid_598452 = validateParameter(valid_598452, JBool, required = false,
                                 default = newJBool(true))
  if valid_598452 != nil:
    section.add "prettyPrint", valid_598452
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598453: Call_DirectoryDomainsList_598442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the domains of the customer.
  ## 
  let valid = call_598453.validator(path, query, header, formData, body)
  let scheme = call_598453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598453.url(scheme.get, call_598453.host, call_598453.base,
                         call_598453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598453, url, valid)

proc call*(call_598454: Call_DirectoryDomainsList_598442; customer: string;
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
  var path_598455 = newJObject()
  var query_598456 = newJObject()
  add(query_598456, "fields", newJString(fields))
  add(query_598456, "quotaUser", newJString(quotaUser))
  add(query_598456, "alt", newJString(alt))
  add(query_598456, "oauth_token", newJString(oauthToken))
  add(query_598456, "userIp", newJString(userIp))
  add(query_598456, "key", newJString(key))
  add(path_598455, "customer", newJString(customer))
  add(query_598456, "prettyPrint", newJBool(prettyPrint))
  result = call_598454.call(path_598455, query_598456, nil, nil, nil)

var directoryDomainsList* = Call_DirectoryDomainsList_598442(
    name: "directoryDomainsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/domains",
    validator: validate_DirectoryDomainsList_598443, base: "/admin/directory/v1",
    url: url_DirectoryDomainsList_598444, schemes: {Scheme.Https})
type
  Call_DirectoryDomainsGet_598474 = ref object of OpenApiRestCall_597437
proc url_DirectoryDomainsGet_598476(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryDomainsGet_598475(path: JsonNode; query: JsonNode;
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
  var valid_598477 = path.getOrDefault("domainName")
  valid_598477 = validateParameter(valid_598477, JString, required = true,
                                 default = nil)
  if valid_598477 != nil:
    section.add "domainName", valid_598477
  var valid_598478 = path.getOrDefault("customer")
  valid_598478 = validateParameter(valid_598478, JString, required = true,
                                 default = nil)
  if valid_598478 != nil:
    section.add "customer", valid_598478
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
  var valid_598479 = query.getOrDefault("fields")
  valid_598479 = validateParameter(valid_598479, JString, required = false,
                                 default = nil)
  if valid_598479 != nil:
    section.add "fields", valid_598479
  var valid_598480 = query.getOrDefault("quotaUser")
  valid_598480 = validateParameter(valid_598480, JString, required = false,
                                 default = nil)
  if valid_598480 != nil:
    section.add "quotaUser", valid_598480
  var valid_598481 = query.getOrDefault("alt")
  valid_598481 = validateParameter(valid_598481, JString, required = false,
                                 default = newJString("json"))
  if valid_598481 != nil:
    section.add "alt", valid_598481
  var valid_598482 = query.getOrDefault("oauth_token")
  valid_598482 = validateParameter(valid_598482, JString, required = false,
                                 default = nil)
  if valid_598482 != nil:
    section.add "oauth_token", valid_598482
  var valid_598483 = query.getOrDefault("userIp")
  valid_598483 = validateParameter(valid_598483, JString, required = false,
                                 default = nil)
  if valid_598483 != nil:
    section.add "userIp", valid_598483
  var valid_598484 = query.getOrDefault("key")
  valid_598484 = validateParameter(valid_598484, JString, required = false,
                                 default = nil)
  if valid_598484 != nil:
    section.add "key", valid_598484
  var valid_598485 = query.getOrDefault("prettyPrint")
  valid_598485 = validateParameter(valid_598485, JBool, required = false,
                                 default = newJBool(true))
  if valid_598485 != nil:
    section.add "prettyPrint", valid_598485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598486: Call_DirectoryDomainsGet_598474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a domain of the customer.
  ## 
  let valid = call_598486.validator(path, query, header, formData, body)
  let scheme = call_598486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598486.url(scheme.get, call_598486.host, call_598486.base,
                         call_598486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598486, url, valid)

proc call*(call_598487: Call_DirectoryDomainsGet_598474; domainName: string;
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
  var path_598488 = newJObject()
  var query_598489 = newJObject()
  add(query_598489, "fields", newJString(fields))
  add(query_598489, "quotaUser", newJString(quotaUser))
  add(query_598489, "alt", newJString(alt))
  add(query_598489, "oauth_token", newJString(oauthToken))
  add(query_598489, "userIp", newJString(userIp))
  add(query_598489, "key", newJString(key))
  add(path_598488, "domainName", newJString(domainName))
  add(path_598488, "customer", newJString(customer))
  add(query_598489, "prettyPrint", newJBool(prettyPrint))
  result = call_598487.call(path_598488, query_598489, nil, nil, nil)

var directoryDomainsGet* = Call_DirectoryDomainsGet_598474(
    name: "directoryDomainsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domains/{domainName}",
    validator: validate_DirectoryDomainsGet_598475, base: "/admin/directory/v1",
    url: url_DirectoryDomainsGet_598476, schemes: {Scheme.Https})
type
  Call_DirectoryDomainsDelete_598490 = ref object of OpenApiRestCall_597437
proc url_DirectoryDomainsDelete_598492(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryDomainsDelete_598491(path: JsonNode; query: JsonNode;
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
  var valid_598493 = path.getOrDefault("domainName")
  valid_598493 = validateParameter(valid_598493, JString, required = true,
                                 default = nil)
  if valid_598493 != nil:
    section.add "domainName", valid_598493
  var valid_598494 = path.getOrDefault("customer")
  valid_598494 = validateParameter(valid_598494, JString, required = true,
                                 default = nil)
  if valid_598494 != nil:
    section.add "customer", valid_598494
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
  var valid_598495 = query.getOrDefault("fields")
  valid_598495 = validateParameter(valid_598495, JString, required = false,
                                 default = nil)
  if valid_598495 != nil:
    section.add "fields", valid_598495
  var valid_598496 = query.getOrDefault("quotaUser")
  valid_598496 = validateParameter(valid_598496, JString, required = false,
                                 default = nil)
  if valid_598496 != nil:
    section.add "quotaUser", valid_598496
  var valid_598497 = query.getOrDefault("alt")
  valid_598497 = validateParameter(valid_598497, JString, required = false,
                                 default = newJString("json"))
  if valid_598497 != nil:
    section.add "alt", valid_598497
  var valid_598498 = query.getOrDefault("oauth_token")
  valid_598498 = validateParameter(valid_598498, JString, required = false,
                                 default = nil)
  if valid_598498 != nil:
    section.add "oauth_token", valid_598498
  var valid_598499 = query.getOrDefault("userIp")
  valid_598499 = validateParameter(valid_598499, JString, required = false,
                                 default = nil)
  if valid_598499 != nil:
    section.add "userIp", valid_598499
  var valid_598500 = query.getOrDefault("key")
  valid_598500 = validateParameter(valid_598500, JString, required = false,
                                 default = nil)
  if valid_598500 != nil:
    section.add "key", valid_598500
  var valid_598501 = query.getOrDefault("prettyPrint")
  valid_598501 = validateParameter(valid_598501, JBool, required = false,
                                 default = newJBool(true))
  if valid_598501 != nil:
    section.add "prettyPrint", valid_598501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598502: Call_DirectoryDomainsDelete_598490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a domain of the customer.
  ## 
  let valid = call_598502.validator(path, query, header, formData, body)
  let scheme = call_598502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598502.url(scheme.get, call_598502.host, call_598502.base,
                         call_598502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598502, url, valid)

proc call*(call_598503: Call_DirectoryDomainsDelete_598490; domainName: string;
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
  var path_598504 = newJObject()
  var query_598505 = newJObject()
  add(query_598505, "fields", newJString(fields))
  add(query_598505, "quotaUser", newJString(quotaUser))
  add(query_598505, "alt", newJString(alt))
  add(query_598505, "oauth_token", newJString(oauthToken))
  add(query_598505, "userIp", newJString(userIp))
  add(query_598505, "key", newJString(key))
  add(path_598504, "domainName", newJString(domainName))
  add(path_598504, "customer", newJString(customer))
  add(query_598505, "prettyPrint", newJBool(prettyPrint))
  result = call_598503.call(path_598504, query_598505, nil, nil, nil)

var directoryDomainsDelete* = Call_DirectoryDomainsDelete_598490(
    name: "directoryDomainsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domains/{domainName}",
    validator: validate_DirectoryDomainsDelete_598491,
    base: "/admin/directory/v1", url: url_DirectoryDomainsDelete_598492,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsList_598506 = ref object of OpenApiRestCall_597437
proc url_DirectoryNotificationsList_598508(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryNotificationsList_598507(path: JsonNode; query: JsonNode;
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
  var valid_598509 = path.getOrDefault("customer")
  valid_598509 = validateParameter(valid_598509, JString, required = true,
                                 default = nil)
  if valid_598509 != nil:
    section.add "customer", valid_598509
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
  var valid_598510 = query.getOrDefault("fields")
  valid_598510 = validateParameter(valid_598510, JString, required = false,
                                 default = nil)
  if valid_598510 != nil:
    section.add "fields", valid_598510
  var valid_598511 = query.getOrDefault("pageToken")
  valid_598511 = validateParameter(valid_598511, JString, required = false,
                                 default = nil)
  if valid_598511 != nil:
    section.add "pageToken", valid_598511
  var valid_598512 = query.getOrDefault("quotaUser")
  valid_598512 = validateParameter(valid_598512, JString, required = false,
                                 default = nil)
  if valid_598512 != nil:
    section.add "quotaUser", valid_598512
  var valid_598513 = query.getOrDefault("alt")
  valid_598513 = validateParameter(valid_598513, JString, required = false,
                                 default = newJString("json"))
  if valid_598513 != nil:
    section.add "alt", valid_598513
  var valid_598514 = query.getOrDefault("language")
  valid_598514 = validateParameter(valid_598514, JString, required = false,
                                 default = nil)
  if valid_598514 != nil:
    section.add "language", valid_598514
  var valid_598515 = query.getOrDefault("oauth_token")
  valid_598515 = validateParameter(valid_598515, JString, required = false,
                                 default = nil)
  if valid_598515 != nil:
    section.add "oauth_token", valid_598515
  var valid_598516 = query.getOrDefault("userIp")
  valid_598516 = validateParameter(valid_598516, JString, required = false,
                                 default = nil)
  if valid_598516 != nil:
    section.add "userIp", valid_598516
  var valid_598517 = query.getOrDefault("maxResults")
  valid_598517 = validateParameter(valid_598517, JInt, required = false, default = nil)
  if valid_598517 != nil:
    section.add "maxResults", valid_598517
  var valid_598518 = query.getOrDefault("key")
  valid_598518 = validateParameter(valid_598518, JString, required = false,
                                 default = nil)
  if valid_598518 != nil:
    section.add "key", valid_598518
  var valid_598519 = query.getOrDefault("prettyPrint")
  valid_598519 = validateParameter(valid_598519, JBool, required = false,
                                 default = newJBool(true))
  if valid_598519 != nil:
    section.add "prettyPrint", valid_598519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598520: Call_DirectoryNotificationsList_598506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of notifications.
  ## 
  let valid = call_598520.validator(path, query, header, formData, body)
  let scheme = call_598520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598520.url(scheme.get, call_598520.host, call_598520.base,
                         call_598520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598520, url, valid)

proc call*(call_598521: Call_DirectoryNotificationsList_598506; customer: string;
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
  var path_598522 = newJObject()
  var query_598523 = newJObject()
  add(query_598523, "fields", newJString(fields))
  add(query_598523, "pageToken", newJString(pageToken))
  add(query_598523, "quotaUser", newJString(quotaUser))
  add(query_598523, "alt", newJString(alt))
  add(query_598523, "language", newJString(language))
  add(query_598523, "oauth_token", newJString(oauthToken))
  add(query_598523, "userIp", newJString(userIp))
  add(query_598523, "maxResults", newJInt(maxResults))
  add(query_598523, "key", newJString(key))
  add(path_598522, "customer", newJString(customer))
  add(query_598523, "prettyPrint", newJBool(prettyPrint))
  result = call_598521.call(path_598522, query_598523, nil, nil, nil)

var directoryNotificationsList* = Call_DirectoryNotificationsList_598506(
    name: "directoryNotificationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/notifications",
    validator: validate_DirectoryNotificationsList_598507,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsList_598508,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsUpdate_598540 = ref object of OpenApiRestCall_597437
proc url_DirectoryNotificationsUpdate_598542(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryNotificationsUpdate_598541(path: JsonNode; query: JsonNode;
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
  var valid_598543 = path.getOrDefault("notificationId")
  valid_598543 = validateParameter(valid_598543, JString, required = true,
                                 default = nil)
  if valid_598543 != nil:
    section.add "notificationId", valid_598543
  var valid_598544 = path.getOrDefault("customer")
  valid_598544 = validateParameter(valid_598544, JString, required = true,
                                 default = nil)
  if valid_598544 != nil:
    section.add "customer", valid_598544
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
  var valid_598545 = query.getOrDefault("fields")
  valid_598545 = validateParameter(valid_598545, JString, required = false,
                                 default = nil)
  if valid_598545 != nil:
    section.add "fields", valid_598545
  var valid_598546 = query.getOrDefault("quotaUser")
  valid_598546 = validateParameter(valid_598546, JString, required = false,
                                 default = nil)
  if valid_598546 != nil:
    section.add "quotaUser", valid_598546
  var valid_598547 = query.getOrDefault("alt")
  valid_598547 = validateParameter(valid_598547, JString, required = false,
                                 default = newJString("json"))
  if valid_598547 != nil:
    section.add "alt", valid_598547
  var valid_598548 = query.getOrDefault("oauth_token")
  valid_598548 = validateParameter(valid_598548, JString, required = false,
                                 default = nil)
  if valid_598548 != nil:
    section.add "oauth_token", valid_598548
  var valid_598549 = query.getOrDefault("userIp")
  valid_598549 = validateParameter(valid_598549, JString, required = false,
                                 default = nil)
  if valid_598549 != nil:
    section.add "userIp", valid_598549
  var valid_598550 = query.getOrDefault("key")
  valid_598550 = validateParameter(valid_598550, JString, required = false,
                                 default = nil)
  if valid_598550 != nil:
    section.add "key", valid_598550
  var valid_598551 = query.getOrDefault("prettyPrint")
  valid_598551 = validateParameter(valid_598551, JBool, required = false,
                                 default = newJBool(true))
  if valid_598551 != nil:
    section.add "prettyPrint", valid_598551
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

proc call*(call_598553: Call_DirectoryNotificationsUpdate_598540; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a notification.
  ## 
  let valid = call_598553.validator(path, query, header, formData, body)
  let scheme = call_598553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598553.url(scheme.get, call_598553.host, call_598553.base,
                         call_598553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598553, url, valid)

proc call*(call_598554: Call_DirectoryNotificationsUpdate_598540;
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
  var path_598555 = newJObject()
  var query_598556 = newJObject()
  var body_598557 = newJObject()
  add(query_598556, "fields", newJString(fields))
  add(query_598556, "quotaUser", newJString(quotaUser))
  add(query_598556, "alt", newJString(alt))
  add(path_598555, "notificationId", newJString(notificationId))
  add(query_598556, "oauth_token", newJString(oauthToken))
  add(query_598556, "userIp", newJString(userIp))
  add(query_598556, "key", newJString(key))
  add(path_598555, "customer", newJString(customer))
  if body != nil:
    body_598557 = body
  add(query_598556, "prettyPrint", newJBool(prettyPrint))
  result = call_598554.call(path_598555, query_598556, nil, nil, body_598557)

var directoryNotificationsUpdate* = Call_DirectoryNotificationsUpdate_598540(
    name: "directoryNotificationsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsUpdate_598541,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsUpdate_598542,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsGet_598524 = ref object of OpenApiRestCall_597437
proc url_DirectoryNotificationsGet_598526(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryNotificationsGet_598525(path: JsonNode; query: JsonNode;
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
  var valid_598527 = path.getOrDefault("notificationId")
  valid_598527 = validateParameter(valid_598527, JString, required = true,
                                 default = nil)
  if valid_598527 != nil:
    section.add "notificationId", valid_598527
  var valid_598528 = path.getOrDefault("customer")
  valid_598528 = validateParameter(valid_598528, JString, required = true,
                                 default = nil)
  if valid_598528 != nil:
    section.add "customer", valid_598528
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
  var valid_598529 = query.getOrDefault("fields")
  valid_598529 = validateParameter(valid_598529, JString, required = false,
                                 default = nil)
  if valid_598529 != nil:
    section.add "fields", valid_598529
  var valid_598530 = query.getOrDefault("quotaUser")
  valid_598530 = validateParameter(valid_598530, JString, required = false,
                                 default = nil)
  if valid_598530 != nil:
    section.add "quotaUser", valid_598530
  var valid_598531 = query.getOrDefault("alt")
  valid_598531 = validateParameter(valid_598531, JString, required = false,
                                 default = newJString("json"))
  if valid_598531 != nil:
    section.add "alt", valid_598531
  var valid_598532 = query.getOrDefault("oauth_token")
  valid_598532 = validateParameter(valid_598532, JString, required = false,
                                 default = nil)
  if valid_598532 != nil:
    section.add "oauth_token", valid_598532
  var valid_598533 = query.getOrDefault("userIp")
  valid_598533 = validateParameter(valid_598533, JString, required = false,
                                 default = nil)
  if valid_598533 != nil:
    section.add "userIp", valid_598533
  var valid_598534 = query.getOrDefault("key")
  valid_598534 = validateParameter(valid_598534, JString, required = false,
                                 default = nil)
  if valid_598534 != nil:
    section.add "key", valid_598534
  var valid_598535 = query.getOrDefault("prettyPrint")
  valid_598535 = validateParameter(valid_598535, JBool, required = false,
                                 default = newJBool(true))
  if valid_598535 != nil:
    section.add "prettyPrint", valid_598535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598536: Call_DirectoryNotificationsGet_598524; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a notification.
  ## 
  let valid = call_598536.validator(path, query, header, formData, body)
  let scheme = call_598536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598536.url(scheme.get, call_598536.host, call_598536.base,
                         call_598536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598536, url, valid)

proc call*(call_598537: Call_DirectoryNotificationsGet_598524;
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
  var path_598538 = newJObject()
  var query_598539 = newJObject()
  add(query_598539, "fields", newJString(fields))
  add(query_598539, "quotaUser", newJString(quotaUser))
  add(query_598539, "alt", newJString(alt))
  add(path_598538, "notificationId", newJString(notificationId))
  add(query_598539, "oauth_token", newJString(oauthToken))
  add(query_598539, "userIp", newJString(userIp))
  add(query_598539, "key", newJString(key))
  add(path_598538, "customer", newJString(customer))
  add(query_598539, "prettyPrint", newJBool(prettyPrint))
  result = call_598537.call(path_598538, query_598539, nil, nil, nil)

var directoryNotificationsGet* = Call_DirectoryNotificationsGet_598524(
    name: "directoryNotificationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsGet_598525,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsGet_598526,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsPatch_598574 = ref object of OpenApiRestCall_597437
proc url_DirectoryNotificationsPatch_598576(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryNotificationsPatch_598575(path: JsonNode; query: JsonNode;
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
  var valid_598577 = path.getOrDefault("notificationId")
  valid_598577 = validateParameter(valid_598577, JString, required = true,
                                 default = nil)
  if valid_598577 != nil:
    section.add "notificationId", valid_598577
  var valid_598578 = path.getOrDefault("customer")
  valid_598578 = validateParameter(valid_598578, JString, required = true,
                                 default = nil)
  if valid_598578 != nil:
    section.add "customer", valid_598578
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
  var valid_598579 = query.getOrDefault("fields")
  valid_598579 = validateParameter(valid_598579, JString, required = false,
                                 default = nil)
  if valid_598579 != nil:
    section.add "fields", valid_598579
  var valid_598580 = query.getOrDefault("quotaUser")
  valid_598580 = validateParameter(valid_598580, JString, required = false,
                                 default = nil)
  if valid_598580 != nil:
    section.add "quotaUser", valid_598580
  var valid_598581 = query.getOrDefault("alt")
  valid_598581 = validateParameter(valid_598581, JString, required = false,
                                 default = newJString("json"))
  if valid_598581 != nil:
    section.add "alt", valid_598581
  var valid_598582 = query.getOrDefault("oauth_token")
  valid_598582 = validateParameter(valid_598582, JString, required = false,
                                 default = nil)
  if valid_598582 != nil:
    section.add "oauth_token", valid_598582
  var valid_598583 = query.getOrDefault("userIp")
  valid_598583 = validateParameter(valid_598583, JString, required = false,
                                 default = nil)
  if valid_598583 != nil:
    section.add "userIp", valid_598583
  var valid_598584 = query.getOrDefault("key")
  valid_598584 = validateParameter(valid_598584, JString, required = false,
                                 default = nil)
  if valid_598584 != nil:
    section.add "key", valid_598584
  var valid_598585 = query.getOrDefault("prettyPrint")
  valid_598585 = validateParameter(valid_598585, JBool, required = false,
                                 default = newJBool(true))
  if valid_598585 != nil:
    section.add "prettyPrint", valid_598585
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

proc call*(call_598587: Call_DirectoryNotificationsPatch_598574; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a notification. This method supports patch semantics.
  ## 
  let valid = call_598587.validator(path, query, header, formData, body)
  let scheme = call_598587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598587.url(scheme.get, call_598587.host, call_598587.base,
                         call_598587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598587, url, valid)

proc call*(call_598588: Call_DirectoryNotificationsPatch_598574;
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
  var path_598589 = newJObject()
  var query_598590 = newJObject()
  var body_598591 = newJObject()
  add(query_598590, "fields", newJString(fields))
  add(query_598590, "quotaUser", newJString(quotaUser))
  add(query_598590, "alt", newJString(alt))
  add(path_598589, "notificationId", newJString(notificationId))
  add(query_598590, "oauth_token", newJString(oauthToken))
  add(query_598590, "userIp", newJString(userIp))
  add(query_598590, "key", newJString(key))
  add(path_598589, "customer", newJString(customer))
  if body != nil:
    body_598591 = body
  add(query_598590, "prettyPrint", newJBool(prettyPrint))
  result = call_598588.call(path_598589, query_598590, nil, nil, body_598591)

var directoryNotificationsPatch* = Call_DirectoryNotificationsPatch_598574(
    name: "directoryNotificationsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsPatch_598575,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsPatch_598576,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsDelete_598558 = ref object of OpenApiRestCall_597437
proc url_DirectoryNotificationsDelete_598560(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryNotificationsDelete_598559(path: JsonNode; query: JsonNode;
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
  var valid_598561 = path.getOrDefault("notificationId")
  valid_598561 = validateParameter(valid_598561, JString, required = true,
                                 default = nil)
  if valid_598561 != nil:
    section.add "notificationId", valid_598561
  var valid_598562 = path.getOrDefault("customer")
  valid_598562 = validateParameter(valid_598562, JString, required = true,
                                 default = nil)
  if valid_598562 != nil:
    section.add "customer", valid_598562
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
  var valid_598563 = query.getOrDefault("fields")
  valid_598563 = validateParameter(valid_598563, JString, required = false,
                                 default = nil)
  if valid_598563 != nil:
    section.add "fields", valid_598563
  var valid_598564 = query.getOrDefault("quotaUser")
  valid_598564 = validateParameter(valid_598564, JString, required = false,
                                 default = nil)
  if valid_598564 != nil:
    section.add "quotaUser", valid_598564
  var valid_598565 = query.getOrDefault("alt")
  valid_598565 = validateParameter(valid_598565, JString, required = false,
                                 default = newJString("json"))
  if valid_598565 != nil:
    section.add "alt", valid_598565
  var valid_598566 = query.getOrDefault("oauth_token")
  valid_598566 = validateParameter(valid_598566, JString, required = false,
                                 default = nil)
  if valid_598566 != nil:
    section.add "oauth_token", valid_598566
  var valid_598567 = query.getOrDefault("userIp")
  valid_598567 = validateParameter(valid_598567, JString, required = false,
                                 default = nil)
  if valid_598567 != nil:
    section.add "userIp", valid_598567
  var valid_598568 = query.getOrDefault("key")
  valid_598568 = validateParameter(valid_598568, JString, required = false,
                                 default = nil)
  if valid_598568 != nil:
    section.add "key", valid_598568
  var valid_598569 = query.getOrDefault("prettyPrint")
  valid_598569 = validateParameter(valid_598569, JBool, required = false,
                                 default = newJBool(true))
  if valid_598569 != nil:
    section.add "prettyPrint", valid_598569
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598570: Call_DirectoryNotificationsDelete_598558; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a notification
  ## 
  let valid = call_598570.validator(path, query, header, formData, body)
  let scheme = call_598570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598570.url(scheme.get, call_598570.host, call_598570.base,
                         call_598570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598570, url, valid)

proc call*(call_598571: Call_DirectoryNotificationsDelete_598558;
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
  var path_598572 = newJObject()
  var query_598573 = newJObject()
  add(query_598573, "fields", newJString(fields))
  add(query_598573, "quotaUser", newJString(quotaUser))
  add(query_598573, "alt", newJString(alt))
  add(path_598572, "notificationId", newJString(notificationId))
  add(query_598573, "oauth_token", newJString(oauthToken))
  add(query_598573, "userIp", newJString(userIp))
  add(query_598573, "key", newJString(key))
  add(path_598572, "customer", newJString(customer))
  add(query_598573, "prettyPrint", newJBool(prettyPrint))
  result = call_598571.call(path_598572, query_598573, nil, nil, nil)

var directoryNotificationsDelete* = Call_DirectoryNotificationsDelete_598558(
    name: "directoryNotificationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsDelete_598559,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsDelete_598560,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsInsert_598609 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesBuildingsInsert_598611(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesBuildingsInsert_598610(path: JsonNode;
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
  var valid_598612 = path.getOrDefault("customer")
  valid_598612 = validateParameter(valid_598612, JString, required = true,
                                 default = nil)
  if valid_598612 != nil:
    section.add "customer", valid_598612
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
  var valid_598613 = query.getOrDefault("fields")
  valid_598613 = validateParameter(valid_598613, JString, required = false,
                                 default = nil)
  if valid_598613 != nil:
    section.add "fields", valid_598613
  var valid_598614 = query.getOrDefault("quotaUser")
  valid_598614 = validateParameter(valid_598614, JString, required = false,
                                 default = nil)
  if valid_598614 != nil:
    section.add "quotaUser", valid_598614
  var valid_598615 = query.getOrDefault("coordinatesSource")
  valid_598615 = validateParameter(valid_598615, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_598615 != nil:
    section.add "coordinatesSource", valid_598615
  var valid_598616 = query.getOrDefault("alt")
  valid_598616 = validateParameter(valid_598616, JString, required = false,
                                 default = newJString("json"))
  if valid_598616 != nil:
    section.add "alt", valid_598616
  var valid_598617 = query.getOrDefault("oauth_token")
  valid_598617 = validateParameter(valid_598617, JString, required = false,
                                 default = nil)
  if valid_598617 != nil:
    section.add "oauth_token", valid_598617
  var valid_598618 = query.getOrDefault("userIp")
  valid_598618 = validateParameter(valid_598618, JString, required = false,
                                 default = nil)
  if valid_598618 != nil:
    section.add "userIp", valid_598618
  var valid_598619 = query.getOrDefault("key")
  valid_598619 = validateParameter(valid_598619, JString, required = false,
                                 default = nil)
  if valid_598619 != nil:
    section.add "key", valid_598619
  var valid_598620 = query.getOrDefault("prettyPrint")
  valid_598620 = validateParameter(valid_598620, JBool, required = false,
                                 default = newJBool(true))
  if valid_598620 != nil:
    section.add "prettyPrint", valid_598620
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

proc call*(call_598622: Call_DirectoryResourcesBuildingsInsert_598609;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a building.
  ## 
  let valid = call_598622.validator(path, query, header, formData, body)
  let scheme = call_598622.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598622.url(scheme.get, call_598622.host, call_598622.base,
                         call_598622.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598622, url, valid)

proc call*(call_598623: Call_DirectoryResourcesBuildingsInsert_598609;
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
  var path_598624 = newJObject()
  var query_598625 = newJObject()
  var body_598626 = newJObject()
  add(query_598625, "fields", newJString(fields))
  add(query_598625, "quotaUser", newJString(quotaUser))
  add(query_598625, "coordinatesSource", newJString(coordinatesSource))
  add(query_598625, "alt", newJString(alt))
  add(query_598625, "oauth_token", newJString(oauthToken))
  add(query_598625, "userIp", newJString(userIp))
  add(query_598625, "key", newJString(key))
  add(path_598624, "customer", newJString(customer))
  if body != nil:
    body_598626 = body
  add(query_598625, "prettyPrint", newJBool(prettyPrint))
  result = call_598623.call(path_598624, query_598625, nil, nil, body_598626)

var directoryResourcesBuildingsInsert* = Call_DirectoryResourcesBuildingsInsert_598609(
    name: "directoryResourcesBuildingsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/buildings",
    validator: validate_DirectoryResourcesBuildingsInsert_598610,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsInsert_598611,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsList_598592 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesBuildingsList_598594(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesBuildingsList_598593(path: JsonNode;
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
  var valid_598595 = path.getOrDefault("customer")
  valid_598595 = validateParameter(valid_598595, JString, required = true,
                                 default = nil)
  if valid_598595 != nil:
    section.add "customer", valid_598595
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
  var valid_598596 = query.getOrDefault("fields")
  valid_598596 = validateParameter(valid_598596, JString, required = false,
                                 default = nil)
  if valid_598596 != nil:
    section.add "fields", valid_598596
  var valid_598597 = query.getOrDefault("pageToken")
  valid_598597 = validateParameter(valid_598597, JString, required = false,
                                 default = nil)
  if valid_598597 != nil:
    section.add "pageToken", valid_598597
  var valid_598598 = query.getOrDefault("quotaUser")
  valid_598598 = validateParameter(valid_598598, JString, required = false,
                                 default = nil)
  if valid_598598 != nil:
    section.add "quotaUser", valid_598598
  var valid_598599 = query.getOrDefault("alt")
  valid_598599 = validateParameter(valid_598599, JString, required = false,
                                 default = newJString("json"))
  if valid_598599 != nil:
    section.add "alt", valid_598599
  var valid_598600 = query.getOrDefault("oauth_token")
  valid_598600 = validateParameter(valid_598600, JString, required = false,
                                 default = nil)
  if valid_598600 != nil:
    section.add "oauth_token", valid_598600
  var valid_598601 = query.getOrDefault("userIp")
  valid_598601 = validateParameter(valid_598601, JString, required = false,
                                 default = nil)
  if valid_598601 != nil:
    section.add "userIp", valid_598601
  var valid_598602 = query.getOrDefault("maxResults")
  valid_598602 = validateParameter(valid_598602, JInt, required = false, default = nil)
  if valid_598602 != nil:
    section.add "maxResults", valid_598602
  var valid_598603 = query.getOrDefault("key")
  valid_598603 = validateParameter(valid_598603, JString, required = false,
                                 default = nil)
  if valid_598603 != nil:
    section.add "key", valid_598603
  var valid_598604 = query.getOrDefault("prettyPrint")
  valid_598604 = validateParameter(valid_598604, JBool, required = false,
                                 default = newJBool(true))
  if valid_598604 != nil:
    section.add "prettyPrint", valid_598604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598605: Call_DirectoryResourcesBuildingsList_598592;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of buildings for an account.
  ## 
  let valid = call_598605.validator(path, query, header, formData, body)
  let scheme = call_598605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598605.url(scheme.get, call_598605.host, call_598605.base,
                         call_598605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598605, url, valid)

proc call*(call_598606: Call_DirectoryResourcesBuildingsList_598592;
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
  var path_598607 = newJObject()
  var query_598608 = newJObject()
  add(query_598608, "fields", newJString(fields))
  add(query_598608, "pageToken", newJString(pageToken))
  add(query_598608, "quotaUser", newJString(quotaUser))
  add(query_598608, "alt", newJString(alt))
  add(query_598608, "oauth_token", newJString(oauthToken))
  add(query_598608, "userIp", newJString(userIp))
  add(query_598608, "maxResults", newJInt(maxResults))
  add(query_598608, "key", newJString(key))
  add(path_598607, "customer", newJString(customer))
  add(query_598608, "prettyPrint", newJBool(prettyPrint))
  result = call_598606.call(path_598607, query_598608, nil, nil, nil)

var directoryResourcesBuildingsList* = Call_DirectoryResourcesBuildingsList_598592(
    name: "directoryResourcesBuildingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/buildings",
    validator: validate_DirectoryResourcesBuildingsList_598593,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsList_598594,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsUpdate_598643 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesBuildingsUpdate_598645(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesBuildingsUpdate_598644(path: JsonNode;
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
  var valid_598646 = path.getOrDefault("buildingId")
  valid_598646 = validateParameter(valid_598646, JString, required = true,
                                 default = nil)
  if valid_598646 != nil:
    section.add "buildingId", valid_598646
  var valid_598647 = path.getOrDefault("customer")
  valid_598647 = validateParameter(valid_598647, JString, required = true,
                                 default = nil)
  if valid_598647 != nil:
    section.add "customer", valid_598647
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
  var valid_598648 = query.getOrDefault("fields")
  valid_598648 = validateParameter(valid_598648, JString, required = false,
                                 default = nil)
  if valid_598648 != nil:
    section.add "fields", valid_598648
  var valid_598649 = query.getOrDefault("quotaUser")
  valid_598649 = validateParameter(valid_598649, JString, required = false,
                                 default = nil)
  if valid_598649 != nil:
    section.add "quotaUser", valid_598649
  var valid_598650 = query.getOrDefault("coordinatesSource")
  valid_598650 = validateParameter(valid_598650, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_598650 != nil:
    section.add "coordinatesSource", valid_598650
  var valid_598651 = query.getOrDefault("alt")
  valid_598651 = validateParameter(valid_598651, JString, required = false,
                                 default = newJString("json"))
  if valid_598651 != nil:
    section.add "alt", valid_598651
  var valid_598652 = query.getOrDefault("oauth_token")
  valid_598652 = validateParameter(valid_598652, JString, required = false,
                                 default = nil)
  if valid_598652 != nil:
    section.add "oauth_token", valid_598652
  var valid_598653 = query.getOrDefault("userIp")
  valid_598653 = validateParameter(valid_598653, JString, required = false,
                                 default = nil)
  if valid_598653 != nil:
    section.add "userIp", valid_598653
  var valid_598654 = query.getOrDefault("key")
  valid_598654 = validateParameter(valid_598654, JString, required = false,
                                 default = nil)
  if valid_598654 != nil:
    section.add "key", valid_598654
  var valid_598655 = query.getOrDefault("prettyPrint")
  valid_598655 = validateParameter(valid_598655, JBool, required = false,
                                 default = newJBool(true))
  if valid_598655 != nil:
    section.add "prettyPrint", valid_598655
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

proc call*(call_598657: Call_DirectoryResourcesBuildingsUpdate_598643;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a building.
  ## 
  let valid = call_598657.validator(path, query, header, formData, body)
  let scheme = call_598657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598657.url(scheme.get, call_598657.host, call_598657.base,
                         call_598657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598657, url, valid)

proc call*(call_598658: Call_DirectoryResourcesBuildingsUpdate_598643;
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
  var path_598659 = newJObject()
  var query_598660 = newJObject()
  var body_598661 = newJObject()
  add(query_598660, "fields", newJString(fields))
  add(query_598660, "quotaUser", newJString(quotaUser))
  add(query_598660, "coordinatesSource", newJString(coordinatesSource))
  add(path_598659, "buildingId", newJString(buildingId))
  add(query_598660, "alt", newJString(alt))
  add(query_598660, "oauth_token", newJString(oauthToken))
  add(query_598660, "userIp", newJString(userIp))
  add(query_598660, "key", newJString(key))
  add(path_598659, "customer", newJString(customer))
  if body != nil:
    body_598661 = body
  add(query_598660, "prettyPrint", newJBool(prettyPrint))
  result = call_598658.call(path_598659, query_598660, nil, nil, body_598661)

var directoryResourcesBuildingsUpdate* = Call_DirectoryResourcesBuildingsUpdate_598643(
    name: "directoryResourcesBuildingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsUpdate_598644,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsUpdate_598645,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsGet_598627 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesBuildingsGet_598629(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesBuildingsGet_598628(path: JsonNode;
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
  var valid_598630 = path.getOrDefault("buildingId")
  valid_598630 = validateParameter(valid_598630, JString, required = true,
                                 default = nil)
  if valid_598630 != nil:
    section.add "buildingId", valid_598630
  var valid_598631 = path.getOrDefault("customer")
  valid_598631 = validateParameter(valid_598631, JString, required = true,
                                 default = nil)
  if valid_598631 != nil:
    section.add "customer", valid_598631
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
  var valid_598632 = query.getOrDefault("fields")
  valid_598632 = validateParameter(valid_598632, JString, required = false,
                                 default = nil)
  if valid_598632 != nil:
    section.add "fields", valid_598632
  var valid_598633 = query.getOrDefault("quotaUser")
  valid_598633 = validateParameter(valid_598633, JString, required = false,
                                 default = nil)
  if valid_598633 != nil:
    section.add "quotaUser", valid_598633
  var valid_598634 = query.getOrDefault("alt")
  valid_598634 = validateParameter(valid_598634, JString, required = false,
                                 default = newJString("json"))
  if valid_598634 != nil:
    section.add "alt", valid_598634
  var valid_598635 = query.getOrDefault("oauth_token")
  valid_598635 = validateParameter(valid_598635, JString, required = false,
                                 default = nil)
  if valid_598635 != nil:
    section.add "oauth_token", valid_598635
  var valid_598636 = query.getOrDefault("userIp")
  valid_598636 = validateParameter(valid_598636, JString, required = false,
                                 default = nil)
  if valid_598636 != nil:
    section.add "userIp", valid_598636
  var valid_598637 = query.getOrDefault("key")
  valid_598637 = validateParameter(valid_598637, JString, required = false,
                                 default = nil)
  if valid_598637 != nil:
    section.add "key", valid_598637
  var valid_598638 = query.getOrDefault("prettyPrint")
  valid_598638 = validateParameter(valid_598638, JBool, required = false,
                                 default = newJBool(true))
  if valid_598638 != nil:
    section.add "prettyPrint", valid_598638
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598639: Call_DirectoryResourcesBuildingsGet_598627; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a building.
  ## 
  let valid = call_598639.validator(path, query, header, formData, body)
  let scheme = call_598639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598639.url(scheme.get, call_598639.host, call_598639.base,
                         call_598639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598639, url, valid)

proc call*(call_598640: Call_DirectoryResourcesBuildingsGet_598627;
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
  var path_598641 = newJObject()
  var query_598642 = newJObject()
  add(query_598642, "fields", newJString(fields))
  add(query_598642, "quotaUser", newJString(quotaUser))
  add(path_598641, "buildingId", newJString(buildingId))
  add(query_598642, "alt", newJString(alt))
  add(query_598642, "oauth_token", newJString(oauthToken))
  add(query_598642, "userIp", newJString(userIp))
  add(query_598642, "key", newJString(key))
  add(path_598641, "customer", newJString(customer))
  add(query_598642, "prettyPrint", newJBool(prettyPrint))
  result = call_598640.call(path_598641, query_598642, nil, nil, nil)

var directoryResourcesBuildingsGet* = Call_DirectoryResourcesBuildingsGet_598627(
    name: "directoryResourcesBuildingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsGet_598628,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsGet_598629,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsPatch_598678 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesBuildingsPatch_598680(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesBuildingsPatch_598679(path: JsonNode;
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
  var valid_598681 = path.getOrDefault("buildingId")
  valid_598681 = validateParameter(valid_598681, JString, required = true,
                                 default = nil)
  if valid_598681 != nil:
    section.add "buildingId", valid_598681
  var valid_598682 = path.getOrDefault("customer")
  valid_598682 = validateParameter(valid_598682, JString, required = true,
                                 default = nil)
  if valid_598682 != nil:
    section.add "customer", valid_598682
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
  var valid_598683 = query.getOrDefault("fields")
  valid_598683 = validateParameter(valid_598683, JString, required = false,
                                 default = nil)
  if valid_598683 != nil:
    section.add "fields", valid_598683
  var valid_598684 = query.getOrDefault("quotaUser")
  valid_598684 = validateParameter(valid_598684, JString, required = false,
                                 default = nil)
  if valid_598684 != nil:
    section.add "quotaUser", valid_598684
  var valid_598685 = query.getOrDefault("coordinatesSource")
  valid_598685 = validateParameter(valid_598685, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_598685 != nil:
    section.add "coordinatesSource", valid_598685
  var valid_598686 = query.getOrDefault("alt")
  valid_598686 = validateParameter(valid_598686, JString, required = false,
                                 default = newJString("json"))
  if valid_598686 != nil:
    section.add "alt", valid_598686
  var valid_598687 = query.getOrDefault("oauth_token")
  valid_598687 = validateParameter(valid_598687, JString, required = false,
                                 default = nil)
  if valid_598687 != nil:
    section.add "oauth_token", valid_598687
  var valid_598688 = query.getOrDefault("userIp")
  valid_598688 = validateParameter(valid_598688, JString, required = false,
                                 default = nil)
  if valid_598688 != nil:
    section.add "userIp", valid_598688
  var valid_598689 = query.getOrDefault("key")
  valid_598689 = validateParameter(valid_598689, JString, required = false,
                                 default = nil)
  if valid_598689 != nil:
    section.add "key", valid_598689
  var valid_598690 = query.getOrDefault("prettyPrint")
  valid_598690 = validateParameter(valid_598690, JBool, required = false,
                                 default = newJBool(true))
  if valid_598690 != nil:
    section.add "prettyPrint", valid_598690
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

proc call*(call_598692: Call_DirectoryResourcesBuildingsPatch_598678;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a building. This method supports patch semantics.
  ## 
  let valid = call_598692.validator(path, query, header, formData, body)
  let scheme = call_598692.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598692.url(scheme.get, call_598692.host, call_598692.base,
                         call_598692.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598692, url, valid)

proc call*(call_598693: Call_DirectoryResourcesBuildingsPatch_598678;
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
  var path_598694 = newJObject()
  var query_598695 = newJObject()
  var body_598696 = newJObject()
  add(query_598695, "fields", newJString(fields))
  add(query_598695, "quotaUser", newJString(quotaUser))
  add(query_598695, "coordinatesSource", newJString(coordinatesSource))
  add(path_598694, "buildingId", newJString(buildingId))
  add(query_598695, "alt", newJString(alt))
  add(query_598695, "oauth_token", newJString(oauthToken))
  add(query_598695, "userIp", newJString(userIp))
  add(query_598695, "key", newJString(key))
  add(path_598694, "customer", newJString(customer))
  if body != nil:
    body_598696 = body
  add(query_598695, "prettyPrint", newJBool(prettyPrint))
  result = call_598693.call(path_598694, query_598695, nil, nil, body_598696)

var directoryResourcesBuildingsPatch* = Call_DirectoryResourcesBuildingsPatch_598678(
    name: "directoryResourcesBuildingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsPatch_598679,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsPatch_598680,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsDelete_598662 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesBuildingsDelete_598664(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesBuildingsDelete_598663(path: JsonNode;
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
  var valid_598665 = path.getOrDefault("buildingId")
  valid_598665 = validateParameter(valid_598665, JString, required = true,
                                 default = nil)
  if valid_598665 != nil:
    section.add "buildingId", valid_598665
  var valid_598666 = path.getOrDefault("customer")
  valid_598666 = validateParameter(valid_598666, JString, required = true,
                                 default = nil)
  if valid_598666 != nil:
    section.add "customer", valid_598666
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
  var valid_598667 = query.getOrDefault("fields")
  valid_598667 = validateParameter(valid_598667, JString, required = false,
                                 default = nil)
  if valid_598667 != nil:
    section.add "fields", valid_598667
  var valid_598668 = query.getOrDefault("quotaUser")
  valid_598668 = validateParameter(valid_598668, JString, required = false,
                                 default = nil)
  if valid_598668 != nil:
    section.add "quotaUser", valid_598668
  var valid_598669 = query.getOrDefault("alt")
  valid_598669 = validateParameter(valid_598669, JString, required = false,
                                 default = newJString("json"))
  if valid_598669 != nil:
    section.add "alt", valid_598669
  var valid_598670 = query.getOrDefault("oauth_token")
  valid_598670 = validateParameter(valid_598670, JString, required = false,
                                 default = nil)
  if valid_598670 != nil:
    section.add "oauth_token", valid_598670
  var valid_598671 = query.getOrDefault("userIp")
  valid_598671 = validateParameter(valid_598671, JString, required = false,
                                 default = nil)
  if valid_598671 != nil:
    section.add "userIp", valid_598671
  var valid_598672 = query.getOrDefault("key")
  valid_598672 = validateParameter(valid_598672, JString, required = false,
                                 default = nil)
  if valid_598672 != nil:
    section.add "key", valid_598672
  var valid_598673 = query.getOrDefault("prettyPrint")
  valid_598673 = validateParameter(valid_598673, JBool, required = false,
                                 default = newJBool(true))
  if valid_598673 != nil:
    section.add "prettyPrint", valid_598673
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598674: Call_DirectoryResourcesBuildingsDelete_598662;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a building.
  ## 
  let valid = call_598674.validator(path, query, header, formData, body)
  let scheme = call_598674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598674.url(scheme.get, call_598674.host, call_598674.base,
                         call_598674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598674, url, valid)

proc call*(call_598675: Call_DirectoryResourcesBuildingsDelete_598662;
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
  var path_598676 = newJObject()
  var query_598677 = newJObject()
  add(query_598677, "fields", newJString(fields))
  add(query_598677, "quotaUser", newJString(quotaUser))
  add(path_598676, "buildingId", newJString(buildingId))
  add(query_598677, "alt", newJString(alt))
  add(query_598677, "oauth_token", newJString(oauthToken))
  add(query_598677, "userIp", newJString(userIp))
  add(query_598677, "key", newJString(key))
  add(path_598676, "customer", newJString(customer))
  add(query_598677, "prettyPrint", newJBool(prettyPrint))
  result = call_598675.call(path_598676, query_598677, nil, nil, nil)

var directoryResourcesBuildingsDelete* = Call_DirectoryResourcesBuildingsDelete_598662(
    name: "directoryResourcesBuildingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsDelete_598663,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsDelete_598664,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsInsert_598716 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesCalendarsInsert_598718(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesCalendarsInsert_598717(path: JsonNode;
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
  var valid_598719 = path.getOrDefault("customer")
  valid_598719 = validateParameter(valid_598719, JString, required = true,
                                 default = nil)
  if valid_598719 != nil:
    section.add "customer", valid_598719
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
  var valid_598720 = query.getOrDefault("fields")
  valid_598720 = validateParameter(valid_598720, JString, required = false,
                                 default = nil)
  if valid_598720 != nil:
    section.add "fields", valid_598720
  var valid_598721 = query.getOrDefault("quotaUser")
  valid_598721 = validateParameter(valid_598721, JString, required = false,
                                 default = nil)
  if valid_598721 != nil:
    section.add "quotaUser", valid_598721
  var valid_598722 = query.getOrDefault("alt")
  valid_598722 = validateParameter(valid_598722, JString, required = false,
                                 default = newJString("json"))
  if valid_598722 != nil:
    section.add "alt", valid_598722
  var valid_598723 = query.getOrDefault("oauth_token")
  valid_598723 = validateParameter(valid_598723, JString, required = false,
                                 default = nil)
  if valid_598723 != nil:
    section.add "oauth_token", valid_598723
  var valid_598724 = query.getOrDefault("userIp")
  valid_598724 = validateParameter(valid_598724, JString, required = false,
                                 default = nil)
  if valid_598724 != nil:
    section.add "userIp", valid_598724
  var valid_598725 = query.getOrDefault("key")
  valid_598725 = validateParameter(valid_598725, JString, required = false,
                                 default = nil)
  if valid_598725 != nil:
    section.add "key", valid_598725
  var valid_598726 = query.getOrDefault("prettyPrint")
  valid_598726 = validateParameter(valid_598726, JBool, required = false,
                                 default = newJBool(true))
  if valid_598726 != nil:
    section.add "prettyPrint", valid_598726
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

proc call*(call_598728: Call_DirectoryResourcesCalendarsInsert_598716;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a calendar resource.
  ## 
  let valid = call_598728.validator(path, query, header, formData, body)
  let scheme = call_598728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598728.url(scheme.get, call_598728.host, call_598728.base,
                         call_598728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598728, url, valid)

proc call*(call_598729: Call_DirectoryResourcesCalendarsInsert_598716;
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
  var path_598730 = newJObject()
  var query_598731 = newJObject()
  var body_598732 = newJObject()
  add(query_598731, "fields", newJString(fields))
  add(query_598731, "quotaUser", newJString(quotaUser))
  add(query_598731, "alt", newJString(alt))
  add(query_598731, "oauth_token", newJString(oauthToken))
  add(query_598731, "userIp", newJString(userIp))
  add(query_598731, "key", newJString(key))
  add(path_598730, "customer", newJString(customer))
  if body != nil:
    body_598732 = body
  add(query_598731, "prettyPrint", newJBool(prettyPrint))
  result = call_598729.call(path_598730, query_598731, nil, nil, body_598732)

var directoryResourcesCalendarsInsert* = Call_DirectoryResourcesCalendarsInsert_598716(
    name: "directoryResourcesCalendarsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/calendars",
    validator: validate_DirectoryResourcesCalendarsInsert_598717,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsInsert_598718,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsList_598697 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesCalendarsList_598699(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesCalendarsList_598698(path: JsonNode;
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
  var valid_598700 = path.getOrDefault("customer")
  valid_598700 = validateParameter(valid_598700, JString, required = true,
                                 default = nil)
  if valid_598700 != nil:
    section.add "customer", valid_598700
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
  var valid_598701 = query.getOrDefault("fields")
  valid_598701 = validateParameter(valid_598701, JString, required = false,
                                 default = nil)
  if valid_598701 != nil:
    section.add "fields", valid_598701
  var valid_598702 = query.getOrDefault("pageToken")
  valid_598702 = validateParameter(valid_598702, JString, required = false,
                                 default = nil)
  if valid_598702 != nil:
    section.add "pageToken", valid_598702
  var valid_598703 = query.getOrDefault("quotaUser")
  valid_598703 = validateParameter(valid_598703, JString, required = false,
                                 default = nil)
  if valid_598703 != nil:
    section.add "quotaUser", valid_598703
  var valid_598704 = query.getOrDefault("alt")
  valid_598704 = validateParameter(valid_598704, JString, required = false,
                                 default = newJString("json"))
  if valid_598704 != nil:
    section.add "alt", valid_598704
  var valid_598705 = query.getOrDefault("query")
  valid_598705 = validateParameter(valid_598705, JString, required = false,
                                 default = nil)
  if valid_598705 != nil:
    section.add "query", valid_598705
  var valid_598706 = query.getOrDefault("oauth_token")
  valid_598706 = validateParameter(valid_598706, JString, required = false,
                                 default = nil)
  if valid_598706 != nil:
    section.add "oauth_token", valid_598706
  var valid_598707 = query.getOrDefault("userIp")
  valid_598707 = validateParameter(valid_598707, JString, required = false,
                                 default = nil)
  if valid_598707 != nil:
    section.add "userIp", valid_598707
  var valid_598708 = query.getOrDefault("maxResults")
  valid_598708 = validateParameter(valid_598708, JInt, required = false, default = nil)
  if valid_598708 != nil:
    section.add "maxResults", valid_598708
  var valid_598709 = query.getOrDefault("orderBy")
  valid_598709 = validateParameter(valid_598709, JString, required = false,
                                 default = nil)
  if valid_598709 != nil:
    section.add "orderBy", valid_598709
  var valid_598710 = query.getOrDefault("key")
  valid_598710 = validateParameter(valid_598710, JString, required = false,
                                 default = nil)
  if valid_598710 != nil:
    section.add "key", valid_598710
  var valid_598711 = query.getOrDefault("prettyPrint")
  valid_598711 = validateParameter(valid_598711, JBool, required = false,
                                 default = newJBool(true))
  if valid_598711 != nil:
    section.add "prettyPrint", valid_598711
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598712: Call_DirectoryResourcesCalendarsList_598697;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of calendar resources for an account.
  ## 
  let valid = call_598712.validator(path, query, header, formData, body)
  let scheme = call_598712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598712.url(scheme.get, call_598712.host, call_598712.base,
                         call_598712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598712, url, valid)

proc call*(call_598713: Call_DirectoryResourcesCalendarsList_598697;
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
  var path_598714 = newJObject()
  var query_598715 = newJObject()
  add(query_598715, "fields", newJString(fields))
  add(query_598715, "pageToken", newJString(pageToken))
  add(query_598715, "quotaUser", newJString(quotaUser))
  add(query_598715, "alt", newJString(alt))
  add(query_598715, "query", newJString(query))
  add(query_598715, "oauth_token", newJString(oauthToken))
  add(query_598715, "userIp", newJString(userIp))
  add(query_598715, "maxResults", newJInt(maxResults))
  add(query_598715, "orderBy", newJString(orderBy))
  add(query_598715, "key", newJString(key))
  add(path_598714, "customer", newJString(customer))
  add(query_598715, "prettyPrint", newJBool(prettyPrint))
  result = call_598713.call(path_598714, query_598715, nil, nil, nil)

var directoryResourcesCalendarsList* = Call_DirectoryResourcesCalendarsList_598697(
    name: "directoryResourcesCalendarsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/calendars",
    validator: validate_DirectoryResourcesCalendarsList_598698,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsList_598699,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsUpdate_598749 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesCalendarsUpdate_598751(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesCalendarsUpdate_598750(path: JsonNode;
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
  var valid_598752 = path.getOrDefault("calendarResourceId")
  valid_598752 = validateParameter(valid_598752, JString, required = true,
                                 default = nil)
  if valid_598752 != nil:
    section.add "calendarResourceId", valid_598752
  var valid_598753 = path.getOrDefault("customer")
  valid_598753 = validateParameter(valid_598753, JString, required = true,
                                 default = nil)
  if valid_598753 != nil:
    section.add "customer", valid_598753
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
  var valid_598754 = query.getOrDefault("fields")
  valid_598754 = validateParameter(valid_598754, JString, required = false,
                                 default = nil)
  if valid_598754 != nil:
    section.add "fields", valid_598754
  var valid_598755 = query.getOrDefault("quotaUser")
  valid_598755 = validateParameter(valid_598755, JString, required = false,
                                 default = nil)
  if valid_598755 != nil:
    section.add "quotaUser", valid_598755
  var valid_598756 = query.getOrDefault("alt")
  valid_598756 = validateParameter(valid_598756, JString, required = false,
                                 default = newJString("json"))
  if valid_598756 != nil:
    section.add "alt", valid_598756
  var valid_598757 = query.getOrDefault("oauth_token")
  valid_598757 = validateParameter(valid_598757, JString, required = false,
                                 default = nil)
  if valid_598757 != nil:
    section.add "oauth_token", valid_598757
  var valid_598758 = query.getOrDefault("userIp")
  valid_598758 = validateParameter(valid_598758, JString, required = false,
                                 default = nil)
  if valid_598758 != nil:
    section.add "userIp", valid_598758
  var valid_598759 = query.getOrDefault("key")
  valid_598759 = validateParameter(valid_598759, JString, required = false,
                                 default = nil)
  if valid_598759 != nil:
    section.add "key", valid_598759
  var valid_598760 = query.getOrDefault("prettyPrint")
  valid_598760 = validateParameter(valid_598760, JBool, required = false,
                                 default = newJBool(true))
  if valid_598760 != nil:
    section.add "prettyPrint", valid_598760
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

proc call*(call_598762: Call_DirectoryResourcesCalendarsUpdate_598749;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved.
  ## 
  let valid = call_598762.validator(path, query, header, formData, body)
  let scheme = call_598762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598762.url(scheme.get, call_598762.host, call_598762.base,
                         call_598762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598762, url, valid)

proc call*(call_598763: Call_DirectoryResourcesCalendarsUpdate_598749;
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
  var path_598764 = newJObject()
  var query_598765 = newJObject()
  var body_598766 = newJObject()
  add(query_598765, "fields", newJString(fields))
  add(query_598765, "quotaUser", newJString(quotaUser))
  add(query_598765, "alt", newJString(alt))
  add(query_598765, "oauth_token", newJString(oauthToken))
  add(query_598765, "userIp", newJString(userIp))
  add(path_598764, "calendarResourceId", newJString(calendarResourceId))
  add(query_598765, "key", newJString(key))
  add(path_598764, "customer", newJString(customer))
  if body != nil:
    body_598766 = body
  add(query_598765, "prettyPrint", newJBool(prettyPrint))
  result = call_598763.call(path_598764, query_598765, nil, nil, body_598766)

var directoryResourcesCalendarsUpdate* = Call_DirectoryResourcesCalendarsUpdate_598749(
    name: "directoryResourcesCalendarsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsUpdate_598750,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsUpdate_598751,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsGet_598733 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesCalendarsGet_598735(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesCalendarsGet_598734(path: JsonNode;
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
  var valid_598736 = path.getOrDefault("calendarResourceId")
  valid_598736 = validateParameter(valid_598736, JString, required = true,
                                 default = nil)
  if valid_598736 != nil:
    section.add "calendarResourceId", valid_598736
  var valid_598737 = path.getOrDefault("customer")
  valid_598737 = validateParameter(valid_598737, JString, required = true,
                                 default = nil)
  if valid_598737 != nil:
    section.add "customer", valid_598737
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
  var valid_598738 = query.getOrDefault("fields")
  valid_598738 = validateParameter(valid_598738, JString, required = false,
                                 default = nil)
  if valid_598738 != nil:
    section.add "fields", valid_598738
  var valid_598739 = query.getOrDefault("quotaUser")
  valid_598739 = validateParameter(valid_598739, JString, required = false,
                                 default = nil)
  if valid_598739 != nil:
    section.add "quotaUser", valid_598739
  var valid_598740 = query.getOrDefault("alt")
  valid_598740 = validateParameter(valid_598740, JString, required = false,
                                 default = newJString("json"))
  if valid_598740 != nil:
    section.add "alt", valid_598740
  var valid_598741 = query.getOrDefault("oauth_token")
  valid_598741 = validateParameter(valid_598741, JString, required = false,
                                 default = nil)
  if valid_598741 != nil:
    section.add "oauth_token", valid_598741
  var valid_598742 = query.getOrDefault("userIp")
  valid_598742 = validateParameter(valid_598742, JString, required = false,
                                 default = nil)
  if valid_598742 != nil:
    section.add "userIp", valid_598742
  var valid_598743 = query.getOrDefault("key")
  valid_598743 = validateParameter(valid_598743, JString, required = false,
                                 default = nil)
  if valid_598743 != nil:
    section.add "key", valid_598743
  var valid_598744 = query.getOrDefault("prettyPrint")
  valid_598744 = validateParameter(valid_598744, JBool, required = false,
                                 default = newJBool(true))
  if valid_598744 != nil:
    section.add "prettyPrint", valid_598744
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598745: Call_DirectoryResourcesCalendarsGet_598733; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a calendar resource.
  ## 
  let valid = call_598745.validator(path, query, header, formData, body)
  let scheme = call_598745.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598745.url(scheme.get, call_598745.host, call_598745.base,
                         call_598745.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598745, url, valid)

proc call*(call_598746: Call_DirectoryResourcesCalendarsGet_598733;
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
  var path_598747 = newJObject()
  var query_598748 = newJObject()
  add(query_598748, "fields", newJString(fields))
  add(query_598748, "quotaUser", newJString(quotaUser))
  add(query_598748, "alt", newJString(alt))
  add(query_598748, "oauth_token", newJString(oauthToken))
  add(query_598748, "userIp", newJString(userIp))
  add(path_598747, "calendarResourceId", newJString(calendarResourceId))
  add(query_598748, "key", newJString(key))
  add(path_598747, "customer", newJString(customer))
  add(query_598748, "prettyPrint", newJBool(prettyPrint))
  result = call_598746.call(path_598747, query_598748, nil, nil, nil)

var directoryResourcesCalendarsGet* = Call_DirectoryResourcesCalendarsGet_598733(
    name: "directoryResourcesCalendarsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsGet_598734,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsGet_598735,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsPatch_598783 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesCalendarsPatch_598785(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesCalendarsPatch_598784(path: JsonNode;
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
  var valid_598786 = path.getOrDefault("calendarResourceId")
  valid_598786 = validateParameter(valid_598786, JString, required = true,
                                 default = nil)
  if valid_598786 != nil:
    section.add "calendarResourceId", valid_598786
  var valid_598787 = path.getOrDefault("customer")
  valid_598787 = validateParameter(valid_598787, JString, required = true,
                                 default = nil)
  if valid_598787 != nil:
    section.add "customer", valid_598787
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
  var valid_598788 = query.getOrDefault("fields")
  valid_598788 = validateParameter(valid_598788, JString, required = false,
                                 default = nil)
  if valid_598788 != nil:
    section.add "fields", valid_598788
  var valid_598789 = query.getOrDefault("quotaUser")
  valid_598789 = validateParameter(valid_598789, JString, required = false,
                                 default = nil)
  if valid_598789 != nil:
    section.add "quotaUser", valid_598789
  var valid_598790 = query.getOrDefault("alt")
  valid_598790 = validateParameter(valid_598790, JString, required = false,
                                 default = newJString("json"))
  if valid_598790 != nil:
    section.add "alt", valid_598790
  var valid_598791 = query.getOrDefault("oauth_token")
  valid_598791 = validateParameter(valid_598791, JString, required = false,
                                 default = nil)
  if valid_598791 != nil:
    section.add "oauth_token", valid_598791
  var valid_598792 = query.getOrDefault("userIp")
  valid_598792 = validateParameter(valid_598792, JString, required = false,
                                 default = nil)
  if valid_598792 != nil:
    section.add "userIp", valid_598792
  var valid_598793 = query.getOrDefault("key")
  valid_598793 = validateParameter(valid_598793, JString, required = false,
                                 default = nil)
  if valid_598793 != nil:
    section.add "key", valid_598793
  var valid_598794 = query.getOrDefault("prettyPrint")
  valid_598794 = validateParameter(valid_598794, JBool, required = false,
                                 default = newJBool(true))
  if valid_598794 != nil:
    section.add "prettyPrint", valid_598794
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

proc call*(call_598796: Call_DirectoryResourcesCalendarsPatch_598783;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved. This method supports patch semantics.
  ## 
  let valid = call_598796.validator(path, query, header, formData, body)
  let scheme = call_598796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598796.url(scheme.get, call_598796.host, call_598796.base,
                         call_598796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598796, url, valid)

proc call*(call_598797: Call_DirectoryResourcesCalendarsPatch_598783;
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
  var path_598798 = newJObject()
  var query_598799 = newJObject()
  var body_598800 = newJObject()
  add(query_598799, "fields", newJString(fields))
  add(query_598799, "quotaUser", newJString(quotaUser))
  add(query_598799, "alt", newJString(alt))
  add(query_598799, "oauth_token", newJString(oauthToken))
  add(query_598799, "userIp", newJString(userIp))
  add(path_598798, "calendarResourceId", newJString(calendarResourceId))
  add(query_598799, "key", newJString(key))
  add(path_598798, "customer", newJString(customer))
  if body != nil:
    body_598800 = body
  add(query_598799, "prettyPrint", newJBool(prettyPrint))
  result = call_598797.call(path_598798, query_598799, nil, nil, body_598800)

var directoryResourcesCalendarsPatch* = Call_DirectoryResourcesCalendarsPatch_598783(
    name: "directoryResourcesCalendarsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsPatch_598784,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsPatch_598785,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsDelete_598767 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesCalendarsDelete_598769(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesCalendarsDelete_598768(path: JsonNode;
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
  var valid_598770 = path.getOrDefault("calendarResourceId")
  valid_598770 = validateParameter(valid_598770, JString, required = true,
                                 default = nil)
  if valid_598770 != nil:
    section.add "calendarResourceId", valid_598770
  var valid_598771 = path.getOrDefault("customer")
  valid_598771 = validateParameter(valid_598771, JString, required = true,
                                 default = nil)
  if valid_598771 != nil:
    section.add "customer", valid_598771
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
  var valid_598772 = query.getOrDefault("fields")
  valid_598772 = validateParameter(valid_598772, JString, required = false,
                                 default = nil)
  if valid_598772 != nil:
    section.add "fields", valid_598772
  var valid_598773 = query.getOrDefault("quotaUser")
  valid_598773 = validateParameter(valid_598773, JString, required = false,
                                 default = nil)
  if valid_598773 != nil:
    section.add "quotaUser", valid_598773
  var valid_598774 = query.getOrDefault("alt")
  valid_598774 = validateParameter(valid_598774, JString, required = false,
                                 default = newJString("json"))
  if valid_598774 != nil:
    section.add "alt", valid_598774
  var valid_598775 = query.getOrDefault("oauth_token")
  valid_598775 = validateParameter(valid_598775, JString, required = false,
                                 default = nil)
  if valid_598775 != nil:
    section.add "oauth_token", valid_598775
  var valid_598776 = query.getOrDefault("userIp")
  valid_598776 = validateParameter(valid_598776, JString, required = false,
                                 default = nil)
  if valid_598776 != nil:
    section.add "userIp", valid_598776
  var valid_598777 = query.getOrDefault("key")
  valid_598777 = validateParameter(valid_598777, JString, required = false,
                                 default = nil)
  if valid_598777 != nil:
    section.add "key", valid_598777
  var valid_598778 = query.getOrDefault("prettyPrint")
  valid_598778 = validateParameter(valid_598778, JBool, required = false,
                                 default = newJBool(true))
  if valid_598778 != nil:
    section.add "prettyPrint", valid_598778
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598779: Call_DirectoryResourcesCalendarsDelete_598767;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a calendar resource.
  ## 
  let valid = call_598779.validator(path, query, header, formData, body)
  let scheme = call_598779.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598779.url(scheme.get, call_598779.host, call_598779.base,
                         call_598779.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598779, url, valid)

proc call*(call_598780: Call_DirectoryResourcesCalendarsDelete_598767;
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
  var path_598781 = newJObject()
  var query_598782 = newJObject()
  add(query_598782, "fields", newJString(fields))
  add(query_598782, "quotaUser", newJString(quotaUser))
  add(query_598782, "alt", newJString(alt))
  add(query_598782, "oauth_token", newJString(oauthToken))
  add(query_598782, "userIp", newJString(userIp))
  add(path_598781, "calendarResourceId", newJString(calendarResourceId))
  add(query_598782, "key", newJString(key))
  add(path_598781, "customer", newJString(customer))
  add(query_598782, "prettyPrint", newJBool(prettyPrint))
  result = call_598780.call(path_598781, query_598782, nil, nil, nil)

var directoryResourcesCalendarsDelete* = Call_DirectoryResourcesCalendarsDelete_598767(
    name: "directoryResourcesCalendarsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsDelete_598768,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsDelete_598769,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesInsert_598818 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesFeaturesInsert_598820(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesFeaturesInsert_598819(path: JsonNode;
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
  var valid_598821 = path.getOrDefault("customer")
  valid_598821 = validateParameter(valid_598821, JString, required = true,
                                 default = nil)
  if valid_598821 != nil:
    section.add "customer", valid_598821
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
  var valid_598822 = query.getOrDefault("fields")
  valid_598822 = validateParameter(valid_598822, JString, required = false,
                                 default = nil)
  if valid_598822 != nil:
    section.add "fields", valid_598822
  var valid_598823 = query.getOrDefault("quotaUser")
  valid_598823 = validateParameter(valid_598823, JString, required = false,
                                 default = nil)
  if valid_598823 != nil:
    section.add "quotaUser", valid_598823
  var valid_598824 = query.getOrDefault("alt")
  valid_598824 = validateParameter(valid_598824, JString, required = false,
                                 default = newJString("json"))
  if valid_598824 != nil:
    section.add "alt", valid_598824
  var valid_598825 = query.getOrDefault("oauth_token")
  valid_598825 = validateParameter(valid_598825, JString, required = false,
                                 default = nil)
  if valid_598825 != nil:
    section.add "oauth_token", valid_598825
  var valid_598826 = query.getOrDefault("userIp")
  valid_598826 = validateParameter(valid_598826, JString, required = false,
                                 default = nil)
  if valid_598826 != nil:
    section.add "userIp", valid_598826
  var valid_598827 = query.getOrDefault("key")
  valid_598827 = validateParameter(valid_598827, JString, required = false,
                                 default = nil)
  if valid_598827 != nil:
    section.add "key", valid_598827
  var valid_598828 = query.getOrDefault("prettyPrint")
  valid_598828 = validateParameter(valid_598828, JBool, required = false,
                                 default = newJBool(true))
  if valid_598828 != nil:
    section.add "prettyPrint", valid_598828
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

proc call*(call_598830: Call_DirectoryResourcesFeaturesInsert_598818;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a feature.
  ## 
  let valid = call_598830.validator(path, query, header, formData, body)
  let scheme = call_598830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598830.url(scheme.get, call_598830.host, call_598830.base,
                         call_598830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598830, url, valid)

proc call*(call_598831: Call_DirectoryResourcesFeaturesInsert_598818;
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
  var path_598832 = newJObject()
  var query_598833 = newJObject()
  var body_598834 = newJObject()
  add(query_598833, "fields", newJString(fields))
  add(query_598833, "quotaUser", newJString(quotaUser))
  add(query_598833, "alt", newJString(alt))
  add(query_598833, "oauth_token", newJString(oauthToken))
  add(query_598833, "userIp", newJString(userIp))
  add(query_598833, "key", newJString(key))
  add(path_598832, "customer", newJString(customer))
  if body != nil:
    body_598834 = body
  add(query_598833, "prettyPrint", newJBool(prettyPrint))
  result = call_598831.call(path_598832, query_598833, nil, nil, body_598834)

var directoryResourcesFeaturesInsert* = Call_DirectoryResourcesFeaturesInsert_598818(
    name: "directoryResourcesFeaturesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/features",
    validator: validate_DirectoryResourcesFeaturesInsert_598819,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesInsert_598820,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesList_598801 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesFeaturesList_598803(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesFeaturesList_598802(path: JsonNode;
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
  var valid_598804 = path.getOrDefault("customer")
  valid_598804 = validateParameter(valid_598804, JString, required = true,
                                 default = nil)
  if valid_598804 != nil:
    section.add "customer", valid_598804
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
  var valid_598805 = query.getOrDefault("fields")
  valid_598805 = validateParameter(valid_598805, JString, required = false,
                                 default = nil)
  if valid_598805 != nil:
    section.add "fields", valid_598805
  var valid_598806 = query.getOrDefault("pageToken")
  valid_598806 = validateParameter(valid_598806, JString, required = false,
                                 default = nil)
  if valid_598806 != nil:
    section.add "pageToken", valid_598806
  var valid_598807 = query.getOrDefault("quotaUser")
  valid_598807 = validateParameter(valid_598807, JString, required = false,
                                 default = nil)
  if valid_598807 != nil:
    section.add "quotaUser", valid_598807
  var valid_598808 = query.getOrDefault("alt")
  valid_598808 = validateParameter(valid_598808, JString, required = false,
                                 default = newJString("json"))
  if valid_598808 != nil:
    section.add "alt", valid_598808
  var valid_598809 = query.getOrDefault("oauth_token")
  valid_598809 = validateParameter(valid_598809, JString, required = false,
                                 default = nil)
  if valid_598809 != nil:
    section.add "oauth_token", valid_598809
  var valid_598810 = query.getOrDefault("userIp")
  valid_598810 = validateParameter(valid_598810, JString, required = false,
                                 default = nil)
  if valid_598810 != nil:
    section.add "userIp", valid_598810
  var valid_598811 = query.getOrDefault("maxResults")
  valid_598811 = validateParameter(valid_598811, JInt, required = false, default = nil)
  if valid_598811 != nil:
    section.add "maxResults", valid_598811
  var valid_598812 = query.getOrDefault("key")
  valid_598812 = validateParameter(valid_598812, JString, required = false,
                                 default = nil)
  if valid_598812 != nil:
    section.add "key", valid_598812
  var valid_598813 = query.getOrDefault("prettyPrint")
  valid_598813 = validateParameter(valid_598813, JBool, required = false,
                                 default = newJBool(true))
  if valid_598813 != nil:
    section.add "prettyPrint", valid_598813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598814: Call_DirectoryResourcesFeaturesList_598801; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of features for an account.
  ## 
  let valid = call_598814.validator(path, query, header, formData, body)
  let scheme = call_598814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598814.url(scheme.get, call_598814.host, call_598814.base,
                         call_598814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598814, url, valid)

proc call*(call_598815: Call_DirectoryResourcesFeaturesList_598801;
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
  var path_598816 = newJObject()
  var query_598817 = newJObject()
  add(query_598817, "fields", newJString(fields))
  add(query_598817, "pageToken", newJString(pageToken))
  add(query_598817, "quotaUser", newJString(quotaUser))
  add(query_598817, "alt", newJString(alt))
  add(query_598817, "oauth_token", newJString(oauthToken))
  add(query_598817, "userIp", newJString(userIp))
  add(query_598817, "maxResults", newJInt(maxResults))
  add(query_598817, "key", newJString(key))
  add(path_598816, "customer", newJString(customer))
  add(query_598817, "prettyPrint", newJBool(prettyPrint))
  result = call_598815.call(path_598816, query_598817, nil, nil, nil)

var directoryResourcesFeaturesList* = Call_DirectoryResourcesFeaturesList_598801(
    name: "directoryResourcesFeaturesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/features",
    validator: validate_DirectoryResourcesFeaturesList_598802,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesList_598803,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesUpdate_598851 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesFeaturesUpdate_598853(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesFeaturesUpdate_598852(path: JsonNode;
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
  var valid_598854 = path.getOrDefault("featureKey")
  valid_598854 = validateParameter(valid_598854, JString, required = true,
                                 default = nil)
  if valid_598854 != nil:
    section.add "featureKey", valid_598854
  var valid_598855 = path.getOrDefault("customer")
  valid_598855 = validateParameter(valid_598855, JString, required = true,
                                 default = nil)
  if valid_598855 != nil:
    section.add "customer", valid_598855
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
  var valid_598856 = query.getOrDefault("fields")
  valid_598856 = validateParameter(valid_598856, JString, required = false,
                                 default = nil)
  if valid_598856 != nil:
    section.add "fields", valid_598856
  var valid_598857 = query.getOrDefault("quotaUser")
  valid_598857 = validateParameter(valid_598857, JString, required = false,
                                 default = nil)
  if valid_598857 != nil:
    section.add "quotaUser", valid_598857
  var valid_598858 = query.getOrDefault("alt")
  valid_598858 = validateParameter(valid_598858, JString, required = false,
                                 default = newJString("json"))
  if valid_598858 != nil:
    section.add "alt", valid_598858
  var valid_598859 = query.getOrDefault("oauth_token")
  valid_598859 = validateParameter(valid_598859, JString, required = false,
                                 default = nil)
  if valid_598859 != nil:
    section.add "oauth_token", valid_598859
  var valid_598860 = query.getOrDefault("userIp")
  valid_598860 = validateParameter(valid_598860, JString, required = false,
                                 default = nil)
  if valid_598860 != nil:
    section.add "userIp", valid_598860
  var valid_598861 = query.getOrDefault("key")
  valid_598861 = validateParameter(valid_598861, JString, required = false,
                                 default = nil)
  if valid_598861 != nil:
    section.add "key", valid_598861
  var valid_598862 = query.getOrDefault("prettyPrint")
  valid_598862 = validateParameter(valid_598862, JBool, required = false,
                                 default = newJBool(true))
  if valid_598862 != nil:
    section.add "prettyPrint", valid_598862
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

proc call*(call_598864: Call_DirectoryResourcesFeaturesUpdate_598851;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a feature.
  ## 
  let valid = call_598864.validator(path, query, header, formData, body)
  let scheme = call_598864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598864.url(scheme.get, call_598864.host, call_598864.base,
                         call_598864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598864, url, valid)

proc call*(call_598865: Call_DirectoryResourcesFeaturesUpdate_598851;
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
  var path_598866 = newJObject()
  var query_598867 = newJObject()
  var body_598868 = newJObject()
  add(query_598867, "fields", newJString(fields))
  add(query_598867, "quotaUser", newJString(quotaUser))
  add(query_598867, "alt", newJString(alt))
  add(path_598866, "featureKey", newJString(featureKey))
  add(query_598867, "oauth_token", newJString(oauthToken))
  add(query_598867, "userIp", newJString(userIp))
  add(query_598867, "key", newJString(key))
  add(path_598866, "customer", newJString(customer))
  if body != nil:
    body_598868 = body
  add(query_598867, "prettyPrint", newJBool(prettyPrint))
  result = call_598865.call(path_598866, query_598867, nil, nil, body_598868)

var directoryResourcesFeaturesUpdate* = Call_DirectoryResourcesFeaturesUpdate_598851(
    name: "directoryResourcesFeaturesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesUpdate_598852,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesUpdate_598853,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesGet_598835 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesFeaturesGet_598837(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesFeaturesGet_598836(path: JsonNode; query: JsonNode;
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
  var valid_598838 = path.getOrDefault("featureKey")
  valid_598838 = validateParameter(valid_598838, JString, required = true,
                                 default = nil)
  if valid_598838 != nil:
    section.add "featureKey", valid_598838
  var valid_598839 = path.getOrDefault("customer")
  valid_598839 = validateParameter(valid_598839, JString, required = true,
                                 default = nil)
  if valid_598839 != nil:
    section.add "customer", valid_598839
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
  var valid_598840 = query.getOrDefault("fields")
  valid_598840 = validateParameter(valid_598840, JString, required = false,
                                 default = nil)
  if valid_598840 != nil:
    section.add "fields", valid_598840
  var valid_598841 = query.getOrDefault("quotaUser")
  valid_598841 = validateParameter(valid_598841, JString, required = false,
                                 default = nil)
  if valid_598841 != nil:
    section.add "quotaUser", valid_598841
  var valid_598842 = query.getOrDefault("alt")
  valid_598842 = validateParameter(valid_598842, JString, required = false,
                                 default = newJString("json"))
  if valid_598842 != nil:
    section.add "alt", valid_598842
  var valid_598843 = query.getOrDefault("oauth_token")
  valid_598843 = validateParameter(valid_598843, JString, required = false,
                                 default = nil)
  if valid_598843 != nil:
    section.add "oauth_token", valid_598843
  var valid_598844 = query.getOrDefault("userIp")
  valid_598844 = validateParameter(valid_598844, JString, required = false,
                                 default = nil)
  if valid_598844 != nil:
    section.add "userIp", valid_598844
  var valid_598845 = query.getOrDefault("key")
  valid_598845 = validateParameter(valid_598845, JString, required = false,
                                 default = nil)
  if valid_598845 != nil:
    section.add "key", valid_598845
  var valid_598846 = query.getOrDefault("prettyPrint")
  valid_598846 = validateParameter(valid_598846, JBool, required = false,
                                 default = newJBool(true))
  if valid_598846 != nil:
    section.add "prettyPrint", valid_598846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598847: Call_DirectoryResourcesFeaturesGet_598835; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a feature.
  ## 
  let valid = call_598847.validator(path, query, header, formData, body)
  let scheme = call_598847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598847.url(scheme.get, call_598847.host, call_598847.base,
                         call_598847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598847, url, valid)

proc call*(call_598848: Call_DirectoryResourcesFeaturesGet_598835;
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
  var path_598849 = newJObject()
  var query_598850 = newJObject()
  add(query_598850, "fields", newJString(fields))
  add(query_598850, "quotaUser", newJString(quotaUser))
  add(query_598850, "alt", newJString(alt))
  add(path_598849, "featureKey", newJString(featureKey))
  add(query_598850, "oauth_token", newJString(oauthToken))
  add(query_598850, "userIp", newJString(userIp))
  add(query_598850, "key", newJString(key))
  add(path_598849, "customer", newJString(customer))
  add(query_598850, "prettyPrint", newJBool(prettyPrint))
  result = call_598848.call(path_598849, query_598850, nil, nil, nil)

var directoryResourcesFeaturesGet* = Call_DirectoryResourcesFeaturesGet_598835(
    name: "directoryResourcesFeaturesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesGet_598836,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesGet_598837,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesPatch_598885 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesFeaturesPatch_598887(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesFeaturesPatch_598886(path: JsonNode;
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
  var valid_598888 = path.getOrDefault("featureKey")
  valid_598888 = validateParameter(valid_598888, JString, required = true,
                                 default = nil)
  if valid_598888 != nil:
    section.add "featureKey", valid_598888
  var valid_598889 = path.getOrDefault("customer")
  valid_598889 = validateParameter(valid_598889, JString, required = true,
                                 default = nil)
  if valid_598889 != nil:
    section.add "customer", valid_598889
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
  var valid_598890 = query.getOrDefault("fields")
  valid_598890 = validateParameter(valid_598890, JString, required = false,
                                 default = nil)
  if valid_598890 != nil:
    section.add "fields", valid_598890
  var valid_598891 = query.getOrDefault("quotaUser")
  valid_598891 = validateParameter(valid_598891, JString, required = false,
                                 default = nil)
  if valid_598891 != nil:
    section.add "quotaUser", valid_598891
  var valid_598892 = query.getOrDefault("alt")
  valid_598892 = validateParameter(valid_598892, JString, required = false,
                                 default = newJString("json"))
  if valid_598892 != nil:
    section.add "alt", valid_598892
  var valid_598893 = query.getOrDefault("oauth_token")
  valid_598893 = validateParameter(valid_598893, JString, required = false,
                                 default = nil)
  if valid_598893 != nil:
    section.add "oauth_token", valid_598893
  var valid_598894 = query.getOrDefault("userIp")
  valid_598894 = validateParameter(valid_598894, JString, required = false,
                                 default = nil)
  if valid_598894 != nil:
    section.add "userIp", valid_598894
  var valid_598895 = query.getOrDefault("key")
  valid_598895 = validateParameter(valid_598895, JString, required = false,
                                 default = nil)
  if valid_598895 != nil:
    section.add "key", valid_598895
  var valid_598896 = query.getOrDefault("prettyPrint")
  valid_598896 = validateParameter(valid_598896, JBool, required = false,
                                 default = newJBool(true))
  if valid_598896 != nil:
    section.add "prettyPrint", valid_598896
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

proc call*(call_598898: Call_DirectoryResourcesFeaturesPatch_598885;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a feature. This method supports patch semantics.
  ## 
  let valid = call_598898.validator(path, query, header, formData, body)
  let scheme = call_598898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598898.url(scheme.get, call_598898.host, call_598898.base,
                         call_598898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598898, url, valid)

proc call*(call_598899: Call_DirectoryResourcesFeaturesPatch_598885;
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
  var path_598900 = newJObject()
  var query_598901 = newJObject()
  var body_598902 = newJObject()
  add(query_598901, "fields", newJString(fields))
  add(query_598901, "quotaUser", newJString(quotaUser))
  add(query_598901, "alt", newJString(alt))
  add(path_598900, "featureKey", newJString(featureKey))
  add(query_598901, "oauth_token", newJString(oauthToken))
  add(query_598901, "userIp", newJString(userIp))
  add(query_598901, "key", newJString(key))
  add(path_598900, "customer", newJString(customer))
  if body != nil:
    body_598902 = body
  add(query_598901, "prettyPrint", newJBool(prettyPrint))
  result = call_598899.call(path_598900, query_598901, nil, nil, body_598902)

var directoryResourcesFeaturesPatch* = Call_DirectoryResourcesFeaturesPatch_598885(
    name: "directoryResourcesFeaturesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesPatch_598886,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesPatch_598887,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesDelete_598869 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesFeaturesDelete_598871(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesFeaturesDelete_598870(path: JsonNode;
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
  var valid_598872 = path.getOrDefault("featureKey")
  valid_598872 = validateParameter(valid_598872, JString, required = true,
                                 default = nil)
  if valid_598872 != nil:
    section.add "featureKey", valid_598872
  var valid_598873 = path.getOrDefault("customer")
  valid_598873 = validateParameter(valid_598873, JString, required = true,
                                 default = nil)
  if valid_598873 != nil:
    section.add "customer", valid_598873
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
  var valid_598874 = query.getOrDefault("fields")
  valid_598874 = validateParameter(valid_598874, JString, required = false,
                                 default = nil)
  if valid_598874 != nil:
    section.add "fields", valid_598874
  var valid_598875 = query.getOrDefault("quotaUser")
  valid_598875 = validateParameter(valid_598875, JString, required = false,
                                 default = nil)
  if valid_598875 != nil:
    section.add "quotaUser", valid_598875
  var valid_598876 = query.getOrDefault("alt")
  valid_598876 = validateParameter(valid_598876, JString, required = false,
                                 default = newJString("json"))
  if valid_598876 != nil:
    section.add "alt", valid_598876
  var valid_598877 = query.getOrDefault("oauth_token")
  valid_598877 = validateParameter(valid_598877, JString, required = false,
                                 default = nil)
  if valid_598877 != nil:
    section.add "oauth_token", valid_598877
  var valid_598878 = query.getOrDefault("userIp")
  valid_598878 = validateParameter(valid_598878, JString, required = false,
                                 default = nil)
  if valid_598878 != nil:
    section.add "userIp", valid_598878
  var valid_598879 = query.getOrDefault("key")
  valid_598879 = validateParameter(valid_598879, JString, required = false,
                                 default = nil)
  if valid_598879 != nil:
    section.add "key", valid_598879
  var valid_598880 = query.getOrDefault("prettyPrint")
  valid_598880 = validateParameter(valid_598880, JBool, required = false,
                                 default = newJBool(true))
  if valid_598880 != nil:
    section.add "prettyPrint", valid_598880
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598881: Call_DirectoryResourcesFeaturesDelete_598869;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a feature.
  ## 
  let valid = call_598881.validator(path, query, header, formData, body)
  let scheme = call_598881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598881.url(scheme.get, call_598881.host, call_598881.base,
                         call_598881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598881, url, valid)

proc call*(call_598882: Call_DirectoryResourcesFeaturesDelete_598869;
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
  var path_598883 = newJObject()
  var query_598884 = newJObject()
  add(query_598884, "fields", newJString(fields))
  add(query_598884, "quotaUser", newJString(quotaUser))
  add(query_598884, "alt", newJString(alt))
  add(path_598883, "featureKey", newJString(featureKey))
  add(query_598884, "oauth_token", newJString(oauthToken))
  add(query_598884, "userIp", newJString(userIp))
  add(query_598884, "key", newJString(key))
  add(path_598883, "customer", newJString(customer))
  add(query_598884, "prettyPrint", newJBool(prettyPrint))
  result = call_598882.call(path_598883, query_598884, nil, nil, nil)

var directoryResourcesFeaturesDelete* = Call_DirectoryResourcesFeaturesDelete_598869(
    name: "directoryResourcesFeaturesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesDelete_598870,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesDelete_598871,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesRename_598903 = ref object of OpenApiRestCall_597437
proc url_DirectoryResourcesFeaturesRename_598905(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryResourcesFeaturesRename_598904(path: JsonNode;
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
  var valid_598906 = path.getOrDefault("oldName")
  valid_598906 = validateParameter(valid_598906, JString, required = true,
                                 default = nil)
  if valid_598906 != nil:
    section.add "oldName", valid_598906
  var valid_598907 = path.getOrDefault("customer")
  valid_598907 = validateParameter(valid_598907, JString, required = true,
                                 default = nil)
  if valid_598907 != nil:
    section.add "customer", valid_598907
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
  var valid_598908 = query.getOrDefault("fields")
  valid_598908 = validateParameter(valid_598908, JString, required = false,
                                 default = nil)
  if valid_598908 != nil:
    section.add "fields", valid_598908
  var valid_598909 = query.getOrDefault("quotaUser")
  valid_598909 = validateParameter(valid_598909, JString, required = false,
                                 default = nil)
  if valid_598909 != nil:
    section.add "quotaUser", valid_598909
  var valid_598910 = query.getOrDefault("alt")
  valid_598910 = validateParameter(valid_598910, JString, required = false,
                                 default = newJString("json"))
  if valid_598910 != nil:
    section.add "alt", valid_598910
  var valid_598911 = query.getOrDefault("oauth_token")
  valid_598911 = validateParameter(valid_598911, JString, required = false,
                                 default = nil)
  if valid_598911 != nil:
    section.add "oauth_token", valid_598911
  var valid_598912 = query.getOrDefault("userIp")
  valid_598912 = validateParameter(valid_598912, JString, required = false,
                                 default = nil)
  if valid_598912 != nil:
    section.add "userIp", valid_598912
  var valid_598913 = query.getOrDefault("key")
  valid_598913 = validateParameter(valid_598913, JString, required = false,
                                 default = nil)
  if valid_598913 != nil:
    section.add "key", valid_598913
  var valid_598914 = query.getOrDefault("prettyPrint")
  valid_598914 = validateParameter(valid_598914, JBool, required = false,
                                 default = newJBool(true))
  if valid_598914 != nil:
    section.add "prettyPrint", valid_598914
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

proc call*(call_598916: Call_DirectoryResourcesFeaturesRename_598903;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renames a feature.
  ## 
  let valid = call_598916.validator(path, query, header, formData, body)
  let scheme = call_598916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598916.url(scheme.get, call_598916.host, call_598916.base,
                         call_598916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598916, url, valid)

proc call*(call_598917: Call_DirectoryResourcesFeaturesRename_598903;
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
  var path_598918 = newJObject()
  var query_598919 = newJObject()
  var body_598920 = newJObject()
  add(query_598919, "fields", newJString(fields))
  add(query_598919, "quotaUser", newJString(quotaUser))
  add(query_598919, "alt", newJString(alt))
  add(query_598919, "oauth_token", newJString(oauthToken))
  add(query_598919, "userIp", newJString(userIp))
  add(query_598919, "key", newJString(key))
  add(path_598918, "oldName", newJString(oldName))
  add(path_598918, "customer", newJString(customer))
  if body != nil:
    body_598920 = body
  add(query_598919, "prettyPrint", newJBool(prettyPrint))
  result = call_598917.call(path_598918, query_598919, nil, nil, body_598920)

var directoryResourcesFeaturesRename* = Call_DirectoryResourcesFeaturesRename_598903(
    name: "directoryResourcesFeaturesRename", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{oldName}/rename",
    validator: validate_DirectoryResourcesFeaturesRename_598904,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesRename_598905,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsInsert_598940 = ref object of OpenApiRestCall_597437
proc url_DirectoryRoleAssignmentsInsert_598942(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryRoleAssignmentsInsert_598941(path: JsonNode;
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
  var valid_598943 = path.getOrDefault("customer")
  valid_598943 = validateParameter(valid_598943, JString, required = true,
                                 default = nil)
  if valid_598943 != nil:
    section.add "customer", valid_598943
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
  var valid_598944 = query.getOrDefault("fields")
  valid_598944 = validateParameter(valid_598944, JString, required = false,
                                 default = nil)
  if valid_598944 != nil:
    section.add "fields", valid_598944
  var valid_598945 = query.getOrDefault("quotaUser")
  valid_598945 = validateParameter(valid_598945, JString, required = false,
                                 default = nil)
  if valid_598945 != nil:
    section.add "quotaUser", valid_598945
  var valid_598946 = query.getOrDefault("alt")
  valid_598946 = validateParameter(valid_598946, JString, required = false,
                                 default = newJString("json"))
  if valid_598946 != nil:
    section.add "alt", valid_598946
  var valid_598947 = query.getOrDefault("oauth_token")
  valid_598947 = validateParameter(valid_598947, JString, required = false,
                                 default = nil)
  if valid_598947 != nil:
    section.add "oauth_token", valid_598947
  var valid_598948 = query.getOrDefault("userIp")
  valid_598948 = validateParameter(valid_598948, JString, required = false,
                                 default = nil)
  if valid_598948 != nil:
    section.add "userIp", valid_598948
  var valid_598949 = query.getOrDefault("key")
  valid_598949 = validateParameter(valid_598949, JString, required = false,
                                 default = nil)
  if valid_598949 != nil:
    section.add "key", valid_598949
  var valid_598950 = query.getOrDefault("prettyPrint")
  valid_598950 = validateParameter(valid_598950, JBool, required = false,
                                 default = newJBool(true))
  if valid_598950 != nil:
    section.add "prettyPrint", valid_598950
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

proc call*(call_598952: Call_DirectoryRoleAssignmentsInsert_598940; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role assignment.
  ## 
  let valid = call_598952.validator(path, query, header, formData, body)
  let scheme = call_598952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598952.url(scheme.get, call_598952.host, call_598952.base,
                         call_598952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598952, url, valid)

proc call*(call_598953: Call_DirectoryRoleAssignmentsInsert_598940;
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
  var path_598954 = newJObject()
  var query_598955 = newJObject()
  var body_598956 = newJObject()
  add(query_598955, "fields", newJString(fields))
  add(query_598955, "quotaUser", newJString(quotaUser))
  add(query_598955, "alt", newJString(alt))
  add(query_598955, "oauth_token", newJString(oauthToken))
  add(query_598955, "userIp", newJString(userIp))
  add(query_598955, "key", newJString(key))
  add(path_598954, "customer", newJString(customer))
  if body != nil:
    body_598956 = body
  add(query_598955, "prettyPrint", newJBool(prettyPrint))
  result = call_598953.call(path_598954, query_598955, nil, nil, body_598956)

var directoryRoleAssignmentsInsert* = Call_DirectoryRoleAssignmentsInsert_598940(
    name: "directoryRoleAssignmentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/roleassignments",
    validator: validate_DirectoryRoleAssignmentsInsert_598941,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsInsert_598942,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsList_598921 = ref object of OpenApiRestCall_597437
proc url_DirectoryRoleAssignmentsList_598923(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryRoleAssignmentsList_598922(path: JsonNode; query: JsonNode;
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
  var valid_598924 = path.getOrDefault("customer")
  valid_598924 = validateParameter(valid_598924, JString, required = true,
                                 default = nil)
  if valid_598924 != nil:
    section.add "customer", valid_598924
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
  var valid_598925 = query.getOrDefault("fields")
  valid_598925 = validateParameter(valid_598925, JString, required = false,
                                 default = nil)
  if valid_598925 != nil:
    section.add "fields", valid_598925
  var valid_598926 = query.getOrDefault("pageToken")
  valid_598926 = validateParameter(valid_598926, JString, required = false,
                                 default = nil)
  if valid_598926 != nil:
    section.add "pageToken", valid_598926
  var valid_598927 = query.getOrDefault("quotaUser")
  valid_598927 = validateParameter(valid_598927, JString, required = false,
                                 default = nil)
  if valid_598927 != nil:
    section.add "quotaUser", valid_598927
  var valid_598928 = query.getOrDefault("alt")
  valid_598928 = validateParameter(valid_598928, JString, required = false,
                                 default = newJString("json"))
  if valid_598928 != nil:
    section.add "alt", valid_598928
  var valid_598929 = query.getOrDefault("oauth_token")
  valid_598929 = validateParameter(valid_598929, JString, required = false,
                                 default = nil)
  if valid_598929 != nil:
    section.add "oauth_token", valid_598929
  var valid_598930 = query.getOrDefault("userIp")
  valid_598930 = validateParameter(valid_598930, JString, required = false,
                                 default = nil)
  if valid_598930 != nil:
    section.add "userIp", valid_598930
  var valid_598931 = query.getOrDefault("maxResults")
  valid_598931 = validateParameter(valid_598931, JInt, required = false, default = nil)
  if valid_598931 != nil:
    section.add "maxResults", valid_598931
  var valid_598932 = query.getOrDefault("key")
  valid_598932 = validateParameter(valid_598932, JString, required = false,
                                 default = nil)
  if valid_598932 != nil:
    section.add "key", valid_598932
  var valid_598933 = query.getOrDefault("roleId")
  valid_598933 = validateParameter(valid_598933, JString, required = false,
                                 default = nil)
  if valid_598933 != nil:
    section.add "roleId", valid_598933
  var valid_598934 = query.getOrDefault("prettyPrint")
  valid_598934 = validateParameter(valid_598934, JBool, required = false,
                                 default = newJBool(true))
  if valid_598934 != nil:
    section.add "prettyPrint", valid_598934
  var valid_598935 = query.getOrDefault("userKey")
  valid_598935 = validateParameter(valid_598935, JString, required = false,
                                 default = nil)
  if valid_598935 != nil:
    section.add "userKey", valid_598935
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598936: Call_DirectoryRoleAssignmentsList_598921; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all roleAssignments.
  ## 
  let valid = call_598936.validator(path, query, header, formData, body)
  let scheme = call_598936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598936.url(scheme.get, call_598936.host, call_598936.base,
                         call_598936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598936, url, valid)

proc call*(call_598937: Call_DirectoryRoleAssignmentsList_598921; customer: string;
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
  var path_598938 = newJObject()
  var query_598939 = newJObject()
  add(query_598939, "fields", newJString(fields))
  add(query_598939, "pageToken", newJString(pageToken))
  add(query_598939, "quotaUser", newJString(quotaUser))
  add(query_598939, "alt", newJString(alt))
  add(query_598939, "oauth_token", newJString(oauthToken))
  add(query_598939, "userIp", newJString(userIp))
  add(query_598939, "maxResults", newJInt(maxResults))
  add(query_598939, "key", newJString(key))
  add(query_598939, "roleId", newJString(roleId))
  add(path_598938, "customer", newJString(customer))
  add(query_598939, "prettyPrint", newJBool(prettyPrint))
  add(query_598939, "userKey", newJString(userKey))
  result = call_598937.call(path_598938, query_598939, nil, nil, nil)

var directoryRoleAssignmentsList* = Call_DirectoryRoleAssignmentsList_598921(
    name: "directoryRoleAssignmentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/roleassignments",
    validator: validate_DirectoryRoleAssignmentsList_598922,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsList_598923,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsGet_598957 = ref object of OpenApiRestCall_597437
proc url_DirectoryRoleAssignmentsGet_598959(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryRoleAssignmentsGet_598958(path: JsonNode; query: JsonNode;
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
  var valid_598960 = path.getOrDefault("customer")
  valid_598960 = validateParameter(valid_598960, JString, required = true,
                                 default = nil)
  if valid_598960 != nil:
    section.add "customer", valid_598960
  var valid_598961 = path.getOrDefault("roleAssignmentId")
  valid_598961 = validateParameter(valid_598961, JString, required = true,
                                 default = nil)
  if valid_598961 != nil:
    section.add "roleAssignmentId", valid_598961
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
  var valid_598962 = query.getOrDefault("fields")
  valid_598962 = validateParameter(valid_598962, JString, required = false,
                                 default = nil)
  if valid_598962 != nil:
    section.add "fields", valid_598962
  var valid_598963 = query.getOrDefault("quotaUser")
  valid_598963 = validateParameter(valid_598963, JString, required = false,
                                 default = nil)
  if valid_598963 != nil:
    section.add "quotaUser", valid_598963
  var valid_598964 = query.getOrDefault("alt")
  valid_598964 = validateParameter(valid_598964, JString, required = false,
                                 default = newJString("json"))
  if valid_598964 != nil:
    section.add "alt", valid_598964
  var valid_598965 = query.getOrDefault("oauth_token")
  valid_598965 = validateParameter(valid_598965, JString, required = false,
                                 default = nil)
  if valid_598965 != nil:
    section.add "oauth_token", valid_598965
  var valid_598966 = query.getOrDefault("userIp")
  valid_598966 = validateParameter(valid_598966, JString, required = false,
                                 default = nil)
  if valid_598966 != nil:
    section.add "userIp", valid_598966
  var valid_598967 = query.getOrDefault("key")
  valid_598967 = validateParameter(valid_598967, JString, required = false,
                                 default = nil)
  if valid_598967 != nil:
    section.add "key", valid_598967
  var valid_598968 = query.getOrDefault("prettyPrint")
  valid_598968 = validateParameter(valid_598968, JBool, required = false,
                                 default = newJBool(true))
  if valid_598968 != nil:
    section.add "prettyPrint", valid_598968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598969: Call_DirectoryRoleAssignmentsGet_598957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a role assignment.
  ## 
  let valid = call_598969.validator(path, query, header, formData, body)
  let scheme = call_598969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598969.url(scheme.get, call_598969.host, call_598969.base,
                         call_598969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598969, url, valid)

proc call*(call_598970: Call_DirectoryRoleAssignmentsGet_598957; customer: string;
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
  var path_598971 = newJObject()
  var query_598972 = newJObject()
  add(query_598972, "fields", newJString(fields))
  add(query_598972, "quotaUser", newJString(quotaUser))
  add(query_598972, "alt", newJString(alt))
  add(query_598972, "oauth_token", newJString(oauthToken))
  add(query_598972, "userIp", newJString(userIp))
  add(query_598972, "key", newJString(key))
  add(path_598971, "customer", newJString(customer))
  add(path_598971, "roleAssignmentId", newJString(roleAssignmentId))
  add(query_598972, "prettyPrint", newJBool(prettyPrint))
  result = call_598970.call(path_598971, query_598972, nil, nil, nil)

var directoryRoleAssignmentsGet* = Call_DirectoryRoleAssignmentsGet_598957(
    name: "directoryRoleAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roleassignments/{roleAssignmentId}",
    validator: validate_DirectoryRoleAssignmentsGet_598958,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsGet_598959,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsDelete_598973 = ref object of OpenApiRestCall_597437
proc url_DirectoryRoleAssignmentsDelete_598975(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryRoleAssignmentsDelete_598974(path: JsonNode;
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
  var valid_598976 = path.getOrDefault("customer")
  valid_598976 = validateParameter(valid_598976, JString, required = true,
                                 default = nil)
  if valid_598976 != nil:
    section.add "customer", valid_598976
  var valid_598977 = path.getOrDefault("roleAssignmentId")
  valid_598977 = validateParameter(valid_598977, JString, required = true,
                                 default = nil)
  if valid_598977 != nil:
    section.add "roleAssignmentId", valid_598977
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
  var valid_598978 = query.getOrDefault("fields")
  valid_598978 = validateParameter(valid_598978, JString, required = false,
                                 default = nil)
  if valid_598978 != nil:
    section.add "fields", valid_598978
  var valid_598979 = query.getOrDefault("quotaUser")
  valid_598979 = validateParameter(valid_598979, JString, required = false,
                                 default = nil)
  if valid_598979 != nil:
    section.add "quotaUser", valid_598979
  var valid_598980 = query.getOrDefault("alt")
  valid_598980 = validateParameter(valid_598980, JString, required = false,
                                 default = newJString("json"))
  if valid_598980 != nil:
    section.add "alt", valid_598980
  var valid_598981 = query.getOrDefault("oauth_token")
  valid_598981 = validateParameter(valid_598981, JString, required = false,
                                 default = nil)
  if valid_598981 != nil:
    section.add "oauth_token", valid_598981
  var valid_598982 = query.getOrDefault("userIp")
  valid_598982 = validateParameter(valid_598982, JString, required = false,
                                 default = nil)
  if valid_598982 != nil:
    section.add "userIp", valid_598982
  var valid_598983 = query.getOrDefault("key")
  valid_598983 = validateParameter(valid_598983, JString, required = false,
                                 default = nil)
  if valid_598983 != nil:
    section.add "key", valid_598983
  var valid_598984 = query.getOrDefault("prettyPrint")
  valid_598984 = validateParameter(valid_598984, JBool, required = false,
                                 default = newJBool(true))
  if valid_598984 != nil:
    section.add "prettyPrint", valid_598984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598985: Call_DirectoryRoleAssignmentsDelete_598973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role assignment.
  ## 
  let valid = call_598985.validator(path, query, header, formData, body)
  let scheme = call_598985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598985.url(scheme.get, call_598985.host, call_598985.base,
                         call_598985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598985, url, valid)

proc call*(call_598986: Call_DirectoryRoleAssignmentsDelete_598973;
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
  var path_598987 = newJObject()
  var query_598988 = newJObject()
  add(query_598988, "fields", newJString(fields))
  add(query_598988, "quotaUser", newJString(quotaUser))
  add(query_598988, "alt", newJString(alt))
  add(query_598988, "oauth_token", newJString(oauthToken))
  add(query_598988, "userIp", newJString(userIp))
  add(query_598988, "key", newJString(key))
  add(path_598987, "customer", newJString(customer))
  add(path_598987, "roleAssignmentId", newJString(roleAssignmentId))
  add(query_598988, "prettyPrint", newJBool(prettyPrint))
  result = call_598986.call(path_598987, query_598988, nil, nil, nil)

var directoryRoleAssignmentsDelete* = Call_DirectoryRoleAssignmentsDelete_598973(
    name: "directoryRoleAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roleassignments/{roleAssignmentId}",
    validator: validate_DirectoryRoleAssignmentsDelete_598974,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsDelete_598975,
    schemes: {Scheme.Https})
type
  Call_DirectoryRolesInsert_599006 = ref object of OpenApiRestCall_597437
proc url_DirectoryRolesInsert_599008(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryRolesInsert_599007(path: JsonNode; query: JsonNode;
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
  var valid_599009 = path.getOrDefault("customer")
  valid_599009 = validateParameter(valid_599009, JString, required = true,
                                 default = nil)
  if valid_599009 != nil:
    section.add "customer", valid_599009
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
  var valid_599010 = query.getOrDefault("fields")
  valid_599010 = validateParameter(valid_599010, JString, required = false,
                                 default = nil)
  if valid_599010 != nil:
    section.add "fields", valid_599010
  var valid_599011 = query.getOrDefault("quotaUser")
  valid_599011 = validateParameter(valid_599011, JString, required = false,
                                 default = nil)
  if valid_599011 != nil:
    section.add "quotaUser", valid_599011
  var valid_599012 = query.getOrDefault("alt")
  valid_599012 = validateParameter(valid_599012, JString, required = false,
                                 default = newJString("json"))
  if valid_599012 != nil:
    section.add "alt", valid_599012
  var valid_599013 = query.getOrDefault("oauth_token")
  valid_599013 = validateParameter(valid_599013, JString, required = false,
                                 default = nil)
  if valid_599013 != nil:
    section.add "oauth_token", valid_599013
  var valid_599014 = query.getOrDefault("userIp")
  valid_599014 = validateParameter(valid_599014, JString, required = false,
                                 default = nil)
  if valid_599014 != nil:
    section.add "userIp", valid_599014
  var valid_599015 = query.getOrDefault("key")
  valid_599015 = validateParameter(valid_599015, JString, required = false,
                                 default = nil)
  if valid_599015 != nil:
    section.add "key", valid_599015
  var valid_599016 = query.getOrDefault("prettyPrint")
  valid_599016 = validateParameter(valid_599016, JBool, required = false,
                                 default = newJBool(true))
  if valid_599016 != nil:
    section.add "prettyPrint", valid_599016
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

proc call*(call_599018: Call_DirectoryRolesInsert_599006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role.
  ## 
  let valid = call_599018.validator(path, query, header, formData, body)
  let scheme = call_599018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599018.url(scheme.get, call_599018.host, call_599018.base,
                         call_599018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599018, url, valid)

proc call*(call_599019: Call_DirectoryRolesInsert_599006; customer: string;
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
  var path_599020 = newJObject()
  var query_599021 = newJObject()
  var body_599022 = newJObject()
  add(query_599021, "fields", newJString(fields))
  add(query_599021, "quotaUser", newJString(quotaUser))
  add(query_599021, "alt", newJString(alt))
  add(query_599021, "oauth_token", newJString(oauthToken))
  add(query_599021, "userIp", newJString(userIp))
  add(query_599021, "key", newJString(key))
  add(path_599020, "customer", newJString(customer))
  if body != nil:
    body_599022 = body
  add(query_599021, "prettyPrint", newJBool(prettyPrint))
  result = call_599019.call(path_599020, query_599021, nil, nil, body_599022)

var directoryRolesInsert* = Call_DirectoryRolesInsert_599006(
    name: "directoryRolesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/roles",
    validator: validate_DirectoryRolesInsert_599007, base: "/admin/directory/v1",
    url: url_DirectoryRolesInsert_599008, schemes: {Scheme.Https})
type
  Call_DirectoryRolesList_598989 = ref object of OpenApiRestCall_597437
proc url_DirectoryRolesList_598991(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryRolesList_598990(path: JsonNode; query: JsonNode;
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
  var valid_598992 = path.getOrDefault("customer")
  valid_598992 = validateParameter(valid_598992, JString, required = true,
                                 default = nil)
  if valid_598992 != nil:
    section.add "customer", valid_598992
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
  var valid_598993 = query.getOrDefault("fields")
  valid_598993 = validateParameter(valid_598993, JString, required = false,
                                 default = nil)
  if valid_598993 != nil:
    section.add "fields", valid_598993
  var valid_598994 = query.getOrDefault("pageToken")
  valid_598994 = validateParameter(valid_598994, JString, required = false,
                                 default = nil)
  if valid_598994 != nil:
    section.add "pageToken", valid_598994
  var valid_598995 = query.getOrDefault("quotaUser")
  valid_598995 = validateParameter(valid_598995, JString, required = false,
                                 default = nil)
  if valid_598995 != nil:
    section.add "quotaUser", valid_598995
  var valid_598996 = query.getOrDefault("alt")
  valid_598996 = validateParameter(valid_598996, JString, required = false,
                                 default = newJString("json"))
  if valid_598996 != nil:
    section.add "alt", valid_598996
  var valid_598997 = query.getOrDefault("oauth_token")
  valid_598997 = validateParameter(valid_598997, JString, required = false,
                                 default = nil)
  if valid_598997 != nil:
    section.add "oauth_token", valid_598997
  var valid_598998 = query.getOrDefault("userIp")
  valid_598998 = validateParameter(valid_598998, JString, required = false,
                                 default = nil)
  if valid_598998 != nil:
    section.add "userIp", valid_598998
  var valid_598999 = query.getOrDefault("maxResults")
  valid_598999 = validateParameter(valid_598999, JInt, required = false, default = nil)
  if valid_598999 != nil:
    section.add "maxResults", valid_598999
  var valid_599000 = query.getOrDefault("key")
  valid_599000 = validateParameter(valid_599000, JString, required = false,
                                 default = nil)
  if valid_599000 != nil:
    section.add "key", valid_599000
  var valid_599001 = query.getOrDefault("prettyPrint")
  valid_599001 = validateParameter(valid_599001, JBool, required = false,
                                 default = newJBool(true))
  if valid_599001 != nil:
    section.add "prettyPrint", valid_599001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599002: Call_DirectoryRolesList_598989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all the roles in a domain.
  ## 
  let valid = call_599002.validator(path, query, header, formData, body)
  let scheme = call_599002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599002.url(scheme.get, call_599002.host, call_599002.base,
                         call_599002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599002, url, valid)

proc call*(call_599003: Call_DirectoryRolesList_598989; customer: string;
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
  var path_599004 = newJObject()
  var query_599005 = newJObject()
  add(query_599005, "fields", newJString(fields))
  add(query_599005, "pageToken", newJString(pageToken))
  add(query_599005, "quotaUser", newJString(quotaUser))
  add(query_599005, "alt", newJString(alt))
  add(query_599005, "oauth_token", newJString(oauthToken))
  add(query_599005, "userIp", newJString(userIp))
  add(query_599005, "maxResults", newJInt(maxResults))
  add(query_599005, "key", newJString(key))
  add(path_599004, "customer", newJString(customer))
  add(query_599005, "prettyPrint", newJBool(prettyPrint))
  result = call_599003.call(path_599004, query_599005, nil, nil, nil)

var directoryRolesList* = Call_DirectoryRolesList_598989(
    name: "directoryRolesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/roles",
    validator: validate_DirectoryRolesList_598990, base: "/admin/directory/v1",
    url: url_DirectoryRolesList_598991, schemes: {Scheme.Https})
type
  Call_DirectoryPrivilegesList_599023 = ref object of OpenApiRestCall_597437
proc url_DirectoryPrivilegesList_599025(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryPrivilegesList_599024(path: JsonNode; query: JsonNode;
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
  var valid_599026 = path.getOrDefault("customer")
  valid_599026 = validateParameter(valid_599026, JString, required = true,
                                 default = nil)
  if valid_599026 != nil:
    section.add "customer", valid_599026
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
  var valid_599027 = query.getOrDefault("fields")
  valid_599027 = validateParameter(valid_599027, JString, required = false,
                                 default = nil)
  if valid_599027 != nil:
    section.add "fields", valid_599027
  var valid_599028 = query.getOrDefault("quotaUser")
  valid_599028 = validateParameter(valid_599028, JString, required = false,
                                 default = nil)
  if valid_599028 != nil:
    section.add "quotaUser", valid_599028
  var valid_599029 = query.getOrDefault("alt")
  valid_599029 = validateParameter(valid_599029, JString, required = false,
                                 default = newJString("json"))
  if valid_599029 != nil:
    section.add "alt", valid_599029
  var valid_599030 = query.getOrDefault("oauth_token")
  valid_599030 = validateParameter(valid_599030, JString, required = false,
                                 default = nil)
  if valid_599030 != nil:
    section.add "oauth_token", valid_599030
  var valid_599031 = query.getOrDefault("userIp")
  valid_599031 = validateParameter(valid_599031, JString, required = false,
                                 default = nil)
  if valid_599031 != nil:
    section.add "userIp", valid_599031
  var valid_599032 = query.getOrDefault("key")
  valid_599032 = validateParameter(valid_599032, JString, required = false,
                                 default = nil)
  if valid_599032 != nil:
    section.add "key", valid_599032
  var valid_599033 = query.getOrDefault("prettyPrint")
  valid_599033 = validateParameter(valid_599033, JBool, required = false,
                                 default = newJBool(true))
  if valid_599033 != nil:
    section.add "prettyPrint", valid_599033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599034: Call_DirectoryPrivilegesList_599023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all privileges for a customer.
  ## 
  let valid = call_599034.validator(path, query, header, formData, body)
  let scheme = call_599034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599034.url(scheme.get, call_599034.host, call_599034.base,
                         call_599034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599034, url, valid)

proc call*(call_599035: Call_DirectoryPrivilegesList_599023; customer: string;
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
  var path_599036 = newJObject()
  var query_599037 = newJObject()
  add(query_599037, "fields", newJString(fields))
  add(query_599037, "quotaUser", newJString(quotaUser))
  add(query_599037, "alt", newJString(alt))
  add(query_599037, "oauth_token", newJString(oauthToken))
  add(query_599037, "userIp", newJString(userIp))
  add(query_599037, "key", newJString(key))
  add(path_599036, "customer", newJString(customer))
  add(query_599037, "prettyPrint", newJBool(prettyPrint))
  result = call_599035.call(path_599036, query_599037, nil, nil, nil)

var directoryPrivilegesList* = Call_DirectoryPrivilegesList_599023(
    name: "directoryPrivilegesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roles/ALL/privileges",
    validator: validate_DirectoryPrivilegesList_599024,
    base: "/admin/directory/v1", url: url_DirectoryPrivilegesList_599025,
    schemes: {Scheme.Https})
type
  Call_DirectoryRolesUpdate_599054 = ref object of OpenApiRestCall_597437
proc url_DirectoryRolesUpdate_599056(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryRolesUpdate_599055(path: JsonNode; query: JsonNode;
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
  var valid_599057 = path.getOrDefault("roleId")
  valid_599057 = validateParameter(valid_599057, JString, required = true,
                                 default = nil)
  if valid_599057 != nil:
    section.add "roleId", valid_599057
  var valid_599058 = path.getOrDefault("customer")
  valid_599058 = validateParameter(valid_599058, JString, required = true,
                                 default = nil)
  if valid_599058 != nil:
    section.add "customer", valid_599058
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
  var valid_599059 = query.getOrDefault("fields")
  valid_599059 = validateParameter(valid_599059, JString, required = false,
                                 default = nil)
  if valid_599059 != nil:
    section.add "fields", valid_599059
  var valid_599060 = query.getOrDefault("quotaUser")
  valid_599060 = validateParameter(valid_599060, JString, required = false,
                                 default = nil)
  if valid_599060 != nil:
    section.add "quotaUser", valid_599060
  var valid_599061 = query.getOrDefault("alt")
  valid_599061 = validateParameter(valid_599061, JString, required = false,
                                 default = newJString("json"))
  if valid_599061 != nil:
    section.add "alt", valid_599061
  var valid_599062 = query.getOrDefault("oauth_token")
  valid_599062 = validateParameter(valid_599062, JString, required = false,
                                 default = nil)
  if valid_599062 != nil:
    section.add "oauth_token", valid_599062
  var valid_599063 = query.getOrDefault("userIp")
  valid_599063 = validateParameter(valid_599063, JString, required = false,
                                 default = nil)
  if valid_599063 != nil:
    section.add "userIp", valid_599063
  var valid_599064 = query.getOrDefault("key")
  valid_599064 = validateParameter(valid_599064, JString, required = false,
                                 default = nil)
  if valid_599064 != nil:
    section.add "key", valid_599064
  var valid_599065 = query.getOrDefault("prettyPrint")
  valid_599065 = validateParameter(valid_599065, JBool, required = false,
                                 default = newJBool(true))
  if valid_599065 != nil:
    section.add "prettyPrint", valid_599065
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

proc call*(call_599067: Call_DirectoryRolesUpdate_599054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a role.
  ## 
  let valid = call_599067.validator(path, query, header, formData, body)
  let scheme = call_599067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599067.url(scheme.get, call_599067.host, call_599067.base,
                         call_599067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599067, url, valid)

proc call*(call_599068: Call_DirectoryRolesUpdate_599054; roleId: string;
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
  var path_599069 = newJObject()
  var query_599070 = newJObject()
  var body_599071 = newJObject()
  add(query_599070, "fields", newJString(fields))
  add(query_599070, "quotaUser", newJString(quotaUser))
  add(query_599070, "alt", newJString(alt))
  add(query_599070, "oauth_token", newJString(oauthToken))
  add(query_599070, "userIp", newJString(userIp))
  add(path_599069, "roleId", newJString(roleId))
  add(query_599070, "key", newJString(key))
  add(path_599069, "customer", newJString(customer))
  if body != nil:
    body_599071 = body
  add(query_599070, "prettyPrint", newJBool(prettyPrint))
  result = call_599068.call(path_599069, query_599070, nil, nil, body_599071)

var directoryRolesUpdate* = Call_DirectoryRolesUpdate_599054(
    name: "directoryRolesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesUpdate_599055, base: "/admin/directory/v1",
    url: url_DirectoryRolesUpdate_599056, schemes: {Scheme.Https})
type
  Call_DirectoryRolesGet_599038 = ref object of OpenApiRestCall_597437
proc url_DirectoryRolesGet_599040(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryRolesGet_599039(path: JsonNode; query: JsonNode;
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
  var valid_599041 = path.getOrDefault("roleId")
  valid_599041 = validateParameter(valid_599041, JString, required = true,
                                 default = nil)
  if valid_599041 != nil:
    section.add "roleId", valid_599041
  var valid_599042 = path.getOrDefault("customer")
  valid_599042 = validateParameter(valid_599042, JString, required = true,
                                 default = nil)
  if valid_599042 != nil:
    section.add "customer", valid_599042
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
  var valid_599043 = query.getOrDefault("fields")
  valid_599043 = validateParameter(valid_599043, JString, required = false,
                                 default = nil)
  if valid_599043 != nil:
    section.add "fields", valid_599043
  var valid_599044 = query.getOrDefault("quotaUser")
  valid_599044 = validateParameter(valid_599044, JString, required = false,
                                 default = nil)
  if valid_599044 != nil:
    section.add "quotaUser", valid_599044
  var valid_599045 = query.getOrDefault("alt")
  valid_599045 = validateParameter(valid_599045, JString, required = false,
                                 default = newJString("json"))
  if valid_599045 != nil:
    section.add "alt", valid_599045
  var valid_599046 = query.getOrDefault("oauth_token")
  valid_599046 = validateParameter(valid_599046, JString, required = false,
                                 default = nil)
  if valid_599046 != nil:
    section.add "oauth_token", valid_599046
  var valid_599047 = query.getOrDefault("userIp")
  valid_599047 = validateParameter(valid_599047, JString, required = false,
                                 default = nil)
  if valid_599047 != nil:
    section.add "userIp", valid_599047
  var valid_599048 = query.getOrDefault("key")
  valid_599048 = validateParameter(valid_599048, JString, required = false,
                                 default = nil)
  if valid_599048 != nil:
    section.add "key", valid_599048
  var valid_599049 = query.getOrDefault("prettyPrint")
  valid_599049 = validateParameter(valid_599049, JBool, required = false,
                                 default = newJBool(true))
  if valid_599049 != nil:
    section.add "prettyPrint", valid_599049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599050: Call_DirectoryRolesGet_599038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a role.
  ## 
  let valid = call_599050.validator(path, query, header, formData, body)
  let scheme = call_599050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599050.url(scheme.get, call_599050.host, call_599050.base,
                         call_599050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599050, url, valid)

proc call*(call_599051: Call_DirectoryRolesGet_599038; roleId: string;
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
  var path_599052 = newJObject()
  var query_599053 = newJObject()
  add(query_599053, "fields", newJString(fields))
  add(query_599053, "quotaUser", newJString(quotaUser))
  add(query_599053, "alt", newJString(alt))
  add(query_599053, "oauth_token", newJString(oauthToken))
  add(query_599053, "userIp", newJString(userIp))
  add(path_599052, "roleId", newJString(roleId))
  add(query_599053, "key", newJString(key))
  add(path_599052, "customer", newJString(customer))
  add(query_599053, "prettyPrint", newJBool(prettyPrint))
  result = call_599051.call(path_599052, query_599053, nil, nil, nil)

var directoryRolesGet* = Call_DirectoryRolesGet_599038(name: "directoryRolesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesGet_599039, base: "/admin/directory/v1",
    url: url_DirectoryRolesGet_599040, schemes: {Scheme.Https})
type
  Call_DirectoryRolesPatch_599088 = ref object of OpenApiRestCall_597437
proc url_DirectoryRolesPatch_599090(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryRolesPatch_599089(path: JsonNode; query: JsonNode;
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
  var valid_599091 = path.getOrDefault("roleId")
  valid_599091 = validateParameter(valid_599091, JString, required = true,
                                 default = nil)
  if valid_599091 != nil:
    section.add "roleId", valid_599091
  var valid_599092 = path.getOrDefault("customer")
  valid_599092 = validateParameter(valid_599092, JString, required = true,
                                 default = nil)
  if valid_599092 != nil:
    section.add "customer", valid_599092
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
  var valid_599093 = query.getOrDefault("fields")
  valid_599093 = validateParameter(valid_599093, JString, required = false,
                                 default = nil)
  if valid_599093 != nil:
    section.add "fields", valid_599093
  var valid_599094 = query.getOrDefault("quotaUser")
  valid_599094 = validateParameter(valid_599094, JString, required = false,
                                 default = nil)
  if valid_599094 != nil:
    section.add "quotaUser", valid_599094
  var valid_599095 = query.getOrDefault("alt")
  valid_599095 = validateParameter(valid_599095, JString, required = false,
                                 default = newJString("json"))
  if valid_599095 != nil:
    section.add "alt", valid_599095
  var valid_599096 = query.getOrDefault("oauth_token")
  valid_599096 = validateParameter(valid_599096, JString, required = false,
                                 default = nil)
  if valid_599096 != nil:
    section.add "oauth_token", valid_599096
  var valid_599097 = query.getOrDefault("userIp")
  valid_599097 = validateParameter(valid_599097, JString, required = false,
                                 default = nil)
  if valid_599097 != nil:
    section.add "userIp", valid_599097
  var valid_599098 = query.getOrDefault("key")
  valid_599098 = validateParameter(valid_599098, JString, required = false,
                                 default = nil)
  if valid_599098 != nil:
    section.add "key", valid_599098
  var valid_599099 = query.getOrDefault("prettyPrint")
  valid_599099 = validateParameter(valid_599099, JBool, required = false,
                                 default = newJBool(true))
  if valid_599099 != nil:
    section.add "prettyPrint", valid_599099
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

proc call*(call_599101: Call_DirectoryRolesPatch_599088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a role. This method supports patch semantics.
  ## 
  let valid = call_599101.validator(path, query, header, formData, body)
  let scheme = call_599101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599101.url(scheme.get, call_599101.host, call_599101.base,
                         call_599101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599101, url, valid)

proc call*(call_599102: Call_DirectoryRolesPatch_599088; roleId: string;
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
  var path_599103 = newJObject()
  var query_599104 = newJObject()
  var body_599105 = newJObject()
  add(query_599104, "fields", newJString(fields))
  add(query_599104, "quotaUser", newJString(quotaUser))
  add(query_599104, "alt", newJString(alt))
  add(query_599104, "oauth_token", newJString(oauthToken))
  add(query_599104, "userIp", newJString(userIp))
  add(path_599103, "roleId", newJString(roleId))
  add(query_599104, "key", newJString(key))
  add(path_599103, "customer", newJString(customer))
  if body != nil:
    body_599105 = body
  add(query_599104, "prettyPrint", newJBool(prettyPrint))
  result = call_599102.call(path_599103, query_599104, nil, nil, body_599105)

var directoryRolesPatch* = Call_DirectoryRolesPatch_599088(
    name: "directoryRolesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesPatch_599089, base: "/admin/directory/v1",
    url: url_DirectoryRolesPatch_599090, schemes: {Scheme.Https})
type
  Call_DirectoryRolesDelete_599072 = ref object of OpenApiRestCall_597437
proc url_DirectoryRolesDelete_599074(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryRolesDelete_599073(path: JsonNode; query: JsonNode;
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
  var valid_599075 = path.getOrDefault("roleId")
  valid_599075 = validateParameter(valid_599075, JString, required = true,
                                 default = nil)
  if valid_599075 != nil:
    section.add "roleId", valid_599075
  var valid_599076 = path.getOrDefault("customer")
  valid_599076 = validateParameter(valid_599076, JString, required = true,
                                 default = nil)
  if valid_599076 != nil:
    section.add "customer", valid_599076
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
  var valid_599077 = query.getOrDefault("fields")
  valid_599077 = validateParameter(valid_599077, JString, required = false,
                                 default = nil)
  if valid_599077 != nil:
    section.add "fields", valid_599077
  var valid_599078 = query.getOrDefault("quotaUser")
  valid_599078 = validateParameter(valid_599078, JString, required = false,
                                 default = nil)
  if valid_599078 != nil:
    section.add "quotaUser", valid_599078
  var valid_599079 = query.getOrDefault("alt")
  valid_599079 = validateParameter(valid_599079, JString, required = false,
                                 default = newJString("json"))
  if valid_599079 != nil:
    section.add "alt", valid_599079
  var valid_599080 = query.getOrDefault("oauth_token")
  valid_599080 = validateParameter(valid_599080, JString, required = false,
                                 default = nil)
  if valid_599080 != nil:
    section.add "oauth_token", valid_599080
  var valid_599081 = query.getOrDefault("userIp")
  valid_599081 = validateParameter(valid_599081, JString, required = false,
                                 default = nil)
  if valid_599081 != nil:
    section.add "userIp", valid_599081
  var valid_599082 = query.getOrDefault("key")
  valid_599082 = validateParameter(valid_599082, JString, required = false,
                                 default = nil)
  if valid_599082 != nil:
    section.add "key", valid_599082
  var valid_599083 = query.getOrDefault("prettyPrint")
  valid_599083 = validateParameter(valid_599083, JBool, required = false,
                                 default = newJBool(true))
  if valid_599083 != nil:
    section.add "prettyPrint", valid_599083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599084: Call_DirectoryRolesDelete_599072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role.
  ## 
  let valid = call_599084.validator(path, query, header, formData, body)
  let scheme = call_599084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599084.url(scheme.get, call_599084.host, call_599084.base,
                         call_599084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599084, url, valid)

proc call*(call_599085: Call_DirectoryRolesDelete_599072; roleId: string;
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
  var path_599086 = newJObject()
  var query_599087 = newJObject()
  add(query_599087, "fields", newJString(fields))
  add(query_599087, "quotaUser", newJString(quotaUser))
  add(query_599087, "alt", newJString(alt))
  add(query_599087, "oauth_token", newJString(oauthToken))
  add(query_599087, "userIp", newJString(userIp))
  add(path_599086, "roleId", newJString(roleId))
  add(query_599087, "key", newJString(key))
  add(path_599086, "customer", newJString(customer))
  add(query_599087, "prettyPrint", newJBool(prettyPrint))
  result = call_599085.call(path_599086, query_599087, nil, nil, nil)

var directoryRolesDelete* = Call_DirectoryRolesDelete_599072(
    name: "directoryRolesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesDelete_599073, base: "/admin/directory/v1",
    url: url_DirectoryRolesDelete_599074, schemes: {Scheme.Https})
type
  Call_DirectoryCustomersUpdate_599121 = ref object of OpenApiRestCall_597437
proc url_DirectoryCustomersUpdate_599123(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerKey" in path, "`customerKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryCustomersUpdate_599122(path: JsonNode; query: JsonNode;
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
  var valid_599124 = path.getOrDefault("customerKey")
  valid_599124 = validateParameter(valid_599124, JString, required = true,
                                 default = nil)
  if valid_599124 != nil:
    section.add "customerKey", valid_599124
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
  var valid_599125 = query.getOrDefault("fields")
  valid_599125 = validateParameter(valid_599125, JString, required = false,
                                 default = nil)
  if valid_599125 != nil:
    section.add "fields", valid_599125
  var valid_599126 = query.getOrDefault("quotaUser")
  valid_599126 = validateParameter(valid_599126, JString, required = false,
                                 default = nil)
  if valid_599126 != nil:
    section.add "quotaUser", valid_599126
  var valid_599127 = query.getOrDefault("alt")
  valid_599127 = validateParameter(valid_599127, JString, required = false,
                                 default = newJString("json"))
  if valid_599127 != nil:
    section.add "alt", valid_599127
  var valid_599128 = query.getOrDefault("oauth_token")
  valid_599128 = validateParameter(valid_599128, JString, required = false,
                                 default = nil)
  if valid_599128 != nil:
    section.add "oauth_token", valid_599128
  var valid_599129 = query.getOrDefault("userIp")
  valid_599129 = validateParameter(valid_599129, JString, required = false,
                                 default = nil)
  if valid_599129 != nil:
    section.add "userIp", valid_599129
  var valid_599130 = query.getOrDefault("key")
  valid_599130 = validateParameter(valid_599130, JString, required = false,
                                 default = nil)
  if valid_599130 != nil:
    section.add "key", valid_599130
  var valid_599131 = query.getOrDefault("prettyPrint")
  valid_599131 = validateParameter(valid_599131, JBool, required = false,
                                 default = newJBool(true))
  if valid_599131 != nil:
    section.add "prettyPrint", valid_599131
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

proc call*(call_599133: Call_DirectoryCustomersUpdate_599121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a customer.
  ## 
  let valid = call_599133.validator(path, query, header, formData, body)
  let scheme = call_599133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599133.url(scheme.get, call_599133.host, call_599133.base,
                         call_599133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599133, url, valid)

proc call*(call_599134: Call_DirectoryCustomersUpdate_599121; customerKey: string;
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
  var path_599135 = newJObject()
  var query_599136 = newJObject()
  var body_599137 = newJObject()
  add(path_599135, "customerKey", newJString(customerKey))
  add(query_599136, "fields", newJString(fields))
  add(query_599136, "quotaUser", newJString(quotaUser))
  add(query_599136, "alt", newJString(alt))
  add(query_599136, "oauth_token", newJString(oauthToken))
  add(query_599136, "userIp", newJString(userIp))
  add(query_599136, "key", newJString(key))
  if body != nil:
    body_599137 = body
  add(query_599136, "prettyPrint", newJBool(prettyPrint))
  result = call_599134.call(path_599135, query_599136, nil, nil, body_599137)

var directoryCustomersUpdate* = Call_DirectoryCustomersUpdate_599121(
    name: "directoryCustomersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersUpdate_599122,
    base: "/admin/directory/v1", url: url_DirectoryCustomersUpdate_599123,
    schemes: {Scheme.Https})
type
  Call_DirectoryCustomersGet_599106 = ref object of OpenApiRestCall_597437
proc url_DirectoryCustomersGet_599108(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerKey" in path, "`customerKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryCustomersGet_599107(path: JsonNode; query: JsonNode;
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
  var valid_599109 = path.getOrDefault("customerKey")
  valid_599109 = validateParameter(valid_599109, JString, required = true,
                                 default = nil)
  if valid_599109 != nil:
    section.add "customerKey", valid_599109
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
  var valid_599110 = query.getOrDefault("fields")
  valid_599110 = validateParameter(valid_599110, JString, required = false,
                                 default = nil)
  if valid_599110 != nil:
    section.add "fields", valid_599110
  var valid_599111 = query.getOrDefault("quotaUser")
  valid_599111 = validateParameter(valid_599111, JString, required = false,
                                 default = nil)
  if valid_599111 != nil:
    section.add "quotaUser", valid_599111
  var valid_599112 = query.getOrDefault("alt")
  valid_599112 = validateParameter(valid_599112, JString, required = false,
                                 default = newJString("json"))
  if valid_599112 != nil:
    section.add "alt", valid_599112
  var valid_599113 = query.getOrDefault("oauth_token")
  valid_599113 = validateParameter(valid_599113, JString, required = false,
                                 default = nil)
  if valid_599113 != nil:
    section.add "oauth_token", valid_599113
  var valid_599114 = query.getOrDefault("userIp")
  valid_599114 = validateParameter(valid_599114, JString, required = false,
                                 default = nil)
  if valid_599114 != nil:
    section.add "userIp", valid_599114
  var valid_599115 = query.getOrDefault("key")
  valid_599115 = validateParameter(valid_599115, JString, required = false,
                                 default = nil)
  if valid_599115 != nil:
    section.add "key", valid_599115
  var valid_599116 = query.getOrDefault("prettyPrint")
  valid_599116 = validateParameter(valid_599116, JBool, required = false,
                                 default = newJBool(true))
  if valid_599116 != nil:
    section.add "prettyPrint", valid_599116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599117: Call_DirectoryCustomersGet_599106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a customer.
  ## 
  let valid = call_599117.validator(path, query, header, formData, body)
  let scheme = call_599117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599117.url(scheme.get, call_599117.host, call_599117.base,
                         call_599117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599117, url, valid)

proc call*(call_599118: Call_DirectoryCustomersGet_599106; customerKey: string;
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
  var path_599119 = newJObject()
  var query_599120 = newJObject()
  add(path_599119, "customerKey", newJString(customerKey))
  add(query_599120, "fields", newJString(fields))
  add(query_599120, "quotaUser", newJString(quotaUser))
  add(query_599120, "alt", newJString(alt))
  add(query_599120, "oauth_token", newJString(oauthToken))
  add(query_599120, "userIp", newJString(userIp))
  add(query_599120, "key", newJString(key))
  add(query_599120, "prettyPrint", newJBool(prettyPrint))
  result = call_599118.call(path_599119, query_599120, nil, nil, nil)

var directoryCustomersGet* = Call_DirectoryCustomersGet_599106(
    name: "directoryCustomersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersGet_599107, base: "/admin/directory/v1",
    url: url_DirectoryCustomersGet_599108, schemes: {Scheme.Https})
type
  Call_DirectoryCustomersPatch_599138 = ref object of OpenApiRestCall_597437
proc url_DirectoryCustomersPatch_599140(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerKey" in path, "`customerKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryCustomersPatch_599139(path: JsonNode; query: JsonNode;
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
  var valid_599141 = path.getOrDefault("customerKey")
  valid_599141 = validateParameter(valid_599141, JString, required = true,
                                 default = nil)
  if valid_599141 != nil:
    section.add "customerKey", valid_599141
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
  var valid_599142 = query.getOrDefault("fields")
  valid_599142 = validateParameter(valid_599142, JString, required = false,
                                 default = nil)
  if valid_599142 != nil:
    section.add "fields", valid_599142
  var valid_599143 = query.getOrDefault("quotaUser")
  valid_599143 = validateParameter(valid_599143, JString, required = false,
                                 default = nil)
  if valid_599143 != nil:
    section.add "quotaUser", valid_599143
  var valid_599144 = query.getOrDefault("alt")
  valid_599144 = validateParameter(valid_599144, JString, required = false,
                                 default = newJString("json"))
  if valid_599144 != nil:
    section.add "alt", valid_599144
  var valid_599145 = query.getOrDefault("oauth_token")
  valid_599145 = validateParameter(valid_599145, JString, required = false,
                                 default = nil)
  if valid_599145 != nil:
    section.add "oauth_token", valid_599145
  var valid_599146 = query.getOrDefault("userIp")
  valid_599146 = validateParameter(valid_599146, JString, required = false,
                                 default = nil)
  if valid_599146 != nil:
    section.add "userIp", valid_599146
  var valid_599147 = query.getOrDefault("key")
  valid_599147 = validateParameter(valid_599147, JString, required = false,
                                 default = nil)
  if valid_599147 != nil:
    section.add "key", valid_599147
  var valid_599148 = query.getOrDefault("prettyPrint")
  valid_599148 = validateParameter(valid_599148, JBool, required = false,
                                 default = newJBool(true))
  if valid_599148 != nil:
    section.add "prettyPrint", valid_599148
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

proc call*(call_599150: Call_DirectoryCustomersPatch_599138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a customer. This method supports patch semantics.
  ## 
  let valid = call_599150.validator(path, query, header, formData, body)
  let scheme = call_599150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599150.url(scheme.get, call_599150.host, call_599150.base,
                         call_599150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599150, url, valid)

proc call*(call_599151: Call_DirectoryCustomersPatch_599138; customerKey: string;
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
  var path_599152 = newJObject()
  var query_599153 = newJObject()
  var body_599154 = newJObject()
  add(path_599152, "customerKey", newJString(customerKey))
  add(query_599153, "fields", newJString(fields))
  add(query_599153, "quotaUser", newJString(quotaUser))
  add(query_599153, "alt", newJString(alt))
  add(query_599153, "oauth_token", newJString(oauthToken))
  add(query_599153, "userIp", newJString(userIp))
  add(query_599153, "key", newJString(key))
  if body != nil:
    body_599154 = body
  add(query_599153, "prettyPrint", newJBool(prettyPrint))
  result = call_599151.call(path_599152, query_599153, nil, nil, body_599154)

var directoryCustomersPatch* = Call_DirectoryCustomersPatch_599138(
    name: "directoryCustomersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersPatch_599139,
    base: "/admin/directory/v1", url: url_DirectoryCustomersPatch_599140,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsInsert_599176 = ref object of OpenApiRestCall_597437
proc url_DirectoryGroupsInsert_599178(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DirectoryGroupsInsert_599177(path: JsonNode; query: JsonNode;
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
  var valid_599179 = query.getOrDefault("fields")
  valid_599179 = validateParameter(valid_599179, JString, required = false,
                                 default = nil)
  if valid_599179 != nil:
    section.add "fields", valid_599179
  var valid_599180 = query.getOrDefault("quotaUser")
  valid_599180 = validateParameter(valid_599180, JString, required = false,
                                 default = nil)
  if valid_599180 != nil:
    section.add "quotaUser", valid_599180
  var valid_599181 = query.getOrDefault("alt")
  valid_599181 = validateParameter(valid_599181, JString, required = false,
                                 default = newJString("json"))
  if valid_599181 != nil:
    section.add "alt", valid_599181
  var valid_599182 = query.getOrDefault("oauth_token")
  valid_599182 = validateParameter(valid_599182, JString, required = false,
                                 default = nil)
  if valid_599182 != nil:
    section.add "oauth_token", valid_599182
  var valid_599183 = query.getOrDefault("userIp")
  valid_599183 = validateParameter(valid_599183, JString, required = false,
                                 default = nil)
  if valid_599183 != nil:
    section.add "userIp", valid_599183
  var valid_599184 = query.getOrDefault("key")
  valid_599184 = validateParameter(valid_599184, JString, required = false,
                                 default = nil)
  if valid_599184 != nil:
    section.add "key", valid_599184
  var valid_599185 = query.getOrDefault("prettyPrint")
  valid_599185 = validateParameter(valid_599185, JBool, required = false,
                                 default = newJBool(true))
  if valid_599185 != nil:
    section.add "prettyPrint", valid_599185
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

proc call*(call_599187: Call_DirectoryGroupsInsert_599176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create Group
  ## 
  let valid = call_599187.validator(path, query, header, formData, body)
  let scheme = call_599187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599187.url(scheme.get, call_599187.host, call_599187.base,
                         call_599187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599187, url, valid)

proc call*(call_599188: Call_DirectoryGroupsInsert_599176; fields: string = "";
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
  var query_599189 = newJObject()
  var body_599190 = newJObject()
  add(query_599189, "fields", newJString(fields))
  add(query_599189, "quotaUser", newJString(quotaUser))
  add(query_599189, "alt", newJString(alt))
  add(query_599189, "oauth_token", newJString(oauthToken))
  add(query_599189, "userIp", newJString(userIp))
  add(query_599189, "key", newJString(key))
  if body != nil:
    body_599190 = body
  add(query_599189, "prettyPrint", newJBool(prettyPrint))
  result = call_599188.call(nil, query_599189, nil, nil, body_599190)

var directoryGroupsInsert* = Call_DirectoryGroupsInsert_599176(
    name: "directoryGroupsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_DirectoryGroupsInsert_599177, base: "/admin/directory/v1",
    url: url_DirectoryGroupsInsert_599178, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsList_599155 = ref object of OpenApiRestCall_597437
proc url_DirectoryGroupsList_599157(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DirectoryGroupsList_599156(path: JsonNode; query: JsonNode;
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
  var valid_599158 = query.getOrDefault("fields")
  valid_599158 = validateParameter(valid_599158, JString, required = false,
                                 default = nil)
  if valid_599158 != nil:
    section.add "fields", valid_599158
  var valid_599159 = query.getOrDefault("pageToken")
  valid_599159 = validateParameter(valid_599159, JString, required = false,
                                 default = nil)
  if valid_599159 != nil:
    section.add "pageToken", valid_599159
  var valid_599160 = query.getOrDefault("quotaUser")
  valid_599160 = validateParameter(valid_599160, JString, required = false,
                                 default = nil)
  if valid_599160 != nil:
    section.add "quotaUser", valid_599160
  var valid_599161 = query.getOrDefault("alt")
  valid_599161 = validateParameter(valid_599161, JString, required = false,
                                 default = newJString("json"))
  if valid_599161 != nil:
    section.add "alt", valid_599161
  var valid_599162 = query.getOrDefault("query")
  valid_599162 = validateParameter(valid_599162, JString, required = false,
                                 default = nil)
  if valid_599162 != nil:
    section.add "query", valid_599162
  var valid_599163 = query.getOrDefault("oauth_token")
  valid_599163 = validateParameter(valid_599163, JString, required = false,
                                 default = nil)
  if valid_599163 != nil:
    section.add "oauth_token", valid_599163
  var valid_599164 = query.getOrDefault("userIp")
  valid_599164 = validateParameter(valid_599164, JString, required = false,
                                 default = nil)
  if valid_599164 != nil:
    section.add "userIp", valid_599164
  var valid_599165 = query.getOrDefault("maxResults")
  valid_599165 = validateParameter(valid_599165, JInt, required = false,
                                 default = newJInt(200))
  if valid_599165 != nil:
    section.add "maxResults", valid_599165
  var valid_599166 = query.getOrDefault("orderBy")
  valid_599166 = validateParameter(valid_599166, JString, required = false,
                                 default = newJString("email"))
  if valid_599166 != nil:
    section.add "orderBy", valid_599166
  var valid_599167 = query.getOrDefault("key")
  valid_599167 = validateParameter(valid_599167, JString, required = false,
                                 default = nil)
  if valid_599167 != nil:
    section.add "key", valid_599167
  var valid_599168 = query.getOrDefault("sortOrder")
  valid_599168 = validateParameter(valid_599168, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_599168 != nil:
    section.add "sortOrder", valid_599168
  var valid_599169 = query.getOrDefault("customer")
  valid_599169 = validateParameter(valid_599169, JString, required = false,
                                 default = nil)
  if valid_599169 != nil:
    section.add "customer", valid_599169
  var valid_599170 = query.getOrDefault("prettyPrint")
  valid_599170 = validateParameter(valid_599170, JBool, required = false,
                                 default = newJBool(true))
  if valid_599170 != nil:
    section.add "prettyPrint", valid_599170
  var valid_599171 = query.getOrDefault("domain")
  valid_599171 = validateParameter(valid_599171, JString, required = false,
                                 default = nil)
  if valid_599171 != nil:
    section.add "domain", valid_599171
  var valid_599172 = query.getOrDefault("userKey")
  valid_599172 = validateParameter(valid_599172, JString, required = false,
                                 default = nil)
  if valid_599172 != nil:
    section.add "userKey", valid_599172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599173: Call_DirectoryGroupsList_599155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all groups of a domain or of a user given a userKey (paginated)
  ## 
  let valid = call_599173.validator(path, query, header, formData, body)
  let scheme = call_599173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599173.url(scheme.get, call_599173.host, call_599173.base,
                         call_599173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599173, url, valid)

proc call*(call_599174: Call_DirectoryGroupsList_599155; fields: string = "";
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
  var query_599175 = newJObject()
  add(query_599175, "fields", newJString(fields))
  add(query_599175, "pageToken", newJString(pageToken))
  add(query_599175, "quotaUser", newJString(quotaUser))
  add(query_599175, "alt", newJString(alt))
  add(query_599175, "query", newJString(query))
  add(query_599175, "oauth_token", newJString(oauthToken))
  add(query_599175, "userIp", newJString(userIp))
  add(query_599175, "maxResults", newJInt(maxResults))
  add(query_599175, "orderBy", newJString(orderBy))
  add(query_599175, "key", newJString(key))
  add(query_599175, "sortOrder", newJString(sortOrder))
  add(query_599175, "customer", newJString(customer))
  add(query_599175, "prettyPrint", newJBool(prettyPrint))
  add(query_599175, "domain", newJString(domain))
  add(query_599175, "userKey", newJString(userKey))
  result = call_599174.call(nil, query_599175, nil, nil, nil)

var directoryGroupsList* = Call_DirectoryGroupsList_599155(
    name: "directoryGroupsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_DirectoryGroupsList_599156, base: "/admin/directory/v1",
    url: url_DirectoryGroupsList_599157, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsUpdate_599206 = ref object of OpenApiRestCall_597437
proc url_DirectoryGroupsUpdate_599208(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryGroupsUpdate_599207(path: JsonNode; query: JsonNode;
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
  var valid_599209 = path.getOrDefault("groupKey")
  valid_599209 = validateParameter(valid_599209, JString, required = true,
                                 default = nil)
  if valid_599209 != nil:
    section.add "groupKey", valid_599209
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
  var valid_599210 = query.getOrDefault("fields")
  valid_599210 = validateParameter(valid_599210, JString, required = false,
                                 default = nil)
  if valid_599210 != nil:
    section.add "fields", valid_599210
  var valid_599211 = query.getOrDefault("quotaUser")
  valid_599211 = validateParameter(valid_599211, JString, required = false,
                                 default = nil)
  if valid_599211 != nil:
    section.add "quotaUser", valid_599211
  var valid_599212 = query.getOrDefault("alt")
  valid_599212 = validateParameter(valid_599212, JString, required = false,
                                 default = newJString("json"))
  if valid_599212 != nil:
    section.add "alt", valid_599212
  var valid_599213 = query.getOrDefault("oauth_token")
  valid_599213 = validateParameter(valid_599213, JString, required = false,
                                 default = nil)
  if valid_599213 != nil:
    section.add "oauth_token", valid_599213
  var valid_599214 = query.getOrDefault("userIp")
  valid_599214 = validateParameter(valid_599214, JString, required = false,
                                 default = nil)
  if valid_599214 != nil:
    section.add "userIp", valid_599214
  var valid_599215 = query.getOrDefault("key")
  valid_599215 = validateParameter(valid_599215, JString, required = false,
                                 default = nil)
  if valid_599215 != nil:
    section.add "key", valid_599215
  var valid_599216 = query.getOrDefault("prettyPrint")
  valid_599216 = validateParameter(valid_599216, JBool, required = false,
                                 default = newJBool(true))
  if valid_599216 != nil:
    section.add "prettyPrint", valid_599216
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

proc call*(call_599218: Call_DirectoryGroupsUpdate_599206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Group
  ## 
  let valid = call_599218.validator(path, query, header, formData, body)
  let scheme = call_599218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599218.url(scheme.get, call_599218.host, call_599218.base,
                         call_599218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599218, url, valid)

proc call*(call_599219: Call_DirectoryGroupsUpdate_599206; groupKey: string;
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
  var path_599220 = newJObject()
  var query_599221 = newJObject()
  var body_599222 = newJObject()
  add(query_599221, "fields", newJString(fields))
  add(query_599221, "quotaUser", newJString(quotaUser))
  add(query_599221, "alt", newJString(alt))
  add(query_599221, "oauth_token", newJString(oauthToken))
  add(query_599221, "userIp", newJString(userIp))
  add(query_599221, "key", newJString(key))
  if body != nil:
    body_599222 = body
  add(query_599221, "prettyPrint", newJBool(prettyPrint))
  add(path_599220, "groupKey", newJString(groupKey))
  result = call_599219.call(path_599220, query_599221, nil, nil, body_599222)

var directoryGroupsUpdate* = Call_DirectoryGroupsUpdate_599206(
    name: "directoryGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsUpdate_599207, base: "/admin/directory/v1",
    url: url_DirectoryGroupsUpdate_599208, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsGet_599191 = ref object of OpenApiRestCall_597437
proc url_DirectoryGroupsGet_599193(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryGroupsGet_599192(path: JsonNode; query: JsonNode;
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
  var valid_599194 = path.getOrDefault("groupKey")
  valid_599194 = validateParameter(valid_599194, JString, required = true,
                                 default = nil)
  if valid_599194 != nil:
    section.add "groupKey", valid_599194
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
  var valid_599195 = query.getOrDefault("fields")
  valid_599195 = validateParameter(valid_599195, JString, required = false,
                                 default = nil)
  if valid_599195 != nil:
    section.add "fields", valid_599195
  var valid_599196 = query.getOrDefault("quotaUser")
  valid_599196 = validateParameter(valid_599196, JString, required = false,
                                 default = nil)
  if valid_599196 != nil:
    section.add "quotaUser", valid_599196
  var valid_599197 = query.getOrDefault("alt")
  valid_599197 = validateParameter(valid_599197, JString, required = false,
                                 default = newJString("json"))
  if valid_599197 != nil:
    section.add "alt", valid_599197
  var valid_599198 = query.getOrDefault("oauth_token")
  valid_599198 = validateParameter(valid_599198, JString, required = false,
                                 default = nil)
  if valid_599198 != nil:
    section.add "oauth_token", valid_599198
  var valid_599199 = query.getOrDefault("userIp")
  valid_599199 = validateParameter(valid_599199, JString, required = false,
                                 default = nil)
  if valid_599199 != nil:
    section.add "userIp", valid_599199
  var valid_599200 = query.getOrDefault("key")
  valid_599200 = validateParameter(valid_599200, JString, required = false,
                                 default = nil)
  if valid_599200 != nil:
    section.add "key", valid_599200
  var valid_599201 = query.getOrDefault("prettyPrint")
  valid_599201 = validateParameter(valid_599201, JBool, required = false,
                                 default = newJBool(true))
  if valid_599201 != nil:
    section.add "prettyPrint", valid_599201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599202: Call_DirectoryGroupsGet_599191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Group
  ## 
  let valid = call_599202.validator(path, query, header, formData, body)
  let scheme = call_599202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599202.url(scheme.get, call_599202.host, call_599202.base,
                         call_599202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599202, url, valid)

proc call*(call_599203: Call_DirectoryGroupsGet_599191; groupKey: string;
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
  var path_599204 = newJObject()
  var query_599205 = newJObject()
  add(query_599205, "fields", newJString(fields))
  add(query_599205, "quotaUser", newJString(quotaUser))
  add(query_599205, "alt", newJString(alt))
  add(query_599205, "oauth_token", newJString(oauthToken))
  add(query_599205, "userIp", newJString(userIp))
  add(query_599205, "key", newJString(key))
  add(query_599205, "prettyPrint", newJBool(prettyPrint))
  add(path_599204, "groupKey", newJString(groupKey))
  result = call_599203.call(path_599204, query_599205, nil, nil, nil)

var directoryGroupsGet* = Call_DirectoryGroupsGet_599191(
    name: "directoryGroupsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsGet_599192, base: "/admin/directory/v1",
    url: url_DirectoryGroupsGet_599193, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsPatch_599238 = ref object of OpenApiRestCall_597437
proc url_DirectoryGroupsPatch_599240(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryGroupsPatch_599239(path: JsonNode; query: JsonNode;
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
  var valid_599241 = path.getOrDefault("groupKey")
  valid_599241 = validateParameter(valid_599241, JString, required = true,
                                 default = nil)
  if valid_599241 != nil:
    section.add "groupKey", valid_599241
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
  var valid_599242 = query.getOrDefault("fields")
  valid_599242 = validateParameter(valid_599242, JString, required = false,
                                 default = nil)
  if valid_599242 != nil:
    section.add "fields", valid_599242
  var valid_599243 = query.getOrDefault("quotaUser")
  valid_599243 = validateParameter(valid_599243, JString, required = false,
                                 default = nil)
  if valid_599243 != nil:
    section.add "quotaUser", valid_599243
  var valid_599244 = query.getOrDefault("alt")
  valid_599244 = validateParameter(valid_599244, JString, required = false,
                                 default = newJString("json"))
  if valid_599244 != nil:
    section.add "alt", valid_599244
  var valid_599245 = query.getOrDefault("oauth_token")
  valid_599245 = validateParameter(valid_599245, JString, required = false,
                                 default = nil)
  if valid_599245 != nil:
    section.add "oauth_token", valid_599245
  var valid_599246 = query.getOrDefault("userIp")
  valid_599246 = validateParameter(valid_599246, JString, required = false,
                                 default = nil)
  if valid_599246 != nil:
    section.add "userIp", valid_599246
  var valid_599247 = query.getOrDefault("key")
  valid_599247 = validateParameter(valid_599247, JString, required = false,
                                 default = nil)
  if valid_599247 != nil:
    section.add "key", valid_599247
  var valid_599248 = query.getOrDefault("prettyPrint")
  valid_599248 = validateParameter(valid_599248, JBool, required = false,
                                 default = newJBool(true))
  if valid_599248 != nil:
    section.add "prettyPrint", valid_599248
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

proc call*(call_599250: Call_DirectoryGroupsPatch_599238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Group. This method supports patch semantics.
  ## 
  let valid = call_599250.validator(path, query, header, formData, body)
  let scheme = call_599250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599250.url(scheme.get, call_599250.host, call_599250.base,
                         call_599250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599250, url, valid)

proc call*(call_599251: Call_DirectoryGroupsPatch_599238; groupKey: string;
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
  var path_599252 = newJObject()
  var query_599253 = newJObject()
  var body_599254 = newJObject()
  add(query_599253, "fields", newJString(fields))
  add(query_599253, "quotaUser", newJString(quotaUser))
  add(query_599253, "alt", newJString(alt))
  add(query_599253, "oauth_token", newJString(oauthToken))
  add(query_599253, "userIp", newJString(userIp))
  add(query_599253, "key", newJString(key))
  if body != nil:
    body_599254 = body
  add(query_599253, "prettyPrint", newJBool(prettyPrint))
  add(path_599252, "groupKey", newJString(groupKey))
  result = call_599251.call(path_599252, query_599253, nil, nil, body_599254)

var directoryGroupsPatch* = Call_DirectoryGroupsPatch_599238(
    name: "directoryGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsPatch_599239, base: "/admin/directory/v1",
    url: url_DirectoryGroupsPatch_599240, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsDelete_599223 = ref object of OpenApiRestCall_597437
proc url_DirectoryGroupsDelete_599225(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryGroupsDelete_599224(path: JsonNode; query: JsonNode;
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
  var valid_599226 = path.getOrDefault("groupKey")
  valid_599226 = validateParameter(valid_599226, JString, required = true,
                                 default = nil)
  if valid_599226 != nil:
    section.add "groupKey", valid_599226
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
  var valid_599227 = query.getOrDefault("fields")
  valid_599227 = validateParameter(valid_599227, JString, required = false,
                                 default = nil)
  if valid_599227 != nil:
    section.add "fields", valid_599227
  var valid_599228 = query.getOrDefault("quotaUser")
  valid_599228 = validateParameter(valid_599228, JString, required = false,
                                 default = nil)
  if valid_599228 != nil:
    section.add "quotaUser", valid_599228
  var valid_599229 = query.getOrDefault("alt")
  valid_599229 = validateParameter(valid_599229, JString, required = false,
                                 default = newJString("json"))
  if valid_599229 != nil:
    section.add "alt", valid_599229
  var valid_599230 = query.getOrDefault("oauth_token")
  valid_599230 = validateParameter(valid_599230, JString, required = false,
                                 default = nil)
  if valid_599230 != nil:
    section.add "oauth_token", valid_599230
  var valid_599231 = query.getOrDefault("userIp")
  valid_599231 = validateParameter(valid_599231, JString, required = false,
                                 default = nil)
  if valid_599231 != nil:
    section.add "userIp", valid_599231
  var valid_599232 = query.getOrDefault("key")
  valid_599232 = validateParameter(valid_599232, JString, required = false,
                                 default = nil)
  if valid_599232 != nil:
    section.add "key", valid_599232
  var valid_599233 = query.getOrDefault("prettyPrint")
  valid_599233 = validateParameter(valid_599233, JBool, required = false,
                                 default = newJBool(true))
  if valid_599233 != nil:
    section.add "prettyPrint", valid_599233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599234: Call_DirectoryGroupsDelete_599223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Group
  ## 
  let valid = call_599234.validator(path, query, header, formData, body)
  let scheme = call_599234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599234.url(scheme.get, call_599234.host, call_599234.base,
                         call_599234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599234, url, valid)

proc call*(call_599235: Call_DirectoryGroupsDelete_599223; groupKey: string;
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
  var path_599236 = newJObject()
  var query_599237 = newJObject()
  add(query_599237, "fields", newJString(fields))
  add(query_599237, "quotaUser", newJString(quotaUser))
  add(query_599237, "alt", newJString(alt))
  add(query_599237, "oauth_token", newJString(oauthToken))
  add(query_599237, "userIp", newJString(userIp))
  add(query_599237, "key", newJString(key))
  add(query_599237, "prettyPrint", newJBool(prettyPrint))
  add(path_599236, "groupKey", newJString(groupKey))
  result = call_599235.call(path_599236, query_599237, nil, nil, nil)

var directoryGroupsDelete* = Call_DirectoryGroupsDelete_599223(
    name: "directoryGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsDelete_599224, base: "/admin/directory/v1",
    url: url_DirectoryGroupsDelete_599225, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesInsert_599270 = ref object of OpenApiRestCall_597437
proc url_DirectoryGroupsAliasesInsert_599272(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryGroupsAliasesInsert_599271(path: JsonNode; query: JsonNode;
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
  var valid_599273 = path.getOrDefault("groupKey")
  valid_599273 = validateParameter(valid_599273, JString, required = true,
                                 default = nil)
  if valid_599273 != nil:
    section.add "groupKey", valid_599273
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
  var valid_599274 = query.getOrDefault("fields")
  valid_599274 = validateParameter(valid_599274, JString, required = false,
                                 default = nil)
  if valid_599274 != nil:
    section.add "fields", valid_599274
  var valid_599275 = query.getOrDefault("quotaUser")
  valid_599275 = validateParameter(valid_599275, JString, required = false,
                                 default = nil)
  if valid_599275 != nil:
    section.add "quotaUser", valid_599275
  var valid_599276 = query.getOrDefault("alt")
  valid_599276 = validateParameter(valid_599276, JString, required = false,
                                 default = newJString("json"))
  if valid_599276 != nil:
    section.add "alt", valid_599276
  var valid_599277 = query.getOrDefault("oauth_token")
  valid_599277 = validateParameter(valid_599277, JString, required = false,
                                 default = nil)
  if valid_599277 != nil:
    section.add "oauth_token", valid_599277
  var valid_599278 = query.getOrDefault("userIp")
  valid_599278 = validateParameter(valid_599278, JString, required = false,
                                 default = nil)
  if valid_599278 != nil:
    section.add "userIp", valid_599278
  var valid_599279 = query.getOrDefault("key")
  valid_599279 = validateParameter(valid_599279, JString, required = false,
                                 default = nil)
  if valid_599279 != nil:
    section.add "key", valid_599279
  var valid_599280 = query.getOrDefault("prettyPrint")
  valid_599280 = validateParameter(valid_599280, JBool, required = false,
                                 default = newJBool(true))
  if valid_599280 != nil:
    section.add "prettyPrint", valid_599280
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

proc call*(call_599282: Call_DirectoryGroupsAliasesInsert_599270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a alias for the group
  ## 
  let valid = call_599282.validator(path, query, header, formData, body)
  let scheme = call_599282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599282.url(scheme.get, call_599282.host, call_599282.base,
                         call_599282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599282, url, valid)

proc call*(call_599283: Call_DirectoryGroupsAliasesInsert_599270; groupKey: string;
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
  var path_599284 = newJObject()
  var query_599285 = newJObject()
  var body_599286 = newJObject()
  add(query_599285, "fields", newJString(fields))
  add(query_599285, "quotaUser", newJString(quotaUser))
  add(query_599285, "alt", newJString(alt))
  add(query_599285, "oauth_token", newJString(oauthToken))
  add(query_599285, "userIp", newJString(userIp))
  add(query_599285, "key", newJString(key))
  if body != nil:
    body_599286 = body
  add(query_599285, "prettyPrint", newJBool(prettyPrint))
  add(path_599284, "groupKey", newJString(groupKey))
  result = call_599283.call(path_599284, query_599285, nil, nil, body_599286)

var directoryGroupsAliasesInsert* = Call_DirectoryGroupsAliasesInsert_599270(
    name: "directoryGroupsAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases",
    validator: validate_DirectoryGroupsAliasesInsert_599271,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesInsert_599272,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesList_599255 = ref object of OpenApiRestCall_597437
proc url_DirectoryGroupsAliasesList_599257(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryGroupsAliasesList_599256(path: JsonNode; query: JsonNode;
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
  var valid_599258 = path.getOrDefault("groupKey")
  valid_599258 = validateParameter(valid_599258, JString, required = true,
                                 default = nil)
  if valid_599258 != nil:
    section.add "groupKey", valid_599258
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
  var valid_599259 = query.getOrDefault("fields")
  valid_599259 = validateParameter(valid_599259, JString, required = false,
                                 default = nil)
  if valid_599259 != nil:
    section.add "fields", valid_599259
  var valid_599260 = query.getOrDefault("quotaUser")
  valid_599260 = validateParameter(valid_599260, JString, required = false,
                                 default = nil)
  if valid_599260 != nil:
    section.add "quotaUser", valid_599260
  var valid_599261 = query.getOrDefault("alt")
  valid_599261 = validateParameter(valid_599261, JString, required = false,
                                 default = newJString("json"))
  if valid_599261 != nil:
    section.add "alt", valid_599261
  var valid_599262 = query.getOrDefault("oauth_token")
  valid_599262 = validateParameter(valid_599262, JString, required = false,
                                 default = nil)
  if valid_599262 != nil:
    section.add "oauth_token", valid_599262
  var valid_599263 = query.getOrDefault("userIp")
  valid_599263 = validateParameter(valid_599263, JString, required = false,
                                 default = nil)
  if valid_599263 != nil:
    section.add "userIp", valid_599263
  var valid_599264 = query.getOrDefault("key")
  valid_599264 = validateParameter(valid_599264, JString, required = false,
                                 default = nil)
  if valid_599264 != nil:
    section.add "key", valid_599264
  var valid_599265 = query.getOrDefault("prettyPrint")
  valid_599265 = validateParameter(valid_599265, JBool, required = false,
                                 default = newJBool(true))
  if valid_599265 != nil:
    section.add "prettyPrint", valid_599265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599266: Call_DirectoryGroupsAliasesList_599255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all aliases for a group
  ## 
  let valid = call_599266.validator(path, query, header, formData, body)
  let scheme = call_599266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599266.url(scheme.get, call_599266.host, call_599266.base,
                         call_599266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599266, url, valid)

proc call*(call_599267: Call_DirectoryGroupsAliasesList_599255; groupKey: string;
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
  var path_599268 = newJObject()
  var query_599269 = newJObject()
  add(query_599269, "fields", newJString(fields))
  add(query_599269, "quotaUser", newJString(quotaUser))
  add(query_599269, "alt", newJString(alt))
  add(query_599269, "oauth_token", newJString(oauthToken))
  add(query_599269, "userIp", newJString(userIp))
  add(query_599269, "key", newJString(key))
  add(query_599269, "prettyPrint", newJBool(prettyPrint))
  add(path_599268, "groupKey", newJString(groupKey))
  result = call_599267.call(path_599268, query_599269, nil, nil, nil)

var directoryGroupsAliasesList* = Call_DirectoryGroupsAliasesList_599255(
    name: "directoryGroupsAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases",
    validator: validate_DirectoryGroupsAliasesList_599256,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesList_599257,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesDelete_599287 = ref object of OpenApiRestCall_597437
proc url_DirectoryGroupsAliasesDelete_599289(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryGroupsAliasesDelete_599288(path: JsonNode; query: JsonNode;
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
  var valid_599290 = path.getOrDefault("groupKey")
  valid_599290 = validateParameter(valid_599290, JString, required = true,
                                 default = nil)
  if valid_599290 != nil:
    section.add "groupKey", valid_599290
  var valid_599291 = path.getOrDefault("alias")
  valid_599291 = validateParameter(valid_599291, JString, required = true,
                                 default = nil)
  if valid_599291 != nil:
    section.add "alias", valid_599291
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
  var valid_599292 = query.getOrDefault("fields")
  valid_599292 = validateParameter(valid_599292, JString, required = false,
                                 default = nil)
  if valid_599292 != nil:
    section.add "fields", valid_599292
  var valid_599293 = query.getOrDefault("quotaUser")
  valid_599293 = validateParameter(valid_599293, JString, required = false,
                                 default = nil)
  if valid_599293 != nil:
    section.add "quotaUser", valid_599293
  var valid_599294 = query.getOrDefault("alt")
  valid_599294 = validateParameter(valid_599294, JString, required = false,
                                 default = newJString("json"))
  if valid_599294 != nil:
    section.add "alt", valid_599294
  var valid_599295 = query.getOrDefault("oauth_token")
  valid_599295 = validateParameter(valid_599295, JString, required = false,
                                 default = nil)
  if valid_599295 != nil:
    section.add "oauth_token", valid_599295
  var valid_599296 = query.getOrDefault("userIp")
  valid_599296 = validateParameter(valid_599296, JString, required = false,
                                 default = nil)
  if valid_599296 != nil:
    section.add "userIp", valid_599296
  var valid_599297 = query.getOrDefault("key")
  valid_599297 = validateParameter(valid_599297, JString, required = false,
                                 default = nil)
  if valid_599297 != nil:
    section.add "key", valid_599297
  var valid_599298 = query.getOrDefault("prettyPrint")
  valid_599298 = validateParameter(valid_599298, JBool, required = false,
                                 default = newJBool(true))
  if valid_599298 != nil:
    section.add "prettyPrint", valid_599298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599299: Call_DirectoryGroupsAliasesDelete_599287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a alias for the group
  ## 
  let valid = call_599299.validator(path, query, header, formData, body)
  let scheme = call_599299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599299.url(scheme.get, call_599299.host, call_599299.base,
                         call_599299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599299, url, valid)

proc call*(call_599300: Call_DirectoryGroupsAliasesDelete_599287; groupKey: string;
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
  var path_599301 = newJObject()
  var query_599302 = newJObject()
  add(query_599302, "fields", newJString(fields))
  add(query_599302, "quotaUser", newJString(quotaUser))
  add(query_599302, "alt", newJString(alt))
  add(query_599302, "oauth_token", newJString(oauthToken))
  add(query_599302, "userIp", newJString(userIp))
  add(query_599302, "key", newJString(key))
  add(query_599302, "prettyPrint", newJBool(prettyPrint))
  add(path_599301, "groupKey", newJString(groupKey))
  add(path_599301, "alias", newJString(alias))
  result = call_599300.call(path_599301, query_599302, nil, nil, nil)

var directoryGroupsAliasesDelete* = Call_DirectoryGroupsAliasesDelete_599287(
    name: "directoryGroupsAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases/{alias}",
    validator: validate_DirectoryGroupsAliasesDelete_599288,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesDelete_599289,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersHasMember_599303 = ref object of OpenApiRestCall_597437
proc url_DirectoryMembersHasMember_599305(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryMembersHasMember_599304(path: JsonNode; query: JsonNode;
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
  var valid_599306 = path.getOrDefault("memberKey")
  valid_599306 = validateParameter(valid_599306, JString, required = true,
                                 default = nil)
  if valid_599306 != nil:
    section.add "memberKey", valid_599306
  var valid_599307 = path.getOrDefault("groupKey")
  valid_599307 = validateParameter(valid_599307, JString, required = true,
                                 default = nil)
  if valid_599307 != nil:
    section.add "groupKey", valid_599307
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
  var valid_599308 = query.getOrDefault("fields")
  valid_599308 = validateParameter(valid_599308, JString, required = false,
                                 default = nil)
  if valid_599308 != nil:
    section.add "fields", valid_599308
  var valid_599309 = query.getOrDefault("quotaUser")
  valid_599309 = validateParameter(valid_599309, JString, required = false,
                                 default = nil)
  if valid_599309 != nil:
    section.add "quotaUser", valid_599309
  var valid_599310 = query.getOrDefault("alt")
  valid_599310 = validateParameter(valid_599310, JString, required = false,
                                 default = newJString("json"))
  if valid_599310 != nil:
    section.add "alt", valid_599310
  var valid_599311 = query.getOrDefault("oauth_token")
  valid_599311 = validateParameter(valid_599311, JString, required = false,
                                 default = nil)
  if valid_599311 != nil:
    section.add "oauth_token", valid_599311
  var valid_599312 = query.getOrDefault("userIp")
  valid_599312 = validateParameter(valid_599312, JString, required = false,
                                 default = nil)
  if valid_599312 != nil:
    section.add "userIp", valid_599312
  var valid_599313 = query.getOrDefault("key")
  valid_599313 = validateParameter(valid_599313, JString, required = false,
                                 default = nil)
  if valid_599313 != nil:
    section.add "key", valid_599313
  var valid_599314 = query.getOrDefault("prettyPrint")
  valid_599314 = validateParameter(valid_599314, JBool, required = false,
                                 default = newJBool(true))
  if valid_599314 != nil:
    section.add "prettyPrint", valid_599314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599315: Call_DirectoryMembersHasMember_599303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the given user is a member of the group. Membership can be direct or nested.
  ## 
  let valid = call_599315.validator(path, query, header, formData, body)
  let scheme = call_599315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599315.url(scheme.get, call_599315.host, call_599315.base,
                         call_599315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599315, url, valid)

proc call*(call_599316: Call_DirectoryMembersHasMember_599303; memberKey: string;
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
  var path_599317 = newJObject()
  var query_599318 = newJObject()
  add(query_599318, "fields", newJString(fields))
  add(query_599318, "quotaUser", newJString(quotaUser))
  add(query_599318, "alt", newJString(alt))
  add(query_599318, "oauth_token", newJString(oauthToken))
  add(query_599318, "userIp", newJString(userIp))
  add(path_599317, "memberKey", newJString(memberKey))
  add(query_599318, "key", newJString(key))
  add(query_599318, "prettyPrint", newJBool(prettyPrint))
  add(path_599317, "groupKey", newJString(groupKey))
  result = call_599316.call(path_599317, query_599318, nil, nil, nil)

var directoryMembersHasMember* = Call_DirectoryMembersHasMember_599303(
    name: "directoryMembersHasMember", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/hasMember/{memberKey}",
    validator: validate_DirectoryMembersHasMember_599304,
    base: "/admin/directory/v1", url: url_DirectoryMembersHasMember_599305,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersInsert_599338 = ref object of OpenApiRestCall_597437
proc url_DirectoryMembersInsert_599340(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryMembersInsert_599339(path: JsonNode; query: JsonNode;
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
  var valid_599341 = path.getOrDefault("groupKey")
  valid_599341 = validateParameter(valid_599341, JString, required = true,
                                 default = nil)
  if valid_599341 != nil:
    section.add "groupKey", valid_599341
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
  var valid_599342 = query.getOrDefault("fields")
  valid_599342 = validateParameter(valid_599342, JString, required = false,
                                 default = nil)
  if valid_599342 != nil:
    section.add "fields", valid_599342
  var valid_599343 = query.getOrDefault("quotaUser")
  valid_599343 = validateParameter(valid_599343, JString, required = false,
                                 default = nil)
  if valid_599343 != nil:
    section.add "quotaUser", valid_599343
  var valid_599344 = query.getOrDefault("alt")
  valid_599344 = validateParameter(valid_599344, JString, required = false,
                                 default = newJString("json"))
  if valid_599344 != nil:
    section.add "alt", valid_599344
  var valid_599345 = query.getOrDefault("oauth_token")
  valid_599345 = validateParameter(valid_599345, JString, required = false,
                                 default = nil)
  if valid_599345 != nil:
    section.add "oauth_token", valid_599345
  var valid_599346 = query.getOrDefault("userIp")
  valid_599346 = validateParameter(valid_599346, JString, required = false,
                                 default = nil)
  if valid_599346 != nil:
    section.add "userIp", valid_599346
  var valid_599347 = query.getOrDefault("key")
  valid_599347 = validateParameter(valid_599347, JString, required = false,
                                 default = nil)
  if valid_599347 != nil:
    section.add "key", valid_599347
  var valid_599348 = query.getOrDefault("prettyPrint")
  valid_599348 = validateParameter(valid_599348, JBool, required = false,
                                 default = newJBool(true))
  if valid_599348 != nil:
    section.add "prettyPrint", valid_599348
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

proc call*(call_599350: Call_DirectoryMembersInsert_599338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add user to the specified group.
  ## 
  let valid = call_599350.validator(path, query, header, formData, body)
  let scheme = call_599350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599350.url(scheme.get, call_599350.host, call_599350.base,
                         call_599350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599350, url, valid)

proc call*(call_599351: Call_DirectoryMembersInsert_599338; groupKey: string;
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
  var path_599352 = newJObject()
  var query_599353 = newJObject()
  var body_599354 = newJObject()
  add(query_599353, "fields", newJString(fields))
  add(query_599353, "quotaUser", newJString(quotaUser))
  add(query_599353, "alt", newJString(alt))
  add(query_599353, "oauth_token", newJString(oauthToken))
  add(query_599353, "userIp", newJString(userIp))
  add(query_599353, "key", newJString(key))
  if body != nil:
    body_599354 = body
  add(query_599353, "prettyPrint", newJBool(prettyPrint))
  add(path_599352, "groupKey", newJString(groupKey))
  result = call_599351.call(path_599352, query_599353, nil, nil, body_599354)

var directoryMembersInsert* = Call_DirectoryMembersInsert_599338(
    name: "directoryMembersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members",
    validator: validate_DirectoryMembersInsert_599339,
    base: "/admin/directory/v1", url: url_DirectoryMembersInsert_599340,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersList_599319 = ref object of OpenApiRestCall_597437
proc url_DirectoryMembersList_599321(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryMembersList_599320(path: JsonNode; query: JsonNode;
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
  var valid_599322 = path.getOrDefault("groupKey")
  valid_599322 = validateParameter(valid_599322, JString, required = true,
                                 default = nil)
  if valid_599322 != nil:
    section.add "groupKey", valid_599322
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
  var valid_599323 = query.getOrDefault("fields")
  valid_599323 = validateParameter(valid_599323, JString, required = false,
                                 default = nil)
  if valid_599323 != nil:
    section.add "fields", valid_599323
  var valid_599324 = query.getOrDefault("pageToken")
  valid_599324 = validateParameter(valid_599324, JString, required = false,
                                 default = nil)
  if valid_599324 != nil:
    section.add "pageToken", valid_599324
  var valid_599325 = query.getOrDefault("quotaUser")
  valid_599325 = validateParameter(valid_599325, JString, required = false,
                                 default = nil)
  if valid_599325 != nil:
    section.add "quotaUser", valid_599325
  var valid_599326 = query.getOrDefault("includeDerivedMembership")
  valid_599326 = validateParameter(valid_599326, JBool, required = false, default = nil)
  if valid_599326 != nil:
    section.add "includeDerivedMembership", valid_599326
  var valid_599327 = query.getOrDefault("roles")
  valid_599327 = validateParameter(valid_599327, JString, required = false,
                                 default = nil)
  if valid_599327 != nil:
    section.add "roles", valid_599327
  var valid_599328 = query.getOrDefault("alt")
  valid_599328 = validateParameter(valid_599328, JString, required = false,
                                 default = newJString("json"))
  if valid_599328 != nil:
    section.add "alt", valid_599328
  var valid_599329 = query.getOrDefault("oauth_token")
  valid_599329 = validateParameter(valid_599329, JString, required = false,
                                 default = nil)
  if valid_599329 != nil:
    section.add "oauth_token", valid_599329
  var valid_599330 = query.getOrDefault("userIp")
  valid_599330 = validateParameter(valid_599330, JString, required = false,
                                 default = nil)
  if valid_599330 != nil:
    section.add "userIp", valid_599330
  var valid_599331 = query.getOrDefault("maxResults")
  valid_599331 = validateParameter(valid_599331, JInt, required = false,
                                 default = newJInt(200))
  if valid_599331 != nil:
    section.add "maxResults", valid_599331
  var valid_599332 = query.getOrDefault("key")
  valid_599332 = validateParameter(valid_599332, JString, required = false,
                                 default = nil)
  if valid_599332 != nil:
    section.add "key", valid_599332
  var valid_599333 = query.getOrDefault("prettyPrint")
  valid_599333 = validateParameter(valid_599333, JBool, required = false,
                                 default = newJBool(true))
  if valid_599333 != nil:
    section.add "prettyPrint", valid_599333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599334: Call_DirectoryMembersList_599319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all members in a group (paginated)
  ## 
  let valid = call_599334.validator(path, query, header, formData, body)
  let scheme = call_599334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599334.url(scheme.get, call_599334.host, call_599334.base,
                         call_599334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599334, url, valid)

proc call*(call_599335: Call_DirectoryMembersList_599319; groupKey: string;
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
  var path_599336 = newJObject()
  var query_599337 = newJObject()
  add(query_599337, "fields", newJString(fields))
  add(query_599337, "pageToken", newJString(pageToken))
  add(query_599337, "quotaUser", newJString(quotaUser))
  add(query_599337, "includeDerivedMembership", newJBool(includeDerivedMembership))
  add(query_599337, "roles", newJString(roles))
  add(query_599337, "alt", newJString(alt))
  add(query_599337, "oauth_token", newJString(oauthToken))
  add(query_599337, "userIp", newJString(userIp))
  add(query_599337, "maxResults", newJInt(maxResults))
  add(query_599337, "key", newJString(key))
  add(query_599337, "prettyPrint", newJBool(prettyPrint))
  add(path_599336, "groupKey", newJString(groupKey))
  result = call_599335.call(path_599336, query_599337, nil, nil, nil)

var directoryMembersList* = Call_DirectoryMembersList_599319(
    name: "directoryMembersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members",
    validator: validate_DirectoryMembersList_599320, base: "/admin/directory/v1",
    url: url_DirectoryMembersList_599321, schemes: {Scheme.Https})
type
  Call_DirectoryMembersUpdate_599371 = ref object of OpenApiRestCall_597437
proc url_DirectoryMembersUpdate_599373(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryMembersUpdate_599372(path: JsonNode; query: JsonNode;
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
  var valid_599374 = path.getOrDefault("memberKey")
  valid_599374 = validateParameter(valid_599374, JString, required = true,
                                 default = nil)
  if valid_599374 != nil:
    section.add "memberKey", valid_599374
  var valid_599375 = path.getOrDefault("groupKey")
  valid_599375 = validateParameter(valid_599375, JString, required = true,
                                 default = nil)
  if valid_599375 != nil:
    section.add "groupKey", valid_599375
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
  var valid_599376 = query.getOrDefault("fields")
  valid_599376 = validateParameter(valid_599376, JString, required = false,
                                 default = nil)
  if valid_599376 != nil:
    section.add "fields", valid_599376
  var valid_599377 = query.getOrDefault("quotaUser")
  valid_599377 = validateParameter(valid_599377, JString, required = false,
                                 default = nil)
  if valid_599377 != nil:
    section.add "quotaUser", valid_599377
  var valid_599378 = query.getOrDefault("alt")
  valid_599378 = validateParameter(valid_599378, JString, required = false,
                                 default = newJString("json"))
  if valid_599378 != nil:
    section.add "alt", valid_599378
  var valid_599379 = query.getOrDefault("oauth_token")
  valid_599379 = validateParameter(valid_599379, JString, required = false,
                                 default = nil)
  if valid_599379 != nil:
    section.add "oauth_token", valid_599379
  var valid_599380 = query.getOrDefault("userIp")
  valid_599380 = validateParameter(valid_599380, JString, required = false,
                                 default = nil)
  if valid_599380 != nil:
    section.add "userIp", valid_599380
  var valid_599381 = query.getOrDefault("key")
  valid_599381 = validateParameter(valid_599381, JString, required = false,
                                 default = nil)
  if valid_599381 != nil:
    section.add "key", valid_599381
  var valid_599382 = query.getOrDefault("prettyPrint")
  valid_599382 = validateParameter(valid_599382, JBool, required = false,
                                 default = newJBool(true))
  if valid_599382 != nil:
    section.add "prettyPrint", valid_599382
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

proc call*(call_599384: Call_DirectoryMembersUpdate_599371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update membership of a user in the specified group.
  ## 
  let valid = call_599384.validator(path, query, header, formData, body)
  let scheme = call_599384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599384.url(scheme.get, call_599384.host, call_599384.base,
                         call_599384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599384, url, valid)

proc call*(call_599385: Call_DirectoryMembersUpdate_599371; memberKey: string;
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
  var path_599386 = newJObject()
  var query_599387 = newJObject()
  var body_599388 = newJObject()
  add(query_599387, "fields", newJString(fields))
  add(query_599387, "quotaUser", newJString(quotaUser))
  add(query_599387, "alt", newJString(alt))
  add(query_599387, "oauth_token", newJString(oauthToken))
  add(query_599387, "userIp", newJString(userIp))
  add(path_599386, "memberKey", newJString(memberKey))
  add(query_599387, "key", newJString(key))
  if body != nil:
    body_599388 = body
  add(query_599387, "prettyPrint", newJBool(prettyPrint))
  add(path_599386, "groupKey", newJString(groupKey))
  result = call_599385.call(path_599386, query_599387, nil, nil, body_599388)

var directoryMembersUpdate* = Call_DirectoryMembersUpdate_599371(
    name: "directoryMembersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersUpdate_599372,
    base: "/admin/directory/v1", url: url_DirectoryMembersUpdate_599373,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersGet_599355 = ref object of OpenApiRestCall_597437
proc url_DirectoryMembersGet_599357(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryMembersGet_599356(path: JsonNode; query: JsonNode;
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
  var valid_599358 = path.getOrDefault("memberKey")
  valid_599358 = validateParameter(valid_599358, JString, required = true,
                                 default = nil)
  if valid_599358 != nil:
    section.add "memberKey", valid_599358
  var valid_599359 = path.getOrDefault("groupKey")
  valid_599359 = validateParameter(valid_599359, JString, required = true,
                                 default = nil)
  if valid_599359 != nil:
    section.add "groupKey", valid_599359
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
  var valid_599360 = query.getOrDefault("fields")
  valid_599360 = validateParameter(valid_599360, JString, required = false,
                                 default = nil)
  if valid_599360 != nil:
    section.add "fields", valid_599360
  var valid_599361 = query.getOrDefault("quotaUser")
  valid_599361 = validateParameter(valid_599361, JString, required = false,
                                 default = nil)
  if valid_599361 != nil:
    section.add "quotaUser", valid_599361
  var valid_599362 = query.getOrDefault("alt")
  valid_599362 = validateParameter(valid_599362, JString, required = false,
                                 default = newJString("json"))
  if valid_599362 != nil:
    section.add "alt", valid_599362
  var valid_599363 = query.getOrDefault("oauth_token")
  valid_599363 = validateParameter(valid_599363, JString, required = false,
                                 default = nil)
  if valid_599363 != nil:
    section.add "oauth_token", valid_599363
  var valid_599364 = query.getOrDefault("userIp")
  valid_599364 = validateParameter(valid_599364, JString, required = false,
                                 default = nil)
  if valid_599364 != nil:
    section.add "userIp", valid_599364
  var valid_599365 = query.getOrDefault("key")
  valid_599365 = validateParameter(valid_599365, JString, required = false,
                                 default = nil)
  if valid_599365 != nil:
    section.add "key", valid_599365
  var valid_599366 = query.getOrDefault("prettyPrint")
  valid_599366 = validateParameter(valid_599366, JBool, required = false,
                                 default = newJBool(true))
  if valid_599366 != nil:
    section.add "prettyPrint", valid_599366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599367: Call_DirectoryMembersGet_599355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Group Member
  ## 
  let valid = call_599367.validator(path, query, header, formData, body)
  let scheme = call_599367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599367.url(scheme.get, call_599367.host, call_599367.base,
                         call_599367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599367, url, valid)

proc call*(call_599368: Call_DirectoryMembersGet_599355; memberKey: string;
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
  var path_599369 = newJObject()
  var query_599370 = newJObject()
  add(query_599370, "fields", newJString(fields))
  add(query_599370, "quotaUser", newJString(quotaUser))
  add(query_599370, "alt", newJString(alt))
  add(query_599370, "oauth_token", newJString(oauthToken))
  add(query_599370, "userIp", newJString(userIp))
  add(path_599369, "memberKey", newJString(memberKey))
  add(query_599370, "key", newJString(key))
  add(query_599370, "prettyPrint", newJBool(prettyPrint))
  add(path_599369, "groupKey", newJString(groupKey))
  result = call_599368.call(path_599369, query_599370, nil, nil, nil)

var directoryMembersGet* = Call_DirectoryMembersGet_599355(
    name: "directoryMembersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersGet_599356, base: "/admin/directory/v1",
    url: url_DirectoryMembersGet_599357, schemes: {Scheme.Https})
type
  Call_DirectoryMembersPatch_599405 = ref object of OpenApiRestCall_597437
proc url_DirectoryMembersPatch_599407(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryMembersPatch_599406(path: JsonNode; query: JsonNode;
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
  var valid_599408 = path.getOrDefault("memberKey")
  valid_599408 = validateParameter(valid_599408, JString, required = true,
                                 default = nil)
  if valid_599408 != nil:
    section.add "memberKey", valid_599408
  var valid_599409 = path.getOrDefault("groupKey")
  valid_599409 = validateParameter(valid_599409, JString, required = true,
                                 default = nil)
  if valid_599409 != nil:
    section.add "groupKey", valid_599409
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
  var valid_599410 = query.getOrDefault("fields")
  valid_599410 = validateParameter(valid_599410, JString, required = false,
                                 default = nil)
  if valid_599410 != nil:
    section.add "fields", valid_599410
  var valid_599411 = query.getOrDefault("quotaUser")
  valid_599411 = validateParameter(valid_599411, JString, required = false,
                                 default = nil)
  if valid_599411 != nil:
    section.add "quotaUser", valid_599411
  var valid_599412 = query.getOrDefault("alt")
  valid_599412 = validateParameter(valid_599412, JString, required = false,
                                 default = newJString("json"))
  if valid_599412 != nil:
    section.add "alt", valid_599412
  var valid_599413 = query.getOrDefault("oauth_token")
  valid_599413 = validateParameter(valid_599413, JString, required = false,
                                 default = nil)
  if valid_599413 != nil:
    section.add "oauth_token", valid_599413
  var valid_599414 = query.getOrDefault("userIp")
  valid_599414 = validateParameter(valid_599414, JString, required = false,
                                 default = nil)
  if valid_599414 != nil:
    section.add "userIp", valid_599414
  var valid_599415 = query.getOrDefault("key")
  valid_599415 = validateParameter(valid_599415, JString, required = false,
                                 default = nil)
  if valid_599415 != nil:
    section.add "key", valid_599415
  var valid_599416 = query.getOrDefault("prettyPrint")
  valid_599416 = validateParameter(valid_599416, JBool, required = false,
                                 default = newJBool(true))
  if valid_599416 != nil:
    section.add "prettyPrint", valid_599416
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

proc call*(call_599418: Call_DirectoryMembersPatch_599405; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update membership of a user in the specified group. This method supports patch semantics.
  ## 
  let valid = call_599418.validator(path, query, header, formData, body)
  let scheme = call_599418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599418.url(scheme.get, call_599418.host, call_599418.base,
                         call_599418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599418, url, valid)

proc call*(call_599419: Call_DirectoryMembersPatch_599405; memberKey: string;
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
  var path_599420 = newJObject()
  var query_599421 = newJObject()
  var body_599422 = newJObject()
  add(query_599421, "fields", newJString(fields))
  add(query_599421, "quotaUser", newJString(quotaUser))
  add(query_599421, "alt", newJString(alt))
  add(query_599421, "oauth_token", newJString(oauthToken))
  add(query_599421, "userIp", newJString(userIp))
  add(path_599420, "memberKey", newJString(memberKey))
  add(query_599421, "key", newJString(key))
  if body != nil:
    body_599422 = body
  add(query_599421, "prettyPrint", newJBool(prettyPrint))
  add(path_599420, "groupKey", newJString(groupKey))
  result = call_599419.call(path_599420, query_599421, nil, nil, body_599422)

var directoryMembersPatch* = Call_DirectoryMembersPatch_599405(
    name: "directoryMembersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersPatch_599406, base: "/admin/directory/v1",
    url: url_DirectoryMembersPatch_599407, schemes: {Scheme.Https})
type
  Call_DirectoryMembersDelete_599389 = ref object of OpenApiRestCall_597437
proc url_DirectoryMembersDelete_599391(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryMembersDelete_599390(path: JsonNode; query: JsonNode;
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
  var valid_599392 = path.getOrDefault("memberKey")
  valid_599392 = validateParameter(valid_599392, JString, required = true,
                                 default = nil)
  if valid_599392 != nil:
    section.add "memberKey", valid_599392
  var valid_599393 = path.getOrDefault("groupKey")
  valid_599393 = validateParameter(valid_599393, JString, required = true,
                                 default = nil)
  if valid_599393 != nil:
    section.add "groupKey", valid_599393
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
  var valid_599394 = query.getOrDefault("fields")
  valid_599394 = validateParameter(valid_599394, JString, required = false,
                                 default = nil)
  if valid_599394 != nil:
    section.add "fields", valid_599394
  var valid_599395 = query.getOrDefault("quotaUser")
  valid_599395 = validateParameter(valid_599395, JString, required = false,
                                 default = nil)
  if valid_599395 != nil:
    section.add "quotaUser", valid_599395
  var valid_599396 = query.getOrDefault("alt")
  valid_599396 = validateParameter(valid_599396, JString, required = false,
                                 default = newJString("json"))
  if valid_599396 != nil:
    section.add "alt", valid_599396
  var valid_599397 = query.getOrDefault("oauth_token")
  valid_599397 = validateParameter(valid_599397, JString, required = false,
                                 default = nil)
  if valid_599397 != nil:
    section.add "oauth_token", valid_599397
  var valid_599398 = query.getOrDefault("userIp")
  valid_599398 = validateParameter(valid_599398, JString, required = false,
                                 default = nil)
  if valid_599398 != nil:
    section.add "userIp", valid_599398
  var valid_599399 = query.getOrDefault("key")
  valid_599399 = validateParameter(valid_599399, JString, required = false,
                                 default = nil)
  if valid_599399 != nil:
    section.add "key", valid_599399
  var valid_599400 = query.getOrDefault("prettyPrint")
  valid_599400 = validateParameter(valid_599400, JBool, required = false,
                                 default = newJBool(true))
  if valid_599400 != nil:
    section.add "prettyPrint", valid_599400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599401: Call_DirectoryMembersDelete_599389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove membership.
  ## 
  let valid = call_599401.validator(path, query, header, formData, body)
  let scheme = call_599401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599401.url(scheme.get, call_599401.host, call_599401.base,
                         call_599401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599401, url, valid)

proc call*(call_599402: Call_DirectoryMembersDelete_599389; memberKey: string;
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
  var path_599403 = newJObject()
  var query_599404 = newJObject()
  add(query_599404, "fields", newJString(fields))
  add(query_599404, "quotaUser", newJString(quotaUser))
  add(query_599404, "alt", newJString(alt))
  add(query_599404, "oauth_token", newJString(oauthToken))
  add(query_599404, "userIp", newJString(userIp))
  add(path_599403, "memberKey", newJString(memberKey))
  add(query_599404, "key", newJString(key))
  add(query_599404, "prettyPrint", newJBool(prettyPrint))
  add(path_599403, "groupKey", newJString(groupKey))
  result = call_599402.call(path_599403, query_599404, nil, nil, nil)

var directoryMembersDelete* = Call_DirectoryMembersDelete_599389(
    name: "directoryMembersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersDelete_599390,
    base: "/admin/directory/v1", url: url_DirectoryMembersDelete_599391,
    schemes: {Scheme.Https})
type
  Call_DirectoryResolvedAppAccessSettingsGetSettings_599423 = ref object of OpenApiRestCall_597437
proc url_DirectoryResolvedAppAccessSettingsGetSettings_599425(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DirectoryResolvedAppAccessSettingsGetSettings_599424(
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
  var valid_599426 = query.getOrDefault("fields")
  valid_599426 = validateParameter(valid_599426, JString, required = false,
                                 default = nil)
  if valid_599426 != nil:
    section.add "fields", valid_599426
  var valid_599427 = query.getOrDefault("quotaUser")
  valid_599427 = validateParameter(valid_599427, JString, required = false,
                                 default = nil)
  if valid_599427 != nil:
    section.add "quotaUser", valid_599427
  var valid_599428 = query.getOrDefault("alt")
  valid_599428 = validateParameter(valid_599428, JString, required = false,
                                 default = newJString("json"))
  if valid_599428 != nil:
    section.add "alt", valid_599428
  var valid_599429 = query.getOrDefault("oauth_token")
  valid_599429 = validateParameter(valid_599429, JString, required = false,
                                 default = nil)
  if valid_599429 != nil:
    section.add "oauth_token", valid_599429
  var valid_599430 = query.getOrDefault("userIp")
  valid_599430 = validateParameter(valid_599430, JString, required = false,
                                 default = nil)
  if valid_599430 != nil:
    section.add "userIp", valid_599430
  var valid_599431 = query.getOrDefault("key")
  valid_599431 = validateParameter(valid_599431, JString, required = false,
                                 default = nil)
  if valid_599431 != nil:
    section.add "key", valid_599431
  var valid_599432 = query.getOrDefault("prettyPrint")
  valid_599432 = validateParameter(valid_599432, JBool, required = false,
                                 default = newJBool(true))
  if valid_599432 != nil:
    section.add "prettyPrint", valid_599432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599433: Call_DirectoryResolvedAppAccessSettingsGetSettings_599423;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves resolved app access settings of the logged in user.
  ## 
  let valid = call_599433.validator(path, query, header, formData, body)
  let scheme = call_599433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599433.url(scheme.get, call_599433.host, call_599433.base,
                         call_599433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599433, url, valid)

proc call*(call_599434: Call_DirectoryResolvedAppAccessSettingsGetSettings_599423;
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
  var query_599435 = newJObject()
  add(query_599435, "fields", newJString(fields))
  add(query_599435, "quotaUser", newJString(quotaUser))
  add(query_599435, "alt", newJString(alt))
  add(query_599435, "oauth_token", newJString(oauthToken))
  add(query_599435, "userIp", newJString(userIp))
  add(query_599435, "key", newJString(key))
  add(query_599435, "prettyPrint", newJBool(prettyPrint))
  result = call_599434.call(nil, query_599435, nil, nil, nil)

var directoryResolvedAppAccessSettingsGetSettings* = Call_DirectoryResolvedAppAccessSettingsGetSettings_599423(
    name: "directoryResolvedAppAccessSettingsGetSettings",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/resolvedappaccesssettings",
    validator: validate_DirectoryResolvedAppAccessSettingsGetSettings_599424,
    base: "/admin/directory/v1",
    url: url_DirectoryResolvedAppAccessSettingsGetSettings_599425,
    schemes: {Scheme.Https})
type
  Call_DirectoryResolvedAppAccessSettingsListTrustedApps_599436 = ref object of OpenApiRestCall_597437
proc url_DirectoryResolvedAppAccessSettingsListTrustedApps_599438(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DirectoryResolvedAppAccessSettingsListTrustedApps_599437(
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
  var valid_599439 = query.getOrDefault("fields")
  valid_599439 = validateParameter(valid_599439, JString, required = false,
                                 default = nil)
  if valid_599439 != nil:
    section.add "fields", valid_599439
  var valid_599440 = query.getOrDefault("quotaUser")
  valid_599440 = validateParameter(valid_599440, JString, required = false,
                                 default = nil)
  if valid_599440 != nil:
    section.add "quotaUser", valid_599440
  var valid_599441 = query.getOrDefault("alt")
  valid_599441 = validateParameter(valid_599441, JString, required = false,
                                 default = newJString("json"))
  if valid_599441 != nil:
    section.add "alt", valid_599441
  var valid_599442 = query.getOrDefault("oauth_token")
  valid_599442 = validateParameter(valid_599442, JString, required = false,
                                 default = nil)
  if valid_599442 != nil:
    section.add "oauth_token", valid_599442
  var valid_599443 = query.getOrDefault("userIp")
  valid_599443 = validateParameter(valid_599443, JString, required = false,
                                 default = nil)
  if valid_599443 != nil:
    section.add "userIp", valid_599443
  var valid_599444 = query.getOrDefault("key")
  valid_599444 = validateParameter(valid_599444, JString, required = false,
                                 default = nil)
  if valid_599444 != nil:
    section.add "key", valid_599444
  var valid_599445 = query.getOrDefault("prettyPrint")
  valid_599445 = validateParameter(valid_599445, JBool, required = false,
                                 default = newJBool(true))
  if valid_599445 != nil:
    section.add "prettyPrint", valid_599445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599446: Call_DirectoryResolvedAppAccessSettingsListTrustedApps_599436;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of apps trusted by the admin of the logged in user.
  ## 
  let valid = call_599446.validator(path, query, header, formData, body)
  let scheme = call_599446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599446.url(scheme.get, call_599446.host, call_599446.base,
                         call_599446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599446, url, valid)

proc call*(call_599447: Call_DirectoryResolvedAppAccessSettingsListTrustedApps_599436;
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
  var query_599448 = newJObject()
  add(query_599448, "fields", newJString(fields))
  add(query_599448, "quotaUser", newJString(quotaUser))
  add(query_599448, "alt", newJString(alt))
  add(query_599448, "oauth_token", newJString(oauthToken))
  add(query_599448, "userIp", newJString(userIp))
  add(query_599448, "key", newJString(key))
  add(query_599448, "prettyPrint", newJBool(prettyPrint))
  result = call_599447.call(nil, query_599448, nil, nil, nil)

var directoryResolvedAppAccessSettingsListTrustedApps* = Call_DirectoryResolvedAppAccessSettingsListTrustedApps_599436(
    name: "directoryResolvedAppAccessSettingsListTrustedApps",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/trustedapps",
    validator: validate_DirectoryResolvedAppAccessSettingsListTrustedApps_599437,
    base: "/admin/directory/v1",
    url: url_DirectoryResolvedAppAccessSettingsListTrustedApps_599438,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersInsert_599474 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersInsert_599476(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DirectoryUsersInsert_599475(path: JsonNode; query: JsonNode;
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
  var valid_599477 = query.getOrDefault("fields")
  valid_599477 = validateParameter(valid_599477, JString, required = false,
                                 default = nil)
  if valid_599477 != nil:
    section.add "fields", valid_599477
  var valid_599478 = query.getOrDefault("quotaUser")
  valid_599478 = validateParameter(valid_599478, JString, required = false,
                                 default = nil)
  if valid_599478 != nil:
    section.add "quotaUser", valid_599478
  var valid_599479 = query.getOrDefault("alt")
  valid_599479 = validateParameter(valid_599479, JString, required = false,
                                 default = newJString("json"))
  if valid_599479 != nil:
    section.add "alt", valid_599479
  var valid_599480 = query.getOrDefault("oauth_token")
  valid_599480 = validateParameter(valid_599480, JString, required = false,
                                 default = nil)
  if valid_599480 != nil:
    section.add "oauth_token", valid_599480
  var valid_599481 = query.getOrDefault("userIp")
  valid_599481 = validateParameter(valid_599481, JString, required = false,
                                 default = nil)
  if valid_599481 != nil:
    section.add "userIp", valid_599481
  var valid_599482 = query.getOrDefault("key")
  valid_599482 = validateParameter(valid_599482, JString, required = false,
                                 default = nil)
  if valid_599482 != nil:
    section.add "key", valid_599482
  var valid_599483 = query.getOrDefault("prettyPrint")
  valid_599483 = validateParameter(valid_599483, JBool, required = false,
                                 default = newJBool(true))
  if valid_599483 != nil:
    section.add "prettyPrint", valid_599483
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

proc call*(call_599485: Call_DirectoryUsersInsert_599474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## create user.
  ## 
  let valid = call_599485.validator(path, query, header, formData, body)
  let scheme = call_599485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599485.url(scheme.get, call_599485.host, call_599485.base,
                         call_599485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599485, url, valid)

proc call*(call_599486: Call_DirectoryUsersInsert_599474; fields: string = "";
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
  var query_599487 = newJObject()
  var body_599488 = newJObject()
  add(query_599487, "fields", newJString(fields))
  add(query_599487, "quotaUser", newJString(quotaUser))
  add(query_599487, "alt", newJString(alt))
  add(query_599487, "oauth_token", newJString(oauthToken))
  add(query_599487, "userIp", newJString(userIp))
  add(query_599487, "key", newJString(key))
  if body != nil:
    body_599488 = body
  add(query_599487, "prettyPrint", newJBool(prettyPrint))
  result = call_599486.call(nil, query_599487, nil, nil, body_599488)

var directoryUsersInsert* = Call_DirectoryUsersInsert_599474(
    name: "directoryUsersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users",
    validator: validate_DirectoryUsersInsert_599475, base: "/admin/directory/v1",
    url: url_DirectoryUsersInsert_599476, schemes: {Scheme.Https})
type
  Call_DirectoryUsersList_599449 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersList_599451(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DirectoryUsersList_599450(path: JsonNode; query: JsonNode;
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
  var valid_599452 = query.getOrDefault("fields")
  valid_599452 = validateParameter(valid_599452, JString, required = false,
                                 default = nil)
  if valid_599452 != nil:
    section.add "fields", valid_599452
  var valid_599453 = query.getOrDefault("pageToken")
  valid_599453 = validateParameter(valid_599453, JString, required = false,
                                 default = nil)
  if valid_599453 != nil:
    section.add "pageToken", valid_599453
  var valid_599454 = query.getOrDefault("quotaUser")
  valid_599454 = validateParameter(valid_599454, JString, required = false,
                                 default = nil)
  if valid_599454 != nil:
    section.add "quotaUser", valid_599454
  var valid_599455 = query.getOrDefault("event")
  valid_599455 = validateParameter(valid_599455, JString, required = false,
                                 default = newJString("add"))
  if valid_599455 != nil:
    section.add "event", valid_599455
  var valid_599456 = query.getOrDefault("alt")
  valid_599456 = validateParameter(valid_599456, JString, required = false,
                                 default = newJString("json"))
  if valid_599456 != nil:
    section.add "alt", valid_599456
  var valid_599457 = query.getOrDefault("query")
  valid_599457 = validateParameter(valid_599457, JString, required = false,
                                 default = nil)
  if valid_599457 != nil:
    section.add "query", valid_599457
  var valid_599458 = query.getOrDefault("oauth_token")
  valid_599458 = validateParameter(valid_599458, JString, required = false,
                                 default = nil)
  if valid_599458 != nil:
    section.add "oauth_token", valid_599458
  var valid_599459 = query.getOrDefault("userIp")
  valid_599459 = validateParameter(valid_599459, JString, required = false,
                                 default = nil)
  if valid_599459 != nil:
    section.add "userIp", valid_599459
  var valid_599460 = query.getOrDefault("maxResults")
  valid_599460 = validateParameter(valid_599460, JInt, required = false,
                                 default = newJInt(100))
  if valid_599460 != nil:
    section.add "maxResults", valid_599460
  var valid_599461 = query.getOrDefault("orderBy")
  valid_599461 = validateParameter(valid_599461, JString, required = false,
                                 default = newJString("email"))
  if valid_599461 != nil:
    section.add "orderBy", valid_599461
  var valid_599462 = query.getOrDefault("showDeleted")
  valid_599462 = validateParameter(valid_599462, JString, required = false,
                                 default = nil)
  if valid_599462 != nil:
    section.add "showDeleted", valid_599462
  var valid_599463 = query.getOrDefault("customFieldMask")
  valid_599463 = validateParameter(valid_599463, JString, required = false,
                                 default = nil)
  if valid_599463 != nil:
    section.add "customFieldMask", valid_599463
  var valid_599464 = query.getOrDefault("key")
  valid_599464 = validateParameter(valid_599464, JString, required = false,
                                 default = nil)
  if valid_599464 != nil:
    section.add "key", valid_599464
  var valid_599465 = query.getOrDefault("projection")
  valid_599465 = validateParameter(valid_599465, JString, required = false,
                                 default = newJString("basic"))
  if valid_599465 != nil:
    section.add "projection", valid_599465
  var valid_599466 = query.getOrDefault("sortOrder")
  valid_599466 = validateParameter(valid_599466, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_599466 != nil:
    section.add "sortOrder", valid_599466
  var valid_599467 = query.getOrDefault("customer")
  valid_599467 = validateParameter(valid_599467, JString, required = false,
                                 default = nil)
  if valid_599467 != nil:
    section.add "customer", valid_599467
  var valid_599468 = query.getOrDefault("prettyPrint")
  valid_599468 = validateParameter(valid_599468, JBool, required = false,
                                 default = newJBool(true))
  if valid_599468 != nil:
    section.add "prettyPrint", valid_599468
  var valid_599469 = query.getOrDefault("viewType")
  valid_599469 = validateParameter(valid_599469, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_599469 != nil:
    section.add "viewType", valid_599469
  var valid_599470 = query.getOrDefault("domain")
  valid_599470 = validateParameter(valid_599470, JString, required = false,
                                 default = nil)
  if valid_599470 != nil:
    section.add "domain", valid_599470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599471: Call_DirectoryUsersList_599449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve either deleted users or all users in a domain (paginated)
  ## 
  let valid = call_599471.validator(path, query, header, formData, body)
  let scheme = call_599471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599471.url(scheme.get, call_599471.host, call_599471.base,
                         call_599471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599471, url, valid)

proc call*(call_599472: Call_DirectoryUsersList_599449; fields: string = "";
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
  var query_599473 = newJObject()
  add(query_599473, "fields", newJString(fields))
  add(query_599473, "pageToken", newJString(pageToken))
  add(query_599473, "quotaUser", newJString(quotaUser))
  add(query_599473, "event", newJString(event))
  add(query_599473, "alt", newJString(alt))
  add(query_599473, "query", newJString(query))
  add(query_599473, "oauth_token", newJString(oauthToken))
  add(query_599473, "userIp", newJString(userIp))
  add(query_599473, "maxResults", newJInt(maxResults))
  add(query_599473, "orderBy", newJString(orderBy))
  add(query_599473, "showDeleted", newJString(showDeleted))
  add(query_599473, "customFieldMask", newJString(customFieldMask))
  add(query_599473, "key", newJString(key))
  add(query_599473, "projection", newJString(projection))
  add(query_599473, "sortOrder", newJString(sortOrder))
  add(query_599473, "customer", newJString(customer))
  add(query_599473, "prettyPrint", newJBool(prettyPrint))
  add(query_599473, "viewType", newJString(viewType))
  add(query_599473, "domain", newJString(domain))
  result = call_599472.call(nil, query_599473, nil, nil, nil)

var directoryUsersList* = Call_DirectoryUsersList_599449(
    name: "directoryUsersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users",
    validator: validate_DirectoryUsersList_599450, base: "/admin/directory/v1",
    url: url_DirectoryUsersList_599451, schemes: {Scheme.Https})
type
  Call_DirectoryUsersWatch_599489 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersWatch_599491(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DirectoryUsersWatch_599490(path: JsonNode; query: JsonNode;
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
  var valid_599492 = query.getOrDefault("fields")
  valid_599492 = validateParameter(valid_599492, JString, required = false,
                                 default = nil)
  if valid_599492 != nil:
    section.add "fields", valid_599492
  var valid_599493 = query.getOrDefault("pageToken")
  valid_599493 = validateParameter(valid_599493, JString, required = false,
                                 default = nil)
  if valid_599493 != nil:
    section.add "pageToken", valid_599493
  var valid_599494 = query.getOrDefault("quotaUser")
  valid_599494 = validateParameter(valid_599494, JString, required = false,
                                 default = nil)
  if valid_599494 != nil:
    section.add "quotaUser", valid_599494
  var valid_599495 = query.getOrDefault("event")
  valid_599495 = validateParameter(valid_599495, JString, required = false,
                                 default = newJString("add"))
  if valid_599495 != nil:
    section.add "event", valid_599495
  var valid_599496 = query.getOrDefault("alt")
  valid_599496 = validateParameter(valid_599496, JString, required = false,
                                 default = newJString("json"))
  if valid_599496 != nil:
    section.add "alt", valid_599496
  var valid_599497 = query.getOrDefault("query")
  valid_599497 = validateParameter(valid_599497, JString, required = false,
                                 default = nil)
  if valid_599497 != nil:
    section.add "query", valid_599497
  var valid_599498 = query.getOrDefault("oauth_token")
  valid_599498 = validateParameter(valid_599498, JString, required = false,
                                 default = nil)
  if valid_599498 != nil:
    section.add "oauth_token", valid_599498
  var valid_599499 = query.getOrDefault("userIp")
  valid_599499 = validateParameter(valid_599499, JString, required = false,
                                 default = nil)
  if valid_599499 != nil:
    section.add "userIp", valid_599499
  var valid_599500 = query.getOrDefault("maxResults")
  valid_599500 = validateParameter(valid_599500, JInt, required = false,
                                 default = newJInt(100))
  if valid_599500 != nil:
    section.add "maxResults", valid_599500
  var valid_599501 = query.getOrDefault("orderBy")
  valid_599501 = validateParameter(valid_599501, JString, required = false,
                                 default = newJString("email"))
  if valid_599501 != nil:
    section.add "orderBy", valid_599501
  var valid_599502 = query.getOrDefault("showDeleted")
  valid_599502 = validateParameter(valid_599502, JString, required = false,
                                 default = nil)
  if valid_599502 != nil:
    section.add "showDeleted", valid_599502
  var valid_599503 = query.getOrDefault("customFieldMask")
  valid_599503 = validateParameter(valid_599503, JString, required = false,
                                 default = nil)
  if valid_599503 != nil:
    section.add "customFieldMask", valid_599503
  var valid_599504 = query.getOrDefault("key")
  valid_599504 = validateParameter(valid_599504, JString, required = false,
                                 default = nil)
  if valid_599504 != nil:
    section.add "key", valid_599504
  var valid_599505 = query.getOrDefault("projection")
  valid_599505 = validateParameter(valid_599505, JString, required = false,
                                 default = newJString("basic"))
  if valid_599505 != nil:
    section.add "projection", valid_599505
  var valid_599506 = query.getOrDefault("sortOrder")
  valid_599506 = validateParameter(valid_599506, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_599506 != nil:
    section.add "sortOrder", valid_599506
  var valid_599507 = query.getOrDefault("customer")
  valid_599507 = validateParameter(valid_599507, JString, required = false,
                                 default = nil)
  if valid_599507 != nil:
    section.add "customer", valid_599507
  var valid_599508 = query.getOrDefault("prettyPrint")
  valid_599508 = validateParameter(valid_599508, JBool, required = false,
                                 default = newJBool(true))
  if valid_599508 != nil:
    section.add "prettyPrint", valid_599508
  var valid_599509 = query.getOrDefault("viewType")
  valid_599509 = validateParameter(valid_599509, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_599509 != nil:
    section.add "viewType", valid_599509
  var valid_599510 = query.getOrDefault("domain")
  valid_599510 = validateParameter(valid_599510, JString, required = false,
                                 default = nil)
  if valid_599510 != nil:
    section.add "domain", valid_599510
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

proc call*(call_599512: Call_DirectoryUsersWatch_599489; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes in users list
  ## 
  let valid = call_599512.validator(path, query, header, formData, body)
  let scheme = call_599512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599512.url(scheme.get, call_599512.host, call_599512.base,
                         call_599512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599512, url, valid)

proc call*(call_599513: Call_DirectoryUsersWatch_599489; fields: string = "";
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
  var query_599514 = newJObject()
  var body_599515 = newJObject()
  add(query_599514, "fields", newJString(fields))
  add(query_599514, "pageToken", newJString(pageToken))
  add(query_599514, "quotaUser", newJString(quotaUser))
  add(query_599514, "event", newJString(event))
  add(query_599514, "alt", newJString(alt))
  add(query_599514, "query", newJString(query))
  add(query_599514, "oauth_token", newJString(oauthToken))
  add(query_599514, "userIp", newJString(userIp))
  add(query_599514, "maxResults", newJInt(maxResults))
  add(query_599514, "orderBy", newJString(orderBy))
  add(query_599514, "showDeleted", newJString(showDeleted))
  add(query_599514, "customFieldMask", newJString(customFieldMask))
  add(query_599514, "key", newJString(key))
  add(query_599514, "projection", newJString(projection))
  add(query_599514, "sortOrder", newJString(sortOrder))
  if resource != nil:
    body_599515 = resource
  add(query_599514, "customer", newJString(customer))
  add(query_599514, "prettyPrint", newJBool(prettyPrint))
  add(query_599514, "viewType", newJString(viewType))
  add(query_599514, "domain", newJString(domain))
  result = call_599513.call(nil, query_599514, nil, nil, body_599515)

var directoryUsersWatch* = Call_DirectoryUsersWatch_599489(
    name: "directoryUsersWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/watch",
    validator: validate_DirectoryUsersWatch_599490, base: "/admin/directory/v1",
    url: url_DirectoryUsersWatch_599491, schemes: {Scheme.Https})
type
  Call_DirectoryUsersUpdate_599534 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersUpdate_599536(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryUsersUpdate_599535(path: JsonNode; query: JsonNode;
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
  var valid_599537 = path.getOrDefault("userKey")
  valid_599537 = validateParameter(valid_599537, JString, required = true,
                                 default = nil)
  if valid_599537 != nil:
    section.add "userKey", valid_599537
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
  var valid_599538 = query.getOrDefault("fields")
  valid_599538 = validateParameter(valid_599538, JString, required = false,
                                 default = nil)
  if valid_599538 != nil:
    section.add "fields", valid_599538
  var valid_599539 = query.getOrDefault("quotaUser")
  valid_599539 = validateParameter(valid_599539, JString, required = false,
                                 default = nil)
  if valid_599539 != nil:
    section.add "quotaUser", valid_599539
  var valid_599540 = query.getOrDefault("alt")
  valid_599540 = validateParameter(valid_599540, JString, required = false,
                                 default = newJString("json"))
  if valid_599540 != nil:
    section.add "alt", valid_599540
  var valid_599541 = query.getOrDefault("oauth_token")
  valid_599541 = validateParameter(valid_599541, JString, required = false,
                                 default = nil)
  if valid_599541 != nil:
    section.add "oauth_token", valid_599541
  var valid_599542 = query.getOrDefault("userIp")
  valid_599542 = validateParameter(valid_599542, JString, required = false,
                                 default = nil)
  if valid_599542 != nil:
    section.add "userIp", valid_599542
  var valid_599543 = query.getOrDefault("key")
  valid_599543 = validateParameter(valid_599543, JString, required = false,
                                 default = nil)
  if valid_599543 != nil:
    section.add "key", valid_599543
  var valid_599544 = query.getOrDefault("prettyPrint")
  valid_599544 = validateParameter(valid_599544, JBool, required = false,
                                 default = newJBool(true))
  if valid_599544 != nil:
    section.add "prettyPrint", valid_599544
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

proc call*(call_599546: Call_DirectoryUsersUpdate_599534; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## update user
  ## 
  let valid = call_599546.validator(path, query, header, formData, body)
  let scheme = call_599546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599546.url(scheme.get, call_599546.host, call_599546.base,
                         call_599546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599546, url, valid)

proc call*(call_599547: Call_DirectoryUsersUpdate_599534; userKey: string;
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
  var path_599548 = newJObject()
  var query_599549 = newJObject()
  var body_599550 = newJObject()
  add(query_599549, "fields", newJString(fields))
  add(query_599549, "quotaUser", newJString(quotaUser))
  add(query_599549, "alt", newJString(alt))
  add(query_599549, "oauth_token", newJString(oauthToken))
  add(query_599549, "userIp", newJString(userIp))
  add(path_599548, "userKey", newJString(userKey))
  add(query_599549, "key", newJString(key))
  if body != nil:
    body_599550 = body
  add(query_599549, "prettyPrint", newJBool(prettyPrint))
  result = call_599547.call(path_599548, query_599549, nil, nil, body_599550)

var directoryUsersUpdate* = Call_DirectoryUsersUpdate_599534(
    name: "directoryUsersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersUpdate_599535, base: "/admin/directory/v1",
    url: url_DirectoryUsersUpdate_599536, schemes: {Scheme.Https})
type
  Call_DirectoryUsersGet_599516 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersGet_599518(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryUsersGet_599517(path: JsonNode; query: JsonNode;
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
  var valid_599519 = path.getOrDefault("userKey")
  valid_599519 = validateParameter(valid_599519, JString, required = true,
                                 default = nil)
  if valid_599519 != nil:
    section.add "userKey", valid_599519
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
  var valid_599520 = query.getOrDefault("fields")
  valid_599520 = validateParameter(valid_599520, JString, required = false,
                                 default = nil)
  if valid_599520 != nil:
    section.add "fields", valid_599520
  var valid_599521 = query.getOrDefault("quotaUser")
  valid_599521 = validateParameter(valid_599521, JString, required = false,
                                 default = nil)
  if valid_599521 != nil:
    section.add "quotaUser", valid_599521
  var valid_599522 = query.getOrDefault("alt")
  valid_599522 = validateParameter(valid_599522, JString, required = false,
                                 default = newJString("json"))
  if valid_599522 != nil:
    section.add "alt", valid_599522
  var valid_599523 = query.getOrDefault("oauth_token")
  valid_599523 = validateParameter(valid_599523, JString, required = false,
                                 default = nil)
  if valid_599523 != nil:
    section.add "oauth_token", valid_599523
  var valid_599524 = query.getOrDefault("userIp")
  valid_599524 = validateParameter(valid_599524, JString, required = false,
                                 default = nil)
  if valid_599524 != nil:
    section.add "userIp", valid_599524
  var valid_599525 = query.getOrDefault("customFieldMask")
  valid_599525 = validateParameter(valid_599525, JString, required = false,
                                 default = nil)
  if valid_599525 != nil:
    section.add "customFieldMask", valid_599525
  var valid_599526 = query.getOrDefault("key")
  valid_599526 = validateParameter(valid_599526, JString, required = false,
                                 default = nil)
  if valid_599526 != nil:
    section.add "key", valid_599526
  var valid_599527 = query.getOrDefault("projection")
  valid_599527 = validateParameter(valid_599527, JString, required = false,
                                 default = newJString("basic"))
  if valid_599527 != nil:
    section.add "projection", valid_599527
  var valid_599528 = query.getOrDefault("prettyPrint")
  valid_599528 = validateParameter(valid_599528, JBool, required = false,
                                 default = newJBool(true))
  if valid_599528 != nil:
    section.add "prettyPrint", valid_599528
  var valid_599529 = query.getOrDefault("viewType")
  valid_599529 = validateParameter(valid_599529, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_599529 != nil:
    section.add "viewType", valid_599529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599530: Call_DirectoryUsersGet_599516; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## retrieve user
  ## 
  let valid = call_599530.validator(path, query, header, formData, body)
  let scheme = call_599530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599530.url(scheme.get, call_599530.host, call_599530.base,
                         call_599530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599530, url, valid)

proc call*(call_599531: Call_DirectoryUsersGet_599516; userKey: string;
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
  var path_599532 = newJObject()
  var query_599533 = newJObject()
  add(query_599533, "fields", newJString(fields))
  add(query_599533, "quotaUser", newJString(quotaUser))
  add(query_599533, "alt", newJString(alt))
  add(query_599533, "oauth_token", newJString(oauthToken))
  add(query_599533, "userIp", newJString(userIp))
  add(path_599532, "userKey", newJString(userKey))
  add(query_599533, "customFieldMask", newJString(customFieldMask))
  add(query_599533, "key", newJString(key))
  add(query_599533, "projection", newJString(projection))
  add(query_599533, "prettyPrint", newJBool(prettyPrint))
  add(query_599533, "viewType", newJString(viewType))
  result = call_599531.call(path_599532, query_599533, nil, nil, nil)

var directoryUsersGet* = Call_DirectoryUsersGet_599516(name: "directoryUsersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersGet_599517, base: "/admin/directory/v1",
    url: url_DirectoryUsersGet_599518, schemes: {Scheme.Https})
type
  Call_DirectoryUsersPatch_599566 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersPatch_599568(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryUsersPatch_599567(path: JsonNode; query: JsonNode;
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
  var valid_599569 = path.getOrDefault("userKey")
  valid_599569 = validateParameter(valid_599569, JString, required = true,
                                 default = nil)
  if valid_599569 != nil:
    section.add "userKey", valid_599569
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
  var valid_599570 = query.getOrDefault("fields")
  valid_599570 = validateParameter(valid_599570, JString, required = false,
                                 default = nil)
  if valid_599570 != nil:
    section.add "fields", valid_599570
  var valid_599571 = query.getOrDefault("quotaUser")
  valid_599571 = validateParameter(valid_599571, JString, required = false,
                                 default = nil)
  if valid_599571 != nil:
    section.add "quotaUser", valid_599571
  var valid_599572 = query.getOrDefault("alt")
  valid_599572 = validateParameter(valid_599572, JString, required = false,
                                 default = newJString("json"))
  if valid_599572 != nil:
    section.add "alt", valid_599572
  var valid_599573 = query.getOrDefault("oauth_token")
  valid_599573 = validateParameter(valid_599573, JString, required = false,
                                 default = nil)
  if valid_599573 != nil:
    section.add "oauth_token", valid_599573
  var valid_599574 = query.getOrDefault("userIp")
  valid_599574 = validateParameter(valid_599574, JString, required = false,
                                 default = nil)
  if valid_599574 != nil:
    section.add "userIp", valid_599574
  var valid_599575 = query.getOrDefault("key")
  valid_599575 = validateParameter(valid_599575, JString, required = false,
                                 default = nil)
  if valid_599575 != nil:
    section.add "key", valid_599575
  var valid_599576 = query.getOrDefault("prettyPrint")
  valid_599576 = validateParameter(valid_599576, JBool, required = false,
                                 default = newJBool(true))
  if valid_599576 != nil:
    section.add "prettyPrint", valid_599576
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

proc call*(call_599578: Call_DirectoryUsersPatch_599566; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## update user. This method supports patch semantics.
  ## 
  let valid = call_599578.validator(path, query, header, formData, body)
  let scheme = call_599578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599578.url(scheme.get, call_599578.host, call_599578.base,
                         call_599578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599578, url, valid)

proc call*(call_599579: Call_DirectoryUsersPatch_599566; userKey: string;
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
  var path_599580 = newJObject()
  var query_599581 = newJObject()
  var body_599582 = newJObject()
  add(query_599581, "fields", newJString(fields))
  add(query_599581, "quotaUser", newJString(quotaUser))
  add(query_599581, "alt", newJString(alt))
  add(query_599581, "oauth_token", newJString(oauthToken))
  add(query_599581, "userIp", newJString(userIp))
  add(path_599580, "userKey", newJString(userKey))
  add(query_599581, "key", newJString(key))
  if body != nil:
    body_599582 = body
  add(query_599581, "prettyPrint", newJBool(prettyPrint))
  result = call_599579.call(path_599580, query_599581, nil, nil, body_599582)

var directoryUsersPatch* = Call_DirectoryUsersPatch_599566(
    name: "directoryUsersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersPatch_599567, base: "/admin/directory/v1",
    url: url_DirectoryUsersPatch_599568, schemes: {Scheme.Https})
type
  Call_DirectoryUsersDelete_599551 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersDelete_599553(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryUsersDelete_599552(path: JsonNode; query: JsonNode;
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
  var valid_599554 = path.getOrDefault("userKey")
  valid_599554 = validateParameter(valid_599554, JString, required = true,
                                 default = nil)
  if valid_599554 != nil:
    section.add "userKey", valid_599554
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
  var valid_599555 = query.getOrDefault("fields")
  valid_599555 = validateParameter(valid_599555, JString, required = false,
                                 default = nil)
  if valid_599555 != nil:
    section.add "fields", valid_599555
  var valid_599556 = query.getOrDefault("quotaUser")
  valid_599556 = validateParameter(valid_599556, JString, required = false,
                                 default = nil)
  if valid_599556 != nil:
    section.add "quotaUser", valid_599556
  var valid_599557 = query.getOrDefault("alt")
  valid_599557 = validateParameter(valid_599557, JString, required = false,
                                 default = newJString("json"))
  if valid_599557 != nil:
    section.add "alt", valid_599557
  var valid_599558 = query.getOrDefault("oauth_token")
  valid_599558 = validateParameter(valid_599558, JString, required = false,
                                 default = nil)
  if valid_599558 != nil:
    section.add "oauth_token", valid_599558
  var valid_599559 = query.getOrDefault("userIp")
  valid_599559 = validateParameter(valid_599559, JString, required = false,
                                 default = nil)
  if valid_599559 != nil:
    section.add "userIp", valid_599559
  var valid_599560 = query.getOrDefault("key")
  valid_599560 = validateParameter(valid_599560, JString, required = false,
                                 default = nil)
  if valid_599560 != nil:
    section.add "key", valid_599560
  var valid_599561 = query.getOrDefault("prettyPrint")
  valid_599561 = validateParameter(valid_599561, JBool, required = false,
                                 default = newJBool(true))
  if valid_599561 != nil:
    section.add "prettyPrint", valid_599561
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599562: Call_DirectoryUsersDelete_599551; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete user
  ## 
  let valid = call_599562.validator(path, query, header, formData, body)
  let scheme = call_599562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599562.url(scheme.get, call_599562.host, call_599562.base,
                         call_599562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599562, url, valid)

proc call*(call_599563: Call_DirectoryUsersDelete_599551; userKey: string;
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
  var path_599564 = newJObject()
  var query_599565 = newJObject()
  add(query_599565, "fields", newJString(fields))
  add(query_599565, "quotaUser", newJString(quotaUser))
  add(query_599565, "alt", newJString(alt))
  add(query_599565, "oauth_token", newJString(oauthToken))
  add(query_599565, "userIp", newJString(userIp))
  add(path_599564, "userKey", newJString(userKey))
  add(query_599565, "key", newJString(key))
  add(query_599565, "prettyPrint", newJBool(prettyPrint))
  result = call_599563.call(path_599564, query_599565, nil, nil, nil)

var directoryUsersDelete* = Call_DirectoryUsersDelete_599551(
    name: "directoryUsersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersDelete_599552, base: "/admin/directory/v1",
    url: url_DirectoryUsersDelete_599553, schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesInsert_599599 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersAliasesInsert_599601(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryUsersAliasesInsert_599600(path: JsonNode; query: JsonNode;
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
  var valid_599602 = path.getOrDefault("userKey")
  valid_599602 = validateParameter(valid_599602, JString, required = true,
                                 default = nil)
  if valid_599602 != nil:
    section.add "userKey", valid_599602
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
  var valid_599603 = query.getOrDefault("fields")
  valid_599603 = validateParameter(valid_599603, JString, required = false,
                                 default = nil)
  if valid_599603 != nil:
    section.add "fields", valid_599603
  var valid_599604 = query.getOrDefault("quotaUser")
  valid_599604 = validateParameter(valid_599604, JString, required = false,
                                 default = nil)
  if valid_599604 != nil:
    section.add "quotaUser", valid_599604
  var valid_599605 = query.getOrDefault("alt")
  valid_599605 = validateParameter(valid_599605, JString, required = false,
                                 default = newJString("json"))
  if valid_599605 != nil:
    section.add "alt", valid_599605
  var valid_599606 = query.getOrDefault("oauth_token")
  valid_599606 = validateParameter(valid_599606, JString, required = false,
                                 default = nil)
  if valid_599606 != nil:
    section.add "oauth_token", valid_599606
  var valid_599607 = query.getOrDefault("userIp")
  valid_599607 = validateParameter(valid_599607, JString, required = false,
                                 default = nil)
  if valid_599607 != nil:
    section.add "userIp", valid_599607
  var valid_599608 = query.getOrDefault("key")
  valid_599608 = validateParameter(valid_599608, JString, required = false,
                                 default = nil)
  if valid_599608 != nil:
    section.add "key", valid_599608
  var valid_599609 = query.getOrDefault("prettyPrint")
  valid_599609 = validateParameter(valid_599609, JBool, required = false,
                                 default = newJBool(true))
  if valid_599609 != nil:
    section.add "prettyPrint", valid_599609
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

proc call*(call_599611: Call_DirectoryUsersAliasesInsert_599599; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a alias for the user
  ## 
  let valid = call_599611.validator(path, query, header, formData, body)
  let scheme = call_599611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599611.url(scheme.get, call_599611.host, call_599611.base,
                         call_599611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599611, url, valid)

proc call*(call_599612: Call_DirectoryUsersAliasesInsert_599599; userKey: string;
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
  var path_599613 = newJObject()
  var query_599614 = newJObject()
  var body_599615 = newJObject()
  add(query_599614, "fields", newJString(fields))
  add(query_599614, "quotaUser", newJString(quotaUser))
  add(query_599614, "alt", newJString(alt))
  add(query_599614, "oauth_token", newJString(oauthToken))
  add(query_599614, "userIp", newJString(userIp))
  add(path_599613, "userKey", newJString(userKey))
  add(query_599614, "key", newJString(key))
  if body != nil:
    body_599615 = body
  add(query_599614, "prettyPrint", newJBool(prettyPrint))
  result = call_599612.call(path_599613, query_599614, nil, nil, body_599615)

var directoryUsersAliasesInsert* = Call_DirectoryUsersAliasesInsert_599599(
    name: "directoryUsersAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases",
    validator: validate_DirectoryUsersAliasesInsert_599600,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesInsert_599601,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesList_599583 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersAliasesList_599585(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryUsersAliasesList_599584(path: JsonNode; query: JsonNode;
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
  var valid_599586 = path.getOrDefault("userKey")
  valid_599586 = validateParameter(valid_599586, JString, required = true,
                                 default = nil)
  if valid_599586 != nil:
    section.add "userKey", valid_599586
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
  var valid_599587 = query.getOrDefault("fields")
  valid_599587 = validateParameter(valid_599587, JString, required = false,
                                 default = nil)
  if valid_599587 != nil:
    section.add "fields", valid_599587
  var valid_599588 = query.getOrDefault("quotaUser")
  valid_599588 = validateParameter(valid_599588, JString, required = false,
                                 default = nil)
  if valid_599588 != nil:
    section.add "quotaUser", valid_599588
  var valid_599589 = query.getOrDefault("event")
  valid_599589 = validateParameter(valid_599589, JString, required = false,
                                 default = newJString("add"))
  if valid_599589 != nil:
    section.add "event", valid_599589
  var valid_599590 = query.getOrDefault("alt")
  valid_599590 = validateParameter(valid_599590, JString, required = false,
                                 default = newJString("json"))
  if valid_599590 != nil:
    section.add "alt", valid_599590
  var valid_599591 = query.getOrDefault("oauth_token")
  valid_599591 = validateParameter(valid_599591, JString, required = false,
                                 default = nil)
  if valid_599591 != nil:
    section.add "oauth_token", valid_599591
  var valid_599592 = query.getOrDefault("userIp")
  valid_599592 = validateParameter(valid_599592, JString, required = false,
                                 default = nil)
  if valid_599592 != nil:
    section.add "userIp", valid_599592
  var valid_599593 = query.getOrDefault("key")
  valid_599593 = validateParameter(valid_599593, JString, required = false,
                                 default = nil)
  if valid_599593 != nil:
    section.add "key", valid_599593
  var valid_599594 = query.getOrDefault("prettyPrint")
  valid_599594 = validateParameter(valid_599594, JBool, required = false,
                                 default = newJBool(true))
  if valid_599594 != nil:
    section.add "prettyPrint", valid_599594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599595: Call_DirectoryUsersAliasesList_599583; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all aliases for a user
  ## 
  let valid = call_599595.validator(path, query, header, formData, body)
  let scheme = call_599595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599595.url(scheme.get, call_599595.host, call_599595.base,
                         call_599595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599595, url, valid)

proc call*(call_599596: Call_DirectoryUsersAliasesList_599583; userKey: string;
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
  var path_599597 = newJObject()
  var query_599598 = newJObject()
  add(query_599598, "fields", newJString(fields))
  add(query_599598, "quotaUser", newJString(quotaUser))
  add(query_599598, "event", newJString(event))
  add(query_599598, "alt", newJString(alt))
  add(query_599598, "oauth_token", newJString(oauthToken))
  add(query_599598, "userIp", newJString(userIp))
  add(path_599597, "userKey", newJString(userKey))
  add(query_599598, "key", newJString(key))
  add(query_599598, "prettyPrint", newJBool(prettyPrint))
  result = call_599596.call(path_599597, query_599598, nil, nil, nil)

var directoryUsersAliasesList* = Call_DirectoryUsersAliasesList_599583(
    name: "directoryUsersAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases",
    validator: validate_DirectoryUsersAliasesList_599584,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesList_599585,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesWatch_599616 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersAliasesWatch_599618(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryUsersAliasesWatch_599617(path: JsonNode; query: JsonNode;
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
  var valid_599619 = path.getOrDefault("userKey")
  valid_599619 = validateParameter(valid_599619, JString, required = true,
                                 default = nil)
  if valid_599619 != nil:
    section.add "userKey", valid_599619
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
  var valid_599620 = query.getOrDefault("fields")
  valid_599620 = validateParameter(valid_599620, JString, required = false,
                                 default = nil)
  if valid_599620 != nil:
    section.add "fields", valid_599620
  var valid_599621 = query.getOrDefault("quotaUser")
  valid_599621 = validateParameter(valid_599621, JString, required = false,
                                 default = nil)
  if valid_599621 != nil:
    section.add "quotaUser", valid_599621
  var valid_599622 = query.getOrDefault("event")
  valid_599622 = validateParameter(valid_599622, JString, required = false,
                                 default = newJString("add"))
  if valid_599622 != nil:
    section.add "event", valid_599622
  var valid_599623 = query.getOrDefault("alt")
  valid_599623 = validateParameter(valid_599623, JString, required = false,
                                 default = newJString("json"))
  if valid_599623 != nil:
    section.add "alt", valid_599623
  var valid_599624 = query.getOrDefault("oauth_token")
  valid_599624 = validateParameter(valid_599624, JString, required = false,
                                 default = nil)
  if valid_599624 != nil:
    section.add "oauth_token", valid_599624
  var valid_599625 = query.getOrDefault("userIp")
  valid_599625 = validateParameter(valid_599625, JString, required = false,
                                 default = nil)
  if valid_599625 != nil:
    section.add "userIp", valid_599625
  var valid_599626 = query.getOrDefault("key")
  valid_599626 = validateParameter(valid_599626, JString, required = false,
                                 default = nil)
  if valid_599626 != nil:
    section.add "key", valid_599626
  var valid_599627 = query.getOrDefault("prettyPrint")
  valid_599627 = validateParameter(valid_599627, JBool, required = false,
                                 default = newJBool(true))
  if valid_599627 != nil:
    section.add "prettyPrint", valid_599627
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

proc call*(call_599629: Call_DirectoryUsersAliasesWatch_599616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes in user aliases list
  ## 
  let valid = call_599629.validator(path, query, header, formData, body)
  let scheme = call_599629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599629.url(scheme.get, call_599629.host, call_599629.base,
                         call_599629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599629, url, valid)

proc call*(call_599630: Call_DirectoryUsersAliasesWatch_599616; userKey: string;
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
  var path_599631 = newJObject()
  var query_599632 = newJObject()
  var body_599633 = newJObject()
  add(query_599632, "fields", newJString(fields))
  add(query_599632, "quotaUser", newJString(quotaUser))
  add(query_599632, "event", newJString(event))
  add(query_599632, "alt", newJString(alt))
  add(query_599632, "oauth_token", newJString(oauthToken))
  add(query_599632, "userIp", newJString(userIp))
  add(path_599631, "userKey", newJString(userKey))
  add(query_599632, "key", newJString(key))
  if resource != nil:
    body_599633 = resource
  add(query_599632, "prettyPrint", newJBool(prettyPrint))
  result = call_599630.call(path_599631, query_599632, nil, nil, body_599633)

var directoryUsersAliasesWatch* = Call_DirectoryUsersAliasesWatch_599616(
    name: "directoryUsersAliasesWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases/watch",
    validator: validate_DirectoryUsersAliasesWatch_599617,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesWatch_599618,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesDelete_599634 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersAliasesDelete_599636(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryUsersAliasesDelete_599635(path: JsonNode; query: JsonNode;
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
  var valid_599637 = path.getOrDefault("userKey")
  valid_599637 = validateParameter(valid_599637, JString, required = true,
                                 default = nil)
  if valid_599637 != nil:
    section.add "userKey", valid_599637
  var valid_599638 = path.getOrDefault("alias")
  valid_599638 = validateParameter(valid_599638, JString, required = true,
                                 default = nil)
  if valid_599638 != nil:
    section.add "alias", valid_599638
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
  var valid_599639 = query.getOrDefault("fields")
  valid_599639 = validateParameter(valid_599639, JString, required = false,
                                 default = nil)
  if valid_599639 != nil:
    section.add "fields", valid_599639
  var valid_599640 = query.getOrDefault("quotaUser")
  valid_599640 = validateParameter(valid_599640, JString, required = false,
                                 default = nil)
  if valid_599640 != nil:
    section.add "quotaUser", valid_599640
  var valid_599641 = query.getOrDefault("alt")
  valid_599641 = validateParameter(valid_599641, JString, required = false,
                                 default = newJString("json"))
  if valid_599641 != nil:
    section.add "alt", valid_599641
  var valid_599642 = query.getOrDefault("oauth_token")
  valid_599642 = validateParameter(valid_599642, JString, required = false,
                                 default = nil)
  if valid_599642 != nil:
    section.add "oauth_token", valid_599642
  var valid_599643 = query.getOrDefault("userIp")
  valid_599643 = validateParameter(valid_599643, JString, required = false,
                                 default = nil)
  if valid_599643 != nil:
    section.add "userIp", valid_599643
  var valid_599644 = query.getOrDefault("key")
  valid_599644 = validateParameter(valid_599644, JString, required = false,
                                 default = nil)
  if valid_599644 != nil:
    section.add "key", valid_599644
  var valid_599645 = query.getOrDefault("prettyPrint")
  valid_599645 = validateParameter(valid_599645, JBool, required = false,
                                 default = newJBool(true))
  if valid_599645 != nil:
    section.add "prettyPrint", valid_599645
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599646: Call_DirectoryUsersAliasesDelete_599634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a alias for the user
  ## 
  let valid = call_599646.validator(path, query, header, formData, body)
  let scheme = call_599646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599646.url(scheme.get, call_599646.host, call_599646.base,
                         call_599646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599646, url, valid)

proc call*(call_599647: Call_DirectoryUsersAliasesDelete_599634; userKey: string;
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
  var path_599648 = newJObject()
  var query_599649 = newJObject()
  add(query_599649, "fields", newJString(fields))
  add(query_599649, "quotaUser", newJString(quotaUser))
  add(query_599649, "alt", newJString(alt))
  add(query_599649, "oauth_token", newJString(oauthToken))
  add(query_599649, "userIp", newJString(userIp))
  add(path_599648, "userKey", newJString(userKey))
  add(query_599649, "key", newJString(key))
  add(query_599649, "prettyPrint", newJBool(prettyPrint))
  add(path_599648, "alias", newJString(alias))
  result = call_599647.call(path_599648, query_599649, nil, nil, nil)

var directoryUsersAliasesDelete* = Call_DirectoryUsersAliasesDelete_599634(
    name: "directoryUsersAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases/{alias}",
    validator: validate_DirectoryUsersAliasesDelete_599635,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesDelete_599636,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsList_599650 = ref object of OpenApiRestCall_597437
proc url_DirectoryAspsList_599652(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryAspsList_599651(path: JsonNode; query: JsonNode;
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
  var valid_599653 = path.getOrDefault("userKey")
  valid_599653 = validateParameter(valid_599653, JString, required = true,
                                 default = nil)
  if valid_599653 != nil:
    section.add "userKey", valid_599653
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
  var valid_599654 = query.getOrDefault("fields")
  valid_599654 = validateParameter(valid_599654, JString, required = false,
                                 default = nil)
  if valid_599654 != nil:
    section.add "fields", valid_599654
  var valid_599655 = query.getOrDefault("quotaUser")
  valid_599655 = validateParameter(valid_599655, JString, required = false,
                                 default = nil)
  if valid_599655 != nil:
    section.add "quotaUser", valid_599655
  var valid_599656 = query.getOrDefault("alt")
  valid_599656 = validateParameter(valid_599656, JString, required = false,
                                 default = newJString("json"))
  if valid_599656 != nil:
    section.add "alt", valid_599656
  var valid_599657 = query.getOrDefault("oauth_token")
  valid_599657 = validateParameter(valid_599657, JString, required = false,
                                 default = nil)
  if valid_599657 != nil:
    section.add "oauth_token", valid_599657
  var valid_599658 = query.getOrDefault("userIp")
  valid_599658 = validateParameter(valid_599658, JString, required = false,
                                 default = nil)
  if valid_599658 != nil:
    section.add "userIp", valid_599658
  var valid_599659 = query.getOrDefault("key")
  valid_599659 = validateParameter(valid_599659, JString, required = false,
                                 default = nil)
  if valid_599659 != nil:
    section.add "key", valid_599659
  var valid_599660 = query.getOrDefault("prettyPrint")
  valid_599660 = validateParameter(valid_599660, JBool, required = false,
                                 default = newJBool(true))
  if valid_599660 != nil:
    section.add "prettyPrint", valid_599660
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599661: Call_DirectoryAspsList_599650; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the ASPs issued by a user.
  ## 
  let valid = call_599661.validator(path, query, header, formData, body)
  let scheme = call_599661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599661.url(scheme.get, call_599661.host, call_599661.base,
                         call_599661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599661, url, valid)

proc call*(call_599662: Call_DirectoryAspsList_599650; userKey: string;
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
  var path_599663 = newJObject()
  var query_599664 = newJObject()
  add(query_599664, "fields", newJString(fields))
  add(query_599664, "quotaUser", newJString(quotaUser))
  add(query_599664, "alt", newJString(alt))
  add(query_599664, "oauth_token", newJString(oauthToken))
  add(query_599664, "userIp", newJString(userIp))
  add(path_599663, "userKey", newJString(userKey))
  add(query_599664, "key", newJString(key))
  add(query_599664, "prettyPrint", newJBool(prettyPrint))
  result = call_599662.call(path_599663, query_599664, nil, nil, nil)

var directoryAspsList* = Call_DirectoryAspsList_599650(name: "directoryAspsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/users/{userKey}/asps", validator: validate_DirectoryAspsList_599651,
    base: "/admin/directory/v1", url: url_DirectoryAspsList_599652,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsGet_599665 = ref object of OpenApiRestCall_597437
proc url_DirectoryAspsGet_599667(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryAspsGet_599666(path: JsonNode; query: JsonNode;
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
  var valid_599668 = path.getOrDefault("userKey")
  valid_599668 = validateParameter(valid_599668, JString, required = true,
                                 default = nil)
  if valid_599668 != nil:
    section.add "userKey", valid_599668
  var valid_599669 = path.getOrDefault("codeId")
  valid_599669 = validateParameter(valid_599669, JInt, required = true, default = nil)
  if valid_599669 != nil:
    section.add "codeId", valid_599669
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
  var valid_599670 = query.getOrDefault("fields")
  valid_599670 = validateParameter(valid_599670, JString, required = false,
                                 default = nil)
  if valid_599670 != nil:
    section.add "fields", valid_599670
  var valid_599671 = query.getOrDefault("quotaUser")
  valid_599671 = validateParameter(valid_599671, JString, required = false,
                                 default = nil)
  if valid_599671 != nil:
    section.add "quotaUser", valid_599671
  var valid_599672 = query.getOrDefault("alt")
  valid_599672 = validateParameter(valid_599672, JString, required = false,
                                 default = newJString("json"))
  if valid_599672 != nil:
    section.add "alt", valid_599672
  var valid_599673 = query.getOrDefault("oauth_token")
  valid_599673 = validateParameter(valid_599673, JString, required = false,
                                 default = nil)
  if valid_599673 != nil:
    section.add "oauth_token", valid_599673
  var valid_599674 = query.getOrDefault("userIp")
  valid_599674 = validateParameter(valid_599674, JString, required = false,
                                 default = nil)
  if valid_599674 != nil:
    section.add "userIp", valid_599674
  var valid_599675 = query.getOrDefault("key")
  valid_599675 = validateParameter(valid_599675, JString, required = false,
                                 default = nil)
  if valid_599675 != nil:
    section.add "key", valid_599675
  var valid_599676 = query.getOrDefault("prettyPrint")
  valid_599676 = validateParameter(valid_599676, JBool, required = false,
                                 default = newJBool(true))
  if valid_599676 != nil:
    section.add "prettyPrint", valid_599676
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599677: Call_DirectoryAspsGet_599665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about an ASP issued by a user.
  ## 
  let valid = call_599677.validator(path, query, header, formData, body)
  let scheme = call_599677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599677.url(scheme.get, call_599677.host, call_599677.base,
                         call_599677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599677, url, valid)

proc call*(call_599678: Call_DirectoryAspsGet_599665; userKey: string; codeId: int;
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
  var path_599679 = newJObject()
  var query_599680 = newJObject()
  add(query_599680, "fields", newJString(fields))
  add(query_599680, "quotaUser", newJString(quotaUser))
  add(query_599680, "alt", newJString(alt))
  add(query_599680, "oauth_token", newJString(oauthToken))
  add(query_599680, "userIp", newJString(userIp))
  add(path_599679, "userKey", newJString(userKey))
  add(query_599680, "key", newJString(key))
  add(path_599679, "codeId", newJInt(codeId))
  add(query_599680, "prettyPrint", newJBool(prettyPrint))
  result = call_599678.call(path_599679, query_599680, nil, nil, nil)

var directoryAspsGet* = Call_DirectoryAspsGet_599665(name: "directoryAspsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/users/{userKey}/asps/{codeId}", validator: validate_DirectoryAspsGet_599666,
    base: "/admin/directory/v1", url: url_DirectoryAspsGet_599667,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsDelete_599681 = ref object of OpenApiRestCall_597437
proc url_DirectoryAspsDelete_599683(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryAspsDelete_599682(path: JsonNode; query: JsonNode;
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
  var valid_599684 = path.getOrDefault("userKey")
  valid_599684 = validateParameter(valid_599684, JString, required = true,
                                 default = nil)
  if valid_599684 != nil:
    section.add "userKey", valid_599684
  var valid_599685 = path.getOrDefault("codeId")
  valid_599685 = validateParameter(valid_599685, JInt, required = true, default = nil)
  if valid_599685 != nil:
    section.add "codeId", valid_599685
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
  var valid_599686 = query.getOrDefault("fields")
  valid_599686 = validateParameter(valid_599686, JString, required = false,
                                 default = nil)
  if valid_599686 != nil:
    section.add "fields", valid_599686
  var valid_599687 = query.getOrDefault("quotaUser")
  valid_599687 = validateParameter(valid_599687, JString, required = false,
                                 default = nil)
  if valid_599687 != nil:
    section.add "quotaUser", valid_599687
  var valid_599688 = query.getOrDefault("alt")
  valid_599688 = validateParameter(valid_599688, JString, required = false,
                                 default = newJString("json"))
  if valid_599688 != nil:
    section.add "alt", valid_599688
  var valid_599689 = query.getOrDefault("oauth_token")
  valid_599689 = validateParameter(valid_599689, JString, required = false,
                                 default = nil)
  if valid_599689 != nil:
    section.add "oauth_token", valid_599689
  var valid_599690 = query.getOrDefault("userIp")
  valid_599690 = validateParameter(valid_599690, JString, required = false,
                                 default = nil)
  if valid_599690 != nil:
    section.add "userIp", valid_599690
  var valid_599691 = query.getOrDefault("key")
  valid_599691 = validateParameter(valid_599691, JString, required = false,
                                 default = nil)
  if valid_599691 != nil:
    section.add "key", valid_599691
  var valid_599692 = query.getOrDefault("prettyPrint")
  valid_599692 = validateParameter(valid_599692, JBool, required = false,
                                 default = newJBool(true))
  if valid_599692 != nil:
    section.add "prettyPrint", valid_599692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599693: Call_DirectoryAspsDelete_599681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an ASP issued by a user.
  ## 
  let valid = call_599693.validator(path, query, header, formData, body)
  let scheme = call_599693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599693.url(scheme.get, call_599693.host, call_599693.base,
                         call_599693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599693, url, valid)

proc call*(call_599694: Call_DirectoryAspsDelete_599681; userKey: string;
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
  var path_599695 = newJObject()
  var query_599696 = newJObject()
  add(query_599696, "fields", newJString(fields))
  add(query_599696, "quotaUser", newJString(quotaUser))
  add(query_599696, "alt", newJString(alt))
  add(query_599696, "oauth_token", newJString(oauthToken))
  add(query_599696, "userIp", newJString(userIp))
  add(path_599695, "userKey", newJString(userKey))
  add(query_599696, "key", newJString(key))
  add(path_599695, "codeId", newJInt(codeId))
  add(query_599696, "prettyPrint", newJBool(prettyPrint))
  result = call_599694.call(path_599695, query_599696, nil, nil, nil)

var directoryAspsDelete* = Call_DirectoryAspsDelete_599681(
    name: "directoryAspsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/asps/{codeId}",
    validator: validate_DirectoryAspsDelete_599682, base: "/admin/directory/v1",
    url: url_DirectoryAspsDelete_599683, schemes: {Scheme.Https})
type
  Call_DirectoryUsersMakeAdmin_599697 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersMakeAdmin_599699(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryUsersMakeAdmin_599698(path: JsonNode; query: JsonNode;
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
  var valid_599700 = path.getOrDefault("userKey")
  valid_599700 = validateParameter(valid_599700, JString, required = true,
                                 default = nil)
  if valid_599700 != nil:
    section.add "userKey", valid_599700
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
  var valid_599701 = query.getOrDefault("fields")
  valid_599701 = validateParameter(valid_599701, JString, required = false,
                                 default = nil)
  if valid_599701 != nil:
    section.add "fields", valid_599701
  var valid_599702 = query.getOrDefault("quotaUser")
  valid_599702 = validateParameter(valid_599702, JString, required = false,
                                 default = nil)
  if valid_599702 != nil:
    section.add "quotaUser", valid_599702
  var valid_599703 = query.getOrDefault("alt")
  valid_599703 = validateParameter(valid_599703, JString, required = false,
                                 default = newJString("json"))
  if valid_599703 != nil:
    section.add "alt", valid_599703
  var valid_599704 = query.getOrDefault("oauth_token")
  valid_599704 = validateParameter(valid_599704, JString, required = false,
                                 default = nil)
  if valid_599704 != nil:
    section.add "oauth_token", valid_599704
  var valid_599705 = query.getOrDefault("userIp")
  valid_599705 = validateParameter(valid_599705, JString, required = false,
                                 default = nil)
  if valid_599705 != nil:
    section.add "userIp", valid_599705
  var valid_599706 = query.getOrDefault("key")
  valid_599706 = validateParameter(valid_599706, JString, required = false,
                                 default = nil)
  if valid_599706 != nil:
    section.add "key", valid_599706
  var valid_599707 = query.getOrDefault("prettyPrint")
  valid_599707 = validateParameter(valid_599707, JBool, required = false,
                                 default = newJBool(true))
  if valid_599707 != nil:
    section.add "prettyPrint", valid_599707
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

proc call*(call_599709: Call_DirectoryUsersMakeAdmin_599697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## change admin status of a user
  ## 
  let valid = call_599709.validator(path, query, header, formData, body)
  let scheme = call_599709.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599709.url(scheme.get, call_599709.host, call_599709.base,
                         call_599709.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599709, url, valid)

proc call*(call_599710: Call_DirectoryUsersMakeAdmin_599697; userKey: string;
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
  var path_599711 = newJObject()
  var query_599712 = newJObject()
  var body_599713 = newJObject()
  add(query_599712, "fields", newJString(fields))
  add(query_599712, "quotaUser", newJString(quotaUser))
  add(query_599712, "alt", newJString(alt))
  add(query_599712, "oauth_token", newJString(oauthToken))
  add(query_599712, "userIp", newJString(userIp))
  add(path_599711, "userKey", newJString(userKey))
  add(query_599712, "key", newJString(key))
  if body != nil:
    body_599713 = body
  add(query_599712, "prettyPrint", newJBool(prettyPrint))
  result = call_599710.call(path_599711, query_599712, nil, nil, body_599713)

var directoryUsersMakeAdmin* = Call_DirectoryUsersMakeAdmin_599697(
    name: "directoryUsersMakeAdmin", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/makeAdmin",
    validator: validate_DirectoryUsersMakeAdmin_599698,
    base: "/admin/directory/v1", url: url_DirectoryUsersMakeAdmin_599699,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosUpdate_599729 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersPhotosUpdate_599731(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryUsersPhotosUpdate_599730(path: JsonNode; query: JsonNode;
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
  var valid_599732 = path.getOrDefault("userKey")
  valid_599732 = validateParameter(valid_599732, JString, required = true,
                                 default = nil)
  if valid_599732 != nil:
    section.add "userKey", valid_599732
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
  var valid_599733 = query.getOrDefault("fields")
  valid_599733 = validateParameter(valid_599733, JString, required = false,
                                 default = nil)
  if valid_599733 != nil:
    section.add "fields", valid_599733
  var valid_599734 = query.getOrDefault("quotaUser")
  valid_599734 = validateParameter(valid_599734, JString, required = false,
                                 default = nil)
  if valid_599734 != nil:
    section.add "quotaUser", valid_599734
  var valid_599735 = query.getOrDefault("alt")
  valid_599735 = validateParameter(valid_599735, JString, required = false,
                                 default = newJString("json"))
  if valid_599735 != nil:
    section.add "alt", valid_599735
  var valid_599736 = query.getOrDefault("oauth_token")
  valid_599736 = validateParameter(valid_599736, JString, required = false,
                                 default = nil)
  if valid_599736 != nil:
    section.add "oauth_token", valid_599736
  var valid_599737 = query.getOrDefault("userIp")
  valid_599737 = validateParameter(valid_599737, JString, required = false,
                                 default = nil)
  if valid_599737 != nil:
    section.add "userIp", valid_599737
  var valid_599738 = query.getOrDefault("key")
  valid_599738 = validateParameter(valid_599738, JString, required = false,
                                 default = nil)
  if valid_599738 != nil:
    section.add "key", valid_599738
  var valid_599739 = query.getOrDefault("prettyPrint")
  valid_599739 = validateParameter(valid_599739, JBool, required = false,
                                 default = newJBool(true))
  if valid_599739 != nil:
    section.add "prettyPrint", valid_599739
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

proc call*(call_599741: Call_DirectoryUsersPhotosUpdate_599729; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a photo for the user
  ## 
  let valid = call_599741.validator(path, query, header, formData, body)
  let scheme = call_599741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599741.url(scheme.get, call_599741.host, call_599741.base,
                         call_599741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599741, url, valid)

proc call*(call_599742: Call_DirectoryUsersPhotosUpdate_599729; userKey: string;
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
  var path_599743 = newJObject()
  var query_599744 = newJObject()
  var body_599745 = newJObject()
  add(query_599744, "fields", newJString(fields))
  add(query_599744, "quotaUser", newJString(quotaUser))
  add(query_599744, "alt", newJString(alt))
  add(query_599744, "oauth_token", newJString(oauthToken))
  add(query_599744, "userIp", newJString(userIp))
  add(path_599743, "userKey", newJString(userKey))
  add(query_599744, "key", newJString(key))
  if body != nil:
    body_599745 = body
  add(query_599744, "prettyPrint", newJBool(prettyPrint))
  result = call_599742.call(path_599743, query_599744, nil, nil, body_599745)

var directoryUsersPhotosUpdate* = Call_DirectoryUsersPhotosUpdate_599729(
    name: "directoryUsersPhotosUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosUpdate_599730,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosUpdate_599731,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosGet_599714 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersPhotosGet_599716(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryUsersPhotosGet_599715(path: JsonNode; query: JsonNode;
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
  var valid_599717 = path.getOrDefault("userKey")
  valid_599717 = validateParameter(valid_599717, JString, required = true,
                                 default = nil)
  if valid_599717 != nil:
    section.add "userKey", valid_599717
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
  var valid_599718 = query.getOrDefault("fields")
  valid_599718 = validateParameter(valid_599718, JString, required = false,
                                 default = nil)
  if valid_599718 != nil:
    section.add "fields", valid_599718
  var valid_599719 = query.getOrDefault("quotaUser")
  valid_599719 = validateParameter(valid_599719, JString, required = false,
                                 default = nil)
  if valid_599719 != nil:
    section.add "quotaUser", valid_599719
  var valid_599720 = query.getOrDefault("alt")
  valid_599720 = validateParameter(valid_599720, JString, required = false,
                                 default = newJString("json"))
  if valid_599720 != nil:
    section.add "alt", valid_599720
  var valid_599721 = query.getOrDefault("oauth_token")
  valid_599721 = validateParameter(valid_599721, JString, required = false,
                                 default = nil)
  if valid_599721 != nil:
    section.add "oauth_token", valid_599721
  var valid_599722 = query.getOrDefault("userIp")
  valid_599722 = validateParameter(valid_599722, JString, required = false,
                                 default = nil)
  if valid_599722 != nil:
    section.add "userIp", valid_599722
  var valid_599723 = query.getOrDefault("key")
  valid_599723 = validateParameter(valid_599723, JString, required = false,
                                 default = nil)
  if valid_599723 != nil:
    section.add "key", valid_599723
  var valid_599724 = query.getOrDefault("prettyPrint")
  valid_599724 = validateParameter(valid_599724, JBool, required = false,
                                 default = newJBool(true))
  if valid_599724 != nil:
    section.add "prettyPrint", valid_599724
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599725: Call_DirectoryUsersPhotosGet_599714; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve photo of a user
  ## 
  let valid = call_599725.validator(path, query, header, formData, body)
  let scheme = call_599725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599725.url(scheme.get, call_599725.host, call_599725.base,
                         call_599725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599725, url, valid)

proc call*(call_599726: Call_DirectoryUsersPhotosGet_599714; userKey: string;
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
  var path_599727 = newJObject()
  var query_599728 = newJObject()
  add(query_599728, "fields", newJString(fields))
  add(query_599728, "quotaUser", newJString(quotaUser))
  add(query_599728, "alt", newJString(alt))
  add(query_599728, "oauth_token", newJString(oauthToken))
  add(query_599728, "userIp", newJString(userIp))
  add(path_599727, "userKey", newJString(userKey))
  add(query_599728, "key", newJString(key))
  add(query_599728, "prettyPrint", newJBool(prettyPrint))
  result = call_599726.call(path_599727, query_599728, nil, nil, nil)

var directoryUsersPhotosGet* = Call_DirectoryUsersPhotosGet_599714(
    name: "directoryUsersPhotosGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosGet_599715,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosGet_599716,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosPatch_599761 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersPhotosPatch_599763(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryUsersPhotosPatch_599762(path: JsonNode; query: JsonNode;
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
  var valid_599764 = path.getOrDefault("userKey")
  valid_599764 = validateParameter(valid_599764, JString, required = true,
                                 default = nil)
  if valid_599764 != nil:
    section.add "userKey", valid_599764
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
  var valid_599765 = query.getOrDefault("fields")
  valid_599765 = validateParameter(valid_599765, JString, required = false,
                                 default = nil)
  if valid_599765 != nil:
    section.add "fields", valid_599765
  var valid_599766 = query.getOrDefault("quotaUser")
  valid_599766 = validateParameter(valid_599766, JString, required = false,
                                 default = nil)
  if valid_599766 != nil:
    section.add "quotaUser", valid_599766
  var valid_599767 = query.getOrDefault("alt")
  valid_599767 = validateParameter(valid_599767, JString, required = false,
                                 default = newJString("json"))
  if valid_599767 != nil:
    section.add "alt", valid_599767
  var valid_599768 = query.getOrDefault("oauth_token")
  valid_599768 = validateParameter(valid_599768, JString, required = false,
                                 default = nil)
  if valid_599768 != nil:
    section.add "oauth_token", valid_599768
  var valid_599769 = query.getOrDefault("userIp")
  valid_599769 = validateParameter(valid_599769, JString, required = false,
                                 default = nil)
  if valid_599769 != nil:
    section.add "userIp", valid_599769
  var valid_599770 = query.getOrDefault("key")
  valid_599770 = validateParameter(valid_599770, JString, required = false,
                                 default = nil)
  if valid_599770 != nil:
    section.add "key", valid_599770
  var valid_599771 = query.getOrDefault("prettyPrint")
  valid_599771 = validateParameter(valid_599771, JBool, required = false,
                                 default = newJBool(true))
  if valid_599771 != nil:
    section.add "prettyPrint", valid_599771
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

proc call*(call_599773: Call_DirectoryUsersPhotosPatch_599761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a photo for the user. This method supports patch semantics.
  ## 
  let valid = call_599773.validator(path, query, header, formData, body)
  let scheme = call_599773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599773.url(scheme.get, call_599773.host, call_599773.base,
                         call_599773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599773, url, valid)

proc call*(call_599774: Call_DirectoryUsersPhotosPatch_599761; userKey: string;
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
  var path_599775 = newJObject()
  var query_599776 = newJObject()
  var body_599777 = newJObject()
  add(query_599776, "fields", newJString(fields))
  add(query_599776, "quotaUser", newJString(quotaUser))
  add(query_599776, "alt", newJString(alt))
  add(query_599776, "oauth_token", newJString(oauthToken))
  add(query_599776, "userIp", newJString(userIp))
  add(path_599775, "userKey", newJString(userKey))
  add(query_599776, "key", newJString(key))
  if body != nil:
    body_599777 = body
  add(query_599776, "prettyPrint", newJBool(prettyPrint))
  result = call_599774.call(path_599775, query_599776, nil, nil, body_599777)

var directoryUsersPhotosPatch* = Call_DirectoryUsersPhotosPatch_599761(
    name: "directoryUsersPhotosPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosPatch_599762,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosPatch_599763,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosDelete_599746 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersPhotosDelete_599748(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryUsersPhotosDelete_599747(path: JsonNode; query: JsonNode;
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
  var valid_599749 = path.getOrDefault("userKey")
  valid_599749 = validateParameter(valid_599749, JString, required = true,
                                 default = nil)
  if valid_599749 != nil:
    section.add "userKey", valid_599749
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
  var valid_599750 = query.getOrDefault("fields")
  valid_599750 = validateParameter(valid_599750, JString, required = false,
                                 default = nil)
  if valid_599750 != nil:
    section.add "fields", valid_599750
  var valid_599751 = query.getOrDefault("quotaUser")
  valid_599751 = validateParameter(valid_599751, JString, required = false,
                                 default = nil)
  if valid_599751 != nil:
    section.add "quotaUser", valid_599751
  var valid_599752 = query.getOrDefault("alt")
  valid_599752 = validateParameter(valid_599752, JString, required = false,
                                 default = newJString("json"))
  if valid_599752 != nil:
    section.add "alt", valid_599752
  var valid_599753 = query.getOrDefault("oauth_token")
  valid_599753 = validateParameter(valid_599753, JString, required = false,
                                 default = nil)
  if valid_599753 != nil:
    section.add "oauth_token", valid_599753
  var valid_599754 = query.getOrDefault("userIp")
  valid_599754 = validateParameter(valid_599754, JString, required = false,
                                 default = nil)
  if valid_599754 != nil:
    section.add "userIp", valid_599754
  var valid_599755 = query.getOrDefault("key")
  valid_599755 = validateParameter(valid_599755, JString, required = false,
                                 default = nil)
  if valid_599755 != nil:
    section.add "key", valid_599755
  var valid_599756 = query.getOrDefault("prettyPrint")
  valid_599756 = validateParameter(valid_599756, JBool, required = false,
                                 default = newJBool(true))
  if valid_599756 != nil:
    section.add "prettyPrint", valid_599756
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599757: Call_DirectoryUsersPhotosDelete_599746; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove photos for the user
  ## 
  let valid = call_599757.validator(path, query, header, formData, body)
  let scheme = call_599757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599757.url(scheme.get, call_599757.host, call_599757.base,
                         call_599757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599757, url, valid)

proc call*(call_599758: Call_DirectoryUsersPhotosDelete_599746; userKey: string;
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
  var path_599759 = newJObject()
  var query_599760 = newJObject()
  add(query_599760, "fields", newJString(fields))
  add(query_599760, "quotaUser", newJString(quotaUser))
  add(query_599760, "alt", newJString(alt))
  add(query_599760, "oauth_token", newJString(oauthToken))
  add(query_599760, "userIp", newJString(userIp))
  add(path_599759, "userKey", newJString(userKey))
  add(query_599760, "key", newJString(key))
  add(query_599760, "prettyPrint", newJBool(prettyPrint))
  result = call_599758.call(path_599759, query_599760, nil, nil, nil)

var directoryUsersPhotosDelete* = Call_DirectoryUsersPhotosDelete_599746(
    name: "directoryUsersPhotosDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosDelete_599747,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosDelete_599748,
    schemes: {Scheme.Https})
type
  Call_DirectoryTokensList_599778 = ref object of OpenApiRestCall_597437
proc url_DirectoryTokensList_599780(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryTokensList_599779(path: JsonNode; query: JsonNode;
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
  var valid_599781 = path.getOrDefault("userKey")
  valid_599781 = validateParameter(valid_599781, JString, required = true,
                                 default = nil)
  if valid_599781 != nil:
    section.add "userKey", valid_599781
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
  var valid_599782 = query.getOrDefault("fields")
  valid_599782 = validateParameter(valid_599782, JString, required = false,
                                 default = nil)
  if valid_599782 != nil:
    section.add "fields", valid_599782
  var valid_599783 = query.getOrDefault("quotaUser")
  valid_599783 = validateParameter(valid_599783, JString, required = false,
                                 default = nil)
  if valid_599783 != nil:
    section.add "quotaUser", valid_599783
  var valid_599784 = query.getOrDefault("alt")
  valid_599784 = validateParameter(valid_599784, JString, required = false,
                                 default = newJString("json"))
  if valid_599784 != nil:
    section.add "alt", valid_599784
  var valid_599785 = query.getOrDefault("oauth_token")
  valid_599785 = validateParameter(valid_599785, JString, required = false,
                                 default = nil)
  if valid_599785 != nil:
    section.add "oauth_token", valid_599785
  var valid_599786 = query.getOrDefault("userIp")
  valid_599786 = validateParameter(valid_599786, JString, required = false,
                                 default = nil)
  if valid_599786 != nil:
    section.add "userIp", valid_599786
  var valid_599787 = query.getOrDefault("key")
  valid_599787 = validateParameter(valid_599787, JString, required = false,
                                 default = nil)
  if valid_599787 != nil:
    section.add "key", valid_599787
  var valid_599788 = query.getOrDefault("prettyPrint")
  valid_599788 = validateParameter(valid_599788, JBool, required = false,
                                 default = newJBool(true))
  if valid_599788 != nil:
    section.add "prettyPrint", valid_599788
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599789: Call_DirectoryTokensList_599778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the set of tokens specified user has issued to 3rd party applications.
  ## 
  let valid = call_599789.validator(path, query, header, formData, body)
  let scheme = call_599789.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599789.url(scheme.get, call_599789.host, call_599789.base,
                         call_599789.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599789, url, valid)

proc call*(call_599790: Call_DirectoryTokensList_599778; userKey: string;
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
  var path_599791 = newJObject()
  var query_599792 = newJObject()
  add(query_599792, "fields", newJString(fields))
  add(query_599792, "quotaUser", newJString(quotaUser))
  add(query_599792, "alt", newJString(alt))
  add(query_599792, "oauth_token", newJString(oauthToken))
  add(query_599792, "userIp", newJString(userIp))
  add(path_599791, "userKey", newJString(userKey))
  add(query_599792, "key", newJString(key))
  add(query_599792, "prettyPrint", newJBool(prettyPrint))
  result = call_599790.call(path_599791, query_599792, nil, nil, nil)

var directoryTokensList* = Call_DirectoryTokensList_599778(
    name: "directoryTokensList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens",
    validator: validate_DirectoryTokensList_599779, base: "/admin/directory/v1",
    url: url_DirectoryTokensList_599780, schemes: {Scheme.Https})
type
  Call_DirectoryTokensGet_599793 = ref object of OpenApiRestCall_597437
proc url_DirectoryTokensGet_599795(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryTokensGet_599794(path: JsonNode; query: JsonNode;
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
  var valid_599796 = path.getOrDefault("clientId")
  valid_599796 = validateParameter(valid_599796, JString, required = true,
                                 default = nil)
  if valid_599796 != nil:
    section.add "clientId", valid_599796
  var valid_599797 = path.getOrDefault("userKey")
  valid_599797 = validateParameter(valid_599797, JString, required = true,
                                 default = nil)
  if valid_599797 != nil:
    section.add "userKey", valid_599797
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
  var valid_599798 = query.getOrDefault("fields")
  valid_599798 = validateParameter(valid_599798, JString, required = false,
                                 default = nil)
  if valid_599798 != nil:
    section.add "fields", valid_599798
  var valid_599799 = query.getOrDefault("quotaUser")
  valid_599799 = validateParameter(valid_599799, JString, required = false,
                                 default = nil)
  if valid_599799 != nil:
    section.add "quotaUser", valid_599799
  var valid_599800 = query.getOrDefault("alt")
  valid_599800 = validateParameter(valid_599800, JString, required = false,
                                 default = newJString("json"))
  if valid_599800 != nil:
    section.add "alt", valid_599800
  var valid_599801 = query.getOrDefault("oauth_token")
  valid_599801 = validateParameter(valid_599801, JString, required = false,
                                 default = nil)
  if valid_599801 != nil:
    section.add "oauth_token", valid_599801
  var valid_599802 = query.getOrDefault("userIp")
  valid_599802 = validateParameter(valid_599802, JString, required = false,
                                 default = nil)
  if valid_599802 != nil:
    section.add "userIp", valid_599802
  var valid_599803 = query.getOrDefault("key")
  valid_599803 = validateParameter(valid_599803, JString, required = false,
                                 default = nil)
  if valid_599803 != nil:
    section.add "key", valid_599803
  var valid_599804 = query.getOrDefault("prettyPrint")
  valid_599804 = validateParameter(valid_599804, JBool, required = false,
                                 default = newJBool(true))
  if valid_599804 != nil:
    section.add "prettyPrint", valid_599804
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599805: Call_DirectoryTokensGet_599793; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about an access token issued by a user.
  ## 
  let valid = call_599805.validator(path, query, header, formData, body)
  let scheme = call_599805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599805.url(scheme.get, call_599805.host, call_599805.base,
                         call_599805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599805, url, valid)

proc call*(call_599806: Call_DirectoryTokensGet_599793; clientId: string;
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
  var path_599807 = newJObject()
  var query_599808 = newJObject()
  add(query_599808, "fields", newJString(fields))
  add(query_599808, "quotaUser", newJString(quotaUser))
  add(query_599808, "alt", newJString(alt))
  add(query_599808, "oauth_token", newJString(oauthToken))
  add(query_599808, "userIp", newJString(userIp))
  add(path_599807, "clientId", newJString(clientId))
  add(path_599807, "userKey", newJString(userKey))
  add(query_599808, "key", newJString(key))
  add(query_599808, "prettyPrint", newJBool(prettyPrint))
  result = call_599806.call(path_599807, query_599808, nil, nil, nil)

var directoryTokensGet* = Call_DirectoryTokensGet_599793(
    name: "directoryTokensGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens/{clientId}",
    validator: validate_DirectoryTokensGet_599794, base: "/admin/directory/v1",
    url: url_DirectoryTokensGet_599795, schemes: {Scheme.Https})
type
  Call_DirectoryTokensDelete_599809 = ref object of OpenApiRestCall_597437
proc url_DirectoryTokensDelete_599811(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryTokensDelete_599810(path: JsonNode; query: JsonNode;
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
  var valid_599812 = path.getOrDefault("clientId")
  valid_599812 = validateParameter(valid_599812, JString, required = true,
                                 default = nil)
  if valid_599812 != nil:
    section.add "clientId", valid_599812
  var valid_599813 = path.getOrDefault("userKey")
  valid_599813 = validateParameter(valid_599813, JString, required = true,
                                 default = nil)
  if valid_599813 != nil:
    section.add "userKey", valid_599813
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
  var valid_599814 = query.getOrDefault("fields")
  valid_599814 = validateParameter(valid_599814, JString, required = false,
                                 default = nil)
  if valid_599814 != nil:
    section.add "fields", valid_599814
  var valid_599815 = query.getOrDefault("quotaUser")
  valid_599815 = validateParameter(valid_599815, JString, required = false,
                                 default = nil)
  if valid_599815 != nil:
    section.add "quotaUser", valid_599815
  var valid_599816 = query.getOrDefault("alt")
  valid_599816 = validateParameter(valid_599816, JString, required = false,
                                 default = newJString("json"))
  if valid_599816 != nil:
    section.add "alt", valid_599816
  var valid_599817 = query.getOrDefault("oauth_token")
  valid_599817 = validateParameter(valid_599817, JString, required = false,
                                 default = nil)
  if valid_599817 != nil:
    section.add "oauth_token", valid_599817
  var valid_599818 = query.getOrDefault("userIp")
  valid_599818 = validateParameter(valid_599818, JString, required = false,
                                 default = nil)
  if valid_599818 != nil:
    section.add "userIp", valid_599818
  var valid_599819 = query.getOrDefault("key")
  valid_599819 = validateParameter(valid_599819, JString, required = false,
                                 default = nil)
  if valid_599819 != nil:
    section.add "key", valid_599819
  var valid_599820 = query.getOrDefault("prettyPrint")
  valid_599820 = validateParameter(valid_599820, JBool, required = false,
                                 default = newJBool(true))
  if valid_599820 != nil:
    section.add "prettyPrint", valid_599820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599821: Call_DirectoryTokensDelete_599809; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete all access tokens issued by a user for an application.
  ## 
  let valid = call_599821.validator(path, query, header, formData, body)
  let scheme = call_599821.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599821.url(scheme.get, call_599821.host, call_599821.base,
                         call_599821.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599821, url, valid)

proc call*(call_599822: Call_DirectoryTokensDelete_599809; clientId: string;
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
  var path_599823 = newJObject()
  var query_599824 = newJObject()
  add(query_599824, "fields", newJString(fields))
  add(query_599824, "quotaUser", newJString(quotaUser))
  add(query_599824, "alt", newJString(alt))
  add(query_599824, "oauth_token", newJString(oauthToken))
  add(query_599824, "userIp", newJString(userIp))
  add(path_599823, "clientId", newJString(clientId))
  add(path_599823, "userKey", newJString(userKey))
  add(query_599824, "key", newJString(key))
  add(query_599824, "prettyPrint", newJBool(prettyPrint))
  result = call_599822.call(path_599823, query_599824, nil, nil, nil)

var directoryTokensDelete* = Call_DirectoryTokensDelete_599809(
    name: "directoryTokensDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens/{clientId}",
    validator: validate_DirectoryTokensDelete_599810, base: "/admin/directory/v1",
    url: url_DirectoryTokensDelete_599811, schemes: {Scheme.Https})
type
  Call_DirectoryUsersUndelete_599825 = ref object of OpenApiRestCall_597437
proc url_DirectoryUsersUndelete_599827(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryUsersUndelete_599826(path: JsonNode; query: JsonNode;
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
  var valid_599828 = path.getOrDefault("userKey")
  valid_599828 = validateParameter(valid_599828, JString, required = true,
                                 default = nil)
  if valid_599828 != nil:
    section.add "userKey", valid_599828
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
  var valid_599829 = query.getOrDefault("fields")
  valid_599829 = validateParameter(valid_599829, JString, required = false,
                                 default = nil)
  if valid_599829 != nil:
    section.add "fields", valid_599829
  var valid_599830 = query.getOrDefault("quotaUser")
  valid_599830 = validateParameter(valid_599830, JString, required = false,
                                 default = nil)
  if valid_599830 != nil:
    section.add "quotaUser", valid_599830
  var valid_599831 = query.getOrDefault("alt")
  valid_599831 = validateParameter(valid_599831, JString, required = false,
                                 default = newJString("json"))
  if valid_599831 != nil:
    section.add "alt", valid_599831
  var valid_599832 = query.getOrDefault("oauth_token")
  valid_599832 = validateParameter(valid_599832, JString, required = false,
                                 default = nil)
  if valid_599832 != nil:
    section.add "oauth_token", valid_599832
  var valid_599833 = query.getOrDefault("userIp")
  valid_599833 = validateParameter(valid_599833, JString, required = false,
                                 default = nil)
  if valid_599833 != nil:
    section.add "userIp", valid_599833
  var valid_599834 = query.getOrDefault("key")
  valid_599834 = validateParameter(valid_599834, JString, required = false,
                                 default = nil)
  if valid_599834 != nil:
    section.add "key", valid_599834
  var valid_599835 = query.getOrDefault("prettyPrint")
  valid_599835 = validateParameter(valid_599835, JBool, required = false,
                                 default = newJBool(true))
  if valid_599835 != nil:
    section.add "prettyPrint", valid_599835
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

proc call*(call_599837: Call_DirectoryUsersUndelete_599825; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undelete a deleted user
  ## 
  let valid = call_599837.validator(path, query, header, formData, body)
  let scheme = call_599837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599837.url(scheme.get, call_599837.host, call_599837.base,
                         call_599837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599837, url, valid)

proc call*(call_599838: Call_DirectoryUsersUndelete_599825; userKey: string;
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
  var path_599839 = newJObject()
  var query_599840 = newJObject()
  var body_599841 = newJObject()
  add(query_599840, "fields", newJString(fields))
  add(query_599840, "quotaUser", newJString(quotaUser))
  add(query_599840, "alt", newJString(alt))
  add(query_599840, "oauth_token", newJString(oauthToken))
  add(query_599840, "userIp", newJString(userIp))
  add(path_599839, "userKey", newJString(userKey))
  add(query_599840, "key", newJString(key))
  if body != nil:
    body_599841 = body
  add(query_599840, "prettyPrint", newJBool(prettyPrint))
  result = call_599838.call(path_599839, query_599840, nil, nil, body_599841)

var directoryUsersUndelete* = Call_DirectoryUsersUndelete_599825(
    name: "directoryUsersUndelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/undelete",
    validator: validate_DirectoryUsersUndelete_599826,
    base: "/admin/directory/v1", url: url_DirectoryUsersUndelete_599827,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesList_599842 = ref object of OpenApiRestCall_597437
proc url_DirectoryVerificationCodesList_599844(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryVerificationCodesList_599843(path: JsonNode;
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
  var valid_599845 = path.getOrDefault("userKey")
  valid_599845 = validateParameter(valid_599845, JString, required = true,
                                 default = nil)
  if valid_599845 != nil:
    section.add "userKey", valid_599845
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
  var valid_599846 = query.getOrDefault("fields")
  valid_599846 = validateParameter(valid_599846, JString, required = false,
                                 default = nil)
  if valid_599846 != nil:
    section.add "fields", valid_599846
  var valid_599847 = query.getOrDefault("quotaUser")
  valid_599847 = validateParameter(valid_599847, JString, required = false,
                                 default = nil)
  if valid_599847 != nil:
    section.add "quotaUser", valid_599847
  var valid_599848 = query.getOrDefault("alt")
  valid_599848 = validateParameter(valid_599848, JString, required = false,
                                 default = newJString("json"))
  if valid_599848 != nil:
    section.add "alt", valid_599848
  var valid_599849 = query.getOrDefault("oauth_token")
  valid_599849 = validateParameter(valid_599849, JString, required = false,
                                 default = nil)
  if valid_599849 != nil:
    section.add "oauth_token", valid_599849
  var valid_599850 = query.getOrDefault("userIp")
  valid_599850 = validateParameter(valid_599850, JString, required = false,
                                 default = nil)
  if valid_599850 != nil:
    section.add "userIp", valid_599850
  var valid_599851 = query.getOrDefault("key")
  valid_599851 = validateParameter(valid_599851, JString, required = false,
                                 default = nil)
  if valid_599851 != nil:
    section.add "key", valid_599851
  var valid_599852 = query.getOrDefault("prettyPrint")
  valid_599852 = validateParameter(valid_599852, JBool, required = false,
                                 default = newJBool(true))
  if valid_599852 != nil:
    section.add "prettyPrint", valid_599852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599853: Call_DirectoryVerificationCodesList_599842; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the current set of valid backup verification codes for the specified user.
  ## 
  let valid = call_599853.validator(path, query, header, formData, body)
  let scheme = call_599853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599853.url(scheme.get, call_599853.host, call_599853.base,
                         call_599853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599853, url, valid)

proc call*(call_599854: Call_DirectoryVerificationCodesList_599842;
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
  var path_599855 = newJObject()
  var query_599856 = newJObject()
  add(query_599856, "fields", newJString(fields))
  add(query_599856, "quotaUser", newJString(quotaUser))
  add(query_599856, "alt", newJString(alt))
  add(query_599856, "oauth_token", newJString(oauthToken))
  add(query_599856, "userIp", newJString(userIp))
  add(path_599855, "userKey", newJString(userKey))
  add(query_599856, "key", newJString(key))
  add(query_599856, "prettyPrint", newJBool(prettyPrint))
  result = call_599854.call(path_599855, query_599856, nil, nil, nil)

var directoryVerificationCodesList* = Call_DirectoryVerificationCodesList_599842(
    name: "directoryVerificationCodesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/verificationCodes",
    validator: validate_DirectoryVerificationCodesList_599843,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesList_599844,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesGenerate_599857 = ref object of OpenApiRestCall_597437
proc url_DirectoryVerificationCodesGenerate_599859(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryVerificationCodesGenerate_599858(path: JsonNode;
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
  var valid_599860 = path.getOrDefault("userKey")
  valid_599860 = validateParameter(valid_599860, JString, required = true,
                                 default = nil)
  if valid_599860 != nil:
    section.add "userKey", valid_599860
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
  var valid_599861 = query.getOrDefault("fields")
  valid_599861 = validateParameter(valid_599861, JString, required = false,
                                 default = nil)
  if valid_599861 != nil:
    section.add "fields", valid_599861
  var valid_599862 = query.getOrDefault("quotaUser")
  valid_599862 = validateParameter(valid_599862, JString, required = false,
                                 default = nil)
  if valid_599862 != nil:
    section.add "quotaUser", valid_599862
  var valid_599863 = query.getOrDefault("alt")
  valid_599863 = validateParameter(valid_599863, JString, required = false,
                                 default = newJString("json"))
  if valid_599863 != nil:
    section.add "alt", valid_599863
  var valid_599864 = query.getOrDefault("oauth_token")
  valid_599864 = validateParameter(valid_599864, JString, required = false,
                                 default = nil)
  if valid_599864 != nil:
    section.add "oauth_token", valid_599864
  var valid_599865 = query.getOrDefault("userIp")
  valid_599865 = validateParameter(valid_599865, JString, required = false,
                                 default = nil)
  if valid_599865 != nil:
    section.add "userIp", valid_599865
  var valid_599866 = query.getOrDefault("key")
  valid_599866 = validateParameter(valid_599866, JString, required = false,
                                 default = nil)
  if valid_599866 != nil:
    section.add "key", valid_599866
  var valid_599867 = query.getOrDefault("prettyPrint")
  valid_599867 = validateParameter(valid_599867, JBool, required = false,
                                 default = newJBool(true))
  if valid_599867 != nil:
    section.add "prettyPrint", valid_599867
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599868: Call_DirectoryVerificationCodesGenerate_599857;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate new backup verification codes for the user.
  ## 
  let valid = call_599868.validator(path, query, header, formData, body)
  let scheme = call_599868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599868.url(scheme.get, call_599868.host, call_599868.base,
                         call_599868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599868, url, valid)

proc call*(call_599869: Call_DirectoryVerificationCodesGenerate_599857;
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
  var path_599870 = newJObject()
  var query_599871 = newJObject()
  add(query_599871, "fields", newJString(fields))
  add(query_599871, "quotaUser", newJString(quotaUser))
  add(query_599871, "alt", newJString(alt))
  add(query_599871, "oauth_token", newJString(oauthToken))
  add(query_599871, "userIp", newJString(userIp))
  add(path_599870, "userKey", newJString(userKey))
  add(query_599871, "key", newJString(key))
  add(query_599871, "prettyPrint", newJBool(prettyPrint))
  result = call_599869.call(path_599870, query_599871, nil, nil, nil)

var directoryVerificationCodesGenerate* = Call_DirectoryVerificationCodesGenerate_599857(
    name: "directoryVerificationCodesGenerate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/users/{userKey}/verificationCodes/generate",
    validator: validate_DirectoryVerificationCodesGenerate_599858,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesGenerate_599859,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesInvalidate_599872 = ref object of OpenApiRestCall_597437
proc url_DirectoryVerificationCodesInvalidate_599874(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DirectoryVerificationCodesInvalidate_599873(path: JsonNode;
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
  var valid_599875 = path.getOrDefault("userKey")
  valid_599875 = validateParameter(valid_599875, JString, required = true,
                                 default = nil)
  if valid_599875 != nil:
    section.add "userKey", valid_599875
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
  var valid_599876 = query.getOrDefault("fields")
  valid_599876 = validateParameter(valid_599876, JString, required = false,
                                 default = nil)
  if valid_599876 != nil:
    section.add "fields", valid_599876
  var valid_599877 = query.getOrDefault("quotaUser")
  valid_599877 = validateParameter(valid_599877, JString, required = false,
                                 default = nil)
  if valid_599877 != nil:
    section.add "quotaUser", valid_599877
  var valid_599878 = query.getOrDefault("alt")
  valid_599878 = validateParameter(valid_599878, JString, required = false,
                                 default = newJString("json"))
  if valid_599878 != nil:
    section.add "alt", valid_599878
  var valid_599879 = query.getOrDefault("oauth_token")
  valid_599879 = validateParameter(valid_599879, JString, required = false,
                                 default = nil)
  if valid_599879 != nil:
    section.add "oauth_token", valid_599879
  var valid_599880 = query.getOrDefault("userIp")
  valid_599880 = validateParameter(valid_599880, JString, required = false,
                                 default = nil)
  if valid_599880 != nil:
    section.add "userIp", valid_599880
  var valid_599881 = query.getOrDefault("key")
  valid_599881 = validateParameter(valid_599881, JString, required = false,
                                 default = nil)
  if valid_599881 != nil:
    section.add "key", valid_599881
  var valid_599882 = query.getOrDefault("prettyPrint")
  valid_599882 = validateParameter(valid_599882, JBool, required = false,
                                 default = newJBool(true))
  if valid_599882 != nil:
    section.add "prettyPrint", valid_599882
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599883: Call_DirectoryVerificationCodesInvalidate_599872;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Invalidate the current backup verification codes for the user.
  ## 
  let valid = call_599883.validator(path, query, header, formData, body)
  let scheme = call_599883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599883.url(scheme.get, call_599883.host, call_599883.base,
                         call_599883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599883, url, valid)

proc call*(call_599884: Call_DirectoryVerificationCodesInvalidate_599872;
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
  var path_599885 = newJObject()
  var query_599886 = newJObject()
  add(query_599886, "fields", newJString(fields))
  add(query_599886, "quotaUser", newJString(quotaUser))
  add(query_599886, "alt", newJString(alt))
  add(query_599886, "oauth_token", newJString(oauthToken))
  add(query_599886, "userIp", newJString(userIp))
  add(path_599885, "userKey", newJString(userKey))
  add(query_599886, "key", newJString(key))
  add(query_599886, "prettyPrint", newJBool(prettyPrint))
  result = call_599884.call(path_599885, query_599886, nil, nil, nil)

var directoryVerificationCodesInvalidate* = Call_DirectoryVerificationCodesInvalidate_599872(
    name: "directoryVerificationCodesInvalidate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/users/{userKey}/verificationCodes/invalidate",
    validator: validate_DirectoryVerificationCodesInvalidate_599873,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesInvalidate_599874,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
