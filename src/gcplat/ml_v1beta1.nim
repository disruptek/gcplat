
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  Call_MlProjectsJobsGet_578619 = ref object of OpenApiRestCall_578348
proc url_MlProjectsJobsGet_578621(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsJobsGet_578620(path: JsonNode; query: JsonNode;
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
  var valid_578747 = path.getOrDefault("name")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "name", valid_578747
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("pp")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "pp", valid_578762
  var valid_578763 = query.getOrDefault("prettyPrint")
  valid_578763 = validateParameter(valid_578763, JBool, required = false,
                                 default = newJBool(true))
  if valid_578763 != nil:
    section.add "prettyPrint", valid_578763
  var valid_578764 = query.getOrDefault("oauth_token")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "oauth_token", valid_578764
  var valid_578765 = query.getOrDefault("$.xgafv")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("1"))
  if valid_578765 != nil:
    section.add "$.xgafv", valid_578765
  var valid_578766 = query.getOrDefault("bearer_token")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "bearer_token", valid_578766
  var valid_578767 = query.getOrDefault("uploadType")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "uploadType", valid_578767
  var valid_578768 = query.getOrDefault("alt")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = newJString("json"))
  if valid_578768 != nil:
    section.add "alt", valid_578768
  var valid_578769 = query.getOrDefault("quotaUser")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "quotaUser", valid_578769
  var valid_578770 = query.getOrDefault("callback")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "callback", valid_578770
  var valid_578771 = query.getOrDefault("fields")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "fields", valid_578771
  var valid_578772 = query.getOrDefault("access_token")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "access_token", valid_578772
  var valid_578773 = query.getOrDefault("upload_protocol")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "upload_protocol", valid_578773
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578796: Call_MlProjectsJobsGet_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Describes a job.
  ## 
  let valid = call_578796.validator(path, query, header, formData, body)
  let scheme = call_578796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578796.url(scheme.get, call_578796.host, call_578796.base,
                         call_578796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578796, url, valid)

