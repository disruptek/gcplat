
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
    host: "cloudfunctions.googleapis.com", route: "/v1beta2/operations",
    validator: validate_CloudfunctionsOperationsList_597678, base: "/",
    url: url_CloudfunctionsOperationsList_597679, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsCreate_597988 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsCreate_597990(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudfunctionsProjectsLocationsFunctionsCreate_597989(
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
  var valid_597991 = path.getOrDefault("location")
  valid_597991 = validateParameter(valid_597991, JString, required = true,
                                 default = nil)
  if valid_597991 != nil:
    section.add "location", valid_597991
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_598004: Call_CloudfunctionsProjectsLocationsFunctionsCreate_597988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new function. If a function with the given name already exists in
  ## the specified project, the long running operation will return
  ## `ALREADY_EXISTS` error.
  ## 
  let valid = call_598004.validator(path, query, header, formData, body)
  let scheme = call_598004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598004.url(scheme.get, call_598004.host, call_598004.base,
                         call_598004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598004, url, valid)

proc call*(call_598005: Call_CloudfunctionsProjectsLocationsFunctionsCreate_597988;
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
  var path_598006 = newJObject()
  var query_598007 = newJObject()
  var body_598008 = newJObject()
  add(query_598007, "upload_protocol", newJString(uploadProtocol))
  add(query_598007, "fields", newJString(fields))
  add(query_598007, "quotaUser", newJString(quotaUser))
  add(query_598007, "alt", newJString(alt))
  add(query_598007, "oauth_token", newJString(oauthToken))
  add(query_598007, "callback", newJString(callback))
  add(query_598007, "access_token", newJString(accessToken))
  add(query_598007, "uploadType", newJString(uploadType))
  add(query_598007, "key", newJString(key))
  add(query_598007, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598008 = body
  add(query_598007, "prettyPrint", newJBool(prettyPrint))
  add(path_598006, "location", newJString(location))
  result = call_598005.call(path_598006, query_598007, nil, nil, body_598008)

var cloudfunctionsProjectsLocationsFunctionsCreate* = Call_CloudfunctionsProjectsLocationsFunctionsCreate_597988(
    name: "cloudfunctionsProjectsLocationsFunctionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{location}/functions",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsCreate_597989,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsCreate_597990,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsList_597953 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsList_597955(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudfunctionsProjectsLocationsFunctionsList_597954(path: JsonNode;
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
  var valid_597973 = query.getOrDefault("pageToken")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "pageToken", valid_597973
  var valid_597974 = query.getOrDefault("quotaUser")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "quotaUser", valid_597974
  var valid_597975 = query.getOrDefault("alt")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = newJString("json"))
  if valid_597975 != nil:
    section.add "alt", valid_597975
  var valid_597976 = query.getOrDefault("oauth_token")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "oauth_token", valid_597976
  var valid_597977 = query.getOrDefault("callback")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "callback", valid_597977
  var valid_597978 = query.getOrDefault("access_token")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "access_token", valid_597978
  var valid_597979 = query.getOrDefault("uploadType")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "uploadType", valid_597979
  var valid_597980 = query.getOrDefault("key")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "key", valid_597980
  var valid_597981 = query.getOrDefault("$.xgafv")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = newJString("1"))
  if valid_597981 != nil:
    section.add "$.xgafv", valid_597981
  var valid_597982 = query.getOrDefault("pageSize")
  valid_597982 = validateParameter(valid_597982, JInt, required = false, default = nil)
  if valid_597982 != nil:
    section.add "pageSize", valid_597982
  var valid_597983 = query.getOrDefault("prettyPrint")
  valid_597983 = validateParameter(valid_597983, JBool, required = false,
                                 default = newJBool(true))
  if valid_597983 != nil:
    section.add "prettyPrint", valid_597983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597984: Call_CloudfunctionsProjectsLocationsFunctionsList_597953;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of functions that belong to the requested project.
  ## 
  let valid = call_597984.validator(path, query, header, formData, body)
  let scheme = call_597984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597984.url(scheme.get, call_597984.host, call_597984.base,
                         call_597984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597984, url, valid)

proc call*(call_597985: Call_CloudfunctionsProjectsLocationsFunctionsList_597953;
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
  var path_597986 = newJObject()
  var query_597987 = newJObject()
  add(query_597987, "upload_protocol", newJString(uploadProtocol))
  add(query_597987, "fields", newJString(fields))
  add(query_597987, "pageToken", newJString(pageToken))
  add(query_597987, "quotaUser", newJString(quotaUser))
  add(query_597987, "alt", newJString(alt))
  add(query_597987, "oauth_token", newJString(oauthToken))
  add(query_597987, "callback", newJString(callback))
  add(query_597987, "access_token", newJString(accessToken))
  add(query_597987, "uploadType", newJString(uploadType))
  add(query_597987, "key", newJString(key))
  add(query_597987, "$.xgafv", newJString(Xgafv))
  add(query_597987, "pageSize", newJInt(pageSize))
  add(query_597987, "prettyPrint", newJBool(prettyPrint))
  add(path_597986, "location", newJString(location))
  result = call_597985.call(path_597986, query_597987, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsList* = Call_CloudfunctionsProjectsLocationsFunctionsList_597953(
    name: "cloudfunctionsProjectsLocationsFunctionsList",
    meth: HttpMethod.HttpGet, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{location}/functions",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsList_597954,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsList_597955,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsUpdate_598028 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsUpdate_598030(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsUpdate_598029(
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
  var valid_598031 = path.getOrDefault("name")
  valid_598031 = validateParameter(valid_598031, JString, required = true,
                                 default = nil)
  if valid_598031 != nil:
    section.add "name", valid_598031
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
  var valid_598032 = query.getOrDefault("upload_protocol")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "upload_protocol", valid_598032
  var valid_598033 = query.getOrDefault("fields")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "fields", valid_598033
  var valid_598034 = query.getOrDefault("quotaUser")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "quotaUser", valid_598034
  var valid_598035 = query.getOrDefault("alt")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = newJString("json"))
  if valid_598035 != nil:
    section.add "alt", valid_598035
  var valid_598036 = query.getOrDefault("oauth_token")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "oauth_token", valid_598036
  var valid_598037 = query.getOrDefault("callback")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "callback", valid_598037
  var valid_598038 = query.getOrDefault("access_token")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "access_token", valid_598038
  var valid_598039 = query.getOrDefault("uploadType")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "uploadType", valid_598039
  var valid_598040 = query.getOrDefault("key")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "key", valid_598040
  var valid_598041 = query.getOrDefault("$.xgafv")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = newJString("1"))
  if valid_598041 != nil:
    section.add "$.xgafv", valid_598041
  var valid_598042 = query.getOrDefault("prettyPrint")
  valid_598042 = validateParameter(valid_598042, JBool, required = false,
                                 default = newJBool(true))
  if valid_598042 != nil:
    section.add "prettyPrint", valid_598042
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

proc call*(call_598044: Call_CloudfunctionsProjectsLocationsFunctionsUpdate_598028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates existing function.
  ## 
  let valid = call_598044.validator(path, query, header, formData, body)
  let scheme = call_598044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598044.url(scheme.get, call_598044.host, call_598044.base,
                         call_598044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598044, url, valid)

proc call*(call_598045: Call_CloudfunctionsProjectsLocationsFunctionsUpdate_598028;
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
  var path_598046 = newJObject()
  var query_598047 = newJObject()
  var body_598048 = newJObject()
  add(query_598047, "upload_protocol", newJString(uploadProtocol))
  add(query_598047, "fields", newJString(fields))
  add(query_598047, "quotaUser", newJString(quotaUser))
  add(path_598046, "name", newJString(name))
  add(query_598047, "alt", newJString(alt))
  add(query_598047, "oauth_token", newJString(oauthToken))
  add(query_598047, "callback", newJString(callback))
  add(query_598047, "access_token", newJString(accessToken))
  add(query_598047, "uploadType", newJString(uploadType))
  add(query_598047, "key", newJString(key))
  add(query_598047, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598048 = body
  add(query_598047, "prettyPrint", newJBool(prettyPrint))
  result = call_598045.call(path_598046, query_598047, nil, nil, body_598048)

var cloudfunctionsProjectsLocationsFunctionsUpdate* = Call_CloudfunctionsProjectsLocationsFunctionsUpdate_598028(
    name: "cloudfunctionsProjectsLocationsFunctionsUpdate",
    meth: HttpMethod.HttpPut, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsUpdate_598029,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsUpdate_598030,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGet_598009 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsGet_598011(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsGet_598010(path: JsonNode;
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
  var valid_598012 = path.getOrDefault("name")
  valid_598012 = validateParameter(valid_598012, JString, required = true,
                                 default = nil)
  if valid_598012 != nil:
    section.add "name", valid_598012
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
  var valid_598013 = query.getOrDefault("upload_protocol")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "upload_protocol", valid_598013
  var valid_598014 = query.getOrDefault("fields")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "fields", valid_598014
  var valid_598015 = query.getOrDefault("quotaUser")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "quotaUser", valid_598015
  var valid_598016 = query.getOrDefault("alt")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = newJString("json"))
  if valid_598016 != nil:
    section.add "alt", valid_598016
  var valid_598017 = query.getOrDefault("oauth_token")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "oauth_token", valid_598017
  var valid_598018 = query.getOrDefault("callback")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "callback", valid_598018
  var valid_598019 = query.getOrDefault("access_token")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "access_token", valid_598019
  var valid_598020 = query.getOrDefault("uploadType")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "uploadType", valid_598020
  var valid_598021 = query.getOrDefault("key")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "key", valid_598021
  var valid_598022 = query.getOrDefault("$.xgafv")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = newJString("1"))
  if valid_598022 != nil:
    section.add "$.xgafv", valid_598022
  var valid_598023 = query.getOrDefault("prettyPrint")
  valid_598023 = validateParameter(valid_598023, JBool, required = false,
                                 default = newJBool(true))
  if valid_598023 != nil:
    section.add "prettyPrint", valid_598023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598024: Call_CloudfunctionsProjectsLocationsFunctionsGet_598009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a function with the given name from the requested project.
  ## 
  let valid = call_598024.validator(path, query, header, formData, body)
  let scheme = call_598024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598024.url(scheme.get, call_598024.host, call_598024.base,
                         call_598024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598024, url, valid)

proc call*(call_598025: Call_CloudfunctionsProjectsLocationsFunctionsGet_598009;
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
  var path_598026 = newJObject()
  var query_598027 = newJObject()
  add(query_598027, "upload_protocol", newJString(uploadProtocol))
  add(query_598027, "fields", newJString(fields))
  add(query_598027, "quotaUser", newJString(quotaUser))
  add(path_598026, "name", newJString(name))
  add(query_598027, "alt", newJString(alt))
  add(query_598027, "oauth_token", newJString(oauthToken))
  add(query_598027, "callback", newJString(callback))
  add(query_598027, "access_token", newJString(accessToken))
  add(query_598027, "uploadType", newJString(uploadType))
  add(query_598027, "key", newJString(key))
  add(query_598027, "$.xgafv", newJString(Xgafv))
  add(query_598027, "prettyPrint", newJBool(prettyPrint))
  result = call_598025.call(path_598026, query_598027, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsGet* = Call_CloudfunctionsProjectsLocationsFunctionsGet_598009(
    name: "cloudfunctionsProjectsLocationsFunctionsGet", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1beta2/{name}",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsGet_598010,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsGet_598011,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsDelete_598049 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsDelete_598051(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudfunctionsProjectsLocationsFunctionsDelete_598050(
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
  var valid_598052 = path.getOrDefault("name")
  valid_598052 = validateParameter(valid_598052, JString, required = true,
                                 default = nil)
  if valid_598052 != nil:
    section.add "name", valid_598052
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
  var valid_598053 = query.getOrDefault("upload_protocol")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "upload_protocol", valid_598053
  var valid_598054 = query.getOrDefault("fields")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "fields", valid_598054
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
  var valid_598063 = query.getOrDefault("prettyPrint")
  valid_598063 = validateParameter(valid_598063, JBool, required = false,
                                 default = newJBool(true))
  if valid_598063 != nil:
    section.add "prettyPrint", valid_598063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598064: Call_CloudfunctionsProjectsLocationsFunctionsDelete_598049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a function with the given name from the specified project. If the
  ## given function is used by some trigger, the trigger will be updated to
  ## remove this function.
  ## 
  let valid = call_598064.validator(path, query, header, formData, body)
  let scheme = call_598064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598064.url(scheme.get, call_598064.host, call_598064.base,
                         call_598064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598064, url, valid)

proc call*(call_598065: Call_CloudfunctionsProjectsLocationsFunctionsDelete_598049;
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
  var path_598066 = newJObject()
  var query_598067 = newJObject()
  add(query_598067, "upload_protocol", newJString(uploadProtocol))
  add(query_598067, "fields", newJString(fields))
  add(query_598067, "quotaUser", newJString(quotaUser))
  add(path_598066, "name", newJString(name))
  add(query_598067, "alt", newJString(alt))
  add(query_598067, "oauth_token", newJString(oauthToken))
  add(query_598067, "callback", newJString(callback))
  add(query_598067, "access_token", newJString(accessToken))
  add(query_598067, "uploadType", newJString(uploadType))
  add(query_598067, "key", newJString(key))
  add(query_598067, "$.xgafv", newJString(Xgafv))
  add(query_598067, "prettyPrint", newJBool(prettyPrint))
  result = call_598065.call(path_598066, query_598067, nil, nil, nil)

var cloudfunctionsProjectsLocationsFunctionsDelete* = Call_CloudfunctionsProjectsLocationsFunctionsDelete_598049(
    name: "cloudfunctionsProjectsLocationsFunctionsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsDelete_598050,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsDelete_598051,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsList_598068 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsList_598070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudfunctionsProjectsLocationsList_598069(path: JsonNode;
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
  var valid_598071 = path.getOrDefault("name")
  valid_598071 = validateParameter(valid_598071, JString, required = true,
                                 default = nil)
  if valid_598071 != nil:
    section.add "name", valid_598071
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
  var valid_598072 = query.getOrDefault("upload_protocol")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "upload_protocol", valid_598072
  var valid_598073 = query.getOrDefault("fields")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "fields", valid_598073
  var valid_598074 = query.getOrDefault("pageToken")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "pageToken", valid_598074
  var valid_598075 = query.getOrDefault("quotaUser")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "quotaUser", valid_598075
  var valid_598076 = query.getOrDefault("alt")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = newJString("json"))
  if valid_598076 != nil:
    section.add "alt", valid_598076
  var valid_598077 = query.getOrDefault("oauth_token")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "oauth_token", valid_598077
  var valid_598078 = query.getOrDefault("callback")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "callback", valid_598078
  var valid_598079 = query.getOrDefault("access_token")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "access_token", valid_598079
  var valid_598080 = query.getOrDefault("uploadType")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "uploadType", valid_598080
  var valid_598081 = query.getOrDefault("key")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "key", valid_598081
  var valid_598082 = query.getOrDefault("$.xgafv")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = newJString("1"))
  if valid_598082 != nil:
    section.add "$.xgafv", valid_598082
  var valid_598083 = query.getOrDefault("pageSize")
  valid_598083 = validateParameter(valid_598083, JInt, required = false, default = nil)
  if valid_598083 != nil:
    section.add "pageSize", valid_598083
  var valid_598084 = query.getOrDefault("prettyPrint")
  valid_598084 = validateParameter(valid_598084, JBool, required = false,
                                 default = newJBool(true))
  if valid_598084 != nil:
    section.add "prettyPrint", valid_598084
  var valid_598085 = query.getOrDefault("filter")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "filter", valid_598085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598086: Call_CloudfunctionsProjectsLocationsList_598068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_598086.validator(path, query, header, formData, body)
  let scheme = call_598086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598086.url(scheme.get, call_598086.host, call_598086.base,
                         call_598086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598086, url, valid)

proc call*(call_598087: Call_CloudfunctionsProjectsLocationsList_598068;
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
  var path_598088 = newJObject()
  var query_598089 = newJObject()
  add(query_598089, "upload_protocol", newJString(uploadProtocol))
  add(query_598089, "fields", newJString(fields))
  add(query_598089, "pageToken", newJString(pageToken))
  add(query_598089, "quotaUser", newJString(quotaUser))
  add(path_598088, "name", newJString(name))
  add(query_598089, "alt", newJString(alt))
  add(query_598089, "oauth_token", newJString(oauthToken))
  add(query_598089, "callback", newJString(callback))
  add(query_598089, "access_token", newJString(accessToken))
  add(query_598089, "uploadType", newJString(uploadType))
  add(query_598089, "key", newJString(key))
  add(query_598089, "$.xgafv", newJString(Xgafv))
  add(query_598089, "pageSize", newJInt(pageSize))
  add(query_598089, "prettyPrint", newJBool(prettyPrint))
  add(query_598089, "filter", newJString(filter))
  result = call_598087.call(path_598088, query_598089, nil, nil, nil)

var cloudfunctionsProjectsLocationsList* = Call_CloudfunctionsProjectsLocationsList_598068(
    name: "cloudfunctionsProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudfunctions.googleapis.com", route: "/v1beta2/{name}/locations",
    validator: validate_CloudfunctionsProjectsLocationsList_598069, base: "/",
    url: url_CloudfunctionsProjectsLocationsList_598070, schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsCall_598090 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsCall_598092(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudfunctionsProjectsLocationsFunctionsCall_598091(path: JsonNode;
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
  var valid_598093 = path.getOrDefault("name")
  valid_598093 = validateParameter(valid_598093, JString, required = true,
                                 default = nil)
  if valid_598093 != nil:
    section.add "name", valid_598093
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
  var valid_598094 = query.getOrDefault("upload_protocol")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "upload_protocol", valid_598094
  var valid_598095 = query.getOrDefault("fields")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "fields", valid_598095
  var valid_598096 = query.getOrDefault("quotaUser")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "quotaUser", valid_598096
  var valid_598097 = query.getOrDefault("alt")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = newJString("json"))
  if valid_598097 != nil:
    section.add "alt", valid_598097
  var valid_598098 = query.getOrDefault("oauth_token")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "oauth_token", valid_598098
  var valid_598099 = query.getOrDefault("callback")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "callback", valid_598099
  var valid_598100 = query.getOrDefault("access_token")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "access_token", valid_598100
  var valid_598101 = query.getOrDefault("uploadType")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "uploadType", valid_598101
  var valid_598102 = query.getOrDefault("key")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "key", valid_598102
  var valid_598103 = query.getOrDefault("$.xgafv")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = newJString("1"))
  if valid_598103 != nil:
    section.add "$.xgafv", valid_598103
  var valid_598104 = query.getOrDefault("prettyPrint")
  valid_598104 = validateParameter(valid_598104, JBool, required = false,
                                 default = newJBool(true))
  if valid_598104 != nil:
    section.add "prettyPrint", valid_598104
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

proc call*(call_598106: Call_CloudfunctionsProjectsLocationsFunctionsCall_598090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Synchronously invokes a deployed Cloud Function. To be used for testing
  ## purposes as very limited traffic is allowed. For more information on
  ## the actual limits refer to [API Calls](
  ## https://cloud.google.com/functions/quotas#rate_limits).
  ## 
  let valid = call_598106.validator(path, query, header, formData, body)
  let scheme = call_598106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598106.url(scheme.get, call_598106.host, call_598106.base,
                         call_598106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598106, url, valid)

proc call*(call_598107: Call_CloudfunctionsProjectsLocationsFunctionsCall_598090;
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
  var path_598108 = newJObject()
  var query_598109 = newJObject()
  var body_598110 = newJObject()
  add(query_598109, "upload_protocol", newJString(uploadProtocol))
  add(query_598109, "fields", newJString(fields))
  add(query_598109, "quotaUser", newJString(quotaUser))
  add(path_598108, "name", newJString(name))
  add(query_598109, "alt", newJString(alt))
  add(query_598109, "oauth_token", newJString(oauthToken))
  add(query_598109, "callback", newJString(callback))
  add(query_598109, "access_token", newJString(accessToken))
  add(query_598109, "uploadType", newJString(uploadType))
  add(query_598109, "key", newJString(key))
  add(query_598109, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598110 = body
  add(query_598109, "prettyPrint", newJBool(prettyPrint))
  result = call_598107.call(path_598108, query_598109, nil, nil, body_598110)

var cloudfunctionsProjectsLocationsFunctionsCall* = Call_CloudfunctionsProjectsLocationsFunctionsCall_598090(
    name: "cloudfunctionsProjectsLocationsFunctionsCall",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{name}:call",
    validator: validate_CloudfunctionsProjectsLocationsFunctionsCall_598091,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsCall_598092,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598111 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598113(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598112(
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
  var valid_598114 = path.getOrDefault("name")
  valid_598114 = validateParameter(valid_598114, JString, required = true,
                                 default = nil)
  if valid_598114 != nil:
    section.add "name", valid_598114
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
  var valid_598115 = query.getOrDefault("upload_protocol")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "upload_protocol", valid_598115
  var valid_598116 = query.getOrDefault("fields")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "fields", valid_598116
  var valid_598117 = query.getOrDefault("quotaUser")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "quotaUser", valid_598117
  var valid_598118 = query.getOrDefault("alt")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = newJString("json"))
  if valid_598118 != nil:
    section.add "alt", valid_598118
  var valid_598119 = query.getOrDefault("oauth_token")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "oauth_token", valid_598119
  var valid_598120 = query.getOrDefault("callback")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "callback", valid_598120
  var valid_598121 = query.getOrDefault("access_token")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "access_token", valid_598121
  var valid_598122 = query.getOrDefault("uploadType")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "uploadType", valid_598122
  var valid_598123 = query.getOrDefault("key")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "key", valid_598123
  var valid_598124 = query.getOrDefault("$.xgafv")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = newJString("1"))
  if valid_598124 != nil:
    section.add "$.xgafv", valid_598124
  var valid_598125 = query.getOrDefault("prettyPrint")
  valid_598125 = validateParameter(valid_598125, JBool, required = false,
                                 default = newJBool(true))
  if valid_598125 != nil:
    section.add "prettyPrint", valid_598125
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

proc call*(call_598127: Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a signed URL for downloading deployed function source code.
  ## The URL is only valid for a limited period and should be used within
  ## minutes after generation.
  ## For more information about the signed URL usage see:
  ## https://cloud.google.com/storage/docs/access-control/signed-urls
  ## 
  let valid = call_598127.validator(path, query, header, formData, body)
  let scheme = call_598127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598127.url(scheme.get, call_598127.host, call_598127.base,
                         call_598127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598127, url, valid)

proc call*(call_598128: Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598111;
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
  var path_598129 = newJObject()
  var query_598130 = newJObject()
  var body_598131 = newJObject()
  add(query_598130, "upload_protocol", newJString(uploadProtocol))
  add(query_598130, "fields", newJString(fields))
  add(query_598130, "quotaUser", newJString(quotaUser))
  add(path_598129, "name", newJString(name))
  add(query_598130, "alt", newJString(alt))
  add(query_598130, "oauth_token", newJString(oauthToken))
  add(query_598130, "callback", newJString(callback))
  add(query_598130, "access_token", newJString(accessToken))
  add(query_598130, "uploadType", newJString(uploadType))
  add(query_598130, "key", newJString(key))
  add(query_598130, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598131 = body
  add(query_598130, "prettyPrint", newJBool(prettyPrint))
  result = call_598128.call(path_598129, query_598130, nil, nil, body_598131)

var cloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl* = Call_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598111(
    name: "cloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{name}:generateDownloadUrl", validator: validate_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598112,
    base: "/",
    url: url_CloudfunctionsProjectsLocationsFunctionsGenerateDownloadUrl_598113,
    schemes: {Scheme.Https})
type
  Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598132 = ref object of OpenApiRestCall_597408
proc url_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598134(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598133(
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
  var valid_598135 = path.getOrDefault("parent")
  valid_598135 = validateParameter(valid_598135, JString, required = true,
                                 default = nil)
  if valid_598135 != nil:
    section.add "parent", valid_598135
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
  var valid_598136 = query.getOrDefault("upload_protocol")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = nil)
  if valid_598136 != nil:
    section.add "upload_protocol", valid_598136
  var valid_598137 = query.getOrDefault("fields")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = nil)
  if valid_598137 != nil:
    section.add "fields", valid_598137
  var valid_598138 = query.getOrDefault("quotaUser")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "quotaUser", valid_598138
  var valid_598139 = query.getOrDefault("alt")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = newJString("json"))
  if valid_598139 != nil:
    section.add "alt", valid_598139
  var valid_598140 = query.getOrDefault("oauth_token")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "oauth_token", valid_598140
  var valid_598141 = query.getOrDefault("callback")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "callback", valid_598141
  var valid_598142 = query.getOrDefault("access_token")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "access_token", valid_598142
  var valid_598143 = query.getOrDefault("uploadType")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "uploadType", valid_598143
  var valid_598144 = query.getOrDefault("key")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "key", valid_598144
  var valid_598145 = query.getOrDefault("$.xgafv")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = newJString("1"))
  if valid_598145 != nil:
    section.add "$.xgafv", valid_598145
  var valid_598146 = query.getOrDefault("prettyPrint")
  valid_598146 = validateParameter(valid_598146, JBool, required = false,
                                 default = newJBool(true))
  if valid_598146 != nil:
    section.add "prettyPrint", valid_598146
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

proc call*(call_598148: Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598132;
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
  let valid = call_598148.validator(path, query, header, formData, body)
  let scheme = call_598148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598148.url(scheme.get, call_598148.host, call_598148.base,
                         call_598148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598148, url, valid)

proc call*(call_598149: Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598132;
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
  var path_598150 = newJObject()
  var query_598151 = newJObject()
  var body_598152 = newJObject()
  add(query_598151, "upload_protocol", newJString(uploadProtocol))
  add(query_598151, "fields", newJString(fields))
  add(query_598151, "quotaUser", newJString(quotaUser))
  add(query_598151, "alt", newJString(alt))
  add(query_598151, "oauth_token", newJString(oauthToken))
  add(query_598151, "callback", newJString(callback))
  add(query_598151, "access_token", newJString(accessToken))
  add(query_598151, "uploadType", newJString(uploadType))
  add(path_598150, "parent", newJString(parent))
  add(query_598151, "key", newJString(key))
  add(query_598151, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598152 = body
  add(query_598151, "prettyPrint", newJBool(prettyPrint))
  result = call_598149.call(path_598150, query_598151, nil, nil, body_598152)

var cloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl* = Call_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598132(
    name: "cloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl",
    meth: HttpMethod.HttpPost, host: "cloudfunctions.googleapis.com",
    route: "/v1beta2/{parent}/functions:generateUploadUrl", validator: validate_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598133,
    base: "/", url: url_CloudfunctionsProjectsLocationsFunctionsGenerateUploadUrl_598134,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
