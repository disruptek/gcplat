
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RemotebuildexecutionActionResultsUpdate_579983 = ref object of OpenApiRestCall_579421
proc url_RemotebuildexecutionActionResultsUpdate_579985(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RemotebuildexecutionActionResultsUpdate_579984(path: JsonNode;
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
  var valid_579986 = path.getOrDefault("sizeBytes")
  valid_579986 = validateParameter(valid_579986, JString, required = true,
                                 default = nil)
  if valid_579986 != nil:
    section.add "sizeBytes", valid_579986
  var valid_579987 = path.getOrDefault("instanceName")
  valid_579987 = validateParameter(valid_579987, JString, required = true,
                                 default = nil)
  if valid_579987 != nil:
    section.add "instanceName", valid_579987
  var valid_579988 = path.getOrDefault("hash")
  valid_579988 = validateParameter(valid_579988, JString, required = true,
                                 default = nil)
  if valid_579988 != nil:
    section.add "hash", valid_579988
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
  var valid_579989 = query.getOrDefault("upload_protocol")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "upload_protocol", valid_579989
  var valid_579990 = query.getOrDefault("fields")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "fields", valid_579990
  var valid_579991 = query.getOrDefault("quotaUser")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "quotaUser", valid_579991
  var valid_579992 = query.getOrDefault("alt")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = newJString("json"))
  if valid_579992 != nil:
    section.add "alt", valid_579992
  var valid_579993 = query.getOrDefault("oauth_token")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "oauth_token", valid_579993
  var valid_579994 = query.getOrDefault("callback")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "callback", valid_579994
  var valid_579995 = query.getOrDefault("access_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "access_token", valid_579995
  var valid_579996 = query.getOrDefault("uploadType")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "uploadType", valid_579996
  var valid_579997 = query.getOrDefault("resultsCachePolicy.priority")
  valid_579997 = validateParameter(valid_579997, JInt, required = false, default = nil)
  if valid_579997 != nil:
    section.add "resultsCachePolicy.priority", valid_579997
  var valid_579998 = query.getOrDefault("key")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "key", valid_579998
  var valid_579999 = query.getOrDefault("$.xgafv")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("1"))
  if valid_579999 != nil:
    section.add "$.xgafv", valid_579999
  var valid_580000 = query.getOrDefault("prettyPrint")
  valid_580000 = validateParameter(valid_580000, JBool, required = false,
                                 default = newJBool(true))
  if valid_580000 != nil:
    section.add "prettyPrint", valid_580000
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

proc call*(call_580002: Call_RemotebuildexecutionActionResultsUpdate_579983;
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
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_RemotebuildexecutionActionResultsUpdate_579983;
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
  var path_580004 = newJObject()
  var query_580005 = newJObject()
  var body_580006 = newJObject()
  add(query_580005, "upload_protocol", newJString(uploadProtocol))
  add(query_580005, "fields", newJString(fields))
  add(query_580005, "quotaUser", newJString(quotaUser))
  add(path_580004, "sizeBytes", newJString(sizeBytes))
  add(query_580005, "alt", newJString(alt))
  add(path_580004, "instanceName", newJString(instanceName))
  add(query_580005, "oauth_token", newJString(oauthToken))
  add(query_580005, "callback", newJString(callback))
  add(query_580005, "access_token", newJString(accessToken))
  add(query_580005, "uploadType", newJString(uploadType))
  add(path_580004, "hash", newJString(hash))
  add(query_580005, "resultsCachePolicy.priority",
      newJInt(resultsCachePolicyPriority))
  add(query_580005, "key", newJString(key))
  add(query_580005, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580006 = body
  add(query_580005, "prettyPrint", newJBool(prettyPrint))
  result = call_580003.call(path_580004, query_580005, nil, nil, body_580006)

var remotebuildexecutionActionResultsUpdate* = Call_RemotebuildexecutionActionResultsUpdate_579983(
    name: "remotebuildexecutionActionResultsUpdate", meth: HttpMethod.HttpPut,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actionResults/{hash}/{sizeBytes}",
    validator: validate_RemotebuildexecutionActionResultsUpdate_579984, base: "/",
    url: url_RemotebuildexecutionActionResultsUpdate_579985,
    schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionActionResultsGet_579690 = ref object of OpenApiRestCall_579421
proc url_RemotebuildexecutionActionResultsGet_579692(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RemotebuildexecutionActionResultsGet_579691(path: JsonNode;
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
  var valid_579818 = path.getOrDefault("sizeBytes")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "sizeBytes", valid_579818
  var valid_579819 = path.getOrDefault("instanceName")
  valid_579819 = validateParameter(valid_579819, JString, required = true,
                                 default = nil)
  if valid_579819 != nil:
    section.add "instanceName", valid_579819
  var valid_579820 = path.getOrDefault("hash")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "hash", valid_579820
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
  var valid_579821 = query.getOrDefault("inlineOutputFiles")
  valid_579821 = validateParameter(valid_579821, JArray, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "inlineOutputFiles", valid_579821
  var valid_579822 = query.getOrDefault("upload_protocol")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "upload_protocol", valid_579822
  var valid_579823 = query.getOrDefault("fields")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "fields", valid_579823
  var valid_579824 = query.getOrDefault("quotaUser")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "quotaUser", valid_579824
  var valid_579838 = query.getOrDefault("alt")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = newJString("json"))
  if valid_579838 != nil:
    section.add "alt", valid_579838
  var valid_579839 = query.getOrDefault("inlineStderr")
  valid_579839 = validateParameter(valid_579839, JBool, required = false, default = nil)
  if valid_579839 != nil:
    section.add "inlineStderr", valid_579839
  var valid_579840 = query.getOrDefault("oauth_token")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "oauth_token", valid_579840
  var valid_579841 = query.getOrDefault("callback")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = nil)
  if valid_579841 != nil:
    section.add "callback", valid_579841
  var valid_579842 = query.getOrDefault("access_token")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "access_token", valid_579842
  var valid_579843 = query.getOrDefault("uploadType")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = nil)
  if valid_579843 != nil:
    section.add "uploadType", valid_579843
  var valid_579844 = query.getOrDefault("key")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "key", valid_579844
  var valid_579845 = query.getOrDefault("$.xgafv")
  valid_579845 = validateParameter(valid_579845, JString, required = false,
                                 default = newJString("1"))
  if valid_579845 != nil:
    section.add "$.xgafv", valid_579845
  var valid_579846 = query.getOrDefault("prettyPrint")
  valid_579846 = validateParameter(valid_579846, JBool, required = false,
                                 default = newJBool(true))
  if valid_579846 != nil:
    section.add "prettyPrint", valid_579846
  var valid_579847 = query.getOrDefault("inlineStdout")
  valid_579847 = validateParameter(valid_579847, JBool, required = false, default = nil)
  if valid_579847 != nil:
    section.add "inlineStdout", valid_579847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579870: Call_RemotebuildexecutionActionResultsGet_579690;
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
  let valid = call_579870.validator(path, query, header, formData, body)
  let scheme = call_579870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579870.url(scheme.get, call_579870.host, call_579870.base,
                         call_579870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579870, url, valid)

proc call*(call_579941: Call_RemotebuildexecutionActionResultsGet_579690;
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
  var path_579942 = newJObject()
  var query_579944 = newJObject()
  if inlineOutputFiles != nil:
    query_579944.add "inlineOutputFiles", inlineOutputFiles
  add(query_579944, "upload_protocol", newJString(uploadProtocol))
  add(query_579944, "fields", newJString(fields))
  add(query_579944, "quotaUser", newJString(quotaUser))
  add(path_579942, "sizeBytes", newJString(sizeBytes))
  add(query_579944, "alt", newJString(alt))
  add(query_579944, "inlineStderr", newJBool(inlineStderr))
  add(path_579942, "instanceName", newJString(instanceName))
  add(query_579944, "oauth_token", newJString(oauthToken))
  add(query_579944, "callback", newJString(callback))
  add(query_579944, "access_token", newJString(accessToken))
  add(query_579944, "uploadType", newJString(uploadType))
  add(path_579942, "hash", newJString(hash))
  add(query_579944, "key", newJString(key))
  add(query_579944, "$.xgafv", newJString(Xgafv))
  add(query_579944, "prettyPrint", newJBool(prettyPrint))
  add(query_579944, "inlineStdout", newJBool(inlineStdout))
  result = call_579941.call(path_579942, query_579944, nil, nil, nil)

var remotebuildexecutionActionResultsGet* = Call_RemotebuildexecutionActionResultsGet_579690(
    name: "remotebuildexecutionActionResultsGet", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actionResults/{hash}/{sizeBytes}",
    validator: validate_RemotebuildexecutionActionResultsGet_579691, base: "/",
    url: url_RemotebuildexecutionActionResultsGet_579692, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionActionsExecute_580007 = ref object of OpenApiRestCall_579421
proc url_RemotebuildexecutionActionsExecute_580009(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RemotebuildexecutionActionsExecute_580008(path: JsonNode;
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
  var valid_580010 = path.getOrDefault("instanceName")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "instanceName", valid_580010
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580023: Call_RemotebuildexecutionActionsExecute_580007;
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
  let valid = call_580023.validator(path, query, header, formData, body)
  let scheme = call_580023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580023.url(scheme.get, call_580023.host, call_580023.base,
                         call_580023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580023, url, valid)

proc call*(call_580024: Call_RemotebuildexecutionActionsExecute_580007;
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
  var path_580025 = newJObject()
  var query_580026 = newJObject()
  var body_580027 = newJObject()
  add(query_580026, "upload_protocol", newJString(uploadProtocol))
  add(query_580026, "fields", newJString(fields))
  add(query_580026, "quotaUser", newJString(quotaUser))
  add(query_580026, "alt", newJString(alt))
  add(path_580025, "instanceName", newJString(instanceName))
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "callback", newJString(callback))
  add(query_580026, "access_token", newJString(accessToken))
  add(query_580026, "uploadType", newJString(uploadType))
  add(query_580026, "key", newJString(key))
  add(query_580026, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580027 = body
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  result = call_580024.call(path_580025, query_580026, nil, nil, body_580027)

var remotebuildexecutionActionsExecute* = Call_RemotebuildexecutionActionsExecute_580007(
    name: "remotebuildexecutionActionsExecute", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actions:execute",
    validator: validate_RemotebuildexecutionActionsExecute_580008, base: "/",
    url: url_RemotebuildexecutionActionsExecute_580009, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsGetTree_580028 = ref object of OpenApiRestCall_579421
proc url_RemotebuildexecutionBlobsGetTree_580030(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RemotebuildexecutionBlobsGetTree_580029(path: JsonNode;
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
  var valid_580031 = path.getOrDefault("sizeBytes")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "sizeBytes", valid_580031
  var valid_580032 = path.getOrDefault("instanceName")
  valid_580032 = validateParameter(valid_580032, JString, required = true,
                                 default = nil)
  if valid_580032 != nil:
    section.add "instanceName", valid_580032
  var valid_580033 = path.getOrDefault("hash")
  valid_580033 = validateParameter(valid_580033, JString, required = true,
                                 default = nil)
  if valid_580033 != nil:
    section.add "hash", valid_580033
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
  var valid_580034 = query.getOrDefault("upload_protocol")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "upload_protocol", valid_580034
  var valid_580035 = query.getOrDefault("fields")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "fields", valid_580035
  var valid_580036 = query.getOrDefault("pageToken")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "pageToken", valid_580036
  var valid_580037 = query.getOrDefault("quotaUser")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "quotaUser", valid_580037
  var valid_580038 = query.getOrDefault("alt")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = newJString("json"))
  if valid_580038 != nil:
    section.add "alt", valid_580038
  var valid_580039 = query.getOrDefault("oauth_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "oauth_token", valid_580039
  var valid_580040 = query.getOrDefault("callback")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "callback", valid_580040
  var valid_580041 = query.getOrDefault("access_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "access_token", valid_580041
  var valid_580042 = query.getOrDefault("uploadType")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "uploadType", valid_580042
  var valid_580043 = query.getOrDefault("key")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "key", valid_580043
  var valid_580044 = query.getOrDefault("$.xgafv")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = newJString("1"))
  if valid_580044 != nil:
    section.add "$.xgafv", valid_580044
  var valid_580045 = query.getOrDefault("pageSize")
  valid_580045 = validateParameter(valid_580045, JInt, required = false, default = nil)
  if valid_580045 != nil:
    section.add "pageSize", valid_580045
  var valid_580046 = query.getOrDefault("prettyPrint")
  valid_580046 = validateParameter(valid_580046, JBool, required = false,
                                 default = newJBool(true))
  if valid_580046 != nil:
    section.add "prettyPrint", valid_580046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580047: Call_RemotebuildexecutionBlobsGetTree_580028;
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
  let valid = call_580047.validator(path, query, header, formData, body)
  let scheme = call_580047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580047.url(scheme.get, call_580047.host, call_580047.base,
                         call_580047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580047, url, valid)

proc call*(call_580048: Call_RemotebuildexecutionBlobsGetTree_580028;
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
  var path_580049 = newJObject()
  var query_580050 = newJObject()
  add(query_580050, "upload_protocol", newJString(uploadProtocol))
  add(query_580050, "fields", newJString(fields))
  add(query_580050, "pageToken", newJString(pageToken))
  add(query_580050, "quotaUser", newJString(quotaUser))
  add(path_580049, "sizeBytes", newJString(sizeBytes))
  add(query_580050, "alt", newJString(alt))
  add(path_580049, "instanceName", newJString(instanceName))
  add(query_580050, "oauth_token", newJString(oauthToken))
  add(query_580050, "callback", newJString(callback))
  add(query_580050, "access_token", newJString(accessToken))
  add(query_580050, "uploadType", newJString(uploadType))
  add(path_580049, "hash", newJString(hash))
  add(query_580050, "key", newJString(key))
  add(query_580050, "$.xgafv", newJString(Xgafv))
  add(query_580050, "pageSize", newJInt(pageSize))
  add(query_580050, "prettyPrint", newJBool(prettyPrint))
  result = call_580048.call(path_580049, query_580050, nil, nil, nil)

var remotebuildexecutionBlobsGetTree* = Call_RemotebuildexecutionBlobsGetTree_580028(
    name: "remotebuildexecutionBlobsGetTree", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs/{hash}/{sizeBytes}:getTree",
    validator: validate_RemotebuildexecutionBlobsGetTree_580029, base: "/",
    url: url_RemotebuildexecutionBlobsGetTree_580030, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsBatchRead_580051 = ref object of OpenApiRestCall_579421
proc url_RemotebuildexecutionBlobsBatchRead_580053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RemotebuildexecutionBlobsBatchRead_580052(path: JsonNode;
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
  var valid_580054 = path.getOrDefault("instanceName")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "instanceName", valid_580054
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
  var valid_580055 = query.getOrDefault("upload_protocol")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "upload_protocol", valid_580055
  var valid_580056 = query.getOrDefault("fields")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "fields", valid_580056
  var valid_580057 = query.getOrDefault("quotaUser")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "quotaUser", valid_580057
  var valid_580058 = query.getOrDefault("alt")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("json"))
  if valid_580058 != nil:
    section.add "alt", valid_580058
  var valid_580059 = query.getOrDefault("oauth_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "oauth_token", valid_580059
  var valid_580060 = query.getOrDefault("callback")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "callback", valid_580060
  var valid_580061 = query.getOrDefault("access_token")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "access_token", valid_580061
  var valid_580062 = query.getOrDefault("uploadType")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "uploadType", valid_580062
  var valid_580063 = query.getOrDefault("key")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "key", valid_580063
  var valid_580064 = query.getOrDefault("$.xgafv")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = newJString("1"))
  if valid_580064 != nil:
    section.add "$.xgafv", valid_580064
  var valid_580065 = query.getOrDefault("prettyPrint")
  valid_580065 = validateParameter(valid_580065, JBool, required = false,
                                 default = newJBool(true))
  if valid_580065 != nil:
    section.add "prettyPrint", valid_580065
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

proc call*(call_580067: Call_RemotebuildexecutionBlobsBatchRead_580051;
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
  let valid = call_580067.validator(path, query, header, formData, body)
  let scheme = call_580067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580067.url(scheme.get, call_580067.host, call_580067.base,
                         call_580067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580067, url, valid)

proc call*(call_580068: Call_RemotebuildexecutionBlobsBatchRead_580051;
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
  var path_580069 = newJObject()
  var query_580070 = newJObject()
  var body_580071 = newJObject()
  add(query_580070, "upload_protocol", newJString(uploadProtocol))
  add(query_580070, "fields", newJString(fields))
  add(query_580070, "quotaUser", newJString(quotaUser))
  add(query_580070, "alt", newJString(alt))
  add(path_580069, "instanceName", newJString(instanceName))
  add(query_580070, "oauth_token", newJString(oauthToken))
  add(query_580070, "callback", newJString(callback))
  add(query_580070, "access_token", newJString(accessToken))
  add(query_580070, "uploadType", newJString(uploadType))
  add(query_580070, "key", newJString(key))
  add(query_580070, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580071 = body
  add(query_580070, "prettyPrint", newJBool(prettyPrint))
  result = call_580068.call(path_580069, query_580070, nil, nil, body_580071)

var remotebuildexecutionBlobsBatchRead* = Call_RemotebuildexecutionBlobsBatchRead_580051(
    name: "remotebuildexecutionBlobsBatchRead", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:batchRead",
    validator: validate_RemotebuildexecutionBlobsBatchRead_580052, base: "/",
    url: url_RemotebuildexecutionBlobsBatchRead_580053, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsBatchUpdate_580072 = ref object of OpenApiRestCall_579421
proc url_RemotebuildexecutionBlobsBatchUpdate_580074(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RemotebuildexecutionBlobsBatchUpdate_580073(path: JsonNode;
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
  var valid_580075 = path.getOrDefault("instanceName")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "instanceName", valid_580075
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
  var valid_580076 = query.getOrDefault("upload_protocol")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "upload_protocol", valid_580076
  var valid_580077 = query.getOrDefault("fields")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "fields", valid_580077
  var valid_580078 = query.getOrDefault("quotaUser")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "quotaUser", valid_580078
  var valid_580079 = query.getOrDefault("alt")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = newJString("json"))
  if valid_580079 != nil:
    section.add "alt", valid_580079
  var valid_580080 = query.getOrDefault("oauth_token")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "oauth_token", valid_580080
  var valid_580081 = query.getOrDefault("callback")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "callback", valid_580081
  var valid_580082 = query.getOrDefault("access_token")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "access_token", valid_580082
  var valid_580083 = query.getOrDefault("uploadType")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "uploadType", valid_580083
  var valid_580084 = query.getOrDefault("key")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "key", valid_580084
  var valid_580085 = query.getOrDefault("$.xgafv")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = newJString("1"))
  if valid_580085 != nil:
    section.add "$.xgafv", valid_580085
  var valid_580086 = query.getOrDefault("prettyPrint")
  valid_580086 = validateParameter(valid_580086, JBool, required = false,
                                 default = newJBool(true))
  if valid_580086 != nil:
    section.add "prettyPrint", valid_580086
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

proc call*(call_580088: Call_RemotebuildexecutionBlobsBatchUpdate_580072;
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
  let valid = call_580088.validator(path, query, header, formData, body)
  let scheme = call_580088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580088.url(scheme.get, call_580088.host, call_580088.base,
                         call_580088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580088, url, valid)

proc call*(call_580089: Call_RemotebuildexecutionBlobsBatchUpdate_580072;
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
  var path_580090 = newJObject()
  var query_580091 = newJObject()
  var body_580092 = newJObject()
  add(query_580091, "upload_protocol", newJString(uploadProtocol))
  add(query_580091, "fields", newJString(fields))
  add(query_580091, "quotaUser", newJString(quotaUser))
  add(query_580091, "alt", newJString(alt))
  add(path_580090, "instanceName", newJString(instanceName))
  add(query_580091, "oauth_token", newJString(oauthToken))
  add(query_580091, "callback", newJString(callback))
  add(query_580091, "access_token", newJString(accessToken))
  add(query_580091, "uploadType", newJString(uploadType))
  add(query_580091, "key", newJString(key))
  add(query_580091, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580092 = body
  add(query_580091, "prettyPrint", newJBool(prettyPrint))
  result = call_580089.call(path_580090, query_580091, nil, nil, body_580092)

var remotebuildexecutionBlobsBatchUpdate* = Call_RemotebuildexecutionBlobsBatchUpdate_580072(
    name: "remotebuildexecutionBlobsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:batchUpdate",
    validator: validate_RemotebuildexecutionBlobsBatchUpdate_580073, base: "/",
    url: url_RemotebuildexecutionBlobsBatchUpdate_580074, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsFindMissing_580093 = ref object of OpenApiRestCall_579421
proc url_RemotebuildexecutionBlobsFindMissing_580095(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RemotebuildexecutionBlobsFindMissing_580094(path: JsonNode;
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
  var valid_580096 = path.getOrDefault("instanceName")
  valid_580096 = validateParameter(valid_580096, JString, required = true,
                                 default = nil)
  if valid_580096 != nil:
    section.add "instanceName", valid_580096
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
  var valid_580097 = query.getOrDefault("upload_protocol")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "upload_protocol", valid_580097
  var valid_580098 = query.getOrDefault("fields")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "fields", valid_580098
  var valid_580099 = query.getOrDefault("quotaUser")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "quotaUser", valid_580099
  var valid_580100 = query.getOrDefault("alt")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("json"))
  if valid_580100 != nil:
    section.add "alt", valid_580100
  var valid_580101 = query.getOrDefault("oauth_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "oauth_token", valid_580101
  var valid_580102 = query.getOrDefault("callback")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "callback", valid_580102
  var valid_580103 = query.getOrDefault("access_token")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "access_token", valid_580103
  var valid_580104 = query.getOrDefault("uploadType")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "uploadType", valid_580104
  var valid_580105 = query.getOrDefault("key")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "key", valid_580105
  var valid_580106 = query.getOrDefault("$.xgafv")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = newJString("1"))
  if valid_580106 != nil:
    section.add "$.xgafv", valid_580106
  var valid_580107 = query.getOrDefault("prettyPrint")
  valid_580107 = validateParameter(valid_580107, JBool, required = false,
                                 default = newJBool(true))
  if valid_580107 != nil:
    section.add "prettyPrint", valid_580107
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

proc call*(call_580109: Call_RemotebuildexecutionBlobsFindMissing_580093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Determine if blobs are present in the CAS.
  ## 
  ## Clients can use this API before uploading blobs to determine which ones are
  ## already present in the CAS and do not need to be uploaded again.
  ## 
  ## There are no method-specific errors.
  ## 
  let valid = call_580109.validator(path, query, header, formData, body)
  let scheme = call_580109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580109.url(scheme.get, call_580109.host, call_580109.base,
                         call_580109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580109, url, valid)

proc call*(call_580110: Call_RemotebuildexecutionBlobsFindMissing_580093;
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
  var path_580111 = newJObject()
  var query_580112 = newJObject()
  var body_580113 = newJObject()
  add(query_580112, "upload_protocol", newJString(uploadProtocol))
  add(query_580112, "fields", newJString(fields))
  add(query_580112, "quotaUser", newJString(quotaUser))
  add(query_580112, "alt", newJString(alt))
  add(path_580111, "instanceName", newJString(instanceName))
  add(query_580112, "oauth_token", newJString(oauthToken))
  add(query_580112, "callback", newJString(callback))
  add(query_580112, "access_token", newJString(accessToken))
  add(query_580112, "uploadType", newJString(uploadType))
  add(query_580112, "key", newJString(key))
  add(query_580112, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580113 = body
  add(query_580112, "prettyPrint", newJBool(prettyPrint))
  result = call_580110.call(path_580111, query_580112, nil, nil, body_580113)

var remotebuildexecutionBlobsFindMissing* = Call_RemotebuildexecutionBlobsFindMissing_580093(
    name: "remotebuildexecutionBlobsFindMissing", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:findMissing",
    validator: validate_RemotebuildexecutionBlobsFindMissing_580094, base: "/",
    url: url_RemotebuildexecutionBlobsFindMissing_580095, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionGetCapabilities_580114 = ref object of OpenApiRestCall_579421
proc url_RemotebuildexecutionGetCapabilities_580116(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RemotebuildexecutionGetCapabilities_580115(path: JsonNode;
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
  var valid_580117 = path.getOrDefault("instanceName")
  valid_580117 = validateParameter(valid_580117, JString, required = true,
                                 default = nil)
  if valid_580117 != nil:
    section.add "instanceName", valid_580117
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
  var valid_580118 = query.getOrDefault("upload_protocol")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "upload_protocol", valid_580118
  var valid_580119 = query.getOrDefault("fields")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "fields", valid_580119
  var valid_580120 = query.getOrDefault("quotaUser")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "quotaUser", valid_580120
  var valid_580121 = query.getOrDefault("alt")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("json"))
  if valid_580121 != nil:
    section.add "alt", valid_580121
  var valid_580122 = query.getOrDefault("oauth_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "oauth_token", valid_580122
  var valid_580123 = query.getOrDefault("callback")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "callback", valid_580123
  var valid_580124 = query.getOrDefault("access_token")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "access_token", valid_580124
  var valid_580125 = query.getOrDefault("uploadType")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "uploadType", valid_580125
  var valid_580126 = query.getOrDefault("key")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "key", valid_580126
  var valid_580127 = query.getOrDefault("$.xgafv")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = newJString("1"))
  if valid_580127 != nil:
    section.add "$.xgafv", valid_580127
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

proc call*(call_580129: Call_RemotebuildexecutionGetCapabilities_580114;
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
  let valid = call_580129.validator(path, query, header, formData, body)
  let scheme = call_580129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580129.url(scheme.get, call_580129.host, call_580129.base,
                         call_580129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580129, url, valid)

proc call*(call_580130: Call_RemotebuildexecutionGetCapabilities_580114;
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
  var path_580131 = newJObject()
  var query_580132 = newJObject()
  add(query_580132, "upload_protocol", newJString(uploadProtocol))
  add(query_580132, "fields", newJString(fields))
  add(query_580132, "quotaUser", newJString(quotaUser))
  add(query_580132, "alt", newJString(alt))
  add(path_580131, "instanceName", newJString(instanceName))
  add(query_580132, "oauth_token", newJString(oauthToken))
  add(query_580132, "callback", newJString(callback))
  add(query_580132, "access_token", newJString(accessToken))
  add(query_580132, "uploadType", newJString(uploadType))
  add(query_580132, "key", newJString(key))
  add(query_580132, "$.xgafv", newJString(Xgafv))
  add(query_580132, "prettyPrint", newJBool(prettyPrint))
  result = call_580130.call(path_580131, query_580132, nil, nil, nil)

var remotebuildexecutionGetCapabilities* = Call_RemotebuildexecutionGetCapabilities_580114(
    name: "remotebuildexecutionGetCapabilities", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/capabilities",
    validator: validate_RemotebuildexecutionGetCapabilities_580115, base: "/",
    url: url_RemotebuildexecutionGetCapabilities_580116, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionOperationsWaitExecution_580133 = ref object of OpenApiRestCall_579421
proc url_RemotebuildexecutionOperationsWaitExecution_580135(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RemotebuildexecutionOperationsWaitExecution_580134(path: JsonNode;
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
  var valid_580136 = path.getOrDefault("name")
  valid_580136 = validateParameter(valid_580136, JString, required = true,
                                 default = nil)
  if valid_580136 != nil:
    section.add "name", valid_580136
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

proc call*(call_580149: Call_RemotebuildexecutionOperationsWaitExecution_580133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Wait for an execution operation to complete. When the client initially
  ## makes the request, the server immediately responds with the current status
  ## of the execution. The server will leave the request stream open until the
  ## operation completes, and then respond with the completed operation. The
  ## server MAY choose to stream additional updates as execution progresses,
  ## such as to provide an update as to the state of the execution.
  ## 
  let valid = call_580149.validator(path, query, header, formData, body)
  let scheme = call_580149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580149.url(scheme.get, call_580149.host, call_580149.base,
                         call_580149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580149, url, valid)

proc call*(call_580150: Call_RemotebuildexecutionOperationsWaitExecution_580133;
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
  var path_580151 = newJObject()
  var query_580152 = newJObject()
  var body_580153 = newJObject()
  add(query_580152, "upload_protocol", newJString(uploadProtocol))
  add(query_580152, "fields", newJString(fields))
  add(query_580152, "quotaUser", newJString(quotaUser))
  add(path_580151, "name", newJString(name))
  add(query_580152, "alt", newJString(alt))
  add(query_580152, "oauth_token", newJString(oauthToken))
  add(query_580152, "callback", newJString(callback))
  add(query_580152, "access_token", newJString(accessToken))
  add(query_580152, "uploadType", newJString(uploadType))
  add(query_580152, "key", newJString(key))
  add(query_580152, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580153 = body
  add(query_580152, "prettyPrint", newJBool(prettyPrint))
  result = call_580150.call(path_580151, query_580152, nil, nil, body_580153)

var remotebuildexecutionOperationsWaitExecution* = Call_RemotebuildexecutionOperationsWaitExecution_580133(
    name: "remotebuildexecutionOperationsWaitExecution",
    meth: HttpMethod.HttpPost, host: "remotebuildexecution.googleapis.com",
    route: "/v2/{name}:waitExecution",
    validator: validate_RemotebuildexecutionOperationsWaitExecution_580134,
    base: "/", url: url_RemotebuildexecutionOperationsWaitExecution_580135,
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
