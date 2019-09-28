
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Cloud IoT
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Registers and manages IoT (Internet of Things) devices that connect to the Google Cloud Platform.
## 
## 
## https://cloud.google.com/iot
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
  gcpServiceName = "cloudiot"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudiotProjectsLocationsRegistriesDevicesGet_579677 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesGet_579679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesGet_579678(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets details about a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the device. For example,
  ## `projects/p0/locations/us-central1/registries/registry0/devices/device0` or
  ## `projects/p0/locations/us-central1/registries/registry0/devices/{num_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579805 = path.getOrDefault("name")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "name", valid_579805
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579806 = query.getOrDefault("upload_protocol")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "upload_protocol", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("pp")
  valid_579823 = validateParameter(valid_579823, JBool, required = false,
                                 default = newJBool(true))
  if valid_579823 != nil:
    section.add "pp", valid_579823
  var valid_579824 = query.getOrDefault("oauth_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "oauth_token", valid_579824
  var valid_579825 = query.getOrDefault("callback")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "callback", valid_579825
  var valid_579826 = query.getOrDefault("access_token")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "access_token", valid_579826
  var valid_579827 = query.getOrDefault("uploadType")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "uploadType", valid_579827
  var valid_579828 = query.getOrDefault("key")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "key", valid_579828
  var valid_579829 = query.getOrDefault("$.xgafv")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = newJString("1"))
  if valid_579829 != nil:
    section.add "$.xgafv", valid_579829
  var valid_579830 = query.getOrDefault("prettyPrint")
  valid_579830 = validateParameter(valid_579830, JBool, required = false,
                                 default = newJBool(true))
  if valid_579830 != nil:
    section.add "prettyPrint", valid_579830
  var valid_579831 = query.getOrDefault("bearer_token")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "bearer_token", valid_579831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579854: Call_CloudiotProjectsLocationsRegistriesDevicesGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets details about a device.
  ## 
  let valid = call_579854.validator(path, query, header, formData, body)
  let scheme = call_579854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579854.url(scheme.get, call_579854.host, call_579854.base,
                         call_579854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579854, url, valid)

proc call*(call_579925: Call_CloudiotProjectsLocationsRegistriesDevicesGet_579677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesGet
  ## Gets details about a device.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the device. For example,
  ## `projects/p0/locations/us-central1/registries/registry0/devices/device0` or
  ## `projects/p0/locations/us-central1/registries/registry0/devices/{num_id}`.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_579926 = newJObject()
  var query_579928 = newJObject()
  add(query_579928, "upload_protocol", newJString(uploadProtocol))
  add(query_579928, "fields", newJString(fields))
  add(query_579928, "quotaUser", newJString(quotaUser))
  add(path_579926, "name", newJString(name))
  add(query_579928, "alt", newJString(alt))
  add(query_579928, "pp", newJBool(pp))
  add(query_579928, "oauth_token", newJString(oauthToken))
  add(query_579928, "callback", newJString(callback))
  add(query_579928, "access_token", newJString(accessToken))
  add(query_579928, "uploadType", newJString(uploadType))
  add(query_579928, "key", newJString(key))
  add(query_579928, "$.xgafv", newJString(Xgafv))
  add(query_579928, "prettyPrint", newJBool(prettyPrint))
  add(query_579928, "bearer_token", newJString(bearerToken))
  result = call_579925.call(path_579926, query_579928, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesGet* = Call_CloudiotProjectsLocationsRegistriesDevicesGet_579677(
    name: "cloudiotProjectsLocationsRegistriesDevicesGet",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesGet_579678,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesGet_579679,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesPatch_579988 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesPatch_579990(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesPatch_579989(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource path name. For example,
  ## `projects/p1/locations/us-central1/registries/registry0/devices/dev0` or
  ## `projects/p1/locations/us-central1/registries/registry0/devices/{num_id}`.
  ## When `name` is populated as a response from the service, it always ends
  ## in the device numeric ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579991 = path.getOrDefault("name")
  valid_579991 = validateParameter(valid_579991, JString, required = true,
                                 default = nil)
  if valid_579991 != nil:
    section.add "name", valid_579991
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Only updates the `device` fields indicated by this mask.
  ## The field mask must not be empty, and it must not contain fields that
  ## are immutable or only set by the server.
  ## Mutable top-level fields: `credentials` and `enabled_state`
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579992 = query.getOrDefault("upload_protocol")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "upload_protocol", valid_579992
  var valid_579993 = query.getOrDefault("fields")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "fields", valid_579993
  var valid_579994 = query.getOrDefault("quotaUser")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "quotaUser", valid_579994
  var valid_579995 = query.getOrDefault("alt")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("json"))
  if valid_579995 != nil:
    section.add "alt", valid_579995
  var valid_579996 = query.getOrDefault("pp")
  valid_579996 = validateParameter(valid_579996, JBool, required = false,
                                 default = newJBool(true))
  if valid_579996 != nil:
    section.add "pp", valid_579996
  var valid_579997 = query.getOrDefault("oauth_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "oauth_token", valid_579997
  var valid_579998 = query.getOrDefault("callback")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "callback", valid_579998
  var valid_579999 = query.getOrDefault("access_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "access_token", valid_579999
  var valid_580000 = query.getOrDefault("uploadType")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "uploadType", valid_580000
  var valid_580001 = query.getOrDefault("key")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "key", valid_580001
  var valid_580002 = query.getOrDefault("$.xgafv")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = newJString("1"))
  if valid_580002 != nil:
    section.add "$.xgafv", valid_580002
  var valid_580003 = query.getOrDefault("prettyPrint")
  valid_580003 = validateParameter(valid_580003, JBool, required = false,
                                 default = newJBool(true))
  if valid_580003 != nil:
    section.add "prettyPrint", valid_580003
  var valid_580004 = query.getOrDefault("updateMask")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "updateMask", valid_580004
  var valid_580005 = query.getOrDefault("bearer_token")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "bearer_token", valid_580005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580007: Call_CloudiotProjectsLocationsRegistriesDevicesPatch_579988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a device.
  ## 
  let valid = call_580007.validator(path, query, header, formData, body)
  let scheme = call_580007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580007.url(scheme.get, call_580007.host, call_580007.base,
                         call_580007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580007, url, valid)

proc call*(call_580008: Call_CloudiotProjectsLocationsRegistriesDevicesPatch_579988;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; updateMask: string = "";
          bearerToken: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesPatch
  ## Updates a device.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource path name. For example,
  ## `projects/p1/locations/us-central1/registries/registry0/devices/dev0` or
  ## `projects/p1/locations/us-central1/registries/registry0/devices/{num_id}`.
  ## When `name` is populated as a response from the service, it always ends
  ## in the device numeric ID.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Only updates the `device` fields indicated by this mask.
  ## The field mask must not be empty, and it must not contain fields that
  ## are immutable or only set by the server.
  ## Mutable top-level fields: `credentials` and `enabled_state`
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580009 = newJObject()
  var query_580010 = newJObject()
  var body_580011 = newJObject()
  add(query_580010, "upload_protocol", newJString(uploadProtocol))
  add(query_580010, "fields", newJString(fields))
  add(query_580010, "quotaUser", newJString(quotaUser))
  add(path_580009, "name", newJString(name))
  add(query_580010, "alt", newJString(alt))
  add(query_580010, "pp", newJBool(pp))
  add(query_580010, "oauth_token", newJString(oauthToken))
  add(query_580010, "callback", newJString(callback))
  add(query_580010, "access_token", newJString(accessToken))
  add(query_580010, "uploadType", newJString(uploadType))
  add(query_580010, "key", newJString(key))
  add(query_580010, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580011 = body
  add(query_580010, "prettyPrint", newJBool(prettyPrint))
  add(query_580010, "updateMask", newJString(updateMask))
  add(query_580010, "bearer_token", newJString(bearerToken))
  result = call_580008.call(path_580009, query_580010, nil, nil, body_580011)

var cloudiotProjectsLocationsRegistriesDevicesPatch* = Call_CloudiotProjectsLocationsRegistriesDevicesPatch_579988(
    name: "cloudiotProjectsLocationsRegistriesDevicesPatch",
    meth: HttpMethod.HttpPatch, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesPatch_579989,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesPatch_579990,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesDelete_579967 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesDelete_579969(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesDelete_579968(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the device. For example,
  ## `projects/p0/locations/us-central1/registries/registry0/devices/device0` or
  ## `projects/p0/locations/us-central1/registries/registry0/devices/{num_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579970 = path.getOrDefault("name")
  valid_579970 = validateParameter(valid_579970, JString, required = true,
                                 default = nil)
  if valid_579970 != nil:
    section.add "name", valid_579970
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579971 = query.getOrDefault("upload_protocol")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "upload_protocol", valid_579971
  var valid_579972 = query.getOrDefault("fields")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "fields", valid_579972
  var valid_579973 = query.getOrDefault("quotaUser")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "quotaUser", valid_579973
  var valid_579974 = query.getOrDefault("alt")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = newJString("json"))
  if valid_579974 != nil:
    section.add "alt", valid_579974
  var valid_579975 = query.getOrDefault("pp")
  valid_579975 = validateParameter(valid_579975, JBool, required = false,
                                 default = newJBool(true))
  if valid_579975 != nil:
    section.add "pp", valid_579975
  var valid_579976 = query.getOrDefault("oauth_token")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "oauth_token", valid_579976
  var valid_579977 = query.getOrDefault("callback")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "callback", valid_579977
  var valid_579978 = query.getOrDefault("access_token")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "access_token", valid_579978
  var valid_579979 = query.getOrDefault("uploadType")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "uploadType", valid_579979
  var valid_579980 = query.getOrDefault("key")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "key", valid_579980
  var valid_579981 = query.getOrDefault("$.xgafv")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = newJString("1"))
  if valid_579981 != nil:
    section.add "$.xgafv", valid_579981
  var valid_579982 = query.getOrDefault("prettyPrint")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(true))
  if valid_579982 != nil:
    section.add "prettyPrint", valid_579982
  var valid_579983 = query.getOrDefault("bearer_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "bearer_token", valid_579983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579984: Call_CloudiotProjectsLocationsRegistriesDevicesDelete_579967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a device.
  ## 
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_CloudiotProjectsLocationsRegistriesDevicesDelete_579967;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesDelete
  ## Deletes a device.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the device. For example,
  ## `projects/p0/locations/us-central1/registries/registry0/devices/device0` or
  ## `projects/p0/locations/us-central1/registries/registry0/devices/{num_id}`.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_579986 = newJObject()
  var query_579987 = newJObject()
  add(query_579987, "upload_protocol", newJString(uploadProtocol))
  add(query_579987, "fields", newJString(fields))
  add(query_579987, "quotaUser", newJString(quotaUser))
  add(path_579986, "name", newJString(name))
  add(query_579987, "alt", newJString(alt))
  add(query_579987, "pp", newJBool(pp))
  add(query_579987, "oauth_token", newJString(oauthToken))
  add(query_579987, "callback", newJString(callback))
  add(query_579987, "access_token", newJString(accessToken))
  add(query_579987, "uploadType", newJString(uploadType))
  add(query_579987, "key", newJString(key))
  add(query_579987, "$.xgafv", newJString(Xgafv))
  add(query_579987, "prettyPrint", newJBool(prettyPrint))
  add(query_579987, "bearer_token", newJString(bearerToken))
  result = call_579985.call(path_579986, query_579987, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesDelete* = Call_CloudiotProjectsLocationsRegistriesDevicesDelete_579967(
    name: "cloudiotProjectsLocationsRegistriesDevicesDelete",
    meth: HttpMethod.HttpDelete, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesDelete_579968,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesDelete_579969,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580012 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580014(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/configVersions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580013(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the last few versions of the device configuration in descending
  ## order (i.e.: newest first).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the device. For example,
  ## `projects/p0/locations/us-central1/registries/registry0/devices/device0` or
  ## `projects/p0/locations/us-central1/registries/registry0/devices/{num_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580015 = path.getOrDefault("name")
  valid_580015 = validateParameter(valid_580015, JString, required = true,
                                 default = nil)
  if valid_580015 != nil:
    section.add "name", valid_580015
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   numVersions: JInt
  ##              : The number of versions to list. Versions are listed in decreasing order of
  ## the version number. The maximum number of versions retained is 10. If this
  ## value is zero, it will return all the versions available.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580016 = query.getOrDefault("upload_protocol")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "upload_protocol", valid_580016
  var valid_580017 = query.getOrDefault("fields")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "fields", valid_580017
  var valid_580018 = query.getOrDefault("quotaUser")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "quotaUser", valid_580018
  var valid_580019 = query.getOrDefault("alt")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = newJString("json"))
  if valid_580019 != nil:
    section.add "alt", valid_580019
  var valid_580020 = query.getOrDefault("pp")
  valid_580020 = validateParameter(valid_580020, JBool, required = false,
                                 default = newJBool(true))
  if valid_580020 != nil:
    section.add "pp", valid_580020
  var valid_580021 = query.getOrDefault("oauth_token")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "oauth_token", valid_580021
  var valid_580022 = query.getOrDefault("callback")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "callback", valid_580022
  var valid_580023 = query.getOrDefault("access_token")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "access_token", valid_580023
  var valid_580024 = query.getOrDefault("uploadType")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "uploadType", valid_580024
  var valid_580025 = query.getOrDefault("key")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "key", valid_580025
  var valid_580026 = query.getOrDefault("$.xgafv")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = newJString("1"))
  if valid_580026 != nil:
    section.add "$.xgafv", valid_580026
  var valid_580027 = query.getOrDefault("prettyPrint")
  valid_580027 = validateParameter(valid_580027, JBool, required = false,
                                 default = newJBool(true))
  if valid_580027 != nil:
    section.add "prettyPrint", valid_580027
  var valid_580028 = query.getOrDefault("numVersions")
  valid_580028 = validateParameter(valid_580028, JInt, required = false, default = nil)
  if valid_580028 != nil:
    section.add "numVersions", valid_580028
  var valid_580029 = query.getOrDefault("bearer_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "bearer_token", valid_580029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580030: Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the last few versions of the device configuration in descending
  ## order (i.e.: newest first).
  ## 
  let valid = call_580030.validator(path, query, header, formData, body)
  let scheme = call_580030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580030.url(scheme.get, call_580030.host, call_580030.base,
                         call_580030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580030, url, valid)

proc call*(call_580031: Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580012;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; numVersions: int = 0; bearerToken: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesConfigVersionsList
  ## Lists the last few versions of the device configuration in descending
  ## order (i.e.: newest first).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the device. For example,
  ## `projects/p0/locations/us-central1/registries/registry0/devices/device0` or
  ## `projects/p0/locations/us-central1/registries/registry0/devices/{num_id}`.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   numVersions: int
  ##              : The number of versions to list. Versions are listed in decreasing order of
  ## the version number. The maximum number of versions retained is 10. If this
  ## value is zero, it will return all the versions available.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580032 = newJObject()
  var query_580033 = newJObject()
  add(query_580033, "upload_protocol", newJString(uploadProtocol))
  add(query_580033, "fields", newJString(fields))
  add(query_580033, "quotaUser", newJString(quotaUser))
  add(path_580032, "name", newJString(name))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "pp", newJBool(pp))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(query_580033, "callback", newJString(callback))
  add(query_580033, "access_token", newJString(accessToken))
  add(query_580033, "uploadType", newJString(uploadType))
  add(query_580033, "key", newJString(key))
  add(query_580033, "$.xgafv", newJString(Xgafv))
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  add(query_580033, "numVersions", newJInt(numVersions))
  add(query_580033, "bearer_token", newJString(bearerToken))
  result = call_580031.call(path_580032, query_580033, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesConfigVersionsList* = Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580012(
    name: "cloudiotProjectsLocationsRegistriesDevicesConfigVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{name}/configVersions", validator: validate_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580013,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580014,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580034 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580036(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":modifyCloudToDeviceConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580035(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Modifies the configuration for the device, which is eventually sent from
  ## the Cloud IoT servers. Returns the modified configuration version and its
  ## meta-data.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the device. For example,
  ## `projects/p0/locations/us-central1/registries/registry0/devices/device0` or
  ## `projects/p0/locations/us-central1/registries/registry0/devices/{num_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580037 = path.getOrDefault("name")
  valid_580037 = validateParameter(valid_580037, JString, required = true,
                                 default = nil)
  if valid_580037 != nil:
    section.add "name", valid_580037
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580038 = query.getOrDefault("upload_protocol")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "upload_protocol", valid_580038
  var valid_580039 = query.getOrDefault("fields")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "fields", valid_580039
  var valid_580040 = query.getOrDefault("quotaUser")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "quotaUser", valid_580040
  var valid_580041 = query.getOrDefault("alt")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("json"))
  if valid_580041 != nil:
    section.add "alt", valid_580041
  var valid_580042 = query.getOrDefault("pp")
  valid_580042 = validateParameter(valid_580042, JBool, required = false,
                                 default = newJBool(true))
  if valid_580042 != nil:
    section.add "pp", valid_580042
  var valid_580043 = query.getOrDefault("oauth_token")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "oauth_token", valid_580043
  var valid_580044 = query.getOrDefault("callback")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "callback", valid_580044
  var valid_580045 = query.getOrDefault("access_token")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "access_token", valid_580045
  var valid_580046 = query.getOrDefault("uploadType")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "uploadType", valid_580046
  var valid_580047 = query.getOrDefault("key")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "key", valid_580047
  var valid_580048 = query.getOrDefault("$.xgafv")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = newJString("1"))
  if valid_580048 != nil:
    section.add "$.xgafv", valid_580048
  var valid_580049 = query.getOrDefault("prettyPrint")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(true))
  if valid_580049 != nil:
    section.add "prettyPrint", valid_580049
  var valid_580050 = query.getOrDefault("bearer_token")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "bearer_token", valid_580050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580052: Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580034;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the configuration for the device, which is eventually sent from
  ## the Cloud IoT servers. Returns the modified configuration version and its
  ## meta-data.
  ## 
  let valid = call_580052.validator(path, query, header, formData, body)
  let scheme = call_580052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580052.url(scheme.get, call_580052.host, call_580052.base,
                         call_580052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580052, url, valid)

proc call*(call_580053: Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580034;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig
  ## Modifies the configuration for the device, which is eventually sent from
  ## the Cloud IoT servers. Returns the modified configuration version and its
  ## meta-data.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the device. For example,
  ## `projects/p0/locations/us-central1/registries/registry0/devices/device0` or
  ## `projects/p0/locations/us-central1/registries/registry0/devices/{num_id}`.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580054 = newJObject()
  var query_580055 = newJObject()
  var body_580056 = newJObject()
  add(query_580055, "upload_protocol", newJString(uploadProtocol))
  add(query_580055, "fields", newJString(fields))
  add(query_580055, "quotaUser", newJString(quotaUser))
  add(path_580054, "name", newJString(name))
  add(query_580055, "alt", newJString(alt))
  add(query_580055, "pp", newJBool(pp))
  add(query_580055, "oauth_token", newJString(oauthToken))
  add(query_580055, "callback", newJString(callback))
  add(query_580055, "access_token", newJString(accessToken))
  add(query_580055, "uploadType", newJString(uploadType))
  add(query_580055, "key", newJString(key))
  add(query_580055, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580056 = body
  add(query_580055, "prettyPrint", newJBool(prettyPrint))
  add(query_580055, "bearer_token", newJString(bearerToken))
  result = call_580053.call(path_580054, query_580055, nil, nil, body_580056)

var cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig* = Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580034(name: "cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{name}:modifyCloudToDeviceConfig", validator: validate_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580035,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580036,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesCreate_580083 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesCreate_580085(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/devices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesCreate_580084(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a device in a device registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the device registry where this device should be created.
  ## For example,
  ## `projects/example-project/locations/us-central1/registries/my-registry`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580086 = path.getOrDefault("parent")
  valid_580086 = validateParameter(valid_580086, JString, required = true,
                                 default = nil)
  if valid_580086 != nil:
    section.add "parent", valid_580086
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580087 = query.getOrDefault("upload_protocol")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "upload_protocol", valid_580087
  var valid_580088 = query.getOrDefault("fields")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "fields", valid_580088
  var valid_580089 = query.getOrDefault("quotaUser")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "quotaUser", valid_580089
  var valid_580090 = query.getOrDefault("alt")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = newJString("json"))
  if valid_580090 != nil:
    section.add "alt", valid_580090
  var valid_580091 = query.getOrDefault("pp")
  valid_580091 = validateParameter(valid_580091, JBool, required = false,
                                 default = newJBool(true))
  if valid_580091 != nil:
    section.add "pp", valid_580091
  var valid_580092 = query.getOrDefault("oauth_token")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "oauth_token", valid_580092
  var valid_580093 = query.getOrDefault("callback")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "callback", valid_580093
  var valid_580094 = query.getOrDefault("access_token")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "access_token", valid_580094
  var valid_580095 = query.getOrDefault("uploadType")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "uploadType", valid_580095
  var valid_580096 = query.getOrDefault("key")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "key", valid_580096
  var valid_580097 = query.getOrDefault("$.xgafv")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("1"))
  if valid_580097 != nil:
    section.add "$.xgafv", valid_580097
  var valid_580098 = query.getOrDefault("prettyPrint")
  valid_580098 = validateParameter(valid_580098, JBool, required = false,
                                 default = newJBool(true))
  if valid_580098 != nil:
    section.add "prettyPrint", valid_580098
  var valid_580099 = query.getOrDefault("bearer_token")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "bearer_token", valid_580099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580101: Call_CloudiotProjectsLocationsRegistriesDevicesCreate_580083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a device in a device registry.
  ## 
  let valid = call_580101.validator(path, query, header, formData, body)
  let scheme = call_580101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580101.url(scheme.get, call_580101.host, call_580101.base,
                         call_580101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580101, url, valid)

proc call*(call_580102: Call_CloudiotProjectsLocationsRegistriesDevicesCreate_580083;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesCreate
  ## Creates a device in a device registry.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The name of the device registry where this device should be created.
  ## For example,
  ## `projects/example-project/locations/us-central1/registries/my-registry`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580103 = newJObject()
  var query_580104 = newJObject()
  var body_580105 = newJObject()
  add(query_580104, "upload_protocol", newJString(uploadProtocol))
  add(query_580104, "fields", newJString(fields))
  add(query_580104, "quotaUser", newJString(quotaUser))
  add(query_580104, "alt", newJString(alt))
  add(query_580104, "pp", newJBool(pp))
  add(query_580104, "oauth_token", newJString(oauthToken))
  add(query_580104, "callback", newJString(callback))
  add(query_580104, "access_token", newJString(accessToken))
  add(query_580104, "uploadType", newJString(uploadType))
  add(path_580103, "parent", newJString(parent))
  add(query_580104, "key", newJString(key))
  add(query_580104, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580105 = body
  add(query_580104, "prettyPrint", newJBool(prettyPrint))
  add(query_580104, "bearer_token", newJString(bearerToken))
  result = call_580102.call(path_580103, query_580104, nil, nil, body_580105)

var cloudiotProjectsLocationsRegistriesDevicesCreate* = Call_CloudiotProjectsLocationsRegistriesDevicesCreate_580083(
    name: "cloudiotProjectsLocationsRegistriesDevicesCreate",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{parent}/devices",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesCreate_580084,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesCreate_580085,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesList_580057 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesList_580059(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/devices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesList_580058(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List devices in a device registry.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The device registry path. Required. For example,
  ## `projects/my-project/locations/us-central1/registries/my-registry`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580060 = path.getOrDefault("parent")
  valid_580060 = validateParameter(valid_580060, JString, required = true,
                                 default = nil)
  if valid_580060 != nil:
    section.add "parent", valid_580060
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListDevicesResponse`; indicates
  ## that this is a continuation of a prior `ListDevices` call, and
  ## that the system should return the next page of data.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   deviceIds: JArray
  ##            : A list of device string identifiers. If empty, it will ignore this field.
  ## For example, `['device0', 'device12']`. This field cannot hold more than
  ## 10,000 entries.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fieldMask: JString
  ##            : The fields of the `Device` resource to be returned in the response. The
  ## fields `id`, and `num_id` are always returned by default, along with any
  ## other fields specified.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of devices to return in the response. If this value
  ## is zero, the service will select a default size. A call may return fewer
  ## objects than requested, but if there is a non-empty `page_token`, it
  ## indicates that more entries are available.
  ##   deviceNumIds: JArray
  ##               : A list of device numerical ids. If empty, it will ignore this field. This
  ## field cannot hold more than 10,000 entries.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580061 = query.getOrDefault("upload_protocol")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "upload_protocol", valid_580061
  var valid_580062 = query.getOrDefault("fields")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "fields", valid_580062
  var valid_580063 = query.getOrDefault("pageToken")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "pageToken", valid_580063
  var valid_580064 = query.getOrDefault("quotaUser")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "quotaUser", valid_580064
  var valid_580065 = query.getOrDefault("alt")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = newJString("json"))
  if valid_580065 != nil:
    section.add "alt", valid_580065
  var valid_580066 = query.getOrDefault("pp")
  valid_580066 = validateParameter(valid_580066, JBool, required = false,
                                 default = newJBool(true))
  if valid_580066 != nil:
    section.add "pp", valid_580066
  var valid_580067 = query.getOrDefault("oauth_token")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "oauth_token", valid_580067
  var valid_580068 = query.getOrDefault("callback")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "callback", valid_580068
  var valid_580069 = query.getOrDefault("access_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "access_token", valid_580069
  var valid_580070 = query.getOrDefault("uploadType")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "uploadType", valid_580070
  var valid_580071 = query.getOrDefault("deviceIds")
  valid_580071 = validateParameter(valid_580071, JArray, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "deviceIds", valid_580071
  var valid_580072 = query.getOrDefault("key")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "key", valid_580072
  var valid_580073 = query.getOrDefault("fieldMask")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "fieldMask", valid_580073
  var valid_580074 = query.getOrDefault("$.xgafv")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = newJString("1"))
  if valid_580074 != nil:
    section.add "$.xgafv", valid_580074
  var valid_580075 = query.getOrDefault("pageSize")
  valid_580075 = validateParameter(valid_580075, JInt, required = false, default = nil)
  if valid_580075 != nil:
    section.add "pageSize", valid_580075
  var valid_580076 = query.getOrDefault("deviceNumIds")
  valid_580076 = validateParameter(valid_580076, JArray, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "deviceNumIds", valid_580076
  var valid_580077 = query.getOrDefault("prettyPrint")
  valid_580077 = validateParameter(valid_580077, JBool, required = false,
                                 default = newJBool(true))
  if valid_580077 != nil:
    section.add "prettyPrint", valid_580077
  var valid_580078 = query.getOrDefault("bearer_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "bearer_token", valid_580078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580079: Call_CloudiotProjectsLocationsRegistriesDevicesList_580057;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List devices in a device registry.
  ## 
  let valid = call_580079.validator(path, query, header, formData, body)
  let scheme = call_580079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580079.url(scheme.get, call_580079.host, call_580079.base,
                         call_580079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580079, url, valid)

proc call*(call_580080: Call_CloudiotProjectsLocationsRegistriesDevicesList_580057;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; deviceIds: JsonNode = nil;
          key: string = ""; fieldMask: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          deviceNumIds: JsonNode = nil; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesList
  ## List devices in a device registry.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListDevicesResponse`; indicates
  ## that this is a continuation of a prior `ListDevices` call, and
  ## that the system should return the next page of data.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The device registry path. Required. For example,
  ## `projects/my-project/locations/us-central1/registries/my-registry`.
  ##   deviceIds: JArray
  ##            : A list of device string identifiers. If empty, it will ignore this field.
  ## For example, `['device0', 'device12']`. This field cannot hold more than
  ## 10,000 entries.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fieldMask: string
  ##            : The fields of the `Device` resource to be returned in the response. The
  ## fields `id`, and `num_id` are always returned by default, along with any
  ## other fields specified.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of devices to return in the response. If this value
  ## is zero, the service will select a default size. A call may return fewer
  ## objects than requested, but if there is a non-empty `page_token`, it
  ## indicates that more entries are available.
  ##   deviceNumIds: JArray
  ##               : A list of device numerical ids. If empty, it will ignore this field. This
  ## field cannot hold more than 10,000 entries.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580081 = newJObject()
  var query_580082 = newJObject()
  add(query_580082, "upload_protocol", newJString(uploadProtocol))
  add(query_580082, "fields", newJString(fields))
  add(query_580082, "pageToken", newJString(pageToken))
  add(query_580082, "quotaUser", newJString(quotaUser))
  add(query_580082, "alt", newJString(alt))
  add(query_580082, "pp", newJBool(pp))
  add(query_580082, "oauth_token", newJString(oauthToken))
  add(query_580082, "callback", newJString(callback))
  add(query_580082, "access_token", newJString(accessToken))
  add(query_580082, "uploadType", newJString(uploadType))
  add(path_580081, "parent", newJString(parent))
  if deviceIds != nil:
    query_580082.add "deviceIds", deviceIds
  add(query_580082, "key", newJString(key))
  add(query_580082, "fieldMask", newJString(fieldMask))
  add(query_580082, "$.xgafv", newJString(Xgafv))
  add(query_580082, "pageSize", newJInt(pageSize))
  if deviceNumIds != nil:
    query_580082.add "deviceNumIds", deviceNumIds
  add(query_580082, "prettyPrint", newJBool(prettyPrint))
  add(query_580082, "bearer_token", newJString(bearerToken))
  result = call_580080.call(path_580081, query_580082, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesList* = Call_CloudiotProjectsLocationsRegistriesDevicesList_580057(
    name: "cloudiotProjectsLocationsRegistriesDevicesList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{parent}/devices",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesList_580058,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesList_580059,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesCreate_580129 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesCreate_580131(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/registries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesCreate_580130(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a device registry that contains devices.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project and cloud region where this device registry must be created.
  ## For example, `projects/example-project/locations/us-central1`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580132 = path.getOrDefault("parent")
  valid_580132 = validateParameter(valid_580132, JString, required = true,
                                 default = nil)
  if valid_580132 != nil:
    section.add "parent", valid_580132
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580133 = query.getOrDefault("upload_protocol")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "upload_protocol", valid_580133
  var valid_580134 = query.getOrDefault("fields")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "fields", valid_580134
  var valid_580135 = query.getOrDefault("quotaUser")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "quotaUser", valid_580135
  var valid_580136 = query.getOrDefault("alt")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = newJString("json"))
  if valid_580136 != nil:
    section.add "alt", valid_580136
  var valid_580137 = query.getOrDefault("pp")
  valid_580137 = validateParameter(valid_580137, JBool, required = false,
                                 default = newJBool(true))
  if valid_580137 != nil:
    section.add "pp", valid_580137
  var valid_580138 = query.getOrDefault("oauth_token")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "oauth_token", valid_580138
  var valid_580139 = query.getOrDefault("callback")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "callback", valid_580139
  var valid_580140 = query.getOrDefault("access_token")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "access_token", valid_580140
  var valid_580141 = query.getOrDefault("uploadType")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "uploadType", valid_580141
  var valid_580142 = query.getOrDefault("key")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "key", valid_580142
  var valid_580143 = query.getOrDefault("$.xgafv")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = newJString("1"))
  if valid_580143 != nil:
    section.add "$.xgafv", valid_580143
  var valid_580144 = query.getOrDefault("prettyPrint")
  valid_580144 = validateParameter(valid_580144, JBool, required = false,
                                 default = newJBool(true))
  if valid_580144 != nil:
    section.add "prettyPrint", valid_580144
  var valid_580145 = query.getOrDefault("bearer_token")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "bearer_token", valid_580145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580147: Call_CloudiotProjectsLocationsRegistriesCreate_580129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a device registry that contains devices.
  ## 
  let valid = call_580147.validator(path, query, header, formData, body)
  let scheme = call_580147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580147.url(scheme.get, call_580147.host, call_580147.base,
                         call_580147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580147, url, valid)

proc call*(call_580148: Call_CloudiotProjectsLocationsRegistriesCreate_580129;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesCreate
  ## Creates a device registry that contains devices.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project and cloud region where this device registry must be created.
  ## For example, `projects/example-project/locations/us-central1`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580149 = newJObject()
  var query_580150 = newJObject()
  var body_580151 = newJObject()
  add(query_580150, "upload_protocol", newJString(uploadProtocol))
  add(query_580150, "fields", newJString(fields))
  add(query_580150, "quotaUser", newJString(quotaUser))
  add(query_580150, "alt", newJString(alt))
  add(query_580150, "pp", newJBool(pp))
  add(query_580150, "oauth_token", newJString(oauthToken))
  add(query_580150, "callback", newJString(callback))
  add(query_580150, "access_token", newJString(accessToken))
  add(query_580150, "uploadType", newJString(uploadType))
  add(path_580149, "parent", newJString(parent))
  add(query_580150, "key", newJString(key))
  add(query_580150, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580151 = body
  add(query_580150, "prettyPrint", newJBool(prettyPrint))
  add(query_580150, "bearer_token", newJString(bearerToken))
  result = call_580148.call(path_580149, query_580150, nil, nil, body_580151)

var cloudiotProjectsLocationsRegistriesCreate* = Call_CloudiotProjectsLocationsRegistriesCreate_580129(
    name: "cloudiotProjectsLocationsRegistriesCreate", meth: HttpMethod.HttpPost,
    host: "cloudiot.googleapis.com", route: "/v1beta1/{parent}/registries",
    validator: validate_CloudiotProjectsLocationsRegistriesCreate_580130,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesCreate_580131,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesList_580106 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesList_580108(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/registries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesList_580107(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists device registries.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project and cloud region path. For example,
  ## `projects/example-project/locations/us-central1`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580109 = path.getOrDefault("parent")
  valid_580109 = validateParameter(valid_580109, JString, required = true,
                                 default = nil)
  if valid_580109 != nil:
    section.add "parent", valid_580109
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListDeviceRegistriesResponse`; indicates
  ## that this is a continuation of a prior `ListDeviceRegistries` call, and
  ## that the system should return the next page of data.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of registries to return in the response. If this value
  ## is zero, the service will select a default size. A call may return fewer
  ## objects than requested, but if there is a non-empty `page_token`, it
  ## indicates that more entries are available.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580110 = query.getOrDefault("upload_protocol")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "upload_protocol", valid_580110
  var valid_580111 = query.getOrDefault("fields")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "fields", valid_580111
  var valid_580112 = query.getOrDefault("pageToken")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "pageToken", valid_580112
  var valid_580113 = query.getOrDefault("quotaUser")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "quotaUser", valid_580113
  var valid_580114 = query.getOrDefault("alt")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = newJString("json"))
  if valid_580114 != nil:
    section.add "alt", valid_580114
  var valid_580115 = query.getOrDefault("pp")
  valid_580115 = validateParameter(valid_580115, JBool, required = false,
                                 default = newJBool(true))
  if valid_580115 != nil:
    section.add "pp", valid_580115
  var valid_580116 = query.getOrDefault("oauth_token")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "oauth_token", valid_580116
  var valid_580117 = query.getOrDefault("callback")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "callback", valid_580117
  var valid_580118 = query.getOrDefault("access_token")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "access_token", valid_580118
  var valid_580119 = query.getOrDefault("uploadType")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "uploadType", valid_580119
  var valid_580120 = query.getOrDefault("key")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "key", valid_580120
  var valid_580121 = query.getOrDefault("$.xgafv")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("1"))
  if valid_580121 != nil:
    section.add "$.xgafv", valid_580121
  var valid_580122 = query.getOrDefault("pageSize")
  valid_580122 = validateParameter(valid_580122, JInt, required = false, default = nil)
  if valid_580122 != nil:
    section.add "pageSize", valid_580122
  var valid_580123 = query.getOrDefault("prettyPrint")
  valid_580123 = validateParameter(valid_580123, JBool, required = false,
                                 default = newJBool(true))
  if valid_580123 != nil:
    section.add "prettyPrint", valid_580123
  var valid_580124 = query.getOrDefault("bearer_token")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "bearer_token", valid_580124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580125: Call_CloudiotProjectsLocationsRegistriesList_580106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists device registries.
  ## 
  let valid = call_580125.validator(path, query, header, formData, body)
  let scheme = call_580125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580125.url(scheme.get, call_580125.host, call_580125.base,
                         call_580125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580125, url, valid)

proc call*(call_580126: Call_CloudiotProjectsLocationsRegistriesList_580106;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesList
  ## Lists device registries.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListDeviceRegistriesResponse`; indicates
  ## that this is a continuation of a prior `ListDeviceRegistries` call, and
  ## that the system should return the next page of data.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project and cloud region path. For example,
  ## `projects/example-project/locations/us-central1`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of registries to return in the response. If this value
  ## is zero, the service will select a default size. A call may return fewer
  ## objects than requested, but if there is a non-empty `page_token`, it
  ## indicates that more entries are available.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580127 = newJObject()
  var query_580128 = newJObject()
  add(query_580128, "upload_protocol", newJString(uploadProtocol))
  add(query_580128, "fields", newJString(fields))
  add(query_580128, "pageToken", newJString(pageToken))
  add(query_580128, "quotaUser", newJString(quotaUser))
  add(query_580128, "alt", newJString(alt))
  add(query_580128, "pp", newJBool(pp))
  add(query_580128, "oauth_token", newJString(oauthToken))
  add(query_580128, "callback", newJString(callback))
  add(query_580128, "access_token", newJString(accessToken))
  add(query_580128, "uploadType", newJString(uploadType))
  add(path_580127, "parent", newJString(parent))
  add(query_580128, "key", newJString(key))
  add(query_580128, "$.xgafv", newJString(Xgafv))
  add(query_580128, "pageSize", newJInt(pageSize))
  add(query_580128, "prettyPrint", newJBool(prettyPrint))
  add(query_580128, "bearer_token", newJString(bearerToken))
  result = call_580126.call(path_580127, query_580128, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesList* = Call_CloudiotProjectsLocationsRegistriesList_580106(
    name: "cloudiotProjectsLocationsRegistriesList", meth: HttpMethod.HttpGet,
    host: "cloudiot.googleapis.com", route: "/v1beta1/{parent}/registries",
    validator: validate_CloudiotProjectsLocationsRegistriesList_580107, base: "/",
    url: url_CloudiotProjectsLocationsRegistriesList_580108,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesGetIamPolicy_580152 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesGetIamPolicy_580154(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesGetIamPolicy_580153(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580155 = path.getOrDefault("resource")
  valid_580155 = validateParameter(valid_580155, JString, required = true,
                                 default = nil)
  if valid_580155 != nil:
    section.add "resource", valid_580155
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580156 = query.getOrDefault("upload_protocol")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "upload_protocol", valid_580156
  var valid_580157 = query.getOrDefault("fields")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "fields", valid_580157
  var valid_580158 = query.getOrDefault("quotaUser")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "quotaUser", valid_580158
  var valid_580159 = query.getOrDefault("alt")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = newJString("json"))
  if valid_580159 != nil:
    section.add "alt", valid_580159
  var valid_580160 = query.getOrDefault("pp")
  valid_580160 = validateParameter(valid_580160, JBool, required = false,
                                 default = newJBool(true))
  if valid_580160 != nil:
    section.add "pp", valid_580160
  var valid_580161 = query.getOrDefault("oauth_token")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "oauth_token", valid_580161
  var valid_580162 = query.getOrDefault("callback")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "callback", valid_580162
  var valid_580163 = query.getOrDefault("access_token")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "access_token", valid_580163
  var valid_580164 = query.getOrDefault("uploadType")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "uploadType", valid_580164
  var valid_580165 = query.getOrDefault("key")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "key", valid_580165
  var valid_580166 = query.getOrDefault("$.xgafv")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = newJString("1"))
  if valid_580166 != nil:
    section.add "$.xgafv", valid_580166
  var valid_580167 = query.getOrDefault("prettyPrint")
  valid_580167 = validateParameter(valid_580167, JBool, required = false,
                                 default = newJBool(true))
  if valid_580167 != nil:
    section.add "prettyPrint", valid_580167
  var valid_580168 = query.getOrDefault("bearer_token")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "bearer_token", valid_580168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580170: Call_CloudiotProjectsLocationsRegistriesGetIamPolicy_580152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_580170.validator(path, query, header, formData, body)
  let scheme = call_580170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580170.url(scheme.get, call_580170.host, call_580170.base,
                         call_580170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580170, url, valid)

proc call*(call_580171: Call_CloudiotProjectsLocationsRegistriesGetIamPolicy_580152;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesGetIamPolicy
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580172 = newJObject()
  var query_580173 = newJObject()
  var body_580174 = newJObject()
  add(query_580173, "upload_protocol", newJString(uploadProtocol))
  add(query_580173, "fields", newJString(fields))
  add(query_580173, "quotaUser", newJString(quotaUser))
  add(query_580173, "alt", newJString(alt))
  add(query_580173, "pp", newJBool(pp))
  add(query_580173, "oauth_token", newJString(oauthToken))
  add(query_580173, "callback", newJString(callback))
  add(query_580173, "access_token", newJString(accessToken))
  add(query_580173, "uploadType", newJString(uploadType))
  add(query_580173, "key", newJString(key))
  add(query_580173, "$.xgafv", newJString(Xgafv))
  add(path_580172, "resource", newJString(resource))
  if body != nil:
    body_580174 = body
  add(query_580173, "prettyPrint", newJBool(prettyPrint))
  add(query_580173, "bearer_token", newJString(bearerToken))
  result = call_580171.call(path_580172, query_580173, nil, nil, body_580174)

var cloudiotProjectsLocationsRegistriesGetIamPolicy* = Call_CloudiotProjectsLocationsRegistriesGetIamPolicy_580152(
    name: "cloudiotProjectsLocationsRegistriesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_CloudiotProjectsLocationsRegistriesGetIamPolicy_580153,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesGetIamPolicy_580154,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesSetIamPolicy_580175 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesSetIamPolicy_580177(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesSetIamPolicy_580176(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580178 = path.getOrDefault("resource")
  valid_580178 = validateParameter(valid_580178, JString, required = true,
                                 default = nil)
  if valid_580178 != nil:
    section.add "resource", valid_580178
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580179 = query.getOrDefault("upload_protocol")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "upload_protocol", valid_580179
  var valid_580180 = query.getOrDefault("fields")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "fields", valid_580180
  var valid_580181 = query.getOrDefault("quotaUser")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "quotaUser", valid_580181
  var valid_580182 = query.getOrDefault("alt")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = newJString("json"))
  if valid_580182 != nil:
    section.add "alt", valid_580182
  var valid_580183 = query.getOrDefault("pp")
  valid_580183 = validateParameter(valid_580183, JBool, required = false,
                                 default = newJBool(true))
  if valid_580183 != nil:
    section.add "pp", valid_580183
  var valid_580184 = query.getOrDefault("oauth_token")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "oauth_token", valid_580184
  var valid_580185 = query.getOrDefault("callback")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "callback", valid_580185
  var valid_580186 = query.getOrDefault("access_token")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "access_token", valid_580186
  var valid_580187 = query.getOrDefault("uploadType")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "uploadType", valid_580187
  var valid_580188 = query.getOrDefault("key")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "key", valid_580188
  var valid_580189 = query.getOrDefault("$.xgafv")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = newJString("1"))
  if valid_580189 != nil:
    section.add "$.xgafv", valid_580189
  var valid_580190 = query.getOrDefault("prettyPrint")
  valid_580190 = validateParameter(valid_580190, JBool, required = false,
                                 default = newJBool(true))
  if valid_580190 != nil:
    section.add "prettyPrint", valid_580190
  var valid_580191 = query.getOrDefault("bearer_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "bearer_token", valid_580191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580193: Call_CloudiotProjectsLocationsRegistriesSetIamPolicy_580175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_580193.validator(path, query, header, formData, body)
  let scheme = call_580193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580193.url(scheme.get, call_580193.host, call_580193.base,
                         call_580193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580193, url, valid)

proc call*(call_580194: Call_CloudiotProjectsLocationsRegistriesSetIamPolicy_580175;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580195 = newJObject()
  var query_580196 = newJObject()
  var body_580197 = newJObject()
  add(query_580196, "upload_protocol", newJString(uploadProtocol))
  add(query_580196, "fields", newJString(fields))
  add(query_580196, "quotaUser", newJString(quotaUser))
  add(query_580196, "alt", newJString(alt))
  add(query_580196, "pp", newJBool(pp))
  add(query_580196, "oauth_token", newJString(oauthToken))
  add(query_580196, "callback", newJString(callback))
  add(query_580196, "access_token", newJString(accessToken))
  add(query_580196, "uploadType", newJString(uploadType))
  add(query_580196, "key", newJString(key))
  add(query_580196, "$.xgafv", newJString(Xgafv))
  add(path_580195, "resource", newJString(resource))
  if body != nil:
    body_580197 = body
  add(query_580196, "prettyPrint", newJBool(prettyPrint))
  add(query_580196, "bearer_token", newJString(bearerToken))
  result = call_580194.call(path_580195, query_580196, nil, nil, body_580197)

var cloudiotProjectsLocationsRegistriesSetIamPolicy* = Call_CloudiotProjectsLocationsRegistriesSetIamPolicy_580175(
    name: "cloudiotProjectsLocationsRegistriesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_CloudiotProjectsLocationsRegistriesSetIamPolicy_580176,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesSetIamPolicy_580177,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesTestIamPermissions_580198 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesTestIamPermissions_580200(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesTestIamPermissions_580199(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580201 = path.getOrDefault("resource")
  valid_580201 = validateParameter(valid_580201, JString, required = true,
                                 default = nil)
  if valid_580201 != nil:
    section.add "resource", valid_580201
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580202 = query.getOrDefault("upload_protocol")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "upload_protocol", valid_580202
  var valid_580203 = query.getOrDefault("fields")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "fields", valid_580203
  var valid_580204 = query.getOrDefault("quotaUser")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "quotaUser", valid_580204
  var valid_580205 = query.getOrDefault("alt")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = newJString("json"))
  if valid_580205 != nil:
    section.add "alt", valid_580205
  var valid_580206 = query.getOrDefault("pp")
  valid_580206 = validateParameter(valid_580206, JBool, required = false,
                                 default = newJBool(true))
  if valid_580206 != nil:
    section.add "pp", valid_580206
  var valid_580207 = query.getOrDefault("oauth_token")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "oauth_token", valid_580207
  var valid_580208 = query.getOrDefault("callback")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "callback", valid_580208
  var valid_580209 = query.getOrDefault("access_token")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "access_token", valid_580209
  var valid_580210 = query.getOrDefault("uploadType")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "uploadType", valid_580210
  var valid_580211 = query.getOrDefault("key")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "key", valid_580211
  var valid_580212 = query.getOrDefault("$.xgafv")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = newJString("1"))
  if valid_580212 != nil:
    section.add "$.xgafv", valid_580212
  var valid_580213 = query.getOrDefault("prettyPrint")
  valid_580213 = validateParameter(valid_580213, JBool, required = false,
                                 default = newJBool(true))
  if valid_580213 != nil:
    section.add "prettyPrint", valid_580213
  var valid_580214 = query.getOrDefault("bearer_token")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "bearer_token", valid_580214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580216: Call_CloudiotProjectsLocationsRegistriesTestIamPermissions_580198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  let valid = call_580216.validator(path, query, header, formData, body)
  let scheme = call_580216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580216.url(scheme.get, call_580216.host, call_580216.base,
                         call_580216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580216, url, valid)

proc call*(call_580217: Call_CloudiotProjectsLocationsRegistriesTestIamPermissions_580198;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580218 = newJObject()
  var query_580219 = newJObject()
  var body_580220 = newJObject()
  add(query_580219, "upload_protocol", newJString(uploadProtocol))
  add(query_580219, "fields", newJString(fields))
  add(query_580219, "quotaUser", newJString(quotaUser))
  add(query_580219, "alt", newJString(alt))
  add(query_580219, "pp", newJBool(pp))
  add(query_580219, "oauth_token", newJString(oauthToken))
  add(query_580219, "callback", newJString(callback))
  add(query_580219, "access_token", newJString(accessToken))
  add(query_580219, "uploadType", newJString(uploadType))
  add(query_580219, "key", newJString(key))
  add(query_580219, "$.xgafv", newJString(Xgafv))
  add(path_580218, "resource", newJString(resource))
  if body != nil:
    body_580220 = body
  add(query_580219, "prettyPrint", newJBool(prettyPrint))
  add(query_580219, "bearer_token", newJString(bearerToken))
  result = call_580217.call(path_580218, query_580219, nil, nil, body_580220)

var cloudiotProjectsLocationsRegistriesTestIamPermissions* = Call_CloudiotProjectsLocationsRegistriesTestIamPermissions_580198(
    name: "cloudiotProjectsLocationsRegistriesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_CloudiotProjectsLocationsRegistriesTestIamPermissions_580199,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesTestIamPermissions_580200,
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
