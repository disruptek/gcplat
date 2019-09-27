
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
  var valid_597823 = query.getOrDefault("pp")
  valid_597823 = validateParameter(valid_597823, JBool, required = false,
                                 default = newJBool(true))
  if valid_597823 != nil:
    section.add "pp", valid_597823
  var valid_597824 = query.getOrDefault("oauth_token")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "oauth_token", valid_597824
  var valid_597825 = query.getOrDefault("callback")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "callback", valid_597825
  var valid_597826 = query.getOrDefault("access_token")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "access_token", valid_597826
  var valid_597827 = query.getOrDefault("uploadType")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "uploadType", valid_597827
  var valid_597828 = query.getOrDefault("key")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = nil)
  if valid_597828 != nil:
    section.add "key", valid_597828
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
  var valid_597831 = query.getOrDefault("bearer_token")
  valid_597831 = validateParameter(valid_597831, JString, required = false,
                                 default = nil)
  if valid_597831 != nil:
    section.add "bearer_token", valid_597831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597854: Call_CloudiotProjectsLocationsRegistriesDevicesGet_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets details about a device.
  ## 
  let valid = call_597854.validator(path, query, header, formData, body)
  let scheme = call_597854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597854.url(scheme.get, call_597854.host, call_597854.base,
                         call_597854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597854, url, valid)

