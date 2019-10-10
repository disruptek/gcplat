
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Functions
## version: v1
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
    host: "cloudfunctions.googleapis.com", route: "/v1/operations",
    validator: validate_CloudfunctionsOperationsList_588711, base: "/",
    url: url_CloudfunctionsOperationsList_588712, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsCreate_588986 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsCreate_588988(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/functions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsCreate_588987(
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
  var valid_589006 = query.getOrDefault("quotaUser")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "quotaUser", valid_589006
  var valid_589007 = query.getOrDefault("alt")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = newJString("json"))
  if valid_589007 != nil:
    section.add "alt", valid_589007
  var valid_589008 = query.getOrDefault("oauth_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "oauth_token", valid_589008
  var valid_589009 = query.getOrDefault("callback")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "callback", valid_589009
  var valid_589010 = query.getOrDefault("access_token")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "access_token", valid_589010
  var valid_589011 = query.getOrDefault("uploadType")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "uploadType", valid_589011
  var valid_589012 = query.getOrDefault("key")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "key", valid_589012
  var valid_589013 = query.getOrDefault("$.xgafv")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = newJString("1"))
  if valid_589013 != nil:
    section.add "$.xgafv", valid_589013
  var valid_589014 = query.getOrDefault("prettyPrint")
  valid_589014 = validateParameter(valid_589014, JBool, required = false,
                                 default = newJBool(true))
  if valid_589014 != nil:
    section.add "prettyPrint", valid_589014
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

proc call*(call_589016: Call_CloudfunctionsProjectsLocationsFunctionsCreate_588986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new function. If a function with the given name already exists in
  ## the specified project, the long running operation will return
  ## `ALREADY_EXISTS` error.
  ## 
  let valid = call_589016.validator(path, query, header, formData, body)
  let scheme = call_589016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589016.url(scheme.get, call_589016.host, call_589016.base,
                         call_589016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589016, url, valid)

proc call*(call_589017: Call_CloudfunctionsProjectsLocationsFunctionsCreate_588986;
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
  var path_589018 = newJObject()
  var query_589019 = newJObject()
  var body_589020 = newJObject()
  add(query_589019, "upload_protocol", newJString(uploadProtocol))
  add(query_589019, "fields", newJString(fields))
  add(query_589019, "quotaUser", newJString(quotaUser))
  add(query_589019, "alt", newJString(alt))
  add(query_589019, "oauth_token", newJString(oauthToken))
  add(query_589019, "callback", newJString(callback))
  add(query_589019, "access_token", newJString(accessToken))
  add(query_589019, "uploadType", newJString(uploadType))
  add(query_589019, "key", newJString(key))
  add(query_589019, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589020 = body
  add(query_589019, "prettyPrint", newJBool(prettyPrint))
  add(path_589018, "location", newJString(location))
  result = call_589017.call(path_589018, query_589019, nil, nil, body_589020)

var cloudfunctionsProjectsLocationsFunctionsCreate* = Call_CloudfunctionsProjectsLocationsFunctionsCreate_588986(
    name: "cloudfunctionsProjectsLocationsFunctionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{location}/functions",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsCreate_588987,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsCreate_588988,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsOperationsGet_589021 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsOperationsGet_589023(protocol: Scheme; host: string;
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

proc validate_CloudfunctionsOperationsGet_589022(path: JsonNode; query: JsonNode;
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
  var valid_589024 = path.getOrDefault("name")
  valid_589024 = validateParameter(valid_589024, JString, required = true,
                                 default = nil)
  if valid_589024 != nil:
    section.add "name", valid_589024
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
  if body != nil:
    result.add "body", body

proc call*(call_589036: Call_CloudfunctionsOperationsGet_589021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_589036.validator(path, query, header, formData, body)
  let scheme = call_589036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589036.url(scheme.get, call_589036.host, call_589036.base,
                         call_589036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589036, url, valid)

proc call*(call_589037: Call_CloudfunctionsOperationsGet_589021; name: string;
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
  var path_589038 = newJObject()
  var query_589039 = newJObject()
  add(query_589039, "upload_protocol", newJString(uploadProtocol))
  add(query_589039, "fields", newJString(fields))
  add(query_589039, "quotaUser", newJString(quotaUser))
  add(path_589038, "name", newJString(name))
  add(query_589039, "alt", newJString(alt))
  add(query_589039, "oauth_token", newJString(oauthToken))
  add(query_589039, "callback", newJString(callback))
  add(query_589039, "access_token", newJString(accessToken))
  add(query_589039, "uploadType", newJString(uploadType))
  add(query_589039, "key", newJString(key))
  add(query_589039, "$.xgafv", newJString(Xgafv))
  add(query_589039, "prettyPrint", newJBool(prettyPrint))
  result = call_589037.call(path_589038, query_589039, nil, nil, nil)

var cloudfunctionsOperationsGet* = Call_CloudfunctionsOperationsGet_589021(
    name: "cloudfunctionsOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudfunctionsOperationsGet_589022, base: "/",
    url: url_CloudfunctionsOperationsGet_589023, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsPatch_589059 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsPatch_589061(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_CloudfunctionsProjectsLocationsFunctionsPatch_589060(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates existing function.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : A user-defined name of the function. Function names must be unique
  ## globally and match pattern `projects/*/locations/*/functions/*`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589062 = path.getOrDefault("name")
  valid_589062 = validateParameter(valid_589062, JString, required = true,
                                 default = nil)
  if valid_589062 != nil:
    section.add "name", valid_589062
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
  ##             : Required list of fields to be updated in this request.
  section = newJObject()
  var valid_589063 = query.getOrDefault("upload_protocol")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "upload_protocol", valid_589063
  var valid_589064 = query.getOrDefault("fields")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "fields", valid_589064
  var valid_589065 = query.getOrDefault("quotaUser")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "quotaUser", valid_589065
  var valid_589066 = query.getOrDefault("alt")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = newJString("json"))
  if valid_589066 != nil:
    section.add "alt", valid_589066
  var valid_589067 = query.getOrDefault("oauth_token")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "oauth_token", valid_589067
  var valid_589068 = query.getOrDefault("callback")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "callback", valid_589068
  var valid_589069 = query.getOrDefault("access_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "access_token", valid_589069
  var valid_589070 = query.getOrDefault("uploadType")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "uploadType", valid_589070
  var valid_589071 = query.getOrDefault("key")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "key", valid_589071
  var valid_589072 = query.getOrDefault("$.xgafv")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = newJString("1"))
  if valid_589072 != nil:
    section.add "$.xgafv", valid_589072
  var valid_589073 = query.getOrDefault("prettyPrint")
  valid_589073 = validateParameter(valid_589073, JBool, required = false,
                                 default = newJBool(true))
  if valid_589073 != nil:
    section.add "prettyPrint", valid_589073
  var valid_589074 = query.getOrDefault("updateMask")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "updateMask", valid_589074
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

proc call*(call_589076: Call_CloudfunctionsProjectsLocationsFunctionsPatch_589059;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates existing function.
  ## 
  let valid = call_589076.validator(path, query, header, formData, body)
  let scheme = call_589076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589076.url(scheme.get, call_589076.host, call_589076.base,
                         call_589076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589076, url, valid)

proc call*(call_589077: Call_CloudfunctionsProjectsLocationsFunctionsPatch_589059;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## cloudfunctionsProjectsLocationsFunctionsPatch
  ## Updates existing function.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : A user-defined name of the function. Function names must be unique
  ## globally and match pattern `projects/*/locations/*/functions/*`
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
  ##             : Required list of fields to be updated in this request.
  var path_589078 = newJObject()
  var query_589079 = newJObject()
  var body_589080 = newJObject()
  add(query_589079, "upload_protocol", newJString(uploadProtocol))
  add(query_589079, "fields", newJString(fields))
  add(query_589079, "quotaUser", newJString(quotaUser))
  add(path_589078, "name", newJString(name))
  add(query_589079, "alt", newJString(alt))
  add(query_589079, "oauth_token", newJString(oauthToken))
  add(query_589079, "callback", newJString(callback))
  add(query_589079, "access_token", newJString(accessToken))
  add(query_589079, "uploadType", newJString(uploadType))
  add(query_589079, "key", newJString(key))
  add(query_589079, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589080 = body
  add(query_589079, "prettyPrint", newJBool(prettyPrint))
  add(query_589079, "updateMask", newJString(updateMask))
  result = call_589077.call(path_589078, query_589079, nil, nil, body_589080)

var cloudfunctionsProjectsLocationsFunctionsPatch* = Call_CloudfunctionsProjectsLocationsFunctionsPatch_589059(
    name: "cloudfunctionsProjectsLocationsFunctionsPatch",
    meth: HttpMethod.HttpPatch, host: "cloudfunctions.googleapis.com",
    route: "/v1/{name}",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsPatch_589060,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsPatch_589061,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsDelete_589040 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsDelete_589042(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_CloudfunctionsProjectsLocationsFunctionsDelete_589041(
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
  var valid_589043 = path.getOrDefault("name")
  valid_589043 = validateParameter(valid_589043, JString, required = true,
                                 default = nil)
  if valid_589043 != nil:
    section.add "name", valid_589043
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
  var valid_589044 = query.getOrDefault("upload_protocol")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "upload_protocol", valid_589044
  var valid_589045 = query.getOrDefault("fields")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "fields", valid_589045
  var valid_589046 = query.getOrDefault("quotaUser")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "quotaUser", valid_589046
  var valid_589047 = query.getOrDefault("alt")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("json"))
  if valid_589047 != nil:
    section.add "alt", valid_589047
  var valid_589048 = query.getOrDefault("oauth_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "oauth_token", valid_589048
  var valid_589049 = query.getOrDefault("callback")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "callback", valid_589049
  var valid_589050 = query.getOrDefault("access_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "access_token", valid_589050
  var valid_589051 = query.getOrDefault("uploadType")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "uploadType", valid_589051
  var valid_589052 = query.getOrDefault("key")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "key", valid_589052
  var valid_589053 = query.getOrDefault("$.xgafv")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = newJString("1"))
  if valid_589053 != nil:
    section.add "$.xgafv", valid_589053
  var valid_589054 = query.getOrDefault("prettyPrint")
  valid_589054 = validateParameter(valid_589054, JBool, required = false,
                                 default = newJBool(true))
  if valid_589054 != nil:
    section.add "prettyPrint", valid_589054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589055: Call_CloudfunctionsProjectsLocationsFunctionsDelete_589040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a function with the given name from the specified project. If the
  ## given function is used by some trigger, the trigger will be updated to
  ## remove this function.
  ## 
  let valid = call_589055.validator(path, query, header, formData, body)
  let scheme = call_589055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589055.url(scheme.get, call_589055.host, call_589055.base,
                         call_589055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589055, url, valid)

proc call*(call_589056: Call_CloudfunctionsProjectsLocationsFunctionsDelete_589040;
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
  var path_589057 = newJObject()
  var query_589058 = newJObject()
  add(query_589058, "upload_protocol", newJString(uploadProtocol))
  add(query_589058, "fields", newJString(fields))
  add(query_589058, "quotaUser", newJString(quotaUser))
  add(path_589057, "name", newJString(name))
  add(query_589058, "alt", newJString(alt))
  add(query_589058, "oauth_token", newJString(oauthToken))
  add(query_589058, "callback", newJString(callback))
  add(query_589058, "access_token", newJString(accessToken))
  add(query_589058, "uploadType", newJString(uploadType))
  add(query_589058, "key", newJString(key))
  add(query_589058, "$.xgafv", newJString(Xgafv))
  add(query_589058, "prettyPrint", newJBool(prettyPrint))
  result = call_589056.call(path_589057, query_589058, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsDelete* = Call_CloudfunctionsProjectsLocationsFunctionsDelete_589040(
    name: "cloudfunctionsProjectsLocationsFunctionsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudfunctions.googleapis.com",
    route: "/v1/{name}",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsDelete_589041,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsDelete_589042,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsList_589081 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsList_589083(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsList_589082(path: JsonNode;
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
  var valid_589084 = path.getOrDefault("name")
  valid_589084 = validateParameter(valid_589084, JString, required = true,
                                 default = nil)
  if valid_589084 != nil:
    section.add "name", valid_589084
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
  var valid_589085 = query.getOrDefault("upload_protocol")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "upload_protocol", valid_589085
  var valid_589086 = query.getOrDefault("fields")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "fields", valid_589086
  var valid_589087 = query.getOrDefault("pageToken")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "pageToken", valid_589087
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
  var valid_589096 = query.getOrDefault("pageSize")
  valid_589096 = validateParameter(valid_589096, JInt, required = false, default = nil)
  if valid_589096 != nil:
    section.add "pageSize", valid_589096
  var valid_589097 = query.getOrDefault("prettyPrint")
  valid_589097 = validateParameter(valid_589097, JBool, required = false,
                                 default = newJBool(true))
  if valid_589097 != nil:
    section.add "prettyPrint", valid_589097
  var valid_589098 = query.getOrDefault("filter")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "filter", valid_589098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589099: Call_CloudfunctionsProjectsLocationsList_589081;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_589099.validator(path, query, header, formData, body)
  let scheme = call_589099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589099.url(scheme.get, call_589099.host, call_589099.base,
                         call_589099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589099, url, valid)

proc call*(call_589100: Call_CloudfunctionsProjectsLocationsList_589081;
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
  var path_589101 = newJObject()
  var query_589102 = newJObject()
  add(query_589102, "upload_protocol", newJString(uploadProtocol))
  add(query_589102, "fields", newJString(fields))
  add(query_589102, "pageToken", newJString(pageToken))
  add(query_589102, "quotaUser", newJString(quotaUser))
  add(path_589101, "name", newJString(name))
  add(query_589102, "alt", newJString(alt))
  add(query_589102, "oauth_token", newJString(oauthToken))
  add(query_589102, "callback", newJString(callback))
  add(query_589102, "access_token", newJString(accessToken))
  add(query_589102, "uploadType", newJString(uploadType))
  add(query_589102, "key", newJString(key))
  add(query_589102, "$.xgafv", newJString(Xgafv))
  add(query_589102, "pageSize", newJInt(pageSize))
  add(query_589102, "prettyPrint", newJBool(prettyPrint))
  add(query_589102, "filter", newJString(filter))
  result = call_589100.call(path_589101, query_589102, nil, nil, nil)

var cloudfunctionsProjectsLocationsList* = Call_CloudfunctionsProjectsLocationsList_589081(
    name: "cloudfunctionsProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_CloudfunctionsProjectsLocationsList_589082, base: "/",
    url: url_CloudfunctionsProjectsLocationsList_589083, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsCall_589103 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsCall_589105(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":call")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsCall_589104(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Synchronously invokes a deployed Cloud Function. To be used for testing
  ## purposes as very limited traffic is allowed. For more information on
  ## the actual limits, refer to
  ## [Rate Limits](https://cloud.google.com/functions/quotas#rate_limits).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the function to be called.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589106 = path.getOrDefault("name")
  valid_589106 = validateParameter(valid_589106, JString, required = true,
                                 default = nil)
  if valid_589106 != nil:
    section.add "name", valid_589106
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
  var valid_589107 = query.getOrDefault("upload_protocol")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "upload_protocol", valid_589107
  var valid_589108 = query.getOrDefault("fields")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "fields", valid_589108
  var valid_589109 = query.getOrDefault("quotaUser")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "quotaUser", valid_589109
  var valid_589110 = query.getOrDefault("alt")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = newJString("json"))
  if valid_589110 != nil:
    section.add "alt", valid_589110
  var valid_589111 = query.getOrDefault("oauth_token")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "oauth_token", valid_589111
  var valid_589112 = query.getOrDefault("callback")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "callback", valid_589112
  var valid_589113 = query.getOrDefault("access_token")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "access_token", valid_589113
  var valid_589114 = query.getOrDefault("uploadType")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "uploadType", valid_589114
  var valid_589115 = query.getOrDefault("key")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "key", valid_589115
  var valid_589116 = query.getOrDefault("$.xgafv")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = newJString("1"))
  if valid_589116 != nil:
    section.add "$.xgafv", valid_589116
  var valid_589117 = query.getOrDefault("prettyPrint")
  valid_589117 = validateParameter(valid_589117, JBool, required = false,
                                 default = newJBool(true))
  if valid_589117 != nil:
    section.add "prettyPrint", valid_589117
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

proc call*(call_589119: Call_CloudfunctionsProjectsLocationsFunctionsCall_589103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Synchronously invokes a deployed Cloud Function. To be used for testing
  ## purposes as very limited traffic is allowed. For more information on
  ## the actual limits, refer to
  ## [Rate Limits](https://cloud.google.com/functions/quotas#rate_limits).
  ## 
  let valid = call_589119.validator(path, query, header, formData, body)
  let scheme = call_589119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589119.url(scheme.get, call_589119.host, call_589119.base,
                         call_589119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589119, url, valid)

proc call*(call_589120: Call_CloudfunctionsProjectsLocationsFunctionsCall_589103;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudfunctionsProjectsLocationsFunctionsCall
  ## Synchronously invokes a deployed Cloud Function. To be used for testing
  ## purposes as very limited traffic is allowed. For more information on
  ## the actual limits, refer to
  ## [Rate Limits](https://cloud.google.com/functions/quotas#rate_limits).
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
  var path_589121 = newJObject()
  var query_589122 = newJObject()
  var body_589123 = newJObject()
  add(query_589122, "upload_protocol", newJString(uploadProtocol))
  add(query_589122, "fields", newJString(fields))
  add(query_589122, "quotaUser", newJString(quotaUser))
  add(path_589121, "name", newJString(name))
  add(query_589122, "alt", newJString(alt))
  add(query_589122, "oauth_token", newJString(oauthToken))
  add(query_589122, "callback", newJString(callback))
  add(query_589122, "access_token", newJString(accessToken))
  add(query_589122, "uploadType", newJString(uploadType))
  add(query_589122, "key", newJString(key))
  add(query_589122, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589123 = body
  add(query_589122, "prettyPrint", newJBool(prettyPrint))
  result = call_589120.call(path_589121, query_589122, nil, nil, body_589123)

var cloudfunctionsProjectsLocationsFunctionsCall* = Call_CloudfunctionsProjectsLocationsFunctionsCall_589103(
    name: "cloudfunctionsProjectsLocationsFunctionsCall",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{name}:call",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsCall_589104,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsCall_589105,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589124 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589126(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":generateDownloadUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589125(
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
  var valid_589127 = path.getOrDefault("name")
  valid_589127 = validateParameter(valid_589127, JString, required = true,
                                 default = nil)
  if valid_589127 != nil:
    section.add "name", valid_589127
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
  var valid_589128 = query.getOrDefault("upload_protocol")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "upload_protocol", valid_589128
  var valid_589129 = query.getOrDefault("fields")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "fields", valid_589129
  var valid_589130 = query.getOrDefault("quotaUser")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "quotaUser", valid_589130
  var valid_589131 = query.getOrDefault("alt")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = newJString("json"))
  if valid_589131 != nil:
    section.add "alt", valid_589131
  var valid_589132 = query.getOrDefault("oauth_token")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "oauth_token", valid_589132
  var valid_589133 = query.getOrDefault("callback")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "callback", valid_589133
  var valid_589134 = query.getOrDefault("access_token")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "access_token", valid_589134
  var valid_589135 = query.getOrDefault("uploadType")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "uploadType", valid_589135
  var valid_589136 = query.getOrDefault("key")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "key", valid_589136
  var valid_589137 = query.getOrDefault("$.xgafv")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = newJString("1"))
  if valid_589137 != nil:
    section.add "$.xgafv", valid_589137
  var valid_589138 = query.getOrDefault("prettyPrint")
  valid_589138 = validateParameter(valid_589138, JBool, required = false,
                                 default = newJBool(true))
  if valid_589138 != nil:
    section.add "prettyPrint", valid_589138
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

proc call*(call_589140: Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a signed URL for downloading deployed function source code.
  ## The URL is only valid for a limited period and should be used within
  ## minutes after generation.
  ## For more information about the signed URL usage see:
  ## https://cloud.google.com/storage/docs/access-control/signed-urls
  ## 
  let valid = call_589140.validator(path, query, header, formData, body)
  let scheme = call_589140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589140.url(scheme.get, call_589140.host, call_589140.base,
                         call_589140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589140, url, valid)

proc call*(call_589141: Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589124;
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
  var path_589142 = newJObject()
  var query_589143 = newJObject()
  var body_589144 = newJObject()
  add(query_589143, "upload_protocol", newJString(uploadProtocol))
  add(query_589143, "fields", newJString(fields))
  add(query_589143, "quotaUser", newJString(quotaUser))
  add(path_589142, "name", newJString(name))
  add(query_589143, "alt", newJString(alt))
  add(query_589143, "oauth_token", newJString(oauthToken))
  add(query_589143, "callback", newJString(callback))
  add(query_589143, "access_token", newJString(accessToken))
  add(query_589143, "uploadType", newJString(uploadType))
  add(query_589143, "key", newJString(key))
  add(query_589143, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589144 = body
  add(query_589143, "prettyPrint", newJBool(prettyPrint))
  result = call_589141.call(path_589142, query_589143, nil, nil, body_589144)

var cloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl* = Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589124(
    name: "cloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{name}:generateDownloadUrl", validator: validate_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589125,
    base: "/",
    url: url_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_589126,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsList_589145 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsList_589147(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/functions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsList_589146(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of functions that belong to the requested project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project and location from which the function should be listed,
  ## specified in the format `projects/*/locations/*`
  ## If you want to list functions in all locations, use "-" in place of a
  ## location.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589148 = path.getOrDefault("parent")
  valid_589148 = validateParameter(valid_589148, JString, required = true,
                                 default = nil)
  if valid_589148 != nil:
    section.add "parent", valid_589148
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
  var valid_589149 = query.getOrDefault("upload_protocol")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "upload_protocol", valid_589149
  var valid_589150 = query.getOrDefault("fields")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "fields", valid_589150
  var valid_589151 = query.getOrDefault("pageToken")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "pageToken", valid_589151
  var valid_589152 = query.getOrDefault("quotaUser")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "quotaUser", valid_589152
  var valid_589153 = query.getOrDefault("alt")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = newJString("json"))
  if valid_589153 != nil:
    section.add "alt", valid_589153
  var valid_589154 = query.getOrDefault("oauth_token")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "oauth_token", valid_589154
  var valid_589155 = query.getOrDefault("callback")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "callback", valid_589155
  var valid_589156 = query.getOrDefault("access_token")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "access_token", valid_589156
  var valid_589157 = query.getOrDefault("uploadType")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "uploadType", valid_589157
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589162: Call_CloudfunctionsProjectsLocationsFunctionsList_589145;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of functions that belong to the requested project.
  ## 
  let valid = call_589162.validator(path, query, header, formData, body)
  let scheme = call_589162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589162.url(scheme.get, call_589162.host, call_589162.base,
                         call_589162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589162, url, valid)

proc call*(call_589163: Call_CloudfunctionsProjectsLocationsFunctionsList_589145;
          parent: string; uploadProtocol: string = ""; fields: string = "";
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
  ##   parent: string (required)
  ##         : The project and location from which the function should be listed,
  ## specified in the format `projects/*/locations/*`
  ## If you want to list functions in all locations, use "-" in place of a
  ## location.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of functions to return per call.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589164 = newJObject()
  var query_589165 = newJObject()
  add(query_589165, "upload_protocol", newJString(uploadProtocol))
  add(query_589165, "fields", newJString(fields))
  add(query_589165, "pageToken", newJString(pageToken))
  add(query_589165, "quotaUser", newJString(quotaUser))
  add(query_589165, "alt", newJString(alt))
  add(query_589165, "oauth_token", newJString(oauthToken))
  add(query_589165, "callback", newJString(callback))
  add(query_589165, "access_token", newJString(accessToken))
  add(query_589165, "uploadType", newJString(uploadType))
  add(path_589164, "parent", newJString(parent))
  add(query_589165, "key", newJString(key))
  add(query_589165, "$.xgafv", newJString(Xgafv))
  add(query_589165, "pageSize", newJInt(pageSize))
  add(query_589165, "prettyPrint", newJBool(prettyPrint))
  result = call_589163.call(path_589164, query_589165, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsList* = Call_CloudfunctionsProjectsLocationsFunctionsList_589145(
    name: "cloudfunctionsProjectsLocationsFunctionsList",
    meth: HttpMethod.HttpGet, host: "cloudfunctions.googleapis.com",
    route: "/v1/{parent}/functions",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsList_589146,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsList_589147,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589166 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589168(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/functions:generateUploadUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589167(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns a signed URL for uploading a function source code.
  ## For more information about the signed URL usage see:
  ## https://cloud.google.com/storage/docs/access-control/signed-urls.
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
  var valid_589169 = path.getOrDefault("parent")
  valid_589169 = validateParameter(valid_589169, JString, required = true,
                                 default = nil)
  if valid_589169 != nil:
    section.add "parent", valid_589169
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
  var valid_589170 = query.getOrDefault("upload_protocol")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "upload_protocol", valid_589170
  var valid_589171 = query.getOrDefault("fields")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "fields", valid_589171
  var valid_589172 = query.getOrDefault("quotaUser")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "quotaUser", valid_589172
  var valid_589173 = query.getOrDefault("alt")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = newJString("json"))
  if valid_589173 != nil:
    section.add "alt", valid_589173
  var valid_589174 = query.getOrDefault("oauth_token")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "oauth_token", valid_589174
  var valid_589175 = query.getOrDefault("callback")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "callback", valid_589175
  var valid_589176 = query.getOrDefault("access_token")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "access_token", valid_589176
  var valid_589177 = query.getOrDefault("uploadType")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "uploadType", valid_589177
  var valid_589178 = query.getOrDefault("key")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "key", valid_589178
  var valid_589179 = query.getOrDefault("$.xgafv")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = newJString("1"))
  if valid_589179 != nil:
    section.add "$.xgafv", valid_589179
  var valid_589180 = query.getOrDefault("prettyPrint")
  valid_589180 = validateParameter(valid_589180, JBool, required = false,
                                 default = newJBool(true))
  if valid_589180 != nil:
    section.add "prettyPrint", valid_589180
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

proc call*(call_589182: Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a signed URL for uploading a function source code.
  ## For more information about the signed URL usage see:
  ## https://cloud.google.com/storage/docs/access-control/signed-urls.
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
  let valid = call_589182.validator(path, query, header, formData, body)
  let scheme = call_589182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589182.url(scheme.get, call_589182.host, call_589182.base,
                         call_589182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589182, url, valid)

proc call*(call_589183: Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589166;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl
  ## Returns a signed URL for uploading a function source code.
  ## For more information about the signed URL usage see:
  ## https://cloud.google.com/storage/docs/access-control/signed-urls.
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
  var path_589184 = newJObject()
  var query_589185 = newJObject()
  var body_589186 = newJObject()
  add(query_589185, "upload_protocol", newJString(uploadProtocol))
  add(query_589185, "fields", newJString(fields))
  add(query_589185, "quotaUser", newJString(quotaUser))
  add(query_589185, "alt", newJString(alt))
  add(query_589185, "oauth_token", newJString(oauthToken))
  add(query_589185, "callback", newJString(callback))
  add(query_589185, "access_token", newJString(accessToken))
  add(query_589185, "uploadType", newJString(uploadType))
  add(path_589184, "parent", newJString(parent))
  add(query_589185, "key", newJString(key))
  add(query_589185, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589186 = body
  add(query_589185, "prettyPrint", newJBool(prettyPrint))
  result = call_589183.call(path_589184, query_589185, nil, nil, body_589186)

var cloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl* = Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589166(
    name: "cloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{parent}/functions:generateUploadUrl", validator: validate_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589167,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_589168,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_589187 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_589189(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_589188(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the IAM access control policy for a function.
  ## Returns an empty policy if the function exists and does not have a policy
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
  var valid_589190 = path.getOrDefault("resource")
  valid_589190 = validateParameter(valid_589190, JString, required = true,
                                 default = nil)
  if valid_589190 != nil:
    section.add "resource", valid_589190
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589191 = query.getOrDefault("upload_protocol")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "upload_protocol", valid_589191
  var valid_589192 = query.getOrDefault("fields")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "fields", valid_589192
  var valid_589193 = query.getOrDefault("quotaUser")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "quotaUser", valid_589193
  var valid_589194 = query.getOrDefault("alt")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = newJString("json"))
  if valid_589194 != nil:
    section.add "alt", valid_589194
  var valid_589195 = query.getOrDefault("oauth_token")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "oauth_token", valid_589195
  var valid_589196 = query.getOrDefault("callback")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "callback", valid_589196
  var valid_589197 = query.getOrDefault("access_token")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "access_token", valid_589197
  var valid_589198 = query.getOrDefault("uploadType")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "uploadType", valid_589198
  var valid_589199 = query.getOrDefault("options.requestedPolicyVersion")
  valid_589199 = validateParameter(valid_589199, JInt, required = false, default = nil)
  if valid_589199 != nil:
    section.add "options.requestedPolicyVersion", valid_589199
  var valid_589200 = query.getOrDefault("key")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "key", valid_589200
  var valid_589201 = query.getOrDefault("$.xgafv")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = newJString("1"))
  if valid_589201 != nil:
    section.add "$.xgafv", valid_589201
  var valid_589202 = query.getOrDefault("prettyPrint")
  valid_589202 = validateParameter(valid_589202, JBool, required = false,
                                 default = newJBool(true))
  if valid_589202 != nil:
    section.add "prettyPrint", valid_589202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589203: Call_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_589187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the IAM access control policy for a function.
  ## Returns an empty policy if the function exists and does not have a policy
  ## set.
  ## 
  let valid = call_589203.validator(path, query, header, formData, body)
  let scheme = call_589203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589203.url(scheme.get, call_589203.host, call_589203.base,
                         call_589203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589203, url, valid)

proc call*(call_589204: Call_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_589187;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## cloudfunctionsProjectsLocationsFunctionsGetIamPolicy
  ## Gets the IAM access control policy for a function.
  ## Returns an empty policy if the function exists and does not have a policy
  ## set.
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
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589205 = newJObject()
  var query_589206 = newJObject()
  add(query_589206, "upload_protocol", newJString(uploadProtocol))
  add(query_589206, "fields", newJString(fields))
  add(query_589206, "quotaUser", newJString(quotaUser))
  add(query_589206, "alt", newJString(alt))
  add(query_589206, "oauth_token", newJString(oauthToken))
  add(query_589206, "callback", newJString(callback))
  add(query_589206, "access_token", newJString(accessToken))
  add(query_589206, "uploadType", newJString(uploadType))
  add(query_589206, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_589206, "key", newJString(key))
  add(query_589206, "$.xgafv", newJString(Xgafv))
  add(path_589205, "resource", newJString(resource))
  add(query_589206, "prettyPrint", newJBool(prettyPrint))
  result = call_589204.call(path_589205, query_589206, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsGetIamPolicy* = Call_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_589187(
    name: "cloudfunctionsProjectsLocationsFunctionsGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "cloudfunctions.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_589188,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_589189,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_589207 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_589209(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_589208(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the IAM access control policy on the specified function.
  ## Replaces any existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589210 = path.getOrDefault("resource")
  valid_589210 = validateParameter(valid_589210, JString, required = true,
                                 default = nil)
  if valid_589210 != nil:
    section.add "resource", valid_589210
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
  var valid_589211 = query.getOrDefault("upload_protocol")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "upload_protocol", valid_589211
  var valid_589212 = query.getOrDefault("fields")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "fields", valid_589212
  var valid_589213 = query.getOrDefault("quotaUser")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "quotaUser", valid_589213
  var valid_589214 = query.getOrDefault("alt")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = newJString("json"))
  if valid_589214 != nil:
    section.add "alt", valid_589214
  var valid_589215 = query.getOrDefault("oauth_token")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "oauth_token", valid_589215
  var valid_589216 = query.getOrDefault("callback")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "callback", valid_589216
  var valid_589217 = query.getOrDefault("access_token")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "access_token", valid_589217
  var valid_589218 = query.getOrDefault("uploadType")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "uploadType", valid_589218
  var valid_589219 = query.getOrDefault("key")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "key", valid_589219
  var valid_589220 = query.getOrDefault("$.xgafv")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = newJString("1"))
  if valid_589220 != nil:
    section.add "$.xgafv", valid_589220
  var valid_589221 = query.getOrDefault("prettyPrint")
  valid_589221 = validateParameter(valid_589221, JBool, required = false,
                                 default = newJBool(true))
  if valid_589221 != nil:
    section.add "prettyPrint", valid_589221
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

proc call*(call_589223: Call_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_589207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM access control policy on the specified function.
  ## Replaces any existing policy.
  ## 
  let valid = call_589223.validator(path, query, header, formData, body)
  let scheme = call_589223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589223.url(scheme.get, call_589223.host, call_589223.base,
                         call_589223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589223, url, valid)

proc call*(call_589224: Call_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_589207;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudfunctionsProjectsLocationsFunctionsSetIamPolicy
  ## Sets the IAM access control policy on the specified function.
  ## Replaces any existing policy.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589225 = newJObject()
  var query_589226 = newJObject()
  var body_589227 = newJObject()
  add(query_589226, "upload_protocol", newJString(uploadProtocol))
  add(query_589226, "fields", newJString(fields))
  add(query_589226, "quotaUser", newJString(quotaUser))
  add(query_589226, "alt", newJString(alt))
  add(query_589226, "oauth_token", newJString(oauthToken))
  add(query_589226, "callback", newJString(callback))
  add(query_589226, "access_token", newJString(accessToken))
  add(query_589226, "uploadType", newJString(uploadType))
  add(query_589226, "key", newJString(key))
  add(query_589226, "$.xgafv", newJString(Xgafv))
  add(path_589225, "resource", newJString(resource))
  if body != nil:
    body_589227 = body
  add(query_589226, "prettyPrint", newJBool(prettyPrint))
  result = call_589224.call(path_589225, query_589226, nil, nil, body_589227)

var cloudfunctionsProjectsLocationsFunctionsSetIamPolicy* = Call_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_589207(
    name: "cloudfunctionsProjectsLocationsFunctionsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_589208,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_589209,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_589228 = ref object of OpenApiRestCall_588441
proc url_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_589230(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_589229(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Tests the specified permissions against the IAM access control policy
  ## for a function.
  ## If the function does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589231 = path.getOrDefault("resource")
  valid_589231 = validateParameter(valid_589231, JString, required = true,
                                 default = nil)
  if valid_589231 != nil:
    section.add "resource", valid_589231
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
  var valid_589232 = query.getOrDefault("upload_protocol")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "upload_protocol", valid_589232
  var valid_589233 = query.getOrDefault("fields")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "fields", valid_589233
  var valid_589234 = query.getOrDefault("quotaUser")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "quotaUser", valid_589234
  var valid_589235 = query.getOrDefault("alt")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = newJString("json"))
  if valid_589235 != nil:
    section.add "alt", valid_589235
  var valid_589236 = query.getOrDefault("oauth_token")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "oauth_token", valid_589236
  var valid_589237 = query.getOrDefault("callback")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "callback", valid_589237
  var valid_589238 = query.getOrDefault("access_token")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "access_token", valid_589238
  var valid_589239 = query.getOrDefault("uploadType")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "uploadType", valid_589239
  var valid_589240 = query.getOrDefault("key")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "key", valid_589240
  var valid_589241 = query.getOrDefault("$.xgafv")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = newJString("1"))
  if valid_589241 != nil:
    section.add "$.xgafv", valid_589241
  var valid_589242 = query.getOrDefault("prettyPrint")
  valid_589242 = validateParameter(valid_589242, JBool, required = false,
                                 default = newJBool(true))
  if valid_589242 != nil:
    section.add "prettyPrint", valid_589242
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

proc call*(call_589244: Call_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_589228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the specified permissions against the IAM access control policy
  ## for a function.
  ## If the function does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  let valid = call_589244.validator(path, query, header, formData, body)
  let scheme = call_589244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589244.url(scheme.get, call_589244.host, call_589244.base,
                         call_589244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589244, url, valid)

proc call*(call_589245: Call_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_589228;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudfunctionsProjectsLocationsFunctionsTestIamPermissions
  ## Tests the specified permissions against the IAM access control policy
  ## for a function.
  ## If the function does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589246 = newJObject()
  var query_589247 = newJObject()
  var body_589248 = newJObject()
  add(query_589247, "upload_protocol", newJString(uploadProtocol))
  add(query_589247, "fields", newJString(fields))
  add(query_589247, "quotaUser", newJString(quotaUser))
  add(query_589247, "alt", newJString(alt))
  add(query_589247, "oauth_token", newJString(oauthToken))
  add(query_589247, "callback", newJString(callback))
  add(query_589247, "access_token", newJString(accessToken))
  add(query_589247, "uploadType", newJString(uploadType))
  add(query_589247, "key", newJString(key))
  add(query_589247, "$.xgafv", newJString(Xgafv))
  add(path_589246, "resource", newJString(resource))
  if body != nil:
    body_589248 = body
  add(query_589247, "prettyPrint", newJBool(prettyPrint))
  result = call_589245.call(path_589246, query_589247, nil, nil, body_589248)

var cloudfunctionsProjectsLocationsFunctionsTestIamPermissions* = Call_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_589228(
    name: "cloudfunctionsProjectsLocationsFunctionsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{resource}:testIamPermissions", validator: validate_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_589229,
    base: "/",
    url: url_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_589230,
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
