
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MlProjectsJobsGet_593677 = ref object of OpenApiRestCall_593408
proc url_MlProjectsJobsGet_593679(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_MlProjectsJobsGet_593678(path: JsonNode; query: JsonNode;
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
  var valid_593805 = path.getOrDefault("name")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "name", valid_593805
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
  var valid_593806 = query.getOrDefault("upload_protocol")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "upload_protocol", valid_593806
  var valid_593807 = query.getOrDefault("fields")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "fields", valid_593807
  var valid_593808 = query.getOrDefault("quotaUser")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "quotaUser", valid_593808
  var valid_593822 = query.getOrDefault("alt")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("json"))
  if valid_593822 != nil:
    section.add "alt", valid_593822
  var valid_593823 = query.getOrDefault("pp")
  valid_593823 = validateParameter(valid_593823, JBool, required = false,
                                 default = newJBool(true))
  if valid_593823 != nil:
    section.add "pp", valid_593823
  var valid_593824 = query.getOrDefault("oauth_token")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "oauth_token", valid_593824
  var valid_593825 = query.getOrDefault("callback")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "callback", valid_593825
  var valid_593826 = query.getOrDefault("access_token")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "access_token", valid_593826
  var valid_593827 = query.getOrDefault("uploadType")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "uploadType", valid_593827
  var valid_593828 = query.getOrDefault("key")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = nil)
  if valid_593828 != nil:
    section.add "key", valid_593828
  var valid_593829 = query.getOrDefault("$.xgafv")
  valid_593829 = validateParameter(valid_593829, JString, required = false,
                                 default = newJString("1"))
  if valid_593829 != nil:
    section.add "$.xgafv", valid_593829
  var valid_593830 = query.getOrDefault("prettyPrint")
  valid_593830 = validateParameter(valid_593830, JBool, required = false,
                                 default = newJBool(true))
  if valid_593830 != nil:
    section.add "prettyPrint", valid_593830
  var valid_593831 = query.getOrDefault("bearer_token")
  valid_593831 = validateParameter(valid_593831, JString, required = false,
                                 default = nil)
  if valid_593831 != nil:
    section.add "bearer_token", valid_593831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593854: Call_MlProjectsJobsGet_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Describes a job.
  ## 
  let valid = call_593854.validator(path, query, header, formData, body)
  let scheme = call_593854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593854.url(scheme.get, call_593854.host, call_593854.base,
                         call_593854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593854, url, valid)

