
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "cloudbuild"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudbuildProjectsWorkerPoolsGet_597677 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsWorkerPoolsGet_597679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsWorkerPoolsGet_597678(path: JsonNode;
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597852: Call_CloudbuildProjectsWorkerPoolsGet_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about a `WorkerPool`.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_597852.validator(path, query, header, formData, body)
  let scheme = call_597852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597852.url(scheme.get, call_597852.host, call_597852.base,
                         call_597852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597852, url, valid)

proc call*(call_597923: Call_CloudbuildProjectsWorkerPoolsGet_597677; name: string;
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
  var path_597924 = newJObject()
  var query_597926 = newJObject()
  add(query_597926, "upload_protocol", newJString(uploadProtocol))
  add(query_597926, "fields", newJString(fields))
  add(query_597926, "quotaUser", newJString(quotaUser))
  add(path_597924, "name", newJString(name))
  add(query_597926, "alt", newJString(alt))
  add(query_597926, "oauth_token", newJString(oauthToken))
  add(query_597926, "callback", newJString(callback))
  add(query_597926, "access_token", newJString(accessToken))
  add(query_597926, "uploadType", newJString(uploadType))
  add(query_597926, "key", newJString(key))
  add(query_597926, "$.xgafv", newJString(Xgafv))
  add(query_597926, "prettyPrint", newJBool(prettyPrint))
  result = call_597923.call(path_597924, query_597926, nil, nil, nil)

var cloudbuildProjectsWorkerPoolsGet* = Call_CloudbuildProjectsWorkerPoolsGet_597677(
    name: "cloudbuildProjectsWorkerPoolsGet", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_CloudbuildProjectsWorkerPoolsGet_597678, base: "/",
    url: url_CloudbuildProjectsWorkerPoolsGet_597679, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsWorkerPoolsPatch_597984 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsWorkerPoolsPatch_597986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsWorkerPoolsPatch_597985(path: JsonNode;
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
  var valid_597987 = path.getOrDefault("name")
  valid_597987 = validateParameter(valid_597987, JString, required = true,
                                 default = nil)
  if valid_597987 != nil:
    section.add "name", valid_597987
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
  var valid_597988 = query.getOrDefault("upload_protocol")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = nil)
  if valid_597988 != nil:
    section.add "upload_protocol", valid_597988
  var valid_597989 = query.getOrDefault("fields")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "fields", valid_597989
  var valid_597990 = query.getOrDefault("quotaUser")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "quotaUser", valid_597990
  var valid_597991 = query.getOrDefault("alt")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = newJString("json"))
  if valid_597991 != nil:
    section.add "alt", valid_597991
  var valid_597992 = query.getOrDefault("oauth_token")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "oauth_token", valid_597992
  var valid_597993 = query.getOrDefault("callback")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "callback", valid_597993
  var valid_597994 = query.getOrDefault("access_token")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "access_token", valid_597994
  var valid_597995 = query.getOrDefault("uploadType")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "uploadType", valid_597995
  var valid_597996 = query.getOrDefault("key")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "key", valid_597996
  var valid_597997 = query.getOrDefault("$.xgafv")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = newJString("1"))
  if valid_597997 != nil:
    section.add "$.xgafv", valid_597997
  var valid_597998 = query.getOrDefault("prettyPrint")
  valid_597998 = validateParameter(valid_597998, JBool, required = false,
                                 default = newJBool(true))
  if valid_597998 != nil:
    section.add "prettyPrint", valid_597998
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

proc call*(call_598000: Call_CloudbuildProjectsWorkerPoolsPatch_597984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a `WorkerPool`.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_598000.validator(path, query, header, formData, body)
  let scheme = call_598000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598000.url(scheme.get, call_598000.host, call_598000.base,
                         call_598000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598000, url, valid)

proc call*(call_598001: Call_CloudbuildProjectsWorkerPoolsPatch_597984;
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
  var path_598002 = newJObject()
  var query_598003 = newJObject()
  var body_598004 = newJObject()
  add(query_598003, "upload_protocol", newJString(uploadProtocol))
  add(query_598003, "fields", newJString(fields))
  add(query_598003, "quotaUser", newJString(quotaUser))
  add(path_598002, "name", newJString(name))
  add(query_598003, "alt", newJString(alt))
  add(query_598003, "oauth_token", newJString(oauthToken))
  add(query_598003, "callback", newJString(callback))
  add(query_598003, "access_token", newJString(accessToken))
  add(query_598003, "uploadType", newJString(uploadType))
  add(query_598003, "key", newJString(key))
  add(query_598003, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598004 = body
  add(query_598003, "prettyPrint", newJBool(prettyPrint))
  result = call_598001.call(path_598002, query_598003, nil, nil, body_598004)

var cloudbuildProjectsWorkerPoolsPatch* = Call_CloudbuildProjectsWorkerPoolsPatch_597984(
    name: "cloudbuildProjectsWorkerPoolsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudbuild.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_CloudbuildProjectsWorkerPoolsPatch_597985, base: "/",
    url: url_CloudbuildProjectsWorkerPoolsPatch_597986, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsWorkerPoolsDelete_597965 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsWorkerPoolsDelete_597967(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbuildProjectsWorkerPoolsDelete_597966(path: JsonNode;
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
  var valid_597968 = path.getOrDefault("name")
  valid_597968 = validateParameter(valid_597968, JString, required = true,
                                 default = nil)
  if valid_597968 != nil:
    section.add "name", valid_597968
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
  var valid_597969 = query.getOrDefault("upload_protocol")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "upload_protocol", valid_597969
  var valid_597970 = query.getOrDefault("fields")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "fields", valid_597970
  var valid_597971 = query.getOrDefault("quotaUser")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "quotaUser", valid_597971
  var valid_597972 = query.getOrDefault("alt")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = newJString("json"))
  if valid_597972 != nil:
    section.add "alt", valid_597972
  var valid_597973 = query.getOrDefault("oauth_token")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "oauth_token", valid_597973
  var valid_597974 = query.getOrDefault("callback")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "callback", valid_597974
  var valid_597975 = query.getOrDefault("access_token")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "access_token", valid_597975
  var valid_597976 = query.getOrDefault("uploadType")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "uploadType", valid_597976
  var valid_597977 = query.getOrDefault("key")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "key", valid_597977
  var valid_597978 = query.getOrDefault("$.xgafv")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = newJString("1"))
  if valid_597978 != nil:
    section.add "$.xgafv", valid_597978
  var valid_597979 = query.getOrDefault("prettyPrint")
  valid_597979 = validateParameter(valid_597979, JBool, required = false,
                                 default = newJBool(true))
  if valid_597979 != nil:
    section.add "prettyPrint", valid_597979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597980: Call_CloudbuildProjectsWorkerPoolsDelete_597965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a `WorkerPool` by its project ID and WorkerPool name.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_597980.validator(path, query, header, formData, body)
  let scheme = call_597980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597980.url(scheme.get, call_597980.host, call_597980.base,
                         call_597980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597980, url, valid)

proc call*(call_597981: Call_CloudbuildProjectsWorkerPoolsDelete_597965;
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
  var path_597982 = newJObject()
  var query_597983 = newJObject()
  add(query_597983, "upload_protocol", newJString(uploadProtocol))
  add(query_597983, "fields", newJString(fields))
  add(query_597983, "quotaUser", newJString(quotaUser))
  add(path_597982, "name", newJString(name))
  add(query_597983, "alt", newJString(alt))
  add(query_597983, "oauth_token", newJString(oauthToken))
  add(query_597983, "callback", newJString(callback))
  add(query_597983, "access_token", newJString(accessToken))
  add(query_597983, "uploadType", newJString(uploadType))
  add(query_597983, "key", newJString(key))
  add(query_597983, "$.xgafv", newJString(Xgafv))
  add(query_597983, "prettyPrint", newJBool(prettyPrint))
  result = call_597981.call(path_597982, query_597983, nil, nil, nil)

var cloudbuildProjectsWorkerPoolsDelete* = Call_CloudbuildProjectsWorkerPoolsDelete_597965(
    name: "cloudbuildProjectsWorkerPoolsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudbuild.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_CloudbuildProjectsWorkerPoolsDelete_597966, base: "/",
    url: url_CloudbuildProjectsWorkerPoolsDelete_597967, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsWorkerPoolsCreate_598024 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsWorkerPoolsCreate_598026(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbuildProjectsWorkerPoolsCreate_598025(path: JsonNode;
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
  var valid_598027 = path.getOrDefault("parent")
  valid_598027 = validateParameter(valid_598027, JString, required = true,
                                 default = nil)
  if valid_598027 != nil:
    section.add "parent", valid_598027
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
  var valid_598028 = query.getOrDefault("upload_protocol")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "upload_protocol", valid_598028
  var valid_598029 = query.getOrDefault("fields")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "fields", valid_598029
  var valid_598030 = query.getOrDefault("quotaUser")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "quotaUser", valid_598030
  var valid_598031 = query.getOrDefault("alt")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = newJString("json"))
  if valid_598031 != nil:
    section.add "alt", valid_598031
  var valid_598032 = query.getOrDefault("oauth_token")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "oauth_token", valid_598032
  var valid_598033 = query.getOrDefault("callback")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "callback", valid_598033
  var valid_598034 = query.getOrDefault("access_token")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "access_token", valid_598034
  var valid_598035 = query.getOrDefault("uploadType")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "uploadType", valid_598035
  var valid_598036 = query.getOrDefault("key")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "key", valid_598036
  var valid_598037 = query.getOrDefault("$.xgafv")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = newJString("1"))
  if valid_598037 != nil:
    section.add "$.xgafv", valid_598037
  var valid_598038 = query.getOrDefault("prettyPrint")
  valid_598038 = validateParameter(valid_598038, JBool, required = false,
                                 default = newJBool(true))
  if valid_598038 != nil:
    section.add "prettyPrint", valid_598038
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

proc call*(call_598040: Call_CloudbuildProjectsWorkerPoolsCreate_598024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a `WorkerPool` to run the builds, and returns the new worker pool.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_598040.validator(path, query, header, formData, body)
  let scheme = call_598040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598040.url(scheme.get, call_598040.host, call_598040.base,
                         call_598040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598040, url, valid)

proc call*(call_598041: Call_CloudbuildProjectsWorkerPoolsCreate_598024;
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
  var path_598042 = newJObject()
  var query_598043 = newJObject()
  var body_598044 = newJObject()
  add(query_598043, "upload_protocol", newJString(uploadProtocol))
  add(query_598043, "fields", newJString(fields))
  add(query_598043, "quotaUser", newJString(quotaUser))
  add(query_598043, "alt", newJString(alt))
  add(query_598043, "oauth_token", newJString(oauthToken))
  add(query_598043, "callback", newJString(callback))
  add(query_598043, "access_token", newJString(accessToken))
  add(query_598043, "uploadType", newJString(uploadType))
  add(path_598042, "parent", newJString(parent))
  add(query_598043, "key", newJString(key))
  add(query_598043, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598044 = body
  add(query_598043, "prettyPrint", newJBool(prettyPrint))
  result = call_598041.call(path_598042, query_598043, nil, nil, body_598044)

var cloudbuildProjectsWorkerPoolsCreate* = Call_CloudbuildProjectsWorkerPoolsCreate_598024(
    name: "cloudbuildProjectsWorkerPoolsCreate", meth: HttpMethod.HttpPost,
    host: "cloudbuild.googleapis.com", route: "/v1alpha1/{parent}/workerPools",
    validator: validate_CloudbuildProjectsWorkerPoolsCreate_598025, base: "/",
    url: url_CloudbuildProjectsWorkerPoolsCreate_598026, schemes: {Scheme.Https})
type
  Call_CloudbuildProjectsWorkerPoolsList_598005 = ref object of OpenApiRestCall_597408
proc url_CloudbuildProjectsWorkerPoolsList_598007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbuildProjectsWorkerPoolsList_598006(path: JsonNode;
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
  var valid_598008 = path.getOrDefault("parent")
  valid_598008 = validateParameter(valid_598008, JString, required = true,
                                 default = nil)
  if valid_598008 != nil:
    section.add "parent", valid_598008
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
  var valid_598009 = query.getOrDefault("upload_protocol")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "upload_protocol", valid_598009
  var valid_598010 = query.getOrDefault("fields")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "fields", valid_598010
  var valid_598011 = query.getOrDefault("quotaUser")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "quotaUser", valid_598011
  var valid_598012 = query.getOrDefault("alt")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = newJString("json"))
  if valid_598012 != nil:
    section.add "alt", valid_598012
  var valid_598013 = query.getOrDefault("oauth_token")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "oauth_token", valid_598013
  var valid_598014 = query.getOrDefault("callback")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "callback", valid_598014
  var valid_598015 = query.getOrDefault("access_token")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "access_token", valid_598015
  var valid_598016 = query.getOrDefault("uploadType")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "uploadType", valid_598016
  var valid_598017 = query.getOrDefault("key")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "key", valid_598017
  var valid_598018 = query.getOrDefault("$.xgafv")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = newJString("1"))
  if valid_598018 != nil:
    section.add "$.xgafv", valid_598018
  var valid_598019 = query.getOrDefault("prettyPrint")
  valid_598019 = validateParameter(valid_598019, JBool, required = false,
                                 default = newJBool(true))
  if valid_598019 != nil:
    section.add "prettyPrint", valid_598019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598020: Call_CloudbuildProjectsWorkerPoolsList_598005;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List project's `WorkerPool`s.
  ## 
  ## This API is experimental.
  ## 
  let valid = call_598020.validator(path, query, header, formData, body)
  let scheme = call_598020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598020.url(scheme.get, call_598020.host, call_598020.base,
                         call_598020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598020, url, valid)

proc call*(call_598021: Call_CloudbuildProjectsWorkerPoolsList_598005;
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
  var path_598022 = newJObject()
  var query_598023 = newJObject()
  add(query_598023, "upload_protocol", newJString(uploadProtocol))
  add(query_598023, "fields", newJString(fields))
  add(query_598023, "quotaUser", newJString(quotaUser))
  add(query_598023, "alt", newJString(alt))
  add(query_598023, "oauth_token", newJString(oauthToken))
  add(query_598023, "callback", newJString(callback))
  add(query_598023, "access_token", newJString(accessToken))
  add(query_598023, "uploadType", newJString(uploadType))
  add(path_598022, "parent", newJString(parent))
  add(query_598023, "key", newJString(key))
  add(query_598023, "$.xgafv", newJString(Xgafv))
  add(query_598023, "prettyPrint", newJBool(prettyPrint))
  result = call_598021.call(path_598022, query_598023, nil, nil, nil)

var cloudbuildProjectsWorkerPoolsList* = Call_CloudbuildProjectsWorkerPoolsList_598005(
    name: "cloudbuildProjectsWorkerPoolsList", meth: HttpMethod.HttpGet,
    host: "cloudbuild.googleapis.com", route: "/v1alpha1/{parent}/workerPools",
    validator: validate_CloudbuildProjectsWorkerPoolsList_598006, base: "/",
    url: url_CloudbuildProjectsWorkerPoolsList_598007, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