proc call*(call_597925: Call_CloudiotProjectsLocationsRegistriesDevicesGet_597677;
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
  var path_597926 = newJObject()
  var query_597928 = newJObject()
  add(query_597928, "upload_protocol", newJString(uploadProtocol))
  add(query_597928, "fields", newJString(fields))
  add(query_597928, "quotaUser", newJString(quotaUser))
  add(path_597926, "name", newJString(name))
  add(query_597928, "alt", newJString(alt))
  add(query_597928, "pp", newJBool(pp))
  add(query_597928, "oauth_token", newJString(oauthToken))
  add(query_597928, "callback", newJString(callback))
  add(query_597928, "access_token", newJString(accessToken))
  add(query_597928, "uploadType", newJString(uploadType))
  add(query_597928, "key", newJString(key))
  add(query_597928, "$.xgafv", newJString(Xgafv))
  add(query_597928, "prettyPrint", newJBool(prettyPrint))
  add(query_597928, "bearer_token", newJString(bearerToken))
  result = call_597925.call(path_597926, query_597928, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesGet* = Call_CloudiotProjectsLocationsRegistriesDevicesGet_597677(
    name: "cloudiotProjectsLocationsRegistriesDevicesGet",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesGet_597678,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesGet_597679,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesPatch_597988 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesPatch_597990(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesPatch_597989(
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
  var valid_597991 = path.getOrDefault("name")
  valid_597991 = validateParameter(valid_597991, JString, required = true,
                                 default = nil)
  if valid_597991 != nil:
    section.add "name", valid_597991
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
  var valid_597992 = query.getOrDefault("upload_protocol")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "upload_protocol", valid_597992
  var valid_597993 = query.getOrDefault("fields")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "fields", valid_597993
  var valid_597994 = query.getOrDefault("quotaUser")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "quotaUser", valid_597994
  var valid_597995 = query.getOrDefault("alt")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = newJString("json"))
  if valid_597995 != nil:
    section.add "alt", valid_597995
  var valid_597996 = query.getOrDefault("pp")
  valid_597996 = validateParameter(valid_597996, JBool, required = false,
                                 default = newJBool(true))
  if valid_597996 != nil:
    section.add "pp", valid_597996
  var valid_597997 = query.getOrDefault("oauth_token")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "oauth_token", valid_597997
  var valid_597998 = query.getOrDefault("callback")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "callback", valid_597998
  var valid_597999 = query.getOrDefault("access_token")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "access_token", valid_597999
  var valid_598000 = query.getOrDefault("uploadType")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "uploadType", valid_598000
  var valid_598001 = query.getOrDefault("key")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "key", valid_598001
  var valid_598002 = query.getOrDefault("$.xgafv")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = newJString("1"))
  if valid_598002 != nil:
    section.add "$.xgafv", valid_598002
  var valid_598003 = query.getOrDefault("prettyPrint")
  valid_598003 = validateParameter(valid_598003, JBool, required = false,
                                 default = newJBool(true))
  if valid_598003 != nil:
    section.add "prettyPrint", valid_598003
  var valid_598004 = query.getOrDefault("updateMask")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "updateMask", valid_598004
  var valid_598005 = query.getOrDefault("bearer_token")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = nil)
  if valid_598005 != nil:
    section.add "bearer_token", valid_598005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598007: Call_CloudiotProjectsLocationsRegistriesDevicesPatch_597988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a device.
  ## 
  let valid = call_598007.validator(path, query, header, formData, body)
  let scheme = call_598007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598007.url(scheme.get, call_598007.host, call_598007.base,
                         call_598007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598007, url, valid)

proc call*(call_598008: Call_CloudiotProjectsLocationsRegistriesDevicesPatch_597988;
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
  var path_598009 = newJObject()
  var query_598010 = newJObject()
  var body_598011 = newJObject()
  add(query_598010, "upload_protocol", newJString(uploadProtocol))
  add(query_598010, "fields", newJString(fields))
  add(query_598010, "quotaUser", newJString(quotaUser))
  add(path_598009, "name", newJString(name))
  add(query_598010, "alt", newJString(alt))
  add(query_598010, "pp", newJBool(pp))
  add(query_598010, "oauth_token", newJString(oauthToken))
  add(query_598010, "callback", newJString(callback))
  add(query_598010, "access_token", newJString(accessToken))
  add(query_598010, "uploadType", newJString(uploadType))
  add(query_598010, "key", newJString(key))
  add(query_598010, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598011 = body
  add(query_598010, "prettyPrint", newJBool(prettyPrint))
  add(query_598010, "updateMask", newJString(updateMask))
  add(query_598010, "bearer_token", newJString(bearerToken))
  result = call_598008.call(path_598009, query_598010, nil, nil, body_598011)

var cloudiotProjectsLocationsRegistriesDevicesPatch* = Call_CloudiotProjectsLocationsRegistriesDevicesPatch_597988(
    name: "cloudiotProjectsLocationsRegistriesDevicesPatch",
    meth: HttpMethod.HttpPatch, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesPatch_597989,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesPatch_597990,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesDelete_597967 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesDelete_597969(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudiotProjectsLocationsRegistriesDevicesDelete_597968(
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
  var valid_597970 = path.getOrDefault("name")
  valid_597970 = validateParameter(valid_597970, JString, required = true,
                                 default = nil)
  if valid_597970 != nil:
    section.add "name", valid_597970
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
  var valid_597971 = query.getOrDefault("upload_protocol")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "upload_protocol", valid_597971
  var valid_597972 = query.getOrDefault("fields")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "fields", valid_597972
  var valid_597973 = query.getOrDefault("quotaUser")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "quotaUser", valid_597973
  var valid_597974 = query.getOrDefault("alt")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = newJString("json"))
  if valid_597974 != nil:
    section.add "alt", valid_597974
  var valid_597975 = query.getOrDefault("pp")
  valid_597975 = validateParameter(valid_597975, JBool, required = false,
                                 default = newJBool(true))
  if valid_597975 != nil:
    section.add "pp", valid_597975
  var valid_597976 = query.getOrDefault("oauth_token")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "oauth_token", valid_597976
  var valid_597977 = query.getOrDefault("callback")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "callback", valid_597977
  var valid_597978 = query.getOrDefault("access_token")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "access_token", valid_597978
  var valid_597979 = query.getOrDefault("uploadType")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "uploadType", valid_597979
  var valid_597980 = query.getOrDefault("key")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "key", valid_597980
  var valid_597981 = query.getOrDefault("$.xgafv")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = newJString("1"))
  if valid_597981 != nil:
    section.add "$.xgafv", valid_597981
  var valid_597982 = query.getOrDefault("prettyPrint")
  valid_597982 = validateParameter(valid_597982, JBool, required = false,
                                 default = newJBool(true))
  if valid_597982 != nil:
    section.add "prettyPrint", valid_597982
  var valid_597983 = query.getOrDefault("bearer_token")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "bearer_token", valid_597983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597984: Call_CloudiotProjectsLocationsRegistriesDevicesDelete_597967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a device.
  ## 
  let valid = call_597984.validator(path, query, header, formData, body)
  let scheme = call_597984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597984.url(scheme.get, call_597984.host, call_597984.base,
                         call_597984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597984, url, valid)

proc call*(call_597985: Call_CloudiotProjectsLocationsRegistriesDevicesDelete_597967;
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
  var path_597986 = newJObject()
  var query_597987 = newJObject()
  add(query_597987, "upload_protocol", newJString(uploadProtocol))
  add(query_597987, "fields", newJString(fields))
  add(query_597987, "quotaUser", newJString(quotaUser))
  add(path_597986, "name", newJString(name))
  add(query_597987, "alt", newJString(alt))
  add(query_597987, "pp", newJBool(pp))
  add(query_597987, "oauth_token", newJString(oauthToken))
  add(query_597987, "callback", newJString(callback))
  add(query_597987, "access_token", newJString(accessToken))
  add(query_597987, "uploadType", newJString(uploadType))
  add(query_597987, "key", newJString(key))
  add(query_597987, "$.xgafv", newJString(Xgafv))
  add(query_597987, "prettyPrint", newJBool(prettyPrint))
  add(query_597987, "bearer_token", newJString(bearerToken))
  result = call_597985.call(path_597986, query_597987, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesDelete* = Call_CloudiotProjectsLocationsRegistriesDevicesDelete_597967(
    name: "cloudiotProjectsLocationsRegistriesDevicesDelete",
    meth: HttpMethod.HttpDelete, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesDelete_597968,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesDelete_597969,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598012 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598014(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598013(
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
  var valid_598015 = path.getOrDefault("name")
  valid_598015 = validateParameter(valid_598015, JString, required = true,
                                 default = nil)
  if valid_598015 != nil:
    section.add "name", valid_598015
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
  var valid_598016 = query.getOrDefault("upload_protocol")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "upload_protocol", valid_598016
  var valid_598017 = query.getOrDefault("fields")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "fields", valid_598017
  var valid_598018 = query.getOrDefault("quotaUser")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "quotaUser", valid_598018
  var valid_598019 = query.getOrDefault("alt")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = newJString("json"))
  if valid_598019 != nil:
    section.add "alt", valid_598019
  var valid_598020 = query.getOrDefault("pp")
  valid_598020 = validateParameter(valid_598020, JBool, required = false,
                                 default = newJBool(true))
  if valid_598020 != nil:
    section.add "pp", valid_598020
  var valid_598021 = query.getOrDefault("oauth_token")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "oauth_token", valid_598021
  var valid_598022 = query.getOrDefault("callback")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = nil)
  if valid_598022 != nil:
    section.add "callback", valid_598022
  var valid_598023 = query.getOrDefault("access_token")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = nil)
  if valid_598023 != nil:
    section.add "access_token", valid_598023
  var valid_598024 = query.getOrDefault("uploadType")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = nil)
  if valid_598024 != nil:
    section.add "uploadType", valid_598024
  var valid_598025 = query.getOrDefault("key")
  valid_598025 = validateParameter(valid_598025, JString, required = false,
                                 default = nil)
  if valid_598025 != nil:
    section.add "key", valid_598025
  var valid_598026 = query.getOrDefault("$.xgafv")
  valid_598026 = validateParameter(valid_598026, JString, required = false,
                                 default = newJString("1"))
  if valid_598026 != nil:
    section.add "$.xgafv", valid_598026
  var valid_598027 = query.getOrDefault("prettyPrint")
  valid_598027 = validateParameter(valid_598027, JBool, required = false,
                                 default = newJBool(true))
  if valid_598027 != nil:
    section.add "prettyPrint", valid_598027
  var valid_598028 = query.getOrDefault("numVersions")
  valid_598028 = validateParameter(valid_598028, JInt, required = false, default = nil)
  if valid_598028 != nil:
    section.add "numVersions", valid_598028
  var valid_598029 = query.getOrDefault("bearer_token")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "bearer_token", valid_598029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598030: Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the last few versions of the device configuration in descending
  ## order (i.e.: newest first).
  ## 
  let valid = call_598030.validator(path, query, header, formData, body)
  let scheme = call_598030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598030.url(scheme.get, call_598030.host, call_598030.base,
                         call_598030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598030, url, valid)

proc call*(call_598031: Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598012;
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
  var path_598032 = newJObject()
  var query_598033 = newJObject()
  add(query_598033, "upload_protocol", newJString(uploadProtocol))
  add(query_598033, "fields", newJString(fields))
  add(query_598033, "quotaUser", newJString(quotaUser))
  add(path_598032, "name", newJString(name))
  add(query_598033, "alt", newJString(alt))
  add(query_598033, "pp", newJBool(pp))
  add(query_598033, "oauth_token", newJString(oauthToken))
  add(query_598033, "callback", newJString(callback))
  add(query_598033, "access_token", newJString(accessToken))
  add(query_598033, "uploadType", newJString(uploadType))
  add(query_598033, "key", newJString(key))
  add(query_598033, "$.xgafv", newJString(Xgafv))
  add(query_598033, "prettyPrint", newJBool(prettyPrint))
  add(query_598033, "numVersions", newJInt(numVersions))
  add(query_598033, "bearer_token", newJString(bearerToken))
  result = call_598031.call(path_598032, query_598033, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesConfigVersionsList* = Call_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598012(
    name: "cloudiotProjectsLocationsRegistriesDevicesConfigVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{name}/configVersions", validator: validate_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598013,
    base: "/",
    url: url_CloudiotProjectsLocationsRegistriesDevicesConfigVersionsList_598014,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598034 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598036(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598035(
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
  var valid_598037 = path.getOrDefault("name")
  valid_598037 = validateParameter(valid_598037, JString, required = true,
                                 default = nil)
  if valid_598037 != nil:
    section.add "name", valid_598037
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
  var valid_598038 = query.getOrDefault("upload_protocol")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "upload_protocol", valid_598038
  var valid_598039 = query.getOrDefault("fields")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "fields", valid_598039
  var valid_598040 = query.getOrDefault("quotaUser")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "quotaUser", valid_598040
  var valid_598041 = query.getOrDefault("alt")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = newJString("json"))
  if valid_598041 != nil:
    section.add "alt", valid_598041
  var valid_598042 = query.getOrDefault("pp")
  valid_598042 = validateParameter(valid_598042, JBool, required = false,
                                 default = newJBool(true))
  if valid_598042 != nil:
    section.add "pp", valid_598042
  var valid_598043 = query.getOrDefault("oauth_token")
  valid_598043 = validateParameter(valid_598043, JString, required = false,
                                 default = nil)
  if valid_598043 != nil:
    section.add "oauth_token", valid_598043
  var valid_598044 = query.getOrDefault("callback")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = nil)
  if valid_598044 != nil:
    section.add "callback", valid_598044
  var valid_598045 = query.getOrDefault("access_token")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = nil)
  if valid_598045 != nil:
    section.add "access_token", valid_598045
  var valid_598046 = query.getOrDefault("uploadType")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = nil)
  if valid_598046 != nil:
    section.add "uploadType", valid_598046
  var valid_598047 = query.getOrDefault("key")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = nil)
  if valid_598047 != nil:
    section.add "key", valid_598047
  var valid_598048 = query.getOrDefault("$.xgafv")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = newJString("1"))
  if valid_598048 != nil:
    section.add "$.xgafv", valid_598048
  var valid_598049 = query.getOrDefault("prettyPrint")
  valid_598049 = validateParameter(valid_598049, JBool, required = false,
                                 default = newJBool(true))
  if valid_598049 != nil:
    section.add "prettyPrint", valid_598049
  var valid_598050 = query.getOrDefault("bearer_token")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "bearer_token", valid_598050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598052: Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598034;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the configuration for the device, which is eventually sent from
  ## the Cloud IoT servers. Returns the modified configuration version and its
  ## meta-data.
  ## 
  let valid = call_598052.validator(path, query, header, formData, body)
  let scheme = call_598052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598052.url(scheme.get, call_598052.host, call_598052.base,
                         call_598052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598052, url, valid)

proc call*(call_598053: Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598034;
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
  var path_598054 = newJObject()
  var query_598055 = newJObject()
  var body_598056 = newJObject()
  add(query_598055, "upload_protocol", newJString(uploadProtocol))
  add(query_598055, "fields", newJString(fields))
  add(query_598055, "quotaUser", newJString(quotaUser))
  add(path_598054, "name", newJString(name))
  add(query_598055, "alt", newJString(alt))
  add(query_598055, "pp", newJBool(pp))
  add(query_598055, "oauth_token", newJString(oauthToken))
  add(query_598055, "callback", newJString(callback))
  add(query_598055, "access_token", newJString(accessToken))
  add(query_598055, "uploadType", newJString(uploadType))
  add(query_598055, "key", newJString(key))
  add(query_598055, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598056 = body
  add(query_598055, "prettyPrint", newJBool(prettyPrint))
  add(query_598055, "bearer_token", newJString(bearerToken))
  result = call_598053.call(path_598054, query_598055, nil, nil, body_598056)

var cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig* = Call_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598034(name: "cloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{name}:modifyCloudToDeviceConfig", validator: validate_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598035,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesModifyCloudToDeviceConfig_598036,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesCreate_598083 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesCreate_598085(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesCreate_598084(
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
  var valid_598086 = path.getOrDefault("parent")
  valid_598086 = validateParameter(valid_598086, JString, required = true,
                                 default = nil)
  if valid_598086 != nil:
    section.add "parent", valid_598086
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
  var valid_598087 = query.getOrDefault("upload_protocol")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = nil)
  if valid_598087 != nil:
    section.add "upload_protocol", valid_598087
  var valid_598088 = query.getOrDefault("fields")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = nil)
  if valid_598088 != nil:
    section.add "fields", valid_598088
  var valid_598089 = query.getOrDefault("quotaUser")
  valid_598089 = validateParameter(valid_598089, JString, required = false,
                                 default = nil)
  if valid_598089 != nil:
    section.add "quotaUser", valid_598089
  var valid_598090 = query.getOrDefault("alt")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = newJString("json"))
  if valid_598090 != nil:
    section.add "alt", valid_598090
  var valid_598091 = query.getOrDefault("pp")
  valid_598091 = validateParameter(valid_598091, JBool, required = false,
                                 default = newJBool(true))
  if valid_598091 != nil:
    section.add "pp", valid_598091
  var valid_598092 = query.getOrDefault("oauth_token")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = nil)
  if valid_598092 != nil:
    section.add "oauth_token", valid_598092
  var valid_598093 = query.getOrDefault("callback")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "callback", valid_598093
  var valid_598094 = query.getOrDefault("access_token")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "access_token", valid_598094
  var valid_598095 = query.getOrDefault("uploadType")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "uploadType", valid_598095
  var valid_598096 = query.getOrDefault("key")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "key", valid_598096
  var valid_598097 = query.getOrDefault("$.xgafv")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = newJString("1"))
  if valid_598097 != nil:
    section.add "$.xgafv", valid_598097
  var valid_598098 = query.getOrDefault("prettyPrint")
  valid_598098 = validateParameter(valid_598098, JBool, required = false,
                                 default = newJBool(true))
  if valid_598098 != nil:
    section.add "prettyPrint", valid_598098
  var valid_598099 = query.getOrDefault("bearer_token")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "bearer_token", valid_598099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598101: Call_CloudiotProjectsLocationsRegistriesDevicesCreate_598083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a device in a device registry.
  ## 
  let valid = call_598101.validator(path, query, header, formData, body)
  let scheme = call_598101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598101.url(scheme.get, call_598101.host, call_598101.base,
                         call_598101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598101, url, valid)

proc call*(call_598102: Call_CloudiotProjectsLocationsRegistriesDevicesCreate_598083;
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
  var path_598103 = newJObject()
  var query_598104 = newJObject()
  var body_598105 = newJObject()
  add(query_598104, "upload_protocol", newJString(uploadProtocol))
  add(query_598104, "fields", newJString(fields))
  add(query_598104, "quotaUser", newJString(quotaUser))
  add(query_598104, "alt", newJString(alt))
  add(query_598104, "pp", newJBool(pp))
  add(query_598104, "oauth_token", newJString(oauthToken))
  add(query_598104, "callback", newJString(callback))
  add(query_598104, "access_token", newJString(accessToken))
  add(query_598104, "uploadType", newJString(uploadType))
  add(path_598103, "parent", newJString(parent))
  add(query_598104, "key", newJString(key))
  add(query_598104, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598105 = body
  add(query_598104, "prettyPrint", newJBool(prettyPrint))
  add(query_598104, "bearer_token", newJString(bearerToken))
  result = call_598102.call(path_598103, query_598104, nil, nil, body_598105)

var cloudiotProjectsLocationsRegistriesDevicesCreate* = Call_CloudiotProjectsLocationsRegistriesDevicesCreate_598083(
    name: "cloudiotProjectsLocationsRegistriesDevicesCreate",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{parent}/devices",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesCreate_598084,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesCreate_598085,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesDevicesList_598057 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesDevicesList_598059(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesDevicesList_598058(
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
  var valid_598060 = path.getOrDefault("parent")
  valid_598060 = validateParameter(valid_598060, JString, required = true,
                                 default = nil)
  if valid_598060 != nil:
    section.add "parent", valid_598060
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
  var valid_598061 = query.getOrDefault("upload_protocol")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "upload_protocol", valid_598061
  var valid_598062 = query.getOrDefault("fields")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = nil)
  if valid_598062 != nil:
    section.add "fields", valid_598062
  var valid_598063 = query.getOrDefault("pageToken")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = nil)
  if valid_598063 != nil:
    section.add "pageToken", valid_598063
  var valid_598064 = query.getOrDefault("quotaUser")
  valid_598064 = validateParameter(valid_598064, JString, required = false,
                                 default = nil)
  if valid_598064 != nil:
    section.add "quotaUser", valid_598064
  var valid_598065 = query.getOrDefault("alt")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = newJString("json"))
  if valid_598065 != nil:
    section.add "alt", valid_598065
  var valid_598066 = query.getOrDefault("pp")
  valid_598066 = validateParameter(valid_598066, JBool, required = false,
                                 default = newJBool(true))
  if valid_598066 != nil:
    section.add "pp", valid_598066
  var valid_598067 = query.getOrDefault("oauth_token")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "oauth_token", valid_598067
  var valid_598068 = query.getOrDefault("callback")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "callback", valid_598068
  var valid_598069 = query.getOrDefault("access_token")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "access_token", valid_598069
  var valid_598070 = query.getOrDefault("uploadType")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "uploadType", valid_598070
  var valid_598071 = query.getOrDefault("deviceIds")
  valid_598071 = validateParameter(valid_598071, JArray, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "deviceIds", valid_598071
  var valid_598072 = query.getOrDefault("key")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "key", valid_598072
  var valid_598073 = query.getOrDefault("fieldMask")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "fieldMask", valid_598073
  var valid_598074 = query.getOrDefault("$.xgafv")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = newJString("1"))
  if valid_598074 != nil:
    section.add "$.xgafv", valid_598074
  var valid_598075 = query.getOrDefault("pageSize")
  valid_598075 = validateParameter(valid_598075, JInt, required = false, default = nil)
  if valid_598075 != nil:
    section.add "pageSize", valid_598075
  var valid_598076 = query.getOrDefault("deviceNumIds")
  valid_598076 = validateParameter(valid_598076, JArray, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "deviceNumIds", valid_598076
  var valid_598077 = query.getOrDefault("prettyPrint")
  valid_598077 = validateParameter(valid_598077, JBool, required = false,
                                 default = newJBool(true))
  if valid_598077 != nil:
    section.add "prettyPrint", valid_598077
  var valid_598078 = query.getOrDefault("bearer_token")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "bearer_token", valid_598078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598079: Call_CloudiotProjectsLocationsRegistriesDevicesList_598057;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List devices in a device registry.
  ## 
  let valid = call_598079.validator(path, query, header, formData, body)
  let scheme = call_598079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598079.url(scheme.get, call_598079.host, call_598079.base,
                         call_598079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598079, url, valid)

proc call*(call_598080: Call_CloudiotProjectsLocationsRegistriesDevicesList_598057;
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
  var path_598081 = newJObject()
  var query_598082 = newJObject()
  add(query_598082, "upload_protocol", newJString(uploadProtocol))
  add(query_598082, "fields", newJString(fields))
  add(query_598082, "pageToken", newJString(pageToken))
  add(query_598082, "quotaUser", newJString(quotaUser))
  add(query_598082, "alt", newJString(alt))
  add(query_598082, "pp", newJBool(pp))
  add(query_598082, "oauth_token", newJString(oauthToken))
  add(query_598082, "callback", newJString(callback))
  add(query_598082, "access_token", newJString(accessToken))
  add(query_598082, "uploadType", newJString(uploadType))
  add(path_598081, "parent", newJString(parent))
  if deviceIds != nil:
    query_598082.add "deviceIds", deviceIds
  add(query_598082, "key", newJString(key))
  add(query_598082, "fieldMask", newJString(fieldMask))
  add(query_598082, "$.xgafv", newJString(Xgafv))
  add(query_598082, "pageSize", newJInt(pageSize))
  if deviceNumIds != nil:
    query_598082.add "deviceNumIds", deviceNumIds
  add(query_598082, "prettyPrint", newJBool(prettyPrint))
  add(query_598082, "bearer_token", newJString(bearerToken))
  result = call_598080.call(path_598081, query_598082, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesDevicesList* = Call_CloudiotProjectsLocationsRegistriesDevicesList_598057(
    name: "cloudiotProjectsLocationsRegistriesDevicesList",
    meth: HttpMethod.HttpGet, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{parent}/devices",
    validator: validate_CloudiotProjectsLocationsRegistriesDevicesList_598058,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesDevicesList_598059,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesCreate_598129 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesCreate_598131(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesCreate_598130(path: JsonNode;
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
  var valid_598132 = path.getOrDefault("parent")
  valid_598132 = validateParameter(valid_598132, JString, required = true,
                                 default = nil)
  if valid_598132 != nil:
    section.add "parent", valid_598132
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
  var valid_598133 = query.getOrDefault("upload_protocol")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "upload_protocol", valid_598133
  var valid_598134 = query.getOrDefault("fields")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "fields", valid_598134
  var valid_598135 = query.getOrDefault("quotaUser")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "quotaUser", valid_598135
  var valid_598136 = query.getOrDefault("alt")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = newJString("json"))
  if valid_598136 != nil:
    section.add "alt", valid_598136
  var valid_598137 = query.getOrDefault("pp")
  valid_598137 = validateParameter(valid_598137, JBool, required = false,
                                 default = newJBool(true))
  if valid_598137 != nil:
    section.add "pp", valid_598137
  var valid_598138 = query.getOrDefault("oauth_token")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "oauth_token", valid_598138
  var valid_598139 = query.getOrDefault("callback")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "callback", valid_598139
  var valid_598140 = query.getOrDefault("access_token")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "access_token", valid_598140
  var valid_598141 = query.getOrDefault("uploadType")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "uploadType", valid_598141
  var valid_598142 = query.getOrDefault("key")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "key", valid_598142
  var valid_598143 = query.getOrDefault("$.xgafv")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = newJString("1"))
  if valid_598143 != nil:
    section.add "$.xgafv", valid_598143
  var valid_598144 = query.getOrDefault("prettyPrint")
  valid_598144 = validateParameter(valid_598144, JBool, required = false,
                                 default = newJBool(true))
  if valid_598144 != nil:
    section.add "prettyPrint", valid_598144
  var valid_598145 = query.getOrDefault("bearer_token")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "bearer_token", valid_598145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598147: Call_CloudiotProjectsLocationsRegistriesCreate_598129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a device registry that contains devices.
  ## 
  let valid = call_598147.validator(path, query, header, formData, body)
  let scheme = call_598147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598147.url(scheme.get, call_598147.host, call_598147.base,
                         call_598147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598147, url, valid)

proc call*(call_598148: Call_CloudiotProjectsLocationsRegistriesCreate_598129;
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
  var path_598149 = newJObject()
  var query_598150 = newJObject()
  var body_598151 = newJObject()
  add(query_598150, "upload_protocol", newJString(uploadProtocol))
  add(query_598150, "fields", newJString(fields))
  add(query_598150, "quotaUser", newJString(quotaUser))
  add(query_598150, "alt", newJString(alt))
  add(query_598150, "pp", newJBool(pp))
  add(query_598150, "oauth_token", newJString(oauthToken))
  add(query_598150, "callback", newJString(callback))
  add(query_598150, "access_token", newJString(accessToken))
  add(query_598150, "uploadType", newJString(uploadType))
  add(path_598149, "parent", newJString(parent))
  add(query_598150, "key", newJString(key))
  add(query_598150, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598151 = body
  add(query_598150, "prettyPrint", newJBool(prettyPrint))
  add(query_598150, "bearer_token", newJString(bearerToken))
  result = call_598148.call(path_598149, query_598150, nil, nil, body_598151)

var cloudiotProjectsLocationsRegistriesCreate* = Call_CloudiotProjectsLocationsRegistriesCreate_598129(
    name: "cloudiotProjectsLocationsRegistriesCreate", meth: HttpMethod.HttpPost,
    host: "cloudiot.googleapis.com", route: "/v1beta1/{parent}/registries",
    validator: validate_CloudiotProjectsLocationsRegistriesCreate_598130,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesCreate_598131,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesList_598106 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesList_598108(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesList_598107(path: JsonNode;
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
  var valid_598109 = path.getOrDefault("parent")
  valid_598109 = validateParameter(valid_598109, JString, required = true,
                                 default = nil)
  if valid_598109 != nil:
    section.add "parent", valid_598109
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
  var valid_598110 = query.getOrDefault("upload_protocol")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = nil)
  if valid_598110 != nil:
    section.add "upload_protocol", valid_598110
  var valid_598111 = query.getOrDefault("fields")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "fields", valid_598111
  var valid_598112 = query.getOrDefault("pageToken")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "pageToken", valid_598112
  var valid_598113 = query.getOrDefault("quotaUser")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = nil)
  if valid_598113 != nil:
    section.add "quotaUser", valid_598113
  var valid_598114 = query.getOrDefault("alt")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = newJString("json"))
  if valid_598114 != nil:
    section.add "alt", valid_598114
  var valid_598115 = query.getOrDefault("pp")
  valid_598115 = validateParameter(valid_598115, JBool, required = false,
                                 default = newJBool(true))
  if valid_598115 != nil:
    section.add "pp", valid_598115
  var valid_598116 = query.getOrDefault("oauth_token")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "oauth_token", valid_598116
  var valid_598117 = query.getOrDefault("callback")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "callback", valid_598117
  var valid_598118 = query.getOrDefault("access_token")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "access_token", valid_598118
  var valid_598119 = query.getOrDefault("uploadType")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "uploadType", valid_598119
  var valid_598120 = query.getOrDefault("key")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "key", valid_598120
  var valid_598121 = query.getOrDefault("$.xgafv")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = newJString("1"))
  if valid_598121 != nil:
    section.add "$.xgafv", valid_598121
  var valid_598122 = query.getOrDefault("pageSize")
  valid_598122 = validateParameter(valid_598122, JInt, required = false, default = nil)
  if valid_598122 != nil:
    section.add "pageSize", valid_598122
  var valid_598123 = query.getOrDefault("prettyPrint")
  valid_598123 = validateParameter(valid_598123, JBool, required = false,
                                 default = newJBool(true))
  if valid_598123 != nil:
    section.add "prettyPrint", valid_598123
  var valid_598124 = query.getOrDefault("bearer_token")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "bearer_token", valid_598124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598125: Call_CloudiotProjectsLocationsRegistriesList_598106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists device registries.
  ## 
  let valid = call_598125.validator(path, query, header, formData, body)
  let scheme = call_598125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598125.url(scheme.get, call_598125.host, call_598125.base,
                         call_598125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598125, url, valid)

proc call*(call_598126: Call_CloudiotProjectsLocationsRegistriesList_598106;
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
  var path_598127 = newJObject()
  var query_598128 = newJObject()
  add(query_598128, "upload_protocol", newJString(uploadProtocol))
  add(query_598128, "fields", newJString(fields))
  add(query_598128, "pageToken", newJString(pageToken))
  add(query_598128, "quotaUser", newJString(quotaUser))
  add(query_598128, "alt", newJString(alt))
  add(query_598128, "pp", newJBool(pp))
  add(query_598128, "oauth_token", newJString(oauthToken))
  add(query_598128, "callback", newJString(callback))
  add(query_598128, "access_token", newJString(accessToken))
  add(query_598128, "uploadType", newJString(uploadType))
  add(path_598127, "parent", newJString(parent))
  add(query_598128, "key", newJString(key))
  add(query_598128, "$.xgafv", newJString(Xgafv))
  add(query_598128, "pageSize", newJInt(pageSize))
  add(query_598128, "prettyPrint", newJBool(prettyPrint))
  add(query_598128, "bearer_token", newJString(bearerToken))
  result = call_598126.call(path_598127, query_598128, nil, nil, nil)

var cloudiotProjectsLocationsRegistriesList* = Call_CloudiotProjectsLocationsRegistriesList_598106(
    name: "cloudiotProjectsLocationsRegistriesList", meth: HttpMethod.HttpGet,
    host: "cloudiot.googleapis.com", route: "/v1beta1/{parent}/registries",
    validator: validate_CloudiotProjectsLocationsRegistriesList_598107, base: "/",
    url: url_CloudiotProjectsLocationsRegistriesList_598108,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesGetIamPolicy_598152 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesGetIamPolicy_598154(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesGetIamPolicy_598153(
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
  var valid_598155 = path.getOrDefault("resource")
  valid_598155 = validateParameter(valid_598155, JString, required = true,
                                 default = nil)
  if valid_598155 != nil:
    section.add "resource", valid_598155
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
  var valid_598156 = query.getOrDefault("upload_protocol")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "upload_protocol", valid_598156
  var valid_598157 = query.getOrDefault("fields")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "fields", valid_598157
  var valid_598158 = query.getOrDefault("quotaUser")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "quotaUser", valid_598158
  var valid_598159 = query.getOrDefault("alt")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = newJString("json"))
  if valid_598159 != nil:
    section.add "alt", valid_598159
  var valid_598160 = query.getOrDefault("pp")
  valid_598160 = validateParameter(valid_598160, JBool, required = false,
                                 default = newJBool(true))
  if valid_598160 != nil:
    section.add "pp", valid_598160
  var valid_598161 = query.getOrDefault("oauth_token")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "oauth_token", valid_598161
  var valid_598162 = query.getOrDefault("callback")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "callback", valid_598162
  var valid_598163 = query.getOrDefault("access_token")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "access_token", valid_598163
  var valid_598164 = query.getOrDefault("uploadType")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = nil)
  if valid_598164 != nil:
    section.add "uploadType", valid_598164
  var valid_598165 = query.getOrDefault("key")
  valid_598165 = validateParameter(valid_598165, JString, required = false,
                                 default = nil)
  if valid_598165 != nil:
    section.add "key", valid_598165
  var valid_598166 = query.getOrDefault("$.xgafv")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = newJString("1"))
  if valid_598166 != nil:
    section.add "$.xgafv", valid_598166
  var valid_598167 = query.getOrDefault("prettyPrint")
  valid_598167 = validateParameter(valid_598167, JBool, required = false,
                                 default = newJBool(true))
  if valid_598167 != nil:
    section.add "prettyPrint", valid_598167
  var valid_598168 = query.getOrDefault("bearer_token")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = nil)
  if valid_598168 != nil:
    section.add "bearer_token", valid_598168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598170: Call_CloudiotProjectsLocationsRegistriesGetIamPolicy_598152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_598170.validator(path, query, header, formData, body)
  let scheme = call_598170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598170.url(scheme.get, call_598170.host, call_598170.base,
                         call_598170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598170, url, valid)

proc call*(call_598171: Call_CloudiotProjectsLocationsRegistriesGetIamPolicy_598152;
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
  var path_598172 = newJObject()
  var query_598173 = newJObject()
  var body_598174 = newJObject()
  add(query_598173, "upload_protocol", newJString(uploadProtocol))
  add(query_598173, "fields", newJString(fields))
  add(query_598173, "quotaUser", newJString(quotaUser))
  add(query_598173, "alt", newJString(alt))
  add(query_598173, "pp", newJBool(pp))
  add(query_598173, "oauth_token", newJString(oauthToken))
  add(query_598173, "callback", newJString(callback))
  add(query_598173, "access_token", newJString(accessToken))
  add(query_598173, "uploadType", newJString(uploadType))
  add(query_598173, "key", newJString(key))
  add(query_598173, "$.xgafv", newJString(Xgafv))
  add(path_598172, "resource", newJString(resource))
  if body != nil:
    body_598174 = body
  add(query_598173, "prettyPrint", newJBool(prettyPrint))
  add(query_598173, "bearer_token", newJString(bearerToken))
  result = call_598171.call(path_598172, query_598173, nil, nil, body_598174)

var cloudiotProjectsLocationsRegistriesGetIamPolicy* = Call_CloudiotProjectsLocationsRegistriesGetIamPolicy_598152(
    name: "cloudiotProjectsLocationsRegistriesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_CloudiotProjectsLocationsRegistriesGetIamPolicy_598153,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesGetIamPolicy_598154,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesSetIamPolicy_598175 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesSetIamPolicy_598177(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesSetIamPolicy_598176(
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
  var valid_598178 = path.getOrDefault("resource")
  valid_598178 = validateParameter(valid_598178, JString, required = true,
                                 default = nil)
  if valid_598178 != nil:
    section.add "resource", valid_598178
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
  var valid_598179 = query.getOrDefault("upload_protocol")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "upload_protocol", valid_598179
  var valid_598180 = query.getOrDefault("fields")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "fields", valid_598180
  var valid_598181 = query.getOrDefault("quotaUser")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = nil)
  if valid_598181 != nil:
    section.add "quotaUser", valid_598181
  var valid_598182 = query.getOrDefault("alt")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = newJString("json"))
  if valid_598182 != nil:
    section.add "alt", valid_598182
  var valid_598183 = query.getOrDefault("pp")
  valid_598183 = validateParameter(valid_598183, JBool, required = false,
                                 default = newJBool(true))
  if valid_598183 != nil:
    section.add "pp", valid_598183
  var valid_598184 = query.getOrDefault("oauth_token")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "oauth_token", valid_598184
  var valid_598185 = query.getOrDefault("callback")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "callback", valid_598185
  var valid_598186 = query.getOrDefault("access_token")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "access_token", valid_598186
  var valid_598187 = query.getOrDefault("uploadType")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = nil)
  if valid_598187 != nil:
    section.add "uploadType", valid_598187
  var valid_598188 = query.getOrDefault("key")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = nil)
  if valid_598188 != nil:
    section.add "key", valid_598188
  var valid_598189 = query.getOrDefault("$.xgafv")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = newJString("1"))
  if valid_598189 != nil:
    section.add "$.xgafv", valid_598189
  var valid_598190 = query.getOrDefault("prettyPrint")
  valid_598190 = validateParameter(valid_598190, JBool, required = false,
                                 default = newJBool(true))
  if valid_598190 != nil:
    section.add "prettyPrint", valid_598190
  var valid_598191 = query.getOrDefault("bearer_token")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "bearer_token", valid_598191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598193: Call_CloudiotProjectsLocationsRegistriesSetIamPolicy_598175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_598193.validator(path, query, header, formData, body)
  let scheme = call_598193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598193.url(scheme.get, call_598193.host, call_598193.base,
                         call_598193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598193, url, valid)

proc call*(call_598194: Call_CloudiotProjectsLocationsRegistriesSetIamPolicy_598175;
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
  var path_598195 = newJObject()
  var query_598196 = newJObject()
  var body_598197 = newJObject()
  add(query_598196, "upload_protocol", newJString(uploadProtocol))
  add(query_598196, "fields", newJString(fields))
  add(query_598196, "quotaUser", newJString(quotaUser))
  add(query_598196, "alt", newJString(alt))
  add(query_598196, "pp", newJBool(pp))
  add(query_598196, "oauth_token", newJString(oauthToken))
  add(query_598196, "callback", newJString(callback))
  add(query_598196, "access_token", newJString(accessToken))
  add(query_598196, "uploadType", newJString(uploadType))
  add(query_598196, "key", newJString(key))
  add(query_598196, "$.xgafv", newJString(Xgafv))
  add(path_598195, "resource", newJString(resource))
  if body != nil:
    body_598197 = body
  add(query_598196, "prettyPrint", newJBool(prettyPrint))
  add(query_598196, "bearer_token", newJString(bearerToken))
  result = call_598194.call(path_598195, query_598196, nil, nil, body_598197)

var cloudiotProjectsLocationsRegistriesSetIamPolicy* = Call_CloudiotProjectsLocationsRegistriesSetIamPolicy_598175(
    name: "cloudiotProjectsLocationsRegistriesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_CloudiotProjectsLocationsRegistriesSetIamPolicy_598176,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesSetIamPolicy_598177,
    schemes: {Scheme.Https})
type
  Call_CloudiotProjectsLocationsRegistriesTestIamPermissions_598198 = ref object of OpenApiRestCall_597408
proc url_CloudiotProjectsLocationsRegistriesTestIamPermissions_598200(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudiotProjectsLocationsRegistriesTestIamPermissions_598199(
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
  var valid_598201 = path.getOrDefault("resource")
  valid_598201 = validateParameter(valid_598201, JString, required = true,
                                 default = nil)
  if valid_598201 != nil:
    section.add "resource", valid_598201
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
  var valid_598202 = query.getOrDefault("upload_protocol")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = nil)
  if valid_598202 != nil:
    section.add "upload_protocol", valid_598202
  var valid_598203 = query.getOrDefault("fields")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "fields", valid_598203
  var valid_598204 = query.getOrDefault("quotaUser")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "quotaUser", valid_598204
  var valid_598205 = query.getOrDefault("alt")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = newJString("json"))
  if valid_598205 != nil:
    section.add "alt", valid_598205
  var valid_598206 = query.getOrDefault("pp")
  valid_598206 = validateParameter(valid_598206, JBool, required = false,
                                 default = newJBool(true))
  if valid_598206 != nil:
    section.add "pp", valid_598206
  var valid_598207 = query.getOrDefault("oauth_token")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = nil)
  if valid_598207 != nil:
    section.add "oauth_token", valid_598207
  var valid_598208 = query.getOrDefault("callback")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "callback", valid_598208
  var valid_598209 = query.getOrDefault("access_token")
  valid_598209 = validateParameter(valid_598209, JString, required = false,
                                 default = nil)
  if valid_598209 != nil:
    section.add "access_token", valid_598209
  var valid_598210 = query.getOrDefault("uploadType")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "uploadType", valid_598210
  var valid_598211 = query.getOrDefault("key")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = nil)
  if valid_598211 != nil:
    section.add "key", valid_598211
  var valid_598212 = query.getOrDefault("$.xgafv")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = newJString("1"))
  if valid_598212 != nil:
    section.add "$.xgafv", valid_598212
  var valid_598213 = query.getOrDefault("prettyPrint")
  valid_598213 = validateParameter(valid_598213, JBool, required = false,
                                 default = newJBool(true))
  if valid_598213 != nil:
    section.add "prettyPrint", valid_598213
  var valid_598214 = query.getOrDefault("bearer_token")
  valid_598214 = validateParameter(valid_598214, JString, required = false,
                                 default = nil)
  if valid_598214 != nil:
    section.add "bearer_token", valid_598214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598216: Call_CloudiotProjectsLocationsRegistriesTestIamPermissions_598198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  let valid = call_598216.validator(path, query, header, formData, body)
  let scheme = call_598216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598216.url(scheme.get, call_598216.host, call_598216.base,
                         call_598216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598216, url, valid)

proc call*(call_598217: Call_CloudiotProjectsLocationsRegistriesTestIamPermissions_598198;
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
  var path_598218 = newJObject()
  var query_598219 = newJObject()
  var body_598220 = newJObject()
  add(query_598219, "upload_protocol", newJString(uploadProtocol))
  add(query_598219, "fields", newJString(fields))
  add(query_598219, "quotaUser", newJString(quotaUser))
  add(query_598219, "alt", newJString(alt))
  add(query_598219, "pp", newJBool(pp))
  add(query_598219, "oauth_token", newJString(oauthToken))
  add(query_598219, "callback", newJString(callback))
  add(query_598219, "access_token", newJString(accessToken))
  add(query_598219, "uploadType", newJString(uploadType))
  add(query_598219, "key", newJString(key))
  add(query_598219, "$.xgafv", newJString(Xgafv))
  add(path_598218, "resource", newJString(resource))
  if body != nil:
    body_598220 = body
  add(query_598219, "prettyPrint", newJBool(prettyPrint))
  add(query_598219, "bearer_token", newJString(bearerToken))
  result = call_598217.call(path_598218, query_598219, nil, nil, body_598220)

var cloudiotProjectsLocationsRegistriesTestIamPermissions* = Call_CloudiotProjectsLocationsRegistriesTestIamPermissions_598198(
    name: "cloudiotProjectsLocationsRegistriesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudiot.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_CloudiotProjectsLocationsRegistriesTestIamPermissions_598199,
    base: "/", url: url_CloudiotProjectsLocationsRegistriesTestIamPermissions_598200,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
