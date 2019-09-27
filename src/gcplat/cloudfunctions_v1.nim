
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudfunctionsOperationsList_597677 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsOperationsList_597679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudfunctionsOperationsList_597678(path: JsonNode; query: JsonNode;
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
  var valid_597791 = query.getOrDefault("upload_protocol")
  valid_597791 = validateParameter(valid_597791, JString, required = false,
                                 default = nil)
  if valid_597791 != nil:
    section.add "upload_protocol", valid_597791
  var valid_597792 = query.getOrDefault("fields")
  valid_597792 = validateParameter(valid_597792, JString, required = false,
                                 default = nil)
  if valid_597792 != nil:
    section.add "fields", valid_597792
  var valid_597793 = query.getOrDefault("pageToken")
  valid_597793 = validateParameter(valid_597793, JString, required = false,
                                 default = nil)
  if valid_597793 != nil:
    section.add "pageToken", valid_597793
  var valid_597794 = query.getOrDefault("quotaUser")
  valid_597794 = validateParameter(valid_597794, JString, required = false,
                                 default = nil)
  if valid_597794 != nil:
    section.add "quotaUser", valid_597794
  var valid_597808 = query.getOrDefault("alt")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = newJString("json"))
  if valid_597808 != nil:
    section.add "alt", valid_597808
  var valid_597809 = query.getOrDefault("oauth_token")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "oauth_token", valid_597809
  var valid_597810 = query.getOrDefault("callback")
  valid_597810 = validateParameter(valid_597810, JString, required = false,
                                 default = nil)
  if valid_597810 != nil:
    section.add "callback", valid_597810
  var valid_597811 = query.getOrDefault("access_token")
  valid_597811 = validateParameter(valid_597811, JString, required = false,
                                 default = nil)
  if valid_597811 != nil:
    section.add "access_token", valid_597811
  var valid_597812 = query.getOrDefault("uploadType")
  valid_597812 = validateParameter(valid_597812, JString, required = false,
                                 default = nil)
  if valid_597812 != nil:
    section.add "uploadType", valid_597812
  var valid_597813 = query.getOrDefault("key")
  valid_597813 = validateParameter(valid_597813, JString, required = false,
                                 default = nil)
  if valid_597813 != nil:
    section.add "key", valid_597813
  var valid_597814 = query.getOrDefault("name")
  valid_597814 = validateParameter(valid_597814, JString, required = false,
                                 default = nil)
  if valid_597814 != nil:
    section.add "name", valid_597814
  var valid_597815 = query.getOrDefault("$.xgafv")
  valid_597815 = validateParameter(valid_597815, JString, required = false,
                                 default = newJString("1"))
  if valid_597815 != nil:
    section.add "$.xgafv", valid_597815
  var valid_597816 = query.getOrDefault("pageSize")
  valid_597816 = validateParameter(valid_597816, JInt, required = false, default = nil)
  if valid_597816 != nil:
    section.add "pageSize", valid_597816
  var valid_597817 = query.getOrDefault("prettyPrint")
  valid_597817 = validateParameter(valid_597817, JBool, required = false,
                                 default = newJBool(true))
  if valid_597817 != nil:
    section.add "prettyPrint", valid_597817
  var valid_597818 = query.getOrDefault("filter")
  valid_597818 = validateParameter(valid_597818, JString, required = false,
                                 default = nil)
  if valid_597818 != nil:
    section.add "filter", valid_597818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597841: Call_CloudfunctionsOperationsList_597677; path: JsonNode;
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
  let valid = call_597841.validator(path, query, header, formData, body)
  let scheme = call_597841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597841.url(scheme.get, call_597841.host, call_597841.base,
                         call_597841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597841, url, valid)

