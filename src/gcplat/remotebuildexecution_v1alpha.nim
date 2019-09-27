
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Remote Build Execution
## version: v1alpha
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Supplies a Remote Execution API service for tools such as bazel.
## 
## https://cloud.google.com/remote-build-execution/docs/
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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
  gcpServiceName = "remotebuildexecution"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RemotebuildexecutionProjectsInstancesWorkerpoolsGet_593690 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionProjectsInstancesWorkerpoolsGet_593692(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionProjectsInstancesWorkerpoolsGet_593691(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the specified worker pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the worker pool to retrieve.
  ## Format:
  ## `projects/[PROJECT_ID]/instances/[INSTANCE_ID]/workerpools/[POOL_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593818 = path.getOrDefault("name")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "name", valid_593818
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
  var valid_593819 = query.getOrDefault("upload_protocol")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = nil)
  if valid_593819 != nil:
    section.add "upload_protocol", valid_593819
  var valid_593820 = query.getOrDefault("fields")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "fields", valid_593820
  var valid_593821 = query.getOrDefault("quotaUser")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "quotaUser", valid_593821
  var valid_593835 = query.getOrDefault("alt")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = newJString("json"))
  if valid_593835 != nil:
    section.add "alt", valid_593835
  var valid_593836 = query.getOrDefault("oauth_token")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "oauth_token", valid_593836
  var valid_593837 = query.getOrDefault("callback")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "callback", valid_593837
  var valid_593838 = query.getOrDefault("access_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "access_token", valid_593838
  var valid_593839 = query.getOrDefault("uploadType")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "uploadType", valid_593839
  var valid_593840 = query.getOrDefault("key")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "key", valid_593840
  var valid_593841 = query.getOrDefault("$.xgafv")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = newJString("1"))
  if valid_593841 != nil:
    section.add "$.xgafv", valid_593841
  var valid_593842 = query.getOrDefault("prettyPrint")
  valid_593842 = validateParameter(valid_593842, JBool, required = false,
                                 default = newJBool(true))
  if valid_593842 != nil:
    section.add "prettyPrint", valid_593842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593865: Call_RemotebuildexecutionProjectsInstancesWorkerpoolsGet_593690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the specified worker pool.
  ## 
  let valid = call_593865.validator(path, query, header, formData, body)
  let scheme = call_593865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593865.url(scheme.get, call_593865.host, call_593865.base,
                         call_593865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593865, url, valid)

