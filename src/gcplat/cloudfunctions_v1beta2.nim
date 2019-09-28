
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
  gcpServiceName = "cloudfunctions"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudfunctionsOperationsList_579677 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsOperationsList_579679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudfunctionsOperationsList_579678(path: JsonNode; query: JsonNode;
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
  var valid_579791 = query.getOrDefault("upload_protocol")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "upload_protocol", valid_579791
  var valid_579792 = query.getOrDefault("fields")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "fields", valid_579792
  var valid_579793 = query.getOrDefault("pageToken")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "pageToken", valid_579793
  var valid_579794 = query.getOrDefault("quotaUser")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "quotaUser", valid_579794
  var valid_579808 = query.getOrDefault("alt")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = newJString("json"))
  if valid_579808 != nil:
    section.add "alt", valid_579808
  var valid_579809 = query.getOrDefault("oauth_token")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "oauth_token", valid_579809
  var valid_579810 = query.getOrDefault("callback")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "callback", valid_579810
  var valid_579811 = query.getOrDefault("access_token")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "access_token", valid_579811
  var valid_579812 = query.getOrDefault("uploadType")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "uploadType", valid_579812
  var valid_579813 = query.getOrDefault("key")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "key", valid_579813
  var valid_579814 = query.getOrDefault("name")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "name", valid_579814
  var valid_579815 = query.getOrDefault("$.xgafv")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = newJString("1"))
  if valid_579815 != nil:
    section.add "$.xgafv", valid_579815
  var valid_579816 = query.getOrDefault("pageSize")
  valid_579816 = validateParameter(valid_579816, JInt, required = false, default = nil)
  if valid_579816 != nil:
    section.add "pageSize", valid_579816
  var valid_579817 = query.getOrDefault("prettyPrint")
  valid_579817 = validateParameter(valid_579817, JBool, required = false,
                                 default = newJBool(true))
  if valid_579817 != nil:
    section.add "prettyPrint", valid_579817
  var valid_579818 = query.getOrDefault("filter")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = nil)
  if valid_579818 != nil:
    section.add "filter", valid_579818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579841: Call_CloudfunctionsOperationsList_579677; path: JsonNode;
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
  let valid = call_579841.validator(path, query, header, formData, body)
  let scheme = call_579841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579841.url(scheme.get, call_579841.host, call_579841.base,
                         call_579841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579841, url, valid)

