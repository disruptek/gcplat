
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
    host: "cloudfunctions.googleapis.com", route: "/v1/operations",
    validator: validate_CloudfunctionsOperationsList_579678, base: "/",
    url: url_CloudfunctionsOperationsList_579679, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsCreate_579953 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsCreate_579955(protocol: Scheme;
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

proc validate_CloudfunctionsProjectsLocationsFunctionsCreate_579954(
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
  var valid_579975 = query.getOrDefault("oauth_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "oauth_token", valid_579975
  var valid_579976 = query.getOrDefault("callback")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "callback", valid_579976
  var valid_579977 = query.getOrDefault("access_token")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "access_token", valid_579977
  var valid_579978 = query.getOrDefault("uploadType")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "uploadType", valid_579978
  var valid_579979 = query.getOrDefault("key")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "key", valid_579979
  var valid_579980 = query.getOrDefault("$.xgafv")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = newJString("1"))
  if valid_579980 != nil:
    section.add "$.xgafv", valid_579980
  var valid_579981 = query.getOrDefault("prettyPrint")
  valid_579981 = validateParameter(valid_579981, JBool, required = false,
                                 default = newJBool(true))
  if valid_579981 != nil:
    section.add "prettyPrint", valid_579981
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

proc call*(call_579983: Call_CloudfunctionsProjectsLocationsFunctionsCreate_579953;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new function. If a function with the given name already exists in
  ## the specified project, the long running operation will return
  ## `ALREADY_EXISTS` error.
  ## 
  let valid = call_579983.validator(path, query, header, formData, body)
  let scheme = call_579983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579983.url(scheme.get, call_579983.host, call_579983.base,
                         call_579983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579983, url, valid)

proc call*(call_579984: Call_CloudfunctionsProjectsLocationsFunctionsCreate_579953;
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
  var path_579985 = newJObject()
  var query_579986 = newJObject()
  var body_579987 = newJObject()
  add(query_579986, "upload_protocol", newJString(uploadProtocol))
  add(query_579986, "fields", newJString(fields))
  add(query_579986, "quotaUser", newJString(quotaUser))
  add(query_579986, "alt", newJString(alt))
  add(query_579986, "oauth_token", newJString(oauthToken))
  add(query_579986, "callback", newJString(callback))
  add(query_579986, "access_token", newJString(accessToken))
  add(query_579986, "uploadType", newJString(uploadType))
  add(query_579986, "key", newJString(key))
  add(query_579986, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579987 = body
  add(query_579986, "prettyPrint", newJBool(prettyPrint))
  add(path_579985, "location", newJString(location))
  result = call_579984.call(path_579985, query_579986, nil, nil, body_579987)

var cloudfunctionsProjectsLocationsFunctionsCreate* = Call_CloudfunctionsProjectsLocationsFunctionsCreate_579953(
    name: "cloudfunctionsProjectsLocationsFunctionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{location}/functions",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsCreate_579954,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsCreate_579955,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsOperationsGet_579988 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsOperationsGet_579990(protocol: Scheme; host: string;
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

proc validate_CloudfunctionsOperationsGet_579989(path: JsonNode; query: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_580003: Call_CloudfunctionsOperationsGet_579988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_580003.validator(path, query, header, formData, body)
  let scheme = call_580003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580003.url(scheme.get, call_580003.host, call_580003.base,
                         call_580003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580003, url, valid)

proc call*(call_580004: Call_CloudfunctionsOperationsGet_579988; name: string;
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
  var path_580005 = newJObject()
  var query_580006 = newJObject()
  add(query_580006, "upload_protocol", newJString(uploadProtocol))
  add(query_580006, "fields", newJString(fields))
  add(query_580006, "quotaUser", newJString(quotaUser))
  add(path_580005, "name", newJString(name))
  add(query_580006, "alt", newJString(alt))
  add(query_580006, "oauth_token", newJString(oauthToken))
  add(query_580006, "callback", newJString(callback))
  add(query_580006, "access_token", newJString(accessToken))
  add(query_580006, "uploadType", newJString(uploadType))
  add(query_580006, "key", newJString(key))
  add(query_580006, "$.xgafv", newJString(Xgafv))
  add(query_580006, "prettyPrint", newJBool(prettyPrint))
  result = call_580004.call(path_580005, query_580006, nil, nil, nil)

var cloudfunctionsOperationsGet* = Call_CloudfunctionsOperationsGet_579988(
    name: "cloudfunctionsOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudfunctionsOperationsGet_579989, base: "/",
    url: url_CloudfunctionsOperationsGet_579990, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsPatch_580026 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsPatch_580028(protocol: Scheme;
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

proc validate_CloudfunctionsProjectsLocationsFunctionsPatch_580027(
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
  var valid_580029 = path.getOrDefault("name")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "name", valid_580029
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
  var valid_580030 = query.getOrDefault("upload_protocol")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "upload_protocol", valid_580030
  var valid_580031 = query.getOrDefault("fields")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "fields", valid_580031
  var valid_580032 = query.getOrDefault("quotaUser")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "quotaUser", valid_580032
  var valid_580033 = query.getOrDefault("alt")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("json"))
  if valid_580033 != nil:
    section.add "alt", valid_580033
  var valid_580034 = query.getOrDefault("oauth_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "oauth_token", valid_580034
  var valid_580035 = query.getOrDefault("callback")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "callback", valid_580035
  var valid_580036 = query.getOrDefault("access_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "access_token", valid_580036
  var valid_580037 = query.getOrDefault("uploadType")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "uploadType", valid_580037
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
  var valid_580041 = query.getOrDefault("updateMask")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "updateMask", valid_580041
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

proc call*(call_580043: Call_CloudfunctionsProjectsLocationsFunctionsPatch_580026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates existing function.
  ## 
  let valid = call_580043.validator(path, query, header, formData, body)
  let scheme = call_580043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580043.url(scheme.get, call_580043.host, call_580043.base,
                         call_580043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580043, url, valid)

proc call*(call_580044: Call_CloudfunctionsProjectsLocationsFunctionsPatch_580026;
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
  var path_580045 = newJObject()
  var query_580046 = newJObject()
  var body_580047 = newJObject()
  add(query_580046, "upload_protocol", newJString(uploadProtocol))
  add(query_580046, "fields", newJString(fields))
  add(query_580046, "quotaUser", newJString(quotaUser))
  add(path_580045, "name", newJString(name))
  add(query_580046, "alt", newJString(alt))
  add(query_580046, "oauth_token", newJString(oauthToken))
  add(query_580046, "callback", newJString(callback))
  add(query_580046, "access_token", newJString(accessToken))
  add(query_580046, "uploadType", newJString(uploadType))
  add(query_580046, "key", newJString(key))
  add(query_580046, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580047 = body
  add(query_580046, "prettyPrint", newJBool(prettyPrint))
  add(query_580046, "updateMask", newJString(updateMask))
  result = call_580044.call(path_580045, query_580046, nil, nil, body_580047)

var cloudfunctionsProjectsLocationsFunctionsPatch* = Call_CloudfunctionsProjectsLocationsFunctionsPatch_580026(
    name: "cloudfunctionsProjectsLocationsFunctionsPatch",
    meth: HttpMethod.HttpPatch, host: "cloudfunctions.googleapis.com",
    route: "/v1/{name}",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsPatch_580027,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsPatch_580028,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsDelete_580007 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsDelete_580009(protocol: Scheme;
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

proc validate_CloudfunctionsProjectsLocationsFunctionsDelete_580008(
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
  var valid_580010 = path.getOrDefault("name")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "name", valid_580010
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
  var valid_580011 = query.getOrDefault("upload_protocol")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "upload_protocol", valid_580011
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("callback")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "callback", valid_580016
  var valid_580017 = query.getOrDefault("access_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "access_token", valid_580017
  var valid_580018 = query.getOrDefault("uploadType")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "uploadType", valid_580018
  var valid_580019 = query.getOrDefault("key")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "key", valid_580019
  var valid_580020 = query.getOrDefault("$.xgafv")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("1"))
  if valid_580020 != nil:
    section.add "$.xgafv", valid_580020
  var valid_580021 = query.getOrDefault("prettyPrint")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(true))
  if valid_580021 != nil:
    section.add "prettyPrint", valid_580021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580022: Call_CloudfunctionsProjectsLocationsFunctionsDelete_580007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a function with the given name from the specified project. If the
  ## given function is used by some trigger, the trigger will be updated to
  ## remove this function.
  ## 
  let valid = call_580022.validator(path, query, header, formData, body)
  let scheme = call_580022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580022.url(scheme.get, call_580022.host, call_580022.base,
                         call_580022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580022, url, valid)

proc call*(call_580023: Call_CloudfunctionsProjectsLocationsFunctionsDelete_580007;
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
  var path_580024 = newJObject()
  var query_580025 = newJObject()
  add(query_580025, "upload_protocol", newJString(uploadProtocol))
  add(query_580025, "fields", newJString(fields))
  add(query_580025, "quotaUser", newJString(quotaUser))
  add(path_580024, "name", newJString(name))
  add(query_580025, "alt", newJString(alt))
  add(query_580025, "oauth_token", newJString(oauthToken))
  add(query_580025, "callback", newJString(callback))
  add(query_580025, "access_token", newJString(accessToken))
  add(query_580025, "uploadType", newJString(uploadType))
  add(query_580025, "key", newJString(key))
  add(query_580025, "$.xgafv", newJString(Xgafv))
  add(query_580025, "prettyPrint", newJBool(prettyPrint))
  result = call_580023.call(path_580024, query_580025, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsDelete* = Call_CloudfunctionsProjectsLocationsFunctionsDelete_580007(
    name: "cloudfunctionsProjectsLocationsFunctionsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudfunctions.googleapis.com",
    route: "/v1/{name}",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsDelete_580008,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsDelete_580009,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsList_580048 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsList_580050(protocol: Scheme; host: string;
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

proc validate_CloudfunctionsProjectsLocationsList_580049(path: JsonNode;
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
  var valid_580054 = query.getOrDefault("pageToken")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "pageToken", valid_580054
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
  var valid_580063 = query.getOrDefault("pageSize")
  valid_580063 = validateParameter(valid_580063, JInt, required = false, default = nil)
  if valid_580063 != nil:
    section.add "pageSize", valid_580063
  var valid_580064 = query.getOrDefault("prettyPrint")
  valid_580064 = validateParameter(valid_580064, JBool, required = false,
                                 default = newJBool(true))
  if valid_580064 != nil:
    section.add "prettyPrint", valid_580064
  var valid_580065 = query.getOrDefault("filter")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "filter", valid_580065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580066: Call_CloudfunctionsProjectsLocationsList_580048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_CloudfunctionsProjectsLocationsList_580048;
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
  var path_580068 = newJObject()
  var query_580069 = newJObject()
  add(query_580069, "upload_protocol", newJString(uploadProtocol))
  add(query_580069, "fields", newJString(fields))
  add(query_580069, "pageToken", newJString(pageToken))
  add(query_580069, "quotaUser", newJString(quotaUser))
  add(path_580068, "name", newJString(name))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "callback", newJString(callback))
  add(query_580069, "access_token", newJString(accessToken))
  add(query_580069, "uploadType", newJString(uploadType))
  add(query_580069, "key", newJString(key))
  add(query_580069, "$.xgafv", newJString(Xgafv))
  add(query_580069, "pageSize", newJInt(pageSize))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  add(query_580069, "filter", newJString(filter))
  result = call_580067.call(path_580068, query_580069, nil, nil, nil)

var cloudfunctionsProjectsLocationsList* = Call_CloudfunctionsProjectsLocationsList_580048(
    name: "cloudfunctionsProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_CloudfunctionsProjectsLocationsList_580049, base: "/",
    url: url_CloudfunctionsProjectsLocationsList_580050, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsCall_580070 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsCall_580072(protocol: Scheme;
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

proc validate_CloudfunctionsProjectsLocationsFunctionsCall_580071(path: JsonNode;
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
  ##       : The name of the function to be called.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580073 = path.getOrDefault("name")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "name", valid_580073
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
  var valid_580074 = query.getOrDefault("upload_protocol")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "upload_protocol", valid_580074
  var valid_580075 = query.getOrDefault("fields")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "fields", valid_580075
  var valid_580076 = query.getOrDefault("quotaUser")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "quotaUser", valid_580076
  var valid_580077 = query.getOrDefault("alt")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("json"))
  if valid_580077 != nil:
    section.add "alt", valid_580077
  var valid_580078 = query.getOrDefault("oauth_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "oauth_token", valid_580078
  var valid_580079 = query.getOrDefault("callback")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "callback", valid_580079
  var valid_580080 = query.getOrDefault("access_token")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "access_token", valid_580080
  var valid_580081 = query.getOrDefault("uploadType")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "uploadType", valid_580081
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

proc call*(call_580086: Call_CloudfunctionsProjectsLocationsFunctionsCall_580070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Synchronously invokes a deployed Cloud Function. To be used for testing
  ## purposes as very limited traffic is allowed. For more information on
  ## the actual limits, refer to
  ## [Rate Limits](https://cloud.google.com/functions/quotas#rate_limits).
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_CloudfunctionsProjectsLocationsFunctionsCall_580070;
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
  var path_580088 = newJObject()
  var query_580089 = newJObject()
  var body_580090 = newJObject()
  add(query_580089, "upload_protocol", newJString(uploadProtocol))
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "quotaUser", newJString(quotaUser))
  add(path_580088, "name", newJString(name))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "callback", newJString(callback))
  add(query_580089, "access_token", newJString(accessToken))
  add(query_580089, "uploadType", newJString(uploadType))
  add(query_580089, "key", newJString(key))
  add(query_580089, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580090 = body
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  result = call_580087.call(path_580088, query_580089, nil, nil, body_580090)

var cloudfunctionsProjectsLocationsFunctionsCall* = Call_CloudfunctionsProjectsLocationsFunctionsCall_580070(
    name: "cloudfunctionsProjectsLocationsFunctionsCall",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{name}:call",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsCall_580071,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsCall_580072,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580091 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580093(
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

proc validate_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580092(
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
  var valid_580094 = path.getOrDefault("name")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "name", valid_580094
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
  var valid_580095 = query.getOrDefault("upload_protocol")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "upload_protocol", valid_580095
  var valid_580096 = query.getOrDefault("fields")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "fields", valid_580096
  var valid_580097 = query.getOrDefault("quotaUser")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "quotaUser", valid_580097
  var valid_580098 = query.getOrDefault("alt")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = newJString("json"))
  if valid_580098 != nil:
    section.add "alt", valid_580098
  var valid_580099 = query.getOrDefault("oauth_token")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "oauth_token", valid_580099
  var valid_580100 = query.getOrDefault("callback")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "callback", valid_580100
  var valid_580101 = query.getOrDefault("access_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "access_token", valid_580101
  var valid_580102 = query.getOrDefault("uploadType")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "uploadType", valid_580102
  var valid_580103 = query.getOrDefault("key")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "key", valid_580103
  var valid_580104 = query.getOrDefault("$.xgafv")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = newJString("1"))
  if valid_580104 != nil:
    section.add "$.xgafv", valid_580104
  var valid_580105 = query.getOrDefault("prettyPrint")
  valid_580105 = validateParameter(valid_580105, JBool, required = false,
                                 default = newJBool(true))
  if valid_580105 != nil:
    section.add "prettyPrint", valid_580105
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

proc call*(call_580107: Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a signed URL for downloading deployed function source code.
  ## The URL is only valid for a limited period and should be used within
  ## minutes after generation.
  ## For more information about the signed URL usage see:
  ## https://cloud.google.com/storage/docs/access-control/signed-urls
  ## 
  let valid = call_580107.validator(path, query, header, formData, body)
  let scheme = call_580107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580107.url(scheme.get, call_580107.host, call_580107.base,
                         call_580107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580107, url, valid)

proc call*(call_580108: Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580091;
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
  var path_580109 = newJObject()
  var query_580110 = newJObject()
  var body_580111 = newJObject()
  add(query_580110, "upload_protocol", newJString(uploadProtocol))
  add(query_580110, "fields", newJString(fields))
  add(query_580110, "quotaUser", newJString(quotaUser))
  add(path_580109, "name", newJString(name))
  add(query_580110, "alt", newJString(alt))
  add(query_580110, "oauth_token", newJString(oauthToken))
  add(query_580110, "callback", newJString(callback))
  add(query_580110, "access_token", newJString(accessToken))
  add(query_580110, "uploadType", newJString(uploadType))
  add(query_580110, "key", newJString(key))
  add(query_580110, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580111 = body
  add(query_580110, "prettyPrint", newJBool(prettyPrint))
  result = call_580108.call(path_580109, query_580110, nil, nil, body_580111)

var cloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl* = Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580091(
    name: "cloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{name}:generateDownloadUrl", validator: validate_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580092,
    base: "/",
    url: url_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_580093,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsList_580112 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsList_580114(protocol: Scheme;
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

proc validate_CloudfunctionsProjectsLocationsFunctionsList_580113(path: JsonNode;
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
  var valid_580115 = path.getOrDefault("parent")
  valid_580115 = validateParameter(valid_580115, JString, required = true,
                                 default = nil)
  if valid_580115 != nil:
    section.add "parent", valid_580115
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
  var valid_580116 = query.getOrDefault("upload_protocol")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "upload_protocol", valid_580116
  var valid_580117 = query.getOrDefault("fields")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "fields", valid_580117
  var valid_580118 = query.getOrDefault("pageToken")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "pageToken", valid_580118
  var valid_580119 = query.getOrDefault("quotaUser")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "quotaUser", valid_580119
  var valid_580120 = query.getOrDefault("alt")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = newJString("json"))
  if valid_580120 != nil:
    section.add "alt", valid_580120
  var valid_580121 = query.getOrDefault("oauth_token")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "oauth_token", valid_580121
  var valid_580122 = query.getOrDefault("callback")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "callback", valid_580122
  var valid_580123 = query.getOrDefault("access_token")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "access_token", valid_580123
  var valid_580124 = query.getOrDefault("uploadType")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "uploadType", valid_580124
  var valid_580125 = query.getOrDefault("key")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "key", valid_580125
  var valid_580126 = query.getOrDefault("$.xgafv")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = newJString("1"))
  if valid_580126 != nil:
    section.add "$.xgafv", valid_580126
  var valid_580127 = query.getOrDefault("pageSize")
  valid_580127 = validateParameter(valid_580127, JInt, required = false, default = nil)
  if valid_580127 != nil:
    section.add "pageSize", valid_580127
  var valid_580128 = query.getOrDefault("prettyPrint")
  valid_580128 = validateParameter(valid_580128, JBool, required = false,
                                 default = newJBool(true))
  if valid_580128 != nil:
    section.add "prettyPrint", valid_580128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580129: Call_CloudfunctionsProjectsLocationsFunctionsList_580112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of functions that belong to the requested project.
  ## 
  let valid = call_580129.validator(path, query, header, formData, body)
  let scheme = call_580129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580129.url(scheme.get, call_580129.host, call_580129.base,
                         call_580129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580129, url, valid)

proc call*(call_580130: Call_CloudfunctionsProjectsLocationsFunctionsList_580112;
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
  var path_580131 = newJObject()
  var query_580132 = newJObject()
  add(query_580132, "upload_protocol", newJString(uploadProtocol))
  add(query_580132, "fields", newJString(fields))
  add(query_580132, "pageToken", newJString(pageToken))
  add(query_580132, "quotaUser", newJString(quotaUser))
  add(query_580132, "alt", newJString(alt))
  add(query_580132, "oauth_token", newJString(oauthToken))
  add(query_580132, "callback", newJString(callback))
  add(query_580132, "access_token", newJString(accessToken))
  add(query_580132, "uploadType", newJString(uploadType))
  add(path_580131, "parent", newJString(parent))
  add(query_580132, "key", newJString(key))
  add(query_580132, "$.xgafv", newJString(Xgafv))
  add(query_580132, "pageSize", newJInt(pageSize))
  add(query_580132, "prettyPrint", newJBool(prettyPrint))
  result = call_580130.call(path_580131, query_580132, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsList* = Call_CloudfunctionsProjectsLocationsFunctionsList_580112(
    name: "cloudfunctionsProjectsLocationsFunctionsList",
    meth: HttpMethod.HttpGet, host: "cloudfunctions.googleapis.com",
    route: "/v1/{parent}/functions",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsList_580113,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsList_580114,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580133 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580135(
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

proc validate_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580134(
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
  var valid_580136 = path.getOrDefault("parent")
  valid_580136 = validateParameter(valid_580136, JString, required = true,
                                 default = nil)
  if valid_580136 != nil:
    section.add "parent", valid_580136
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
  var valid_580137 = query.getOrDefault("upload_protocol")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "upload_protocol", valid_580137
  var valid_580138 = query.getOrDefault("fields")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "fields", valid_580138
  var valid_580139 = query.getOrDefault("quotaUser")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "quotaUser", valid_580139
  var valid_580140 = query.getOrDefault("alt")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("json"))
  if valid_580140 != nil:
    section.add "alt", valid_580140
  var valid_580141 = query.getOrDefault("oauth_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "oauth_token", valid_580141
  var valid_580142 = query.getOrDefault("callback")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "callback", valid_580142
  var valid_580143 = query.getOrDefault("access_token")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "access_token", valid_580143
  var valid_580144 = query.getOrDefault("uploadType")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "uploadType", valid_580144
  var valid_580145 = query.getOrDefault("key")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "key", valid_580145
  var valid_580146 = query.getOrDefault("$.xgafv")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = newJString("1"))
  if valid_580146 != nil:
    section.add "$.xgafv", valid_580146
  var valid_580147 = query.getOrDefault("prettyPrint")
  valid_580147 = validateParameter(valid_580147, JBool, required = false,
                                 default = newJBool(true))
  if valid_580147 != nil:
    section.add "prettyPrint", valid_580147
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

proc call*(call_580149: Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580133;
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
  let valid = call_580149.validator(path, query, header, formData, body)
  let scheme = call_580149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580149.url(scheme.get, call_580149.host, call_580149.base,
                         call_580149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580149, url, valid)

proc call*(call_580150: Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580133;
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
  var path_580151 = newJObject()
  var query_580152 = newJObject()
  var body_580153 = newJObject()
  add(query_580152, "upload_protocol", newJString(uploadProtocol))
  add(query_580152, "fields", newJString(fields))
  add(query_580152, "quotaUser", newJString(quotaUser))
  add(query_580152, "alt", newJString(alt))
  add(query_580152, "oauth_token", newJString(oauthToken))
  add(query_580152, "callback", newJString(callback))
  add(query_580152, "access_token", newJString(accessToken))
  add(query_580152, "uploadType", newJString(uploadType))
  add(path_580151, "parent", newJString(parent))
  add(query_580152, "key", newJString(key))
  add(query_580152, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580153 = body
  add(query_580152, "prettyPrint", newJBool(prettyPrint))
  result = call_580150.call(path_580151, query_580152, nil, nil, body_580153)

var cloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl* = Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580133(
    name: "cloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{parent}/functions:generateUploadUrl", validator: validate_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580134,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_580135,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_580154 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_580156(
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

proc validate_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_580155(
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
  var valid_580157 = path.getOrDefault("resource")
  valid_580157 = validateParameter(valid_580157, JString, required = true,
                                 default = nil)
  if valid_580157 != nil:
    section.add "resource", valid_580157
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
  ## Acceptable values are 0, 1, and 3.
  ## If the value is 0, or the field is omitted, policy format version 1 will be
  ## returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580158 = query.getOrDefault("upload_protocol")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "upload_protocol", valid_580158
  var valid_580159 = query.getOrDefault("fields")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "fields", valid_580159
  var valid_580160 = query.getOrDefault("quotaUser")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "quotaUser", valid_580160
  var valid_580161 = query.getOrDefault("alt")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = newJString("json"))
  if valid_580161 != nil:
    section.add "alt", valid_580161
  var valid_580162 = query.getOrDefault("oauth_token")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "oauth_token", valid_580162
  var valid_580163 = query.getOrDefault("callback")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "callback", valid_580163
  var valid_580164 = query.getOrDefault("access_token")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "access_token", valid_580164
  var valid_580165 = query.getOrDefault("uploadType")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "uploadType", valid_580165
  var valid_580166 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580166 = validateParameter(valid_580166, JInt, required = false, default = nil)
  if valid_580166 != nil:
    section.add "options.requestedPolicyVersion", valid_580166
  var valid_580167 = query.getOrDefault("key")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "key", valid_580167
  var valid_580168 = query.getOrDefault("$.xgafv")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = newJString("1"))
  if valid_580168 != nil:
    section.add "$.xgafv", valid_580168
  var valid_580169 = query.getOrDefault("prettyPrint")
  valid_580169 = validateParameter(valid_580169, JBool, required = false,
                                 default = newJBool(true))
  if valid_580169 != nil:
    section.add "prettyPrint", valid_580169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580170: Call_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_580154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the IAM access control policy for a function.
  ## Returns an empty policy if the function exists and does not have a policy
  ## set.
  ## 
  let valid = call_580170.validator(path, query, header, formData, body)
  let scheme = call_580170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580170.url(scheme.get, call_580170.host, call_580170.base,
                         call_580170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580170, url, valid)

proc call*(call_580171: Call_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_580154;
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
  ## Acceptable values are 0, 1, and 3.
  ## If the value is 0, or the field is omitted, policy format version 1 will be
  ## returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580172 = newJObject()
  var query_580173 = newJObject()
  add(query_580173, "upload_protocol", newJString(uploadProtocol))
  add(query_580173, "fields", newJString(fields))
  add(query_580173, "quotaUser", newJString(quotaUser))
  add(query_580173, "alt", newJString(alt))
  add(query_580173, "oauth_token", newJString(oauthToken))
  add(query_580173, "callback", newJString(callback))
  add(query_580173, "access_token", newJString(accessToken))
  add(query_580173, "uploadType", newJString(uploadType))
  add(query_580173, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580173, "key", newJString(key))
  add(query_580173, "$.xgafv", newJString(Xgafv))
  add(path_580172, "resource", newJString(resource))
  add(query_580173, "prettyPrint", newJBool(prettyPrint))
  result = call_580171.call(path_580172, query_580173, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsGetIamPolicy* = Call_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_580154(
    name: "cloudfunctionsProjectsLocationsFunctionsGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "cloudfunctions.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_580155,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_580156,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_580174 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_580176(
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

proc validate_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_580175(
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
  var valid_580177 = path.getOrDefault("resource")
  valid_580177 = validateParameter(valid_580177, JString, required = true,
                                 default = nil)
  if valid_580177 != nil:
    section.add "resource", valid_580177
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
  var valid_580178 = query.getOrDefault("upload_protocol")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "upload_protocol", valid_580178
  var valid_580179 = query.getOrDefault("fields")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "fields", valid_580179
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
  var valid_580182 = query.getOrDefault("oauth_token")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "oauth_token", valid_580182
  var valid_580183 = query.getOrDefault("callback")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "callback", valid_580183
  var valid_580184 = query.getOrDefault("access_token")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "access_token", valid_580184
  var valid_580185 = query.getOrDefault("uploadType")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "uploadType", valid_580185
  var valid_580186 = query.getOrDefault("key")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "key", valid_580186
  var valid_580187 = query.getOrDefault("$.xgafv")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("1"))
  if valid_580187 != nil:
    section.add "$.xgafv", valid_580187
  var valid_580188 = query.getOrDefault("prettyPrint")
  valid_580188 = validateParameter(valid_580188, JBool, required = false,
                                 default = newJBool(true))
  if valid_580188 != nil:
    section.add "prettyPrint", valid_580188
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

proc call*(call_580190: Call_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_580174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM access control policy on the specified function.
  ## Replaces any existing policy.
  ## 
  let valid = call_580190.validator(path, query, header, formData, body)
  let scheme = call_580190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580190.url(scheme.get, call_580190.host, call_580190.base,
                         call_580190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580190, url, valid)

proc call*(call_580191: Call_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_580174;
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
  var path_580192 = newJObject()
  var query_580193 = newJObject()
  var body_580194 = newJObject()
  add(query_580193, "upload_protocol", newJString(uploadProtocol))
  add(query_580193, "fields", newJString(fields))
  add(query_580193, "quotaUser", newJString(quotaUser))
  add(query_580193, "alt", newJString(alt))
  add(query_580193, "oauth_token", newJString(oauthToken))
  add(query_580193, "callback", newJString(callback))
  add(query_580193, "access_token", newJString(accessToken))
  add(query_580193, "uploadType", newJString(uploadType))
  add(query_580193, "key", newJString(key))
  add(query_580193, "$.xgafv", newJString(Xgafv))
  add(path_580192, "resource", newJString(resource))
  if body != nil:
    body_580194 = body
  add(query_580193, "prettyPrint", newJBool(prettyPrint))
  result = call_580191.call(path_580192, query_580193, nil, nil, body_580194)

var cloudfunctionsProjectsLocationsFunctionsSetIamPolicy* = Call_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_580174(
    name: "cloudfunctionsProjectsLocationsFunctionsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_580175,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_580176,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_580195 = ref object of OpenApiRestCall_579408
proc url_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_580197(
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

proc validate_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_580196(
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
  var valid_580198 = path.getOrDefault("resource")
  valid_580198 = validateParameter(valid_580198, JString, required = true,
                                 default = nil)
  if valid_580198 != nil:
    section.add "resource", valid_580198
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
  var valid_580199 = query.getOrDefault("upload_protocol")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "upload_protocol", valid_580199
  var valid_580200 = query.getOrDefault("fields")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "fields", valid_580200
  var valid_580201 = query.getOrDefault("quotaUser")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "quotaUser", valid_580201
  var valid_580202 = query.getOrDefault("alt")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = newJString("json"))
  if valid_580202 != nil:
    section.add "alt", valid_580202
  var valid_580203 = query.getOrDefault("oauth_token")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "oauth_token", valid_580203
  var valid_580204 = query.getOrDefault("callback")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "callback", valid_580204
  var valid_580205 = query.getOrDefault("access_token")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "access_token", valid_580205
  var valid_580206 = query.getOrDefault("uploadType")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "uploadType", valid_580206
  var valid_580207 = query.getOrDefault("key")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "key", valid_580207
  var valid_580208 = query.getOrDefault("$.xgafv")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = newJString("1"))
  if valid_580208 != nil:
    section.add "$.xgafv", valid_580208
  var valid_580209 = query.getOrDefault("prettyPrint")
  valid_580209 = validateParameter(valid_580209, JBool, required = false,
                                 default = newJBool(true))
  if valid_580209 != nil:
    section.add "prettyPrint", valid_580209
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

proc call*(call_580211: Call_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_580195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the specified permissions against the IAM access control policy
  ## for a function.
  ## If the function does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  let valid = call_580211.validator(path, query, header, formData, body)
  let scheme = call_580211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580211.url(scheme.get, call_580211.host, call_580211.base,
                         call_580211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580211, url, valid)

proc call*(call_580212: Call_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_580195;
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
  var path_580213 = newJObject()
  var query_580214 = newJObject()
  var body_580215 = newJObject()
  add(query_580214, "upload_protocol", newJString(uploadProtocol))
  add(query_580214, "fields", newJString(fields))
  add(query_580214, "quotaUser", newJString(quotaUser))
  add(query_580214, "alt", newJString(alt))
  add(query_580214, "oauth_token", newJString(oauthToken))
  add(query_580214, "callback", newJString(callback))
  add(query_580214, "access_token", newJString(accessToken))
  add(query_580214, "uploadType", newJString(uploadType))
  add(query_580214, "key", newJString(key))
  add(query_580214, "$.xgafv", newJString(Xgafv))
  add(path_580213, "resource", newJString(resource))
  if body != nil:
    body_580215 = body
  add(query_580214, "prettyPrint", newJBool(prettyPrint))
  result = call_580212.call(path_580213, query_580214, nil, nil, body_580215)

var cloudfunctionsProjectsLocationsFunctionsTestIamPermissions* = Call_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_580195(
    name: "cloudfunctionsProjectsLocationsFunctionsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{resource}:testIamPermissions", validator: validate_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_580196,
    base: "/",
    url: url_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_580197,
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
