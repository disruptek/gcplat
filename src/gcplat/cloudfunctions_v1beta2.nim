
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Functions
## version: v1beta2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages lightweight user-provided functions executed in response to events.
## 
## https://cloud.google.com/functions
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudfunctions"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudfunctionsOperationsList_588710 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsOperationsList_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudfunctionsOperationsList_588711(path: JsonNode; query: JsonNode;
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
  section = newJObject()
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
  ##   name: JString
  ##       : Must not be set.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Required. A filter for matching the requested operations.<br><br> The supported formats of <b>filter</b> are:<br> To query for specific function: <code>project:*,location:*,function:*</code><br> To query for all of the latest operations for a project: <code>project:*,latest:true</code>
  section = newJObject()
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("pageToken")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "pageToken", valid_588826
  var valid_588827 = query.getOrDefault("quotaUser")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "quotaUser", valid_588827
  var valid_588841 = query.getOrDefault("alt")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("json"))
  if valid_588841 != nil:
    section.add "alt", valid_588841
  var valid_588842 = query.getOrDefault("oauth_token")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "oauth_token", valid_588842
  var valid_588843 = query.getOrDefault("callback")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "callback", valid_588843
  var valid_588844 = query.getOrDefault("access_token")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "access_token", valid_588844
  var valid_588845 = query.getOrDefault("uploadType")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "uploadType", valid_588845
  var valid_588846 = query.getOrDefault("key")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "key", valid_588846
  var valid_588847 = query.getOrDefault("name")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "name", valid_588847
  var valid_588848 = query.getOrDefault("$.xgafv")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = newJString("1"))
  if valid_588848 != nil:
    section.add "$.xgafv", valid_588848
  var valid_588849 = query.getOrDefault("pageSize")
  valid_588849 = validateParameter(valid_588849, JInt, required = false, default = nil)
  if valid_588849 != nil:
    section.add "pageSize", valid_588849
  var valid_588850 = query.getOrDefault("prettyPrint")
  valid_588850 = validateParameter(valid_588850, JBool, required = false,
                                 default = newJBool(true))
  if valid_588850 != nil:
    section.add "prettyPrint", valid_588850
  var valid_588851 = query.getOrDefault("filter")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "filter", valid_588851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588874: Call_CloudfunctionsOperationsList_588710; path: JsonNode;
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
  let valid = call_588874.validator(path, query, header, formData, body)
  let scheme = call_588874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588874.url(scheme.get, call_588874.host, call_588874.base,
                         call_588874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588874, url, valid)

