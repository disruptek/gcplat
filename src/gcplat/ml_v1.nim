
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
  gcpServiceName = "ml"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MlProjectsJobsGet_579677 = ref object of OpenApiRestCall_579408
proc url_MlProjectsJobsGet_579679(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsJobsGet_579678(path: JsonNode; query: JsonNode;
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
  var valid_579823 = query.getOrDefault("pp")
  valid_579823 = validateParameter(valid_579823, JBool, required = false,
                                 default = newJBool(true))
  if valid_579823 != nil:
    section.add "pp", valid_579823
  var valid_579824 = query.getOrDefault("oauth_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "oauth_token", valid_579824
  var valid_579825 = query.getOrDefault("callback")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "callback", valid_579825
  var valid_579826 = query.getOrDefault("access_token")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "access_token", valid_579826
  var valid_579827 = query.getOrDefault("uploadType")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "uploadType", valid_579827
  var valid_579828 = query.getOrDefault("key")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "key", valid_579828
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
  var valid_579831 = query.getOrDefault("bearer_token")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "bearer_token", valid_579831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579854: Call_MlProjectsJobsGet_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Describes a job.
  ## 
  let valid = call_579854.validator(path, query, header, formData, body)
  let scheme = call_579854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579854.url(scheme.get, call_579854.host, call_579854.base,
                         call_579854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579854, url, valid)

proc call*(call_579925: Call_MlProjectsJobsGet_579677; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## mlProjectsJobsGet
  ## Describes a job.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the job to get the description of.
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
  var path_579926 = newJObject()
  var query_579928 = newJObject()
  add(query_579928, "upload_protocol", newJString(uploadProtocol))
  add(query_579928, "fields", newJString(fields))
  add(query_579928, "quotaUser", newJString(quotaUser))
  add(path_579926, "name", newJString(name))
  add(query_579928, "alt", newJString(alt))
  add(query_579928, "pp", newJBool(pp))
  add(query_579928, "oauth_token", newJString(oauthToken))
  add(query_579928, "callback", newJString(callback))
  add(query_579928, "access_token", newJString(accessToken))
  add(query_579928, "uploadType", newJString(uploadType))
  add(query_579928, "key", newJString(key))
  add(query_579928, "$.xgafv", newJString(Xgafv))
  add(query_579928, "prettyPrint", newJBool(prettyPrint))
  add(query_579928, "bearer_token", newJString(bearerToken))
  result = call_579925.call(path_579926, query_579928, nil, nil, nil)

var mlProjectsJobsGet* = Call_MlProjectsJobsGet_579677(name: "mlProjectsJobsGet",
    meth: HttpMethod.HttpGet, host: "ml.googleapis.com", route: "/v1/{name}",
    validator: validate_MlProjectsJobsGet_579678, base: "/",
    url: url_MlProjectsJobsGet_579679, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsPatch_579988 = ref object of OpenApiRestCall_579408
proc url_MlProjectsJobsPatch_579990(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsJobsPatch_579989(path: JsonNode; query: JsonNode;
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
  var valid_579991 = path.getOrDefault("name")
  valid_579991 = validateParameter(valid_579991, JString, required = true,
                                 default = nil)
  if valid_579991 != nil:
    section.add "name", valid_579991
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579992 = query.getOrDefault("upload_protocol")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "upload_protocol", valid_579992
  var valid_579993 = query.getOrDefault("fields")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "fields", valid_579993
  var valid_579994 = query.getOrDefault("quotaUser")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "quotaUser", valid_579994
  var valid_579995 = query.getOrDefault("alt")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("json"))
  if valid_579995 != nil:
    section.add "alt", valid_579995
  var valid_579996 = query.getOrDefault("pp")
  valid_579996 = validateParameter(valid_579996, JBool, required = false,
                                 default = newJBool(true))
  if valid_579996 != nil:
    section.add "pp", valid_579996
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
  var valid_580004 = query.getOrDefault("updateMask")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "updateMask", valid_580004
  var valid_580005 = query.getOrDefault("bearer_token")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "bearer_token", valid_580005
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

proc call*(call_580007: Call_MlProjectsJobsPatch_579988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a specific job resource.
  ## 
  ## Currently the only supported fields to update are `labels`.
  ## 
  let valid = call_580007.validator(path, query, header, formData, body)
  let scheme = call_580007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580007.url(scheme.get, call_580007.host, call_580007.base,
                         call_580007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580007, url, valid)

proc call*(call_580008: Call_MlProjectsJobsPatch_579988; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""; bearerToken: string = ""): Recallable =
  ## mlProjectsJobsPatch
  ## Updates a specific job resource.
  ## 
  ## Currently the only supported fields to update are `labels`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The job name.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580009 = newJObject()
  var query_580010 = newJObject()
  var body_580011 = newJObject()
  add(query_580010, "upload_protocol", newJString(uploadProtocol))
  add(query_580010, "fields", newJString(fields))
  add(query_580010, "quotaUser", newJString(quotaUser))
  add(path_580009, "name", newJString(name))
  add(query_580010, "alt", newJString(alt))
  add(query_580010, "pp", newJBool(pp))
  add(query_580010, "oauth_token", newJString(oauthToken))
  add(query_580010, "callback", newJString(callback))
  add(query_580010, "access_token", newJString(accessToken))
  add(query_580010, "uploadType", newJString(uploadType))
  add(query_580010, "key", newJString(key))
  add(query_580010, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580011 = body
  add(query_580010, "prettyPrint", newJBool(prettyPrint))
  add(query_580010, "updateMask", newJString(updateMask))
  add(query_580010, "bearer_token", newJString(bearerToken))
  result = call_580008.call(path_580009, query_580010, nil, nil, body_580011)

var mlProjectsJobsPatch* = Call_MlProjectsJobsPatch_579988(
    name: "mlProjectsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "ml.googleapis.com", route: "/v1/{name}",
    validator: validate_MlProjectsJobsPatch_579989, base: "/",
    url: url_MlProjectsJobsPatch_579990, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsDelete_579967 = ref object of OpenApiRestCall_579408
proc url_MlProjectsModelsVersionsDelete_579969(protocol: Scheme; host: string;
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

proc validate_MlProjectsModelsVersionsDelete_579968(path: JsonNode;
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
  var valid_579970 = path.getOrDefault("name")
  valid_579970 = validateParameter(valid_579970, JString, required = true,
                                 default = nil)
  if valid_579970 != nil:
    section.add "name", valid_579970
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
  var valid_579971 = query.getOrDefault("upload_protocol")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "upload_protocol", valid_579971
  var valid_579972 = query.getOrDefault("fields")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "fields", valid_579972
  var valid_579973 = query.getOrDefault("quotaUser")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "quotaUser", valid_579973
  var valid_579974 = query.getOrDefault("alt")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = newJString("json"))
  if valid_579974 != nil:
    section.add "alt", valid_579974
  var valid_579975 = query.getOrDefault("pp")
  valid_579975 = validateParameter(valid_579975, JBool, required = false,
                                 default = newJBool(true))
  if valid_579975 != nil:
    section.add "pp", valid_579975
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
  var valid_579983 = query.getOrDefault("bearer_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "bearer_token", valid_579983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579984: Call_MlProjectsModelsVersionsDelete_579967; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a model version.
  ## 
  ## Each model can have multiple versions deployed and in use at any given
  ## time. Use this method to remove a single version.
  ## 
  ## Note: You cannot delete the version that is set as the default version
  ## of the model unless it is the only remaining version.
  ## 
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_MlProjectsModelsVersionsDelete_579967; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## mlProjectsModelsVersionsDelete
  ## Deletes a model version.
  ## 
  ## Each model can have multiple versions deployed and in use at any given
  ## time. Use this method to remove a single version.
  ## 
  ## Note: You cannot delete the version that is set as the default version
  ## of the model unless it is the only remaining version.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the version. You can get the names of all the
  ## versions of a model by calling
  ## 
  ## [projects.models.versions.list](/ml-engine/reference/rest/v1/projects.models.versions/list).
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
  var path_579986 = newJObject()
  var query_579987 = newJObject()
  add(query_579987, "upload_protocol", newJString(uploadProtocol))
  add(query_579987, "fields", newJString(fields))
  add(query_579987, "quotaUser", newJString(quotaUser))
  add(path_579986, "name", newJString(name))
  add(query_579987, "alt", newJString(alt))
  add(query_579987, "pp", newJBool(pp))
  add(query_579987, "oauth_token", newJString(oauthToken))
  add(query_579987, "callback", newJString(callback))
  add(query_579987, "access_token", newJString(accessToken))
  add(query_579987, "uploadType", newJString(uploadType))
  add(query_579987, "key", newJString(key))
  add(query_579987, "$.xgafv", newJString(Xgafv))
  add(query_579987, "prettyPrint", newJBool(prettyPrint))
  add(query_579987, "bearer_token", newJString(bearerToken))
  result = call_579985.call(path_579986, query_579987, nil, nil, nil)

var mlProjectsModelsVersionsDelete* = Call_MlProjectsModelsVersionsDelete_579967(
    name: "mlProjectsModelsVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "ml.googleapis.com", route: "/v1/{name}",
    validator: validate_MlProjectsModelsVersionsDelete_579968, base: "/",
    url: url_MlProjectsModelsVersionsDelete_579969, schemes: {Scheme.Https})
type
  Call_MlProjectsOperationsList_580012 = ref object of OpenApiRestCall_579408
proc url_MlProjectsOperationsList_580014(protocol: Scheme; host: string;
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

proc validate_MlProjectsOperationsList_580013(path: JsonNode; query: JsonNode;
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
  var valid_580015 = path.getOrDefault("name")
  valid_580015 = validateParameter(valid_580015, JString, required = true,
                                 default = nil)
  if valid_580015 != nil:
    section.add "name", valid_580015
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580016 = query.getOrDefault("upload_protocol")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "upload_protocol", valid_580016
  var valid_580017 = query.getOrDefault("fields")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "fields", valid_580017
  var valid_580018 = query.getOrDefault("pageToken")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "pageToken", valid_580018
  var valid_580019 = query.getOrDefault("quotaUser")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "quotaUser", valid_580019
  var valid_580020 = query.getOrDefault("alt")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("json"))
  if valid_580020 != nil:
    section.add "alt", valid_580020
  var valid_580021 = query.getOrDefault("pp")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(true))
  if valid_580021 != nil:
    section.add "pp", valid_580021
  var valid_580022 = query.getOrDefault("oauth_token")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "oauth_token", valid_580022
  var valid_580023 = query.getOrDefault("callback")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "callback", valid_580023
  var valid_580024 = query.getOrDefault("access_token")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "access_token", valid_580024
  var valid_580025 = query.getOrDefault("uploadType")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "uploadType", valid_580025
  var valid_580026 = query.getOrDefault("key")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "key", valid_580026
  var valid_580027 = query.getOrDefault("$.xgafv")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("1"))
  if valid_580027 != nil:
    section.add "$.xgafv", valid_580027
  var valid_580028 = query.getOrDefault("pageSize")
  valid_580028 = validateParameter(valid_580028, JInt, required = false, default = nil)
  if valid_580028 != nil:
    section.add "pageSize", valid_580028
  var valid_580029 = query.getOrDefault("prettyPrint")
  valid_580029 = validateParameter(valid_580029, JBool, required = false,
                                 default = newJBool(true))
  if valid_580029 != nil:
    section.add "prettyPrint", valid_580029
  var valid_580030 = query.getOrDefault("filter")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "filter", valid_580030
  var valid_580031 = query.getOrDefault("bearer_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "bearer_token", valid_580031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580032: Call_MlProjectsOperationsList_580012; path: JsonNode;
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
  let valid = call_580032.validator(path, query, header, formData, body)
  let scheme = call_580032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580032.url(scheme.get, call_580032.host, call_580032.base,
                         call_580032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580032, url, valid)

proc call*(call_580033: Call_MlProjectsOperationsList_580012; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""; bearerToken: string = ""): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
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
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580034 = newJObject()
  var query_580035 = newJObject()
  add(query_580035, "upload_protocol", newJString(uploadProtocol))
  add(query_580035, "fields", newJString(fields))
  add(query_580035, "pageToken", newJString(pageToken))
  add(query_580035, "quotaUser", newJString(quotaUser))
  add(path_580034, "name", newJString(name))
  add(query_580035, "alt", newJString(alt))
  add(query_580035, "pp", newJBool(pp))
  add(query_580035, "oauth_token", newJString(oauthToken))
  add(query_580035, "callback", newJString(callback))
  add(query_580035, "access_token", newJString(accessToken))
  add(query_580035, "uploadType", newJString(uploadType))
  add(query_580035, "key", newJString(key))
  add(query_580035, "$.xgafv", newJString(Xgafv))
  add(query_580035, "pageSize", newJInt(pageSize))
  add(query_580035, "prettyPrint", newJBool(prettyPrint))
  add(query_580035, "filter", newJString(filter))
  add(query_580035, "bearer_token", newJString(bearerToken))
  result = call_580033.call(path_580034, query_580035, nil, nil, nil)

var mlProjectsOperationsList* = Call_MlProjectsOperationsList_580012(
    name: "mlProjectsOperationsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{name}/operations",
    validator: validate_MlProjectsOperationsList_580013, base: "/",
    url: url_MlProjectsOperationsList_580014, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsCancel_580036 = ref object of OpenApiRestCall_579408
proc url_MlProjectsJobsCancel_580038(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsJobsCancel_580037(path: JsonNode; query: JsonNode;
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
  var valid_580039 = path.getOrDefault("name")
  valid_580039 = validateParameter(valid_580039, JString, required = true,
                                 default = nil)
  if valid_580039 != nil:
    section.add "name", valid_580039
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
  var valid_580040 = query.getOrDefault("upload_protocol")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "upload_protocol", valid_580040
  var valid_580041 = query.getOrDefault("fields")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "fields", valid_580041
  var valid_580042 = query.getOrDefault("quotaUser")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "quotaUser", valid_580042
  var valid_580043 = query.getOrDefault("alt")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("json"))
  if valid_580043 != nil:
    section.add "alt", valid_580043
  var valid_580044 = query.getOrDefault("pp")
  valid_580044 = validateParameter(valid_580044, JBool, required = false,
                                 default = newJBool(true))
  if valid_580044 != nil:
    section.add "pp", valid_580044
  var valid_580045 = query.getOrDefault("oauth_token")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "oauth_token", valid_580045
  var valid_580046 = query.getOrDefault("callback")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "callback", valid_580046
  var valid_580047 = query.getOrDefault("access_token")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "access_token", valid_580047
  var valid_580048 = query.getOrDefault("uploadType")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "uploadType", valid_580048
  var valid_580049 = query.getOrDefault("key")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "key", valid_580049
  var valid_580050 = query.getOrDefault("$.xgafv")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("1"))
  if valid_580050 != nil:
    section.add "$.xgafv", valid_580050
  var valid_580051 = query.getOrDefault("prettyPrint")
  valid_580051 = validateParameter(valid_580051, JBool, required = false,
                                 default = newJBool(true))
  if valid_580051 != nil:
    section.add "prettyPrint", valid_580051
  var valid_580052 = query.getOrDefault("bearer_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "bearer_token", valid_580052
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

proc call*(call_580054: Call_MlProjectsJobsCancel_580036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a running job.
  ## 
  let valid = call_580054.validator(path, query, header, formData, body)
  let scheme = call_580054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580054.url(scheme.get, call_580054.host, call_580054.base,
                         call_580054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580054, url, valid)

proc call*(call_580055: Call_MlProjectsJobsCancel_580036; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## mlProjectsJobsCancel
  ## Cancels a running job.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the job to cancel.
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
  var path_580056 = newJObject()
  var query_580057 = newJObject()
  var body_580058 = newJObject()
  add(query_580057, "upload_protocol", newJString(uploadProtocol))
  add(query_580057, "fields", newJString(fields))
  add(query_580057, "quotaUser", newJString(quotaUser))
  add(path_580056, "name", newJString(name))
  add(query_580057, "alt", newJString(alt))
  add(query_580057, "pp", newJBool(pp))
  add(query_580057, "oauth_token", newJString(oauthToken))
  add(query_580057, "callback", newJString(callback))
  add(query_580057, "access_token", newJString(accessToken))
  add(query_580057, "uploadType", newJString(uploadType))
  add(query_580057, "key", newJString(key))
  add(query_580057, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580058 = body
  add(query_580057, "prettyPrint", newJBool(prettyPrint))
  add(query_580057, "bearer_token", newJString(bearerToken))
  result = call_580055.call(path_580056, query_580057, nil, nil, body_580058)

var mlProjectsJobsCancel* = Call_MlProjectsJobsCancel_580036(
    name: "mlProjectsJobsCancel", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_MlProjectsJobsCancel_580037, base: "/",
    url: url_MlProjectsJobsCancel_580038, schemes: {Scheme.Https})
type
  Call_MlProjectsGetConfig_580059 = ref object of OpenApiRestCall_579408
proc url_MlProjectsGetConfig_580061(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsGetConfig_580060(path: JsonNode; query: JsonNode;
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
  var valid_580062 = path.getOrDefault("name")
  valid_580062 = validateParameter(valid_580062, JString, required = true,
                                 default = nil)
  if valid_580062 != nil:
    section.add "name", valid_580062
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
  var valid_580063 = query.getOrDefault("upload_protocol")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "upload_protocol", valid_580063
  var valid_580064 = query.getOrDefault("fields")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "fields", valid_580064
  var valid_580065 = query.getOrDefault("quotaUser")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "quotaUser", valid_580065
  var valid_580066 = query.getOrDefault("alt")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = newJString("json"))
  if valid_580066 != nil:
    section.add "alt", valid_580066
  var valid_580067 = query.getOrDefault("pp")
  valid_580067 = validateParameter(valid_580067, JBool, required = false,
                                 default = newJBool(true))
  if valid_580067 != nil:
    section.add "pp", valid_580067
  var valid_580068 = query.getOrDefault("oauth_token")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "oauth_token", valid_580068
  var valid_580069 = query.getOrDefault("callback")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "callback", valid_580069
  var valid_580070 = query.getOrDefault("access_token")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "access_token", valid_580070
  var valid_580071 = query.getOrDefault("uploadType")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "uploadType", valid_580071
  var valid_580072 = query.getOrDefault("key")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "key", valid_580072
  var valid_580073 = query.getOrDefault("$.xgafv")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("1"))
  if valid_580073 != nil:
    section.add "$.xgafv", valid_580073
  var valid_580074 = query.getOrDefault("prettyPrint")
  valid_580074 = validateParameter(valid_580074, JBool, required = false,
                                 default = newJBool(true))
  if valid_580074 != nil:
    section.add "prettyPrint", valid_580074
  var valid_580075 = query.getOrDefault("bearer_token")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "bearer_token", valid_580075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580076: Call_MlProjectsGetConfig_580059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the service account information associated with your project. You need
  ## this information in order to grant the service account persmissions for
  ## the Google Cloud Storage location where you put your model training code
  ## for training the model with Google Cloud Machine Learning.
  ## 
  let valid = call_580076.validator(path, query, header, formData, body)
  let scheme = call_580076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580076.url(scheme.get, call_580076.host, call_580076.base,
                         call_580076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580076, url, valid)

proc call*(call_580077: Call_MlProjectsGetConfig_580059; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## mlProjectsGetConfig
  ## Get the service account information associated with your project. You need
  ## this information in order to grant the service account persmissions for
  ## the Google Cloud Storage location where you put your model training code
  ## for training the model with Google Cloud Machine Learning.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The project name.
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
  var path_580078 = newJObject()
  var query_580079 = newJObject()
  add(query_580079, "upload_protocol", newJString(uploadProtocol))
  add(query_580079, "fields", newJString(fields))
  add(query_580079, "quotaUser", newJString(quotaUser))
  add(path_580078, "name", newJString(name))
  add(query_580079, "alt", newJString(alt))
  add(query_580079, "pp", newJBool(pp))
  add(query_580079, "oauth_token", newJString(oauthToken))
  add(query_580079, "callback", newJString(callback))
  add(query_580079, "access_token", newJString(accessToken))
  add(query_580079, "uploadType", newJString(uploadType))
  add(query_580079, "key", newJString(key))
  add(query_580079, "$.xgafv", newJString(Xgafv))
  add(query_580079, "prettyPrint", newJBool(prettyPrint))
  add(query_580079, "bearer_token", newJString(bearerToken))
  result = call_580077.call(path_580078, query_580079, nil, nil, nil)

var mlProjectsGetConfig* = Call_MlProjectsGetConfig_580059(
    name: "mlProjectsGetConfig", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{name}:getConfig",
    validator: validate_MlProjectsGetConfig_580060, base: "/",
    url: url_MlProjectsGetConfig_580061, schemes: {Scheme.Https})
type
  Call_MlProjectsPredict_580080 = ref object of OpenApiRestCall_579408
proc url_MlProjectsPredict_580082(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsPredict_580081(path: JsonNode; query: JsonNode;
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
  var valid_580083 = path.getOrDefault("name")
  valid_580083 = validateParameter(valid_580083, JString, required = true,
                                 default = nil)
  if valid_580083 != nil:
    section.add "name", valid_580083
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
  var valid_580084 = query.getOrDefault("upload_protocol")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "upload_protocol", valid_580084
  var valid_580085 = query.getOrDefault("fields")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "fields", valid_580085
  var valid_580086 = query.getOrDefault("quotaUser")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "quotaUser", valid_580086
  var valid_580087 = query.getOrDefault("alt")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = newJString("json"))
  if valid_580087 != nil:
    section.add "alt", valid_580087
  var valid_580088 = query.getOrDefault("pp")
  valid_580088 = validateParameter(valid_580088, JBool, required = false,
                                 default = newJBool(true))
  if valid_580088 != nil:
    section.add "pp", valid_580088
  var valid_580089 = query.getOrDefault("oauth_token")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "oauth_token", valid_580089
  var valid_580090 = query.getOrDefault("callback")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "callback", valid_580090
  var valid_580091 = query.getOrDefault("access_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "access_token", valid_580091
  var valid_580092 = query.getOrDefault("uploadType")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "uploadType", valid_580092
  var valid_580093 = query.getOrDefault("key")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "key", valid_580093
  var valid_580094 = query.getOrDefault("$.xgafv")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("1"))
  if valid_580094 != nil:
    section.add "$.xgafv", valid_580094
  var valid_580095 = query.getOrDefault("prettyPrint")
  valid_580095 = validateParameter(valid_580095, JBool, required = false,
                                 default = newJBool(true))
  if valid_580095 != nil:
    section.add "prettyPrint", valid_580095
  var valid_580096 = query.getOrDefault("bearer_token")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "bearer_token", valid_580096
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

proc call*(call_580098: Call_MlProjectsPredict_580080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs prediction on the data in the request.
  ## Cloud ML Engine implements a custom `predict` verb on top of an HTTP POST
  ## method. For details of the format, see the **guide to the
  ## [predict request format](/ml-engine/docs/v1/predict-request)**.
  ## 
  let valid = call_580098.validator(path, query, header, formData, body)
  let scheme = call_580098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580098.url(scheme.get, call_580098.host, call_580098.base,
                         call_580098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580098, url, valid)

proc call*(call_580099: Call_MlProjectsPredict_580080; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## mlProjectsPredict
  ## Performs prediction on the data in the request.
  ## Cloud ML Engine implements a custom `predict` verb on top of an HTTP POST
  ## method. For details of the format, see the **guide to the
  ## [predict request format](/ml-engine/docs/v1/predict-request)**.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of a model or a version.
  ## 
  ## Authorization: requires the `predict` permission on the specified resource.
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
  var path_580100 = newJObject()
  var query_580101 = newJObject()
  var body_580102 = newJObject()
  add(query_580101, "upload_protocol", newJString(uploadProtocol))
  add(query_580101, "fields", newJString(fields))
  add(query_580101, "quotaUser", newJString(quotaUser))
  add(path_580100, "name", newJString(name))
  add(query_580101, "alt", newJString(alt))
  add(query_580101, "pp", newJBool(pp))
  add(query_580101, "oauth_token", newJString(oauthToken))
  add(query_580101, "callback", newJString(callback))
  add(query_580101, "access_token", newJString(accessToken))
  add(query_580101, "uploadType", newJString(uploadType))
  add(query_580101, "key", newJString(key))
  add(query_580101, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580102 = body
  add(query_580101, "prettyPrint", newJBool(prettyPrint))
  add(query_580101, "bearer_token", newJString(bearerToken))
  result = call_580099.call(path_580100, query_580101, nil, nil, body_580102)

var mlProjectsPredict* = Call_MlProjectsPredict_580080(name: "mlProjectsPredict",
    meth: HttpMethod.HttpPost, host: "ml.googleapis.com",
    route: "/v1/{name}:predict", validator: validate_MlProjectsPredict_580081,
    base: "/", url: url_MlProjectsPredict_580082, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsSetDefault_580103 = ref object of OpenApiRestCall_579408
proc url_MlProjectsModelsVersionsSetDefault_580105(protocol: Scheme; host: string;
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

proc validate_MlProjectsModelsVersionsSetDefault_580104(path: JsonNode;
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
  var valid_580106 = path.getOrDefault("name")
  valid_580106 = validateParameter(valid_580106, JString, required = true,
                                 default = nil)
  if valid_580106 != nil:
    section.add "name", valid_580106
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
  var valid_580107 = query.getOrDefault("upload_protocol")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "upload_protocol", valid_580107
  var valid_580108 = query.getOrDefault("fields")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "fields", valid_580108
  var valid_580109 = query.getOrDefault("quotaUser")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "quotaUser", valid_580109
  var valid_580110 = query.getOrDefault("alt")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = newJString("json"))
  if valid_580110 != nil:
    section.add "alt", valid_580110
  var valid_580111 = query.getOrDefault("pp")
  valid_580111 = validateParameter(valid_580111, JBool, required = false,
                                 default = newJBool(true))
  if valid_580111 != nil:
    section.add "pp", valid_580111
  var valid_580112 = query.getOrDefault("oauth_token")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "oauth_token", valid_580112
  var valid_580113 = query.getOrDefault("callback")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "callback", valid_580113
  var valid_580114 = query.getOrDefault("access_token")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "access_token", valid_580114
  var valid_580115 = query.getOrDefault("uploadType")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "uploadType", valid_580115
  var valid_580116 = query.getOrDefault("key")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "key", valid_580116
  var valid_580117 = query.getOrDefault("$.xgafv")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = newJString("1"))
  if valid_580117 != nil:
    section.add "$.xgafv", valid_580117
  var valid_580118 = query.getOrDefault("prettyPrint")
  valid_580118 = validateParameter(valid_580118, JBool, required = false,
                                 default = newJBool(true))
  if valid_580118 != nil:
    section.add "prettyPrint", valid_580118
  var valid_580119 = query.getOrDefault("bearer_token")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "bearer_token", valid_580119
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

proc call*(call_580121: Call_MlProjectsModelsVersionsSetDefault_580103;
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
  let valid = call_580121.validator(path, query, header, formData, body)
  let scheme = call_580121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580121.url(scheme.get, call_580121.host, call_580121.base,
                         call_580121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580121, url, valid)

proc call*(call_580122: Call_MlProjectsModelsVersionsSetDefault_580103;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## mlProjectsModelsVersionsSetDefault
  ## Designates a version to be the default for the model.
  ## 
  ## The default version is used for prediction requests made against the model
  ## that don't specify a version.
  ## 
  ## The first version to be created for a model is automatically set as the
  ## default. You must make any subsequent changes to the default version
  ## setting manually using this method.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the version to make the default for the model. You
  ## can get the names of all the versions of a model by calling
  ## 
  ## [projects.models.versions.list](/ml-engine/reference/rest/v1/projects.models.versions/list).
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
  var path_580123 = newJObject()
  var query_580124 = newJObject()
  var body_580125 = newJObject()
  add(query_580124, "upload_protocol", newJString(uploadProtocol))
  add(query_580124, "fields", newJString(fields))
  add(query_580124, "quotaUser", newJString(quotaUser))
  add(path_580123, "name", newJString(name))
  add(query_580124, "alt", newJString(alt))
  add(query_580124, "pp", newJBool(pp))
  add(query_580124, "oauth_token", newJString(oauthToken))
  add(query_580124, "callback", newJString(callback))
  add(query_580124, "access_token", newJString(accessToken))
  add(query_580124, "uploadType", newJString(uploadType))
  add(query_580124, "key", newJString(key))
  add(query_580124, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580125 = body
  add(query_580124, "prettyPrint", newJBool(prettyPrint))
  add(query_580124, "bearer_token", newJString(bearerToken))
  result = call_580122.call(path_580123, query_580124, nil, nil, body_580125)

var mlProjectsModelsVersionsSetDefault* = Call_MlProjectsModelsVersionsSetDefault_580103(
    name: "mlProjectsModelsVersionsSetDefault", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{name}:setDefault",
    validator: validate_MlProjectsModelsVersionsSetDefault_580104, base: "/",
    url: url_MlProjectsModelsVersionsSetDefault_580105, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsCreate_580150 = ref object of OpenApiRestCall_579408
proc url_MlProjectsJobsCreate_580152(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsJobsCreate_580151(path: JsonNode; query: JsonNode;
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
  var valid_580153 = path.getOrDefault("parent")
  valid_580153 = validateParameter(valid_580153, JString, required = true,
                                 default = nil)
  if valid_580153 != nil:
    section.add "parent", valid_580153
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
  var valid_580154 = query.getOrDefault("upload_protocol")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "upload_protocol", valid_580154
  var valid_580155 = query.getOrDefault("fields")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "fields", valid_580155
  var valid_580156 = query.getOrDefault("quotaUser")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "quotaUser", valid_580156
  var valid_580157 = query.getOrDefault("alt")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = newJString("json"))
  if valid_580157 != nil:
    section.add "alt", valid_580157
  var valid_580158 = query.getOrDefault("pp")
  valid_580158 = validateParameter(valid_580158, JBool, required = false,
                                 default = newJBool(true))
  if valid_580158 != nil:
    section.add "pp", valid_580158
  var valid_580159 = query.getOrDefault("oauth_token")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "oauth_token", valid_580159
  var valid_580160 = query.getOrDefault("callback")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "callback", valid_580160
  var valid_580161 = query.getOrDefault("access_token")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "access_token", valid_580161
  var valid_580162 = query.getOrDefault("uploadType")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "uploadType", valid_580162
  var valid_580163 = query.getOrDefault("key")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "key", valid_580163
  var valid_580164 = query.getOrDefault("$.xgafv")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("1"))
  if valid_580164 != nil:
    section.add "$.xgafv", valid_580164
  var valid_580165 = query.getOrDefault("prettyPrint")
  valid_580165 = validateParameter(valid_580165, JBool, required = false,
                                 default = newJBool(true))
  if valid_580165 != nil:
    section.add "prettyPrint", valid_580165
  var valid_580166 = query.getOrDefault("bearer_token")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "bearer_token", valid_580166
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

proc call*(call_580168: Call_MlProjectsJobsCreate_580150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a training or a batch prediction job.
  ## 
  let valid = call_580168.validator(path, query, header, formData, body)
  let scheme = call_580168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580168.url(scheme.get, call_580168.host, call_580168.base,
                         call_580168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580168, url, valid)

proc call*(call_580169: Call_MlProjectsJobsCreate_580150; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## mlProjectsJobsCreate
  ## Creates a training or a batch prediction job.
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
  ##         : Required. The project name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580170 = newJObject()
  var query_580171 = newJObject()
  var body_580172 = newJObject()
  add(query_580171, "upload_protocol", newJString(uploadProtocol))
  add(query_580171, "fields", newJString(fields))
  add(query_580171, "quotaUser", newJString(quotaUser))
  add(query_580171, "alt", newJString(alt))
  add(query_580171, "pp", newJBool(pp))
  add(query_580171, "oauth_token", newJString(oauthToken))
  add(query_580171, "callback", newJString(callback))
  add(query_580171, "access_token", newJString(accessToken))
  add(query_580171, "uploadType", newJString(uploadType))
  add(path_580170, "parent", newJString(parent))
  add(query_580171, "key", newJString(key))
  add(query_580171, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580172 = body
  add(query_580171, "prettyPrint", newJBool(prettyPrint))
  add(query_580171, "bearer_token", newJString(bearerToken))
  result = call_580169.call(path_580170, query_580171, nil, nil, body_580172)

var mlProjectsJobsCreate* = Call_MlProjectsJobsCreate_580150(
    name: "mlProjectsJobsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{parent}/jobs",
    validator: validate_MlProjectsJobsCreate_580151, base: "/",
    url: url_MlProjectsJobsCreate_580152, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsList_580126 = ref object of OpenApiRestCall_579408
proc url_MlProjectsJobsList_580128(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsJobsList_580127(path: JsonNode; query: JsonNode;
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
  var valid_580129 = path.getOrDefault("parent")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "parent", valid_580129
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
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
  ##           : Optional. The number of jobs to retrieve per "page" of results. If there
  ## are more remaining results than this number, the response message will
  ## contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Specifies the subset of jobs to retrieve.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580130 = query.getOrDefault("upload_protocol")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "upload_protocol", valid_580130
  var valid_580131 = query.getOrDefault("fields")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "fields", valid_580131
  var valid_580132 = query.getOrDefault("pageToken")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "pageToken", valid_580132
  var valid_580133 = query.getOrDefault("quotaUser")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "quotaUser", valid_580133
  var valid_580134 = query.getOrDefault("alt")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = newJString("json"))
  if valid_580134 != nil:
    section.add "alt", valid_580134
  var valid_580135 = query.getOrDefault("pp")
  valid_580135 = validateParameter(valid_580135, JBool, required = false,
                                 default = newJBool(true))
  if valid_580135 != nil:
    section.add "pp", valid_580135
  var valid_580136 = query.getOrDefault("oauth_token")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "oauth_token", valid_580136
  var valid_580137 = query.getOrDefault("callback")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "callback", valid_580137
  var valid_580138 = query.getOrDefault("access_token")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "access_token", valid_580138
  var valid_580139 = query.getOrDefault("uploadType")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "uploadType", valid_580139
  var valid_580140 = query.getOrDefault("key")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "key", valid_580140
  var valid_580141 = query.getOrDefault("$.xgafv")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = newJString("1"))
  if valid_580141 != nil:
    section.add "$.xgafv", valid_580141
  var valid_580142 = query.getOrDefault("pageSize")
  valid_580142 = validateParameter(valid_580142, JInt, required = false, default = nil)
  if valid_580142 != nil:
    section.add "pageSize", valid_580142
  var valid_580143 = query.getOrDefault("prettyPrint")
  valid_580143 = validateParameter(valid_580143, JBool, required = false,
                                 default = newJBool(true))
  if valid_580143 != nil:
    section.add "prettyPrint", valid_580143
  var valid_580144 = query.getOrDefault("filter")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "filter", valid_580144
  var valid_580145 = query.getOrDefault("bearer_token")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "bearer_token", valid_580145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580146: Call_MlProjectsJobsList_580126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the jobs in the project.
  ## 
  let valid = call_580146.validator(path, query, header, formData, body)
  let scheme = call_580146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580146.url(scheme.get, call_580146.host, call_580146.base,
                         call_580146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580146, url, valid)

proc call*(call_580147: Call_MlProjectsJobsList_580126; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""; bearerToken: string = ""): Recallable =
  ## mlProjectsJobsList
  ## Lists the jobs in the project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
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
  ##         : Required. The name of the project for which to list jobs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The number of jobs to retrieve per "page" of results. If there
  ## are more remaining results than this number, the response message will
  ## contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Specifies the subset of jobs to retrieve.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580148 = newJObject()
  var query_580149 = newJObject()
  add(query_580149, "upload_protocol", newJString(uploadProtocol))
  add(query_580149, "fields", newJString(fields))
  add(query_580149, "pageToken", newJString(pageToken))
  add(query_580149, "quotaUser", newJString(quotaUser))
  add(query_580149, "alt", newJString(alt))
  add(query_580149, "pp", newJBool(pp))
  add(query_580149, "oauth_token", newJString(oauthToken))
  add(query_580149, "callback", newJString(callback))
  add(query_580149, "access_token", newJString(accessToken))
  add(query_580149, "uploadType", newJString(uploadType))
  add(path_580148, "parent", newJString(parent))
  add(query_580149, "key", newJString(key))
  add(query_580149, "$.xgafv", newJString(Xgafv))
  add(query_580149, "pageSize", newJInt(pageSize))
  add(query_580149, "prettyPrint", newJBool(prettyPrint))
  add(query_580149, "filter", newJString(filter))
  add(query_580149, "bearer_token", newJString(bearerToken))
  result = call_580147.call(path_580148, query_580149, nil, nil, nil)

var mlProjectsJobsList* = Call_MlProjectsJobsList_580126(
    name: "mlProjectsJobsList", meth: HttpMethod.HttpGet, host: "ml.googleapis.com",
    route: "/v1/{parent}/jobs", validator: validate_MlProjectsJobsList_580127,
    base: "/", url: url_MlProjectsJobsList_580128, schemes: {Scheme.Https})
type
  Call_MlProjectsLocationsList_580173 = ref object of OpenApiRestCall_579408
proc url_MlProjectsLocationsList_580175(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsLocationsList_580174(path: JsonNode; query: JsonNode;
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
  var valid_580176 = path.getOrDefault("parent")
  valid_580176 = validateParameter(valid_580176, JString, required = true,
                                 default = nil)
  if valid_580176 != nil:
    section.add "parent", valid_580176
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
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
  ##           : Optional. The number of locations to retrieve per "page" of results. If there
  ## are more remaining results than this number, the response message will
  ## contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580177 = query.getOrDefault("upload_protocol")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "upload_protocol", valid_580177
  var valid_580178 = query.getOrDefault("fields")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "fields", valid_580178
  var valid_580179 = query.getOrDefault("pageToken")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "pageToken", valid_580179
  var valid_580180 = query.getOrDefault("quotaUser")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "quotaUser", valid_580180
  var valid_580181 = query.getOrDefault("alt")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = newJString("json"))
  if valid_580181 != nil:
    section.add "alt", valid_580181
  var valid_580182 = query.getOrDefault("pp")
  valid_580182 = validateParameter(valid_580182, JBool, required = false,
                                 default = newJBool(true))
  if valid_580182 != nil:
    section.add "pp", valid_580182
  var valid_580183 = query.getOrDefault("oauth_token")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "oauth_token", valid_580183
  var valid_580184 = query.getOrDefault("callback")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "callback", valid_580184
  var valid_580185 = query.getOrDefault("access_token")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "access_token", valid_580185
  var valid_580186 = query.getOrDefault("uploadType")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "uploadType", valid_580186
  var valid_580187 = query.getOrDefault("key")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "key", valid_580187
  var valid_580188 = query.getOrDefault("$.xgafv")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = newJString("1"))
  if valid_580188 != nil:
    section.add "$.xgafv", valid_580188
  var valid_580189 = query.getOrDefault("pageSize")
  valid_580189 = validateParameter(valid_580189, JInt, required = false, default = nil)
  if valid_580189 != nil:
    section.add "pageSize", valid_580189
  var valid_580190 = query.getOrDefault("prettyPrint")
  valid_580190 = validateParameter(valid_580190, JBool, required = false,
                                 default = newJBool(true))
  if valid_580190 != nil:
    section.add "prettyPrint", valid_580190
  var valid_580191 = query.getOrDefault("bearer_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "bearer_token", valid_580191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580192: Call_MlProjectsLocationsList_580173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all locations that provides at least one type of CMLE capability.
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_MlProjectsLocationsList_580173; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## mlProjectsLocationsList
  ## List all locations that provides at least one type of CMLE capability.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
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
  ##         : Required. The name of the project for which available locations are to be
  ## listed (since some locations might be whitelisted for specific projects).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The number of locations to retrieve per "page" of results. If there
  ## are more remaining results than this number, the response message will
  ## contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580194 = newJObject()
  var query_580195 = newJObject()
  add(query_580195, "upload_protocol", newJString(uploadProtocol))
  add(query_580195, "fields", newJString(fields))
  add(query_580195, "pageToken", newJString(pageToken))
  add(query_580195, "quotaUser", newJString(quotaUser))
  add(query_580195, "alt", newJString(alt))
  add(query_580195, "pp", newJBool(pp))
  add(query_580195, "oauth_token", newJString(oauthToken))
  add(query_580195, "callback", newJString(callback))
  add(query_580195, "access_token", newJString(accessToken))
  add(query_580195, "uploadType", newJString(uploadType))
  add(path_580194, "parent", newJString(parent))
  add(query_580195, "key", newJString(key))
  add(query_580195, "$.xgafv", newJString(Xgafv))
  add(query_580195, "pageSize", newJInt(pageSize))
  add(query_580195, "prettyPrint", newJBool(prettyPrint))
  add(query_580195, "bearer_token", newJString(bearerToken))
  result = call_580193.call(path_580194, query_580195, nil, nil, nil)

var mlProjectsLocationsList* = Call_MlProjectsLocationsList_580173(
    name: "mlProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{parent}/locations",
    validator: validate_MlProjectsLocationsList_580174, base: "/",
    url: url_MlProjectsLocationsList_580175, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsCreate_580220 = ref object of OpenApiRestCall_579408
proc url_MlProjectsModelsCreate_580222(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsModelsCreate_580221(path: JsonNode; query: JsonNode;
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
  var valid_580223 = path.getOrDefault("parent")
  valid_580223 = validateParameter(valid_580223, JString, required = true,
                                 default = nil)
  if valid_580223 != nil:
    section.add "parent", valid_580223
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
  var valid_580224 = query.getOrDefault("upload_protocol")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "upload_protocol", valid_580224
  var valid_580225 = query.getOrDefault("fields")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "fields", valid_580225
  var valid_580226 = query.getOrDefault("quotaUser")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "quotaUser", valid_580226
  var valid_580227 = query.getOrDefault("alt")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = newJString("json"))
  if valid_580227 != nil:
    section.add "alt", valid_580227
  var valid_580228 = query.getOrDefault("pp")
  valid_580228 = validateParameter(valid_580228, JBool, required = false,
                                 default = newJBool(true))
  if valid_580228 != nil:
    section.add "pp", valid_580228
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
  var valid_580236 = query.getOrDefault("bearer_token")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "bearer_token", valid_580236
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

proc call*(call_580238: Call_MlProjectsModelsCreate_580220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a model which will later contain one or more versions.
  ## 
  ## You must add at least one version before you can request predictions from
  ## the model. Add versions by calling
  ## [projects.models.versions.create](/ml-engine/reference/rest/v1/projects.models.versions/create).
  ## 
  let valid = call_580238.validator(path, query, header, formData, body)
  let scheme = call_580238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580238.url(scheme.get, call_580238.host, call_580238.base,
                         call_580238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580238, url, valid)

proc call*(call_580239: Call_MlProjectsModelsCreate_580220; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## mlProjectsModelsCreate
  ## Creates a model which will later contain one or more versions.
  ## 
  ## You must add at least one version before you can request predictions from
  ## the model. Add versions by calling
  ## [projects.models.versions.create](/ml-engine/reference/rest/v1/projects.models.versions/create).
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
  ##         : Required. The project name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580240 = newJObject()
  var query_580241 = newJObject()
  var body_580242 = newJObject()
  add(query_580241, "upload_protocol", newJString(uploadProtocol))
  add(query_580241, "fields", newJString(fields))
  add(query_580241, "quotaUser", newJString(quotaUser))
  add(query_580241, "alt", newJString(alt))
  add(query_580241, "pp", newJBool(pp))
  add(query_580241, "oauth_token", newJString(oauthToken))
  add(query_580241, "callback", newJString(callback))
  add(query_580241, "access_token", newJString(accessToken))
  add(query_580241, "uploadType", newJString(uploadType))
  add(path_580240, "parent", newJString(parent))
  add(query_580241, "key", newJString(key))
  add(query_580241, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580242 = body
  add(query_580241, "prettyPrint", newJBool(prettyPrint))
  add(query_580241, "bearer_token", newJString(bearerToken))
  result = call_580239.call(path_580240, query_580241, nil, nil, body_580242)

var mlProjectsModelsCreate* = Call_MlProjectsModelsCreate_580220(
    name: "mlProjectsModelsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{parent}/models",
    validator: validate_MlProjectsModelsCreate_580221, base: "/",
    url: url_MlProjectsModelsCreate_580222, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsList_580196 = ref object of OpenApiRestCall_579408
proc url_MlProjectsModelsList_580198(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsModelsList_580197(path: JsonNode; query: JsonNode;
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
  var valid_580199 = path.getOrDefault("parent")
  valid_580199 = validateParameter(valid_580199, JString, required = true,
                                 default = nil)
  if valid_580199 != nil:
    section.add "parent", valid_580199
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
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
  ##           : Optional. The number of models to retrieve per "page" of results. If there
  ## are more remaining results than this number, the response message will
  ## contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Specifies the subset of models to retrieve.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580200 = query.getOrDefault("upload_protocol")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "upload_protocol", valid_580200
  var valid_580201 = query.getOrDefault("fields")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "fields", valid_580201
  var valid_580202 = query.getOrDefault("pageToken")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "pageToken", valid_580202
  var valid_580203 = query.getOrDefault("quotaUser")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "quotaUser", valid_580203
  var valid_580204 = query.getOrDefault("alt")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = newJString("json"))
  if valid_580204 != nil:
    section.add "alt", valid_580204
  var valid_580205 = query.getOrDefault("pp")
  valid_580205 = validateParameter(valid_580205, JBool, required = false,
                                 default = newJBool(true))
  if valid_580205 != nil:
    section.add "pp", valid_580205
  var valid_580206 = query.getOrDefault("oauth_token")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "oauth_token", valid_580206
  var valid_580207 = query.getOrDefault("callback")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "callback", valid_580207
  var valid_580208 = query.getOrDefault("access_token")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "access_token", valid_580208
  var valid_580209 = query.getOrDefault("uploadType")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "uploadType", valid_580209
  var valid_580210 = query.getOrDefault("key")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "key", valid_580210
  var valid_580211 = query.getOrDefault("$.xgafv")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = newJString("1"))
  if valid_580211 != nil:
    section.add "$.xgafv", valid_580211
  var valid_580212 = query.getOrDefault("pageSize")
  valid_580212 = validateParameter(valid_580212, JInt, required = false, default = nil)
  if valid_580212 != nil:
    section.add "pageSize", valid_580212
  var valid_580213 = query.getOrDefault("prettyPrint")
  valid_580213 = validateParameter(valid_580213, JBool, required = false,
                                 default = newJBool(true))
  if valid_580213 != nil:
    section.add "prettyPrint", valid_580213
  var valid_580214 = query.getOrDefault("filter")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "filter", valid_580214
  var valid_580215 = query.getOrDefault("bearer_token")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "bearer_token", valid_580215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580216: Call_MlProjectsModelsList_580196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the models in a project.
  ## 
  ## Each project can contain multiple models, and each model can have multiple
  ## versions.
  ## 
  let valid = call_580216.validator(path, query, header, formData, body)
  let scheme = call_580216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580216.url(scheme.get, call_580216.host, call_580216.base,
                         call_580216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580216, url, valid)

proc call*(call_580217: Call_MlProjectsModelsList_580196; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""; bearerToken: string = ""): Recallable =
  ## mlProjectsModelsList
  ## Lists the models in a project.
  ## 
  ## Each project can contain multiple models, and each model can have multiple
  ## versions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
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
  ##         : Required. The name of the project whose models are to be listed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The number of models to retrieve per "page" of results. If there
  ## are more remaining results than this number, the response message will
  ## contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Specifies the subset of models to retrieve.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580218 = newJObject()
  var query_580219 = newJObject()
  add(query_580219, "upload_protocol", newJString(uploadProtocol))
  add(query_580219, "fields", newJString(fields))
  add(query_580219, "pageToken", newJString(pageToken))
  add(query_580219, "quotaUser", newJString(quotaUser))
  add(query_580219, "alt", newJString(alt))
  add(query_580219, "pp", newJBool(pp))
  add(query_580219, "oauth_token", newJString(oauthToken))
  add(query_580219, "callback", newJString(callback))
  add(query_580219, "access_token", newJString(accessToken))
  add(query_580219, "uploadType", newJString(uploadType))
  add(path_580218, "parent", newJString(parent))
  add(query_580219, "key", newJString(key))
  add(query_580219, "$.xgafv", newJString(Xgafv))
  add(query_580219, "pageSize", newJInt(pageSize))
  add(query_580219, "prettyPrint", newJBool(prettyPrint))
  add(query_580219, "filter", newJString(filter))
  add(query_580219, "bearer_token", newJString(bearerToken))
  result = call_580217.call(path_580218, query_580219, nil, nil, nil)

var mlProjectsModelsList* = Call_MlProjectsModelsList_580196(
    name: "mlProjectsModelsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{parent}/models",
    validator: validate_MlProjectsModelsList_580197, base: "/",
    url: url_MlProjectsModelsList_580198, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsCreate_580267 = ref object of OpenApiRestCall_579408
proc url_MlProjectsModelsVersionsCreate_580269(protocol: Scheme; host: string;
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

proc validate_MlProjectsModelsVersionsCreate_580268(path: JsonNode;
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
  var valid_580270 = path.getOrDefault("parent")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "parent", valid_580270
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
  var valid_580271 = query.getOrDefault("upload_protocol")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "upload_protocol", valid_580271
  var valid_580272 = query.getOrDefault("fields")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "fields", valid_580272
  var valid_580273 = query.getOrDefault("quotaUser")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "quotaUser", valid_580273
  var valid_580274 = query.getOrDefault("alt")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = newJString("json"))
  if valid_580274 != nil:
    section.add "alt", valid_580274
  var valid_580275 = query.getOrDefault("pp")
  valid_580275 = validateParameter(valid_580275, JBool, required = false,
                                 default = newJBool(true))
  if valid_580275 != nil:
    section.add "pp", valid_580275
  var valid_580276 = query.getOrDefault("oauth_token")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "oauth_token", valid_580276
  var valid_580277 = query.getOrDefault("callback")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "callback", valid_580277
  var valid_580278 = query.getOrDefault("access_token")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "access_token", valid_580278
  var valid_580279 = query.getOrDefault("uploadType")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "uploadType", valid_580279
  var valid_580280 = query.getOrDefault("key")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "key", valid_580280
  var valid_580281 = query.getOrDefault("$.xgafv")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = newJString("1"))
  if valid_580281 != nil:
    section.add "$.xgafv", valid_580281
  var valid_580282 = query.getOrDefault("prettyPrint")
  valid_580282 = validateParameter(valid_580282, JBool, required = false,
                                 default = newJBool(true))
  if valid_580282 != nil:
    section.add "prettyPrint", valid_580282
  var valid_580283 = query.getOrDefault("bearer_token")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "bearer_token", valid_580283
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

proc call*(call_580285: Call_MlProjectsModelsVersionsCreate_580267; path: JsonNode;
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
  let valid = call_580285.validator(path, query, header, formData, body)
  let scheme = call_580285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580285.url(scheme.get, call_580285.host, call_580285.base,
                         call_580285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580285, url, valid)

proc call*(call_580286: Call_MlProjectsModelsVersionsCreate_580267; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## mlProjectsModelsVersionsCreate
  ## Creates a new version of a model from a trained TensorFlow model.
  ## 
  ## If the version created in the cloud by this call is the first deployed
  ## version of the specified model, it will be made the default version of the
  ## model. When you add a version to a model that already has one or more
  ## versions, the default version does not automatically change. If you want a
  ## new version to be the default, you must call
  ## [projects.models.versions.setDefault](/ml-engine/reference/rest/v1/projects.models.versions/setDefault).
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
  ##         : Required. The name of the model.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580287 = newJObject()
  var query_580288 = newJObject()
  var body_580289 = newJObject()
  add(query_580288, "upload_protocol", newJString(uploadProtocol))
  add(query_580288, "fields", newJString(fields))
  add(query_580288, "quotaUser", newJString(quotaUser))
  add(query_580288, "alt", newJString(alt))
  add(query_580288, "pp", newJBool(pp))
  add(query_580288, "oauth_token", newJString(oauthToken))
  add(query_580288, "callback", newJString(callback))
  add(query_580288, "access_token", newJString(accessToken))
  add(query_580288, "uploadType", newJString(uploadType))
  add(path_580287, "parent", newJString(parent))
  add(query_580288, "key", newJString(key))
  add(query_580288, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580289 = body
  add(query_580288, "prettyPrint", newJBool(prettyPrint))
  add(query_580288, "bearer_token", newJString(bearerToken))
  result = call_580286.call(path_580287, query_580288, nil, nil, body_580289)

var mlProjectsModelsVersionsCreate* = Call_MlProjectsModelsVersionsCreate_580267(
    name: "mlProjectsModelsVersionsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{parent}/versions",
    validator: validate_MlProjectsModelsVersionsCreate_580268, base: "/",
    url: url_MlProjectsModelsVersionsCreate_580269, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsList_580243 = ref object of OpenApiRestCall_579408
proc url_MlProjectsModelsVersionsList_580245(protocol: Scheme; host: string;
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

proc validate_MlProjectsModelsVersionsList_580244(path: JsonNode; query: JsonNode;
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
  var valid_580246 = path.getOrDefault("parent")
  valid_580246 = validateParameter(valid_580246, JString, required = true,
                                 default = nil)
  if valid_580246 != nil:
    section.add "parent", valid_580246
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
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
  ##           : Optional. The number of versions to retrieve per "page" of results. If
  ## there are more remaining results than this number, the response message
  ## will contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Specifies the subset of versions to retrieve.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580247 = query.getOrDefault("upload_protocol")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "upload_protocol", valid_580247
  var valid_580248 = query.getOrDefault("fields")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "fields", valid_580248
  var valid_580249 = query.getOrDefault("pageToken")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "pageToken", valid_580249
  var valid_580250 = query.getOrDefault("quotaUser")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "quotaUser", valid_580250
  var valid_580251 = query.getOrDefault("alt")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = newJString("json"))
  if valid_580251 != nil:
    section.add "alt", valid_580251
  var valid_580252 = query.getOrDefault("pp")
  valid_580252 = validateParameter(valid_580252, JBool, required = false,
                                 default = newJBool(true))
  if valid_580252 != nil:
    section.add "pp", valid_580252
  var valid_580253 = query.getOrDefault("oauth_token")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "oauth_token", valid_580253
  var valid_580254 = query.getOrDefault("callback")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "callback", valid_580254
  var valid_580255 = query.getOrDefault("access_token")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "access_token", valid_580255
  var valid_580256 = query.getOrDefault("uploadType")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "uploadType", valid_580256
  var valid_580257 = query.getOrDefault("key")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "key", valid_580257
  var valid_580258 = query.getOrDefault("$.xgafv")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = newJString("1"))
  if valid_580258 != nil:
    section.add "$.xgafv", valid_580258
  var valid_580259 = query.getOrDefault("pageSize")
  valid_580259 = validateParameter(valid_580259, JInt, required = false, default = nil)
  if valid_580259 != nil:
    section.add "pageSize", valid_580259
  var valid_580260 = query.getOrDefault("prettyPrint")
  valid_580260 = validateParameter(valid_580260, JBool, required = false,
                                 default = newJBool(true))
  if valid_580260 != nil:
    section.add "prettyPrint", valid_580260
  var valid_580261 = query.getOrDefault("filter")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "filter", valid_580261
  var valid_580262 = query.getOrDefault("bearer_token")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "bearer_token", valid_580262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580263: Call_MlProjectsModelsVersionsList_580243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets basic information about all the versions of a model.
  ## 
  ## If you expect that a model has a lot of versions, or if you need to handle
  ## only a limited number of results at a time, you can request that the list
  ## be retrieved in batches (called pages):
  ## 
  let valid = call_580263.validator(path, query, header, formData, body)
  let scheme = call_580263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580263.url(scheme.get, call_580263.host, call_580263.base,
                         call_580263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580263, url, valid)

proc call*(call_580264: Call_MlProjectsModelsVersionsList_580243; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""; bearerToken: string = ""): Recallable =
  ## mlProjectsModelsVersionsList
  ## Gets basic information about all the versions of a model.
  ## 
  ## If you expect that a model has a lot of versions, or if you need to handle
  ## only a limited number of results at a time, you can request that the list
  ## be retrieved in batches (called pages):
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. A page token to request the next page of results.
  ## 
  ## You get the token from the `next_page_token` field of the response from
  ## the previous call.
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
  ##         : Required. The name of the model for which to list the version.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The number of versions to retrieve per "page" of results. If
  ## there are more remaining results than this number, the response message
  ## will contain a valid value in the `next_page_token` field.
  ## 
  ## The default value is 20, and the maximum page size is 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Specifies the subset of versions to retrieve.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580265 = newJObject()
  var query_580266 = newJObject()
  add(query_580266, "upload_protocol", newJString(uploadProtocol))
  add(query_580266, "fields", newJString(fields))
  add(query_580266, "pageToken", newJString(pageToken))
  add(query_580266, "quotaUser", newJString(quotaUser))
  add(query_580266, "alt", newJString(alt))
  add(query_580266, "pp", newJBool(pp))
  add(query_580266, "oauth_token", newJString(oauthToken))
  add(query_580266, "callback", newJString(callback))
  add(query_580266, "access_token", newJString(accessToken))
  add(query_580266, "uploadType", newJString(uploadType))
  add(path_580265, "parent", newJString(parent))
  add(query_580266, "key", newJString(key))
  add(query_580266, "$.xgafv", newJString(Xgafv))
  add(query_580266, "pageSize", newJInt(pageSize))
  add(query_580266, "prettyPrint", newJBool(prettyPrint))
  add(query_580266, "filter", newJString(filter))
  add(query_580266, "bearer_token", newJString(bearerToken))
  result = call_580264.call(path_580265, query_580266, nil, nil, nil)

var mlProjectsModelsVersionsList* = Call_MlProjectsModelsVersionsList_580243(
    name: "mlProjectsModelsVersionsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{parent}/versions",
    validator: validate_MlProjectsModelsVersionsList_580244, base: "/",
    url: url_MlProjectsModelsVersionsList_580245, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsGetIamPolicy_580290 = ref object of OpenApiRestCall_579408
proc url_MlProjectsJobsGetIamPolicy_580292(protocol: Scheme; host: string;
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

proc validate_MlProjectsJobsGetIamPolicy_580291(path: JsonNode; query: JsonNode;
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
  var valid_580293 = path.getOrDefault("resource")
  valid_580293 = validateParameter(valid_580293, JString, required = true,
                                 default = nil)
  if valid_580293 != nil:
    section.add "resource", valid_580293
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
  var valid_580294 = query.getOrDefault("upload_protocol")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "upload_protocol", valid_580294
  var valid_580295 = query.getOrDefault("fields")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "fields", valid_580295
  var valid_580296 = query.getOrDefault("quotaUser")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "quotaUser", valid_580296
  var valid_580297 = query.getOrDefault("alt")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = newJString("json"))
  if valid_580297 != nil:
    section.add "alt", valid_580297
  var valid_580298 = query.getOrDefault("pp")
  valid_580298 = validateParameter(valid_580298, JBool, required = false,
                                 default = newJBool(true))
  if valid_580298 != nil:
    section.add "pp", valid_580298
  var valid_580299 = query.getOrDefault("oauth_token")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "oauth_token", valid_580299
  var valid_580300 = query.getOrDefault("callback")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "callback", valid_580300
  var valid_580301 = query.getOrDefault("access_token")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "access_token", valid_580301
  var valid_580302 = query.getOrDefault("uploadType")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "uploadType", valid_580302
  var valid_580303 = query.getOrDefault("key")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "key", valid_580303
  var valid_580304 = query.getOrDefault("$.xgafv")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = newJString("1"))
  if valid_580304 != nil:
    section.add "$.xgafv", valid_580304
  var valid_580305 = query.getOrDefault("prettyPrint")
  valid_580305 = validateParameter(valid_580305, JBool, required = false,
                                 default = newJBool(true))
  if valid_580305 != nil:
    section.add "prettyPrint", valid_580305
  var valid_580306 = query.getOrDefault("bearer_token")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "bearer_token", valid_580306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580307: Call_MlProjectsJobsGetIamPolicy_580290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_580307.validator(path, query, header, formData, body)
  let scheme = call_580307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580307.url(scheme.get, call_580307.host, call_580307.base,
                         call_580307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580307, url, valid)

proc call*(call_580308: Call_MlProjectsJobsGetIamPolicy_580290; resource: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## mlProjectsJobsGetIamPolicy
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580309 = newJObject()
  var query_580310 = newJObject()
  add(query_580310, "upload_protocol", newJString(uploadProtocol))
  add(query_580310, "fields", newJString(fields))
  add(query_580310, "quotaUser", newJString(quotaUser))
  add(query_580310, "alt", newJString(alt))
  add(query_580310, "pp", newJBool(pp))
  add(query_580310, "oauth_token", newJString(oauthToken))
  add(query_580310, "callback", newJString(callback))
  add(query_580310, "access_token", newJString(accessToken))
  add(query_580310, "uploadType", newJString(uploadType))
  add(query_580310, "key", newJString(key))
  add(query_580310, "$.xgafv", newJString(Xgafv))
  add(path_580309, "resource", newJString(resource))
  add(query_580310, "prettyPrint", newJBool(prettyPrint))
  add(query_580310, "bearer_token", newJString(bearerToken))
  result = call_580308.call(path_580309, query_580310, nil, nil, nil)

var mlProjectsJobsGetIamPolicy* = Call_MlProjectsJobsGetIamPolicy_580290(
    name: "mlProjectsJobsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_MlProjectsJobsGetIamPolicy_580291, base: "/",
    url: url_MlProjectsJobsGetIamPolicy_580292, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsSetIamPolicy_580311 = ref object of OpenApiRestCall_579408
proc url_MlProjectsJobsSetIamPolicy_580313(protocol: Scheme; host: string;
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

proc validate_MlProjectsJobsSetIamPolicy_580312(path: JsonNode; query: JsonNode;
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
  var valid_580314 = path.getOrDefault("resource")
  valid_580314 = validateParameter(valid_580314, JString, required = true,
                                 default = nil)
  if valid_580314 != nil:
    section.add "resource", valid_580314
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
  var valid_580315 = query.getOrDefault("upload_protocol")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "upload_protocol", valid_580315
  var valid_580316 = query.getOrDefault("fields")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "fields", valid_580316
  var valid_580317 = query.getOrDefault("quotaUser")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "quotaUser", valid_580317
  var valid_580318 = query.getOrDefault("alt")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = newJString("json"))
  if valid_580318 != nil:
    section.add "alt", valid_580318
  var valid_580319 = query.getOrDefault("pp")
  valid_580319 = validateParameter(valid_580319, JBool, required = false,
                                 default = newJBool(true))
  if valid_580319 != nil:
    section.add "pp", valid_580319
  var valid_580320 = query.getOrDefault("oauth_token")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "oauth_token", valid_580320
  var valid_580321 = query.getOrDefault("callback")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "callback", valid_580321
  var valid_580322 = query.getOrDefault("access_token")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "access_token", valid_580322
  var valid_580323 = query.getOrDefault("uploadType")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "uploadType", valid_580323
  var valid_580324 = query.getOrDefault("key")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "key", valid_580324
  var valid_580325 = query.getOrDefault("$.xgafv")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = newJString("1"))
  if valid_580325 != nil:
    section.add "$.xgafv", valid_580325
  var valid_580326 = query.getOrDefault("prettyPrint")
  valid_580326 = validateParameter(valid_580326, JBool, required = false,
                                 default = newJBool(true))
  if valid_580326 != nil:
    section.add "prettyPrint", valid_580326
  var valid_580327 = query.getOrDefault("bearer_token")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "bearer_token", valid_580327
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

proc call*(call_580329: Call_MlProjectsJobsSetIamPolicy_580311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_580329.validator(path, query, header, formData, body)
  let scheme = call_580329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580329.url(scheme.get, call_580329.host, call_580329.base,
                         call_580329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580329, url, valid)

proc call*(call_580330: Call_MlProjectsJobsSetIamPolicy_580311; resource: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## mlProjectsJobsSetIamPolicy
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
  var path_580331 = newJObject()
  var query_580332 = newJObject()
  var body_580333 = newJObject()
  add(query_580332, "upload_protocol", newJString(uploadProtocol))
  add(query_580332, "fields", newJString(fields))
  add(query_580332, "quotaUser", newJString(quotaUser))
  add(query_580332, "alt", newJString(alt))
  add(query_580332, "pp", newJBool(pp))
  add(query_580332, "oauth_token", newJString(oauthToken))
  add(query_580332, "callback", newJString(callback))
  add(query_580332, "access_token", newJString(accessToken))
  add(query_580332, "uploadType", newJString(uploadType))
  add(query_580332, "key", newJString(key))
  add(query_580332, "$.xgafv", newJString(Xgafv))
  add(path_580331, "resource", newJString(resource))
  if body != nil:
    body_580333 = body
  add(query_580332, "prettyPrint", newJBool(prettyPrint))
  add(query_580332, "bearer_token", newJString(bearerToken))
  result = call_580330.call(path_580331, query_580332, nil, nil, body_580333)

var mlProjectsJobsSetIamPolicy* = Call_MlProjectsJobsSetIamPolicy_580311(
    name: "mlProjectsJobsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_MlProjectsJobsSetIamPolicy_580312, base: "/",
    url: url_MlProjectsJobsSetIamPolicy_580313, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsTestIamPermissions_580334 = ref object of OpenApiRestCall_579408
proc url_MlProjectsJobsTestIamPermissions_580336(protocol: Scheme; host: string;
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

proc validate_MlProjectsJobsTestIamPermissions_580335(path: JsonNode;
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
  var valid_580337 = path.getOrDefault("resource")
  valid_580337 = validateParameter(valid_580337, JString, required = true,
                                 default = nil)
  if valid_580337 != nil:
    section.add "resource", valid_580337
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
  var valid_580338 = query.getOrDefault("upload_protocol")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "upload_protocol", valid_580338
  var valid_580339 = query.getOrDefault("fields")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "fields", valid_580339
  var valid_580340 = query.getOrDefault("quotaUser")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "quotaUser", valid_580340
  var valid_580341 = query.getOrDefault("alt")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = newJString("json"))
  if valid_580341 != nil:
    section.add "alt", valid_580341
  var valid_580342 = query.getOrDefault("pp")
  valid_580342 = validateParameter(valid_580342, JBool, required = false,
                                 default = newJBool(true))
  if valid_580342 != nil:
    section.add "pp", valid_580342
  var valid_580343 = query.getOrDefault("oauth_token")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "oauth_token", valid_580343
  var valid_580344 = query.getOrDefault("callback")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "callback", valid_580344
  var valid_580345 = query.getOrDefault("access_token")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "access_token", valid_580345
  var valid_580346 = query.getOrDefault("uploadType")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "uploadType", valid_580346
  var valid_580347 = query.getOrDefault("key")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "key", valid_580347
  var valid_580348 = query.getOrDefault("$.xgafv")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = newJString("1"))
  if valid_580348 != nil:
    section.add "$.xgafv", valid_580348
  var valid_580349 = query.getOrDefault("prettyPrint")
  valid_580349 = validateParameter(valid_580349, JBool, required = false,
                                 default = newJBool(true))
  if valid_580349 != nil:
    section.add "prettyPrint", valid_580349
  var valid_580350 = query.getOrDefault("bearer_token")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "bearer_token", valid_580350
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

proc call*(call_580352: Call_MlProjectsJobsTestIamPermissions_580334;
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
  let valid = call_580352.validator(path, query, header, formData, body)
  let scheme = call_580352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580352.url(scheme.get, call_580352.host, call_580352.base,
                         call_580352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580352, url, valid)

proc call*(call_580353: Call_MlProjectsJobsTestIamPermissions_580334;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## mlProjectsJobsTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
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
  var path_580354 = newJObject()
  var query_580355 = newJObject()
  var body_580356 = newJObject()
  add(query_580355, "upload_protocol", newJString(uploadProtocol))
  add(query_580355, "fields", newJString(fields))
  add(query_580355, "quotaUser", newJString(quotaUser))
  add(query_580355, "alt", newJString(alt))
  add(query_580355, "pp", newJBool(pp))
  add(query_580355, "oauth_token", newJString(oauthToken))
  add(query_580355, "callback", newJString(callback))
  add(query_580355, "access_token", newJString(accessToken))
  add(query_580355, "uploadType", newJString(uploadType))
  add(query_580355, "key", newJString(key))
  add(query_580355, "$.xgafv", newJString(Xgafv))
  add(path_580354, "resource", newJString(resource))
  if body != nil:
    body_580356 = body
  add(query_580355, "prettyPrint", newJBool(prettyPrint))
  add(query_580355, "bearer_token", newJString(bearerToken))
  result = call_580353.call(path_580354, query_580355, nil, nil, body_580356)

var mlProjectsJobsTestIamPermissions* = Call_MlProjectsJobsTestIamPermissions_580334(
    name: "mlProjectsJobsTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{resource}:testIamPermissions",
    validator: validate_MlProjectsJobsTestIamPermissions_580335, base: "/",
    url: url_MlProjectsJobsTestIamPermissions_580336, schemes: {Scheme.Https})
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
