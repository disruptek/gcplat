
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Tool Results firstparty
## version: v1beta3firstparty
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Reads and publishes results from Firebase Test Lab.
## 
## https://firebase.google.com/docs/test-lab/
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
  gcpServiceName = "toolresults"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ToolresultsProjectsHistoriesCreate_593976 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesCreate_593978(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesCreate_593977(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a History.
  ## 
  ## The returned History will have the id set.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing project does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_593979 = path.getOrDefault("projectId")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "projectId", valid_593979
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593980 = query.getOrDefault("fields")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "fields", valid_593980
  var valid_593981 = query.getOrDefault("requestId")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "requestId", valid_593981
  var valid_593982 = query.getOrDefault("quotaUser")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "quotaUser", valid_593982
  var valid_593983 = query.getOrDefault("alt")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = newJString("json"))
  if valid_593983 != nil:
    section.add "alt", valid_593983
  var valid_593984 = query.getOrDefault("oauth_token")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "oauth_token", valid_593984
  var valid_593985 = query.getOrDefault("userIp")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "userIp", valid_593985
  var valid_593986 = query.getOrDefault("key")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "key", valid_593986
  var valid_593987 = query.getOrDefault("prettyPrint")
  valid_593987 = validateParameter(valid_593987, JBool, required = false,
                                 default = newJBool(true))
  if valid_593987 != nil:
    section.add "prettyPrint", valid_593987
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

proc call*(call_593989: Call_ToolresultsProjectsHistoriesCreate_593976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a History.
  ## 
  ## The returned History will have the id set.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing project does not exist
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_ToolresultsProjectsHistoriesCreate_593976;
          projectId: string; fields: string = ""; requestId: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesCreate
  ## Creates a History.
  ## 
  ## The returned History will have the id set.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing project does not exist
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  var body_593993 = newJObject()
  add(query_593992, "fields", newJString(fields))
  add(query_593992, "requestId", newJString(requestId))
  add(query_593992, "quotaUser", newJString(quotaUser))
  add(query_593992, "alt", newJString(alt))
  add(query_593992, "oauth_token", newJString(oauthToken))
  add(query_593992, "userIp", newJString(userIp))
  add(query_593992, "key", newJString(key))
  add(path_593991, "projectId", newJString(projectId))
  if body != nil:
    body_593993 = body
  add(query_593992, "prettyPrint", newJBool(prettyPrint))
  result = call_593990.call(path_593991, query_593992, nil, nil, body_593993)

var toolresultsProjectsHistoriesCreate* = Call_ToolresultsProjectsHistoriesCreate_593976(
    name: "toolresultsProjectsHistoriesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectId}/histories",
    validator: validate_ToolresultsProjectsHistoriesCreate_593977,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesCreate_593978, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesList_593689 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesList_593691(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesList_593690(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Histories for a given Project.
  ## 
  ## The histories are sorted by modification time in descending order. The history_id key will be used to order the history with the same modification time.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the History does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_593817 = path.getOrDefault("projectId")
  valid_593817 = validateParameter(valid_593817, JString, required = true,
                                 default = nil)
  if valid_593817 != nil:
    section.add "projectId", valid_593817
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pageSize: JInt
  ##           : The maximum number of Histories to fetch.
  ## 
  ## Default value: 20. The server will use this default if the field is not set or has a value of 0. Any value greater than 100 will be treated as 100.
  ## 
  ## Optional.
  ##   filterByName: JString
  ##               : If set, only return histories with the given name.
  ## 
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593818 = query.getOrDefault("fields")
  valid_593818 = validateParameter(valid_593818, JString, required = false,
                                 default = nil)
  if valid_593818 != nil:
    section.add "fields", valid_593818
  var valid_593819 = query.getOrDefault("pageToken")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = nil)
  if valid_593819 != nil:
    section.add "pageToken", valid_593819
  var valid_593820 = query.getOrDefault("quotaUser")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "quotaUser", valid_593820
  var valid_593834 = query.getOrDefault("alt")
  valid_593834 = validateParameter(valid_593834, JString, required = false,
                                 default = newJString("json"))
  if valid_593834 != nil:
    section.add "alt", valid_593834
  var valid_593835 = query.getOrDefault("oauth_token")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = nil)
  if valid_593835 != nil:
    section.add "oauth_token", valid_593835
  var valid_593836 = query.getOrDefault("userIp")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "userIp", valid_593836
  var valid_593837 = query.getOrDefault("key")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "key", valid_593837
  var valid_593838 = query.getOrDefault("pageSize")
  valid_593838 = validateParameter(valid_593838, JInt, required = false, default = nil)
  if valid_593838 != nil:
    section.add "pageSize", valid_593838
  var valid_593839 = query.getOrDefault("filterByName")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "filterByName", valid_593839
  var valid_593840 = query.getOrDefault("prettyPrint")
  valid_593840 = validateParameter(valid_593840, JBool, required = false,
                                 default = newJBool(true))
  if valid_593840 != nil:
    section.add "prettyPrint", valid_593840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593863: Call_ToolresultsProjectsHistoriesList_593689;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Histories for a given Project.
  ## 
  ## The histories are sorted by modification time in descending order. The history_id key will be used to order the history with the same modification time.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the History does not exist
  ## 
  let valid = call_593863.validator(path, query, header, formData, body)
  let scheme = call_593863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593863.url(scheme.get, call_593863.host, call_593863.base,
                         call_593863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593863, url, valid)

proc call*(call_593934: Call_ToolresultsProjectsHistoriesList_593689;
          projectId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; pageSize: int = 0;
          filterByName: string = ""; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesList
  ## Lists Histories for a given Project.
  ## 
  ## The histories are sorted by modification time in descending order. The history_id key will be used to order the history with the same modification time.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the History does not exist
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   pageSize: int
  ##           : The maximum number of Histories to fetch.
  ## 
  ## Default value: 20. The server will use this default if the field is not set or has a value of 0. Any value greater than 100 will be treated as 100.
  ## 
  ## Optional.
  ##   filterByName: string
  ##               : If set, only return histories with the given name.
  ## 
  ## Optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593935 = newJObject()
  var query_593937 = newJObject()
  add(query_593937, "fields", newJString(fields))
  add(query_593937, "pageToken", newJString(pageToken))
  add(query_593937, "quotaUser", newJString(quotaUser))
  add(query_593937, "alt", newJString(alt))
  add(query_593937, "oauth_token", newJString(oauthToken))
  add(query_593937, "userIp", newJString(userIp))
  add(query_593937, "key", newJString(key))
  add(path_593935, "projectId", newJString(projectId))
  add(query_593937, "pageSize", newJInt(pageSize))
  add(query_593937, "filterByName", newJString(filterByName))
  add(query_593937, "prettyPrint", newJBool(prettyPrint))
  result = call_593934.call(path_593935, query_593937, nil, nil, nil)

var toolresultsProjectsHistoriesList* = Call_ToolresultsProjectsHistoriesList_593689(
    name: "toolresultsProjectsHistoriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectId}/histories",
    validator: validate_ToolresultsProjectsHistoriesList_593690,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesList_593691, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesGet_593994 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesGet_593996(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesGet_593995(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a History.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the History does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_593997 = path.getOrDefault("projectId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "projectId", valid_593997
  var valid_593998 = path.getOrDefault("historyId")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "historyId", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593999 = query.getOrDefault("fields")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "fields", valid_593999
  var valid_594000 = query.getOrDefault("quotaUser")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "quotaUser", valid_594000
  var valid_594001 = query.getOrDefault("alt")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = newJString("json"))
  if valid_594001 != nil:
    section.add "alt", valid_594001
  var valid_594002 = query.getOrDefault("oauth_token")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "oauth_token", valid_594002
  var valid_594003 = query.getOrDefault("userIp")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "userIp", valid_594003
  var valid_594004 = query.getOrDefault("key")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "key", valid_594004
  var valid_594005 = query.getOrDefault("prettyPrint")
  valid_594005 = validateParameter(valid_594005, JBool, required = false,
                                 default = newJBool(true))
  if valid_594005 != nil:
    section.add "prettyPrint", valid_594005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_ToolresultsProjectsHistoriesGet_593994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a History.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the History does not exist
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_ToolresultsProjectsHistoriesGet_593994;
          projectId: string; historyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesGet
  ## Gets a History.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the History does not exist
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  add(query_594009, "fields", newJString(fields))
  add(query_594009, "quotaUser", newJString(quotaUser))
  add(query_594009, "alt", newJString(alt))
  add(query_594009, "oauth_token", newJString(oauthToken))
  add(query_594009, "userIp", newJString(userIp))
  add(query_594009, "key", newJString(key))
  add(path_594008, "projectId", newJString(projectId))
  add(path_594008, "historyId", newJString(historyId))
  add(query_594009, "prettyPrint", newJBool(prettyPrint))
  result = call_594007.call(path_594008, query_594009, nil, nil, nil)

var toolresultsProjectsHistoriesGet* = Call_ToolresultsProjectsHistoriesGet_593994(
    name: "toolresultsProjectsHistoriesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}",
    validator: validate_ToolresultsProjectsHistoriesGet_593995,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesGet_593996, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsCreate_594028 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsCreate_594030(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsCreate_594029(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an Execution.
  ## 
  ## The returned Execution will have the id set.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing History does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_594031 = path.getOrDefault("projectId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "projectId", valid_594031
  var valid_594032 = path.getOrDefault("historyId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "historyId", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594033 = query.getOrDefault("fields")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "fields", valid_594033
  var valid_594034 = query.getOrDefault("requestId")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "requestId", valid_594034
  var valid_594035 = query.getOrDefault("quotaUser")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "quotaUser", valid_594035
  var valid_594036 = query.getOrDefault("alt")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = newJString("json"))
  if valid_594036 != nil:
    section.add "alt", valid_594036
  var valid_594037 = query.getOrDefault("oauth_token")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "oauth_token", valid_594037
  var valid_594038 = query.getOrDefault("userIp")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "userIp", valid_594038
  var valid_594039 = query.getOrDefault("key")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "key", valid_594039
  var valid_594040 = query.getOrDefault("prettyPrint")
  valid_594040 = validateParameter(valid_594040, JBool, required = false,
                                 default = newJBool(true))
  if valid_594040 != nil:
    section.add "prettyPrint", valid_594040
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

proc call*(call_594042: Call_ToolresultsProjectsHistoriesExecutionsCreate_594028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Execution.
  ## 
  ## The returned Execution will have the id set.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing History does not exist
  ## 
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_ToolresultsProjectsHistoriesExecutionsCreate_594028;
          projectId: string; historyId: string; fields: string = "";
          requestId: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsCreate
  ## Creates an Execution.
  ## 
  ## The returned Execution will have the id set.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing History does not exist
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  var body_594046 = newJObject()
  add(query_594045, "fields", newJString(fields))
  add(query_594045, "requestId", newJString(requestId))
  add(query_594045, "quotaUser", newJString(quotaUser))
  add(query_594045, "alt", newJString(alt))
  add(query_594045, "oauth_token", newJString(oauthToken))
  add(query_594045, "userIp", newJString(userIp))
  add(query_594045, "key", newJString(key))
  add(path_594044, "projectId", newJString(projectId))
  add(path_594044, "historyId", newJString(historyId))
  if body != nil:
    body_594046 = body
  add(query_594045, "prettyPrint", newJBool(prettyPrint))
  result = call_594043.call(path_594044, query_594045, nil, nil, body_594046)

var toolresultsProjectsHistoriesExecutionsCreate* = Call_ToolresultsProjectsHistoriesExecutionsCreate_594028(
    name: "toolresultsProjectsHistoriesExecutionsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions",
    validator: validate_ToolresultsProjectsHistoriesExecutionsCreate_594029,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsCreate_594030,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsList_594010 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsList_594012(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsList_594011(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Histories for a given Project.
  ## 
  ## The executions are sorted by creation_time in descending order. The execution_id key will be used to order the executions with the same creation_time.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing History does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_594013 = path.getOrDefault("projectId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "projectId", valid_594013
  var valid_594014 = path.getOrDefault("historyId")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "historyId", valid_594014
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pageSize: JInt
  ##           : The maximum number of Executions to fetch.
  ## 
  ## Default value: 25. The server will use this default if the field is not set or has a value of 0.
  ## 
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594015 = query.getOrDefault("fields")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "fields", valid_594015
  var valid_594016 = query.getOrDefault("pageToken")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "pageToken", valid_594016
  var valid_594017 = query.getOrDefault("quotaUser")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "quotaUser", valid_594017
  var valid_594018 = query.getOrDefault("alt")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = newJString("json"))
  if valid_594018 != nil:
    section.add "alt", valid_594018
  var valid_594019 = query.getOrDefault("oauth_token")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "oauth_token", valid_594019
  var valid_594020 = query.getOrDefault("userIp")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "userIp", valid_594020
  var valid_594021 = query.getOrDefault("key")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "key", valid_594021
  var valid_594022 = query.getOrDefault("pageSize")
  valid_594022 = validateParameter(valid_594022, JInt, required = false, default = nil)
  if valid_594022 != nil:
    section.add "pageSize", valid_594022
  var valid_594023 = query.getOrDefault("prettyPrint")
  valid_594023 = validateParameter(valid_594023, JBool, required = false,
                                 default = newJBool(true))
  if valid_594023 != nil:
    section.add "prettyPrint", valid_594023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_ToolresultsProjectsHistoriesExecutionsList_594010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Histories for a given Project.
  ## 
  ## The executions are sorted by creation_time in descending order. The execution_id key will be used to order the executions with the same creation_time.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing History does not exist
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_ToolresultsProjectsHistoriesExecutionsList_594010;
          projectId: string; historyId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = ""; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsList
  ## Lists Histories for a given Project.
  ## 
  ## The executions are sorted by creation_time in descending order. The execution_id key will be used to order the executions with the same creation_time.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing History does not exist
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   pageSize: int
  ##           : The maximum number of Executions to fetch.
  ## 
  ## Default value: 25. The server will use this default if the field is not set or has a value of 0.
  ## 
  ## Optional.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  add(query_594027, "fields", newJString(fields))
  add(query_594027, "pageToken", newJString(pageToken))
  add(query_594027, "quotaUser", newJString(quotaUser))
  add(query_594027, "alt", newJString(alt))
  add(query_594027, "oauth_token", newJString(oauthToken))
  add(query_594027, "userIp", newJString(userIp))
  add(query_594027, "key", newJString(key))
  add(path_594026, "projectId", newJString(projectId))
  add(query_594027, "pageSize", newJInt(pageSize))
  add(path_594026, "historyId", newJString(historyId))
  add(query_594027, "prettyPrint", newJBool(prettyPrint))
  result = call_594025.call(path_594026, query_594027, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsList* = Call_ToolresultsProjectsHistoriesExecutionsList_594010(
    name: "toolresultsProjectsHistoriesExecutionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions",
    validator: validate_ToolresultsProjectsHistoriesExecutionsList_594011,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsList_594012,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsGet_594047 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsGet_594049(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsGet_594048(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an Execution.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the Execution does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : An Execution id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_594050 = path.getOrDefault("projectId")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "projectId", valid_594050
  var valid_594051 = path.getOrDefault("historyId")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "historyId", valid_594051
  var valid_594052 = path.getOrDefault("executionId")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "executionId", valid_594052
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594053 = query.getOrDefault("fields")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "fields", valid_594053
  var valid_594054 = query.getOrDefault("quotaUser")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "quotaUser", valid_594054
  var valid_594055 = query.getOrDefault("alt")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = newJString("json"))
  if valid_594055 != nil:
    section.add "alt", valid_594055
  var valid_594056 = query.getOrDefault("oauth_token")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "oauth_token", valid_594056
  var valid_594057 = query.getOrDefault("userIp")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "userIp", valid_594057
  var valid_594058 = query.getOrDefault("key")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "key", valid_594058
  var valid_594059 = query.getOrDefault("prettyPrint")
  valid_594059 = validateParameter(valid_594059, JBool, required = false,
                                 default = newJBool(true))
  if valid_594059 != nil:
    section.add "prettyPrint", valid_594059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_ToolresultsProjectsHistoriesExecutionsGet_594047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an Execution.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the Execution does not exist
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_ToolresultsProjectsHistoriesExecutionsGet_594047;
          projectId: string; historyId: string; executionId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsGet
  ## Gets an Execution.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the Execution does not exist
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : An Execution id.
  ## 
  ## Required.
  var path_594062 = newJObject()
  var query_594063 = newJObject()
  add(query_594063, "fields", newJString(fields))
  add(query_594063, "quotaUser", newJString(quotaUser))
  add(query_594063, "alt", newJString(alt))
  add(query_594063, "oauth_token", newJString(oauthToken))
  add(query_594063, "userIp", newJString(userIp))
  add(query_594063, "key", newJString(key))
  add(path_594062, "projectId", newJString(projectId))
  add(path_594062, "historyId", newJString(historyId))
  add(query_594063, "prettyPrint", newJBool(prettyPrint))
  add(path_594062, "executionId", newJString(executionId))
  result = call_594061.call(path_594062, query_594063, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsGet* = Call_ToolresultsProjectsHistoriesExecutionsGet_594047(
    name: "toolresultsProjectsHistoriesExecutionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsGet_594048,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsGet_594049,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsPatch_594064 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsPatch_594066(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsPatch_594065(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing Execution with the supplied partial entity.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal - NOT_FOUND - if the containing History does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A Project id. Required.
  ##   historyId: JString (required)
  ##            : Required.
  ##   executionId: JString (required)
  ##              : Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_594067 = path.getOrDefault("projectId")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "projectId", valid_594067
  var valid_594068 = path.getOrDefault("historyId")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "historyId", valid_594068
  var valid_594069 = path.getOrDefault("executionId")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "executionId", valid_594069
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594070 = query.getOrDefault("fields")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "fields", valid_594070
  var valid_594071 = query.getOrDefault("requestId")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "requestId", valid_594071
  var valid_594072 = query.getOrDefault("quotaUser")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "quotaUser", valid_594072
  var valid_594073 = query.getOrDefault("alt")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = newJString("json"))
  if valid_594073 != nil:
    section.add "alt", valid_594073
  var valid_594074 = query.getOrDefault("oauth_token")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "oauth_token", valid_594074
  var valid_594075 = query.getOrDefault("userIp")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "userIp", valid_594075
  var valid_594076 = query.getOrDefault("key")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "key", valid_594076
  var valid_594077 = query.getOrDefault("prettyPrint")
  valid_594077 = validateParameter(valid_594077, JBool, required = false,
                                 default = newJBool(true))
  if valid_594077 != nil:
    section.add "prettyPrint", valid_594077
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

proc call*(call_594079: Call_ToolresultsProjectsHistoriesExecutionsPatch_594064;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing Execution with the supplied partial entity.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal - NOT_FOUND - if the containing History does not exist
  ## 
  let valid = call_594079.validator(path, query, header, formData, body)
  let scheme = call_594079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594079.url(scheme.get, call_594079.host, call_594079.base,
                         call_594079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594079, url, valid)

proc call*(call_594080: Call_ToolresultsProjectsHistoriesExecutionsPatch_594064;
          projectId: string; historyId: string; executionId: string;
          fields: string = ""; requestId: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsPatch
  ## Updates an existing Execution with the supplied partial entity.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal - NOT_FOUND - if the containing History does not exist
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id. Required.
  ##   historyId: string (required)
  ##            : Required.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : Required.
  var path_594081 = newJObject()
  var query_594082 = newJObject()
  var body_594083 = newJObject()
  add(query_594082, "fields", newJString(fields))
  add(query_594082, "requestId", newJString(requestId))
  add(query_594082, "quotaUser", newJString(quotaUser))
  add(query_594082, "alt", newJString(alt))
  add(query_594082, "oauth_token", newJString(oauthToken))
  add(query_594082, "userIp", newJString(userIp))
  add(query_594082, "key", newJString(key))
  add(path_594081, "projectId", newJString(projectId))
  add(path_594081, "historyId", newJString(historyId))
  if body != nil:
    body_594083 = body
  add(query_594082, "prettyPrint", newJBool(prettyPrint))
  add(path_594081, "executionId", newJString(executionId))
  result = call_594080.call(path_594081, query_594082, nil, nil, body_594083)

var toolresultsProjectsHistoriesExecutionsPatch* = Call_ToolresultsProjectsHistoriesExecutionsPatch_594064(
    name: "toolresultsProjectsHistoriesExecutionsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsPatch_594065,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsPatch_594066,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsClustersList_594084 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsClustersList_594086(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsClustersList_594085(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists Screenshot Clusters
  ## 
  ## Returns the list of screenshot clusters corresponding to an execution. Screenshot clusters are created after the execution is finished. Clusters are created from a set of screenshots. Between any two screenshots, a matching score is calculated based off their metadata that determines how similar they are. Screenshots are placed in the cluster that has screens which have the highest matching scores.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : An Execution id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_594087 = path.getOrDefault("projectId")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "projectId", valid_594087
  var valid_594088 = path.getOrDefault("historyId")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "historyId", valid_594088
  var valid_594089 = path.getOrDefault("executionId")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "executionId", valid_594089
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594090 = query.getOrDefault("fields")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "fields", valid_594090
  var valid_594091 = query.getOrDefault("quotaUser")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "quotaUser", valid_594091
  var valid_594092 = query.getOrDefault("alt")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = newJString("json"))
  if valid_594092 != nil:
    section.add "alt", valid_594092
  var valid_594093 = query.getOrDefault("oauth_token")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "oauth_token", valid_594093
  var valid_594094 = query.getOrDefault("userIp")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "userIp", valid_594094
  var valid_594095 = query.getOrDefault("key")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "key", valid_594095
  var valid_594096 = query.getOrDefault("prettyPrint")
  valid_594096 = validateParameter(valid_594096, JBool, required = false,
                                 default = newJBool(true))
  if valid_594096 != nil:
    section.add "prettyPrint", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594097: Call_ToolresultsProjectsHistoriesExecutionsClustersList_594084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Screenshot Clusters
  ## 
  ## Returns the list of screenshot clusters corresponding to an execution. Screenshot clusters are created after the execution is finished. Clusters are created from a set of screenshots. Between any two screenshots, a matching score is calculated based off their metadata that determines how similar they are. Screenshots are placed in the cluster that has screens which have the highest matching scores.
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_ToolresultsProjectsHistoriesExecutionsClustersList_594084;
          projectId: string; historyId: string; executionId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsClustersList
  ## Lists Screenshot Clusters
  ## 
  ## Returns the list of screenshot clusters corresponding to an execution. Screenshot clusters are created after the execution is finished. Clusters are created from a set of screenshots. Between any two screenshots, a matching score is calculated based off their metadata that determines how similar they are. Screenshots are placed in the cluster that has screens which have the highest matching scores.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : An Execution id.
  ## 
  ## Required.
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  add(query_594100, "fields", newJString(fields))
  add(query_594100, "quotaUser", newJString(quotaUser))
  add(query_594100, "alt", newJString(alt))
  add(query_594100, "oauth_token", newJString(oauthToken))
  add(query_594100, "userIp", newJString(userIp))
  add(query_594100, "key", newJString(key))
  add(path_594099, "projectId", newJString(projectId))
  add(path_594099, "historyId", newJString(historyId))
  add(query_594100, "prettyPrint", newJBool(prettyPrint))
  add(path_594099, "executionId", newJString(executionId))
  result = call_594098.call(path_594099, query_594100, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsClustersList* = Call_ToolresultsProjectsHistoriesExecutionsClustersList_594084(
    name: "toolresultsProjectsHistoriesExecutionsClustersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/clusters",
    validator: validate_ToolresultsProjectsHistoriesExecutionsClustersList_594085,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsClustersList_594086,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsClustersGet_594101 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsClustersGet_594103(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsClustersGet_594102(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves a single screenshot cluster by its ID
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   clusterId: JString (required)
  ##            : A Cluster id
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : An Execution id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_594104 = path.getOrDefault("projectId")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "projectId", valid_594104
  var valid_594105 = path.getOrDefault("historyId")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "historyId", valid_594105
  var valid_594106 = path.getOrDefault("clusterId")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "clusterId", valid_594106
  var valid_594107 = path.getOrDefault("executionId")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "executionId", valid_594107
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594108 = query.getOrDefault("fields")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "fields", valid_594108
  var valid_594109 = query.getOrDefault("quotaUser")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "quotaUser", valid_594109
  var valid_594110 = query.getOrDefault("alt")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = newJString("json"))
  if valid_594110 != nil:
    section.add "alt", valid_594110
  var valid_594111 = query.getOrDefault("oauth_token")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "oauth_token", valid_594111
  var valid_594112 = query.getOrDefault("userIp")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "userIp", valid_594112
  var valid_594113 = query.getOrDefault("key")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "key", valid_594113
  var valid_594114 = query.getOrDefault("prettyPrint")
  valid_594114 = validateParameter(valid_594114, JBool, required = false,
                                 default = newJBool(true))
  if valid_594114 != nil:
    section.add "prettyPrint", valid_594114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594115: Call_ToolresultsProjectsHistoriesExecutionsClustersGet_594101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a single screenshot cluster by its ID
  ## 
  let valid = call_594115.validator(path, query, header, formData, body)
  let scheme = call_594115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594115.url(scheme.get, call_594115.host, call_594115.base,
                         call_594115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594115, url, valid)

proc call*(call_594116: Call_ToolresultsProjectsHistoriesExecutionsClustersGet_594101;
          projectId: string; historyId: string; clusterId: string;
          executionId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsClustersGet
  ## Retrieves a single screenshot cluster by its ID
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : A Cluster id
  ## 
  ## Required.
  ##   executionId: string (required)
  ##              : An Execution id.
  ## 
  ## Required.
  var path_594117 = newJObject()
  var query_594118 = newJObject()
  add(query_594118, "fields", newJString(fields))
  add(query_594118, "quotaUser", newJString(quotaUser))
  add(query_594118, "alt", newJString(alt))
  add(query_594118, "oauth_token", newJString(oauthToken))
  add(query_594118, "userIp", newJString(userIp))
  add(query_594118, "key", newJString(key))
  add(path_594117, "projectId", newJString(projectId))
  add(path_594117, "historyId", newJString(historyId))
  add(query_594118, "prettyPrint", newJBool(prettyPrint))
  add(path_594117, "clusterId", newJString(clusterId))
  add(path_594117, "executionId", newJString(executionId))
  result = call_594116.call(path_594117, query_594118, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsClustersGet* = Call_ToolresultsProjectsHistoriesExecutionsClustersGet_594101(
    name: "toolresultsProjectsHistoriesExecutionsClustersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/clusters/{clusterId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsClustersGet_594102,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsClustersGet_594103,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_594138 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsStepsCreate_594140(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/steps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsCreate_594139(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a Step.
  ## 
  ## The returned Step will have the id set.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the step is too large (more than 10Mib) - NOT_FOUND - if the containing Execution does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : A Execution id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_594141 = path.getOrDefault("projectId")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "projectId", valid_594141
  var valid_594142 = path.getOrDefault("historyId")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "historyId", valid_594142
  var valid_594143 = path.getOrDefault("executionId")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "executionId", valid_594143
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594144 = query.getOrDefault("fields")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "fields", valid_594144
  var valid_594145 = query.getOrDefault("requestId")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "requestId", valid_594145
  var valid_594146 = query.getOrDefault("quotaUser")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "quotaUser", valid_594146
  var valid_594147 = query.getOrDefault("alt")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = newJString("json"))
  if valid_594147 != nil:
    section.add "alt", valid_594147
  var valid_594148 = query.getOrDefault("oauth_token")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "oauth_token", valid_594148
  var valid_594149 = query.getOrDefault("userIp")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "userIp", valid_594149
  var valid_594150 = query.getOrDefault("key")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "key", valid_594150
  var valid_594151 = query.getOrDefault("prettyPrint")
  valid_594151 = validateParameter(valid_594151, JBool, required = false,
                                 default = newJBool(true))
  if valid_594151 != nil:
    section.add "prettyPrint", valid_594151
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

proc call*(call_594153: Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_594138;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Step.
  ## 
  ## The returned Step will have the id set.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the step is too large (more than 10Mib) - NOT_FOUND - if the containing Execution does not exist
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_594138;
          projectId: string; historyId: string; executionId: string;
          fields: string = ""; requestId: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsCreate
  ## Creates a Step.
  ## 
  ## The returned Step will have the id set.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the step is too large (more than 10Mib) - NOT_FOUND - if the containing Execution does not exist
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : A Execution id.
  ## 
  ## Required.
  var path_594155 = newJObject()
  var query_594156 = newJObject()
  var body_594157 = newJObject()
  add(query_594156, "fields", newJString(fields))
  add(query_594156, "requestId", newJString(requestId))
  add(query_594156, "quotaUser", newJString(quotaUser))
  add(query_594156, "alt", newJString(alt))
  add(query_594156, "oauth_token", newJString(oauthToken))
  add(query_594156, "userIp", newJString(userIp))
  add(query_594156, "key", newJString(key))
  add(path_594155, "projectId", newJString(projectId))
  add(path_594155, "historyId", newJString(historyId))
  if body != nil:
    body_594157 = body
  add(query_594156, "prettyPrint", newJBool(prettyPrint))
  add(path_594155, "executionId", newJString(executionId))
  result = call_594154.call(path_594155, query_594156, nil, nil, body_594157)

var toolresultsProjectsHistoriesExecutionsStepsCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_594138(
    name: "toolresultsProjectsHistoriesExecutionsStepsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsCreate_594139,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsCreate_594140,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsList_594119 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsStepsList_594121(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/steps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsList_594120(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists Steps for a given Execution.
  ## 
  ## The steps are sorted by creation_time in descending order. The step_id key will be used to order the steps with the same creation_time.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if an argument in the request happens to be invalid; e.g. if an attempt is made to list the children of a nonexistent Step - NOT_FOUND - if the containing Execution does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : A Execution id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_594122 = path.getOrDefault("projectId")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "projectId", valid_594122
  var valid_594123 = path.getOrDefault("historyId")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "historyId", valid_594123
  var valid_594124 = path.getOrDefault("executionId")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "executionId", valid_594124
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pageSize: JInt
  ##           : The maximum number of Steps to fetch.
  ## 
  ## Default value: 25. The server will use this default if the field is not set or has a value of 0.
  ## 
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594125 = query.getOrDefault("fields")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "fields", valid_594125
  var valid_594126 = query.getOrDefault("pageToken")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "pageToken", valid_594126
  var valid_594127 = query.getOrDefault("quotaUser")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "quotaUser", valid_594127
  var valid_594128 = query.getOrDefault("alt")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = newJString("json"))
  if valid_594128 != nil:
    section.add "alt", valid_594128
  var valid_594129 = query.getOrDefault("oauth_token")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "oauth_token", valid_594129
  var valid_594130 = query.getOrDefault("userIp")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "userIp", valid_594130
  var valid_594131 = query.getOrDefault("key")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "key", valid_594131
  var valid_594132 = query.getOrDefault("pageSize")
  valid_594132 = validateParameter(valid_594132, JInt, required = false, default = nil)
  if valid_594132 != nil:
    section.add "pageSize", valid_594132
  var valid_594133 = query.getOrDefault("prettyPrint")
  valid_594133 = validateParameter(valid_594133, JBool, required = false,
                                 default = newJBool(true))
  if valid_594133 != nil:
    section.add "prettyPrint", valid_594133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594134: Call_ToolresultsProjectsHistoriesExecutionsStepsList_594119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Steps for a given Execution.
  ## 
  ## The steps are sorted by creation_time in descending order. The step_id key will be used to order the steps with the same creation_time.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if an argument in the request happens to be invalid; e.g. if an attempt is made to list the children of a nonexistent Step - NOT_FOUND - if the containing Execution does not exist
  ## 
  let valid = call_594134.validator(path, query, header, formData, body)
  let scheme = call_594134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594134.url(scheme.get, call_594134.host, call_594134.base,
                         call_594134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594134, url, valid)

proc call*(call_594135: Call_ToolresultsProjectsHistoriesExecutionsStepsList_594119;
          projectId: string; historyId: string; executionId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsList
  ## Lists Steps for a given Execution.
  ## 
  ## The steps are sorted by creation_time in descending order. The step_id key will be used to order the steps with the same creation_time.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if an argument in the request happens to be invalid; e.g. if an attempt is made to list the children of a nonexistent Step - NOT_FOUND - if the containing Execution does not exist
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   pageSize: int
  ##           : The maximum number of Steps to fetch.
  ## 
  ## Default value: 25. The server will use this default if the field is not set or has a value of 0.
  ## 
  ## Optional.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : A Execution id.
  ## 
  ## Required.
  var path_594136 = newJObject()
  var query_594137 = newJObject()
  add(query_594137, "fields", newJString(fields))
  add(query_594137, "pageToken", newJString(pageToken))
  add(query_594137, "quotaUser", newJString(quotaUser))
  add(query_594137, "alt", newJString(alt))
  add(query_594137, "oauth_token", newJString(oauthToken))
  add(query_594137, "userIp", newJString(userIp))
  add(query_594137, "key", newJString(key))
  add(path_594136, "projectId", newJString(projectId))
  add(query_594137, "pageSize", newJInt(pageSize))
  add(path_594136, "historyId", newJString(historyId))
  add(query_594137, "prettyPrint", newJBool(prettyPrint))
  add(path_594136, "executionId", newJString(executionId))
  result = call_594135.call(path_594136, query_594137, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsList* = Call_ToolresultsProjectsHistoriesExecutionsStepsList_594119(
    name: "toolresultsProjectsHistoriesExecutionsStepsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsList_594120,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsList_594121,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsGet_594158 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsStepsGet_594160(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  assert "stepId" in path, "`stepId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsGet_594159(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a Step.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the Step does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stepId: JString (required)
  ##         : A Step id.
  ## 
  ## Required.
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : A Execution id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stepId` field"
  var valid_594161 = path.getOrDefault("stepId")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "stepId", valid_594161
  var valid_594162 = path.getOrDefault("projectId")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "projectId", valid_594162
  var valid_594163 = path.getOrDefault("historyId")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "historyId", valid_594163
  var valid_594164 = path.getOrDefault("executionId")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "executionId", valid_594164
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594165 = query.getOrDefault("fields")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "fields", valid_594165
  var valid_594166 = query.getOrDefault("quotaUser")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "quotaUser", valid_594166
  var valid_594167 = query.getOrDefault("alt")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = newJString("json"))
  if valid_594167 != nil:
    section.add "alt", valid_594167
  var valid_594168 = query.getOrDefault("oauth_token")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "oauth_token", valid_594168
  var valid_594169 = query.getOrDefault("userIp")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "userIp", valid_594169
  var valid_594170 = query.getOrDefault("key")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "key", valid_594170
  var valid_594171 = query.getOrDefault("prettyPrint")
  valid_594171 = validateParameter(valid_594171, JBool, required = false,
                                 default = newJBool(true))
  if valid_594171 != nil:
    section.add "prettyPrint", valid_594171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594172: Call_ToolresultsProjectsHistoriesExecutionsStepsGet_594158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a Step.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the Step does not exist
  ## 
  let valid = call_594172.validator(path, query, header, formData, body)
  let scheme = call_594172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594172.url(scheme.get, call_594172.host, call_594172.base,
                         call_594172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594172, url, valid)

proc call*(call_594173: Call_ToolresultsProjectsHistoriesExecutionsStepsGet_594158;
          stepId: string; projectId: string; historyId: string; executionId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsGet
  ## Gets a Step.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the Step does not exist
  ##   stepId: string (required)
  ##         : A Step id.
  ## 
  ## Required.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : A Execution id.
  ## 
  ## Required.
  var path_594174 = newJObject()
  var query_594175 = newJObject()
  add(path_594174, "stepId", newJString(stepId))
  add(query_594175, "fields", newJString(fields))
  add(query_594175, "quotaUser", newJString(quotaUser))
  add(query_594175, "alt", newJString(alt))
  add(query_594175, "oauth_token", newJString(oauthToken))
  add(query_594175, "userIp", newJString(userIp))
  add(query_594175, "key", newJString(key))
  add(path_594174, "projectId", newJString(projectId))
  add(path_594174, "historyId", newJString(historyId))
  add(query_594175, "prettyPrint", newJBool(prettyPrint))
  add(path_594174, "executionId", newJString(executionId))
  result = call_594173.call(path_594174, query_594175, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsGet* = Call_ToolresultsProjectsHistoriesExecutionsStepsGet_594158(
    name: "toolresultsProjectsHistoriesExecutionsStepsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsGet_594159,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsGet_594160,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_594176 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPatch_594178(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  assert "stepId" in path, "`stepId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPatch_594177(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an existing Step with the supplied partial entity.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal (e.g try to upload a duplicate xml file), if the updated step is too large (more than 10Mib) - NOT_FOUND - if the containing Execution does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stepId: JString (required)
  ##         : A Step id.
  ## 
  ## Required.
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : A Execution id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stepId` field"
  var valid_594179 = path.getOrDefault("stepId")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "stepId", valid_594179
  var valid_594180 = path.getOrDefault("projectId")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "projectId", valid_594180
  var valid_594181 = path.getOrDefault("historyId")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "historyId", valid_594181
  var valid_594182 = path.getOrDefault("executionId")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "executionId", valid_594182
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594183 = query.getOrDefault("fields")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "fields", valid_594183
  var valid_594184 = query.getOrDefault("requestId")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "requestId", valid_594184
  var valid_594185 = query.getOrDefault("quotaUser")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "quotaUser", valid_594185
  var valid_594186 = query.getOrDefault("alt")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = newJString("json"))
  if valid_594186 != nil:
    section.add "alt", valid_594186
  var valid_594187 = query.getOrDefault("oauth_token")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "oauth_token", valid_594187
  var valid_594188 = query.getOrDefault("userIp")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "userIp", valid_594188
  var valid_594189 = query.getOrDefault("key")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "key", valid_594189
  var valid_594190 = query.getOrDefault("prettyPrint")
  valid_594190 = validateParameter(valid_594190, JBool, required = false,
                                 default = newJBool(true))
  if valid_594190 != nil:
    section.add "prettyPrint", valid_594190
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

proc call*(call_594192: Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_594176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing Step with the supplied partial entity.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal (e.g try to upload a duplicate xml file), if the updated step is too large (more than 10Mib) - NOT_FOUND - if the containing Execution does not exist
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_594176;
          stepId: string; projectId: string; historyId: string; executionId: string;
          fields: string = ""; requestId: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPatch
  ## Updates an existing Step with the supplied partial entity.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal (e.g try to upload a duplicate xml file), if the updated step is too large (more than 10Mib) - NOT_FOUND - if the containing Execution does not exist
  ##   stepId: string (required)
  ##         : A Step id.
  ## 
  ## Required.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : A Execution id.
  ## 
  ## Required.
  var path_594194 = newJObject()
  var query_594195 = newJObject()
  var body_594196 = newJObject()
  add(path_594194, "stepId", newJString(stepId))
  add(query_594195, "fields", newJString(fields))
  add(query_594195, "requestId", newJString(requestId))
  add(query_594195, "quotaUser", newJString(quotaUser))
  add(query_594195, "alt", newJString(alt))
  add(query_594195, "oauth_token", newJString(oauthToken))
  add(query_594195, "userIp", newJString(userIp))
  add(query_594195, "key", newJString(key))
  add(path_594194, "projectId", newJString(projectId))
  add(path_594194, "historyId", newJString(historyId))
  if body != nil:
    body_594196 = body
  add(query_594195, "prettyPrint", newJBool(prettyPrint))
  add(path_594194, "executionId", newJString(executionId))
  result = call_594193.call(path_594194, query_594195, nil, nil, body_594196)

var toolresultsProjectsHistoriesExecutionsStepsPatch* = Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_594176(
    name: "toolresultsProjectsHistoriesExecutionsStepsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPatch_594177,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPatch_594178,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_594215 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_594217(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  assert "stepId" in path, "`stepId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepId"),
               (kind: ConstantSegment, value: "/perfMetricsSummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_594216(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a PerfMetricsSummary resource.
  ## 
  ## May return any of the following error code(s): - ALREADY_EXISTS - A PerfMetricSummary already exists for the given Step - NOT_FOUND - The containing Step does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stepId: JString (required)
  ##         : A tool results step ID.
  ##   projectId: JString (required)
  ##            : The cloud project
  ##   historyId: JString (required)
  ##            : A tool results history ID.
  ##   executionId: JString (required)
  ##              : A tool results execution ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stepId` field"
  var valid_594218 = path.getOrDefault("stepId")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "stepId", valid_594218
  var valid_594219 = path.getOrDefault("projectId")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "projectId", valid_594219
  var valid_594220 = path.getOrDefault("historyId")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "historyId", valid_594220
  var valid_594221 = path.getOrDefault("executionId")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "executionId", valid_594221
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594222 = query.getOrDefault("fields")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "fields", valid_594222
  var valid_594223 = query.getOrDefault("quotaUser")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "quotaUser", valid_594223
  var valid_594224 = query.getOrDefault("alt")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = newJString("json"))
  if valid_594224 != nil:
    section.add "alt", valid_594224
  var valid_594225 = query.getOrDefault("oauth_token")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = nil)
  if valid_594225 != nil:
    section.add "oauth_token", valid_594225
  var valid_594226 = query.getOrDefault("userIp")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "userIp", valid_594226
  var valid_594227 = query.getOrDefault("key")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "key", valid_594227
  var valid_594228 = query.getOrDefault("prettyPrint")
  valid_594228 = validateParameter(valid_594228, JBool, required = false,
                                 default = newJBool(true))
  if valid_594228 != nil:
    section.add "prettyPrint", valid_594228
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

proc call*(call_594230: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_594215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a PerfMetricsSummary resource.
  ## 
  ## May return any of the following error code(s): - ALREADY_EXISTS - A PerfMetricSummary already exists for the given Step - NOT_FOUND - The containing Step does not exist
  ## 
  let valid = call_594230.validator(path, query, header, formData, body)
  let scheme = call_594230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594230.url(scheme.get, call_594230.host, call_594230.base,
                         call_594230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594230, url, valid)

proc call*(call_594231: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_594215;
          stepId: string; projectId: string; historyId: string; executionId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate
  ## Creates a PerfMetricsSummary resource.
  ## 
  ## May return any of the following error code(s): - ALREADY_EXISTS - A PerfMetricSummary already exists for the given Step - NOT_FOUND - The containing Step does not exist
  ##   stepId: string (required)
  ##         : A tool results step ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The cloud project
  ##   historyId: string (required)
  ##            : A tool results history ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : A tool results execution ID.
  var path_594232 = newJObject()
  var query_594233 = newJObject()
  var body_594234 = newJObject()
  add(path_594232, "stepId", newJString(stepId))
  add(query_594233, "fields", newJString(fields))
  add(query_594233, "quotaUser", newJString(quotaUser))
  add(query_594233, "alt", newJString(alt))
  add(query_594233, "oauth_token", newJString(oauthToken))
  add(query_594233, "userIp", newJString(userIp))
  add(query_594233, "key", newJString(key))
  add(path_594232, "projectId", newJString(projectId))
  add(path_594232, "historyId", newJString(historyId))
  if body != nil:
    body_594234 = body
  add(query_594233, "prettyPrint", newJBool(prettyPrint))
  add(path_594232, "executionId", newJString(executionId))
  result = call_594231.call(path_594232, query_594233, nil, nil, body_594234)

var toolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_594215(name: "toolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfMetricsSummary", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_594216,
    base: "/toolresults/v1beta3firstparty/projects", url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_594217,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_594197 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_594199(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  assert "stepId" in path, "`stepId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepId"),
               (kind: ConstantSegment, value: "/perfMetricsSummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_594198(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves a PerfMetricsSummary.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfMetricsSummary does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stepId: JString (required)
  ##         : A tool results step ID.
  ##   projectId: JString (required)
  ##            : The cloud project
  ##   historyId: JString (required)
  ##            : A tool results history ID.
  ##   executionId: JString (required)
  ##              : A tool results execution ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stepId` field"
  var valid_594200 = path.getOrDefault("stepId")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "stepId", valid_594200
  var valid_594201 = path.getOrDefault("projectId")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "projectId", valid_594201
  var valid_594202 = path.getOrDefault("historyId")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "historyId", valid_594202
  var valid_594203 = path.getOrDefault("executionId")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "executionId", valid_594203
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594204 = query.getOrDefault("fields")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "fields", valid_594204
  var valid_594205 = query.getOrDefault("quotaUser")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "quotaUser", valid_594205
  var valid_594206 = query.getOrDefault("alt")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = newJString("json"))
  if valid_594206 != nil:
    section.add "alt", valid_594206
  var valid_594207 = query.getOrDefault("oauth_token")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "oauth_token", valid_594207
  var valid_594208 = query.getOrDefault("userIp")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "userIp", valid_594208
  var valid_594209 = query.getOrDefault("key")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "key", valid_594209
  var valid_594210 = query.getOrDefault("prettyPrint")
  valid_594210 = validateParameter(valid_594210, JBool, required = false,
                                 default = newJBool(true))
  if valid_594210 != nil:
    section.add "prettyPrint", valid_594210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594211: Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_594197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a PerfMetricsSummary.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfMetricsSummary does not exist
  ## 
  let valid = call_594211.validator(path, query, header, formData, body)
  let scheme = call_594211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594211.url(scheme.get, call_594211.host, call_594211.base,
                         call_594211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594211, url, valid)

proc call*(call_594212: Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_594197;
          stepId: string; projectId: string; historyId: string; executionId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary
  ## Retrieves a PerfMetricsSummary.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfMetricsSummary does not exist
  ##   stepId: string (required)
  ##         : A tool results step ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The cloud project
  ##   historyId: string (required)
  ##            : A tool results history ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : A tool results execution ID.
  var path_594213 = newJObject()
  var query_594214 = newJObject()
  add(path_594213, "stepId", newJString(stepId))
  add(query_594214, "fields", newJString(fields))
  add(query_594214, "quotaUser", newJString(quotaUser))
  add(query_594214, "alt", newJString(alt))
  add(query_594214, "oauth_token", newJString(oauthToken))
  add(query_594214, "userIp", newJString(userIp))
  add(query_594214, "key", newJString(key))
  add(path_594213, "projectId", newJString(projectId))
  add(path_594213, "historyId", newJString(historyId))
  add(query_594214, "prettyPrint", newJBool(prettyPrint))
  add(path_594213, "executionId", newJString(executionId))
  result = call_594212.call(path_594213, query_594214, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary* = Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_594197(
    name: "toolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfMetricsSummary", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_594198,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_594199,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_594254 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_594256(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  assert "stepId" in path, "`stepId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepId"),
               (kind: ConstantSegment, value: "/perfSampleSeries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_594255(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - ALREADY_EXISTS - PerfMetricSummary already exists for the given Step - NOT_FOUND - The containing Step does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stepId: JString (required)
  ##         : A tool results step ID.
  ##   projectId: JString (required)
  ##            : The cloud project
  ##   historyId: JString (required)
  ##            : A tool results history ID.
  ##   executionId: JString (required)
  ##              : A tool results execution ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stepId` field"
  var valid_594257 = path.getOrDefault("stepId")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "stepId", valid_594257
  var valid_594258 = path.getOrDefault("projectId")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "projectId", valid_594258
  var valid_594259 = path.getOrDefault("historyId")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "historyId", valid_594259
  var valid_594260 = path.getOrDefault("executionId")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "executionId", valid_594260
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594261 = query.getOrDefault("fields")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "fields", valid_594261
  var valid_594262 = query.getOrDefault("quotaUser")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "quotaUser", valid_594262
  var valid_594263 = query.getOrDefault("alt")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = newJString("json"))
  if valid_594263 != nil:
    section.add "alt", valid_594263
  var valid_594264 = query.getOrDefault("oauth_token")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "oauth_token", valid_594264
  var valid_594265 = query.getOrDefault("userIp")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = nil)
  if valid_594265 != nil:
    section.add "userIp", valid_594265
  var valid_594266 = query.getOrDefault("key")
  valid_594266 = validateParameter(valid_594266, JString, required = false,
                                 default = nil)
  if valid_594266 != nil:
    section.add "key", valid_594266
  var valid_594267 = query.getOrDefault("prettyPrint")
  valid_594267 = validateParameter(valid_594267, JBool, required = false,
                                 default = newJBool(true))
  if valid_594267 != nil:
    section.add "prettyPrint", valid_594267
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

proc call*(call_594269: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_594254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - ALREADY_EXISTS - PerfMetricSummary already exists for the given Step - NOT_FOUND - The containing Step does not exist
  ## 
  let valid = call_594269.validator(path, query, header, formData, body)
  let scheme = call_594269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594269.url(scheme.get, call_594269.host, call_594269.base,
                         call_594269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594269, url, valid)

proc call*(call_594270: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_594254;
          stepId: string; projectId: string; historyId: string; executionId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate
  ## Creates a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - ALREADY_EXISTS - PerfMetricSummary already exists for the given Step - NOT_FOUND - The containing Step does not exist
  ##   stepId: string (required)
  ##         : A tool results step ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The cloud project
  ##   historyId: string (required)
  ##            : A tool results history ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : A tool results execution ID.
  var path_594271 = newJObject()
  var query_594272 = newJObject()
  var body_594273 = newJObject()
  add(path_594271, "stepId", newJString(stepId))
  add(query_594272, "fields", newJString(fields))
  add(query_594272, "quotaUser", newJString(quotaUser))
  add(query_594272, "alt", newJString(alt))
  add(query_594272, "oauth_token", newJString(oauthToken))
  add(query_594272, "userIp", newJString(userIp))
  add(query_594272, "key", newJString(key))
  add(path_594271, "projectId", newJString(projectId))
  add(path_594271, "historyId", newJString(historyId))
  if body != nil:
    body_594273 = body
  add(query_594272, "prettyPrint", newJBool(prettyPrint))
  add(path_594271, "executionId", newJString(executionId))
  result = call_594270.call(path_594271, query_594272, nil, nil, body_594273)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_594254(
    name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_594255,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_594256,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_594235 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_594237(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  assert "stepId" in path, "`stepId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepId"),
               (kind: ConstantSegment, value: "/perfSampleSeries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_594236(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists PerfSampleSeries for a given Step.
  ## 
  ## The request provides an optional filter which specifies one or more PerfMetricsType to include in the result; if none returns all. The resulting PerfSampleSeries are sorted by ids.
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing Step does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stepId: JString (required)
  ##         : A tool results step ID.
  ##   projectId: JString (required)
  ##            : The cloud project
  ##   historyId: JString (required)
  ##            : A tool results history ID.
  ##   executionId: JString (required)
  ##              : A tool results execution ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stepId` field"
  var valid_594238 = path.getOrDefault("stepId")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "stepId", valid_594238
  var valid_594239 = path.getOrDefault("projectId")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "projectId", valid_594239
  var valid_594240 = path.getOrDefault("historyId")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "historyId", valid_594240
  var valid_594241 = path.getOrDefault("executionId")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "executionId", valid_594241
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JArray
  ##         : Specify one or more PerfMetricType values such as CPU to filter the result
  section = newJObject()
  var valid_594242 = query.getOrDefault("fields")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "fields", valid_594242
  var valid_594243 = query.getOrDefault("quotaUser")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "quotaUser", valid_594243
  var valid_594244 = query.getOrDefault("alt")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = newJString("json"))
  if valid_594244 != nil:
    section.add "alt", valid_594244
  var valid_594245 = query.getOrDefault("oauth_token")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "oauth_token", valid_594245
  var valid_594246 = query.getOrDefault("userIp")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "userIp", valid_594246
  var valid_594247 = query.getOrDefault("key")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = nil)
  if valid_594247 != nil:
    section.add "key", valid_594247
  var valid_594248 = query.getOrDefault("prettyPrint")
  valid_594248 = validateParameter(valid_594248, JBool, required = false,
                                 default = newJBool(true))
  if valid_594248 != nil:
    section.add "prettyPrint", valid_594248
  var valid_594249 = query.getOrDefault("filter")
  valid_594249 = validateParameter(valid_594249, JArray, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "filter", valid_594249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594250: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_594235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists PerfSampleSeries for a given Step.
  ## 
  ## The request provides an optional filter which specifies one or more PerfMetricsType to include in the result; if none returns all. The resulting PerfSampleSeries are sorted by ids.
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing Step does not exist
  ## 
  let valid = call_594250.validator(path, query, header, formData, body)
  let scheme = call_594250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594250.url(scheme.get, call_594250.host, call_594250.base,
                         call_594250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594250, url, valid)

proc call*(call_594251: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_594235;
          stepId: string; projectId: string; historyId: string; executionId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; filter: JsonNode = nil): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList
  ## Lists PerfSampleSeries for a given Step.
  ## 
  ## The request provides an optional filter which specifies one or more PerfMetricsType to include in the result; if none returns all. The resulting PerfSampleSeries are sorted by ids.
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing Step does not exist
  ##   stepId: string (required)
  ##         : A tool results step ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The cloud project
  ##   historyId: string (required)
  ##            : A tool results history ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : A tool results execution ID.
  ##   filter: JArray
  ##         : Specify one or more PerfMetricType values such as CPU to filter the result
  var path_594252 = newJObject()
  var query_594253 = newJObject()
  add(path_594252, "stepId", newJString(stepId))
  add(query_594253, "fields", newJString(fields))
  add(query_594253, "quotaUser", newJString(quotaUser))
  add(query_594253, "alt", newJString(alt))
  add(query_594253, "oauth_token", newJString(oauthToken))
  add(query_594253, "userIp", newJString(userIp))
  add(query_594253, "key", newJString(key))
  add(path_594252, "projectId", newJString(projectId))
  add(path_594252, "historyId", newJString(historyId))
  add(query_594253, "prettyPrint", newJBool(prettyPrint))
  add(path_594252, "executionId", newJString(executionId))
  if filter != nil:
    query_594253.add "filter", filter
  result = call_594251.call(path_594252, query_594253, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_594235(
    name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_594236,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_594237,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_594274 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_594276(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  assert "stepId" in path, "`stepId` is a required path parameter"
  assert "sampleSeriesId" in path, "`sampleSeriesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepId"),
               (kind: ConstantSegment, value: "/perfSampleSeries/"),
               (kind: VariableSegment, value: "sampleSeriesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_594275(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfSampleSeries does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stepId: JString (required)
  ##         : A tool results step ID.
  ##   projectId: JString (required)
  ##            : The cloud project
  ##   sampleSeriesId: JString (required)
  ##                 : A sample series id
  ##   historyId: JString (required)
  ##            : A tool results history ID.
  ##   executionId: JString (required)
  ##              : A tool results execution ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stepId` field"
  var valid_594277 = path.getOrDefault("stepId")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "stepId", valid_594277
  var valid_594278 = path.getOrDefault("projectId")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "projectId", valid_594278
  var valid_594279 = path.getOrDefault("sampleSeriesId")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "sampleSeriesId", valid_594279
  var valid_594280 = path.getOrDefault("historyId")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "historyId", valid_594280
  var valid_594281 = path.getOrDefault("executionId")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "executionId", valid_594281
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594282 = query.getOrDefault("fields")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "fields", valid_594282
  var valid_594283 = query.getOrDefault("quotaUser")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "quotaUser", valid_594283
  var valid_594284 = query.getOrDefault("alt")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = newJString("json"))
  if valid_594284 != nil:
    section.add "alt", valid_594284
  var valid_594285 = query.getOrDefault("oauth_token")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "oauth_token", valid_594285
  var valid_594286 = query.getOrDefault("userIp")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "userIp", valid_594286
  var valid_594287 = query.getOrDefault("key")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "key", valid_594287
  var valid_594288 = query.getOrDefault("prettyPrint")
  valid_594288 = validateParameter(valid_594288, JBool, required = false,
                                 default = newJBool(true))
  if valid_594288 != nil:
    section.add "prettyPrint", valid_594288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594289: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_594274;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfSampleSeries does not exist
  ## 
  let valid = call_594289.validator(path, query, header, formData, body)
  let scheme = call_594289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594289.url(scheme.get, call_594289.host, call_594289.base,
                         call_594289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594289, url, valid)

proc call*(call_594290: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_594274;
          stepId: string; projectId: string; sampleSeriesId: string;
          historyId: string; executionId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet
  ## Gets a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfSampleSeries does not exist
  ##   stepId: string (required)
  ##         : A tool results step ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The cloud project
  ##   sampleSeriesId: string (required)
  ##                 : A sample series id
  ##   historyId: string (required)
  ##            : A tool results history ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : A tool results execution ID.
  var path_594291 = newJObject()
  var query_594292 = newJObject()
  add(path_594291, "stepId", newJString(stepId))
  add(query_594292, "fields", newJString(fields))
  add(query_594292, "quotaUser", newJString(quotaUser))
  add(query_594292, "alt", newJString(alt))
  add(query_594292, "oauth_token", newJString(oauthToken))
  add(query_594292, "userIp", newJString(userIp))
  add(query_594292, "key", newJString(key))
  add(path_594291, "projectId", newJString(projectId))
  add(path_594291, "sampleSeriesId", newJString(sampleSeriesId))
  add(path_594291, "historyId", newJString(historyId))
  add(query_594292, "prettyPrint", newJBool(prettyPrint))
  add(path_594291, "executionId", newJString(executionId))
  result = call_594290.call(path_594291, query_594292, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_594274(
    name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries/{sampleSeriesId}", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_594275,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_594276,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_594293 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_594295(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  assert "stepId" in path, "`stepId` is a required path parameter"
  assert "sampleSeriesId" in path, "`sampleSeriesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepId"),
               (kind: ConstantSegment, value: "/perfSampleSeries/"),
               (kind: VariableSegment, value: "sampleSeriesId"),
               (kind: ConstantSegment, value: "/samples")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_594294(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the Performance Samples of a given Sample Series - The list results are sorted by timestamps ascending - The default page size is 500 samples; and maximum size allowed 5000 - The response token indicates the last returned PerfSample timestamp - When the results size exceeds the page size, submit a subsequent request including the page token to return the rest of the samples up to the page limit
  ## 
  ## May return any of the following canonical error codes: - OUT_OF_RANGE - The specified request page_token is out of valid range - NOT_FOUND - The containing PerfSampleSeries does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stepId: JString (required)
  ##         : A tool results step ID.
  ##   projectId: JString (required)
  ##            : The cloud project
  ##   sampleSeriesId: JString (required)
  ##                 : A sample series id
  ##   historyId: JString (required)
  ##            : A tool results history ID.
  ##   executionId: JString (required)
  ##              : A tool results execution ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stepId` field"
  var valid_594296 = path.getOrDefault("stepId")
  valid_594296 = validateParameter(valid_594296, JString, required = true,
                                 default = nil)
  if valid_594296 != nil:
    section.add "stepId", valid_594296
  var valid_594297 = path.getOrDefault("projectId")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "projectId", valid_594297
  var valid_594298 = path.getOrDefault("sampleSeriesId")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "sampleSeriesId", valid_594298
  var valid_594299 = path.getOrDefault("historyId")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "historyId", valid_594299
  var valid_594300 = path.getOrDefault("executionId")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "executionId", valid_594300
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional, the next_page_token returned in the previous response
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pageSize: JInt
  ##           : The default page size is 500 samples, and the maximum size is 5000. If the page_size is greater than 5000, the effective page size will be 5000
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594301 = query.getOrDefault("fields")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "fields", valid_594301
  var valid_594302 = query.getOrDefault("pageToken")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "pageToken", valid_594302
  var valid_594303 = query.getOrDefault("quotaUser")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "quotaUser", valid_594303
  var valid_594304 = query.getOrDefault("alt")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = newJString("json"))
  if valid_594304 != nil:
    section.add "alt", valid_594304
  var valid_594305 = query.getOrDefault("oauth_token")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "oauth_token", valid_594305
  var valid_594306 = query.getOrDefault("userIp")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "userIp", valid_594306
  var valid_594307 = query.getOrDefault("key")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = nil)
  if valid_594307 != nil:
    section.add "key", valid_594307
  var valid_594308 = query.getOrDefault("pageSize")
  valid_594308 = validateParameter(valid_594308, JInt, required = false, default = nil)
  if valid_594308 != nil:
    section.add "pageSize", valid_594308
  var valid_594309 = query.getOrDefault("prettyPrint")
  valid_594309 = validateParameter(valid_594309, JBool, required = false,
                                 default = newJBool(true))
  if valid_594309 != nil:
    section.add "prettyPrint", valid_594309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594310: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_594293;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Performance Samples of a given Sample Series - The list results are sorted by timestamps ascending - The default page size is 500 samples; and maximum size allowed 5000 - The response token indicates the last returned PerfSample timestamp - When the results size exceeds the page size, submit a subsequent request including the page token to return the rest of the samples up to the page limit
  ## 
  ## May return any of the following canonical error codes: - OUT_OF_RANGE - The specified request page_token is out of valid range - NOT_FOUND - The containing PerfSampleSeries does not exist
  ## 
  let valid = call_594310.validator(path, query, header, formData, body)
  let scheme = call_594310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594310.url(scheme.get, call_594310.host, call_594310.base,
                         call_594310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594310, url, valid)

proc call*(call_594311: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_594293;
          stepId: string; projectId: string; sampleSeriesId: string;
          historyId: string; executionId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = ""; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList
  ## Lists the Performance Samples of a given Sample Series - The list results are sorted by timestamps ascending - The default page size is 500 samples; and maximum size allowed 5000 - The response token indicates the last returned PerfSample timestamp - When the results size exceeds the page size, submit a subsequent request including the page token to return the rest of the samples up to the page limit
  ## 
  ## May return any of the following canonical error codes: - OUT_OF_RANGE - The specified request page_token is out of valid range - NOT_FOUND - The containing PerfSampleSeries does not exist
  ##   stepId: string (required)
  ##         : A tool results step ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional, the next_page_token returned in the previous response
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The cloud project
  ##   sampleSeriesId: string (required)
  ##                 : A sample series id
  ##   pageSize: int
  ##           : The default page size is 500 samples, and the maximum size is 5000. If the page_size is greater than 5000, the effective page size will be 5000
  ##   historyId: string (required)
  ##            : A tool results history ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : A tool results execution ID.
  var path_594312 = newJObject()
  var query_594313 = newJObject()
  add(path_594312, "stepId", newJString(stepId))
  add(query_594313, "fields", newJString(fields))
  add(query_594313, "pageToken", newJString(pageToken))
  add(query_594313, "quotaUser", newJString(quotaUser))
  add(query_594313, "alt", newJString(alt))
  add(query_594313, "oauth_token", newJString(oauthToken))
  add(query_594313, "userIp", newJString(userIp))
  add(query_594313, "key", newJString(key))
  add(path_594312, "projectId", newJString(projectId))
  add(path_594312, "sampleSeriesId", newJString(sampleSeriesId))
  add(query_594313, "pageSize", newJInt(pageSize))
  add(path_594312, "historyId", newJString(historyId))
  add(query_594313, "prettyPrint", newJBool(prettyPrint))
  add(path_594312, "executionId", newJString(executionId))
  result = call_594311.call(path_594312, query_594313, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_594293(name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries/{sampleSeriesId}/samples", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_594294,
    base: "/toolresults/v1beta3firstparty/projects", url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_594295,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_594314 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_594316(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  assert "stepId" in path, "`stepId` is a required path parameter"
  assert "sampleSeriesId" in path, "`sampleSeriesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepId"),
               (kind: ConstantSegment, value: "/perfSampleSeries/"),
               (kind: VariableSegment, value: "sampleSeriesId"),
               (kind: ConstantSegment, value: "/samples:batchCreate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_594315(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a batch of PerfSamples - a client can submit multiple batches of Perf Samples through repeated calls to this method in order to split up a large request payload - duplicates and existing timestamp entries will be ignored. - the batch operation may partially succeed - the set of elements successfully inserted is returned in the response (omits items which already existed in the database).
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing PerfSampleSeries does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stepId: JString (required)
  ##         : A tool results step ID.
  ##   projectId: JString (required)
  ##            : The cloud project
  ##   sampleSeriesId: JString (required)
  ##                 : A sample series id
  ##   historyId: JString (required)
  ##            : A tool results history ID.
  ##   executionId: JString (required)
  ##              : A tool results execution ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stepId` field"
  var valid_594317 = path.getOrDefault("stepId")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "stepId", valid_594317
  var valid_594318 = path.getOrDefault("projectId")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "projectId", valid_594318
  var valid_594319 = path.getOrDefault("sampleSeriesId")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "sampleSeriesId", valid_594319
  var valid_594320 = path.getOrDefault("historyId")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "historyId", valid_594320
  var valid_594321 = path.getOrDefault("executionId")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "executionId", valid_594321
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594322 = query.getOrDefault("fields")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = nil)
  if valid_594322 != nil:
    section.add "fields", valid_594322
  var valid_594323 = query.getOrDefault("quotaUser")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "quotaUser", valid_594323
  var valid_594324 = query.getOrDefault("alt")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = newJString("json"))
  if valid_594324 != nil:
    section.add "alt", valid_594324
  var valid_594325 = query.getOrDefault("oauth_token")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = nil)
  if valid_594325 != nil:
    section.add "oauth_token", valid_594325
  var valid_594326 = query.getOrDefault("userIp")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = nil)
  if valid_594326 != nil:
    section.add "userIp", valid_594326
  var valid_594327 = query.getOrDefault("key")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = nil)
  if valid_594327 != nil:
    section.add "key", valid_594327
  var valid_594328 = query.getOrDefault("prettyPrint")
  valid_594328 = validateParameter(valid_594328, JBool, required = false,
                                 default = newJBool(true))
  if valid_594328 != nil:
    section.add "prettyPrint", valid_594328
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

proc call*(call_594330: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_594314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a batch of PerfSamples - a client can submit multiple batches of Perf Samples through repeated calls to this method in order to split up a large request payload - duplicates and existing timestamp entries will be ignored. - the batch operation may partially succeed - the set of elements successfully inserted is returned in the response (omits items which already existed in the database).
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing PerfSampleSeries does not exist
  ## 
  let valid = call_594330.validator(path, query, header, formData, body)
  let scheme = call_594330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594330.url(scheme.get, call_594330.host, call_594330.base,
                         call_594330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594330, url, valid)

proc call*(call_594331: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_594314;
          stepId: string; projectId: string; sampleSeriesId: string;
          historyId: string; executionId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate
  ## Creates a batch of PerfSamples - a client can submit multiple batches of Perf Samples through repeated calls to this method in order to split up a large request payload - duplicates and existing timestamp entries will be ignored. - the batch operation may partially succeed - the set of elements successfully inserted is returned in the response (omits items which already existed in the database).
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing PerfSampleSeries does not exist
  ##   stepId: string (required)
  ##         : A tool results step ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The cloud project
  ##   sampleSeriesId: string (required)
  ##                 : A sample series id
  ##   historyId: string (required)
  ##            : A tool results history ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : A tool results execution ID.
  var path_594332 = newJObject()
  var query_594333 = newJObject()
  var body_594334 = newJObject()
  add(path_594332, "stepId", newJString(stepId))
  add(query_594333, "fields", newJString(fields))
  add(query_594333, "quotaUser", newJString(quotaUser))
  add(query_594333, "alt", newJString(alt))
  add(query_594333, "oauth_token", newJString(oauthToken))
  add(query_594333, "userIp", newJString(userIp))
  add(query_594333, "key", newJString(key))
  add(path_594332, "projectId", newJString(projectId))
  add(path_594332, "sampleSeriesId", newJString(sampleSeriesId))
  add(path_594332, "historyId", newJString(historyId))
  if body != nil:
    body_594334 = body
  add(query_594333, "prettyPrint", newJBool(prettyPrint))
  add(path_594332, "executionId", newJString(executionId))
  result = call_594331.call(path_594332, query_594333, nil, nil, body_594334)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_594314(name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries/{sampleSeriesId}/samples:batchCreate", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_594315,
    base: "/toolresults/v1beta3firstparty/projects", url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_594316,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_594335 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_594337(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  assert "stepId" in path, "`stepId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepId"),
               (kind: ConstantSegment, value: "/thumbnails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_594336(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists thumbnails of images attached to a step.
  ## 
  ## May return any of the following canonical error codes: - PERMISSION_DENIED - if the user is not authorized to read from the project, or from any of the images - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the step does not exist, or if any of the images do not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stepId: JString (required)
  ##         : A Step id.
  ## 
  ## Required.
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : An Execution id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stepId` field"
  var valid_594338 = path.getOrDefault("stepId")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "stepId", valid_594338
  var valid_594339 = path.getOrDefault("projectId")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "projectId", valid_594339
  var valid_594340 = path.getOrDefault("historyId")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "historyId", valid_594340
  var valid_594341 = path.getOrDefault("executionId")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "executionId", valid_594341
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pageSize: JInt
  ##           : The maximum number of thumbnails to fetch.
  ## 
  ## Default value: 50. The server will use this default if the field is not set or has a value of 0.
  ## 
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594342 = query.getOrDefault("fields")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = nil)
  if valid_594342 != nil:
    section.add "fields", valid_594342
  var valid_594343 = query.getOrDefault("pageToken")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = nil)
  if valid_594343 != nil:
    section.add "pageToken", valid_594343
  var valid_594344 = query.getOrDefault("quotaUser")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = nil)
  if valid_594344 != nil:
    section.add "quotaUser", valid_594344
  var valid_594345 = query.getOrDefault("alt")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = newJString("json"))
  if valid_594345 != nil:
    section.add "alt", valid_594345
  var valid_594346 = query.getOrDefault("oauth_token")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = nil)
  if valid_594346 != nil:
    section.add "oauth_token", valid_594346
  var valid_594347 = query.getOrDefault("userIp")
  valid_594347 = validateParameter(valid_594347, JString, required = false,
                                 default = nil)
  if valid_594347 != nil:
    section.add "userIp", valid_594347
  var valid_594348 = query.getOrDefault("key")
  valid_594348 = validateParameter(valid_594348, JString, required = false,
                                 default = nil)
  if valid_594348 != nil:
    section.add "key", valid_594348
  var valid_594349 = query.getOrDefault("pageSize")
  valid_594349 = validateParameter(valid_594349, JInt, required = false, default = nil)
  if valid_594349 != nil:
    section.add "pageSize", valid_594349
  var valid_594350 = query.getOrDefault("prettyPrint")
  valid_594350 = validateParameter(valid_594350, JBool, required = false,
                                 default = newJBool(true))
  if valid_594350 != nil:
    section.add "prettyPrint", valid_594350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594351: Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_594335;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists thumbnails of images attached to a step.
  ## 
  ## May return any of the following canonical error codes: - PERMISSION_DENIED - if the user is not authorized to read from the project, or from any of the images - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the step does not exist, or if any of the images do not exist
  ## 
  let valid = call_594351.validator(path, query, header, formData, body)
  let scheme = call_594351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594351.url(scheme.get, call_594351.host, call_594351.base,
                         call_594351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594351, url, valid)

proc call*(call_594352: Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_594335;
          stepId: string; projectId: string; historyId: string; executionId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsThumbnailsList
  ## Lists thumbnails of images attached to a step.
  ## 
  ## May return any of the following canonical error codes: - PERMISSION_DENIED - if the user is not authorized to read from the project, or from any of the images - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the step does not exist, or if any of the images do not exist
  ##   stepId: string (required)
  ##         : A Step id.
  ## 
  ## Required.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   pageSize: int
  ##           : The maximum number of thumbnails to fetch.
  ## 
  ## Default value: 50. The server will use this default if the field is not set or has a value of 0.
  ## 
  ## Optional.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : An Execution id.
  ## 
  ## Required.
  var path_594353 = newJObject()
  var query_594354 = newJObject()
  add(path_594353, "stepId", newJString(stepId))
  add(query_594354, "fields", newJString(fields))
  add(query_594354, "pageToken", newJString(pageToken))
  add(query_594354, "quotaUser", newJString(quotaUser))
  add(query_594354, "alt", newJString(alt))
  add(query_594354, "oauth_token", newJString(oauthToken))
  add(query_594354, "userIp", newJString(userIp))
  add(query_594354, "key", newJString(key))
  add(path_594353, "projectId", newJString(projectId))
  add(query_594354, "pageSize", newJInt(pageSize))
  add(path_594353, "historyId", newJString(historyId))
  add(query_594354, "prettyPrint", newJBool(prettyPrint))
  add(path_594353, "executionId", newJString(executionId))
  result = call_594352.call(path_594353, query_594354, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsThumbnailsList* = Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_594335(
    name: "toolresultsProjectsHistoriesExecutionsStepsThumbnailsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/thumbnails", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_594336,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_594337,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_594355 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_594357(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "historyId" in path, "`historyId` is a required path parameter"
  assert "executionId" in path, "`executionId` is a required path parameter"
  assert "stepId" in path, "`stepId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepId"),
               (kind: ConstantSegment, value: ":publishXunitXmlFiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_594356(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Publish xml files to an existing Step.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal, e.g try to upload a duplicate xml file or a file too large. - NOT_FOUND - if the containing Execution does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stepId: JString (required)
  ##         : A Step id. Note: This step must include a TestExecutionStep.
  ## 
  ## Required.
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : A Execution id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stepId` field"
  var valid_594358 = path.getOrDefault("stepId")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "stepId", valid_594358
  var valid_594359 = path.getOrDefault("projectId")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "projectId", valid_594359
  var valid_594360 = path.getOrDefault("historyId")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "historyId", valid_594360
  var valid_594361 = path.getOrDefault("executionId")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "executionId", valid_594361
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594362 = query.getOrDefault("fields")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = nil)
  if valid_594362 != nil:
    section.add "fields", valid_594362
  var valid_594363 = query.getOrDefault("quotaUser")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = nil)
  if valid_594363 != nil:
    section.add "quotaUser", valid_594363
  var valid_594364 = query.getOrDefault("alt")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = newJString("json"))
  if valid_594364 != nil:
    section.add "alt", valid_594364
  var valid_594365 = query.getOrDefault("oauth_token")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = nil)
  if valid_594365 != nil:
    section.add "oauth_token", valid_594365
  var valid_594366 = query.getOrDefault("userIp")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "userIp", valid_594366
  var valid_594367 = query.getOrDefault("key")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = nil)
  if valid_594367 != nil:
    section.add "key", valid_594367
  var valid_594368 = query.getOrDefault("prettyPrint")
  valid_594368 = validateParameter(valid_594368, JBool, required = false,
                                 default = newJBool(true))
  if valid_594368 != nil:
    section.add "prettyPrint", valid_594368
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

proc call*(call_594370: Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_594355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Publish xml files to an existing Step.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal, e.g try to upload a duplicate xml file or a file too large. - NOT_FOUND - if the containing Execution does not exist
  ## 
  let valid = call_594370.validator(path, query, header, formData, body)
  let scheme = call_594370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594370.url(scheme.get, call_594370.host, call_594370.base,
                         call_594370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594370, url, valid)

proc call*(call_594371: Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_594355;
          stepId: string; projectId: string; historyId: string; executionId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles
  ## Publish xml files to an existing Step.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal, e.g try to upload a duplicate xml file or a file too large. - NOT_FOUND - if the containing Execution does not exist
  ##   stepId: string (required)
  ##         : A Step id. Note: This step must include a TestExecutionStep.
  ## 
  ## Required.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   executionId: string (required)
  ##              : A Execution id.
  ## 
  ## Required.
  var path_594372 = newJObject()
  var query_594373 = newJObject()
  var body_594374 = newJObject()
  add(path_594372, "stepId", newJString(stepId))
  add(query_594373, "fields", newJString(fields))
  add(query_594373, "quotaUser", newJString(quotaUser))
  add(query_594373, "alt", newJString(alt))
  add(query_594373, "oauth_token", newJString(oauthToken))
  add(query_594373, "userIp", newJString(userIp))
  add(query_594373, "key", newJString(key))
  add(path_594372, "projectId", newJString(projectId))
  add(path_594372, "historyId", newJString(historyId))
  if body != nil:
    body_594374 = body
  add(query_594373, "prettyPrint", newJBool(prettyPrint))
  add(path_594372, "executionId", newJString(executionId))
  result = call_594371.call(path_594372, query_594373, nil, nil, body_594374)

var toolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles* = Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_594355(
    name: "toolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}:publishXunitXmlFiles", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_594356,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_594357,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsGetSettings_594375 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsGetSettings_594377(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/settings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsGetSettings_594376(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Tool Results settings for a project.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read from project
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_594378 = path.getOrDefault("projectId")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "projectId", valid_594378
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594379 = query.getOrDefault("fields")
  valid_594379 = validateParameter(valid_594379, JString, required = false,
                                 default = nil)
  if valid_594379 != nil:
    section.add "fields", valid_594379
  var valid_594380 = query.getOrDefault("quotaUser")
  valid_594380 = validateParameter(valid_594380, JString, required = false,
                                 default = nil)
  if valid_594380 != nil:
    section.add "quotaUser", valid_594380
  var valid_594381 = query.getOrDefault("alt")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = newJString("json"))
  if valid_594381 != nil:
    section.add "alt", valid_594381
  var valid_594382 = query.getOrDefault("oauth_token")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "oauth_token", valid_594382
  var valid_594383 = query.getOrDefault("userIp")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = nil)
  if valid_594383 != nil:
    section.add "userIp", valid_594383
  var valid_594384 = query.getOrDefault("key")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = nil)
  if valid_594384 != nil:
    section.add "key", valid_594384
  var valid_594385 = query.getOrDefault("prettyPrint")
  valid_594385 = validateParameter(valid_594385, JBool, required = false,
                                 default = newJBool(true))
  if valid_594385 != nil:
    section.add "prettyPrint", valid_594385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594386: Call_ToolresultsProjectsGetSettings_594375; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Tool Results settings for a project.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read from project
  ## 
  let valid = call_594386.validator(path, query, header, formData, body)
  let scheme = call_594386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594386.url(scheme.get, call_594386.host, call_594386.base,
                         call_594386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594386, url, valid)

proc call*(call_594387: Call_ToolresultsProjectsGetSettings_594375;
          projectId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsGetSettings
  ## Gets the Tool Results settings for a project.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read from project
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594388 = newJObject()
  var query_594389 = newJObject()
  add(query_594389, "fields", newJString(fields))
  add(query_594389, "quotaUser", newJString(quotaUser))
  add(query_594389, "alt", newJString(alt))
  add(query_594389, "oauth_token", newJString(oauthToken))
  add(query_594389, "userIp", newJString(userIp))
  add(query_594389, "key", newJString(key))
  add(path_594388, "projectId", newJString(projectId))
  add(query_594389, "prettyPrint", newJBool(prettyPrint))
  result = call_594387.call(path_594388, query_594389, nil, nil, nil)

var toolresultsProjectsGetSettings* = Call_ToolresultsProjectsGetSettings_594375(
    name: "toolresultsProjectsGetSettings", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectId}/settings",
    validator: validate_ToolresultsProjectsGetSettings_594376,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsGetSettings_594377, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsInitializeSettings_594390 = ref object of OpenApiRestCall_593421
proc url_ToolresultsProjectsInitializeSettings_594392(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":initializeSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsInitializeSettings_594391(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates resources for settings which have not yet been set.
  ## 
  ## Currently, this creates a single resource: a Google Cloud Storage bucket, to be used as the default bucket for this project. The bucket is created in an FTL-own storage project. Except for in rare cases, calling this method in parallel from multiple clients will only create a single bucket. In order to avoid unnecessary storage charges, the bucket is configured to automatically delete objects older than 90 days.
  ## 
  ## The bucket is created with the following permissions: - Owner access for owners of central storage project (FTL-owned) - Writer access for owners/editors of customer project - Reader access for viewers of customer project The default ACL on objects created in the bucket is: - Owner access for owners of central storage project - Reader access for owners/editors/viewers of customer project See Google Cloud Storage documentation for more details.
  ## 
  ## If there is already a default bucket set and the project can access the bucket, this call does nothing. However, if the project doesn't have the permission to access the bucket or the bucket is deleted, a new bucket will be created.
  ## 
  ## May return any canonical error codes, including the following:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - Any error code raised by Google Cloud Storage
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_594393 = path.getOrDefault("projectId")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "projectId", valid_594393
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594394 = query.getOrDefault("fields")
  valid_594394 = validateParameter(valid_594394, JString, required = false,
                                 default = nil)
  if valid_594394 != nil:
    section.add "fields", valid_594394
  var valid_594395 = query.getOrDefault("quotaUser")
  valid_594395 = validateParameter(valid_594395, JString, required = false,
                                 default = nil)
  if valid_594395 != nil:
    section.add "quotaUser", valid_594395
  var valid_594396 = query.getOrDefault("alt")
  valid_594396 = validateParameter(valid_594396, JString, required = false,
                                 default = newJString("json"))
  if valid_594396 != nil:
    section.add "alt", valid_594396
  var valid_594397 = query.getOrDefault("oauth_token")
  valid_594397 = validateParameter(valid_594397, JString, required = false,
                                 default = nil)
  if valid_594397 != nil:
    section.add "oauth_token", valid_594397
  var valid_594398 = query.getOrDefault("userIp")
  valid_594398 = validateParameter(valid_594398, JString, required = false,
                                 default = nil)
  if valid_594398 != nil:
    section.add "userIp", valid_594398
  var valid_594399 = query.getOrDefault("key")
  valid_594399 = validateParameter(valid_594399, JString, required = false,
                                 default = nil)
  if valid_594399 != nil:
    section.add "key", valid_594399
  var valid_594400 = query.getOrDefault("prettyPrint")
  valid_594400 = validateParameter(valid_594400, JBool, required = false,
                                 default = newJBool(true))
  if valid_594400 != nil:
    section.add "prettyPrint", valid_594400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594401: Call_ToolresultsProjectsInitializeSettings_594390;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates resources for settings which have not yet been set.
  ## 
  ## Currently, this creates a single resource: a Google Cloud Storage bucket, to be used as the default bucket for this project. The bucket is created in an FTL-own storage project. Except for in rare cases, calling this method in parallel from multiple clients will only create a single bucket. In order to avoid unnecessary storage charges, the bucket is configured to automatically delete objects older than 90 days.
  ## 
  ## The bucket is created with the following permissions: - Owner access for owners of central storage project (FTL-owned) - Writer access for owners/editors of customer project - Reader access for viewers of customer project The default ACL on objects created in the bucket is: - Owner access for owners of central storage project - Reader access for owners/editors/viewers of customer project See Google Cloud Storage documentation for more details.
  ## 
  ## If there is already a default bucket set and the project can access the bucket, this call does nothing. However, if the project doesn't have the permission to access the bucket or the bucket is deleted, a new bucket will be created.
  ## 
  ## May return any canonical error codes, including the following:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - Any error code raised by Google Cloud Storage
  ## 
  let valid = call_594401.validator(path, query, header, formData, body)
  let scheme = call_594401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594401.url(scheme.get, call_594401.host, call_594401.base,
                         call_594401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594401, url, valid)

proc call*(call_594402: Call_ToolresultsProjectsInitializeSettings_594390;
          projectId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## toolresultsProjectsInitializeSettings
  ## Creates resources for settings which have not yet been set.
  ## 
  ## Currently, this creates a single resource: a Google Cloud Storage bucket, to be used as the default bucket for this project. The bucket is created in an FTL-own storage project. Except for in rare cases, calling this method in parallel from multiple clients will only create a single bucket. In order to avoid unnecessary storage charges, the bucket is configured to automatically delete objects older than 90 days.
  ## 
  ## The bucket is created with the following permissions: - Owner access for owners of central storage project (FTL-owned) - Writer access for owners/editors of customer project - Reader access for viewers of customer project The default ACL on objects created in the bucket is: - Owner access for owners of central storage project - Reader access for owners/editors/viewers of customer project See Google Cloud Storage documentation for more details.
  ## 
  ## If there is already a default bucket set and the project can access the bucket, this call does nothing. However, if the project doesn't have the permission to access the bucket or the bucket is deleted, a new bucket will be created.
  ## 
  ## May return any canonical error codes, including the following:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - Any error code raised by Google Cloud Storage
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594403 = newJObject()
  var query_594404 = newJObject()
  add(query_594404, "fields", newJString(fields))
  add(query_594404, "quotaUser", newJString(quotaUser))
  add(query_594404, "alt", newJString(alt))
  add(query_594404, "oauth_token", newJString(oauthToken))
  add(query_594404, "userIp", newJString(userIp))
  add(query_594404, "key", newJString(key))
  add(path_594403, "projectId", newJString(projectId))
  add(query_594404, "prettyPrint", newJBool(prettyPrint))
  result = call_594402.call(path_594403, query_594404, nil, nil, nil)

var toolresultsProjectsInitializeSettings* = Call_ToolresultsProjectsInitializeSettings_594390(
    name: "toolresultsProjectsInitializeSettings", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectId}:initializeSettings",
    validator: validate_ToolresultsProjectsInitializeSettings_594391,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsInitializeSettings_594392, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
