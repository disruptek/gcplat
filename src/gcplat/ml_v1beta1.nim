
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  Call_MlProjectsJobsGet_588719 = ref object of OpenApiRestCall_588450
proc url_MlProjectsJobsGet_588721(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsJobsGet_588720(path: JsonNode; query: JsonNode;
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
  var valid_588847 = path.getOrDefault("name")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "name", valid_588847
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
  var valid_588848 = query.getOrDefault("upload_protocol")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "upload_protocol", valid_588848
  var valid_588849 = query.getOrDefault("fields")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "fields", valid_588849
  var valid_588850 = query.getOrDefault("quotaUser")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "quotaUser", valid_588850
  var valid_588864 = query.getOrDefault("alt")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = newJString("json"))
  if valid_588864 != nil:
    section.add "alt", valid_588864
  var valid_588865 = query.getOrDefault("pp")
  valid_588865 = validateParameter(valid_588865, JBool, required = false,
                                 default = newJBool(true))
  if valid_588865 != nil:
    section.add "pp", valid_588865
  var valid_588866 = query.getOrDefault("oauth_token")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "oauth_token", valid_588866
  var valid_588867 = query.getOrDefault("uploadType")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "uploadType", valid_588867
  var valid_588868 = query.getOrDefault("callback")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "callback", valid_588868
  var valid_588869 = query.getOrDefault("access_token")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "access_token", valid_588869
  var valid_588870 = query.getOrDefault("key")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = nil)
  if valid_588870 != nil:
    section.add "key", valid_588870
  var valid_588871 = query.getOrDefault("$.xgafv")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = newJString("1"))
  if valid_588871 != nil:
    section.add "$.xgafv", valid_588871
  var valid_588872 = query.getOrDefault("prettyPrint")
  valid_588872 = validateParameter(valid_588872, JBool, required = false,
                                 default = newJBool(true))
  if valid_588872 != nil:
    section.add "prettyPrint", valid_588872
  var valid_588873 = query.getOrDefault("bearer_token")
  valid_588873 = validateParameter(valid_588873, JString, required = false,
                                 default = nil)
  if valid_588873 != nil:
    section.add "bearer_token", valid_588873
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588896: Call_MlProjectsJobsGet_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Describes a job.
  ## 
  let valid = call_588896.validator(path, query, header, formData, body)
  let scheme = call_588896.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588896.url(scheme.get, call_588896.host, call_588896.base,
                         call_588896.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588896, url, valid)

