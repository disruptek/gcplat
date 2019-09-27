
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "cloudprofiler"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudprofilerProjectsProfilesPatch_597677 = ref object of OpenApiRestCall_597408
proc url_CloudprofilerProjectsProfilesPatch_597679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprofilerProjectsProfilesPatch_597678(path: JsonNode;
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
  var valid_597828 = query.getOrDefault("$.xgafv")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = newJString("1"))
  if valid_597828 != nil:
    section.add "$.xgafv", valid_597828
  var valid_597829 = query.getOrDefault("prettyPrint")
  valid_597829 = validateParameter(valid_597829, JBool, required = false,
                                 default = newJBool(true))
  if valid_597829 != nil:
    section.add "prettyPrint", valid_597829
  var valid_597830 = query.getOrDefault("updateMask")
  valid_597830 = validateParameter(valid_597830, JString, required = false,
                                 default = nil)
  if valid_597830 != nil:
    section.add "updateMask", valid_597830
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

proc call*(call_597854: Call_CloudprofilerProjectsProfilesPatch_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## UpdateProfile updates the profile bytes and labels on the profile resource
  ## created in the online mode. Updating the bytes for profiles created in the
  ## offline mode is currently not supported: the profile content must be
  ## provided at the time of the profile creation.
  ## 
  let valid = call_597854.validator(path, query, header, formData, body)
  let scheme = call_597854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597854.url(scheme.get, call_597854.host, call_597854.base,
                         call_597854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597854, url, valid)

proc call*(call_597925: Call_CloudprofilerProjectsProfilesPatch_597677;
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
  var path_597926 = newJObject()
  var query_597928 = newJObject()
  var body_597929 = newJObject()
  add(query_597928, "upload_protocol", newJString(uploadProtocol))
  add(query_597928, "fields", newJString(fields))
  add(query_597928, "quotaUser", newJString(quotaUser))
  add(path_597926, "name", newJString(name))
  add(query_597928, "alt", newJString(alt))
  add(query_597928, "oauth_token", newJString(oauthToken))
  add(query_597928, "callback", newJString(callback))
  add(query_597928, "access_token", newJString(accessToken))
  add(query_597928, "uploadType", newJString(uploadType))
  add(query_597928, "key", newJString(key))
  add(query_597928, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597929 = body
  add(query_597928, "prettyPrint", newJBool(prettyPrint))
  add(query_597928, "updateMask", newJString(updateMask))
  result = call_597925.call(path_597926, query_597928, nil, nil, body_597929)

var cloudprofilerProjectsProfilesPatch* = Call_CloudprofilerProjectsProfilesPatch_597677(
    name: "cloudprofilerProjectsProfilesPatch", meth: HttpMethod.HttpPatch,
    host: "cloudprofiler.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudprofilerProjectsProfilesPatch_597678, base: "/",
    url: url_CloudprofilerProjectsProfilesPatch_597679, schemes: {Scheme.Https})
type
  Call_CloudprofilerProjectsProfilesCreate_597968 = ref object of OpenApiRestCall_597408
proc url_CloudprofilerProjectsProfilesCreate_597970(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprofilerProjectsProfilesCreate_597969(path: JsonNode;
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
  var valid_597971 = path.getOrDefault("parent")
  valid_597971 = validateParameter(valid_597971, JString, required = true,
                                 default = nil)
  if valid_597971 != nil:
    section.add "parent", valid_597971
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
  var valid_597972 = query.getOrDefault("upload_protocol")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "upload_protocol", valid_597972
  var valid_597973 = query.getOrDefault("fields")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "fields", valid_597973
  var valid_597974 = query.getOrDefault("quotaUser")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "quotaUser", valid_597974
  var valid_597975 = query.getOrDefault("alt")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = newJString("json"))
  if valid_597975 != nil:
    section.add "alt", valid_597975
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

proc call*(call_597984: Call_CloudprofilerProjectsProfilesCreate_597968;
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
  let valid = call_597984.validator(path, query, header, formData, body)
  let scheme = call_597984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597984.url(scheme.get, call_597984.host, call_597984.base,
                         call_597984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597984, url, valid)

proc call*(call_597985: Call_CloudprofilerProjectsProfilesCreate_597968;
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
  var path_597986 = newJObject()
  var query_597987 = newJObject()
  var body_597988 = newJObject()
  add(query_597987, "upload_protocol", newJString(uploadProtocol))
  add(query_597987, "fields", newJString(fields))
  add(query_597987, "quotaUser", newJString(quotaUser))
  add(query_597987, "alt", newJString(alt))
  add(query_597987, "oauth_token", newJString(oauthToken))
  add(query_597987, "callback", newJString(callback))
  add(query_597987, "access_token", newJString(accessToken))
  add(query_597987, "uploadType", newJString(uploadType))
  add(path_597986, "parent", newJString(parent))
  add(query_597987, "key", newJString(key))
  add(query_597987, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597988 = body
  add(query_597987, "prettyPrint", newJBool(prettyPrint))
  result = call_597985.call(path_597986, query_597987, nil, nil, body_597988)

var cloudprofilerProjectsProfilesCreate* = Call_CloudprofilerProjectsProfilesCreate_597968(
    name: "cloudprofilerProjectsProfilesCreate", meth: HttpMethod.HttpPost,
    host: "cloudprofiler.googleapis.com", route: "/v2/{parent}/profiles",
    validator: validate_CloudprofilerProjectsProfilesCreate_597969, base: "/",
    url: url_CloudprofilerProjectsProfilesCreate_597970, schemes: {Scheme.Https})
type
  Call_CloudprofilerProjectsProfilesCreateOffline_597989 = ref object of OpenApiRestCall_597408
proc url_CloudprofilerProjectsProfilesCreateOffline_597991(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudprofilerProjectsProfilesCreateOffline_597990(path: JsonNode;
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
  var valid_597992 = path.getOrDefault("parent")
  valid_597992 = validateParameter(valid_597992, JString, required = true,
                                 default = nil)
  if valid_597992 != nil:
    section.add "parent", valid_597992
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
  var valid_597993 = query.getOrDefault("upload_protocol")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "upload_protocol", valid_597993
  var valid_597994 = query.getOrDefault("fields")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "fields", valid_597994
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

proc call*(call_598005: Call_CloudprofilerProjectsProfilesCreateOffline_597989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## CreateOfflineProfile creates a new profile resource in the offline mode.
  ## The client provides the profile to create along with the profile bytes, the
  ## server records it.
  ## 
  let valid = call_598005.validator(path, query, header, formData, body)
  let scheme = call_598005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598005.url(scheme.get, call_598005.host, call_598005.base,
                         call_598005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598005, url, valid)

proc call*(call_598006: Call_CloudprofilerProjectsProfilesCreateOffline_597989;
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
  var path_598007 = newJObject()
  var query_598008 = newJObject()
  var body_598009 = newJObject()
  add(query_598008, "upload_protocol", newJString(uploadProtocol))
  add(query_598008, "fields", newJString(fields))
  add(query_598008, "quotaUser", newJString(quotaUser))
  add(query_598008, "alt", newJString(alt))
  add(query_598008, "oauth_token", newJString(oauthToken))
  add(query_598008, "callback", newJString(callback))
  add(query_598008, "access_token", newJString(accessToken))
  add(query_598008, "uploadType", newJString(uploadType))
  add(path_598007, "parent", newJString(parent))
  add(query_598008, "key", newJString(key))
  add(query_598008, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598009 = body
  add(query_598008, "prettyPrint", newJBool(prettyPrint))
  result = call_598006.call(path_598007, query_598008, nil, nil, body_598009)

var cloudprofilerProjectsProfilesCreateOffline* = Call_CloudprofilerProjectsProfilesCreateOffline_597989(
    name: "cloudprofilerProjectsProfilesCreateOffline", meth: HttpMethod.HttpPost,
    host: "cloudprofiler.googleapis.com",
    route: "/v2/{parent}/profiles:createOffline",
    validator: validate_CloudprofilerProjectsProfilesCreateOffline_597990,
    base: "/", url: url_CloudprofilerProjectsProfilesCreateOffline_597991,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