proc call*(call_593936: Call_RemotebuildexecutionProjectsInstancesWorkerpoolsGet_593690;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## remotebuildexecutionProjectsInstancesWorkerpoolsGet
  ## Returns the specified worker pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the worker pool to retrieve.
  ## Format:
  ## `projects/[PROJECT_ID]/instances/[INSTANCE_ID]/workerpools/[POOL_ID]`.
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
  var path_593937 = newJObject()
  var query_593939 = newJObject()
  add(query_593939, "upload_protocol", newJString(uploadProtocol))
  add(query_593939, "fields", newJString(fields))
  add(query_593939, "quotaUser", newJString(quotaUser))
  add(path_593937, "name", newJString(name))
  add(query_593939, "alt", newJString(alt))
  add(query_593939, "oauth_token", newJString(oauthToken))
  add(query_593939, "callback", newJString(callback))
  add(query_593939, "access_token", newJString(accessToken))
  add(query_593939, "uploadType", newJString(uploadType))
  add(query_593939, "key", newJString(key))
  add(query_593939, "$.xgafv", newJString(Xgafv))
  add(query_593939, "prettyPrint", newJBool(prettyPrint))
  result = call_593936.call(path_593937, query_593939, nil, nil, nil)

var remotebuildexecutionProjectsInstancesWorkerpoolsGet* = Call_RemotebuildexecutionProjectsInstancesWorkerpoolsGet_593690(
    name: "remotebuildexecutionProjectsInstancesWorkerpoolsGet",
    meth: HttpMethod.HttpGet, host: "admin-remotebuildexecution.googleapis.com",
    route: "/v1alpha/{name}",
    validator: validate_RemotebuildexecutionProjectsInstancesWorkerpoolsGet_593691,
    base: "/", url: url_RemotebuildexecutionProjectsInstancesWorkerpoolsGet_593692,
    schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionProjectsInstancesWorkerpoolsPatch_593997 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionProjectsInstancesWorkerpoolsPatch_593999(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionProjectsInstancesWorkerpoolsPatch_593998(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an existing worker pool with a specified size and/or configuration.
  ## Returns a long running operation, which contains a worker pool on
  ## completion. While the long running operation is in progress, any call to
  ## `GetWorkerPool` returns a worker pool in state `UPDATING`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : WorkerPool resource name formatted as:
  ## `projects/[PROJECT_ID]/instances/[INSTANCE_ID]/workerpools/[POOL_ID]`.
  ## name should not be populated when creating a worker pool since it is
  ## provided in the `poolId` field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594000 = path.getOrDefault("name")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "name", valid_594000
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
  var valid_594001 = query.getOrDefault("upload_protocol")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "upload_protocol", valid_594001
  var valid_594002 = query.getOrDefault("fields")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "fields", valid_594002
  var valid_594003 = query.getOrDefault("quotaUser")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "quotaUser", valid_594003
  var valid_594004 = query.getOrDefault("alt")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("json"))
  if valid_594004 != nil:
    section.add "alt", valid_594004
  var valid_594005 = query.getOrDefault("oauth_token")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "oauth_token", valid_594005
  var valid_594006 = query.getOrDefault("callback")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "callback", valid_594006
  var valid_594007 = query.getOrDefault("access_token")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "access_token", valid_594007
  var valid_594008 = query.getOrDefault("uploadType")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "uploadType", valid_594008
  var valid_594009 = query.getOrDefault("key")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "key", valid_594009
  var valid_594010 = query.getOrDefault("$.xgafv")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = newJString("1"))
  if valid_594010 != nil:
    section.add "$.xgafv", valid_594010
  var valid_594011 = query.getOrDefault("prettyPrint")
  valid_594011 = validateParameter(valid_594011, JBool, required = false,
                                 default = newJBool(true))
  if valid_594011 != nil:
    section.add "prettyPrint", valid_594011
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

proc call*(call_594013: Call_RemotebuildexecutionProjectsInstancesWorkerpoolsPatch_593997;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing worker pool with a specified size and/or configuration.
  ## Returns a long running operation, which contains a worker pool on
  ## completion. While the long running operation is in progress, any call to
  ## `GetWorkerPool` returns a worker pool in state `UPDATING`.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_RemotebuildexecutionProjectsInstancesWorkerpoolsPatch_593997;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## remotebuildexecutionProjectsInstancesWorkerpoolsPatch
  ## Updates an existing worker pool with a specified size and/or configuration.
  ## Returns a long running operation, which contains a worker pool on
  ## completion. While the long running operation is in progress, any call to
  ## `GetWorkerPool` returns a worker pool in state `UPDATING`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : WorkerPool resource name formatted as:
  ## `projects/[PROJECT_ID]/instances/[INSTANCE_ID]/workerpools/[POOL_ID]`.
  ## name should not be populated when creating a worker pool since it is
  ## provided in the `poolId` field.
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
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  var body_594017 = newJObject()
  add(query_594016, "upload_protocol", newJString(uploadProtocol))
  add(query_594016, "fields", newJString(fields))
  add(query_594016, "quotaUser", newJString(quotaUser))
  add(path_594015, "name", newJString(name))
  add(query_594016, "alt", newJString(alt))
  add(query_594016, "oauth_token", newJString(oauthToken))
  add(query_594016, "callback", newJString(callback))
  add(query_594016, "access_token", newJString(accessToken))
  add(query_594016, "uploadType", newJString(uploadType))
  add(query_594016, "key", newJString(key))
  add(query_594016, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594017 = body
  add(query_594016, "prettyPrint", newJBool(prettyPrint))
  result = call_594014.call(path_594015, query_594016, nil, nil, body_594017)

var remotebuildexecutionProjectsInstancesWorkerpoolsPatch* = Call_RemotebuildexecutionProjectsInstancesWorkerpoolsPatch_593997(
    name: "remotebuildexecutionProjectsInstancesWorkerpoolsPatch",
    meth: HttpMethod.HttpPatch, host: "admin-remotebuildexecution.googleapis.com",
    route: "/v1alpha/{name}",
    validator: validate_RemotebuildexecutionProjectsInstancesWorkerpoolsPatch_593998,
    base: "/", url: url_RemotebuildexecutionProjectsInstancesWorkerpoolsPatch_593999,
    schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionProjectsInstancesWorkerpoolsDelete_593978 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionProjectsInstancesWorkerpoolsDelete_593980(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionProjectsInstancesWorkerpoolsDelete_593979(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the specified worker pool.
  ## Returns a long running operation, which contains a `google.protobuf.Empty`
  ## response on completion.
  ## While the long running operation is in progress, any call to
  ## `GetWorkerPool` returns a worker pool in state `DELETING`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the worker pool to delete.
  ## Format:
  ## `projects/[PROJECT_ID]/instances/[INSTANCE_ID]/workerpools/[POOL_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593981 = path.getOrDefault("name")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "name", valid_593981
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
  var valid_593982 = query.getOrDefault("upload_protocol")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "upload_protocol", valid_593982
  var valid_593983 = query.getOrDefault("fields")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "fields", valid_593983
  var valid_593984 = query.getOrDefault("quotaUser")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "quotaUser", valid_593984
  var valid_593985 = query.getOrDefault("alt")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = newJString("json"))
  if valid_593985 != nil:
    section.add "alt", valid_593985
  var valid_593986 = query.getOrDefault("oauth_token")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "oauth_token", valid_593986
  var valid_593987 = query.getOrDefault("callback")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "callback", valid_593987
  var valid_593988 = query.getOrDefault("access_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "access_token", valid_593988
  var valid_593989 = query.getOrDefault("uploadType")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "uploadType", valid_593989
  var valid_593990 = query.getOrDefault("key")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "key", valid_593990
  var valid_593991 = query.getOrDefault("$.xgafv")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("1"))
  if valid_593991 != nil:
    section.add "$.xgafv", valid_593991
  var valid_593992 = query.getOrDefault("prettyPrint")
  valid_593992 = validateParameter(valid_593992, JBool, required = false,
                                 default = newJBool(true))
  if valid_593992 != nil:
    section.add "prettyPrint", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_RemotebuildexecutionProjectsInstancesWorkerpoolsDelete_593978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified worker pool.
  ## Returns a long running operation, which contains a `google.protobuf.Empty`
  ## response on completion.
  ## While the long running operation is in progress, any call to
  ## `GetWorkerPool` returns a worker pool in state `DELETING`.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_RemotebuildexecutionProjectsInstancesWorkerpoolsDelete_593978;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## remotebuildexecutionProjectsInstancesWorkerpoolsDelete
  ## Deletes the specified worker pool.
  ## Returns a long running operation, which contains a `google.protobuf.Empty`
  ## response on completion.
  ## While the long running operation is in progress, any call to
  ## `GetWorkerPool` returns a worker pool in state `DELETING`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the worker pool to delete.
  ## Format:
  ## `projects/[PROJECT_ID]/instances/[INSTANCE_ID]/workerpools/[POOL_ID]`.
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
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "upload_protocol", newJString(uploadProtocol))
  add(query_593996, "fields", newJString(fields))
  add(query_593996, "quotaUser", newJString(quotaUser))
  add(path_593995, "name", newJString(name))
  add(query_593996, "alt", newJString(alt))
  add(query_593996, "oauth_token", newJString(oauthToken))
  add(query_593996, "callback", newJString(callback))
  add(query_593996, "access_token", newJString(accessToken))
  add(query_593996, "uploadType", newJString(uploadType))
  add(query_593996, "key", newJString(key))
  add(query_593996, "$.xgafv", newJString(Xgafv))
  add(query_593996, "prettyPrint", newJBool(prettyPrint))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var remotebuildexecutionProjectsInstancesWorkerpoolsDelete* = Call_RemotebuildexecutionProjectsInstancesWorkerpoolsDelete_593978(
    name: "remotebuildexecutionProjectsInstancesWorkerpoolsDelete",
    meth: HttpMethod.HttpDelete,
    host: "admin-remotebuildexecution.googleapis.com", route: "/v1alpha/{name}",
    validator: validate_RemotebuildexecutionProjectsInstancesWorkerpoolsDelete_593979,
    base: "/", url: url_RemotebuildexecutionProjectsInstancesWorkerpoolsDelete_593980,
    schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionProjectsInstancesCreate_594037 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionProjectsInstancesCreate_594039(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionProjectsInstancesCreate_594038(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new instance in the specified region.
  ## Returns a long running operation which contains an instance on completion.
  ## While the long running operation is in progress, any call to `GetInstance`
  ## returns an instance in state `CREATING`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Resource name of the project containing the instance.
  ## Format: `projects/[PROJECT_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594040 = path.getOrDefault("parent")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "parent", valid_594040
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
  var valid_594041 = query.getOrDefault("upload_protocol")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "upload_protocol", valid_594041
  var valid_594042 = query.getOrDefault("fields")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "fields", valid_594042
  var valid_594043 = query.getOrDefault("quotaUser")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "quotaUser", valid_594043
  var valid_594044 = query.getOrDefault("alt")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = newJString("json"))
  if valid_594044 != nil:
    section.add "alt", valid_594044
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

proc call*(call_594053: Call_RemotebuildexecutionProjectsInstancesCreate_594037;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new instance in the specified region.
  ## Returns a long running operation which contains an instance on completion.
  ## While the long running operation is in progress, any call to `GetInstance`
  ## returns an instance in state `CREATING`.
  ## 
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_RemotebuildexecutionProjectsInstancesCreate_594037;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## remotebuildexecutionProjectsInstancesCreate
  ## Creates a new instance in the specified region.
  ## Returns a long running operation which contains an instance on completion.
  ## While the long running operation is in progress, any call to `GetInstance`
  ## returns an instance in state `CREATING`.
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
  ##         : Resource name of the project containing the instance.
  ## Format: `projects/[PROJECT_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594055 = newJObject()
  var query_594056 = newJObject()
  var body_594057 = newJObject()
  add(query_594056, "upload_protocol", newJString(uploadProtocol))
  add(query_594056, "fields", newJString(fields))
  add(query_594056, "quotaUser", newJString(quotaUser))
  add(query_594056, "alt", newJString(alt))
  add(query_594056, "oauth_token", newJString(oauthToken))
  add(query_594056, "callback", newJString(callback))
  add(query_594056, "access_token", newJString(accessToken))
  add(query_594056, "uploadType", newJString(uploadType))
  add(path_594055, "parent", newJString(parent))
  add(query_594056, "key", newJString(key))
  add(query_594056, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594057 = body
  add(query_594056, "prettyPrint", newJBool(prettyPrint))
  result = call_594054.call(path_594055, query_594056, nil, nil, body_594057)

var remotebuildexecutionProjectsInstancesCreate* = Call_RemotebuildexecutionProjectsInstancesCreate_594037(
    name: "remotebuildexecutionProjectsInstancesCreate",
    meth: HttpMethod.HttpPost, host: "admin-remotebuildexecution.googleapis.com",
    route: "/v1alpha/{parent}/instances",
    validator: validate_RemotebuildexecutionProjectsInstancesCreate_594038,
    base: "/", url: url_RemotebuildexecutionProjectsInstancesCreate_594039,
    schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionProjectsInstancesList_594018 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionProjectsInstancesList_594020(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionProjectsInstancesList_594019(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists instances in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Resource name of the project.
  ## Format: `projects/[PROJECT_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594021 = path.getOrDefault("parent")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "parent", valid_594021
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
  var valid_594022 = query.getOrDefault("upload_protocol")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "upload_protocol", valid_594022
  var valid_594023 = query.getOrDefault("fields")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "fields", valid_594023
  var valid_594024 = query.getOrDefault("quotaUser")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "quotaUser", valid_594024
  var valid_594025 = query.getOrDefault("alt")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = newJString("json"))
  if valid_594025 != nil:
    section.add "alt", valid_594025
  var valid_594026 = query.getOrDefault("oauth_token")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "oauth_token", valid_594026
  var valid_594027 = query.getOrDefault("callback")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "callback", valid_594027
  var valid_594028 = query.getOrDefault("access_token")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "access_token", valid_594028
  var valid_594029 = query.getOrDefault("uploadType")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "uploadType", valid_594029
  var valid_594030 = query.getOrDefault("key")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "key", valid_594030
  var valid_594031 = query.getOrDefault("$.xgafv")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = newJString("1"))
  if valid_594031 != nil:
    section.add "$.xgafv", valid_594031
  var valid_594032 = query.getOrDefault("prettyPrint")
  valid_594032 = validateParameter(valid_594032, JBool, required = false,
                                 default = newJBool(true))
  if valid_594032 != nil:
    section.add "prettyPrint", valid_594032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594033: Call_RemotebuildexecutionProjectsInstancesList_594018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists instances in a project.
  ## 
  let valid = call_594033.validator(path, query, header, formData, body)
  let scheme = call_594033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594033.url(scheme.get, call_594033.host, call_594033.base,
                         call_594033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594033, url, valid)

proc call*(call_594034: Call_RemotebuildexecutionProjectsInstancesList_594018;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## remotebuildexecutionProjectsInstancesList
  ## Lists instances in a project.
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
  ##         : Resource name of the project.
  ## Format: `projects/[PROJECT_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594035 = newJObject()
  var query_594036 = newJObject()
  add(query_594036, "upload_protocol", newJString(uploadProtocol))
  add(query_594036, "fields", newJString(fields))
  add(query_594036, "quotaUser", newJString(quotaUser))
  add(query_594036, "alt", newJString(alt))
  add(query_594036, "oauth_token", newJString(oauthToken))
  add(query_594036, "callback", newJString(callback))
  add(query_594036, "access_token", newJString(accessToken))
  add(query_594036, "uploadType", newJString(uploadType))
  add(path_594035, "parent", newJString(parent))
  add(query_594036, "key", newJString(key))
  add(query_594036, "$.xgafv", newJString(Xgafv))
  add(query_594036, "prettyPrint", newJBool(prettyPrint))
  result = call_594034.call(path_594035, query_594036, nil, nil, nil)

var remotebuildexecutionProjectsInstancesList* = Call_RemotebuildexecutionProjectsInstancesList_594018(
    name: "remotebuildexecutionProjectsInstancesList", meth: HttpMethod.HttpGet,
    host: "admin-remotebuildexecution.googleapis.com",
    route: "/v1alpha/{parent}/instances",
    validator: validate_RemotebuildexecutionProjectsInstancesList_594019,
    base: "/", url: url_RemotebuildexecutionProjectsInstancesList_594020,
    schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionProjectsInstancesWorkerpoolsCreate_594078 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionProjectsInstancesWorkerpoolsCreate_594080(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/workerpools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionProjectsInstancesWorkerpoolsCreate_594079(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new worker pool with a specified size and configuration.
  ## Returns a long running operation which contains a worker pool on
  ## completion. While the long running operation is in progress, any call to
  ## `GetWorkerPool` returns a worker pool in state `CREATING`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Resource name of the instance in which to create the new worker pool.
  ## Format: `projects/[PROJECT_ID]/instances/[INSTANCE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594081 = path.getOrDefault("parent")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "parent", valid_594081
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
  var valid_594082 = query.getOrDefault("upload_protocol")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "upload_protocol", valid_594082
  var valid_594083 = query.getOrDefault("fields")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "fields", valid_594083
  var valid_594084 = query.getOrDefault("quotaUser")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "quotaUser", valid_594084
  var valid_594085 = query.getOrDefault("alt")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = newJString("json"))
  if valid_594085 != nil:
    section.add "alt", valid_594085
  var valid_594086 = query.getOrDefault("oauth_token")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "oauth_token", valid_594086
  var valid_594087 = query.getOrDefault("callback")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "callback", valid_594087
  var valid_594088 = query.getOrDefault("access_token")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "access_token", valid_594088
  var valid_594089 = query.getOrDefault("uploadType")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "uploadType", valid_594089
  var valid_594090 = query.getOrDefault("key")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "key", valid_594090
  var valid_594091 = query.getOrDefault("$.xgafv")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = newJString("1"))
  if valid_594091 != nil:
    section.add "$.xgafv", valid_594091
  var valid_594092 = query.getOrDefault("prettyPrint")
  valid_594092 = validateParameter(valid_594092, JBool, required = false,
                                 default = newJBool(true))
  if valid_594092 != nil:
    section.add "prettyPrint", valid_594092
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

proc call*(call_594094: Call_RemotebuildexecutionProjectsInstancesWorkerpoolsCreate_594078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new worker pool with a specified size and configuration.
  ## Returns a long running operation which contains a worker pool on
  ## completion. While the long running operation is in progress, any call to
  ## `GetWorkerPool` returns a worker pool in state `CREATING`.
  ## 
  let valid = call_594094.validator(path, query, header, formData, body)
  let scheme = call_594094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594094.url(scheme.get, call_594094.host, call_594094.base,
                         call_594094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594094, url, valid)

proc call*(call_594095: Call_RemotebuildexecutionProjectsInstancesWorkerpoolsCreate_594078;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## remotebuildexecutionProjectsInstancesWorkerpoolsCreate
  ## Creates a new worker pool with a specified size and configuration.
  ## Returns a long running operation which contains a worker pool on
  ## completion. While the long running operation is in progress, any call to
  ## `GetWorkerPool` returns a worker pool in state `CREATING`.
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
  ##         : Resource name of the instance in which to create the new worker pool.
  ## Format: `projects/[PROJECT_ID]/instances/[INSTANCE_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594096 = newJObject()
  var query_594097 = newJObject()
  var body_594098 = newJObject()
  add(query_594097, "upload_protocol", newJString(uploadProtocol))
  add(query_594097, "fields", newJString(fields))
  add(query_594097, "quotaUser", newJString(quotaUser))
  add(query_594097, "alt", newJString(alt))
  add(query_594097, "oauth_token", newJString(oauthToken))
  add(query_594097, "callback", newJString(callback))
  add(query_594097, "access_token", newJString(accessToken))
  add(query_594097, "uploadType", newJString(uploadType))
  add(path_594096, "parent", newJString(parent))
  add(query_594097, "key", newJString(key))
  add(query_594097, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594098 = body
  add(query_594097, "prettyPrint", newJBool(prettyPrint))
  result = call_594095.call(path_594096, query_594097, nil, nil, body_594098)

var remotebuildexecutionProjectsInstancesWorkerpoolsCreate* = Call_RemotebuildexecutionProjectsInstancesWorkerpoolsCreate_594078(
    name: "remotebuildexecutionProjectsInstancesWorkerpoolsCreate",
    meth: HttpMethod.HttpPost, host: "admin-remotebuildexecution.googleapis.com",
    route: "/v1alpha/{parent}/workerpools",
    validator: validate_RemotebuildexecutionProjectsInstancesWorkerpoolsCreate_594079,
    base: "/", url: url_RemotebuildexecutionProjectsInstancesWorkerpoolsCreate_594080,
    schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionProjectsInstancesWorkerpoolsList_594058 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionProjectsInstancesWorkerpoolsList_594060(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/workerpools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionProjectsInstancesWorkerpoolsList_594059(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists worker pools in an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Resource name of the instance.
  ## Format: `projects/[PROJECT_ID]/instances/[INSTANCE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594061 = path.getOrDefault("parent")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "parent", valid_594061
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
  ##   filter: JString
  ##         : Optional. A filter expression that filters resources listed in
  ## the response. The expression must specify the field name, a comparison
  ## operator, and the value that you want to use for filtering. The value
  ## must be a string, a number, or a boolean. String values are
  ## case-insensitive.
  ## The comparison operator must be either `:`, `=`, `!=`, `>`, `>=`, `<=` or
  ## `<`.
  ## The `:` operator can be used with string fields to match substrings.
  ## For non-string fields it is equivalent to the `=` operator.
  ## The `:*` comparison can be used to test  whether a key has been defined.
  ## 
  ## You can also filter on nested fields.
  ## 
  ## To filter on multiple expressions, you can separate expression using
  ## `AND` and `OR` operators, using parentheses to specify precedence. If
  ## neither operator is specified, `AND` is assumed.
  ## 
  ## Examples:
  ## 
  ## Include only pools with more than 100 reserved workers:
  ## `(worker_count > 100) (worker_config.reserved = true)`
  ## 
  ## Include only pools with a certain label or machines of the n1-standard
  ## family:
  ## `worker_config.labels.key1 : * OR worker_config.machine_type: n1-standard`
  section = newJObject()
  var valid_594062 = query.getOrDefault("upload_protocol")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "upload_protocol", valid_594062
  var valid_594063 = query.getOrDefault("fields")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "fields", valid_594063
  var valid_594064 = query.getOrDefault("quotaUser")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "quotaUser", valid_594064
  var valid_594065 = query.getOrDefault("alt")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = newJString("json"))
  if valid_594065 != nil:
    section.add "alt", valid_594065
  var valid_594066 = query.getOrDefault("oauth_token")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "oauth_token", valid_594066
  var valid_594067 = query.getOrDefault("callback")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "callback", valid_594067
  var valid_594068 = query.getOrDefault("access_token")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "access_token", valid_594068
  var valid_594069 = query.getOrDefault("uploadType")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "uploadType", valid_594069
  var valid_594070 = query.getOrDefault("key")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "key", valid_594070
  var valid_594071 = query.getOrDefault("$.xgafv")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = newJString("1"))
  if valid_594071 != nil:
    section.add "$.xgafv", valid_594071
  var valid_594072 = query.getOrDefault("prettyPrint")
  valid_594072 = validateParameter(valid_594072, JBool, required = false,
                                 default = newJBool(true))
  if valid_594072 != nil:
    section.add "prettyPrint", valid_594072
  var valid_594073 = query.getOrDefault("filter")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "filter", valid_594073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_RemotebuildexecutionProjectsInstancesWorkerpoolsList_594058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists worker pools in an instance.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_RemotebuildexecutionProjectsInstancesWorkerpoolsList_594058;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## remotebuildexecutionProjectsInstancesWorkerpoolsList
  ## Lists worker pools in an instance.
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
  ##         : Resource name of the instance.
  ## Format: `projects/[PROJECT_ID]/instances/[INSTANCE_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. A filter expression that filters resources listed in
  ## the response. The expression must specify the field name, a comparison
  ## operator, and the value that you want to use for filtering. The value
  ## must be a string, a number, or a boolean. String values are
  ## case-insensitive.
  ## The comparison operator must be either `:`, `=`, `!=`, `>`, `>=`, `<=` or
  ## `<`.
  ## The `:` operator can be used with string fields to match substrings.
  ## For non-string fields it is equivalent to the `=` operator.
  ## The `:*` comparison can be used to test  whether a key has been defined.
  ## 
  ## You can also filter on nested fields.
  ## 
  ## To filter on multiple expressions, you can separate expression using
  ## `AND` and `OR` operators, using parentheses to specify precedence. If
  ## neither operator is specified, `AND` is assumed.
  ## 
  ## Examples:
  ## 
  ## Include only pools with more than 100 reserved workers:
  ## `(worker_count > 100) (worker_config.reserved = true)`
  ## 
  ## Include only pools with a certain label or machines of the n1-standard
  ## family:
  ## `worker_config.labels.key1 : * OR worker_config.machine_type: n1-standard`
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  add(query_594077, "upload_protocol", newJString(uploadProtocol))
  add(query_594077, "fields", newJString(fields))
  add(query_594077, "quotaUser", newJString(quotaUser))
  add(query_594077, "alt", newJString(alt))
  add(query_594077, "oauth_token", newJString(oauthToken))
  add(query_594077, "callback", newJString(callback))
  add(query_594077, "access_token", newJString(accessToken))
  add(query_594077, "uploadType", newJString(uploadType))
  add(path_594076, "parent", newJString(parent))
  add(query_594077, "key", newJString(key))
  add(query_594077, "$.xgafv", newJString(Xgafv))
  add(query_594077, "prettyPrint", newJBool(prettyPrint))
  add(query_594077, "filter", newJString(filter))
  result = call_594075.call(path_594076, query_594077, nil, nil, nil)

var remotebuildexecutionProjectsInstancesWorkerpoolsList* = Call_RemotebuildexecutionProjectsInstancesWorkerpoolsList_594058(
    name: "remotebuildexecutionProjectsInstancesWorkerpoolsList",
    meth: HttpMethod.HttpGet, host: "admin-remotebuildexecution.googleapis.com",
    route: "/v1alpha/{parent}/workerpools",
    validator: validate_RemotebuildexecutionProjectsInstancesWorkerpoolsList_594059,
    base: "/", url: url_RemotebuildexecutionProjectsInstancesWorkerpoolsList_594060,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
