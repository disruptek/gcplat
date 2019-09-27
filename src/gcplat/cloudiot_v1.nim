
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudiotProjectsLocationsRegistriesDevicesGet_597677 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesGet_597679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesGet_597678(
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
  var valid_597805 = path.getOrDefault("name")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "name", valid_597805
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
  var valid_597806 = query.getOrDefault("upload_protocol")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "upload_protocol", valid_597806
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("quotaUser")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "quotaUser", valid_597808
  var valid_597822 = query.getOrDefault("alt")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = newJString("json"))
  if valid_597822 != nil:
    section.add "alt", valid_597822
  var valid_597823 = query.getOrDefault("oauth_token")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "oauth_token", valid_597823
  var valid_597824 = query.getOrDefault("callback")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "callback", valid_597824
  var valid_597825 = query.getOrDefault("access_token")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "access_token", valid_597825
  var valid_597826 = query.getOrDefault("uploadType")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "uploadType", valid_597826
  var valid_597827 = query.getOrDefault("key")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "key", valid_597827
  var valid_597828 = query.getOrDefault("fieldMask")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = nil)
  if valid_597828 != nil:
    section.add "fieldMask", valid_597828
  var valid_597829 = query.getOrDefault("$.xgafv")
  valid_597829 = validateParameter(valid_597829, JString, required = false,
                                 default = newJString("1"))
  if valid_597829 != nil:
    section.add "$.xgafv", valid_597829
  var valid_597830 = query.getOrDefault("prettyPrint")
  valid_597830 = validateParameter(valid_597830, JBool, required = false,
                                 default = newJBool(true))
  if valid_597830 != nil:
    section.add "prettyPrint", valid_597830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597853: Call_CloudiotProjectsLocationsRegistriesDevicesGet_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets details about a device.
  ## 
  let valid = call_597853.validator(path, query, header, formData, body)
  let scheme = call_597853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597853.url(scheme.get, call_597853.host, call_597853.base,
                         call_597853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597853, url, valid)

