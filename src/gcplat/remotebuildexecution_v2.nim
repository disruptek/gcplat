
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "remotebuildexecution"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RemotebuildexecutionActionResultsUpdate_589012 = ref object of OpenApiRestCall_588450
proc url_RemotebuildexecutionActionResultsUpdate_589014(protocol: Scheme;
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

proc validate_RemotebuildexecutionActionResultsUpdate_589013(path: JsonNode;
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
  var valid_589015 = path.getOrDefault("sizeBytes")
  valid_589015 = validateParameter(valid_589015, JString, required = true,
                                 default = nil)
  if valid_589015 != nil:
    section.add "sizeBytes", valid_589015
  var valid_589016 = path.getOrDefault("instanceName")
  valid_589016 = validateParameter(valid_589016, JString, required = true,
                                 default = nil)
  if valid_589016 != nil:
    section.add "instanceName", valid_589016
  var valid_589017 = path.getOrDefault("hash")
  valid_589017 = validateParameter(valid_589017, JString, required = true,
                                 default = nil)
  if valid_589017 != nil:
    section.add "hash", valid_589017
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
  var valid_589018 = query.getOrDefault("upload_protocol")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "upload_protocol", valid_589018
  var valid_589019 = query.getOrDefault("fields")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "fields", valid_589019
  var valid_589020 = query.getOrDefault("quotaUser")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "quotaUser", valid_589020
  var valid_589021 = query.getOrDefault("alt")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = newJString("json"))
  if valid_589021 != nil:
    section.add "alt", valid_589021
  var valid_589022 = query.getOrDefault("oauth_token")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "oauth_token", valid_589022
  var valid_589023 = query.getOrDefault("callback")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "callback", valid_589023
  var valid_589024 = query.getOrDefault("access_token")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "access_token", valid_589024
  var valid_589025 = query.getOrDefault("uploadType")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "uploadType", valid_589025
  var valid_589026 = query.getOrDefault("resultsCachePolicy.priority")
  valid_589026 = validateParameter(valid_589026, JInt, required = false, default = nil)
  if valid_589026 != nil:
    section.add "resultsCachePolicy.priority", valid_589026
  var valid_589027 = query.getOrDefault("key")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "key", valid_589027
  var valid_589028 = query.getOrDefault("$.xgafv")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = newJString("1"))
  if valid_589028 != nil:
    section.add "$.xgafv", valid_589028
  var valid_589029 = query.getOrDefault("prettyPrint")
  valid_589029 = validateParameter(valid_589029, JBool, required = false,
                                 default = newJBool(true))
  if valid_589029 != nil:
    section.add "prettyPrint", valid_589029
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