proc call*(call_588967: Call_MlProjectsJobsGet_588719; name: string;
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
  var path_588968 = newJObject()
  var query_588970 = newJObject()
  add(query_588970, "upload_protocol", newJString(uploadProtocol))
  add(query_588970, "fields", newJString(fields))
  add(query_588970, "quotaUser", newJString(quotaUser))
  add(path_588968, "name", newJString(name))
  add(query_588970, "alt", newJString(alt))
  add(query_588970, "pp", newJBool(pp))
  add(query_588970, "oauth_token", newJString(oauthToken))
  add(query_588970, "uploadType", newJString(uploadType))
  add(query_588970, "callback", newJString(callback))
  add(query_588970, "access_token", newJString(accessToken))
  add(query_588970, "key", newJString(key))
  add(query_588970, "$.xgafv", newJString(Xgafv))
  add(query_588970, "prettyPrint", newJBool(prettyPrint))
  add(query_588970, "bearer_token", newJString(bearerToken))
  result = call_588967.call(path_588968, query_588970, nil, nil, nil)

var mlProjectsJobsGet* = Call_MlProjectsJobsGet_588719(name: "mlProjectsJobsGet",
    meth: HttpMethod.HttpGet, host: "ml.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_MlProjectsJobsGet_588720, base: "/",
    url: url_MlProjectsJobsGet_588721, schemes: {Scheme.Https})
type
  Call_MlProjectsOperationsDelete_589009 = ref object of OpenApiRestCall_588450
proc url_MlProjectsOperationsDelete_589011(protocol: Scheme; host: string;
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

proc validate_MlProjectsOperationsDelete_589010(path: JsonNode; query: JsonNode;
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
  var valid_589012 = path.getOrDefault("name")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "name", valid_589012
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
  var valid_589013 = query.getOrDefault("upload_protocol")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "upload_protocol", valid_589013
  var valid_589014 = query.getOrDefault("fields")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "fields", valid_589014
  var valid_589015 = query.getOrDefault("quotaUser")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "quotaUser", valid_589015
  var valid_589016 = query.getOrDefault("alt")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("json"))
  if valid_589016 != nil:
    section.add "alt", valid_589016
  var valid_589017 = query.getOrDefault("pp")
  valid_589017 = validateParameter(valid_589017, JBool, required = false,
                                 default = newJBool(true))
  if valid_589017 != nil:
    section.add "pp", valid_589017
  var valid_589018 = query.getOrDefault("oauth_token")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "oauth_token", valid_589018
  var valid_589019 = query.getOrDefault("uploadType")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "uploadType", valid_589019
  var valid_589020 = query.getOrDefault("callback")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "callback", valid_589020
  var valid_589021 = query.getOrDefault("access_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "access_token", valid_589021
  var valid_589022 = query.getOrDefault("key")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "key", valid_589022
  var valid_589023 = query.getOrDefault("$.xgafv")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = newJString("1"))
  if valid_589023 != nil:
    section.add "$.xgafv", valid_589023
  var valid_589024 = query.getOrDefault("prettyPrint")
  valid_589024 = validateParameter(valid_589024, JBool, required = false,
                                 default = newJBool(true))
  if valid_589024 != nil:
    section.add "prettyPrint", valid_589024
  var valid_589025 = query.getOrDefault("bearer_token")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "bearer_token", valid_589025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589026: Call_MlProjectsOperationsDelete_589009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_589026.validator(path, query, header, formData, body)
  let scheme = call_589026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589026.url(scheme.get, call_589026.host, call_589026.base,
                         call_589026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589026, url, valid)

proc call*(call_589027: Call_MlProjectsOperationsDelete_589009; name: string;
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
  var path_589028 = newJObject()
  var query_589029 = newJObject()
  add(query_589029, "upload_protocol", newJString(uploadProtocol))
  add(query_589029, "fields", newJString(fields))
  add(query_589029, "quotaUser", newJString(quotaUser))
  add(path_589028, "name", newJString(name))
  add(query_589029, "alt", newJString(alt))
  add(query_589029, "pp", newJBool(pp))
  add(query_589029, "oauth_token", newJString(oauthToken))
  add(query_589029, "uploadType", newJString(uploadType))
  add(query_589029, "callback", newJString(callback))
  add(query_589029, "access_token", newJString(accessToken))
  add(query_589029, "key", newJString(key))
  add(query_589029, "$.xgafv", newJString(Xgafv))
  add(query_589029, "prettyPrint", newJBool(prettyPrint))
  add(query_589029, "bearer_token", newJString(bearerToken))
  result = call_589027.call(path_589028, query_589029, nil, nil, nil)

var mlProjectsOperationsDelete* = Call_MlProjectsOperationsDelete_589009(
    name: "mlProjectsOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "ml.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_MlProjectsOperationsDelete_589010, base: "/",
    url: url_MlProjectsOperationsDelete_589011, schemes: {Scheme.Https})
type
  Call_MlProjectsOperationsList_589030 = ref object of OpenApiRestCall_588450
proc url_MlProjectsOperationsList_589032(protocol: Scheme; host: string;
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

proc validate_MlProjectsOperationsList_589031(path: JsonNode; query: JsonNode;
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
  var valid_589033 = path.getOrDefault("name")
  valid_589033 = validateParameter(valid_589033, JString, required = true,
                                 default = nil)
  if valid_589033 != nil:
    section.add "name", valid_589033
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
  var valid_589034 = query.getOrDefault("upload_protocol")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "upload_protocol", valid_589034
  var valid_589035 = query.getOrDefault("fields")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "fields", valid_589035
  var valid_589036 = query.getOrDefault("pageToken")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "pageToken", valid_589036
  var valid_589037 = query.getOrDefault("quotaUser")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "quotaUser", valid_589037
  var valid_589038 = query.getOrDefault("alt")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = newJString("json"))
  if valid_589038 != nil:
    section.add "alt", valid_589038
  var valid_589039 = query.getOrDefault("pp")
  valid_589039 = validateParameter(valid_589039, JBool, required = false,
                                 default = newJBool(true))
  if valid_589039 != nil:
    section.add "pp", valid_589039
  var valid_589040 = query.getOrDefault("oauth_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "oauth_token", valid_589040
  var valid_589041 = query.getOrDefault("uploadType")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "uploadType", valid_589041
  var valid_589042 = query.getOrDefault("callback")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "callback", valid_589042
  var valid_589043 = query.getOrDefault("access_token")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "access_token", valid_589043
  var valid_589044 = query.getOrDefault("key")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "key", valid_589044
  var valid_589045 = query.getOrDefault("$.xgafv")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = newJString("1"))
  if valid_589045 != nil:
    section.add "$.xgafv", valid_589045
  var valid_589046 = query.getOrDefault("pageSize")
  valid_589046 = validateParameter(valid_589046, JInt, required = false, default = nil)
  if valid_589046 != nil:
    section.add "pageSize", valid_589046
  var valid_589047 = query.getOrDefault("prettyPrint")
  valid_589047 = validateParameter(valid_589047, JBool, required = false,
                                 default = newJBool(true))
  if valid_589047 != nil:
    section.add "prettyPrint", valid_589047
  var valid_589048 = query.getOrDefault("filter")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "filter", valid_589048
  var valid_589049 = query.getOrDefault("bearer_token")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "bearer_token", valid_589049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589050: Call_MlProjectsOperationsList_589030; path: JsonNode;
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
  let valid = call_589050.validator(path, query, header, formData, body)
  let scheme = call_589050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589050.url(scheme.get, call_589050.host, call_589050.base,
                         call_589050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589050, url, valid)

proc call*(call_589051: Call_MlProjectsOperationsList_589030; name: string;
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
  var path_589052 = newJObject()
  var query_589053 = newJObject()
  add(query_589053, "upload_protocol", newJString(uploadProtocol))
  add(query_589053, "fields", newJString(fields))
  add(query_589053, "pageToken", newJString(pageToken))
  add(query_589053, "quotaUser", newJString(quotaUser))
  add(path_589052, "name", newJString(name))
  add(query_589053, "alt", newJString(alt))
  add(query_589053, "pp", newJBool(pp))
  add(query_589053, "oauth_token", newJString(oauthToken))
  add(query_589053, "uploadType", newJString(uploadType))
  add(query_589053, "callback", newJString(callback))
  add(query_589053, "access_token", newJString(accessToken))
  add(query_589053, "key", newJString(key))
  add(query_589053, "$.xgafv", newJString(Xgafv))
  add(query_589053, "pageSize", newJInt(pageSize))
  add(query_589053, "prettyPrint", newJBool(prettyPrint))
  add(query_589053, "filter", newJString(filter))
  add(query_589053, "bearer_token", newJString(bearerToken))
  result = call_589051.call(path_589052, query_589053, nil, nil, nil)

var mlProjectsOperationsList* = Call_MlProjectsOperationsList_589030(
    name: "mlProjectsOperationsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{name}/operations",
    validator: validate_MlProjectsOperationsList_589031, base: "/",
    url: url_MlProjectsOperationsList_589032, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsCancel_589054 = ref object of OpenApiRestCall_588450
proc url_MlProjectsJobsCancel_589056(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsJobsCancel_589055(path: JsonNode; query: JsonNode;
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
  var valid_589057 = path.getOrDefault("name")
  valid_589057 = validateParameter(valid_589057, JString, required = true,
                                 default = nil)
  if valid_589057 != nil:
    section.add "name", valid_589057
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
  var valid_589058 = query.getOrDefault("upload_protocol")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "upload_protocol", valid_589058
  var valid_589059 = query.getOrDefault("fields")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "fields", valid_589059
  var valid_589060 = query.getOrDefault("quotaUser")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "quotaUser", valid_589060
  var valid_589061 = query.getOrDefault("alt")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = newJString("json"))
  if valid_589061 != nil:
    section.add "alt", valid_589061
  var valid_589062 = query.getOrDefault("pp")
  valid_589062 = validateParameter(valid_589062, JBool, required = false,
                                 default = newJBool(true))
  if valid_589062 != nil:
    section.add "pp", valid_589062
  var valid_589063 = query.getOrDefault("oauth_token")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "oauth_token", valid_589063
  var valid_589064 = query.getOrDefault("uploadType")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "uploadType", valid_589064
  var valid_589065 = query.getOrDefault("callback")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "callback", valid_589065
  var valid_589066 = query.getOrDefault("access_token")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "access_token", valid_589066
  var valid_589067 = query.getOrDefault("key")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "key", valid_589067
  var valid_589068 = query.getOrDefault("$.xgafv")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("1"))
  if valid_589068 != nil:
    section.add "$.xgafv", valid_589068
  var valid_589069 = query.getOrDefault("prettyPrint")
  valid_589069 = validateParameter(valid_589069, JBool, required = false,
                                 default = newJBool(true))
  if valid_589069 != nil:
    section.add "prettyPrint", valid_589069
  var valid_589070 = query.getOrDefault("bearer_token")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "bearer_token", valid_589070
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

proc call*(call_589072: Call_MlProjectsJobsCancel_589054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a running job.
  ## 
  let valid = call_589072.validator(path, query, header, formData, body)
  let scheme = call_589072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589072.url(scheme.get, call_589072.host, call_589072.base,
                         call_589072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589072, url, valid)

proc call*(call_589073: Call_MlProjectsJobsCancel_589054; name: string;
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
  var path_589074 = newJObject()
  var query_589075 = newJObject()
  var body_589076 = newJObject()
  add(query_589075, "upload_protocol", newJString(uploadProtocol))
  add(query_589075, "fields", newJString(fields))
  add(query_589075, "quotaUser", newJString(quotaUser))
  add(path_589074, "name", newJString(name))
  add(query_589075, "alt", newJString(alt))
  add(query_589075, "pp", newJBool(pp))
  add(query_589075, "oauth_token", newJString(oauthToken))
  add(query_589075, "uploadType", newJString(uploadType))
  add(query_589075, "callback", newJString(callback))
  add(query_589075, "access_token", newJString(accessToken))
  add(query_589075, "key", newJString(key))
  add(query_589075, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589076 = body
  add(query_589075, "prettyPrint", newJBool(prettyPrint))
  add(query_589075, "bearer_token", newJString(bearerToken))
  result = call_589073.call(path_589074, query_589075, nil, nil, body_589076)

var mlProjectsJobsCancel* = Call_MlProjectsJobsCancel_589054(
    name: "mlProjectsJobsCancel", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{name}:cancel",
    validator: validate_MlProjectsJobsCancel_589055, base: "/",
    url: url_MlProjectsJobsCancel_589056, schemes: {Scheme.Https})
type
  Call_MlProjectsGetConfig_589077 = ref object of OpenApiRestCall_588450
proc url_MlProjectsGetConfig_589079(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsGetConfig_589078(path: JsonNode; query: JsonNode;
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
  var valid_589080 = path.getOrDefault("name")
  valid_589080 = validateParameter(valid_589080, JString, required = true,
                                 default = nil)
  if valid_589080 != nil:
    section.add "name", valid_589080
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
  var valid_589081 = query.getOrDefault("upload_protocol")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "upload_protocol", valid_589081
  var valid_589082 = query.getOrDefault("fields")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "fields", valid_589082
  var valid_589083 = query.getOrDefault("quotaUser")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "quotaUser", valid_589083
  var valid_589084 = query.getOrDefault("alt")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = newJString("json"))
  if valid_589084 != nil:
    section.add "alt", valid_589084
  var valid_589085 = query.getOrDefault("pp")
  valid_589085 = validateParameter(valid_589085, JBool, required = false,
                                 default = newJBool(true))
  if valid_589085 != nil:
    section.add "pp", valid_589085
  var valid_589086 = query.getOrDefault("oauth_token")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "oauth_token", valid_589086
  var valid_589087 = query.getOrDefault("uploadType")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "uploadType", valid_589087
  var valid_589088 = query.getOrDefault("callback")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "callback", valid_589088
  var valid_589089 = query.getOrDefault("access_token")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "access_token", valid_589089
  var valid_589090 = query.getOrDefault("key")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "key", valid_589090
  var valid_589091 = query.getOrDefault("$.xgafv")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = newJString("1"))
  if valid_589091 != nil:
    section.add "$.xgafv", valid_589091
  var valid_589092 = query.getOrDefault("prettyPrint")
  valid_589092 = validateParameter(valid_589092, JBool, required = false,
                                 default = newJBool(true))
  if valid_589092 != nil:
    section.add "prettyPrint", valid_589092
  var valid_589093 = query.getOrDefault("bearer_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "bearer_token", valid_589093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589094: Call_MlProjectsGetConfig_589077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the service account information associated with your project. You need
  ## this information in order to grant the service account persmissions for
  ## the Google Cloud Storage location where you put your model training code
  ## for training the model with Google Cloud Machine Learning.
  ## 
  let valid = call_589094.validator(path, query, header, formData, body)
  let scheme = call_589094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589094.url(scheme.get, call_589094.host, call_589094.base,
                         call_589094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589094, url, valid)

proc call*(call_589095: Call_MlProjectsGetConfig_589077; name: string;
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
  var path_589096 = newJObject()
  var query_589097 = newJObject()
  add(query_589097, "upload_protocol", newJString(uploadProtocol))
  add(query_589097, "fields", newJString(fields))
  add(query_589097, "quotaUser", newJString(quotaUser))
  add(path_589096, "name", newJString(name))
  add(query_589097, "alt", newJString(alt))
  add(query_589097, "pp", newJBool(pp))
  add(query_589097, "oauth_token", newJString(oauthToken))
  add(query_589097, "uploadType", newJString(uploadType))
  add(query_589097, "callback", newJString(callback))
  add(query_589097, "access_token", newJString(accessToken))
  add(query_589097, "key", newJString(key))
  add(query_589097, "$.xgafv", newJString(Xgafv))
  add(query_589097, "prettyPrint", newJBool(prettyPrint))
  add(query_589097, "bearer_token", newJString(bearerToken))
  result = call_589095.call(path_589096, query_589097, nil, nil, nil)

var mlProjectsGetConfig* = Call_MlProjectsGetConfig_589077(
    name: "mlProjectsGetConfig", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{name}:getConfig",
    validator: validate_MlProjectsGetConfig_589078, base: "/",
    url: url_MlProjectsGetConfig_589079, schemes: {Scheme.Https})
type
  Call_MlProjectsPredict_589098 = ref object of OpenApiRestCall_588450
proc url_MlProjectsPredict_589100(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsPredict_589099(path: JsonNode; query: JsonNode;
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
  var valid_589101 = path.getOrDefault("name")
  valid_589101 = validateParameter(valid_589101, JString, required = true,
                                 default = nil)
  if valid_589101 != nil:
    section.add "name", valid_589101
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
  var valid_589102 = query.getOrDefault("upload_protocol")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "upload_protocol", valid_589102
  var valid_589103 = query.getOrDefault("fields")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "fields", valid_589103
  var valid_589104 = query.getOrDefault("quotaUser")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "quotaUser", valid_589104
  var valid_589105 = query.getOrDefault("alt")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = newJString("json"))
  if valid_589105 != nil:
    section.add "alt", valid_589105
  var valid_589106 = query.getOrDefault("pp")
  valid_589106 = validateParameter(valid_589106, JBool, required = false,
                                 default = newJBool(true))
  if valid_589106 != nil:
    section.add "pp", valid_589106
  var valid_589107 = query.getOrDefault("oauth_token")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "oauth_token", valid_589107
  var valid_589108 = query.getOrDefault("uploadType")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "uploadType", valid_589108
  var valid_589109 = query.getOrDefault("callback")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "callback", valid_589109
  var valid_589110 = query.getOrDefault("access_token")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "access_token", valid_589110
  var valid_589111 = query.getOrDefault("key")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "key", valid_589111
  var valid_589112 = query.getOrDefault("$.xgafv")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = newJString("1"))
  if valid_589112 != nil:
    section.add "$.xgafv", valid_589112
  var valid_589113 = query.getOrDefault("prettyPrint")
  valid_589113 = validateParameter(valid_589113, JBool, required = false,
                                 default = newJBool(true))
  if valid_589113 != nil:
    section.add "prettyPrint", valid_589113
  var valid_589114 = query.getOrDefault("bearer_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "bearer_token", valid_589114
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

proc call*(call_589116: Call_MlProjectsPredict_589098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs prediction on the data in the request.
  ## 
  ## **** REMOVE FROM GENERATED DOCUMENTATION
  ## 
  let valid = call_589116.validator(path, query, header, formData, body)
  let scheme = call_589116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589116.url(scheme.get, call_589116.host, call_589116.base,
                         call_589116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589116, url, valid)

proc call*(call_589117: Call_MlProjectsPredict_589098; name: string;
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
  var path_589118 = newJObject()
  var query_589119 = newJObject()
  var body_589120 = newJObject()
  add(query_589119, "upload_protocol", newJString(uploadProtocol))
  add(query_589119, "fields", newJString(fields))
  add(query_589119, "quotaUser", newJString(quotaUser))
  add(path_589118, "name", newJString(name))
  add(query_589119, "alt", newJString(alt))
  add(query_589119, "pp", newJBool(pp))
  add(query_589119, "oauth_token", newJString(oauthToken))
  add(query_589119, "uploadType", newJString(uploadType))
  add(query_589119, "callback", newJString(callback))
  add(query_589119, "access_token", newJString(accessToken))
  add(query_589119, "key", newJString(key))
  add(query_589119, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589120 = body
  add(query_589119, "prettyPrint", newJBool(prettyPrint))
  add(query_589119, "bearer_token", newJString(bearerToken))
  result = call_589117.call(path_589118, query_589119, nil, nil, body_589120)

var mlProjectsPredict* = Call_MlProjectsPredict_589098(name: "mlProjectsPredict",
    meth: HttpMethod.HttpPost, host: "ml.googleapis.com",
    route: "/v1beta1/{name}:predict", validator: validate_MlProjectsPredict_589099,
    base: "/", url: url_MlProjectsPredict_589100, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsSetDefault_589121 = ref object of OpenApiRestCall_588450
proc url_MlProjectsModelsVersionsSetDefault_589123(protocol: Scheme; host: string;
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

proc validate_MlProjectsModelsVersionsSetDefault_589122(path: JsonNode;
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
  var valid_589124 = path.getOrDefault("name")
  valid_589124 = validateParameter(valid_589124, JString, required = true,
                                 default = nil)
  if valid_589124 != nil:
    section.add "name", valid_589124
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
  var valid_589125 = query.getOrDefault("upload_protocol")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "upload_protocol", valid_589125
  var valid_589126 = query.getOrDefault("fields")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "fields", valid_589126
  var valid_589127 = query.getOrDefault("quotaUser")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "quotaUser", valid_589127
  var valid_589128 = query.getOrDefault("alt")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = newJString("json"))
  if valid_589128 != nil:
    section.add "alt", valid_589128
  var valid_589129 = query.getOrDefault("pp")
  valid_589129 = validateParameter(valid_589129, JBool, required = false,
                                 default = newJBool(true))
  if valid_589129 != nil:
    section.add "pp", valid_589129
  var valid_589130 = query.getOrDefault("oauth_token")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "oauth_token", valid_589130
  var valid_589131 = query.getOrDefault("uploadType")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "uploadType", valid_589131
  var valid_589132 = query.getOrDefault("callback")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "callback", valid_589132
  var valid_589133 = query.getOrDefault("access_token")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "access_token", valid_589133
  var valid_589134 = query.getOrDefault("key")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "key", valid_589134
  var valid_589135 = query.getOrDefault("$.xgafv")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = newJString("1"))
  if valid_589135 != nil:
    section.add "$.xgafv", valid_589135
  var valid_589136 = query.getOrDefault("prettyPrint")
  valid_589136 = validateParameter(valid_589136, JBool, required = false,
                                 default = newJBool(true))
  if valid_589136 != nil:
    section.add "prettyPrint", valid_589136
  var valid_589137 = query.getOrDefault("bearer_token")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "bearer_token", valid_589137
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

proc call*(call_589139: Call_MlProjectsModelsVersionsSetDefault_589121;
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
  let valid = call_589139.validator(path, query, header, formData, body)
  let scheme = call_589139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589139.url(scheme.get, call_589139.host, call_589139.base,
                         call_589139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589139, url, valid)

proc call*(call_589140: Call_MlProjectsModelsVersionsSetDefault_589121;
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
  var path_589141 = newJObject()
  var query_589142 = newJObject()
  var body_589143 = newJObject()
  add(query_589142, "upload_protocol", newJString(uploadProtocol))
  add(query_589142, "fields", newJString(fields))
  add(query_589142, "quotaUser", newJString(quotaUser))
  add(path_589141, "name", newJString(name))
  add(query_589142, "alt", newJString(alt))
  add(query_589142, "pp", newJBool(pp))
  add(query_589142, "oauth_token", newJString(oauthToken))
  add(query_589142, "uploadType", newJString(uploadType))
  add(query_589142, "callback", newJString(callback))
  add(query_589142, "access_token", newJString(accessToken))
  add(query_589142, "key", newJString(key))
  add(query_589142, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589143 = body
  add(query_589142, "prettyPrint", newJBool(prettyPrint))
  add(query_589142, "bearer_token", newJString(bearerToken))
  result = call_589140.call(path_589141, query_589142, nil, nil, body_589143)

var mlProjectsModelsVersionsSetDefault* = Call_MlProjectsModelsVersionsSetDefault_589121(
    name: "mlProjectsModelsVersionsSetDefault", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{name}:setDefault",
    validator: validate_MlProjectsModelsVersionsSetDefault_589122, base: "/",
    url: url_MlProjectsModelsVersionsSetDefault_589123, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsCreate_589168 = ref object of OpenApiRestCall_588450
proc url_MlProjectsJobsCreate_589170(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsJobsCreate_589169(path: JsonNode; query: JsonNode;
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
  var valid_589171 = path.getOrDefault("parent")
  valid_589171 = validateParameter(valid_589171, JString, required = true,
                                 default = nil)
  if valid_589171 != nil:
    section.add "parent", valid_589171
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
  var valid_589172 = query.getOrDefault("upload_protocol")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "upload_protocol", valid_589172
  var valid_589173 = query.getOrDefault("fields")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "fields", valid_589173
  var valid_589174 = query.getOrDefault("quotaUser")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "quotaUser", valid_589174
  var valid_589175 = query.getOrDefault("alt")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = newJString("json"))
  if valid_589175 != nil:
    section.add "alt", valid_589175
  var valid_589176 = query.getOrDefault("pp")
  valid_589176 = validateParameter(valid_589176, JBool, required = false,
                                 default = newJBool(true))
  if valid_589176 != nil:
    section.add "pp", valid_589176
  var valid_589177 = query.getOrDefault("oauth_token")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "oauth_token", valid_589177
  var valid_589178 = query.getOrDefault("uploadType")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "uploadType", valid_589178
  var valid_589179 = query.getOrDefault("callback")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "callback", valid_589179
  var valid_589180 = query.getOrDefault("access_token")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "access_token", valid_589180
  var valid_589181 = query.getOrDefault("key")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "key", valid_589181
  var valid_589182 = query.getOrDefault("$.xgafv")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = newJString("1"))
  if valid_589182 != nil:
    section.add "$.xgafv", valid_589182
  var valid_589183 = query.getOrDefault("prettyPrint")
  valid_589183 = validateParameter(valid_589183, JBool, required = false,
                                 default = newJBool(true))
  if valid_589183 != nil:
    section.add "prettyPrint", valid_589183
  var valid_589184 = query.getOrDefault("bearer_token")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "bearer_token", valid_589184
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

proc call*(call_589186: Call_MlProjectsJobsCreate_589168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a training or a batch prediction job.
  ## 
  let valid = call_589186.validator(path, query, header, formData, body)
  let scheme = call_589186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589186.url(scheme.get, call_589186.host, call_589186.base,
                         call_589186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589186, url, valid)

proc call*(call_589187: Call_MlProjectsJobsCreate_589168; parent: string;
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
  var path_589188 = newJObject()
  var query_589189 = newJObject()
  var body_589190 = newJObject()
  add(query_589189, "upload_protocol", newJString(uploadProtocol))
  add(query_589189, "fields", newJString(fields))
  add(query_589189, "quotaUser", newJString(quotaUser))
  add(query_589189, "alt", newJString(alt))
  add(query_589189, "pp", newJBool(pp))
  add(query_589189, "oauth_token", newJString(oauthToken))
  add(query_589189, "uploadType", newJString(uploadType))
  add(query_589189, "callback", newJString(callback))
  add(query_589189, "access_token", newJString(accessToken))
  add(path_589188, "parent", newJString(parent))
  add(query_589189, "key", newJString(key))
  add(query_589189, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589190 = body
  add(query_589189, "prettyPrint", newJBool(prettyPrint))
  add(query_589189, "bearer_token", newJString(bearerToken))
  result = call_589187.call(path_589188, query_589189, nil, nil, body_589190)

var mlProjectsJobsCreate* = Call_MlProjectsJobsCreate_589168(
    name: "mlProjectsJobsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/jobs",
    validator: validate_MlProjectsJobsCreate_589169, base: "/",
    url: url_MlProjectsJobsCreate_589170, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsList_589144 = ref object of OpenApiRestCall_588450
proc url_MlProjectsJobsList_589146(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsJobsList_589145(path: JsonNode; query: JsonNode;
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
  var valid_589147 = path.getOrDefault("parent")
  valid_589147 = validateParameter(valid_589147, JString, required = true,
                                 default = nil)
  if valid_589147 != nil:
    section.add "parent", valid_589147
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
  var valid_589148 = query.getOrDefault("upload_protocol")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "upload_protocol", valid_589148
  var valid_589149 = query.getOrDefault("fields")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "fields", valid_589149
  var valid_589150 = query.getOrDefault("pageToken")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "pageToken", valid_589150
  var valid_589151 = query.getOrDefault("quotaUser")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "quotaUser", valid_589151
  var valid_589152 = query.getOrDefault("alt")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = newJString("json"))
  if valid_589152 != nil:
    section.add "alt", valid_589152
  var valid_589153 = query.getOrDefault("pp")
  valid_589153 = validateParameter(valid_589153, JBool, required = false,
                                 default = newJBool(true))
  if valid_589153 != nil:
    section.add "pp", valid_589153
  var valid_589154 = query.getOrDefault("oauth_token")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "oauth_token", valid_589154
  var valid_589155 = query.getOrDefault("uploadType")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "uploadType", valid_589155
  var valid_589156 = query.getOrDefault("callback")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "callback", valid_589156
  var valid_589157 = query.getOrDefault("access_token")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "access_token", valid_589157
  var valid_589158 = query.getOrDefault("key")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "key", valid_589158
  var valid_589159 = query.getOrDefault("$.xgafv")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = newJString("1"))
  if valid_589159 != nil:
    section.add "$.xgafv", valid_589159
  var valid_589160 = query.getOrDefault("pageSize")
  valid_589160 = validateParameter(valid_589160, JInt, required = false, default = nil)
  if valid_589160 != nil:
    section.add "pageSize", valid_589160
  var valid_589161 = query.getOrDefault("prettyPrint")
  valid_589161 = validateParameter(valid_589161, JBool, required = false,
                                 default = newJBool(true))
  if valid_589161 != nil:
    section.add "prettyPrint", valid_589161
  var valid_589162 = query.getOrDefault("filter")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "filter", valid_589162
  var valid_589163 = query.getOrDefault("bearer_token")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "bearer_token", valid_589163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589164: Call_MlProjectsJobsList_589144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the jobs in the project.
  ## 
  let valid = call_589164.validator(path, query, header, formData, body)
  let scheme = call_589164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589164.url(scheme.get, call_589164.host, call_589164.base,
                         call_589164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589164, url, valid)

proc call*(call_589165: Call_MlProjectsJobsList_589144; parent: string;
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
  var path_589166 = newJObject()
  var query_589167 = newJObject()
  add(query_589167, "upload_protocol", newJString(uploadProtocol))
  add(query_589167, "fields", newJString(fields))
  add(query_589167, "pageToken", newJString(pageToken))
  add(query_589167, "quotaUser", newJString(quotaUser))
  add(query_589167, "alt", newJString(alt))
  add(query_589167, "pp", newJBool(pp))
  add(query_589167, "oauth_token", newJString(oauthToken))
  add(query_589167, "uploadType", newJString(uploadType))
  add(query_589167, "callback", newJString(callback))
  add(query_589167, "access_token", newJString(accessToken))
  add(path_589166, "parent", newJString(parent))
  add(query_589167, "key", newJString(key))
  add(query_589167, "$.xgafv", newJString(Xgafv))
  add(query_589167, "pageSize", newJInt(pageSize))
  add(query_589167, "prettyPrint", newJBool(prettyPrint))
  add(query_589167, "filter", newJString(filter))
  add(query_589167, "bearer_token", newJString(bearerToken))
  result = call_589165.call(path_589166, query_589167, nil, nil, nil)

var mlProjectsJobsList* = Call_MlProjectsJobsList_589144(
    name: "mlProjectsJobsList", meth: HttpMethod.HttpGet, host: "ml.googleapis.com",
    route: "/v1beta1/{parent}/jobs", validator: validate_MlProjectsJobsList_589145,
    base: "/", url: url_MlProjectsJobsList_589146, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsCreate_589214 = ref object of OpenApiRestCall_588450
proc url_MlProjectsModelsCreate_589216(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsModelsCreate_589215(path: JsonNode; query: JsonNode;
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
  var valid_589217 = path.getOrDefault("parent")
  valid_589217 = validateParameter(valid_589217, JString, required = true,
                                 default = nil)
  if valid_589217 != nil:
    section.add "parent", valid_589217
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
  var valid_589218 = query.getOrDefault("upload_protocol")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "upload_protocol", valid_589218
  var valid_589219 = query.getOrDefault("fields")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "fields", valid_589219
  var valid_589220 = query.getOrDefault("quotaUser")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "quotaUser", valid_589220
  var valid_589221 = query.getOrDefault("alt")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = newJString("json"))
  if valid_589221 != nil:
    section.add "alt", valid_589221
  var valid_589222 = query.getOrDefault("pp")
  valid_589222 = validateParameter(valid_589222, JBool, required = false,
                                 default = newJBool(true))
  if valid_589222 != nil:
    section.add "pp", valid_589222
  var valid_589223 = query.getOrDefault("oauth_token")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "oauth_token", valid_589223
  var valid_589224 = query.getOrDefault("uploadType")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "uploadType", valid_589224
  var valid_589225 = query.getOrDefault("callback")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "callback", valid_589225
  var valid_589226 = query.getOrDefault("access_token")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "access_token", valid_589226
  var valid_589227 = query.getOrDefault("key")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "key", valid_589227
  var valid_589228 = query.getOrDefault("$.xgafv")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = newJString("1"))
  if valid_589228 != nil:
    section.add "$.xgafv", valid_589228
  var valid_589229 = query.getOrDefault("prettyPrint")
  valid_589229 = validateParameter(valid_589229, JBool, required = false,
                                 default = newJBool(true))
  if valid_589229 != nil:
    section.add "prettyPrint", valid_589229
  var valid_589230 = query.getOrDefault("bearer_token")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "bearer_token", valid_589230
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

proc call*(call_589232: Call_MlProjectsModelsCreate_589214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a model which will later contain one or more versions.
  ## 
  ## You must add at least one version before you can request predictions from
  ## the model. Add versions by calling
  ## [projects.models.versions.create](/ml-engine/reference/rest/v1beta1/projects.models.versions/create).
  ## 
  let valid = call_589232.validator(path, query, header, formData, body)
  let scheme = call_589232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589232.url(scheme.get, call_589232.host, call_589232.base,
                         call_589232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589232, url, valid)

proc call*(call_589233: Call_MlProjectsModelsCreate_589214; parent: string;
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
  var path_589234 = newJObject()
  var query_589235 = newJObject()
  var body_589236 = newJObject()
  add(query_589235, "upload_protocol", newJString(uploadProtocol))
  add(query_589235, "fields", newJString(fields))
  add(query_589235, "quotaUser", newJString(quotaUser))
  add(query_589235, "alt", newJString(alt))
  add(query_589235, "pp", newJBool(pp))
  add(query_589235, "oauth_token", newJString(oauthToken))
  add(query_589235, "uploadType", newJString(uploadType))
  add(query_589235, "callback", newJString(callback))
  add(query_589235, "access_token", newJString(accessToken))
  add(path_589234, "parent", newJString(parent))
  add(query_589235, "key", newJString(key))
  add(query_589235, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589236 = body
  add(query_589235, "prettyPrint", newJBool(prettyPrint))
  add(query_589235, "bearer_token", newJString(bearerToken))
  result = call_589233.call(path_589234, query_589235, nil, nil, body_589236)

var mlProjectsModelsCreate* = Call_MlProjectsModelsCreate_589214(
    name: "mlProjectsModelsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/models",
    validator: validate_MlProjectsModelsCreate_589215, base: "/",
    url: url_MlProjectsModelsCreate_589216, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsList_589191 = ref object of OpenApiRestCall_588450
proc url_MlProjectsModelsList_589193(protocol: Scheme; host: string; base: string;
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

proc validate_MlProjectsModelsList_589192(path: JsonNode; query: JsonNode;
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
  var valid_589194 = path.getOrDefault("parent")
  valid_589194 = validateParameter(valid_589194, JString, required = true,
                                 default = nil)
  if valid_589194 != nil:
    section.add "parent", valid_589194
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
  var valid_589195 = query.getOrDefault("upload_protocol")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "upload_protocol", valid_589195
  var valid_589196 = query.getOrDefault("fields")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "fields", valid_589196
  var valid_589197 = query.getOrDefault("pageToken")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "pageToken", valid_589197
  var valid_589198 = query.getOrDefault("quotaUser")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "quotaUser", valid_589198
  var valid_589199 = query.getOrDefault("alt")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = newJString("json"))
  if valid_589199 != nil:
    section.add "alt", valid_589199
  var valid_589200 = query.getOrDefault("pp")
  valid_589200 = validateParameter(valid_589200, JBool, required = false,
                                 default = newJBool(true))
  if valid_589200 != nil:
    section.add "pp", valid_589200
  var valid_589201 = query.getOrDefault("oauth_token")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "oauth_token", valid_589201
  var valid_589202 = query.getOrDefault("uploadType")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "uploadType", valid_589202
  var valid_589203 = query.getOrDefault("callback")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "callback", valid_589203
  var valid_589204 = query.getOrDefault("access_token")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "access_token", valid_589204
  var valid_589205 = query.getOrDefault("key")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "key", valid_589205
  var valid_589206 = query.getOrDefault("$.xgafv")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = newJString("1"))
  if valid_589206 != nil:
    section.add "$.xgafv", valid_589206
  var valid_589207 = query.getOrDefault("pageSize")
  valid_589207 = validateParameter(valid_589207, JInt, required = false, default = nil)
  if valid_589207 != nil:
    section.add "pageSize", valid_589207
  var valid_589208 = query.getOrDefault("prettyPrint")
  valid_589208 = validateParameter(valid_589208, JBool, required = false,
                                 default = newJBool(true))
  if valid_589208 != nil:
    section.add "prettyPrint", valid_589208
  var valid_589209 = query.getOrDefault("bearer_token")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "bearer_token", valid_589209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589210: Call_MlProjectsModelsList_589191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the models in a project.
  ## 
  ## Each project can contain multiple models, and each model can have multiple
  ## versions.
  ## 
  let valid = call_589210.validator(path, query, header, formData, body)
  let scheme = call_589210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589210.url(scheme.get, call_589210.host, call_589210.base,
                         call_589210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589210, url, valid)

proc call*(call_589211: Call_MlProjectsModelsList_589191; parent: string;
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
  var path_589212 = newJObject()
  var query_589213 = newJObject()
  add(query_589213, "upload_protocol", newJString(uploadProtocol))
  add(query_589213, "fields", newJString(fields))
  add(query_589213, "pageToken", newJString(pageToken))
  add(query_589213, "quotaUser", newJString(quotaUser))
  add(query_589213, "alt", newJString(alt))
  add(query_589213, "pp", newJBool(pp))
  add(query_589213, "oauth_token", newJString(oauthToken))
  add(query_589213, "uploadType", newJString(uploadType))
  add(query_589213, "callback", newJString(callback))
  add(query_589213, "access_token", newJString(accessToken))
  add(path_589212, "parent", newJString(parent))
  add(query_589213, "key", newJString(key))
  add(query_589213, "$.xgafv", newJString(Xgafv))
  add(query_589213, "pageSize", newJInt(pageSize))
  add(query_589213, "prettyPrint", newJBool(prettyPrint))
  add(query_589213, "bearer_token", newJString(bearerToken))
  result = call_589211.call(path_589212, query_589213, nil, nil, nil)

var mlProjectsModelsList* = Call_MlProjectsModelsList_589191(
    name: "mlProjectsModelsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/models",
    validator: validate_MlProjectsModelsList_589192, base: "/",
    url: url_MlProjectsModelsList_589193, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsCreate_589260 = ref object of OpenApiRestCall_588450
proc url_MlProjectsModelsVersionsCreate_589262(protocol: Scheme; host: string;
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

proc validate_MlProjectsModelsVersionsCreate_589261(path: JsonNode;
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
  var valid_589263 = path.getOrDefault("parent")
  valid_589263 = validateParameter(valid_589263, JString, required = true,
                                 default = nil)
  if valid_589263 != nil:
    section.add "parent", valid_589263
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
  var valid_589264 = query.getOrDefault("upload_protocol")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "upload_protocol", valid_589264
  var valid_589265 = query.getOrDefault("fields")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "fields", valid_589265
  var valid_589266 = query.getOrDefault("quotaUser")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "quotaUser", valid_589266
  var valid_589267 = query.getOrDefault("alt")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = newJString("json"))
  if valid_589267 != nil:
    section.add "alt", valid_589267
  var valid_589268 = query.getOrDefault("pp")
  valid_589268 = validateParameter(valid_589268, JBool, required = false,
                                 default = newJBool(true))
  if valid_589268 != nil:
    section.add "pp", valid_589268
  var valid_589269 = query.getOrDefault("oauth_token")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "oauth_token", valid_589269
  var valid_589270 = query.getOrDefault("uploadType")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "uploadType", valid_589270
  var valid_589271 = query.getOrDefault("callback")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "callback", valid_589271
  var valid_589272 = query.getOrDefault("access_token")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "access_token", valid_589272
  var valid_589273 = query.getOrDefault("key")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "key", valid_589273
  var valid_589274 = query.getOrDefault("$.xgafv")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = newJString("1"))
  if valid_589274 != nil:
    section.add "$.xgafv", valid_589274
  var valid_589275 = query.getOrDefault("prettyPrint")
  valid_589275 = validateParameter(valid_589275, JBool, required = false,
                                 default = newJBool(true))
  if valid_589275 != nil:
    section.add "prettyPrint", valid_589275
  var valid_589276 = query.getOrDefault("bearer_token")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "bearer_token", valid_589276
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

proc call*(call_589278: Call_MlProjectsModelsVersionsCreate_589260; path: JsonNode;
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
  let valid = call_589278.validator(path, query, header, formData, body)
  let scheme = call_589278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589278.url(scheme.get, call_589278.host, call_589278.base,
                         call_589278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589278, url, valid)

proc call*(call_589279: Call_MlProjectsModelsVersionsCreate_589260; parent: string;
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
  var path_589280 = newJObject()
  var query_589281 = newJObject()
  var body_589282 = newJObject()
  add(query_589281, "upload_protocol", newJString(uploadProtocol))
  add(query_589281, "fields", newJString(fields))
  add(query_589281, "quotaUser", newJString(quotaUser))
  add(query_589281, "alt", newJString(alt))
  add(query_589281, "pp", newJBool(pp))
  add(query_589281, "oauth_token", newJString(oauthToken))
  add(query_589281, "uploadType", newJString(uploadType))
  add(query_589281, "callback", newJString(callback))
  add(query_589281, "access_token", newJString(accessToken))
  add(path_589280, "parent", newJString(parent))
  add(query_589281, "key", newJString(key))
  add(query_589281, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589282 = body
  add(query_589281, "prettyPrint", newJBool(prettyPrint))
  add(query_589281, "bearer_token", newJString(bearerToken))
  result = call_589279.call(path_589280, query_589281, nil, nil, body_589282)

var mlProjectsModelsVersionsCreate* = Call_MlProjectsModelsVersionsCreate_589260(
    name: "mlProjectsModelsVersionsCreate", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/versions",
    validator: validate_MlProjectsModelsVersionsCreate_589261, base: "/",
    url: url_MlProjectsModelsVersionsCreate_589262, schemes: {Scheme.Https})
type
  Call_MlProjectsModelsVersionsList_589237 = ref object of OpenApiRestCall_588450
proc url_MlProjectsModelsVersionsList_589239(protocol: Scheme; host: string;
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

proc validate_MlProjectsModelsVersionsList_589238(path: JsonNode; query: JsonNode;
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
  var valid_589240 = path.getOrDefault("parent")
  valid_589240 = validateParameter(valid_589240, JString, required = true,
                                 default = nil)
  if valid_589240 != nil:
    section.add "parent", valid_589240
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
  var valid_589241 = query.getOrDefault("upload_protocol")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "upload_protocol", valid_589241
  var valid_589242 = query.getOrDefault("fields")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "fields", valid_589242
  var valid_589243 = query.getOrDefault("pageToken")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "pageToken", valid_589243
  var valid_589244 = query.getOrDefault("quotaUser")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "quotaUser", valid_589244
  var valid_589245 = query.getOrDefault("alt")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = newJString("json"))
  if valid_589245 != nil:
    section.add "alt", valid_589245
  var valid_589246 = query.getOrDefault("pp")
  valid_589246 = validateParameter(valid_589246, JBool, required = false,
                                 default = newJBool(true))
  if valid_589246 != nil:
    section.add "pp", valid_589246
  var valid_589247 = query.getOrDefault("oauth_token")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "oauth_token", valid_589247
  var valid_589248 = query.getOrDefault("uploadType")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "uploadType", valid_589248
  var valid_589249 = query.getOrDefault("callback")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "callback", valid_589249
  var valid_589250 = query.getOrDefault("access_token")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "access_token", valid_589250
  var valid_589251 = query.getOrDefault("key")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "key", valid_589251
  var valid_589252 = query.getOrDefault("$.xgafv")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = newJString("1"))
  if valid_589252 != nil:
    section.add "$.xgafv", valid_589252
  var valid_589253 = query.getOrDefault("pageSize")
  valid_589253 = validateParameter(valid_589253, JInt, required = false, default = nil)
  if valid_589253 != nil:
    section.add "pageSize", valid_589253
  var valid_589254 = query.getOrDefault("prettyPrint")
  valid_589254 = validateParameter(valid_589254, JBool, required = false,
                                 default = newJBool(true))
  if valid_589254 != nil:
    section.add "prettyPrint", valid_589254
  var valid_589255 = query.getOrDefault("bearer_token")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "bearer_token", valid_589255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589256: Call_MlProjectsModelsVersionsList_589237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets basic information about all the versions of a model.
  ## 
  ## If you expect that a model has a lot of versions, or if you need to handle
  ## only a limited number of results at a time, you can request that the list
  ## be retrieved in batches (called pages):
  ## 
  let valid = call_589256.validator(path, query, header, formData, body)
  let scheme = call_589256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589256.url(scheme.get, call_589256.host, call_589256.base,
                         call_589256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589256, url, valid)

proc call*(call_589257: Call_MlProjectsModelsVersionsList_589237; parent: string;
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
  var path_589258 = newJObject()
  var query_589259 = newJObject()
  add(query_589259, "upload_protocol", newJString(uploadProtocol))
  add(query_589259, "fields", newJString(fields))
  add(query_589259, "pageToken", newJString(pageToken))
  add(query_589259, "quotaUser", newJString(quotaUser))
  add(query_589259, "alt", newJString(alt))
  add(query_589259, "pp", newJBool(pp))
  add(query_589259, "oauth_token", newJString(oauthToken))
  add(query_589259, "uploadType", newJString(uploadType))
  add(query_589259, "callback", newJString(callback))
  add(query_589259, "access_token", newJString(accessToken))
  add(path_589258, "parent", newJString(parent))
  add(query_589259, "key", newJString(key))
  add(query_589259, "$.xgafv", newJString(Xgafv))
  add(query_589259, "pageSize", newJInt(pageSize))
  add(query_589259, "prettyPrint", newJBool(prettyPrint))
  add(query_589259, "bearer_token", newJString(bearerToken))
  result = call_589257.call(path_589258, query_589259, nil, nil, nil)

var mlProjectsModelsVersionsList* = Call_MlProjectsModelsVersionsList_589237(
    name: "mlProjectsModelsVersionsList", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{parent}/versions",
    validator: validate_MlProjectsModelsVersionsList_589238, base: "/",
    url: url_MlProjectsModelsVersionsList_589239, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsGetIamPolicy_589283 = ref object of OpenApiRestCall_588450
proc url_MlProjectsJobsGetIamPolicy_589285(protocol: Scheme; host: string;
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

proc validate_MlProjectsJobsGetIamPolicy_589284(path: JsonNode; query: JsonNode;
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
  var valid_589286 = path.getOrDefault("resource")
  valid_589286 = validateParameter(valid_589286, JString, required = true,
                                 default = nil)
  if valid_589286 != nil:
    section.add "resource", valid_589286
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
  var valid_589287 = query.getOrDefault("upload_protocol")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "upload_protocol", valid_589287
  var valid_589288 = query.getOrDefault("fields")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "fields", valid_589288
  var valid_589289 = query.getOrDefault("quotaUser")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "quotaUser", valid_589289
  var valid_589290 = query.getOrDefault("alt")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = newJString("json"))
  if valid_589290 != nil:
    section.add "alt", valid_589290
  var valid_589291 = query.getOrDefault("pp")
  valid_589291 = validateParameter(valid_589291, JBool, required = false,
                                 default = newJBool(true))
  if valid_589291 != nil:
    section.add "pp", valid_589291
  var valid_589292 = query.getOrDefault("oauth_token")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "oauth_token", valid_589292
  var valid_589293 = query.getOrDefault("callback")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "callback", valid_589293
  var valid_589294 = query.getOrDefault("access_token")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "access_token", valid_589294
  var valid_589295 = query.getOrDefault("uploadType")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "uploadType", valid_589295
  var valid_589296 = query.getOrDefault("key")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "key", valid_589296
  var valid_589297 = query.getOrDefault("$.xgafv")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = newJString("1"))
  if valid_589297 != nil:
    section.add "$.xgafv", valid_589297
  var valid_589298 = query.getOrDefault("prettyPrint")
  valid_589298 = validateParameter(valid_589298, JBool, required = false,
                                 default = newJBool(true))
  if valid_589298 != nil:
    section.add "prettyPrint", valid_589298
  var valid_589299 = query.getOrDefault("bearer_token")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "bearer_token", valid_589299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589300: Call_MlProjectsJobsGetIamPolicy_589283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_589300.validator(path, query, header, formData, body)
  let scheme = call_589300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589300.url(scheme.get, call_589300.host, call_589300.base,
                         call_589300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589300, url, valid)

proc call*(call_589301: Call_MlProjectsJobsGetIamPolicy_589283; resource: string;
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
  var path_589302 = newJObject()
  var query_589303 = newJObject()
  add(query_589303, "upload_protocol", newJString(uploadProtocol))
  add(query_589303, "fields", newJString(fields))
  add(query_589303, "quotaUser", newJString(quotaUser))
  add(query_589303, "alt", newJString(alt))
  add(query_589303, "pp", newJBool(pp))
  add(query_589303, "oauth_token", newJString(oauthToken))
  add(query_589303, "callback", newJString(callback))
  add(query_589303, "access_token", newJString(accessToken))
  add(query_589303, "uploadType", newJString(uploadType))
  add(query_589303, "key", newJString(key))
  add(query_589303, "$.xgafv", newJString(Xgafv))
  add(path_589302, "resource", newJString(resource))
  add(query_589303, "prettyPrint", newJBool(prettyPrint))
  add(query_589303, "bearer_token", newJString(bearerToken))
  result = call_589301.call(path_589302, query_589303, nil, nil, nil)

var mlProjectsJobsGetIamPolicy* = Call_MlProjectsJobsGetIamPolicy_589283(
    name: "mlProjectsJobsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "ml.googleapis.com", route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_MlProjectsJobsGetIamPolicy_589284, base: "/",
    url: url_MlProjectsJobsGetIamPolicy_589285, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsSetIamPolicy_589304 = ref object of OpenApiRestCall_588450
proc url_MlProjectsJobsSetIamPolicy_589306(protocol: Scheme; host: string;
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

proc validate_MlProjectsJobsSetIamPolicy_589305(path: JsonNode; query: JsonNode;
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
  var valid_589307 = path.getOrDefault("resource")
  valid_589307 = validateParameter(valid_589307, JString, required = true,
                                 default = nil)
  if valid_589307 != nil:
    section.add "resource", valid_589307
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
  var valid_589308 = query.getOrDefault("upload_protocol")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "upload_protocol", valid_589308
  var valid_589309 = query.getOrDefault("fields")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "fields", valid_589309
  var valid_589310 = query.getOrDefault("quotaUser")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "quotaUser", valid_589310
  var valid_589311 = query.getOrDefault("alt")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = newJString("json"))
  if valid_589311 != nil:
    section.add "alt", valid_589311
  var valid_589312 = query.getOrDefault("pp")
  valid_589312 = validateParameter(valid_589312, JBool, required = false,
                                 default = newJBool(true))
  if valid_589312 != nil:
    section.add "pp", valid_589312
  var valid_589313 = query.getOrDefault("oauth_token")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "oauth_token", valid_589313
  var valid_589314 = query.getOrDefault("callback")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "callback", valid_589314
  var valid_589315 = query.getOrDefault("access_token")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "access_token", valid_589315
  var valid_589316 = query.getOrDefault("uploadType")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "uploadType", valid_589316
  var valid_589317 = query.getOrDefault("key")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "key", valid_589317
  var valid_589318 = query.getOrDefault("$.xgafv")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = newJString("1"))
  if valid_589318 != nil:
    section.add "$.xgafv", valid_589318
  var valid_589319 = query.getOrDefault("prettyPrint")
  valid_589319 = validateParameter(valid_589319, JBool, required = false,
                                 default = newJBool(true))
  if valid_589319 != nil:
    section.add "prettyPrint", valid_589319
  var valid_589320 = query.getOrDefault("bearer_token")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "bearer_token", valid_589320
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

proc call*(call_589322: Call_MlProjectsJobsSetIamPolicy_589304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_589322.validator(path, query, header, formData, body)
  let scheme = call_589322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589322.url(scheme.get, call_589322.host, call_589322.base,
                         call_589322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589322, url, valid)

proc call*(call_589323: Call_MlProjectsJobsSetIamPolicy_589304; resource: string;
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
  var path_589324 = newJObject()
  var query_589325 = newJObject()
  var body_589326 = newJObject()
  add(query_589325, "upload_protocol", newJString(uploadProtocol))
  add(query_589325, "fields", newJString(fields))
  add(query_589325, "quotaUser", newJString(quotaUser))
  add(query_589325, "alt", newJString(alt))
  add(query_589325, "pp", newJBool(pp))
  add(query_589325, "oauth_token", newJString(oauthToken))
  add(query_589325, "callback", newJString(callback))
  add(query_589325, "access_token", newJString(accessToken))
  add(query_589325, "uploadType", newJString(uploadType))
  add(query_589325, "key", newJString(key))
  add(query_589325, "$.xgafv", newJString(Xgafv))
  add(path_589324, "resource", newJString(resource))
  if body != nil:
    body_589326 = body
  add(query_589325, "prettyPrint", newJBool(prettyPrint))
  add(query_589325, "bearer_token", newJString(bearerToken))
  result = call_589323.call(path_589324, query_589325, nil, nil, body_589326)

var mlProjectsJobsSetIamPolicy* = Call_MlProjectsJobsSetIamPolicy_589304(
    name: "mlProjectsJobsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_MlProjectsJobsSetIamPolicy_589305, base: "/",
    url: url_MlProjectsJobsSetIamPolicy_589306, schemes: {Scheme.Https})
type
  Call_MlProjectsJobsTestIamPermissions_589327 = ref object of OpenApiRestCall_588450
proc url_MlProjectsJobsTestIamPermissions_589329(protocol: Scheme; host: string;
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

proc validate_MlProjectsJobsTestIamPermissions_589328(path: JsonNode;
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
  var valid_589330 = path.getOrDefault("resource")
  valid_589330 = validateParameter(valid_589330, JString, required = true,
                                 default = nil)
  if valid_589330 != nil:
    section.add "resource", valid_589330
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
  var valid_589331 = query.getOrDefault("upload_protocol")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "upload_protocol", valid_589331
  var valid_589332 = query.getOrDefault("fields")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "fields", valid_589332
  var valid_589333 = query.getOrDefault("quotaUser")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "quotaUser", valid_589333
  var valid_589334 = query.getOrDefault("alt")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = newJString("json"))
  if valid_589334 != nil:
    section.add "alt", valid_589334
  var valid_589335 = query.getOrDefault("pp")
  valid_589335 = validateParameter(valid_589335, JBool, required = false,
                                 default = newJBool(true))
  if valid_589335 != nil:
    section.add "pp", valid_589335
  var valid_589336 = query.getOrDefault("oauth_token")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "oauth_token", valid_589336
  var valid_589337 = query.getOrDefault("callback")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "callback", valid_589337
  var valid_589338 = query.getOrDefault("access_token")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "access_token", valid_589338
  var valid_589339 = query.getOrDefault("uploadType")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "uploadType", valid_589339
  var valid_589340 = query.getOrDefault("key")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "key", valid_589340
  var valid_589341 = query.getOrDefault("$.xgafv")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = newJString("1"))
  if valid_589341 != nil:
    section.add "$.xgafv", valid_589341
  var valid_589342 = query.getOrDefault("prettyPrint")
  valid_589342 = validateParameter(valid_589342, JBool, required = false,
                                 default = newJBool(true))
  if valid_589342 != nil:
    section.add "prettyPrint", valid_589342
  var valid_589343 = query.getOrDefault("bearer_token")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "bearer_token", valid_589343
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

proc call*(call_589345: Call_MlProjectsJobsTestIamPermissions_589327;
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
  let valid = call_589345.validator(path, query, header, formData, body)
  let scheme = call_589345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589345.url(scheme.get, call_589345.host, call_589345.base,
                         call_589345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589345, url, valid)

proc call*(call_589346: Call_MlProjectsJobsTestIamPermissions_589327;
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
  var path_589347 = newJObject()
  var query_589348 = newJObject()
  var body_589349 = newJObject()
  add(query_589348, "upload_protocol", newJString(uploadProtocol))
  add(query_589348, "fields", newJString(fields))
  add(query_589348, "quotaUser", newJString(quotaUser))
  add(query_589348, "alt", newJString(alt))
  add(query_589348, "pp", newJBool(pp))
  add(query_589348, "oauth_token", newJString(oauthToken))
  add(query_589348, "callback", newJString(callback))
  add(query_589348, "access_token", newJString(accessToken))
  add(query_589348, "uploadType", newJString(uploadType))
  add(query_589348, "key", newJString(key))
  add(query_589348, "$.xgafv", newJString(Xgafv))
  add(path_589347, "resource", newJString(resource))
  if body != nil:
    body_589349 = body
  add(query_589348, "prettyPrint", newJBool(prettyPrint))
  add(query_589348, "bearer_token", newJString(bearerToken))
  result = call_589346.call(path_589347, query_589348, nil, nil, body_589349)

var mlProjectsJobsTestIamPermissions* = Call_MlProjectsJobsTestIamPermissions_589327(
    name: "mlProjectsJobsTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "ml.googleapis.com", route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_MlProjectsJobsTestIamPermissions_589328, base: "/",
    url: url_MlProjectsJobsTestIamPermissions_589329, schemes: {Scheme.Https})
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