proc call*(call_597924: Call_CloudiotProjectsLocationsRegistriesDevicesGet_597677;
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
  var path_597925 = newJObject()
  var query_597927 = newJObject()
  add(query_597927, "upload_protocol", newJString(uploadProtocol))
  add(query_597927, "fields", newJString(fields))
  add(query_597927, "quotaUser", newJString(quotaUser))
  add(path_597925, "name", newJString(name))
  add(query_597927, "alt", newJString(alt))
  add(query_597927, "oauth_token", newJString(oauthToken))
  add(query_597927, "callback", newJString(callback))
  add(query_597927, "access_token", newJString(accessToken))
  add(query_597927, "uploadType", newJString(uploadType))
  add(query_597927, "key", newJString(key))
  add(query_597927, "fieldMask", newJString(fieldMask))
  add(query_597927, "$.xgafv", newJString(Xgafv))
  add(query_597927, "prettyPrint", newJBool(prettyPrint))
  result = call_597924.call(path_597925, query_597927, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesGet* = Call_CloudiotProjectsLocationsRegistriesDevicesGet_597677(
    name: "cloudiotProjectsLocationsRegistriesDevicesGet",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesGet_597678,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesGet_597679,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesPatch_597985 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesPatch_597987(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesPatch_597986(
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
  var valid_597988 = path.getOrDefault("name")
  valid_597988 = validateParameter(valid_597988, JString, required = true,
                                 default = nil)
  if valid_597988 != nil:
    section.add "name", valid_597988
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
  var valid_597989 = query.getOrDefault("upload_protocol")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "upload_protocol", valid_597989
  var valid_597990 = query.getOrDefault("fields")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "fields", valid_597990
  var valid_597991 = query.getOrDefault("quotaUser")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "quotaUser", valid_597991
  var valid_597992 = query.getOrDefault("alt")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = newJString("json"))
  if valid_597992 != nil:
    section.add "alt", valid_597992
  var valid_597993 = query.getOrDefault("oauth_token")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "oauth_token", valid_597993
  var valid_597994 = query.getOrDefault("callback")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "callback", valid_597994
  var valid_597995 = query.getOrDefault("access_token")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "access_token", valid_597995
  var valid_597996 = query.getOrDefault("uploadType")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "uploadType", valid_597996
  var valid_597997 = query.getOrDefault("key")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "key", valid_597997
  var valid_597998 = query.getOrDefault("$.xgafv")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = newJString("1"))
  if valid_597998 != nil:
    section.add "$.xgafv", valid_597998
  var valid_597999 = query.getOrDefault("prettyPrint")
  valid_597999 = validateParameter(valid_597999, JBool, required = false,
                                 default = newJBool(true))
  if valid_597999 != nil:
    section.add "prettyPrint", valid_597999
  var valid_598000 = query.getOrDefault("updateMask")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "updateMask", valid_598000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598002: Call_CloudiotProjectsLocationsRegistriesDevicesPatch_597985;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a device.
  ## 
  let valid = call_598002.validator(path, query, header, formData, body)
  let scheme = call_598002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598002.url(scheme.get, call_598002.host, call_598002.base,
                         call_598002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598002, url, valid)

proc call*(call_598003: Call_CloudiotProjectsLocationsRegistriesDevicesPatch_597985;
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
  var path_598004 = newJObject()
  var query_598005 = newJObject()
  var body_598006 = newJObject()
  add(query_598005, "upload_protocol", newJString(uploadProtocol))
  add(query_598005, "fields", newJString(fields))
  add(query_598005, "quotaUser", newJString(quotaUser))
  add(path_598004, "name", newJString(name))
  add(query_598005, "alt", newJString(alt))
  add(query_598005, "oauth_token", newJString(oauthToken))
  add(query_598005, "callback", newJString(callback))
  add(query_598005, "access_token", newJString(accessToken))
  add(query_598005, "uploadType", newJString(uploadType))
  add(query_598005, "key", newJString(key))
  add(query_598005, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598006 = body
  add(query_598005, "prettyPrint", newJBool(prettyPrint))
  add(query_598005, "updateMask", newJString(updateMask))
  result = call_598003.call(path_598004, query_598005, nil, nil, body_598006)

var cloudiotProjectsLocationsRegistriesDevicesPatch* = Call_CloudiotProjectsLocationsRegistriesDevicesPatch_597985(
    name: "cloudiotProjectsLocationsRegistriesDevicesPatch",
    meth: HttpMethod.HttpPatch, host: "cloudiot.googleapis.com",
    route: "/v1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesPatch_597986,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesPatch_597987,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesDelete_597966 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesDelete_597968(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesDelete_597967(
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
  var valid_597969 = path.getOrDefault("name")
  valid_597969 = validateParameter(valid_597969, JString, required = true,
                                 default = nil)
  if valid_597969 != nil:
    section.add "name", valid_597969
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
  var valid_597970 = query.getOrDefault("upload_protocol")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "upload_protocol", valid_597970
  var valid_597971 = query.getOrDefault("fields")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "fields", valid_597971
  var valid_597972 = query.getOrDefault("quotaUser")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "quotaUser", valid_597972
  var valid_597973 = query.getOrDefault("alt")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = newJString("json"))
  if valid_597973 != nil:
    section.add "alt", valid_597973
  var valid_597974 = query.getOrDefault("oauth_token")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "oauth_token", valid_597974
  var valid_597975 = query.getOrDefault("callback")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "callback", valid_597975
  var valid_597976 = query.getOrDefault("access_token")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "access_token", valid_597976
  var valid_597977 = query.getOrDefault("uploadType")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "uploadType", valid_597977
  var valid_597978 = query.getOrDefault("key")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "key", valid_597978
  var valid_597979 = query.getOrDefault("$.xgafv")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = newJString("1"))
  if valid_597979 != nil:
    section.add "$.xgafv", valid_597979
  var valid_597980 = query.getOrDefault("prettyPrint")
  valid_597980 = validateParameter(valid_597980, JBool, required = false,
                                 default = newJBool(true))
  if valid_597980 != nil:
    section.add "prettyPrint", valid_597980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597981: Call_CloudiotProjectsLocationsRegistriesDevicesDelete_597966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a device.
  ## 
  let valid = call_597981.validator(path, query, header, formData, body)
  let scheme = call_597981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597981.url(scheme.get, call_597981.host, call_597981.base,
                         call_597981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597981, url, valid)

proc call*(call_597982: Call_CloudiotProjectsLocationsRegistriesDevicesDelete_597966;
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
  var path_597983 = newJObject()
  var query_597984 = newJObject()
  add(query_597984, "upload_protocol", newJString(uploadProtocol))
  add(query_597984, "fields", newJString(fields))
  add(query_597984, "quotaUser", newJString(quotaUser))
  add(path_597983, "name", newJString(name))
  add(query_597984, "alt", newJString(alt))
  add(query_597984, "oauth_token", newJString(oauthToken))
  add(query_597984, "callback", newJString(callback))
  add(query_597984, "access_token", newJString(accessToken))
  add(query_597984, "uploadType", newJString(uploadType))
  add(query_597984, "key", newJString(key))
  add(query_597984, "$.xgafv", newJString(Xgafv))
  add(query_597984, "prettyPrint", newJBool(prettyPrint))
  result = call_597982.call(path_597983, query_597984, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesDelete* = Call_CloudiotProjectsLocationsRegistriesDevicesDelete_597966(
    name: "cloudiotProjectsLocationsRegistriesDevicesDelete",
    meth: HttpMethod.HttpDelete, host: "cloudiot.googleapis.com",
    route: "/v1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesDelete_597967,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesDelete_597968,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598007 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598009(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598008(
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
  var valid_598010 = path.getOrDefault("name")
  valid_598010 = validateParameter(valid_598010, JString, required = true,
                                 default = nil)
  if valid_598010 != nil:
    section.add "name", valid_598010
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
  var valid_598011 = query.getOrDefault("upload_protocol")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "upload_protocol", valid_598011
  var valid_598012 = query.getOrDefault("fields")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "fields", valid_598012
  var valid_598013 = query.getOrDefault("quotaUser")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "quotaUser", valid_598013
  var valid_598014 = query.getOrDefault("alt")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = newJString("json"))
  if valid_598014 != nil:
    section.add "alt", valid_598014
  var valid_598015 = query.getOrDefault("oauth_token")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "oauth_token", valid_598015
  var valid_598016 = query.getOrDefault("callback")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "callback", valid_598016
  var valid_598017 = query.getOrDefault("access_token")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "access_token", valid_598017
  var valid_598018 = query.getOrDefault("uploadType")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "uploadType", valid_598018
  var valid_598019 = query.getOrDefault("key")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "key", valid_598019
  var valid_598020 = query.getOrDefault("$.xgafv")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = newJString("1"))
  if valid_598020 != nil:
    section.add "$.xgafv", valid_598020
  var valid_598021 = query.getOrDefault("prettyPrint")
  valid_598021 = validateParameter(valid_598021, JBool, required = false,
                                 default = newJBool(true))
  if valid_598021 != nil:
    section.add "prettyPrint", valid_598021
  var valid_598022 = query.getOrDefault("numVersions")
  valid_598022 = validateParameter(valid_598022, JInt, required = false, default = nil)
  if valid_598022 != nil:
    section.add "numVersions", valid_598022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598023: Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the last few versions of the device configuration in descending
  ## order (i.e.: newest first).
  ## 
  let valid = call_598023.validator(path, query, header, formData, body)
  let scheme = call_598023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598023.url(scheme.get, call_598023.host, call_598023.base,
                         call_598023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598023, url, valid)

proc call*(call_598024: Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598007;
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
  var path_598025 = newJObject()
  var query_598026 = newJObject()
  add(query_598026, "upload_protocol", newJString(uploadProtocol))
  add(query_598026, "fields", newJString(fields))
  add(query_598026, "quotaUser", newJString(quotaUser))
  add(path_598025, "name", newJString(name))
  add(query_598026, "alt", newJString(alt))
  add(query_598026, "oauth_token", newJString(oauthToken))
  add(query_598026, "callback", newJString(callback))
  add(query_598026, "access_token", newJString(accessToken))
  add(query_598026, "uploadType", newJString(uploadType))
  add(query_598026, "key", newJString(key))
  add(query_598026, "$.xgafv", newJString(Xgafv))
  add(query_598026, "prettyPrint", newJBool(prettyPrint))
  add(query_598026, "numVersions", newJInt(numVersions))
  result = call_598024.call(path_598025, query_598026, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesConfigVersionsList* = Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598007(
    name: "cloudiotProjectsLocationsRegistriesDevicesConfigVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1/{name}/configVersions", validator: validate_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598008,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598009,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_598027 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesStatesList_598029(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesStatesList_598028(
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
  var valid_598030 = path.getOrDefault("name")
  valid_598030 = validateParameter(valid_598030, JString, required = true,
                                 default = nil)
  if valid_598030 != nil:
    section.add "name", valid_598030
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
  var valid_598031 = query.getOrDefault("upload_protocol")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "upload_protocol", valid_598031
  var valid_598032 = query.getOrDefault("fields")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "fields", valid_598032
  var valid_598033 = query.getOrDefault("quotaUser")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "quotaUser", valid_598033
  var valid_598034 = query.getOrDefault("alt")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = newJString("json"))
  if valid_598034 != nil:
    section.add "alt", valid_598034
  var valid_598035 = query.getOrDefault("oauth_token")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "oauth_token", valid_598035
  var valid_598036 = query.getOrDefault("callback")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "callback", valid_598036
  var valid_598037 = query.getOrDefault("access_token")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "access_token", valid_598037
  var valid_598038 = query.getOrDefault("uploadType")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "uploadType", valid_598038
  var valid_598039 = query.getOrDefault("key")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "key", valid_598039
  var valid_598040 = query.getOrDefault("$.xgafv")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = newJString("1"))
  if valid_598040 != nil:
    section.add "$.xgafv", valid_598040
  var valid_598041 = query.getOrDefault("numStates")
  valid_598041 = validateParameter(valid_598041, JInt, required = false, default = nil)
  if valid_598041 != nil:
    section.add "numStates", valid_598041
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

proc call*(call_598043: Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_598027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the last few versions of the device state in descending order (i.e.:
  ## newest first).
  ## 
  let valid = call_598043.validator(path, query, header, formData, body)
  let scheme = call_598043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598043.url(scheme.get, call_598043.host, call_598043.base,
                         call_598043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598043, url, valid)

proc call*(call_598044: Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_598027;
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
  var path_598045 = newJObject()
  var query_598046 = newJObject()
  add(query_598046, "upload_protocol", newJString(uploadProtocol))
  add(query_598046, "fields", newJString(fields))
  add(query_598046, "quotaUser", newJString(quotaUser))
  add(path_598045, "name", newJString(name))
  add(query_598046, "alt", newJString(alt))
  add(query_598046, "oauth_token", newJString(oauthToken))
  add(query_598046, "callback", newJString(callback))
  add(query_598046, "access_token", newJString(accessToken))
  add(query_598046, "uploadType", newJString(uploadType))
  add(query_598046, "key", newJString(key))
  add(query_598046, "$.xgafv", newJString(Xgafv))
  add(query_598046, "numStates", newJInt(numStates))
  add(query_598046, "prettyPrint", newJBool(prettyPrint))
  result = call_598044.call(path_598045, query_598046, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesStatesList* = Call_CloudiotProjectsLocationsRegistriesDevicesStatesList_598027(
    name: "cloudiotProjectsLocationsRegistriesDevicesStatesList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1/{name}/states",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesStatesList_598028,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesStatesList_598029,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598047 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598049(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598048(
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
  var valid_598050 = path.getOrDefault("name")
  valid_598050 = validateParameter(valid_598050, JString, required = true,
                                 default = nil)
  if valid_598050 != nil:
    section.add "name", valid_598050
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
  var valid_598051 = query.getOrDefault("upload_protocol")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "upload_protocol", valid_598051
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
  var valid_598056 = query.getOrDefault("callback")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "callback", valid_598056
  var valid_598057 = query.getOrDefault("access_token")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "access_token", valid_598057
  var valid_598058 = query.getOrDefault("uploadType")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "uploadType", valid_598058
  var valid_598059 = query.getOrDefault("key")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "key", valid_598059
  var valid_598060 = query.getOrDefault("$.xgafv")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = newJString("1"))
  if valid_598060 != nil:
    section.add "$.xgafv", valid_598060
  var valid_598061 = query.getOrDefault("prettyPrint")
  valid_598061 = validateParameter(valid_598061, JBool, required = false,
                                 default = newJBool(true))
  if valid_598061 != nil:
    section.add "prettyPrint", valid_598061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598063: Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the configuration for the device, which is eventually sent from
  ## the Cloud IoT Core servers. Returns the modified configuration version and
  ## its metadata.
  ## 
  let valid = call_598063.validator(path, query, header, formData, body)
  let scheme = call_598063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598063.url(scheme.get, call_598063.host, call_598063.base,
                         call_598063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598063, url, valid)

proc call*(call_598064: Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598047;
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
  var path_598065 = newJObject()
  var query_598066 = newJObject()
  var body_598067 = newJObject()
  add(query_598066, "upload_protocol", newJString(uploadProtocol))
  add(query_598066, "fields", newJString(fields))
  add(query_598066, "quotaUser", newJString(quotaUser))
  add(path_598065, "name", newJString(name))
  add(query_598066, "alt", newJString(alt))
  add(query_598066, "oauth_token", newJString(oauthToken))
  add(query_598066, "callback", newJString(callback))
  add(query_598066, "access_token", newJString(accessToken))
  add(query_598066, "uploadType", newJString(uploadType))
  add(query_598066, "key", newJString(key))
  add(query_598066, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598067 = body
  add(query_598066, "prettyPrint", newJBool(prettyPrint))
  result = call_598064.call(path_598065, query_598066, nil, nil, body_598067)

var cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig* = Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598047(name: "cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{name}:modifyCloudToDeviceConfig", validator: validate_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598048,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598049,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_598068 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_598070(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_598069(
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
  var valid_598071 = path.getOrDefault("name")
  valid_598071 = validateParameter(valid_598071, JString, required = true,
                                 default = nil)
  if valid_598071 != nil:
    section.add "name", valid_598071
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
  var valid_598072 = query.getOrDefault("upload_protocol")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "upload_protocol", valid_598072
  var valid_598073 = query.getOrDefault("fields")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "fields", valid_598073
  var valid_598074 = query.getOrDefault("quotaUser")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "quotaUser", valid_598074
  var valid_598075 = query.getOrDefault("alt")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = newJString("json"))
  if valid_598075 != nil:
    section.add "alt", valid_598075
  var valid_598076 = query.getOrDefault("oauth_token")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "oauth_token", valid_598076
  var valid_598077 = query.getOrDefault("callback")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "callback", valid_598077
  var valid_598078 = query.getOrDefault("access_token")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "access_token", valid_598078
  var valid_598079 = query.getOrDefault("uploadType")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "uploadType", valid_598079
  var valid_598080 = query.getOrDefault("key")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "key", valid_598080
  var valid_598081 = query.getOrDefault("$.xgafv")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = newJString("1"))
  if valid_598081 != nil:
    section.add "$.xgafv", valid_598081
  var valid_598082 = query.getOrDefault("prettyPrint")
  valid_598082 = validateParameter(valid_598082, JBool, required = false,
                                 default = newJBool(true))
  if valid_598082 != nil:
    section.add "prettyPrint", valid_598082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598084: Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_598068;
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
  let valid = call_598084.validator(path, query, header, formData, body)
  let scheme = call_598084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598084.url(scheme.get, call_598084.host, call_598084.base,
                         call_598084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598084, url, valid)

proc call*(call_598085: Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_598068;
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
  var path_598086 = newJObject()
  var query_598087 = newJObject()
  var body_598088 = newJObject()
  add(query_598087, "upload_protocol", newJString(uploadProtocol))
  add(query_598087, "fields", newJString(fields))
  add(query_598087, "quotaUser", newJString(quotaUser))
  add(path_598086, "name", newJString(name))
  add(query_598087, "alt", newJString(alt))
  add(query_598087, "oauth_token", newJString(oauthToken))
  add(query_598087, "callback", newJString(callback))
  add(query_598087, "access_token", newJString(accessToken))
  add(query_598087, "uploadType", newJString(uploadType))
  add(query_598087, "key", newJString(key))
  add(query_598087, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598088 = body
  add(query_598087, "prettyPrint", newJBool(prettyPrint))
  result = call_598085.call(path_598086, query_598087, nil, nil, body_598088)

var cloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice* = Call_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_598068(
    name: "cloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{name}:sendCommandToDevice", validator: validate_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_598069,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesDevicesSendCommandToDevice_598070,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesCreate_598116 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesCreate_598118(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesCreate_598117(
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
  var valid_598119 = path.getOrDefault("parent")
  valid_598119 = validateParameter(valid_598119, JString, required = true,
                                 default = nil)
  if valid_598119 != nil:
    section.add "parent", valid_598119
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
  var valid_598120 = query.getOrDefault("upload_protocol")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "upload_protocol", valid_598120
  var valid_598121 = query.getOrDefault("fields")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "fields", valid_598121
  var valid_598122 = query.getOrDefault("quotaUser")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "quotaUser", valid_598122
  var valid_598123 = query.getOrDefault("alt")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = newJString("json"))
  if valid_598123 != nil:
    section.add "alt", valid_598123
  var valid_598124 = query.getOrDefault("oauth_token")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "oauth_token", valid_598124
  var valid_598125 = query.getOrDefault("callback")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "callback", valid_598125
  var valid_598126 = query.getOrDefault("access_token")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = nil)
  if valid_598126 != nil:
    section.add "access_token", valid_598126
  var valid_598127 = query.getOrDefault("uploadType")
  valid_598127 = validateParameter(valid_598127, JString, required = false,
                                 default = nil)
  if valid_598127 != nil:
    section.add "uploadType", valid_598127
  var valid_598128 = query.getOrDefault("key")
  valid_598128 = validateParameter(valid_598128, JString, required = false,
                                 default = nil)
  if valid_598128 != nil:
    section.add "key", valid_598128
  var valid_598129 = query.getOrDefault("$.xgafv")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = newJString("1"))
  if valid_598129 != nil:
    section.add "$.xgafv", valid_598129
  var valid_598130 = query.getOrDefault("prettyPrint")
  valid_598130 = validateParameter(valid_598130, JBool, required = false,
                                 default = newJBool(true))
  if valid_598130 != nil:
    section.add "prettyPrint", valid_598130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598132: Call_CloudiotProjectsLocationsRegistriesDevicesCreate_598116;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a device in a device registry.
  ## 
  let valid = call_598132.validator(path, query, header, formData, body)
  let scheme = call_598132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598132.url(scheme.get, call_598132.host, call_598132.base,
                         call_598132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598132, url, valid)

proc call*(call_598133: Call_CloudiotProjectsLocationsRegistriesDevicesCreate_598116;
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
  var path_598134 = newJObject()
  var query_598135 = newJObject()
  var body_598136 = newJObject()
  add(query_598135, "upload_protocol", newJString(uploadProtocol))
  add(query_598135, "fields", newJString(fields))
  add(query_598135, "quotaUser", newJString(quotaUser))
  add(query_598135, "alt", newJString(alt))
  add(query_598135, "oauth_token", newJString(oauthToken))
  add(query_598135, "callback", newJString(callback))
  add(query_598135, "access_token", newJString(accessToken))
  add(query_598135, "uploadType", newJString(uploadType))
  add(path_598134, "parent", newJString(parent))
  add(query_598135, "key", newJString(key))
  add(query_598135, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598136 = body
  add(query_598135, "prettyPrint", newJBool(prettyPrint))
  result = call_598133.call(path_598134, query_598135, nil, nil, body_598136)

var cloudiotProjectsLocationsRegistriesDevicesCreate* = Call_CloudiotProjectsLocationsRegistriesDevicesCreate_598116(
    name: "cloudiotProjectsLocationsRegistriesDevicesCreate",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}/devices",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesCreate_598117,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesCreate_598118,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesList_598089 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesList_598091(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesList_598090(
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
  var valid_598092 = path.getOrDefault("parent")
  valid_598092 = validateParameter(valid_598092, JString, required = true,
                                 default = nil)
  if valid_598092 != nil:
    section.add "parent", valid_598092
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
  var valid_598093 = query.getOrDefault("upload_protocol")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "upload_protocol", valid_598093
  var valid_598094 = query.getOrDefault("gatewayListOptions.gatewayType")
  valid_598094 = validateParameter(valid_598094, JString, required = false, default = newJString(
      "GATEWAY_TYPE_UNSPECIFIED"))
  if valid_598094 != nil:
    section.add "gatewayListOptions.gatewayType", valid_598094
  var valid_598095 = query.getOrDefault("fields")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "fields", valid_598095
  var valid_598096 = query.getOrDefault("pageToken")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "pageToken", valid_598096
  var valid_598097 = query.getOrDefault("quotaUser")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "quotaUser", valid_598097
  var valid_598098 = query.getOrDefault("alt")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = newJString("json"))
  if valid_598098 != nil:
    section.add "alt", valid_598098
  var valid_598099 = query.getOrDefault("gatewayListOptions.associationsDeviceId")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "gatewayListOptions.associationsDeviceId", valid_598099
  var valid_598100 = query.getOrDefault("oauth_token")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "oauth_token", valid_598100
  var valid_598101 = query.getOrDefault("callback")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "callback", valid_598101
  var valid_598102 = query.getOrDefault("access_token")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "access_token", valid_598102
  var valid_598103 = query.getOrDefault("uploadType")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "uploadType", valid_598103
  var valid_598104 = query.getOrDefault("gatewayListOptions.associationsGatewayId")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "gatewayListOptions.associationsGatewayId", valid_598104
  var valid_598105 = query.getOrDefault("deviceIds")
  valid_598105 = validateParameter(valid_598105, JArray, required = false,
                                 default = nil)
  if valid_598105 != nil:
    section.add "deviceIds", valid_598105
  var valid_598106 = query.getOrDefault("key")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "key", valid_598106
  var valid_598107 = query.getOrDefault("fieldMask")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "fieldMask", valid_598107
  var valid_598108 = query.getOrDefault("$.xgafv")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = newJString("1"))
  if valid_598108 != nil:
    section.add "$.xgafv", valid_598108
  var valid_598109 = query.getOrDefault("pageSize")
  valid_598109 = validateParameter(valid_598109, JInt, required = false, default = nil)
  if valid_598109 != nil:
    section.add "pageSize", valid_598109
  var valid_598110 = query.getOrDefault("deviceNumIds")
  valid_598110 = validateParameter(valid_598110, JArray, required = false,
                                 default = nil)
  if valid_598110 != nil:
    section.add "deviceNumIds", valid_598110
  var valid_598111 = query.getOrDefault("prettyPrint")
  valid_598111 = validateParameter(valid_598111, JBool, required = false,
                                 default = newJBool(true))
  if valid_598111 != nil:
    section.add "prettyPrint", valid_598111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598112: Call_CloudiotProjectsLocationsRegistriesDevicesList_598089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List devices in a device registry.
  ## 
  let valid = call_598112.validator(path, query, header, formData, body)
  let scheme = call_598112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598112.url(scheme.get, call_598112.host, call_598112.base,
                         call_598112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598112, url, valid)

proc call*(call_598113: Call_CloudiotProjectsLocationsRegistriesDevicesList_598089;
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
  var path_598114 = newJObject()
  var query_598115 = newJObject()
  add(query_598115, "upload_protocol", newJString(uploadProtocol))
  add(query_598115, "gatewayListOptions.gatewayType",
      newJString(gatewayListOptionsGatewayType))
  add(query_598115, "fields", newJString(fields))
  add(query_598115, "pageToken", newJString(pageToken))
  add(query_598115, "quotaUser", newJString(quotaUser))
  add(query_598115, "alt", newJString(alt))
  add(query_598115, "gatewayListOptions.associationsDeviceId",
      newJString(gatewayListOptionsAssociationsDeviceId))
  add(query_598115, "oauth_token", newJString(oauthToken))
  add(query_598115, "callback", newJString(callback))
  add(query_598115, "access_token", newJString(accessToken))
  add(query_598115, "uploadType", newJString(uploadType))
  add(path_598114, "parent", newJString(parent))
  add(query_598115, "gatewayListOptions.associationsGatewayId",
      newJString(gatewayListOptionsAssociationsGatewayId))
  if deviceIds != nil:
    query_598115.add "deviceIds", deviceIds
  add(query_598115, "key", newJString(key))
  add(query_598115, "fieldMask", newJString(fieldMask))
  add(query_598115, "$.xgafv", newJString(Xgafv))
  add(query_598115, "pageSize", newJInt(pageSize))
  if deviceNumIds != nil:
    query_598115.add "deviceNumIds", deviceNumIds
  add(query_598115, "prettyPrint", newJBool(prettyPrint))
  result = call_598113.call(path_598114, query_598115, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesList* = Call_CloudiotProjectsLocationsRegistriesDevicesList_598089(
    name: "cloudiotProjectsLocationsRegistriesDevicesList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}/devices",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesList_598090,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesList_598091,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesCreate_598158 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesCreate_598160(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesCreate_598159(path: JsonNode;
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
  var valid_598161 = path.getOrDefault("parent")
  valid_598161 = validateParameter(valid_598161, JString, required = true,
                                 default = nil)
  if valid_598161 != nil:
    section.add "parent", valid_598161
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
  var valid_598162 = query.getOrDefault("upload_protocol")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "upload_protocol", valid_598162
  var valid_598163 = query.getOrDefault("fields")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "fields", valid_598163
  var valid_598164 = query.getOrDefault("quotaUser")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = nil)
  if valid_598164 != nil:
    section.add "quotaUser", valid_598164
  var valid_598165 = query.getOrDefault("alt")
  valid_598165 = validateParameter(valid_598165, JString, required = false,
                                 default = newJString("json"))
  if valid_598165 != nil:
    section.add "alt", valid_598165
  var valid_598166 = query.getOrDefault("oauth_token")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = nil)
  if valid_598166 != nil:
    section.add "oauth_token", valid_598166
  var valid_598167 = query.getOrDefault("callback")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "callback", valid_598167
  var valid_598168 = query.getOrDefault("access_token")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = nil)
  if valid_598168 != nil:
    section.add "access_token", valid_598168
  var valid_598169 = query.getOrDefault("uploadType")
  valid_598169 = validateParameter(valid_598169, JString, required = false,
                                 default = nil)
  if valid_598169 != nil:
    section.add "uploadType", valid_598169
  var valid_598170 = query.getOrDefault("key")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = nil)
  if valid_598170 != nil:
    section.add "key", valid_598170
  var valid_598171 = query.getOrDefault("$.xgafv")
  valid_598171 = validateParameter(valid_598171, JString, required = false,
                                 default = newJString("1"))
  if valid_598171 != nil:
    section.add "$.xgafv", valid_598171
  var valid_598172 = query.getOrDefault("prettyPrint")
  valid_598172 = validateParameter(valid_598172, JBool, required = false,
                                 default = newJBool(true))
  if valid_598172 != nil:
    section.add "prettyPrint", valid_598172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598174: Call_CloudiotProjectsLocationsRegistriesCreate_598158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a device registry that contains devices.
  ## 
  let valid = call_598174.validator(path, query, header, formData, body)
  let scheme = call_598174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598174.url(scheme.get, call_598174.host, call_598174.base,
                         call_598174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598174, url, valid)

proc call*(call_598175: Call_CloudiotProjectsLocationsRegistriesCreate_598158;
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
  var path_598176 = newJObject()
  var query_598177 = newJObject()
  var body_598178 = newJObject()
  add(query_598177, "upload_protocol", newJString(uploadProtocol))
  add(query_598177, "fields", newJString(fields))
  add(query_598177, "quotaUser", newJString(quotaUser))
  add(query_598177, "alt", newJString(alt))
  add(query_598177, "oauth_token", newJString(oauthToken))
  add(query_598177, "callback", newJString(callback))
  add(query_598177, "access_token", newJString(accessToken))
  add(query_598177, "uploadType", newJString(uploadType))
  add(path_598176, "parent", newJString(parent))
  add(query_598177, "key", newJString(key))
  add(query_598177, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598178 = body
  add(query_598177, "prettyPrint", newJBool(prettyPrint))
  result = call_598175.call(path_598176, query_598177, nil, nil, body_598178)

var cloudiotProjectsLocationsRegistriesCreate* = Call_CloudiotProjectsLocationsRegistriesCreate_598158(
    name: "cloudiotProjectsLocationsRegistriesCreate", meth: HttpMethod.HttpPost,
    host: "cloudiot.googleapis.com", route: "/v1/{parent}/registries",
    validator: validate_CloudiotProjectsLocationsRegistriesCreate_598159,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesCreate_598160,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesList_598137 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesList_598139(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesList_598138(path: JsonNode;
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
  var valid_598140 = path.getOrDefault("parent")
  valid_598140 = validateParameter(valid_598140, JString, required = true,
                                 default = nil)
  if valid_598140 != nil:
    section.add "parent", valid_598140
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
  var valid_598141 = query.getOrDefault("upload_protocol")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "upload_protocol", valid_598141
  var valid_598142 = query.getOrDefault("fields")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "fields", valid_598142
  var valid_598143 = query.getOrDefault("pageToken")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "pageToken", valid_598143
  var valid_598144 = query.getOrDefault("quotaUser")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "quotaUser", valid_598144
  var valid_598145 = query.getOrDefault("alt")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = newJString("json"))
  if valid_598145 != nil:
    section.add "alt", valid_598145
  var valid_598146 = query.getOrDefault("oauth_token")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "oauth_token", valid_598146
  var valid_598147 = query.getOrDefault("callback")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = nil)
  if valid_598147 != nil:
    section.add "callback", valid_598147
  var valid_598148 = query.getOrDefault("access_token")
  valid_598148 = validateParameter(valid_598148, JString, required = false,
                                 default = nil)
  if valid_598148 != nil:
    section.add "access_token", valid_598148
  var valid_598149 = query.getOrDefault("uploadType")
  valid_598149 = validateParameter(valid_598149, JString, required = false,
                                 default = nil)
  if valid_598149 != nil:
    section.add "uploadType", valid_598149
  var valid_598150 = query.getOrDefault("key")
  valid_598150 = validateParameter(valid_598150, JString, required = false,
                                 default = nil)
  if valid_598150 != nil:
    section.add "key", valid_598150
  var valid_598151 = query.getOrDefault("$.xgafv")
  valid_598151 = validateParameter(valid_598151, JString, required = false,
                                 default = newJString("1"))
  if valid_598151 != nil:
    section.add "$.xgafv", valid_598151
  var valid_598152 = query.getOrDefault("pageSize")
  valid_598152 = validateParameter(valid_598152, JInt, required = false, default = nil)
  if valid_598152 != nil:
    section.add "pageSize", valid_598152
  var valid_598153 = query.getOrDefault("prettyPrint")
  valid_598153 = validateParameter(valid_598153, JBool, required = false,
                                 default = newJBool(true))
  if valid_598153 != nil:
    section.add "prettyPrint", valid_598153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598154: Call_CloudiotProjectsLocationsRegistriesList_598137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists device registries.
  ## 
  let valid = call_598154.validator(path, query, header, formData, body)
  let scheme = call_598154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598154.url(scheme.get, call_598154.host, call_598154.base,
                         call_598154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598154, url, valid)

proc call*(call_598155: Call_CloudiotProjectsLocationsRegistriesList_598137;
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
  var path_598156 = newJObject()
  var query_598157 = newJObject()
  add(query_598157, "upload_protocol", newJString(uploadProtocol))
  add(query_598157, "fields", newJString(fields))
  add(query_598157, "pageToken", newJString(pageToken))
  add(query_598157, "quotaUser", newJString(quotaUser))
  add(query_598157, "alt", newJString(alt))
  add(query_598157, "oauth_token", newJString(oauthToken))
  add(query_598157, "callback", newJString(callback))
  add(query_598157, "access_token", newJString(accessToken))
  add(query_598157, "uploadType", newJString(uploadType))
  add(path_598156, "parent", newJString(parent))
  add(query_598157, "key", newJString(key))
  add(query_598157, "$.xgafv", newJString(Xgafv))
  add(query_598157, "pageSize", newJInt(pageSize))
  add(query_598157, "prettyPrint", newJBool(prettyPrint))
  result = call_598155.call(path_598156, query_598157, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesList* = Call_CloudiotProjectsLocationsRegistriesList_598137(
    name: "cloudiotProjectsLocationsRegistriesList", meth: HttpMethod.HttpGet,
    host: "cloudiot.googleapis.com", route: "/v1/{parent}/registries",
    validator: validate_CloudiotProjectsLocationsRegistriesList_598138, base: "/",
    url: url_CloudiotProjectsLocationsRegistriesList_598139,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_598179 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_598181(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_598180(
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
  var valid_598182 = path.getOrDefault("parent")
  valid_598182 = validateParameter(valid_598182, JString, required = true,
                                 default = nil)
  if valid_598182 != nil:
    section.add "parent", valid_598182
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
  var valid_598183 = query.getOrDefault("upload_protocol")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "upload_protocol", valid_598183
  var valid_598184 = query.getOrDefault("fields")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "fields", valid_598184
  var valid_598185 = query.getOrDefault("quotaUser")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "quotaUser", valid_598185
  var valid_598186 = query.getOrDefault("alt")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = newJString("json"))
  if valid_598186 != nil:
    section.add "alt", valid_598186
  var valid_598187 = query.getOrDefault("oauth_token")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = nil)
  if valid_598187 != nil:
    section.add "oauth_token", valid_598187
  var valid_598188 = query.getOrDefault("callback")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = nil)
  if valid_598188 != nil:
    section.add "callback", valid_598188
  var valid_598189 = query.getOrDefault("access_token")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "access_token", valid_598189
  var valid_598190 = query.getOrDefault("uploadType")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = nil)
  if valid_598190 != nil:
    section.add "uploadType", valid_598190
  var valid_598191 = query.getOrDefault("key")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "key", valid_598191
  var valid_598192 = query.getOrDefault("$.xgafv")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = newJString("1"))
  if valid_598192 != nil:
    section.add "$.xgafv", valid_598192
  var valid_598193 = query.getOrDefault("prettyPrint")
  valid_598193 = validateParameter(valid_598193, JBool, required = false,
                                 default = newJBool(true))
  if valid_598193 != nil:
    section.add "prettyPrint", valid_598193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598195: Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_598179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associates the device with the gateway.
  ## 
  let valid = call_598195.validator(path, query, header, formData, body)
  let scheme = call_598195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598195.url(scheme.get, call_598195.host, call_598195.base,
                         call_598195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598195, url, valid)

proc call*(call_598196: Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_598179;
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
  var path_598197 = newJObject()
  var query_598198 = newJObject()
  var body_598199 = newJObject()
  add(query_598198, "upload_protocol", newJString(uploadProtocol))
  add(query_598198, "fields", newJString(fields))
  add(query_598198, "quotaUser", newJString(quotaUser))
  add(query_598198, "alt", newJString(alt))
  add(query_598198, "oauth_token", newJString(oauthToken))
  add(query_598198, "callback", newJString(callback))
  add(query_598198, "access_token", newJString(accessToken))
  add(query_598198, "uploadType", newJString(uploadType))
  add(path_598197, "parent", newJString(parent))
  add(query_598198, "key", newJString(key))
  add(query_598198, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598199 = body
  add(query_598198, "prettyPrint", newJBool(prettyPrint))
  result = call_598196.call(path_598197, query_598198, nil, nil, body_598199)

var cloudiotProjectsLocationsRegistriesBindDeviceToGateway* = Call_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_598179(
    name: "cloudiotProjectsLocationsRegistriesBindDeviceToGateway",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}:bindDeviceToGateway",
    validator: validate_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_598180,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesBindDeviceToGateway_598181,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_598200 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_598202(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_598201(
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
  var valid_598203 = path.getOrDefault("parent")
  valid_598203 = validateParameter(valid_598203, JString, required = true,
                                 default = nil)
  if valid_598203 != nil:
    section.add "parent", valid_598203
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
  var valid_598204 = query.getOrDefault("upload_protocol")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "upload_protocol", valid_598204
  var valid_598205 = query.getOrDefault("fields")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = nil)
  if valid_598205 != nil:
    section.add "fields", valid_598205
  var valid_598206 = query.getOrDefault("quotaUser")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "quotaUser", valid_598206
  var valid_598207 = query.getOrDefault("alt")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = newJString("json"))
  if valid_598207 != nil:
    section.add "alt", valid_598207
  var valid_598208 = query.getOrDefault("oauth_token")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "oauth_token", valid_598208
  var valid_598209 = query.getOrDefault("callback")
  valid_598209 = validateParameter(valid_598209, JString, required = false,
                                 default = nil)
  if valid_598209 != nil:
    section.add "callback", valid_598209
  var valid_598210 = query.getOrDefault("access_token")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "access_token", valid_598210
  var valid_598211 = query.getOrDefault("uploadType")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = nil)
  if valid_598211 != nil:
    section.add "uploadType", valid_598211
  var valid_598212 = query.getOrDefault("key")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = nil)
  if valid_598212 != nil:
    section.add "key", valid_598212
  var valid_598213 = query.getOrDefault("$.xgafv")
  valid_598213 = validateParameter(valid_598213, JString, required = false,
                                 default = newJString("1"))
  if valid_598213 != nil:
    section.add "$.xgafv", valid_598213
  var valid_598214 = query.getOrDefault("prettyPrint")
  valid_598214 = validateParameter(valid_598214, JBool, required = false,
                                 default = newJBool(true))
  if valid_598214 != nil:
    section.add "prettyPrint", valid_598214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598216: Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_598200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the association between the device and the gateway.
  ## 
  let valid = call_598216.validator(path, query, header, formData, body)
  let scheme = call_598216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598216.url(scheme.get, call_598216.host, call_598216.base,
                         call_598216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598216, url, valid)

proc call*(call_598217: Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_598200;
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
  var path_598218 = newJObject()
  var query_598219 = newJObject()
  var body_598220 = newJObject()
  add(query_598219, "upload_protocol", newJString(uploadProtocol))
  add(query_598219, "fields", newJString(fields))
  add(query_598219, "quotaUser", newJString(quotaUser))
  add(query_598219, "alt", newJString(alt))
  add(query_598219, "oauth_token", newJString(oauthToken))
  add(query_598219, "callback", newJString(callback))
  add(query_598219, "access_token", newJString(accessToken))
  add(query_598219, "uploadType", newJString(uploadType))
  add(path_598218, "parent", newJString(parent))
  add(query_598219, "key", newJString(key))
  add(query_598219, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598220 = body
  add(query_598219, "prettyPrint", newJBool(prettyPrint))
  result = call_598217.call(path_598218, query_598219, nil, nil, body_598220)

var cloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway* = Call_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_598200(
    name: "cloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{parent}:unbindDeviceFromGateway", validator: validate_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_598201,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesUnbindDeviceFromGateway_598202,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_598221 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_598223(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_598222(
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
  var valid_598224 = path.getOrDefault("resource")
  valid_598224 = validateParameter(valid_598224, JString, required = true,
                                 default = nil)
  if valid_598224 != nil:
    section.add "resource", valid_598224
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
  var valid_598225 = query.getOrDefault("upload_protocol")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "upload_protocol", valid_598225
  var valid_598226 = query.getOrDefault("fields")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "fields", valid_598226
  var valid_598227 = query.getOrDefault("quotaUser")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = nil)
  if valid_598227 != nil:
    section.add "quotaUser", valid_598227
  var valid_598228 = query.getOrDefault("alt")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = newJString("json"))
  if valid_598228 != nil:
    section.add "alt", valid_598228
  var valid_598229 = query.getOrDefault("oauth_token")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = nil)
  if valid_598229 != nil:
    section.add "oauth_token", valid_598229
  var valid_598230 = query.getOrDefault("callback")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "callback", valid_598230
  var valid_598231 = query.getOrDefault("access_token")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = nil)
  if valid_598231 != nil:
    section.add "access_token", valid_598231
  var valid_598232 = query.getOrDefault("uploadType")
  valid_598232 = validateParameter(valid_598232, JString, required = false,
                                 default = nil)
  if valid_598232 != nil:
    section.add "uploadType", valid_598232
  var valid_598233 = query.getOrDefault("key")
  valid_598233 = validateParameter(valid_598233, JString, required = false,
                                 default = nil)
  if valid_598233 != nil:
    section.add "key", valid_598233
  var valid_598234 = query.getOrDefault("$.xgafv")
  valid_598234 = validateParameter(valid_598234, JString, required = false,
                                 default = newJString("1"))
  if valid_598234 != nil:
    section.add "$.xgafv", valid_598234
  var valid_598235 = query.getOrDefault("prettyPrint")
  valid_598235 = validateParameter(valid_598235, JBool, required = false,
                                 default = newJBool(true))
  if valid_598235 != nil:
    section.add "prettyPrint", valid_598235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598237: Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_598221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_598237.validator(path, query, header, formData, body)
  let scheme = call_598237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598237.url(scheme.get, call_598237.host, call_598237.base,
                         call_598237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598237, url, valid)

proc call*(call_598238: Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_598221;
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
  var path_598239 = newJObject()
  var query_598240 = newJObject()
  var body_598241 = newJObject()
  add(query_598240, "upload_protocol", newJString(uploadProtocol))
  add(query_598240, "fields", newJString(fields))
  add(query_598240, "quotaUser", newJString(quotaUser))
  add(query_598240, "alt", newJString(alt))
  add(query_598240, "oauth_token", newJString(oauthToken))
  add(query_598240, "callback", newJString(callback))
  add(query_598240, "access_token", newJString(accessToken))
  add(query_598240, "uploadType", newJString(uploadType))
  add(query_598240, "key", newJString(key))
  add(query_598240, "$.xgafv", newJString(Xgafv))
  add(path_598239, "resource", newJString(resource))
  if body != nil:
    body_598241 = body
  add(query_598240, "prettyPrint", newJBool(prettyPrint))
  result = call_598238.call(path_598239, query_598240, nil, nil, body_598241)

var cloudiotProjectsLocationsRegistriesGroupsGetIamPolicy* = Call_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_598221(
    name: "cloudiotProjectsLocationsRegistriesGroupsGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_598222,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesGroupsGetIamPolicy_598223,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_598242 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_598244(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_598243(
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
  var valid_598245 = path.getOrDefault("resource")
  valid_598245 = validateParameter(valid_598245, JString, required = true,
                                 default = nil)
  if valid_598245 != nil:
    section.add "resource", valid_598245
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
  var valid_598246 = query.getOrDefault("upload_protocol")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "upload_protocol", valid_598246
  var valid_598247 = query.getOrDefault("fields")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = nil)
  if valid_598247 != nil:
    section.add "fields", valid_598247
  var valid_598248 = query.getOrDefault("quotaUser")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = nil)
  if valid_598248 != nil:
    section.add "quotaUser", valid_598248
  var valid_598249 = query.getOrDefault("alt")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = newJString("json"))
  if valid_598249 != nil:
    section.add "alt", valid_598249
  var valid_598250 = query.getOrDefault("oauth_token")
  valid_598250 = validateParameter(valid_598250, JString, required = false,
                                 default = nil)
  if valid_598250 != nil:
    section.add "oauth_token", valid_598250
  var valid_598251 = query.getOrDefault("callback")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = nil)
  if valid_598251 != nil:
    section.add "callback", valid_598251
  var valid_598252 = query.getOrDefault("access_token")
  valid_598252 = validateParameter(valid_598252, JString, required = false,
                                 default = nil)
  if valid_598252 != nil:
    section.add "access_token", valid_598252
  var valid_598253 = query.getOrDefault("uploadType")
  valid_598253 = validateParameter(valid_598253, JString, required = false,
                                 default = nil)
  if valid_598253 != nil:
    section.add "uploadType", valid_598253
  var valid_598254 = query.getOrDefault("key")
  valid_598254 = validateParameter(valid_598254, JString, required = false,
                                 default = nil)
  if valid_598254 != nil:
    section.add "key", valid_598254
  var valid_598255 = query.getOrDefault("$.xgafv")
  valid_598255 = validateParameter(valid_598255, JString, required = false,
                                 default = newJString("1"))
  if valid_598255 != nil:
    section.add "$.xgafv", valid_598255
  var valid_598256 = query.getOrDefault("prettyPrint")
  valid_598256 = validateParameter(valid_598256, JBool, required = false,
                                 default = newJBool(true))
  if valid_598256 != nil:
    section.add "prettyPrint", valid_598256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598258: Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_598242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_598258.validator(path, query, header, formData, body)
  let scheme = call_598258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598258.url(scheme.get, call_598258.host, call_598258.base,
                         call_598258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598258, url, valid)

proc call*(call_598259: Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_598242;
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
  var path_598260 = newJObject()
  var query_598261 = newJObject()
  var body_598262 = newJObject()
  add(query_598261, "upload_protocol", newJString(uploadProtocol))
  add(query_598261, "fields", newJString(fields))
  add(query_598261, "quotaUser", newJString(quotaUser))
  add(query_598261, "alt", newJString(alt))
  add(query_598261, "oauth_token", newJString(oauthToken))
  add(query_598261, "callback", newJString(callback))
  add(query_598261, "access_token", newJString(accessToken))
  add(query_598261, "uploadType", newJString(uploadType))
  add(query_598261, "key", newJString(key))
  add(query_598261, "$.xgafv", newJString(Xgafv))
  add(path_598260, "resource", newJString(resource))
  if body != nil:
    body_598262 = body
  add(query_598261, "prettyPrint", newJBool(prettyPrint))
  result = call_598259.call(path_598260, query_598261, nil, nil, body_598262)

var cloudiotProjectsLocationsRegistriesGroupsSetIamPolicy* = Call_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_598242(
    name: "cloudiotProjectsLocationsRegistriesGroupsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_598243,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesGroupsSetIamPolicy_598244,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_598263 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_598265(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_598264(
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
  var valid_598266 = path.getOrDefault("resource")
  valid_598266 = validateParameter(valid_598266, JString, required = true,
                                 default = nil)
  if valid_598266 != nil:
    section.add "resource", valid_598266
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
  var valid_598267 = query.getOrDefault("upload_protocol")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "upload_protocol", valid_598267
  var valid_598268 = query.getOrDefault("fields")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = nil)
  if valid_598268 != nil:
    section.add "fields", valid_598268
  var valid_598269 = query.getOrDefault("quotaUser")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = nil)
  if valid_598269 != nil:
    section.add "quotaUser", valid_598269
  var valid_598270 = query.getOrDefault("alt")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = newJString("json"))
  if valid_598270 != nil:
    section.add "alt", valid_598270
  var valid_598271 = query.getOrDefault("oauth_token")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = nil)
  if valid_598271 != nil:
    section.add "oauth_token", valid_598271
  var valid_598272 = query.getOrDefault("callback")
  valid_598272 = validateParameter(valid_598272, JString, required = false,
                                 default = nil)
  if valid_598272 != nil:
    section.add "callback", valid_598272
  var valid_598273 = query.getOrDefault("access_token")
  valid_598273 = validateParameter(valid_598273, JString, required = false,
                                 default = nil)
  if valid_598273 != nil:
    section.add "access_token", valid_598273
  var valid_598274 = query.getOrDefault("uploadType")
  valid_598274 = validateParameter(valid_598274, JString, required = false,
                                 default = nil)
  if valid_598274 != nil:
    section.add "uploadType", valid_598274
  var valid_598275 = query.getOrDefault("key")
  valid_598275 = validateParameter(valid_598275, JString, required = false,
                                 default = nil)
  if valid_598275 != nil:
    section.add "key", valid_598275
  var valid_598276 = query.getOrDefault("$.xgafv")
  valid_598276 = validateParameter(valid_598276, JString, required = false,
                                 default = newJString("1"))
  if valid_598276 != nil:
    section.add "$.xgafv", valid_598276
  var valid_598277 = query.getOrDefault("prettyPrint")
  valid_598277 = validateParameter(valid_598277, JBool, required = false,
                                 default = newJBool(true))
  if valid_598277 != nil:
    section.add "prettyPrint", valid_598277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598279: Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_598263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  let valid = call_598279.validator(path, query, header, formData, body)
  let scheme = call_598279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598279.url(scheme.get, call_598279.host, call_598279.base,
                         call_598279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598279, url, valid)

proc call*(call_598280: Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_598263;
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
  var path_598281 = newJObject()
  var query_598282 = newJObject()
  var body_598283 = newJObject()
  add(query_598282, "upload_protocol", newJString(uploadProtocol))
  add(query_598282, "fields", newJString(fields))
  add(query_598282, "quotaUser", newJString(quotaUser))
  add(query_598282, "alt", newJString(alt))
  add(query_598282, "oauth_token", newJString(oauthToken))
  add(query_598282, "callback", newJString(callback))
  add(query_598282, "access_token", newJString(accessToken))
  add(query_598282, "uploadType", newJString(uploadType))
  add(query_598282, "key", newJString(key))
  add(query_598282, "$.xgafv", newJString(Xgafv))
  add(path_598281, "resource", newJString(resource))
  if body != nil:
    body_598283 = body
  add(query_598282, "prettyPrint", newJBool(prettyPrint))
  result = call_598280.call(path_598281, query_598282, nil, nil, body_598283)

var cloudiotProjectsLocationsRegistriesGroupsTestIamPermissions* = Call_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_598263(
    name: "cloudiotProjectsLocationsRegistriesGroupsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1/{resource}:testIamPermissions", validator: validate_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_598264,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesGroupsTestIamPermissions_598265,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
