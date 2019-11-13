
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579373 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579373](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579373): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "remotebuildexecution"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RemotebuildexecutionActionResultsUpdate_579937 = ref object of OpenApiRestCall_579373
proc url_RemotebuildexecutionActionResultsUpdate_579939(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RemotebuildexecutionActionResultsUpdate_579938(path: JsonNode;
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
  ##   hash: JString (required)
  ##       : The hash. In the case of SHA-256, it will always be a lowercase hex string
  ## exactly 64 characters long.
  ##   sizeBytes: JString (required)
  ##            : The size of the blob, in bytes.
  ##   instanceName: JString (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hash` field"
  var valid_579940 = path.getOrDefault("hash")
  valid_579940 = validateParameter(valid_579940, JString, required = true,
                                 default = nil)
  if valid_579940 != nil:
    section.add "hash", valid_579940
  var valid_579941 = path.getOrDefault("sizeBytes")
  valid_579941 = validateParameter(valid_579941, JString, required = true,
                                 default = nil)
  if valid_579941 != nil:
    section.add "sizeBytes", valid_579941
  var valid_579942 = path.getOrDefault("instanceName")
  valid_579942 = validateParameter(valid_579942, JString, required = true,
                                 default = nil)
  if valid_579942 != nil:
    section.add "instanceName", valid_579942
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resultsCachePolicy.priority: JInt
  ##                              : The priority (relative importance) of this content in the overall cache.
  ## Generally, a lower value means a longer retention time or other advantage,
  ## but the interpretation of a given value is server-dependent. A priority of
  ## 0 means a *default* value, decided by the server.
  ## 
  ## The particular semantics of this field is up to the server. In particular,
  ## every server will have their own supported range of priorities, and will
  ## decide how these map into retention/eviction policy.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579943 = query.getOrDefault("key")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "key", valid_579943
  var valid_579944 = query.getOrDefault("prettyPrint")
  valid_579944 = validateParameter(valid_579944, JBool, required = false,
                                 default = newJBool(true))
  if valid_579944 != nil:
    section.add "prettyPrint", valid_579944
  var valid_579945 = query.getOrDefault("oauth_token")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "oauth_token", valid_579945
  var valid_579946 = query.getOrDefault("$.xgafv")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = newJString("1"))
  if valid_579946 != nil:
    section.add "$.xgafv", valid_579946
  var valid_579947 = query.getOrDefault("alt")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = newJString("json"))
  if valid_579947 != nil:
    section.add "alt", valid_579947
  var valid_579948 = query.getOrDefault("uploadType")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "uploadType", valid_579948
  var valid_579949 = query.getOrDefault("quotaUser")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "quotaUser", valid_579949
  var valid_579950 = query.getOrDefault("resultsCachePolicy.priority")
  valid_579950 = validateParameter(valid_579950, JInt, required = false, default = nil)
  if valid_579950 != nil:
    section.add "resultsCachePolicy.priority", valid_579950
  var valid_579951 = query.getOrDefault("callback")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "callback", valid_579951
  var valid_579952 = query.getOrDefault("fields")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "fields", valid_579952
  var valid_579953 = query.getOrDefault("access_token")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "access_token", valid_579953
  var valid_579954 = query.getOrDefault("upload_protocol")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "upload_protocol", valid_579954
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