proc call*(call_578867: Call_MlProjectsJobsGet_578619; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
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
  var path_578868 = newJObject()
  var query_578870 = newJObject()
  add(query_578870, "key", newJString(key))
  add(query_578870, "pp", newJBool(pp))
  add(query_578870, "prettyPrint", newJBool(prettyPrint))
  add(query_578870, "oauth_token", newJString(oauthToken))
  add(query_578870, "$.xgafv", newJString(Xgafv))
  add(query_578870, "bearer_token", newJString(bearerToken))
  add(query_578870, "uploadType", newJString(uploadType))
  add(query_578870, "alt", newJString(alt))
  add(query_578870, "quotaUser", newJString(quotaUser))
  add(path_578868, "name", newJString(name))
  add(query_578870, "callback", newJString(callback))
  add(query_578870, "fields", newJString(fields))
  add(query_578870, "access_token", newJString(accessToken))
  add(query_578870, "upload_protocol", newJString(uploadProtocol))
  result = call_578867.call(path_578868, query_578870, nil, nil, nil)

var mlProjectsJobsGet* = Call_MlProjectsJobsGet_578619(name: "mlProjectsJobsGet",
    meth: HttpMethod.HttpGet, host: "ml.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_MlProjectsJobsGet_578620, base: "/",
    url: url_MlProjectsJobsGet_578621, schemes: {Scheme.Https})
type
  Call_MlProjectsOperationsDelete_578909 = ref object of OpenApiRestCall_578348
proc url_MlProjectsOperationsDelete_578911(protocol: Scheme; host: string;
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

proc validate_MlProjectsOperationsDelete_578910(path: JsonNode; query: JsonNode;
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
  var valid_578912 = path.getOrDefault("name")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "name", valid_578912
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_578913 = query.getOrDefault("key")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "key", valid_578913
  var valid_578914 = query.getOrDefault("pp")
  valid_578914 = validateParameter(valid_578914, JBool, required = false,
                                 default = newJBool(true))
  if valid_578914 != nil:
    section.add "pp", valid_578914
  var valid_578915 = query.getOrDefault("prettyPrint")
  valid_578915 = validateParameter(valid_578915, JBool, required = false,
                                 default = newJBool(true))
  if valid_578915 != nil:
    section.add "prettyPrint", valid_578915
  var valid_578916 = query.getOrDefault("oauth_token")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "oauth_token", valid_578916
  var valid_578917 = query.getOrDefault("$.xgafv")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = newJString("1"))
  if valid_578917 != nil:
    section.add "$.xgafv", valid_578917
  var valid_578918 = query.getOrDefault("bearer_token")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "bearer_token", valid_578918
  var valid_578919 = query.getOrDefault("uploadType")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "uploadType", valid_578919
  var valid_578920 = query.getOrDefault("alt")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = newJString("json"))
  if valid_578920 != nil:
    section.add "alt", valid_578920
  var valid_578921 = query.getOrDefault("quotaUser")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "quotaUser", valid_578921
  var valid_578922 = query.getOrDefault("callback")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "callback", valid_578922
  var valid_578923 = query.getOrDefault("fields")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "fields", valid_578923
  var valid_578924 = query.getOrDefault("access_token")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "access_token", valid_578924
  var valid_578925 = query.getOrDefault("upload_protocol")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "upload_protocol", valid_578925
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578926: Call_MlProjectsOperationsDelete_578909; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_578926.validator(path, query, header, formData, body)
  let scheme = call_578926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578926.url(scheme.get, call_578926.host, call_578926.base,
                         call_578926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578926, url, valid)

proc call*(call_578927: Call_MlProjectsOperationsDelete_578909; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## mlProjectsOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578928 = newJObject()
  var query_578929 = newJObject()
  add(query_578929, "key", newJString(key))
  add(query_578929, "pp", newJBool(pp))
  add(query_578929, "prettyPrint", newJBool(prettyPrint))
  add(query_578929, "oauth_token", newJString(oauthToken))
  add(query_578929, "$.xgafv", newJString(Xgafv))
  add(query_578929, "bearer_token", newJString(bearerToken))
  add(query_578929, "uploadType", newJString(uploadType))
  add(query_578929, "alt", newJString(alt))
  add(query_578929, "quotaUser", newJString(quotaUser))
  add(path_578928, "name", newJString(name))
  add(query_578929, "callback", newJString(callback))
  add(query_578929, "fields", newJString(fields))
  add(query_578929, "access_token", newJString(accessToken))
  add(query_578929, "upload_protocol", newJString(uploadProtocol))
  result = call_578927.call(path_578928, query_578929, nil, nil, nil)

var mlProjectsOperationsDelete* = Call_MlProjectsOperationsDelete_578909(
    name: "mlProjectsOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "ml.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_MlProjectsOperationsDelete_578910, base: "/",
    url: url_MlProjectsOperationsDelete_578911, schemes: {Scheme.Https})
type
  Call_MlProjectsOperationsList_578930 = ref object of OpenApiRestCall_578348
proc url_MlProjectsOperationsList_578932(protocol: Scheme; host: string;
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

proc validate_MlProjectsOperationsList_578931(path: JsonNode; query: JsonNode;
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
  var valid_578933 = path.getOrDefault("name")
  valid_578933 = validateParameter(valid_578933, JString, required = true,
                                 default = nil)
  if valid_578933 != nil:
    section.add "name", valid_578933
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_578934 = query.getOrDefault("key")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "key", valid_578934
  var valid_578935 = query.getOrDefault("pp")
  valid_578935 = validateParameter(valid_578935, JBool, required = false,
                                 default = newJBool(true))
  if valid_578935 != nil:
    section.add "pp", valid_578935
  var valid_578936 = query.getOrDefault("prettyPrint")
  valid_578936 = validateParameter(valid_578936, JBool, required = false,
                                 default = newJBool(true))
  if valid_578936 != nil:
    section.add "prettyPrint", valid_578936
  var valid_578937 = query.getOrDefault("oauth_token")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "oauth_token", valid_578937
  var valid_578938 = query.getOrDefault("$.xgafv")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("1"))
  if valid_578938 != nil:
    section.add "$.xgafv", valid_578938
  var valid_578939 = query.getOrDefault("bearer_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "bearer_token", valid_578939
  var valid_578940 = query.getOrDefault("pageSize")
  valid_578940 = validateParameter(valid_578940, JInt, required = false, default = nil)
  if valid_578940 != nil:
    section.add "pageSize", valid_578940
  var valid_578941 = query.getOrDefault("uploadType")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "uploadType", valid_578941
  var valid_578942 = query.getOrDefault("alt")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = newJString("json"))
  if valid_578942 != nil:
    section.add "alt", valid_578942
  var valid_578943 = query.getOrDefault("quotaUser")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "quotaUser", valid_578943
  var valid_578944 = query.getOrDefault("filter")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "filter", valid_578944
  var valid_578945 = query.getOrDefault("pageToken")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "pageToken", valid_578945
  var valid_578946 = query.getOrDefault("callback")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "callback", valid_578946
  var valid_578947 = query.getOrDefault("fields")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "fields", valid_578947
  var valid_578948 = query.getOrDefault("access_token")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "access_token", valid_578948
  var valid_578949 = query.getOrDefault("upload_protocol")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "upload_protocol", valid_578949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578950: Call_MlProjectsOperationsList_578930; path: JsonNode;
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
  let valid = call_578950.validator(path, query, header, formData, body)
  let scheme = call_578950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578950.url(scheme.get, call_578950.host, call_578950.base,
                         call_578950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578950, url, valid)

proc call*(call_578951: Call_MlProjectsOperationsList_578930; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; uploadType: string = ""; alt: string = "json";
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
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
  var path_578952 = newJObject()
  var query_578953 = newJObject()
  add(query_578953, "key", newJString(key))
  add(query_578953, "pp", newJBool(pp))
  add(query_578953, "prettyPrint", newJBool(prettyPrint))
  add(query_578953, "oauth_token", newJString(oauthToken))
  add(query_578953, "$.xgafv", newJString(Xgafv))
  add(query_578953, "bearer_token", newJString(bearerToken))
  add(query_578953, "pageSize", newJInt(pageSize))
  add(query_578953, "uploadType", newJString(uploadType))
  add(query_578953, "alt", newJString(alt))
  add(query_578953, "quotaUser", newJString(quotaUser))
  add(path_578952, "name", newJString(name))
  add(query_578953, "filter", newJString(filter))
  add(query_578953, "pageToken", newJString(pageToken))
  add(query_578953, "callback", newJString(callback))
  add(query_578953, "fields", newJString(fields))
  add(query_578953, "access_token", newJString(accessToken))
  add(query_578953, "upload_protocol", newJString(uploadProtocol))
  result = call_578951.call(path_578952, query_578953, nil, nil, nil)

var mlProjectsOperationsList* = Call_MlProjectsOperationsList_578930(
    name: "mlProjectsOperationsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{name}/operations",
    validator: validate_MlProjectsOperationsList_578931, base: "/",
    url: url_MlProjectsOperationsList_578932, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsCancel_578954 = ref object of OpenApiRestCall_578348
proc url_MlProjectsJobsCancel_578956(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsJobsCancel_578955(path: JsonNode; query: JsonNode;
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
  var valid_578957 = path.getOrDefault("name")
  valid_578957 = validateParameter(valid_578957, JString, required = true,
                                 default = nil)
  if valid_578957 != nil:
    section.add "name", valid_578957
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_578958 = query.getOrDefault("key")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "key", valid_578958
  var valid_578959 = query.getOrDefault("pp")
  valid_578959 = validateParameter(valid_578959, JBool, required = false,
                                 default = newJBool(true))
  if valid_578959 != nil:
    section.add "pp", valid_578959
  var valid_578960 = query.getOrDefault("prettyPrint")
  valid_578960 = validateParameter(valid_578960, JBool, required = false,
                                 default = newJBool(true))
  if valid_578960 != nil:
    section.add "prettyPrint", valid_578960
  var valid_578961 = query.getOrDefault("oauth_token")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "oauth_token", valid_578961
  var valid_578962 = query.getOrDefault("$.xgafv")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = newJString("1"))
  if valid_578962 != nil:
    section.add "$.xgafv", valid_578962
  var valid_578963 = query.getOrDefault("bearer_token")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "bearer_token", valid_578963
  var valid_578964 = query.getOrDefault("uploadType")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "uploadType", valid_578964
  var valid_578965 = query.getOrDefault("alt")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("json"))
  if valid_578965 != nil:
    section.add "alt", valid_578965
  var valid_578966 = query.getOrDefault("quotaUser")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "quotaUser", valid_578966
  var valid_578967 = query.getOrDefault("callback")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "callback", valid_578967
  var valid_578968 = query.getOrDefault("fields")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "fields", valid_578968
  var valid_578969 = query.getOrDefault("access_token")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "access_token", valid_578969
  var valid_578970 = query.getOrDefault("upload_protocol")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "upload_protocol", valid_578970
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

proc call*(call_578972: Call_MlProjectsJobsCancel_578954; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a running job.
  ## 
  let valid = call_578972.validator(path, query, header, formData, body)
  let scheme = call_578972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578972.url(scheme.get, call_578972.host, call_578972.base,
                         call_578972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578972, url, valid)

proc call*(call_578973: Call_MlProjectsJobsCancel_578954; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
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
  var path_578974 = newJObject()
  var query_578975 = newJObject()
  var body_578976 = newJObject()
  add(query_578975, "key", newJString(key))
  add(query_578975, "pp", newJBool(pp))
  add(query_578975, "prettyPrint", newJBool(prettyPrint))
  add(query_578975, "oauth_token", newJString(oauthToken))
  add(query_578975, "$.xgafv", newJString(Xgafv))
  add(query_578975, "bearer_token", newJString(bearerToken))
  add(query_578975, "uploadType", newJString(uploadType))
  add(query_578975, "alt", newJString(alt))
  add(query_578975, "quotaUser", newJString(quotaUser))
  add(path_578974, "name", newJString(name))
  if body != nil:
    body_578976 = body
  add(query_578975, "callback", newJString(callback))
  add(query_578975, "fields", newJString(fields))
  add(query_578975, "access_token", newJString(accessToken))
  add(query_578975, "upload_protocol", newJString(uploadProtocol))
  result = call_578973.call(path_578974, query_578975, nil, nil, body_578976)

var mlProjectsJobsCancel* = Call_MlProjectsJobsCancel_578954(
    name: "mlProjectsJobsCancel", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{name}:cancel",
    validator: validate_MlProjectsJobsCancel_578955, base: "/",
    url: url_MlProjectsJobsCancel_578956, schemes: {Scheme.Https})
type
  Call_MlProjectsGetConfig_578977 = ref object of OpenApiRestCall_578348
proc url_MlProjectsGetConfig_578979(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsGetConfig_578978(path: JsonNode; query: JsonNode;
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
  var valid_578980 = path.getOrDefault("name")
  valid_578980 = validateParameter(valid_578980, JString, required = true,
                                 default = nil)
  if valid_578980 != nil:
    section.add "name", valid_578980
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_578981 = query.getOrDefault("key")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "key", valid_578981
  var valid_578982 = query.getOrDefault("pp")
  valid_578982 = validateParameter(valid_578982, JBool, required = false,
                                 default = newJBool(true))
  if valid_578982 != nil:
    section.add "pp", valid_578982
  var valid_578983 = query.getOrDefault("prettyPrint")
  valid_578983 = validateParameter(valid_578983, JBool, required = false,
                                 default = newJBool(true))
  if valid_578983 != nil:
    section.add "prettyPrint", valid_578983
  var valid_578984 = query.getOrDefault("oauth_token")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "oauth_token", valid_578984
  var valid_578985 = query.getOrDefault("$.xgafv")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = newJString("1"))
  if valid_578985 != nil:
    section.add "$.xgafv", valid_578985
  var valid_578986 = query.getOrDefault("bearer_token")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "bearer_token", valid_578986
  var valid_578987 = query.getOrDefault("uploadType")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "uploadType", valid_578987
  var valid_578988 = query.getOrDefault("alt")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("json"))
  if valid_578988 != nil:
    section.add "alt", valid_578988
  var valid_578989 = query.getOrDefault("quotaUser")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "quotaUser", valid_578989
  var valid_578990 = query.getOrDefault("callback")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "callback", valid_578990
  var valid_578991 = query.getOrDefault("fields")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "fields", valid_578991
  var valid_578992 = query.getOrDefault("access_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "access_token", valid_578992
  var valid_578993 = query.getOrDefault("upload_protocol")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "upload_protocol", valid_578993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578994: Call_MlProjectsGetConfig_578977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the service account information associated with your project. You need
  ## this information in order to grant the service account persmissions for
  ## the Google Cloud Storage location where you put your model training code
  ## for training the model with Google Cloud Machine Learning.
  ## 
  let valid = call_578994.validator(path, query, header, formData, body)
  let scheme = call_578994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578994.url(scheme.get, call_578994.host, call_578994.base,
                         call_578994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578994, url, valid)

proc call*(call_578995: Call_MlProjectsGetConfig_578977; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
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
  var path_578996 = newJObject()
  var query_578997 = newJObject()
  add(query_578997, "key", newJString(key))
  add(query_578997, "pp", newJBool(pp))
  add(query_578997, "prettyPrint", newJBool(prettyPrint))
  add(query_578997, "oauth_token", newJString(oauthToken))
  add(query_578997, "$.xgafv", newJString(Xgafv))
  add(query_578997, "bearer_token", newJString(bearerToken))
  add(query_578997, "uploadType", newJString(uploadType))
  add(query_578997, "alt", newJString(alt))
  add(query_578997, "quotaUser", newJString(quotaUser))
  add(path_578996, "name", newJString(name))
  add(query_578997, "callback", newJString(callback))
  add(query_578997, "fields", newJString(fields))
  add(query_578997, "access_token", newJString(accessToken))
  add(query_578997, "upload_protocol", newJString(uploadProtocol))
  result = call_578995.call(path_578996, query_578997, nil, nil, nil)

var mlProjectsGetConfig* = Call_MlProjectsGetConfig_578977(
    name: "mlProjectsGetConfig", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{name}:getConfig",
    validator: validate_MlProjectsGetConfig_578978, base: "/",
    url: url_MlProjectsGetConfig_578979, schemes: {Scheme.Https})
type
  Call_MlProjectsPredict_578998 = ref object of OpenApiRestCall_578348
proc url_MlProjectsPredict_579000(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsPredict_578999(path: JsonNode; query: JsonNode;
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
  var valid_579001 = path.getOrDefault("name")
  valid_579001 = validateParameter(valid_579001, JString, required = true,
                                 default = nil)
  if valid_579001 != nil:
    section.add "name", valid_579001
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_579002 = query.getOrDefault("key")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "key", valid_579002
  var valid_579003 = query.getOrDefault("pp")
  valid_579003 = validateParameter(valid_579003, JBool, required = false,
                                 default = newJBool(true))
  if valid_579003 != nil:
    section.add "pp", valid_579003
  var valid_579004 = query.getOrDefault("prettyPrint")
  valid_579004 = validateParameter(valid_579004, JBool, required = false,
                                 default = newJBool(true))
  if valid_579004 != nil:
    section.add "prettyPrint", valid_579004
  var valid_579005 = query.getOrDefault("oauth_token")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "oauth_token", valid_579005
  var valid_579006 = query.getOrDefault("$.xgafv")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = newJString("1"))
  if valid_579006 != nil:
    section.add "$.xgafv", valid_579006
  var valid_579007 = query.getOrDefault("bearer_token")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "bearer_token", valid_579007
  var valid_579008 = query.getOrDefault("uploadType")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "uploadType", valid_579008
  var valid_579009 = query.getOrDefault("alt")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = newJString("json"))
  if valid_579009 != nil:
    section.add "alt", valid_579009
  var valid_579010 = query.getOrDefault("quotaUser")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "quotaUser", valid_579010
  var valid_579011 = query.getOrDefault("callback")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "callback", valid_579011
  var valid_579012 = query.getOrDefault("fields")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "fields", valid_579012
  var valid_579013 = query.getOrDefault("access_token")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "access_token", valid_579013
  var valid_579014 = query.getOrDefault("upload_protocol")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "upload_protocol", valid_579014
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

proc call*(call_579016: Call_MlProjectsPredict_578998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs prediction on the data in the request.
  ## 
  ## **** REMOVE FROM GENERATED DOCUMENTATION
  ## 
  let valid = call_579016.validator(path, query, header, formData, body)
  let scheme = call_579016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579016.url(scheme.get, call_579016.host, call_579016.base,
                         call_579016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579016, url, valid)

proc call*(call_579017: Call_MlProjectsPredict_578998; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## mlProjectsPredict
  ## Performs prediction on the data in the request.
  ## 
  ## **** REMOVE FROM GENERATED DOCUMENTATION
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
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
  var path_579018 = newJObject()
  var query_579019 = newJObject()
  var body_579020 = newJObject()
  add(query_579019, "key", newJString(key))
  add(query_579019, "pp", newJBool(pp))
  add(query_579019, "prettyPrint", newJBool(prettyPrint))
  add(query_579019, "oauth_token", newJString(oauthToken))
  add(query_579019, "$.xgafv", newJString(Xgafv))
  add(query_579019, "bearer_token", newJString(bearerToken))
  add(query_579019, "uploadType", newJString(uploadType))
  add(query_579019, "alt", newJString(alt))
  add(query_579019, "quotaUser", newJString(quotaUser))
  add(path_579018, "name", newJString(name))
  if body != nil:
    body_579020 = body
  add(query_579019, "callback", newJString(callback))
  add(query_579019, "fields", newJString(fields))
  add(query_579019, "access_token", newJString(accessToken))
  add(query_579019, "upload_protocol", newJString(uploadProtocol))
  result = call_579017.call(path_579018, query_579019, nil, nil, body_579020)

var mlProjectsPredict* = Call_MlProjectsPredict_578998(name: "mlProjectsPredict",
    meth: HttpMethod.HttpPost, host: "ml.googleapis.com",
    route: "/v1beta1/{name}:predict", validator: validate_MlProjectsPredict_578999,
    base: "/", url: url_MlProjectsPredict_579000, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsSetDefault_579021 = ref object of OpenApiRestCall_578348
proc url_MlProjectsModelsVersionsSetDefault_579023(protocol: Scheme; host: string;
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

proc validate_MlProjectsModelsVersionsSetDefault_579022(path: JsonNode;
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
  var valid_579024 = path.getOrDefault("name")
  valid_579024 = validateParameter(valid_579024, JString, required = true,
                                 default = nil)
  if valid_579024 != nil:
    section.add "name", valid_579024
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_579025 = query.getOrDefault("key")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "key", valid_579025
  var valid_579026 = query.getOrDefault("pp")
  valid_579026 = validateParameter(valid_579026, JBool, required = false,
                                 default = newJBool(true))
  if valid_579026 != nil:
    section.add "pp", valid_579026
  var valid_579027 = query.getOrDefault("prettyPrint")
  valid_579027 = validateParameter(valid_579027, JBool, required = false,
                                 default = newJBool(true))
  if valid_579027 != nil:
    section.add "prettyPrint", valid_579027
  var valid_579028 = query.getOrDefault("oauth_token")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "oauth_token", valid_579028
  var valid_579029 = query.getOrDefault("$.xgafv")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = newJString("1"))
  if valid_579029 != nil:
    section.add "$.xgafv", valid_579029
  var valid_579030 = query.getOrDefault("bearer_token")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "bearer_token", valid_579030
  var valid_579031 = query.getOrDefault("uploadType")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "uploadType", valid_579031
  var valid_579032 = query.getOrDefault("alt")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = newJString("json"))
  if valid_579032 != nil:
    section.add "alt", valid_579032
  var valid_579033 = query.getOrDefault("quotaUser")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "quotaUser", valid_579033
  var valid_579034 = query.getOrDefault("callback")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "callback", valid_579034
  var valid_579035 = query.getOrDefault("fields")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "fields", valid_579035
  var valid_579036 = query.getOrDefault("access_token")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "access_token", valid_579036
  var valid_579037 = query.getOrDefault("upload_protocol")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "upload_protocol", valid_579037
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

proc call*(call_579039: Call_MlProjectsModelsVersionsSetDefault_579021;
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
  let valid = call_579039.validator(path, query, header, formData, body)
  let scheme = call_579039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579039.url(scheme.get, call_579039.host, call_579039.base,
                         call_579039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579039, url, valid)

proc call*(call_579040: Call_MlProjectsModelsVersionsSetDefault_579021;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the version to make the default for the model. You
  ## can get the names of all the versions of a model by calling
  ## 
  ## [projects.models.versions.list](/ml-engine/reference/rest/v1beta1/projects.models.versions/list).
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579041 = newJObject()
  var query_579042 = newJObject()
  var body_579043 = newJObject()
  add(query_579042, "key", newJString(key))
  add(query_579042, "pp", newJBool(pp))
  add(query_579042, "prettyPrint", newJBool(prettyPrint))
  add(query_579042, "oauth_token", newJString(oauthToken))
  add(query_579042, "$.xgafv", newJString(Xgafv))
  add(query_579042, "bearer_token", newJString(bearerToken))
  add(query_579042, "uploadType", newJString(uploadType))
  add(query_579042, "alt", newJString(alt))
  add(query_579042, "quotaUser", newJString(quotaUser))
  add(path_579041, "name", newJString(name))
  if body != nil:
    body_579043 = body
  add(query_579042, "callback", newJString(callback))
  add(query_579042, "fields", newJString(fields))
  add(query_579042, "access_token", newJString(accessToken))
  add(query_579042, "upload_protocol", newJString(uploadProtocol))
  result = call_579040.call(path_579041, query_579042, nil, nil, body_579043)

var mlProjectsModelsVersionsSetDefault* = Call_MlProjectsModelsVersionsSetDefault_579021(
    name: "mlProjectsModelsVersionsSetDefault", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{name}:setDefault",
    validator: validate_MlProjectsModelsVersionsSetDefault_579022, base: "/",
    url: url_MlProjectsModelsVersionsSetDefault_579023, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsCreate_579068 = ref object of OpenApiRestCall_578348
proc url_MlProjectsJobsCreate_579070(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsJobsCreate_579069(path: JsonNode; query: JsonNode;
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
  var valid_579071 = path.getOrDefault("parent")
  valid_579071 = validateParameter(valid_579071, JString, required = true,
                                 default = nil)
  if valid_579071 != nil:
    section.add "parent", valid_579071
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_579072 = query.getOrDefault("key")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "key", valid_579072
  var valid_579073 = query.getOrDefault("pp")
  valid_579073 = validateParameter(valid_579073, JBool, required = false,
                                 default = newJBool(true))
  if valid_579073 != nil:
    section.add "pp", valid_579073
  var valid_579074 = query.getOrDefault("prettyPrint")
  valid_579074 = validateParameter(valid_579074, JBool, required = false,
                                 default = newJBool(true))
  if valid_579074 != nil:
    section.add "prettyPrint", valid_579074
  var valid_579075 = query.getOrDefault("oauth_token")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "oauth_token", valid_579075
  var valid_579076 = query.getOrDefault("$.xgafv")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = newJString("1"))
  if valid_579076 != nil:
    section.add "$.xgafv", valid_579076
  var valid_579077 = query.getOrDefault("bearer_token")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "bearer_token", valid_579077
  var valid_579078 = query.getOrDefault("uploadType")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "uploadType", valid_579078
  var valid_579079 = query.getOrDefault("alt")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = newJString("json"))
  if valid_579079 != nil:
    section.add "alt", valid_579079
  var valid_579080 = query.getOrDefault("quotaUser")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "quotaUser", valid_579080
  var valid_579081 = query.getOrDefault("callback")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "callback", valid_579081
  var valid_579082 = query.getOrDefault("fields")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "fields", valid_579082
  var valid_579083 = query.getOrDefault("access_token")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "access_token", valid_579083
  var valid_579084 = query.getOrDefault("upload_protocol")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "upload_protocol", valid_579084
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

proc call*(call_579086: Call_MlProjectsJobsCreate_579068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a training or a batch prediction job.
  ## 
  let valid = call_579086.validator(path, query, header, formData, body)
  let scheme = call_579086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579086.url(scheme.get, call_579086.host, call_579086.base,
                         call_579086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579086, url, valid)

proc call*(call_579087: Call_MlProjectsJobsCreate_579068; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
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
  var path_579088 = newJObject()
  var query_579089 = newJObject()
  var body_579090 = newJObject()
  add(query_579089, "key", newJString(key))
  add(query_579089, "pp", newJBool(pp))
  add(query_579089, "prettyPrint", newJBool(prettyPrint))
  add(query_579089, "oauth_token", newJString(oauthToken))
  add(query_579089, "$.xgafv", newJString(Xgafv))
  add(query_579089, "bearer_token", newJString(bearerToken))
  add(query_579089, "uploadType", newJString(uploadType))
  add(query_579089, "alt", newJString(alt))
  add(query_579089, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579090 = body
  add(query_579089, "callback", newJString(callback))
  add(path_579088, "parent", newJString(parent))
  add(query_579089, "fields", newJString(fields))
  add(query_579089, "access_token", newJString(accessToken))
  add(query_579089, "upload_protocol", newJString(uploadProtocol))
  result = call_579087.call(path_579088, query_579089, nil, nil, body_579090)

var mlProjectsJobsCreate* = Call_MlProjectsJobsCreate_579068(
    name: "mlProjectsJobsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/jobs",
    validator: validate_MlProjectsJobsCreate_579069, base: "/",
    url: url_MlProjectsJobsCreate_579070, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsList_579044 = ref object of OpenApiRestCall_578348
proc url_MlProjectsJobsList_579046(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsJobsList_579045(path: JsonNode; query: JsonNode;
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
  var valid_579047 = path.getOrDefault("parent")
  valid_579047 = validateParameter(valid_579047, JString, required = true,
                                 default = nil)
  if valid_579047 != nil:
    section.add "parent", valid_579047
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_579048 = query.getOrDefault("key")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "key", valid_579048
  var valid_579049 = query.getOrDefault("pp")
  valid_579049 = validateParameter(valid_579049, JBool, required = false,
                                 default = newJBool(true))
  if valid_579049 != nil:
    section.add "pp", valid_579049
  var valid_579050 = query.getOrDefault("prettyPrint")
  valid_579050 = validateParameter(valid_579050, JBool, required = false,
                                 default = newJBool(true))
  if valid_579050 != nil:
    section.add "prettyPrint", valid_579050
  var valid_579051 = query.getOrDefault("oauth_token")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "oauth_token", valid_579051
  var valid_579052 = query.getOrDefault("$.xgafv")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = newJString("1"))
  if valid_579052 != nil:
    section.add "$.xgafv", valid_579052
  var valid_579053 = query.getOrDefault("bearer_token")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "bearer_token", valid_579053
  var valid_579054 = query.getOrDefault("pageSize")
  valid_579054 = validateParameter(valid_579054, JInt, required = false, default = nil)
  if valid_579054 != nil:
    section.add "pageSize", valid_579054
  var valid_579055 = query.getOrDefault("uploadType")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "uploadType", valid_579055
  var valid_579056 = query.getOrDefault("alt")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = newJString("json"))
  if valid_579056 != nil:
    section.add "alt", valid_579056
  var valid_579057 = query.getOrDefault("quotaUser")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "quotaUser", valid_579057
  var valid_579058 = query.getOrDefault("filter")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "filter", valid_579058
  var valid_579059 = query.getOrDefault("pageToken")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "pageToken", valid_579059
  var valid_579060 = query.getOrDefault("callback")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "callback", valid_579060
  var valid_579061 = query.getOrDefault("fields")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "fields", valid_579061
  var valid_579062 = query.getOrDefault("access_token")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "access_token", valid_579062
  var valid_579063 = query.getOrDefault("upload_protocol")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "upload_protocol", valid_579063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579064: Call_MlProjectsJobsList_579044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the jobs in the project.
  ## 
  let valid = call_579064.validator(path, query, header, formData, body)
  let scheme = call_579064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579064.url(scheme.get, call_579064.host, call_579064.base,
                         call_579064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579064, url, valid)

proc call*(call_579065: Call_MlProjectsJobsList_579044; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; uploadType: string = ""; alt: string = "json";
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
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
  var path_579066 = newJObject()
  var query_579067 = newJObject()
  add(query_579067, "key", newJString(key))
  add(query_579067, "pp", newJBool(pp))
  add(query_579067, "prettyPrint", newJBool(prettyPrint))
  add(query_579067, "oauth_token", newJString(oauthToken))
  add(query_579067, "$.xgafv", newJString(Xgafv))
  add(query_579067, "bearer_token", newJString(bearerToken))
  add(query_579067, "pageSize", newJInt(pageSize))
  add(query_579067, "uploadType", newJString(uploadType))
  add(query_579067, "alt", newJString(alt))
  add(query_579067, "quotaUser", newJString(quotaUser))
  add(query_579067, "filter", newJString(filter))
  add(query_579067, "pageToken", newJString(pageToken))
  add(query_579067, "callback", newJString(callback))
  add(path_579066, "parent", newJString(parent))
  add(query_579067, "fields", newJString(fields))
  add(query_579067, "access_token", newJString(accessToken))
  add(query_579067, "upload_protocol", newJString(uploadProtocol))
  result = call_579065.call(path_579066, query_579067, nil, nil, nil)

var mlProjectsJobsList* = Call_MlProjectsJobsList_579044(
    name: "mlProjectsJobsList", meth: HttpMethod.HttpGet, host: "ml.googleapis.com",
    route: "/v1beta1/{parent}/jobs", validator: validate_MlProjectsJobsList_579045,
    base: "/", url: url_MlProjectsJobsList_579046, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsCreate_579114 = ref object of OpenApiRestCall_578348
proc url_MlProjectsModelsCreate_579116(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsModelsCreate_579115(path: JsonNode; query: JsonNode;
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
  var valid_579117 = path.getOrDefault("parent")
  valid_579117 = validateParameter(valid_579117, JString, required = true,
                                 default = nil)
  if valid_579117 != nil:
    section.add "parent", valid_579117
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_579118 = query.getOrDefault("key")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "key", valid_579118
  var valid_579119 = query.getOrDefault("pp")
  valid_579119 = validateParameter(valid_579119, JBool, required = false,
                                 default = newJBool(true))
  if valid_579119 != nil:
    section.add "pp", valid_579119
  var valid_579120 = query.getOrDefault("prettyPrint")
  valid_579120 = validateParameter(valid_579120, JBool, required = false,
                                 default = newJBool(true))
  if valid_579120 != nil:
    section.add "prettyPrint", valid_579120
  var valid_579121 = query.getOrDefault("oauth_token")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "oauth_token", valid_579121
  var valid_579122 = query.getOrDefault("$.xgafv")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = newJString("1"))
  if valid_579122 != nil:
    section.add "$.xgafv", valid_579122
  var valid_579123 = query.getOrDefault("bearer_token")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "bearer_token", valid_579123
  var valid_579124 = query.getOrDefault("uploadType")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "uploadType", valid_579124
  var valid_579125 = query.getOrDefault("alt")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = newJString("json"))
  if valid_579125 != nil:
    section.add "alt", valid_579125
  var valid_579126 = query.getOrDefault("quotaUser")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "quotaUser", valid_579126
  var valid_579127 = query.getOrDefault("callback")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "callback", valid_579127
  var valid_579128 = query.getOrDefault("fields")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "fields", valid_579128
  var valid_579129 = query.getOrDefault("access_token")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "access_token", valid_579129
  var valid_579130 = query.getOrDefault("upload_protocol")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "upload_protocol", valid_579130
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

proc call*(call_579132: Call_MlProjectsModelsCreate_579114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a model which will later contain one or more versions.
  ## 
  ## You must add at least one version before you can request predictions from
  ## the model. Add versions by calling
  ## [projects.models.versions.create](/ml-engine/reference/rest/v1beta1/projects.models.versions/create).
  ## 
  let valid = call_579132.validator(path, query, header, formData, body)
  let scheme = call_579132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579132.url(scheme.get, call_579132.host, call_579132.base,
                         call_579132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579132, url, valid)

proc call*(call_579133: Call_MlProjectsModelsCreate_579114; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## mlProjectsModelsCreate
  ## Creates a model which will later contain one or more versions.
  ## 
  ## You must add at least one version before you can request predictions from
  ## the model. Add versions by calling
  ## [projects.models.versions.create](/ml-engine/reference/rest/v1beta1/projects.models.versions/create).
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
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
  var path_579134 = newJObject()
  var query_579135 = newJObject()
  var body_579136 = newJObject()
  add(query_579135, "key", newJString(key))
  add(query_579135, "pp", newJBool(pp))
  add(query_579135, "prettyPrint", newJBool(prettyPrint))
  add(query_579135, "oauth_token", newJString(oauthToken))
  add(query_579135, "$.xgafv", newJString(Xgafv))
  add(query_579135, "bearer_token", newJString(bearerToken))
  add(query_579135, "uploadType", newJString(uploadType))
  add(query_579135, "alt", newJString(alt))
  add(query_579135, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579136 = body
  add(query_579135, "callback", newJString(callback))
  add(path_579134, "parent", newJString(parent))
  add(query_579135, "fields", newJString(fields))
  add(query_579135, "access_token", newJString(accessToken))
  add(query_579135, "upload_protocol", newJString(uploadProtocol))
  result = call_579133.call(path_579134, query_579135, nil, nil, body_579136)

var mlProjectsModelsCreate* = Call_MlProjectsModelsCreate_579114(
    name: "mlProjectsModelsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/models",
    validator: validate_MlProjectsModelsCreate_579115, base: "/",
    url: url_MlProjectsModelsCreate_579116, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsList_579091 = ref object of OpenApiRestCall_578348
proc url_MlProjectsModelsList_579093(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsModelsList_579092(path: JsonNode; query: JsonNode;
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
  var valid_579094 = path.getOrDefault("parent")
  valid_579094 = validateParameter(valid_579094, JString, required = true,
                                 default = nil)
  if valid_579094 != nil:
    section.add "parent", valid_579094
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_579095 = query.getOrDefault("key")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "key", valid_579095
  var valid_579096 = query.getOrDefault("pp")
  valid_579096 = validateParameter(valid_579096, JBool, required = false,
                                 default = newJBool(true))
  if valid_579096 != nil:
    section.add "pp", valid_579096
  var valid_579097 = query.getOrDefault("prettyPrint")
  valid_579097 = validateParameter(valid_579097, JBool, required = false,
                                 default = newJBool(true))
  if valid_579097 != nil:
    section.add "prettyPrint", valid_579097
  var valid_579098 = query.getOrDefault("oauth_token")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "oauth_token", valid_579098
  var valid_579099 = query.getOrDefault("$.xgafv")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = newJString("1"))
  if valid_579099 != nil:
    section.add "$.xgafv", valid_579099
  var valid_579100 = query.getOrDefault("bearer_token")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "bearer_token", valid_579100
  var valid_579101 = query.getOrDefault("pageSize")
  valid_579101 = validateParameter(valid_579101, JInt, required = false, default = nil)
  if valid_579101 != nil:
    section.add "pageSize", valid_579101
  var valid_579102 = query.getOrDefault("uploadType")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "uploadType", valid_579102
  var valid_579103 = query.getOrDefault("alt")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = newJString("json"))
  if valid_579103 != nil:
    section.add "alt", valid_579103
  var valid_579104 = query.getOrDefault("quotaUser")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "quotaUser", valid_579104
  var valid_579105 = query.getOrDefault("pageToken")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "pageToken", valid_579105
  var valid_579106 = query.getOrDefault("callback")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "callback", valid_579106
  var valid_579107 = query.getOrDefault("fields")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "fields", valid_579107
  var valid_579108 = query.getOrDefault("access_token")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "access_token", valid_579108
  var valid_579109 = query.getOrDefault("upload_protocol")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "upload_protocol", valid_579109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579110: Call_MlProjectsModelsList_579091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the models in a project.
  ## 
  ## Each project can contain multiple models, and each model can have multiple
  ## versions.
  ## 
  let valid = call_579110.validator(path, query, header, formData, body)
  let scheme = call_579110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579110.url(scheme.get, call_579110.host, call_579110.base,
                         call_579110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579110, url, valid)

proc call*(call_579111: Call_MlProjectsModelsList_579091; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
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
  ##         : Required. The name of the project whose models are to be listed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579112 = newJObject()
  var query_579113 = newJObject()
  add(query_579113, "key", newJString(key))
  add(query_579113, "pp", newJBool(pp))
  add(query_579113, "prettyPrint", newJBool(prettyPrint))
  add(query_579113, "oauth_token", newJString(oauthToken))
  add(query_579113, "$.xgafv", newJString(Xgafv))
  add(query_579113, "bearer_token", newJString(bearerToken))
  add(query_579113, "pageSize", newJInt(pageSize))
  add(query_579113, "uploadType", newJString(uploadType))
  add(query_579113, "alt", newJString(alt))
  add(query_579113, "quotaUser", newJString(quotaUser))
  add(query_579113, "pageToken", newJString(pageToken))
  add(query_579113, "callback", newJString(callback))
  add(path_579112, "parent", newJString(parent))
  add(query_579113, "fields", newJString(fields))
  add(query_579113, "access_token", newJString(accessToken))
  add(query_579113, "upload_protocol", newJString(uploadProtocol))
  result = call_579111.call(path_579112, query_579113, nil, nil, nil)

var mlProjectsModelsList* = Call_MlProjectsModelsList_579091(
    name: "mlProjectsModelsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/models",
    validator: validate_MlProjectsModelsList_579092, base: "/",
    url: url_MlProjectsModelsList_579093, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsCreate_579160 = ref object of OpenApiRestCall_578348
proc url_MlProjectsModelsVersionsCreate_579162(protocol: Scheme; host: string;
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

proc validate_MlProjectsModelsVersionsCreate_579161(path: JsonNode;
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
  var valid_579163 = path.getOrDefault("parent")
  valid_579163 = validateParameter(valid_579163, JString, required = true,
                                 default = nil)
  if valid_579163 != nil:
    section.add "parent", valid_579163
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_579164 = query.getOrDefault("key")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "key", valid_579164
  var valid_579165 = query.getOrDefault("pp")
  valid_579165 = validateParameter(valid_579165, JBool, required = false,
                                 default = newJBool(true))
  if valid_579165 != nil:
    section.add "pp", valid_579165
  var valid_579166 = query.getOrDefault("prettyPrint")
  valid_579166 = validateParameter(valid_579166, JBool, required = false,
                                 default = newJBool(true))
  if valid_579166 != nil:
    section.add "prettyPrint", valid_579166
  var valid_579167 = query.getOrDefault("oauth_token")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "oauth_token", valid_579167
  var valid_579168 = query.getOrDefault("$.xgafv")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = newJString("1"))
  if valid_579168 != nil:
    section.add "$.xgafv", valid_579168
  var valid_579169 = query.getOrDefault("bearer_token")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "bearer_token", valid_579169
  var valid_579170 = query.getOrDefault("uploadType")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "uploadType", valid_579170
  var valid_579171 = query.getOrDefault("alt")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = newJString("json"))
  if valid_579171 != nil:
    section.add "alt", valid_579171
  var valid_579172 = query.getOrDefault("quotaUser")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "quotaUser", valid_579172
  var valid_579173 = query.getOrDefault("callback")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "callback", valid_579173
  var valid_579174 = query.getOrDefault("fields")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "fields", valid_579174
  var valid_579175 = query.getOrDefault("access_token")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "access_token", valid_579175
  var valid_579176 = query.getOrDefault("upload_protocol")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "upload_protocol", valid_579176
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

proc call*(call_579178: Call_MlProjectsModelsVersionsCreate_579160; path: JsonNode;
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
  let valid = call_579178.validator(path, query, header, formData, body)
  let scheme = call_579178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579178.url(scheme.get, call_579178.host, call_579178.base,
                         call_579178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579178, url, valid)

proc call*(call_579179: Call_MlProjectsModelsVersionsCreate_579160; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
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
  ## [projects.models.versions.setDefault](/ml-engine/reference/rest/v1beta1/projects.models.versions/setDefault).
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
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
  var path_579180 = newJObject()
  var query_579181 = newJObject()
  var body_579182 = newJObject()
  add(query_579181, "key", newJString(key))
  add(query_579181, "pp", newJBool(pp))
  add(query_579181, "prettyPrint", newJBool(prettyPrint))
  add(query_579181, "oauth_token", newJString(oauthToken))
  add(query_579181, "$.xgafv", newJString(Xgafv))
  add(query_579181, "bearer_token", newJString(bearerToken))
  add(query_579181, "uploadType", newJString(uploadType))
  add(query_579181, "alt", newJString(alt))
  add(query_579181, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579182 = body
  add(query_579181, "callback", newJString(callback))
  add(path_579180, "parent", newJString(parent))
  add(query_579181, "fields", newJString(fields))
  add(query_579181, "access_token", newJString(accessToken))
  add(query_579181, "upload_protocol", newJString(uploadProtocol))
  result = call_579179.call(path_579180, query_579181, nil, nil, body_579182)

var mlProjectsModelsVersionsCreate* = Call_MlProjectsModelsVersionsCreate_579160(
    name: "mlProjectsModelsVersionsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/versions",
    validator: validate_MlProjectsModelsVersionsCreate_579161, base: "/",
    url: url_MlProjectsModelsVersionsCreate_579162, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsList_579137 = ref object of OpenApiRestCall_578348
proc url_MlProjectsModelsVersionsList_579139(protocol: Scheme; host: string;
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

proc validate_MlProjectsModelsVersionsList_579138(path: JsonNode; query: JsonNode;
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
  var valid_579140 = path.getOrDefault("parent")
  valid_579140 = validateParameter(valid_579140, JString, required = true,
                                 default = nil)
  if valid_579140 != nil:
    section.add "parent", valid_579140
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
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
  var valid_579141 = query.getOrDefault("key")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "key", valid_579141
  var valid_579142 = query.getOrDefault("pp")
  valid_579142 = validateParameter(valid_579142, JBool, required = false,
                                 default = newJBool(true))
  if valid_579142 != nil:
    section.add "pp", valid_579142
  var valid_579143 = query.getOrDefault("prettyPrint")
  valid_579143 = validateParameter(valid_579143, JBool, required = false,
                                 default = newJBool(true))
  if valid_579143 != nil:
    section.add "prettyPrint", valid_579143
  var valid_579144 = query.getOrDefault("oauth_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "oauth_token", valid_579144
  var valid_579145 = query.getOrDefault("$.xgafv")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("1"))
  if valid_579145 != nil:
    section.add "$.xgafv", valid_579145
  var valid_579146 = query.getOrDefault("bearer_token")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "bearer_token", valid_579146
  var valid_579147 = query.getOrDefault("pageSize")
  valid_579147 = validateParameter(valid_579147, JInt, required = false, default = nil)
  if valid_579147 != nil:
    section.add "pageSize", valid_579147
  var valid_579148 = query.getOrDefault("uploadType")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "uploadType", valid_579148
  var valid_579149 = query.getOrDefault("alt")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = newJString("json"))
  if valid_579149 != nil:
    section.add "alt", valid_579149
  var valid_579150 = query.getOrDefault("quotaUser")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "quotaUser", valid_579150
  var valid_579151 = query.getOrDefault("pageToken")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "pageToken", valid_579151
  var valid_579152 = query.getOrDefault("callback")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "callback", valid_579152
  var valid_579153 = query.getOrDefault("fields")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "fields", valid_579153
  var valid_579154 = query.getOrDefault("access_token")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "access_token", valid_579154
  var valid_579155 = query.getOrDefault("upload_protocol")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "upload_protocol", valid_579155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579156: Call_MlProjectsModelsVersionsList_579137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets basic information about all the versions of a model.
  ## 
  ## If you expect that a model has a lot of versions, or if you need to handle
  ## only a limited number of results at a time, you can request that the list
  ## be retrieved in batches (called pages):
  ## 
  let valid = call_579156.validator(path, query, header, formData, body)
  let scheme = call_579156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579156.url(scheme.get, call_579156.host, call_579156.base,
                         call_579156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579156, url, valid)

proc call*(call_579157: Call_MlProjectsModelsVersionsList_579137; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
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
  ##         : Required. The name of the model for which to list the version.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579158 = newJObject()
  var query_579159 = newJObject()
  add(query_579159, "key", newJString(key))
  add(query_579159, "pp", newJBool(pp))
  add(query_579159, "prettyPrint", newJBool(prettyPrint))
  add(query_579159, "oauth_token", newJString(oauthToken))
  add(query_579159, "$.xgafv", newJString(Xgafv))
  add(query_579159, "bearer_token", newJString(bearerToken))
  add(query_579159, "pageSize", newJInt(pageSize))
  add(query_579159, "uploadType", newJString(uploadType))
  add(query_579159, "alt", newJString(alt))
  add(query_579159, "quotaUser", newJString(quotaUser))
  add(query_579159, "pageToken", newJString(pageToken))
  add(query_579159, "callback", newJString(callback))
  add(path_579158, "parent", newJString(parent))
  add(query_579159, "fields", newJString(fields))
  add(query_579159, "access_token", newJString(accessToken))
  add(query_579159, "upload_protocol", newJString(uploadProtocol))
  result = call_579157.call(path_579158, query_579159, nil, nil, nil)

var mlProjectsModelsVersionsList* = Call_MlProjectsModelsVersionsList_579137(
    name: "mlProjectsModelsVersionsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/versions",
    validator: validate_MlProjectsModelsVersionsList_579138, base: "/",
    url: url_MlProjectsModelsVersionsList_579139, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsGetIamPolicy_579183 = ref object of OpenApiRestCall_578348
proc url_MlProjectsJobsGetIamPolicy_579185(protocol: Scheme; host: string;
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

proc validate_MlProjectsJobsGetIamPolicy_579184(path: JsonNode; query: JsonNode;
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
  var valid_579186 = path.getOrDefault("resource")
  valid_579186 = validateParameter(valid_579186, JString, required = true,
                                 default = nil)
  if valid_579186 != nil:
    section.add "resource", valid_579186
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
  var valid_579187 = query.getOrDefault("key")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "key", valid_579187
  var valid_579188 = query.getOrDefault("pp")
  valid_579188 = validateParameter(valid_579188, JBool, required = false,
                                 default = newJBool(true))
  if valid_579188 != nil:
    section.add "pp", valid_579188
  var valid_579189 = query.getOrDefault("prettyPrint")
  valid_579189 = validateParameter(valid_579189, JBool, required = false,
                                 default = newJBool(true))
  if valid_579189 != nil:
    section.add "prettyPrint", valid_579189
  var valid_579190 = query.getOrDefault("oauth_token")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "oauth_token", valid_579190
  var valid_579191 = query.getOrDefault("$.xgafv")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = newJString("1"))
  if valid_579191 != nil:
    section.add "$.xgafv", valid_579191
  var valid_579192 = query.getOrDefault("bearer_token")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "bearer_token", valid_579192
  var valid_579193 = query.getOrDefault("alt")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = newJString("json"))
  if valid_579193 != nil:
    section.add "alt", valid_579193
  var valid_579194 = query.getOrDefault("uploadType")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "uploadType", valid_579194
  var valid_579195 = query.getOrDefault("quotaUser")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "quotaUser", valid_579195
  var valid_579196 = query.getOrDefault("callback")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "callback", valid_579196
  var valid_579197 = query.getOrDefault("fields")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "fields", valid_579197
  var valid_579198 = query.getOrDefault("access_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "access_token", valid_579198
  var valid_579199 = query.getOrDefault("upload_protocol")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "upload_protocol", valid_579199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579200: Call_MlProjectsJobsGetIamPolicy_579183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_579200.validator(path, query, header, formData, body)
  let scheme = call_579200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579200.url(scheme.get, call_579200.host, call_579200.base,
                         call_579200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579200, url, valid)

proc call*(call_579201: Call_MlProjectsJobsGetIamPolicy_579183; resource: string;
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
  var path_579202 = newJObject()
  var query_579203 = newJObject()
  add(query_579203, "key", newJString(key))
  add(query_579203, "pp", newJBool(pp))
  add(query_579203, "prettyPrint", newJBool(prettyPrint))
  add(query_579203, "oauth_token", newJString(oauthToken))
  add(query_579203, "$.xgafv", newJString(Xgafv))
  add(query_579203, "bearer_token", newJString(bearerToken))
  add(query_579203, "alt", newJString(alt))
  add(query_579203, "uploadType", newJString(uploadType))
  add(query_579203, "quotaUser", newJString(quotaUser))
  add(path_579202, "resource", newJString(resource))
  add(query_579203, "callback", newJString(callback))
  add(query_579203, "fields", newJString(fields))
  add(query_579203, "access_token", newJString(accessToken))
  add(query_579203, "upload_protocol", newJString(uploadProtocol))
  result = call_579201.call(path_579202, query_579203, nil, nil, nil)

var mlProjectsJobsGetIamPolicy* = Call_MlProjectsJobsGetIamPolicy_579183(
    name: "mlProjectsJobsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_MlProjectsJobsGetIamPolicy_579184, base: "/",
    url: url_MlProjectsJobsGetIamPolicy_579185, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsSetIamPolicy_579204 = ref object of OpenApiRestCall_578348
proc url_MlProjectsJobsSetIamPolicy_579206(protocol: Scheme; host: string;
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

proc validate_MlProjectsJobsSetIamPolicy_579205(path: JsonNode; query: JsonNode;
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
  var valid_579207 = path.getOrDefault("resource")
  valid_579207 = validateParameter(valid_579207, JString, required = true,
                                 default = nil)
  if valid_579207 != nil:
    section.add "resource", valid_579207
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
  var valid_579208 = query.getOrDefault("key")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "key", valid_579208
  var valid_579209 = query.getOrDefault("pp")
  valid_579209 = validateParameter(valid_579209, JBool, required = false,
                                 default = newJBool(true))
  if valid_579209 != nil:
    section.add "pp", valid_579209
  var valid_579210 = query.getOrDefault("prettyPrint")
  valid_579210 = validateParameter(valid_579210, JBool, required = false,
                                 default = newJBool(true))
  if valid_579210 != nil:
    section.add "prettyPrint", valid_579210
  var valid_579211 = query.getOrDefault("oauth_token")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "oauth_token", valid_579211
  var valid_579212 = query.getOrDefault("$.xgafv")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = newJString("1"))
  if valid_579212 != nil:
    section.add "$.xgafv", valid_579212
  var valid_579213 = query.getOrDefault("bearer_token")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "bearer_token", valid_579213
  var valid_579214 = query.getOrDefault("alt")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = newJString("json"))
  if valid_579214 != nil:
    section.add "alt", valid_579214
  var valid_579215 = query.getOrDefault("uploadType")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "uploadType", valid_579215
  var valid_579216 = query.getOrDefault("quotaUser")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "quotaUser", valid_579216
  var valid_579217 = query.getOrDefault("callback")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "callback", valid_579217
  var valid_579218 = query.getOrDefault("fields")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "fields", valid_579218
  var valid_579219 = query.getOrDefault("access_token")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "access_token", valid_579219
  var valid_579220 = query.getOrDefault("upload_protocol")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "upload_protocol", valid_579220
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

proc call*(call_579222: Call_MlProjectsJobsSetIamPolicy_579204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_579222.validator(path, query, header, formData, body)
  let scheme = call_579222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579222.url(scheme.get, call_579222.host, call_579222.base,
                         call_579222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579222, url, valid)

proc call*(call_579223: Call_MlProjectsJobsSetIamPolicy_579204; resource: string;
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
  var path_579224 = newJObject()
  var query_579225 = newJObject()
  var body_579226 = newJObject()
  add(query_579225, "key", newJString(key))
  add(query_579225, "pp", newJBool(pp))
  add(query_579225, "prettyPrint", newJBool(prettyPrint))
  add(query_579225, "oauth_token", newJString(oauthToken))
  add(query_579225, "$.xgafv", newJString(Xgafv))
  add(query_579225, "bearer_token", newJString(bearerToken))
  add(query_579225, "alt", newJString(alt))
  add(query_579225, "uploadType", newJString(uploadType))
  add(query_579225, "quotaUser", newJString(quotaUser))
  add(path_579224, "resource", newJString(resource))
  if body != nil:
    body_579226 = body
  add(query_579225, "callback", newJString(callback))
  add(query_579225, "fields", newJString(fields))
  add(query_579225, "access_token", newJString(accessToken))
  add(query_579225, "upload_protocol", newJString(uploadProtocol))
  result = call_579223.call(path_579224, query_579225, nil, nil, body_579226)

var mlProjectsJobsSetIamPolicy* = Call_MlProjectsJobsSetIamPolicy_579204(
    name: "mlProjectsJobsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_MlProjectsJobsSetIamPolicy_579205, base: "/",
    url: url_MlProjectsJobsSetIamPolicy_579206, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsTestIamPermissions_579227 = ref object of OpenApiRestCall_578348
proc url_MlProjectsJobsTestIamPermissions_579229(protocol: Scheme; host: string;
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

proc validate_MlProjectsJobsTestIamPermissions_579228(path: JsonNode;
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
  var valid_579230 = path.getOrDefault("resource")
  valid_579230 = validateParameter(valid_579230, JString, required = true,
                                 default = nil)
  if valid_579230 != nil:
    section.add "resource", valid_579230
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
  var valid_579231 = query.getOrDefault("key")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "key", valid_579231
  var valid_579232 = query.getOrDefault("pp")
  valid_579232 = validateParameter(valid_579232, JBool, required = false,
                                 default = newJBool(true))
  if valid_579232 != nil:
    section.add "pp", valid_579232
  var valid_579233 = query.getOrDefault("prettyPrint")
  valid_579233 = validateParameter(valid_579233, JBool, required = false,
                                 default = newJBool(true))
  if valid_579233 != nil:
    section.add "prettyPrint", valid_579233
  var valid_579234 = query.getOrDefault("oauth_token")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "oauth_token", valid_579234
  var valid_579235 = query.getOrDefault("$.xgafv")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = newJString("1"))
  if valid_579235 != nil:
    section.add "$.xgafv", valid_579235
  var valid_579236 = query.getOrDefault("bearer_token")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "bearer_token", valid_579236
  var valid_579237 = query.getOrDefault("alt")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = newJString("json"))
  if valid_579237 != nil:
    section.add "alt", valid_579237
  var valid_579238 = query.getOrDefault("uploadType")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "uploadType", valid_579238
  var valid_579239 = query.getOrDefault("quotaUser")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "quotaUser", valid_579239
  var valid_579240 = query.getOrDefault("callback")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "callback", valid_579240
  var valid_579241 = query.getOrDefault("fields")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "fields", valid_579241
  var valid_579242 = query.getOrDefault("access_token")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "access_token", valid_579242
  var valid_579243 = query.getOrDefault("upload_protocol")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "upload_protocol", valid_579243
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

proc call*(call_579245: Call_MlProjectsJobsTestIamPermissions_579227;
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
  let valid = call_579245.validator(path, query, header, formData, body)
  let scheme = call_579245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579245.url(scheme.get, call_579245.host, call_579245.base,
                         call_579245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579245, url, valid)

proc call*(call_579246: Call_MlProjectsJobsTestIamPermissions_579227;
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
  var path_579247 = newJObject()
  var query_579248 = newJObject()
  var body_579249 = newJObject()
  add(query_579248, "key", newJString(key))
  add(query_579248, "pp", newJBool(pp))
  add(query_579248, "prettyPrint", newJBool(prettyPrint))
  add(query_579248, "oauth_token", newJString(oauthToken))
  add(query_579248, "$.xgafv", newJString(Xgafv))
  add(query_579248, "bearer_token", newJString(bearerToken))
  add(query_579248, "alt", newJString(alt))
  add(query_579248, "uploadType", newJString(uploadType))
  add(query_579248, "quotaUser", newJString(quotaUser))
  add(path_579247, "resource", newJString(resource))
  if body != nil:
    body_579249 = body
  add(query_579248, "callback", newJString(callback))
  add(query_579248, "fields", newJString(fields))
  add(query_579248, "access_token", newJString(accessToken))
  add(query_579248, "upload_protocol", newJString(uploadProtocol))
  result = call_579246.call(path_579247, query_579248, nil, nil, body_579249)

var mlProjectsJobsTestIamPermissions* = Call_MlProjectsJobsTestIamPermissions_579227(
    name: "mlProjectsJobsTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_MlProjectsJobsTestIamPermissions_579228, base: "/",
    url: url_MlProjectsJobsTestIamPermissions_579229, schemes: {Scheme.Https})
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