proc call*(call_597912: Call_CloudfunctionsOperationsList_597677;
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
  var query_597913 = newJObject()
  add(query_597913, "upload_protocol", newJString(uploadProtocol))
  add(query_597913, "fields", newJString(fields))
  add(query_597913, "pageToken", newJString(pageToken))
  add(query_597913, "quotaUser", newJString(quotaUser))
  add(query_597913, "alt", newJString(alt))
  add(query_597913, "oauth_token", newJString(oauthToken))
  add(query_597913, "callback", newJString(callback))
  add(query_597913, "access_token", newJString(accessToken))
  add(query_597913, "uploadType", newJString(uploadType))
  add(query_597913, "key", newJString(key))
  add(query_597913, "name", newJString(name))
  add(query_597913, "$.xgafv", newJString(Xgafv))
  add(query_597913, "pageSize", newJInt(pageSize))
  add(query_597913, "prettyPrint", newJBool(prettyPrint))
  add(query_597913, "filter", newJString(filter))
  result = call_597912.call(nil, query_597913, nil, nil, nil)

var cloudfunctionsOperationsList* = Call_CloudfunctionsOperationsList_597677(
    name: "cloudfunctionsOperationsList", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1/operations",
    validator: validate_CloudfunctionsOperationsList_597678, base: "/",
    url: url_CloudfunctionsOperationsList_597679, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsCreate_597953 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsCreate_597955(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudfunctionsProjectsLocationsFunctionsCreate_597954(
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
  var valid_597970 = path.getOrDefault("location")
  valid_597970 = validateParameter(valid_597970, JString, required = true,
                                 default = nil)
  if valid_597970 != nil:
    section.add "location", valid_597970
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
  var valid_597971 = query.getOrDefault("upload_protocol")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "upload_protocol", valid_597971
  var valid_597972 = query.getOrDefault("fields")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "fields", valid_597972
  var valid_597973 = query.getOrDefault("quotaUser")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "quotaUser", valid_597973
  var valid_597974 = query.getOrDefault("alt")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = newJString("json"))
  if valid_597974 != nil:
    section.add "alt", valid_597974
  var valid_597975 = query.getOrDefault("oauth_token")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "oauth_token", valid_597975
  var valid_597976 = query.getOrDefault("callback")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "callback", valid_597976
  var valid_597977 = query.getOrDefault("access_token")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "access_token", valid_597977
  var valid_597978 = query.getOrDefault("uploadType")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "uploadType", valid_597978
  var valid_597979 = query.getOrDefault("key")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "key", valid_597979
  var valid_597980 = query.getOrDefault("$.xgafv")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = newJString("1"))
  if valid_597980 != nil:
    section.add "$.xgafv", valid_597980
  var valid_597981 = query.getOrDefault("prettyPrint")
  valid_597981 = validateParameter(valid_597981, JBool, required = false,
                                 default = newJBool(true))
  if valid_597981 != nil:
    section.add "prettyPrint", valid_597981
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

proc call*(call_597983: Call_CloudfunctionsProjectsLocationsFunctionsCreate_597953;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new function. If a function with the given name already exists in
  ## the specified project, the long running operation will return
  ## `ALREADY_EXISTS` error.
  ## 
  let valid = call_597983.validator(path, query, header, formData, body)
  let scheme = call_597983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597983.url(scheme.get, call_597983.host, call_597983.base,
                         call_597983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597983, url, valid)

proc call*(call_597984: Call_CloudfunctionsProjectsLocationsFunctionsCreate_597953;
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
  var path_597985 = newJObject()
  var query_597986 = newJObject()
  var body_597987 = newJObject()
  add(query_597986, "upload_protocol", newJString(uploadProtocol))
  add(query_597986, "fields", newJString(fields))
  add(query_597986, "quotaUser", newJString(quotaUser))
  add(query_597986, "alt", newJString(alt))
  add(query_597986, "oauth_token", newJString(oauthToken))
  add(query_597986, "callback", newJString(callback))
  add(query_597986, "access_token", newJString(accessToken))
  add(query_597986, "uploadType", newJString(uploadType))
  add(query_597986, "key", newJString(key))
  add(query_597986, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597987 = body
  add(query_597986, "prettyPrint", newJBool(prettyPrint))
  add(path_597985, "location", newJString(location))
  result = call_597984.call(path_597985, query_597986, nil, nil, body_597987)

var cloudfunctionsProjectsLocationsFunctionsCreate* = Call_CloudfunctionsProjectsLocationsFunctionsCreate_597953(
    name: "cloudfunctionsProjectsLocationsFunctionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{location}/functions",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsCreate_597954,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsCreate_597955,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsOperationsGet_597988 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsOperationsGet_597990(protocol: Scheme; host: string;
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

proc validate_CloudfunctionsOperationsGet_597989(path: JsonNode; query: JsonNode;
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
  var valid_597991 = path.getOrDefault("name")
  valid_597991 = validateParameter(valid_597991, JString, required = true,
                                 default = nil)
  if valid_597991 != nil:
    section.add "name", valid_597991
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
  var valid_597992 = query.getOrDefault("upload_protocol")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "upload_protocol", valid_597992
  var valid_597993 = query.getOrDefault("fields")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "fields", valid_597993
  var valid_597994 = query.getOrDefault("quotaUser")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "quotaUser", valid_597994
  var valid_597995 = query.getOrDefault("alt")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = newJString("json"))
  if valid_597995 != nil:
    section.add "alt", valid_597995
  var valid_597996 = query.getOrDefault("oauth_token")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "oauth_token", valid_597996
  var valid_597997 = query.getOrDefault("callback")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "callback", valid_597997
  var valid_597998 = query.getOrDefault("access_token")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "access_token", valid_597998
  var valid_597999 = query.getOrDefault("uploadType")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "uploadType", valid_597999
  var valid_598000 = query.getOrDefault("key")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "key", valid_598000
  var valid_598001 = query.getOrDefault("$.xgafv")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = newJString("1"))
  if valid_598001 != nil:
    section.add "$.xgafv", valid_598001
  var valid_598002 = query.getOrDefault("prettyPrint")
  valid_598002 = validateParameter(valid_598002, JBool, required = false,
                                 default = newJBool(true))
  if valid_598002 != nil:
    section.add "prettyPrint", valid_598002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598003: Call_CloudfunctionsOperationsGet_597988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_598003.validator(path, query, header, formData, body)
  let scheme = call_598003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598003.url(scheme.get, call_598003.host, call_598003.base,
                         call_598003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598003, url, valid)

proc call*(call_598004: Call_CloudfunctionsOperationsGet_597988; name: string;
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
  var path_598005 = newJObject()
  var query_598006 = newJObject()
  add(query_598006, "upload_protocol", newJString(uploadProtocol))
  add(query_598006, "fields", newJString(fields))
  add(query_598006, "quotaUser", newJString(quotaUser))
  add(path_598005, "name", newJString(name))
  add(query_598006, "alt", newJString(alt))
  add(query_598006, "oauth_token", newJString(oauthToken))
  add(query_598006, "callback", newJString(callback))
  add(query_598006, "access_token", newJString(accessToken))
  add(query_598006, "uploadType", newJString(uploadType))
  add(query_598006, "key", newJString(key))
  add(query_598006, "$.xgafv", newJString(Xgafv))
  add(query_598006, "prettyPrint", newJBool(prettyPrint))
  result = call_598004.call(path_598005, query_598006, nil, nil, nil)

var cloudfunctionsOperationsGet* = Call_CloudfunctionsOperationsGet_597988(
    name: "cloudfunctionsOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudfunctionsOperationsGet_597989, base: "/",
    url: url_CloudfunctionsOperationsGet_597990, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsPatch_598026 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsPatch_598028(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_CloudfunctionsProjectsLocationsFunctionsPatch_598027(
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
  var valid_598029 = path.getOrDefault("name")
  valid_598029 = validateParameter(valid_598029, JString, required = true,
                                 default = nil)
  if valid_598029 != nil:
    section.add "name", valid_598029
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
  var valid_598030 = query.getOrDefault("upload_protocol")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "upload_protocol", valid_598030
  var valid_598031 = query.getOrDefault("fields")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "fields", valid_598031
  var valid_598032 = query.getOrDefault("quotaUser")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "quotaUser", valid_598032
  var valid_598033 = query.getOrDefault("alt")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = newJString("json"))
  if valid_598033 != nil:
    section.add "alt", valid_598033
  var valid_598034 = query.getOrDefault("oauth_token")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "oauth_token", valid_598034
  var valid_598035 = query.getOrDefault("callback")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "callback", valid_598035
  var valid_598036 = query.getOrDefault("access_token")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "access_token", valid_598036
  var valid_598037 = query.getOrDefault("uploadType")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "uploadType", valid_598037
  var valid_598038 = query.getOrDefault("key")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "key", valid_598038
  var valid_598039 = query.getOrDefault("$.xgafv")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = newJString("1"))
  if valid_598039 != nil:
    section.add "$.xgafv", valid_598039
  var valid_598040 = query.getOrDefault("prettyPrint")
  valid_598040 = validateParameter(valid_598040, JBool, required = false,
                                 default = newJBool(true))
  if valid_598040 != nil:
    section.add "prettyPrint", valid_598040
  var valid_598041 = query.getOrDefault("updateMask")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "updateMask", valid_598041
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

proc call*(call_598043: Call_CloudfunctionsProjectsLocationsFunctionsPatch_598026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates existing function.
  ## 
  let valid = call_598043.validator(path, query, header, formData, body)
  let scheme = call_598043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598043.url(scheme.get, call_598043.host, call_598043.base,
                         call_598043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598043, url, valid)

proc call*(call_598044: Call_CloudfunctionsProjectsLocationsFunctionsPatch_598026;
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
  var path_598045 = newJObject()
  var query_598046 = newJObject()
  var body_598047 = newJObject()
  add(query_598046, "upload_protocol", newJString(uploadProtocol))
  add(query_598046, "fields", newJString(fields))
  add(query_598046, "quotaUser", newJString(quotaUser))
  add(path_598045, "name", newJString(name))
  add(query_598046, "alt", newJString(alt))
  add(query_598046, "oauth_token", newJString(oauthToken))
  add(query_598046, "callback", newJString(callback))
  add(query_598046, "access_token", newJString(accessToken))
  add(query_598046, "uploadType", newJString(uploadType))
  add(query_598046, "key", newJString(key))
  add(query_598046, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598047 = body
  add(query_598046, "prettyPrint", newJBool(prettyPrint))
  add(query_598046, "updateMask", newJString(updateMask))
  result = call_598044.call(path_598045, query_598046, nil, nil, body_598047)

var cloudfunctionsProjectsLocationsFunctionsPatch* = Call_CloudfunctionsProjectsLocationsFunctionsPatch_598026(
    name: "cloudfunctionsProjectsLocationsFunctionsPatch",
    meth: HttpMethod.HttpPatch, host: "cloudfunctions.googleapis.com",
    route: "/v1/{name}",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsPatch_598027,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsPatch_598028,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsDelete_598007 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsDelete_598009(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_CloudfunctionsProjectsLocationsFunctionsDelete_598008(
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
  var valid_598010 = path.getOrDefault("name")
  valid_598010 = validateParameter(valid_598010, JString, required = true,
                                 default = nil)
  if valid_598010 != nil:
    section.add "name", valid_598010
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
  var valid_598011 = query.getOrDefault("upload_protocol")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "upload_protocol", valid_598011
  var valid_598012 = query.getOrDefault("fields")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "fields", valid_598012
  var valid_598013 = query.getOrDefault("quotaUser")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "quotaUser", valid_598013
  var valid_598014 = query.getOrDefault("alt")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = newJString("json"))
  if valid_598014 != nil:
    section.add "alt", valid_598014
  var valid_598015 = query.getOrDefault("oauth_token")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "oauth_token", valid_598015
  var valid_598016 = query.getOrDefault("callback")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "callback", valid_598016
  var valid_598017 = query.getOrDefault("access_token")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "access_token", valid_598017
  var valid_598018 = query.getOrDefault("uploadType")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "uploadType", valid_598018
  var valid_598019 = query.getOrDefault("key")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "key", valid_598019
  var valid_598020 = query.getOrDefault("$.xgafv")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = newJString("1"))
  if valid_598020 != nil:
    section.add "$.xgafv", valid_598020
  var valid_598021 = query.getOrDefault("prettyPrint")
  valid_598021 = validateParameter(valid_598021, JBool, required = false,
                                 default = newJBool(true))
  if valid_598021 != nil:
    section.add "prettyPrint", valid_598021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598022: Call_CloudfunctionsProjectsLocationsFunctionsDelete_598007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a function with the given name from the specified project. If the
  ## given function is used by some trigger, the trigger will be updated to
  ## remove this function.
  ## 
  let valid = call_598022.validator(path, query, header, formData, body)
  let scheme = call_598022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598022.url(scheme.get, call_598022.host, call_598022.base,
                         call_598022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598022, url, valid)

proc call*(call_598023: Call_CloudfunctionsProjectsLocationsFunctionsDelete_598007;
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
  var path_598024 = newJObject()
  var query_598025 = newJObject()
  add(query_598025, "upload_protocol", newJString(uploadProtocol))
  add(query_598025, "fields", newJString(fields))
  add(query_598025, "quotaUser", newJString(quotaUser))
  add(path_598024, "name", newJString(name))
  add(query_598025, "alt", newJString(alt))
  add(query_598025, "oauth_token", newJString(oauthToken))
  add(query_598025, "callback", newJString(callback))
  add(query_598025, "access_token", newJString(accessToken))
  add(query_598025, "uploadType", newJString(uploadType))
  add(query_598025, "key", newJString(key))
  add(query_598025, "$.xgafv", newJString(Xgafv))
  add(query_598025, "prettyPrint", newJBool(prettyPrint))
  result = call_598023.call(path_598024, query_598025, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsDelete* = Call_CloudfunctionsProjectsLocationsFunctionsDelete_598007(
    name: "cloudfunctionsProjectsLocationsFunctionsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudfunctions.googleapis.com",
    route: "/v1/{name}",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsDelete_598008,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsDelete_598009,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsList_598048 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsList_598050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudfunctionsProjectsLocationsList_598049(path: JsonNode;
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
  var valid_598051 = path.getOrDefault("name")
  valid_598051 = validateParameter(valid_598051, JString, required = true,
                                 default = nil)
  if valid_598051 != nil:
    section.add "name", valid_598051
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
  var valid_598052 = query.getOrDefault("upload_protocol")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "upload_protocol", valid_598052
  var valid_598053 = query.getOrDefault("fields")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "fields", valid_598053
  var valid_598054 = query.getOrDefault("pageToken")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "pageToken", valid_598054
  var valid_598055 = query.getOrDefault("quotaUser")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "quotaUser", valid_598055
  var valid_598056 = query.getOrDefault("alt")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = newJString("json"))
  if valid_598056 != nil:
    section.add "alt", valid_598056
  var valid_598057 = query.getOrDefault("oauth_token")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "oauth_token", valid_598057
  var valid_598058 = query.getOrDefault("callback")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "callback", valid_598058
  var valid_598059 = query.getOrDefault("access_token")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "access_token", valid_598059
  var valid_598060 = query.getOrDefault("uploadType")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "uploadType", valid_598060
  var valid_598061 = query.getOrDefault("key")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "key", valid_598061
  var valid_598062 = query.getOrDefault("$.xgafv")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = newJString("1"))
  if valid_598062 != nil:
    section.add "$.xgafv", valid_598062
  var valid_598063 = query.getOrDefault("pageSize")
  valid_598063 = validateParameter(valid_598063, JInt, required = false, default = nil)
  if valid_598063 != nil:
    section.add "pageSize", valid_598063
  var valid_598064 = query.getOrDefault("prettyPrint")
  valid_598064 = validateParameter(valid_598064, JBool, required = false,
                                 default = newJBool(true))
  if valid_598064 != nil:
    section.add "prettyPrint", valid_598064
  var valid_598065 = query.getOrDefault("filter")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = nil)
  if valid_598065 != nil:
    section.add "filter", valid_598065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598066: Call_CloudfunctionsProjectsLocationsList_598048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_598066.validator(path, query, header, formData, body)
  let scheme = call_598066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598066.url(scheme.get, call_598066.host, call_598066.base,
                         call_598066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598066, url, valid)

proc call*(call_598067: Call_CloudfunctionsProjectsLocationsList_598048;
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
  var path_598068 = newJObject()
  var query_598069 = newJObject()
  add(query_598069, "upload_protocol", newJString(uploadProtocol))
  add(query_598069, "fields", newJString(fields))
  add(query_598069, "pageToken", newJString(pageToken))
  add(query_598069, "quotaUser", newJString(quotaUser))
  add(path_598068, "name", newJString(name))
  add(query_598069, "alt", newJString(alt))
  add(query_598069, "oauth_token", newJString(oauthToken))
  add(query_598069, "callback", newJString(callback))
  add(query_598069, "access_token", newJString(accessToken))
  add(query_598069, "uploadType", newJString(uploadType))
  add(query_598069, "key", newJString(key))
  add(query_598069, "$.xgafv", newJString(Xgafv))
  add(query_598069, "pageSize", newJInt(pageSize))
  add(query_598069, "prettyPrint", newJBool(prettyPrint))
  add(query_598069, "filter", newJString(filter))
  result = call_598067.call(path_598068, query_598069, nil, nil, nil)

var cloudfunctionsProjectsLocationsList* = Call_CloudfunctionsProjectsLocationsList_598048(
    name: "cloudfunctionsProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_CloudfunctionsProjectsLocationsList_598049, base: "/",
    url: url_CloudfunctionsProjectsLocationsList_598050, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsCall_598070 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsCall_598072(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudfunctionsProjectsLocationsFunctionsCall_598071(path: JsonNode;
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
  var valid_598073 = path.getOrDefault("name")
  valid_598073 = validateParameter(valid_598073, JString, required = true,
                                 default = nil)
  if valid_598073 != nil:
    section.add "name", valid_598073
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
  var valid_598074 = query.getOrDefault("upload_protocol")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "upload_protocol", valid_598074
  var valid_598075 = query.getOrDefault("fields")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "fields", valid_598075
  var valid_598076 = query.getOrDefault("quotaUser")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "quotaUser", valid_598076
  var valid_598077 = query.getOrDefault("alt")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = newJString("json"))
  if valid_598077 != nil:
    section.add "alt", valid_598077
  var valid_598078 = query.getOrDefault("oauth_token")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "oauth_token", valid_598078
  var valid_598079 = query.getOrDefault("callback")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "callback", valid_598079
  var valid_598080 = query.getOrDefault("access_token")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "access_token", valid_598080
  var valid_598081 = query.getOrDefault("uploadType")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "uploadType", valid_598081
  var valid_598082 = query.getOrDefault("key")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "key", valid_598082
  var valid_598083 = query.getOrDefault("$.xgafv")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = newJString("1"))
  if valid_598083 != nil:
    section.add "$.xgafv", valid_598083
  var valid_598084 = query.getOrDefault("prettyPrint")
  valid_598084 = validateParameter(valid_598084, JBool, required = false,
                                 default = newJBool(true))
  if valid_598084 != nil:
    section.add "prettyPrint", valid_598084
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

proc call*(call_598086: Call_CloudfunctionsProjectsLocationsFunctionsCall_598070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Synchronously invokes a deployed Cloud Function. To be used for testing
  ## purposes as very limited traffic is allowed. For more information on
  ## the actual limits, refer to
  ## [Rate Limits](https://cloud.google.com/functions/quotas#rate_limits).
  ## 
  let valid = call_598086.validator(path, query, header, formData, body)
  let scheme = call_598086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598086.url(scheme.get, call_598086.host, call_598086.base,
                         call_598086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598086, url, valid)

proc call*(call_598087: Call_CloudfunctionsProjectsLocationsFunctionsCall_598070;
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
  var path_598088 = newJObject()
  var query_598089 = newJObject()
  var body_598090 = newJObject()
  add(query_598089, "upload_protocol", newJString(uploadProtocol))
  add(query_598089, "fields", newJString(fields))
  add(query_598089, "quotaUser", newJString(quotaUser))
  add(path_598088, "name", newJString(name))
  add(query_598089, "alt", newJString(alt))
  add(query_598089, "oauth_token", newJString(oauthToken))
  add(query_598089, "callback", newJString(callback))
  add(query_598089, "access_token", newJString(accessToken))
  add(query_598089, "uploadType", newJString(uploadType))
  add(query_598089, "key", newJString(key))
  add(query_598089, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598090 = body
  add(query_598089, "prettyPrint", newJBool(prettyPrint))
  result = call_598087.call(path_598088, query_598089, nil, nil, body_598090)

var cloudfunctionsProjectsLocationsFunctionsCall* = Call_CloudfunctionsProjectsLocationsFunctionsCall_598070(
    name: "cloudfunctionsProjectsLocationsFunctionsCall",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{name}:call",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsCall_598071,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsCall_598072,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598091 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598093(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598092(
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
  var valid_598094 = path.getOrDefault("name")
  valid_598094 = validateParameter(valid_598094, JString, required = true,
                                 default = nil)
  if valid_598094 != nil:
    section.add "name", valid_598094
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
  var valid_598095 = query.getOrDefault("upload_protocol")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "upload_protocol", valid_598095
  var valid_598096 = query.getOrDefault("fields")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "fields", valid_598096
  var valid_598097 = query.getOrDefault("quotaUser")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "quotaUser", valid_598097
  var valid_598098 = query.getOrDefault("alt")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = newJString("json"))
  if valid_598098 != nil:
    section.add "alt", valid_598098
  var valid_598099 = query.getOrDefault("oauth_token")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "oauth_token", valid_598099
  var valid_598100 = query.getOrDefault("callback")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "callback", valid_598100
  var valid_598101 = query.getOrDefault("access_token")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "access_token", valid_598101
  var valid_598102 = query.getOrDefault("uploadType")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "uploadType", valid_598102
  var valid_598103 = query.getOrDefault("key")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "key", valid_598103
  var valid_598104 = query.getOrDefault("$.xgafv")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = newJString("1"))
  if valid_598104 != nil:
    section.add "$.xgafv", valid_598104
  var valid_598105 = query.getOrDefault("prettyPrint")
  valid_598105 = validateParameter(valid_598105, JBool, required = false,
                                 default = newJBool(true))
  if valid_598105 != nil:
    section.add "prettyPrint", valid_598105
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

proc call*(call_598107: Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a signed URL for downloading deployed function source code.
  ## The URL is only valid for a limited period and should be used within
  ## minutes after generation.
  ## For more information about the signed URL usage see:
  ## https://cloud.google.com/storage/docs/access-control/signed-urls
  ## 
  let valid = call_598107.validator(path, query, header, formData, body)
  let scheme = call_598107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598107.url(scheme.get, call_598107.host, call_598107.base,
                         call_598107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598107, url, valid)

proc call*(call_598108: Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598091;
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
  var path_598109 = newJObject()
  var query_598110 = newJObject()
  var body_598111 = newJObject()
  add(query_598110, "upload_protocol", newJString(uploadProtocol))
  add(query_598110, "fields", newJString(fields))
  add(query_598110, "quotaUser", newJString(quotaUser))
  add(path_598109, "name", newJString(name))
  add(query_598110, "alt", newJString(alt))
  add(query_598110, "oauth_token", newJString(oauthToken))
  add(query_598110, "callback", newJString(callback))
  add(query_598110, "access_token", newJString(accessToken))
  add(query_598110, "uploadType", newJString(uploadType))
  add(query_598110, "key", newJString(key))
  add(query_598110, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598111 = body
  add(query_598110, "prettyPrint", newJBool(prettyPrint))
  result = call_598108.call(path_598109, query_598110, nil, nil, body_598111)

var cloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl* = Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598091(
    name: "cloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{name}:generateDownloadUrl", validator: validate_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598092,
    base: "/",
    url: url_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598093,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsList_598112 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsList_598114(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudfunctionsProjectsLocationsFunctionsList_598113(path: JsonNode;
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
  var valid_598115 = path.getOrDefault("parent")
  valid_598115 = validateParameter(valid_598115, JString, required = true,
                                 default = nil)
  if valid_598115 != nil:
    section.add "parent", valid_598115
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
  var valid_598116 = query.getOrDefault("upload_protocol")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "upload_protocol", valid_598116
  var valid_598117 = query.getOrDefault("fields")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "fields", valid_598117
  var valid_598118 = query.getOrDefault("pageToken")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "pageToken", valid_598118
  var valid_598119 = query.getOrDefault("quotaUser")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "quotaUser", valid_598119
  var valid_598120 = query.getOrDefault("alt")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = newJString("json"))
  if valid_598120 != nil:
    section.add "alt", valid_598120
  var valid_598121 = query.getOrDefault("oauth_token")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "oauth_token", valid_598121
  var valid_598122 = query.getOrDefault("callback")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "callback", valid_598122
  var valid_598123 = query.getOrDefault("access_token")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "access_token", valid_598123
  var valid_598124 = query.getOrDefault("uploadType")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "uploadType", valid_598124
  var valid_598125 = query.getOrDefault("key")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "key", valid_598125
  var valid_598126 = query.getOrDefault("$.xgafv")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = newJString("1"))
  if valid_598126 != nil:
    section.add "$.xgafv", valid_598126
  var valid_598127 = query.getOrDefault("pageSize")
  valid_598127 = validateParameter(valid_598127, JInt, required = false, default = nil)
  if valid_598127 != nil:
    section.add "pageSize", valid_598127
  var valid_598128 = query.getOrDefault("prettyPrint")
  valid_598128 = validateParameter(valid_598128, JBool, required = false,
                                 default = newJBool(true))
  if valid_598128 != nil:
    section.add "prettyPrint", valid_598128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598129: Call_CloudfunctionsProjectsLocationsFunctionsList_598112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of functions that belong to the requested project.
  ## 
  let valid = call_598129.validator(path, query, header, formData, body)
  let scheme = call_598129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598129.url(scheme.get, call_598129.host, call_598129.base,
                         call_598129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598129, url, valid)

proc call*(call_598130: Call_CloudfunctionsProjectsLocationsFunctionsList_598112;
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
  var path_598131 = newJObject()
  var query_598132 = newJObject()
  add(query_598132, "upload_protocol", newJString(uploadProtocol))
  add(query_598132, "fields", newJString(fields))
  add(query_598132, "pageToken", newJString(pageToken))
  add(query_598132, "quotaUser", newJString(quotaUser))
  add(query_598132, "alt", newJString(alt))
  add(query_598132, "oauth_token", newJString(oauthToken))
  add(query_598132, "callback", newJString(callback))
  add(query_598132, "access_token", newJString(accessToken))
  add(query_598132, "uploadType", newJString(uploadType))
  add(path_598131, "parent", newJString(parent))
  add(query_598132, "key", newJString(key))
  add(query_598132, "$.xgafv", newJString(Xgafv))
  add(query_598132, "pageSize", newJInt(pageSize))
  add(query_598132, "prettyPrint", newJBool(prettyPrint))
  result = call_598130.call(path_598131, query_598132, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsList* = Call_CloudfunctionsProjectsLocationsFunctionsList_598112(
    name: "cloudfunctionsProjectsLocationsFunctionsList",
    meth: HttpMethod.HttpGet, host: "cloudfunctions.googleapis.com",
    route: "/v1/{parent}/functions",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsList_598113,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsList_598114,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598133 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598135(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598134(
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
  var valid_598136 = path.getOrDefault("parent")
  valid_598136 = validateParameter(valid_598136, JString, required = true,
                                 default = nil)
  if valid_598136 != nil:
    section.add "parent", valid_598136
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
  var valid_598137 = query.getOrDefault("upload_protocol")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = nil)
  if valid_598137 != nil:
    section.add "upload_protocol", valid_598137
  var valid_598138 = query.getOrDefault("fields")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "fields", valid_598138
  var valid_598139 = query.getOrDefault("quotaUser")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "quotaUser", valid_598139
  var valid_598140 = query.getOrDefault("alt")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = newJString("json"))
  if valid_598140 != nil:
    section.add "alt", valid_598140
  var valid_598141 = query.getOrDefault("oauth_token")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "oauth_token", valid_598141
  var valid_598142 = query.getOrDefault("callback")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "callback", valid_598142
  var valid_598143 = query.getOrDefault("access_token")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "access_token", valid_598143
  var valid_598144 = query.getOrDefault("uploadType")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "uploadType", valid_598144
  var valid_598145 = query.getOrDefault("key")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "key", valid_598145
  var valid_598146 = query.getOrDefault("$.xgafv")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = newJString("1"))
  if valid_598146 != nil:
    section.add "$.xgafv", valid_598146
  var valid_598147 = query.getOrDefault("prettyPrint")
  valid_598147 = validateParameter(valid_598147, JBool, required = false,
                                 default = newJBool(true))
  if valid_598147 != nil:
    section.add "prettyPrint", valid_598147
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

proc call*(call_598149: Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598133;
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
  let valid = call_598149.validator(path, query, header, formData, body)
  let scheme = call_598149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598149.url(scheme.get, call_598149.host, call_598149.base,
                         call_598149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598149, url, valid)

proc call*(call_598150: Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598133;
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
  var path_598151 = newJObject()
  var query_598152 = newJObject()
  var body_598153 = newJObject()
  add(query_598152, "upload_protocol", newJString(uploadProtocol))
  add(query_598152, "fields", newJString(fields))
  add(query_598152, "quotaUser", newJString(quotaUser))
  add(query_598152, "alt", newJString(alt))
  add(query_598152, "oauth_token", newJString(oauthToken))
  add(query_598152, "callback", newJString(callback))
  add(query_598152, "access_token", newJString(accessToken))
  add(query_598152, "uploadType", newJString(uploadType))
  add(path_598151, "parent", newJString(parent))
  add(query_598152, "key", newJString(key))
  add(query_598152, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598153 = body
  add(query_598152, "prettyPrint", newJBool(prettyPrint))
  result = call_598150.call(path_598151, query_598152, nil, nil, body_598153)

var cloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl* = Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598133(
    name: "cloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{parent}/functions:generateUploadUrl", validator: validate_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598134,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598135,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_598154 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_598156(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_598155(
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
  var valid_598157 = path.getOrDefault("resource")
  valid_598157 = validateParameter(valid_598157, JString, required = true,
                                 default = nil)
  if valid_598157 != nil:
    section.add "resource", valid_598157
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
  var valid_598158 = query.getOrDefault("upload_protocol")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "upload_protocol", valid_598158
  var valid_598159 = query.getOrDefault("fields")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "fields", valid_598159
  var valid_598160 = query.getOrDefault("quotaUser")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "quotaUser", valid_598160
  var valid_598161 = query.getOrDefault("alt")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = newJString("json"))
  if valid_598161 != nil:
    section.add "alt", valid_598161
  var valid_598162 = query.getOrDefault("oauth_token")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "oauth_token", valid_598162
  var valid_598163 = query.getOrDefault("callback")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "callback", valid_598163
  var valid_598164 = query.getOrDefault("access_token")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = nil)
  if valid_598164 != nil:
    section.add "access_token", valid_598164
  var valid_598165 = query.getOrDefault("uploadType")
  valid_598165 = validateParameter(valid_598165, JString, required = false,
                                 default = nil)
  if valid_598165 != nil:
    section.add "uploadType", valid_598165
  var valid_598166 = query.getOrDefault("options.requestedPolicyVersion")
  valid_598166 = validateParameter(valid_598166, JInt, required = false, default = nil)
  if valid_598166 != nil:
    section.add "options.requestedPolicyVersion", valid_598166
  var valid_598167 = query.getOrDefault("key")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "key", valid_598167
  var valid_598168 = query.getOrDefault("$.xgafv")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = newJString("1"))
  if valid_598168 != nil:
    section.add "$.xgafv", valid_598168
  var valid_598169 = query.getOrDefault("prettyPrint")
  valid_598169 = validateParameter(valid_598169, JBool, required = false,
                                 default = newJBool(true))
  if valid_598169 != nil:
    section.add "prettyPrint", valid_598169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598170: Call_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_598154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the IAM access control policy for a function.
  ## Returns an empty policy if the function exists and does not have a policy
  ## set.
  ## 
  let valid = call_598170.validator(path, query, header, formData, body)
  let scheme = call_598170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598170.url(scheme.get, call_598170.host, call_598170.base,
                         call_598170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598170, url, valid)

proc call*(call_598171: Call_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_598154;
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
  var path_598172 = newJObject()
  var query_598173 = newJObject()
  add(query_598173, "upload_protocol", newJString(uploadProtocol))
  add(query_598173, "fields", newJString(fields))
  add(query_598173, "quotaUser", newJString(quotaUser))
  add(query_598173, "alt", newJString(alt))
  add(query_598173, "oauth_token", newJString(oauthToken))
  add(query_598173, "callback", newJString(callback))
  add(query_598173, "access_token", newJString(accessToken))
  add(query_598173, "uploadType", newJString(uploadType))
  add(query_598173, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_598173, "key", newJString(key))
  add(query_598173, "$.xgafv", newJString(Xgafv))
  add(path_598172, "resource", newJString(resource))
  add(query_598173, "prettyPrint", newJBool(prettyPrint))
  result = call_598171.call(path_598172, query_598173, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsGetIamPolicy* = Call_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_598154(
    name: "cloudfunctionsProjectsLocationsFunctionsGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "cloudfunctions.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_598155,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsGetIamPolicy_598156,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_598174 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_598176(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_598175(
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
  var valid_598177 = path.getOrDefault("resource")
  valid_598177 = validateParameter(valid_598177, JString, required = true,
                                 default = nil)
  if valid_598177 != nil:
    section.add "resource", valid_598177
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
  var valid_598178 = query.getOrDefault("upload_protocol")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "upload_protocol", valid_598178
  var valid_598179 = query.getOrDefault("fields")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "fields", valid_598179
  var valid_598180 = query.getOrDefault("quotaUser")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "quotaUser", valid_598180
  var valid_598181 = query.getOrDefault("alt")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = newJString("json"))
  if valid_598181 != nil:
    section.add "alt", valid_598181
  var valid_598182 = query.getOrDefault("oauth_token")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = nil)
  if valid_598182 != nil:
    section.add "oauth_token", valid_598182
  var valid_598183 = query.getOrDefault("callback")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "callback", valid_598183
  var valid_598184 = query.getOrDefault("access_token")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "access_token", valid_598184
  var valid_598185 = query.getOrDefault("uploadType")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "uploadType", valid_598185
  var valid_598186 = query.getOrDefault("key")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "key", valid_598186
  var valid_598187 = query.getOrDefault("$.xgafv")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = newJString("1"))
  if valid_598187 != nil:
    section.add "$.xgafv", valid_598187
  var valid_598188 = query.getOrDefault("prettyPrint")
  valid_598188 = validateParameter(valid_598188, JBool, required = false,
                                 default = newJBool(true))
  if valid_598188 != nil:
    section.add "prettyPrint", valid_598188
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

proc call*(call_598190: Call_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_598174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM access control policy on the specified function.
  ## Replaces any existing policy.
  ## 
  let valid = call_598190.validator(path, query, header, formData, body)
  let scheme = call_598190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598190.url(scheme.get, call_598190.host, call_598190.base,
                         call_598190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598190, url, valid)

proc call*(call_598191: Call_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_598174;
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
  var path_598192 = newJObject()
  var query_598193 = newJObject()
  var body_598194 = newJObject()
  add(query_598193, "upload_protocol", newJString(uploadProtocol))
  add(query_598193, "fields", newJString(fields))
  add(query_598193, "quotaUser", newJString(quotaUser))
  add(query_598193, "alt", newJString(alt))
  add(query_598193, "oauth_token", newJString(oauthToken))
  add(query_598193, "callback", newJString(callback))
  add(query_598193, "access_token", newJString(accessToken))
  add(query_598193, "uploadType", newJString(uploadType))
  add(query_598193, "key", newJString(key))
  add(query_598193, "$.xgafv", newJString(Xgafv))
  add(path_598192, "resource", newJString(resource))
  if body != nil:
    body_598194 = body
  add(query_598193, "prettyPrint", newJBool(prettyPrint))
  result = call_598191.call(path_598192, query_598193, nil, nil, body_598194)

var cloudfunctionsProjectsLocationsFunctionsSetIamPolicy* = Call_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_598174(
    name: "cloudfunctionsProjectsLocationsFunctionsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_598175,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsSetIamPolicy_598176,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_598195 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_598197(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_598196(
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
  var valid_598198 = path.getOrDefault("resource")
  valid_598198 = validateParameter(valid_598198, JString, required = true,
                                 default = nil)
  if valid_598198 != nil:
    section.add "resource", valid_598198
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
  var valid_598199 = query.getOrDefault("upload_protocol")
  valid_598199 = validateParameter(valid_598199, JString, required = false,
                                 default = nil)
  if valid_598199 != nil:
    section.add "upload_protocol", valid_598199
  var valid_598200 = query.getOrDefault("fields")
  valid_598200 = validateParameter(valid_598200, JString, required = false,
                                 default = nil)
  if valid_598200 != nil:
    section.add "fields", valid_598200
  var valid_598201 = query.getOrDefault("quotaUser")
  valid_598201 = validateParameter(valid_598201, JString, required = false,
                                 default = nil)
  if valid_598201 != nil:
    section.add "quotaUser", valid_598201
  var valid_598202 = query.getOrDefault("alt")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = newJString("json"))
  if valid_598202 != nil:
    section.add "alt", valid_598202
  var valid_598203 = query.getOrDefault("oauth_token")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "oauth_token", valid_598203
  var valid_598204 = query.getOrDefault("callback")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "callback", valid_598204
  var valid_598205 = query.getOrDefault("access_token")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = nil)
  if valid_598205 != nil:
    section.add "access_token", valid_598205
  var valid_598206 = query.getOrDefault("uploadType")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "uploadType", valid_598206
  var valid_598207 = query.getOrDefault("key")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = nil)
  if valid_598207 != nil:
    section.add "key", valid_598207
  var valid_598208 = query.getOrDefault("$.xgafv")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = newJString("1"))
  if valid_598208 != nil:
    section.add "$.xgafv", valid_598208
  var valid_598209 = query.getOrDefault("prettyPrint")
  valid_598209 = validateParameter(valid_598209, JBool, required = false,
                                 default = newJBool(true))
  if valid_598209 != nil:
    section.add "prettyPrint", valid_598209
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

proc call*(call_598211: Call_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_598195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the specified permissions against the IAM access control policy
  ## for a function.
  ## If the function does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  let valid = call_598211.validator(path, query, header, formData, body)
  let scheme = call_598211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598211.url(scheme.get, call_598211.host, call_598211.base,
                         call_598211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598211, url, valid)

proc call*(call_598212: Call_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_598195;
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
  var path_598213 = newJObject()
  var query_598214 = newJObject()
  var body_598215 = newJObject()
  add(query_598214, "upload_protocol", newJString(uploadProtocol))
  add(query_598214, "fields", newJString(fields))
  add(query_598214, "quotaUser", newJString(quotaUser))
  add(query_598214, "alt", newJString(alt))
  add(query_598214, "oauth_token", newJString(oauthToken))
  add(query_598214, "callback", newJString(callback))
  add(query_598214, "access_token", newJString(accessToken))
  add(query_598214, "uploadType", newJString(uploadType))
  add(query_598214, "key", newJString(key))
  add(query_598214, "$.xgafv", newJString(Xgafv))
  add(path_598213, "resource", newJString(resource))
  if body != nil:
    body_598215 = body
  add(query_598214, "prettyPrint", newJBool(prettyPrint))
  result = call_598212.call(path_598213, query_598214, nil, nil, body_598215)

var cloudfunctionsProjectsLocationsFunctionsTestIamPermissions* = Call_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_598195(
    name: "cloudfunctionsProjectsLocationsFunctionsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1/{resource}:testIamPermissions", validator: validate_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_598196,
    base: "/",
    url: url_CloudfunctionsProjectsLocationsFunctionsTestIamPermissions_598197,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