proc call*(call_593925: Call_MlProjectsJobsGet_593677; name: string;
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
  var path_593926 = newJObject()
  var query_593928 = newJObject()
  add(query_593928, "upload_protocol", newJString(uploadProtocol))
  add(query_593928, "fields", newJString(fields))
  add(query_593928, "quotaUser", newJString(quotaUser))
  add(path_593926, "name", newJString(name))
  add(query_593928, "alt", newJString(alt))
  add(query_593928, "pp", newJBool(pp))
  add(query_593928, "oauth_token", newJString(oauthToken))
  add(query_593928, "callback", newJString(callback))
  add(query_593928, "access_token", newJString(accessToken))
  add(query_593928, "uploadType", newJString(uploadType))
  add(query_593928, "key", newJString(key))
  add(query_593928, "$.xgafv", newJString(Xgafv))
  add(query_593928, "prettyPrint", newJBool(prettyPrint))
  add(query_593928, "bearer_token", newJString(bearerToken))
  result = call_593925.call(path_593926, query_593928, nil, nil, nil)

var mlProjectsJobsGet* = Call_MlProjectsJobsGet_593677(name: "mlProjectsJobsGet",
    meth: HttpMethod.HttpGet, host: "ml.googleapis.com", route: "/v1/{name}",
    validator: validate_MlProjectsJobsGet_593678, base: "/",
    url: url_MlProjectsJobsGet_593679, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsPatch_593988 = ref object of OpenApiRestCall_593408
proc url_MlProjectsJobsPatch_593990(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_MlProjectsJobsPatch_593989(path: JsonNode; query: JsonNode;
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
  var valid_593991 = path.getOrDefault("name")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "name", valid_593991
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
  var valid_593992 = query.getOrDefault("upload_protocol")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "upload_protocol", valid_593992
  var valid_593993 = query.getOrDefault("fields")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "fields", valid_593993
  var valid_593994 = query.getOrDefault("quotaUser")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "quotaUser", valid_593994
  var valid_593995 = query.getOrDefault("alt")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = newJString("json"))
  if valid_593995 != nil:
    section.add "alt", valid_593995
  var valid_593996 = query.getOrDefault("pp")
  valid_593996 = validateParameter(valid_593996, JBool, required = false,
                                 default = newJBool(true))
  if valid_593996 != nil:
    section.add "pp", valid_593996
  var valid_593997 = query.getOrDefault("oauth_token")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "oauth_token", valid_593997
  var valid_593998 = query.getOrDefault("callback")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "callback", valid_593998
  var valid_593999 = query.getOrDefault("access_token")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "access_token", valid_593999
  var valid_594000 = query.getOrDefault("uploadType")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "uploadType", valid_594000
  var valid_594001 = query.getOrDefault("key")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "key", valid_594001
  var valid_594002 = query.getOrDefault("$.xgafv")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = newJString("1"))
  if valid_594002 != nil:
    section.add "$.xgafv", valid_594002
  var valid_594003 = query.getOrDefault("prettyPrint")
  valid_594003 = validateParameter(valid_594003, JBool, required = false,
                                 default = newJBool(true))
  if valid_594003 != nil:
    section.add "prettyPrint", valid_594003
  var valid_594004 = query.getOrDefault("updateMask")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "updateMask", valid_594004
  var valid_594005 = query.getOrDefault("bearer_token")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "bearer_token", valid_594005
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

proc call*(call_594007: Call_MlProjectsJobsPatch_593988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a specific job resource.
  ## 
  ## Currently the only supported fields to update are `labels`.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_MlProjectsJobsPatch_593988; name: string;
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
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  var body_594011 = newJObject()
  add(query_594010, "upload_protocol", newJString(uploadProtocol))
  add(query_594010, "fields", newJString(fields))
  add(query_594010, "quotaUser", newJString(quotaUser))
  add(path_594009, "name", newJString(name))
  add(query_594010, "alt", newJString(alt))
  add(query_594010, "pp", newJBool(pp))
  add(query_594010, "oauth_token", newJString(oauthToken))
  add(query_594010, "callback", newJString(callback))
  add(query_594010, "access_token", newJString(accessToken))
  add(query_594010, "uploadType", newJString(uploadType))
  add(query_594010, "key", newJString(key))
  add(query_594010, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594011 = body
  add(query_594010, "prettyPrint", newJBool(prettyPrint))
  add(query_594010, "updateMask", newJString(updateMask))
  add(query_594010, "bearer_token", newJString(bearerToken))
  result = call_594008.call(path_594009, query_594010, nil, nil, body_594011)

var mlProjectsJobsPatch* = Call_MlProjectsJobsPatch_593988(
    name: "mlProjectsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "ml.googleapis.com", route: "/v1/{name}",
    validator: validate_MlProjectsJobsPatch_593989, base: "/",
    url: url_MlProjectsJobsPatch_593990, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsDelete_593967 = ref object of OpenApiRestCall_593408
proc url_MlProjectsModelsVersionsDelete_593969(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_MlProjectsModelsVersionsDelete_593968(path: JsonNode;
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
  var valid_593970 = path.getOrDefault("name")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "name", valid_593970
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
  var valid_593971 = query.getOrDefault("upload_protocol")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "upload_protocol", valid_593971
  var valid_593972 = query.getOrDefault("fields")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "fields", valid_593972
  var valid_593973 = query.getOrDefault("quotaUser")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "quotaUser", valid_593973
  var valid_593974 = query.getOrDefault("alt")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = newJString("json"))
  if valid_593974 != nil:
    section.add "alt", valid_593974
  var valid_593975 = query.getOrDefault("pp")
  valid_593975 = validateParameter(valid_593975, JBool, required = false,
                                 default = newJBool(true))
  if valid_593975 != nil:
    section.add "pp", valid_593975
  var valid_593976 = query.getOrDefault("oauth_token")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "oauth_token", valid_593976
  var valid_593977 = query.getOrDefault("callback")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "callback", valid_593977
  var valid_593978 = query.getOrDefault("access_token")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "access_token", valid_593978
  var valid_593979 = query.getOrDefault("uploadType")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "uploadType", valid_593979
  var valid_593980 = query.getOrDefault("key")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "key", valid_593980
  var valid_593981 = query.getOrDefault("$.xgafv")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = newJString("1"))
  if valid_593981 != nil:
    section.add "$.xgafv", valid_593981
  var valid_593982 = query.getOrDefault("prettyPrint")
  valid_593982 = validateParameter(valid_593982, JBool, required = false,
                                 default = newJBool(true))
  if valid_593982 != nil:
    section.add "prettyPrint", valid_593982
  var valid_593983 = query.getOrDefault("bearer_token")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "bearer_token", valid_593983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_MlProjectsModelsVersionsDelete_593967; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a model version.
  ## 
  ## Each model can have multiple versions deployed and in use at any given
  ## time. Use this method to remove a single version.
  ## 
  ## Note: You cannot delete the version that is set as the default version
  ## of the model unless it is the only remaining version.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_MlProjectsModelsVersionsDelete_593967; name: string;
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
  var path_593986 = newJObject()
  var query_593987 = newJObject()
  add(query_593987, "upload_protocol", newJString(uploadProtocol))
  add(query_593987, "fields", newJString(fields))
  add(query_593987, "quotaUser", newJString(quotaUser))
  add(path_593986, "name", newJString(name))
  add(query_593987, "alt", newJString(alt))
  add(query_593987, "pp", newJBool(pp))
  add(query_593987, "oauth_token", newJString(oauthToken))
  add(query_593987, "callback", newJString(callback))
  add(query_593987, "access_token", newJString(accessToken))
  add(query_593987, "uploadType", newJString(uploadType))
  add(query_593987, "key", newJString(key))
  add(query_593987, "$.xgafv", newJString(Xgafv))
  add(query_593987, "prettyPrint", newJBool(prettyPrint))
  add(query_593987, "bearer_token", newJString(bearerToken))
  result = call_593985.call(path_593986, query_593987, nil, nil, nil)

var mlProjectsModelsVersionsDelete* = Call_MlProjectsModelsVersionsDelete_593967(
    name: "mlProjectsModelsVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "ml.googleapis.com", route: "/v1/{name}",
    validator: validate_MlProjectsModelsVersionsDelete_593968, base: "/",
    url: url_MlProjectsModelsVersionsDelete_593969, schemes: {Scheme.Https})
type
  Call_MlProjectsOperationsList_594012 = ref object of OpenApiRestCall_593408
proc url_MlProjectsOperationsList_594014(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MlProjectsOperationsList_594013(path: JsonNode; query: JsonNode;
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
  var valid_594015 = path.getOrDefault("name")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "name", valid_594015
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
  var valid_594016 = query.getOrDefault("upload_protocol")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "upload_protocol", valid_594016
  var valid_594017 = query.getOrDefault("fields")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "fields", valid_594017
  var valid_594018 = query.getOrDefault("pageToken")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "pageToken", valid_594018
  var valid_594019 = query.getOrDefault("quotaUser")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "quotaUser", valid_594019
  var valid_594020 = query.getOrDefault("alt")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = newJString("json"))
  if valid_594020 != nil:
    section.add "alt", valid_594020
  var valid_594021 = query.getOrDefault("pp")
  valid_594021 = validateParameter(valid_594021, JBool, required = false,
                                 default = newJBool(true))
  if valid_594021 != nil:
    section.add "pp", valid_594021
  var valid_594022 = query.getOrDefault("oauth_token")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "oauth_token", valid_594022
  var valid_594023 = query.getOrDefault("callback")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "callback", valid_594023
  var valid_594024 = query.getOrDefault("access_token")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "access_token", valid_594024
  var valid_594025 = query.getOrDefault("uploadType")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "uploadType", valid_594025
  var valid_594026 = query.getOrDefault("key")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "key", valid_594026
  var valid_594027 = query.getOrDefault("$.xgafv")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = newJString("1"))
  if valid_594027 != nil:
    section.add "$.xgafv", valid_594027
  var valid_594028 = query.getOrDefault("pageSize")
  valid_594028 = validateParameter(valid_594028, JInt, required = false, default = nil)
  if valid_594028 != nil:
    section.add "pageSize", valid_594028
  var valid_594029 = query.getOrDefault("prettyPrint")
  valid_594029 = validateParameter(valid_594029, JBool, required = false,
                                 default = newJBool(true))
  if valid_594029 != nil:
    section.add "prettyPrint", valid_594029
  var valid_594030 = query.getOrDefault("filter")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "filter", valid_594030
  var valid_594031 = query.getOrDefault("bearer_token")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "bearer_token", valid_594031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_MlProjectsOperationsList_594012; path: JsonNode;
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
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_MlProjectsOperationsList_594012; name: string;
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
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  add(query_594035, "upload_protocol", newJString(uploadProtocol))
  add(query_594035, "fields", newJString(fields))
  add(query_594035, "pageToken", newJString(pageToken))
  add(query_594035, "quotaUser", newJString(quotaUser))
  add(path_594034, "name", newJString(name))
  add(query_594035, "alt", newJString(alt))
  add(query_594035, "pp", newJBool(pp))
  add(query_594035, "oauth_token", newJString(oauthToken))
  add(query_594035, "callback", newJString(callback))
  add(query_594035, "access_token", newJString(accessToken))
  add(query_594035, "uploadType", newJString(uploadType))
  add(query_594035, "key", newJString(key))
  add(query_594035, "$.xgafv", newJString(Xgafv))
  add(query_594035, "pageSize", newJInt(pageSize))
  add(query_594035, "prettyPrint", newJBool(prettyPrint))
  add(query_594035, "filter", newJString(filter))
  add(query_594035, "bearer_token", newJString(bearerToken))
  result = call_594033.call(path_594034, query_594035, nil, nil, nil)

var mlProjectsOperationsList* = Call_MlProjectsOperationsList_594012(
    name: "mlProjectsOperationsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{name}/operations",
    validator: validate_MlProjectsOperationsList_594013, base: "/",
    url: url_MlProjectsOperationsList_594014, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsCancel_594036 = ref object of OpenApiRestCall_593408
proc url_MlProjectsJobsCancel_594038(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MlProjectsJobsCancel_594037(path: JsonNode; query: JsonNode;
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
  var valid_594039 = path.getOrDefault("name")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "name", valid_594039
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
  var valid_594040 = query.getOrDefault("upload_protocol")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "upload_protocol", valid_594040
  var valid_594041 = query.getOrDefault("fields")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "fields", valid_594041
  var valid_594042 = query.getOrDefault("quotaUser")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "quotaUser", valid_594042
  var valid_594043 = query.getOrDefault("alt")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = newJString("json"))
  if valid_594043 != nil:
    section.add "alt", valid_594043
  var valid_594044 = query.getOrDefault("pp")
  valid_594044 = validateParameter(valid_594044, JBool, required = false,
                                 default = newJBool(true))
  if valid_594044 != nil:
    section.add "pp", valid_594044
  var valid_594045 = query.getOrDefault("oauth_token")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "oauth_token", valid_594045
  var valid_594046 = query.getOrDefault("callback")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "callback", valid_594046
  var valid_594047 = query.getOrDefault("access_token")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "access_token", valid_594047
  var valid_594048 = query.getOrDefault("uploadType")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "uploadType", valid_594048
  var valid_594049 = query.getOrDefault("key")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "key", valid_594049
  var valid_594050 = query.getOrDefault("$.xgafv")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = newJString("1"))
  if valid_594050 != nil:
    section.add "$.xgafv", valid_594050
  var valid_594051 = query.getOrDefault("prettyPrint")
  valid_594051 = validateParameter(valid_594051, JBool, required = false,
                                 default = newJBool(true))
  if valid_594051 != nil:
    section.add "prettyPrint", valid_594051
  var valid_594052 = query.getOrDefault("bearer_token")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "bearer_token", valid_594052
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

proc call*(call_594054: Call_MlProjectsJobsCancel_594036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a running job.
  ## 
  let valid = call_594054.validator(path, query, header, formData, body)
  let scheme = call_594054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594054.url(scheme.get, call_594054.host, call_594054.base,
                         call_594054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594054, url, valid)

proc call*(call_594055: Call_MlProjectsJobsCancel_594036; name: string;
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
  var path_594056 = newJObject()
  var query_594057 = newJObject()
  var body_594058 = newJObject()
  add(query_594057, "upload_protocol", newJString(uploadProtocol))
  add(query_594057, "fields", newJString(fields))
  add(query_594057, "quotaUser", newJString(quotaUser))
  add(path_594056, "name", newJString(name))
  add(query_594057, "alt", newJString(alt))
  add(query_594057, "pp", newJBool(pp))
  add(query_594057, "oauth_token", newJString(oauthToken))
  add(query_594057, "callback", newJString(callback))
  add(query_594057, "access_token", newJString(accessToken))
  add(query_594057, "uploadType", newJString(uploadType))
  add(query_594057, "key", newJString(key))
  add(query_594057, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594058 = body
  add(query_594057, "prettyPrint", newJBool(prettyPrint))
  add(query_594057, "bearer_token", newJString(bearerToken))
  result = call_594055.call(path_594056, query_594057, nil, nil, body_594058)

var mlProjectsJobsCancel* = Call_MlProjectsJobsCancel_594036(
    name: "mlProjectsJobsCancel", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_MlProjectsJobsCancel_594037, base: "/",
    url: url_MlProjectsJobsCancel_594038, schemes: {Scheme.Https})
type
  Call_MlProjectsGetConfig_594059 = ref object of OpenApiRestCall_593408
proc url_MlProjectsGetConfig_594061(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MlProjectsGetConfig_594060(path: JsonNode; query: JsonNode;
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
  var valid_594062 = path.getOrDefault("name")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "name", valid_594062
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
  var valid_594063 = query.getOrDefault("upload_protocol")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "upload_protocol", valid_594063
  var valid_594064 = query.getOrDefault("fields")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "fields", valid_594064
  var valid_594065 = query.getOrDefault("quotaUser")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "quotaUser", valid_594065
  var valid_594066 = query.getOrDefault("alt")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = newJString("json"))
  if valid_594066 != nil:
    section.add "alt", valid_594066
  var valid_594067 = query.getOrDefault("pp")
  valid_594067 = validateParameter(valid_594067, JBool, required = false,
                                 default = newJBool(true))
  if valid_594067 != nil:
    section.add "pp", valid_594067
  var valid_594068 = query.getOrDefault("oauth_token")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "oauth_token", valid_594068
  var valid_594069 = query.getOrDefault("callback")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "callback", valid_594069
  var valid_594070 = query.getOrDefault("access_token")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "access_token", valid_594070
  var valid_594071 = query.getOrDefault("uploadType")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "uploadType", valid_594071
  var valid_594072 = query.getOrDefault("key")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "key", valid_594072
  var valid_594073 = query.getOrDefault("$.xgafv")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = newJString("1"))
  if valid_594073 != nil:
    section.add "$.xgafv", valid_594073
  var valid_594074 = query.getOrDefault("prettyPrint")
  valid_594074 = validateParameter(valid_594074, JBool, required = false,
                                 default = newJBool(true))
  if valid_594074 != nil:
    section.add "prettyPrint", valid_594074
  var valid_594075 = query.getOrDefault("bearer_token")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "bearer_token", valid_594075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594076: Call_MlProjectsGetConfig_594059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the service account information associated with your project. You need
  ## this information in order to grant the service account persmissions for
  ## the Google Cloud Storage location where you put your model training code
  ## for training the model with Google Cloud Machine Learning.
  ## 
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_MlProjectsGetConfig_594059; name: string;
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
  var path_594078 = newJObject()
  var query_594079 = newJObject()
  add(query_594079, "upload_protocol", newJString(uploadProtocol))
  add(query_594079, "fields", newJString(fields))
  add(query_594079, "quotaUser", newJString(quotaUser))
  add(path_594078, "name", newJString(name))
  add(query_594079, "alt", newJString(alt))
  add(query_594079, "pp", newJBool(pp))
  add(query_594079, "oauth_token", newJString(oauthToken))
  add(query_594079, "callback", newJString(callback))
  add(query_594079, "access_token", newJString(accessToken))
  add(query_594079, "uploadType", newJString(uploadType))
  add(query_594079, "key", newJString(key))
  add(query_594079, "$.xgafv", newJString(Xgafv))
  add(query_594079, "prettyPrint", newJBool(prettyPrint))
  add(query_594079, "bearer_token", newJString(bearerToken))
  result = call_594077.call(path_594078, query_594079, nil, nil, nil)

var mlProjectsGetConfig* = Call_MlProjectsGetConfig_594059(
    name: "mlProjectsGetConfig", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{name}:getConfig",
    validator: validate_MlProjectsGetConfig_594060, base: "/",
    url: url_MlProjectsGetConfig_594061, schemes: {Scheme.Https})
type
  Call_MlProjectsPredict_594080 = ref object of OpenApiRestCall_593408
proc url_MlProjectsPredict_594082(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MlProjectsPredict_594081(path: JsonNode; query: JsonNode;
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
  var valid_594083 = path.getOrDefault("name")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "name", valid_594083
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
  var valid_594084 = query.getOrDefault("upload_protocol")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "upload_protocol", valid_594084
  var valid_594085 = query.getOrDefault("fields")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "fields", valid_594085
  var valid_594086 = query.getOrDefault("quotaUser")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "quotaUser", valid_594086
  var valid_594087 = query.getOrDefault("alt")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = newJString("json"))
  if valid_594087 != nil:
    section.add "alt", valid_594087
  var valid_594088 = query.getOrDefault("pp")
  valid_594088 = validateParameter(valid_594088, JBool, required = false,
                                 default = newJBool(true))
  if valid_594088 != nil:
    section.add "pp", valid_594088
  var valid_594089 = query.getOrDefault("oauth_token")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "oauth_token", valid_594089
  var valid_594090 = query.getOrDefault("callback")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "callback", valid_594090
  var valid_594091 = query.getOrDefault("access_token")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "access_token", valid_594091
  var valid_594092 = query.getOrDefault("uploadType")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "uploadType", valid_594092
  var valid_594093 = query.getOrDefault("key")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "key", valid_594093
  var valid_594094 = query.getOrDefault("$.xgafv")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = newJString("1"))
  if valid_594094 != nil:
    section.add "$.xgafv", valid_594094
  var valid_594095 = query.getOrDefault("prettyPrint")
  valid_594095 = validateParameter(valid_594095, JBool, required = false,
                                 default = newJBool(true))
  if valid_594095 != nil:
    section.add "prettyPrint", valid_594095
  var valid_594096 = query.getOrDefault("bearer_token")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "bearer_token", valid_594096
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

proc call*(call_594098: Call_MlProjectsPredict_594080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs prediction on the data in the request.
  ## Cloud ML Engine implements a custom `predict` verb on top of an HTTP POST
  ## method. For details of the format, see the **guide to the
  ## [predict request format](/ml-engine/docs/v1/predict-request)**.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_MlProjectsPredict_594080; name: string;
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
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  var body_594102 = newJObject()
  add(query_594101, "upload_protocol", newJString(uploadProtocol))
  add(query_594101, "fields", newJString(fields))
  add(query_594101, "quotaUser", newJString(quotaUser))
  add(path_594100, "name", newJString(name))
  add(query_594101, "alt", newJString(alt))
  add(query_594101, "pp", newJBool(pp))
  add(query_594101, "oauth_token", newJString(oauthToken))
  add(query_594101, "callback", newJString(callback))
  add(query_594101, "access_token", newJString(accessToken))
  add(query_594101, "uploadType", newJString(uploadType))
  add(query_594101, "key", newJString(key))
  add(query_594101, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594102 = body
  add(query_594101, "prettyPrint", newJBool(prettyPrint))
  add(query_594101, "bearer_token", newJString(bearerToken))
  result = call_594099.call(path_594100, query_594101, nil, nil, body_594102)

var mlProjectsPredict* = Call_MlProjectsPredict_594080(name: "mlProjectsPredict",
    meth: HttpMethod.HttpPost, host: "ml.googleapis.com",
    route: "/v1/{name}:predict", validator: validate_MlProjectsPredict_594081,
    base: "/", url: url_MlProjectsPredict_594082, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsSetDefault_594103 = ref object of OpenApiRestCall_593408
proc url_MlProjectsModelsVersionsSetDefault_594105(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MlProjectsModelsVersionsSetDefault_594104(path: JsonNode;
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
  var valid_594106 = path.getOrDefault("name")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "name", valid_594106
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
  var valid_594107 = query.getOrDefault("upload_protocol")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "upload_protocol", valid_594107
  var valid_594108 = query.getOrDefault("fields")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "fields", valid_594108
  var valid_594109 = query.getOrDefault("quotaUser")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "quotaUser", valid_594109
  var valid_594110 = query.getOrDefault("alt")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = newJString("json"))
  if valid_594110 != nil:
    section.add "alt", valid_594110
  var valid_594111 = query.getOrDefault("pp")
  valid_594111 = validateParameter(valid_594111, JBool, required = false,
                                 default = newJBool(true))
  if valid_594111 != nil:
    section.add "pp", valid_594111
  var valid_594112 = query.getOrDefault("oauth_token")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "oauth_token", valid_594112
  var valid_594113 = query.getOrDefault("callback")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "callback", valid_594113
  var valid_594114 = query.getOrDefault("access_token")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "access_token", valid_594114
  var valid_594115 = query.getOrDefault("uploadType")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "uploadType", valid_594115
  var valid_594116 = query.getOrDefault("key")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "key", valid_594116
  var valid_594117 = query.getOrDefault("$.xgafv")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = newJString("1"))
  if valid_594117 != nil:
    section.add "$.xgafv", valid_594117
  var valid_594118 = query.getOrDefault("prettyPrint")
  valid_594118 = validateParameter(valid_594118, JBool, required = false,
                                 default = newJBool(true))
  if valid_594118 != nil:
    section.add "prettyPrint", valid_594118
  var valid_594119 = query.getOrDefault("bearer_token")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "bearer_token", valid_594119
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

proc call*(call_594121: Call_MlProjectsModelsVersionsSetDefault_594103;
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
  let valid = call_594121.validator(path, query, header, formData, body)
  let scheme = call_594121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594121.url(scheme.get, call_594121.host, call_594121.base,
                         call_594121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594121, url, valid)

proc call*(call_594122: Call_MlProjectsModelsVersionsSetDefault_594103;
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
  var path_594123 = newJObject()
  var query_594124 = newJObject()
  var body_594125 = newJObject()
  add(query_594124, "upload_protocol", newJString(uploadProtocol))
  add(query_594124, "fields", newJString(fields))
  add(query_594124, "quotaUser", newJString(quotaUser))
  add(path_594123, "name", newJString(name))
  add(query_594124, "alt", newJString(alt))
  add(query_594124, "pp", newJBool(pp))
  add(query_594124, "oauth_token", newJString(oauthToken))
  add(query_594124, "callback", newJString(callback))
  add(query_594124, "access_token", newJString(accessToken))
  add(query_594124, "uploadType", newJString(uploadType))
  add(query_594124, "key", newJString(key))
  add(query_594124, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594125 = body
  add(query_594124, "prettyPrint", newJBool(prettyPrint))
  add(query_594124, "bearer_token", newJString(bearerToken))
  result = call_594122.call(path_594123, query_594124, nil, nil, body_594125)

var mlProjectsModelsVersionsSetDefault* = Call_MlProjectsModelsVersionsSetDefault_594103(
    name: "mlProjectsModelsVersionsSetDefault", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{name}:setDefault",
    validator: validate_MlProjectsModelsVersionsSetDefault_594104, base: "/",
    url: url_MlProjectsModelsVersionsSetDefault_594105, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsCreate_594150 = ref object of OpenApiRestCall_593408
proc url_MlProjectsJobsCreate_594152(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MlProjectsJobsCreate_594151(path: JsonNode; query: JsonNode;
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
  var valid_594153 = path.getOrDefault("parent")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "parent", valid_594153
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
  var valid_594154 = query.getOrDefault("upload_protocol")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "upload_protocol", valid_594154
  var valid_594155 = query.getOrDefault("fields")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "fields", valid_594155
  var valid_594156 = query.getOrDefault("quotaUser")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "quotaUser", valid_594156
  var valid_594157 = query.getOrDefault("alt")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = newJString("json"))
  if valid_594157 != nil:
    section.add "alt", valid_594157
  var valid_594158 = query.getOrDefault("pp")
  valid_594158 = validateParameter(valid_594158, JBool, required = false,
                                 default = newJBool(true))
  if valid_594158 != nil:
    section.add "pp", valid_594158
  var valid_594159 = query.getOrDefault("oauth_token")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "oauth_token", valid_594159
  var valid_594160 = query.getOrDefault("callback")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "callback", valid_594160
  var valid_594161 = query.getOrDefault("access_token")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "access_token", valid_594161
  var valid_594162 = query.getOrDefault("uploadType")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "uploadType", valid_594162
  var valid_594163 = query.getOrDefault("key")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "key", valid_594163
  var valid_594164 = query.getOrDefault("$.xgafv")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = newJString("1"))
  if valid_594164 != nil:
    section.add "$.xgafv", valid_594164
  var valid_594165 = query.getOrDefault("prettyPrint")
  valid_594165 = validateParameter(valid_594165, JBool, required = false,
                                 default = newJBool(true))
  if valid_594165 != nil:
    section.add "prettyPrint", valid_594165
  var valid_594166 = query.getOrDefault("bearer_token")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "bearer_token", valid_594166
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

proc call*(call_594168: Call_MlProjectsJobsCreate_594150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a training or a batch prediction job.
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_MlProjectsJobsCreate_594150; parent: string;
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
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  var body_594172 = newJObject()
  add(query_594171, "upload_protocol", newJString(uploadProtocol))
  add(query_594171, "fields", newJString(fields))
  add(query_594171, "quotaUser", newJString(quotaUser))
  add(query_594171, "alt", newJString(alt))
  add(query_594171, "pp", newJBool(pp))
  add(query_594171, "oauth_token", newJString(oauthToken))
  add(query_594171, "callback", newJString(callback))
  add(query_594171, "access_token", newJString(accessToken))
  add(query_594171, "uploadType", newJString(uploadType))
  add(path_594170, "parent", newJString(parent))
  add(query_594171, "key", newJString(key))
  add(query_594171, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594172 = body
  add(query_594171, "prettyPrint", newJBool(prettyPrint))
  add(query_594171, "bearer_token", newJString(bearerToken))
  result = call_594169.call(path_594170, query_594171, nil, nil, body_594172)

var mlProjectsJobsCreate* = Call_MlProjectsJobsCreate_594150(
    name: "mlProjectsJobsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{parent}/jobs",
    validator: validate_MlProjectsJobsCreate_594151, base: "/",
    url: url_MlProjectsJobsCreate_594152, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsList_594126 = ref object of OpenApiRestCall_593408
proc url_MlProjectsJobsList_594128(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MlProjectsJobsList_594127(path: JsonNode; query: JsonNode;
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
  var valid_594129 = path.getOrDefault("parent")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "parent", valid_594129
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
  var valid_594130 = query.getOrDefault("upload_protocol")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "upload_protocol", valid_594130
  var valid_594131 = query.getOrDefault("fields")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "fields", valid_594131
  var valid_594132 = query.getOrDefault("pageToken")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "pageToken", valid_594132
  var valid_594133 = query.getOrDefault("quotaUser")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "quotaUser", valid_594133
  var valid_594134 = query.getOrDefault("alt")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = newJString("json"))
  if valid_594134 != nil:
    section.add "alt", valid_594134
  var valid_594135 = query.getOrDefault("pp")
  valid_594135 = validateParameter(valid_594135, JBool, required = false,
                                 default = newJBool(true))
  if valid_594135 != nil:
    section.add "pp", valid_594135
  var valid_594136 = query.getOrDefault("oauth_token")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "oauth_token", valid_594136
  var valid_594137 = query.getOrDefault("callback")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "callback", valid_594137
  var valid_594138 = query.getOrDefault("access_token")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "access_token", valid_594138
  var valid_594139 = query.getOrDefault("uploadType")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "uploadType", valid_594139
  var valid_594140 = query.getOrDefault("key")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "key", valid_594140
  var valid_594141 = query.getOrDefault("$.xgafv")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = newJString("1"))
  if valid_594141 != nil:
    section.add "$.xgafv", valid_594141
  var valid_594142 = query.getOrDefault("pageSize")
  valid_594142 = validateParameter(valid_594142, JInt, required = false, default = nil)
  if valid_594142 != nil:
    section.add "pageSize", valid_594142
  var valid_594143 = query.getOrDefault("prettyPrint")
  valid_594143 = validateParameter(valid_594143, JBool, required = false,
                                 default = newJBool(true))
  if valid_594143 != nil:
    section.add "prettyPrint", valid_594143
  var valid_594144 = query.getOrDefault("filter")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "filter", valid_594144
  var valid_594145 = query.getOrDefault("bearer_token")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "bearer_token", valid_594145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594146: Call_MlProjectsJobsList_594126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the jobs in the project.
  ## 
  let valid = call_594146.validator(path, query, header, formData, body)
  let scheme = call_594146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594146.url(scheme.get, call_594146.host, call_594146.base,
                         call_594146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594146, url, valid)

proc call*(call_594147: Call_MlProjectsJobsList_594126; parent: string;
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
  var path_594148 = newJObject()
  var query_594149 = newJObject()
  add(query_594149, "upload_protocol", newJString(uploadProtocol))
  add(query_594149, "fields", newJString(fields))
  add(query_594149, "pageToken", newJString(pageToken))
  add(query_594149, "quotaUser", newJString(quotaUser))
  add(query_594149, "alt", newJString(alt))
  add(query_594149, "pp", newJBool(pp))
  add(query_594149, "oauth_token", newJString(oauthToken))
  add(query_594149, "callback", newJString(callback))
  add(query_594149, "access_token", newJString(accessToken))
  add(query_594149, "uploadType", newJString(uploadType))
  add(path_594148, "parent", newJString(parent))
  add(query_594149, "key", newJString(key))
  add(query_594149, "$.xgafv", newJString(Xgafv))
  add(query_594149, "pageSize", newJInt(pageSize))
  add(query_594149, "prettyPrint", newJBool(prettyPrint))
  add(query_594149, "filter", newJString(filter))
  add(query_594149, "bearer_token", newJString(bearerToken))
  result = call_594147.call(path_594148, query_594149, nil, nil, nil)

var mlProjectsJobsList* = Call_MlProjectsJobsList_594126(
    name: "mlProjectsJobsList", meth: HttpMethod.HttpGet, host: "ml.googleapis.com",
    route: "/v1/{parent}/jobs", validator: validate_MlProjectsJobsList_594127,
    base: "/", url: url_MlProjectsJobsList_594128, schemes: {Scheme.Https})
type
  Call_MlProjectsLocationsList_594173 = ref object of OpenApiRestCall_593408
proc url_MlProjectsLocationsList_594175(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MlProjectsLocationsList_594174(path: JsonNode; query: JsonNode;
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
  var valid_594176 = path.getOrDefault("parent")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "parent", valid_594176
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
  var valid_594177 = query.getOrDefault("upload_protocol")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "upload_protocol", valid_594177
  var valid_594178 = query.getOrDefault("fields")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "fields", valid_594178
  var valid_594179 = query.getOrDefault("pageToken")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "pageToken", valid_594179
  var valid_594180 = query.getOrDefault("quotaUser")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "quotaUser", valid_594180
  var valid_594181 = query.getOrDefault("alt")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = newJString("json"))
  if valid_594181 != nil:
    section.add "alt", valid_594181
  var valid_594182 = query.getOrDefault("pp")
  valid_594182 = validateParameter(valid_594182, JBool, required = false,
                                 default = newJBool(true))
  if valid_594182 != nil:
    section.add "pp", valid_594182
  var valid_594183 = query.getOrDefault("oauth_token")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "oauth_token", valid_594183
  var valid_594184 = query.getOrDefault("callback")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "callback", valid_594184
  var valid_594185 = query.getOrDefault("access_token")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "access_token", valid_594185
  var valid_594186 = query.getOrDefault("uploadType")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "uploadType", valid_594186
  var valid_594187 = query.getOrDefault("key")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "key", valid_594187
  var valid_594188 = query.getOrDefault("$.xgafv")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = newJString("1"))
  if valid_594188 != nil:
    section.add "$.xgafv", valid_594188
  var valid_594189 = query.getOrDefault("pageSize")
  valid_594189 = validateParameter(valid_594189, JInt, required = false, default = nil)
  if valid_594189 != nil:
    section.add "pageSize", valid_594189
  var valid_594190 = query.getOrDefault("prettyPrint")
  valid_594190 = validateParameter(valid_594190, JBool, required = false,
                                 default = newJBool(true))
  if valid_594190 != nil:
    section.add "prettyPrint", valid_594190
  var valid_594191 = query.getOrDefault("bearer_token")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "bearer_token", valid_594191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594192: Call_MlProjectsLocationsList_594173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all locations that provides at least one type of CMLE capability.
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_MlProjectsLocationsList_594173; parent: string;
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
  var path_594194 = newJObject()
  var query_594195 = newJObject()
  add(query_594195, "upload_protocol", newJString(uploadProtocol))
  add(query_594195, "fields", newJString(fields))
  add(query_594195, "pageToken", newJString(pageToken))
  add(query_594195, "quotaUser", newJString(quotaUser))
  add(query_594195, "alt", newJString(alt))
  add(query_594195, "pp", newJBool(pp))
  add(query_594195, "oauth_token", newJString(oauthToken))
  add(query_594195, "callback", newJString(callback))
  add(query_594195, "access_token", newJString(accessToken))
  add(query_594195, "uploadType", newJString(uploadType))
  add(path_594194, "parent", newJString(parent))
  add(query_594195, "key", newJString(key))
  add(query_594195, "$.xgafv", newJString(Xgafv))
  add(query_594195, "pageSize", newJInt(pageSize))
  add(query_594195, "prettyPrint", newJBool(prettyPrint))
  add(query_594195, "bearer_token", newJString(bearerToken))
  result = call_594193.call(path_594194, query_594195, nil, nil, nil)

var mlProjectsLocationsList* = Call_MlProjectsLocationsList_594173(
    name: "mlProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{parent}/locations",
    validator: validate_MlProjectsLocationsList_594174, base: "/",
    url: url_MlProjectsLocationsList_594175, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsCreate_594220 = ref object of OpenApiRestCall_593408
proc url_MlProjectsModelsCreate_594222(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MlProjectsModelsCreate_594221(path: JsonNode; query: JsonNode;
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
  var valid_594223 = path.getOrDefault("parent")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "parent", valid_594223
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
  var valid_594224 = query.getOrDefault("upload_protocol")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = nil)
  if valid_594224 != nil:
    section.add "upload_protocol", valid_594224
  var valid_594225 = query.getOrDefault("fields")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = nil)
  if valid_594225 != nil:
    section.add "fields", valid_594225
  var valid_594226 = query.getOrDefault("quotaUser")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "quotaUser", valid_594226
  var valid_594227 = query.getOrDefault("alt")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = newJString("json"))
  if valid_594227 != nil:
    section.add "alt", valid_594227
  var valid_594228 = query.getOrDefault("pp")
  valid_594228 = validateParameter(valid_594228, JBool, required = false,
                                 default = newJBool(true))
  if valid_594228 != nil:
    section.add "pp", valid_594228
  var valid_594229 = query.getOrDefault("oauth_token")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "oauth_token", valid_594229
  var valid_594230 = query.getOrDefault("callback")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "callback", valid_594230
  var valid_594231 = query.getOrDefault("access_token")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "access_token", valid_594231
  var valid_594232 = query.getOrDefault("uploadType")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "uploadType", valid_594232
  var valid_594233 = query.getOrDefault("key")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "key", valid_594233
  var valid_594234 = query.getOrDefault("$.xgafv")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = newJString("1"))
  if valid_594234 != nil:
    section.add "$.xgafv", valid_594234
  var valid_594235 = query.getOrDefault("prettyPrint")
  valid_594235 = validateParameter(valid_594235, JBool, required = false,
                                 default = newJBool(true))
  if valid_594235 != nil:
    section.add "prettyPrint", valid_594235
  var valid_594236 = query.getOrDefault("bearer_token")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "bearer_token", valid_594236
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

proc call*(call_594238: Call_MlProjectsModelsCreate_594220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a model which will later contain one or more versions.
  ## 
  ## You must add at least one version before you can request predictions from
  ## the model. Add versions by calling
  ## [projects.models.versions.create](/ml-engine/reference/rest/v1/projects.models.versions/create).
  ## 
  let valid = call_594238.validator(path, query, header, formData, body)
  let scheme = call_594238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594238.url(scheme.get, call_594238.host, call_594238.base,
                         call_594238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594238, url, valid)

proc call*(call_594239: Call_MlProjectsModelsCreate_594220; parent: string;
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
  var path_594240 = newJObject()
  var query_594241 = newJObject()
  var body_594242 = newJObject()
  add(query_594241, "upload_protocol", newJString(uploadProtocol))
  add(query_594241, "fields", newJString(fields))
  add(query_594241, "quotaUser", newJString(quotaUser))
  add(query_594241, "alt", newJString(alt))
  add(query_594241, "pp", newJBool(pp))
  add(query_594241, "oauth_token", newJString(oauthToken))
  add(query_594241, "callback", newJString(callback))
  add(query_594241, "access_token", newJString(accessToken))
  add(query_594241, "uploadType", newJString(uploadType))
  add(path_594240, "parent", newJString(parent))
  add(query_594241, "key", newJString(key))
  add(query_594241, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594242 = body
  add(query_594241, "prettyPrint", newJBool(prettyPrint))
  add(query_594241, "bearer_token", newJString(bearerToken))
  result = call_594239.call(path_594240, query_594241, nil, nil, body_594242)

var mlProjectsModelsCreate* = Call_MlProjectsModelsCreate_594220(
    name: "mlProjectsModelsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{parent}/models",
    validator: validate_MlProjectsModelsCreate_594221, base: "/",
    url: url_MlProjectsModelsCreate_594222, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsList_594196 = ref object of OpenApiRestCall_593408
proc url_MlProjectsModelsList_594198(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MlProjectsModelsList_594197(path: JsonNode; query: JsonNode;
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
  var valid_594199 = path.getOrDefault("parent")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "parent", valid_594199
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
  var valid_594200 = query.getOrDefault("upload_protocol")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "upload_protocol", valid_594200
  var valid_594201 = query.getOrDefault("fields")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "fields", valid_594201
  var valid_594202 = query.getOrDefault("pageToken")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "pageToken", valid_594202
  var valid_594203 = query.getOrDefault("quotaUser")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "quotaUser", valid_594203
  var valid_594204 = query.getOrDefault("alt")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = newJString("json"))
  if valid_594204 != nil:
    section.add "alt", valid_594204
  var valid_594205 = query.getOrDefault("pp")
  valid_594205 = validateParameter(valid_594205, JBool, required = false,
                                 default = newJBool(true))
  if valid_594205 != nil:
    section.add "pp", valid_594205
  var valid_594206 = query.getOrDefault("oauth_token")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "oauth_token", valid_594206
  var valid_594207 = query.getOrDefault("callback")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "callback", valid_594207
  var valid_594208 = query.getOrDefault("access_token")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "access_token", valid_594208
  var valid_594209 = query.getOrDefault("uploadType")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "uploadType", valid_594209
  var valid_594210 = query.getOrDefault("key")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "key", valid_594210
  var valid_594211 = query.getOrDefault("$.xgafv")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = newJString("1"))
  if valid_594211 != nil:
    section.add "$.xgafv", valid_594211
  var valid_594212 = query.getOrDefault("pageSize")
  valid_594212 = validateParameter(valid_594212, JInt, required = false, default = nil)
  if valid_594212 != nil:
    section.add "pageSize", valid_594212
  var valid_594213 = query.getOrDefault("prettyPrint")
  valid_594213 = validateParameter(valid_594213, JBool, required = false,
                                 default = newJBool(true))
  if valid_594213 != nil:
    section.add "prettyPrint", valid_594213
  var valid_594214 = query.getOrDefault("filter")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "filter", valid_594214
  var valid_594215 = query.getOrDefault("bearer_token")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "bearer_token", valid_594215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594216: Call_MlProjectsModelsList_594196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the models in a project.
  ## 
  ## Each project can contain multiple models, and each model can have multiple
  ## versions.
  ## 
  let valid = call_594216.validator(path, query, header, formData, body)
  let scheme = call_594216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594216.url(scheme.get, call_594216.host, call_594216.base,
                         call_594216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594216, url, valid)

proc call*(call_594217: Call_MlProjectsModelsList_594196; parent: string;
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
  var path_594218 = newJObject()
  var query_594219 = newJObject()
  add(query_594219, "upload_protocol", newJString(uploadProtocol))
  add(query_594219, "fields", newJString(fields))
  add(query_594219, "pageToken", newJString(pageToken))
  add(query_594219, "quotaUser", newJString(quotaUser))
  add(query_594219, "alt", newJString(alt))
  add(query_594219, "pp", newJBool(pp))
  add(query_594219, "oauth_token", newJString(oauthToken))
  add(query_594219, "callback", newJString(callback))
  add(query_594219, "access_token", newJString(accessToken))
  add(query_594219, "uploadType", newJString(uploadType))
  add(path_594218, "parent", newJString(parent))
  add(query_594219, "key", newJString(key))
  add(query_594219, "$.xgafv", newJString(Xgafv))
  add(query_594219, "pageSize", newJInt(pageSize))
  add(query_594219, "prettyPrint", newJBool(prettyPrint))
  add(query_594219, "filter", newJString(filter))
  add(query_594219, "bearer_token", newJString(bearerToken))
  result = call_594217.call(path_594218, query_594219, nil, nil, nil)

var mlProjectsModelsList* = Call_MlProjectsModelsList_594196(
    name: "mlProjectsModelsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{parent}/models",
    validator: validate_MlProjectsModelsList_594197, base: "/",
    url: url_MlProjectsModelsList_594198, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsCreate_594267 = ref object of OpenApiRestCall_593408
proc url_MlProjectsModelsVersionsCreate_594269(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MlProjectsModelsVersionsCreate_594268(path: JsonNode;
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
  var valid_594270 = path.getOrDefault("parent")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "parent", valid_594270
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
  var valid_594271 = query.getOrDefault("upload_protocol")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "upload_protocol", valid_594271
  var valid_594272 = query.getOrDefault("fields")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "fields", valid_594272
  var valid_594273 = query.getOrDefault("quotaUser")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "quotaUser", valid_594273
  var valid_594274 = query.getOrDefault("alt")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = newJString("json"))
  if valid_594274 != nil:
    section.add "alt", valid_594274
  var valid_594275 = query.getOrDefault("pp")
  valid_594275 = validateParameter(valid_594275, JBool, required = false,
                                 default = newJBool(true))
  if valid_594275 != nil:
    section.add "pp", valid_594275
  var valid_594276 = query.getOrDefault("oauth_token")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "oauth_token", valid_594276
  var valid_594277 = query.getOrDefault("callback")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "callback", valid_594277
  var valid_594278 = query.getOrDefault("access_token")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "access_token", valid_594278
  var valid_594279 = query.getOrDefault("uploadType")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "uploadType", valid_594279
  var valid_594280 = query.getOrDefault("key")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "key", valid_594280
  var valid_594281 = query.getOrDefault("$.xgafv")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = newJString("1"))
  if valid_594281 != nil:
    section.add "$.xgafv", valid_594281
  var valid_594282 = query.getOrDefault("prettyPrint")
  valid_594282 = validateParameter(valid_594282, JBool, required = false,
                                 default = newJBool(true))
  if valid_594282 != nil:
    section.add "prettyPrint", valid_594282
  var valid_594283 = query.getOrDefault("bearer_token")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "bearer_token", valid_594283
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

proc call*(call_594285: Call_MlProjectsModelsVersionsCreate_594267; path: JsonNode;
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
  let valid = call_594285.validator(path, query, header, formData, body)
  let scheme = call_594285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594285.url(scheme.get, call_594285.host, call_594285.base,
                         call_594285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594285, url, valid)

proc call*(call_594286: Call_MlProjectsModelsVersionsCreate_594267; parent: string;
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
  var path_594287 = newJObject()
  var query_594288 = newJObject()
  var body_594289 = newJObject()
  add(query_594288, "upload_protocol", newJString(uploadProtocol))
  add(query_594288, "fields", newJString(fields))
  add(query_594288, "quotaUser", newJString(quotaUser))
  add(query_594288, "alt", newJString(alt))
  add(query_594288, "pp", newJBool(pp))
  add(query_594288, "oauth_token", newJString(oauthToken))
  add(query_594288, "callback", newJString(callback))
  add(query_594288, "access_token", newJString(accessToken))
  add(query_594288, "uploadType", newJString(uploadType))
  add(path_594287, "parent", newJString(parent))
  add(query_594288, "key", newJString(key))
  add(query_594288, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594289 = body
  add(query_594288, "prettyPrint", newJBool(prettyPrint))
  add(query_594288, "bearer_token", newJString(bearerToken))
  result = call_594286.call(path_594287, query_594288, nil, nil, body_594289)

var mlProjectsModelsVersionsCreate* = Call_MlProjectsModelsVersionsCreate_594267(
    name: "mlProjectsModelsVersionsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{parent}/versions",
    validator: validate_MlProjectsModelsVersionsCreate_594268, base: "/",
    url: url_MlProjectsModelsVersionsCreate_594269, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsList_594243 = ref object of OpenApiRestCall_593408
proc url_MlProjectsModelsVersionsList_594245(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MlProjectsModelsVersionsList_594244(path: JsonNode; query: JsonNode;
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
  var valid_594246 = path.getOrDefault("parent")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "parent", valid_594246
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
  var valid_594247 = query.getOrDefault("upload_protocol")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = nil)
  if valid_594247 != nil:
    section.add "upload_protocol", valid_594247
  var valid_594248 = query.getOrDefault("fields")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "fields", valid_594248
  var valid_594249 = query.getOrDefault("pageToken")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "pageToken", valid_594249
  var valid_594250 = query.getOrDefault("quotaUser")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "quotaUser", valid_594250
  var valid_594251 = query.getOrDefault("alt")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = newJString("json"))
  if valid_594251 != nil:
    section.add "alt", valid_594251
  var valid_594252 = query.getOrDefault("pp")
  valid_594252 = validateParameter(valid_594252, JBool, required = false,
                                 default = newJBool(true))
  if valid_594252 != nil:
    section.add "pp", valid_594252
  var valid_594253 = query.getOrDefault("oauth_token")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "oauth_token", valid_594253
  var valid_594254 = query.getOrDefault("callback")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "callback", valid_594254
  var valid_594255 = query.getOrDefault("access_token")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "access_token", valid_594255
  var valid_594256 = query.getOrDefault("uploadType")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "uploadType", valid_594256
  var valid_594257 = query.getOrDefault("key")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "key", valid_594257
  var valid_594258 = query.getOrDefault("$.xgafv")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = newJString("1"))
  if valid_594258 != nil:
    section.add "$.xgafv", valid_594258
  var valid_594259 = query.getOrDefault("pageSize")
  valid_594259 = validateParameter(valid_594259, JInt, required = false, default = nil)
  if valid_594259 != nil:
    section.add "pageSize", valid_594259
  var valid_594260 = query.getOrDefault("prettyPrint")
  valid_594260 = validateParameter(valid_594260, JBool, required = false,
                                 default = newJBool(true))
  if valid_594260 != nil:
    section.add "prettyPrint", valid_594260
  var valid_594261 = query.getOrDefault("filter")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "filter", valid_594261
  var valid_594262 = query.getOrDefault("bearer_token")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "bearer_token", valid_594262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594263: Call_MlProjectsModelsVersionsList_594243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets basic information about all the versions of a model.
  ## 
  ## If you expect that a model has a lot of versions, or if you need to handle
  ## only a limited number of results at a time, you can request that the list
  ## be retrieved in batches (called pages):
  ## 
  let valid = call_594263.validator(path, query, header, formData, body)
  let scheme = call_594263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594263.url(scheme.get, call_594263.host, call_594263.base,
                         call_594263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594263, url, valid)

proc call*(call_594264: Call_MlProjectsModelsVersionsList_594243; parent: string;
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
  var path_594265 = newJObject()
  var query_594266 = newJObject()
  add(query_594266, "upload_protocol", newJString(uploadProtocol))
  add(query_594266, "fields", newJString(fields))
  add(query_594266, "pageToken", newJString(pageToken))
  add(query_594266, "quotaUser", newJString(quotaUser))
  add(query_594266, "alt", newJString(alt))
  add(query_594266, "pp", newJBool(pp))
  add(query_594266, "oauth_token", newJString(oauthToken))
  add(query_594266, "callback", newJString(callback))
  add(query_594266, "access_token", newJString(accessToken))
  add(query_594266, "uploadType", newJString(uploadType))
  add(path_594265, "parent", newJString(parent))
  add(query_594266, "key", newJString(key))
  add(query_594266, "$.xgafv", newJString(Xgafv))
  add(query_594266, "pageSize", newJInt(pageSize))
  add(query_594266, "prettyPrint", newJBool(prettyPrint))
  add(query_594266, "filter", newJString(filter))
  add(query_594266, "bearer_token", newJString(bearerToken))
  result = call_594264.call(path_594265, query_594266, nil, nil, nil)

var mlProjectsModelsVersionsList* = Call_MlProjectsModelsVersionsList_594243(
    name: "mlProjectsModelsVersionsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{parent}/versions",
    validator: validate_MlProjectsModelsVersionsList_594244, base: "/",
    url: url_MlProjectsModelsVersionsList_594245, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsGetIamPolicy_594290 = ref object of OpenApiRestCall_593408
proc url_MlProjectsJobsGetIamPolicy_594292(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_MlProjectsJobsGetIamPolicy_594291(path: JsonNode; query: JsonNode;
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
  var valid_594293 = path.getOrDefault("resource")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "resource", valid_594293
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
  var valid_594294 = query.getOrDefault("upload_protocol")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "upload_protocol", valid_594294
  var valid_594295 = query.getOrDefault("fields")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "fields", valid_594295
  var valid_594296 = query.getOrDefault("quotaUser")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "quotaUser", valid_594296
  var valid_594297 = query.getOrDefault("alt")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = newJString("json"))
  if valid_594297 != nil:
    section.add "alt", valid_594297
  var valid_594298 = query.getOrDefault("pp")
  valid_594298 = validateParameter(valid_594298, JBool, required = false,
                                 default = newJBool(true))
  if valid_594298 != nil:
    section.add "pp", valid_594298
  var valid_594299 = query.getOrDefault("oauth_token")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "oauth_token", valid_594299
  var valid_594300 = query.getOrDefault("callback")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "callback", valid_594300
  var valid_594301 = query.getOrDefault("access_token")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "access_token", valid_594301
  var valid_594302 = query.getOrDefault("uploadType")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "uploadType", valid_594302
  var valid_594303 = query.getOrDefault("key")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "key", valid_594303
  var valid_594304 = query.getOrDefault("$.xgafv")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = newJString("1"))
  if valid_594304 != nil:
    section.add "$.xgafv", valid_594304
  var valid_594305 = query.getOrDefault("prettyPrint")
  valid_594305 = validateParameter(valid_594305, JBool, required = false,
                                 default = newJBool(true))
  if valid_594305 != nil:
    section.add "prettyPrint", valid_594305
  var valid_594306 = query.getOrDefault("bearer_token")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "bearer_token", valid_594306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594307: Call_MlProjectsJobsGetIamPolicy_594290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_594307.validator(path, query, header, formData, body)
  let scheme = call_594307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594307.url(scheme.get, call_594307.host, call_594307.base,
                         call_594307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594307, url, valid)

proc call*(call_594308: Call_MlProjectsJobsGetIamPolicy_594290; resource: string;
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
  var path_594309 = newJObject()
  var query_594310 = newJObject()
  add(query_594310, "upload_protocol", newJString(uploadProtocol))
  add(query_594310, "fields", newJString(fields))
  add(query_594310, "quotaUser", newJString(quotaUser))
  add(query_594310, "alt", newJString(alt))
  add(query_594310, "pp", newJBool(pp))
  add(query_594310, "oauth_token", newJString(oauthToken))
  add(query_594310, "callback", newJString(callback))
  add(query_594310, "access_token", newJString(accessToken))
  add(query_594310, "uploadType", newJString(uploadType))
  add(query_594310, "key", newJString(key))
  add(query_594310, "$.xgafv", newJString(Xgafv))
  add(path_594309, "resource", newJString(resource))
  add(query_594310, "prettyPrint", newJBool(prettyPrint))
  add(query_594310, "bearer_token", newJString(bearerToken))
  result = call_594308.call(path_594309, query_594310, nil, nil, nil)

var mlProjectsJobsGetIamPolicy* = Call_MlProjectsJobsGetIamPolicy_594290(
    name: "mlProjectsJobsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_MlProjectsJobsGetIamPolicy_594291, base: "/",
    url: url_MlProjectsJobsGetIamPolicy_594292, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsSetIamPolicy_594311 = ref object of OpenApiRestCall_593408
proc url_MlProjectsJobsSetIamPolicy_594313(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_MlProjectsJobsSetIamPolicy_594312(path: JsonNode; query: JsonNode;
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
  var valid_594314 = path.getOrDefault("resource")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "resource", valid_594314
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
  var valid_594315 = query.getOrDefault("upload_protocol")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "upload_protocol", valid_594315
  var valid_594316 = query.getOrDefault("fields")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "fields", valid_594316
  var valid_594317 = query.getOrDefault("quotaUser")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "quotaUser", valid_594317
  var valid_594318 = query.getOrDefault("alt")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = newJString("json"))
  if valid_594318 != nil:
    section.add "alt", valid_594318
  var valid_594319 = query.getOrDefault("pp")
  valid_594319 = validateParameter(valid_594319, JBool, required = false,
                                 default = newJBool(true))
  if valid_594319 != nil:
    section.add "pp", valid_594319
  var valid_594320 = query.getOrDefault("oauth_token")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "oauth_token", valid_594320
  var valid_594321 = query.getOrDefault("callback")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "callback", valid_594321
  var valid_594322 = query.getOrDefault("access_token")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = nil)
  if valid_594322 != nil:
    section.add "access_token", valid_594322
  var valid_594323 = query.getOrDefault("uploadType")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "uploadType", valid_594323
  var valid_594324 = query.getOrDefault("key")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "key", valid_594324
  var valid_594325 = query.getOrDefault("$.xgafv")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = newJString("1"))
  if valid_594325 != nil:
    section.add "$.xgafv", valid_594325
  var valid_594326 = query.getOrDefault("prettyPrint")
  valid_594326 = validateParameter(valid_594326, JBool, required = false,
                                 default = newJBool(true))
  if valid_594326 != nil:
    section.add "prettyPrint", valid_594326
  var valid_594327 = query.getOrDefault("bearer_token")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = nil)
  if valid_594327 != nil:
    section.add "bearer_token", valid_594327
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

proc call*(call_594329: Call_MlProjectsJobsSetIamPolicy_594311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_594329.validator(path, query, header, formData, body)
  let scheme = call_594329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594329.url(scheme.get, call_594329.host, call_594329.base,
                         call_594329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594329, url, valid)

proc call*(call_594330: Call_MlProjectsJobsSetIamPolicy_594311; resource: string;
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
  var path_594331 = newJObject()
  var query_594332 = newJObject()
  var body_594333 = newJObject()
  add(query_594332, "upload_protocol", newJString(uploadProtocol))
  add(query_594332, "fields", newJString(fields))
  add(query_594332, "quotaUser", newJString(quotaUser))
  add(query_594332, "alt", newJString(alt))
  add(query_594332, "pp", newJBool(pp))
  add(query_594332, "oauth_token", newJString(oauthToken))
  add(query_594332, "callback", newJString(callback))
  add(query_594332, "access_token", newJString(accessToken))
  add(query_594332, "uploadType", newJString(uploadType))
  add(query_594332, "key", newJString(key))
  add(query_594332, "$.xgafv", newJString(Xgafv))
  add(path_594331, "resource", newJString(resource))
  if body != nil:
    body_594333 = body
  add(query_594332, "prettyPrint", newJBool(prettyPrint))
  add(query_594332, "bearer_token", newJString(bearerToken))
  result = call_594330.call(path_594331, query_594332, nil, nil, body_594333)

var mlProjectsJobsSetIamPolicy* = Call_MlProjectsJobsSetIamPolicy_594311(
    name: "mlProjectsJobsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_MlProjectsJobsSetIamPolicy_594312, base: "/",
    url: url_MlProjectsJobsSetIamPolicy_594313, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsTestIamPermissions_594334 = ref object of OpenApiRestCall_593408
proc url_MlProjectsJobsTestIamPermissions_594336(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_MlProjectsJobsTestIamPermissions_594335(path: JsonNode;
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
  var valid_594337 = path.getOrDefault("resource")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "resource", valid_594337
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
  var valid_594338 = query.getOrDefault("upload_protocol")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "upload_protocol", valid_594338
  var valid_594339 = query.getOrDefault("fields")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "fields", valid_594339
  var valid_594340 = query.getOrDefault("quotaUser")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "quotaUser", valid_594340
  var valid_594341 = query.getOrDefault("alt")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = newJString("json"))
  if valid_594341 != nil:
    section.add "alt", valid_594341
  var valid_594342 = query.getOrDefault("pp")
  valid_594342 = validateParameter(valid_594342, JBool, required = false,
                                 default = newJBool(true))
  if valid_594342 != nil:
    section.add "pp", valid_594342
  var valid_594343 = query.getOrDefault("oauth_token")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = nil)
  if valid_594343 != nil:
    section.add "oauth_token", valid_594343
  var valid_594344 = query.getOrDefault("callback")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = nil)
  if valid_594344 != nil:
    section.add "callback", valid_594344
  var valid_594345 = query.getOrDefault("access_token")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = nil)
  if valid_594345 != nil:
    section.add "access_token", valid_594345
  var valid_594346 = query.getOrDefault("uploadType")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = nil)
  if valid_594346 != nil:
    section.add "uploadType", valid_594346
  var valid_594347 = query.getOrDefault("key")
  valid_594347 = validateParameter(valid_594347, JString, required = false,
                                 default = nil)
  if valid_594347 != nil:
    section.add "key", valid_594347
  var valid_594348 = query.getOrDefault("$.xgafv")
  valid_594348 = validateParameter(valid_594348, JString, required = false,
                                 default = newJString("1"))
  if valid_594348 != nil:
    section.add "$.xgafv", valid_594348
  var valid_594349 = query.getOrDefault("prettyPrint")
  valid_594349 = validateParameter(valid_594349, JBool, required = false,
                                 default = newJBool(true))
  if valid_594349 != nil:
    section.add "prettyPrint", valid_594349
  var valid_594350 = query.getOrDefault("bearer_token")
  valid_594350 = validateParameter(valid_594350, JString, required = false,
                                 default = nil)
  if valid_594350 != nil:
    section.add "bearer_token", valid_594350
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

proc call*(call_594352: Call_MlProjectsJobsTestIamPermissions_594334;
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
  let valid = call_594352.validator(path, query, header, formData, body)
  let scheme = call_594352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594352.url(scheme.get, call_594352.host, call_594352.base,
                         call_594352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594352, url, valid)

proc call*(call_594353: Call_MlProjectsJobsTestIamPermissions_594334;
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
  var path_594354 = newJObject()
  var query_594355 = newJObject()
  var body_594356 = newJObject()
  add(query_594355, "upload_protocol", newJString(uploadProtocol))
  add(query_594355, "fields", newJString(fields))
  add(query_594355, "quotaUser", newJString(quotaUser))
  add(query_594355, "alt", newJString(alt))
  add(query_594355, "pp", newJBool(pp))
  add(query_594355, "oauth_token", newJString(oauthToken))
  add(query_594355, "callback", newJString(callback))
  add(query_594355, "access_token", newJString(accessToken))
  add(query_594355, "uploadType", newJString(uploadType))
  add(query_594355, "key", newJString(key))
  add(query_594355, "$.xgafv", newJString(Xgafv))
  add(path_594354, "resource", newJString(resource))
  if body != nil:
    body_594356 = body
  add(query_594355, "prettyPrint", newJBool(prettyPrint))
  add(query_594355, "bearer_token", newJString(bearerToken))
  result = call_594353.call(path_594354, query_594355, nil, nil, body_594356)

var mlProjectsJobsTestIamPermissions* = Call_MlProjectsJobsTestIamPermissions_594334(
    name: "mlProjectsJobsTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1/{resource}:testIamPermissions",
    validator: validate_MlProjectsJobsTestIamPermissions_594335, base: "/",
    url: url_MlProjectsJobsTestIamPermissions_594336, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