proc call*(call_588945: Call_CloudfunctionsOperationsList_588710;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudfunctionsOperationsList
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
  ##   name: string
  ##       : Must not be set.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Required. A filter for matching the requested operations.<br><br> The supported formats of <b>filter</b> are:<br> To query for specific function: <code>project:*,location:*,function:*</code><br> To query for all of the latest operations for a project: <code>project:*,latest:true</code>
  var query_588946 = newJObject()
  add(query_588946, "upload_protocol", newJString(uploadProtocol))
  add(query_588946, "fields", newJString(fields))
  add(query_588946, "pageToken", newJString(pageToken))
  add(query_588946, "quotaUser", newJString(quotaUser))
  add(query_588946, "alt", newJString(alt))
  add(query_588946, "oauth_token", newJString(oauthToken))
  add(query_588946, "callback", newJString(callback))
  add(query_588946, "access_token", newJString(accessToken))
  add(query_588946, "uploadType", newJString(uploadType))
  add(query_588946, "key", newJString(key))
  add(query_588946, "name", newJString(name))
  add(query_588946, "$.xgafv", newJString(Xgafv))
  add(query_588946, "pageSize", newJInt(pageSize))
  add(query_588946, "prettyPrint", newJBool(prettyPrint))
  add(query_588946, "filter", newJString(filter))
  result = call_588945.call(nil, query_588946, nil, nil, nil)

var cloudfunctionsOperationsList* = Call_CloudfunctionsOperationsList_588710(
    name: "cloudfunctionsOperationsList", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1beta2/operations",
    validator: validate_CloudfunctionsOperationsList_588711, base: "/",
    url: url_CloudfunctionsOperationsList_588712, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsCreate_589021 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsCreate_589023(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/functions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsCreate_589022(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new function. If a function with the given name already exists in
  ## the specified project, the long running operation will return
  ## `ALREADY_EXISTS` error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : Required. The project and location in which the function should be created, specified
  ## in the format `projects/*/locations/*`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_589024 = path.getOrDefault("location")
  valid_589024 = validateParameter(valid_589024, JString, required = true,
                                 default = nil)
  if valid_589024 != nil:
    section.add "location", valid_589024
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
  var valid_589025 = query.getOrDefault("upload_protocol")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "upload_protocol", valid_589025
  var valid_589026 = query.getOrDefault("fields")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "fields", valid_589026
  var valid_589027 = query.getOrDefault("quotaUser")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "quotaUser", valid_589027
  var valid_589028 = query.getOrDefault("alt")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = newJString("json"))
  if valid_589028 != nil:
    section.add "alt", valid_589028
  var valid_589029 = query.getOrDefault("oauth_token")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "oauth_token", valid_589029
  var valid_589030 = query.getOrDefault("callback")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "callback", valid_589030
  var valid_589031 = query.getOrDefault("access_token")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "access_token", valid_589031
  var valid_589032 = query.getOrDefault("uploadType")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "uploadType", valid_589032
  var valid_589033 = query.getOrDefault("key")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "key", valid_589033
  var valid_589034 = query.getOrDefault("$.xgafv")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = newJString("1"))
  if valid_589034 != nil:
    section.add "$.xgafv", valid_589034
  var valid_589035 = query.getOrDefault("prettyPrint")
  valid_589035 = validateParameter(valid_589035, JBool, required = false,
                                 default = newJBool(true))
  if valid_589035 != nil:
    section.add "prettyPrint", valid_589035
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

proc call*(call_589037: Call_CloudfunctionsProjectsLocationsFunctionsCreate_589021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new function. If a function with the given name already exists in
  ## the specified project, the long running operation will return
  ## `ALREADY_EXISTS` error.
  ## 
  let valid = call_589037.validator(path, query, header, formData, body)
  let scheme = call_589037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589037.url(scheme.get, call_589037.host, call_589037.base,
                         call_589037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589037, url, valid)

proc call*(call_589038: Call_CloudfunctionsProjectsLocationsFunctionsCreate_589021;
          location: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudfunctionsProjectsLocationsFunctionsCreate
  ## Creates a new function. If a function with the given name already exists in
  ## the specified project, the long running operation will return
  ## `ALREADY_EXISTS` error.
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : Required. The project and location in which the function should be created, specified
  ## in the format `projects/*/locations/*`
  var path_589039 = newJObject()
  var query_589040 = newJObject()
  var body_589041 = newJObject()
  add(query_589040, "upload_protocol", newJString(uploadProtocol))
  add(query_589040, "fields", newJString(fields))
  add(query_589040, "quotaUser", newJString(quotaUser))
  add(query_589040, "alt", newJString(alt))
  add(query_589040, "oauth_token", newJString(oauthToken))
  add(query_589040, "callback", newJString(callback))
  add(query_589040, "access_token", newJString(accessToken))
  add(query_589040, "uploadType", newJString(uploadType))
  add(query_589040, "key", newJString(key))
  add(query_589040, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589041 = body
  add(query_589040, "prettyPrint", newJBool(prettyPrint))
  add(path_589039, "location", newJString(location))
  result = call_589038.call(path_589039, query_589040, nil, nil, body_589041)

var cloudfunctionsProjectsLocationsFunctionsCreate* = Call_CloudfunctionsProjectsLocationsFunctionsCreate_589021(
    name: "cloudfunctionsProjectsLocationsFunctionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{location}/functions",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsCreate_589022,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsCreate_589023,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsList_588986 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsList_588988(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/functions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsList_588987(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of functions that belong to the requested project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : Required. The project and location from which the function should be listed,
  ## specified in the format `projects/*/locations/*`
  ## If you want to list functions in all locations, use "-" in place of a
  ## location.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_589003 = path.getOrDefault("location")
  valid_589003 = validateParameter(valid_589003, JString, required = true,
                                 default = nil)
  if valid_589003 != nil:
    section.add "location", valid_589003
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last
  ## `ListFunctionsResponse`; indicates that
  ## this is a continuation of a prior `ListFunctions` call, and that the
  ## system should return the next page of data.
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
  ##   pageSize: JInt
  ##           : Maximum number of functions to return per call.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589004 = query.getOrDefault("upload_protocol")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "upload_protocol", valid_589004
  var valid_589005 = query.getOrDefault("fields")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "fields", valid_589005
  var valid_589006 = query.getOrDefault("pageToken")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "pageToken", valid_589006
  var valid_589007 = query.getOrDefault("quotaUser")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "quotaUser", valid_589007
  var valid_589008 = query.getOrDefault("alt")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = newJString("json"))
  if valid_589008 != nil:
    section.add "alt", valid_589008
  var valid_589009 = query.getOrDefault("oauth_token")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "oauth_token", valid_589009
  var valid_589010 = query.getOrDefault("callback")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "callback", valid_589010
  var valid_589011 = query.getOrDefault("access_token")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "access_token", valid_589011
  var valid_589012 = query.getOrDefault("uploadType")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "uploadType", valid_589012
  var valid_589013 = query.getOrDefault("key")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "key", valid_589013
  var valid_589014 = query.getOrDefault("$.xgafv")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("1"))
  if valid_589014 != nil:
    section.add "$.xgafv", valid_589014
  var valid_589015 = query.getOrDefault("pageSize")
  valid_589015 = validateParameter(valid_589015, JInt, required = false, default = nil)
  if valid_589015 != nil:
    section.add "pageSize", valid_589015
  var valid_589016 = query.getOrDefault("prettyPrint")
  valid_589016 = validateParameter(valid_589016, JBool, required = false,
                                 default = newJBool(true))
  if valid_589016 != nil:
    section.add "prettyPrint", valid_589016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589017: Call_CloudfunctionsProjectsLocationsFunctionsList_588986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of functions that belong to the requested project.
  ## 
  let valid = call_589017.validator(path, query, header, formData, body)
  let scheme = call_589017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589017.url(scheme.get, call_589017.host, call_589017.base,
                         call_589017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589017, url, valid)

proc call*(call_589018: Call_CloudfunctionsProjectsLocationsFunctionsList_588986;
          location: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudfunctionsProjectsLocationsFunctionsList
  ## Returns a list of functions that belong to the requested project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last
  ## `ListFunctionsResponse`; indicates that
  ## this is a continuation of a prior `ListFunctions` call, and that the
  ## system should return the next page of data.
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of functions to return per call.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : Required. The project and location from which the function should be listed,
  ## specified in the format `projects/*/locations/*`
  ## If you want to list functions in all locations, use "-" in place of a
  ## location.
  var path_589019 = newJObject()
  var query_589020 = newJObject()
  add(query_589020, "upload_protocol", newJString(uploadProtocol))
  add(query_589020, "fields", newJString(fields))
  add(query_589020, "pageToken", newJString(pageToken))
  add(query_589020, "quotaUser", newJString(quotaUser))
  add(query_589020, "alt", newJString(alt))
  add(query_589020, "oauth_token", newJString(oauthToken))
  add(query_589020, "callback", newJString(callback))
  add(query_589020, "access_token", newJString(accessToken))
  add(query_589020, "uploadType", newJString(uploadType))
  add(query_589020, "key", newJString(key))
  add(query_589020, "$.xgafv", newJString(Xgafv))
  add(query_589020, "pageSize", newJInt(pageSize))
  add(query_589020, "prettyPrint", newJBool(prettyPrint))
  add(path_589019, "location", newJString(location))
  result = call_589018.call(path_589019, query_589020, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsList* = Call_CloudfunctionsProjectsLocationsFunctionsList_588986(
    name: "cloudfunctionsProjectsLocationsFunctionsList",
    meth: HttpMethod.HttpGet, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{location}/functions",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsList_588987,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsList_588988,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsUpdate_589061 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsUpdate_589063(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsUpdate_589062(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates existing function.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the function to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589064 = path.getOrDefault("name")
  valid_589064 = validateParameter(valid_589064, JString, required = true,
                                 default = nil)
  if valid_589064 != nil:
    section.add "name", valid_589064
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
  var valid_589065 = query.getOrDefault("upload_protocol")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "upload_protocol", valid_589065
  var valid_589066 = query.getOrDefault("fields")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "fields", valid_589066
  var valid_589067 = query.getOrDefault("quotaUser")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "quotaUser", valid_589067
  var valid_589068 = query.getOrDefault("alt")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("json"))
  if valid_589068 != nil:
    section.add "alt", valid_589068
  var valid_589069 = query.getOrDefault("oauth_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "oauth_token", valid_589069
  var valid_589070 = query.getOrDefault("callback")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "callback", valid_589070
  var valid_589071 = query.getOrDefault("access_token")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "access_token", valid_589071
  var valid_589072 = query.getOrDefault("uploadType")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "uploadType", valid_589072
  var valid_589073 = query.getOrDefault("key")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "key", valid_589073
  var valid_589074 = query.getOrDefault("$.xgafv")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = newJString("1"))
  if valid_589074 != nil:
    section.add "$.xgafv", valid_589074
  var valid_589075 = query.getOrDefault("prettyPrint")
  valid_589075 = validateParameter(valid_589075, JBool, required = false,
                                 default = newJBool(true))
  if valid_589075 != nil:
    section.add "prettyPrint", valid_589075
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

proc call*(call_589077: Call_CloudfunctionsProjectsLocationsFunctionsUpdate_589061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates existing function.
  ## 
  let valid = call_589077.validator(path, query, header, formData, body)
  let scheme = call_589077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589077.url(scheme.get, call_589077.host, call_589077.base,
                         call_589077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589077, url, valid)

proc call*(call_589078: Call_CloudfunctionsProjectsLocationsFunctionsUpdate_589061;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudfunctionsProjectsLocationsFunctionsUpdate
  ## Updates existing function.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the function to be updated.
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
  var path_589079 = newJObject()
  var query_589080 = newJObject()
  var body_589081 = newJObject()
  add(query_589080, "upload_protocol", newJString(uploadProtocol))
  add(query_589080, "fields", newJString(fields))
  add(query_589080, "quotaUser", newJString(quotaUser))
  add(path_589079, "name", newJString(name))
  add(query_589080, "alt", newJString(alt))
  add(query_589080, "oauth_token", newJString(oauthToken))
  add(query_589080, "callback", newJString(callback))
  add(query_589080, "access_token", newJString(accessToken))
  add(query_589080, "uploadType", newJString(uploadType))
  add(query_589080, "key", newJString(key))
  add(query_589080, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589081 = body
  add(query_589080, "prettyPrint", newJBool(prettyPrint))
  result = call_589078.call(path_589079, query_589080, nil, nil, body_589081)

var cloudfunctionsProjectsLocationsFunctionsUpdate* = Call_CloudfunctionsProjectsLocationsFunctionsUpdate_589061(
    name: "cloudfunctionsProjectsLocationsFunctionsUpdate",
    meth: HttpMethod.HttpPut, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsUpdate_589062,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsUpdate_589063,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsOperationsGet_589042 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsOperationsGet_589044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsOperationsGet_589043(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589045 = path.getOrDefault("name")
  valid_589045 = validateParameter(valid_589045, JString, required = true,
                                 default = nil)
  if valid_589045 != nil:
    section.add "name", valid_589045
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
  var valid_589046 = query.getOrDefault("upload_protocol")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "upload_protocol", valid_589046
  var valid_589047 = query.getOrDefault("fields")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "fields", valid_589047
  var valid_589048 = query.getOrDefault("quotaUser")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "quotaUser", valid_589048
  var valid_589049 = query.getOrDefault("alt")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = newJString("json"))
  if valid_589049 != nil:
    section.add "alt", valid_589049
  var valid_589050 = query.getOrDefault("oauth_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "oauth_token", valid_589050
  var valid_589051 = query.getOrDefault("callback")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "callback", valid_589051
  var valid_589052 = query.getOrDefault("access_token")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "access_token", valid_589052
  var valid_589053 = query.getOrDefault("uploadType")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "uploadType", valid_589053
  var valid_589054 = query.getOrDefault("key")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "key", valid_589054
  var valid_589055 = query.getOrDefault("$.xgafv")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = newJString("1"))
  if valid_589055 != nil:
    section.add "$.xgafv", valid_589055
  var valid_589056 = query.getOrDefault("prettyPrint")
  valid_589056 = validateParameter(valid_589056, JBool, required = false,
                                 default = newJBool(true))
  if valid_589056 != nil:
    section.add "prettyPrint", valid_589056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589057: Call_CloudfunctionsOperationsGet_589042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_589057.validator(path, query, header, formData, body)
  let scheme = call_589057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589057.url(scheme.get, call_589057.host, call_589057.base,
                         call_589057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589057, url, valid)

proc call*(call_589058: Call_CloudfunctionsOperationsGet_589042; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudfunctionsOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
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
  var path_589059 = newJObject()
  var query_589060 = newJObject()
  add(query_589060, "upload_protocol", newJString(uploadProtocol))
  add(query_589060, "fields", newJString(fields))
  add(query_589060, "quotaUser", newJString(quotaUser))
  add(path_589059, "name", newJString(name))
  add(query_589060, "alt", newJString(alt))
  add(query_589060, "oauth_token", newJString(oauthToken))
  add(query_589060, "callback", newJString(callback))
  add(query_589060, "access_token", newJString(accessToken))
  add(query_589060, "uploadType", newJString(uploadType))
  add(query_589060, "key", newJString(key))
  add(query_589060, "$.xgafv", newJString(Xgafv))
  add(query_589060, "prettyPrint", newJBool(prettyPrint))
  result = call_589058.call(path_589059, query_589060, nil, nil, nil)

var cloudfunctionsOperationsGet* = Call_CloudfunctionsOperationsGet_589042(
    name: "cloudfunctionsOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1beta2/{name}",
    validator: validate_CloudfunctionsOperationsGet_589043, base: "/",
    url: url_CloudfunctionsOperationsGet_589044, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsDelete_589082 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsDelete_589084(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsDelete_589083(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a function with the given name from the specified project. If the
  ## given function is used by some trigger, the trigger will be updated to
  ## remove this function.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the function which should be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589085 = path.getOrDefault("name")
  valid_589085 = validateParameter(valid_589085, JString, required = true,
                                 default = nil)
  if valid_589085 != nil:
    section.add "name", valid_589085
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
  var valid_589086 = query.getOrDefault("upload_protocol")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "upload_protocol", valid_589086
  var valid_589087 = query.getOrDefault("fields")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "fields", valid_589087
  var valid_589088 = query.getOrDefault("quotaUser")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "quotaUser", valid_589088
  var valid_589089 = query.getOrDefault("alt")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = newJString("json"))
  if valid_589089 != nil:
    section.add "alt", valid_589089
  var valid_589090 = query.getOrDefault("oauth_token")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "oauth_token", valid_589090
  var valid_589091 = query.getOrDefault("callback")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "callback", valid_589091
  var valid_589092 = query.getOrDefault("access_token")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "access_token", valid_589092
  var valid_589093 = query.getOrDefault("uploadType")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "uploadType", valid_589093
  var valid_589094 = query.getOrDefault("key")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "key", valid_589094
  var valid_589095 = query.getOrDefault("$.xgafv")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = newJString("1"))
  if valid_589095 != nil:
    section.add "$.xgafv", valid_589095
  var valid_589096 = query.getOrDefault("prettyPrint")
  valid_589096 = validateParameter(valid_589096, JBool, required = false,
                                 default = newJBool(true))
  if valid_589096 != nil:
    section.add "prettyPrint", valid_589096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589097: Call_CloudfunctionsProjectsLocationsFunctionsDelete_589082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a function with the given name from the specified project. If the
  ## given function is used by some trigger, the trigger will be updated to
  ## remove this function.
  ## 
  let valid = call_589097.validator(path, query, header, formData, body)
  let scheme = call_589097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589097.url(scheme.get, call_589097.host, call_589097.base,
                         call_589097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589097, url, valid)

proc call*(call_589098: Call_CloudfunctionsProjectsLocationsFunctionsDelete_589082;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudfunctionsProjectsLocationsFunctionsDelete
  ## Deletes a function with the given name from the specified project. If the
  ## given function is used by some trigger, the trigger will be updated to
  ## remove this function.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the function which should be deleted.
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
  var path_589099 = newJObject()
  var query_589100 = newJObject()
  add(query_589100, "upload_protocol", newJString(uploadProtocol))
  add(query_589100, "fields", newJString(fields))
  add(query_589100, "quotaUser", newJString(quotaUser))
  add(path_589099, "name", newJString(name))
  add(query_589100, "alt", newJString(alt))
  add(query_589100, "oauth_token", newJString(oauthToken))
  add(query_589100, "callback", newJString(callback))
  add(query_589100, "access_token", newJString(accessToken))
  add(query_589100, "uploadType", newJString(uploadType))
  add(query_589100, "key", newJString(key))
  add(query_589100, "$.xgafv", newJString(Xgafv))
  add(query_589100, "prettyPrint", newJBool(prettyPrint))
  result = call_589098.call(path_589099, query_589100, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsDelete* = Call_CloudfunctionsProjectsLocationsFunctionsDelete_589082(
    name: "cloudfunctionsProjectsLocationsFunctionsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsDelete_589083,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsDelete_589084,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsList_589101 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsList_589103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsList_589102(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589104 = path.getOrDefault("name")
  valid_589104 = validateParameter(valid_589104, JString, required = true,
                                 default = nil)
  if valid_589104 != nil:
    section.add "name", valid_589104
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
  section = newJObject()
  var valid_589105 = query.getOrDefault("upload_protocol")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "upload_protocol", valid_589105
  var valid_589106 = query.getOrDefault("fields")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "fields", valid_589106
  var valid_589107 = query.getOrDefault("pageToken")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "pageToken", valid_589107
  var valid_589108 = query.getOrDefault("quotaUser")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "quotaUser", valid_589108
  var valid_589109 = query.getOrDefault("alt")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = newJString("json"))
  if valid_589109 != nil:
    section.add "alt", valid_589109
  var valid_589110 = query.getOrDefault("oauth_token")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "oauth_token", valid_589110
  var valid_589111 = query.getOrDefault("callback")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "callback", valid_589111
  var valid_589112 = query.getOrDefault("access_token")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "access_token", valid_589112
  var valid_589113 = query.getOrDefault("uploadType")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "uploadType", valid_589113
  var valid_589114 = query.getOrDefault("key")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "key", valid_589114
  var valid_589115 = query.getOrDefault("$.xgafv")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = newJString("1"))
  if valid_589115 != nil:
    section.add "$.xgafv", valid_589115
  var valid_589116 = query.getOrDefault("pageSize")
  valid_589116 = validateParameter(valid_589116, JInt, required = false, default = nil)
  if valid_589116 != nil:
    section.add "pageSize", valid_589116
  var valid_589117 = query.getOrDefault("prettyPrint")
  valid_589117 = validateParameter(valid_589117, JBool, required = false,
                                 default = newJBool(true))
  if valid_589117 != nil:
    section.add "prettyPrint", valid_589117
  var valid_589118 = query.getOrDefault("filter")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "filter", valid_589118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589119: Call_CloudfunctionsProjectsLocationsList_589101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_589119.validator(path, query, header, formData, body)
  let scheme = call_589119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589119.url(scheme.get, call_589119.host, call_589119.base,
                         call_589119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589119, url, valid)

proc call*(call_589120: Call_CloudfunctionsProjectsLocationsList_589101;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudfunctionsProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
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
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_589121 = newJObject()
  var query_589122 = newJObject()
  add(query_589122, "upload_protocol", newJString(uploadProtocol))
  add(query_589122, "fields", newJString(fields))
  add(query_589122, "pageToken", newJString(pageToken))
  add(query_589122, "quotaUser", newJString(quotaUser))
  add(path_589121, "name", newJString(name))
  add(query_589122, "alt", newJString(alt))
  add(query_589122, "oauth_token", newJString(oauthToken))
  add(query_589122, "callback", newJString(callback))
  add(query_589122, "access_token", newJString(accessToken))
  add(query_589122, "uploadType", newJString(uploadType))
  add(query_589122, "key", newJString(key))
  add(query_589122, "$.xgafv", newJString(Xgafv))
  add(query_589122, "pageSize", newJInt(pageSize))
  add(query_589122, "prettyPrint", newJBool(prettyPrint))
  add(query_589122, "filter", newJString(filter))
  result = call_589120.call(path_589121, query_589122, nil, nil, nil)

var cloudfunctionsProjectsLocationsList* = Call_CloudfunctionsProjectsLocationsList_589101(
    name: "cloudfunctionsProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1beta2/{name}/locations",
    validator: validate_CloudfunctionsProjectsLocationsList_589102, base: "/",
    url: url_CloudfunctionsProjectsLocationsList_589103, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsCall_589123 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsCall_589125(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":call")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsCall_589124(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Synchronously invokes a deployed Cloud Function. To be used for testing
  ## purposes as very limited traffic is allowed. For more information on
  ## the actual limits refer to [API Calls](
  ## https://cloud.google.com/functions/quotas#rate_limits).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the function to be called.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589126 = path.getOrDefault("name")
  valid_589126 = validateParameter(valid_589126, JString, required = true,
                                 default = nil)
  if valid_589126 != nil:
    section.add "name", valid_589126
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
  var valid_589127 = query.getOrDefault("upload_protocol")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "upload_protocol", valid_589127
  var valid_589128 = query.getOrDefault("fields")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "fields", valid_589128
  var valid_589129 = query.getOrDefault("quotaUser")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "quotaUser", valid_589129
  var valid_589130 = query.getOrDefault("alt")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = newJString("json"))
  if valid_589130 != nil:
    section.add "alt", valid_589130
  var valid_589131 = query.getOrDefault("oauth_token")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "oauth_token", valid_589131
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
  var valid_589134 = query.getOrDefault("uploadType")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "uploadType", valid_589134
  var valid_589135 = query.getOrDefault("key")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "key", valid_589135
  var valid_589136 = query.getOrDefault("$.xgafv")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = newJString("1"))
  if valid_589136 != nil:
    section.add "$.xgafv", valid_589136
  var valid_589137 = query.getOrDefault("prettyPrint")
  valid_589137 = validateParameter(valid_589137, JBool, required = false,
                                 default = newJBool(true))
  if valid_589137 != nil:
    section.add "prettyPrint", valid_589137
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

proc call*(call_589139: Call_CloudfunctionsProjectsLocationsFunctionsCall_589123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Synchronously invokes a deployed Cloud Function. To be used for testing
  ## purposes as very limited traffic is allowed. For more information on
  ## the actual limits refer to [API Calls](
  ## https://cloud.google.com/functions/quotas#rate_limits).
  ## 
  let valid = call_589139.validator(path, query, header, formData, body)
  let scheme = call_589139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589139.url(scheme.get, call_589139.host, call_589139.base,
                         call_589139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589139, url, valid)

proc call*(call_589140: Call_CloudfunctionsProjectsLocationsFunctionsCall_589123;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudfunctionsProjectsLocationsFunctionsCall
  ## Synchronously invokes a deployed Cloud Function. To be used for testing
  ## purposes as very limited traffic is allowed. For more information on
  ## the actual limits refer to [API Calls](
  ## https://cloud.google.com/functions/quotas#rate_limits).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the function to be called.
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
  var path_589141 = newJObject()
  var query_589142 = newJObject()
  var body_589143 = newJObject()
  add(query_589142, "upload_protocol", newJString(uploadProtocol))
  add(query_589142, "fields", newJString(fields))
  add(query_589142, "quotaUser", newJString(quotaUser))
  add(path_589141, "name", newJString(name))
  add(query_589142, "alt", newJString(alt))
  add(query_589142, "oauth_token", newJString(oauthToken))
  add(query_589142, "callback", newJString(callback))
  add(query_589142, "access_token", newJString(accessToken))
  add(query_589142, "uploadType", newJString(uploadType))
  add(query_589142, "key", newJString(key))
  add(query_589142, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589143 = body
  add(query_589142, "prettyPrint", newJBool(prettyPrint))
  result = call_589140.call(path_589141, query_589142, nil, nil, body_589143)

var cloudfunctionsProjectsLocationsFunctionsCall* = Call_CloudfunctionsProjectsLocationsFunctionsCall_589123(
    name: "cloudfunctionsProjectsLocationsFunctionsCall",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{name}:call",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsCall_589124,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsCall_589125,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589144 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589146(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":generateDownloadUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589145(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns a signed URL for downloading deployed function source code.
  ## The URL is only valid for a limited period and should be used within
  ## minutes after generation.
  ## For more information about the signed URL usage see:
  ## https://cloud.google.com/storage/docs/access-control/signed-urls
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of function for which source code Google Cloud Storage signed
  ## URL should be generated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589147 = path.getOrDefault("name")
  valid_589147 = validateParameter(valid_589147, JString, required = true,
                                 default = nil)
  if valid_589147 != nil:
    section.add "name", valid_589147
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
  var valid_589150 = query.getOrDefault("quotaUser")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "quotaUser", valid_589150
  var valid_589151 = query.getOrDefault("alt")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = newJString("json"))
  if valid_589151 != nil:
    section.add "alt", valid_589151
  var valid_589152 = query.getOrDefault("oauth_token")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "oauth_token", valid_589152
  var valid_589153 = query.getOrDefault("callback")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "callback", valid_589153
  var valid_589154 = query.getOrDefault("access_token")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "access_token", valid_589154
  var valid_589155 = query.getOrDefault("uploadType")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "uploadType", valid_589155
  var valid_589156 = query.getOrDefault("key")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "key", valid_589156
  var valid_589157 = query.getOrDefault("$.xgafv")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = newJString("1"))
  if valid_589157 != nil:
    section.add "$.xgafv", valid_589157
  var valid_589158 = query.getOrDefault("prettyPrint")
  valid_589158 = validateParameter(valid_589158, JBool, required = false,
                                 default = newJBool(true))
  if valid_589158 != nil:
    section.add "prettyPrint", valid_589158
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

proc call*(call_589160: Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a signed URL for downloading deployed function source code.
  ## The URL is only valid for a limited period and should be used within
  ## minutes after generation.
  ## For more information about the signed URL usage see:
  ## https://cloud.google.com/storage/docs/access-control/signed-urls
  ## 
  let valid = call_589160.validator(path, query, header, formData, body)
  let scheme = call_589160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589160.url(scheme.get, call_589160.host, call_589160.base,
                         call_589160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589160, url, valid)

proc call*(call_589161: Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589144;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl
  ## Returns a signed URL for downloading deployed function source code.
  ## The URL is only valid for a limited period and should be used within
  ## minutes after generation.
  ## For more information about the signed URL usage see:
  ## https://cloud.google.com/storage/docs/access-control/signed-urls
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of function for which source code Google Cloud Storage signed
  ## URL should be generated.
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
  var path_589162 = newJObject()
  var query_589163 = newJObject()
  var body_589164 = newJObject()
  add(query_589163, "upload_protocol", newJString(uploadProtocol))
  add(query_589163, "fields", newJString(fields))
  add(query_589163, "quotaUser", newJString(quotaUser))
  add(path_589162, "name", newJString(name))
  add(query_589163, "alt", newJString(alt))
  add(query_589163, "oauth_token", newJString(oauthToken))
  add(query_589163, "callback", newJString(callback))
  add(query_589163, "access_token", newJString(accessToken))
  add(query_589163, "uploadType", newJString(uploadType))
  add(query_589163, "key", newJString(key))
  add(query_589163, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589164 = body
  add(query_589163, "prettyPrint", newJBool(prettyPrint))
  result = call_589161.call(path_589162, query_589163, nil, nil, body_589164)

var cloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl* = Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589144(
    name: "cloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{name}:generateDownloadUrl", validator: validate_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589145,
    base: "/",
    url: url_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589146,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589165 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589167(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/functions:generateUploadUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589166(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns a signed URL for uploading a function source code.
  ## For more information about the signed URL usage see:
  ## https://cloud.google.com/storage/docs/access-control/signed-urls
  ## Once the function source code upload is complete, the used signed
  ## URL should be provided in CreateFunction or UpdateFunction request
  ## as a reference to the function source code.
  ## 
  ## When uploading source code to the generated signed URL, please follow
  ## these restrictions:
  ## 
  ## * Source file type should be a zip file.
  ## * Source file size should not exceed 100MB limit.
  ## * No credentials should be attached - the signed URLs provide access to the
  ##   target bucket using internal service identity; if credentials were
  ##   attached, the identity from the credentials would be used, but that
  ##   identity does not have permissions to upload files to the URL.
  ## 
  ## When making a HTTP PUT request, these two headers need to be specified:
  ## 
  ## * `content-type: application/zip`
  ## * `x-goog-content-length-range: 0,104857600`
  ## 
  ## And this header SHOULD NOT be specified:
  ## 
  ## * `Authorization: Bearer YOUR_TOKEN`
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project and location in which the Google Cloud Storage signed URL
  ## should be generated, specified in the format `projects/*/locations/*`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589168 = path.getOrDefault("parent")
  valid_589168 = validateParameter(valid_589168, JString, required = true,
                                 default = nil)
  if valid_589168 != nil:
    section.add "parent", valid_589168
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
  var valid_589169 = query.getOrDefault("upload_protocol")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "upload_protocol", valid_589169
  var valid_589170 = query.getOrDefault("fields")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "fields", valid_589170
  var valid_589171 = query.getOrDefault("quotaUser")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "quotaUser", valid_589171
  var valid_589172 = query.getOrDefault("alt")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = newJString("json"))
  if valid_589172 != nil:
    section.add "alt", valid_589172
  var valid_589173 = query.getOrDefault("oauth_token")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "oauth_token", valid_589173
  var valid_589174 = query.getOrDefault("callback")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "callback", valid_589174
  var valid_589175 = query.getOrDefault("access_token")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "access_token", valid_589175
  var valid_589176 = query.getOrDefault("uploadType")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "uploadType", valid_589176
  var valid_589177 = query.getOrDefault("key")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "key", valid_589177
  var valid_589178 = query.getOrDefault("$.xgafv")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = newJString("1"))
  if valid_589178 != nil:
    section.add "$.xgafv", valid_589178
  var valid_589179 = query.getOrDefault("prettyPrint")
  valid_589179 = validateParameter(valid_589179, JBool, required = false,
                                 default = newJBool(true))
  if valid_589179 != nil:
    section.add "prettyPrint", valid_589179
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

proc call*(call_589181: Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a signed URL for uploading a function source code.
  ## For more information about the signed URL usage see:
  ## https://cloud.google.com/storage/docs/access-control/signed-urls
  ## Once the function source code upload is complete, the used signed
  ## URL should be provided in CreateFunction or UpdateFunction request
  ## as a reference to the function source code.
  ## 
  ## When uploading source code to the generated signed URL, please follow
  ## these restrictions:
  ## 
  ## * Source file type should be a zip file.
  ## * Source file size should not exceed 100MB limit.
  ## * No credentials should be attached - the signed URLs provide access to the
  ##   target bucket using internal service identity; if credentials were
  ##   attached, the identity from the credentials would be used, but that
  ##   identity does not have permissions to upload files to the URL.
  ## 
  ## When making a HTTP PUT request, these two headers need to be specified:
  ## 
  ## * `content-type: application/zip`
  ## * `x-goog-content-length-range: 0,104857600`
  ## 
  ## And this header SHOULD NOT be specified:
  ## 
  ## * `Authorization: Bearer YOUR_TOKEN`
  ## 
  let valid = call_589181.validator(path, query, header, formData, body)
  let scheme = call_589181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589181.url(scheme.get, call_589181.host, call_589181.base,
                         call_589181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589181, url, valid)

proc call*(call_589182: Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589165;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl
  ## Returns a signed URL for uploading a function source code.
  ## For more information about the signed URL usage see:
  ## https://cloud.google.com/storage/docs/access-control/signed-urls
  ## Once the function source code upload is complete, the used signed
  ## URL should be provided in CreateFunction or UpdateFunction request
  ## as a reference to the function source code.
  ## 
  ## When uploading source code to the generated signed URL, please follow
  ## these restrictions:
  ## 
  ## * Source file type should be a zip file.
  ## * Source file size should not exceed 100MB limit.
  ## * No credentials should be attached - the signed URLs provide access to the
  ##   target bucket using internal service identity; if credentials were
  ##   attached, the identity from the credentials would be used, but that
  ##   identity does not have permissions to upload files to the URL.
  ## 
  ## When making a HTTP PUT request, these two headers need to be specified:
  ## 
  ## * `content-type: application/zip`
  ## * `x-goog-content-length-range: 0,104857600`
  ## 
  ## And this header SHOULD NOT be specified:
  ## 
  ## * `Authorization: Bearer YOUR_TOKEN`
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
  ##         : The project and location in which the Google Cloud Storage signed URL
  ## should be generated, specified in the format `projects/*/locations/*`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589183 = newJObject()
  var query_589184 = newJObject()
  var body_589185 = newJObject()
  add(query_589184, "upload_protocol", newJString(uploadProtocol))
  add(query_589184, "fields", newJString(fields))
  add(query_589184, "quotaUser", newJString(quotaUser))
  add(query_589184, "alt", newJString(alt))
  add(query_589184, "oauth_token", newJString(oauthToken))
  add(query_589184, "callback", newJString(callback))
  add(query_589184, "access_token", newJString(accessToken))
  add(query_589184, "uploadType", newJString(uploadType))
  add(path_589183, "parent", newJString(parent))
  add(query_589184, "key", newJString(key))
  add(query_589184, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589185 = body
  add(query_589184, "prettyPrint", newJBool(prettyPrint))
  result = call_589182.call(path_589183, query_589184, nil, nil, body_589185)

var cloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl* = Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589165(
    name: "cloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{parent}/functions:generateUploadUrl", validator: validate_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589166,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589167,
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
