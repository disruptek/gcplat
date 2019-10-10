
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
  gcpServiceName = "cloudiot"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudiotProjectsLocationsRegistriesDevicesGet_588710 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesDevicesGet_588712(protocol: Scheme;
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesGet_588711(
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
  var valid_588838 = path.getOrDefault("name")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "name", valid_588838
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
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("callback")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "callback", valid_588857
  var valid_588858 = query.getOrDefault("access_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "access_token", valid_588858
  var valid_588859 = query.getOrDefault("uploadType")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "uploadType", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("fieldMask")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = nil)
  if valid_588861 != nil:
    section.add "fieldMask", valid_588861
  var valid_588862 = query.getOrDefault("$.xgafv")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = newJString("1"))
  if valid_588862 != nil:
    section.add "$.xgafv", valid_588862
  var valid_588863 = query.getOrDefault("prettyPrint")
  valid_588863 = validateParameter(valid_588863, JBool, required = false,
                                 default = newJBool(true))
  if valid_588863 != nil:
    section.add "prettyPrint", valid_588863
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588886: Call_CloudiotProjectsLocationsRegistriesDevicesGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets details about a device.
  ## 
  let valid = call_588886.validator(path, query, header, formData, body)
  let scheme = call_588886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588886.url(scheme.get, call_588886.host, call_588886.base,
                         call_588886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588886, url, valid)

proc call*(call_588957: Call_CloudiotProjectsLocationsRegistriesDevicesGet_588710;
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
  var path_588958 = newJObject()
  var query_588960 = newJObject()
  add(query_588960, "upload_protocol", newJString(uploadProtocol))
  add(query_588960, "fields", newJString(fields))
  add(query_588960, "quotaUser", newJString(quotaUser))
  add(path_588958, "name", newJString(name))
  add(query_588960, "alt", newJString(alt))
  add(query_588960, "oauth_token", newJString(oauthToken))
  add(query_588960, "callback", newJString(callback))
  add(query_588960, "access_token", newJString(accessToken))
  add(query_588960, "uploadType", newJString(uploadType))
  add(query_588960, "key", newJString(key))
  add(query_588960, "fieldMask", newJString(fieldMask))
  add(query_588960, "$.xgafv", newJString(Xgafv))
  add(query_588960, "prettyPrint", newJBool(prettyPrint))
  result = call_588957.call(path_588958, query_588960, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesGet* = Call_CloudiotProjectsLocationsRegistriesDevicesGet_588710(
    name: "cloudiotProjectsLocationsRegistriesDevicesGet",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesGet_588711,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesGet_588712,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesPatch_589018 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesDevicesPatch_589020(protocol: Scheme;
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesPatch_589019(
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
  var valid_589021 = path.getOrDefault("name")
  valid_589021 = validateParameter(valid_589021, JString, required = true,
                                 default = nil)
  if valid_589021 != nil:
    section.add "name", valid_589021
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
  var valid_589022 = query.getOrDefault("upload_protocol")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "upload_protocol", valid_589022
  var valid_589023 = query.getOrDefault("fields")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "fields", valid_589023
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
  var valid_589026 = query.getOrDefault("oauth_token")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "oauth_token", valid_589026
  var valid_589027 = query.getOrDefault("callback")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "callback", valid_589027
  var valid_589028 = query.getOrDefault("access_token")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "access_token", valid_589028
  var valid_589029 = query.getOrDefault("uploadType")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "uploadType", valid_589029
  var valid_589030 = query.getOrDefault("key")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "key", valid_589030
  var valid_589031 = query.getOrDefault("$.xgafv")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = newJString("1"))
  if valid_589031 != nil:
    section.add "$.xgafv", valid_589031
  var valid_589032 = query.getOrDefault("prettyPrint")
  valid_589032 = validateParameter(valid_589032, JBool, required = false,
                                 default = newJBool(true))
  if valid_589032 != nil:
    section.add "prettyPrint", valid_589032
  var valid_589033 = query.getOrDefault("updateMask")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "updateMask", valid_589033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589035: Call_CloudiotProjectsLocationsRegistriesDevicesPatch_589018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a device.
  ## 
  let valid = call_589035.validator(path, query, header, formData, body)
  let scheme = call_589035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589035.url(scheme.get, call_589035.host, call_589035.base,
                         call_589035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589035, url, valid)

proc call*(call_589036: Call_CloudiotProjectsLocationsRegistriesDevicesPatch_589018;
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
  var path_589037 = newJObject()
  var query_589038 = newJObject()
  var body_589039 = newJObject()
  add(query_589038, "upload_protocol", newJString(uploadProtocol))
  add(query_589038, "fields", newJString(fields))
  add(query_589038, "quotaUser", newJString(quotaUser))
  add(path_589037, "name", newJString(name))
  add(query_589038, "alt", newJString(alt))
  add(query_589038, "oauth_token", newJString(oauthToken))
  add(query_589038, "callback", newJString(callback))
  add(query_589038, "access_token", newJString(accessToken))
  add(query_589038, "uploadType", newJString(uploadType))
  add(query_589038, "key", newJString(key))
  add(query_589038, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589039 = body
  add(query_589038, "prettyPrint", newJBool(prettyPrint))
  add(query_589038, "updateMask", newJString(updateMask))
  result = call_589036.call(path_589037, query_589038, nil, nil, body_589039)

var cloudiotProjectsLocationsRegistriesDevicesPatch* = Call_CloudiotProjectsLocationsRegistriesDevicesPatch_589018(
    name: "cloudiotProjectsLocationsRegistriesDevicesPatch",
    meth: HttpMethod.HttpPatch, host: "cloudiot.googleapis.com",
    route: "/v1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesPatch_589019,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesPatch_589020,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesDelete_588999 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesDevicesDelete_589001(
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesDelete_589000(
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
  var valid_589002 = path.getOrDefault("name")
  valid_589002 = validateParameter(valid_589002, JString, required = true,
                                 default = nil)
  if valid_589002 != nil:
    section.add "name", valid_589002
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
  var valid_589003 = query.getOrDefault("upload_protocol")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "upload_protocol", valid_589003
  var valid_589004 = query.getOrDefault("fields")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "fields", valid_589004
  var valid_589005 = query.getOrDefault("quotaUser")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "quotaUser", valid_589005
  var valid_589006 = query.getOrDefault("alt")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = newJString("json"))
  if valid_589006 != nil:
    section.add "alt", valid_589006
  var valid_589007 = query.getOrDefault("oauth_token")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "oauth_token", valid_589007
  var valid_589008 = query.getOrDefault("callback")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "callback", valid_589008
  var valid_589009 = query.getOrDefault("access_token")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "access_token", valid_589009
  var valid_589010 = query.getOrDefault("uploadType")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "uploadType", valid_589010
  var valid_589011 = query.getOrDefault("key")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "key", valid_589011
  var valid_589012 = query.getOrDefault("$.xgafv")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("1"))
  if valid_589012 != nil:
    section.add "$.xgafv", valid_589012
  var valid_589013 = query.getOrDefault("prettyPrint")
  valid_589013 = validateParameter(valid_589013, JBool, required = false,
                                 default = newJBool(true))
  if valid_589013 != nil:
    section.add "prettyPrint", valid_589013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589014: Call_CloudiotProjectsLocationsRegistriesDevicesDelete_588999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a device.
  ## 
  let valid = call_589014.validator(path, query, header, formData, body)
  let scheme = call_589014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589014.url(scheme.get, call_589014.host, call_589014.base,
                         call_589014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589014, url, valid)

proc call*(call_589015: Call_CloudiotProjectsLocationsRegistriesDevicesDelete_588999;
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
  var path_589016 = newJObject()
  var query_589017 = newJObject()
  add(query_589017, "upload_protocol", newJString(uploadProtocol))
  add(query_589017, "fields", newJString(fields))
  add(query_589017, "quotaUser", newJString(quotaUser))
  add(path_589016, "name", newJString(name))
  add(query_589017, "alt", newJString(alt))
  add(query_589017, "oauth_token", newJString(oauthToken))
  add(query_589017, "callback", newJString(callback))
  add(query_589017, "access_token", newJString(accessToken))
  add(query_589017, "uploadType", newJString(uploadType))
  add(query_589017, "key", newJString(key))
  add(query_589017, "$.xgafv", newJString(Xgafv))
  add(query_589017, "prettyPrint", newJBool(prettyPrint))
  result = call_589015.call(path_589016, query_589017, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesDelete* = Call_CloudiotProjectsLocationsRegistriesDevicesDelete_588999(
    name: "cloudiotProjectsLocationsRegistriesDevicesDelete",
    meth: HttpMethod.HttpDelete, host: "cloudiot.googleapis.com",
    route: "/v1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesDelete_589000,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesDelete_589001,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_589040 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_589042(
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_589041(
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
  var valid_589043 = path.getOrDefault("name")
  valid_589043 = validateParameter(valid_589043, JString, required = true,
                                 default = nil)
  if valid_589043 != nil:
    section.add "name", valid_589043
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
  var valid_589044 = query.getOrDefault("upload_protocol")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "upload_protocol", valid_589044
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
  var valid_589048 = query.getOrDefault("oauth_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "oauth_token", valid_589048
  var valid_589049 = query.getOrDefault("callback")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "callback", valid_589049
  var valid_589050 = query.getOrDefault("access_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "access_token", valid_589050
  var valid_589051 = query.getOrDefault("uploadType")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "uploadType", valid_589051
  var valid_589052 = query.getOrDefault("key")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "key", valid_589052
  var valid_589053 = query.getOrDefault("$.xgafv")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = newJString("1"))
  if valid_589053 != nil:
    section.add "$.xgafv", valid_589053
  var valid_589054 = query.getOrDefault("prettyPrint")
  valid_589054 = validateParameter(valid_589054, JBool, required = false,
                                 default = newJBool(true))
  if valid_589054 != nil:
    section.add "prettyPrint", valid_589054
  var valid_589055 = query.getOrDefault("numVersions")
  valid_589055 = validateParameter(valid_589055, JInt, required = false, default = nil)
  if valid_589055 != nil:
    section.add "numVersions", valid_589055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589056: Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_589040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the last few versions of the device configuration in descending
  ## order (i.e.: newest first).
  ## 
  let valid = call_589056.validator(path, query, header, formData, body)
  let scheme = call_589056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589056.url(scheme.get, call_589056.host, call_589056.base,
                         call_589056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589056, url, valid)

proc call*(call_589057: Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_589040;
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
  var path_589058 = newJObject()
  var query_589059 = newJObject()
  add(query_589059, "upload_protocol", newJString(uploadProtocol))
  add(query_589059, "fields", newJString(fields))
  add(query_589059, "quotaUser", newJString(quotaUser))
  add(path_589058, "name", newJString(name))
  add(query_589059, "alt", newJString(alt))
  add(query_589059, "oauth_token", newJString(oauthToken))
  add(query_589059, "callback", newJString(callback))
  add(query_589059, "access_token", newJString(accessToken))
  add(query_589059, "uploadType", newJString(uploadType))
  add(query_589059, "key", newJString(key))
  add(query_589059, "$.xgafv", newJString(Xgafv))
  add(query_589059, "prettyPrint", newJBool(prettyPrint))
  add(query_589059, "numVersions", newJInt(numVersions))
  result = call_589057.call(path_589058, query_589059, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesConfigVersionsList* = Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_589040(
    name: "cloudiotProjectsLocationsRegistriesDevicesConfigVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1/{name}/configVersions", validator: validate_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_589041,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_589042,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_589060 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesDevicesStatesList_589062(
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesStatesList_589061(
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
  var valid_589063 = path.getOrDefault("name")
  valid_589063 = validateParameter(valid_589063, JString, required = true,
                                 default = nil)
  if valid_589063 != nil:
    section.add "name", valid_589063
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
  var valid_589064 = query.getOrDefault("upload_protocol")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "upload_protocol", valid_589064
  var valid_589065 = query.getOrDefault("fields")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "fields", valid_589065
  var valid_589066 = query.getOrDefault("quotaUser")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "quotaUser", valid_589066
  var valid_589067 = query.getOrDefault("alt")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = newJString("json"))
  if valid_589067 != nil:
    section.add "alt", valid_589067
  var valid_589068 = query.getOrDefault("oauth_token")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "oauth_token", valid_589068
  var valid_589069 = query.getOrDefault("callback")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "callback", valid_589069
  var valid_589070 = query.getOrDefault("access_token")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "access_token", valid_589070
  var valid_589071 = query.getOrDefault("uploadType")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "uploadType", valid_589071
  var valid_589072 = query.getOrDefault("key")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "key", valid_589072
  var valid_589073 = query.getOrDefault("$.xgafv")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = newJString("1"))
  if valid_589073 != nil:
    section.add "$.xgafv", valid_589073
  var valid_589074 = query.getOrDefault("numStates")
  valid_589074 = validateParameter(valid_589074, JInt, required = false, default = nil)
  if valid_589074 != nil:
    section.add "numStates", valid_589074
  var valid_589075 = query.getOrDefault("prettyPrint")
  valid_589075 = validateParameter(valid_589075, JBool, required = false,
                                 default = newJBool(true))
  if valid_589075 != nil:
    section.add "prettyPrint", valid_589075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589076: Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_589060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the last few versions of the device state in descending order (i.e.:
  ## newest first).
  ## 
  let valid = call_589076.validator(path, query, header, formData, body)
  let scheme = call_589076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589076.url(scheme.get, call_589076.host, call_589076.base,
                         call_589076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589076, url, valid)

proc call*(call_589077: Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_589060;
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
  var path_589078 = newJObject()
  var query_589079 = newJObject()
  add(query_589079, "upload_protocol", newJString(uploadProtocol))
  add(query_589079, "fields", newJString(fields))
  add(query_589079, "quotaUser", newJString(quotaUser))
  add(path_589078, "name", newJString(name))
  add(query_589079, "alt", newJString(alt))
  add(query_589079, "oauth_token", newJString(oauthToken))
  add(query_589079, "callback", newJString(callback))
  add(query_589079, "access_token", newJString(accessToken))
  add(query_589079, "uploadType", newJString(uploadType))
  add(query_589079, "key", newJString(key))
  add(query_589079, "$.xgafv", newJString(Xgafv))
  add(query_589079, "numStates", newJInt(numStates))
  add(query_589079, "prettyPrint", newJBool(prettyPrint))
  result = call_589077.call(path_589078, query_589079, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesStatesList* = Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_589060(
    name: "cloudiotProjectsLocationsRegistriesDevicesStatesList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1/{name}/states",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesStatesList_589061,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesStatesList_589062,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_589080 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_589082(
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_589081(
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
  var valid_589083 = path.getOrDefault("name")
  valid_589083 = validateParameter(valid_589083, JString, required = true,
                                 default = nil)
  if valid_589083 != nil:
    section.add "name", valid_589083
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
  var valid_589084 = query.getOrDefault("upload_protocol")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "upload_protocol", valid_589084
  var valid_589085 = query.getOrDefault("fields")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "fields", valid_589085
  var valid_589086 = query.getOrDefault("quotaUser")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "quotaUser", valid_589086
  var valid_589087 = query.getOrDefault("alt")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = newJString("json"))
  if valid_589087 != nil:
    section.add "alt", valid_589087
  var valid_589088 = query.getOrDefault("oauth_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "oauth_token", valid_589088
  var valid_589089 = query.getOrDefault("callback")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "callback", valid_589089
  var valid_589090 = query.getOrDefault("access_token")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "access_token", valid_589090
  var valid_589091 = query.getOrDefault("uploadType")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "uploadType", valid_589091
  var valid_589092 = query.getOrDefault("key")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "key", valid_589092
  var valid_589093 = query.getOrDefault("$.xgafv")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = newJString("1"))
  if valid_589093 != nil:
    section.add "$.xgafv", valid_589093
  var valid_589094 = query.getOrDefault("prettyPrint")
  valid_589094 = validateParameter(valid_589094, JBool, required = false,
                                 default = newJBool(true))
  if valid_589094 != nil:
    section.add "prettyPrint", valid_589094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589096: Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_589080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the configuration for the device, which is eventually sent from
  ## the Cloud IoT Core servers. Returns the modified configuration version and
  ## its metadata.
  ## 
  let valid = call_589096.validator(path, query, header, formData, body)
  let scheme = call_589096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589096.url(scheme.get, call_589096.host, call_589096.base,
                         call_589096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589096, url, valid)

proc call*(call_589097: Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_589080;
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
  var path_589098 = newJObject()
  var query_589099 = newJObject()
  var body_589100 = newJObject()
  add(query_589099, "upload_protocol", newJString(uploadProtocol))
  add(query_589099, "fields", newJString(fields))
  add(query_589099, "quotaUser", newJString(quotaUser))
  add(path_589098, "name", newJString(name))
  add(query_589099, "alt", newJString(alt))
  add(query_589099, "oauth_token", newJString(oauthToken))
  add(query_589099, "callback", newJString(callback))
  add(query_589099, "access_token", newJString(accessToken))
  add(query_589099, "uploadType", newJString(uploadType))
  add(query_589099, "key", newJString(key))
  add(query_589099, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589100 = body
  add(query_589099, "prettyPrint", newJBool(prettyPrint))
  result = call_589097.call(path_589098, query_589099, nil, nil, body_589100)

var cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig* = Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_589080(name: "cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{name}:modifyCloudToDeviceConfig", validator: validate_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_589081,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_589082,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_589101 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_589103(
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_589102(
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
  var valid_589104 = path.getOrDefault("name")
  valid_589104 = validateParameter(valid_589104, JString, required = true,
                                 default = nil)
  if valid_589104 != nil:
    section.add "name", valid_589104
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
  var valid_589105 = query.getOrDefault("upload_protocol")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "upload_protocol", valid_589105
  var valid_589106 = query.getOrDefault("fields")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "fields", valid_589106
  var valid_589107 = query.getOrDefault("quotaUser")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "quotaUser", valid_589107
  var valid_589108 = query.getOrDefault("alt")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = newJString("json"))
  if valid_589108 != nil:
    section.add "alt", valid_589108
  var valid_589109 = query.getOrDefault("oauth_token")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "oauth_token", valid_589109
  var valid_589110 = query.getOrDefault("callback")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "callback", valid_589110
  var valid_589111 = query.getOrDefault("access_token")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "access_token", valid_589111
  var valid_589112 = query.getOrDefault("uploadType")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "uploadType", valid_589112
  var valid_589113 = query.getOrDefault("key")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "key", valid_589113
  var valid_589114 = query.getOrDefault("$.xgafv")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = newJString("1"))
  if valid_589114 != nil:
    section.add "$.xgafv", valid_589114
  var valid_589115 = query.getOrDefault("prettyPrint")
  valid_589115 = validateParameter(valid_589115, JBool, required = false,
                                 default = newJBool(true))
  if valid_589115 != nil:
    section.add "prettyPrint", valid_589115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589117: Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_589101;
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
  let valid = call_589117.validator(path, query, header, formData, body)
  let scheme = call_589117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589117.url(scheme.get, call_589117.host, call_589117.base,
                         call_589117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589117, url, valid)

proc call*(call_589118: Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_589101;
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
  var path_589119 = newJObject()
  var query_589120 = newJObject()
  var body_589121 = newJObject()
  add(query_589120, "upload_protocol", newJString(uploadProtocol))
  add(query_589120, "fields", newJString(fields))
  add(query_589120, "quotaUser", newJString(quotaUser))
  add(path_589119, "name", newJString(name))
  add(query_589120, "alt", newJString(alt))
  add(query_589120, "oauth_token", newJString(oauthToken))
  add(query_589120, "callback", newJString(callback))
  add(query_589120, "access_token", newJString(accessToken))
  add(query_589120, "uploadType", newJString(uploadType))
  add(query_589120, "key", newJString(key))
  add(query_589120, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589121 = body
  add(query_589120, "prettyPrint", newJBool(prettyPrint))
  result = call_589118.call(path_589119, query_589120, nil, nil, body_589121)

var cloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice* = Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_589101(
    name: "cloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{name}:sendCommandToDevice", validator: validate_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_589102,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_589103,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesCreate_589149 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesDevicesCreate_589151(
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesCreate_589150(
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
  var valid_589152 = path.getOrDefault("parent")
  valid_589152 = validateParameter(valid_589152, JString, required = true,
                                 default = nil)
  if valid_589152 != nil:
    section.add "parent", valid_589152
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
  var valid_589153 = query.getOrDefault("upload_protocol")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "upload_protocol", valid_589153
  var valid_589154 = query.getOrDefault("fields")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "fields", valid_589154
  var valid_589155 = query.getOrDefault("quotaUser")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "quotaUser", valid_589155
  var valid_589156 = query.getOrDefault("alt")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = newJString("json"))
  if valid_589156 != nil:
    section.add "alt", valid_589156
  var valid_589157 = query.getOrDefault("oauth_token")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "oauth_token", valid_589157
  var valid_589158 = query.getOrDefault("callback")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "callback", valid_589158
  var valid_589159 = query.getOrDefault("access_token")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "access_token", valid_589159
  var valid_589160 = query.getOrDefault("uploadType")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "uploadType", valid_589160
  var valid_589161 = query.getOrDefault("key")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "key", valid_589161
  var valid_589162 = query.getOrDefault("$.xgafv")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = newJString("1"))
  if valid_589162 != nil:
    section.add "$.xgafv", valid_589162
  var valid_589163 = query.getOrDefault("prettyPrint")
  valid_589163 = validateParameter(valid_589163, JBool, required = false,
                                 default = newJBool(true))
  if valid_589163 != nil:
    section.add "prettyPrint", valid_589163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589165: Call_CloudiotProjectsLocationsRegistriesDevicesCreate_589149;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a device in a device registry.
  ## 
  let valid = call_589165.validator(path, query, header, formData, body)
  let scheme = call_589165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589165.url(scheme.get, call_589165.host, call_589165.base,
                         call_589165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589165, url, valid)

proc call*(call_589166: Call_CloudiotProjectsLocationsRegistriesDevicesCreate_589149;
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
  var path_589167 = newJObject()
  var query_589168 = newJObject()
  var body_589169 = newJObject()
  add(query_589168, "upload_protocol", newJString(uploadProtocol))
  add(query_589168, "fields", newJString(fields))
  add(query_589168, "quotaUser", newJString(quotaUser))
  add(query_589168, "alt", newJString(alt))
  add(query_589168, "oauth_token", newJString(oauthToken))
  add(query_589168, "callback", newJString(callback))
  add(query_589168, "access_token", newJString(accessToken))
  add(query_589168, "uploadType", newJString(uploadType))
  add(path_589167, "parent", newJString(parent))
  add(query_589168, "key", newJString(key))
  add(query_589168, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589169 = body
  add(query_589168, "prettyPrint", newJBool(prettyPrint))
  result = call_589166.call(path_589167, query_589168, nil, nil, body_589169)

var cloudiotProjectsLocationsRegistriesDevicesCreate* = Call_CloudiotProjectsLocationsRegistriesDevicesCreate_589149(
    name: "cloudiotProjectsLocationsRegistriesDevicesCreate",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}/devices",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesCreate_589150,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesCreate_589151,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesList_589122 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesDevicesList_589124(protocol: Scheme;
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesList_589123(
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
  var valid_589125 = path.getOrDefault("parent")
  valid_589125 = validateParameter(valid_589125, JString, required = true,
                                 default = nil)
  if valid_589125 != nil:
    section.add "parent", valid_589125
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
  var valid_589126 = query.getOrDefault("upload_protocol")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "upload_protocol", valid_589126
  var valid_589127 = query.getOrDefault("gatewayListOptions.gatewayType")
  valid_589127 = validateParameter(valid_589127, JString, required = false, default = newJString(
      "GATEWAY_TYPE_UNSPECIFIED"))
  if valid_589127 != nil:
    section.add "gatewayListOptions.gatewayType", valid_589127
  var valid_589128 = query.getOrDefault("fields")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "fields", valid_589128
  var valid_589129 = query.getOrDefault("pageToken")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "pageToken", valid_589129
  var valid_589130 = query.getOrDefault("quotaUser")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "quotaUser", valid_589130
  var valid_589131 = query.getOrDefault("alt")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = newJString("json"))
  if valid_589131 != nil:
    section.add "alt", valid_589131
  var valid_589132 = query.getOrDefault("gatewayListOptions.associationsDeviceId")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "gatewayListOptions.associationsDeviceId", valid_589132
  var valid_589133 = query.getOrDefault("oauth_token")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "oauth_token", valid_589133
  var valid_589134 = query.getOrDefault("callback")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "callback", valid_589134
  var valid_589135 = query.getOrDefault("access_token")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "access_token", valid_589135
  var valid_589136 = query.getOrDefault("uploadType")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "uploadType", valid_589136
  var valid_589137 = query.getOrDefault("gatewayListOptions.associationsGatewayId")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "gatewayListOptions.associationsGatewayId", valid_589137
  var valid_589138 = query.getOrDefault("deviceIds")
  valid_589138 = validateParameter(valid_589138, JArray, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "deviceIds", valid_589138
  var valid_589139 = query.getOrDefault("key")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "key", valid_589139
  var valid_589140 = query.getOrDefault("fieldMask")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "fieldMask", valid_589140
  var valid_589141 = query.getOrDefault("$.xgafv")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = newJString("1"))
  if valid_589141 != nil:
    section.add "$.xgafv", valid_589141
  var valid_589142 = query.getOrDefault("pageSize")
  valid_589142 = validateParameter(valid_589142, JInt, required = false, default = nil)
  if valid_589142 != nil:
    section.add "pageSize", valid_589142
  var valid_589143 = query.getOrDefault("deviceNumIds")
  valid_589143 = validateParameter(valid_589143, JArray, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "deviceNumIds", valid_589143
  var valid_589144 = query.getOrDefault("prettyPrint")
  valid_589144 = validateParameter(valid_589144, JBool, required = false,
                                 default = newJBool(true))
  if valid_589144 != nil:
    section.add "prettyPrint", valid_589144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589145: Call_CloudiotProjectsLocationsRegistriesDevicesList_589122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List devices in a device registry.
  ## 
  let valid = call_589145.validator(path, query, header, formData, body)
  let scheme = call_589145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589145.url(scheme.get, call_589145.host, call_589145.base,
                         call_589145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589145, url, valid)

proc call*(call_589146: Call_CloudiotProjectsLocationsRegistriesDevicesList_589122;
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
  var path_589147 = newJObject()
  var query_589148 = newJObject()
  add(query_589148, "upload_protocol", newJString(uploadProtocol))
  add(query_589148, "gatewayListOptions.gatewayType",
      newJString(gatewayListOptionsGatewayType))
  add(query_589148, "fields", newJString(fields))
  add(query_589148, "pageToken", newJString(pageToken))
  add(query_589148, "quotaUser", newJString(quotaUser))
  add(query_589148, "alt", newJString(alt))
  add(query_589148, "gatewayListOptions.associationsDeviceId",
      newJString(gatewayListOptionsAssociationsDeviceId))
  add(query_589148, "oauth_token", newJString(oauthToken))
  add(query_589148, "callback", newJString(callback))
  add(query_589148, "access_token", newJString(accessToken))
  add(query_589148, "uploadType", newJString(uploadType))
  add(path_589147, "parent", newJString(parent))
  add(query_589148, "gatewayListOptions.associationsGatewayId",
      newJString(gatewayListOptionsAssociationsGatewayId))
  if deviceIds != nil:
    query_589148.add "deviceIds", deviceIds
  add(query_589148, "key", newJString(key))
  add(query_589148, "fieldMask", newJString(fieldMask))
  add(query_589148, "$.xgafv", newJString(Xgafv))
  add(query_589148, "pageSize", newJInt(pageSize))
  if deviceNumIds != nil:
    query_589148.add "deviceNumIds", deviceNumIds
  add(query_589148, "prettyPrint", newJBool(prettyPrint))
  result = call_589146.call(path_589147, query_589148, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesList* = Call_CloudiotProjectsLocationsRegistriesDevicesList_589122(
    name: "cloudiotProjectsLocationsRegistriesDevicesList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}/devices",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesList_589123,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesList_589124,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesCreate_589191 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesCreate_589193(protocol: Scheme;
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

proc validate_CloudiotProjectsLocationsRegistriesCreate_589192(path: JsonNode;
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
  var valid_589194 = path.getOrDefault("parent")
  valid_589194 = validateParameter(valid_589194, JString, required = true,
                                 default = nil)
  if valid_589194 != nil:
    section.add "parent", valid_589194
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
  var valid_589195 = query.getOrDefault("upload_protocol")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "upload_protocol", valid_589195
  var valid_589196 = query.getOrDefault("fields")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "fields", valid_589196
  var valid_589197 = query.getOrDefault("quotaUser")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "quotaUser", valid_589197
  var valid_589198 = query.getOrDefault("alt")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = newJString("json"))
  if valid_589198 != nil:
    section.add "alt", valid_589198
  var valid_589199 = query.getOrDefault("oauth_token")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "oauth_token", valid_589199
  var valid_589200 = query.getOrDefault("callback")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "callback", valid_589200
  var valid_589201 = query.getOrDefault("access_token")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "access_token", valid_589201
  var valid_589202 = query.getOrDefault("uploadType")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "uploadType", valid_589202
  var valid_589203 = query.getOrDefault("key")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "key", valid_589203
  var valid_589204 = query.getOrDefault("$.xgafv")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = newJString("1"))
  if valid_589204 != nil:
    section.add "$.xgafv", valid_589204
  var valid_589205 = query.getOrDefault("prettyPrint")
  valid_589205 = validateParameter(valid_589205, JBool, required = false,
                                 default = newJBool(true))
  if valid_589205 != nil:
    section.add "prettyPrint", valid_589205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589207: Call_CloudiotProjectsLocationsRegistriesCreate_589191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a device registry that contains devices.
  ## 
  let valid = call_589207.validator(path, query, header, formData, body)
  let scheme = call_589207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589207.url(scheme.get, call_589207.host, call_589207.base,
                         call_589207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589207, url, valid)

proc call*(call_589208: Call_CloudiotProjectsLocationsRegistriesCreate_589191;
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
  var path_589209 = newJObject()
  var query_589210 = newJObject()
  var body_589211 = newJObject()
  add(query_589210, "upload_protocol", newJString(uploadProtocol))
  add(query_589210, "fields", newJString(fields))
  add(query_589210, "quotaUser", newJString(quotaUser))
  add(query_589210, "alt", newJString(alt))
  add(query_589210, "oauth_token", newJString(oauthToken))
  add(query_589210, "callback", newJString(callback))
  add(query_589210, "access_token", newJString(accessToken))
  add(query_589210, "uploadType", newJString(uploadType))
  add(path_589209, "parent", newJString(parent))
  add(query_589210, "key", newJString(key))
  add(query_589210, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589211 = body
  add(query_589210, "prettyPrint", newJBool(prettyPrint))
  result = call_589208.call(path_589209, query_589210, nil, nil, body_589211)

var cloudiotProjectsLocationsRegistriesCreate* = Call_CloudiotProjectsLocationsRegistriesCreate_589191(
    name: "cloudiotProjectsLocationsRegistriesCreate", meth: HttpMethod.HttpPost,
    host: "cloudiot.googleapis.com", route: "/v1/{parent}/registries",
    validator: validate_CloudiotProjectsLocationsRegistriesCreate_589192,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesCreate_589193,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesList_589170 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesList_589172(protocol: Scheme;
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

proc validate_CloudiotProjectsLocationsRegistriesList_589171(path: JsonNode;
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
  var valid_589173 = path.getOrDefault("parent")
  valid_589173 = validateParameter(valid_589173, JString, required = true,
                                 default = nil)
  if valid_589173 != nil:
    section.add "parent", valid_589173
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
  var valid_589174 = query.getOrDefault("upload_protocol")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "upload_protocol", valid_589174
  var valid_589175 = query.getOrDefault("fields")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "fields", valid_589175
  var valid_589176 = query.getOrDefault("pageToken")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "pageToken", valid_589176
  var valid_589177 = query.getOrDefault("quotaUser")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "quotaUser", valid_589177
  var valid_589178 = query.getOrDefault("alt")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = newJString("json"))
  if valid_589178 != nil:
    section.add "alt", valid_589178
  var valid_589179 = query.getOrDefault("oauth_token")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "oauth_token", valid_589179
  var valid_589180 = query.getOrDefault("callback")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "callback", valid_589180
  var valid_589181 = query.getOrDefault("access_token")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "access_token", valid_589181
  var valid_589182 = query.getOrDefault("uploadType")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "uploadType", valid_589182
  var valid_589183 = query.getOrDefault("key")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "key", valid_589183
  var valid_589184 = query.getOrDefault("$.xgafv")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = newJString("1"))
  if valid_589184 != nil:
    section.add "$.xgafv", valid_589184
  var valid_589185 = query.getOrDefault("pageSize")
  valid_589185 = validateParameter(valid_589185, JInt, required = false, default = nil)
  if valid_589185 != nil:
    section.add "pageSize", valid_589185
  var valid_589186 = query.getOrDefault("prettyPrint")
  valid_589186 = validateParameter(valid_589186, JBool, required = false,
                                 default = newJBool(true))
  if valid_589186 != nil:
    section.add "prettyPrint", valid_589186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589187: Call_CloudiotProjectsLocationsRegistriesList_589170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists device registries.
  ## 
  let valid = call_589187.validator(path, query, header, formData, body)
  let scheme = call_589187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589187.url(scheme.get, call_589187.host, call_589187.base,
                         call_589187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589187, url, valid)

proc call*(call_589188: Call_CloudiotProjectsLocationsRegistriesList_589170;
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
  var path_589189 = newJObject()
  var query_589190 = newJObject()
  add(query_589190, "upload_protocol", newJString(uploadProtocol))
  add(query_589190, "fields", newJString(fields))
  add(query_589190, "pageToken", newJString(pageToken))
  add(query_589190, "quotaUser", newJString(quotaUser))
  add(query_589190, "alt", newJString(alt))
  add(query_589190, "oauth_token", newJString(oauthToken))
  add(query_589190, "callback", newJString(callback))
  add(query_589190, "access_token", newJString(accessToken))
  add(query_589190, "uploadType", newJString(uploadType))
  add(path_589189, "parent", newJString(parent))
  add(query_589190, "key", newJString(key))
  add(query_589190, "$.xgafv", newJString(Xgafv))
  add(query_589190, "pageSize", newJInt(pageSize))
  add(query_589190, "prettyPrint", newJBool(prettyPrint))
  result = call_589188.call(path_589189, query_589190, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesList* = Call_CloudiotProjectsLocationsRegistriesList_589170(
    name: "cloudiotProjectsLocationsRegistriesList", meth: HttpMethod.HttpGet,
    host: "cloudiot.googleapis.com", route: "/v1/{parent}/registries",
    validator: validate_CloudiotProjectsLocationsRegistriesList_589171, base: "/",
    url: url_CloudiotProjectsLocationsRegistriesList_589172,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_589212 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_589214(
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

proc validate_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_589213(
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
  var valid_589215 = path.getOrDefault("parent")
  valid_589215 = validateParameter(valid_589215, JString, required = true,
                                 default = nil)
  if valid_589215 != nil:
    section.add "parent", valid_589215
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
  var valid_589216 = query.getOrDefault("upload_protocol")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "upload_protocol", valid_589216
  var valid_589217 = query.getOrDefault("fields")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "fields", valid_589217
  var valid_589218 = query.getOrDefault("quotaUser")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "quotaUser", valid_589218
  var valid_589219 = query.getOrDefault("alt")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = newJString("json"))
  if valid_589219 != nil:
    section.add "alt", valid_589219
  var valid_589220 = query.getOrDefault("oauth_token")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "oauth_token", valid_589220
  var valid_589221 = query.getOrDefault("callback")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "callback", valid_589221
  var valid_589222 = query.getOrDefault("access_token")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "access_token", valid_589222
  var valid_589223 = query.getOrDefault("uploadType")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "uploadType", valid_589223
  var valid_589224 = query.getOrDefault("key")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "key", valid_589224
  var valid_589225 = query.getOrDefault("$.xgafv")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = newJString("1"))
  if valid_589225 != nil:
    section.add "$.xgafv", valid_589225
  var valid_589226 = query.getOrDefault("prettyPrint")
  valid_589226 = validateParameter(valid_589226, JBool, required = false,
                                 default = newJBool(true))
  if valid_589226 != nil:
    section.add "prettyPrint", valid_589226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589228: Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_589212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associates the device with the gateway.
  ## 
  let valid = call_589228.validator(path, query, header, formData, body)
  let scheme = call_589228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589228.url(scheme.get, call_589228.host, call_589228.base,
                         call_589228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589228, url, valid)

proc call*(call_589229: Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_589212;
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
  var path_589230 = newJObject()
  var query_589231 = newJObject()
  var body_589232 = newJObject()
  add(query_589231, "upload_protocol", newJString(uploadProtocol))
  add(query_589231, "fields", newJString(fields))
  add(query_589231, "quotaUser", newJString(quotaUser))
  add(query_589231, "alt", newJString(alt))
  add(query_589231, "oauth_token", newJString(oauthToken))
  add(query_589231, "callback", newJString(callback))
  add(query_589231, "access_token", newJString(accessToken))
  add(query_589231, "uploadType", newJString(uploadType))
  add(path_589230, "parent", newJString(parent))
  add(query_589231, "key", newJString(key))
  add(query_589231, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589232 = body
  add(query_589231, "prettyPrint", newJBool(prettyPrint))
  result = call_589229.call(path_589230, query_589231, nil, nil, body_589232)

var cloudiotProjectsLocationsRegistriesBindDeviceToGateway* = Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_589212(
    name: "cloudiotProjectsLocationsRegistriesBindDeviceToGateway",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}:bindDeviceToGateway",
    validator: validate_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_589213,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_589214,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_589233 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_589235(
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

proc validate_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_589234(
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
  var valid_589236 = path.getOrDefault("parent")
  valid_589236 = validateParameter(valid_589236, JString, required = true,
                                 default = nil)
  if valid_589236 != nil:
    section.add "parent", valid_589236
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
  var valid_589237 = query.getOrDefault("upload_protocol")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "upload_protocol", valid_589237
  var valid_589238 = query.getOrDefault("fields")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "fields", valid_589238
  var valid_589239 = query.getOrDefault("quotaUser")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "quotaUser", valid_589239
  var valid_589240 = query.getOrDefault("alt")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = newJString("json"))
  if valid_589240 != nil:
    section.add "alt", valid_589240
  var valid_589241 = query.getOrDefault("oauth_token")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "oauth_token", valid_589241
  var valid_589242 = query.getOrDefault("callback")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "callback", valid_589242
  var valid_589243 = query.getOrDefault("access_token")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "access_token", valid_589243
  var valid_589244 = query.getOrDefault("uploadType")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "uploadType", valid_589244
  var valid_589245 = query.getOrDefault("key")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "key", valid_589245
  var valid_589246 = query.getOrDefault("$.xgafv")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = newJString("1"))
  if valid_589246 != nil:
    section.add "$.xgafv", valid_589246
  var valid_589247 = query.getOrDefault("prettyPrint")
  valid_589247 = validateParameter(valid_589247, JBool, required = false,
                                 default = newJBool(true))
  if valid_589247 != nil:
    section.add "prettyPrint", valid_589247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589249: Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_589233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the association between the device and the gateway.
  ## 
  let valid = call_589249.validator(path, query, header, formData, body)
  let scheme = call_589249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589249.url(scheme.get, call_589249.host, call_589249.base,
                         call_589249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589249, url, valid)

proc call*(call_589250: Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_589233;
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
  var path_589251 = newJObject()
  var query_589252 = newJObject()
  var body_589253 = newJObject()
  add(query_589252, "upload_protocol", newJString(uploadProtocol))
  add(query_589252, "fields", newJString(fields))
  add(query_589252, "quotaUser", newJString(quotaUser))
  add(query_589252, "alt", newJString(alt))
  add(query_589252, "oauth_token", newJString(oauthToken))
  add(query_589252, "callback", newJString(callback))
  add(query_589252, "access_token", newJString(accessToken))
  add(query_589252, "uploadType", newJString(uploadType))
  add(path_589251, "parent", newJString(parent))
  add(query_589252, "key", newJString(key))
  add(query_589252, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589253 = body
  add(query_589252, "prettyPrint", newJBool(prettyPrint))
  result = call_589250.call(path_589251, query_589252, nil, nil, body_589253)

var cloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway* = Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_589233(
    name: "cloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}:unbindDeviceFromGateway", validator: validate_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_589234,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_589235,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_589254 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_589256(
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

proc validate_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_589255(
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
  var valid_589257 = path.getOrDefault("resource")
  valid_589257 = validateParameter(valid_589257, JString, required = true,
                                 default = nil)
  if valid_589257 != nil:
    section.add "resource", valid_589257
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
  var valid_589258 = query.getOrDefault("upload_protocol")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "upload_protocol", valid_589258
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
  var valid_589263 = query.getOrDefault("callback")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "callback", valid_589263
  var valid_589264 = query.getOrDefault("access_token")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "access_token", valid_589264
  var valid_589265 = query.getOrDefault("uploadType")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "uploadType", valid_589265
  var valid_589266 = query.getOrDefault("key")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "key", valid_589266
  var valid_589267 = query.getOrDefault("$.xgafv")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = newJString("1"))
  if valid_589267 != nil:
    section.add "$.xgafv", valid_589267
  var valid_589268 = query.getOrDefault("prettyPrint")
  valid_589268 = validateParameter(valid_589268, JBool, required = false,
                                 default = newJBool(true))
  if valid_589268 != nil:
    section.add "prettyPrint", valid_589268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589270: Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_589254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_589270.validator(path, query, header, formData, body)
  let scheme = call_589270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589270.url(scheme.get, call_589270.host, call_589270.base,
                         call_589270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589270, url, valid)

proc call*(call_589271: Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_589254;
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
  var path_589272 = newJObject()
  var query_589273 = newJObject()
  var body_589274 = newJObject()
  add(query_589273, "upload_protocol", newJString(uploadProtocol))
  add(query_589273, "fields", newJString(fields))
  add(query_589273, "quotaUser", newJString(quotaUser))
  add(query_589273, "alt", newJString(alt))
  add(query_589273, "oauth_token", newJString(oauthToken))
  add(query_589273, "callback", newJString(callback))
  add(query_589273, "access_token", newJString(accessToken))
  add(query_589273, "uploadType", newJString(uploadType))
  add(query_589273, "key", newJString(key))
  add(query_589273, "$.xgafv", newJString(Xgafv))
  add(path_589272, "resource", newJString(resource))
  if body != nil:
    body_589274 = body
  add(query_589273, "prettyPrint", newJBool(prettyPrint))
  result = call_589271.call(path_589272, query_589273, nil, nil, body_589274)

var cloudiotProjectsLocationsRegistriesGroupsGetIamPolicy* = Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_589254(
    name: "cloudiotProjectsLocationsRegistriesGroupsGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_589255,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_589256,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_589275 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_589277(
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

proc validate_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_589276(
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
  var valid_589278 = path.getOrDefault("resource")
  valid_589278 = validateParameter(valid_589278, JString, required = true,
                                 default = nil)
  if valid_589278 != nil:
    section.add "resource", valid_589278
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
  var valid_589279 = query.getOrDefault("upload_protocol")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "upload_protocol", valid_589279
  var valid_589280 = query.getOrDefault("fields")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "fields", valid_589280
  var valid_589281 = query.getOrDefault("quotaUser")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "quotaUser", valid_589281
  var valid_589282 = query.getOrDefault("alt")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = newJString("json"))
  if valid_589282 != nil:
    section.add "alt", valid_589282
  var valid_589283 = query.getOrDefault("oauth_token")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "oauth_token", valid_589283
  var valid_589284 = query.getOrDefault("callback")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "callback", valid_589284
  var valid_589285 = query.getOrDefault("access_token")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "access_token", valid_589285
  var valid_589286 = query.getOrDefault("uploadType")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "uploadType", valid_589286
  var valid_589287 = query.getOrDefault("key")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "key", valid_589287
  var valid_589288 = query.getOrDefault("$.xgafv")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = newJString("1"))
  if valid_589288 != nil:
    section.add "$.xgafv", valid_589288
  var valid_589289 = query.getOrDefault("prettyPrint")
  valid_589289 = validateParameter(valid_589289, JBool, required = false,
                                 default = newJBool(true))
  if valid_589289 != nil:
    section.add "prettyPrint", valid_589289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589291: Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_589275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_589291.validator(path, query, header, formData, body)
  let scheme = call_589291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589291.url(scheme.get, call_589291.host, call_589291.base,
                         call_589291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589291, url, valid)

proc call*(call_589292: Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_589275;
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
  var path_589293 = newJObject()
  var query_589294 = newJObject()
  var body_589295 = newJObject()
  add(query_589294, "upload_protocol", newJString(uploadProtocol))
  add(query_589294, "fields", newJString(fields))
  add(query_589294, "quotaUser", newJString(quotaUser))
  add(query_589294, "alt", newJString(alt))
  add(query_589294, "oauth_token", newJString(oauthToken))
  add(query_589294, "callback", newJString(callback))
  add(query_589294, "access_token", newJString(accessToken))
  add(query_589294, "uploadType", newJString(uploadType))
  add(query_589294, "key", newJString(key))
  add(query_589294, "$.xgafv", newJString(Xgafv))
  add(path_589293, "resource", newJString(resource))
  if body != nil:
    body_589295 = body
  add(query_589294, "prettyPrint", newJBool(prettyPrint))
  result = call_589292.call(path_589293, query_589294, nil, nil, body_589295)

var cloudiotProjectsLocationsRegistriesGroupsSetIamPolicy* = Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_589275(
    name: "cloudiotProjectsLocationsRegistriesGroupsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_589276,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_589277,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_589296 = ref object of OpenApiRestCall_588441
proc url_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_589298(
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

proc validate_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_589297(
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
  var valid_589299 = path.getOrDefault("resource")
  valid_589299 = validateParameter(valid_589299, JString, required = true,
                                 default = nil)
  if valid_589299 != nil:
    section.add "resource", valid_589299
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
  var valid_589300 = query.getOrDefault("upload_protocol")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "upload_protocol", valid_589300
  var valid_589301 = query.getOrDefault("fields")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "fields", valid_589301
  var valid_589302 = query.getOrDefault("quotaUser")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "quotaUser", valid_589302
  var valid_589303 = query.getOrDefault("alt")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = newJString("json"))
  if valid_589303 != nil:
    section.add "alt", valid_589303
  var valid_589304 = query.getOrDefault("oauth_token")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "oauth_token", valid_589304
  var valid_589305 = query.getOrDefault("callback")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "callback", valid_589305
  var valid_589306 = query.getOrDefault("access_token")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "access_token", valid_589306
  var valid_589307 = query.getOrDefault("uploadType")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "uploadType", valid_589307
  var valid_589308 = query.getOrDefault("key")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "key", valid_589308
  var valid_589309 = query.getOrDefault("$.xgafv")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = newJString("1"))
  if valid_589309 != nil:
    section.add "$.xgafv", valid_589309
  var valid_589310 = query.getOrDefault("prettyPrint")
  valid_589310 = validateParameter(valid_589310, JBool, required = false,
                                 default = newJBool(true))
  if valid_589310 != nil:
    section.add "prettyPrint", valid_589310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589312: Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_589296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  let valid = call_589312.validator(path, query, header, formData, body)
  let scheme = call_589312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589312.url(scheme.get, call_589312.host, call_589312.base,
                         call_589312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589312, url, valid)

proc call*(call_589313: Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_589296;
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
  var path_589314 = newJObject()
  var query_589315 = newJObject()
  var body_589316 = newJObject()
  add(query_589315, "upload_protocol", newJString(uploadProtocol))
  add(query_589315, "fields", newJString(fields))
  add(query_589315, "quotaUser", newJString(quotaUser))
  add(query_589315, "alt", newJString(alt))
  add(query_589315, "oauth_token", newJString(oauthToken))
  add(query_589315, "callback", newJString(callback))
  add(query_589315, "access_token", newJString(accessToken))
  add(query_589315, "uploadType", newJString(uploadType))
  add(query_589315, "key", newJString(key))
  add(query_589315, "$.xgafv", newJString(Xgafv))
  add(path_589314, "resource", newJString(resource))
  if body != nil:
    body_589316 = body
  add(query_589315, "prettyPrint", newJBool(prettyPrint))
  result = call_589313.call(path_589314, query_589315, nil, nil, body_589316)

var cloudiotProjectsLocationsRegistriesGroupsTestIamPermissions* = Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_589296(
    name: "cloudiotProjectsLocationsRegistriesGroupsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{resource}:testIamPermissions", validator: validate_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_589297,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_589298,
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