proc call*(call_579956: Call_RemotebuildexecutionActionResultsUpdate_579937;
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
  let valid = call_579956.validator(path, query, header, formData, body)
  let scheme = call_579956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579956.url(scheme.get, call_579956.host, call_579956.base,
                         call_579956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579956, url, valid)

proc call*(call_579957: Call_RemotebuildexecutionActionResultsUpdate_579937;
          hash: string; sizeBytes: string; instanceName: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          resultsCachePolicyPriority: int = 0; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   hash: string (required)
  ##       : The hash. In the case of SHA-256, it will always be a lowercase hex string
  ## exactly 64 characters long.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   sizeBytes: string (required)
  ##            : The size of the blob, in bytes.
  ##   resultsCachePolicyPriority: int
  ##                             : The priority (relative importance) of this content in the overall cache.
  ## Generally, a lower value means a longer retention time or other advantage,
  ## but the interpretation of a given value is server-dependent. A priority of
  ## 0 means a *default* value, decided by the server.
  ## 
  ## The particular semantics of this field is up to the server. In particular,
  ## every server will have their own supported range of priorities, and will
  ## decide how these map into retention/eviction policy.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579958 = newJObject()
  var query_579959 = newJObject()
  var body_579960 = newJObject()
  add(query_579959, "key", newJString(key))
  add(query_579959, "prettyPrint", newJBool(prettyPrint))
  add(query_579959, "oauth_token", newJString(oauthToken))
  add(query_579959, "$.xgafv", newJString(Xgafv))
  add(path_579958, "hash", newJString(hash))
  add(query_579959, "alt", newJString(alt))
  add(query_579959, "uploadType", newJString(uploadType))
  add(query_579959, "quotaUser", newJString(quotaUser))
  add(path_579958, "sizeBytes", newJString(sizeBytes))
  add(query_579959, "resultsCachePolicy.priority",
      newJInt(resultsCachePolicyPriority))
  add(path_579958, "instanceName", newJString(instanceName))
  if body != nil:
    body_579960 = body
  add(query_579959, "callback", newJString(callback))
  add(query_579959, "fields", newJString(fields))
  add(query_579959, "access_token", newJString(accessToken))
  add(query_579959, "upload_protocol", newJString(uploadProtocol))
  result = call_579957.call(path_579958, query_579959, nil, nil, body_579960)

var remotebuildexecutionActionResultsUpdate* = Call_RemotebuildexecutionActionResultsUpdate_579937(
    name: "remotebuildexecutionActionResultsUpdate", meth: HttpMethod.HttpPut,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actionResults/{hash}/{sizeBytes}",
    validator: validate_RemotebuildexecutionActionResultsUpdate_579938, base: "/",
    url: url_RemotebuildexecutionActionResultsUpdate_579939,
    schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionActionResultsGet_579644 = ref object of OpenApiRestCall_579373
proc url_RemotebuildexecutionActionResultsGet_579646(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RemotebuildexecutionActionResultsGet_579645(path: JsonNode;
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
  ##   hash: JString (required)
  ##       : The hash. In the case of SHA-256, it will always be a lowercase hex string
  ## exactly 64 characters long.
  ##   sizeBytes: JString (required)
  ##            : The size of the blob, in bytes.
  ##   instanceName: JString (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hash` field"
  var valid_579772 = path.getOrDefault("hash")
  valid_579772 = validateParameter(valid_579772, JString, required = true,
                                 default = nil)
  if valid_579772 != nil:
    section.add "hash", valid_579772
  var valid_579773 = path.getOrDefault("sizeBytes")
  valid_579773 = validateParameter(valid_579773, JString, required = true,
                                 default = nil)
  if valid_579773 != nil:
    section.add "sizeBytes", valid_579773
  var valid_579774 = path.getOrDefault("instanceName")
  valid_579774 = validateParameter(valid_579774, JString, required = true,
                                 default = nil)
  if valid_579774 != nil:
    section.add "instanceName", valid_579774
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   inlineOutputFiles: JArray
  ##                    : A hint to the server to inline the contents of the listed output files.
  ## Each path needs to exactly match one path in `output_files` in the
  ## Command message.
  ##   inlineStdout: JBool
  ##               : A hint to the server to request inlining stdout in the
  ## ActionResult message.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   inlineStderr: JBool
  ##               : A hint to the server to request inlining stderr in the
  ## ActionResult message.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579775 = query.getOrDefault("key")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "key", valid_579775
  var valid_579789 = query.getOrDefault("prettyPrint")
  valid_579789 = validateParameter(valid_579789, JBool, required = false,
                                 default = newJBool(true))
  if valid_579789 != nil:
    section.add "prettyPrint", valid_579789
  var valid_579790 = query.getOrDefault("oauth_token")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "oauth_token", valid_579790
  var valid_579791 = query.getOrDefault("inlineOutputFiles")
  valid_579791 = validateParameter(valid_579791, JArray, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "inlineOutputFiles", valid_579791
  var valid_579792 = query.getOrDefault("inlineStdout")
  valid_579792 = validateParameter(valid_579792, JBool, required = false, default = nil)
  if valid_579792 != nil:
    section.add "inlineStdout", valid_579792
  var valid_579793 = query.getOrDefault("$.xgafv")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = newJString("1"))
  if valid_579793 != nil:
    section.add "$.xgafv", valid_579793
  var valid_579794 = query.getOrDefault("alt")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = newJString("json"))
  if valid_579794 != nil:
    section.add "alt", valid_579794
  var valid_579795 = query.getOrDefault("uploadType")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "uploadType", valid_579795
  var valid_579796 = query.getOrDefault("inlineStderr")
  valid_579796 = validateParameter(valid_579796, JBool, required = false, default = nil)
  if valid_579796 != nil:
    section.add "inlineStderr", valid_579796
  var valid_579797 = query.getOrDefault("quotaUser")
  valid_579797 = validateParameter(valid_579797, JString, required = false,
                                 default = nil)
  if valid_579797 != nil:
    section.add "quotaUser", valid_579797
  var valid_579798 = query.getOrDefault("callback")
  valid_579798 = validateParameter(valid_579798, JString, required = false,
                                 default = nil)
  if valid_579798 != nil:
    section.add "callback", valid_579798
  var valid_579799 = query.getOrDefault("fields")
  valid_579799 = validateParameter(valid_579799, JString, required = false,
                                 default = nil)
  if valid_579799 != nil:
    section.add "fields", valid_579799
  var valid_579800 = query.getOrDefault("access_token")
  valid_579800 = validateParameter(valid_579800, JString, required = false,
                                 default = nil)
  if valid_579800 != nil:
    section.add "access_token", valid_579800
  var valid_579801 = query.getOrDefault("upload_protocol")
  valid_579801 = validateParameter(valid_579801, JString, required = false,
                                 default = nil)
  if valid_579801 != nil:
    section.add "upload_protocol", valid_579801
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579824: Call_RemotebuildexecutionActionResultsGet_579644;
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
  let valid = call_579824.validator(path, query, header, formData, body)
  let scheme = call_579824.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579824.url(scheme.get, call_579824.host, call_579824.base,
                         call_579824.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579824, url, valid)

proc call*(call_579895: Call_RemotebuildexecutionActionResultsGet_579644;
          hash: string; sizeBytes: string; instanceName: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          inlineOutputFiles: JsonNode = nil; inlineStdout: bool = false;
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          inlineStderr: bool = false; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   inlineOutputFiles: JArray
  ##                    : A hint to the server to inline the contents of the listed output files.
  ## Each path needs to exactly match one path in `output_files` in the
  ## Command message.
  ##   inlineStdout: bool
  ##               : A hint to the server to request inlining stdout in the
  ## ActionResult message.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   hash: string (required)
  ##       : The hash. In the case of SHA-256, it will always be a lowercase hex string
  ## exactly 64 characters long.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   inlineStderr: bool
  ##               : A hint to the server to request inlining stderr in the
  ## ActionResult message.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   sizeBytes: string (required)
  ##            : The size of the blob, in bytes.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579896 = newJObject()
  var query_579898 = newJObject()
  add(query_579898, "key", newJString(key))
  add(query_579898, "prettyPrint", newJBool(prettyPrint))
  add(query_579898, "oauth_token", newJString(oauthToken))
  if inlineOutputFiles != nil:
    query_579898.add "inlineOutputFiles", inlineOutputFiles
  add(query_579898, "inlineStdout", newJBool(inlineStdout))
  add(query_579898, "$.xgafv", newJString(Xgafv))
  add(path_579896, "hash", newJString(hash))
  add(query_579898, "alt", newJString(alt))
  add(query_579898, "uploadType", newJString(uploadType))
  add(query_579898, "inlineStderr", newJBool(inlineStderr))
  add(query_579898, "quotaUser", newJString(quotaUser))
  add(path_579896, "sizeBytes", newJString(sizeBytes))
  add(path_579896, "instanceName", newJString(instanceName))
  add(query_579898, "callback", newJString(callback))
  add(query_579898, "fields", newJString(fields))
  add(query_579898, "access_token", newJString(accessToken))
  add(query_579898, "upload_protocol", newJString(uploadProtocol))
  result = call_579895.call(path_579896, query_579898, nil, nil, nil)

var remotebuildexecutionActionResultsGet* = Call_RemotebuildexecutionActionResultsGet_579644(
    name: "remotebuildexecutionActionResultsGet", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actionResults/{hash}/{sizeBytes}",
    validator: validate_RemotebuildexecutionActionResultsGet_579645, base: "/",
    url: url_RemotebuildexecutionActionResultsGet_579646, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionActionsExecute_579961 = ref object of OpenApiRestCall_579373
proc url_RemotebuildexecutionActionsExecute_579963(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RemotebuildexecutionActionsExecute_579962(path: JsonNode;
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
  var valid_579964 = path.getOrDefault("instanceName")
  valid_579964 = validateParameter(valid_579964, JString, required = true,
                                 default = nil)
  if valid_579964 != nil:
    section.add "instanceName", valid_579964
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579965 = query.getOrDefault("key")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "key", valid_579965
  var valid_579966 = query.getOrDefault("prettyPrint")
  valid_579966 = validateParameter(valid_579966, JBool, required = false,
                                 default = newJBool(true))
  if valid_579966 != nil:
    section.add "prettyPrint", valid_579966
  var valid_579967 = query.getOrDefault("oauth_token")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "oauth_token", valid_579967
  var valid_579968 = query.getOrDefault("$.xgafv")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = newJString("1"))
  if valid_579968 != nil:
    section.add "$.xgafv", valid_579968
  var valid_579969 = query.getOrDefault("alt")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = newJString("json"))
  if valid_579969 != nil:
    section.add "alt", valid_579969
  var valid_579970 = query.getOrDefault("uploadType")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "uploadType", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("callback")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "callback", valid_579972
  var valid_579973 = query.getOrDefault("fields")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "fields", valid_579973
  var valid_579974 = query.getOrDefault("access_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "access_token", valid_579974
  var valid_579975 = query.getOrDefault("upload_protocol")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "upload_protocol", valid_579975
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

proc call*(call_579977: Call_RemotebuildexecutionActionsExecute_579961;
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
  let valid = call_579977.validator(path, query, header, formData, body)
  let scheme = call_579977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579977.url(scheme.get, call_579977.host, call_579977.base,
                         call_579977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579977, url, valid)

proc call*(call_579978: Call_RemotebuildexecutionActionsExecute_579961;
          instanceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579979 = newJObject()
  var query_579980 = newJObject()
  var body_579981 = newJObject()
  add(query_579980, "key", newJString(key))
  add(query_579980, "prettyPrint", newJBool(prettyPrint))
  add(query_579980, "oauth_token", newJString(oauthToken))
  add(query_579980, "$.xgafv", newJString(Xgafv))
  add(query_579980, "alt", newJString(alt))
  add(query_579980, "uploadType", newJString(uploadType))
  add(query_579980, "quotaUser", newJString(quotaUser))
  add(path_579979, "instanceName", newJString(instanceName))
  if body != nil:
    body_579981 = body
  add(query_579980, "callback", newJString(callback))
  add(query_579980, "fields", newJString(fields))
  add(query_579980, "access_token", newJString(accessToken))
  add(query_579980, "upload_protocol", newJString(uploadProtocol))
  result = call_579978.call(path_579979, query_579980, nil, nil, body_579981)

var remotebuildexecutionActionsExecute* = Call_RemotebuildexecutionActionsExecute_579961(
    name: "remotebuildexecutionActionsExecute", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actions:execute",
    validator: validate_RemotebuildexecutionActionsExecute_579962, base: "/",
    url: url_RemotebuildexecutionActionsExecute_579963, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsGetTree_579982 = ref object of OpenApiRestCall_579373
proc url_RemotebuildexecutionBlobsGetTree_579984(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RemotebuildexecutionBlobsGetTree_579983(path: JsonNode;
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
  ##   hash: JString (required)
  ##       : The hash. In the case of SHA-256, it will always be a lowercase hex string
  ## exactly 64 characters long.
  ##   sizeBytes: JString (required)
  ##            : The size of the blob, in bytes.
  ##   instanceName: JString (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `hash` field"
  var valid_579985 = path.getOrDefault("hash")
  valid_579985 = validateParameter(valid_579985, JString, required = true,
                                 default = nil)
  if valid_579985 != nil:
    section.add "hash", valid_579985
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
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : A maximum page size to request. If present, the server will request no more
  ## than this many items. Regardless of whether a page size is specified, the
  ## server may place its own limit on the number of items to be returned and
  ## require the client to retrieve more items using a subsequent request.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A page token, which must be a value received in a previous
  ## GetTreeResponse.
  ## If present, the server will use it to return the following page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579988 = query.getOrDefault("key")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "key", valid_579988
  var valid_579989 = query.getOrDefault("prettyPrint")
  valid_579989 = validateParameter(valid_579989, JBool, required = false,
                                 default = newJBool(true))
  if valid_579989 != nil:
    section.add "prettyPrint", valid_579989
  var valid_579990 = query.getOrDefault("oauth_token")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "oauth_token", valid_579990
  var valid_579991 = query.getOrDefault("$.xgafv")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("1"))
  if valid_579991 != nil:
    section.add "$.xgafv", valid_579991
  var valid_579992 = query.getOrDefault("pageSize")
  valid_579992 = validateParameter(valid_579992, JInt, required = false, default = nil)
  if valid_579992 != nil:
    section.add "pageSize", valid_579992
  var valid_579993 = query.getOrDefault("alt")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("json"))
  if valid_579993 != nil:
    section.add "alt", valid_579993
  var valid_579994 = query.getOrDefault("uploadType")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "uploadType", valid_579994
  var valid_579995 = query.getOrDefault("quotaUser")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "quotaUser", valid_579995
  var valid_579996 = query.getOrDefault("pageToken")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "pageToken", valid_579996
  var valid_579997 = query.getOrDefault("callback")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "callback", valid_579997
  var valid_579998 = query.getOrDefault("fields")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "fields", valid_579998
  var valid_579999 = query.getOrDefault("access_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "access_token", valid_579999
  var valid_580000 = query.getOrDefault("upload_protocol")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "upload_protocol", valid_580000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580001: Call_RemotebuildexecutionBlobsGetTree_579982;
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
  let valid = call_580001.validator(path, query, header, formData, body)
  let scheme = call_580001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580001.url(scheme.get, call_580001.host, call_580001.base,
                         call_580001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580001, url, valid)

proc call*(call_580002: Call_RemotebuildexecutionBlobsGetTree_579982; hash: string;
          sizeBytes: string; instanceName: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   hash: string (required)
  ##       : The hash. In the case of SHA-256, it will always be a lowercase hex string
  ## exactly 64 characters long.
  ##   pageSize: int
  ##           : A maximum page size to request. If present, the server will request no more
  ## than this many items. Regardless of whether a page size is specified, the
  ## server may place its own limit on the number of items to be returned and
  ## require the client to retrieve more items using a subsequent request.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   sizeBytes: string (required)
  ##            : The size of the blob, in bytes.
  ##   pageToken: string
  ##            : A page token, which must be a value received in a previous
  ## GetTreeResponse.
  ## If present, the server will use it to return the following page of results.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580003 = newJObject()
  var query_580004 = newJObject()
  add(query_580004, "key", newJString(key))
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "$.xgafv", newJString(Xgafv))
  add(path_580003, "hash", newJString(hash))
  add(query_580004, "pageSize", newJInt(pageSize))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "uploadType", newJString(uploadType))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(path_580003, "sizeBytes", newJString(sizeBytes))
  add(query_580004, "pageToken", newJString(pageToken))
  add(path_580003, "instanceName", newJString(instanceName))
  add(query_580004, "callback", newJString(callback))
  add(query_580004, "fields", newJString(fields))
  add(query_580004, "access_token", newJString(accessToken))
  add(query_580004, "upload_protocol", newJString(uploadProtocol))
  result = call_580002.call(path_580003, query_580004, nil, nil, nil)

var remotebuildexecutionBlobsGetTree* = Call_RemotebuildexecutionBlobsGetTree_579982(
    name: "remotebuildexecutionBlobsGetTree", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs/{hash}/{sizeBytes}:getTree",
    validator: validate_RemotebuildexecutionBlobsGetTree_579983, base: "/",
    url: url_RemotebuildexecutionBlobsGetTree_579984, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsBatchRead_580005 = ref object of OpenApiRestCall_579373
proc url_RemotebuildexecutionBlobsBatchRead_580007(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RemotebuildexecutionBlobsBatchRead_580006(path: JsonNode;
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
  var valid_580008 = path.getOrDefault("instanceName")
  valid_580008 = validateParameter(valid_580008, JString, required = true,
                                 default = nil)
  if valid_580008 != nil:
    section.add "instanceName", valid_580008
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580009 = query.getOrDefault("key")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "key", valid_580009
  var valid_580010 = query.getOrDefault("prettyPrint")
  valid_580010 = validateParameter(valid_580010, JBool, required = false,
                                 default = newJBool(true))
  if valid_580010 != nil:
    section.add "prettyPrint", valid_580010
  var valid_580011 = query.getOrDefault("oauth_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "oauth_token", valid_580011
  var valid_580012 = query.getOrDefault("$.xgafv")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("1"))
  if valid_580012 != nil:
    section.add "$.xgafv", valid_580012
  var valid_580013 = query.getOrDefault("alt")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("json"))
  if valid_580013 != nil:
    section.add "alt", valid_580013
  var valid_580014 = query.getOrDefault("uploadType")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "uploadType", valid_580014
  var valid_580015 = query.getOrDefault("quotaUser")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "quotaUser", valid_580015
  var valid_580016 = query.getOrDefault("callback")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "callback", valid_580016
  var valid_580017 = query.getOrDefault("fields")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "fields", valid_580017
  var valid_580018 = query.getOrDefault("access_token")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "access_token", valid_580018
  var valid_580019 = query.getOrDefault("upload_protocol")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "upload_protocol", valid_580019
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

proc call*(call_580021: Call_RemotebuildexecutionBlobsBatchRead_580005;
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
  let valid = call_580021.validator(path, query, header, formData, body)
  let scheme = call_580021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580021.url(scheme.get, call_580021.host, call_580021.base,
                         call_580021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580021, url, valid)

proc call*(call_580022: Call_RemotebuildexecutionBlobsBatchRead_580005;
          instanceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580023 = newJObject()
  var query_580024 = newJObject()
  var body_580025 = newJObject()
  add(query_580024, "key", newJString(key))
  add(query_580024, "prettyPrint", newJBool(prettyPrint))
  add(query_580024, "oauth_token", newJString(oauthToken))
  add(query_580024, "$.xgafv", newJString(Xgafv))
  add(query_580024, "alt", newJString(alt))
  add(query_580024, "uploadType", newJString(uploadType))
  add(query_580024, "quotaUser", newJString(quotaUser))
  add(path_580023, "instanceName", newJString(instanceName))
  if body != nil:
    body_580025 = body
  add(query_580024, "callback", newJString(callback))
  add(query_580024, "fields", newJString(fields))
  add(query_580024, "access_token", newJString(accessToken))
  add(query_580024, "upload_protocol", newJString(uploadProtocol))
  result = call_580022.call(path_580023, query_580024, nil, nil, body_580025)

var remotebuildexecutionBlobsBatchRead* = Call_RemotebuildexecutionBlobsBatchRead_580005(
    name: "remotebuildexecutionBlobsBatchRead", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:batchRead",
    validator: validate_RemotebuildexecutionBlobsBatchRead_580006, base: "/",
    url: url_RemotebuildexecutionBlobsBatchRead_580007, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsBatchUpdate_580026 = ref object of OpenApiRestCall_579373
proc url_RemotebuildexecutionBlobsBatchUpdate_580028(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RemotebuildexecutionBlobsBatchUpdate_580027(path: JsonNode;
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
  var valid_580029 = path.getOrDefault("instanceName")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "instanceName", valid_580029
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580030 = query.getOrDefault("key")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "key", valid_580030
  var valid_580031 = query.getOrDefault("prettyPrint")
  valid_580031 = validateParameter(valid_580031, JBool, required = false,
                                 default = newJBool(true))
  if valid_580031 != nil:
    section.add "prettyPrint", valid_580031
  var valid_580032 = query.getOrDefault("oauth_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "oauth_token", valid_580032
  var valid_580033 = query.getOrDefault("$.xgafv")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("1"))
  if valid_580033 != nil:
    section.add "$.xgafv", valid_580033
  var valid_580034 = query.getOrDefault("alt")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("json"))
  if valid_580034 != nil:
    section.add "alt", valid_580034
  var valid_580035 = query.getOrDefault("uploadType")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "uploadType", valid_580035
  var valid_580036 = query.getOrDefault("quotaUser")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "quotaUser", valid_580036
  var valid_580037 = query.getOrDefault("callback")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "callback", valid_580037
  var valid_580038 = query.getOrDefault("fields")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "fields", valid_580038
  var valid_580039 = query.getOrDefault("access_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "access_token", valid_580039
  var valid_580040 = query.getOrDefault("upload_protocol")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "upload_protocol", valid_580040
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

proc call*(call_580042: Call_RemotebuildexecutionBlobsBatchUpdate_580026;
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
  let valid = call_580042.validator(path, query, header, formData, body)
  let scheme = call_580042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580042.url(scheme.get, call_580042.host, call_580042.base,
                         call_580042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580042, url, valid)

proc call*(call_580043: Call_RemotebuildexecutionBlobsBatchUpdate_580026;
          instanceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580044 = newJObject()
  var query_580045 = newJObject()
  var body_580046 = newJObject()
  add(query_580045, "key", newJString(key))
  add(query_580045, "prettyPrint", newJBool(prettyPrint))
  add(query_580045, "oauth_token", newJString(oauthToken))
  add(query_580045, "$.xgafv", newJString(Xgafv))
  add(query_580045, "alt", newJString(alt))
  add(query_580045, "uploadType", newJString(uploadType))
  add(query_580045, "quotaUser", newJString(quotaUser))
  add(path_580044, "instanceName", newJString(instanceName))
  if body != nil:
    body_580046 = body
  add(query_580045, "callback", newJString(callback))
  add(query_580045, "fields", newJString(fields))
  add(query_580045, "access_token", newJString(accessToken))
  add(query_580045, "upload_protocol", newJString(uploadProtocol))
  result = call_580043.call(path_580044, query_580045, nil, nil, body_580046)

var remotebuildexecutionBlobsBatchUpdate* = Call_RemotebuildexecutionBlobsBatchUpdate_580026(
    name: "remotebuildexecutionBlobsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:batchUpdate",
    validator: validate_RemotebuildexecutionBlobsBatchUpdate_580027, base: "/",
    url: url_RemotebuildexecutionBlobsBatchUpdate_580028, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsFindMissing_580047 = ref object of OpenApiRestCall_579373
proc url_RemotebuildexecutionBlobsFindMissing_580049(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RemotebuildexecutionBlobsFindMissing_580048(path: JsonNode;
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
  var valid_580050 = path.getOrDefault("instanceName")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "instanceName", valid_580050
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580051 = query.getOrDefault("key")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "key", valid_580051
  var valid_580052 = query.getOrDefault("prettyPrint")
  valid_580052 = validateParameter(valid_580052, JBool, required = false,
                                 default = newJBool(true))
  if valid_580052 != nil:
    section.add "prettyPrint", valid_580052
  var valid_580053 = query.getOrDefault("oauth_token")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "oauth_token", valid_580053
  var valid_580054 = query.getOrDefault("$.xgafv")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = newJString("1"))
  if valid_580054 != nil:
    section.add "$.xgafv", valid_580054
  var valid_580055 = query.getOrDefault("alt")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("json"))
  if valid_580055 != nil:
    section.add "alt", valid_580055
  var valid_580056 = query.getOrDefault("uploadType")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "uploadType", valid_580056
  var valid_580057 = query.getOrDefault("quotaUser")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "quotaUser", valid_580057
  var valid_580058 = query.getOrDefault("callback")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "callback", valid_580058
  var valid_580059 = query.getOrDefault("fields")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "fields", valid_580059
  var valid_580060 = query.getOrDefault("access_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "access_token", valid_580060
  var valid_580061 = query.getOrDefault("upload_protocol")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "upload_protocol", valid_580061
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

proc call*(call_580063: Call_RemotebuildexecutionBlobsFindMissing_580047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Determine if blobs are present in the CAS.
  ## 
  ## Clients can use this API before uploading blobs to determine which ones are
  ## already present in the CAS and do not need to be uploaded again.
  ## 
  ## There are no method-specific errors.
  ## 
  let valid = call_580063.validator(path, query, header, formData, body)
  let scheme = call_580063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580063.url(scheme.get, call_580063.host, call_580063.base,
                         call_580063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580063, url, valid)

proc call*(call_580064: Call_RemotebuildexecutionBlobsFindMissing_580047;
          instanceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## remotebuildexecutionBlobsFindMissing
  ## Determine if blobs are present in the CAS.
  ## 
  ## Clients can use this API before uploading blobs to determine which ones are
  ## already present in the CAS and do not need to be uploaded again.
  ## 
  ## There are no method-specific errors.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580065 = newJObject()
  var query_580066 = newJObject()
  var body_580067 = newJObject()
  add(query_580066, "key", newJString(key))
  add(query_580066, "prettyPrint", newJBool(prettyPrint))
  add(query_580066, "oauth_token", newJString(oauthToken))
  add(query_580066, "$.xgafv", newJString(Xgafv))
  add(query_580066, "alt", newJString(alt))
  add(query_580066, "uploadType", newJString(uploadType))
  add(query_580066, "quotaUser", newJString(quotaUser))
  add(path_580065, "instanceName", newJString(instanceName))
  if body != nil:
    body_580067 = body
  add(query_580066, "callback", newJString(callback))
  add(query_580066, "fields", newJString(fields))
  add(query_580066, "access_token", newJString(accessToken))
  add(query_580066, "upload_protocol", newJString(uploadProtocol))
  result = call_580064.call(path_580065, query_580066, nil, nil, body_580067)

var remotebuildexecutionBlobsFindMissing* = Call_RemotebuildexecutionBlobsFindMissing_580047(
    name: "remotebuildexecutionBlobsFindMissing", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:findMissing",
    validator: validate_RemotebuildexecutionBlobsFindMissing_580048, base: "/",
    url: url_RemotebuildexecutionBlobsFindMissing_580049, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionGetCapabilities_580068 = ref object of OpenApiRestCall_579373
proc url_RemotebuildexecutionGetCapabilities_580070(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RemotebuildexecutionGetCapabilities_580069(path: JsonNode;
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
  var valid_580071 = path.getOrDefault("instanceName")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "instanceName", valid_580071
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580072 = query.getOrDefault("key")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "key", valid_580072
  var valid_580073 = query.getOrDefault("prettyPrint")
  valid_580073 = validateParameter(valid_580073, JBool, required = false,
                                 default = newJBool(true))
  if valid_580073 != nil:
    section.add "prettyPrint", valid_580073
  var valid_580074 = query.getOrDefault("oauth_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "oauth_token", valid_580074
  var valid_580075 = query.getOrDefault("$.xgafv")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("1"))
  if valid_580075 != nil:
    section.add "$.xgafv", valid_580075
  var valid_580076 = query.getOrDefault("alt")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("json"))
  if valid_580076 != nil:
    section.add "alt", valid_580076
  var valid_580077 = query.getOrDefault("uploadType")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "uploadType", valid_580077
  var valid_580078 = query.getOrDefault("quotaUser")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "quotaUser", valid_580078
  var valid_580079 = query.getOrDefault("callback")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "callback", valid_580079
  var valid_580080 = query.getOrDefault("fields")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "fields", valid_580080
  var valid_580081 = query.getOrDefault("access_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "access_token", valid_580081
  var valid_580082 = query.getOrDefault("upload_protocol")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "upload_protocol", valid_580082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580083: Call_RemotebuildexecutionGetCapabilities_580068;
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
  let valid = call_580083.validator(path, query, header, formData, body)
  let scheme = call_580083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580083.url(scheme.get, call_580083.host, call_580083.base,
                         call_580083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580083, url, valid)

proc call*(call_580084: Call_RemotebuildexecutionGetCapabilities_580068;
          instanceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## remotebuildexecutionGetCapabilities
  ## GetCapabilities returns the server capabilities configuration of the
  ## remote endpoint.
  ## Only the capabilities of the services supported by the endpoint will
  ## be returned:
  ## * Execution + CAS + Action Cache endpoints should return both
  ##   CacheCapabilities and ExecutionCapabilities.
  ## * Execution only endpoints should return ExecutionCapabilities.
  ## * CAS + Action Cache only endpoints should return CacheCapabilities.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instanceName: string (required)
  ##               : The instance of the execution system to operate against. A server may
  ## support multiple instances of the execution system (with their own workers,
  ## storage, caches, etc.). The server MAY require use of this field to select
  ## between them in an implementation-defined fashion, otherwise it can be
  ## omitted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580085 = newJObject()
  var query_580086 = newJObject()
  add(query_580086, "key", newJString(key))
  add(query_580086, "prettyPrint", newJBool(prettyPrint))
  add(query_580086, "oauth_token", newJString(oauthToken))
  add(query_580086, "$.xgafv", newJString(Xgafv))
  add(query_580086, "alt", newJString(alt))
  add(query_580086, "uploadType", newJString(uploadType))
  add(query_580086, "quotaUser", newJString(quotaUser))
  add(path_580085, "instanceName", newJString(instanceName))
  add(query_580086, "callback", newJString(callback))
  add(query_580086, "fields", newJString(fields))
  add(query_580086, "access_token", newJString(accessToken))
  add(query_580086, "upload_protocol", newJString(uploadProtocol))
  result = call_580084.call(path_580085, query_580086, nil, nil, nil)

var remotebuildexecutionGetCapabilities* = Call_RemotebuildexecutionGetCapabilities_580068(
    name: "remotebuildexecutionGetCapabilities", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/capabilities",
    validator: validate_RemotebuildexecutionGetCapabilities_580069, base: "/",
    url: url_RemotebuildexecutionGetCapabilities_580070, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionOperationsWaitExecution_580087 = ref object of OpenApiRestCall_579373
proc url_RemotebuildexecutionOperationsWaitExecution_580089(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RemotebuildexecutionOperationsWaitExecution_580088(path: JsonNode;
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
  var valid_580090 = path.getOrDefault("name")
  valid_580090 = validateParameter(valid_580090, JString, required = true,
                                 default = nil)
  if valid_580090 != nil:
    section.add "name", valid_580090
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580091 = query.getOrDefault("key")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "key", valid_580091
  var valid_580092 = query.getOrDefault("prettyPrint")
  valid_580092 = validateParameter(valid_580092, JBool, required = false,
                                 default = newJBool(true))
  if valid_580092 != nil:
    section.add "prettyPrint", valid_580092
  var valid_580093 = query.getOrDefault("oauth_token")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "oauth_token", valid_580093
  var valid_580094 = query.getOrDefault("$.xgafv")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("1"))
  if valid_580094 != nil:
    section.add "$.xgafv", valid_580094
  var valid_580095 = query.getOrDefault("alt")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("json"))
  if valid_580095 != nil:
    section.add "alt", valid_580095
  var valid_580096 = query.getOrDefault("uploadType")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "uploadType", valid_580096
  var valid_580097 = query.getOrDefault("quotaUser")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "quotaUser", valid_580097
  var valid_580098 = query.getOrDefault("callback")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "callback", valid_580098
  var valid_580099 = query.getOrDefault("fields")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "fields", valid_580099
  var valid_580100 = query.getOrDefault("access_token")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "access_token", valid_580100
  var valid_580101 = query.getOrDefault("upload_protocol")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "upload_protocol", valid_580101
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

proc call*(call_580103: Call_RemotebuildexecutionOperationsWaitExecution_580087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Wait for an execution operation to complete. When the client initially
  ## makes the request, the server immediately responds with the current status
  ## of the execution. The server will leave the request stream open until the
  ## operation completes, and then respond with the completed operation. The
  ## server MAY choose to stream additional updates as execution progresses,
  ## such as to provide an update as to the state of the execution.
  ## 
  let valid = call_580103.validator(path, query, header, formData, body)
  let scheme = call_580103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580103.url(scheme.get, call_580103.host, call_580103.base,
                         call_580103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580103, url, valid)

proc call*(call_580104: Call_RemotebuildexecutionOperationsWaitExecution_580087;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## remotebuildexecutionOperationsWaitExecution
  ## Wait for an execution operation to complete. When the client initially
  ## makes the request, the server immediately responds with the current status
  ## of the execution. The server will leave the request stream open until the
  ## operation completes, and then respond with the completed operation. The
  ## server MAY choose to stream additional updates as execution progresses,
  ## such as to provide an update as to the state of the execution.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the Operation
  ## returned by Execute.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580105 = newJObject()
  var query_580106 = newJObject()
  var body_580107 = newJObject()
  add(query_580106, "key", newJString(key))
  add(query_580106, "prettyPrint", newJBool(prettyPrint))
  add(query_580106, "oauth_token", newJString(oauthToken))
  add(query_580106, "$.xgafv", newJString(Xgafv))
  add(query_580106, "alt", newJString(alt))
  add(query_580106, "uploadType", newJString(uploadType))
  add(query_580106, "quotaUser", newJString(quotaUser))
  add(path_580105, "name", newJString(name))
  if body != nil:
    body_580107 = body
  add(query_580106, "callback", newJString(callback))
  add(query_580106, "fields", newJString(fields))
  add(query_580106, "access_token", newJString(accessToken))
  add(query_580106, "upload_protocol", newJString(uploadProtocol))
  result = call_580104.call(path_580105, query_580106, nil, nil, body_580107)

var remotebuildexecutionOperationsWaitExecution* = Call_RemotebuildexecutionOperationsWaitExecution_580087(
    name: "remotebuildexecutionOperationsWaitExecution",
    meth: HttpMethod.HttpPost, host: "remotebuildexecution.googleapis.com",
    route: "/v2/{name}:waitExecution",
    validator: validate_RemotebuildexecutionOperationsWaitExecution_580088,
    base: "/", url: url_RemotebuildexecutionOperationsWaitExecution_580089,
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
