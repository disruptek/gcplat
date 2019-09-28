
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud IoT
## version: v1
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
    segments = @[(kind: ConstantSegment, value: "/v1/"),
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
  ##   fieldMask: JString
  ##            : The fields of the `Device` resource to be returned in the response. If the
  ## field mask is unset or empty, all fields are returned.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("callback")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "callback", valid_579824
  var valid_579825 = query.getOrDefault("access_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "access_token", valid_579825
  var valid_579826 = query.getOrDefault("uploadType")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "uploadType", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("fieldMask")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "fieldMask", valid_579828
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579853: Call_CloudiotProjectsLocationsRegistriesDevicesGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets details about a device.
  ## 
  let valid = call_579853.validator(path, query, header, formData, body)
  let scheme = call_579853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579853.url(scheme.get, call_579853.host, call_579853.base,
                         call_579853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579853, url, valid)

proc call*(call_579924: Call_CloudiotProjectsLocationsRegistriesDevicesGet_579677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; fieldMask: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
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
  ##   fieldMask: string
  ##            : The fields of the `Device` resource to be returned in the response. If the
  ## field mask is unset or empty, all fields are returned.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579925 = newJObject()
  var query_579927 = newJObject()
  add(query_579927, "upload_protocol", newJString(uploadProtocol))
  add(query_579927, "fields", newJString(fields))
  add(query_579927, "quotaUser", newJString(quotaUser))
  add(path_579925, "name", newJString(name))
  add(query_579927, "alt", newJString(alt))
  add(query_579927, "oauth_token", newJString(oauthToken))
  add(query_579927, "callback", newJString(callback))
  add(query_579927, "access_token", newJString(accessToken))
  add(query_579927, "uploadType", newJString(uploadType))
  add(query_579927, "key", newJString(key))
  add(query_579927, "fieldMask", newJString(fieldMask))
  add(query_579927, "$.xgafv", newJString(Xgafv))
  add(query_579927, "prettyPrint", newJBool(prettyPrint))
  result = call_579924.call(path_579925, query_579927, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesGet* = Call_CloudiotProjectsLocationsRegistriesDevicesGet_579677(
    name: "cloudiotProjectsLocationsRegistriesDevicesGet",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesGet_579678,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesGet_579679,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesPatch_579985 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesPatch_579987(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesPatch_579986(
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
  var valid_579988 = path.getOrDefault("name")
  valid_579988 = validateParameter(valid_579988, JString, required = true,
                                 default = nil)
  if valid_579988 != nil:
    section.add "name", valid_579988
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
  ## Mutable top-level fields: `credentials`, `blocked`, and `metadata`
  section = newJObject()
  var valid_579989 = query.getOrDefault("upload_protocol")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "upload_protocol", valid_579989
  var valid_579990 = query.getOrDefault("fields")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "fields", valid_579990
  var valid_579991 = query.getOrDefault("quotaUser")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "quotaUser", valid_579991
  var valid_579992 = query.getOrDefault("alt")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = newJString("json"))
  if valid_579992 != nil:
    section.add "alt", valid_579992
  var valid_579993 = query.getOrDefault("oauth_token")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "oauth_token", valid_579993
  var valid_579994 = query.getOrDefault("callback")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "callback", valid_579994
  var valid_579995 = query.getOrDefault("access_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "access_token", valid_579995
  var valid_579996 = query.getOrDefault("uploadType")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "uploadType", valid_579996
  var valid_579997 = query.getOrDefault("key")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "key", valid_579997
  var valid_579998 = query.getOrDefault("$.xgafv")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = newJString("1"))
  if valid_579998 != nil:
    section.add "$.xgafv", valid_579998
  var valid_579999 = query.getOrDefault("prettyPrint")
  valid_579999 = validateParameter(valid_579999, JBool, required = false,
                                 default = newJBool(true))
  if valid_579999 != nil:
    section.add "prettyPrint", valid_579999
  var valid_580000 = query.getOrDefault("updateMask")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "updateMask", valid_580000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580002: Call_CloudiotProjectsLocationsRegistriesDevicesPatch_579985;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a device.
  ## 
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_CloudiotProjectsLocationsRegistriesDevicesPatch_579985;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
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
  ## Mutable top-level fields: `credentials`, `blocked`, and `metadata`
  var path_580004 = newJObject()
  var query_580005 = newJObject()
  var body_580006 = newJObject()
  add(query_580005, "upload_protocol", newJString(uploadProtocol))
  add(query_580005, "fields", newJString(fields))
  add(query_580005, "quotaUser", newJString(quotaUser))
  add(path_580004, "name", newJString(name))
  add(query_580005, "alt", newJString(alt))
  add(query_580005, "oauth_token", newJString(oauthToken))
  add(query_580005, "callback", newJString(callback))
  add(query_580005, "access_token", newJString(accessToken))
  add(query_580005, "uploadType", newJString(uploadType))
  add(query_580005, "key", newJString(key))
  add(query_580005, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580006 = body
  add(query_580005, "prettyPrint", newJBool(prettyPrint))
  add(query_580005, "updateMask", newJString(updateMask))
  result = call_580003.call(path_580004, query_580005, nil, nil, body_580006)

var cloudiotProjectsLocationsRegistriesDevicesPatch* = Call_CloudiotProjectsLocationsRegistriesDevicesPatch_579985(
    name: "cloudiotProjectsLocationsRegistriesDevicesPatch",
    meth: HttpMethod.HttpPatch, host: "cloudiot.googleapis.com",
    route: "/v1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesPatch_579986,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesPatch_579987,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesDelete_579966 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesDelete_579968(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesDelete_579967(
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
  var valid_579969 = path.getOrDefault("name")
  valid_579969 = validateParameter(valid_579969, JString, required = true,
                                 default = nil)
  if valid_579969 != nil:
    section.add "name", valid_579969
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
  section = newJObject()
  var valid_579970 = query.getOrDefault("upload_protocol")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "upload_protocol", valid_579970
  var valid_579971 = query.getOrDefault("fields")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "fields", valid_579971
  var valid_579972 = query.getOrDefault("quotaUser")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "quotaUser", valid_579972
  var valid_579973 = query.getOrDefault("alt")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = newJString("json"))
  if valid_579973 != nil:
    section.add "alt", valid_579973
  var valid_579974 = query.getOrDefault("oauth_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "oauth_token", valid_579974
  var valid_579975 = query.getOrDefault("callback")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "callback", valid_579975
  var valid_579976 = query.getOrDefault("access_token")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "access_token", valid_579976
  var valid_579977 = query.getOrDefault("uploadType")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "uploadType", valid_579977
  var valid_579978 = query.getOrDefault("key")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "key", valid_579978
  var valid_579979 = query.getOrDefault("$.xgafv")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("1"))
  if valid_579979 != nil:
    section.add "$.xgafv", valid_579979
  var valid_579980 = query.getOrDefault("prettyPrint")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(true))
  if valid_579980 != nil:
    section.add "prettyPrint", valid_579980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579981: Call_CloudiotProjectsLocationsRegistriesDevicesDelete_579966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a device.
  ## 
  let valid = call_579981.validator(path, query, header, formData, body)
  let scheme = call_579981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579981.url(scheme.get, call_579981.host, call_579981.base,
                         call_579981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579981, url, valid)

proc call*(call_579982: Call_CloudiotProjectsLocationsRegistriesDevicesDelete_579966;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
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
  var path_579983 = newJObject()
  var query_579984 = newJObject()
  add(query_579984, "upload_protocol", newJString(uploadProtocol))
  add(query_579984, "fields", newJString(fields))
  add(query_579984, "quotaUser", newJString(quotaUser))
  add(path_579983, "name", newJString(name))
  add(query_579984, "alt", newJString(alt))
  add(query_579984, "oauth_token", newJString(oauthToken))
  add(query_579984, "callback", newJString(callback))
  add(query_579984, "access_token", newJString(accessToken))
  add(query_579984, "uploadType", newJString(uploadType))
  add(query_579984, "key", newJString(key))
  add(query_579984, "$.xgafv", newJString(Xgafv))
  add(query_579984, "prettyPrint", newJBool(prettyPrint))
  result = call_579982.call(path_579983, query_579984, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesDelete* = Call_CloudiotProjectsLocationsRegistriesDevicesDelete_579966(
    name: "cloudiotProjectsLocationsRegistriesDevicesDelete",
    meth: HttpMethod.HttpDelete, host: "cloudiot.googleapis.com",
    route: "/v1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesDelete_579967,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesDelete_579968,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580007 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580009(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/configVersions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580008(
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
  var valid_580010 = path.getOrDefault("name")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "name", valid_580010
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
  section = newJObject()
  var valid_580011 = query.getOrDefault("upload_protocol")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "upload_protocol", valid_580011
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("callback")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "callback", valid_580016
  var valid_580017 = query.getOrDefault("access_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "access_token", valid_580017
  var valid_580018 = query.getOrDefault("uploadType")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "uploadType", valid_580018
  var valid_580019 = query.getOrDefault("key")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "key", valid_580019
  var valid_580020 = query.getOrDefault("$.xgafv")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("1"))
  if valid_580020 != nil:
    section.add "$.xgafv", valid_580020
  var valid_580021 = query.getOrDefault("prettyPrint")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(true))
  if valid_580021 != nil:
    section.add "prettyPrint", valid_580021
  var valid_580022 = query.getOrDefault("numVersions")
  valid_580022 = validateParameter(valid_580022, JInt, required = false, default = nil)
  if valid_580022 != nil:
    section.add "numVersions", valid_580022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580023: Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the last few versions of the device configuration in descending
  ## order (i.e.: newest first).
  ## 
  let valid = call_580023.validator(path, query, header, formData, body)
  let scheme = call_580023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580023.url(scheme.get, call_580023.host, call_580023.base,
                         call_580023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580023, url, valid)

proc call*(call_580024: Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580007;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          numVersions: int = 0): Recallable =
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
  var path_580025 = newJObject()
  var query_580026 = newJObject()
  add(query_580026, "upload_protocol", newJString(uploadProtocol))
  add(query_580026, "fields", newJString(fields))
  add(query_580026, "quotaUser", newJString(quotaUser))
  add(path_580025, "name", newJString(name))
  add(query_580026, "alt", newJString(alt))
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "callback", newJString(callback))
  add(query_580026, "access_token", newJString(accessToken))
  add(query_580026, "uploadType", newJString(uploadType))
  add(query_580026, "key", newJString(key))
  add(query_580026, "$.xgafv", newJString(Xgafv))
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  add(query_580026, "numVersions", newJInt(numVersions))
  result = call_580024.call(path_580025, query_580026, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesConfigVersionsList* = Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580007(
    name: "cloudiotProjectsLocationsRegistriesDevicesConfigVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1/{name}/configVersions", validator: validate_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580008,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_580009,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_580027 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesStatesList_580029(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/states")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesStatesList_580028(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the last few versions of the device state in descending order (i.e.:
  ## newest first).
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
  var valid_580030 = path.getOrDefault("name")
  valid_580030 = validateParameter(valid_580030, JString, required = true,
                                 default = nil)
  if valid_580030 != nil:
    section.add "name", valid_580030
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
  ##   numStates: JInt
  ##            : The number of states to list. States are listed in descending order of
  ## update time. The maximum number of states retained is 10. If this
  ## value is zero, it will return all the states available.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580031 = query.getOrDefault("upload_protocol")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "upload_protocol", valid_580031
  var valid_580032 = query.getOrDefault("fields")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "fields", valid_580032
  var valid_580033 = query.getOrDefault("quotaUser")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "quotaUser", valid_580033
  var valid_580034 = query.getOrDefault("alt")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("json"))
  if valid_580034 != nil:
    section.add "alt", valid_580034
  var valid_580035 = query.getOrDefault("oauth_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "oauth_token", valid_580035
  var valid_580036 = query.getOrDefault("callback")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "callback", valid_580036
  var valid_580037 = query.getOrDefault("access_token")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "access_token", valid_580037
  var valid_580038 = query.getOrDefault("uploadType")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "uploadType", valid_580038
  var valid_580039 = query.getOrDefault("key")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "key", valid_580039
  var valid_580040 = query.getOrDefault("$.xgafv")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = newJString("1"))
  if valid_580040 != nil:
    section.add "$.xgafv", valid_580040
  var valid_580041 = query.getOrDefault("numStates")
  valid_580041 = validateParameter(valid_580041, JInt, required = false, default = nil)
  if valid_580041 != nil:
    section.add "numStates", valid_580041
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

proc call*(call_580043: Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_580027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the last few versions of the device state in descending order (i.e.:
  ## newest first).
  ## 
  let valid = call_580043.validator(path, query, header, formData, body)
  let scheme = call_580043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580043.url(scheme.get, call_580043.host, call_580043.base,
                         call_580043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580043, url, valid)

proc call*(call_580044: Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_580027;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; numStates: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesStatesList
  ## Lists the last few versions of the device state in descending order (i.e.:
  ## newest first).
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
  ##   numStates: int
  ##            : The number of states to list. States are listed in descending order of
  ## update time. The maximum number of states retained is 10. If this
  ## value is zero, it will return all the states available.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580045 = newJObject()
  var query_580046 = newJObject()
  add(query_580046, "upload_protocol", newJString(uploadProtocol))
  add(query_580046, "fields", newJString(fields))
  add(query_580046, "quotaUser", newJString(quotaUser))
  add(path_580045, "name", newJString(name))
  add(query_580046, "alt", newJString(alt))
  add(query_580046, "oauth_token", newJString(oauthToken))
  add(query_580046, "callback", newJString(callback))
  add(query_580046, "access_token", newJString(accessToken))
  add(query_580046, "uploadType", newJString(uploadType))
  add(query_580046, "key", newJString(key))
  add(query_580046, "$.xgafv", newJString(Xgafv))
  add(query_580046, "numStates", newJInt(numStates))
  add(query_580046, "prettyPrint", newJBool(prettyPrint))
  result = call_580044.call(path_580045, query_580046, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesStatesList* = Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_580027(
    name: "cloudiotProjectsLocationsRegistriesDevicesStatesList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1/{name}/states",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesStatesList_580028,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesStatesList_580029,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580047 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580049(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":modifyCloudToDeviceConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580048(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Modifies the configuration for the device, which is eventually sent from
  ## the Cloud IoT Core servers. Returns the modified configuration version and
  ## its metadata.
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
  var valid_580050 = path.getOrDefault("name")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "name", valid_580050
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
  section = newJObject()
  var valid_580051 = query.getOrDefault("upload_protocol")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "upload_protocol", valid_580051
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
  var valid_580056 = query.getOrDefault("callback")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "callback", valid_580056
  var valid_580057 = query.getOrDefault("access_token")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "access_token", valid_580057
  var valid_580058 = query.getOrDefault("uploadType")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "uploadType", valid_580058
  var valid_580059 = query.getOrDefault("key")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "key", valid_580059
  var valid_580060 = query.getOrDefault("$.xgafv")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = newJString("1"))
  if valid_580060 != nil:
    section.add "$.xgafv", valid_580060
  var valid_580061 = query.getOrDefault("prettyPrint")
  valid_580061 = validateParameter(valid_580061, JBool, required = false,
                                 default = newJBool(true))
  if valid_580061 != nil:
    section.add "prettyPrint", valid_580061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580063: Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the configuration for the device, which is eventually sent from
  ## the Cloud IoT Core servers. Returns the modified configuration version and
  ## its metadata.
  ## 
  let valid = call_580063.validator(path, query, header, formData, body)
  let scheme = call_580063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580063.url(scheme.get, call_580063.host, call_580063.base,
                         call_580063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580063, url, valid)

proc call*(call_580064: Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580047;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig
  ## Modifies the configuration for the device, which is eventually sent from
  ## the Cloud IoT Core servers. Returns the modified configuration version and
  ## its metadata.
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
  var path_580065 = newJObject()
  var query_580066 = newJObject()
  var body_580067 = newJObject()
  add(query_580066, "upload_protocol", newJString(uploadProtocol))
  add(query_580066, "fields", newJString(fields))
  add(query_580066, "quotaUser", newJString(quotaUser))
  add(path_580065, "name", newJString(name))
  add(query_580066, "alt", newJString(alt))
  add(query_580066, "oauth_token", newJString(oauthToken))
  add(query_580066, "callback", newJString(callback))
  add(query_580066, "access_token", newJString(accessToken))
  add(query_580066, "uploadType", newJString(uploadType))
  add(query_580066, "key", newJString(key))
  add(query_580066, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580067 = body
  add(query_580066, "prettyPrint", newJBool(prettyPrint))
  result = call_580064.call(path_580065, query_580066, nil, nil, body_580067)

var cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig* = Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580047(name: "cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{name}:modifyCloudToDeviceConfig", validator: validate_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580048,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_580049,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_580068 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_580070(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":sendCommandToDevice")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_580069(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sends a command to the specified device. In order for a device to be able
  ## to receive commands, it must:
  ## 1) be connected to Cloud IoT Core using the MQTT protocol, and
  ## 2) be subscribed to the group of MQTT topics specified by
  ##    /devices/{device-id}/commands/#. This subscription will receive commands
  ##    at the top-level topic /devices/{device-id}/commands as well as commands
  ##    for subfolders, like /devices/{device-id}/commands/subfolder.
  ##    Note that subscribing to specific subfolders is not supported.
  ## If the command could not be delivered to the device, this method will
  ## return an error; in particular, if the device is not subscribed, this
  ## method will return FAILED_PRECONDITION. Otherwise, this method will
  ## return OK. If the subscription is QoS 1, at least once delivery will be
  ## guaranteed; for QoS 0, no acknowledgment will be expected from the device.
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
  var valid_580071 = path.getOrDefault("name")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "name", valid_580071
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
  section = newJObject()
  var valid_580072 = query.getOrDefault("upload_protocol")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "upload_protocol", valid_580072
  var valid_580073 = query.getOrDefault("fields")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "fields", valid_580073
  var valid_580074 = query.getOrDefault("quotaUser")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "quotaUser", valid_580074
  var valid_580075 = query.getOrDefault("alt")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("json"))
  if valid_580075 != nil:
    section.add "alt", valid_580075
  var valid_580076 = query.getOrDefault("oauth_token")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "oauth_token", valid_580076
  var valid_580077 = query.getOrDefault("callback")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "callback", valid_580077
  var valid_580078 = query.getOrDefault("access_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "access_token", valid_580078
  var valid_580079 = query.getOrDefault("uploadType")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "uploadType", valid_580079
  var valid_580080 = query.getOrDefault("key")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "key", valid_580080
  var valid_580081 = query.getOrDefault("$.xgafv")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = newJString("1"))
  if valid_580081 != nil:
    section.add "$.xgafv", valid_580081
  var valid_580082 = query.getOrDefault("prettyPrint")
  valid_580082 = validateParameter(valid_580082, JBool, required = false,
                                 default = newJBool(true))
  if valid_580082 != nil:
    section.add "prettyPrint", valid_580082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580084: Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_580068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sends a command to the specified device. In order for a device to be able
  ## to receive commands, it must:
  ## 1) be connected to Cloud IoT Core using the MQTT protocol, and
  ## 2) be subscribed to the group of MQTT topics specified by
  ##    /devices/{device-id}/commands/#. This subscription will receive commands
  ##    at the top-level topic /devices/{device-id}/commands as well as commands
  ##    for subfolders, like /devices/{device-id}/commands/subfolder.
  ##    Note that subscribing to specific subfolders is not supported.
  ## If the command could not be delivered to the device, this method will
  ## return an error; in particular, if the device is not subscribed, this
  ## method will return FAILED_PRECONDITION. Otherwise, this method will
  ## return OK. If the subscription is QoS 1, at least once delivery will be
  ## guaranteed; for QoS 0, no acknowledgment will be expected from the device.
  ## 
  let valid = call_580084.validator(path, query, header, formData, body)
  let scheme = call_580084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580084.url(scheme.get, call_580084.host, call_580084.base,
                         call_580084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580084, url, valid)

proc call*(call_580085: Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_580068;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice
  ## Sends a command to the specified device. In order for a device to be able
  ## to receive commands, it must:
  ## 1) be connected to Cloud IoT Core using the MQTT protocol, and
  ## 2) be subscribed to the group of MQTT topics specified by
  ##    /devices/{device-id}/commands/#. This subscription will receive commands
  ##    at the top-level topic /devices/{device-id}/commands as well as commands
  ##    for subfolders, like /devices/{device-id}/commands/subfolder.
  ##    Note that subscribing to specific subfolders is not supported.
  ## If the command could not be delivered to the device, this method will
  ## return an error; in particular, if the device is not subscribed, this
  ## method will return FAILED_PRECONDITION. Otherwise, this method will
  ## return OK. If the subscription is QoS 1, at least once delivery will be
  ## guaranteed; for QoS 0, no acknowledgment will be expected from the device.
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
  var path_580086 = newJObject()
  var query_580087 = newJObject()
  var body_580088 = newJObject()
  add(query_580087, "upload_protocol", newJString(uploadProtocol))
  add(query_580087, "fields", newJString(fields))
  add(query_580087, "quotaUser", newJString(quotaUser))
  add(path_580086, "name", newJString(name))
  add(query_580087, "alt", newJString(alt))
  add(query_580087, "oauth_token", newJString(oauthToken))
  add(query_580087, "callback", newJString(callback))
  add(query_580087, "access_token", newJString(accessToken))
  add(query_580087, "uploadType", newJString(uploadType))
  add(query_580087, "key", newJString(key))
  add(query_580087, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580088 = body
  add(query_580087, "prettyPrint", newJBool(prettyPrint))
  result = call_580085.call(path_580086, query_580087, nil, nil, body_580088)

var cloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice* = Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_580068(
    name: "cloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{name}:sendCommandToDevice", validator: validate_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_580069,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_580070,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesCreate_580116 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesCreate_580118(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/devices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesCreate_580117(
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
  var valid_580119 = path.getOrDefault("parent")
  valid_580119 = validateParameter(valid_580119, JString, required = true,
                                 default = nil)
  if valid_580119 != nil:
    section.add "parent", valid_580119
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
  section = newJObject()
  var valid_580120 = query.getOrDefault("upload_protocol")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "upload_protocol", valid_580120
  var valid_580121 = query.getOrDefault("fields")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "fields", valid_580121
  var valid_580122 = query.getOrDefault("quotaUser")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "quotaUser", valid_580122
  var valid_580123 = query.getOrDefault("alt")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = newJString("json"))
  if valid_580123 != nil:
    section.add "alt", valid_580123
  var valid_580124 = query.getOrDefault("oauth_token")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "oauth_token", valid_580124
  var valid_580125 = query.getOrDefault("callback")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "callback", valid_580125
  var valid_580126 = query.getOrDefault("access_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "access_token", valid_580126
  var valid_580127 = query.getOrDefault("uploadType")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "uploadType", valid_580127
  var valid_580128 = query.getOrDefault("key")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "key", valid_580128
  var valid_580129 = query.getOrDefault("$.xgafv")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = newJString("1"))
  if valid_580129 != nil:
    section.add "$.xgafv", valid_580129
  var valid_580130 = query.getOrDefault("prettyPrint")
  valid_580130 = validateParameter(valid_580130, JBool, required = false,
                                 default = newJBool(true))
  if valid_580130 != nil:
    section.add "prettyPrint", valid_580130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580132: Call_CloudiotProjectsLocationsRegistriesDevicesCreate_580116;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a device in a device registry.
  ## 
  let valid = call_580132.validator(path, query, header, formData, body)
  let scheme = call_580132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580132.url(scheme.get, call_580132.host, call_580132.base,
                         call_580132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580132, url, valid)

proc call*(call_580133: Call_CloudiotProjectsLocationsRegistriesDevicesCreate_580116;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  var path_580134 = newJObject()
  var query_580135 = newJObject()
  var body_580136 = newJObject()
  add(query_580135, "upload_protocol", newJString(uploadProtocol))
  add(query_580135, "fields", newJString(fields))
  add(query_580135, "quotaUser", newJString(quotaUser))
  add(query_580135, "alt", newJString(alt))
  add(query_580135, "oauth_token", newJString(oauthToken))
  add(query_580135, "callback", newJString(callback))
  add(query_580135, "access_token", newJString(accessToken))
  add(query_580135, "uploadType", newJString(uploadType))
  add(path_580134, "parent", newJString(parent))
  add(query_580135, "key", newJString(key))
  add(query_580135, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580136 = body
  add(query_580135, "prettyPrint", newJBool(prettyPrint))
  result = call_580133.call(path_580134, query_580135, nil, nil, body_580136)

var cloudiotProjectsLocationsRegistriesDevicesCreate* = Call_CloudiotProjectsLocationsRegistriesDevicesCreate_580116(
    name: "cloudiotProjectsLocationsRegistriesDevicesCreate",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}/devices",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesCreate_580117,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesCreate_580118,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesList_580089 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesDevicesList_580091(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/devices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesList_580090(
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
  var valid_580092 = path.getOrDefault("parent")
  valid_580092 = validateParameter(valid_580092, JString, required = true,
                                 default = nil)
  if valid_580092 != nil:
    section.add "parent", valid_580092
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   gatewayListOptions.gatewayType: JString
  ##                                 : If `GATEWAY` is specified, only gateways are returned. If `NON_GATEWAY`
  ## is specified, only non-gateway devices are returned. If
  ## `GATEWAY_TYPE_UNSPECIFIED` is specified, all devices are returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListDevicesResponse`; indicates
  ## that this is a continuation of a prior `ListDevices` call and
  ## the system should return the next page of data.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   gatewayListOptions.associationsDeviceId: JString
  ##                                          : If set, returns only the gateways with which the specified device is
  ## associated. The device ID can be numeric (`num_id`) or the user-defined
  ## string (`id`). For example, if `456` is specified, returns only the
  ## gateways to which the device with `num_id` 456 is bound.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   gatewayListOptions.associationsGatewayId: JString
  ##                                           : If set, only devices associated with the specified gateway are returned.
  ## The gateway ID can be numeric (`num_id`) or the user-defined string
  ## (`id`). For example, if `123` is specified, only devices bound to the
  ## gateway with `num_id` 123 are returned.
  ##   deviceIds: JArray
  ##            : A list of device string IDs. For example, `['device0', 'device12']`.
  ## If empty, this field is ignored. Maximum IDs: 10,000
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fieldMask: JString
  ##            : The fields of the `Device` resource to be returned in the response. The
  ## fields `id` and `num_id` are always returned, along with any
  ## other fields specified.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of devices to return in the response. If this value
  ## is zero, the service will select a default size. A call may return fewer
  ## objects than requested. A non-empty `next_page_token` in the response
  ## indicates that more data is available.
  ##   deviceNumIds: JArray
  ##               : A list of device numeric IDs. If empty, this field is ignored. Maximum
  ## IDs: 10,000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580093 = query.getOrDefault("upload_protocol")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "upload_protocol", valid_580093
  var valid_580094 = query.getOrDefault("gatewayListOptions.gatewayType")
  valid_580094 = validateParameter(valid_580094, JString, required = false, default = newJString(
      "GATEWAY_TYPE_UNSPECIFIED"))
  if valid_580094 != nil:
    section.add "gatewayListOptions.gatewayType", valid_580094
  var valid_580095 = query.getOrDefault("fields")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "fields", valid_580095
  var valid_580096 = query.getOrDefault("pageToken")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "pageToken", valid_580096
  var valid_580097 = query.getOrDefault("quotaUser")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "quotaUser", valid_580097
  var valid_580098 = query.getOrDefault("alt")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = newJString("json"))
  if valid_580098 != nil:
    section.add "alt", valid_580098
  var valid_580099 = query.getOrDefault("gatewayListOptions.associationsDeviceId")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "gatewayListOptions.associationsDeviceId", valid_580099
  var valid_580100 = query.getOrDefault("oauth_token")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "oauth_token", valid_580100
  var valid_580101 = query.getOrDefault("callback")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "callback", valid_580101
  var valid_580102 = query.getOrDefault("access_token")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "access_token", valid_580102
  var valid_580103 = query.getOrDefault("uploadType")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "uploadType", valid_580103
  var valid_580104 = query.getOrDefault("gatewayListOptions.associationsGatewayId")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "gatewayListOptions.associationsGatewayId", valid_580104
  var valid_580105 = query.getOrDefault("deviceIds")
  valid_580105 = validateParameter(valid_580105, JArray, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "deviceIds", valid_580105
  var valid_580106 = query.getOrDefault("key")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "key", valid_580106
  var valid_580107 = query.getOrDefault("fieldMask")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "fieldMask", valid_580107
  var valid_580108 = query.getOrDefault("$.xgafv")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = newJString("1"))
  if valid_580108 != nil:
    section.add "$.xgafv", valid_580108
  var valid_580109 = query.getOrDefault("pageSize")
  valid_580109 = validateParameter(valid_580109, JInt, required = false, default = nil)
  if valid_580109 != nil:
    section.add "pageSize", valid_580109
  var valid_580110 = query.getOrDefault("deviceNumIds")
  valid_580110 = validateParameter(valid_580110, JArray, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "deviceNumIds", valid_580110
  var valid_580111 = query.getOrDefault("prettyPrint")
  valid_580111 = validateParameter(valid_580111, JBool, required = false,
                                 default = newJBool(true))
  if valid_580111 != nil:
    section.add "prettyPrint", valid_580111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580112: Call_CloudiotProjectsLocationsRegistriesDevicesList_580089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List devices in a device registry.
  ## 
  let valid = call_580112.validator(path, query, header, formData, body)
  let scheme = call_580112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580112.url(scheme.get, call_580112.host, call_580112.base,
                         call_580112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580112, url, valid)

proc call*(call_580113: Call_CloudiotProjectsLocationsRegistriesDevicesList_580089;
          parent: string; uploadProtocol: string = "";
          gatewayListOptionsGatewayType: string = "GATEWAY_TYPE_UNSPECIFIED";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; gatewayListOptionsAssociationsDeviceId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          gatewayListOptionsAssociationsGatewayId: string = "";
          deviceIds: JsonNode = nil; key: string = ""; fieldMask: string = "";
          Xgafv: string = "1"; pageSize: int = 0; deviceNumIds: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesList
  ## List devices in a device registry.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   gatewayListOptionsGatewayType: string
  ##                                : If `GATEWAY` is specified, only gateways are returned. If `NON_GATEWAY`
  ## is specified, only non-gateway devices are returned. If
  ## `GATEWAY_TYPE_UNSPECIFIED` is specified, all devices are returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListDevicesResponse`; indicates
  ## that this is a continuation of a prior `ListDevices` call and
  ## the system should return the next page of data.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   gatewayListOptionsAssociationsDeviceId: string
  ##                                         : If set, returns only the gateways with which the specified device is
  ## associated. The device ID can be numeric (`num_id`) or the user-defined
  ## string (`id`). For example, if `456` is specified, returns only the
  ## gateways to which the device with `num_id` 456 is bound.
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
  ##   gatewayListOptionsAssociationsGatewayId: string
  ##                                          : If set, only devices associated with the specified gateway are returned.
  ## The gateway ID can be numeric (`num_id`) or the user-defined string
  ## (`id`). For example, if `123` is specified, only devices bound to the
  ## gateway with `num_id` 123 are returned.
  ##   deviceIds: JArray
  ##            : A list of device string IDs. For example, `['device0', 'device12']`.
  ## If empty, this field is ignored. Maximum IDs: 10,000
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fieldMask: string
  ##            : The fields of the `Device` resource to be returned in the response. The
  ## fields `id` and `num_id` are always returned, along with any
  ## other fields specified.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of devices to return in the response. If this value
  ## is zero, the service will select a default size. A call may return fewer
  ## objects than requested. A non-empty `next_page_token` in the response
  ## indicates that more data is available.
  ##   deviceNumIds: JArray
  ##               : A list of device numeric IDs. If empty, this field is ignored. Maximum
  ## IDs: 10,000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580114 = newJObject()
  var query_580115 = newJObject()
  add(query_580115, "upload_protocol", newJString(uploadProtocol))
  add(query_580115, "gatewayListOptions.gatewayType",
      newJString(gatewayListOptionsGatewayType))
  add(query_580115, "fields", newJString(fields))
  add(query_580115, "pageToken", newJString(pageToken))
  add(query_580115, "quotaUser", newJString(quotaUser))
  add(query_580115, "alt", newJString(alt))
  add(query_580115, "gatewayListOptions.associationsDeviceId",
      newJString(gatewayListOptionsAssociationsDeviceId))
  add(query_580115, "oauth_token", newJString(oauthToken))
  add(query_580115, "callback", newJString(callback))
  add(query_580115, "access_token", newJString(accessToken))
  add(query_580115, "uploadType", newJString(uploadType))
  add(path_580114, "parent", newJString(parent))
  add(query_580115, "gatewayListOptions.associationsGatewayId",
      newJString(gatewayListOptionsAssociationsGatewayId))
  if deviceIds != nil:
    query_580115.add "deviceIds", deviceIds
  add(query_580115, "key", newJString(key))
  add(query_580115, "fieldMask", newJString(fieldMask))
  add(query_580115, "$.xgafv", newJString(Xgafv))
  add(query_580115, "pageSize", newJInt(pageSize))
  if deviceNumIds != nil:
    query_580115.add "deviceNumIds", deviceNumIds
  add(query_580115, "prettyPrint", newJBool(prettyPrint))
  result = call_580113.call(path_580114, query_580115, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesList* = Call_CloudiotProjectsLocationsRegistriesDevicesList_580089(
    name: "cloudiotProjectsLocationsRegistriesDevicesList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}/devices",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesList_580090,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesList_580091,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesCreate_580158 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesCreate_580160(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/registries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesCreate_580159(path: JsonNode;
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
  var valid_580161 = path.getOrDefault("parent")
  valid_580161 = validateParameter(valid_580161, JString, required = true,
                                 default = nil)
  if valid_580161 != nil:
    section.add "parent", valid_580161
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
  section = newJObject()
  var valid_580162 = query.getOrDefault("upload_protocol")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "upload_protocol", valid_580162
  var valid_580163 = query.getOrDefault("fields")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "fields", valid_580163
  var valid_580164 = query.getOrDefault("quotaUser")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "quotaUser", valid_580164
  var valid_580165 = query.getOrDefault("alt")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = newJString("json"))
  if valid_580165 != nil:
    section.add "alt", valid_580165
  var valid_580166 = query.getOrDefault("oauth_token")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "oauth_token", valid_580166
  var valid_580167 = query.getOrDefault("callback")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "callback", valid_580167
  var valid_580168 = query.getOrDefault("access_token")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "access_token", valid_580168
  var valid_580169 = query.getOrDefault("uploadType")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "uploadType", valid_580169
  var valid_580170 = query.getOrDefault("key")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "key", valid_580170
  var valid_580171 = query.getOrDefault("$.xgafv")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = newJString("1"))
  if valid_580171 != nil:
    section.add "$.xgafv", valid_580171
  var valid_580172 = query.getOrDefault("prettyPrint")
  valid_580172 = validateParameter(valid_580172, JBool, required = false,
                                 default = newJBool(true))
  if valid_580172 != nil:
    section.add "prettyPrint", valid_580172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580174: Call_CloudiotProjectsLocationsRegistriesCreate_580158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a device registry that contains devices.
  ## 
  let valid = call_580174.validator(path, query, header, formData, body)
  let scheme = call_580174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580174.url(scheme.get, call_580174.host, call_580174.base,
                         call_580174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580174, url, valid)

proc call*(call_580175: Call_CloudiotProjectsLocationsRegistriesCreate_580158;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  var path_580176 = newJObject()
  var query_580177 = newJObject()
  var body_580178 = newJObject()
  add(query_580177, "upload_protocol", newJString(uploadProtocol))
  add(query_580177, "fields", newJString(fields))
  add(query_580177, "quotaUser", newJString(quotaUser))
  add(query_580177, "alt", newJString(alt))
  add(query_580177, "oauth_token", newJString(oauthToken))
  add(query_580177, "callback", newJString(callback))
  add(query_580177, "access_token", newJString(accessToken))
  add(query_580177, "uploadType", newJString(uploadType))
  add(path_580176, "parent", newJString(parent))
  add(query_580177, "key", newJString(key))
  add(query_580177, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580178 = body
  add(query_580177, "prettyPrint", newJBool(prettyPrint))
  result = call_580175.call(path_580176, query_580177, nil, nil, body_580178)

var cloudiotProjectsLocationsRegistriesCreate* = Call_CloudiotProjectsLocationsRegistriesCreate_580158(
    name: "cloudiotProjectsLocationsRegistriesCreate", meth: HttpMethod.HttpPost,
    host: "cloudiot.googleapis.com", route: "/v1/{parent}/registries",
    validator: validate_CloudiotProjectsLocationsRegistriesCreate_580159,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesCreate_580160,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesList_580137 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesList_580139(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/registries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesList_580138(path: JsonNode;
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
  var valid_580140 = path.getOrDefault("parent")
  valid_580140 = validateParameter(valid_580140, JString, required = true,
                                 default = nil)
  if valid_580140 != nil:
    section.add "parent", valid_580140
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListDeviceRegistriesResponse`; indicates
  ## that this is a continuation of a prior `ListDeviceRegistries` call and
  ## the system should return the next page of data.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
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
  ## objects than requested. A non-empty `next_page_token` in the response
  ## indicates that more data is available.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580141 = query.getOrDefault("upload_protocol")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "upload_protocol", valid_580141
  var valid_580142 = query.getOrDefault("fields")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "fields", valid_580142
  var valid_580143 = query.getOrDefault("pageToken")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "pageToken", valid_580143
  var valid_580144 = query.getOrDefault("quotaUser")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "quotaUser", valid_580144
  var valid_580145 = query.getOrDefault("alt")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = newJString("json"))
  if valid_580145 != nil:
    section.add "alt", valid_580145
  var valid_580146 = query.getOrDefault("oauth_token")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "oauth_token", valid_580146
  var valid_580147 = query.getOrDefault("callback")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "callback", valid_580147
  var valid_580148 = query.getOrDefault("access_token")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "access_token", valid_580148
  var valid_580149 = query.getOrDefault("uploadType")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "uploadType", valid_580149
  var valid_580150 = query.getOrDefault("key")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "key", valid_580150
  var valid_580151 = query.getOrDefault("$.xgafv")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = newJString("1"))
  if valid_580151 != nil:
    section.add "$.xgafv", valid_580151
  var valid_580152 = query.getOrDefault("pageSize")
  valid_580152 = validateParameter(valid_580152, JInt, required = false, default = nil)
  if valid_580152 != nil:
    section.add "pageSize", valid_580152
  var valid_580153 = query.getOrDefault("prettyPrint")
  valid_580153 = validateParameter(valid_580153, JBool, required = false,
                                 default = newJBool(true))
  if valid_580153 != nil:
    section.add "prettyPrint", valid_580153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580154: Call_CloudiotProjectsLocationsRegistriesList_580137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists device registries.
  ## 
  let valid = call_580154.validator(path, query, header, formData, body)
  let scheme = call_580154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580154.url(scheme.get, call_580154.host, call_580154.base,
                         call_580154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580154, url, valid)

proc call*(call_580155: Call_CloudiotProjectsLocationsRegistriesList_580137;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudiotProjectsLocationsRegistriesList
  ## Lists device registries.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListDeviceRegistriesResponse`; indicates
  ## that this is a continuation of a prior `ListDeviceRegistries` call and
  ## the system should return the next page of data.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ## objects than requested. A non-empty `next_page_token` in the response
  ## indicates that more data is available.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580156 = newJObject()
  var query_580157 = newJObject()
  add(query_580157, "upload_protocol", newJString(uploadProtocol))
  add(query_580157, "fields", newJString(fields))
  add(query_580157, "pageToken", newJString(pageToken))
  add(query_580157, "quotaUser", newJString(quotaUser))
  add(query_580157, "alt", newJString(alt))
  add(query_580157, "oauth_token", newJString(oauthToken))
  add(query_580157, "callback", newJString(callback))
  add(query_580157, "access_token", newJString(accessToken))
  add(query_580157, "uploadType", newJString(uploadType))
  add(path_580156, "parent", newJString(parent))
  add(query_580157, "key", newJString(key))
  add(query_580157, "$.xgafv", newJString(Xgafv))
  add(query_580157, "pageSize", newJInt(pageSize))
  add(query_580157, "prettyPrint", newJBool(prettyPrint))
  result = call_580155.call(path_580156, query_580157, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesList* = Call_CloudiotProjectsLocationsRegistriesList_580137(
    name: "cloudiotProjectsLocationsRegistriesList", meth: HttpMethod.HttpGet,
    host: "cloudiot.googleapis.com", route: "/v1/{parent}/registries",
    validator: validate_CloudiotProjectsLocationsRegistriesList_580138, base: "/",
    url: url_CloudiotProjectsLocationsRegistriesList_580139,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_580179 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_580181(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":bindDeviceToGateway")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_580180(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Associates the device with the gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the registry. For example,
  ## `projects/example-project/locations/us-central1/registries/my-registry`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580182 = path.getOrDefault("parent")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "parent", valid_580182
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
  section = newJObject()
  var valid_580183 = query.getOrDefault("upload_protocol")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "upload_protocol", valid_580183
  var valid_580184 = query.getOrDefault("fields")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "fields", valid_580184
  var valid_580185 = query.getOrDefault("quotaUser")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "quotaUser", valid_580185
  var valid_580186 = query.getOrDefault("alt")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("json"))
  if valid_580186 != nil:
    section.add "alt", valid_580186
  var valid_580187 = query.getOrDefault("oauth_token")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "oauth_token", valid_580187
  var valid_580188 = query.getOrDefault("callback")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "callback", valid_580188
  var valid_580189 = query.getOrDefault("access_token")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "access_token", valid_580189
  var valid_580190 = query.getOrDefault("uploadType")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "uploadType", valid_580190
  var valid_580191 = query.getOrDefault("key")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "key", valid_580191
  var valid_580192 = query.getOrDefault("$.xgafv")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = newJString("1"))
  if valid_580192 != nil:
    section.add "$.xgafv", valid_580192
  var valid_580193 = query.getOrDefault("prettyPrint")
  valid_580193 = validateParameter(valid_580193, JBool, required = false,
                                 default = newJBool(true))
  if valid_580193 != nil:
    section.add "prettyPrint", valid_580193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580195: Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_580179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associates the device with the gateway.
  ## 
  let valid = call_580195.validator(path, query, header, formData, body)
  let scheme = call_580195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580195.url(scheme.get, call_580195.host, call_580195.base,
                         call_580195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580195, url, valid)

proc call*(call_580196: Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_580179;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudiotProjectsLocationsRegistriesBindDeviceToGateway
  ## Associates the device with the gateway.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The name of the registry. For example,
  ## `projects/example-project/locations/us-central1/registries/my-registry`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580197 = newJObject()
  var query_580198 = newJObject()
  var body_580199 = newJObject()
  add(query_580198, "upload_protocol", newJString(uploadProtocol))
  add(query_580198, "fields", newJString(fields))
  add(query_580198, "quotaUser", newJString(quotaUser))
  add(query_580198, "alt", newJString(alt))
  add(query_580198, "oauth_token", newJString(oauthToken))
  add(query_580198, "callback", newJString(callback))
  add(query_580198, "access_token", newJString(accessToken))
  add(query_580198, "uploadType", newJString(uploadType))
  add(path_580197, "parent", newJString(parent))
  add(query_580198, "key", newJString(key))
  add(query_580198, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580199 = body
  add(query_580198, "prettyPrint", newJBool(prettyPrint))
  result = call_580196.call(path_580197, query_580198, nil, nil, body_580199)

var cloudiotProjectsLocationsRegistriesBindDeviceToGateway* = Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_580179(
    name: "cloudiotProjectsLocationsRegistriesBindDeviceToGateway",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}:bindDeviceToGateway",
    validator: validate_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_580180,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_580181,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_580200 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_580202(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":unbindDeviceFromGateway")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_580201(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the association between the device and the gateway.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the registry. For example,
  ## `projects/example-project/locations/us-central1/registries/my-registry`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580203 = path.getOrDefault("parent")
  valid_580203 = validateParameter(valid_580203, JString, required = true,
                                 default = nil)
  if valid_580203 != nil:
    section.add "parent", valid_580203
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
  section = newJObject()
  var valid_580204 = query.getOrDefault("upload_protocol")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "upload_protocol", valid_580204
  var valid_580205 = query.getOrDefault("fields")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "fields", valid_580205
  var valid_580206 = query.getOrDefault("quotaUser")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "quotaUser", valid_580206
  var valid_580207 = query.getOrDefault("alt")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = newJString("json"))
  if valid_580207 != nil:
    section.add "alt", valid_580207
  var valid_580208 = query.getOrDefault("oauth_token")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "oauth_token", valid_580208
  var valid_580209 = query.getOrDefault("callback")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "callback", valid_580209
  var valid_580210 = query.getOrDefault("access_token")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "access_token", valid_580210
  var valid_580211 = query.getOrDefault("uploadType")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "uploadType", valid_580211
  var valid_580212 = query.getOrDefault("key")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "key", valid_580212
  var valid_580213 = query.getOrDefault("$.xgafv")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = newJString("1"))
  if valid_580213 != nil:
    section.add "$.xgafv", valid_580213
  var valid_580214 = query.getOrDefault("prettyPrint")
  valid_580214 = validateParameter(valid_580214, JBool, required = false,
                                 default = newJBool(true))
  if valid_580214 != nil:
    section.add "prettyPrint", valid_580214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580216: Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_580200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the association between the device and the gateway.
  ## 
  let valid = call_580216.validator(path, query, header, formData, body)
  let scheme = call_580216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580216.url(scheme.get, call_580216.host, call_580216.base,
                         call_580216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580216, url, valid)

proc call*(call_580217: Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_580200;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway
  ## Deletes the association between the device and the gateway.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The name of the registry. For example,
  ## `projects/example-project/locations/us-central1/registries/my-registry`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580218 = newJObject()
  var query_580219 = newJObject()
  var body_580220 = newJObject()
  add(query_580219, "upload_protocol", newJString(uploadProtocol))
  add(query_580219, "fields", newJString(fields))
  add(query_580219, "quotaUser", newJString(quotaUser))
  add(query_580219, "alt", newJString(alt))
  add(query_580219, "oauth_token", newJString(oauthToken))
  add(query_580219, "callback", newJString(callback))
  add(query_580219, "access_token", newJString(accessToken))
  add(query_580219, "uploadType", newJString(uploadType))
  add(path_580218, "parent", newJString(parent))
  add(query_580219, "key", newJString(key))
  add(query_580219, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580220 = body
  add(query_580219, "prettyPrint", newJBool(prettyPrint))
  result = call_580217.call(path_580218, query_580219, nil, nil, body_580220)

var cloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway* = Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_580200(
    name: "cloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}:unbindDeviceFromGateway", validator: validate_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_580201,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_580202,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_580221 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_580223(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_580222(
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
  var valid_580224 = path.getOrDefault("resource")
  valid_580224 = validateParameter(valid_580224, JString, required = true,
                                 default = nil)
  if valid_580224 != nil:
    section.add "resource", valid_580224
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
  section = newJObject()
  var valid_580225 = query.getOrDefault("upload_protocol")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "upload_protocol", valid_580225
  var valid_580226 = query.getOrDefault("fields")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "fields", valid_580226
  var valid_580227 = query.getOrDefault("quotaUser")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "quotaUser", valid_580227
  var valid_580228 = query.getOrDefault("alt")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("json"))
  if valid_580228 != nil:
    section.add "alt", valid_580228
  var valid_580229 = query.getOrDefault("oauth_token")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "oauth_token", valid_580229
  var valid_580230 = query.getOrDefault("callback")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "callback", valid_580230
  var valid_580231 = query.getOrDefault("access_token")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "access_token", valid_580231
  var valid_580232 = query.getOrDefault("uploadType")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "uploadType", valid_580232
  var valid_580233 = query.getOrDefault("key")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "key", valid_580233
  var valid_580234 = query.getOrDefault("$.xgafv")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = newJString("1"))
  if valid_580234 != nil:
    section.add "$.xgafv", valid_580234
  var valid_580235 = query.getOrDefault("prettyPrint")
  valid_580235 = validateParameter(valid_580235, JBool, required = false,
                                 default = newJBool(true))
  if valid_580235 != nil:
    section.add "prettyPrint", valid_580235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580237: Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_580221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_580237.validator(path, query, header, formData, body)
  let scheme = call_580237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580237.url(scheme.get, call_580237.host, call_580237.base,
                         call_580237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580237, url, valid)

proc call*(call_580238: Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_580221;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudiotProjectsLocationsRegistriesGroupsGetIamPolicy
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
  var path_580239 = newJObject()
  var query_580240 = newJObject()
  var body_580241 = newJObject()
  add(query_580240, "upload_protocol", newJString(uploadProtocol))
  add(query_580240, "fields", newJString(fields))
  add(query_580240, "quotaUser", newJString(quotaUser))
  add(query_580240, "alt", newJString(alt))
  add(query_580240, "oauth_token", newJString(oauthToken))
  add(query_580240, "callback", newJString(callback))
  add(query_580240, "access_token", newJString(accessToken))
  add(query_580240, "uploadType", newJString(uploadType))
  add(query_580240, "key", newJString(key))
  add(query_580240, "$.xgafv", newJString(Xgafv))
  add(path_580239, "resource", newJString(resource))
  if body != nil:
    body_580241 = body
  add(query_580240, "prettyPrint", newJBool(prettyPrint))
  result = call_580238.call(path_580239, query_580240, nil, nil, body_580241)

var cloudiotProjectsLocationsRegistriesGroupsGetIamPolicy* = Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_580221(
    name: "cloudiotProjectsLocationsRegistriesGroupsGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_580222,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_580223,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_580242 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_580244(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_580243(
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
  var valid_580245 = path.getOrDefault("resource")
  valid_580245 = validateParameter(valid_580245, JString, required = true,
                                 default = nil)
  if valid_580245 != nil:
    section.add "resource", valid_580245
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
  section = newJObject()
  var valid_580246 = query.getOrDefault("upload_protocol")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "upload_protocol", valid_580246
  var valid_580247 = query.getOrDefault("fields")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "fields", valid_580247
  var valid_580248 = query.getOrDefault("quotaUser")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "quotaUser", valid_580248
  var valid_580249 = query.getOrDefault("alt")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = newJString("json"))
  if valid_580249 != nil:
    section.add "alt", valid_580249
  var valid_580250 = query.getOrDefault("oauth_token")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "oauth_token", valid_580250
  var valid_580251 = query.getOrDefault("callback")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "callback", valid_580251
  var valid_580252 = query.getOrDefault("access_token")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "access_token", valid_580252
  var valid_580253 = query.getOrDefault("uploadType")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "uploadType", valid_580253
  var valid_580254 = query.getOrDefault("key")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "key", valid_580254
  var valid_580255 = query.getOrDefault("$.xgafv")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = newJString("1"))
  if valid_580255 != nil:
    section.add "$.xgafv", valid_580255
  var valid_580256 = query.getOrDefault("prettyPrint")
  valid_580256 = validateParameter(valid_580256, JBool, required = false,
                                 default = newJBool(true))
  if valid_580256 != nil:
    section.add "prettyPrint", valid_580256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580258: Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_580242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_580258.validator(path, query, header, formData, body)
  let scheme = call_580258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580258.url(scheme.get, call_580258.host, call_580258.base,
                         call_580258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580258, url, valid)

proc call*(call_580259: Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_580242;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudiotProjectsLocationsRegistriesGroupsSetIamPolicy
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
  var path_580260 = newJObject()
  var query_580261 = newJObject()
  var body_580262 = newJObject()
  add(query_580261, "upload_protocol", newJString(uploadProtocol))
  add(query_580261, "fields", newJString(fields))
  add(query_580261, "quotaUser", newJString(quotaUser))
  add(query_580261, "alt", newJString(alt))
  add(query_580261, "oauth_token", newJString(oauthToken))
  add(query_580261, "callback", newJString(callback))
  add(query_580261, "access_token", newJString(accessToken))
  add(query_580261, "uploadType", newJString(uploadType))
  add(query_580261, "key", newJString(key))
  add(query_580261, "$.xgafv", newJString(Xgafv))
  add(path_580260, "resource", newJString(resource))
  if body != nil:
    body_580262 = body
  add(query_580261, "prettyPrint", newJBool(prettyPrint))
  result = call_580259.call(path_580260, query_580261, nil, nil, body_580262)

var cloudiotProjectsLocationsRegistriesGroupsSetIamPolicy* = Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_580242(
    name: "cloudiotProjectsLocationsRegistriesGroupsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_580243,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_580244,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_580263 = ref object of OpenApiRestCall_579408
proc url_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_580265(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_580264(
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
  var valid_580266 = path.getOrDefault("resource")
  valid_580266 = validateParameter(valid_580266, JString, required = true,
                                 default = nil)
  if valid_580266 != nil:
    section.add "resource", valid_580266
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
  section = newJObject()
  var valid_580267 = query.getOrDefault("upload_protocol")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "upload_protocol", valid_580267
  var valid_580268 = query.getOrDefault("fields")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "fields", valid_580268
  var valid_580269 = query.getOrDefault("quotaUser")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "quotaUser", valid_580269
  var valid_580270 = query.getOrDefault("alt")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = newJString("json"))
  if valid_580270 != nil:
    section.add "alt", valid_580270
  var valid_580271 = query.getOrDefault("oauth_token")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "oauth_token", valid_580271
  var valid_580272 = query.getOrDefault("callback")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "callback", valid_580272
  var valid_580273 = query.getOrDefault("access_token")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "access_token", valid_580273
  var valid_580274 = query.getOrDefault("uploadType")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "uploadType", valid_580274
  var valid_580275 = query.getOrDefault("key")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "key", valid_580275
  var valid_580276 = query.getOrDefault("$.xgafv")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = newJString("1"))
  if valid_580276 != nil:
    section.add "$.xgafv", valid_580276
  var valid_580277 = query.getOrDefault("prettyPrint")
  valid_580277 = validateParameter(valid_580277, JBool, required = false,
                                 default = newJBool(true))
  if valid_580277 != nil:
    section.add "prettyPrint", valid_580277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580279: Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_580263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  let valid = call_580279.validator(path, query, header, formData, body)
  let scheme = call_580279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580279.url(scheme.get, call_580279.host, call_580279.base,
                         call_580279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580279, url, valid)

proc call*(call_580280: Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_580263;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudiotProjectsLocationsRegistriesGroupsTestIamPermissions
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
  var path_580281 = newJObject()
  var query_580282 = newJObject()
  var body_580283 = newJObject()
  add(query_580282, "upload_protocol", newJString(uploadProtocol))
  add(query_580282, "fields", newJString(fields))
  add(query_580282, "quotaUser", newJString(quotaUser))
  add(query_580282, "alt", newJString(alt))
  add(query_580282, "oauth_token", newJString(oauthToken))
  add(query_580282, "callback", newJString(callback))
  add(query_580282, "access_token", newJString(accessToken))
  add(query_580282, "uploadType", newJString(uploadType))
  add(query_580282, "key", newJString(key))
  add(query_580282, "$.xgafv", newJString(Xgafv))
  add(path_580281, "resource", newJString(resource))
  if body != nil:
    body_580283 = body
  add(query_580282, "prettyPrint", newJBool(prettyPrint))
  result = call_580280.call(path_580281, query_580282, nil, nil, body_580283)

var cloudiotProjectsLocationsRegistriesGroupsTestIamPermissions* = Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_580263(
    name: "cloudiotProjectsLocationsRegistriesGroupsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{resource}:testIamPermissions", validator: validate_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_580264,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_580265,
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
