
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Cloud Machine Learning Engine
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  Call_MlProjectsJobsGet_579690 = ref object of OpenApiRestCall_579421
proc url_MlProjectsJobsGet_579692(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsJobsGet_579691(path: JsonNode; query: JsonNode;
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
  var valid_579818 = path.getOrDefault("name")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "name", valid_579818
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579819 = query.getOrDefault("upload_protocol")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "upload_protocol", valid_579819
  var valid_579820 = query.getOrDefault("fields")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "fields", valid_579820
  var valid_579821 = query.getOrDefault("quotaUser")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "quotaUser", valid_579821
  var valid_579835 = query.getOrDefault("alt")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = newJString("json"))
  if valid_579835 != nil:
    section.add "alt", valid_579835
  var valid_579836 = query.getOrDefault("pp")
  valid_579836 = validateParameter(valid_579836, JBool, required = false,
                                 default = newJBool(true))
  if valid_579836 != nil:
    section.add "pp", valid_579836
  var valid_579837 = query.getOrDefault("oauth_token")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "oauth_token", valid_579837
  var valid_579838 = query.getOrDefault("uploadType")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "uploadType", valid_579838
  var valid_579839 = query.getOrDefault("callback")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "callback", valid_579839
  var valid_579840 = query.getOrDefault("access_token")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "access_token", valid_579840
  var valid_579841 = query.getOrDefault("key")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = nil)
  if valid_579841 != nil:
    section.add "key", valid_579841
  var valid_579842 = query.getOrDefault("$.xgafv")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = newJString("1"))
  if valid_579842 != nil:
    section.add "$.xgafv", valid_579842
  var valid_579843 = query.getOrDefault("prettyPrint")
  valid_579843 = validateParameter(valid_579843, JBool, required = false,
                                 default = newJBool(true))
  if valid_579843 != nil:
    section.add "prettyPrint", valid_579843
  var valid_579844 = query.getOrDefault("bearer_token")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "bearer_token", valid_579844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579867: Call_MlProjectsJobsGet_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Describes a job.
  ## 
  let valid = call_579867.validator(path, query, header, formData, body)
  let scheme = call_579867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579867.url(scheme.get, call_579867.host, call_579867.base,
                         call_579867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579867, url, valid)

