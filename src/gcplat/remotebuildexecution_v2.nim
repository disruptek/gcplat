
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Remote Build Execution
## version: v2
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
  Call_RemotebuildexecutionActionResultsUpdate_593983 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionActionResultsUpdate_593985(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "instanceName" in path, "`instanceName` is a required path parameter"
  assert "hash" in path, "`hash` is a required path parameter"
  assert "sizeBytes" in path, "`sizeBytes` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "instanceName"),
               (kind: ConstantSegment, value: "/actionResults/"),
               (kind: VariableSegment, value: "hash"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "sizeBytes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionActionResultsUpdate_593984(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upload a new execution result.
  ## 
  ## In order to allow the server to perform access control based on the type of
  ## action, and to assist with client debugging, the client MUST first upload
  ## the Action that produced the
  ## result, along with its
  ## Command, into the
  ## `ContentAddressableStorage`.
  ## 
  ## Errors:
  ## 
  ## * `INVALID_ARGUMENT`: One or more arguments are invalid.
  ## * `FAILED_PRECONDITION`: One or more errors occurred in updating the
  ##   action result, such as a missing command or action.
  ## * `RESOURCE_EXHAUSTED`: There is insufficient storage space to add the
  ##   entry to the cache.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sizeBytes: JString (required)
  ##            : The size of the blob, in bytes.
  ##   instanceName: JString (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  ##   hash: JString (required)
  ##       : The hash. In the case of SHA-256, it will always be a lowercase hex string
  ## exactly 64 characters long.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sizeBytes` field"
  var valid_593986 = path.getOrDefault("sizeBytes")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "sizeBytes", valid_593986
  var valid_593987 = path.getOrDefault("instanceName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "instanceName", valid_593987
  var valid_593988 = path.getOrDefault("hash")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "hash", valid_593988
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
  ##   resultsCachePolicy.priority: JInt
  ##                              : The priority (relative importance) of this content in the overall cache.
  ## Generally, a lower value means a longer retention time or other advantage,
  ## but the interpretation of a given value is server-dependent. A priority of
  ## 0 means a *default* value, decided by the server.
  ## 
  ## The particular semantics of this field is up to the server. In particular,
  ## every server will have their own supported range of priorities, and will
  ## decide how these map into retention/eviction policy.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593989 = query.getOrDefault("upload_protocol")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "upload_protocol", valid_593989
  var valid_593990 = query.getOrDefault("fields")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "fields", valid_593990
  var valid_593991 = query.getOrDefault("quotaUser")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "quotaUser", valid_593991
  var valid_593992 = query.getOrDefault("alt")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = newJString("json"))
  if valid_593992 != nil:
    section.add "alt", valid_593992
  var valid_593993 = query.getOrDefault("oauth_token")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "oauth_token", valid_593993
  var valid_593994 = query.getOrDefault("callback")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "callback", valid_593994
  var valid_593995 = query.getOrDefault("access_token")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "access_token", valid_593995
  var valid_593996 = query.getOrDefault("uploadType")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "uploadType", valid_593996
  var valid_593997 = query.getOrDefault("resultsCachePolicy.priority")
  valid_593997 = validateParameter(valid_593997, JInt, required = false, default = nil)
  if valid_593997 != nil:
    section.add "resultsCachePolicy.priority", valid_593997
  var valid_593998 = query.getOrDefault("key")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "key", valid_593998
  var valid_593999 = query.getOrDefault("$.xgafv")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = newJString("1"))
  if valid_593999 != nil:
    section.add "$.xgafv", valid_593999
  var valid_594000 = query.getOrDefault("prettyPrint")
  valid_594000 = validateParameter(valid_594000, JBool, required = false,
                                 default = newJBool(true))
  if valid_594000 != nil:
    section.add "prettyPrint", valid_594000
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

proc call*(call_594002: Call_RemotebuildexecutionActionResultsUpdate_593983;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload a new execution result.
  ## 
  ## In order to allow the server to perform access control based on the type of
  ## action, and to assist with client debugging, the client MUST first upload
  ## the Action that produced the
  ## result, along with its
  ## Command, into the
  ## `ContentAddressableStorage`.
  ## 
  ## Errors:
  ## 
  ## * `INVALID_ARGUMENT`: One or more arguments are invalid.
  ## * `FAILED_PRECONDITION`: One or more errors occurred in updating the
  ##   action result, such as a missing command or action.
  ## * `RESOURCE_EXHAUSTED`: There is insufficient storage space to add the
  ##   entry to the cache.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_RemotebuildexecutionActionResultsUpdate_593983;
          sizeBytes: string; instanceName: string; hash: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resultsCachePolicyPriority: int = 0; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## remotebuildexecutionActionResultsUpdate
  ## Upload a new execution result.
  ## 
  ## In order to allow the server to perform access control based on the type of
  ## action, and to assist with client debugging, the client MUST first upload
  ## the Action that produced the
  ## result, along with its
  ## Command, into the
  ## `ContentAddressableStorage`.
  ## 
  ## Errors:
  ## 
  ## * `INVALID_ARGUMENT`: One or more arguments are invalid.
  ## * `FAILED_PRECONDITION`: One or more errors occurred in updating the
  ##   action result, such as a missing command or action.
  ## * `RESOURCE_EXHAUSTED`: There is insufficient storage space to add the
  ##   entry to the cache.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   sizeBytes: string (required)
  ##            : The size of the blob, in bytes.
  ##   alt: string
  ##      : Data format for response.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   hash: string (required)
  ##       : The hash. In the case of SHA-256, it will always be a lowercase hex string
  ## exactly 64 characters long.
  ##   resultsCachePolicyPriority: int
  ##                             : The priority (relative importance) of this content in the overall cache.
  ## Generally, a lower value means a longer retention time or other advantage,
  ## but the interpretation of a given value is server-dependent. A priority of
  ## 0 means a *default* value, decided by the server.
  ## 
  ## The particular semantics of this field is up to the server. In particular,
  ## every server will have their own supported range of priorities, and will
  ## decide how these map into retention/eviction policy.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  var body_594006 = newJObject()
  add(query_594005, "upload_protocol", newJString(uploadProtocol))
  add(query_594005, "fields", newJString(fields))
  add(query_594005, "quotaUser", newJString(quotaUser))
  add(path_594004, "sizeBytes", newJString(sizeBytes))
  add(query_594005, "alt", newJString(alt))
  add(path_594004, "instanceName", newJString(instanceName))
  add(query_594005, "oauth_token", newJString(oauthToken))
  add(query_594005, "callback", newJString(callback))
  add(query_594005, "access_token", newJString(accessToken))
  add(query_594005, "uploadType", newJString(uploadType))
  add(path_594004, "hash", newJString(hash))
  add(query_594005, "resultsCachePolicy.priority",
      newJInt(resultsCachePolicyPriority))
  add(query_594005, "key", newJString(key))
  add(query_594005, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594006 = body
  add(query_594005, "prettyPrint", newJBool(prettyPrint))
  result = call_594003.call(path_594004, query_594005, nil, nil, body_594006)

var remotebuildexecutionActionResultsUpdate* = Call_RemotebuildexecutionActionResultsUpdate_593983(
    name: "remotebuildexecutionActionResultsUpdate", meth: HttpMethod.HttpPut,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actionResults/{hash}/{sizeBytes}",
    validator: validate_RemotebuildexecutionActionResultsUpdate_593984, base: "/",
    url: url_RemotebuildexecutionActionResultsUpdate_593985,
    schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionActionResultsGet_593690 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionActionResultsGet_593692(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "instanceName" in path, "`instanceName` is a required path parameter"
  assert "hash" in path, "`hash` is a required path parameter"
  assert "sizeBytes" in path, "`sizeBytes` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "instanceName"),
               (kind: ConstantSegment, value: "/actionResults/"),
               (kind: VariableSegment, value: "hash"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "sizeBytes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionActionResultsGet_593691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a cached execution result.
  ## 
  ## Implementations SHOULD ensure that any blobs referenced from the
  ## ContentAddressableStorage
  ## are available at the time of returning the
  ## ActionResult and will be
  ## for some period of time afterwards. The TTLs of the referenced blobs SHOULD be increased
  ## if necessary and applicable.
  ## 
  ## Errors:
  ## 
  ## * `NOT_FOUND`: The requested `ActionResult` is not in the cache.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sizeBytes: JString (required)
  ##            : The size of the blob, in bytes.
  ##   instanceName: JString (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  ##   hash: JString (required)
  ##       : The hash. In the case of SHA-256, it will always be a lowercase hex string
  ## exactly 64 characters long.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sizeBytes` field"
  var valid_593818 = path.getOrDefault("sizeBytes")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "sizeBytes", valid_593818
  var valid_593819 = path.getOrDefault("instanceName")
  valid_593819 = validateParameter(valid_593819, JString, required = true,
                                 default = nil)
  if valid_593819 != nil:
    section.add "instanceName", valid_593819
  var valid_593820 = path.getOrDefault("hash")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "hash", valid_593820
  result.add "path", section
  ## parameters in `query` object:
  ##   inlineOutputFiles: JArray
  ##                    : A hint to the server to inline the contents of the listed output files.
  ## Each path needs to exactly match one path in `output_files` in the
  ## Command message.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   inlineStderr: JBool
  ##               : A hint to the server to request inlining stderr in the
  ## ActionResult message.
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
  ##   inlineStdout: JBool
  ##               : A hint to the server to request inlining stdout in the
  ## ActionResult message.
  section = newJObject()
  var valid_593821 = query.getOrDefault("inlineOutputFiles")
  valid_593821 = validateParameter(valid_593821, JArray, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "inlineOutputFiles", valid_593821
  var valid_593822 = query.getOrDefault("upload_protocol")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "upload_protocol", valid_593822
  var valid_593823 = query.getOrDefault("fields")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "fields", valid_593823
  var valid_593824 = query.getOrDefault("quotaUser")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "quotaUser", valid_593824
  var valid_593838 = query.getOrDefault("alt")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = newJString("json"))
  if valid_593838 != nil:
    section.add "alt", valid_593838
  var valid_593839 = query.getOrDefault("inlineStderr")
  valid_593839 = validateParameter(valid_593839, JBool, required = false, default = nil)
  if valid_593839 != nil:
    section.add "inlineStderr", valid_593839
  var valid_593840 = query.getOrDefault("oauth_token")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "oauth_token", valid_593840
  var valid_593841 = query.getOrDefault("callback")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = nil)
  if valid_593841 != nil:
    section.add "callback", valid_593841
  var valid_593842 = query.getOrDefault("access_token")
  valid_593842 = validateParameter(valid_593842, JString, required = false,
                                 default = nil)
  if valid_593842 != nil:
    section.add "access_token", valid_593842
  var valid_593843 = query.getOrDefault("uploadType")
  valid_593843 = validateParameter(valid_593843, JString, required = false,
                                 default = nil)
  if valid_593843 != nil:
    section.add "uploadType", valid_593843
  var valid_593844 = query.getOrDefault("key")
  valid_593844 = validateParameter(valid_593844, JString, required = false,
                                 default = nil)
  if valid_593844 != nil:
    section.add "key", valid_593844
  var valid_593845 = query.getOrDefault("$.xgafv")
  valid_593845 = validateParameter(valid_593845, JString, required = false,
                                 default = newJString("1"))
  if valid_593845 != nil:
    section.add "$.xgafv", valid_593845
  var valid_593846 = query.getOrDefault("prettyPrint")
  valid_593846 = validateParameter(valid_593846, JBool, required = false,
                                 default = newJBool(true))
  if valid_593846 != nil:
    section.add "prettyPrint", valid_593846
  var valid_593847 = query.getOrDefault("inlineStdout")
  valid_593847 = validateParameter(valid_593847, JBool, required = false, default = nil)
  if valid_593847 != nil:
    section.add "inlineStdout", valid_593847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593870: Call_RemotebuildexecutionActionResultsGet_593690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve a cached execution result.
  ## 
  ## Implementations SHOULD ensure that any blobs referenced from the
  ## ContentAddressableStorage
  ## are available at the time of returning the
  ## ActionResult and will be
  ## for some period of time afterwards. The TTLs of the referenced blobs SHOULD be increased
  ## if necessary and applicable.
  ## 
  ## Errors:
  ## 
  ## * `NOT_FOUND`: The requested `ActionResult` is not in the cache.
  ## 
  let valid = call_593870.validator(path, query, header, formData, body)
  let scheme = call_593870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593870.url(scheme.get, call_593870.host, call_593870.base,
                         call_593870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593870, url, valid)

proc call*(call_593941: Call_RemotebuildexecutionActionResultsGet_593690;
          sizeBytes: string; instanceName: string; hash: string;
          inlineOutputFiles: JsonNode = nil; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          inlineStderr: bool = false; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; inlineStdout: bool = false): Recallable =
  ## remotebuildexecutionActionResultsGet
  ## Retrieve a cached execution result.
  ## 
  ## Implementations SHOULD ensure that any blobs referenced from the
  ## ContentAddressableStorage
  ## are available at the time of returning the
  ## ActionResult and will be
  ## for some period of time afterwards. The TTLs of the referenced blobs SHOULD be increased
  ## if necessary and applicable.
  ## 
  ## Errors:
  ## 
  ## * `NOT_FOUND`: The requested `ActionResult` is not in the cache.
  ##   inlineOutputFiles: JArray
  ##                    : A hint to the server to inline the contents of the listed output files.
  ## Each path needs to exactly match one path in `output_files` in the
  ## Command message.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   sizeBytes: string (required)
  ##            : The size of the blob, in bytes.
  ##   alt: string
  ##      : Data format for response.
  ##   inlineStderr: bool
  ##               : A hint to the server to request inlining stderr in the
  ## ActionResult message.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   hash: string (required)
  ##       : The hash. In the case of SHA-256, it will always be a lowercase hex string
  ## exactly 64 characters long.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   inlineStdout: bool
  ##               : A hint to the server to request inlining stdout in the
  ## ActionResult message.
  var path_593942 = newJObject()
  var query_593944 = newJObject()
  if inlineOutputFiles != nil:
    query_593944.add "inlineOutputFiles", inlineOutputFiles
  add(query_593944, "upload_protocol", newJString(uploadProtocol))
  add(query_593944, "fields", newJString(fields))
  add(query_593944, "quotaUser", newJString(quotaUser))
  add(path_593942, "sizeBytes", newJString(sizeBytes))
  add(query_593944, "alt", newJString(alt))
  add(query_593944, "inlineStderr", newJBool(inlineStderr))
  add(path_593942, "instanceName", newJString(instanceName))
  add(query_593944, "oauth_token", newJString(oauthToken))
  add(query_593944, "callback", newJString(callback))
  add(query_593944, "access_token", newJString(accessToken))
  add(query_593944, "uploadType", newJString(uploadType))
  add(path_593942, "hash", newJString(hash))
  add(query_593944, "key", newJString(key))
  add(query_593944, "$.xgafv", newJString(Xgafv))
  add(query_593944, "prettyPrint", newJBool(prettyPrint))
  add(query_593944, "inlineStdout", newJBool(inlineStdout))
  result = call_593941.call(path_593942, query_593944, nil, nil, nil)

var remotebuildexecutionActionResultsGet* = Call_RemotebuildexecutionActionResultsGet_593690(
    name: "remotebuildexecutionActionResultsGet", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actionResults/{hash}/{sizeBytes}",
    validator: validate_RemotebuildexecutionActionResultsGet_593691, base: "/",
    url: url_RemotebuildexecutionActionResultsGet_593692, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionActionsExecute_594007 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionActionsExecute_594009(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "instanceName" in path, "`instanceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "instanceName"),
               (kind: ConstantSegment, value: "/actions:execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionActionsExecute_594008(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute an action remotely.
  ## 
  ## In order to execute an action, the client must first upload all of the
  ## inputs, the
  ## Command to run, and the
  ## Action into the
  ## ContentAddressableStorage.
  ## It then calls `Execute` with an `action_digest` referring to them. The
  ## server will run the action and eventually return the result.
  ## 
  ## The input `Action`'s fields MUST meet the various canonicalization
  ## requirements specified in the documentation for their types so that it has
  ## the same digest as other logically equivalent `Action`s. The server MAY
  ## enforce the requirements and return errors if a non-canonical input is
  ## received. It MAY also proceed without verifying some or all of the
  ## requirements, such as for performance reasons. If the server does not
  ## verify the requirement, then it will treat the `Action` as distinct from
  ## another logically equivalent action if they hash differently.
  ## 
  ## Returns a stream of
  ## google.longrunning.Operation messages
  ## describing the resulting execution, with eventual `response`
  ## ExecuteResponse. The
  ## `metadata` on the operation is of type
  ## ExecuteOperationMetadata.
  ## 
  ## If the client remains connected after the first response is returned after
  ## the server, then updates are streamed as if the client had called
  ## WaitExecution
  ## until the execution completes or the request reaches an error. The
  ## operation can also be queried using Operations
  ## API.
  ## 
  ## The server NEED NOT implement other methods or functionality of the
  ## Operations API.
  ## 
  ## Errors discovered during creation of the `Operation` will be reported
  ## as gRPC Status errors, while errors that occurred while running the
  ## action will be reported in the `status` field of the `ExecuteResponse`. The
  ## server MUST NOT set the `error` field of the `Operation` proto.
  ## The possible errors include:
  ## 
  ## * `INVALID_ARGUMENT`: One or more arguments are invalid.
  ## * `FAILED_PRECONDITION`: One or more errors occurred in setting up the
  ##   action requested, such as a missing input or command or no worker being
  ##   available. The client may be able to fix the errors and retry.
  ## * `RESOURCE_EXHAUSTED`: There is insufficient quota of some resource to run
  ##   the action.
  ## * `UNAVAILABLE`: Due to a transient condition, such as all workers being
  ##   occupied (and the server does not support a queue), the action could not
  ##   be started. The client should retry.
  ## * `INTERNAL`: An internal error occurred in the execution engine or the
  ##   worker.
  ## * `DEADLINE_EXCEEDED`: The execution timed out.
  ## * `CANCELLED`: The operation was cancelled by the client. This status is
  ##   only possible if the server implements the Operations API CancelOperation
  ##   method, and it was called for the current execution.
  ## 
  ## In the case of a missing input or command, the server SHOULD additionally
  ## send a PreconditionFailure error detail
  ## where, for each requested blob not present in the CAS, there is a
  ## `Violation` with a `type` of `MISSING` and a `subject` of
  ## `"blobs/{hash}/{size}"` indicating the digest of the missing blob.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instanceName: JString (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `instanceName` field"
  var valid_594010 = path.getOrDefault("instanceName")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "instanceName", valid_594010
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
  var valid_594011 = query.getOrDefault("upload_protocol")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "upload_protocol", valid_594011
  var valid_594012 = query.getOrDefault("fields")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "fields", valid_594012
  var valid_594013 = query.getOrDefault("quotaUser")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "quotaUser", valid_594013
  var valid_594014 = query.getOrDefault("alt")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = newJString("json"))
  if valid_594014 != nil:
    section.add "alt", valid_594014
  var valid_594015 = query.getOrDefault("oauth_token")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "oauth_token", valid_594015
  var valid_594016 = query.getOrDefault("callback")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "callback", valid_594016
  var valid_594017 = query.getOrDefault("access_token")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "access_token", valid_594017
  var valid_594018 = query.getOrDefault("uploadType")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "uploadType", valid_594018
  var valid_594019 = query.getOrDefault("key")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "key", valid_594019
  var valid_594020 = query.getOrDefault("$.xgafv")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = newJString("1"))
  if valid_594020 != nil:
    section.add "$.xgafv", valid_594020
  var valid_594021 = query.getOrDefault("prettyPrint")
  valid_594021 = validateParameter(valid_594021, JBool, required = false,
                                 default = newJBool(true))
  if valid_594021 != nil:
    section.add "prettyPrint", valid_594021
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

proc call*(call_594023: Call_RemotebuildexecutionActionsExecute_594007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Execute an action remotely.
  ## 
  ## In order to execute an action, the client must first upload all of the
  ## inputs, the
  ## Command to run, and the
  ## Action into the
  ## ContentAddressableStorage.
  ## It then calls `Execute` with an `action_digest` referring to them. The
  ## server will run the action and eventually return the result.
  ## 
  ## The input `Action`'s fields MUST meet the various canonicalization
  ## requirements specified in the documentation for their types so that it has
  ## the same digest as other logically equivalent `Action`s. The server MAY
  ## enforce the requirements and return errors if a non-canonical input is
  ## received. It MAY also proceed without verifying some or all of the
  ## requirements, such as for performance reasons. If the server does not
  ## verify the requirement, then it will treat the `Action` as distinct from
  ## another logically equivalent action if they hash differently.
  ## 
  ## Returns a stream of
  ## google.longrunning.Operation messages
  ## describing the resulting execution, with eventual `response`
  ## ExecuteResponse. The
  ## `metadata` on the operation is of type
  ## ExecuteOperationMetadata.
  ## 
  ## If the client remains connected after the first response is returned after
  ## the server, then updates are streamed as if the client had called
  ## WaitExecution
  ## until the execution completes or the request reaches an error. The
  ## operation can also be queried using Operations
  ## API.
  ## 
  ## The server NEED NOT implement other methods or functionality of the
  ## Operations API.
  ## 
  ## Errors discovered during creation of the `Operation` will be reported
  ## as gRPC Status errors, while errors that occurred while running the
  ## action will be reported in the `status` field of the `ExecuteResponse`. The
  ## server MUST NOT set the `error` field of the `Operation` proto.
  ## The possible errors include:
  ## 
  ## * `INVALID_ARGUMENT`: One or more arguments are invalid.
  ## * `FAILED_PRECONDITION`: One or more errors occurred in setting up the
  ##   action requested, such as a missing input or command or no worker being
  ##   available. The client may be able to fix the errors and retry.
  ## * `RESOURCE_EXHAUSTED`: There is insufficient quota of some resource to run
  ##   the action.
  ## * `UNAVAILABLE`: Due to a transient condition, such as all workers being
  ##   occupied (and the server does not support a queue), the action could not
  ##   be started. The client should retry.
  ## * `INTERNAL`: An internal error occurred in the execution engine or the
  ##   worker.
  ## * `DEADLINE_EXCEEDED`: The execution timed out.
  ## * `CANCELLED`: The operation was cancelled by the client. This status is
  ##   only possible if the server implements the Operations API CancelOperation
  ##   method, and it was called for the current execution.
  ## 
  ## In the case of a missing input or command, the server SHOULD additionally
  ## send a PreconditionFailure error detail
  ## where, for each requested blob not present in the CAS, there is a
  ## `Violation` with a `type` of `MISSING` and a `subject` of
  ## `"blobs/{hash}/{size}"` indicating the digest of the missing blob.
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_RemotebuildexecutionActionsExecute_594007;
          instanceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## remotebuildexecutionActionsExecute
  ## Execute an action remotely.
  ## 
  ## In order to execute an action, the client must first upload all of the
  ## inputs, the
  ## Command to run, and the
  ## Action into the
  ## ContentAddressableStorage.
  ## It then calls `Execute` with an `action_digest` referring to them. The
  ## server will run the action and eventually return the result.
  ## 
  ## The input `Action`'s fields MUST meet the various canonicalization
  ## requirements specified in the documentation for their types so that it has
  ## the same digest as other logically equivalent `Action`s. The server MAY
  ## enforce the requirements and return errors if a non-canonical input is
  ## received. It MAY also proceed without verifying some or all of the
  ## requirements, such as for performance reasons. If the server does not
  ## verify the requirement, then it will treat the `Action` as distinct from
  ## another logically equivalent action if they hash differently.
  ## 
  ## Returns a stream of
  ## google.longrunning.Operation messages
  ## describing the resulting execution, with eventual `response`
  ## ExecuteResponse. The
  ## `metadata` on the operation is of type
  ## ExecuteOperationMetadata.
  ## 
  ## If the client remains connected after the first response is returned after
  ## the server, then updates are streamed as if the client had called
  ## WaitExecution
  ## until the execution completes or the request reaches an error. The
  ## operation can also be queried using Operations
  ## API.
  ## 
  ## The server NEED NOT implement other methods or functionality of the
  ## Operations API.
  ## 
  ## Errors discovered during creation of the `Operation` will be reported
  ## as gRPC Status errors, while errors that occurred while running the
  ## action will be reported in the `status` field of the `ExecuteResponse`. The
  ## server MUST NOT set the `error` field of the `Operation` proto.
  ## The possible errors include:
  ## 
  ## * `INVALID_ARGUMENT`: One or more arguments are invalid.
  ## * `FAILED_PRECONDITION`: One or more errors occurred in setting up the
  ##   action requested, such as a missing input or command or no worker being
  ##   available. The client may be able to fix the errors and retry.
  ## * `RESOURCE_EXHAUSTED`: There is insufficient quota of some resource to run
  ##   the action.
  ## * `UNAVAILABLE`: Due to a transient condition, such as all workers being
  ##   occupied (and the server does not support a queue), the action could not
  ##   be started. The client should retry.
  ## * `INTERNAL`: An internal error occurred in the execution engine or the
  ##   worker.
  ## * `DEADLINE_EXCEEDED`: The execution timed out.
  ## * `CANCELLED`: The operation was cancelled by the client. This status is
  ##   only possible if the server implements the Operations API CancelOperation
  ##   method, and it was called for the current execution.
  ## 
  ## In the case of a missing input or command, the server SHOULD additionally
  ## send a PreconditionFailure error detail
  ## where, for each requested blob not present in the CAS, there is a
  ## `Violation` with a `type` of `MISSING` and a `subject` of
  ## `"blobs/{hash}/{size}"` indicating the digest of the missing blob.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
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
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  var body_594027 = newJObject()
  add(query_594026, "upload_protocol", newJString(uploadProtocol))
  add(query_594026, "fields", newJString(fields))
  add(query_594026, "quotaUser", newJString(quotaUser))
  add(query_594026, "alt", newJString(alt))
  add(path_594025, "instanceName", newJString(instanceName))
  add(query_594026, "oauth_token", newJString(oauthToken))
  add(query_594026, "callback", newJString(callback))
  add(query_594026, "access_token", newJString(accessToken))
  add(query_594026, "uploadType", newJString(uploadType))
  add(query_594026, "key", newJString(key))
  add(query_594026, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594027 = body
  add(query_594026, "prettyPrint", newJBool(prettyPrint))
  result = call_594024.call(path_594025, query_594026, nil, nil, body_594027)

var remotebuildexecutionActionsExecute* = Call_RemotebuildexecutionActionsExecute_594007(
    name: "remotebuildexecutionActionsExecute", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actions:execute",
    validator: validate_RemotebuildexecutionActionsExecute_594008, base: "/",
    url: url_RemotebuildexecutionActionsExecute_594009, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsGetTree_594028 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionBlobsGetTree_594030(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "instanceName" in path, "`instanceName` is a required path parameter"
  assert "hash" in path, "`hash` is a required path parameter"
  assert "sizeBytes" in path, "`sizeBytes` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "instanceName"),
               (kind: ConstantSegment, value: "/blobs/"),
               (kind: VariableSegment, value: "hash"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "sizeBytes"),
               (kind: ConstantSegment, value: ":getTree")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionBlobsGetTree_594029(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetch the entire directory tree rooted at a node.
  ## 
  ## This request must be targeted at a
  ## Directory stored in the
  ## ContentAddressableStorage
  ## (CAS). The server will enumerate the `Directory` tree recursively and
  ## return every node descended from the root.
  ## 
  ## The GetTreeRequest.page_token parameter can be used to skip ahead in
  ## the stream (e.g. when retrying a partially completed and aborted request),
  ## by setting it to a value taken from GetTreeResponse.next_page_token of the
  ## last successfully processed GetTreeResponse).
  ## 
  ## The exact traversal order is unspecified and, unless retrieving subsequent
  ## pages from an earlier request, is not guaranteed to be stable across
  ## multiple invocations of `GetTree`.
  ## 
  ## If part of the tree is missing from the CAS, the server will return the
  ## portion present and omit the rest.
  ## 
  ## * `NOT_FOUND`: The requested tree root is not present in the CAS.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sizeBytes: JString (required)
  ##            : The size of the blob, in bytes.
  ##   instanceName: JString (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  ##   hash: JString (required)
  ##       : The hash. In the case of SHA-256, it will always be a lowercase hex string
  ## exactly 64 characters long.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sizeBytes` field"
  var valid_594031 = path.getOrDefault("sizeBytes")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "sizeBytes", valid_594031
  var valid_594032 = path.getOrDefault("instanceName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "instanceName", valid_594032
  var valid_594033 = path.getOrDefault("hash")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "hash", valid_594033
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A page token, which must be a value received in a previous
  ## GetTreeResponse.
  ## If present, the server will use it to return the following page of results.
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
  ##           : A maximum page size to request. If present, the server will request no more
  ## than this many items. Regardless of whether a page size is specified, the
  ## server may place its own limit on the number of items to be returned and
  ## require the client to retrieve more items using a subsequent request.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594034 = query.getOrDefault("upload_protocol")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "upload_protocol", valid_594034
  var valid_594035 = query.getOrDefault("fields")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "fields", valid_594035
  var valid_594036 = query.getOrDefault("pageToken")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "pageToken", valid_594036
  var valid_594037 = query.getOrDefault("quotaUser")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "quotaUser", valid_594037
  var valid_594038 = query.getOrDefault("alt")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = newJString("json"))
  if valid_594038 != nil:
    section.add "alt", valid_594038
  var valid_594039 = query.getOrDefault("oauth_token")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "oauth_token", valid_594039
  var valid_594040 = query.getOrDefault("callback")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "callback", valid_594040
  var valid_594041 = query.getOrDefault("access_token")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "access_token", valid_594041
  var valid_594042 = query.getOrDefault("uploadType")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "uploadType", valid_594042
  var valid_594043 = query.getOrDefault("key")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "key", valid_594043
  var valid_594044 = query.getOrDefault("$.xgafv")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = newJString("1"))
  if valid_594044 != nil:
    section.add "$.xgafv", valid_594044
  var valid_594045 = query.getOrDefault("pageSize")
  valid_594045 = validateParameter(valid_594045, JInt, required = false, default = nil)
  if valid_594045 != nil:
    section.add "pageSize", valid_594045
  var valid_594046 = query.getOrDefault("prettyPrint")
  valid_594046 = validateParameter(valid_594046, JBool, required = false,
                                 default = newJBool(true))
  if valid_594046 != nil:
    section.add "prettyPrint", valid_594046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_RemotebuildexecutionBlobsGetTree_594028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetch the entire directory tree rooted at a node.
  ## 
  ## This request must be targeted at a
  ## Directory stored in the
  ## ContentAddressableStorage
  ## (CAS). The server will enumerate the `Directory` tree recursively and
  ## return every node descended from the root.
  ## 
  ## The GetTreeRequest.page_token parameter can be used to skip ahead in
  ## the stream (e.g. when retrying a partially completed and aborted request),
  ## by setting it to a value taken from GetTreeResponse.next_page_token of the
  ## last successfully processed GetTreeResponse).
  ## 
  ## The exact traversal order is unspecified and, unless retrieving subsequent
  ## pages from an earlier request, is not guaranteed to be stable across
  ## multiple invocations of `GetTree`.
  ## 
  ## If part of the tree is missing from the CAS, the server will return the
  ## portion present and omit the rest.
  ## 
  ## * `NOT_FOUND`: The requested tree root is not present in the CAS.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_RemotebuildexecutionBlobsGetTree_594028;
          sizeBytes: string; instanceName: string; hash: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## remotebuildexecutionBlobsGetTree
  ## Fetch the entire directory tree rooted at a node.
  ## 
  ## This request must be targeted at a
  ## Directory stored in the
  ## ContentAddressableStorage
  ## (CAS). The server will enumerate the `Directory` tree recursively and
  ## return every node descended from the root.
  ## 
  ## The GetTreeRequest.page_token parameter can be used to skip ahead in
  ## the stream (e.g. when retrying a partially completed and aborted request),
  ## by setting it to a value taken from GetTreeResponse.next_page_token of the
  ## last successfully processed GetTreeResponse).
  ## 
  ## The exact traversal order is unspecified and, unless retrieving subsequent
  ## pages from an earlier request, is not guaranteed to be stable across
  ## multiple invocations of `GetTree`.
  ## 
  ## If part of the tree is missing from the CAS, the server will return the
  ## portion present and omit the rest.
  ## 
  ## * `NOT_FOUND`: The requested tree root is not present in the CAS.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A page token, which must be a value received in a previous
  ## GetTreeResponse.
  ## If present, the server will use it to return the following page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   sizeBytes: string (required)
  ##            : The size of the blob, in bytes.
  ##   alt: string
  ##      : Data format for response.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   hash: string (required)
  ##       : The hash. In the case of SHA-256, it will always be a lowercase hex string
  ## exactly 64 characters long.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : A maximum page size to request. If present, the server will request no more
  ## than this many items. Regardless of whether a page size is specified, the
  ## server may place its own limit on the number of items to be returned and
  ## require the client to retrieve more items using a subsequent request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  add(query_594050, "upload_protocol", newJString(uploadProtocol))
  add(query_594050, "fields", newJString(fields))
  add(query_594050, "pageToken", newJString(pageToken))
  add(query_594050, "quotaUser", newJString(quotaUser))
  add(path_594049, "sizeBytes", newJString(sizeBytes))
  add(query_594050, "alt", newJString(alt))
  add(path_594049, "instanceName", newJString(instanceName))
  add(query_594050, "oauth_token", newJString(oauthToken))
  add(query_594050, "callback", newJString(callback))
  add(query_594050, "access_token", newJString(accessToken))
  add(query_594050, "uploadType", newJString(uploadType))
  add(path_594049, "hash", newJString(hash))
  add(query_594050, "key", newJString(key))
  add(query_594050, "$.xgafv", newJString(Xgafv))
  add(query_594050, "pageSize", newJInt(pageSize))
  add(query_594050, "prettyPrint", newJBool(prettyPrint))
  result = call_594048.call(path_594049, query_594050, nil, nil, nil)

var remotebuildexecutionBlobsGetTree* = Call_RemotebuildexecutionBlobsGetTree_594028(
    name: "remotebuildexecutionBlobsGetTree", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs/{hash}/{sizeBytes}:getTree",
    validator: validate_RemotebuildexecutionBlobsGetTree_594029, base: "/",
    url: url_RemotebuildexecutionBlobsGetTree_594030, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsBatchRead_594051 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionBlobsBatchRead_594053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "instanceName" in path, "`instanceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "instanceName"),
               (kind: ConstantSegment, value: "/blobs:batchRead")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionBlobsBatchRead_594052(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Download many blobs at once.
  ## 
  ## The server may enforce a limit of the combined total size of blobs
  ## to be downloaded using this API. This limit may be obtained using the
  ## Capabilities API.
  ## Requests exceeding the limit should either be split into smaller
  ## chunks or downloaded using the
  ## ByteStream API, as appropriate.
  ## 
  ## This request is equivalent to calling a Bytestream `Read` request
  ## on each individual blob, in parallel. The requests may succeed or fail
  ## independently.
  ## 
  ## Errors:
  ## 
  ## * `INVALID_ARGUMENT`: The client attempted to read more than the
  ##   server supported limit.
  ## 
  ## Every error on individual read will be returned in the corresponding digest
  ## status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instanceName: JString (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `instanceName` field"
  var valid_594054 = path.getOrDefault("instanceName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "instanceName", valid_594054
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
  var valid_594055 = query.getOrDefault("upload_protocol")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "upload_protocol", valid_594055
  var valid_594056 = query.getOrDefault("fields")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "fields", valid_594056
  var valid_594057 = query.getOrDefault("quotaUser")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "quotaUser", valid_594057
  var valid_594058 = query.getOrDefault("alt")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = newJString("json"))
  if valid_594058 != nil:
    section.add "alt", valid_594058
  var valid_594059 = query.getOrDefault("oauth_token")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "oauth_token", valid_594059
  var valid_594060 = query.getOrDefault("callback")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "callback", valid_594060
  var valid_594061 = query.getOrDefault("access_token")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "access_token", valid_594061
  var valid_594062 = query.getOrDefault("uploadType")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "uploadType", valid_594062
  var valid_594063 = query.getOrDefault("key")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "key", valid_594063
  var valid_594064 = query.getOrDefault("$.xgafv")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = newJString("1"))
  if valid_594064 != nil:
    section.add "$.xgafv", valid_594064
  var valid_594065 = query.getOrDefault("prettyPrint")
  valid_594065 = validateParameter(valid_594065, JBool, required = false,
                                 default = newJBool(true))
  if valid_594065 != nil:
    section.add "prettyPrint", valid_594065
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

proc call*(call_594067: Call_RemotebuildexecutionBlobsBatchRead_594051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Download many blobs at once.
  ## 
  ## The server may enforce a limit of the combined total size of blobs
  ## to be downloaded using this API. This limit may be obtained using the
  ## Capabilities API.
  ## Requests exceeding the limit should either be split into smaller
  ## chunks or downloaded using the
  ## ByteStream API, as appropriate.
  ## 
  ## This request is equivalent to calling a Bytestream `Read` request
  ## on each individual blob, in parallel. The requests may succeed or fail
  ## independently.
  ## 
  ## Errors:
  ## 
  ## * `INVALID_ARGUMENT`: The client attempted to read more than the
  ##   server supported limit.
  ## 
  ## Every error on individual read will be returned in the corresponding digest
  ## status.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_RemotebuildexecutionBlobsBatchRead_594051;
          instanceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## remotebuildexecutionBlobsBatchRead
  ## Download many blobs at once.
  ## 
  ## The server may enforce a limit of the combined total size of blobs
  ## to be downloaded using this API. This limit may be obtained using the
  ## Capabilities API.
  ## Requests exceeding the limit should either be split into smaller
  ## chunks or downloaded using the
  ## ByteStream API, as appropriate.
  ## 
  ## This request is equivalent to calling a Bytestream `Read` request
  ## on each individual blob, in parallel. The requests may succeed or fail
  ## independently.
  ## 
  ## Errors:
  ## 
  ## * `INVALID_ARGUMENT`: The client attempted to read more than the
  ##   server supported limit.
  ## 
  ## Every error on individual read will be returned in the corresponding digest
  ## status.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
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
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  var body_594071 = newJObject()
  add(query_594070, "upload_protocol", newJString(uploadProtocol))
  add(query_594070, "fields", newJString(fields))
  add(query_594070, "quotaUser", newJString(quotaUser))
  add(query_594070, "alt", newJString(alt))
  add(path_594069, "instanceName", newJString(instanceName))
  add(query_594070, "oauth_token", newJString(oauthToken))
  add(query_594070, "callback", newJString(callback))
  add(query_594070, "access_token", newJString(accessToken))
  add(query_594070, "uploadType", newJString(uploadType))
  add(query_594070, "key", newJString(key))
  add(query_594070, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594071 = body
  add(query_594070, "prettyPrint", newJBool(prettyPrint))
  result = call_594068.call(path_594069, query_594070, nil, nil, body_594071)

var remotebuildexecutionBlobsBatchRead* = Call_RemotebuildexecutionBlobsBatchRead_594051(
    name: "remotebuildexecutionBlobsBatchRead", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:batchRead",
    validator: validate_RemotebuildexecutionBlobsBatchRead_594052, base: "/",
    url: url_RemotebuildexecutionBlobsBatchRead_594053, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsBatchUpdate_594072 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionBlobsBatchUpdate_594074(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "instanceName" in path, "`instanceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "instanceName"),
               (kind: ConstantSegment, value: "/blobs:batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionBlobsBatchUpdate_594073(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upload many blobs at once.
  ## 
  ## The server may enforce a limit of the combined total size of blobs
  ## to be uploaded using this API. This limit may be obtained using the
  ## Capabilities API.
  ## Requests exceeding the limit should either be split into smaller
  ## chunks or uploaded using the
  ## ByteStream API, as appropriate.
  ## 
  ## This request is equivalent to calling a Bytestream `Write` request
  ## on each individual blob, in parallel. The requests may succeed or fail
  ## independently.
  ## 
  ## Errors:
  ## 
  ## * `INVALID_ARGUMENT`: The client attempted to upload more than the
  ##   server supported limit.
  ## 
  ## Individual requests may return the following errors, additionally:
  ## 
  ## * `RESOURCE_EXHAUSTED`: There is insufficient disk quota to store the blob.
  ## * `INVALID_ARGUMENT`: The
  ## Digest does not match the
  ## provided data.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instanceName: JString (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `instanceName` field"
  var valid_594075 = path.getOrDefault("instanceName")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "instanceName", valid_594075
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
  var valid_594076 = query.getOrDefault("upload_protocol")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "upload_protocol", valid_594076
  var valid_594077 = query.getOrDefault("fields")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "fields", valid_594077
  var valid_594078 = query.getOrDefault("quotaUser")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "quotaUser", valid_594078
  var valid_594079 = query.getOrDefault("alt")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = newJString("json"))
  if valid_594079 != nil:
    section.add "alt", valid_594079
  var valid_594080 = query.getOrDefault("oauth_token")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "oauth_token", valid_594080
  var valid_594081 = query.getOrDefault("callback")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "callback", valid_594081
  var valid_594082 = query.getOrDefault("access_token")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "access_token", valid_594082
  var valid_594083 = query.getOrDefault("uploadType")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "uploadType", valid_594083
  var valid_594084 = query.getOrDefault("key")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "key", valid_594084
  var valid_594085 = query.getOrDefault("$.xgafv")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = newJString("1"))
  if valid_594085 != nil:
    section.add "$.xgafv", valid_594085
  var valid_594086 = query.getOrDefault("prettyPrint")
  valid_594086 = validateParameter(valid_594086, JBool, required = false,
                                 default = newJBool(true))
  if valid_594086 != nil:
    section.add "prettyPrint", valid_594086
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

proc call*(call_594088: Call_RemotebuildexecutionBlobsBatchUpdate_594072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload many blobs at once.
  ## 
  ## The server may enforce a limit of the combined total size of blobs
  ## to be uploaded using this API. This limit may be obtained using the
  ## Capabilities API.
  ## Requests exceeding the limit should either be split into smaller
  ## chunks or uploaded using the
  ## ByteStream API, as appropriate.
  ## 
  ## This request is equivalent to calling a Bytestream `Write` request
  ## on each individual blob, in parallel. The requests may succeed or fail
  ## independently.
  ## 
  ## Errors:
  ## 
  ## * `INVALID_ARGUMENT`: The client attempted to upload more than the
  ##   server supported limit.
  ## 
  ## Individual requests may return the following errors, additionally:
  ## 
  ## * `RESOURCE_EXHAUSTED`: There is insufficient disk quota to store the blob.
  ## * `INVALID_ARGUMENT`: The
  ## Digest does not match the
  ## provided data.
  ## 
  let valid = call_594088.validator(path, query, header, formData, body)
  let scheme = call_594088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594088.url(scheme.get, call_594088.host, call_594088.base,
                         call_594088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594088, url, valid)

proc call*(call_594089: Call_RemotebuildexecutionBlobsBatchUpdate_594072;
          instanceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## remotebuildexecutionBlobsBatchUpdate
  ## Upload many blobs at once.
  ## 
  ## The server may enforce a limit of the combined total size of blobs
  ## to be uploaded using this API. This limit may be obtained using the
  ## Capabilities API.
  ## Requests exceeding the limit should either be split into smaller
  ## chunks or uploaded using the
  ## ByteStream API, as appropriate.
  ## 
  ## This request is equivalent to calling a Bytestream `Write` request
  ## on each individual blob, in parallel. The requests may succeed or fail
  ## independently.
  ## 
  ## Errors:
  ## 
  ## * `INVALID_ARGUMENT`: The client attempted to upload more than the
  ##   server supported limit.
  ## 
  ## Individual requests may return the following errors, additionally:
  ## 
  ## * `RESOURCE_EXHAUSTED`: There is insufficient disk quota to store the blob.
  ## * `INVALID_ARGUMENT`: The
  ## Digest does not match the
  ## provided data.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
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
  var path_594090 = newJObject()
  var query_594091 = newJObject()
  var body_594092 = newJObject()
  add(query_594091, "upload_protocol", newJString(uploadProtocol))
  add(query_594091, "fields", newJString(fields))
  add(query_594091, "quotaUser", newJString(quotaUser))
  add(query_594091, "alt", newJString(alt))
  add(path_594090, "instanceName", newJString(instanceName))
  add(query_594091, "oauth_token", newJString(oauthToken))
  add(query_594091, "callback", newJString(callback))
  add(query_594091, "access_token", newJString(accessToken))
  add(query_594091, "uploadType", newJString(uploadType))
  add(query_594091, "key", newJString(key))
  add(query_594091, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594092 = body
  add(query_594091, "prettyPrint", newJBool(prettyPrint))
  result = call_594089.call(path_594090, query_594091, nil, nil, body_594092)

var remotebuildexecutionBlobsBatchUpdate* = Call_RemotebuildexecutionBlobsBatchUpdate_594072(
    name: "remotebuildexecutionBlobsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:batchUpdate",
    validator: validate_RemotebuildexecutionBlobsBatchUpdate_594073, base: "/",
    url: url_RemotebuildexecutionBlobsBatchUpdate_594074, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsFindMissing_594093 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionBlobsFindMissing_594095(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "instanceName" in path, "`instanceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "instanceName"),
               (kind: ConstantSegment, value: "/blobs:findMissing")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionBlobsFindMissing_594094(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Determine if blobs are present in the CAS.
  ## 
  ## Clients can use this API before uploading blobs to determine which ones are
  ## already present in the CAS and do not need to be uploaded again.
  ## 
  ## There are no method-specific errors.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instanceName: JString (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `instanceName` field"
  var valid_594096 = path.getOrDefault("instanceName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "instanceName", valid_594096
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
  var valid_594097 = query.getOrDefault("upload_protocol")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "upload_protocol", valid_594097
  var valid_594098 = query.getOrDefault("fields")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "fields", valid_594098
  var valid_594099 = query.getOrDefault("quotaUser")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "quotaUser", valid_594099
  var valid_594100 = query.getOrDefault("alt")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = newJString("json"))
  if valid_594100 != nil:
    section.add "alt", valid_594100
  var valid_594101 = query.getOrDefault("oauth_token")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "oauth_token", valid_594101
  var valid_594102 = query.getOrDefault("callback")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "callback", valid_594102
  var valid_594103 = query.getOrDefault("access_token")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "access_token", valid_594103
  var valid_594104 = query.getOrDefault("uploadType")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "uploadType", valid_594104
  var valid_594105 = query.getOrDefault("key")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "key", valid_594105
  var valid_594106 = query.getOrDefault("$.xgafv")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = newJString("1"))
  if valid_594106 != nil:
    section.add "$.xgafv", valid_594106
  var valid_594107 = query.getOrDefault("prettyPrint")
  valid_594107 = validateParameter(valid_594107, JBool, required = false,
                                 default = newJBool(true))
  if valid_594107 != nil:
    section.add "prettyPrint", valid_594107
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

proc call*(call_594109: Call_RemotebuildexecutionBlobsFindMissing_594093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Determine if blobs are present in the CAS.
  ## 
  ## Clients can use this API before uploading blobs to determine which ones are
  ## already present in the CAS and do not need to be uploaded again.
  ## 
  ## There are no method-specific errors.
  ## 
  let valid = call_594109.validator(path, query, header, formData, body)
  let scheme = call_594109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594109.url(scheme.get, call_594109.host, call_594109.base,
                         call_594109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594109, url, valid)

proc call*(call_594110: Call_RemotebuildexecutionBlobsFindMissing_594093;
          instanceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## remotebuildexecutionBlobsFindMissing
  ## Determine if blobs are present in the CAS.
  ## 
  ## Clients can use this API before uploading blobs to determine which ones are
  ## already present in the CAS and do not need to be uploaded again.
  ## 
  ## There are no method-specific errors.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
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
  var path_594111 = newJObject()
  var query_594112 = newJObject()
  var body_594113 = newJObject()
  add(query_594112, "upload_protocol", newJString(uploadProtocol))
  add(query_594112, "fields", newJString(fields))
  add(query_594112, "quotaUser", newJString(quotaUser))
  add(query_594112, "alt", newJString(alt))
  add(path_594111, "instanceName", newJString(instanceName))
  add(query_594112, "oauth_token", newJString(oauthToken))
  add(query_594112, "callback", newJString(callback))
  add(query_594112, "access_token", newJString(accessToken))
  add(query_594112, "uploadType", newJString(uploadType))
  add(query_594112, "key", newJString(key))
  add(query_594112, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594113 = body
  add(query_594112, "prettyPrint", newJBool(prettyPrint))
  result = call_594110.call(path_594111, query_594112, nil, nil, body_594113)

var remotebuildexecutionBlobsFindMissing* = Call_RemotebuildexecutionBlobsFindMissing_594093(
    name: "remotebuildexecutionBlobsFindMissing", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:findMissing",
    validator: validate_RemotebuildexecutionBlobsFindMissing_594094, base: "/",
    url: url_RemotebuildexecutionBlobsFindMissing_594095, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionGetCapabilities_594114 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionGetCapabilities_594116(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "instanceName" in path, "`instanceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "instanceName"),
               (kind: ConstantSegment, value: "/capabilities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionGetCapabilities_594115(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## GetCapabilities returns the server capabilities configuration of the
  ## remote endpoint.
  ## Only the capabilities of the services supported by the endpoint will
  ## be returned:
  ## * Execution + CAS + Action Cache endpoints should return both
  ##   CacheCapabilities and ExecutionCapabilities.
  ## * Execution only endpoints should return ExecutionCapabilities.
  ## * CAS + Action Cache only endpoints should return CacheCapabilities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instanceName: JString (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `instanceName` field"
  var valid_594117 = path.getOrDefault("instanceName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "instanceName", valid_594117
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
  var valid_594118 = query.getOrDefault("upload_protocol")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "upload_protocol", valid_594118
  var valid_594119 = query.getOrDefault("fields")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "fields", valid_594119
  var valid_594120 = query.getOrDefault("quotaUser")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "quotaUser", valid_594120
  var valid_594121 = query.getOrDefault("alt")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = newJString("json"))
  if valid_594121 != nil:
    section.add "alt", valid_594121
  var valid_594122 = query.getOrDefault("oauth_token")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "oauth_token", valid_594122
  var valid_594123 = query.getOrDefault("callback")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "callback", valid_594123
  var valid_594124 = query.getOrDefault("access_token")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "access_token", valid_594124
  var valid_594125 = query.getOrDefault("uploadType")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "uploadType", valid_594125
  var valid_594126 = query.getOrDefault("key")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "key", valid_594126
  var valid_594127 = query.getOrDefault("$.xgafv")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = newJString("1"))
  if valid_594127 != nil:
    section.add "$.xgafv", valid_594127
  var valid_594128 = query.getOrDefault("prettyPrint")
  valid_594128 = validateParameter(valid_594128, JBool, required = false,
                                 default = newJBool(true))
  if valid_594128 != nil:
    section.add "prettyPrint", valid_594128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594129: Call_RemotebuildexecutionGetCapabilities_594114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## GetCapabilities returns the server capabilities configuration of the
  ## remote endpoint.
  ## Only the capabilities of the services supported by the endpoint will
  ## be returned:
  ## * Execution + CAS + Action Cache endpoints should return both
  ##   CacheCapabilities and ExecutionCapabilities.
  ## * Execution only endpoints should return ExecutionCapabilities.
  ## * CAS + Action Cache only endpoints should return CacheCapabilities.
  ## 
  let valid = call_594129.validator(path, query, header, formData, body)
  let scheme = call_594129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594129.url(scheme.get, call_594129.host, call_594129.base,
                         call_594129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594129, url, valid)

proc call*(call_594130: Call_RemotebuildexecutionGetCapabilities_594114;
          instanceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## remotebuildexecutionGetCapabilities
  ## GetCapabilities returns the server capabilities configuration of the
  ## remote endpoint.
  ## Only the capabilities of the services supported by the endpoint will
  ## be returned:
  ## * Execution + CAS + Action Cache endpoints should return both
  ##   CacheCapabilities and ExecutionCapabilities.
  ## * Execution only endpoints should return ExecutionCapabilities.
  ## * CAS + Action Cache only endpoints should return CacheCapabilities.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
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
  var path_594131 = newJObject()
  var query_594132 = newJObject()
  add(query_594132, "upload_protocol", newJString(uploadProtocol))
  add(query_594132, "fields", newJString(fields))
  add(query_594132, "quotaUser", newJString(quotaUser))
  add(query_594132, "alt", newJString(alt))
  add(path_594131, "instanceName", newJString(instanceName))
  add(query_594132, "oauth_token", newJString(oauthToken))
  add(query_594132, "callback", newJString(callback))
  add(query_594132, "access_token", newJString(accessToken))
  add(query_594132, "uploadType", newJString(uploadType))
  add(query_594132, "key", newJString(key))
  add(query_594132, "$.xgafv", newJString(Xgafv))
  add(query_594132, "prettyPrint", newJBool(prettyPrint))
  result = call_594130.call(path_594131, query_594132, nil, nil, nil)

var remotebuildexecutionGetCapabilities* = Call_RemotebuildexecutionGetCapabilities_594114(
    name: "remotebuildexecutionGetCapabilities", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/capabilities",
    validator: validate_RemotebuildexecutionGetCapabilities_594115, base: "/",
    url: url_RemotebuildexecutionGetCapabilities_594116, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionOperationsWaitExecution_594133 = ref object of OpenApiRestCall_593421
proc url_RemotebuildexecutionOperationsWaitExecution_594135(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":waitExecution")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemotebuildexecutionOperationsWaitExecution_594134(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Wait for an execution operation to complete. When the client initially
  ## makes the request, the server immediately responds with the current status
  ## of the execution. The server will leave the request stream open until the
  ## operation completes, and then respond with the completed operation. The
  ## server MAY choose to stream additional updates as execution progresses,
  ## such as to provide an update as to the state of the execution.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the Operation
  ## returned by Execute.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594136 = path.getOrDefault("name")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "name", valid_594136
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
  var valid_594137 = query.getOrDefault("upload_protocol")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "upload_protocol", valid_594137
  var valid_594138 = query.getOrDefault("fields")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "fields", valid_594138
  var valid_594139 = query.getOrDefault("quotaUser")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "quotaUser", valid_594139
  var valid_594140 = query.getOrDefault("alt")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = newJString("json"))
  if valid_594140 != nil:
    section.add "alt", valid_594140
  var valid_594141 = query.getOrDefault("oauth_token")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "oauth_token", valid_594141
  var valid_594142 = query.getOrDefault("callback")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "callback", valid_594142
  var valid_594143 = query.getOrDefault("access_token")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "access_token", valid_594143
  var valid_594144 = query.getOrDefault("uploadType")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "uploadType", valid_594144
  var valid_594145 = query.getOrDefault("key")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "key", valid_594145
  var valid_594146 = query.getOrDefault("$.xgafv")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = newJString("1"))
  if valid_594146 != nil:
    section.add "$.xgafv", valid_594146
  var valid_594147 = query.getOrDefault("prettyPrint")
  valid_594147 = validateParameter(valid_594147, JBool, required = false,
                                 default = newJBool(true))
  if valid_594147 != nil:
    section.add "prettyPrint", valid_594147
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

proc call*(call_594149: Call_RemotebuildexecutionOperationsWaitExecution_594133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Wait for an execution operation to complete. When the client initially
  ## makes the request, the server immediately responds with the current status
  ## of the execution. The server will leave the request stream open until the
  ## operation completes, and then respond with the completed operation. The
  ## server MAY choose to stream additional updates as execution progresses,
  ## such as to provide an update as to the state of the execution.
  ## 
  let valid = call_594149.validator(path, query, header, formData, body)
  let scheme = call_594149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594149.url(scheme.get, call_594149.host, call_594149.base,
                         call_594149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594149, url, valid)

proc call*(call_594150: Call_RemotebuildexecutionOperationsWaitExecution_594133;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## remotebuildexecutionOperationsWaitExecution
  ## Wait for an execution operation to complete. When the client initially
  ## makes the request, the server immediately responds with the current status
  ## of the execution. The server will leave the request stream open until the
  ## operation completes, and then respond with the completed operation. The
  ## server MAY choose to stream additional updates as execution progresses,
  ## such as to provide an update as to the state of the execution.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the Operation
  ## returned by Execute.
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
  var path_594151 = newJObject()
  var query_594152 = newJObject()
  var body_594153 = newJObject()
  add(query_594152, "upload_protocol", newJString(uploadProtocol))
  add(query_594152, "fields", newJString(fields))
  add(query_594152, "quotaUser", newJString(quotaUser))
  add(path_594151, "name", newJString(name))
  add(query_594152, "alt", newJString(alt))
  add(query_594152, "oauth_token", newJString(oauthToken))
  add(query_594152, "callback", newJString(callback))
  add(query_594152, "access_token", newJString(accessToken))
  add(query_594152, "uploadType", newJString(uploadType))
  add(query_594152, "key", newJString(key))
  add(query_594152, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594153 = body
  add(query_594152, "prettyPrint", newJBool(prettyPrint))
  result = call_594150.call(path_594151, query_594152, nil, nil, body_594153)

var remotebuildexecutionOperationsWaitExecution* = Call_RemotebuildexecutionOperationsWaitExecution_594133(
    name: "remotebuildexecutionOperationsWaitExecution",
    meth: HttpMethod.HttpPost, host: "remotebuildexecution.googleapis.com",
    route: "/v2/{name}:waitExecution",
    validator: validate_RemotebuildexecutionOperationsWaitExecution_594134,
    base: "/", url: url_RemotebuildexecutionOperationsWaitExecution_594135,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
