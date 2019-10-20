
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
  gcpServiceName = "cloudiot"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudiotProjectsLocationsRegistriesDevicesGet_578610 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesDevicesGet_578612(protocol: Scheme;
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesGet_578611(
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
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   fieldMask: JString
  ##            : The fields of the `Device` resource to be returned in the response. If the
  ## field mask is unset or empty, all fields are returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("uploadType")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "uploadType", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("fieldMask")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "fieldMask", valid_578759
  var valid_578760 = query.getOrDefault("callback")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "callback", valid_578760
  var valid_578761 = query.getOrDefault("fields")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "fields", valid_578761
  var valid_578762 = query.getOrDefault("access_token")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "access_token", valid_578762
  var valid_578763 = query.getOrDefault("upload_protocol")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "upload_protocol", valid_578763
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578786: Call_CloudiotProjectsLocationsRegistriesDevicesGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets details about a device.
  ## 
  let valid = call_578786.validator(path, query, header, formData, body)
  let scheme = call_578786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578786.url(scheme.get, call_578786.host, call_578786.base,
                         call_578786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578786, url, valid)

proc call*(call_578857: Call_CloudiotProjectsLocationsRegistriesDevicesGet_578610;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; fieldMask: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesGet
  ## Gets details about a device.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the device. For example,
  ## `projects/p0/locations/us-central1/registries/registry0/devices/device0` or
  ## `projects/p0/locations/us-central1/registries/registry0/devices/{num_id}`.
  ##   fieldMask: string
  ##            : The fields of the `Device` resource to be returned in the response. If the
  ## field mask is unset or empty, all fields are returned.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578858 = newJObject()
  var query_578860 = newJObject()
  add(query_578860, "key", newJString(key))
  add(query_578860, "prettyPrint", newJBool(prettyPrint))
  add(query_578860, "oauth_token", newJString(oauthToken))
  add(query_578860, "$.xgafv", newJString(Xgafv))
  add(query_578860, "alt", newJString(alt))
  add(query_578860, "uploadType", newJString(uploadType))
  add(query_578860, "quotaUser", newJString(quotaUser))
  add(path_578858, "name", newJString(name))
  add(query_578860, "fieldMask", newJString(fieldMask))
  add(query_578860, "callback", newJString(callback))
  add(query_578860, "fields", newJString(fields))
  add(query_578860, "access_token", newJString(accessToken))
  add(query_578860, "upload_protocol", newJString(uploadProtocol))
  result = call_578857.call(path_578858, query_578860, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesGet* = Call_CloudiotProjectsLocationsRegistriesDevicesGet_578610(
    name: "cloudiotProjectsLocationsRegistriesDevicesGet",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesGet_578611,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesGet_578612,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesPatch_578918 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesDevicesPatch_578920(protocol: Scheme;
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesPatch_578919(
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
  var valid_578921 = path.getOrDefault("name")
  valid_578921 = validateParameter(valid_578921, JString, required = true,
                                 default = nil)
  if valid_578921 != nil:
    section.add "name", valid_578921
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Only updates the `device` fields indicated by this mask.
  ## The field mask must not be empty, and it must not contain fields that
  ## are immutable or only set by the server.
  ## Mutable top-level fields: `credentials`, `blocked`, and `metadata`
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578922 = query.getOrDefault("key")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "key", valid_578922
  var valid_578923 = query.getOrDefault("prettyPrint")
  valid_578923 = validateParameter(valid_578923, JBool, required = false,
                                 default = newJBool(true))
  if valid_578923 != nil:
    section.add "prettyPrint", valid_578923
  var valid_578924 = query.getOrDefault("oauth_token")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "oauth_token", valid_578924
  var valid_578925 = query.getOrDefault("$.xgafv")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = newJString("1"))
  if valid_578925 != nil:
    section.add "$.xgafv", valid_578925
  var valid_578926 = query.getOrDefault("alt")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("json"))
  if valid_578926 != nil:
    section.add "alt", valid_578926
  var valid_578927 = query.getOrDefault("uploadType")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "uploadType", valid_578927
  var valid_578928 = query.getOrDefault("quotaUser")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "quotaUser", valid_578928
  var valid_578929 = query.getOrDefault("updateMask")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "updateMask", valid_578929
  var valid_578930 = query.getOrDefault("callback")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "callback", valid_578930
  var valid_578931 = query.getOrDefault("fields")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "fields", valid_578931
  var valid_578932 = query.getOrDefault("access_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "access_token", valid_578932
  var valid_578933 = query.getOrDefault("upload_protocol")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "upload_protocol", valid_578933
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578935: Call_CloudiotProjectsLocationsRegistriesDevicesPatch_578918;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a device.
  ## 
  let valid = call_578935.validator(path, query, header, formData, body)
  let scheme = call_578935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578935.url(scheme.get, call_578935.host, call_578935.base,
                         call_578935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578935, url, valid)

proc call*(call_578936: Call_CloudiotProjectsLocationsRegistriesDevicesPatch_578918;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesPatch
  ## Updates a device.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource path name. For example,
  ## `projects/p1/locations/us-central1/registries/registry0/devices/dev0` or
  ## `projects/p1/locations/us-central1/registries/registry0/devices/{num_id}`.
  ## When `name` is populated as a response from the service, it always ends
  ## in the device numeric ID.
  ##   updateMask: string
  ##             : Only updates the `device` fields indicated by this mask.
  ## The field mask must not be empty, and it must not contain fields that
  ## are immutable or only set by the server.
  ## Mutable top-level fields: `credentials`, `blocked`, and `metadata`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578937 = newJObject()
  var query_578938 = newJObject()
  var body_578939 = newJObject()
  add(query_578938, "key", newJString(key))
  add(query_578938, "prettyPrint", newJBool(prettyPrint))
  add(query_578938, "oauth_token", newJString(oauthToken))
  add(query_578938, "$.xgafv", newJString(Xgafv))
  add(query_578938, "alt", newJString(alt))
  add(query_578938, "uploadType", newJString(uploadType))
  add(query_578938, "quotaUser", newJString(quotaUser))
  add(path_578937, "name", newJString(name))
  add(query_578938, "updateMask", newJString(updateMask))
  if body != nil:
    body_578939 = body
  add(query_578938, "callback", newJString(callback))
  add(query_578938, "fields", newJString(fields))
  add(query_578938, "access_token", newJString(accessToken))
  add(query_578938, "upload_protocol", newJString(uploadProtocol))
  result = call_578936.call(path_578937, query_578938, nil, nil, body_578939)

var cloudiotProjectsLocationsRegistriesDevicesPatch* = Call_CloudiotProjectsLocationsRegistriesDevicesPatch_578918(
    name: "cloudiotProjectsLocationsRegistriesDevicesPatch",
    meth: HttpMethod.HttpPatch, host: "cloudiot.googleapis.com",
    route: "/v1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesPatch_578919,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesPatch_578920,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesDelete_578899 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesDevicesDelete_578901(
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesDelete_578900(
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
  var valid_578902 = path.getOrDefault("name")
  valid_578902 = validateParameter(valid_578902, JString, required = true,
                                 default = nil)
  if valid_578902 != nil:
    section.add "name", valid_578902
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578903 = query.getOrDefault("key")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "key", valid_578903
  var valid_578904 = query.getOrDefault("prettyPrint")
  valid_578904 = validateParameter(valid_578904, JBool, required = false,
                                 default = newJBool(true))
  if valid_578904 != nil:
    section.add "prettyPrint", valid_578904
  var valid_578905 = query.getOrDefault("oauth_token")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "oauth_token", valid_578905
  var valid_578906 = query.getOrDefault("$.xgafv")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("1"))
  if valid_578906 != nil:
    section.add "$.xgafv", valid_578906
  var valid_578907 = query.getOrDefault("alt")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = newJString("json"))
  if valid_578907 != nil:
    section.add "alt", valid_578907
  var valid_578908 = query.getOrDefault("uploadType")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "uploadType", valid_578908
  var valid_578909 = query.getOrDefault("quotaUser")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "quotaUser", valid_578909
  var valid_578910 = query.getOrDefault("callback")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "callback", valid_578910
  var valid_578911 = query.getOrDefault("fields")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "fields", valid_578911
  var valid_578912 = query.getOrDefault("access_token")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "access_token", valid_578912
  var valid_578913 = query.getOrDefault("upload_protocol")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "upload_protocol", valid_578913
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578914: Call_CloudiotProjectsLocationsRegistriesDevicesDelete_578899;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a device.
  ## 
  let valid = call_578914.validator(path, query, header, formData, body)
  let scheme = call_578914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578914.url(scheme.get, call_578914.host, call_578914.base,
                         call_578914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578914, url, valid)

proc call*(call_578915: Call_CloudiotProjectsLocationsRegistriesDevicesDelete_578899;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesDelete
  ## Deletes a device.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the device. For example,
  ## `projects/p0/locations/us-central1/registries/registry0/devices/device0` or
  ## `projects/p0/locations/us-central1/registries/registry0/devices/{num_id}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578916 = newJObject()
  var query_578917 = newJObject()
  add(query_578917, "key", newJString(key))
  add(query_578917, "prettyPrint", newJBool(prettyPrint))
  add(query_578917, "oauth_token", newJString(oauthToken))
  add(query_578917, "$.xgafv", newJString(Xgafv))
  add(query_578917, "alt", newJString(alt))
  add(query_578917, "uploadType", newJString(uploadType))
  add(query_578917, "quotaUser", newJString(quotaUser))
  add(path_578916, "name", newJString(name))
  add(query_578917, "callback", newJString(callback))
  add(query_578917, "fields", newJString(fields))
  add(query_578917, "access_token", newJString(accessToken))
  add(query_578917, "upload_protocol", newJString(uploadProtocol))
  result = call_578915.call(path_578916, query_578917, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesDelete* = Call_CloudiotProjectsLocationsRegistriesDevicesDelete_578899(
    name: "cloudiotProjectsLocationsRegistriesDevicesDelete",
    meth: HttpMethod.HttpDelete, host: "cloudiot.googleapis.com",
    route: "/v1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesDelete_578900,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesDelete_578901,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_578940 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_578942(
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_578941(
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
  var valid_578943 = path.getOrDefault("name")
  valid_578943 = validateParameter(valid_578943, JString, required = true,
                                 default = nil)
  if valid_578943 != nil:
    section.add "name", valid_578943
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   numVersions: JInt
  ##              : The number of versions to list. Versions are listed in decreasing order of
  ## the version number. The maximum number of versions retained is 10. If this
  ## value is zero, it will return all the versions available.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578944 = query.getOrDefault("key")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "key", valid_578944
  var valid_578945 = query.getOrDefault("prettyPrint")
  valid_578945 = validateParameter(valid_578945, JBool, required = false,
                                 default = newJBool(true))
  if valid_578945 != nil:
    section.add "prettyPrint", valid_578945
  var valid_578946 = query.getOrDefault("oauth_token")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "oauth_token", valid_578946
  var valid_578947 = query.getOrDefault("$.xgafv")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = newJString("1"))
  if valid_578947 != nil:
    section.add "$.xgafv", valid_578947
  var valid_578948 = query.getOrDefault("numVersions")
  valid_578948 = validateParameter(valid_578948, JInt, required = false, default = nil)
  if valid_578948 != nil:
    section.add "numVersions", valid_578948
  var valid_578949 = query.getOrDefault("alt")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("json"))
  if valid_578949 != nil:
    section.add "alt", valid_578949
  var valid_578950 = query.getOrDefault("uploadType")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "uploadType", valid_578950
  var valid_578951 = query.getOrDefault("quotaUser")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "quotaUser", valid_578951
  var valid_578952 = query.getOrDefault("callback")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "callback", valid_578952
  var valid_578953 = query.getOrDefault("fields")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "fields", valid_578953
  var valid_578954 = query.getOrDefault("access_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "access_token", valid_578954
  var valid_578955 = query.getOrDefault("upload_protocol")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "upload_protocol", valid_578955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578956: Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_578940;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the last few versions of the device configuration in descending
  ## order (i.e.: newest first).
  ## 
  let valid = call_578956.validator(path, query, header, formData, body)
  let scheme = call_578956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578956.url(scheme.get, call_578956.host, call_578956.base,
                         call_578956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578956, url, valid)

proc call*(call_578957: Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_578940;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; numVersions: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesConfigVersionsList
  ## Lists the last few versions of the device configuration in descending
  ## order (i.e.: newest first).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   numVersions: int
  ##              : The number of versions to list. Versions are listed in decreasing order of
  ## the version number. The maximum number of versions retained is 10. If this
  ## value is zero, it will return all the versions available.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the device. For example,
  ## `projects/p0/locations/us-central1/registries/registry0/devices/device0` or
  ## `projects/p0/locations/us-central1/registries/registry0/devices/{num_id}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578958 = newJObject()
  var query_578959 = newJObject()
  add(query_578959, "key", newJString(key))
  add(query_578959, "prettyPrint", newJBool(prettyPrint))
  add(query_578959, "oauth_token", newJString(oauthToken))
  add(query_578959, "$.xgafv", newJString(Xgafv))
  add(query_578959, "numVersions", newJInt(numVersions))
  add(query_578959, "alt", newJString(alt))
  add(query_578959, "uploadType", newJString(uploadType))
  add(query_578959, "quotaUser", newJString(quotaUser))
  add(path_578958, "name", newJString(name))
  add(query_578959, "callback", newJString(callback))
  add(query_578959, "fields", newJString(fields))
  add(query_578959, "access_token", newJString(accessToken))
  add(query_578959, "upload_protocol", newJString(uploadProtocol))
  result = call_578957.call(path_578958, query_578959, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesConfigVersionsList* = Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_578940(
    name: "cloudiotProjectsLocationsRegistriesDevicesConfigVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1/{name}/configVersions", validator: validate_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_578941,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_578942,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_578960 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesDevicesStatesList_578962(
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesStatesList_578961(
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
  var valid_578963 = path.getOrDefault("name")
  valid_578963 = validateParameter(valid_578963, JString, required = true,
                                 default = nil)
  if valid_578963 != nil:
    section.add "name", valid_578963
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   numStates: JInt
  ##            : The number of states to list. States are listed in descending order of
  ## update time. The maximum number of states retained is 10. If this
  ## value is zero, it will return all the states available.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
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
  var valid_578967 = query.getOrDefault("$.xgafv")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = newJString("1"))
  if valid_578967 != nil:
    section.add "$.xgafv", valid_578967
  var valid_578968 = query.getOrDefault("numStates")
  valid_578968 = validateParameter(valid_578968, JInt, required = false, default = nil)
  if valid_578968 != nil:
    section.add "numStates", valid_578968
  var valid_578969 = query.getOrDefault("alt")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = newJString("json"))
  if valid_578969 != nil:
    section.add "alt", valid_578969
  var valid_578970 = query.getOrDefault("uploadType")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "uploadType", valid_578970
  var valid_578971 = query.getOrDefault("quotaUser")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "quotaUser", valid_578971
  var valid_578972 = query.getOrDefault("callback")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "callback", valid_578972
  var valid_578973 = query.getOrDefault("fields")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "fields", valid_578973
  var valid_578974 = query.getOrDefault("access_token")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "access_token", valid_578974
  var valid_578975 = query.getOrDefault("upload_protocol")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "upload_protocol", valid_578975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578976: Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_578960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the last few versions of the device state in descending order (i.e.:
  ## newest first).
  ## 
  let valid = call_578976.validator(path, query, header, formData, body)
  let scheme = call_578976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578976.url(scheme.get, call_578976.host, call_578976.base,
                         call_578976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578976, url, valid)

proc call*(call_578977: Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_578960;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; numStates: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesStatesList
  ## Lists the last few versions of the device state in descending order (i.e.:
  ## newest first).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   numStates: int
  ##            : The number of states to list. States are listed in descending order of
  ## update time. The maximum number of states retained is 10. If this
  ## value is zero, it will return all the states available.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the device. For example,
  ## `projects/p0/locations/us-central1/registries/registry0/devices/device0` or
  ## `projects/p0/locations/us-central1/registries/registry0/devices/{num_id}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578978 = newJObject()
  var query_578979 = newJObject()
  add(query_578979, "key", newJString(key))
  add(query_578979, "prettyPrint", newJBool(prettyPrint))
  add(query_578979, "oauth_token", newJString(oauthToken))
  add(query_578979, "$.xgafv", newJString(Xgafv))
  add(query_578979, "numStates", newJInt(numStates))
  add(query_578979, "alt", newJString(alt))
  add(query_578979, "uploadType", newJString(uploadType))
  add(query_578979, "quotaUser", newJString(quotaUser))
  add(path_578978, "name", newJString(name))
  add(query_578979, "callback", newJString(callback))
  add(query_578979, "fields", newJString(fields))
  add(query_578979, "access_token", newJString(accessToken))
  add(query_578979, "upload_protocol", newJString(uploadProtocol))
  result = call_578977.call(path_578978, query_578979, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesStatesList* = Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_578960(
    name: "cloudiotProjectsLocationsRegistriesDevicesStatesList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1/{name}/states",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesStatesList_578961,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesStatesList_578962,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_578980 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_578982(
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_578981(
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
  var valid_578983 = path.getOrDefault("name")
  valid_578983 = validateParameter(valid_578983, JString, required = true,
                                 default = nil)
  if valid_578983 != nil:
    section.add "name", valid_578983
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578984 = query.getOrDefault("key")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "key", valid_578984
  var valid_578985 = query.getOrDefault("prettyPrint")
  valid_578985 = validateParameter(valid_578985, JBool, required = false,
                                 default = newJBool(true))
  if valid_578985 != nil:
    section.add "prettyPrint", valid_578985
  var valid_578986 = query.getOrDefault("oauth_token")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "oauth_token", valid_578986
  var valid_578987 = query.getOrDefault("$.xgafv")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = newJString("1"))
  if valid_578987 != nil:
    section.add "$.xgafv", valid_578987
  var valid_578988 = query.getOrDefault("alt")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("json"))
  if valid_578988 != nil:
    section.add "alt", valid_578988
  var valid_578989 = query.getOrDefault("uploadType")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "uploadType", valid_578989
  var valid_578990 = query.getOrDefault("quotaUser")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "quotaUser", valid_578990
  var valid_578991 = query.getOrDefault("callback")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "callback", valid_578991
  var valid_578992 = query.getOrDefault("fields")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "fields", valid_578992
  var valid_578993 = query.getOrDefault("access_token")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "access_token", valid_578993
  var valid_578994 = query.getOrDefault("upload_protocol")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "upload_protocol", valid_578994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578996: Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_578980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the configuration for the device, which is eventually sent from
  ## the Cloud IoT Core servers. Returns the modified configuration version and
  ## its metadata.
  ## 
  let valid = call_578996.validator(path, query, header, formData, body)
  let scheme = call_578996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578996.url(scheme.get, call_578996.host, call_578996.base,
                         call_578996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578996, url, valid)

proc call*(call_578997: Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_578980;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig
  ## Modifies the configuration for the device, which is eventually sent from
  ## the Cloud IoT Core servers. Returns the modified configuration version and
  ## its metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the device. For example,
  ## `projects/p0/locations/us-central1/registries/registry0/devices/device0` or
  ## `projects/p0/locations/us-central1/registries/registry0/devices/{num_id}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578998 = newJObject()
  var query_578999 = newJObject()
  var body_579000 = newJObject()
  add(query_578999, "key", newJString(key))
  add(query_578999, "prettyPrint", newJBool(prettyPrint))
  add(query_578999, "oauth_token", newJString(oauthToken))
  add(query_578999, "$.xgafv", newJString(Xgafv))
  add(query_578999, "alt", newJString(alt))
  add(query_578999, "uploadType", newJString(uploadType))
  add(query_578999, "quotaUser", newJString(quotaUser))
  add(path_578998, "name", newJString(name))
  if body != nil:
    body_579000 = body
  add(query_578999, "callback", newJString(callback))
  add(query_578999, "fields", newJString(fields))
  add(query_578999, "access_token", newJString(accessToken))
  add(query_578999, "upload_protocol", newJString(uploadProtocol))
  result = call_578997.call(path_578998, query_578999, nil, nil, body_579000)

var cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig* = Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_578980(name: "cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{name}:modifyCloudToDeviceConfig", validator: validate_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_578981,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_578982,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_579001 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_579003(
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_579002(
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
  var valid_579004 = path.getOrDefault("name")
  valid_579004 = validateParameter(valid_579004, JString, required = true,
                                 default = nil)
  if valid_579004 != nil:
    section.add "name", valid_579004
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579005 = query.getOrDefault("key")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "key", valid_579005
  var valid_579006 = query.getOrDefault("prettyPrint")
  valid_579006 = validateParameter(valid_579006, JBool, required = false,
                                 default = newJBool(true))
  if valid_579006 != nil:
    section.add "prettyPrint", valid_579006
  var valid_579007 = query.getOrDefault("oauth_token")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "oauth_token", valid_579007
  var valid_579008 = query.getOrDefault("$.xgafv")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = newJString("1"))
  if valid_579008 != nil:
    section.add "$.xgafv", valid_579008
  var valid_579009 = query.getOrDefault("alt")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = newJString("json"))
  if valid_579009 != nil:
    section.add "alt", valid_579009
  var valid_579010 = query.getOrDefault("uploadType")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "uploadType", valid_579010
  var valid_579011 = query.getOrDefault("quotaUser")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "quotaUser", valid_579011
  var valid_579012 = query.getOrDefault("callback")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "callback", valid_579012
  var valid_579013 = query.getOrDefault("fields")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "fields", valid_579013
  var valid_579014 = query.getOrDefault("access_token")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "access_token", valid_579014
  var valid_579015 = query.getOrDefault("upload_protocol")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "upload_protocol", valid_579015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579017: Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_579001;
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
  let valid = call_579017.validator(path, query, header, formData, body)
  let scheme = call_579017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579017.url(scheme.get, call_579017.host, call_579017.base,
                         call_579017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579017, url, valid)

proc call*(call_579018: Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_579001;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the device. For example,
  ## `projects/p0/locations/us-central1/registries/registry0/devices/device0` or
  ## `projects/p0/locations/us-central1/registries/registry0/devices/{num_id}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579019 = newJObject()
  var query_579020 = newJObject()
  var body_579021 = newJObject()
  add(query_579020, "key", newJString(key))
  add(query_579020, "prettyPrint", newJBool(prettyPrint))
  add(query_579020, "oauth_token", newJString(oauthToken))
  add(query_579020, "$.xgafv", newJString(Xgafv))
  add(query_579020, "alt", newJString(alt))
  add(query_579020, "uploadType", newJString(uploadType))
  add(query_579020, "quotaUser", newJString(quotaUser))
  add(path_579019, "name", newJString(name))
  if body != nil:
    body_579021 = body
  add(query_579020, "callback", newJString(callback))
  add(query_579020, "fields", newJString(fields))
  add(query_579020, "access_token", newJString(accessToken))
  add(query_579020, "upload_protocol", newJString(uploadProtocol))
  result = call_579018.call(path_579019, query_579020, nil, nil, body_579021)

var cloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice* = Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_579001(
    name: "cloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{name}:sendCommandToDevice", validator: validate_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_579002,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_579003,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesCreate_579049 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesDevicesCreate_579051(
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesCreate_579050(
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
  var valid_579052 = path.getOrDefault("parent")
  valid_579052 = validateParameter(valid_579052, JString, required = true,
                                 default = nil)
  if valid_579052 != nil:
    section.add "parent", valid_579052
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579053 = query.getOrDefault("key")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "key", valid_579053
  var valid_579054 = query.getOrDefault("prettyPrint")
  valid_579054 = validateParameter(valid_579054, JBool, required = false,
                                 default = newJBool(true))
  if valid_579054 != nil:
    section.add "prettyPrint", valid_579054
  var valid_579055 = query.getOrDefault("oauth_token")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "oauth_token", valid_579055
  var valid_579056 = query.getOrDefault("$.xgafv")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = newJString("1"))
  if valid_579056 != nil:
    section.add "$.xgafv", valid_579056
  var valid_579057 = query.getOrDefault("alt")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = newJString("json"))
  if valid_579057 != nil:
    section.add "alt", valid_579057
  var valid_579058 = query.getOrDefault("uploadType")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "uploadType", valid_579058
  var valid_579059 = query.getOrDefault("quotaUser")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "quotaUser", valid_579059
  var valid_579060 = query.getOrDefault("callback")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "callback", valid_579060
  var valid_579061 = query.getOrDefault("fields")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "fields", valid_579061
  var valid_579062 = query.getOrDefault("access_token")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "access_token", valid_579062
  var valid_579063 = query.getOrDefault("upload_protocol")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "upload_protocol", valid_579063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579065: Call_CloudiotProjectsLocationsRegistriesDevicesCreate_579049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a device in a device registry.
  ## 
  let valid = call_579065.validator(path, query, header, formData, body)
  let scheme = call_579065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579065.url(scheme.get, call_579065.host, call_579065.base,
                         call_579065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579065, url, valid)

proc call*(call_579066: Call_CloudiotProjectsLocationsRegistriesDevicesCreate_579049;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesCreate
  ## Creates a device in a device registry.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the device registry where this device should be created.
  ## For example,
  ## `projects/example-project/locations/us-central1/registries/my-registry`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579067 = newJObject()
  var query_579068 = newJObject()
  var body_579069 = newJObject()
  add(query_579068, "key", newJString(key))
  add(query_579068, "prettyPrint", newJBool(prettyPrint))
  add(query_579068, "oauth_token", newJString(oauthToken))
  add(query_579068, "$.xgafv", newJString(Xgafv))
  add(query_579068, "alt", newJString(alt))
  add(query_579068, "uploadType", newJString(uploadType))
  add(query_579068, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579069 = body
  add(query_579068, "callback", newJString(callback))
  add(path_579067, "parent", newJString(parent))
  add(query_579068, "fields", newJString(fields))
  add(query_579068, "access_token", newJString(accessToken))
  add(query_579068, "upload_protocol", newJString(uploadProtocol))
  result = call_579066.call(path_579067, query_579068, nil, nil, body_579069)

var cloudiotProjectsLocationsRegistriesDevicesCreate* = Call_CloudiotProjectsLocationsRegistriesDevicesCreate_579049(
    name: "cloudiotProjectsLocationsRegistriesDevicesCreate",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}/devices",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesCreate_579050,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesCreate_579051,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesList_579022 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesDevicesList_579024(protocol: Scheme;
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesList_579023(
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
  var valid_579025 = path.getOrDefault("parent")
  valid_579025 = validateParameter(valid_579025, JString, required = true,
                                 default = nil)
  if valid_579025 != nil:
    section.add "parent", valid_579025
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   deviceNumIds: JArray
  ##               : A list of device numeric IDs. If empty, this field is ignored. Maximum
  ## IDs: 10,000.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   gatewayListOptions.gatewayType: JString
  ##                                 : If `GATEWAY` is specified, only gateways are returned. If `NON_GATEWAY`
  ## is specified, only non-gateway devices are returned. If
  ## `GATEWAY_TYPE_UNSPECIFIED` is specified, all devices are returned.
  ##   pageSize: JInt
  ##           : The maximum number of devices to return in the response. If this value
  ## is zero, the service will select a default size. A call may return fewer
  ## objects than requested. A non-empty `next_page_token` in the response
  ## indicates that more data is available.
  ##   deviceIds: JArray
  ##            : A list of device string IDs. For example, `['device0', 'device12']`.
  ## If empty, this field is ignored. Maximum IDs: 10,000
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   fieldMask: JString
  ##            : The fields of the `Device` resource to be returned in the response. The
  ## fields `id` and `num_id` are always returned, along with any
  ## other fields specified.
  ##   pageToken: JString
  ##            : The value returned by the last `ListDevicesResponse`; indicates
  ## that this is a continuation of a prior `ListDevices` call and
  ## the system should return the next page of data.
  ##   gatewayListOptions.associationsDeviceId: JString
  ##                                          : If set, returns only the gateways with which the specified device is
  ## associated. The device ID can be numeric (`num_id`) or the user-defined
  ## string (`id`). For example, if `456` is specified, returns only the
  ## gateways to which the device with `num_id` 456 is bound.
  ##   callback: JString
  ##           : JSONP
  ##   gatewayListOptions.associationsGatewayId: JString
  ##                                           : If set, only devices associated with the specified gateway are returned.
  ## The gateway ID can be numeric (`num_id`) or the user-defined string
  ## (`id`). For example, if `123` is specified, only devices bound to the
  ## gateway with `num_id` 123 are returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579026 = query.getOrDefault("key")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "key", valid_579026
  var valid_579027 = query.getOrDefault("prettyPrint")
  valid_579027 = validateParameter(valid_579027, JBool, required = false,
                                 default = newJBool(true))
  if valid_579027 != nil:
    section.add "prettyPrint", valid_579027
  var valid_579028 = query.getOrDefault("oauth_token")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "oauth_token", valid_579028
  var valid_579029 = query.getOrDefault("deviceNumIds")
  valid_579029 = validateParameter(valid_579029, JArray, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "deviceNumIds", valid_579029
  var valid_579030 = query.getOrDefault("$.xgafv")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = newJString("1"))
  if valid_579030 != nil:
    section.add "$.xgafv", valid_579030
  var valid_579031 = query.getOrDefault("gatewayListOptions.gatewayType")
  valid_579031 = validateParameter(valid_579031, JString, required = false, default = newJString(
      "GATEWAY_TYPE_UNSPECIFIED"))
  if valid_579031 != nil:
    section.add "gatewayListOptions.gatewayType", valid_579031
  var valid_579032 = query.getOrDefault("pageSize")
  valid_579032 = validateParameter(valid_579032, JInt, required = false, default = nil)
  if valid_579032 != nil:
    section.add "pageSize", valid_579032
  var valid_579033 = query.getOrDefault("deviceIds")
  valid_579033 = validateParameter(valid_579033, JArray, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "deviceIds", valid_579033
  var valid_579034 = query.getOrDefault("alt")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = newJString("json"))
  if valid_579034 != nil:
    section.add "alt", valid_579034
  var valid_579035 = query.getOrDefault("uploadType")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "uploadType", valid_579035
  var valid_579036 = query.getOrDefault("quotaUser")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "quotaUser", valid_579036
  var valid_579037 = query.getOrDefault("fieldMask")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "fieldMask", valid_579037
  var valid_579038 = query.getOrDefault("pageToken")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "pageToken", valid_579038
  var valid_579039 = query.getOrDefault("gatewayListOptions.associationsDeviceId")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "gatewayListOptions.associationsDeviceId", valid_579039
  var valid_579040 = query.getOrDefault("callback")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "callback", valid_579040
  var valid_579041 = query.getOrDefault("gatewayListOptions.associationsGatewayId")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "gatewayListOptions.associationsGatewayId", valid_579041
  var valid_579042 = query.getOrDefault("fields")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "fields", valid_579042
  var valid_579043 = query.getOrDefault("access_token")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "access_token", valid_579043
  var valid_579044 = query.getOrDefault("upload_protocol")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "upload_protocol", valid_579044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579045: Call_CloudiotProjectsLocationsRegistriesDevicesList_579022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List devices in a device registry.
  ## 
  let valid = call_579045.validator(path, query, header, formData, body)
  let scheme = call_579045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579045.url(scheme.get, call_579045.host, call_579045.base,
                         call_579045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579045, url, valid)

proc call*(call_579046: Call_CloudiotProjectsLocationsRegistriesDevicesList_579022;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; deviceNumIds: JsonNode = nil; Xgafv: string = "1";
          gatewayListOptionsGatewayType: string = "GATEWAY_TYPE_UNSPECIFIED";
          pageSize: int = 0; deviceIds: JsonNode = nil; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; fieldMask: string = "";
          pageToken: string = "";
          gatewayListOptionsAssociationsDeviceId: string = "";
          callback: string = "";
          gatewayListOptionsAssociationsGatewayId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesDevicesList
  ## List devices in a device registry.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deviceNumIds: JArray
  ##               : A list of device numeric IDs. If empty, this field is ignored. Maximum
  ## IDs: 10,000.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   gatewayListOptionsGatewayType: string
  ##                                : If `GATEWAY` is specified, only gateways are returned. If `NON_GATEWAY`
  ## is specified, only non-gateway devices are returned. If
  ## `GATEWAY_TYPE_UNSPECIFIED` is specified, all devices are returned.
  ##   pageSize: int
  ##           : The maximum number of devices to return in the response. If this value
  ## is zero, the service will select a default size. A call may return fewer
  ## objects than requested. A non-empty `next_page_token` in the response
  ## indicates that more data is available.
  ##   deviceIds: JArray
  ##            : A list of device string IDs. For example, `['device0', 'device12']`.
  ## If empty, this field is ignored. Maximum IDs: 10,000
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   fieldMask: string
  ##            : The fields of the `Device` resource to be returned in the response. The
  ## fields `id` and `num_id` are always returned, along with any
  ## other fields specified.
  ##   pageToken: string
  ##            : The value returned by the last `ListDevicesResponse`; indicates
  ## that this is a continuation of a prior `ListDevices` call and
  ## the system should return the next page of data.
  ##   gatewayListOptionsAssociationsDeviceId: string
  ##                                         : If set, returns only the gateways with which the specified device is
  ## associated. The device ID can be numeric (`num_id`) or the user-defined
  ## string (`id`). For example, if `456` is specified, returns only the
  ## gateways to which the device with `num_id` 456 is bound.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The device registry path. Required. For example,
  ## `projects/my-project/locations/us-central1/registries/my-registry`.
  ##   gatewayListOptionsAssociationsGatewayId: string
  ##                                          : If set, only devices associated with the specified gateway are returned.
  ## The gateway ID can be numeric (`num_id`) or the user-defined string
  ## (`id`). For example, if `123` is specified, only devices bound to the
  ## gateway with `num_id` 123 are returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579047 = newJObject()
  var query_579048 = newJObject()
  add(query_579048, "key", newJString(key))
  add(query_579048, "prettyPrint", newJBool(prettyPrint))
  add(query_579048, "oauth_token", newJString(oauthToken))
  if deviceNumIds != nil:
    query_579048.add "deviceNumIds", deviceNumIds
  add(query_579048, "$.xgafv", newJString(Xgafv))
  add(query_579048, "gatewayListOptions.gatewayType",
      newJString(gatewayListOptionsGatewayType))
  add(query_579048, "pageSize", newJInt(pageSize))
  if deviceIds != nil:
    query_579048.add "deviceIds", deviceIds
  add(query_579048, "alt", newJString(alt))
  add(query_579048, "uploadType", newJString(uploadType))
  add(query_579048, "quotaUser", newJString(quotaUser))
  add(query_579048, "fieldMask", newJString(fieldMask))
  add(query_579048, "pageToken", newJString(pageToken))
  add(query_579048, "gatewayListOptions.associationsDeviceId",
      newJString(gatewayListOptionsAssociationsDeviceId))
  add(query_579048, "callback", newJString(callback))
  add(path_579047, "parent", newJString(parent))
  add(query_579048, "gatewayListOptions.associationsGatewayId",
      newJString(gatewayListOptionsAssociationsGatewayId))
  add(query_579048, "fields", newJString(fields))
  add(query_579048, "access_token", newJString(accessToken))
  add(query_579048, "upload_protocol", newJString(uploadProtocol))
  result = call_579046.call(path_579047, query_579048, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesList* = Call_CloudiotProjectsLocationsRegistriesDevicesList_579022(
    name: "cloudiotProjectsLocationsRegistriesDevicesList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}/devices",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesList_579023,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesList_579024,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesCreate_579091 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesCreate_579093(protocol: Scheme;
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

proc validate_CloudiotProjectsLocationsRegistriesCreate_579092(path: JsonNode;
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
  var valid_579094 = path.getOrDefault("parent")
  valid_579094 = validateParameter(valid_579094, JString, required = true,
                                 default = nil)
  if valid_579094 != nil:
    section.add "parent", valid_579094
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579095 = query.getOrDefault("key")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "key", valid_579095
  var valid_579096 = query.getOrDefault("prettyPrint")
  valid_579096 = validateParameter(valid_579096, JBool, required = false,
                                 default = newJBool(true))
  if valid_579096 != nil:
    section.add "prettyPrint", valid_579096
  var valid_579097 = query.getOrDefault("oauth_token")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "oauth_token", valid_579097
  var valid_579098 = query.getOrDefault("$.xgafv")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = newJString("1"))
  if valid_579098 != nil:
    section.add "$.xgafv", valid_579098
  var valid_579099 = query.getOrDefault("alt")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = newJString("json"))
  if valid_579099 != nil:
    section.add "alt", valid_579099
  var valid_579100 = query.getOrDefault("uploadType")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "uploadType", valid_579100
  var valid_579101 = query.getOrDefault("quotaUser")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "quotaUser", valid_579101
  var valid_579102 = query.getOrDefault("callback")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "callback", valid_579102
  var valid_579103 = query.getOrDefault("fields")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "fields", valid_579103
  var valid_579104 = query.getOrDefault("access_token")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "access_token", valid_579104
  var valid_579105 = query.getOrDefault("upload_protocol")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "upload_protocol", valid_579105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579107: Call_CloudiotProjectsLocationsRegistriesCreate_579091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a device registry that contains devices.
  ## 
  let valid = call_579107.validator(path, query, header, formData, body)
  let scheme = call_579107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579107.url(scheme.get, call_579107.host, call_579107.base,
                         call_579107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579107, url, valid)

proc call*(call_579108: Call_CloudiotProjectsLocationsRegistriesCreate_579091;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesCreate
  ## Creates a device registry that contains devices.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project and cloud region where this device registry must be created.
  ## For example, `projects/example-project/locations/us-central1`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579109 = newJObject()
  var query_579110 = newJObject()
  var body_579111 = newJObject()
  add(query_579110, "key", newJString(key))
  add(query_579110, "prettyPrint", newJBool(prettyPrint))
  add(query_579110, "oauth_token", newJString(oauthToken))
  add(query_579110, "$.xgafv", newJString(Xgafv))
  add(query_579110, "alt", newJString(alt))
  add(query_579110, "uploadType", newJString(uploadType))
  add(query_579110, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579111 = body
  add(query_579110, "callback", newJString(callback))
  add(path_579109, "parent", newJString(parent))
  add(query_579110, "fields", newJString(fields))
  add(query_579110, "access_token", newJString(accessToken))
  add(query_579110, "upload_protocol", newJString(uploadProtocol))
  result = call_579108.call(path_579109, query_579110, nil, nil, body_579111)

var cloudiotProjectsLocationsRegistriesCreate* = Call_CloudiotProjectsLocationsRegistriesCreate_579091(
    name: "cloudiotProjectsLocationsRegistriesCreate", meth: HttpMethod.HttpPost,
    host: "cloudiot.googleapis.com", route: "/v1/{parent}/registries",
    validator: validate_CloudiotProjectsLocationsRegistriesCreate_579092,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesCreate_579093,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesList_579070 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesList_579072(protocol: Scheme;
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

proc validate_CloudiotProjectsLocationsRegistriesList_579071(path: JsonNode;
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
  var valid_579073 = path.getOrDefault("parent")
  valid_579073 = validateParameter(valid_579073, JString, required = true,
                                 default = nil)
  if valid_579073 != nil:
    section.add "parent", valid_579073
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of registries to return in the response. If this value
  ## is zero, the service will select a default size. A call may return fewer
  ## objects than requested. A non-empty `next_page_token` in the response
  ## indicates that more data is available.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value returned by the last `ListDeviceRegistriesResponse`; indicates
  ## that this is a continuation of a prior `ListDeviceRegistries` call and
  ## the system should return the next page of data.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579074 = query.getOrDefault("key")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "key", valid_579074
  var valid_579075 = query.getOrDefault("prettyPrint")
  valid_579075 = validateParameter(valid_579075, JBool, required = false,
                                 default = newJBool(true))
  if valid_579075 != nil:
    section.add "prettyPrint", valid_579075
  var valid_579076 = query.getOrDefault("oauth_token")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "oauth_token", valid_579076
  var valid_579077 = query.getOrDefault("$.xgafv")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = newJString("1"))
  if valid_579077 != nil:
    section.add "$.xgafv", valid_579077
  var valid_579078 = query.getOrDefault("pageSize")
  valid_579078 = validateParameter(valid_579078, JInt, required = false, default = nil)
  if valid_579078 != nil:
    section.add "pageSize", valid_579078
  var valid_579079 = query.getOrDefault("alt")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = newJString("json"))
  if valid_579079 != nil:
    section.add "alt", valid_579079
  var valid_579080 = query.getOrDefault("uploadType")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "uploadType", valid_579080
  var valid_579081 = query.getOrDefault("quotaUser")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "quotaUser", valid_579081
  var valid_579082 = query.getOrDefault("pageToken")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "pageToken", valid_579082
  var valid_579083 = query.getOrDefault("callback")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "callback", valid_579083
  var valid_579084 = query.getOrDefault("fields")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "fields", valid_579084
  var valid_579085 = query.getOrDefault("access_token")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "access_token", valid_579085
  var valid_579086 = query.getOrDefault("upload_protocol")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "upload_protocol", valid_579086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579087: Call_CloudiotProjectsLocationsRegistriesList_579070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists device registries.
  ## 
  let valid = call_579087.validator(path, query, header, formData, body)
  let scheme = call_579087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579087.url(scheme.get, call_579087.host, call_579087.base,
                         call_579087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579087, url, valid)

proc call*(call_579088: Call_CloudiotProjectsLocationsRegistriesList_579070;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesList
  ## Lists device registries.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of registries to return in the response. If this value
  ## is zero, the service will select a default size. A call may return fewer
  ## objects than requested. A non-empty `next_page_token` in the response
  ## indicates that more data is available.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The value returned by the last `ListDeviceRegistriesResponse`; indicates
  ## that this is a continuation of a prior `ListDeviceRegistries` call and
  ## the system should return the next page of data.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project and cloud region path. For example,
  ## `projects/example-project/locations/us-central1`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579089 = newJObject()
  var query_579090 = newJObject()
  add(query_579090, "key", newJString(key))
  add(query_579090, "prettyPrint", newJBool(prettyPrint))
  add(query_579090, "oauth_token", newJString(oauthToken))
  add(query_579090, "$.xgafv", newJString(Xgafv))
  add(query_579090, "pageSize", newJInt(pageSize))
  add(query_579090, "alt", newJString(alt))
  add(query_579090, "uploadType", newJString(uploadType))
  add(query_579090, "quotaUser", newJString(quotaUser))
  add(query_579090, "pageToken", newJString(pageToken))
  add(query_579090, "callback", newJString(callback))
  add(path_579089, "parent", newJString(parent))
  add(query_579090, "fields", newJString(fields))
  add(query_579090, "access_token", newJString(accessToken))
  add(query_579090, "upload_protocol", newJString(uploadProtocol))
  result = call_579088.call(path_579089, query_579090, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesList* = Call_CloudiotProjectsLocationsRegistriesList_579070(
    name: "cloudiotProjectsLocationsRegistriesList", meth: HttpMethod.HttpGet,
    host: "cloudiot.googleapis.com", route: "/v1/{parent}/registries",
    validator: validate_CloudiotProjectsLocationsRegistriesList_579071, base: "/",
    url: url_CloudiotProjectsLocationsRegistriesList_579072,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_579112 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_579114(
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

proc validate_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_579113(
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
  var valid_579115 = path.getOrDefault("parent")
  valid_579115 = validateParameter(valid_579115, JString, required = true,
                                 default = nil)
  if valid_579115 != nil:
    section.add "parent", valid_579115
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579116 = query.getOrDefault("key")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "key", valid_579116
  var valid_579117 = query.getOrDefault("prettyPrint")
  valid_579117 = validateParameter(valid_579117, JBool, required = false,
                                 default = newJBool(true))
  if valid_579117 != nil:
    section.add "prettyPrint", valid_579117
  var valid_579118 = query.getOrDefault("oauth_token")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "oauth_token", valid_579118
  var valid_579119 = query.getOrDefault("$.xgafv")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = newJString("1"))
  if valid_579119 != nil:
    section.add "$.xgafv", valid_579119
  var valid_579120 = query.getOrDefault("alt")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = newJString("json"))
  if valid_579120 != nil:
    section.add "alt", valid_579120
  var valid_579121 = query.getOrDefault("uploadType")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "uploadType", valid_579121
  var valid_579122 = query.getOrDefault("quotaUser")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "quotaUser", valid_579122
  var valid_579123 = query.getOrDefault("callback")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "callback", valid_579123
  var valid_579124 = query.getOrDefault("fields")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "fields", valid_579124
  var valid_579125 = query.getOrDefault("access_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "access_token", valid_579125
  var valid_579126 = query.getOrDefault("upload_protocol")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "upload_protocol", valid_579126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579128: Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_579112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associates the device with the gateway.
  ## 
  let valid = call_579128.validator(path, query, header, formData, body)
  let scheme = call_579128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579128.url(scheme.get, call_579128.host, call_579128.base,
                         call_579128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579128, url, valid)

proc call*(call_579129: Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_579112;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesBindDeviceToGateway
  ## Associates the device with the gateway.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the registry. For example,
  ## `projects/example-project/locations/us-central1/registries/my-registry`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579130 = newJObject()
  var query_579131 = newJObject()
  var body_579132 = newJObject()
  add(query_579131, "key", newJString(key))
  add(query_579131, "prettyPrint", newJBool(prettyPrint))
  add(query_579131, "oauth_token", newJString(oauthToken))
  add(query_579131, "$.xgafv", newJString(Xgafv))
  add(query_579131, "alt", newJString(alt))
  add(query_579131, "uploadType", newJString(uploadType))
  add(query_579131, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579132 = body
  add(query_579131, "callback", newJString(callback))
  add(path_579130, "parent", newJString(parent))
  add(query_579131, "fields", newJString(fields))
  add(query_579131, "access_token", newJString(accessToken))
  add(query_579131, "upload_protocol", newJString(uploadProtocol))
  result = call_579129.call(path_579130, query_579131, nil, nil, body_579132)

var cloudiotProjectsLocationsRegistriesBindDeviceToGateway* = Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_579112(
    name: "cloudiotProjectsLocationsRegistriesBindDeviceToGateway",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}:bindDeviceToGateway",
    validator: validate_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_579113,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_579114,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_579133 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_579135(
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

proc validate_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_579134(
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
  var valid_579136 = path.getOrDefault("parent")
  valid_579136 = validateParameter(valid_579136, JString, required = true,
                                 default = nil)
  if valid_579136 != nil:
    section.add "parent", valid_579136
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579137 = query.getOrDefault("key")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "key", valid_579137
  var valid_579138 = query.getOrDefault("prettyPrint")
  valid_579138 = validateParameter(valid_579138, JBool, required = false,
                                 default = newJBool(true))
  if valid_579138 != nil:
    section.add "prettyPrint", valid_579138
  var valid_579139 = query.getOrDefault("oauth_token")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "oauth_token", valid_579139
  var valid_579140 = query.getOrDefault("$.xgafv")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = newJString("1"))
  if valid_579140 != nil:
    section.add "$.xgafv", valid_579140
  var valid_579141 = query.getOrDefault("alt")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = newJString("json"))
  if valid_579141 != nil:
    section.add "alt", valid_579141
  var valid_579142 = query.getOrDefault("uploadType")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "uploadType", valid_579142
  var valid_579143 = query.getOrDefault("quotaUser")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "quotaUser", valid_579143
  var valid_579144 = query.getOrDefault("callback")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "callback", valid_579144
  var valid_579145 = query.getOrDefault("fields")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "fields", valid_579145
  var valid_579146 = query.getOrDefault("access_token")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "access_token", valid_579146
  var valid_579147 = query.getOrDefault("upload_protocol")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "upload_protocol", valid_579147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579149: Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_579133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the association between the device and the gateway.
  ## 
  let valid = call_579149.validator(path, query, header, formData, body)
  let scheme = call_579149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579149.url(scheme.get, call_579149.host, call_579149.base,
                         call_579149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579149, url, valid)

proc call*(call_579150: Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_579133;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway
  ## Deletes the association between the device and the gateway.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the registry. For example,
  ## `projects/example-project/locations/us-central1/registries/my-registry`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579151 = newJObject()
  var query_579152 = newJObject()
  var body_579153 = newJObject()
  add(query_579152, "key", newJString(key))
  add(query_579152, "prettyPrint", newJBool(prettyPrint))
  add(query_579152, "oauth_token", newJString(oauthToken))
  add(query_579152, "$.xgafv", newJString(Xgafv))
  add(query_579152, "alt", newJString(alt))
  add(query_579152, "uploadType", newJString(uploadType))
  add(query_579152, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579153 = body
  add(query_579152, "callback", newJString(callback))
  add(path_579151, "parent", newJString(parent))
  add(query_579152, "fields", newJString(fields))
  add(query_579152, "access_token", newJString(accessToken))
  add(query_579152, "upload_protocol", newJString(uploadProtocol))
  result = call_579150.call(path_579151, query_579152, nil, nil, body_579153)

var cloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway* = Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_579133(
    name: "cloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}:unbindDeviceFromGateway", validator: validate_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_579134,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_579135,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_579154 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_579156(
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

proc validate_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_579155(
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
  var valid_579157 = path.getOrDefault("resource")
  valid_579157 = validateParameter(valid_579157, JString, required = true,
                                 default = nil)
  if valid_579157 != nil:
    section.add "resource", valid_579157
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579158 = query.getOrDefault("key")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "key", valid_579158
  var valid_579159 = query.getOrDefault("prettyPrint")
  valid_579159 = validateParameter(valid_579159, JBool, required = false,
                                 default = newJBool(true))
  if valid_579159 != nil:
    section.add "prettyPrint", valid_579159
  var valid_579160 = query.getOrDefault("oauth_token")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "oauth_token", valid_579160
  var valid_579161 = query.getOrDefault("$.xgafv")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = newJString("1"))
  if valid_579161 != nil:
    section.add "$.xgafv", valid_579161
  var valid_579162 = query.getOrDefault("alt")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = newJString("json"))
  if valid_579162 != nil:
    section.add "alt", valid_579162
  var valid_579163 = query.getOrDefault("uploadType")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "uploadType", valid_579163
  var valid_579164 = query.getOrDefault("quotaUser")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "quotaUser", valid_579164
  var valid_579165 = query.getOrDefault("callback")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "callback", valid_579165
  var valid_579166 = query.getOrDefault("fields")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "fields", valid_579166
  var valid_579167 = query.getOrDefault("access_token")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "access_token", valid_579167
  var valid_579168 = query.getOrDefault("upload_protocol")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "upload_protocol", valid_579168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579170: Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_579154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_579170.validator(path, query, header, formData, body)
  let scheme = call_579170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579170.url(scheme.get, call_579170.host, call_579170.base,
                         call_579170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579170, url, valid)

proc call*(call_579171: Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_579154;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesGroupsGetIamPolicy
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579172 = newJObject()
  var query_579173 = newJObject()
  var body_579174 = newJObject()
  add(query_579173, "key", newJString(key))
  add(query_579173, "prettyPrint", newJBool(prettyPrint))
  add(query_579173, "oauth_token", newJString(oauthToken))
  add(query_579173, "$.xgafv", newJString(Xgafv))
  add(query_579173, "alt", newJString(alt))
  add(query_579173, "uploadType", newJString(uploadType))
  add(query_579173, "quotaUser", newJString(quotaUser))
  add(path_579172, "resource", newJString(resource))
  if body != nil:
    body_579174 = body
  add(query_579173, "callback", newJString(callback))
  add(query_579173, "fields", newJString(fields))
  add(query_579173, "access_token", newJString(accessToken))
  add(query_579173, "upload_protocol", newJString(uploadProtocol))
  result = call_579171.call(path_579172, query_579173, nil, nil, body_579174)

var cloudiotProjectsLocationsRegistriesGroupsGetIamPolicy* = Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_579154(
    name: "cloudiotProjectsLocationsRegistriesGroupsGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_579155,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_579156,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_579175 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_579177(
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

proc validate_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_579176(
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
  var valid_579178 = path.getOrDefault("resource")
  valid_579178 = validateParameter(valid_579178, JString, required = true,
                                 default = nil)
  if valid_579178 != nil:
    section.add "resource", valid_579178
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579179 = query.getOrDefault("key")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "key", valid_579179
  var valid_579180 = query.getOrDefault("prettyPrint")
  valid_579180 = validateParameter(valid_579180, JBool, required = false,
                                 default = newJBool(true))
  if valid_579180 != nil:
    section.add "prettyPrint", valid_579180
  var valid_579181 = query.getOrDefault("oauth_token")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "oauth_token", valid_579181
  var valid_579182 = query.getOrDefault("$.xgafv")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = newJString("1"))
  if valid_579182 != nil:
    section.add "$.xgafv", valid_579182
  var valid_579183 = query.getOrDefault("alt")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = newJString("json"))
  if valid_579183 != nil:
    section.add "alt", valid_579183
  var valid_579184 = query.getOrDefault("uploadType")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "uploadType", valid_579184
  var valid_579185 = query.getOrDefault("quotaUser")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "quotaUser", valid_579185
  var valid_579186 = query.getOrDefault("callback")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "callback", valid_579186
  var valid_579187 = query.getOrDefault("fields")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "fields", valid_579187
  var valid_579188 = query.getOrDefault("access_token")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "access_token", valid_579188
  var valid_579189 = query.getOrDefault("upload_protocol")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "upload_protocol", valid_579189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579191: Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_579175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_579191.validator(path, query, header, formData, body)
  let scheme = call_579191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579191.url(scheme.get, call_579191.host, call_579191.base,
                         call_579191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579191, url, valid)

proc call*(call_579192: Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_579175;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesGroupsSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579193 = newJObject()
  var query_579194 = newJObject()
  var body_579195 = newJObject()
  add(query_579194, "key", newJString(key))
  add(query_579194, "prettyPrint", newJBool(prettyPrint))
  add(query_579194, "oauth_token", newJString(oauthToken))
  add(query_579194, "$.xgafv", newJString(Xgafv))
  add(query_579194, "alt", newJString(alt))
  add(query_579194, "uploadType", newJString(uploadType))
  add(query_579194, "quotaUser", newJString(quotaUser))
  add(path_579193, "resource", newJString(resource))
  if body != nil:
    body_579195 = body
  add(query_579194, "callback", newJString(callback))
  add(query_579194, "fields", newJString(fields))
  add(query_579194, "access_token", newJString(accessToken))
  add(query_579194, "upload_protocol", newJString(uploadProtocol))
  result = call_579192.call(path_579193, query_579194, nil, nil, body_579195)

var cloudiotProjectsLocationsRegistriesGroupsSetIamPolicy* = Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_579175(
    name: "cloudiotProjectsLocationsRegistriesGroupsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_579176,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_579177,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_579196 = ref object of OpenApiRestCall_578339
proc url_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_579198(
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

proc validate_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_579197(
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
  var valid_579199 = path.getOrDefault("resource")
  valid_579199 = validateParameter(valid_579199, JString, required = true,
                                 default = nil)
  if valid_579199 != nil:
    section.add "resource", valid_579199
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579200 = query.getOrDefault("key")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "key", valid_579200
  var valid_579201 = query.getOrDefault("prettyPrint")
  valid_579201 = validateParameter(valid_579201, JBool, required = false,
                                 default = newJBool(true))
  if valid_579201 != nil:
    section.add "prettyPrint", valid_579201
  var valid_579202 = query.getOrDefault("oauth_token")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "oauth_token", valid_579202
  var valid_579203 = query.getOrDefault("$.xgafv")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = newJString("1"))
  if valid_579203 != nil:
    section.add "$.xgafv", valid_579203
  var valid_579204 = query.getOrDefault("alt")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = newJString("json"))
  if valid_579204 != nil:
    section.add "alt", valid_579204
  var valid_579205 = query.getOrDefault("uploadType")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "uploadType", valid_579205
  var valid_579206 = query.getOrDefault("quotaUser")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "quotaUser", valid_579206
  var valid_579207 = query.getOrDefault("callback")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "callback", valid_579207
  var valid_579208 = query.getOrDefault("fields")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "fields", valid_579208
  var valid_579209 = query.getOrDefault("access_token")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "access_token", valid_579209
  var valid_579210 = query.getOrDefault("upload_protocol")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "upload_protocol", valid_579210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579212: Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_579196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  let valid = call_579212.validator(path, query, header, formData, body)
  let scheme = call_579212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579212.url(scheme.get, call_579212.host, call_579212.base,
                         call_579212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579212, url, valid)

proc call*(call_579213: Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_579196;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudiotProjectsLocationsRegistriesGroupsTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579214 = newJObject()
  var query_579215 = newJObject()
  var body_579216 = newJObject()
  add(query_579215, "key", newJString(key))
  add(query_579215, "prettyPrint", newJBool(prettyPrint))
  add(query_579215, "oauth_token", newJString(oauthToken))
  add(query_579215, "$.xgafv", newJString(Xgafv))
  add(query_579215, "alt", newJString(alt))
  add(query_579215, "uploadType", newJString(uploadType))
  add(query_579215, "quotaUser", newJString(quotaUser))
  add(path_579214, "resource", newJString(resource))
  if body != nil:
    body_579216 = body
  add(query_579215, "callback", newJString(callback))
  add(query_579215, "fields", newJString(fields))
  add(query_579215, "access_token", newJString(accessToken))
  add(query_579215, "upload_protocol", newJString(uploadProtocol))
  result = call_579213.call(path_579214, query_579215, nil, nil, body_579216)

var cloudiotProjectsLocationsRegistriesGroupsTestIamPermissions* = Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_579196(
    name: "cloudiotProjectsLocationsRegistriesGroupsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{resource}:testIamPermissions", validator: validate_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_579197,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_579198,
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
