
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  Call_RemotebuildexecutionActionResultsUpdate_578912 = ref object of OpenApiRestCall_578348
proc url_RemotebuildexecutionActionResultsUpdate_578914(protocol: Scheme;
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

proc validate_RemotebuildexecutionActionResultsUpdate_578913(path: JsonNode;
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
  var valid_578915 = path.getOrDefault("hash")
  valid_578915 = validateParameter(valid_578915, JString, required = true,
                                 default = nil)
  if valid_578915 != nil:
    section.add "hash", valid_578915
  var valid_578916 = path.getOrDefault("sizeBytes")
  valid_578916 = validateParameter(valid_578916, JString, required = true,
                                 default = nil)
  if valid_578916 != nil:
    section.add "sizeBytes", valid_578916
  var valid_578917 = path.getOrDefault("instanceName")
  valid_578917 = validateParameter(valid_578917, JString, required = true,
                                 default = nil)
  if valid_578917 != nil:
    section.add "instanceName", valid_578917
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
  var valid_578918 = query.getOrDefault("key")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "key", valid_578918
  var valid_578919 = query.getOrDefault("prettyPrint")
  valid_578919 = validateParameter(valid_578919, JBool, required = false,
                                 default = newJBool(true))
  if valid_578919 != nil:
    section.add "prettyPrint", valid_578919
  var valid_578920 = query.getOrDefault("oauth_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "oauth_token", valid_578920
  var valid_578921 = query.getOrDefault("$.xgafv")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = newJString("1"))
  if valid_578921 != nil:
    section.add "$.xgafv", valid_578921
  var valid_578922 = query.getOrDefault("alt")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = newJString("json"))
  if valid_578922 != nil:
    section.add "alt", valid_578922
  var valid_578923 = query.getOrDefault("uploadType")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "uploadType", valid_578923
  var valid_578924 = query.getOrDefault("quotaUser")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "quotaUser", valid_578924
  var valid_578925 = query.getOrDefault("resultsCachePolicy.priority")
  valid_578925 = validateParameter(valid_578925, JInt, required = false, default = nil)
  if valid_578925 != nil:
    section.add "resultsCachePolicy.priority", valid_578925
  var valid_578926 = query.getOrDefault("callback")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "callback", valid_578926
  var valid_578927 = query.getOrDefault("fields")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "fields", valid_578927
  var valid_578928 = query.getOrDefault("access_token")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "access_token", valid_578928
  var valid_578929 = query.getOrDefault("upload_protocol")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "upload_protocol", valid_578929
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

proc call*(call_578931: Call_RemotebuildexecutionActionResultsUpdate_578912;
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
  let valid = call_578931.validator(path, query, header, formData, body)
  let scheme = call_578931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578931.url(scheme.get, call_578931.host, call_578931.base,
                         call_578931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578931, url, valid)

proc call*(call_578932: Call_RemotebuildexecutionActionResultsUpdate_578912;
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
  var path_578933 = newJObject()
  var query_578934 = newJObject()
  var body_578935 = newJObject()
  add(query_578934, "key", newJString(key))
  add(query_578934, "prettyPrint", newJBool(prettyPrint))
  add(query_578934, "oauth_token", newJString(oauthToken))
  add(query_578934, "$.xgafv", newJString(Xgafv))
  add(path_578933, "hash", newJString(hash))
  add(query_578934, "alt", newJString(alt))
  add(query_578934, "uploadType", newJString(uploadType))
  add(query_578934, "quotaUser", newJString(quotaUser))
  add(path_578933, "sizeBytes", newJString(sizeBytes))
  add(query_578934, "resultsCachePolicy.priority",
      newJInt(resultsCachePolicyPriority))
  add(path_578933, "instanceName", newJString(instanceName))
  if body != nil:
    body_578935 = body
  add(query_578934, "callback", newJString(callback))
  add(query_578934, "fields", newJString(fields))
  add(query_578934, "access_token", newJString(accessToken))
  add(query_578934, "upload_protocol", newJString(uploadProtocol))
  result = call_578932.call(path_578933, query_578934, nil, nil, body_578935)

var remotebuildexecutionActionResultsUpdate* = Call_RemotebuildexecutionActionResultsUpdate_578912(
    name: "remotebuildexecutionActionResultsUpdate", meth: HttpMethod.HttpPut,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actionResults/{hash}/{sizeBytes}",
    validator: validate_RemotebuildexecutionActionResultsUpdate_578913, base: "/",
    url: url_RemotebuildexecutionActionResultsUpdate_578914,
    schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionActionResultsGet_578619 = ref object of OpenApiRestCall_578348
proc url_RemotebuildexecutionActionResultsGet_578621(protocol: Scheme;
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

proc validate_RemotebuildexecutionActionResultsGet_578620(path: JsonNode;
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
  var valid_578747 = path.getOrDefault("hash")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "hash", valid_578747
  var valid_578748 = path.getOrDefault("sizeBytes")
  valid_578748 = validateParameter(valid_578748, JString, required = true,
                                 default = nil)
  if valid_578748 != nil:
    section.add "sizeBytes", valid_578748
  var valid_578749 = path.getOrDefault("instanceName")
  valid_578749 = validateParameter(valid_578749, JString, required = true,
                                 default = nil)
  if valid_578749 != nil:
    section.add "instanceName", valid_578749
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
  var valid_578750 = query.getOrDefault("key")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "key", valid_578750
  var valid_578764 = query.getOrDefault("prettyPrint")
  valid_578764 = validateParameter(valid_578764, JBool, required = false,
                                 default = newJBool(true))
  if valid_578764 != nil:
    section.add "prettyPrint", valid_578764
  var valid_578765 = query.getOrDefault("oauth_token")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "oauth_token", valid_578765
  var valid_578766 = query.getOrDefault("inlineOutputFiles")
  valid_578766 = validateParameter(valid_578766, JArray, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "inlineOutputFiles", valid_578766
  var valid_578767 = query.getOrDefault("inlineStdout")
  valid_578767 = validateParameter(valid_578767, JBool, required = false, default = nil)
  if valid_578767 != nil:
    section.add "inlineStdout", valid_578767
  var valid_578768 = query.getOrDefault("$.xgafv")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = newJString("1"))
  if valid_578768 != nil:
    section.add "$.xgafv", valid_578768
  var valid_578769 = query.getOrDefault("alt")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = newJString("json"))
  if valid_578769 != nil:
    section.add "alt", valid_578769
  var valid_578770 = query.getOrDefault("uploadType")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "uploadType", valid_578770
  var valid_578771 = query.getOrDefault("inlineStderr")
  valid_578771 = validateParameter(valid_578771, JBool, required = false, default = nil)
  if valid_578771 != nil:
    section.add "inlineStderr", valid_578771
  var valid_578772 = query.getOrDefault("quotaUser")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "quotaUser", valid_578772
  var valid_578773 = query.getOrDefault("callback")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "callback", valid_578773
  var valid_578774 = query.getOrDefault("fields")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = nil)
  if valid_578774 != nil:
    section.add "fields", valid_578774
  var valid_578775 = query.getOrDefault("access_token")
  valid_578775 = validateParameter(valid_578775, JString, required = false,
                                 default = nil)
  if valid_578775 != nil:
    section.add "access_token", valid_578775
  var valid_578776 = query.getOrDefault("upload_protocol")
  valid_578776 = validateParameter(valid_578776, JString, required = false,
                                 default = nil)
  if valid_578776 != nil:
    section.add "upload_protocol", valid_578776
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578799: Call_RemotebuildexecutionActionResultsGet_578619;
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
  let valid = call_578799.validator(path, query, header, formData, body)
  let scheme = call_578799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578799.url(scheme.get, call_578799.host, call_578799.base,
                         call_578799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578799, url, valid)

proc call*(call_578870: Call_RemotebuildexecutionActionResultsGet_578619;
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
  var path_578871 = newJObject()
  var query_578873 = newJObject()
  add(query_578873, "key", newJString(key))
  add(query_578873, "prettyPrint", newJBool(prettyPrint))
  add(query_578873, "oauth_token", newJString(oauthToken))
  if inlineOutputFiles != nil:
    query_578873.add "inlineOutputFiles", inlineOutputFiles
  add(query_578873, "inlineStdout", newJBool(inlineStdout))
  add(query_578873, "$.xgafv", newJString(Xgafv))
  add(path_578871, "hash", newJString(hash))
  add(query_578873, "alt", newJString(alt))
  add(query_578873, "uploadType", newJString(uploadType))
  add(query_578873, "inlineStderr", newJBool(inlineStderr))
  add(query_578873, "quotaUser", newJString(quotaUser))
  add(path_578871, "sizeBytes", newJString(sizeBytes))
  add(path_578871, "instanceName", newJString(instanceName))
  add(query_578873, "callback", newJString(callback))
  add(query_578873, "fields", newJString(fields))
  add(query_578873, "access_token", newJString(accessToken))
  add(query_578873, "upload_protocol", newJString(uploadProtocol))
  result = call_578870.call(path_578871, query_578873, nil, nil, nil)

var remotebuildexecutionActionResultsGet* = Call_RemotebuildexecutionActionResultsGet_578619(
    name: "remotebuildexecutionActionResultsGet", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actionResults/{hash}/{sizeBytes}",
    validator: validate_RemotebuildexecutionActionResultsGet_578620, base: "/",
    url: url_RemotebuildexecutionActionResultsGet_578621, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionActionsExecute_578936 = ref object of OpenApiRestCall_578348
proc url_RemotebuildexecutionActionsExecute_578938(protocol: Scheme; host: string;
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

proc validate_RemotebuildexecutionActionsExecute_578937(path: JsonNode;
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
  var valid_578939 = path.getOrDefault("instanceName")
  valid_578939 = validateParameter(valid_578939, JString, required = true,
                                 default = nil)
  if valid_578939 != nil:
    section.add "instanceName", valid_578939
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
  var valid_578940 = query.getOrDefault("key")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "key", valid_578940
  var valid_578941 = query.getOrDefault("prettyPrint")
  valid_578941 = validateParameter(valid_578941, JBool, required = false,
                                 default = newJBool(true))
  if valid_578941 != nil:
    section.add "prettyPrint", valid_578941
  var valid_578942 = query.getOrDefault("oauth_token")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "oauth_token", valid_578942
  var valid_578943 = query.getOrDefault("$.xgafv")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = newJString("1"))
  if valid_578943 != nil:
    section.add "$.xgafv", valid_578943
  var valid_578944 = query.getOrDefault("alt")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = newJString("json"))
  if valid_578944 != nil:
    section.add "alt", valid_578944
  var valid_578945 = query.getOrDefault("uploadType")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "uploadType", valid_578945
  var valid_578946 = query.getOrDefault("quotaUser")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "quotaUser", valid_578946
  var valid_578947 = query.getOrDefault("callback")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "callback", valid_578947
  var valid_578948 = query.getOrDefault("fields")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "fields", valid_578948
  var valid_578949 = query.getOrDefault("access_token")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "access_token", valid_578949
  var valid_578950 = query.getOrDefault("upload_protocol")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "upload_protocol", valid_578950
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

proc call*(call_578952: Call_RemotebuildexecutionActionsExecute_578936;
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
  let valid = call_578952.validator(path, query, header, formData, body)
  let scheme = call_578952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578952.url(scheme.get, call_578952.host, call_578952.base,
                         call_578952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578952, url, valid)

proc call*(call_578953: Call_RemotebuildexecutionActionsExecute_578936;
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
  var path_578954 = newJObject()
  var query_578955 = newJObject()
  var body_578956 = newJObject()
  add(query_578955, "key", newJString(key))
  add(query_578955, "prettyPrint", newJBool(prettyPrint))
  add(query_578955, "oauth_token", newJString(oauthToken))
  add(query_578955, "$.xgafv", newJString(Xgafv))
  add(query_578955, "alt", newJString(alt))
  add(query_578955, "uploadType", newJString(uploadType))
  add(query_578955, "quotaUser", newJString(quotaUser))
  add(path_578954, "instanceName", newJString(instanceName))
  if body != nil:
    body_578956 = body
  add(query_578955, "callback", newJString(callback))
  add(query_578955, "fields", newJString(fields))
  add(query_578955, "access_token", newJString(accessToken))
  add(query_578955, "upload_protocol", newJString(uploadProtocol))
  result = call_578953.call(path_578954, query_578955, nil, nil, body_578956)

var remotebuildexecutionActionsExecute* = Call_RemotebuildexecutionActionsExecute_578936(
    name: "remotebuildexecutionActionsExecute", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actions:execute",
    validator: validate_RemotebuildexecutionActionsExecute_578937, base: "/",
    url: url_RemotebuildexecutionActionsExecute_578938, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsGetTree_578957 = ref object of OpenApiRestCall_578348
proc url_RemotebuildexecutionBlobsGetTree_578959(protocol: Scheme; host: string;
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

proc validate_RemotebuildexecutionBlobsGetTree_578958(path: JsonNode;
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
  var valid_578960 = path.getOrDefault("hash")
  valid_578960 = validateParameter(valid_578960, JString, required = true,
                                 default = nil)
  if valid_578960 != nil:
    section.add "hash", valid_578960
  var valid_578961 = path.getOrDefault("sizeBytes")
  valid_578961 = validateParameter(valid_578961, JString, required = true,
                                 default = nil)
  if valid_578961 != nil:
    section.add "sizeBytes", valid_578961
  var valid_578962 = path.getOrDefault("instanceName")
  valid_578962 = validateParameter(valid_578962, JString, required = true,
                                 default = nil)
  if valid_578962 != nil:
    section.add "instanceName", valid_578962
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
  var valid_578963 = query.getOrDefault("key")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "key", valid_578963
  var valid_578964 = query.getOrDefault("prettyPrint")
  valid_578964 = validateParameter(valid_578964, JBool, required = false,
                                 default = newJBool(true))
  if valid_578964 != nil:
    section.add "prettyPrint", valid_578964
  var valid_578965 = query.getOrDefault("oauth_token")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "oauth_token", valid_578965
  var valid_578966 = query.getOrDefault("$.xgafv")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = newJString("1"))
  if valid_578966 != nil:
    section.add "$.xgafv", valid_578966
  var valid_578967 = query.getOrDefault("pageSize")
  valid_578967 = validateParameter(valid_578967, JInt, required = false, default = nil)
  if valid_578967 != nil:
    section.add "pageSize", valid_578967
  var valid_578968 = query.getOrDefault("alt")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = newJString("json"))
  if valid_578968 != nil:
    section.add "alt", valid_578968
  var valid_578969 = query.getOrDefault("uploadType")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "uploadType", valid_578969
  var valid_578970 = query.getOrDefault("quotaUser")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "quotaUser", valid_578970
  var valid_578971 = query.getOrDefault("pageToken")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "pageToken", valid_578971
  var valid_578972 = query.getOrDefault("callback")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "callback", valid_578972
  var valid_578973 = query.getOrDefault("fields")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "fields", valid_578973
  var valid_578974 = query.getOrDefault("access_token")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "access_token", valid_578974
  var valid_578975 = query.getOrDefault("upload_protocol")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "upload_protocol", valid_578975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578976: Call_RemotebuildexecutionBlobsGetTree_578957;
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
  let valid = call_578976.validator(path, query, header, formData, body)
  let scheme = call_578976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578976.url(scheme.get, call_578976.host, call_578976.base,
                         call_578976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578976, url, valid)

proc call*(call_578977: Call_RemotebuildexecutionBlobsGetTree_578957; hash: string;
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
  var path_578978 = newJObject()
  var query_578979 = newJObject()
  add(query_578979, "key", newJString(key))
  add(query_578979, "prettyPrint", newJBool(prettyPrint))
  add(query_578979, "oauth_token", newJString(oauthToken))
  add(query_578979, "$.xgafv", newJString(Xgafv))
  add(path_578978, "hash", newJString(hash))
  add(query_578979, "pageSize", newJInt(pageSize))
  add(query_578979, "alt", newJString(alt))
  add(query_578979, "uploadType", newJString(uploadType))
  add(query_578979, "quotaUser", newJString(quotaUser))
  add(path_578978, "sizeBytes", newJString(sizeBytes))
  add(query_578979, "pageToken", newJString(pageToken))
  add(path_578978, "instanceName", newJString(instanceName))
  add(query_578979, "callback", newJString(callback))
  add(query_578979, "fields", newJString(fields))
  add(query_578979, "access_token", newJString(accessToken))
  add(query_578979, "upload_protocol", newJString(uploadProtocol))
  result = call_578977.call(path_578978, query_578979, nil, nil, nil)

var remotebuildexecutionBlobsGetTree* = Call_RemotebuildexecutionBlobsGetTree_578957(
    name: "remotebuildexecutionBlobsGetTree", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs/{hash}/{sizeBytes}:getTree",
    validator: validate_RemotebuildexecutionBlobsGetTree_578958, base: "/",
    url: url_RemotebuildexecutionBlobsGetTree_578959, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsBatchRead_578980 = ref object of OpenApiRestCall_578348
proc url_RemotebuildexecutionBlobsBatchRead_578982(protocol: Scheme; host: string;
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

proc validate_RemotebuildexecutionBlobsBatchRead_578981(path: JsonNode;
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
  var valid_578983 = path.getOrDefault("instanceName")
  valid_578983 = validateParameter(valid_578983, JString, required = true,
                                 default = nil)
  if valid_578983 != nil:
    section.add "instanceName", valid_578983
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
  var valid_578984 = query.getOrDefault("key")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "key", valid_578984
  var valid_578985 = query.getOrDefault("prettyPrint")
  valid_578985 = validateParameter(valid_578985, JBool, required = false,
                                 default = newJBool(true))
  if valid_578985 != nil:
    section.add "prettyPrint", valid_578985
  var valid_578986 = query.getOrDefault("oauth_token")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "oauth_token", valid_578986
  var valid_578987 = query.getOrDefault("$.xgafv")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = newJString("1"))
  if valid_578987 != nil:
    section.add "$.xgafv", valid_578987
  var valid_578988 = query.getOrDefault("alt")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("json"))
  if valid_578988 != nil:
    section.add "alt", valid_578988
  var valid_578989 = query.getOrDefault("uploadType")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "uploadType", valid_578989
  var valid_578990 = query.getOrDefault("quotaUser")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "quotaUser", valid_578990
  var valid_578991 = query.getOrDefault("callback")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "callback", valid_578991
  var valid_578992 = query.getOrDefault("fields")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "fields", valid_578992
  var valid_578993 = query.getOrDefault("access_token")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "access_token", valid_578993
  var valid_578994 = query.getOrDefault("upload_protocol")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "upload_protocol", valid_578994
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

proc call*(call_578996: Call_RemotebuildexecutionBlobsBatchRead_578980;
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
  let valid = call_578996.validator(path, query, header, formData, body)
  let scheme = call_578996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578996.url(scheme.get, call_578996.host, call_578996.base,
                         call_578996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578996, url, valid)

proc call*(call_578997: Call_RemotebuildexecutionBlobsBatchRead_578980;
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
  var path_578998 = newJObject()
  var query_578999 = newJObject()
  var body_579000 = newJObject()
  add(query_578999, "key", newJString(key))
  add(query_578999, "prettyPrint", newJBool(prettyPrint))
  add(query_578999, "oauth_token", newJString(oauthToken))
  add(query_578999, "$.xgafv", newJString(Xgafv))
  add(query_578999, "alt", newJString(alt))
  add(query_578999, "uploadType", newJString(uploadType))
  add(query_578999, "quotaUser", newJString(quotaUser))
  add(path_578998, "instanceName", newJString(instanceName))
  if body != nil:
    body_579000 = body
  add(query_578999, "callback", newJString(callback))
  add(query_578999, "fields", newJString(fields))
  add(query_578999, "access_token", newJString(accessToken))
  add(query_578999, "upload_protocol", newJString(uploadProtocol))
  result = call_578997.call(path_578998, query_578999, nil, nil, body_579000)

var remotebuildexecutionBlobsBatchRead* = Call_RemotebuildexecutionBlobsBatchRead_578980(
    name: "remotebuildexecutionBlobsBatchRead", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:batchRead",
    validator: validate_RemotebuildexecutionBlobsBatchRead_578981, base: "/",
    url: url_RemotebuildexecutionBlobsBatchRead_578982, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsBatchUpdate_579001 = ref object of OpenApiRestCall_578348
proc url_RemotebuildexecutionBlobsBatchUpdate_579003(protocol: Scheme;
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

proc validate_RemotebuildexecutionBlobsBatchUpdate_579002(path: JsonNode;
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
  var valid_579004 = path.getOrDefault("instanceName")
  valid_579004 = validateParameter(valid_579004, JString, required = true,
                                 default = nil)
  if valid_579004 != nil:
    section.add "instanceName", valid_579004
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
  var valid_579005 = query.getOrDefault("key")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "key", valid_579005
  var valid_579006 = query.getOrDefault("prettyPrint")
  valid_579006 = validateParameter(valid_579006, JBool, required = false,
                                 default = newJBool(true))
  if valid_579006 != nil:
    section.add "prettyPrint", valid_579006
  var valid_579007 = query.getOrDefault("oauth_token")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "oauth_token", valid_579007
  var valid_579008 = query.getOrDefault("$.xgafv")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = newJString("1"))
  if valid_579008 != nil:
    section.add "$.xgafv", valid_579008
  var valid_579009 = query.getOrDefault("alt")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = newJString("json"))
  if valid_579009 != nil:
    section.add "alt", valid_579009
  var valid_579010 = query.getOrDefault("uploadType")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "uploadType", valid_579010
  var valid_579011 = query.getOrDefault("quotaUser")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "quotaUser", valid_579011
  var valid_579012 = query.getOrDefault("callback")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "callback", valid_579012
  var valid_579013 = query.getOrDefault("fields")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "fields", valid_579013
  var valid_579014 = query.getOrDefault("access_token")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "access_token", valid_579014
  var valid_579015 = query.getOrDefault("upload_protocol")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "upload_protocol", valid_579015
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

proc call*(call_579017: Call_RemotebuildexecutionBlobsBatchUpdate_579001;
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
  let valid = call_579017.validator(path, query, header, formData, body)
  let scheme = call_579017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579017.url(scheme.get, call_579017.host, call_579017.base,
                         call_579017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579017, url, valid)

proc call*(call_579018: Call_RemotebuildexecutionBlobsBatchUpdate_579001;
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
  var path_579019 = newJObject()
  var query_579020 = newJObject()
  var body_579021 = newJObject()
  add(query_579020, "key", newJString(key))
  add(query_579020, "prettyPrint", newJBool(prettyPrint))
  add(query_579020, "oauth_token", newJString(oauthToken))
  add(query_579020, "$.xgafv", newJString(Xgafv))
  add(query_579020, "alt", newJString(alt))
  add(query_579020, "uploadType", newJString(uploadType))
  add(query_579020, "quotaUser", newJString(quotaUser))
  add(path_579019, "instanceName", newJString(instanceName))
  if body != nil:
    body_579021 = body
  add(query_579020, "callback", newJString(callback))
  add(query_579020, "fields", newJString(fields))
  add(query_579020, "access_token", newJString(accessToken))
  add(query_579020, "upload_protocol", newJString(uploadProtocol))
  result = call_579018.call(path_579019, query_579020, nil, nil, body_579021)

var remotebuildexecutionBlobsBatchUpdate* = Call_RemotebuildexecutionBlobsBatchUpdate_579001(
    name: "remotebuildexecutionBlobsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:batchUpdate",
    validator: validate_RemotebuildexecutionBlobsBatchUpdate_579002, base: "/",
    url: url_RemotebuildexecutionBlobsBatchUpdate_579003, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsFindMissing_579022 = ref object of OpenApiRestCall_578348
proc url_RemotebuildexecutionBlobsFindMissing_579024(protocol: Scheme;
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

proc validate_RemotebuildexecutionBlobsFindMissing_579023(path: JsonNode;
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
  var valid_579025 = path.getOrDefault("instanceName")
  valid_579025 = validateParameter(valid_579025, JString, required = true,
                                 default = nil)
  if valid_579025 != nil:
    section.add "instanceName", valid_579025
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
  var valid_579026 = query.getOrDefault("key")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "key", valid_579026
  var valid_579027 = query.getOrDefault("prettyPrint")
  valid_579027 = validateParameter(valid_579027, JBool, required = false,
                                 default = newJBool(true))
  if valid_579027 != nil:
    section.add "prettyPrint", valid_579027
  var valid_579028 = query.getOrDefault("oauth_token")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "oauth_token", valid_579028
  var valid_579029 = query.getOrDefault("$.xgafv")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = newJString("1"))
  if valid_579029 != nil:
    section.add "$.xgafv", valid_579029
  var valid_579030 = query.getOrDefault("alt")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = newJString("json"))
  if valid_579030 != nil:
    section.add "alt", valid_579030
  var valid_579031 = query.getOrDefault("uploadType")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "uploadType", valid_579031
  var valid_579032 = query.getOrDefault("quotaUser")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "quotaUser", valid_579032
  var valid_579033 = query.getOrDefault("callback")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "callback", valid_579033
  var valid_579034 = query.getOrDefault("fields")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "fields", valid_579034
  var valid_579035 = query.getOrDefault("access_token")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "access_token", valid_579035
  var valid_579036 = query.getOrDefault("upload_protocol")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "upload_protocol", valid_579036
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

proc call*(call_579038: Call_RemotebuildexecutionBlobsFindMissing_579022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Determine if blobs are present in the CAS.
  ## 
  ## Clients can use this API before uploading blobs to determine which ones are
  ## already present in the CAS and do not need to be uploaded again.
  ## 
  ## There are no method-specific errors.
  ## 
  let valid = call_579038.validator(path, query, header, formData, body)
  let scheme = call_579038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579038.url(scheme.get, call_579038.host, call_579038.base,
                         call_579038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579038, url, valid)

proc call*(call_579039: Call_RemotebuildexecutionBlobsFindMissing_579022;
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
  var path_579040 = newJObject()
  var query_579041 = newJObject()
  var body_579042 = newJObject()
  add(query_579041, "key", newJString(key))
  add(query_579041, "prettyPrint", newJBool(prettyPrint))
  add(query_579041, "oauth_token", newJString(oauthToken))
  add(query_579041, "$.xgafv", newJString(Xgafv))
  add(query_579041, "alt", newJString(alt))
  add(query_579041, "uploadType", newJString(uploadType))
  add(query_579041, "quotaUser", newJString(quotaUser))
  add(path_579040, "instanceName", newJString(instanceName))
  if body != nil:
    body_579042 = body
  add(query_579041, "callback", newJString(callback))
  add(query_579041, "fields", newJString(fields))
  add(query_579041, "access_token", newJString(accessToken))
  add(query_579041, "upload_protocol", newJString(uploadProtocol))
  result = call_579039.call(path_579040, query_579041, nil, nil, body_579042)

var remotebuildexecutionBlobsFindMissing* = Call_RemotebuildexecutionBlobsFindMissing_579022(
    name: "remotebuildexecutionBlobsFindMissing", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:findMissing",
    validator: validate_RemotebuildexecutionBlobsFindMissing_579023, base: "/",
    url: url_RemotebuildexecutionBlobsFindMissing_579024, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionGetCapabilities_579043 = ref object of OpenApiRestCall_578348
proc url_RemotebuildexecutionGetCapabilities_579045(protocol: Scheme; host: string;
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

proc validate_RemotebuildexecutionGetCapabilities_579044(path: JsonNode;
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
  var valid_579046 = path.getOrDefault("instanceName")
  valid_579046 = validateParameter(valid_579046, JString, required = true,
                                 default = nil)
  if valid_579046 != nil:
    section.add "instanceName", valid_579046
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
  var valid_579047 = query.getOrDefault("key")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "key", valid_579047
  var valid_579048 = query.getOrDefault("prettyPrint")
  valid_579048 = validateParameter(valid_579048, JBool, required = false,
                                 default = newJBool(true))
  if valid_579048 != nil:
    section.add "prettyPrint", valid_579048
  var valid_579049 = query.getOrDefault("oauth_token")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "oauth_token", valid_579049
  var valid_579050 = query.getOrDefault("$.xgafv")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = newJString("1"))
  if valid_579050 != nil:
    section.add "$.xgafv", valid_579050
  var valid_579051 = query.getOrDefault("alt")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = newJString("json"))
  if valid_579051 != nil:
    section.add "alt", valid_579051
  var valid_579052 = query.getOrDefault("uploadType")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "uploadType", valid_579052
  var valid_579053 = query.getOrDefault("quotaUser")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "quotaUser", valid_579053
  var valid_579054 = query.getOrDefault("callback")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "callback", valid_579054
  var valid_579055 = query.getOrDefault("fields")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "fields", valid_579055
  var valid_579056 = query.getOrDefault("access_token")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "access_token", valid_579056
  var valid_579057 = query.getOrDefault("upload_protocol")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "upload_protocol", valid_579057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579058: Call_RemotebuildexecutionGetCapabilities_579043;
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
  let valid = call_579058.validator(path, query, header, formData, body)
  let scheme = call_579058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579058.url(scheme.get, call_579058.host, call_579058.base,
                         call_579058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579058, url, valid)

proc call*(call_579059: Call_RemotebuildexecutionGetCapabilities_579043;
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
  var path_579060 = newJObject()
  var query_579061 = newJObject()
  add(query_579061, "key", newJString(key))
  add(query_579061, "prettyPrint", newJBool(prettyPrint))
  add(query_579061, "oauth_token", newJString(oauthToken))
  add(query_579061, "$.xgafv", newJString(Xgafv))
  add(query_579061, "alt", newJString(alt))
  add(query_579061, "uploadType", newJString(uploadType))
  add(query_579061, "quotaUser", newJString(quotaUser))
  add(path_579060, "instanceName", newJString(instanceName))
  add(query_579061, "callback", newJString(callback))
  add(query_579061, "fields", newJString(fields))
  add(query_579061, "access_token", newJString(accessToken))
  add(query_579061, "upload_protocol", newJString(uploadProtocol))
  result = call_579059.call(path_579060, query_579061, nil, nil, nil)

var remotebuildexecutionGetCapabilities* = Call_RemotebuildexecutionGetCapabilities_579043(
    name: "remotebuildexecutionGetCapabilities", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/capabilities",
    validator: validate_RemotebuildexecutionGetCapabilities_579044, base: "/",
    url: url_RemotebuildexecutionGetCapabilities_579045, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionOperationsWaitExecution_579062 = ref object of OpenApiRestCall_578348
proc url_RemotebuildexecutionOperationsWaitExecution_579064(protocol: Scheme;
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

proc validate_RemotebuildexecutionOperationsWaitExecution_579063(path: JsonNode;
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
  var valid_579065 = path.getOrDefault("name")
  valid_579065 = validateParameter(valid_579065, JString, required = true,
                                 default = nil)
  if valid_579065 != nil:
    section.add "name", valid_579065
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
  var valid_579066 = query.getOrDefault("key")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "key", valid_579066
  var valid_579067 = query.getOrDefault("prettyPrint")
  valid_579067 = validateParameter(valid_579067, JBool, required = false,
                                 default = newJBool(true))
  if valid_579067 != nil:
    section.add "prettyPrint", valid_579067
  var valid_579068 = query.getOrDefault("oauth_token")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "oauth_token", valid_579068
  var valid_579069 = query.getOrDefault("$.xgafv")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = newJString("1"))
  if valid_579069 != nil:
    section.add "$.xgafv", valid_579069
  var valid_579070 = query.getOrDefault("alt")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("json"))
  if valid_579070 != nil:
    section.add "alt", valid_579070
  var valid_579071 = query.getOrDefault("uploadType")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "uploadType", valid_579071
  var valid_579072 = query.getOrDefault("quotaUser")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "quotaUser", valid_579072
  var valid_579073 = query.getOrDefault("callback")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "callback", valid_579073
  var valid_579074 = query.getOrDefault("fields")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "fields", valid_579074
  var valid_579075 = query.getOrDefault("access_token")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "access_token", valid_579075
  var valid_579076 = query.getOrDefault("upload_protocol")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "upload_protocol", valid_579076
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

proc call*(call_579078: Call_RemotebuildexecutionOperationsWaitExecution_579062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Wait for an execution operation to complete. When the client initially
  ## makes the request, the server immediately responds with the current status
  ## of the execution. The server will leave the request stream open until the
  ## operation completes, and then respond with the completed operation. The
  ## server MAY choose to stream additional updates as execution progresses,
  ## such as to provide an update as to the state of the execution.
  ## 
  let valid = call_579078.validator(path, query, header, formData, body)
  let scheme = call_579078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579078.url(scheme.get, call_579078.host, call_579078.base,
                         call_579078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579078, url, valid)

proc call*(call_579079: Call_RemotebuildexecutionOperationsWaitExecution_579062;
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
  var path_579080 = newJObject()
  var query_579081 = newJObject()
  var body_579082 = newJObject()
  add(query_579081, "key", newJString(key))
  add(query_579081, "prettyPrint", newJBool(prettyPrint))
  add(query_579081, "oauth_token", newJString(oauthToken))
  add(query_579081, "$.xgafv", newJString(Xgafv))
  add(query_579081, "alt", newJString(alt))
  add(query_579081, "uploadType", newJString(uploadType))
  add(query_579081, "quotaUser", newJString(quotaUser))
  add(path_579080, "name", newJString(name))
  if body != nil:
    body_579082 = body
  add(query_579081, "callback", newJString(callback))
  add(query_579081, "fields", newJString(fields))
  add(query_579081, "access_token", newJString(accessToken))
  add(query_579081, "upload_protocol", newJString(uploadProtocol))
  result = call_579079.call(path_579080, query_579081, nil, nil, body_579082)

var remotebuildexecutionOperationsWaitExecution* = Call_RemotebuildexecutionOperationsWaitExecution_579062(
    name: "remotebuildexecutionOperationsWaitExecution",
    meth: HttpMethod.HttpPost, host: "remotebuildexecution.googleapis.com",
    route: "/v2/{name}:waitExecution",
    validator: validate_RemotebuildexecutionOperationsWaitExecution_579063,
    base: "/", url: url_RemotebuildexecutionOperationsWaitExecution_579064,
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
