
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Build
## version: v1alpha1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Creates and manages builds on Google Cloud Platform.
## 
## https://cloud.google.com/cloud-build/docs/
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
  gcpServiceName = "cloudbuild"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudbuildProjectsWorkerPoolsGet_579677 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsWorkerPoolsGet_579679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsWorkerPoolsGet_579678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about a `WorkerPool`.
  ## 
  ## This API is experimental.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The field will contain name of the resource requested, for example:
  ## "projects/project-1/workerPools/workerpool-name"
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579852: Call_CloudbuildProjectsWorkerPoolsGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about a `WorkerPool`.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_579852.validator(path, query, header, formData, body)
  let scheme = call_579852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579852.url(scheme.get, call_579852.host, call_579852.base,
                         call_579852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579852, url, valid)

proc call*(call_579923: Call_CloudbuildProjectsWorkerPoolsGet_579677; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudbuildProjectsWorkerPoolsGet
  ## Returns information about a `WorkerPool`.
  ## 
  ## This API is experimental.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The field will contain name of the resource requested, for example:
  ## "projects/project-1/workerPools/workerpool-name"
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
  var path_579924 = newJObject()
  var query_579926 = newJObject()
  add(query_579926, "upload_protocol", newJString(uploadProtocol))
  add(query_579926, "fields", newJString(fields))
  add(query_579926, "quotaUser", newJString(quotaUser))
  add(path_579924, "name", newJString(name))
  add(query_579926, "alt", newJString(alt))
  add(query_579926, "oauth_token", newJString(oauthToken))
  add(query_579926, "callback", newJString(callback))
  add(query_579926, "access_token", newJString(accessToken))
  add(query_579926, "uploadType", newJString(uploadType))
  add(query_579926, "key", newJString(key))
  add(query_579926, "$.xgafv", newJString(Xgafv))
  add(query_579926, "prettyPrint", newJBool(prettyPrint))
  result = call_579923.call(path_579924, query_579926, nil, nil, nil)

var cloudbuildProjectsWorkerPoolsGet* = Call_CloudbuildProjectsWorkerPoolsGet_579677(
    name: "cloudbuildProjectsWorkerPoolsGet", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_CloudbuildProjectsWorkerPoolsGet_579678, base: "/",
    url: url_CloudbuildProjectsWorkerPoolsGet_579679, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsWorkerPoolsPatch_579984 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsWorkerPoolsPatch_579986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsWorkerPoolsPatch_579985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a `WorkerPool`.
  ## 
  ## This API is experimental.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The field will contain name of the resource requested, for example:
  ## "projects/project-1/workerPools/workerpool-name"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579987 = path.getOrDefault("name")
  valid_579987 = validateParameter(valid_579987, JString, required = true,
                                 default = nil)
  if valid_579987 != nil:
    section.add "name", valid_579987
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
  var valid_579988 = query.getOrDefault("upload_protocol")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "upload_protocol", valid_579988
  var valid_579989 = query.getOrDefault("fields")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "fields", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("callback")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "callback", valid_579993
  var valid_579994 = query.getOrDefault("access_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "access_token", valid_579994
  var valid_579995 = query.getOrDefault("uploadType")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "uploadType", valid_579995
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("$.xgafv")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("1"))
  if valid_579997 != nil:
    section.add "$.xgafv", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
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

proc call*(call_580000: Call_CloudbuildProjectsWorkerPoolsPatch_579984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a `WorkerPool`.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_580000.validator(path, query, header, formData, body)
  let scheme = call_580000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580000.url(scheme.get, call_580000.host, call_580000.base,
                         call_580000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580000, url, valid)

proc call*(call_580001: Call_CloudbuildProjectsWorkerPoolsPatch_579984;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudbuildProjectsWorkerPoolsPatch
  ## Update a `WorkerPool`.
  ## 
  ## This API is experimental.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The field will contain name of the resource requested, for example:
  ## "projects/project-1/workerPools/workerpool-name"
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
  var path_580002 = newJObject()
  var query_580003 = newJObject()
  var body_580004 = newJObject()
  add(query_580003, "upload_protocol", newJString(uploadProtocol))
  add(query_580003, "fields", newJString(fields))
  add(query_580003, "quotaUser", newJString(quotaUser))
  add(path_580002, "name", newJString(name))
  add(query_580003, "alt", newJString(alt))
  add(query_580003, "oauth_token", newJString(oauthToken))
  add(query_580003, "callback", newJString(callback))
  add(query_580003, "access_token", newJString(accessToken))
  add(query_580003, "uploadType", newJString(uploadType))
  add(query_580003, "key", newJString(key))
  add(query_580003, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580004 = body
  add(query_580003, "prettyPrint", newJBool(prettyPrint))
  result = call_580001.call(path_580002, query_580003, nil, nil, body_580004)

var cloudbuildProjectsWorkerPoolsPatch* = Call_CloudbuildProjectsWorkerPoolsPatch_579984(
    name: "cloudbuildProjectsWorkerPoolsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudbuild.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_CloudbuildProjectsWorkerPoolsPatch_579985, base: "/",
    url: url_CloudbuildProjectsWorkerPoolsPatch_579986, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsWorkerPoolsDelete_579965 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsWorkerPoolsDelete_579967(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsWorkerPoolsDelete_579966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a `WorkerPool` by its project ID and WorkerPool name.
  ## 
  ## This API is experimental.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The field will contain name of the resource requested, for example:
  ## "projects/project-1/workerPools/workerpool-name"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579968 = path.getOrDefault("name")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "name", valid_579968
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
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("access_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "access_token", valid_579975
  var valid_579976 = query.getOrDefault("uploadType")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "uploadType", valid_579976
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("$.xgafv")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("1"))
  if valid_579978 != nil:
    section.add "$.xgafv", valid_579978
  var valid_579979 = query.getOrDefault("prettyPrint")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(true))
  if valid_579979 != nil:
    section.add "prettyPrint", valid_579979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579980: Call_CloudbuildProjectsWorkerPoolsDelete_579965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a `WorkerPool` by its project ID and WorkerPool name.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_579980.validator(path, query, header, formData, body)
  let scheme = call_579980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579980.url(scheme.get, call_579980.host, call_579980.base,
                         call_579980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579980, url, valid)

proc call*(call_579981: Call_CloudbuildProjectsWorkerPoolsDelete_579965;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudbuildProjectsWorkerPoolsDelete
  ## Deletes a `WorkerPool` by its project ID and WorkerPool name.
  ## 
  ## This API is experimental.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The field will contain name of the resource requested, for example:
  ## "projects/project-1/workerPools/workerpool-name"
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
  var path_579982 = newJObject()
  var query_579983 = newJObject()
  add(query_579983, "upload_protocol", newJString(uploadProtocol))
  add(query_579983, "fields", newJString(fields))
  add(query_579983, "quotaUser", newJString(quotaUser))
  add(path_579982, "name", newJString(name))
  add(query_579983, "alt", newJString(alt))
  add(query_579983, "oauth_token", newJString(oauthToken))
  add(query_579983, "callback", newJString(callback))
  add(query_579983, "access_token", newJString(accessToken))
  add(query_579983, "uploadType", newJString(uploadType))
  add(query_579983, "key", newJString(key))
  add(query_579983, "$.xgafv", newJString(Xgafv))
  add(query_579983, "prettyPrint", newJBool(prettyPrint))
  result = call_579981.call(path_579982, query_579983, nil, nil, nil)

var cloudbuildProjectsWorkerPoolsDelete* = Call_CloudbuildProjectsWorkerPoolsDelete_579965(
    name: "cloudbuildProjectsWorkerPoolsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudbuild.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_CloudbuildProjectsWorkerPoolsDelete_579966, base: "/",
    url: url_CloudbuildProjectsWorkerPoolsDelete_579967, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsWorkerPoolsCreate_580024 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsWorkerPoolsCreate_580026(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/workerPools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsWorkerPoolsCreate_580025(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a `WorkerPool` to run the builds, and returns the new worker pool.
  ## 
  ## This API is experimental.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : ID of the parent project.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580027 = path.getOrDefault("parent")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "parent", valid_580027
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
  var valid_580028 = query.getOrDefault("upload_protocol")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "upload_protocol", valid_580028
  var valid_580029 = query.getOrDefault("fields")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "fields", valid_580029
  var valid_580030 = query.getOrDefault("quotaUser")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "quotaUser", valid_580030
  var valid_580031 = query.getOrDefault("alt")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = newJString("json"))
  if valid_580031 != nil:
    section.add "alt", valid_580031
  var valid_580032 = query.getOrDefault("oauth_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "oauth_token", valid_580032
  var valid_580033 = query.getOrDefault("callback")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "callback", valid_580033
  var valid_580034 = query.getOrDefault("access_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "access_token", valid_580034
  var valid_580035 = query.getOrDefault("uploadType")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "uploadType", valid_580035
  var valid_580036 = query.getOrDefault("key")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "key", valid_580036
  var valid_580037 = query.getOrDefault("$.xgafv")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = newJString("1"))
  if valid_580037 != nil:
    section.add "$.xgafv", valid_580037
  var valid_580038 = query.getOrDefault("prettyPrint")
  valid_580038 = validateParameter(valid_580038, JBool, required = false,
                                 default = newJBool(true))
  if valid_580038 != nil:
    section.add "prettyPrint", valid_580038
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

proc call*(call_580040: Call_CloudbuildProjectsWorkerPoolsCreate_580024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a `WorkerPool` to run the builds, and returns the new worker pool.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_580040.validator(path, query, header, formData, body)
  let scheme = call_580040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580040.url(scheme.get, call_580040.host, call_580040.base,
                         call_580040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580040, url, valid)

proc call*(call_580041: Call_CloudbuildProjectsWorkerPoolsCreate_580024;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudbuildProjectsWorkerPoolsCreate
  ## Creates a `WorkerPool` to run the builds, and returns the new worker pool.
  ## 
  ## This API is experimental.
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
  ##         : ID of the parent project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580042 = newJObject()
  var query_580043 = newJObject()
  var body_580044 = newJObject()
  add(query_580043, "upload_protocol", newJString(uploadProtocol))
  add(query_580043, "fields", newJString(fields))
  add(query_580043, "quotaUser", newJString(quotaUser))
  add(query_580043, "alt", newJString(alt))
  add(query_580043, "oauth_token", newJString(oauthToken))
  add(query_580043, "callback", newJString(callback))
  add(query_580043, "access_token", newJString(accessToken))
  add(query_580043, "uploadType", newJString(uploadType))
  add(path_580042, "parent", newJString(parent))
  add(query_580043, "key", newJString(key))
  add(query_580043, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580044 = body
  add(query_580043, "prettyPrint", newJBool(prettyPrint))
  result = call_580041.call(path_580042, query_580043, nil, nil, body_580044)

var cloudbuildProjectsWorkerPoolsCreate* = Call_CloudbuildProjectsWorkerPoolsCreate_580024(
    name: "cloudbuildProjectsWorkerPoolsCreate", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com", route: "/v1alpha1/{parent}/workerPools",
    validator: validate_CloudbuildProjectsWorkerPoolsCreate_580025, base: "/",
    url: url_CloudbuildProjectsWorkerPoolsCreate_580026, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsWorkerPoolsList_580005 = ref object of OpenApiRestCall_579408
proc url_CloudbuildProjectsWorkerPoolsList_580007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/workerPools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsWorkerPoolsList_580006(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List project's `WorkerPool`s.
  ## 
  ## This API is experimental.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : ID of the parent project.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580008 = path.getOrDefault("parent")
  valid_580008 = validateParameter(valid_580008, JString, required = true,
                                 default = nil)
  if valid_580008 != nil:
    section.add "parent", valid_580008
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
  var valid_580009 = query.getOrDefault("upload_protocol")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "upload_protocol", valid_580009
  var valid_580010 = query.getOrDefault("fields")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "fields", valid_580010
  var valid_580011 = query.getOrDefault("quotaUser")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "quotaUser", valid_580011
  var valid_580012 = query.getOrDefault("alt")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("json"))
  if valid_580012 != nil:
    section.add "alt", valid_580012
  var valid_580013 = query.getOrDefault("oauth_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "oauth_token", valid_580013
  var valid_580014 = query.getOrDefault("callback")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "callback", valid_580014
  var valid_580015 = query.getOrDefault("access_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "access_token", valid_580015
  var valid_580016 = query.getOrDefault("uploadType")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "uploadType", valid_580016
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  var valid_580018 = query.getOrDefault("$.xgafv")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("1"))
  if valid_580018 != nil:
    section.add "$.xgafv", valid_580018
  var valid_580019 = query.getOrDefault("prettyPrint")
  valid_580019 = validateParameter(valid_580019, JBool, required = false,
                                 default = newJBool(true))
  if valid_580019 != nil:
    section.add "prettyPrint", valid_580019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580020: Call_CloudbuildProjectsWorkerPoolsList_580005;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List project's `WorkerPool`s.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_CloudbuildProjectsWorkerPoolsList_580005;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudbuildProjectsWorkerPoolsList
  ## List project's `WorkerPool`s.
  ## 
  ## This API is experimental.
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
  ##         : ID of the parent project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580022 = newJObject()
  var query_580023 = newJObject()
  add(query_580023, "upload_protocol", newJString(uploadProtocol))
  add(query_580023, "fields", newJString(fields))
  add(query_580023, "quotaUser", newJString(quotaUser))
  add(query_580023, "alt", newJString(alt))
  add(query_580023, "oauth_token", newJString(oauthToken))
  add(query_580023, "callback", newJString(callback))
  add(query_580023, "access_token", newJString(accessToken))
  add(query_580023, "uploadType", newJString(uploadType))
  add(path_580022, "parent", newJString(parent))
  add(query_580023, "key", newJString(key))
  add(query_580023, "$.xgafv", newJString(Xgafv))
  add(query_580023, "prettyPrint", newJBool(prettyPrint))
  result = call_580021.call(path_580022, query_580023, nil, nil, nil)

var cloudbuildProjectsWorkerPoolsList* = Call_CloudbuildProjectsWorkerPoolsList_580005(
    name: "cloudbuildProjectsWorkerPoolsList", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1alpha1/{parent}/workerPools",
    validator: validate_CloudbuildProjectsWorkerPoolsList_580006, base: "/",
    url: url_CloudbuildProjectsWorkerPoolsList_580007, schemes: {Scheme.Https})
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