proc call*(call_589031: Call_RemotebuildexecutionActionResultsUpdate_589012;
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
  let valid = call_589031.validator(path, query, header, formData, body)
  let scheme = call_589031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589031.url(scheme.get, call_589031.host, call_589031.base,
                         call_589031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589031, url, valid)

proc call*(call_589032: Call_RemotebuildexecutionActionResultsUpdate_589012;
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
  var path_589033 = newJObject()
  var query_589034 = newJObject()
  var body_589035 = newJObject()
  add(query_589034, "upload_protocol", newJString(uploadProtocol))
  add(query_589034, "fields", newJString(fields))
  add(query_589034, "quotaUser", newJString(quotaUser))
  add(path_589033, "sizeBytes", newJString(sizeBytes))
  add(query_589034, "alt", newJString(alt))
  add(path_589033, "instanceName", newJString(instanceName))
  add(query_589034, "oauth_token", newJString(oauthToken))
  add(query_589034, "callback", newJString(callback))
  add(query_589034, "access_token", newJString(accessToken))
  add(query_589034, "uploadType", newJString(uploadType))
  add(path_589033, "hash", newJString(hash))
  add(query_589034, "resultsCachePolicy.priority",
      newJInt(resultsCachePolicyPriority))
  add(query_589034, "key", newJString(key))
  add(query_589034, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589035 = body
  add(query_589034, "prettyPrint", newJBool(prettyPrint))
  result = call_589032.call(path_589033, query_589034, nil, nil, body_589035)

var remotebuildexecutionActionResultsUpdate* = Call_RemotebuildexecutionActionResultsUpdate_589012(
    name: "remotebuildexecutionActionResultsUpdate", meth: HttpMethod.HttpPut,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actionResults/{hash}/{sizeBytes}",
    validator: validate_RemotebuildexecutionActionResultsUpdate_589013, base: "/",
    url: url_RemotebuildexecutionActionResultsUpdate_589014,
    schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionActionResultsGet_588719 = ref object of OpenApiRestCall_588450
proc url_RemotebuildexecutionActionResultsGet_588721(protocol: Scheme;
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

proc validate_RemotebuildexecutionActionResultsGet_588720(path: JsonNode;
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
  var valid_588847 = path.getOrDefault("sizeBytes")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "sizeBytes", valid_588847
  var valid_588848 = path.getOrDefault("instanceName")
  valid_588848 = validateParameter(valid_588848, JString, required = true,
                                 default = nil)
  if valid_588848 != nil:
    section.add "instanceName", valid_588848
  var valid_588849 = path.getOrDefault("hash")
  valid_588849 = validateParameter(valid_588849, JString, required = true,
                                 default = nil)
  if valid_588849 != nil:
    section.add "hash", valid_588849
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
  var valid_588850 = query.getOrDefault("inlineOutputFiles")
  valid_588850 = validateParameter(valid_588850, JArray, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "inlineOutputFiles", valid_588850
  var valid_588851 = query.getOrDefault("upload_protocol")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "upload_protocol", valid_588851
  var valid_588852 = query.getOrDefault("fields")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "fields", valid_588852
  var valid_588853 = query.getOrDefault("quotaUser")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "quotaUser", valid_588853
  var valid_588867 = query.getOrDefault("alt")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = newJString("json"))
  if valid_588867 != nil:
    section.add "alt", valid_588867
  var valid_588868 = query.getOrDefault("inlineStderr")
  valid_588868 = validateParameter(valid_588868, JBool, required = false, default = nil)
  if valid_588868 != nil:
    section.add "inlineStderr", valid_588868
  var valid_588869 = query.getOrDefault("oauth_token")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "oauth_token", valid_588869
  var valid_588870 = query.getOrDefault("callback")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = nil)
  if valid_588870 != nil:
    section.add "callback", valid_588870
  var valid_588871 = query.getOrDefault("access_token")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = nil)
  if valid_588871 != nil:
    section.add "access_token", valid_588871
  var valid_588872 = query.getOrDefault("uploadType")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "uploadType", valid_588872
  var valid_588873 = query.getOrDefault("key")
  valid_588873 = validateParameter(valid_588873, JString, required = false,
                                 default = nil)
  if valid_588873 != nil:
    section.add "key", valid_588873
  var valid_588874 = query.getOrDefault("$.xgafv")
  valid_588874 = validateParameter(valid_588874, JString, required = false,
                                 default = newJString("1"))
  if valid_588874 != nil:
    section.add "$.xgafv", valid_588874
  var valid_588875 = query.getOrDefault("prettyPrint")
  valid_588875 = validateParameter(valid_588875, JBool, required = false,
                                 default = newJBool(true))
  if valid_588875 != nil:
    section.add "prettyPrint", valid_588875
  var valid_588876 = query.getOrDefault("inlineStdout")
  valid_588876 = validateParameter(valid_588876, JBool, required = false, default = nil)
  if valid_588876 != nil:
    section.add "inlineStdout", valid_588876
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588899: Call_RemotebuildexecutionActionResultsGet_588719;
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
  let valid = call_588899.validator(path, query, header, formData, body)
  let scheme = call_588899.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588899.url(scheme.get, call_588899.host, call_588899.base,
                         call_588899.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588899, url, valid)

proc call*(call_588970: Call_RemotebuildexecutionActionResultsGet_588719;
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
  var path_588971 = newJObject()
  var query_588973 = newJObject()
  if inlineOutputFiles != nil:
    query_588973.add "inlineOutputFiles", inlineOutputFiles
  add(query_588973, "upload_protocol", newJString(uploadProtocol))
  add(query_588973, "fields", newJString(fields))
  add(query_588973, "quotaUser", newJString(quotaUser))
  add(path_588971, "sizeBytes", newJString(sizeBytes))
  add(query_588973, "alt", newJString(alt))
  add(query_588973, "inlineStderr", newJBool(inlineStderr))
  add(path_588971, "instanceName", newJString(instanceName))
  add(query_588973, "oauth_token", newJString(oauthToken))
  add(query_588973, "callback", newJString(callback))
  add(query_588973, "access_token", newJString(accessToken))
  add(query_588973, "uploadType", newJString(uploadType))
  add(path_588971, "hash", newJString(hash))
  add(query_588973, "key", newJString(key))
  add(query_588973, "$.xgafv", newJString(Xgafv))
  add(query_588973, "prettyPrint", newJBool(prettyPrint))
  add(query_588973, "inlineStdout", newJBool(inlineStdout))
  result = call_588970.call(path_588971, query_588973, nil, nil, nil)

var remotebuildexecutionActionResultsGet* = Call_RemotebuildexecutionActionResultsGet_588719(
    name: "remotebuildexecutionActionResultsGet", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actionResults/{hash}/{sizeBytes}",
    validator: validate_RemotebuildexecutionActionResultsGet_588720, base: "/",
    url: url_RemotebuildexecutionActionResultsGet_588721, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionActionsExecute_589036 = ref object of OpenApiRestCall_588450
proc url_RemotebuildexecutionActionsExecute_589038(protocol: Scheme; host: string;
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

proc validate_RemotebuildexecutionActionsExecute_589037(path: JsonNode;
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
  var valid_589039 = path.getOrDefault("instanceName")
  valid_589039 = validateParameter(valid_589039, JString, required = true,
                                 default = nil)
  if valid_589039 != nil:
    section.add "instanceName", valid_589039
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
  var valid_589040 = query.getOrDefault("upload_protocol")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "upload_protocol", valid_589040
  var valid_589041 = query.getOrDefault("fields")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "fields", valid_589041
  var valid_589042 = query.getOrDefault("quotaUser")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "quotaUser", valid_589042
  var valid_589043 = query.getOrDefault("alt")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = newJString("json"))
  if valid_589043 != nil:
    section.add "alt", valid_589043
  var valid_589044 = query.getOrDefault("oauth_token")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "oauth_token", valid_589044
  var valid_589045 = query.getOrDefault("callback")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "callback", valid_589045
  var valid_589046 = query.getOrDefault("access_token")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "access_token", valid_589046
  var valid_589047 = query.getOrDefault("uploadType")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "uploadType", valid_589047
  var valid_589048 = query.getOrDefault("key")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "key", valid_589048
  var valid_589049 = query.getOrDefault("$.xgafv")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = newJString("1"))
  if valid_589049 != nil:
    section.add "$.xgafv", valid_589049
  var valid_589050 = query.getOrDefault("prettyPrint")
  valid_589050 = validateParameter(valid_589050, JBool, required = false,
                                 default = newJBool(true))
  if valid_589050 != nil:
    section.add "prettyPrint", valid_589050
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

proc call*(call_589052: Call_RemotebuildexecutionActionsExecute_589036;
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
  let valid = call_589052.validator(path, query, header, formData, body)
  let scheme = call_589052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589052.url(scheme.get, call_589052.host, call_589052.base,
                         call_589052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589052, url, valid)

proc call*(call_589053: Call_RemotebuildexecutionActionsExecute_589036;
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
  var path_589054 = newJObject()
  var query_589055 = newJObject()
  var body_589056 = newJObject()
  add(query_589055, "upload_protocol", newJString(uploadProtocol))
  add(query_589055, "fields", newJString(fields))
  add(query_589055, "quotaUser", newJString(quotaUser))
  add(query_589055, "alt", newJString(alt))
  add(path_589054, "instanceName", newJString(instanceName))
  add(query_589055, "oauth_token", newJString(oauthToken))
  add(query_589055, "callback", newJString(callback))
  add(query_589055, "access_token", newJString(accessToken))
  add(query_589055, "uploadType", newJString(uploadType))
  add(query_589055, "key", newJString(key))
  add(query_589055, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589056 = body
  add(query_589055, "prettyPrint", newJBool(prettyPrint))
  result = call_589053.call(path_589054, query_589055, nil, nil, body_589056)

var remotebuildexecutionActionsExecute* = Call_RemotebuildexecutionActionsExecute_589036(
    name: "remotebuildexecutionActionsExecute", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/actions:execute",
    validator: validate_RemotebuildexecutionActionsExecute_589037, base: "/",
    url: url_RemotebuildexecutionActionsExecute_589038, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsGetTree_589057 = ref object of OpenApiRestCall_588450
proc url_RemotebuildexecutionBlobsGetTree_589059(protocol: Scheme; host: string;
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

proc validate_RemotebuildexecutionBlobsGetTree_589058(path: JsonNode;
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
  var valid_589060 = path.getOrDefault("sizeBytes")
  valid_589060 = validateParameter(valid_589060, JString, required = true,
                                 default = nil)
  if valid_589060 != nil:
    section.add "sizeBytes", valid_589060
  var valid_589061 = path.getOrDefault("instanceName")
  valid_589061 = validateParameter(valid_589061, JString, required = true,
                                 default = nil)
  if valid_589061 != nil:
    section.add "instanceName", valid_589061
  var valid_589062 = path.getOrDefault("hash")
  valid_589062 = validateParameter(valid_589062, JString, required = true,
                                 default = nil)
  if valid_589062 != nil:
    section.add "hash", valid_589062
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
  var valid_589065 = query.getOrDefault("pageToken")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "pageToken", valid_589065
  var valid_589066 = query.getOrDefault("quotaUser")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "quotaUser", valid_589066
  var valid_589067 = query.getOrDefault("alt")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = newJString("json"))
  if valid_589067 != nil:
    section.add "alt", valid_589067
  var valid_589068 = query.getOrDefault("oauth_token")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "oauth_token", valid_589068
  var valid_589069 = query.getOrDefault("callback")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "callback", valid_589069
  var valid_589070 = query.getOrDefault("access_token")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "access_token", valid_589070
  var valid_589071 = query.getOrDefault("uploadType")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "uploadType", valid_589071
  var valid_589072 = query.getOrDefault("key")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "key", valid_589072
  var valid_589073 = query.getOrDefault("$.xgafv")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = newJString("1"))
  if valid_589073 != nil:
    section.add "$.xgafv", valid_589073
  var valid_589074 = query.getOrDefault("pageSize")
  valid_589074 = validateParameter(valid_589074, JInt, required = false, default = nil)
  if valid_589074 != nil:
    section.add "pageSize", valid_589074
  var valid_589075 = query.getOrDefault("prettyPrint")
  valid_589075 = validateParameter(valid_589075, JBool, required = false,
                                 default = newJBool(true))
  if valid_589075 != nil:
    section.add "prettyPrint", valid_589075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589076: Call_RemotebuildexecutionBlobsGetTree_589057;
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
  let valid = call_589076.validator(path, query, header, formData, body)
  let scheme = call_589076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589076.url(scheme.get, call_589076.host, call_589076.base,
                         call_589076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589076, url, valid)

proc call*(call_589077: Call_RemotebuildexecutionBlobsGetTree_589057;
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
  var path_589078 = newJObject()
  var query_589079 = newJObject()
  add(query_589079, "upload_protocol", newJString(uploadProtocol))
  add(query_589079, "fields", newJString(fields))
  add(query_589079, "pageToken", newJString(pageToken))
  add(query_589079, "quotaUser", newJString(quotaUser))
  add(path_589078, "sizeBytes", newJString(sizeBytes))
  add(query_589079, "alt", newJString(alt))
  add(path_589078, "instanceName", newJString(instanceName))
  add(query_589079, "oauth_token", newJString(oauthToken))
  add(query_589079, "callback", newJString(callback))
  add(query_589079, "access_token", newJString(accessToken))
  add(query_589079, "uploadType", newJString(uploadType))
  add(path_589078, "hash", newJString(hash))
  add(query_589079, "key", newJString(key))
  add(query_589079, "$.xgafv", newJString(Xgafv))
  add(query_589079, "pageSize", newJInt(pageSize))
  add(query_589079, "prettyPrint", newJBool(prettyPrint))
  result = call_589077.call(path_589078, query_589079, nil, nil, nil)

var remotebuildexecutionBlobsGetTree* = Call_RemotebuildexecutionBlobsGetTree_589057(
    name: "remotebuildexecutionBlobsGetTree", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs/{hash}/{sizeBytes}:getTree",
    validator: validate_RemotebuildexecutionBlobsGetTree_589058, base: "/",
    url: url_RemotebuildexecutionBlobsGetTree_589059, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsBatchRead_589080 = ref object of OpenApiRestCall_588450
proc url_RemotebuildexecutionBlobsBatchRead_589082(protocol: Scheme; host: string;
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

proc validate_RemotebuildexecutionBlobsBatchRead_589081(path: JsonNode;
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
  var valid_589083 = path.getOrDefault("instanceName")
  valid_589083 = validateParameter(valid_589083, JString, required = true,
                                 default = nil)
  if valid_589083 != nil:
    section.add "instanceName", valid_589083
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
  var valid_589084 = query.getOrDefault("upload_protocol")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "upload_protocol", valid_589084
  var valid_589085 = query.getOrDefault("fields")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "fields", valid_589085
  var valid_589086 = query.getOrDefault("quotaUser")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "quotaUser", valid_589086
  var valid_589087 = query.getOrDefault("alt")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = newJString("json"))
  if valid_589087 != nil:
    section.add "alt", valid_589087
  var valid_589088 = query.getOrDefault("oauth_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "oauth_token", valid_589088
  var valid_589089 = query.getOrDefault("callback")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "callback", valid_589089
  var valid_589090 = query.getOrDefault("access_token")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "access_token", valid_589090
  var valid_589091 = query.getOrDefault("uploadType")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "uploadType", valid_589091
  var valid_589092 = query.getOrDefault("key")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "key", valid_589092
  var valid_589093 = query.getOrDefault("$.xgafv")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = newJString("1"))
  if valid_589093 != nil:
    section.add "$.xgafv", valid_589093
  var valid_589094 = query.getOrDefault("prettyPrint")
  valid_589094 = validateParameter(valid_589094, JBool, required = false,
                                 default = newJBool(true))
  if valid_589094 != nil:
    section.add "prettyPrint", valid_589094
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

proc call*(call_589096: Call_RemotebuildexecutionBlobsBatchRead_589080;
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
  let valid = call_589096.validator(path, query, header, formData, body)
  let scheme = call_589096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589096.url(scheme.get, call_589096.host, call_589096.base,
                         call_589096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589096, url, valid)

proc call*(call_589097: Call_RemotebuildexecutionBlobsBatchRead_589080;
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
  var path_589098 = newJObject()
  var query_589099 = newJObject()
  var body_589100 = newJObject()
  add(query_589099, "upload_protocol", newJString(uploadProtocol))
  add(query_589099, "fields", newJString(fields))
  add(query_589099, "quotaUser", newJString(quotaUser))
  add(query_589099, "alt", newJString(alt))
  add(path_589098, "instanceName", newJString(instanceName))
  add(query_589099, "oauth_token", newJString(oauthToken))
  add(query_589099, "callback", newJString(callback))
  add(query_589099, "access_token", newJString(accessToken))
  add(query_589099, "uploadType", newJString(uploadType))
  add(query_589099, "key", newJString(key))
  add(query_589099, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589100 = body
  add(query_589099, "prettyPrint", newJBool(prettyPrint))
  result = call_589097.call(path_589098, query_589099, nil, nil, body_589100)

var remotebuildexecutionBlobsBatchRead* = Call_RemotebuildexecutionBlobsBatchRead_589080(
    name: "remotebuildexecutionBlobsBatchRead", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:batchRead",
    validator: validate_RemotebuildexecutionBlobsBatchRead_589081, base: "/",
    url: url_RemotebuildexecutionBlobsBatchRead_589082, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsBatchUpdate_589101 = ref object of OpenApiRestCall_588450
proc url_RemotebuildexecutionBlobsBatchUpdate_589103(protocol: Scheme;
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

proc validate_RemotebuildexecutionBlobsBatchUpdate_589102(path: JsonNode;
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
  var valid_589104 = path.getOrDefault("instanceName")
  valid_589104 = validateParameter(valid_589104, JString, required = true,
                                 default = nil)
  if valid_589104 != nil:
    section.add "instanceName", valid_589104
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
  var valid_589105 = query.getOrDefault("upload_protocol")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "upload_protocol", valid_589105
  var valid_589106 = query.getOrDefault("fields")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "fields", valid_589106
  var valid_589107 = query.getOrDefault("quotaUser")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "quotaUser", valid_589107
  var valid_589108 = query.getOrDefault("alt")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = newJString("json"))
  if valid_589108 != nil:
    section.add "alt", valid_589108
  var valid_589109 = query.getOrDefault("oauth_token")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "oauth_token", valid_589109
  var valid_589110 = query.getOrDefault("callback")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "callback", valid_589110
  var valid_589111 = query.getOrDefault("access_token")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "access_token", valid_589111
  var valid_589112 = query.getOrDefault("uploadType")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "uploadType", valid_589112
  var valid_589113 = query.getOrDefault("key")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "key", valid_589113
  var valid_589114 = query.getOrDefault("$.xgafv")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = newJString("1"))
  if valid_589114 != nil:
    section.add "$.xgafv", valid_589114
  var valid_589115 = query.getOrDefault("prettyPrint")
  valid_589115 = validateParameter(valid_589115, JBool, required = false,
                                 default = newJBool(true))
  if valid_589115 != nil:
    section.add "prettyPrint", valid_589115
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

proc call*(call_589117: Call_RemotebuildexecutionBlobsBatchUpdate_589101;
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
  let valid = call_589117.validator(path, query, header, formData, body)
  let scheme = call_589117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589117.url(scheme.get, call_589117.host, call_589117.base,
                         call_589117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589117, url, valid)

proc call*(call_589118: Call_RemotebuildexecutionBlobsBatchUpdate_589101;
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
  var path_589119 = newJObject()
  var query_589120 = newJObject()
  var body_589121 = newJObject()
  add(query_589120, "upload_protocol", newJString(uploadProtocol))
  add(query_589120, "fields", newJString(fields))
  add(query_589120, "quotaUser", newJString(quotaUser))
  add(query_589120, "alt", newJString(alt))
  add(path_589119, "instanceName", newJString(instanceName))
  add(query_589120, "oauth_token", newJString(oauthToken))
  add(query_589120, "callback", newJString(callback))
  add(query_589120, "access_token", newJString(accessToken))
  add(query_589120, "uploadType", newJString(uploadType))
  add(query_589120, "key", newJString(key))
  add(query_589120, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589121 = body
  add(query_589120, "prettyPrint", newJBool(prettyPrint))
  result = call_589118.call(path_589119, query_589120, nil, nil, body_589121)

var remotebuildexecutionBlobsBatchUpdate* = Call_RemotebuildexecutionBlobsBatchUpdate_589101(
    name: "remotebuildexecutionBlobsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:batchUpdate",
    validator: validate_RemotebuildexecutionBlobsBatchUpdate_589102, base: "/",
    url: url_RemotebuildexecutionBlobsBatchUpdate_589103, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionBlobsFindMissing_589122 = ref object of OpenApiRestCall_588450
proc url_RemotebuildexecutionBlobsFindMissing_589124(protocol: Scheme;
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

proc validate_RemotebuildexecutionBlobsFindMissing_589123(path: JsonNode;
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
  var valid_589125 = path.getOrDefault("instanceName")
  valid_589125 = validateParameter(valid_589125, JString, required = true,
                                 default = nil)
  if valid_589125 != nil:
    section.add "instanceName", valid_589125
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
  var valid_589126 = query.getOrDefault("upload_protocol")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "upload_protocol", valid_589126
  var valid_589127 = query.getOrDefault("fields")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "fields", valid_589127
  var valid_589128 = query.getOrDefault("quotaUser")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "quotaUser", valid_589128
  var valid_589129 = query.getOrDefault("alt")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = newJString("json"))
  if valid_589129 != nil:
    section.add "alt", valid_589129
  var valid_589130 = query.getOrDefault("oauth_token")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "oauth_token", valid_589130
  var valid_589131 = query.getOrDefault("callback")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "callback", valid_589131
  var valid_589132 = query.getOrDefault("access_token")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "access_token", valid_589132
  var valid_589133 = query.getOrDefault("uploadType")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "uploadType", valid_589133
  var valid_589134 = query.getOrDefault("key")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "key", valid_589134
  var valid_589135 = query.getOrDefault("$.xgafv")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = newJString("1"))
  if valid_589135 != nil:
    section.add "$.xgafv", valid_589135
  var valid_589136 = query.getOrDefault("prettyPrint")
  valid_589136 = validateParameter(valid_589136, JBool, required = false,
                                 default = newJBool(true))
  if valid_589136 != nil:
    section.add "prettyPrint", valid_589136
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

proc call*(call_589138: Call_RemotebuildexecutionBlobsFindMissing_589122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Determine if blobs are present in the CAS.
  ## 
  ## Clients can use this API before uploading blobs to determine which ones are
  ## already present in the CAS and do not need to be uploaded again.
  ## 
  ## There are no method-specific errors.
  ## 
  let valid = call_589138.validator(path, query, header, formData, body)
  let scheme = call_589138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589138.url(scheme.get, call_589138.host, call_589138.base,
                         call_589138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589138, url, valid)

proc call*(call_589139: Call_RemotebuildexecutionBlobsFindMissing_589122;
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
  var path_589140 = newJObject()
  var query_589141 = newJObject()
  var body_589142 = newJObject()
  add(query_589141, "upload_protocol", newJString(uploadProtocol))
  add(query_589141, "fields", newJString(fields))
  add(query_589141, "quotaUser", newJString(quotaUser))
  add(query_589141, "alt", newJString(alt))
  add(path_589140, "instanceName", newJString(instanceName))
  add(query_589141, "oauth_token", newJString(oauthToken))
  add(query_589141, "callback", newJString(callback))
  add(query_589141, "access_token", newJString(accessToken))
  add(query_589141, "uploadType", newJString(uploadType))
  add(query_589141, "key", newJString(key))
  add(query_589141, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589142 = body
  add(query_589141, "prettyPrint", newJBool(prettyPrint))
  result = call_589139.call(path_589140, query_589141, nil, nil, body_589142)

var remotebuildexecutionBlobsFindMissing* = Call_RemotebuildexecutionBlobsFindMissing_589122(
    name: "remotebuildexecutionBlobsFindMissing", meth: HttpMethod.HttpPost,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/blobs:findMissing",
    validator: validate_RemotebuildexecutionBlobsFindMissing_589123, base: "/",
    url: url_RemotebuildexecutionBlobsFindMissing_589124, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionGetCapabilities_589143 = ref object of OpenApiRestCall_588450
proc url_RemotebuildexecutionGetCapabilities_589145(protocol: Scheme; host: string;
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

proc validate_RemotebuildexecutionGetCapabilities_589144(path: JsonNode;
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
  var valid_589146 = path.getOrDefault("instanceName")
  valid_589146 = validateParameter(valid_589146, JString, required = true,
                                 default = nil)
  if valid_589146 != nil:
    section.add "instanceName", valid_589146
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
  var valid_589147 = query.getOrDefault("upload_protocol")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "upload_protocol", valid_589147
  var valid_589148 = query.getOrDefault("fields")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "fields", valid_589148
  var valid_589149 = query.getOrDefault("quotaUser")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "quotaUser", valid_589149
  var valid_589150 = query.getOrDefault("alt")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = newJString("json"))
  if valid_589150 != nil:
    section.add "alt", valid_589150
  var valid_589151 = query.getOrDefault("oauth_token")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "oauth_token", valid_589151
  var valid_589152 = query.getOrDefault("callback")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "callback", valid_589152
  var valid_589153 = query.getOrDefault("access_token")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "access_token", valid_589153
  var valid_589154 = query.getOrDefault("uploadType")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "uploadType", valid_589154
  var valid_589155 = query.getOrDefault("key")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "key", valid_589155
  var valid_589156 = query.getOrDefault("$.xgafv")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = newJString("1"))
  if valid_589156 != nil:
    section.add "$.xgafv", valid_589156
  var valid_589157 = query.getOrDefault("prettyPrint")
  valid_589157 = validateParameter(valid_589157, JBool, required = false,
                                 default = newJBool(true))
  if valid_589157 != nil:
    section.add "prettyPrint", valid_589157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589158: Call_RemotebuildexecutionGetCapabilities_589143;
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
  let valid = call_589158.validator(path, query, header, formData, body)
  let scheme = call_589158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589158.url(scheme.get, call_589158.host, call_589158.base,
                         call_589158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589158, url, valid)

proc call*(call_589159: Call_RemotebuildexecutionGetCapabilities_589143;
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
  var path_589160 = newJObject()
  var query_589161 = newJObject()
  add(query_589161, "upload_protocol", newJString(uploadProtocol))
  add(query_589161, "fields", newJString(fields))
  add(query_589161, "quotaUser", newJString(quotaUser))
  add(query_589161, "alt", newJString(alt))
  add(path_589160, "instanceName", newJString(instanceName))
  add(query_589161, "oauth_token", newJString(oauthToken))
  add(query_589161, "callback", newJString(callback))
  add(query_589161, "access_token", newJString(accessToken))
  add(query_589161, "uploadType", newJString(uploadType))
  add(query_589161, "key", newJString(key))
  add(query_589161, "$.xgafv", newJString(Xgafv))
  add(query_589161, "prettyPrint", newJBool(prettyPrint))
  result = call_589159.call(path_589160, query_589161, nil, nil, nil)

var remotebuildexecutionGetCapabilities* = Call_RemotebuildexecutionGetCapabilities_589143(
    name: "remotebuildexecutionGetCapabilities", meth: HttpMethod.HttpGet,
    host: "remotebuildexecution.googleapis.com",
    route: "/v2/{instanceName}/capabilities",
    validator: validate_RemotebuildexecutionGetCapabilities_589144, base: "/",
    url: url_RemotebuildexecutionGetCapabilities_589145, schemes: {Scheme.Https})
type
  Call_RemotebuildexecutionOperationsWaitExecution_589162 = ref object of OpenApiRestCall_588450
proc url_RemotebuildexecutionOperationsWaitExecution_589164(protocol: Scheme;
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

proc validate_RemotebuildexecutionOperationsWaitExecution_589163(path: JsonNode;
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
  var valid_589165 = path.getOrDefault("name")
  valid_589165 = validateParameter(valid_589165, JString, required = true,
                                 default = nil)
  if valid_589165 != nil:
    section.add "name", valid_589165
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
  var valid_589166 = query.getOrDefault("upload_protocol")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "upload_protocol", valid_589166
  var valid_589167 = query.getOrDefault("fields")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "fields", valid_589167
  var valid_589168 = query.getOrDefault("quotaUser")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "quotaUser", valid_589168
  var valid_589169 = query.getOrDefault("alt")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = newJString("json"))
  if valid_589169 != nil:
    section.add "alt", valid_589169
  var valid_589170 = query.getOrDefault("oauth_token")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "oauth_token", valid_589170
  var valid_589171 = query.getOrDefault("callback")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "callback", valid_589171
  var valid_589172 = query.getOrDefault("access_token")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "access_token", valid_589172
  var valid_589173 = query.getOrDefault("uploadType")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "uploadType", valid_589173
  var valid_589174 = query.getOrDefault("key")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "key", valid_589174
  var valid_589175 = query.getOrDefault("$.xgafv")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = newJString("1"))
  if valid_589175 != nil:
    section.add "$.xgafv", valid_589175
  var valid_589176 = query.getOrDefault("prettyPrint")
  valid_589176 = validateParameter(valid_589176, JBool, required = false,
                                 default = newJBool(true))
  if valid_589176 != nil:
    section.add "prettyPrint", valid_589176
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

proc call*(call_589178: Call_RemotebuildexecutionOperationsWaitExecution_589162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Wait for an execution operation to complete. When the client initially
  ## makes the request, the server immediately responds with the current status
  ## of the execution. The server will leave the request stream open until the
  ## operation completes, and then respond with the completed operation. The
  ## server MAY choose to stream additional updates as execution progresses,
  ## such as to provide an update as to the state of the execution.
  ## 
  let valid = call_589178.validator(path, query, header, formData, body)
  let scheme = call_589178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589178.url(scheme.get, call_589178.host, call_589178.base,
                         call_589178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589178, url, valid)

proc call*(call_589179: Call_RemotebuildexecutionOperationsWaitExecution_589162;
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
  var path_589180 = newJObject()
  var query_589181 = newJObject()
  var body_589182 = newJObject()
  add(query_589181, "upload_protocol", newJString(uploadProtocol))
  add(query_589181, "fields", newJString(fields))
  add(query_589181, "quotaUser", newJString(quotaUser))
  add(path_589180, "name", newJString(name))
  add(query_589181, "alt", newJString(alt))
  add(query_589181, "oauth_token", newJString(oauthToken))
  add(query_589181, "callback", newJString(callback))
  add(query_589181, "access_token", newJString(accessToken))
  add(query_589181, "uploadType", newJString(uploadType))
  add(query_589181, "key", newJString(key))
  add(query_589181, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589182 = body
  add(query_589181, "prettyPrint", newJBool(prettyPrint))
  result = call_589179.call(path_589180, query_589181, nil, nil, body_589182)

var remotebuildexecutionOperationsWaitExecution* = Call_RemotebuildexecutionOperationsWaitExecution_589162(
    name: "remotebuildexecutionOperationsWaitExecution",
    meth: HttpMethod.HttpPost, host: "remotebuildexecution.googleapis.com",
    route: "/v2/{name}:waitExecution",
    validator: validate_RemotebuildexecutionOperationsWaitExecution_589163,
    base: "/", url: url_RemotebuildexecutionOperationsWaitExecution_589164,
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
