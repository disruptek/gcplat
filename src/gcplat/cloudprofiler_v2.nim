
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Stackdriver Profiler
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages continuous profiling information.
## 
## https://cloud.google.com/profiler/
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
  gcpServiceName = "cloudprofiler"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudprofilerProjectsProfilesPatch_579677 = ref object of OpenApiRestCall_579408
proc url_CloudprofilerProjectsProfilesPatch_579679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprofilerProjectsProfilesPatch_579678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## UpdateProfile updates the profile bytes and labels on the profile resource
  ## created in the online mode. Updating the bytes for profiles created in the
  ## offline mode is currently not supported: the profile content must be
  ## provided at the time of the profile creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Output only. Opaque, server-assigned, unique ID for this profile.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Field mask used to specify the fields to be overwritten. Currently only
  ## profile_bytes and labels fields are supported by UpdateProfile, so only
  ## those fields can be specified in the mask. When no mask is provided, all
  ## fields are overwritten.
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
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("prettyPrint")
  valid_579829 = validateParameter(valid_579829, JBool, required = false,
                                 default = newJBool(true))
  if valid_579829 != nil:
    section.add "prettyPrint", valid_579829
  var valid_579830 = query.getOrDefault("updateMask")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "updateMask", valid_579830
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

proc call*(call_579854: Call_CloudprofilerProjectsProfilesPatch_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## UpdateProfile updates the profile bytes and labels on the profile resource
  ## created in the online mode. Updating the bytes for profiles created in the
  ## offline mode is currently not supported: the profile content must be
  ## provided at the time of the profile creation.
  ## 
  let valid = call_579854.validator(path, query, header, formData, body)
  let scheme = call_579854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579854.url(scheme.get, call_579854.host, call_579854.base,
                         call_579854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579854, url, valid)

proc call*(call_579925: Call_CloudprofilerProjectsProfilesPatch_579677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## cloudprofilerProjectsProfilesPatch
  ## UpdateProfile updates the profile bytes and labels on the profile resource
  ## created in the online mode. Updating the bytes for profiles created in the
  ## offline mode is currently not supported: the profile content must be
  ## provided at the time of the profile creation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Output only. Opaque, server-assigned, unique ID for this profile.
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
  ##             : Field mask used to specify the fields to be overwritten. Currently only
  ## profile_bytes and labels fields are supported by UpdateProfile, so only
  ## those fields can be specified in the mask. When no mask is provided, all
  ## fields are overwritten.
  var path_579926 = newJObject()
  var query_579928 = newJObject()
  var body_579929 = newJObject()
  add(query_579928, "upload_protocol", newJString(uploadProtocol))
  add(query_579928, "fields", newJString(fields))
  add(query_579928, "quotaUser", newJString(quotaUser))
  add(path_579926, "name", newJString(name))
  add(query_579928, "alt", newJString(alt))
  add(query_579928, "oauth_token", newJString(oauthToken))
  add(query_579928, "callback", newJString(callback))
  add(query_579928, "access_token", newJString(accessToken))
  add(query_579928, "uploadType", newJString(uploadType))
  add(query_579928, "key", newJString(key))
  add(query_579928, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579929 = body
  add(query_579928, "prettyPrint", newJBool(prettyPrint))
  add(query_579928, "updateMask", newJString(updateMask))
  result = call_579925.call(path_579926, query_579928, nil, nil, body_579929)

var cloudprofilerProjectsProfilesPatch* = Call_CloudprofilerProjectsProfilesPatch_579677(
    name: "cloudprofilerProjectsProfilesPatch", meth: HttpMethod.HttpPatch,
    host: "cloudprofiler.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudprofilerProjectsProfilesPatch_579678, base: "/",
    url: url_CloudprofilerProjectsProfilesPatch_579679, schemes: {Scheme.Https})
type
  Call_CloudprofilerProjectsProfilesCreate_579968 = ref object of OpenApiRestCall_579408
proc url_CloudprofilerProjectsProfilesCreate_579970(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprofilerProjectsProfilesCreate_579969(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## CreateProfile creates a new profile resource in the online mode.
  ## 
  ## The server ensures that the new profiles are created at a constant rate per
  ## deployment, so the creation request may hang for some time until the next
  ## profile session is available.
  ## 
  ## The request may fail with ABORTED error if the creation is not available
  ## within ~1m, the response will indicate the duration of the backoff the
  ## client should take before attempting creating a profile again. The backoff
  ## duration is returned in google.rpc.RetryInfo extension on the response
  ## status. To a gRPC client, the extension will be return as a
  ## binary-serialized proto in the trailing metadata item named
  ## "google.rpc.retryinfo-bin".
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent project to create the profile in.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579971 = path.getOrDefault("parent")
  valid_579971 = validateParameter(valid_579971, JString, required = true,
                                 default = nil)
  if valid_579971 != nil:
    section.add "parent", valid_579971
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
  var valid_579972 = query.getOrDefault("upload_protocol")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "upload_protocol", valid_579972
  var valid_579973 = query.getOrDefault("fields")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "fields", valid_579973
  var valid_579974 = query.getOrDefault("quotaUser")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "quotaUser", valid_579974
  var valid_579975 = query.getOrDefault("alt")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = newJString("json"))
  if valid_579975 != nil:
    section.add "alt", valid_579975
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

proc call*(call_579984: Call_CloudprofilerProjectsProfilesCreate_579968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## CreateProfile creates a new profile resource in the online mode.
  ## 
  ## The server ensures that the new profiles are created at a constant rate per
  ## deployment, so the creation request may hang for some time until the next
  ## profile session is available.
  ## 
  ## The request may fail with ABORTED error if the creation is not available
  ## within ~1m, the response will indicate the duration of the backoff the
  ## client should take before attempting creating a profile again. The backoff
  ## duration is returned in google.rpc.RetryInfo extension on the response
  ## status. To a gRPC client, the extension will be return as a
  ## binary-serialized proto in the trailing metadata item named
  ## "google.rpc.retryinfo-bin".
  ## 
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_CloudprofilerProjectsProfilesCreate_579968;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprofilerProjectsProfilesCreate
  ## CreateProfile creates a new profile resource in the online mode.
  ## 
  ## The server ensures that the new profiles are created at a constant rate per
  ## deployment, so the creation request may hang for some time until the next
  ## profile session is available.
  ## 
  ## The request may fail with ABORTED error if the creation is not available
  ## within ~1m, the response will indicate the duration of the backoff the
  ## client should take before attempting creating a profile again. The backoff
  ## duration is returned in google.rpc.RetryInfo extension on the response
  ## status. To a gRPC client, the extension will be return as a
  ## binary-serialized proto in the trailing metadata item named
  ## "google.rpc.retryinfo-bin".
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
  ##         : Parent project to create the profile in.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579986 = newJObject()
  var query_579987 = newJObject()
  var body_579988 = newJObject()
  add(query_579987, "upload_protocol", newJString(uploadProtocol))
  add(query_579987, "fields", newJString(fields))
  add(query_579987, "quotaUser", newJString(quotaUser))
  add(query_579987, "alt", newJString(alt))
  add(query_579987, "oauth_token", newJString(oauthToken))
  add(query_579987, "callback", newJString(callback))
  add(query_579987, "access_token", newJString(accessToken))
  add(query_579987, "uploadType", newJString(uploadType))
  add(path_579986, "parent", newJString(parent))
  add(query_579987, "key", newJString(key))
  add(query_579987, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579988 = body
  add(query_579987, "prettyPrint", newJBool(prettyPrint))
  result = call_579985.call(path_579986, query_579987, nil, nil, body_579988)

var cloudprofilerProjectsProfilesCreate* = Call_CloudprofilerProjectsProfilesCreate_579968(
    name: "cloudprofilerProjectsProfilesCreate", meth: HttpMethod.HttpPost,
    host: "cloudprofiler.googleapis.com", route: "/v2/{parent}/profiles",
    validator: validate_CloudprofilerProjectsProfilesCreate_579969, base: "/",
    url: url_CloudprofilerProjectsProfilesCreate_579970, schemes: {Scheme.Https})
type
  Call_CloudprofilerProjectsProfilesCreateOffline_579989 = ref object of OpenApiRestCall_579408
proc url_CloudprofilerProjectsProfilesCreateOffline_579991(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/profiles:createOffline")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprofilerProjectsProfilesCreateOffline_579990(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## CreateOfflineProfile creates a new profile resource in the offline mode.
  ## The client provides the profile to create along with the profile bytes, the
  ## server records it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent project to create the profile in.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579992 = path.getOrDefault("parent")
  valid_579992 = validateParameter(valid_579992, JString, required = true,
                                 default = nil)
  if valid_579992 != nil:
    section.add "parent", valid_579992
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
  var valid_579993 = query.getOrDefault("upload_protocol")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "upload_protocol", valid_579993
  var valid_579994 = query.getOrDefault("fields")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "fields", valid_579994
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

proc call*(call_580005: Call_CloudprofilerProjectsProfilesCreateOffline_579989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## CreateOfflineProfile creates a new profile resource in the offline mode.
  ## The client provides the profile to create along with the profile bytes, the
  ## server records it.
  ## 
  let valid = call_580005.validator(path, query, header, formData, body)
  let scheme = call_580005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580005.url(scheme.get, call_580005.host, call_580005.base,
                         call_580005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580005, url, valid)

proc call*(call_580006: Call_CloudprofilerProjectsProfilesCreateOffline_579989;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudprofilerProjectsProfilesCreateOffline
  ## CreateOfflineProfile creates a new profile resource in the offline mode.
  ## The client provides the profile to create along with the profile bytes, the
  ## server records it.
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
  ##         : Parent project to create the profile in.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580007 = newJObject()
  var query_580008 = newJObject()
  var body_580009 = newJObject()
  add(query_580008, "upload_protocol", newJString(uploadProtocol))
  add(query_580008, "fields", newJString(fields))
  add(query_580008, "quotaUser", newJString(quotaUser))
  add(query_580008, "alt", newJString(alt))
  add(query_580008, "oauth_token", newJString(oauthToken))
  add(query_580008, "callback", newJString(callback))
  add(query_580008, "access_token", newJString(accessToken))
  add(query_580008, "uploadType", newJString(uploadType))
  add(path_580007, "parent", newJString(parent))
  add(query_580008, "key", newJString(key))
  add(query_580008, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580009 = body
  add(query_580008, "prettyPrint", newJBool(prettyPrint))
  result = call_580006.call(path_580007, query_580008, nil, nil, body_580009)

var cloudprofilerProjectsProfilesCreateOffline* = Call_CloudprofilerProjectsProfilesCreateOffline_579989(
    name: "cloudprofilerProjectsProfilesCreateOffline", meth: HttpMethod.HttpPost,
    host: "cloudprofiler.googleapis.com",
    route: "/v2/{parent}/profiles:createOffline",
    validator: validate_CloudprofilerProjectsProfilesCreateOffline_579990,
    base: "/", url: url_CloudprofilerProjectsProfilesCreateOffline_579991,
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
