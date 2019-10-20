
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Cloud Machine Learning Engine
## version: v1
## termsOfService: (not provided)
## license: (not provided)
## 
## An API to enable creating and using machine learning models.
## 
## https://cloud.google.com/ml/
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
  gcpServiceName = "ml"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MlProjectsJobsGet_578610 = ref object of OpenApiRestCall_578339
proc url_MlProjectsJobsGet_578612(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_MlProjectsJobsGet_578611(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Describes a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the job to get the description of.
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("pp")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "pp", valid_578753
  var valid_578754 = query.getOrDefault("prettyPrint")
  valid_578754 = validateParameter(valid_578754, JBool, required = false,
                                 default = newJBool(true))
  if valid_578754 != nil:
    section.add "prettyPrint", valid_578754
  var valid_578755 = query.getOrDefault("oauth_token")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "oauth_token", valid_578755
  var valid_578756 = query.getOrDefault("$.xgafv")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("1"))
  if valid_578756 != nil:
    section.add "$.xgafv", valid_578756
  var valid_578757 = query.getOrDefault("bearer_token")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "bearer_token", valid_578757
  var valid_578758 = query.getOrDefault("alt")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = newJString("json"))
  if valid_578758 != nil:
    section.add "alt", valid_578758
  var valid_578759 = query.getOrDefault("uploadType")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "uploadType", valid_578759
  var valid_578760 = query.getOrDefault("quotaUser")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "quotaUser", valid_578760
  var valid_578761 = query.getOrDefault("callback")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "callback", valid_578761
  var valid_578762 = query.getOrDefault("fields")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "fields", valid_578762
  var valid_578763 = query.getOrDefault("access_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "access_token", valid_578763
  var valid_578764 = query.getOrDefault("upload_protocol")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "upload_protocol", valid_578764
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578787: Call_MlProjectsJobsGet_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Describes a job.
  ## 
  let valid = call_578787.validator(path, query, header, formData, body)
  let scheme = call_578787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578787.url(scheme.get, call_578787.host, call_578787.base,
                         call_578787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578787, url, valid)

proc call*(call_578858: Call_MlProjectsJobsGet_578610; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## mlProjectsJobsGet
  ## Describes a job.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the job to get the description of.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578859 = newJObject()
  var query_578861 = newJObject()
  add(query_578861, "key", newJString(key))
  add(query_578861, "pp", newJBool(pp))
  add(query_578861, "prettyPrint", newJBool(prettyPrint))
  add(query_578861, "oauth_token", newJString(oauthToken))
  add(query_578861, "$.xgafv", newJString(Xgafv))
  add(query_578861, "bearer_token", newJString(bearerToken))
  add(query_578861, "alt", newJString(alt))
  add(query_578861, "uploadType", newJString(uploadType))
  add(query_578861, "quotaUser", newJString(quotaUser))
  add(path_578859, "name", newJString(name))
  add(query_578861, "callback", newJString(callback))
  add(query_578861, "fields", newJString(fields))
  add(query_578861, "access_token", newJString(accessToken))
  add(query_578861, "upload_protocol", newJString(uploadProtocol))
  result = call_578858.call(path_578859, query_578861, nil, nil, nil)

var mlProjectsJobsGet* = Call_MlProjectsJobsGet_578610(name: "mlProjectsJobsGet",
    meth: HttpMethod.HttpGet, host: "ml.googleapis.com", route: "/v1/{name}",
    validator: validate_MlProjectsJobsGet_578611, base: "/",
    url: url_MlProjectsJobsGet_578612, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsPatch_578921 = ref object of OpenApiRestCall_578339
proc url_MlProjectsJobsPatch_578923(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_MlProjectsJobsPatch_578922(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a specific job resource.
  ## 
  ## Currently the only supported fields to update are `labels`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The job name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578924 = path.getOrDefault("name")
  valid_578924 = validateParameter(valid_578924, JString, required = true,
                                 default = nil)
  if valid_578924 != nil:
    section.add "name", valid_578924
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Required. Specifies the path, relative to `Job`, of the field to update.
  ## To adopt etag mechanism, include `etag` field in the mask, and include the
  ## `etag` value in your job resource.
  ## 
  ## For example, to change the labels of a job, the `update_mask` parameter
  ## would be specified as `labels`, `etag`, and the
  ## `PATCH` request body would specify the new value, as follows:
  ##     {
  ##       "labels": {
  ##          "owner": "Google",
  ##          "color": "Blue"
  ##       }
  ##       "etag": "33a64df551425fcc55e4d42a148795d9f25f89d4"
  ##     }
  ## If `etag` matches the one on the server, the labels of the job will be
  ## replaced with the given ones, and the server end `etag` will be
  ## recalculated.
  ## 
  ## Currently the only supported update masks are `labels` and `etag`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578925 = query.getOrDefault("key")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "key", valid_578925
  var valid_578926 = query.getOrDefault("pp")
  valid_578926 = validateParameter(valid_578926, JBool, required = false,
                                 default = newJBool(true))
  if valid_578926 != nil:
    section.add "pp", valid_578926
  var valid_578927 = query.getOrDefault("prettyPrint")
  valid_578927 = validateParameter(valid_578927, JBool, required = false,
                                 default = newJBool(true))
  if valid_578927 != nil:
    section.add "prettyPrint", valid_578927
  var valid_578928 = query.getOrDefault("oauth_token")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "oauth_token", valid_578928
  var valid_578929 = query.getOrDefault("$.xgafv")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = newJString("1"))
  if valid_578929 != nil:
    section.add "$.xgafv", valid_578929
  var valid_578930 = query.getOrDefault("bearer_token")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "bearer_token", valid_578930
  var valid_578931 = query.getOrDefault("alt")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = newJString("json"))
  if valid_578931 != nil:
    section.add "alt", valid_578931
  var valid_578932 = query.getOrDefault("uploadType")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "uploadType", valid_578932
  var valid_578933 = query.getOrDefault("quotaUser")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "quotaUser", valid_578933
  var valid_578934 = query.getOrDefault("updateMask")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "updateMask", valid_578934
  var valid_578935 = query.getOrDefault("callback")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "callback", valid_578935
  var valid_578936 = query.getOrDefault("fields")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "fields", valid_578936
  var valid_578937 = query.getOrDefault("access_token")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "access_token", valid_578937
  var valid_578938 = query.getOrDefault("upload_protocol")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "upload_protocol", valid_578938
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

proc call*(call_578940: Call_MlProjectsJobsPatch_578921; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a specific job resource.
  ## 
  ## Currently the only supported fields to update are `labels`.
  ## 
  let valid = call_578940.validator(path, query, header, formData, body)
  let scheme = call_578940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578940.url(scheme.get, call_578940.host, call_578940.base,
                         call_578940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578940, url, valid)

proc call*(call_578941: Call_MlProjectsJobsPatch_578921; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          updateMask: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## mlProjectsJobsPatch
  ## Updates a specific job resource.
  ## 
  ## Currently the only supported fields to update are `labels`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The job name.
  ##   updateMask: string
  ##             : Required. Specifies the path, relative to `Job`, of the field to update.
  ## To adopt etag mechanism, include `etag` field in the mask, and include the
  ## `etag` value in your job resource.
  ## 
  ## For example, to change the labels of a job, the `update_mask` parameter
  ## would be specified as `labels`, `etag`, and the
  ## `PATCH` request body would specify the new value, as follows:
  ##     {
  ##       "labels": {
  ##          "owner": "Google",
  ##          "color": "Blue"
  ##       }
  ##       "etag": "33a64df551425fcc55e4d42a148795d9f25f89d4"
  ##     }
  ## If `etag` matches the one on the server, the labels of the job will be
  ## replaced with the given ones, and the server end `etag` will be
  ## recalculated.
  ## 
  ## Currently the only supported update masks are `labels` and `etag`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578942 = newJObject()
  var query_578943 = newJObject()
  var body_578944 = newJObject()
  add(query_578943, "key", newJString(key))
  add(query_578943, "pp", newJBool(pp))
  add(query_578943, "prettyPrint", newJBool(prettyPrint))
  add(query_578943, "oauth_token", newJString(oauthToken))
  add(query_578943, "$.xgafv", newJString(Xgafv))
  add(query_578943, "bearer_token", newJString(bearerToken))
  add(query_578943, "alt", newJString(alt))
  add(query_578943, "uploadType", newJString(uploadType))
  add(query_578943, "quotaUser", newJString(quotaUser))
  add(path_578942, "name", newJString(name))
  add(query_578943, "updateMask", newJString(updateMask))
  if body != nil:
    body_578944 = body
  add(query_578943, "callback", newJString(callback))
  add(query_578943, "fields", newJString(fields))
  add(query_578943, "access_token", newJString(accessToken))
  add(query_578943, "upload_protocol", newJString(uploadProtocol))
  result = call_578941.call(path_578942, query_578943, nil, nil, body_578944)

var mlProjectsJobsPatch* = Call_MlProjectsJobsPatch_578921(
    name: "mlProjectsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "ml.googleapis.com", route: "/v1/{name}",
    validator: validate_MlProjectsJobsPatch_578922, base: "/",
    url: url_MlProjectsJobsPatch_578923, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsDelete_578900 = ref object of OpenApiRestCall_578339
proc url_MlProjectsModelsVersionsDelete_578902(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_MlProjectsModelsVersionsDelete_578901(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a model version.
  ## 
  ## Each model can have multiple versions deployed and in use at any given
  ## time. Use this method to remove a single version.
  ## 
  ## Note: You cannot delete the version that is set as the default version
  ## of the model unless it is the only remaining version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the version. You can get the names of all the
  ## versions of a model by calling
  ## 
  ## [projects.models.versions.list](/ml-engine/reference/rest/v1/projects.models.versions/list).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578903 = path.getOrDefault("name")
  valid_578903 = validateParameter(valid_578903, JString, required = true,
                                 default = nil)
  if valid_578903 != nil:
    section.add "name", valid_578903
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578904 = query.getOrDefault("key")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "key", valid_578904
  var valid_578905 = query.getOrDefault("pp")
  valid_578905 = validateParameter(valid_578905, JBool, required = false,
                                 default = newJBool(true))
  if valid_578905 != nil:
    section.add "pp", valid_578905
  var valid_578906 = query.getOrDefault("prettyPrint")
  valid_578906 = validateParameter(valid_578906, JBool, required = false,
                                 default = newJBool(true))
  if valid_578906 != nil:
    section.add "prettyPrint", valid_578906
  var valid_578907 = query.getOrDefault("oauth_token")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "oauth_token", valid_578907
  var valid_578908 = query.getOrDefault("$.xgafv")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = newJString("1"))
  if valid_578908 != nil:
    section.add "$.xgafv", valid_578908
  var valid_578909 = query.getOrDefault("bearer_token")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "bearer_token", valid_578909
  var valid_578910 = query.getOrDefault("alt")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = newJString("json"))
  if valid_578910 != nil:
    section.add "alt", valid_578910
  var valid_578911 = query.getOrDefault("uploadType")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "uploadType", valid_578911
  var valid_578912 = query.getOrDefault("quotaUser")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "quotaUser", valid_578912
  var valid_578913 = query.getOrDefault("callback")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "callback", valid_578913
  var valid_578914 = query.getOrDefault("fields")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "fields", valid_578914
  var valid_578915 = query.getOrDefault("access_token")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "access_token", valid_578915
  var valid_578916 = query.getOrDefault("upload_protocol")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "upload_protocol", valid_578916
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578917: Call_MlProjectsModelsVersionsDelete_578900; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a model version.
  ## 
  ## Each model can have multiple versions deployed and in use at any given
  ## time. Use this method to remove a single version.
  ## 
  ## Note: You cannot delete the version that is set as the default version
  ## of the model unless it is the only remaining version.
  ## 
  let valid = call_578917.validator(path, query, header, formData, body)
  let scheme = call_578917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578917.url(scheme.get, call_578917.host, call_578917.base,
                         call_578917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578917, url, valid)

proc call*(call_578918: Call_MlProjectsModelsVersionsDelete_578900; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## mlProjectsModelsVersionsDelete
  ## Deletes a model version.
  ## 
  ## Each model can have multiple versions deployed and in use at any given
  ## time. Use this method to remove a single version.
  ## 
  ## Note: You cannot delete the version that is set as the default version
  ## of the model unless it is the only remaining version.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the version. You can get the names of all the
  ## versions of a model by calling
  ## 
  ## [projects.models.versions.list](/ml-engine/reference/rest/v1/projects.models.versions/list).
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578919 = newJObject()
  var query_578920 = newJObject()
  add(query_578920, "key", newJString(key))
  add(query_578920, "pp", newJBool(pp))
  add(query_578920, "prettyPrint", newJBool(prettyPrint))
  add(query_578920, "oauth_token", newJString(oauthToken))
  add(query_578920, "$.xgafv", newJString(Xgafv))
  add(query_578920, "bearer_token", newJString(bearerToken))
  add(query_578920, "alt", newJString(alt))
  add(query_578920, "uploadType", newJString(uploadType))
  add(query_578920, "quotaUser", newJString(quotaUser))
  add(path_578919, "name", newJString(name))
  add(query_578920, "callback", newJString(callback))
  add(query_578920, "fields", newJString(fields))
  add(query_578920, "access_token", newJString(accessToken))
  add(query_578920, "upload_protocol", newJString(uploadProtocol))
  result = call_578918.call(path_578919, query_578920, nil, nil, nil)

var mlProjectsModelsVersionsDelete* = Call_MlProjectsModelsVersionsDelete_578900(
    name: "mlProjectsModelsVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "ml.googleapis.com", route: "/v1/{name}",
    validator: validate_MlProjectsModelsVersionsDelete_578901, base: "/",
    url: url_MlProjectsModelsVersionsDelete_578902, schemes: {Scheme.Https})
type
  Call_MlProjectsOperationsList_578945 = ref object of OpenApiRestCall_578339
proc url_MlProjectsOperationsList_578947(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsOperationsList_578946(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation's parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578948 = path.getOrDefault("name")
  valid_578948 = validateParameter(valid_578948, JString, required = true,
                                 default = nil)
  if valid_578948 != nil:
    section.add "name", valid_578948
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578949 = query.getOrDefault("key")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "key", valid_578949
  var valid_578950 = query.getOrDefault("pp")
  valid_578950 = validateParameter(valid_578950, JBool, required = false,
                                 default = newJBool(true))
  if valid_578950 != nil:
    section.add "pp", valid_578950
  var valid_578951 = query.getOrDefault("prettyPrint")
  valid_578951 = validateParameter(valid_578951, JBool, required = false,
                                 default = newJBool(true))
  if valid_578951 != nil:
    section.add "prettyPrint", valid_578951
  var valid_578952 = query.getOrDefault("oauth_token")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "oauth_token", valid_578952
  var valid_578953 = query.getOrDefault("$.xgafv")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = newJString("1"))
  if valid_578953 != nil:
    section.add "$.xgafv", valid_578953
  var valid_578954 = query.getOrDefault("bearer_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "bearer_token", valid_578954
  var valid_578955 = query.getOrDefault("pageSize")
  valid_578955 = validateParameter(valid_578955, JInt, required = false, default = nil)
  if valid_578955 != nil:
    section.add "pageSize", valid_578955
  var valid_578956 = query.getOrDefault("alt")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = newJString("json"))
  if valid_578956 != nil:
    section.add "alt", valid_578956
  var valid_578957 = query.getOrDefault("uploadType")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "uploadType", valid_578957
  var valid_578958 = query.getOrDefault("quotaUser")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "quotaUser", valid_578958
  var valid_578959 = query.getOrDefault("filter")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "filter", valid_578959
  var valid_578960 = query.getOrDefault("pageToken")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "pageToken", valid_578960
  var valid_578961 = query.getOrDefault("callback")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "callback", valid_578961
  var valid_578962 = query.getOrDefault("fields")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "fields", valid_578962
  var valid_578963 = query.getOrDefault("access_token")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "access_token", valid_578963
  var valid_578964 = query.getOrDefault("upload_protocol")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "upload_protocol", valid_578964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578965: Call_MlProjectsOperationsList_578945; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  let valid = call_578965.validator(path, query, header, formData, body)
  let scheme = call_578965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578965.url(scheme.get, call_578965.host, call_578965.base,
                         call_578965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578965, url, valid)

proc call*(call_578966: Call_MlProjectsOperationsList_578945; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## mlProjectsOperationsList
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578967 = newJObject()
  var query_578968 = newJObject()
  add(query_578968, "key", newJString(key))
  add(query_578968, "pp", newJBool(pp))
  add(query_578968, "prettyPrint", newJBool(prettyPrint))
  add(query_578968, "oauth_token", newJString(oauthToken))
  add(query_578968, "$.xgafv", newJString(Xgafv))
  add(query_578968, "bearer_token", newJString(bearerToken))
  add(query_578968, "pageSize", newJInt(pageSize))
  add(query_578968, "alt", newJString(alt))
  add(query_578968, "uploadType", newJString(uploadType))
  add(query_578968, "quotaUser", newJString(quotaUser))
  add(path_578967, "name", newJString(name))
  add(query_578968, "filter", newJString(filter))
  add(query_578968, "pageToken", newJString(pageToken))
  add(query_578968, "callback", newJString(callback))
  add(query_578968, "fields", newJString(fields))
  add(query_578968, "access_token", newJString(accessToken))
  add(query_578968, "upload_protocol", newJString(uploadProtocol))
  result = call_578966.call(path_578967, query_578968, nil, nil, nil)

var mlProjectsOperationsList* = Call_MlProjectsOperationsList_578945(
    name: "mlProjectsOperationsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{name}/operations",
    validator: validate_MlProjectsOperationsList_578946, base: "/",
    url: url_MlProjectsOperationsList_578947, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsCancel_578969 = ref object of OpenApiRestCall_578339
proc url_MlProjectsJobsCancel_578971(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsJobsCancel_578970(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a running job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the job to cancel.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578972 = path.getOrDefault("name")
  valid_578972 = validateParameter(valid_578972, JString, required = true,
                                 default = nil)
  if valid_578972 != nil:
    section.add "name", valid_578972
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578973 = query.getOrDefault("key")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "key", valid_578973
  var valid_578974 = query.getOrDefault("pp")
  valid_578974 = validateParameter(valid_578974, JBool, required = false,
                                 default = newJBool(true))
  if valid_578974 != nil:
    section.add "pp", valid_578974
  var valid_578975 = query.getOrDefault("prettyPrint")
  valid_578975 = validateParameter(valid_578975, JBool, required = false,
                                 default = newJBool(true))
  if valid_578975 != nil:
    section.add "prettyPrint", valid_578975
  var valid_578976 = query.getOrDefault("oauth_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "oauth_token", valid_578976
  var valid_578977 = query.getOrDefault("$.xgafv")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("1"))
  if valid_578977 != nil:
    section.add "$.xgafv", valid_578977
  var valid_578978 = query.getOrDefault("bearer_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "bearer_token", valid_578978
  var valid_578979 = query.getOrDefault("alt")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = newJString("json"))
  if valid_578979 != nil:
    section.add "alt", valid_578979
  var valid_578980 = query.getOrDefault("uploadType")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "uploadType", valid_578980
  var valid_578981 = query.getOrDefault("quotaUser")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "quotaUser", valid_578981
  var valid_578982 = query.getOrDefault("callback")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "callback", valid_578982
  var valid_578983 = query.getOrDefault("fields")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "fields", valid_578983
  var valid_578984 = query.getOrDefault("access_token")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "access_token", valid_578984
  var valid_578985 = query.getOrDefault("upload_protocol")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "upload_protocol", valid_578985
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

proc call*(call_578987: Call_MlProjectsJobsCancel_578969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a running job.
  ## 
  let valid = call_578987.validator(path, query, header, formData, body)
  let scheme = call_578987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578987.url(scheme.get, call_578987.host, call_578987.base,
                         call_578987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578987, url, valid)

proc call*(call_578988: Call_MlProjectsJobsCancel_578969; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## mlProjectsJobsCancel
  ## Cancels a running job.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the job to cancel.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578989 = newJObject()
  var query_578990 = newJObject()
  var body_578991 = newJObject()
  add(query_578990, "key", newJString(key))
  add(query_578990, "pp", newJBool(pp))
  add(query_578990, "prettyPrint", newJBool(prettyPrint))
  add(query_578990, "oauth_token", newJString(oauthToken))
  add(query_578990, "$.xgafv", newJString(Xgafv))
  add(query_578990, "bearer_token", newJString(bearerToken))
  add(query_578990, "alt", newJString(alt))
  add(query_578990, "uploadType", newJString(uploadType))
  add(query_578990, "quotaUser", newJString(quotaUser))
  add(path_578989, "name", newJString(name))
  if body != nil:
    body_578991 = body
  add(query_578990, "callback", newJString(callback))
  add(query_578990, "fields", newJString(fields))
  add(query_578990, "access_token", newJString(accessToken))
  add(query_578990, "upload_protocol", newJString(uploadProtocol))
  result = call_578988.call(path_578989, query_578990, nil, nil, body_578991)

var mlProjectsJobsCancel* = Call_MlProjectsJobsCancel_578969(
    name: "mlProjectsJobsCancel", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_MlProjectsJobsCancel_578970, base: "/",
    url: url_MlProjectsJobsCancel_578971, schemes: {Scheme.Https})
type
  Call_MlProjectsGetConfig_578992 = ref object of OpenApiRestCall_578339
proc url_MlProjectsGetConfig_578994(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":getConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsGetConfig_578993(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get the service account information associated with your project. You need
  ## this information in order to grant the service account persmissions for
  ## the Google Cloud Storage location where you put your model training code
  ## for training the model with Google Cloud Machine Learning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578995 = path.getOrDefault("name")
  valid_578995 = validateParameter(valid_578995, JString, required = true,
                                 default = nil)
  if valid_578995 != nil:
    section.add "name", valid_578995
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578996 = query.getOrDefault("key")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "key", valid_578996
  var valid_578997 = query.getOrDefault("pp")
  valid_578997 = validateParameter(valid_578997, JBool, required = false,
                                 default = newJBool(true))
  if valid_578997 != nil:
    section.add "pp", valid_578997
  var valid_578998 = query.getOrDefault("prettyPrint")
  valid_578998 = validateParameter(valid_578998, JBool, required = false,
                                 default = newJBool(true))
  if valid_578998 != nil:
    section.add "prettyPrint", valid_578998
  var valid_578999 = query.getOrDefault("oauth_token")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "oauth_token", valid_578999
  var valid_579000 = query.getOrDefault("$.xgafv")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = newJString("1"))
  if valid_579000 != nil:
    section.add "$.xgafv", valid_579000
  var valid_579001 = query.getOrDefault("bearer_token")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "bearer_token", valid_579001
  var valid_579002 = query.getOrDefault("alt")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = newJString("json"))
  if valid_579002 != nil:
    section.add "alt", valid_579002
  var valid_579003 = query.getOrDefault("uploadType")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "uploadType", valid_579003
  var valid_579004 = query.getOrDefault("quotaUser")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "quotaUser", valid_579004
  var valid_579005 = query.getOrDefault("callback")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "callback", valid_579005
  var valid_579006 = query.getOrDefault("fields")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "fields", valid_579006
  var valid_579007 = query.getOrDefault("access_token")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "access_token", valid_579007
  var valid_579008 = query.getOrDefault("upload_protocol")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "upload_protocol", valid_579008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579009: Call_MlProjectsGetConfig_578992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the service account information associated with your project. You need
  ## this information in order to grant the service account persmissions for
  ## the Google Cloud Storage location where you put your model training code
  ## for training the model with Google Cloud Machine Learning.
  ## 
  let valid = call_579009.validator(path, query, header, formData, body)
  let scheme = call_579009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579009.url(scheme.get, call_579009.host, call_579009.base,
                         call_579009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579009, url, valid)

proc call*(call_579010: Call_MlProjectsGetConfig_578992; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## mlProjectsGetConfig
  ## Get the service account information associated with your project. You need
  ## this information in order to grant the service account persmissions for
  ## the Google Cloud Storage location where you put your model training code
  ## for training the model with Google Cloud Machine Learning.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The project name.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579011 = newJObject()
  var query_579012 = newJObject()
  add(query_579012, "key", newJString(key))
  add(query_579012, "pp", newJBool(pp))
  add(query_579012, "prettyPrint", newJBool(prettyPrint))
  add(query_579012, "oauth_token", newJString(oauthToken))
  add(query_579012, "$.xgafv", newJString(Xgafv))
  add(query_579012, "bearer_token", newJString(bearerToken))
  add(query_579012, "alt", newJString(alt))
  add(query_579012, "uploadType", newJString(uploadType))
  add(query_579012, "quotaUser", newJString(quotaUser))
  add(path_579011, "name", newJString(name))
  add(query_579012, "callback", newJString(callback))
  add(query_579012, "fields", newJString(fields))
  add(query_579012, "access_token", newJString(accessToken))
  add(query_579012, "upload_protocol", newJString(uploadProtocol))
  result = call_579010.call(path_579011, query_579012, nil, nil, nil)

var mlProjectsGetConfig* = Call_MlProjectsGetConfig_578992(
    name: "mlProjectsGetConfig", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{name}:getConfig",
    validator: validate_MlProjectsGetConfig_578993, base: "/",
    url: url_MlProjectsGetConfig_578994, schemes: {Scheme.Https})
type
  Call_MlProjectsPredict_579013 = ref object of OpenApiRestCall_578339
proc url_MlProjectsPredict_579015(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":predict")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsPredict_579014(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Performs prediction on the data in the request.
  ## Cloud ML Engine implements a custom `predict` verb on top of an HTTP POST
  ## method. For details of the format, see the **guide to the
  ## [predict request format](/ml-engine/docs/v1/predict-request)**.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of a model or a version.
  ## 
  ## Authorization: requires the `predict` permission on the specified resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579016 = path.getOrDefault("name")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "name", valid_579016
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579017 = query.getOrDefault("key")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "key", valid_579017
  var valid_579018 = query.getOrDefault("pp")
  valid_579018 = validateParameter(valid_579018, JBool, required = false,
                                 default = newJBool(true))
  if valid_579018 != nil:
    section.add "pp", valid_579018
  var valid_579019 = query.getOrDefault("prettyPrint")
  valid_579019 = validateParameter(valid_579019, JBool, required = false,
                                 default = newJBool(true))
  if valid_579019 != nil:
    section.add "prettyPrint", valid_579019
  var valid_579020 = query.getOrDefault("oauth_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "oauth_token", valid_579020
  var valid_579021 = query.getOrDefault("$.xgafv")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = newJString("1"))
  if valid_579021 != nil:
    section.add "$.xgafv", valid_579021
  var valid_579022 = query.getOrDefault("bearer_token")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "bearer_token", valid_579022
  var valid_579023 = query.getOrDefault("alt")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = newJString("json"))
  if valid_579023 != nil:
    section.add "alt", valid_579023
  var valid_579024 = query.getOrDefault("uploadType")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "uploadType", valid_579024
  var valid_579025 = query.getOrDefault("quotaUser")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "quotaUser", valid_579025
  var valid_579026 = query.getOrDefault("callback")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "callback", valid_579026
  var valid_579027 = query.getOrDefault("fields")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "fields", valid_579027
  var valid_579028 = query.getOrDefault("access_token")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "access_token", valid_579028
  var valid_579029 = query.getOrDefault("upload_protocol")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "upload_protocol", valid_579029
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

proc call*(call_579031: Call_MlProjectsPredict_579013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs prediction on the data in the request.
  ## Cloud ML Engine implements a custom `predict` verb on top of an HTTP POST
  ## method. For details of the format, see the **guide to the
  ## [predict request format](/ml-engine/docs/v1/predict-request)**.
  ## 
  let valid = call_579031.validator(path, query, header, formData, body)
  let scheme = call_579031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579031.url(scheme.get, call_579031.host, call_579031.base,
                         call_579031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579031, url, valid)

proc call*(call_579032: Call_MlProjectsPredict_579013; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## mlProjectsPredict
  ## Performs prediction on the data in the request.
  ## Cloud ML Engine implements a custom `predict` verb on top of an HTTP POST
  ## method. For details of the format, see the **guide to the
  ## [predict request format](/ml-engine/docs/v1/predict-request)**.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of a model or a version.
  ## 
  ## Authorization: requires the `predict` permission on the specified resource.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579033 = newJObject()
  var query_579034 = newJObject()
  var body_579035 = newJObject()
  add(query_579034, "key", newJString(key))
  add(query_579034, "pp", newJBool(pp))
  add(query_579034, "prettyPrint", newJBool(prettyPrint))
  add(query_579034, "oauth_token", newJString(oauthToken))
  add(query_579034, "$.xgafv", newJString(Xgafv))
  add(query_579034, "bearer_token", newJString(bearerToken))
  add(query_579034, "alt", newJString(alt))
  add(query_579034, "uploadType", newJString(uploadType))
  add(query_579034, "quotaUser", newJString(quotaUser))
  add(path_579033, "name", newJString(name))
  if body != nil:
    body_579035 = body
  add(query_579034, "callback", newJString(callback))
  add(query_579034, "fields", newJString(fields))
  add(query_579034, "access_token", newJString(accessToken))
  add(query_579034, "upload_protocol", newJString(uploadProtocol))
  result = call_579032.call(path_579033, query_579034, nil, nil, body_579035)

var mlProjectsPredict* = Call_MlProjectsPredict_579013(name: "mlProjectsPredict",
    meth: HttpMethod.HttpPost, host: "ml.googleapis.com",
    route: "/v1/{name}:predict", validator: validate_MlProjectsPredict_579014,
    base: "/", url: url_MlProjectsPredict_579015, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsSetDefault_579036 = ref object of OpenApiRestCall_578339
proc url_MlProjectsModelsVersionsSetDefault_579038(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setDefault")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsModelsVersionsSetDefault_579037(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Designates a version to be the default for the model.
  ## 
  ## The default version is used for prediction requests made against the model
  ## that don't specify a version.
  ## 
  ## The first version to be created for a model is automatically set as the
  ## default. You must make any subsequent changes to the default version
  ## setting manually using this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the version to make the default for the model. You
  ## can get the names of all the versions of a model by calling
  ## 
  ## [projects.models.versions.list](/ml-engine/reference/rest/v1/projects.models.versions/list).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579039 = path.getOrDefault("name")
  valid_579039 = validateParameter(valid_579039, JString, required = true,
                                 default = nil)
  if valid_579039 != nil:
    section.add "name", valid_579039
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579040 = query.getOrDefault("key")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "key", valid_579040
  var valid_579041 = query.getOrDefault("pp")
  valid_579041 = validateParameter(valid_579041, JBool, required = false,
                                 default = newJBool(true))
  if valid_579041 != nil:
    section.add "pp", valid_579041
  var valid_579042 = query.getOrDefault("prettyPrint")
  valid_579042 = validateParameter(valid_579042, JBool, required = false,
                                 default = newJBool(true))
  if valid_579042 != nil:
    section.add "prettyPrint", valid_579042
  var valid_579043 = query.getOrDefault("oauth_token")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "oauth_token", valid_579043
  var valid_579044 = query.getOrDefault("$.xgafv")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = newJString("1"))
  if valid_579044 != nil:
    section.add "$.xgafv", valid_579044
  var valid_579045 = query.getOrDefault("bearer_token")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "bearer_token", valid_579045
  var valid_579046 = query.getOrDefault("alt")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = newJString("json"))
  if valid_579046 != nil:
    section.add "alt", valid_579046
  var valid_579047 = query.getOrDefault("uploadType")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "uploadType", valid_579047
  var valid_579048 = query.getOrDefault("quotaUser")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "quotaUser", valid_579048
  var valid_579049 = query.getOrDefault("callback")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "callback", valid_579049
  var valid_579050 = query.getOrDefault("fields")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "fields", valid_579050
  var valid_579051 = query.getOrDefault("access_token")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "access_token", valid_579051
  var valid_579052 = query.getOrDefault("upload_protocol")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "upload_protocol", valid_579052
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

proc call*(call_579054: Call_MlProjectsModelsVersionsSetDefault_579036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Designates a version to be the default for the model.
  ## 
  ## The default version is used for prediction requests made against the model
  ## that don't specify a version.
  ## 
  ## The first version to be created for a model is automatically set as the
  ## default. You must make any subsequent changes to the default version
  ## setting manually using this method.
  ## 
  let valid = call_579054.validator(path, query, header, formData, body)
  let scheme = call_579054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579054.url(scheme.get, call_579054.host, call_579054.base,
                         call_579054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579054, url, valid)

proc call*(call_579055: Call_MlProjectsModelsVersionsSetDefault_579036;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## mlProjectsModelsVersionsSetDefault
  ## Designates a version to be the default for the model.
  ## 
  ## The default version is used for prediction requests made against the model
  ## that don't specify a version.
  ## 
  ## The first version to be created for a model is automatically set as the
  ## default. You must make any subsequent changes to the default version
  ## setting manually using this method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the version to make the default for the model. You
  ## can get the names of all the versions of a model by calling
  ## 
  ## [projects.models.versions.list](/ml-engine/reference/rest/v1/projects.models.versions/list).
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579056 = newJObject()
  var query_579057 = newJObject()
  var body_579058 = newJObject()
  add(query_579057, "key", newJString(key))
  add(query_579057, "pp", newJBool(pp))
  add(query_579057, "prettyPrint", newJBool(prettyPrint))
  add(query_579057, "oauth_token", newJString(oauthToken))
  add(query_579057, "$.xgafv", newJString(Xgafv))
  add(query_579057, "bearer_token", newJString(bearerToken))
  add(query_579057, "alt", newJString(alt))
  add(query_579057, "uploadType", newJString(uploadType))
  add(query_579057, "quotaUser", newJString(quotaUser))
  add(path_579056, "name", newJString(name))
  if body != nil:
    body_579058 = body
  add(query_579057, "callback", newJString(callback))
  add(query_579057, "fields", newJString(fields))
  add(query_579057, "access_token", newJString(accessToken))
  add(query_579057, "upload_protocol", newJString(uploadProtocol))
  result = call_579055.call(path_579056, query_579057, nil, nil, body_579058)

var mlProjectsModelsVersionsSetDefault* = Call_MlProjectsModelsVersionsSetDefault_579036(
    name: "mlProjectsModelsVersionsSetDefault", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{name}:setDefault",
    validator: validate_MlProjectsModelsVersionsSetDefault_579037, base: "/",
    url: url_MlProjectsModelsVersionsSetDefault_579038, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsCreate_579083 = ref object of OpenApiRestCall_578339
proc url_MlProjectsJobsCreate_579085(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsJobsCreate_579084(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a training or a batch prediction job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579086 = path.getOrDefault("parent")
  valid_579086 = validateParameter(valid_579086, JString, required = true,
                                 default = nil)
  if valid_579086 != nil:
    section.add "parent", valid_579086
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579087 = query.getOrDefault("key")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "key", valid_579087
  var valid_579088 = query.getOrDefault("pp")
  valid_579088 = validateParameter(valid_579088, JBool, required = false,
                                 default = newJBool(true))
  if valid_579088 != nil:
    section.add "pp", valid_579088
  var valid_579089 = query.getOrDefault("prettyPrint")
  valid_579089 = validateParameter(valid_579089, JBool, required = false,
                                 default = newJBool(true))
  if valid_579089 != nil:
    section.add "prettyPrint", valid_579089
  var valid_579090 = query.getOrDefault("oauth_token")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "oauth_token", valid_579090
  var valid_579091 = query.getOrDefault("$.xgafv")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = newJString("1"))
  if valid_579091 != nil:
    section.add "$.xgafv", valid_579091
  var valid_579092 = query.getOrDefault("bearer_token")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "bearer_token", valid_579092
  var valid_579093 = query.getOrDefault("alt")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = newJString("json"))
  if valid_579093 != nil:
    section.add "alt", valid_579093
  var valid_579094 = query.getOrDefault("uploadType")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "uploadType", valid_579094
  var valid_579095 = query.getOrDefault("quotaUser")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "quotaUser", valid_579095
  var valid_579096 = query.getOrDefault("callback")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "callback", valid_579096
  var valid_579097 = query.getOrDefault("fields")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "fields", valid_579097
  var valid_579098 = query.getOrDefault("access_token")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "access_token", valid_579098
  var valid_579099 = query.getOrDefault("upload_protocol")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "upload_protocol", valid_579099
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

proc call*(call_579101: Call_MlProjectsJobsCreate_579083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a training or a batch prediction job.
  ## 
  let valid = call_579101.validator(path, query, header, formData, body)
  let scheme = call_579101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579101.url(scheme.get, call_579101.host, call_579101.base,
                         call_579101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579101, url, valid)

proc call*(call_579102: Call_MlProjectsJobsCreate_579083; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## mlProjectsJobsCreate
  ## Creates a training or a batch prediction job.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  ##         : Required. The project name.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579103 = newJObject()
  var query_579104 = newJObject()
  var body_579105 = newJObject()
  add(query_579104, "key", newJString(key))
  add(query_579104, "pp", newJBool(pp))
  add(query_579104, "prettyPrint", newJBool(prettyPrint))
  add(query_579104, "oauth_token", newJString(oauthToken))
  add(query_579104, "$.xgafv", newJString(Xgafv))
  add(query_579104, "bearer_token", newJString(bearerToken))
  add(query_579104, "alt", newJString(alt))
  add(query_579104, "uploadType", newJString(uploadType))
  add(query_579104, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579105 = body
  add(query_579104, "callback", newJString(callback))
  add(path_579103, "parent", newJString(parent))
  add(query_579104, "fields", newJString(fields))
  add(query_579104, "access_token", newJString(accessToken))
  add(query_579104, "upload_protocol", newJString(uploadProtocol))
  result = call_579102.call(path_579103, query_579104, nil, nil, body_579105)

var mlProjectsJobsCreate* = Call_MlProjectsJobsCreate_579083(
    name: "mlProjectsJobsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{parent}/jobs",
    validator: validate_MlProjectsJobsCreate_579084, base: "/",
    url: url_MlProjectsJobsCreate_579085, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsList_579059 = ref object of OpenApiRestCall_578339
proc url_MlProjectsJobsList_579061(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsJobsList_579060(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the jobs in the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the project for which to list jobs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579062 = path.getOrDefault("parent")
  valid_579062 = validateParameter(valid_579062, JString, required = true,
                                 default = nil)
  if valid_579062 != nil:
    section.add "parent", valid_579062
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Optional. The number of jobs to retrieve per "page" of results. If there
  ## are more remaining results than this number, the response message will
  ## contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Optional. Specifies the subset of jobs to retrieve.
  ##   pageToken: JString
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579063 = query.getOrDefault("key")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "key", valid_579063
  var valid_579064 = query.getOrDefault("pp")
  valid_579064 = validateParameter(valid_579064, JBool, required = false,
                                 default = newJBool(true))
  if valid_579064 != nil:
    section.add "pp", valid_579064
  var valid_579065 = query.getOrDefault("prettyPrint")
  valid_579065 = validateParameter(valid_579065, JBool, required = false,
                                 default = newJBool(true))
  if valid_579065 != nil:
    section.add "prettyPrint", valid_579065
  var valid_579066 = query.getOrDefault("oauth_token")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "oauth_token", valid_579066
  var valid_579067 = query.getOrDefault("$.xgafv")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = newJString("1"))
  if valid_579067 != nil:
    section.add "$.xgafv", valid_579067
  var valid_579068 = query.getOrDefault("bearer_token")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "bearer_token", valid_579068
  var valid_579069 = query.getOrDefault("pageSize")
  valid_579069 = validateParameter(valid_579069, JInt, required = false, default = nil)
  if valid_579069 != nil:
    section.add "pageSize", valid_579069
  var valid_579070 = query.getOrDefault("alt")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("json"))
  if valid_579070 != nil:
    section.add "alt", valid_579070
  var valid_579071 = query.getOrDefault("uploadType")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "uploadType", valid_579071
  var valid_579072 = query.getOrDefault("quotaUser")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "quotaUser", valid_579072
  var valid_579073 = query.getOrDefault("filter")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "filter", valid_579073
  var valid_579074 = query.getOrDefault("pageToken")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "pageToken", valid_579074
  var valid_579075 = query.getOrDefault("callback")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "callback", valid_579075
  var valid_579076 = query.getOrDefault("fields")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "fields", valid_579076
  var valid_579077 = query.getOrDefault("access_token")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "access_token", valid_579077
  var valid_579078 = query.getOrDefault("upload_protocol")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "upload_protocol", valid_579078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579079: Call_MlProjectsJobsList_579059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the jobs in the project.
  ## 
  let valid = call_579079.validator(path, query, header, formData, body)
  let scheme = call_579079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579079.url(scheme.get, call_579079.host, call_579079.base,
                         call_579079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579079, url, valid)

proc call*(call_579080: Call_MlProjectsJobsList_579059; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## mlProjectsJobsList
  ## Lists the jobs in the project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Optional. The number of jobs to retrieve per "page" of results. If there
  ## are more remaining results than this number, the response message will
  ## contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Optional. Specifies the subset of jobs to retrieve.
  ##   pageToken: string
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the project for which to list jobs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579081 = newJObject()
  var query_579082 = newJObject()
  add(query_579082, "key", newJString(key))
  add(query_579082, "pp", newJBool(pp))
  add(query_579082, "prettyPrint", newJBool(prettyPrint))
  add(query_579082, "oauth_token", newJString(oauthToken))
  add(query_579082, "$.xgafv", newJString(Xgafv))
  add(query_579082, "bearer_token", newJString(bearerToken))
  add(query_579082, "pageSize", newJInt(pageSize))
  add(query_579082, "alt", newJString(alt))
  add(query_579082, "uploadType", newJString(uploadType))
  add(query_579082, "quotaUser", newJString(quotaUser))
  add(query_579082, "filter", newJString(filter))
  add(query_579082, "pageToken", newJString(pageToken))
  add(query_579082, "callback", newJString(callback))
  add(path_579081, "parent", newJString(parent))
  add(query_579082, "fields", newJString(fields))
  add(query_579082, "access_token", newJString(accessToken))
  add(query_579082, "upload_protocol", newJString(uploadProtocol))
  result = call_579080.call(path_579081, query_579082, nil, nil, nil)

var mlProjectsJobsList* = Call_MlProjectsJobsList_579059(
    name: "mlProjectsJobsList", meth: HttpMethod.HttpGet, host: "ml.googleapis.com",
    route: "/v1/{parent}/jobs", validator: validate_MlProjectsJobsList_579060,
    base: "/", url: url_MlProjectsJobsList_579061, schemes: {Scheme.Https})
type
  Call_MlProjectsLocationsList_579106 = ref object of OpenApiRestCall_578339
proc url_MlProjectsLocationsList_579108(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsLocationsList_579107(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all locations that provides at least one type of CMLE capability.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the project for which available locations are to be
  ## listed (since some locations might be whitelisted for specific projects).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579109 = path.getOrDefault("parent")
  valid_579109 = validateParameter(valid_579109, JString, required = true,
                                 default = nil)
  if valid_579109 != nil:
    section.add "parent", valid_579109
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Optional. The number of locations to retrieve per "page" of results. If there
  ## are more remaining results than this number, the response message will
  ## contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579110 = query.getOrDefault("key")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "key", valid_579110
  var valid_579111 = query.getOrDefault("pp")
  valid_579111 = validateParameter(valid_579111, JBool, required = false,
                                 default = newJBool(true))
  if valid_579111 != nil:
    section.add "pp", valid_579111
  var valid_579112 = query.getOrDefault("prettyPrint")
  valid_579112 = validateParameter(valid_579112, JBool, required = false,
                                 default = newJBool(true))
  if valid_579112 != nil:
    section.add "prettyPrint", valid_579112
  var valid_579113 = query.getOrDefault("oauth_token")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "oauth_token", valid_579113
  var valid_579114 = query.getOrDefault("$.xgafv")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = newJString("1"))
  if valid_579114 != nil:
    section.add "$.xgafv", valid_579114
  var valid_579115 = query.getOrDefault("bearer_token")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "bearer_token", valid_579115
  var valid_579116 = query.getOrDefault("pageSize")
  valid_579116 = validateParameter(valid_579116, JInt, required = false, default = nil)
  if valid_579116 != nil:
    section.add "pageSize", valid_579116
  var valid_579117 = query.getOrDefault("alt")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = newJString("json"))
  if valid_579117 != nil:
    section.add "alt", valid_579117
  var valid_579118 = query.getOrDefault("uploadType")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "uploadType", valid_579118
  var valid_579119 = query.getOrDefault("quotaUser")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "quotaUser", valid_579119
  var valid_579120 = query.getOrDefault("pageToken")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "pageToken", valid_579120
  var valid_579121 = query.getOrDefault("callback")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "callback", valid_579121
  var valid_579122 = query.getOrDefault("fields")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "fields", valid_579122
  var valid_579123 = query.getOrDefault("access_token")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "access_token", valid_579123
  var valid_579124 = query.getOrDefault("upload_protocol")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "upload_protocol", valid_579124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579125: Call_MlProjectsLocationsList_579106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all locations that provides at least one type of CMLE capability.
  ## 
  let valid = call_579125.validator(path, query, header, formData, body)
  let scheme = call_579125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579125.url(scheme.get, call_579125.host, call_579125.base,
                         call_579125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579125, url, valid)

proc call*(call_579126: Call_MlProjectsLocationsList_579106; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## mlProjectsLocationsList
  ## List all locations that provides at least one type of CMLE capability.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Optional. The number of locations to retrieve per "page" of results. If there
  ## are more remaining results than this number, the response message will
  ## contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the project for which available locations are to be
  ## listed (since some locations might be whitelisted for specific projects).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579127 = newJObject()
  var query_579128 = newJObject()
  add(query_579128, "key", newJString(key))
  add(query_579128, "pp", newJBool(pp))
  add(query_579128, "prettyPrint", newJBool(prettyPrint))
  add(query_579128, "oauth_token", newJString(oauthToken))
  add(query_579128, "$.xgafv", newJString(Xgafv))
  add(query_579128, "bearer_token", newJString(bearerToken))
  add(query_579128, "pageSize", newJInt(pageSize))
  add(query_579128, "alt", newJString(alt))
  add(query_579128, "uploadType", newJString(uploadType))
  add(query_579128, "quotaUser", newJString(quotaUser))
  add(query_579128, "pageToken", newJString(pageToken))
  add(query_579128, "callback", newJString(callback))
  add(path_579127, "parent", newJString(parent))
  add(query_579128, "fields", newJString(fields))
  add(query_579128, "access_token", newJString(accessToken))
  add(query_579128, "upload_protocol", newJString(uploadProtocol))
  result = call_579126.call(path_579127, query_579128, nil, nil, nil)

var mlProjectsLocationsList* = Call_MlProjectsLocationsList_579106(
    name: "mlProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{parent}/locations",
    validator: validate_MlProjectsLocationsList_579107, base: "/",
    url: url_MlProjectsLocationsList_579108, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsCreate_579153 = ref object of OpenApiRestCall_578339
proc url_MlProjectsModelsCreate_579155(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/models")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsModelsCreate_579154(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a model which will later contain one or more versions.
  ## 
  ## You must add at least one version before you can request predictions from
  ## the model. Add versions by calling
  ## [projects.models.versions.create](/ml-engine/reference/rest/v1/projects.models.versions/create).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579156 = path.getOrDefault("parent")
  valid_579156 = validateParameter(valid_579156, JString, required = true,
                                 default = nil)
  if valid_579156 != nil:
    section.add "parent", valid_579156
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579157 = query.getOrDefault("key")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "key", valid_579157
  var valid_579158 = query.getOrDefault("pp")
  valid_579158 = validateParameter(valid_579158, JBool, required = false,
                                 default = newJBool(true))
  if valid_579158 != nil:
    section.add "pp", valid_579158
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
  var valid_579162 = query.getOrDefault("bearer_token")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "bearer_token", valid_579162
  var valid_579163 = query.getOrDefault("alt")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = newJString("json"))
  if valid_579163 != nil:
    section.add "alt", valid_579163
  var valid_579164 = query.getOrDefault("uploadType")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "uploadType", valid_579164
  var valid_579165 = query.getOrDefault("quotaUser")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "quotaUser", valid_579165
  var valid_579166 = query.getOrDefault("callback")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "callback", valid_579166
  var valid_579167 = query.getOrDefault("fields")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "fields", valid_579167
  var valid_579168 = query.getOrDefault("access_token")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "access_token", valid_579168
  var valid_579169 = query.getOrDefault("upload_protocol")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "upload_protocol", valid_579169
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

proc call*(call_579171: Call_MlProjectsModelsCreate_579153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a model which will later contain one or more versions.
  ## 
  ## You must add at least one version before you can request predictions from
  ## the model. Add versions by calling
  ## [projects.models.versions.create](/ml-engine/reference/rest/v1/projects.models.versions/create).
  ## 
  let valid = call_579171.validator(path, query, header, formData, body)
  let scheme = call_579171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579171.url(scheme.get, call_579171.host, call_579171.base,
                         call_579171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579171, url, valid)

proc call*(call_579172: Call_MlProjectsModelsCreate_579153; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## mlProjectsModelsCreate
  ## Creates a model which will later contain one or more versions.
  ## 
  ## You must add at least one version before you can request predictions from
  ## the model. Add versions by calling
  ## [projects.models.versions.create](/ml-engine/reference/rest/v1/projects.models.versions/create).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  ##         : Required. The project name.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579173 = newJObject()
  var query_579174 = newJObject()
  var body_579175 = newJObject()
  add(query_579174, "key", newJString(key))
  add(query_579174, "pp", newJBool(pp))
  add(query_579174, "prettyPrint", newJBool(prettyPrint))
  add(query_579174, "oauth_token", newJString(oauthToken))
  add(query_579174, "$.xgafv", newJString(Xgafv))
  add(query_579174, "bearer_token", newJString(bearerToken))
  add(query_579174, "alt", newJString(alt))
  add(query_579174, "uploadType", newJString(uploadType))
  add(query_579174, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579175 = body
  add(query_579174, "callback", newJString(callback))
  add(path_579173, "parent", newJString(parent))
  add(query_579174, "fields", newJString(fields))
  add(query_579174, "access_token", newJString(accessToken))
  add(query_579174, "upload_protocol", newJString(uploadProtocol))
  result = call_579172.call(path_579173, query_579174, nil, nil, body_579175)

var mlProjectsModelsCreate* = Call_MlProjectsModelsCreate_579153(
    name: "mlProjectsModelsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{parent}/models",
    validator: validate_MlProjectsModelsCreate_579154, base: "/",
    url: url_MlProjectsModelsCreate_579155, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsList_579129 = ref object of OpenApiRestCall_578339
proc url_MlProjectsModelsList_579131(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/models")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsModelsList_579130(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the models in a project.
  ## 
  ## Each project can contain multiple models, and each model can have multiple
  ## versions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the project whose models are to be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579132 = path.getOrDefault("parent")
  valid_579132 = validateParameter(valid_579132, JString, required = true,
                                 default = nil)
  if valid_579132 != nil:
    section.add "parent", valid_579132
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Optional. The number of models to retrieve per "page" of results. If there
  ## are more remaining results than this number, the response message will
  ## contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Optional. Specifies the subset of models to retrieve.
  ##   pageToken: JString
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579133 = query.getOrDefault("key")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "key", valid_579133
  var valid_579134 = query.getOrDefault("pp")
  valid_579134 = validateParameter(valid_579134, JBool, required = false,
                                 default = newJBool(true))
  if valid_579134 != nil:
    section.add "pp", valid_579134
  var valid_579135 = query.getOrDefault("prettyPrint")
  valid_579135 = validateParameter(valid_579135, JBool, required = false,
                                 default = newJBool(true))
  if valid_579135 != nil:
    section.add "prettyPrint", valid_579135
  var valid_579136 = query.getOrDefault("oauth_token")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "oauth_token", valid_579136
  var valid_579137 = query.getOrDefault("$.xgafv")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = newJString("1"))
  if valid_579137 != nil:
    section.add "$.xgafv", valid_579137
  var valid_579138 = query.getOrDefault("bearer_token")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "bearer_token", valid_579138
  var valid_579139 = query.getOrDefault("pageSize")
  valid_579139 = validateParameter(valid_579139, JInt, required = false, default = nil)
  if valid_579139 != nil:
    section.add "pageSize", valid_579139
  var valid_579140 = query.getOrDefault("alt")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = newJString("json"))
  if valid_579140 != nil:
    section.add "alt", valid_579140
  var valid_579141 = query.getOrDefault("uploadType")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "uploadType", valid_579141
  var valid_579142 = query.getOrDefault("quotaUser")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "quotaUser", valid_579142
  var valid_579143 = query.getOrDefault("filter")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "filter", valid_579143
  var valid_579144 = query.getOrDefault("pageToken")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "pageToken", valid_579144
  var valid_579145 = query.getOrDefault("callback")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "callback", valid_579145
  var valid_579146 = query.getOrDefault("fields")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "fields", valid_579146
  var valid_579147 = query.getOrDefault("access_token")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "access_token", valid_579147
  var valid_579148 = query.getOrDefault("upload_protocol")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "upload_protocol", valid_579148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579149: Call_MlProjectsModelsList_579129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the models in a project.
  ## 
  ## Each project can contain multiple models, and each model can have multiple
  ## versions.
  ## 
  let valid = call_579149.validator(path, query, header, formData, body)
  let scheme = call_579149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579149.url(scheme.get, call_579149.host, call_579149.base,
                         call_579149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579149, url, valid)

proc call*(call_579150: Call_MlProjectsModelsList_579129; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## mlProjectsModelsList
  ## Lists the models in a project.
  ## 
  ## Each project can contain multiple models, and each model can have multiple
  ## versions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Optional. The number of models to retrieve per "page" of results. If there
  ## are more remaining results than this number, the response message will
  ## contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Optional. Specifies the subset of models to retrieve.
  ##   pageToken: string
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the project whose models are to be listed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579151 = newJObject()
  var query_579152 = newJObject()
  add(query_579152, "key", newJString(key))
  add(query_579152, "pp", newJBool(pp))
  add(query_579152, "prettyPrint", newJBool(prettyPrint))
  add(query_579152, "oauth_token", newJString(oauthToken))
  add(query_579152, "$.xgafv", newJString(Xgafv))
  add(query_579152, "bearer_token", newJString(bearerToken))
  add(query_579152, "pageSize", newJInt(pageSize))
  add(query_579152, "alt", newJString(alt))
  add(query_579152, "uploadType", newJString(uploadType))
  add(query_579152, "quotaUser", newJString(quotaUser))
  add(query_579152, "filter", newJString(filter))
  add(query_579152, "pageToken", newJString(pageToken))
  add(query_579152, "callback", newJString(callback))
  add(path_579151, "parent", newJString(parent))
  add(query_579152, "fields", newJString(fields))
  add(query_579152, "access_token", newJString(accessToken))
  add(query_579152, "upload_protocol", newJString(uploadProtocol))
  result = call_579150.call(path_579151, query_579152, nil, nil, nil)

var mlProjectsModelsList* = Call_MlProjectsModelsList_579129(
    name: "mlProjectsModelsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{parent}/models",
    validator: validate_MlProjectsModelsList_579130, base: "/",
    url: url_MlProjectsModelsList_579131, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsCreate_579200 = ref object of OpenApiRestCall_578339
proc url_MlProjectsModelsVersionsCreate_579202(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsModelsVersionsCreate_579201(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new version of a model from a trained TensorFlow model.
  ## 
  ## If the version created in the cloud by this call is the first deployed
  ## version of the specified model, it will be made the default version of the
  ## model. When you add a version to a model that already has one or more
  ## versions, the default version does not automatically change. If you want a
  ## new version to be the default, you must call
  ## [projects.models.versions.setDefault](/ml-engine/reference/rest/v1/projects.models.versions/setDefault).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the model.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579203 = path.getOrDefault("parent")
  valid_579203 = validateParameter(valid_579203, JString, required = true,
                                 default = nil)
  if valid_579203 != nil:
    section.add "parent", valid_579203
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579204 = query.getOrDefault("key")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "key", valid_579204
  var valid_579205 = query.getOrDefault("pp")
  valid_579205 = validateParameter(valid_579205, JBool, required = false,
                                 default = newJBool(true))
  if valid_579205 != nil:
    section.add "pp", valid_579205
  var valid_579206 = query.getOrDefault("prettyPrint")
  valid_579206 = validateParameter(valid_579206, JBool, required = false,
                                 default = newJBool(true))
  if valid_579206 != nil:
    section.add "prettyPrint", valid_579206
  var valid_579207 = query.getOrDefault("oauth_token")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "oauth_token", valid_579207
  var valid_579208 = query.getOrDefault("$.xgafv")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = newJString("1"))
  if valid_579208 != nil:
    section.add "$.xgafv", valid_579208
  var valid_579209 = query.getOrDefault("bearer_token")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "bearer_token", valid_579209
  var valid_579210 = query.getOrDefault("alt")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = newJString("json"))
  if valid_579210 != nil:
    section.add "alt", valid_579210
  var valid_579211 = query.getOrDefault("uploadType")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "uploadType", valid_579211
  var valid_579212 = query.getOrDefault("quotaUser")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "quotaUser", valid_579212
  var valid_579213 = query.getOrDefault("callback")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "callback", valid_579213
  var valid_579214 = query.getOrDefault("fields")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "fields", valid_579214
  var valid_579215 = query.getOrDefault("access_token")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "access_token", valid_579215
  var valid_579216 = query.getOrDefault("upload_protocol")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "upload_protocol", valid_579216
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

proc call*(call_579218: Call_MlProjectsModelsVersionsCreate_579200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new version of a model from a trained TensorFlow model.
  ## 
  ## If the version created in the cloud by this call is the first deployed
  ## version of the specified model, it will be made the default version of the
  ## model. When you add a version to a model that already has one or more
  ## versions, the default version does not automatically change. If you want a
  ## new version to be the default, you must call
  ## [projects.models.versions.setDefault](/ml-engine/reference/rest/v1/projects.models.versions/setDefault).
  ## 
  let valid = call_579218.validator(path, query, header, formData, body)
  let scheme = call_579218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579218.url(scheme.get, call_579218.host, call_579218.base,
                         call_579218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579218, url, valid)

proc call*(call_579219: Call_MlProjectsModelsVersionsCreate_579200; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## mlProjectsModelsVersionsCreate
  ## Creates a new version of a model from a trained TensorFlow model.
  ## 
  ## If the version created in the cloud by this call is the first deployed
  ## version of the specified model, it will be made the default version of the
  ## model. When you add a version to a model that already has one or more
  ## versions, the default version does not automatically change. If you want a
  ## new version to be the default, you must call
  ## [projects.models.versions.setDefault](/ml-engine/reference/rest/v1/projects.models.versions/setDefault).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  ##         : Required. The name of the model.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579220 = newJObject()
  var query_579221 = newJObject()
  var body_579222 = newJObject()
  add(query_579221, "key", newJString(key))
  add(query_579221, "pp", newJBool(pp))
  add(query_579221, "prettyPrint", newJBool(prettyPrint))
  add(query_579221, "oauth_token", newJString(oauthToken))
  add(query_579221, "$.xgafv", newJString(Xgafv))
  add(query_579221, "bearer_token", newJString(bearerToken))
  add(query_579221, "alt", newJString(alt))
  add(query_579221, "uploadType", newJString(uploadType))
  add(query_579221, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579222 = body
  add(query_579221, "callback", newJString(callback))
  add(path_579220, "parent", newJString(parent))
  add(query_579221, "fields", newJString(fields))
  add(query_579221, "access_token", newJString(accessToken))
  add(query_579221, "upload_protocol", newJString(uploadProtocol))
  result = call_579219.call(path_579220, query_579221, nil, nil, body_579222)

var mlProjectsModelsVersionsCreate* = Call_MlProjectsModelsVersionsCreate_579200(
    name: "mlProjectsModelsVersionsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{parent}/versions",
    validator: validate_MlProjectsModelsVersionsCreate_579201, base: "/",
    url: url_MlProjectsModelsVersionsCreate_579202, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsList_579176 = ref object of OpenApiRestCall_578339
proc url_MlProjectsModelsVersionsList_579178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsModelsVersionsList_579177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets basic information about all the versions of a model.
  ## 
  ## If you expect that a model has a lot of versions, or if you need to handle
  ## only a limited number of results at a time, you can request that the list
  ## be retrieved in batches (called pages):
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the model for which to list the version.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579179 = path.getOrDefault("parent")
  valid_579179 = validateParameter(valid_579179, JString, required = true,
                                 default = nil)
  if valid_579179 != nil:
    section.add "parent", valid_579179
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Optional. The number of versions to retrieve per "page" of results. If
  ## there are more remaining results than this number, the response message
  ## will contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Optional. Specifies the subset of versions to retrieve.
  ##   pageToken: JString
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579180 = query.getOrDefault("key")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "key", valid_579180
  var valid_579181 = query.getOrDefault("pp")
  valid_579181 = validateParameter(valid_579181, JBool, required = false,
                                 default = newJBool(true))
  if valid_579181 != nil:
    section.add "pp", valid_579181
  var valid_579182 = query.getOrDefault("prettyPrint")
  valid_579182 = validateParameter(valid_579182, JBool, required = false,
                                 default = newJBool(true))
  if valid_579182 != nil:
    section.add "prettyPrint", valid_579182
  var valid_579183 = query.getOrDefault("oauth_token")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "oauth_token", valid_579183
  var valid_579184 = query.getOrDefault("$.xgafv")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = newJString("1"))
  if valid_579184 != nil:
    section.add "$.xgafv", valid_579184
  var valid_579185 = query.getOrDefault("bearer_token")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "bearer_token", valid_579185
  var valid_579186 = query.getOrDefault("pageSize")
  valid_579186 = validateParameter(valid_579186, JInt, required = false, default = nil)
  if valid_579186 != nil:
    section.add "pageSize", valid_579186
  var valid_579187 = query.getOrDefault("alt")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = newJString("json"))
  if valid_579187 != nil:
    section.add "alt", valid_579187
  var valid_579188 = query.getOrDefault("uploadType")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "uploadType", valid_579188
  var valid_579189 = query.getOrDefault("quotaUser")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "quotaUser", valid_579189
  var valid_579190 = query.getOrDefault("filter")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "filter", valid_579190
  var valid_579191 = query.getOrDefault("pageToken")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "pageToken", valid_579191
  var valid_579192 = query.getOrDefault("callback")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "callback", valid_579192
  var valid_579193 = query.getOrDefault("fields")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "fields", valid_579193
  var valid_579194 = query.getOrDefault("access_token")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "access_token", valid_579194
  var valid_579195 = query.getOrDefault("upload_protocol")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "upload_protocol", valid_579195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579196: Call_MlProjectsModelsVersionsList_579176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets basic information about all the versions of a model.
  ## 
  ## If you expect that a model has a lot of versions, or if you need to handle
  ## only a limited number of results at a time, you can request that the list
  ## be retrieved in batches (called pages):
  ## 
  let valid = call_579196.validator(path, query, header, formData, body)
  let scheme = call_579196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579196.url(scheme.get, call_579196.host, call_579196.base,
                         call_579196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579196, url, valid)

proc call*(call_579197: Call_MlProjectsModelsVersionsList_579176; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## mlProjectsModelsVersionsList
  ## Gets basic information about all the versions of a model.
  ## 
  ## If you expect that a model has a lot of versions, or if you need to handle
  ## only a limited number of results at a time, you can request that the list
  ## be retrieved in batches (called pages):
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Optional. The number of versions to retrieve per "page" of results. If
  ## there are more remaining results than this number, the response message
  ## will contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Optional. Specifies the subset of versions to retrieve.
  ##   pageToken: string
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the model for which to list the version.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579198 = newJObject()
  var query_579199 = newJObject()
  add(query_579199, "key", newJString(key))
  add(query_579199, "pp", newJBool(pp))
  add(query_579199, "prettyPrint", newJBool(prettyPrint))
  add(query_579199, "oauth_token", newJString(oauthToken))
  add(query_579199, "$.xgafv", newJString(Xgafv))
  add(query_579199, "bearer_token", newJString(bearerToken))
  add(query_579199, "pageSize", newJInt(pageSize))
  add(query_579199, "alt", newJString(alt))
  add(query_579199, "uploadType", newJString(uploadType))
  add(query_579199, "quotaUser", newJString(quotaUser))
  add(query_579199, "filter", newJString(filter))
  add(query_579199, "pageToken", newJString(pageToken))
  add(query_579199, "callback", newJString(callback))
  add(path_579198, "parent", newJString(parent))
  add(query_579199, "fields", newJString(fields))
  add(query_579199, "access_token", newJString(accessToken))
  add(query_579199, "upload_protocol", newJString(uploadProtocol))
  result = call_579197.call(path_579198, query_579199, nil, nil, nil)

var mlProjectsModelsVersionsList* = Call_MlProjectsModelsVersionsList_579176(
    name: "mlProjectsModelsVersionsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{parent}/versions",
    validator: validate_MlProjectsModelsVersionsList_579177, base: "/",
    url: url_MlProjectsModelsVersionsList_579178, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsGetIamPolicy_579223 = ref object of OpenApiRestCall_578339
proc url_MlProjectsJobsGetIamPolicy_579225(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_MlProjectsJobsGetIamPolicy_579224(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_579226 = path.getOrDefault("resource")
  valid_579226 = validateParameter(valid_579226, JString, required = true,
                                 default = nil)
  if valid_579226 != nil:
    section.add "resource", valid_579226
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579227 = query.getOrDefault("key")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "key", valid_579227
  var valid_579228 = query.getOrDefault("pp")
  valid_579228 = validateParameter(valid_579228, JBool, required = false,
                                 default = newJBool(true))
  if valid_579228 != nil:
    section.add "pp", valid_579228
  var valid_579229 = query.getOrDefault("prettyPrint")
  valid_579229 = validateParameter(valid_579229, JBool, required = false,
                                 default = newJBool(true))
  if valid_579229 != nil:
    section.add "prettyPrint", valid_579229
  var valid_579230 = query.getOrDefault("oauth_token")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "oauth_token", valid_579230
  var valid_579231 = query.getOrDefault("$.xgafv")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = newJString("1"))
  if valid_579231 != nil:
    section.add "$.xgafv", valid_579231
  var valid_579232 = query.getOrDefault("bearer_token")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "bearer_token", valid_579232
  var valid_579233 = query.getOrDefault("alt")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = newJString("json"))
  if valid_579233 != nil:
    section.add "alt", valid_579233
  var valid_579234 = query.getOrDefault("uploadType")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "uploadType", valid_579234
  var valid_579235 = query.getOrDefault("quotaUser")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "quotaUser", valid_579235
  var valid_579236 = query.getOrDefault("callback")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "callback", valid_579236
  var valid_579237 = query.getOrDefault("fields")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "fields", valid_579237
  var valid_579238 = query.getOrDefault("access_token")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "access_token", valid_579238
  var valid_579239 = query.getOrDefault("upload_protocol")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "upload_protocol", valid_579239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579240: Call_MlProjectsJobsGetIamPolicy_579223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_579240.validator(path, query, header, formData, body)
  let scheme = call_579240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579240.url(scheme.get, call_579240.host, call_579240.base,
                         call_579240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579240, url, valid)

proc call*(call_579241: Call_MlProjectsJobsGetIamPolicy_579223; resource: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## mlProjectsJobsGetIamPolicy
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579242 = newJObject()
  var query_579243 = newJObject()
  add(query_579243, "key", newJString(key))
  add(query_579243, "pp", newJBool(pp))
  add(query_579243, "prettyPrint", newJBool(prettyPrint))
  add(query_579243, "oauth_token", newJString(oauthToken))
  add(query_579243, "$.xgafv", newJString(Xgafv))
  add(query_579243, "bearer_token", newJString(bearerToken))
  add(query_579243, "alt", newJString(alt))
  add(query_579243, "uploadType", newJString(uploadType))
  add(query_579243, "quotaUser", newJString(quotaUser))
  add(path_579242, "resource", newJString(resource))
  add(query_579243, "callback", newJString(callback))
  add(query_579243, "fields", newJString(fields))
  add(query_579243, "access_token", newJString(accessToken))
  add(query_579243, "upload_protocol", newJString(uploadProtocol))
  result = call_579241.call(path_579242, query_579243, nil, nil, nil)

var mlProjectsJobsGetIamPolicy* = Call_MlProjectsJobsGetIamPolicy_579223(
    name: "mlProjectsJobsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_MlProjectsJobsGetIamPolicy_579224, base: "/",
    url: url_MlProjectsJobsGetIamPolicy_579225, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsSetIamPolicy_579244 = ref object of OpenApiRestCall_578339
proc url_MlProjectsJobsSetIamPolicy_579246(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_MlProjectsJobsSetIamPolicy_579245(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_579247 = path.getOrDefault("resource")
  valid_579247 = validateParameter(valid_579247, JString, required = true,
                                 default = nil)
  if valid_579247 != nil:
    section.add "resource", valid_579247
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579248 = query.getOrDefault("key")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "key", valid_579248
  var valid_579249 = query.getOrDefault("pp")
  valid_579249 = validateParameter(valid_579249, JBool, required = false,
                                 default = newJBool(true))
  if valid_579249 != nil:
    section.add "pp", valid_579249
  var valid_579250 = query.getOrDefault("prettyPrint")
  valid_579250 = validateParameter(valid_579250, JBool, required = false,
                                 default = newJBool(true))
  if valid_579250 != nil:
    section.add "prettyPrint", valid_579250
  var valid_579251 = query.getOrDefault("oauth_token")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "oauth_token", valid_579251
  var valid_579252 = query.getOrDefault("$.xgafv")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = newJString("1"))
  if valid_579252 != nil:
    section.add "$.xgafv", valid_579252
  var valid_579253 = query.getOrDefault("bearer_token")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "bearer_token", valid_579253
  var valid_579254 = query.getOrDefault("alt")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = newJString("json"))
  if valid_579254 != nil:
    section.add "alt", valid_579254
  var valid_579255 = query.getOrDefault("uploadType")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "uploadType", valid_579255
  var valid_579256 = query.getOrDefault("quotaUser")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "quotaUser", valid_579256
  var valid_579257 = query.getOrDefault("callback")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "callback", valid_579257
  var valid_579258 = query.getOrDefault("fields")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "fields", valid_579258
  var valid_579259 = query.getOrDefault("access_token")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "access_token", valid_579259
  var valid_579260 = query.getOrDefault("upload_protocol")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "upload_protocol", valid_579260
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

proc call*(call_579262: Call_MlProjectsJobsSetIamPolicy_579244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_579262.validator(path, query, header, formData, body)
  let scheme = call_579262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579262.url(scheme.get, call_579262.host, call_579262.base,
                         call_579262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579262, url, valid)

proc call*(call_579263: Call_MlProjectsJobsSetIamPolicy_579244; resource: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## mlProjectsJobsSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_579264 = newJObject()
  var query_579265 = newJObject()
  var body_579266 = newJObject()
  add(query_579265, "key", newJString(key))
  add(query_579265, "pp", newJBool(pp))
  add(query_579265, "prettyPrint", newJBool(prettyPrint))
  add(query_579265, "oauth_token", newJString(oauthToken))
  add(query_579265, "$.xgafv", newJString(Xgafv))
  add(query_579265, "bearer_token", newJString(bearerToken))
  add(query_579265, "alt", newJString(alt))
  add(query_579265, "uploadType", newJString(uploadType))
  add(query_579265, "quotaUser", newJString(quotaUser))
  add(path_579264, "resource", newJString(resource))
  if body != nil:
    body_579266 = body
  add(query_579265, "callback", newJString(callback))
  add(query_579265, "fields", newJString(fields))
  add(query_579265, "access_token", newJString(accessToken))
  add(query_579265, "upload_protocol", newJString(uploadProtocol))
  result = call_579263.call(path_579264, query_579265, nil, nil, body_579266)

var mlProjectsJobsSetIamPolicy* = Call_MlProjectsJobsSetIamPolicy_579244(
    name: "mlProjectsJobsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_MlProjectsJobsSetIamPolicy_579245, base: "/",
    url: url_MlProjectsJobsSetIamPolicy_579246, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsTestIamPermissions_579267 = ref object of OpenApiRestCall_578339
proc url_MlProjectsJobsTestIamPermissions_579269(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_MlProjectsJobsTestIamPermissions_579268(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579270 = path.getOrDefault("resource")
  valid_579270 = validateParameter(valid_579270, JString, required = true,
                                 default = nil)
  if valid_579270 != nil:
    section.add "resource", valid_579270
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579271 = query.getOrDefault("key")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "key", valid_579271
  var valid_579272 = query.getOrDefault("pp")
  valid_579272 = validateParameter(valid_579272, JBool, required = false,
                                 default = newJBool(true))
  if valid_579272 != nil:
    section.add "pp", valid_579272
  var valid_579273 = query.getOrDefault("prettyPrint")
  valid_579273 = validateParameter(valid_579273, JBool, required = false,
                                 default = newJBool(true))
  if valid_579273 != nil:
    section.add "prettyPrint", valid_579273
  var valid_579274 = query.getOrDefault("oauth_token")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "oauth_token", valid_579274
  var valid_579275 = query.getOrDefault("$.xgafv")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = newJString("1"))
  if valid_579275 != nil:
    section.add "$.xgafv", valid_579275
  var valid_579276 = query.getOrDefault("bearer_token")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "bearer_token", valid_579276
  var valid_579277 = query.getOrDefault("alt")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = newJString("json"))
  if valid_579277 != nil:
    section.add "alt", valid_579277
  var valid_579278 = query.getOrDefault("uploadType")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "uploadType", valid_579278
  var valid_579279 = query.getOrDefault("quotaUser")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "quotaUser", valid_579279
  var valid_579280 = query.getOrDefault("callback")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "callback", valid_579280
  var valid_579281 = query.getOrDefault("fields")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "fields", valid_579281
  var valid_579282 = query.getOrDefault("access_token")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "access_token", valid_579282
  var valid_579283 = query.getOrDefault("upload_protocol")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "upload_protocol", valid_579283
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

proc call*(call_579285: Call_MlProjectsJobsTestIamPermissions_579267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  let valid = call_579285.validator(path, query, header, formData, body)
  let scheme = call_579285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579285.url(scheme.get, call_579285.host, call_579285.base,
                         call_579285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579285, url, valid)

proc call*(call_579286: Call_MlProjectsJobsTestIamPermissions_579267;
          resource: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## mlProjectsJobsTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_579287 = newJObject()
  var query_579288 = newJObject()
  var body_579289 = newJObject()
  add(query_579288, "key", newJString(key))
  add(query_579288, "pp", newJBool(pp))
  add(query_579288, "prettyPrint", newJBool(prettyPrint))
  add(query_579288, "oauth_token", newJString(oauthToken))
  add(query_579288, "$.xgafv", newJString(Xgafv))
  add(query_579288, "bearer_token", newJString(bearerToken))
  add(query_579288, "alt", newJString(alt))
  add(query_579288, "uploadType", newJString(uploadType))
  add(query_579288, "quotaUser", newJString(quotaUser))
  add(path_579287, "resource", newJString(resource))
  if body != nil:
    body_579289 = body
  add(query_579288, "callback", newJString(callback))
  add(query_579288, "fields", newJString(fields))
  add(query_579288, "access_token", newJString(accessToken))
  add(query_579288, "upload_protocol", newJString(uploadProtocol))
  result = call_579286.call(path_579287, query_579288, nil, nil, body_579289)

var mlProjectsJobsTestIamPermissions* = Call_MlProjectsJobsTestIamPermissions_579267(
    name: "mlProjectsJobsTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{resource}:testIamPermissions",
    validator: validate_MlProjectsJobsTestIamPermissions_579268, base: "/",
    url: url_MlProjectsJobsTestIamPermissions_579269, schemes: {Scheme.Https})
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