proc call*(call_579938: Call_MlProjectsJobsGet_579690; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_579939 = newJObject()
  var query_579941 = newJObject()
  add(query_579941, "upload_protocol", newJString(uploadProtocol))
  add(query_579941, "fields", newJString(fields))
  add(query_579941, "quotaUser", newJString(quotaUser))
  add(path_579939, "name", newJString(name))
  add(query_579941, "alt", newJString(alt))
  add(query_579941, "pp", newJBool(pp))
  add(query_579941, "oauth_token", newJString(oauthToken))
  add(query_579941, "uploadType", newJString(uploadType))
  add(query_579941, "callback", newJString(callback))
  add(query_579941, "access_token", newJString(accessToken))
  add(query_579941, "key", newJString(key))
  add(query_579941, "$.xgafv", newJString(Xgafv))
  add(query_579941, "prettyPrint", newJBool(prettyPrint))
  add(query_579941, "bearer_token", newJString(bearerToken))
  result = call_579938.call(path_579939, query_579941, nil, nil, nil)

var mlProjectsJobsGet* = Call_MlProjectsJobsGet_579690(name: "mlProjectsJobsGet",
    meth: HttpMethod.HttpGet, host: "ml.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_MlProjectsJobsGet_579691, base: "/",
    url: url_MlProjectsJobsGet_579692, schemes: {Scheme.Https})
type
  Call_MlProjectsOperationsDelete_579980 = ref object of OpenApiRestCall_579421
proc url_MlProjectsOperationsDelete_579982(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsOperationsDelete_579981(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579983 = path.getOrDefault("name")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "name", valid_579983
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579984 = query.getOrDefault("upload_protocol")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "upload_protocol", valid_579984
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  var valid_579986 = query.getOrDefault("quotaUser")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "quotaUser", valid_579986
  var valid_579987 = query.getOrDefault("alt")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = newJString("json"))
  if valid_579987 != nil:
    section.add "alt", valid_579987
  var valid_579988 = query.getOrDefault("pp")
  valid_579988 = validateParameter(valid_579988, JBool, required = false,
                                 default = newJBool(true))
  if valid_579988 != nil:
    section.add "pp", valid_579988
  var valid_579989 = query.getOrDefault("oauth_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "oauth_token", valid_579989
  var valid_579990 = query.getOrDefault("uploadType")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "uploadType", valid_579990
  var valid_579991 = query.getOrDefault("callback")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "callback", valid_579991
  var valid_579992 = query.getOrDefault("access_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "access_token", valid_579992
  var valid_579993 = query.getOrDefault("key")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "key", valid_579993
  var valid_579994 = query.getOrDefault("$.xgafv")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("1"))
  if valid_579994 != nil:
    section.add "$.xgafv", valid_579994
  var valid_579995 = query.getOrDefault("prettyPrint")
  valid_579995 = validateParameter(valid_579995, JBool, required = false,
                                 default = newJBool(true))
  if valid_579995 != nil:
    section.add "prettyPrint", valid_579995
  var valid_579996 = query.getOrDefault("bearer_token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "bearer_token", valid_579996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579997: Call_MlProjectsOperationsDelete_579980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_579997.validator(path, query, header, formData, body)
  let scheme = call_579997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579997.url(scheme.get, call_579997.host, call_579997.base,
                         call_579997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579997, url, valid)

proc call*(call_579998: Call_MlProjectsOperationsDelete_579980; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## mlProjectsOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_579999 = newJObject()
  var query_580000 = newJObject()
  add(query_580000, "upload_protocol", newJString(uploadProtocol))
  add(query_580000, "fields", newJString(fields))
  add(query_580000, "quotaUser", newJString(quotaUser))
  add(path_579999, "name", newJString(name))
  add(query_580000, "alt", newJString(alt))
  add(query_580000, "pp", newJBool(pp))
  add(query_580000, "oauth_token", newJString(oauthToken))
  add(query_580000, "uploadType", newJString(uploadType))
  add(query_580000, "callback", newJString(callback))
  add(query_580000, "access_token", newJString(accessToken))
  add(query_580000, "key", newJString(key))
  add(query_580000, "$.xgafv", newJString(Xgafv))
  add(query_580000, "prettyPrint", newJBool(prettyPrint))
  add(query_580000, "bearer_token", newJString(bearerToken))
  result = call_579998.call(path_579999, query_580000, nil, nil, nil)

var mlProjectsOperationsDelete* = Call_MlProjectsOperationsDelete_579980(
    name: "mlProjectsOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "ml.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_MlProjectsOperationsDelete_579981, base: "/",
    url: url_MlProjectsOperationsDelete_579982, schemes: {Scheme.Https})
type
  Call_MlProjectsOperationsList_580001 = ref object of OpenApiRestCall_579421
proc url_MlProjectsOperationsList_580003(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsOperationsList_580002(path: JsonNode; query: JsonNode;
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
  var valid_580004 = path.getOrDefault("name")
  valid_580004 = validateParameter(valid_580004, JString, required = true,
                                 default = nil)
  if valid_580004 != nil:
    section.add "name", valid_580004
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
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
  var valid_580005 = query.getOrDefault("upload_protocol")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "upload_protocol", valid_580005
  var valid_580006 = query.getOrDefault("fields")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "fields", valid_580006
  var valid_580007 = query.getOrDefault("pageToken")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "pageToken", valid_580007
  var valid_580008 = query.getOrDefault("quotaUser")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "quotaUser", valid_580008
  var valid_580009 = query.getOrDefault("alt")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = newJString("json"))
  if valid_580009 != nil:
    section.add "alt", valid_580009
  var valid_580010 = query.getOrDefault("pp")
  valid_580010 = validateParameter(valid_580010, JBool, required = false,
                                 default = newJBool(true))
  if valid_580010 != nil:
    section.add "pp", valid_580010
  var valid_580011 = query.getOrDefault("oauth_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "oauth_token", valid_580011
  var valid_580012 = query.getOrDefault("uploadType")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "uploadType", valid_580012
  var valid_580013 = query.getOrDefault("callback")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "callback", valid_580013
  var valid_580014 = query.getOrDefault("access_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "access_token", valid_580014
  var valid_580015 = query.getOrDefault("key")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "key", valid_580015
  var valid_580016 = query.getOrDefault("$.xgafv")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("1"))
  if valid_580016 != nil:
    section.add "$.xgafv", valid_580016
  var valid_580017 = query.getOrDefault("pageSize")
  valid_580017 = validateParameter(valid_580017, JInt, required = false, default = nil)
  if valid_580017 != nil:
    section.add "pageSize", valid_580017
  var valid_580018 = query.getOrDefault("prettyPrint")
  valid_580018 = validateParameter(valid_580018, JBool, required = false,
                                 default = newJBool(true))
  if valid_580018 != nil:
    section.add "prettyPrint", valid_580018
  var valid_580019 = query.getOrDefault("filter")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "filter", valid_580019
  var valid_580020 = query.getOrDefault("bearer_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "bearer_token", valid_580020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580021: Call_MlProjectsOperationsList_580001; path: JsonNode;
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
  let valid = call_580021.validator(path, query, header, formData, body)
  let scheme = call_580021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580021.url(scheme.get, call_580021.host, call_580021.base,
                         call_580021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580021, url, valid)

proc call*(call_580022: Call_MlProjectsOperationsList_580001; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true; filter: string = "";
          bearerToken: string = ""): Recallable =
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
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
  var path_580023 = newJObject()
  var query_580024 = newJObject()
  add(query_580024, "upload_protocol", newJString(uploadProtocol))
  add(query_580024, "fields", newJString(fields))
  add(query_580024, "pageToken", newJString(pageToken))
  add(query_580024, "quotaUser", newJString(quotaUser))
  add(path_580023, "name", newJString(name))
  add(query_580024, "alt", newJString(alt))
  add(query_580024, "pp", newJBool(pp))
  add(query_580024, "oauth_token", newJString(oauthToken))
  add(query_580024, "uploadType", newJString(uploadType))
  add(query_580024, "callback", newJString(callback))
  add(query_580024, "access_token", newJString(accessToken))
  add(query_580024, "key", newJString(key))
  add(query_580024, "$.xgafv", newJString(Xgafv))
  add(query_580024, "pageSize", newJInt(pageSize))
  add(query_580024, "prettyPrint", newJBool(prettyPrint))
  add(query_580024, "filter", newJString(filter))
  add(query_580024, "bearer_token", newJString(bearerToken))
  result = call_580022.call(path_580023, query_580024, nil, nil, nil)

var mlProjectsOperationsList* = Call_MlProjectsOperationsList_580001(
    name: "mlProjectsOperationsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{name}/operations",
    validator: validate_MlProjectsOperationsList_580002, base: "/",
    url: url_MlProjectsOperationsList_580003, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsCancel_580025 = ref object of OpenApiRestCall_579421
proc url_MlProjectsJobsCancel_580027(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsJobsCancel_580026(path: JsonNode; query: JsonNode;
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
  var valid_580028 = path.getOrDefault("name")
  valid_580028 = validateParameter(valid_580028, JString, required = true,
                                 default = nil)
  if valid_580028 != nil:
    section.add "name", valid_580028
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580029 = query.getOrDefault("upload_protocol")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "upload_protocol", valid_580029
  var valid_580030 = query.getOrDefault("fields")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "fields", valid_580030
  var valid_580031 = query.getOrDefault("quotaUser")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "quotaUser", valid_580031
  var valid_580032 = query.getOrDefault("alt")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("json"))
  if valid_580032 != nil:
    section.add "alt", valid_580032
  var valid_580033 = query.getOrDefault("pp")
  valid_580033 = validateParameter(valid_580033, JBool, required = false,
                                 default = newJBool(true))
  if valid_580033 != nil:
    section.add "pp", valid_580033
  var valid_580034 = query.getOrDefault("oauth_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "oauth_token", valid_580034
  var valid_580035 = query.getOrDefault("uploadType")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "uploadType", valid_580035
  var valid_580036 = query.getOrDefault("callback")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "callback", valid_580036
  var valid_580037 = query.getOrDefault("access_token")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "access_token", valid_580037
  var valid_580038 = query.getOrDefault("key")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "key", valid_580038
  var valid_580039 = query.getOrDefault("$.xgafv")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("1"))
  if valid_580039 != nil:
    section.add "$.xgafv", valid_580039
  var valid_580040 = query.getOrDefault("prettyPrint")
  valid_580040 = validateParameter(valid_580040, JBool, required = false,
                                 default = newJBool(true))
  if valid_580040 != nil:
    section.add "prettyPrint", valid_580040
  var valid_580041 = query.getOrDefault("bearer_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "bearer_token", valid_580041
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

proc call*(call_580043: Call_MlProjectsJobsCancel_580025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a running job.
  ## 
  let valid = call_580043.validator(path, query, header, formData, body)
  let scheme = call_580043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580043.url(scheme.get, call_580043.host, call_580043.base,
                         call_580043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580043, url, valid)

proc call*(call_580044: Call_MlProjectsJobsCancel_580025; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580045 = newJObject()
  var query_580046 = newJObject()
  var body_580047 = newJObject()
  add(query_580046, "upload_protocol", newJString(uploadProtocol))
  add(query_580046, "fields", newJString(fields))
  add(query_580046, "quotaUser", newJString(quotaUser))
  add(path_580045, "name", newJString(name))
  add(query_580046, "alt", newJString(alt))
  add(query_580046, "pp", newJBool(pp))
  add(query_580046, "oauth_token", newJString(oauthToken))
  add(query_580046, "uploadType", newJString(uploadType))
  add(query_580046, "callback", newJString(callback))
  add(query_580046, "access_token", newJString(accessToken))
  add(query_580046, "key", newJString(key))
  add(query_580046, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580047 = body
  add(query_580046, "prettyPrint", newJBool(prettyPrint))
  add(query_580046, "bearer_token", newJString(bearerToken))
  result = call_580044.call(path_580045, query_580046, nil, nil, body_580047)

var mlProjectsJobsCancel* = Call_MlProjectsJobsCancel_580025(
    name: "mlProjectsJobsCancel", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{name}:cancel",
    validator: validate_MlProjectsJobsCancel_580026, base: "/",
    url: url_MlProjectsJobsCancel_580027, schemes: {Scheme.Https})
type
  Call_MlProjectsGetConfig_580048 = ref object of OpenApiRestCall_579421
proc url_MlProjectsGetConfig_580050(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":getConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsGetConfig_580049(path: JsonNode; query: JsonNode;
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
  var valid_580051 = path.getOrDefault("name")
  valid_580051 = validateParameter(valid_580051, JString, required = true,
                                 default = nil)
  if valid_580051 != nil:
    section.add "name", valid_580051
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580052 = query.getOrDefault("upload_protocol")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "upload_protocol", valid_580052
  var valid_580053 = query.getOrDefault("fields")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "fields", valid_580053
  var valid_580054 = query.getOrDefault("quotaUser")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "quotaUser", valid_580054
  var valid_580055 = query.getOrDefault("alt")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("json"))
  if valid_580055 != nil:
    section.add "alt", valid_580055
  var valid_580056 = query.getOrDefault("pp")
  valid_580056 = validateParameter(valid_580056, JBool, required = false,
                                 default = newJBool(true))
  if valid_580056 != nil:
    section.add "pp", valid_580056
  var valid_580057 = query.getOrDefault("oauth_token")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "oauth_token", valid_580057
  var valid_580058 = query.getOrDefault("uploadType")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "uploadType", valid_580058
  var valid_580059 = query.getOrDefault("callback")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "callback", valid_580059
  var valid_580060 = query.getOrDefault("access_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "access_token", valid_580060
  var valid_580061 = query.getOrDefault("key")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "key", valid_580061
  var valid_580062 = query.getOrDefault("$.xgafv")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("1"))
  if valid_580062 != nil:
    section.add "$.xgafv", valid_580062
  var valid_580063 = query.getOrDefault("prettyPrint")
  valid_580063 = validateParameter(valid_580063, JBool, required = false,
                                 default = newJBool(true))
  if valid_580063 != nil:
    section.add "prettyPrint", valid_580063
  var valid_580064 = query.getOrDefault("bearer_token")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "bearer_token", valid_580064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580065: Call_MlProjectsGetConfig_580048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the service account information associated with your project. You need
  ## this information in order to grant the service account persmissions for
  ## the Google Cloud Storage location where you put your model training code
  ## for training the model with Google Cloud Machine Learning.
  ## 
  let valid = call_580065.validator(path, query, header, formData, body)
  let scheme = call_580065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580065.url(scheme.get, call_580065.host, call_580065.base,
                         call_580065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580065, url, valid)

proc call*(call_580066: Call_MlProjectsGetConfig_580048; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580067 = newJObject()
  var query_580068 = newJObject()
  add(query_580068, "upload_protocol", newJString(uploadProtocol))
  add(query_580068, "fields", newJString(fields))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(path_580067, "name", newJString(name))
  add(query_580068, "alt", newJString(alt))
  add(query_580068, "pp", newJBool(pp))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(query_580068, "uploadType", newJString(uploadType))
  add(query_580068, "callback", newJString(callback))
  add(query_580068, "access_token", newJString(accessToken))
  add(query_580068, "key", newJString(key))
  add(query_580068, "$.xgafv", newJString(Xgafv))
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  add(query_580068, "bearer_token", newJString(bearerToken))
  result = call_580066.call(path_580067, query_580068, nil, nil, nil)

var mlProjectsGetConfig* = Call_MlProjectsGetConfig_580048(
    name: "mlProjectsGetConfig", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{name}:getConfig",
    validator: validate_MlProjectsGetConfig_580049, base: "/",
    url: url_MlProjectsGetConfig_580050, schemes: {Scheme.Https})
type
  Call_MlProjectsPredict_580069 = ref object of OpenApiRestCall_579421
proc url_MlProjectsPredict_580071(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":predict")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsPredict_580070(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Performs prediction on the data in the request.
  ## 
  ## **** REMOVE FROM GENERATED DOCUMENTATION
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
  var valid_580072 = path.getOrDefault("name")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "name", valid_580072
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580073 = query.getOrDefault("upload_protocol")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "upload_protocol", valid_580073
  var valid_580074 = query.getOrDefault("fields")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "fields", valid_580074
  var valid_580075 = query.getOrDefault("quotaUser")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "quotaUser", valid_580075
  var valid_580076 = query.getOrDefault("alt")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("json"))
  if valid_580076 != nil:
    section.add "alt", valid_580076
  var valid_580077 = query.getOrDefault("pp")
  valid_580077 = validateParameter(valid_580077, JBool, required = false,
                                 default = newJBool(true))
  if valid_580077 != nil:
    section.add "pp", valid_580077
  var valid_580078 = query.getOrDefault("oauth_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "oauth_token", valid_580078
  var valid_580079 = query.getOrDefault("uploadType")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "uploadType", valid_580079
  var valid_580080 = query.getOrDefault("callback")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "callback", valid_580080
  var valid_580081 = query.getOrDefault("access_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "access_token", valid_580081
  var valid_580082 = query.getOrDefault("key")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "key", valid_580082
  var valid_580083 = query.getOrDefault("$.xgafv")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = newJString("1"))
  if valid_580083 != nil:
    section.add "$.xgafv", valid_580083
  var valid_580084 = query.getOrDefault("prettyPrint")
  valid_580084 = validateParameter(valid_580084, JBool, required = false,
                                 default = newJBool(true))
  if valid_580084 != nil:
    section.add "prettyPrint", valid_580084
  var valid_580085 = query.getOrDefault("bearer_token")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "bearer_token", valid_580085
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

proc call*(call_580087: Call_MlProjectsPredict_580069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs prediction on the data in the request.
  ## 
  ## **** REMOVE FROM GENERATED DOCUMENTATION
  ## 
  let valid = call_580087.validator(path, query, header, formData, body)
  let scheme = call_580087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580087.url(scheme.get, call_580087.host, call_580087.base,
                         call_580087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580087, url, valid)

proc call*(call_580088: Call_MlProjectsPredict_580069; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## mlProjectsPredict
  ## Performs prediction on the data in the request.
  ## 
  ## **** REMOVE FROM GENERATED DOCUMENTATION
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580089 = newJObject()
  var query_580090 = newJObject()
  var body_580091 = newJObject()
  add(query_580090, "upload_protocol", newJString(uploadProtocol))
  add(query_580090, "fields", newJString(fields))
  add(query_580090, "quotaUser", newJString(quotaUser))
  add(path_580089, "name", newJString(name))
  add(query_580090, "alt", newJString(alt))
  add(query_580090, "pp", newJBool(pp))
  add(query_580090, "oauth_token", newJString(oauthToken))
  add(query_580090, "uploadType", newJString(uploadType))
  add(query_580090, "callback", newJString(callback))
  add(query_580090, "access_token", newJString(accessToken))
  add(query_580090, "key", newJString(key))
  add(query_580090, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580091 = body
  add(query_580090, "prettyPrint", newJBool(prettyPrint))
  add(query_580090, "bearer_token", newJString(bearerToken))
  result = call_580088.call(path_580089, query_580090, nil, nil, body_580091)

var mlProjectsPredict* = Call_MlProjectsPredict_580069(name: "mlProjectsPredict",
    meth: HttpMethod.HttpPost, host: "ml.googleapis.com",
    route: "/v1beta1/{name}:predict", validator: validate_MlProjectsPredict_580070,
    base: "/", url: url_MlProjectsPredict_580071, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsSetDefault_580092 = ref object of OpenApiRestCall_579421
proc url_MlProjectsModelsVersionsSetDefault_580094(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setDefault")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsModelsVersionsSetDefault_580093(path: JsonNode;
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
  ## [projects.models.versions.list](/ml-engine/reference/rest/v1beta1/projects.models.versions/list).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580095 = path.getOrDefault("name")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "name", valid_580095
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580096 = query.getOrDefault("upload_protocol")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "upload_protocol", valid_580096
  var valid_580097 = query.getOrDefault("fields")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "fields", valid_580097
  var valid_580098 = query.getOrDefault("quotaUser")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "quotaUser", valid_580098
  var valid_580099 = query.getOrDefault("alt")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("json"))
  if valid_580099 != nil:
    section.add "alt", valid_580099
  var valid_580100 = query.getOrDefault("pp")
  valid_580100 = validateParameter(valid_580100, JBool, required = false,
                                 default = newJBool(true))
  if valid_580100 != nil:
    section.add "pp", valid_580100
  var valid_580101 = query.getOrDefault("oauth_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "oauth_token", valid_580101
  var valid_580102 = query.getOrDefault("uploadType")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "uploadType", valid_580102
  var valid_580103 = query.getOrDefault("callback")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "callback", valid_580103
  var valid_580104 = query.getOrDefault("access_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "access_token", valid_580104
  var valid_580105 = query.getOrDefault("key")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "key", valid_580105
  var valid_580106 = query.getOrDefault("$.xgafv")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = newJString("1"))
  if valid_580106 != nil:
    section.add "$.xgafv", valid_580106
  var valid_580107 = query.getOrDefault("prettyPrint")
  valid_580107 = validateParameter(valid_580107, JBool, required = false,
                                 default = newJBool(true))
  if valid_580107 != nil:
    section.add "prettyPrint", valid_580107
  var valid_580108 = query.getOrDefault("bearer_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "bearer_token", valid_580108
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

proc call*(call_580110: Call_MlProjectsModelsVersionsSetDefault_580092;
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
  let valid = call_580110.validator(path, query, header, formData, body)
  let scheme = call_580110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580110.url(scheme.get, call_580110.host, call_580110.base,
                         call_580110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580110, url, valid)

proc call*(call_580111: Call_MlProjectsModelsVersionsSetDefault_580092;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
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
  ## [projects.models.versions.list](/ml-engine/reference/rest/v1beta1/projects.models.versions/list).
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580112 = newJObject()
  var query_580113 = newJObject()
  var body_580114 = newJObject()
  add(query_580113, "upload_protocol", newJString(uploadProtocol))
  add(query_580113, "fields", newJString(fields))
  add(query_580113, "quotaUser", newJString(quotaUser))
  add(path_580112, "name", newJString(name))
  add(query_580113, "alt", newJString(alt))
  add(query_580113, "pp", newJBool(pp))
  add(query_580113, "oauth_token", newJString(oauthToken))
  add(query_580113, "uploadType", newJString(uploadType))
  add(query_580113, "callback", newJString(callback))
  add(query_580113, "access_token", newJString(accessToken))
  add(query_580113, "key", newJString(key))
  add(query_580113, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580114 = body
  add(query_580113, "prettyPrint", newJBool(prettyPrint))
  add(query_580113, "bearer_token", newJString(bearerToken))
  result = call_580111.call(path_580112, query_580113, nil, nil, body_580114)

var mlProjectsModelsVersionsSetDefault* = Call_MlProjectsModelsVersionsSetDefault_580092(
    name: "mlProjectsModelsVersionsSetDefault", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{name}:setDefault",
    validator: validate_MlProjectsModelsVersionsSetDefault_580093, base: "/",
    url: url_MlProjectsModelsVersionsSetDefault_580094, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsCreate_580139 = ref object of OpenApiRestCall_579421
proc url_MlProjectsJobsCreate_580141(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsJobsCreate_580140(path: JsonNode; query: JsonNode;
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
  var valid_580142 = path.getOrDefault("parent")
  valid_580142 = validateParameter(valid_580142, JString, required = true,
                                 default = nil)
  if valid_580142 != nil:
    section.add "parent", valid_580142
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580143 = query.getOrDefault("upload_protocol")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "upload_protocol", valid_580143
  var valid_580144 = query.getOrDefault("fields")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "fields", valid_580144
  var valid_580145 = query.getOrDefault("quotaUser")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "quotaUser", valid_580145
  var valid_580146 = query.getOrDefault("alt")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = newJString("json"))
  if valid_580146 != nil:
    section.add "alt", valid_580146
  var valid_580147 = query.getOrDefault("pp")
  valid_580147 = validateParameter(valid_580147, JBool, required = false,
                                 default = newJBool(true))
  if valid_580147 != nil:
    section.add "pp", valid_580147
  var valid_580148 = query.getOrDefault("oauth_token")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "oauth_token", valid_580148
  var valid_580149 = query.getOrDefault("uploadType")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "uploadType", valid_580149
  var valid_580150 = query.getOrDefault("callback")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "callback", valid_580150
  var valid_580151 = query.getOrDefault("access_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "access_token", valid_580151
  var valid_580152 = query.getOrDefault("key")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "key", valid_580152
  var valid_580153 = query.getOrDefault("$.xgafv")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = newJString("1"))
  if valid_580153 != nil:
    section.add "$.xgafv", valid_580153
  var valid_580154 = query.getOrDefault("prettyPrint")
  valid_580154 = validateParameter(valid_580154, JBool, required = false,
                                 default = newJBool(true))
  if valid_580154 != nil:
    section.add "prettyPrint", valid_580154
  var valid_580155 = query.getOrDefault("bearer_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "bearer_token", valid_580155
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

proc call*(call_580157: Call_MlProjectsJobsCreate_580139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a training or a batch prediction job.
  ## 
  let valid = call_580157.validator(path, query, header, formData, body)
  let scheme = call_580157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580157.url(scheme.get, call_580157.host, call_580157.base,
                         call_580157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580157, url, valid)

proc call*(call_580158: Call_MlProjectsJobsCreate_580139; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
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
  var path_580159 = newJObject()
  var query_580160 = newJObject()
  var body_580161 = newJObject()
  add(query_580160, "upload_protocol", newJString(uploadProtocol))
  add(query_580160, "fields", newJString(fields))
  add(query_580160, "quotaUser", newJString(quotaUser))
  add(query_580160, "alt", newJString(alt))
  add(query_580160, "pp", newJBool(pp))
  add(query_580160, "oauth_token", newJString(oauthToken))
  add(query_580160, "uploadType", newJString(uploadType))
  add(query_580160, "callback", newJString(callback))
  add(query_580160, "access_token", newJString(accessToken))
  add(path_580159, "parent", newJString(parent))
  add(query_580160, "key", newJString(key))
  add(query_580160, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580161 = body
  add(query_580160, "prettyPrint", newJBool(prettyPrint))
  add(query_580160, "bearer_token", newJString(bearerToken))
  result = call_580158.call(path_580159, query_580160, nil, nil, body_580161)

var mlProjectsJobsCreate* = Call_MlProjectsJobsCreate_580139(
    name: "mlProjectsJobsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/jobs",
    validator: validate_MlProjectsJobsCreate_580140, base: "/",
    url: url_MlProjectsJobsCreate_580141, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsList_580115 = ref object of OpenApiRestCall_579421
proc url_MlProjectsJobsList_580117(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsJobsList_580116(path: JsonNode; query: JsonNode;
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
  var valid_580118 = path.getOrDefault("parent")
  valid_580118 = validateParameter(valid_580118, JString, required = true,
                                 default = nil)
  if valid_580118 != nil:
    section.add "parent", valid_580118
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
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
  var valid_580119 = query.getOrDefault("upload_protocol")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "upload_protocol", valid_580119
  var valid_580120 = query.getOrDefault("fields")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "fields", valid_580120
  var valid_580121 = query.getOrDefault("pageToken")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "pageToken", valid_580121
  var valid_580122 = query.getOrDefault("quotaUser")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "quotaUser", valid_580122
  var valid_580123 = query.getOrDefault("alt")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = newJString("json"))
  if valid_580123 != nil:
    section.add "alt", valid_580123
  var valid_580124 = query.getOrDefault("pp")
  valid_580124 = validateParameter(valid_580124, JBool, required = false,
                                 default = newJBool(true))
  if valid_580124 != nil:
    section.add "pp", valid_580124
  var valid_580125 = query.getOrDefault("oauth_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "oauth_token", valid_580125
  var valid_580126 = query.getOrDefault("uploadType")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "uploadType", valid_580126
  var valid_580127 = query.getOrDefault("callback")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "callback", valid_580127
  var valid_580128 = query.getOrDefault("access_token")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "access_token", valid_580128
  var valid_580129 = query.getOrDefault("key")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "key", valid_580129
  var valid_580130 = query.getOrDefault("$.xgafv")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = newJString("1"))
  if valid_580130 != nil:
    section.add "$.xgafv", valid_580130
  var valid_580131 = query.getOrDefault("pageSize")
  valid_580131 = validateParameter(valid_580131, JInt, required = false, default = nil)
  if valid_580131 != nil:
    section.add "pageSize", valid_580131
  var valid_580132 = query.getOrDefault("prettyPrint")
  valid_580132 = validateParameter(valid_580132, JBool, required = false,
                                 default = newJBool(true))
  if valid_580132 != nil:
    section.add "prettyPrint", valid_580132
  var valid_580133 = query.getOrDefault("filter")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "filter", valid_580133
  var valid_580134 = query.getOrDefault("bearer_token")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "bearer_token", valid_580134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580135: Call_MlProjectsJobsList_580115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the jobs in the project.
  ## 
  let valid = call_580135.validator(path, query, header, formData, body)
  let scheme = call_580135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580135.url(scheme.get, call_580135.host, call_580135.base,
                         call_580135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580135, url, valid)

proc call*(call_580136: Call_MlProjectsJobsList_580115; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true; filter: string = "";
          bearerToken: string = ""): Recallable =
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
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
  var path_580137 = newJObject()
  var query_580138 = newJObject()
  add(query_580138, "upload_protocol", newJString(uploadProtocol))
  add(query_580138, "fields", newJString(fields))
  add(query_580138, "pageToken", newJString(pageToken))
  add(query_580138, "quotaUser", newJString(quotaUser))
  add(query_580138, "alt", newJString(alt))
  add(query_580138, "pp", newJBool(pp))
  add(query_580138, "oauth_token", newJString(oauthToken))
  add(query_580138, "uploadType", newJString(uploadType))
  add(query_580138, "callback", newJString(callback))
  add(query_580138, "access_token", newJString(accessToken))
  add(path_580137, "parent", newJString(parent))
  add(query_580138, "key", newJString(key))
  add(query_580138, "$.xgafv", newJString(Xgafv))
  add(query_580138, "pageSize", newJInt(pageSize))
  add(query_580138, "prettyPrint", newJBool(prettyPrint))
  add(query_580138, "filter", newJString(filter))
  add(query_580138, "bearer_token", newJString(bearerToken))
  result = call_580136.call(path_580137, query_580138, nil, nil, nil)

var mlProjectsJobsList* = Call_MlProjectsJobsList_580115(
    name: "mlProjectsJobsList", meth: HttpMethod.HttpGet, host: "ml.googleapis.com",
    route: "/v1beta1/{parent}/jobs", validator: validate_MlProjectsJobsList_580116,
    base: "/", url: url_MlProjectsJobsList_580117, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsCreate_580185 = ref object of OpenApiRestCall_579421
proc url_MlProjectsModelsCreate_580187(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/models")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsModelsCreate_580186(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a model which will later contain one or more versions.
  ## 
  ## You must add at least one version before you can request predictions from
  ## the model. Add versions by calling
  ## [projects.models.versions.create](/ml-engine/reference/rest/v1beta1/projects.models.versions/create).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580188 = path.getOrDefault("parent")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = nil)
  if valid_580188 != nil:
    section.add "parent", valid_580188
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580189 = query.getOrDefault("upload_protocol")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "upload_protocol", valid_580189
  var valid_580190 = query.getOrDefault("fields")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "fields", valid_580190
  var valid_580191 = query.getOrDefault("quotaUser")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "quotaUser", valid_580191
  var valid_580192 = query.getOrDefault("alt")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = newJString("json"))
  if valid_580192 != nil:
    section.add "alt", valid_580192
  var valid_580193 = query.getOrDefault("pp")
  valid_580193 = validateParameter(valid_580193, JBool, required = false,
                                 default = newJBool(true))
  if valid_580193 != nil:
    section.add "pp", valid_580193
  var valid_580194 = query.getOrDefault("oauth_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "oauth_token", valid_580194
  var valid_580195 = query.getOrDefault("uploadType")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "uploadType", valid_580195
  var valid_580196 = query.getOrDefault("callback")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "callback", valid_580196
  var valid_580197 = query.getOrDefault("access_token")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "access_token", valid_580197
  var valid_580198 = query.getOrDefault("key")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "key", valid_580198
  var valid_580199 = query.getOrDefault("$.xgafv")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = newJString("1"))
  if valid_580199 != nil:
    section.add "$.xgafv", valid_580199
  var valid_580200 = query.getOrDefault("prettyPrint")
  valid_580200 = validateParameter(valid_580200, JBool, required = false,
                                 default = newJBool(true))
  if valid_580200 != nil:
    section.add "prettyPrint", valid_580200
  var valid_580201 = query.getOrDefault("bearer_token")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "bearer_token", valid_580201
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

proc call*(call_580203: Call_MlProjectsModelsCreate_580185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a model which will later contain one or more versions.
  ## 
  ## You must add at least one version before you can request predictions from
  ## the model. Add versions by calling
  ## [projects.models.versions.create](/ml-engine/reference/rest/v1beta1/projects.models.versions/create).
  ## 
  let valid = call_580203.validator(path, query, header, formData, body)
  let scheme = call_580203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580203.url(scheme.get, call_580203.host, call_580203.base,
                         call_580203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580203, url, valid)

proc call*(call_580204: Call_MlProjectsModelsCreate_580185; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## mlProjectsModelsCreate
  ## Creates a model which will later contain one or more versions.
  ## 
  ## You must add at least one version before you can request predictions from
  ## the model. Add versions by calling
  ## [projects.models.versions.create](/ml-engine/reference/rest/v1beta1/projects.models.versions/create).
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
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
  var path_580205 = newJObject()
  var query_580206 = newJObject()
  var body_580207 = newJObject()
  add(query_580206, "upload_protocol", newJString(uploadProtocol))
  add(query_580206, "fields", newJString(fields))
  add(query_580206, "quotaUser", newJString(quotaUser))
  add(query_580206, "alt", newJString(alt))
  add(query_580206, "pp", newJBool(pp))
  add(query_580206, "oauth_token", newJString(oauthToken))
  add(query_580206, "uploadType", newJString(uploadType))
  add(query_580206, "callback", newJString(callback))
  add(query_580206, "access_token", newJString(accessToken))
  add(path_580205, "parent", newJString(parent))
  add(query_580206, "key", newJString(key))
  add(query_580206, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580207 = body
  add(query_580206, "prettyPrint", newJBool(prettyPrint))
  add(query_580206, "bearer_token", newJString(bearerToken))
  result = call_580204.call(path_580205, query_580206, nil, nil, body_580207)

var mlProjectsModelsCreate* = Call_MlProjectsModelsCreate_580185(
    name: "mlProjectsModelsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/models",
    validator: validate_MlProjectsModelsCreate_580186, base: "/",
    url: url_MlProjectsModelsCreate_580187, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsList_580162 = ref object of OpenApiRestCall_579421
proc url_MlProjectsModelsList_580164(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/models")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsModelsList_580163(path: JsonNode; query: JsonNode;
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
  var valid_580165 = path.getOrDefault("parent")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "parent", valid_580165
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580166 = query.getOrDefault("upload_protocol")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "upload_protocol", valid_580166
  var valid_580167 = query.getOrDefault("fields")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "fields", valid_580167
  var valid_580168 = query.getOrDefault("pageToken")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "pageToken", valid_580168
  var valid_580169 = query.getOrDefault("quotaUser")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "quotaUser", valid_580169
  var valid_580170 = query.getOrDefault("alt")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("json"))
  if valid_580170 != nil:
    section.add "alt", valid_580170
  var valid_580171 = query.getOrDefault("pp")
  valid_580171 = validateParameter(valid_580171, JBool, required = false,
                                 default = newJBool(true))
  if valid_580171 != nil:
    section.add "pp", valid_580171
  var valid_580172 = query.getOrDefault("oauth_token")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "oauth_token", valid_580172
  var valid_580173 = query.getOrDefault("uploadType")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "uploadType", valid_580173
  var valid_580174 = query.getOrDefault("callback")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "callback", valid_580174
  var valid_580175 = query.getOrDefault("access_token")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "access_token", valid_580175
  var valid_580176 = query.getOrDefault("key")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "key", valid_580176
  var valid_580177 = query.getOrDefault("$.xgafv")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = newJString("1"))
  if valid_580177 != nil:
    section.add "$.xgafv", valid_580177
  var valid_580178 = query.getOrDefault("pageSize")
  valid_580178 = validateParameter(valid_580178, JInt, required = false, default = nil)
  if valid_580178 != nil:
    section.add "pageSize", valid_580178
  var valid_580179 = query.getOrDefault("prettyPrint")
  valid_580179 = validateParameter(valid_580179, JBool, required = false,
                                 default = newJBool(true))
  if valid_580179 != nil:
    section.add "prettyPrint", valid_580179
  var valid_580180 = query.getOrDefault("bearer_token")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "bearer_token", valid_580180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580181: Call_MlProjectsModelsList_580162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the models in a project.
  ## 
  ## Each project can contain multiple models, and each model can have multiple
  ## versions.
  ## 
  let valid = call_580181.validator(path, query, header, formData, body)
  let scheme = call_580181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580181.url(scheme.get, call_580181.host, call_580181.base,
                         call_580181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580181, url, valid)

proc call*(call_580182: Call_MlProjectsModelsList_580162; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580183 = newJObject()
  var query_580184 = newJObject()
  add(query_580184, "upload_protocol", newJString(uploadProtocol))
  add(query_580184, "fields", newJString(fields))
  add(query_580184, "pageToken", newJString(pageToken))
  add(query_580184, "quotaUser", newJString(quotaUser))
  add(query_580184, "alt", newJString(alt))
  add(query_580184, "pp", newJBool(pp))
  add(query_580184, "oauth_token", newJString(oauthToken))
  add(query_580184, "uploadType", newJString(uploadType))
  add(query_580184, "callback", newJString(callback))
  add(query_580184, "access_token", newJString(accessToken))
  add(path_580183, "parent", newJString(parent))
  add(query_580184, "key", newJString(key))
  add(query_580184, "$.xgafv", newJString(Xgafv))
  add(query_580184, "pageSize", newJInt(pageSize))
  add(query_580184, "prettyPrint", newJBool(prettyPrint))
  add(query_580184, "bearer_token", newJString(bearerToken))
  result = call_580182.call(path_580183, query_580184, nil, nil, nil)

var mlProjectsModelsList* = Call_MlProjectsModelsList_580162(
    name: "mlProjectsModelsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/models",
    validator: validate_MlProjectsModelsList_580163, base: "/",
    url: url_MlProjectsModelsList_580164, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsCreate_580231 = ref object of OpenApiRestCall_579421
proc url_MlProjectsModelsVersionsCreate_580233(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsModelsVersionsCreate_580232(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new version of a model from a trained TensorFlow model.
  ## 
  ## If the version created in the cloud by this call is the first deployed
  ## version of the specified model, it will be made the default version of the
  ## model. When you add a version to a model that already has one or more
  ## versions, the default version does not automatically change. If you want a
  ## new version to be the default, you must call
  ## [projects.models.versions.setDefault](/ml-engine/reference/rest/v1beta1/projects.models.versions/setDefault).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the model.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580234 = path.getOrDefault("parent")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "parent", valid_580234
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580235 = query.getOrDefault("upload_protocol")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "upload_protocol", valid_580235
  var valid_580236 = query.getOrDefault("fields")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "fields", valid_580236
  var valid_580237 = query.getOrDefault("quotaUser")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "quotaUser", valid_580237
  var valid_580238 = query.getOrDefault("alt")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = newJString("json"))
  if valid_580238 != nil:
    section.add "alt", valid_580238
  var valid_580239 = query.getOrDefault("pp")
  valid_580239 = validateParameter(valid_580239, JBool, required = false,
                                 default = newJBool(true))
  if valid_580239 != nil:
    section.add "pp", valid_580239
  var valid_580240 = query.getOrDefault("oauth_token")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "oauth_token", valid_580240
  var valid_580241 = query.getOrDefault("uploadType")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "uploadType", valid_580241
  var valid_580242 = query.getOrDefault("callback")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "callback", valid_580242
  var valid_580243 = query.getOrDefault("access_token")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "access_token", valid_580243
  var valid_580244 = query.getOrDefault("key")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "key", valid_580244
  var valid_580245 = query.getOrDefault("$.xgafv")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = newJString("1"))
  if valid_580245 != nil:
    section.add "$.xgafv", valid_580245
  var valid_580246 = query.getOrDefault("prettyPrint")
  valid_580246 = validateParameter(valid_580246, JBool, required = false,
                                 default = newJBool(true))
  if valid_580246 != nil:
    section.add "prettyPrint", valid_580246
  var valid_580247 = query.getOrDefault("bearer_token")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "bearer_token", valid_580247
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

proc call*(call_580249: Call_MlProjectsModelsVersionsCreate_580231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new version of a model from a trained TensorFlow model.
  ## 
  ## If the version created in the cloud by this call is the first deployed
  ## version of the specified model, it will be made the default version of the
  ## model. When you add a version to a model that already has one or more
  ## versions, the default version does not automatically change. If you want a
  ## new version to be the default, you must call
  ## [projects.models.versions.setDefault](/ml-engine/reference/rest/v1beta1/projects.models.versions/setDefault).
  ## 
  let valid = call_580249.validator(path, query, header, formData, body)
  let scheme = call_580249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580249.url(scheme.get, call_580249.host, call_580249.base,
                         call_580249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580249, url, valid)

proc call*(call_580250: Call_MlProjectsModelsVersionsCreate_580231; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
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
  ## [projects.models.versions.setDefault](/ml-engine/reference/rest/v1beta1/projects.models.versions/setDefault).
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
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
  var path_580251 = newJObject()
  var query_580252 = newJObject()
  var body_580253 = newJObject()
  add(query_580252, "upload_protocol", newJString(uploadProtocol))
  add(query_580252, "fields", newJString(fields))
  add(query_580252, "quotaUser", newJString(quotaUser))
  add(query_580252, "alt", newJString(alt))
  add(query_580252, "pp", newJBool(pp))
  add(query_580252, "oauth_token", newJString(oauthToken))
  add(query_580252, "uploadType", newJString(uploadType))
  add(query_580252, "callback", newJString(callback))
  add(query_580252, "access_token", newJString(accessToken))
  add(path_580251, "parent", newJString(parent))
  add(query_580252, "key", newJString(key))
  add(query_580252, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580253 = body
  add(query_580252, "prettyPrint", newJBool(prettyPrint))
  add(query_580252, "bearer_token", newJString(bearerToken))
  result = call_580250.call(path_580251, query_580252, nil, nil, body_580253)

var mlProjectsModelsVersionsCreate* = Call_MlProjectsModelsVersionsCreate_580231(
    name: "mlProjectsModelsVersionsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/versions",
    validator: validate_MlProjectsModelsVersionsCreate_580232, base: "/",
    url: url_MlProjectsModelsVersionsCreate_580233, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsList_580208 = ref object of OpenApiRestCall_579421
proc url_MlProjectsModelsVersionsList_580210(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlProjectsModelsVersionsList_580209(path: JsonNode; query: JsonNode;
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
  var valid_580211 = path.getOrDefault("parent")
  valid_580211 = validateParameter(valid_580211, JString, required = true,
                                 default = nil)
  if valid_580211 != nil:
    section.add "parent", valid_580211
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580212 = query.getOrDefault("upload_protocol")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "upload_protocol", valid_580212
  var valid_580213 = query.getOrDefault("fields")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "fields", valid_580213
  var valid_580214 = query.getOrDefault("pageToken")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "pageToken", valid_580214
  var valid_580215 = query.getOrDefault("quotaUser")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "quotaUser", valid_580215
  var valid_580216 = query.getOrDefault("alt")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = newJString("json"))
  if valid_580216 != nil:
    section.add "alt", valid_580216
  var valid_580217 = query.getOrDefault("pp")
  valid_580217 = validateParameter(valid_580217, JBool, required = false,
                                 default = newJBool(true))
  if valid_580217 != nil:
    section.add "pp", valid_580217
  var valid_580218 = query.getOrDefault("oauth_token")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "oauth_token", valid_580218
  var valid_580219 = query.getOrDefault("uploadType")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "uploadType", valid_580219
  var valid_580220 = query.getOrDefault("callback")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "callback", valid_580220
  var valid_580221 = query.getOrDefault("access_token")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "access_token", valid_580221
  var valid_580222 = query.getOrDefault("key")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "key", valid_580222
  var valid_580223 = query.getOrDefault("$.xgafv")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = newJString("1"))
  if valid_580223 != nil:
    section.add "$.xgafv", valid_580223
  var valid_580224 = query.getOrDefault("pageSize")
  valid_580224 = validateParameter(valid_580224, JInt, required = false, default = nil)
  if valid_580224 != nil:
    section.add "pageSize", valid_580224
  var valid_580225 = query.getOrDefault("prettyPrint")
  valid_580225 = validateParameter(valid_580225, JBool, required = false,
                                 default = newJBool(true))
  if valid_580225 != nil:
    section.add "prettyPrint", valid_580225
  var valid_580226 = query.getOrDefault("bearer_token")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "bearer_token", valid_580226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580227: Call_MlProjectsModelsVersionsList_580208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets basic information about all the versions of a model.
  ## 
  ## If you expect that a model has a lot of versions, or if you need to handle
  ## only a limited number of results at a time, you can request that the list
  ## be retrieved in batches (called pages):
  ## 
  let valid = call_580227.validator(path, query, header, formData, body)
  let scheme = call_580227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580227.url(scheme.get, call_580227.host, call_580227.base,
                         call_580227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580227, url, valid)

proc call*(call_580228: Call_MlProjectsModelsVersionsList_580208; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580229 = newJObject()
  var query_580230 = newJObject()
  add(query_580230, "upload_protocol", newJString(uploadProtocol))
  add(query_580230, "fields", newJString(fields))
  add(query_580230, "pageToken", newJString(pageToken))
  add(query_580230, "quotaUser", newJString(quotaUser))
  add(query_580230, "alt", newJString(alt))
  add(query_580230, "pp", newJBool(pp))
  add(query_580230, "oauth_token", newJString(oauthToken))
  add(query_580230, "uploadType", newJString(uploadType))
  add(query_580230, "callback", newJString(callback))
  add(query_580230, "access_token", newJString(accessToken))
  add(path_580229, "parent", newJString(parent))
  add(query_580230, "key", newJString(key))
  add(query_580230, "$.xgafv", newJString(Xgafv))
  add(query_580230, "pageSize", newJInt(pageSize))
  add(query_580230, "prettyPrint", newJBool(prettyPrint))
  add(query_580230, "bearer_token", newJString(bearerToken))
  result = call_580228.call(path_580229, query_580230, nil, nil, nil)

var mlProjectsModelsVersionsList* = Call_MlProjectsModelsVersionsList_580208(
    name: "mlProjectsModelsVersionsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/versions",
    validator: validate_MlProjectsModelsVersionsList_580209, base: "/",
    url: url_MlProjectsModelsVersionsList_580210, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsGetIamPolicy_580254 = ref object of OpenApiRestCall_579421
proc url_MlProjectsJobsGetIamPolicy_580256(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_MlProjectsJobsGetIamPolicy_580255(path: JsonNode; query: JsonNode;
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
  var valid_580257 = path.getOrDefault("resource")
  valid_580257 = validateParameter(valid_580257, JString, required = true,
                                 default = nil)
  if valid_580257 != nil:
    section.add "resource", valid_580257
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
  var valid_580258 = query.getOrDefault("upload_protocol")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "upload_protocol", valid_580258
  var valid_580259 = query.getOrDefault("fields")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "fields", valid_580259
  var valid_580260 = query.getOrDefault("quotaUser")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "quotaUser", valid_580260
  var valid_580261 = query.getOrDefault("alt")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = newJString("json"))
  if valid_580261 != nil:
    section.add "alt", valid_580261
  var valid_580262 = query.getOrDefault("pp")
  valid_580262 = validateParameter(valid_580262, JBool, required = false,
                                 default = newJBool(true))
  if valid_580262 != nil:
    section.add "pp", valid_580262
  var valid_580263 = query.getOrDefault("oauth_token")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "oauth_token", valid_580263
  var valid_580264 = query.getOrDefault("callback")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "callback", valid_580264
  var valid_580265 = query.getOrDefault("access_token")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "access_token", valid_580265
  var valid_580266 = query.getOrDefault("uploadType")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "uploadType", valid_580266
  var valid_580267 = query.getOrDefault("key")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "key", valid_580267
  var valid_580268 = query.getOrDefault("$.xgafv")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = newJString("1"))
  if valid_580268 != nil:
    section.add "$.xgafv", valid_580268
  var valid_580269 = query.getOrDefault("prettyPrint")
  valid_580269 = validateParameter(valid_580269, JBool, required = false,
                                 default = newJBool(true))
  if valid_580269 != nil:
    section.add "prettyPrint", valid_580269
  var valid_580270 = query.getOrDefault("bearer_token")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "bearer_token", valid_580270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580271: Call_MlProjectsJobsGetIamPolicy_580254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_580271.validator(path, query, header, formData, body)
  let scheme = call_580271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580271.url(scheme.get, call_580271.host, call_580271.base,
                         call_580271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580271, url, valid)

proc call*(call_580272: Call_MlProjectsJobsGetIamPolicy_580254; resource: string;
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
  var path_580273 = newJObject()
  var query_580274 = newJObject()
  add(query_580274, "upload_protocol", newJString(uploadProtocol))
  add(query_580274, "fields", newJString(fields))
  add(query_580274, "quotaUser", newJString(quotaUser))
  add(query_580274, "alt", newJString(alt))
  add(query_580274, "pp", newJBool(pp))
  add(query_580274, "oauth_token", newJString(oauthToken))
  add(query_580274, "callback", newJString(callback))
  add(query_580274, "access_token", newJString(accessToken))
  add(query_580274, "uploadType", newJString(uploadType))
  add(query_580274, "key", newJString(key))
  add(query_580274, "$.xgafv", newJString(Xgafv))
  add(path_580273, "resource", newJString(resource))
  add(query_580274, "prettyPrint", newJBool(prettyPrint))
  add(query_580274, "bearer_token", newJString(bearerToken))
  result = call_580272.call(path_580273, query_580274, nil, nil, nil)

var mlProjectsJobsGetIamPolicy* = Call_MlProjectsJobsGetIamPolicy_580254(
    name: "mlProjectsJobsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_MlProjectsJobsGetIamPolicy_580255, base: "/",
    url: url_MlProjectsJobsGetIamPolicy_580256, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsSetIamPolicy_580275 = ref object of OpenApiRestCall_579421
proc url_MlProjectsJobsSetIamPolicy_580277(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_MlProjectsJobsSetIamPolicy_580276(path: JsonNode; query: JsonNode;
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
  var valid_580278 = path.getOrDefault("resource")
  valid_580278 = validateParameter(valid_580278, JString, required = true,
                                 default = nil)
  if valid_580278 != nil:
    section.add "resource", valid_580278
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
  var valid_580279 = query.getOrDefault("upload_protocol")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "upload_protocol", valid_580279
  var valid_580280 = query.getOrDefault("fields")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "fields", valid_580280
  var valid_580281 = query.getOrDefault("quotaUser")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "quotaUser", valid_580281
  var valid_580282 = query.getOrDefault("alt")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = newJString("json"))
  if valid_580282 != nil:
    section.add "alt", valid_580282
  var valid_580283 = query.getOrDefault("pp")
  valid_580283 = validateParameter(valid_580283, JBool, required = false,
                                 default = newJBool(true))
  if valid_580283 != nil:
    section.add "pp", valid_580283
  var valid_580284 = query.getOrDefault("oauth_token")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "oauth_token", valid_580284
  var valid_580285 = query.getOrDefault("callback")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "callback", valid_580285
  var valid_580286 = query.getOrDefault("access_token")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "access_token", valid_580286
  var valid_580287 = query.getOrDefault("uploadType")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "uploadType", valid_580287
  var valid_580288 = query.getOrDefault("key")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "key", valid_580288
  var valid_580289 = query.getOrDefault("$.xgafv")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = newJString("1"))
  if valid_580289 != nil:
    section.add "$.xgafv", valid_580289
  var valid_580290 = query.getOrDefault("prettyPrint")
  valid_580290 = validateParameter(valid_580290, JBool, required = false,
                                 default = newJBool(true))
  if valid_580290 != nil:
    section.add "prettyPrint", valid_580290
  var valid_580291 = query.getOrDefault("bearer_token")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "bearer_token", valid_580291
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

proc call*(call_580293: Call_MlProjectsJobsSetIamPolicy_580275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_580293.validator(path, query, header, formData, body)
  let scheme = call_580293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580293.url(scheme.get, call_580293.host, call_580293.base,
                         call_580293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580293, url, valid)

proc call*(call_580294: Call_MlProjectsJobsSetIamPolicy_580275; resource: string;
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
  var path_580295 = newJObject()
  var query_580296 = newJObject()
  var body_580297 = newJObject()
  add(query_580296, "upload_protocol", newJString(uploadProtocol))
  add(query_580296, "fields", newJString(fields))
  add(query_580296, "quotaUser", newJString(quotaUser))
  add(query_580296, "alt", newJString(alt))
  add(query_580296, "pp", newJBool(pp))
  add(query_580296, "oauth_token", newJString(oauthToken))
  add(query_580296, "callback", newJString(callback))
  add(query_580296, "access_token", newJString(accessToken))
  add(query_580296, "uploadType", newJString(uploadType))
  add(query_580296, "key", newJString(key))
  add(query_580296, "$.xgafv", newJString(Xgafv))
  add(path_580295, "resource", newJString(resource))
  if body != nil:
    body_580297 = body
  add(query_580296, "prettyPrint", newJBool(prettyPrint))
  add(query_580296, "bearer_token", newJString(bearerToken))
  result = call_580294.call(path_580295, query_580296, nil, nil, body_580297)

var mlProjectsJobsSetIamPolicy* = Call_MlProjectsJobsSetIamPolicy_580275(
    name: "mlProjectsJobsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_MlProjectsJobsSetIamPolicy_580276, base: "/",
    url: url_MlProjectsJobsSetIamPolicy_580277, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsTestIamPermissions_580298 = ref object of OpenApiRestCall_579421
proc url_MlProjectsJobsTestIamPermissions_580300(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_MlProjectsJobsTestIamPermissions_580299(path: JsonNode;
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
  var valid_580301 = path.getOrDefault("resource")
  valid_580301 = validateParameter(valid_580301, JString, required = true,
                                 default = nil)
  if valid_580301 != nil:
    section.add "resource", valid_580301
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
  var valid_580302 = query.getOrDefault("upload_protocol")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "upload_protocol", valid_580302
  var valid_580303 = query.getOrDefault("fields")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "fields", valid_580303
  var valid_580304 = query.getOrDefault("quotaUser")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "quotaUser", valid_580304
  var valid_580305 = query.getOrDefault("alt")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = newJString("json"))
  if valid_580305 != nil:
    section.add "alt", valid_580305
  var valid_580306 = query.getOrDefault("pp")
  valid_580306 = validateParameter(valid_580306, JBool, required = false,
                                 default = newJBool(true))
  if valid_580306 != nil:
    section.add "pp", valid_580306
  var valid_580307 = query.getOrDefault("oauth_token")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "oauth_token", valid_580307
  var valid_580308 = query.getOrDefault("callback")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "callback", valid_580308
  var valid_580309 = query.getOrDefault("access_token")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "access_token", valid_580309
  var valid_580310 = query.getOrDefault("uploadType")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "uploadType", valid_580310
  var valid_580311 = query.getOrDefault("key")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "key", valid_580311
  var valid_580312 = query.getOrDefault("$.xgafv")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = newJString("1"))
  if valid_580312 != nil:
    section.add "$.xgafv", valid_580312
  var valid_580313 = query.getOrDefault("prettyPrint")
  valid_580313 = validateParameter(valid_580313, JBool, required = false,
                                 default = newJBool(true))
  if valid_580313 != nil:
    section.add "prettyPrint", valid_580313
  var valid_580314 = query.getOrDefault("bearer_token")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "bearer_token", valid_580314
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

proc call*(call_580316: Call_MlProjectsJobsTestIamPermissions_580298;
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
  let valid = call_580316.validator(path, query, header, formData, body)
  let scheme = call_580316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580316.url(scheme.get, call_580316.host, call_580316.base,
                         call_580316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580316, url, valid)

proc call*(call_580317: Call_MlProjectsJobsTestIamPermissions_580298;
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
  var path_580318 = newJObject()
  var query_580319 = newJObject()
  var body_580320 = newJObject()
  add(query_580319, "upload_protocol", newJString(uploadProtocol))
  add(query_580319, "fields", newJString(fields))
  add(query_580319, "quotaUser", newJString(quotaUser))
  add(query_580319, "alt", newJString(alt))
  add(query_580319, "pp", newJBool(pp))
  add(query_580319, "oauth_token", newJString(oauthToken))
  add(query_580319, "callback", newJString(callback))
  add(query_580319, "access_token", newJString(accessToken))
  add(query_580319, "uploadType", newJString(uploadType))
  add(query_580319, "key", newJString(key))
  add(query_580319, "$.xgafv", newJString(Xgafv))
  add(path_580318, "resource", newJString(resource))
  if body != nil:
    body_580320 = body
  add(query_580319, "prettyPrint", newJBool(prettyPrint))
  add(query_580319, "bearer_token", newJString(bearerToken))
  result = call_580317.call(path_580318, query_580319, nil, nil, body_580320)

var mlProjectsJobsTestIamPermissions* = Call_MlProjectsJobsTestIamPermissions_580298(
    name: "mlProjectsJobsTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_MlProjectsJobsTestIamPermissions_580299, base: "/",
    url: url_MlProjectsJobsTestIamPermissions_580300, schemes: {Scheme.Https})
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