proc call*(call_579912: Call_CloudfunctionsOperationsList_579677;
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
  var query_579913 = newJObject()
  add(query_579913, "upload_protocol", newJString(uploadProtocol))
  add(query_579913, "fields", newJString(fields))
  add(query_579913, "pageToken", newJString(pageToken))
  add(query_579913, "quotaUser", newJString(quotaUser))
  add(query_579913, "alt", newJString(alt))
  add(query_579913, "oauth_token", newJString(oauthToken))
  add(query_579913, "callback", newJString(callback))
  add(query_579913, "access_token", newJString(accessToken))
  add(query_579913, "uploadType", newJString(uploadType))
  add(query_579913, "key", newJString(key))
  add(query_579913, "name", newJString(name))
  add(query_579913, "$.xgafv", newJString(Xgafv))
  add(query_579913, "pageSize", newJInt(pageSize))
  add(query_579913, "prettyPrint", newJBool(prettyPrint))
  add(query_579913, "filter", newJString(filter))
  result = call_579912.call(nil, query_579913, nil, nil, nil)

var cloudfunctionsOperationsList* = Call_CloudfunctionsOperationsList_579677(
    name: "cloudfunctionsOperationsList", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1beta2/operations",
    validator: validate_CloudfunctionsOperationsList_579678, base: "/",
    url: url_CloudfunctionsOperationsList_579679, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsCreate_579988 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsCreate_579990(protocol: Scheme;
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

proc validate_CloudfunctionsProjectsLocationsFunctionsCreate_579989(
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
  ##           : The project and location in which the function should be created, specified
  ## in the format `projects/*/locations/*`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_579991 = path.getOrDefault("location")
  valid_579991 = validateParameter(valid_579991, JString, required = true,
                                 default = nil)
  if valid_579991 != nil:
    section.add "location", valid_579991
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
  var valid_579996 = query.getOrDefault("oauth_token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "oauth_token", valid_579996
  var valid_579997 = query.getOrDefault("callback")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "callback", valid_579997
  var valid_579998 = query.getOrDefault("access_token")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "access_token", valid_579998
  var valid_579999 = query.getOrDefault("uploadType")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "uploadType", valid_579999
  var valid_580000 = query.getOrDefault("key")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "key", valid_580000
  var valid_580001 = query.getOrDefault("$.xgafv")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("1"))
  if valid_580001 != nil:
    section.add "$.xgafv", valid_580001
  var valid_580002 = query.getOrDefault("prettyPrint")
  valid_580002 = validateParameter(valid_580002, JBool, required = false,
                                 default = newJBool(true))
  if valid_580002 != nil:
    section.add "prettyPrint", valid_580002
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

proc call*(call_580004: Call_CloudfunctionsProjectsLocationsFunctionsCreate_579988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new function. If a function with the given name already exists in
  ## the specified project, the long running operation will return
  ## `ALREADY_EXISTS` error.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_CloudfunctionsProjectsLocationsFunctionsCreate_579988;
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
  ##           : The project and location in which the function should be created, specified
  ## in the format `projects/*/locations/*`
  var path_580006 = newJObject()
  var query_580007 = newJObject()
  var body_580008 = newJObject()
  add(query_580007, "upload_protocol", newJString(uploadProtocol))
  add(query_580007, "fields", newJString(fields))
  add(query_580007, "quotaUser", newJString(quotaUser))
  add(query_580007, "alt", newJString(alt))
  add(query_580007, "oauth_token", newJString(oauthToken))
  add(query_580007, "callback", newJString(callback))
  add(query_580007, "access_token", newJString(accessToken))
  add(query_580007, "uploadType", newJString(uploadType))
  add(query_580007, "key", newJString(key))
  add(query_580007, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580008 = body
  add(query_580007, "prettyPrint", newJBool(prettyPrint))
  add(path_580006, "location", newJString(location))
  result = call_580005.call(path_580006, query_580007, nil, nil, body_580008)

var cloudfunctionsProjectsLocationsFunctionsCreate* = Call_CloudfunctionsProjectsLocationsFunctionsCreate_579988(
    name: "cloudfunctionsProjectsLocationsFunctionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{location}/functions",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsCreate_579989,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsCreate_579990,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsList_579953 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsList_579955(protocol: Scheme;
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

proc validate_CloudfunctionsProjectsLocationsFunctionsList_579954(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of functions that belong to the requested project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : The project and location from which the function should be listed,
  ## specified in the format `projects/*/locations/*`
  ## If you want to list functions in all locations, use "-" in place of a
  ## location.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_579970 = path.getOrDefault("location")
  valid_579970 = validateParameter(valid_579970, JString, required = true,
                                 default = nil)
  if valid_579970 != nil:
    section.add "location", valid_579970
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
  var valid_579973 = query.getOrDefault("pageToken")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "pageToken", valid_579973
  var valid_579974 = query.getOrDefault("quotaUser")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "quotaUser", valid_579974
  var valid_579975 = query.getOrDefault("alt")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = newJString("json"))
  if valid_579975 != nil:
    section.add "alt", valid_579975
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
  var valid_579982 = query.getOrDefault("pageSize")
  valid_579982 = validateParameter(valid_579982, JInt, required = false, default = nil)
  if valid_579982 != nil:
    section.add "pageSize", valid_579982
  var valid_579983 = query.getOrDefault("prettyPrint")
  valid_579983 = validateParameter(valid_579983, JBool, required = false,
                                 default = newJBool(true))
  if valid_579983 != nil:
    section.add "prettyPrint", valid_579983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579984: Call_CloudfunctionsProjectsLocationsFunctionsList_579953;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of functions that belong to the requested project.
  ## 
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_CloudfunctionsProjectsLocationsFunctionsList_579953;
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
  ##           : The project and location from which the function should be listed,
  ## specified in the format `projects/*/locations/*`
  ## If you want to list functions in all locations, use "-" in place of a
  ## location.
  var path_579986 = newJObject()
  var query_579987 = newJObject()
  add(query_579987, "upload_protocol", newJString(uploadProtocol))
  add(query_579987, "fields", newJString(fields))
  add(query_579987, "pageToken", newJString(pageToken))
  add(query_579987, "quotaUser", newJString(quotaUser))
  add(query_579987, "alt", newJString(alt))
  add(query_579987, "oauth_token", newJString(oauthToken))
  add(query_579987, "callback", newJString(callback))
  add(query_579987, "access_token", newJString(accessToken))
  add(query_579987, "uploadType", newJString(uploadType))
  add(query_579987, "key", newJString(key))
  add(query_579987, "$.xgafv", newJString(Xgafv))
  add(query_579987, "pageSize", newJInt(pageSize))
  add(query_579987, "prettyPrint", newJBool(prettyPrint))
  add(path_579986, "location", newJString(location))
  result = call_579985.call(path_579986, query_579987, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsList* = Call_CloudfunctionsProjectsLocationsFunctionsList_579953(
    name: "cloudfunctionsProjectsLocationsFunctionsList",
    meth: HttpMethod.HttpGet, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{location}/functions",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsList_579954,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsList_579955,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsUpdate_580028 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsUpdate_580030(protocol: Scheme;
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

proc validate_CloudfunctionsProjectsLocationsFunctionsUpdate_580029(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates existing function.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the function to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580031 = path.getOrDefault("name")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "name", valid_580031
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
  var valid_580032 = query.getOrDefault("upload_protocol")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "upload_protocol", valid_580032
  var valid_580033 = query.getOrDefault("fields")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "fields", valid_580033
  var valid_580034 = query.getOrDefault("quotaUser")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "quotaUser", valid_580034
  var valid_580035 = query.getOrDefault("alt")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("json"))
  if valid_580035 != nil:
    section.add "alt", valid_580035
  var valid_580036 = query.getOrDefault("oauth_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "oauth_token", valid_580036
  var valid_580037 = query.getOrDefault("callback")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "callback", valid_580037
  var valid_580038 = query.getOrDefault("access_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "access_token", valid_580038
  var valid_580039 = query.getOrDefault("uploadType")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "uploadType", valid_580039
  var valid_580040 = query.getOrDefault("key")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "key", valid_580040
  var valid_580041 = query.getOrDefault("$.xgafv")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("1"))
  if valid_580041 != nil:
    section.add "$.xgafv", valid_580041
  var valid_580042 = query.getOrDefault("prettyPrint")
  valid_580042 = validateParameter(valid_580042, JBool, required = false,
                                 default = newJBool(true))
  if valid_580042 != nil:
    section.add "prettyPrint", valid_580042
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

proc call*(call_580044: Call_CloudfunctionsProjectsLocationsFunctionsUpdate_580028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates existing function.
  ## 
  let valid = call_580044.validator(path, query, header, formData, body)
  let scheme = call_580044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580044.url(scheme.get, call_580044.host, call_580044.base,
                         call_580044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580044, url, valid)

proc call*(call_580045: Call_CloudfunctionsProjectsLocationsFunctionsUpdate_580028;
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
  ##       : The name of the function to be updated.
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
  var path_580046 = newJObject()
  var query_580047 = newJObject()
  var body_580048 = newJObject()
  add(query_580047, "upload_protocol", newJString(uploadProtocol))
  add(query_580047, "fields", newJString(fields))
  add(query_580047, "quotaUser", newJString(quotaUser))
  add(path_580046, "name", newJString(name))
  add(query_580047, "alt", newJString(alt))
  add(query_580047, "oauth_token", newJString(oauthToken))
  add(query_580047, "callback", newJString(callback))
  add(query_580047, "access_token", newJString(accessToken))
  add(query_580047, "uploadType", newJString(uploadType))
  add(query_580047, "key", newJString(key))
  add(query_580047, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580048 = body
  add(query_580047, "prettyPrint", newJBool(prettyPrint))
  result = call_580045.call(path_580046, query_580047, nil, nil, body_580048)

var cloudfunctionsProjectsLocationsFunctionsUpdate* = Call_CloudfunctionsProjectsLocationsFunctionsUpdate_580028(
    name: "cloudfunctionsProjectsLocationsFunctionsUpdate",
    meth: HttpMethod.HttpPut, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsUpdate_580029,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsUpdate_580030,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGet_580009 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsGet_580011(protocol: Scheme;
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

proc validate_CloudfunctionsProjectsLocationsFunctionsGet_580010(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a function with the given name from the requested project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the function which details should be obtained.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580012 = path.getOrDefault("name")
  valid_580012 = validateParameter(valid_580012, JString, required = true,
                                 default = nil)
  if valid_580012 != nil:
    section.add "name", valid_580012
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
  var valid_580013 = query.getOrDefault("upload_protocol")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "upload_protocol", valid_580013
  var valid_580014 = query.getOrDefault("fields")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "fields", valid_580014
  var valid_580015 = query.getOrDefault("quotaUser")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "quotaUser", valid_580015
  var valid_580016 = query.getOrDefault("alt")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("json"))
  if valid_580016 != nil:
    section.add "alt", valid_580016
  var valid_580017 = query.getOrDefault("oauth_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "oauth_token", valid_580017
  var valid_580018 = query.getOrDefault("callback")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "callback", valid_580018
  var valid_580019 = query.getOrDefault("access_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "access_token", valid_580019
  var valid_580020 = query.getOrDefault("uploadType")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "uploadType", valid_580020
  var valid_580021 = query.getOrDefault("key")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "key", valid_580021
  var valid_580022 = query.getOrDefault("$.xgafv")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("1"))
  if valid_580022 != nil:
    section.add "$.xgafv", valid_580022
  var valid_580023 = query.getOrDefault("prettyPrint")
  valid_580023 = validateParameter(valid_580023, JBool, required = false,
                                 default = newJBool(true))
  if valid_580023 != nil:
    section.add "prettyPrint", valid_580023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580024: Call_CloudfunctionsProjectsLocationsFunctionsGet_580009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a function with the given name from the requested project.
  ## 
  let valid = call_580024.validator(path, query, header, formData, body)
  let scheme = call_580024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580024.url(scheme.get, call_580024.host, call_580024.base,
                         call_580024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580024, url, valid)

proc call*(call_580025: Call_CloudfunctionsProjectsLocationsFunctionsGet_580009;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudfunctionsProjectsLocationsFunctionsGet
  ## Returns a function with the given name from the requested project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the function which details should be obtained.
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
  var path_580026 = newJObject()
  var query_580027 = newJObject()
  add(query_580027, "upload_protocol", newJString(uploadProtocol))
  add(query_580027, "fields", newJString(fields))
  add(query_580027, "quotaUser", newJString(quotaUser))
  add(path_580026, "name", newJString(name))
  add(query_580027, "alt", newJString(alt))
  add(query_580027, "oauth_token", newJString(oauthToken))
  add(query_580027, "callback", newJString(callback))
  add(query_580027, "access_token", newJString(accessToken))
  add(query_580027, "uploadType", newJString(uploadType))
  add(query_580027, "key", newJString(key))
  add(query_580027, "$.xgafv", newJString(Xgafv))
  add(query_580027, "prettyPrint", newJBool(prettyPrint))
  result = call_580025.call(path_580026, query_580027, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsGet* = Call_CloudfunctionsProjectsLocationsFunctionsGet_580009(
    name: "cloudfunctionsProjectsLocationsFunctionsGet", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1beta2/{name}",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsGet_580010,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsGet_580011,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsDelete_580049 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsDelete_580051(protocol: Scheme;
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

proc validate_CloudfunctionsProjectsLocationsFunctionsDelete_580050(
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
  ##       : The name of the function which should be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580052 = path.getOrDefault("name")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "name", valid_580052
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
  var valid_580053 = query.getOrDefault("upload_protocol")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "upload_protocol", valid_580053
  var valid_580054 = query.getOrDefault("fields")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "fields", valid_580054
  var valid_580055 = query.getOrDefault("quotaUser")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "quotaUser", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("oauth_token")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "oauth_token", valid_580057
  var valid_580058 = query.getOrDefault("callback")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "callback", valid_580058
  var valid_580059 = query.getOrDefault("access_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "access_token", valid_580059
  var valid_580060 = query.getOrDefault("uploadType")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "uploadType", valid_580060
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580064: Call_CloudfunctionsProjectsLocationsFunctionsDelete_580049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a function with the given name from the specified project. If the
  ## given function is used by some trigger, the trigger will be updated to
  ## remove this function.
  ## 
  let valid = call_580064.validator(path, query, header, formData, body)
  let scheme = call_580064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580064.url(scheme.get, call_580064.host, call_580064.base,
                         call_580064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580064, url, valid)

proc call*(call_580065: Call_CloudfunctionsProjectsLocationsFunctionsDelete_580049;
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
  ##       : The name of the function which should be deleted.
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
  var path_580066 = newJObject()
  var query_580067 = newJObject()
  add(query_580067, "upload_protocol", newJString(uploadProtocol))
  add(query_580067, "fields", newJString(fields))
  add(query_580067, "quotaUser", newJString(quotaUser))
  add(path_580066, "name", newJString(name))
  add(query_580067, "alt", newJString(alt))
  add(query_580067, "oauth_token", newJString(oauthToken))
  add(query_580067, "callback", newJString(callback))
  add(query_580067, "access_token", newJString(accessToken))
  add(query_580067, "uploadType", newJString(uploadType))
  add(query_580067, "key", newJString(key))
  add(query_580067, "$.xgafv", newJString(Xgafv))
  add(query_580067, "prettyPrint", newJBool(prettyPrint))
  result = call_580065.call(path_580066, query_580067, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsDelete* = Call_CloudfunctionsProjectsLocationsFunctionsDelete_580049(
    name: "cloudfunctionsProjectsLocationsFunctionsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsDelete_580050,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsDelete_580051,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsList_580068 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsList_580070(protocol: Scheme; host: string;
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

proc validate_CloudfunctionsProjectsLocationsList_580069(path: JsonNode;
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
  var valid_580071 = path.getOrDefault("name")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "name", valid_580071
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
  var valid_580072 = query.getOrDefault("upload_protocol")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "upload_protocol", valid_580072
  var valid_580073 = query.getOrDefault("fields")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "fields", valid_580073
  var valid_580074 = query.getOrDefault("pageToken")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "pageToken", valid_580074
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
  var valid_580077 = query.getOrDefault("oauth_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "oauth_token", valid_580077
  var valid_580078 = query.getOrDefault("callback")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "callback", valid_580078
  var valid_580079 = query.getOrDefault("access_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "access_token", valid_580079
  var valid_580080 = query.getOrDefault("uploadType")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "uploadType", valid_580080
  var valid_580081 = query.getOrDefault("key")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "key", valid_580081
  var valid_580082 = query.getOrDefault("$.xgafv")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = newJString("1"))
  if valid_580082 != nil:
    section.add "$.xgafv", valid_580082
  var valid_580083 = query.getOrDefault("pageSize")
  valid_580083 = validateParameter(valid_580083, JInt, required = false, default = nil)
  if valid_580083 != nil:
    section.add "pageSize", valid_580083
  var valid_580084 = query.getOrDefault("prettyPrint")
  valid_580084 = validateParameter(valid_580084, JBool, required = false,
                                 default = newJBool(true))
  if valid_580084 != nil:
    section.add "prettyPrint", valid_580084
  var valid_580085 = query.getOrDefault("filter")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "filter", valid_580085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580086: Call_CloudfunctionsProjectsLocationsList_580068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_CloudfunctionsProjectsLocationsList_580068;
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
  var path_580088 = newJObject()
  var query_580089 = newJObject()
  add(query_580089, "upload_protocol", newJString(uploadProtocol))
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "pageToken", newJString(pageToken))
  add(query_580089, "quotaUser", newJString(quotaUser))
  add(path_580088, "name", newJString(name))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "callback", newJString(callback))
  add(query_580089, "access_token", newJString(accessToken))
  add(query_580089, "uploadType", newJString(uploadType))
  add(query_580089, "key", newJString(key))
  add(query_580089, "$.xgafv", newJString(Xgafv))
  add(query_580089, "pageSize", newJInt(pageSize))
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  add(query_580089, "filter", newJString(filter))
  result = call_580087.call(path_580088, query_580089, nil, nil, nil)

var cloudfunctionsProjectsLocationsList* = Call_CloudfunctionsProjectsLocationsList_580068(
    name: "cloudfunctionsProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1beta2/{name}/locations",
    validator: validate_CloudfunctionsProjectsLocationsList_580069, base: "/",
    url: url_CloudfunctionsProjectsLocationsList_580070, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsCall_580090 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsCall_580092(protocol: Scheme;
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

proc validate_CloudfunctionsProjectsLocationsFunctionsCall_580091(path: JsonNode;
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
  ##       : The name of the function to be called.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580093 = path.getOrDefault("name")
  valid_580093 = validateParameter(valid_580093, JString, required = true,
                                 default = nil)
  if valid_580093 != nil:
    section.add "name", valid_580093
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
  var valid_580094 = query.getOrDefault("upload_protocol")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "upload_protocol", valid_580094
  var valid_580095 = query.getOrDefault("fields")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "fields", valid_580095
  var valid_580096 = query.getOrDefault("quotaUser")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "quotaUser", valid_580096
  var valid_580097 = query.getOrDefault("alt")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("json"))
  if valid_580097 != nil:
    section.add "alt", valid_580097
  var valid_580098 = query.getOrDefault("oauth_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "oauth_token", valid_580098
  var valid_580099 = query.getOrDefault("callback")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "callback", valid_580099
  var valid_580100 = query.getOrDefault("access_token")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "access_token", valid_580100
  var valid_580101 = query.getOrDefault("uploadType")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "uploadType", valid_580101
  var valid_580102 = query.getOrDefault("key")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "key", valid_580102
  var valid_580103 = query.getOrDefault("$.xgafv")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("1"))
  if valid_580103 != nil:
    section.add "$.xgafv", valid_580103
  var valid_580104 = query.getOrDefault("prettyPrint")
  valid_580104 = validateParameter(valid_580104, JBool, required = false,
                                 default = newJBool(true))
  if valid_580104 != nil:
    section.add "prettyPrint", valid_580104
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

proc call*(call_580106: Call_CloudfunctionsProjectsLocationsFunctionsCall_580090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Synchronously invokes a deployed Cloud Function. To be used for testing
  ## purposes as very limited traffic is allowed. For more information on
  ## the actual limits refer to [API Calls](
  ## https://cloud.google.com/functions/quotas#rate_limits).
  ## 
  let valid = call_580106.validator(path, query, header, formData, body)
  let scheme = call_580106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580106.url(scheme.get, call_580106.host, call_580106.base,
                         call_580106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580106, url, valid)

proc call*(call_580107: Call_CloudfunctionsProjectsLocationsFunctionsCall_580090;
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
  ##       : The name of the function to be called.
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
  var path_580108 = newJObject()
  var query_580109 = newJObject()
  var body_580110 = newJObject()
  add(query_580109, "upload_protocol", newJString(uploadProtocol))
  add(query_580109, "fields", newJString(fields))
  add(query_580109, "quotaUser", newJString(quotaUser))
  add(path_580108, "name", newJString(name))
  add(query_580109, "alt", newJString(alt))
  add(query_580109, "oauth_token", newJString(oauthToken))
  add(query_580109, "callback", newJString(callback))
  add(query_580109, "access_token", newJString(accessToken))
  add(query_580109, "uploadType", newJString(uploadType))
  add(query_580109, "key", newJString(key))
  add(query_580109, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580110 = body
  add(query_580109, "prettyPrint", newJBool(prettyPrint))
  result = call_580107.call(path_580108, query_580109, nil, nil, body_580110)

var cloudfunctionsProjectsLocationsFunctionsCall* = Call_CloudfunctionsProjectsLocationsFunctionsCall_580090(
    name: "cloudfunctionsProjectsLocationsFunctionsCall",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{name}:call",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsCall_580091,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsCall_580092,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580111 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580113(
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

proc validate_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580112(
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
  var valid_580114 = path.getOrDefault("name")
  valid_580114 = validateParameter(valid_580114, JString, required = true,
                                 default = nil)
  if valid_580114 != nil:
    section.add "name", valid_580114
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
  var valid_580115 = query.getOrDefault("upload_protocol")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "upload_protocol", valid_580115
  var valid_580116 = query.getOrDefault("fields")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "fields", valid_580116
  var valid_580117 = query.getOrDefault("quotaUser")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "quotaUser", valid_580117
  var valid_580118 = query.getOrDefault("alt")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = newJString("json"))
  if valid_580118 != nil:
    section.add "alt", valid_580118
  var valid_580119 = query.getOrDefault("oauth_token")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "oauth_token", valid_580119
  var valid_580120 = query.getOrDefault("callback")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "callback", valid_580120
  var valid_580121 = query.getOrDefault("access_token")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "access_token", valid_580121
  var valid_580122 = query.getOrDefault("uploadType")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "uploadType", valid_580122
  var valid_580123 = query.getOrDefault("key")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "key", valid_580123
  var valid_580124 = query.getOrDefault("$.xgafv")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = newJString("1"))
  if valid_580124 != nil:
    section.add "$.xgafv", valid_580124
  var valid_580125 = query.getOrDefault("prettyPrint")
  valid_580125 = validateParameter(valid_580125, JBool, required = false,
                                 default = newJBool(true))
  if valid_580125 != nil:
    section.add "prettyPrint", valid_580125
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

proc call*(call_580127: Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a signed URL for downloading deployed function source code.
  ## The URL is only valid for a limited period and should be used within
  ## minutes after generation.
  ## For more information about the signed URL usage see:
  ## https://cloud.google.com/storage/docs/access-control/signed-urls
  ## 
  let valid = call_580127.validator(path, query, header, formData, body)
  let scheme = call_580127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580127.url(scheme.get, call_580127.host, call_580127.base,
                         call_580127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580127, url, valid)

proc call*(call_580128: Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580111;
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
  var path_580129 = newJObject()
  var query_580130 = newJObject()
  var body_580131 = newJObject()
  add(query_580130, "upload_protocol", newJString(uploadProtocol))
  add(query_580130, "fields", newJString(fields))
  add(query_580130, "quotaUser", newJString(quotaUser))
  add(path_580129, "name", newJString(name))
  add(query_580130, "alt", newJString(alt))
  add(query_580130, "oauth_token", newJString(oauthToken))
  add(query_580130, "callback", newJString(callback))
  add(query_580130, "access_token", newJString(accessToken))
  add(query_580130, "uploadType", newJString(uploadType))
  add(query_580130, "key", newJString(key))
  add(query_580130, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580131 = body
  add(query_580130, "prettyPrint", newJBool(prettyPrint))
  result = call_580128.call(path_580129, query_580130, nil, nil, body_580131)

var cloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl* = Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580111(
    name: "cloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{name}:generateDownloadUrl", validator: validate_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580112,
    base: "/",
    url: url_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580113,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580132 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580134(
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

proc validate_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580133(
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
  var valid_580135 = path.getOrDefault("parent")
  valid_580135 = validateParameter(valid_580135, JString, required = true,
                                 default = nil)
  if valid_580135 != nil:
    section.add "parent", valid_580135
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
  var valid_580136 = query.getOrDefault("upload_protocol")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "upload_protocol", valid_580136
  var valid_580137 = query.getOrDefault("fields")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "fields", valid_580137
  var valid_580138 = query.getOrDefault("quotaUser")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "quotaUser", valid_580138
  var valid_580139 = query.getOrDefault("alt")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = newJString("json"))
  if valid_580139 != nil:
    section.add "alt", valid_580139
  var valid_580140 = query.getOrDefault("oauth_token")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "oauth_token", valid_580140
  var valid_580141 = query.getOrDefault("callback")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "callback", valid_580141
  var valid_580142 = query.getOrDefault("access_token")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "access_token", valid_580142
  var valid_580143 = query.getOrDefault("uploadType")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "uploadType", valid_580143
  var valid_580144 = query.getOrDefault("key")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "key", valid_580144
  var valid_580145 = query.getOrDefault("$.xgafv")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = newJString("1"))
  if valid_580145 != nil:
    section.add "$.xgafv", valid_580145
  var valid_580146 = query.getOrDefault("prettyPrint")
  valid_580146 = validateParameter(valid_580146, JBool, required = false,
                                 default = newJBool(true))
  if valid_580146 != nil:
    section.add "prettyPrint", valid_580146
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

proc call*(call_580148: Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580132;
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
  let valid = call_580148.validator(path, query, header, formData, body)
  let scheme = call_580148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580148.url(scheme.get, call_580148.host, call_580148.base,
                         call_580148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580148, url, valid)

proc call*(call_580149: Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580132;
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
  var path_580150 = newJObject()
  var query_580151 = newJObject()
  var body_580152 = newJObject()
  add(query_580151, "upload_protocol", newJString(uploadProtocol))
  add(query_580151, "fields", newJString(fields))
  add(query_580151, "quotaUser", newJString(quotaUser))
  add(query_580151, "alt", newJString(alt))
  add(query_580151, "oauth_token", newJString(oauthToken))
  add(query_580151, "callback", newJString(callback))
  add(query_580151, "access_token", newJString(accessToken))
  add(query_580151, "uploadType", newJString(uploadType))
  add(path_580150, "parent", newJString(parent))
  add(query_580151, "key", newJString(key))
  add(query_580151, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580152 = body
  add(query_580151, "prettyPrint", newJBool(prettyPrint))
  result = call_580149.call(path_580150, query_580151, nil, nil, body_580152)

var cloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl* = Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580132(
    name: "cloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{parent}/functions:generateUploadUrl", validator: validate_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580133,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580134,
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
