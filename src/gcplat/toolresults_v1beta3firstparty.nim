
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  gcpServiceName = "toolresults"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ToolresultsProjectsHistoriesCreate_579976 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesCreate_579978(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesCreate_579977(path: JsonNode;
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
  var valid_579979 = path.getOrDefault("projectId")
  valid_579979 = validateParameter(valid_579979, JString, required = true,
                                 default = nil)
  if valid_579979 != nil:
    section.add "projectId", valid_579979
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
  var valid_579980 = query.getOrDefault("fields")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "fields", valid_579980
  var valid_579981 = query.getOrDefault("requestId")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "requestId", valid_579981
  var valid_579982 = query.getOrDefault("quotaUser")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "quotaUser", valid_579982
  var valid_579983 = query.getOrDefault("alt")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("json"))
  if valid_579983 != nil:
    section.add "alt", valid_579983
  var valid_579984 = query.getOrDefault("oauth_token")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "oauth_token", valid_579984
  var valid_579985 = query.getOrDefault("userIp")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "userIp", valid_579985
  var valid_579986 = query.getOrDefault("key")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "key", valid_579986
  var valid_579987 = query.getOrDefault("prettyPrint")
  valid_579987 = validateParameter(valid_579987, JBool, required = false,
                                 default = newJBool(true))
  if valid_579987 != nil:
    section.add "prettyPrint", valid_579987
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

proc call*(call_579989: Call_ToolresultsProjectsHistoriesCreate_579976;
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
  let valid = call_579989.validator(path, query, header, formData, body)
  let scheme = call_579989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579989.url(scheme.get, call_579989.host, call_579989.base,
                         call_579989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579989, url, valid)

proc call*(call_579990: Call_ToolresultsProjectsHistoriesCreate_579976;
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
  var path_579991 = newJObject()
  var query_579992 = newJObject()
  var body_579993 = newJObject()
  add(query_579992, "fields", newJString(fields))
  add(query_579992, "requestId", newJString(requestId))
  add(query_579992, "quotaUser", newJString(quotaUser))
  add(query_579992, "alt", newJString(alt))
  add(query_579992, "oauth_token", newJString(oauthToken))
  add(query_579992, "userIp", newJString(userIp))
  add(query_579992, "key", newJString(key))
  add(path_579991, "projectId", newJString(projectId))
  if body != nil:
    body_579993 = body
  add(query_579992, "prettyPrint", newJBool(prettyPrint))
  result = call_579990.call(path_579991, query_579992, nil, nil, body_579993)

var toolresultsProjectsHistoriesCreate* = Call_ToolresultsProjectsHistoriesCreate_579976(
    name: "toolresultsProjectsHistoriesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectId}/histories",
    validator: validate_ToolresultsProjectsHistoriesCreate_579977,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesCreate_579978, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesList_579689 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesList_579691(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesList_579690(path: JsonNode;
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
  var valid_579817 = path.getOrDefault("projectId")
  valid_579817 = validateParameter(valid_579817, JString, required = true,
                                 default = nil)
  if valid_579817 != nil:
    section.add "projectId", valid_579817
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
  var valid_579818 = query.getOrDefault("fields")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = nil)
  if valid_579818 != nil:
    section.add "fields", valid_579818
  var valid_579819 = query.getOrDefault("pageToken")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "pageToken", valid_579819
  var valid_579820 = query.getOrDefault("quotaUser")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "quotaUser", valid_579820
  var valid_579834 = query.getOrDefault("alt")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = newJString("json"))
  if valid_579834 != nil:
    section.add "alt", valid_579834
  var valid_579835 = query.getOrDefault("oauth_token")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "oauth_token", valid_579835
  var valid_579836 = query.getOrDefault("userIp")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "userIp", valid_579836
  var valid_579837 = query.getOrDefault("key")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "key", valid_579837
  var valid_579838 = query.getOrDefault("pageSize")
  valid_579838 = validateParameter(valid_579838, JInt, required = false, default = nil)
  if valid_579838 != nil:
    section.add "pageSize", valid_579838
  var valid_579839 = query.getOrDefault("filterByName")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "filterByName", valid_579839
  var valid_579840 = query.getOrDefault("prettyPrint")
  valid_579840 = validateParameter(valid_579840, JBool, required = false,
                                 default = newJBool(true))
  if valid_579840 != nil:
    section.add "prettyPrint", valid_579840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579863: Call_ToolresultsProjectsHistoriesList_579689;
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
  let valid = call_579863.validator(path, query, header, formData, body)
  let scheme = call_579863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579863.url(scheme.get, call_579863.host, call_579863.base,
                         call_579863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579863, url, valid)

proc call*(call_579934: Call_ToolresultsProjectsHistoriesList_579689;
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
  var path_579935 = newJObject()
  var query_579937 = newJObject()
  add(query_579937, "fields", newJString(fields))
  add(query_579937, "pageToken", newJString(pageToken))
  add(query_579937, "quotaUser", newJString(quotaUser))
  add(query_579937, "alt", newJString(alt))
  add(query_579937, "oauth_token", newJString(oauthToken))
  add(query_579937, "userIp", newJString(userIp))
  add(query_579937, "key", newJString(key))
  add(path_579935, "projectId", newJString(projectId))
  add(query_579937, "pageSize", newJInt(pageSize))
  add(query_579937, "filterByName", newJString(filterByName))
  add(query_579937, "prettyPrint", newJBool(prettyPrint))
  result = call_579934.call(path_579935, query_579937, nil, nil, nil)

var toolresultsProjectsHistoriesList* = Call_ToolresultsProjectsHistoriesList_579689(
    name: "toolresultsProjectsHistoriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectId}/histories",
    validator: validate_ToolresultsProjectsHistoriesList_579690,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesList_579691, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesGet_579994 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesGet_579996(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesGet_579995(path: JsonNode;
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
  var valid_579997 = path.getOrDefault("projectId")
  valid_579997 = validateParameter(valid_579997, JString, required = true,
                                 default = nil)
  if valid_579997 != nil:
    section.add "projectId", valid_579997
  var valid_579998 = path.getOrDefault("historyId")
  valid_579998 = validateParameter(valid_579998, JString, required = true,
                                 default = nil)
  if valid_579998 != nil:
    section.add "historyId", valid_579998
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
  var valid_579999 = query.getOrDefault("fields")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "fields", valid_579999
  var valid_580000 = query.getOrDefault("quotaUser")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "quotaUser", valid_580000
  var valid_580001 = query.getOrDefault("alt")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("json"))
  if valid_580001 != nil:
    section.add "alt", valid_580001
  var valid_580002 = query.getOrDefault("oauth_token")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "oauth_token", valid_580002
  var valid_580003 = query.getOrDefault("userIp")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "userIp", valid_580003
  var valid_580004 = query.getOrDefault("key")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "key", valid_580004
  var valid_580005 = query.getOrDefault("prettyPrint")
  valid_580005 = validateParameter(valid_580005, JBool, required = false,
                                 default = newJBool(true))
  if valid_580005 != nil:
    section.add "prettyPrint", valid_580005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580006: Call_ToolresultsProjectsHistoriesGet_579994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a History.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the History does not exist
  ## 
  let valid = call_580006.validator(path, query, header, formData, body)
  let scheme = call_580006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580006.url(scheme.get, call_580006.host, call_580006.base,
                         call_580006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580006, url, valid)

proc call*(call_580007: Call_ToolresultsProjectsHistoriesGet_579994;
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
  var path_580008 = newJObject()
  var query_580009 = newJObject()
  add(query_580009, "fields", newJString(fields))
  add(query_580009, "quotaUser", newJString(quotaUser))
  add(query_580009, "alt", newJString(alt))
  add(query_580009, "oauth_token", newJString(oauthToken))
  add(query_580009, "userIp", newJString(userIp))
  add(query_580009, "key", newJString(key))
  add(path_580008, "projectId", newJString(projectId))
  add(path_580008, "historyId", newJString(historyId))
  add(query_580009, "prettyPrint", newJBool(prettyPrint))
  result = call_580007.call(path_580008, query_580009, nil, nil, nil)

var toolresultsProjectsHistoriesGet* = Call_ToolresultsProjectsHistoriesGet_579994(
    name: "toolresultsProjectsHistoriesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}",
    validator: validate_ToolresultsProjectsHistoriesGet_579995,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesGet_579996, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsCreate_580028 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsCreate_580030(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsCreate_580029(path: JsonNode;
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
  var valid_580031 = path.getOrDefault("projectId")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "projectId", valid_580031
  var valid_580032 = path.getOrDefault("historyId")
  valid_580032 = validateParameter(valid_580032, JString, required = true,
                                 default = nil)
  if valid_580032 != nil:
    section.add "historyId", valid_580032
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
  var valid_580033 = query.getOrDefault("fields")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "fields", valid_580033
  var valid_580034 = query.getOrDefault("requestId")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "requestId", valid_580034
  var valid_580035 = query.getOrDefault("quotaUser")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "quotaUser", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("oauth_token")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "oauth_token", valid_580037
  var valid_580038 = query.getOrDefault("userIp")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "userIp", valid_580038
  var valid_580039 = query.getOrDefault("key")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "key", valid_580039
  var valid_580040 = query.getOrDefault("prettyPrint")
  valid_580040 = validateParameter(valid_580040, JBool, required = false,
                                 default = newJBool(true))
  if valid_580040 != nil:
    section.add "prettyPrint", valid_580040
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

proc call*(call_580042: Call_ToolresultsProjectsHistoriesExecutionsCreate_580028;
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
  let valid = call_580042.validator(path, query, header, formData, body)
  let scheme = call_580042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580042.url(scheme.get, call_580042.host, call_580042.base,
                         call_580042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580042, url, valid)

proc call*(call_580043: Call_ToolresultsProjectsHistoriesExecutionsCreate_580028;
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
  var path_580044 = newJObject()
  var query_580045 = newJObject()
  var body_580046 = newJObject()
  add(query_580045, "fields", newJString(fields))
  add(query_580045, "requestId", newJString(requestId))
  add(query_580045, "quotaUser", newJString(quotaUser))
  add(query_580045, "alt", newJString(alt))
  add(query_580045, "oauth_token", newJString(oauthToken))
  add(query_580045, "userIp", newJString(userIp))
  add(query_580045, "key", newJString(key))
  add(path_580044, "projectId", newJString(projectId))
  add(path_580044, "historyId", newJString(historyId))
  if body != nil:
    body_580046 = body
  add(query_580045, "prettyPrint", newJBool(prettyPrint))
  result = call_580043.call(path_580044, query_580045, nil, nil, body_580046)

var toolresultsProjectsHistoriesExecutionsCreate* = Call_ToolresultsProjectsHistoriesExecutionsCreate_580028(
    name: "toolresultsProjectsHistoriesExecutionsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions",
    validator: validate_ToolresultsProjectsHistoriesExecutionsCreate_580029,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsCreate_580030,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsList_580010 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsList_580012(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsList_580011(path: JsonNode;
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
  var valid_580013 = path.getOrDefault("projectId")
  valid_580013 = validateParameter(valid_580013, JString, required = true,
                                 default = nil)
  if valid_580013 != nil:
    section.add "projectId", valid_580013
  var valid_580014 = path.getOrDefault("historyId")
  valid_580014 = validateParameter(valid_580014, JString, required = true,
                                 default = nil)
  if valid_580014 != nil:
    section.add "historyId", valid_580014
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
  var valid_580015 = query.getOrDefault("fields")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "fields", valid_580015
  var valid_580016 = query.getOrDefault("pageToken")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "pageToken", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("alt")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("json"))
  if valid_580018 != nil:
    section.add "alt", valid_580018
  var valid_580019 = query.getOrDefault("oauth_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "oauth_token", valid_580019
  var valid_580020 = query.getOrDefault("userIp")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "userIp", valid_580020
  var valid_580021 = query.getOrDefault("key")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "key", valid_580021
  var valid_580022 = query.getOrDefault("pageSize")
  valid_580022 = validateParameter(valid_580022, JInt, required = false, default = nil)
  if valid_580022 != nil:
    section.add "pageSize", valid_580022
  var valid_580023 = query.getOrDefault("prettyPrint")
  valid_580023 = validateParameter(valid_580023, JBool, required = false,
                                 default = newJBool(true))
  if valid_580023 != nil:
    section.add "prettyPrint", valid_580023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580024: Call_ToolresultsProjectsHistoriesExecutionsList_580010;
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
  let valid = call_580024.validator(path, query, header, formData, body)
  let scheme = call_580024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580024.url(scheme.get, call_580024.host, call_580024.base,
                         call_580024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580024, url, valid)

proc call*(call_580025: Call_ToolresultsProjectsHistoriesExecutionsList_580010;
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
  var path_580026 = newJObject()
  var query_580027 = newJObject()
  add(query_580027, "fields", newJString(fields))
  add(query_580027, "pageToken", newJString(pageToken))
  add(query_580027, "quotaUser", newJString(quotaUser))
  add(query_580027, "alt", newJString(alt))
  add(query_580027, "oauth_token", newJString(oauthToken))
  add(query_580027, "userIp", newJString(userIp))
  add(query_580027, "key", newJString(key))
  add(path_580026, "projectId", newJString(projectId))
  add(query_580027, "pageSize", newJInt(pageSize))
  add(path_580026, "historyId", newJString(historyId))
  add(query_580027, "prettyPrint", newJBool(prettyPrint))
  result = call_580025.call(path_580026, query_580027, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsList* = Call_ToolresultsProjectsHistoriesExecutionsList_580010(
    name: "toolresultsProjectsHistoriesExecutionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions",
    validator: validate_ToolresultsProjectsHistoriesExecutionsList_580011,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsList_580012,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsGet_580047 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsGet_580049(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsGet_580048(path: JsonNode;
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
  var valid_580050 = path.getOrDefault("projectId")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "projectId", valid_580050
  var valid_580051 = path.getOrDefault("historyId")
  valid_580051 = validateParameter(valid_580051, JString, required = true,
                                 default = nil)
  if valid_580051 != nil:
    section.add "historyId", valid_580051
  var valid_580052 = path.getOrDefault("executionId")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "executionId", valid_580052
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
  var valid_580053 = query.getOrDefault("fields")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "fields", valid_580053
  var valid_580054 = query.getOrDefault("quotaUser")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "quotaUser", valid_580054
  var valid_580055 = query.getOrDefault("alt")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("json"))
  if valid_580055 != nil:
    section.add "alt", valid_580055
  var valid_580056 = query.getOrDefault("oauth_token")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "oauth_token", valid_580056
  var valid_580057 = query.getOrDefault("userIp")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "userIp", valid_580057
  var valid_580058 = query.getOrDefault("key")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "key", valid_580058
  var valid_580059 = query.getOrDefault("prettyPrint")
  valid_580059 = validateParameter(valid_580059, JBool, required = false,
                                 default = newJBool(true))
  if valid_580059 != nil:
    section.add "prettyPrint", valid_580059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580060: Call_ToolresultsProjectsHistoriesExecutionsGet_580047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an Execution.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the Execution does not exist
  ## 
  let valid = call_580060.validator(path, query, header, formData, body)
  let scheme = call_580060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580060.url(scheme.get, call_580060.host, call_580060.base,
                         call_580060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580060, url, valid)

proc call*(call_580061: Call_ToolresultsProjectsHistoriesExecutionsGet_580047;
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
  var path_580062 = newJObject()
  var query_580063 = newJObject()
  add(query_580063, "fields", newJString(fields))
  add(query_580063, "quotaUser", newJString(quotaUser))
  add(query_580063, "alt", newJString(alt))
  add(query_580063, "oauth_token", newJString(oauthToken))
  add(query_580063, "userIp", newJString(userIp))
  add(query_580063, "key", newJString(key))
  add(path_580062, "projectId", newJString(projectId))
  add(path_580062, "historyId", newJString(historyId))
  add(query_580063, "prettyPrint", newJBool(prettyPrint))
  add(path_580062, "executionId", newJString(executionId))
  result = call_580061.call(path_580062, query_580063, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsGet* = Call_ToolresultsProjectsHistoriesExecutionsGet_580047(
    name: "toolresultsProjectsHistoriesExecutionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsGet_580048,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsGet_580049,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsPatch_580064 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsPatch_580066(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsPatch_580065(path: JsonNode;
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
  var valid_580067 = path.getOrDefault("projectId")
  valid_580067 = validateParameter(valid_580067, JString, required = true,
                                 default = nil)
  if valid_580067 != nil:
    section.add "projectId", valid_580067
  var valid_580068 = path.getOrDefault("historyId")
  valid_580068 = validateParameter(valid_580068, JString, required = true,
                                 default = nil)
  if valid_580068 != nil:
    section.add "historyId", valid_580068
  var valid_580069 = path.getOrDefault("executionId")
  valid_580069 = validateParameter(valid_580069, JString, required = true,
                                 default = nil)
  if valid_580069 != nil:
    section.add "executionId", valid_580069
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
  var valid_580070 = query.getOrDefault("fields")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "fields", valid_580070
  var valid_580071 = query.getOrDefault("requestId")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "requestId", valid_580071
  var valid_580072 = query.getOrDefault("quotaUser")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "quotaUser", valid_580072
  var valid_580073 = query.getOrDefault("alt")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("json"))
  if valid_580073 != nil:
    section.add "alt", valid_580073
  var valid_580074 = query.getOrDefault("oauth_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "oauth_token", valid_580074
  var valid_580075 = query.getOrDefault("userIp")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "userIp", valid_580075
  var valid_580076 = query.getOrDefault("key")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "key", valid_580076
  var valid_580077 = query.getOrDefault("prettyPrint")
  valid_580077 = validateParameter(valid_580077, JBool, required = false,
                                 default = newJBool(true))
  if valid_580077 != nil:
    section.add "prettyPrint", valid_580077
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

proc call*(call_580079: Call_ToolresultsProjectsHistoriesExecutionsPatch_580064;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing Execution with the supplied partial entity.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal - NOT_FOUND - if the containing History does not exist
  ## 
  let valid = call_580079.validator(path, query, header, formData, body)
  let scheme = call_580079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580079.url(scheme.get, call_580079.host, call_580079.base,
                         call_580079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580079, url, valid)

proc call*(call_580080: Call_ToolresultsProjectsHistoriesExecutionsPatch_580064;
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
  var path_580081 = newJObject()
  var query_580082 = newJObject()
  var body_580083 = newJObject()
  add(query_580082, "fields", newJString(fields))
  add(query_580082, "requestId", newJString(requestId))
  add(query_580082, "quotaUser", newJString(quotaUser))
  add(query_580082, "alt", newJString(alt))
  add(query_580082, "oauth_token", newJString(oauthToken))
  add(query_580082, "userIp", newJString(userIp))
  add(query_580082, "key", newJString(key))
  add(path_580081, "projectId", newJString(projectId))
  add(path_580081, "historyId", newJString(historyId))
  if body != nil:
    body_580083 = body
  add(query_580082, "prettyPrint", newJBool(prettyPrint))
  add(path_580081, "executionId", newJString(executionId))
  result = call_580080.call(path_580081, query_580082, nil, nil, body_580083)

var toolresultsProjectsHistoriesExecutionsPatch* = Call_ToolresultsProjectsHistoriesExecutionsPatch_580064(
    name: "toolresultsProjectsHistoriesExecutionsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsPatch_580065,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsPatch_580066,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsClustersList_580084 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsClustersList_580086(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsClustersList_580085(
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
  var valid_580087 = path.getOrDefault("projectId")
  valid_580087 = validateParameter(valid_580087, JString, required = true,
                                 default = nil)
  if valid_580087 != nil:
    section.add "projectId", valid_580087
  var valid_580088 = path.getOrDefault("historyId")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "historyId", valid_580088
  var valid_580089 = path.getOrDefault("executionId")
  valid_580089 = validateParameter(valid_580089, JString, required = true,
                                 default = nil)
  if valid_580089 != nil:
    section.add "executionId", valid_580089
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
  var valid_580090 = query.getOrDefault("fields")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "fields", valid_580090
  var valid_580091 = query.getOrDefault("quotaUser")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "quotaUser", valid_580091
  var valid_580092 = query.getOrDefault("alt")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = newJString("json"))
  if valid_580092 != nil:
    section.add "alt", valid_580092
  var valid_580093 = query.getOrDefault("oauth_token")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "oauth_token", valid_580093
  var valid_580094 = query.getOrDefault("userIp")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "userIp", valid_580094
  var valid_580095 = query.getOrDefault("key")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "key", valid_580095
  var valid_580096 = query.getOrDefault("prettyPrint")
  valid_580096 = validateParameter(valid_580096, JBool, required = false,
                                 default = newJBool(true))
  if valid_580096 != nil:
    section.add "prettyPrint", valid_580096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580097: Call_ToolresultsProjectsHistoriesExecutionsClustersList_580084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Screenshot Clusters
  ## 
  ## Returns the list of screenshot clusters corresponding to an execution. Screenshot clusters are created after the execution is finished. Clusters are created from a set of screenshots. Between any two screenshots, a matching score is calculated based off their metadata that determines how similar they are. Screenshots are placed in the cluster that has screens which have the highest matching scores.
  ## 
  let valid = call_580097.validator(path, query, header, formData, body)
  let scheme = call_580097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580097.url(scheme.get, call_580097.host, call_580097.base,
                         call_580097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580097, url, valid)

proc call*(call_580098: Call_ToolresultsProjectsHistoriesExecutionsClustersList_580084;
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
  var path_580099 = newJObject()
  var query_580100 = newJObject()
  add(query_580100, "fields", newJString(fields))
  add(query_580100, "quotaUser", newJString(quotaUser))
  add(query_580100, "alt", newJString(alt))
  add(query_580100, "oauth_token", newJString(oauthToken))
  add(query_580100, "userIp", newJString(userIp))
  add(query_580100, "key", newJString(key))
  add(path_580099, "projectId", newJString(projectId))
  add(path_580099, "historyId", newJString(historyId))
  add(query_580100, "prettyPrint", newJBool(prettyPrint))
  add(path_580099, "executionId", newJString(executionId))
  result = call_580098.call(path_580099, query_580100, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsClustersList* = Call_ToolresultsProjectsHistoriesExecutionsClustersList_580084(
    name: "toolresultsProjectsHistoriesExecutionsClustersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/clusters",
    validator: validate_ToolresultsProjectsHistoriesExecutionsClustersList_580085,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsClustersList_580086,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsClustersGet_580101 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsClustersGet_580103(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsClustersGet_580102(
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
  var valid_580104 = path.getOrDefault("projectId")
  valid_580104 = validateParameter(valid_580104, JString, required = true,
                                 default = nil)
  if valid_580104 != nil:
    section.add "projectId", valid_580104
  var valid_580105 = path.getOrDefault("historyId")
  valid_580105 = validateParameter(valid_580105, JString, required = true,
                                 default = nil)
  if valid_580105 != nil:
    section.add "historyId", valid_580105
  var valid_580106 = path.getOrDefault("clusterId")
  valid_580106 = validateParameter(valid_580106, JString, required = true,
                                 default = nil)
  if valid_580106 != nil:
    section.add "clusterId", valid_580106
  var valid_580107 = path.getOrDefault("executionId")
  valid_580107 = validateParameter(valid_580107, JString, required = true,
                                 default = nil)
  if valid_580107 != nil:
    section.add "executionId", valid_580107
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
  var valid_580108 = query.getOrDefault("fields")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "fields", valid_580108
  var valid_580109 = query.getOrDefault("quotaUser")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "quotaUser", valid_580109
  var valid_580110 = query.getOrDefault("alt")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = newJString("json"))
  if valid_580110 != nil:
    section.add "alt", valid_580110
  var valid_580111 = query.getOrDefault("oauth_token")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "oauth_token", valid_580111
  var valid_580112 = query.getOrDefault("userIp")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "userIp", valid_580112
  var valid_580113 = query.getOrDefault("key")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "key", valid_580113
  var valid_580114 = query.getOrDefault("prettyPrint")
  valid_580114 = validateParameter(valid_580114, JBool, required = false,
                                 default = newJBool(true))
  if valid_580114 != nil:
    section.add "prettyPrint", valid_580114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580115: Call_ToolresultsProjectsHistoriesExecutionsClustersGet_580101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a single screenshot cluster by its ID
  ## 
  let valid = call_580115.validator(path, query, header, formData, body)
  let scheme = call_580115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580115.url(scheme.get, call_580115.host, call_580115.base,
                         call_580115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580115, url, valid)

proc call*(call_580116: Call_ToolresultsProjectsHistoriesExecutionsClustersGet_580101;
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
  var path_580117 = newJObject()
  var query_580118 = newJObject()
  add(query_580118, "fields", newJString(fields))
  add(query_580118, "quotaUser", newJString(quotaUser))
  add(query_580118, "alt", newJString(alt))
  add(query_580118, "oauth_token", newJString(oauthToken))
  add(query_580118, "userIp", newJString(userIp))
  add(query_580118, "key", newJString(key))
  add(path_580117, "projectId", newJString(projectId))
  add(path_580117, "historyId", newJString(historyId))
  add(query_580118, "prettyPrint", newJBool(prettyPrint))
  add(path_580117, "clusterId", newJString(clusterId))
  add(path_580117, "executionId", newJString(executionId))
  result = call_580116.call(path_580117, query_580118, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsClustersGet* = Call_ToolresultsProjectsHistoriesExecutionsClustersGet_580101(
    name: "toolresultsProjectsHistoriesExecutionsClustersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/clusters/{clusterId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsClustersGet_580102,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsClustersGet_580103,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_580138 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsStepsCreate_580140(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsCreate_580139(
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
  var valid_580141 = path.getOrDefault("projectId")
  valid_580141 = validateParameter(valid_580141, JString, required = true,
                                 default = nil)
  if valid_580141 != nil:
    section.add "projectId", valid_580141
  var valid_580142 = path.getOrDefault("historyId")
  valid_580142 = validateParameter(valid_580142, JString, required = true,
                                 default = nil)
  if valid_580142 != nil:
    section.add "historyId", valid_580142
  var valid_580143 = path.getOrDefault("executionId")
  valid_580143 = validateParameter(valid_580143, JString, required = true,
                                 default = nil)
  if valid_580143 != nil:
    section.add "executionId", valid_580143
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
  var valid_580144 = query.getOrDefault("fields")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "fields", valid_580144
  var valid_580145 = query.getOrDefault("requestId")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "requestId", valid_580145
  var valid_580146 = query.getOrDefault("quotaUser")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "quotaUser", valid_580146
  var valid_580147 = query.getOrDefault("alt")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = newJString("json"))
  if valid_580147 != nil:
    section.add "alt", valid_580147
  var valid_580148 = query.getOrDefault("oauth_token")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "oauth_token", valid_580148
  var valid_580149 = query.getOrDefault("userIp")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "userIp", valid_580149
  var valid_580150 = query.getOrDefault("key")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "key", valid_580150
  var valid_580151 = query.getOrDefault("prettyPrint")
  valid_580151 = validateParameter(valid_580151, JBool, required = false,
                                 default = newJBool(true))
  if valid_580151 != nil:
    section.add "prettyPrint", valid_580151
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

proc call*(call_580153: Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_580138;
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
  let valid = call_580153.validator(path, query, header, formData, body)
  let scheme = call_580153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580153.url(scheme.get, call_580153.host, call_580153.base,
                         call_580153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580153, url, valid)

proc call*(call_580154: Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_580138;
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
  var path_580155 = newJObject()
  var query_580156 = newJObject()
  var body_580157 = newJObject()
  add(query_580156, "fields", newJString(fields))
  add(query_580156, "requestId", newJString(requestId))
  add(query_580156, "quotaUser", newJString(quotaUser))
  add(query_580156, "alt", newJString(alt))
  add(query_580156, "oauth_token", newJString(oauthToken))
  add(query_580156, "userIp", newJString(userIp))
  add(query_580156, "key", newJString(key))
  add(path_580155, "projectId", newJString(projectId))
  add(path_580155, "historyId", newJString(historyId))
  if body != nil:
    body_580157 = body
  add(query_580156, "prettyPrint", newJBool(prettyPrint))
  add(path_580155, "executionId", newJString(executionId))
  result = call_580154.call(path_580155, query_580156, nil, nil, body_580157)

var toolresultsProjectsHistoriesExecutionsStepsCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_580138(
    name: "toolresultsProjectsHistoriesExecutionsStepsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsCreate_580139,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsCreate_580140,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsList_580119 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsStepsList_580121(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsList_580120(
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
  var valid_580122 = path.getOrDefault("projectId")
  valid_580122 = validateParameter(valid_580122, JString, required = true,
                                 default = nil)
  if valid_580122 != nil:
    section.add "projectId", valid_580122
  var valid_580123 = path.getOrDefault("historyId")
  valid_580123 = validateParameter(valid_580123, JString, required = true,
                                 default = nil)
  if valid_580123 != nil:
    section.add "historyId", valid_580123
  var valid_580124 = path.getOrDefault("executionId")
  valid_580124 = validateParameter(valid_580124, JString, required = true,
                                 default = nil)
  if valid_580124 != nil:
    section.add "executionId", valid_580124
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
  var valid_580125 = query.getOrDefault("fields")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "fields", valid_580125
  var valid_580126 = query.getOrDefault("pageToken")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "pageToken", valid_580126
  var valid_580127 = query.getOrDefault("quotaUser")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "quotaUser", valid_580127
  var valid_580128 = query.getOrDefault("alt")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = newJString("json"))
  if valid_580128 != nil:
    section.add "alt", valid_580128
  var valid_580129 = query.getOrDefault("oauth_token")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "oauth_token", valid_580129
  var valid_580130 = query.getOrDefault("userIp")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "userIp", valid_580130
  var valid_580131 = query.getOrDefault("key")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "key", valid_580131
  var valid_580132 = query.getOrDefault("pageSize")
  valid_580132 = validateParameter(valid_580132, JInt, required = false, default = nil)
  if valid_580132 != nil:
    section.add "pageSize", valid_580132
  var valid_580133 = query.getOrDefault("prettyPrint")
  valid_580133 = validateParameter(valid_580133, JBool, required = false,
                                 default = newJBool(true))
  if valid_580133 != nil:
    section.add "prettyPrint", valid_580133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580134: Call_ToolresultsProjectsHistoriesExecutionsStepsList_580119;
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
  let valid = call_580134.validator(path, query, header, formData, body)
  let scheme = call_580134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580134.url(scheme.get, call_580134.host, call_580134.base,
                         call_580134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580134, url, valid)

proc call*(call_580135: Call_ToolresultsProjectsHistoriesExecutionsStepsList_580119;
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
  var path_580136 = newJObject()
  var query_580137 = newJObject()
  add(query_580137, "fields", newJString(fields))
  add(query_580137, "pageToken", newJString(pageToken))
  add(query_580137, "quotaUser", newJString(quotaUser))
  add(query_580137, "alt", newJString(alt))
  add(query_580137, "oauth_token", newJString(oauthToken))
  add(query_580137, "userIp", newJString(userIp))
  add(query_580137, "key", newJString(key))
  add(path_580136, "projectId", newJString(projectId))
  add(query_580137, "pageSize", newJInt(pageSize))
  add(path_580136, "historyId", newJString(historyId))
  add(query_580137, "prettyPrint", newJBool(prettyPrint))
  add(path_580136, "executionId", newJString(executionId))
  result = call_580135.call(path_580136, query_580137, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsList* = Call_ToolresultsProjectsHistoriesExecutionsStepsList_580119(
    name: "toolresultsProjectsHistoriesExecutionsStepsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsList_580120,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsList_580121,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsGet_580158 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsStepsGet_580160(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsGet_580159(
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
  var valid_580161 = path.getOrDefault("stepId")
  valid_580161 = validateParameter(valid_580161, JString, required = true,
                                 default = nil)
  if valid_580161 != nil:
    section.add "stepId", valid_580161
  var valid_580162 = path.getOrDefault("projectId")
  valid_580162 = validateParameter(valid_580162, JString, required = true,
                                 default = nil)
  if valid_580162 != nil:
    section.add "projectId", valid_580162
  var valid_580163 = path.getOrDefault("historyId")
  valid_580163 = validateParameter(valid_580163, JString, required = true,
                                 default = nil)
  if valid_580163 != nil:
    section.add "historyId", valid_580163
  var valid_580164 = path.getOrDefault("executionId")
  valid_580164 = validateParameter(valid_580164, JString, required = true,
                                 default = nil)
  if valid_580164 != nil:
    section.add "executionId", valid_580164
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
  var valid_580165 = query.getOrDefault("fields")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "fields", valid_580165
  var valid_580166 = query.getOrDefault("quotaUser")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "quotaUser", valid_580166
  var valid_580167 = query.getOrDefault("alt")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = newJString("json"))
  if valid_580167 != nil:
    section.add "alt", valid_580167
  var valid_580168 = query.getOrDefault("oauth_token")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "oauth_token", valid_580168
  var valid_580169 = query.getOrDefault("userIp")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "userIp", valid_580169
  var valid_580170 = query.getOrDefault("key")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "key", valid_580170
  var valid_580171 = query.getOrDefault("prettyPrint")
  valid_580171 = validateParameter(valid_580171, JBool, required = false,
                                 default = newJBool(true))
  if valid_580171 != nil:
    section.add "prettyPrint", valid_580171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580172: Call_ToolresultsProjectsHistoriesExecutionsStepsGet_580158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a Step.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the Step does not exist
  ## 
  let valid = call_580172.validator(path, query, header, formData, body)
  let scheme = call_580172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580172.url(scheme.get, call_580172.host, call_580172.base,
                         call_580172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580172, url, valid)

proc call*(call_580173: Call_ToolresultsProjectsHistoriesExecutionsStepsGet_580158;
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
  var path_580174 = newJObject()
  var query_580175 = newJObject()
  add(path_580174, "stepId", newJString(stepId))
  add(query_580175, "fields", newJString(fields))
  add(query_580175, "quotaUser", newJString(quotaUser))
  add(query_580175, "alt", newJString(alt))
  add(query_580175, "oauth_token", newJString(oauthToken))
  add(query_580175, "userIp", newJString(userIp))
  add(query_580175, "key", newJString(key))
  add(path_580174, "projectId", newJString(projectId))
  add(path_580174, "historyId", newJString(historyId))
  add(query_580175, "prettyPrint", newJBool(prettyPrint))
  add(path_580174, "executionId", newJString(executionId))
  result = call_580173.call(path_580174, query_580175, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsGet* = Call_ToolresultsProjectsHistoriesExecutionsStepsGet_580158(
    name: "toolresultsProjectsHistoriesExecutionsStepsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsGet_580159,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsGet_580160,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_580176 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPatch_580178(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPatch_580177(
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
  var valid_580179 = path.getOrDefault("stepId")
  valid_580179 = validateParameter(valid_580179, JString, required = true,
                                 default = nil)
  if valid_580179 != nil:
    section.add "stepId", valid_580179
  var valid_580180 = path.getOrDefault("projectId")
  valid_580180 = validateParameter(valid_580180, JString, required = true,
                                 default = nil)
  if valid_580180 != nil:
    section.add "projectId", valid_580180
  var valid_580181 = path.getOrDefault("historyId")
  valid_580181 = validateParameter(valid_580181, JString, required = true,
                                 default = nil)
  if valid_580181 != nil:
    section.add "historyId", valid_580181
  var valid_580182 = path.getOrDefault("executionId")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "executionId", valid_580182
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
  var valid_580183 = query.getOrDefault("fields")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "fields", valid_580183
  var valid_580184 = query.getOrDefault("requestId")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "requestId", valid_580184
  var valid_580185 = query.getOrDefault("quotaUser")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "quotaUser", valid_580185
  var valid_580186 = query.getOrDefault("alt")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("json"))
  if valid_580186 != nil:
    section.add "alt", valid_580186
  var valid_580187 = query.getOrDefault("oauth_token")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "oauth_token", valid_580187
  var valid_580188 = query.getOrDefault("userIp")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "userIp", valid_580188
  var valid_580189 = query.getOrDefault("key")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "key", valid_580189
  var valid_580190 = query.getOrDefault("prettyPrint")
  valid_580190 = validateParameter(valid_580190, JBool, required = false,
                                 default = newJBool(true))
  if valid_580190 != nil:
    section.add "prettyPrint", valid_580190
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

proc call*(call_580192: Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_580176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing Step with the supplied partial entity.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal (e.g try to upload a duplicate xml file), if the updated step is too large (more than 10Mib) - NOT_FOUND - if the containing Execution does not exist
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_580176;
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
  var path_580194 = newJObject()
  var query_580195 = newJObject()
  var body_580196 = newJObject()
  add(path_580194, "stepId", newJString(stepId))
  add(query_580195, "fields", newJString(fields))
  add(query_580195, "requestId", newJString(requestId))
  add(query_580195, "quotaUser", newJString(quotaUser))
  add(query_580195, "alt", newJString(alt))
  add(query_580195, "oauth_token", newJString(oauthToken))
  add(query_580195, "userIp", newJString(userIp))
  add(query_580195, "key", newJString(key))
  add(path_580194, "projectId", newJString(projectId))
  add(path_580194, "historyId", newJString(historyId))
  if body != nil:
    body_580196 = body
  add(query_580195, "prettyPrint", newJBool(prettyPrint))
  add(path_580194, "executionId", newJString(executionId))
  result = call_580193.call(path_580194, query_580195, nil, nil, body_580196)

var toolresultsProjectsHistoriesExecutionsStepsPatch* = Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_580176(
    name: "toolresultsProjectsHistoriesExecutionsStepsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPatch_580177,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPatch_580178,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_580215 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_580217(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_580216(
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
  var valid_580218 = path.getOrDefault("stepId")
  valid_580218 = validateParameter(valid_580218, JString, required = true,
                                 default = nil)
  if valid_580218 != nil:
    section.add "stepId", valid_580218
  var valid_580219 = path.getOrDefault("projectId")
  valid_580219 = validateParameter(valid_580219, JString, required = true,
                                 default = nil)
  if valid_580219 != nil:
    section.add "projectId", valid_580219
  var valid_580220 = path.getOrDefault("historyId")
  valid_580220 = validateParameter(valid_580220, JString, required = true,
                                 default = nil)
  if valid_580220 != nil:
    section.add "historyId", valid_580220
  var valid_580221 = path.getOrDefault("executionId")
  valid_580221 = validateParameter(valid_580221, JString, required = true,
                                 default = nil)
  if valid_580221 != nil:
    section.add "executionId", valid_580221
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
  var valid_580222 = query.getOrDefault("fields")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "fields", valid_580222
  var valid_580223 = query.getOrDefault("quotaUser")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "quotaUser", valid_580223
  var valid_580224 = query.getOrDefault("alt")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = newJString("json"))
  if valid_580224 != nil:
    section.add "alt", valid_580224
  var valid_580225 = query.getOrDefault("oauth_token")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "oauth_token", valid_580225
  var valid_580226 = query.getOrDefault("userIp")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "userIp", valid_580226
  var valid_580227 = query.getOrDefault("key")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "key", valid_580227
  var valid_580228 = query.getOrDefault("prettyPrint")
  valid_580228 = validateParameter(valid_580228, JBool, required = false,
                                 default = newJBool(true))
  if valid_580228 != nil:
    section.add "prettyPrint", valid_580228
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

proc call*(call_580230: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_580215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a PerfMetricsSummary resource.
  ## 
  ## May return any of the following error code(s): - ALREADY_EXISTS - A PerfMetricSummary already exists for the given Step - NOT_FOUND - The containing Step does not exist
  ## 
  let valid = call_580230.validator(path, query, header, formData, body)
  let scheme = call_580230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580230.url(scheme.get, call_580230.host, call_580230.base,
                         call_580230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580230, url, valid)

proc call*(call_580231: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_580215;
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
  var path_580232 = newJObject()
  var query_580233 = newJObject()
  var body_580234 = newJObject()
  add(path_580232, "stepId", newJString(stepId))
  add(query_580233, "fields", newJString(fields))
  add(query_580233, "quotaUser", newJString(quotaUser))
  add(query_580233, "alt", newJString(alt))
  add(query_580233, "oauth_token", newJString(oauthToken))
  add(query_580233, "userIp", newJString(userIp))
  add(query_580233, "key", newJString(key))
  add(path_580232, "projectId", newJString(projectId))
  add(path_580232, "historyId", newJString(historyId))
  if body != nil:
    body_580234 = body
  add(query_580233, "prettyPrint", newJBool(prettyPrint))
  add(path_580232, "executionId", newJString(executionId))
  result = call_580231.call(path_580232, query_580233, nil, nil, body_580234)

var toolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_580215(name: "toolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfMetricsSummary", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_580216,
    base: "/toolresults/v1beta3firstparty/projects", url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_580217,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_580197 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_580199(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_580198(
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
  var valid_580200 = path.getOrDefault("stepId")
  valid_580200 = validateParameter(valid_580200, JString, required = true,
                                 default = nil)
  if valid_580200 != nil:
    section.add "stepId", valid_580200
  var valid_580201 = path.getOrDefault("projectId")
  valid_580201 = validateParameter(valid_580201, JString, required = true,
                                 default = nil)
  if valid_580201 != nil:
    section.add "projectId", valid_580201
  var valid_580202 = path.getOrDefault("historyId")
  valid_580202 = validateParameter(valid_580202, JString, required = true,
                                 default = nil)
  if valid_580202 != nil:
    section.add "historyId", valid_580202
  var valid_580203 = path.getOrDefault("executionId")
  valid_580203 = validateParameter(valid_580203, JString, required = true,
                                 default = nil)
  if valid_580203 != nil:
    section.add "executionId", valid_580203
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
  var valid_580204 = query.getOrDefault("fields")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "fields", valid_580204
  var valid_580205 = query.getOrDefault("quotaUser")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "quotaUser", valid_580205
  var valid_580206 = query.getOrDefault("alt")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = newJString("json"))
  if valid_580206 != nil:
    section.add "alt", valid_580206
  var valid_580207 = query.getOrDefault("oauth_token")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "oauth_token", valid_580207
  var valid_580208 = query.getOrDefault("userIp")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "userIp", valid_580208
  var valid_580209 = query.getOrDefault("key")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "key", valid_580209
  var valid_580210 = query.getOrDefault("prettyPrint")
  valid_580210 = validateParameter(valid_580210, JBool, required = false,
                                 default = newJBool(true))
  if valid_580210 != nil:
    section.add "prettyPrint", valid_580210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580211: Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_580197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a PerfMetricsSummary.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfMetricsSummary does not exist
  ## 
  let valid = call_580211.validator(path, query, header, formData, body)
  let scheme = call_580211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580211.url(scheme.get, call_580211.host, call_580211.base,
                         call_580211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580211, url, valid)

proc call*(call_580212: Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_580197;
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
  var path_580213 = newJObject()
  var query_580214 = newJObject()
  add(path_580213, "stepId", newJString(stepId))
  add(query_580214, "fields", newJString(fields))
  add(query_580214, "quotaUser", newJString(quotaUser))
  add(query_580214, "alt", newJString(alt))
  add(query_580214, "oauth_token", newJString(oauthToken))
  add(query_580214, "userIp", newJString(userIp))
  add(query_580214, "key", newJString(key))
  add(path_580213, "projectId", newJString(projectId))
  add(path_580213, "historyId", newJString(historyId))
  add(query_580214, "prettyPrint", newJBool(prettyPrint))
  add(path_580213, "executionId", newJString(executionId))
  result = call_580212.call(path_580213, query_580214, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary* = Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_580197(
    name: "toolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfMetricsSummary", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_580198,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_580199,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_580254 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_580256(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_580255(
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
  var valid_580257 = path.getOrDefault("stepId")
  valid_580257 = validateParameter(valid_580257, JString, required = true,
                                 default = nil)
  if valid_580257 != nil:
    section.add "stepId", valid_580257
  var valid_580258 = path.getOrDefault("projectId")
  valid_580258 = validateParameter(valid_580258, JString, required = true,
                                 default = nil)
  if valid_580258 != nil:
    section.add "projectId", valid_580258
  var valid_580259 = path.getOrDefault("historyId")
  valid_580259 = validateParameter(valid_580259, JString, required = true,
                                 default = nil)
  if valid_580259 != nil:
    section.add "historyId", valid_580259
  var valid_580260 = path.getOrDefault("executionId")
  valid_580260 = validateParameter(valid_580260, JString, required = true,
                                 default = nil)
  if valid_580260 != nil:
    section.add "executionId", valid_580260
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
  var valid_580261 = query.getOrDefault("fields")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "fields", valid_580261
  var valid_580262 = query.getOrDefault("quotaUser")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "quotaUser", valid_580262
  var valid_580263 = query.getOrDefault("alt")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = newJString("json"))
  if valid_580263 != nil:
    section.add "alt", valid_580263
  var valid_580264 = query.getOrDefault("oauth_token")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "oauth_token", valid_580264
  var valid_580265 = query.getOrDefault("userIp")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "userIp", valid_580265
  var valid_580266 = query.getOrDefault("key")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "key", valid_580266
  var valid_580267 = query.getOrDefault("prettyPrint")
  valid_580267 = validateParameter(valid_580267, JBool, required = false,
                                 default = newJBool(true))
  if valid_580267 != nil:
    section.add "prettyPrint", valid_580267
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

proc call*(call_580269: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_580254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - ALREADY_EXISTS - PerfMetricSummary already exists for the given Step - NOT_FOUND - The containing Step does not exist
  ## 
  let valid = call_580269.validator(path, query, header, formData, body)
  let scheme = call_580269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580269.url(scheme.get, call_580269.host, call_580269.base,
                         call_580269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580269, url, valid)

proc call*(call_580270: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_580254;
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
  var path_580271 = newJObject()
  var query_580272 = newJObject()
  var body_580273 = newJObject()
  add(path_580271, "stepId", newJString(stepId))
  add(query_580272, "fields", newJString(fields))
  add(query_580272, "quotaUser", newJString(quotaUser))
  add(query_580272, "alt", newJString(alt))
  add(query_580272, "oauth_token", newJString(oauthToken))
  add(query_580272, "userIp", newJString(userIp))
  add(query_580272, "key", newJString(key))
  add(path_580271, "projectId", newJString(projectId))
  add(path_580271, "historyId", newJString(historyId))
  if body != nil:
    body_580273 = body
  add(query_580272, "prettyPrint", newJBool(prettyPrint))
  add(path_580271, "executionId", newJString(executionId))
  result = call_580270.call(path_580271, query_580272, nil, nil, body_580273)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_580254(
    name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_580255,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_580256,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_580235 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_580237(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_580236(
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
  var valid_580238 = path.getOrDefault("stepId")
  valid_580238 = validateParameter(valid_580238, JString, required = true,
                                 default = nil)
  if valid_580238 != nil:
    section.add "stepId", valid_580238
  var valid_580239 = path.getOrDefault("projectId")
  valid_580239 = validateParameter(valid_580239, JString, required = true,
                                 default = nil)
  if valid_580239 != nil:
    section.add "projectId", valid_580239
  var valid_580240 = path.getOrDefault("historyId")
  valid_580240 = validateParameter(valid_580240, JString, required = true,
                                 default = nil)
  if valid_580240 != nil:
    section.add "historyId", valid_580240
  var valid_580241 = path.getOrDefault("executionId")
  valid_580241 = validateParameter(valid_580241, JString, required = true,
                                 default = nil)
  if valid_580241 != nil:
    section.add "executionId", valid_580241
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
  var valid_580242 = query.getOrDefault("fields")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "fields", valid_580242
  var valid_580243 = query.getOrDefault("quotaUser")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "quotaUser", valid_580243
  var valid_580244 = query.getOrDefault("alt")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = newJString("json"))
  if valid_580244 != nil:
    section.add "alt", valid_580244
  var valid_580245 = query.getOrDefault("oauth_token")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "oauth_token", valid_580245
  var valid_580246 = query.getOrDefault("userIp")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "userIp", valid_580246
  var valid_580247 = query.getOrDefault("key")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "key", valid_580247
  var valid_580248 = query.getOrDefault("prettyPrint")
  valid_580248 = validateParameter(valid_580248, JBool, required = false,
                                 default = newJBool(true))
  if valid_580248 != nil:
    section.add "prettyPrint", valid_580248
  var valid_580249 = query.getOrDefault("filter")
  valid_580249 = validateParameter(valid_580249, JArray, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "filter", valid_580249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580250: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_580235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists PerfSampleSeries for a given Step.
  ## 
  ## The request provides an optional filter which specifies one or more PerfMetricsType to include in the result; if none returns all. The resulting PerfSampleSeries are sorted by ids.
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing Step does not exist
  ## 
  let valid = call_580250.validator(path, query, header, formData, body)
  let scheme = call_580250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580250.url(scheme.get, call_580250.host, call_580250.base,
                         call_580250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580250, url, valid)

proc call*(call_580251: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_580235;
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
  var path_580252 = newJObject()
  var query_580253 = newJObject()
  add(path_580252, "stepId", newJString(stepId))
  add(query_580253, "fields", newJString(fields))
  add(query_580253, "quotaUser", newJString(quotaUser))
  add(query_580253, "alt", newJString(alt))
  add(query_580253, "oauth_token", newJString(oauthToken))
  add(query_580253, "userIp", newJString(userIp))
  add(query_580253, "key", newJString(key))
  add(path_580252, "projectId", newJString(projectId))
  add(path_580252, "historyId", newJString(historyId))
  add(query_580253, "prettyPrint", newJBool(prettyPrint))
  add(path_580252, "executionId", newJString(executionId))
  if filter != nil:
    query_580253.add "filter", filter
  result = call_580251.call(path_580252, query_580253, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_580235(
    name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_580236,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_580237,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_580274 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_580276(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_580275(
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
  var valid_580277 = path.getOrDefault("stepId")
  valid_580277 = validateParameter(valid_580277, JString, required = true,
                                 default = nil)
  if valid_580277 != nil:
    section.add "stepId", valid_580277
  var valid_580278 = path.getOrDefault("projectId")
  valid_580278 = validateParameter(valid_580278, JString, required = true,
                                 default = nil)
  if valid_580278 != nil:
    section.add "projectId", valid_580278
  var valid_580279 = path.getOrDefault("sampleSeriesId")
  valid_580279 = validateParameter(valid_580279, JString, required = true,
                                 default = nil)
  if valid_580279 != nil:
    section.add "sampleSeriesId", valid_580279
  var valid_580280 = path.getOrDefault("historyId")
  valid_580280 = validateParameter(valid_580280, JString, required = true,
                                 default = nil)
  if valid_580280 != nil:
    section.add "historyId", valid_580280
  var valid_580281 = path.getOrDefault("executionId")
  valid_580281 = validateParameter(valid_580281, JString, required = true,
                                 default = nil)
  if valid_580281 != nil:
    section.add "executionId", valid_580281
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
  var valid_580282 = query.getOrDefault("fields")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "fields", valid_580282
  var valid_580283 = query.getOrDefault("quotaUser")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "quotaUser", valid_580283
  var valid_580284 = query.getOrDefault("alt")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = newJString("json"))
  if valid_580284 != nil:
    section.add "alt", valid_580284
  var valid_580285 = query.getOrDefault("oauth_token")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "oauth_token", valid_580285
  var valid_580286 = query.getOrDefault("userIp")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "userIp", valid_580286
  var valid_580287 = query.getOrDefault("key")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "key", valid_580287
  var valid_580288 = query.getOrDefault("prettyPrint")
  valid_580288 = validateParameter(valid_580288, JBool, required = false,
                                 default = newJBool(true))
  if valid_580288 != nil:
    section.add "prettyPrint", valid_580288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580289: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_580274;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfSampleSeries does not exist
  ## 
  let valid = call_580289.validator(path, query, header, formData, body)
  let scheme = call_580289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580289.url(scheme.get, call_580289.host, call_580289.base,
                         call_580289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580289, url, valid)

proc call*(call_580290: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_580274;
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
  var path_580291 = newJObject()
  var query_580292 = newJObject()
  add(path_580291, "stepId", newJString(stepId))
  add(query_580292, "fields", newJString(fields))
  add(query_580292, "quotaUser", newJString(quotaUser))
  add(query_580292, "alt", newJString(alt))
  add(query_580292, "oauth_token", newJString(oauthToken))
  add(query_580292, "userIp", newJString(userIp))
  add(query_580292, "key", newJString(key))
  add(path_580291, "projectId", newJString(projectId))
  add(path_580291, "sampleSeriesId", newJString(sampleSeriesId))
  add(path_580291, "historyId", newJString(historyId))
  add(query_580292, "prettyPrint", newJBool(prettyPrint))
  add(path_580291, "executionId", newJString(executionId))
  result = call_580290.call(path_580291, query_580292, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_580274(
    name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries/{sampleSeriesId}", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_580275,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_580276,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_580293 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_580295(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_580294(
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
  var valid_580296 = path.getOrDefault("stepId")
  valid_580296 = validateParameter(valid_580296, JString, required = true,
                                 default = nil)
  if valid_580296 != nil:
    section.add "stepId", valid_580296
  var valid_580297 = path.getOrDefault("projectId")
  valid_580297 = validateParameter(valid_580297, JString, required = true,
                                 default = nil)
  if valid_580297 != nil:
    section.add "projectId", valid_580297
  var valid_580298 = path.getOrDefault("sampleSeriesId")
  valid_580298 = validateParameter(valid_580298, JString, required = true,
                                 default = nil)
  if valid_580298 != nil:
    section.add "sampleSeriesId", valid_580298
  var valid_580299 = path.getOrDefault("historyId")
  valid_580299 = validateParameter(valid_580299, JString, required = true,
                                 default = nil)
  if valid_580299 != nil:
    section.add "historyId", valid_580299
  var valid_580300 = path.getOrDefault("executionId")
  valid_580300 = validateParameter(valid_580300, JString, required = true,
                                 default = nil)
  if valid_580300 != nil:
    section.add "executionId", valid_580300
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
  var valid_580301 = query.getOrDefault("fields")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "fields", valid_580301
  var valid_580302 = query.getOrDefault("pageToken")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "pageToken", valid_580302
  var valid_580303 = query.getOrDefault("quotaUser")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "quotaUser", valid_580303
  var valid_580304 = query.getOrDefault("alt")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = newJString("json"))
  if valid_580304 != nil:
    section.add "alt", valid_580304
  var valid_580305 = query.getOrDefault("oauth_token")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "oauth_token", valid_580305
  var valid_580306 = query.getOrDefault("userIp")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "userIp", valid_580306
  var valid_580307 = query.getOrDefault("key")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "key", valid_580307
  var valid_580308 = query.getOrDefault("pageSize")
  valid_580308 = validateParameter(valid_580308, JInt, required = false, default = nil)
  if valid_580308 != nil:
    section.add "pageSize", valid_580308
  var valid_580309 = query.getOrDefault("prettyPrint")
  valid_580309 = validateParameter(valid_580309, JBool, required = false,
                                 default = newJBool(true))
  if valid_580309 != nil:
    section.add "prettyPrint", valid_580309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580310: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_580293;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Performance Samples of a given Sample Series - The list results are sorted by timestamps ascending - The default page size is 500 samples; and maximum size allowed 5000 - The response token indicates the last returned PerfSample timestamp - When the results size exceeds the page size, submit a subsequent request including the page token to return the rest of the samples up to the page limit
  ## 
  ## May return any of the following canonical error codes: - OUT_OF_RANGE - The specified request page_token is out of valid range - NOT_FOUND - The containing PerfSampleSeries does not exist
  ## 
  let valid = call_580310.validator(path, query, header, formData, body)
  let scheme = call_580310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580310.url(scheme.get, call_580310.host, call_580310.base,
                         call_580310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580310, url, valid)

proc call*(call_580311: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_580293;
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
  var path_580312 = newJObject()
  var query_580313 = newJObject()
  add(path_580312, "stepId", newJString(stepId))
  add(query_580313, "fields", newJString(fields))
  add(query_580313, "pageToken", newJString(pageToken))
  add(query_580313, "quotaUser", newJString(quotaUser))
  add(query_580313, "alt", newJString(alt))
  add(query_580313, "oauth_token", newJString(oauthToken))
  add(query_580313, "userIp", newJString(userIp))
  add(query_580313, "key", newJString(key))
  add(path_580312, "projectId", newJString(projectId))
  add(path_580312, "sampleSeriesId", newJString(sampleSeriesId))
  add(query_580313, "pageSize", newJInt(pageSize))
  add(path_580312, "historyId", newJString(historyId))
  add(query_580313, "prettyPrint", newJBool(prettyPrint))
  add(path_580312, "executionId", newJString(executionId))
  result = call_580311.call(path_580312, query_580313, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_580293(name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries/{sampleSeriesId}/samples", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_580294,
    base: "/toolresults/v1beta3firstparty/projects", url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_580295,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_580314 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_580316(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_580315(
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
  var valid_580317 = path.getOrDefault("stepId")
  valid_580317 = validateParameter(valid_580317, JString, required = true,
                                 default = nil)
  if valid_580317 != nil:
    section.add "stepId", valid_580317
  var valid_580318 = path.getOrDefault("projectId")
  valid_580318 = validateParameter(valid_580318, JString, required = true,
                                 default = nil)
  if valid_580318 != nil:
    section.add "projectId", valid_580318
  var valid_580319 = path.getOrDefault("sampleSeriesId")
  valid_580319 = validateParameter(valid_580319, JString, required = true,
                                 default = nil)
  if valid_580319 != nil:
    section.add "sampleSeriesId", valid_580319
  var valid_580320 = path.getOrDefault("historyId")
  valid_580320 = validateParameter(valid_580320, JString, required = true,
                                 default = nil)
  if valid_580320 != nil:
    section.add "historyId", valid_580320
  var valid_580321 = path.getOrDefault("executionId")
  valid_580321 = validateParameter(valid_580321, JString, required = true,
                                 default = nil)
  if valid_580321 != nil:
    section.add "executionId", valid_580321
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
  var valid_580322 = query.getOrDefault("fields")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "fields", valid_580322
  var valid_580323 = query.getOrDefault("quotaUser")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "quotaUser", valid_580323
  var valid_580324 = query.getOrDefault("alt")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = newJString("json"))
  if valid_580324 != nil:
    section.add "alt", valid_580324
  var valid_580325 = query.getOrDefault("oauth_token")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "oauth_token", valid_580325
  var valid_580326 = query.getOrDefault("userIp")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "userIp", valid_580326
  var valid_580327 = query.getOrDefault("key")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "key", valid_580327
  var valid_580328 = query.getOrDefault("prettyPrint")
  valid_580328 = validateParameter(valid_580328, JBool, required = false,
                                 default = newJBool(true))
  if valid_580328 != nil:
    section.add "prettyPrint", valid_580328
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

proc call*(call_580330: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_580314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a batch of PerfSamples - a client can submit multiple batches of Perf Samples through repeated calls to this method in order to split up a large request payload - duplicates and existing timestamp entries will be ignored. - the batch operation may partially succeed - the set of elements successfully inserted is returned in the response (omits items which already existed in the database).
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing PerfSampleSeries does not exist
  ## 
  let valid = call_580330.validator(path, query, header, formData, body)
  let scheme = call_580330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580330.url(scheme.get, call_580330.host, call_580330.base,
                         call_580330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580330, url, valid)

proc call*(call_580331: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_580314;
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
  var path_580332 = newJObject()
  var query_580333 = newJObject()
  var body_580334 = newJObject()
  add(path_580332, "stepId", newJString(stepId))
  add(query_580333, "fields", newJString(fields))
  add(query_580333, "quotaUser", newJString(quotaUser))
  add(query_580333, "alt", newJString(alt))
  add(query_580333, "oauth_token", newJString(oauthToken))
  add(query_580333, "userIp", newJString(userIp))
  add(query_580333, "key", newJString(key))
  add(path_580332, "projectId", newJString(projectId))
  add(path_580332, "sampleSeriesId", newJString(sampleSeriesId))
  add(path_580332, "historyId", newJString(historyId))
  if body != nil:
    body_580334 = body
  add(query_580333, "prettyPrint", newJBool(prettyPrint))
  add(path_580332, "executionId", newJString(executionId))
  result = call_580331.call(path_580332, query_580333, nil, nil, body_580334)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_580314(name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries/{sampleSeriesId}/samples:batchCreate", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_580315,
    base: "/toolresults/v1beta3firstparty/projects", url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_580316,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_580335 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_580337(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_580336(
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
  var valid_580338 = path.getOrDefault("stepId")
  valid_580338 = validateParameter(valid_580338, JString, required = true,
                                 default = nil)
  if valid_580338 != nil:
    section.add "stepId", valid_580338
  var valid_580339 = path.getOrDefault("projectId")
  valid_580339 = validateParameter(valid_580339, JString, required = true,
                                 default = nil)
  if valid_580339 != nil:
    section.add "projectId", valid_580339
  var valid_580340 = path.getOrDefault("historyId")
  valid_580340 = validateParameter(valid_580340, JString, required = true,
                                 default = nil)
  if valid_580340 != nil:
    section.add "historyId", valid_580340
  var valid_580341 = path.getOrDefault("executionId")
  valid_580341 = validateParameter(valid_580341, JString, required = true,
                                 default = nil)
  if valid_580341 != nil:
    section.add "executionId", valid_580341
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
  var valid_580342 = query.getOrDefault("fields")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "fields", valid_580342
  var valid_580343 = query.getOrDefault("pageToken")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "pageToken", valid_580343
  var valid_580344 = query.getOrDefault("quotaUser")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "quotaUser", valid_580344
  var valid_580345 = query.getOrDefault("alt")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = newJString("json"))
  if valid_580345 != nil:
    section.add "alt", valid_580345
  var valid_580346 = query.getOrDefault("oauth_token")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "oauth_token", valid_580346
  var valid_580347 = query.getOrDefault("userIp")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "userIp", valid_580347
  var valid_580348 = query.getOrDefault("key")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "key", valid_580348
  var valid_580349 = query.getOrDefault("pageSize")
  valid_580349 = validateParameter(valid_580349, JInt, required = false, default = nil)
  if valid_580349 != nil:
    section.add "pageSize", valid_580349
  var valid_580350 = query.getOrDefault("prettyPrint")
  valid_580350 = validateParameter(valid_580350, JBool, required = false,
                                 default = newJBool(true))
  if valid_580350 != nil:
    section.add "prettyPrint", valid_580350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580351: Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_580335;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists thumbnails of images attached to a step.
  ## 
  ## May return any of the following canonical error codes: - PERMISSION_DENIED - if the user is not authorized to read from the project, or from any of the images - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the step does not exist, or if any of the images do not exist
  ## 
  let valid = call_580351.validator(path, query, header, formData, body)
  let scheme = call_580351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580351.url(scheme.get, call_580351.host, call_580351.base,
                         call_580351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580351, url, valid)

proc call*(call_580352: Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_580335;
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
  var path_580353 = newJObject()
  var query_580354 = newJObject()
  add(path_580353, "stepId", newJString(stepId))
  add(query_580354, "fields", newJString(fields))
  add(query_580354, "pageToken", newJString(pageToken))
  add(query_580354, "quotaUser", newJString(quotaUser))
  add(query_580354, "alt", newJString(alt))
  add(query_580354, "oauth_token", newJString(oauthToken))
  add(query_580354, "userIp", newJString(userIp))
  add(query_580354, "key", newJString(key))
  add(path_580353, "projectId", newJString(projectId))
  add(query_580354, "pageSize", newJInt(pageSize))
  add(path_580353, "historyId", newJString(historyId))
  add(query_580354, "prettyPrint", newJBool(prettyPrint))
  add(path_580353, "executionId", newJString(executionId))
  result = call_580352.call(path_580353, query_580354, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsThumbnailsList* = Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_580335(
    name: "toolresultsProjectsHistoriesExecutionsStepsThumbnailsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/thumbnails", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_580336,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_580337,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_580355 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_580357(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_580356(
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
  var valid_580358 = path.getOrDefault("stepId")
  valid_580358 = validateParameter(valid_580358, JString, required = true,
                                 default = nil)
  if valid_580358 != nil:
    section.add "stepId", valid_580358
  var valid_580359 = path.getOrDefault("projectId")
  valid_580359 = validateParameter(valid_580359, JString, required = true,
                                 default = nil)
  if valid_580359 != nil:
    section.add "projectId", valid_580359
  var valid_580360 = path.getOrDefault("historyId")
  valid_580360 = validateParameter(valid_580360, JString, required = true,
                                 default = nil)
  if valid_580360 != nil:
    section.add "historyId", valid_580360
  var valid_580361 = path.getOrDefault("executionId")
  valid_580361 = validateParameter(valid_580361, JString, required = true,
                                 default = nil)
  if valid_580361 != nil:
    section.add "executionId", valid_580361
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
  var valid_580362 = query.getOrDefault("fields")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "fields", valid_580362
  var valid_580363 = query.getOrDefault("quotaUser")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "quotaUser", valid_580363
  var valid_580364 = query.getOrDefault("alt")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = newJString("json"))
  if valid_580364 != nil:
    section.add "alt", valid_580364
  var valid_580365 = query.getOrDefault("oauth_token")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "oauth_token", valid_580365
  var valid_580366 = query.getOrDefault("userIp")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "userIp", valid_580366
  var valid_580367 = query.getOrDefault("key")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "key", valid_580367
  var valid_580368 = query.getOrDefault("prettyPrint")
  valid_580368 = validateParameter(valid_580368, JBool, required = false,
                                 default = newJBool(true))
  if valid_580368 != nil:
    section.add "prettyPrint", valid_580368
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

proc call*(call_580370: Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_580355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Publish xml files to an existing Step.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal, e.g try to upload a duplicate xml file or a file too large. - NOT_FOUND - if the containing Execution does not exist
  ## 
  let valid = call_580370.validator(path, query, header, formData, body)
  let scheme = call_580370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580370.url(scheme.get, call_580370.host, call_580370.base,
                         call_580370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580370, url, valid)

proc call*(call_580371: Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_580355;
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
  var path_580372 = newJObject()
  var query_580373 = newJObject()
  var body_580374 = newJObject()
  add(path_580372, "stepId", newJString(stepId))
  add(query_580373, "fields", newJString(fields))
  add(query_580373, "quotaUser", newJString(quotaUser))
  add(query_580373, "alt", newJString(alt))
  add(query_580373, "oauth_token", newJString(oauthToken))
  add(query_580373, "userIp", newJString(userIp))
  add(query_580373, "key", newJString(key))
  add(path_580372, "projectId", newJString(projectId))
  add(path_580372, "historyId", newJString(historyId))
  if body != nil:
    body_580374 = body
  add(query_580373, "prettyPrint", newJBool(prettyPrint))
  add(path_580372, "executionId", newJString(executionId))
  result = call_580371.call(path_580372, query_580373, nil, nil, body_580374)

var toolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles* = Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_580355(
    name: "toolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}:publishXunitXmlFiles", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_580356,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_580357,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsGetSettings_580375 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsGetSettings_580377(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsGetSettings_580376(path: JsonNode;
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
  var valid_580378 = path.getOrDefault("projectId")
  valid_580378 = validateParameter(valid_580378, JString, required = true,
                                 default = nil)
  if valid_580378 != nil:
    section.add "projectId", valid_580378
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
  var valid_580379 = query.getOrDefault("fields")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "fields", valid_580379
  var valid_580380 = query.getOrDefault("quotaUser")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "quotaUser", valid_580380
  var valid_580381 = query.getOrDefault("alt")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = newJString("json"))
  if valid_580381 != nil:
    section.add "alt", valid_580381
  var valid_580382 = query.getOrDefault("oauth_token")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "oauth_token", valid_580382
  var valid_580383 = query.getOrDefault("userIp")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "userIp", valid_580383
  var valid_580384 = query.getOrDefault("key")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "key", valid_580384
  var valid_580385 = query.getOrDefault("prettyPrint")
  valid_580385 = validateParameter(valid_580385, JBool, required = false,
                                 default = newJBool(true))
  if valid_580385 != nil:
    section.add "prettyPrint", valid_580385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580386: Call_ToolresultsProjectsGetSettings_580375; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Tool Results settings for a project.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read from project
  ## 
  let valid = call_580386.validator(path, query, header, formData, body)
  let scheme = call_580386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580386.url(scheme.get, call_580386.host, call_580386.base,
                         call_580386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580386, url, valid)

proc call*(call_580387: Call_ToolresultsProjectsGetSettings_580375;
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
  var path_580388 = newJObject()
  var query_580389 = newJObject()
  add(query_580389, "fields", newJString(fields))
  add(query_580389, "quotaUser", newJString(quotaUser))
  add(query_580389, "alt", newJString(alt))
  add(query_580389, "oauth_token", newJString(oauthToken))
  add(query_580389, "userIp", newJString(userIp))
  add(query_580389, "key", newJString(key))
  add(path_580388, "projectId", newJString(projectId))
  add(query_580389, "prettyPrint", newJBool(prettyPrint))
  result = call_580387.call(path_580388, query_580389, nil, nil, nil)

var toolresultsProjectsGetSettings* = Call_ToolresultsProjectsGetSettings_580375(
    name: "toolresultsProjectsGetSettings", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectId}/settings",
    validator: validate_ToolresultsProjectsGetSettings_580376,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsGetSettings_580377, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsInitializeSettings_580390 = ref object of OpenApiRestCall_579421
proc url_ToolresultsProjectsInitializeSettings_580392(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ToolresultsProjectsInitializeSettings_580391(path: JsonNode;
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
  var valid_580393 = path.getOrDefault("projectId")
  valid_580393 = validateParameter(valid_580393, JString, required = true,
                                 default = nil)
  if valid_580393 != nil:
    section.add "projectId", valid_580393
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
  var valid_580394 = query.getOrDefault("fields")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "fields", valid_580394
  var valid_580395 = query.getOrDefault("quotaUser")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "quotaUser", valid_580395
  var valid_580396 = query.getOrDefault("alt")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = newJString("json"))
  if valid_580396 != nil:
    section.add "alt", valid_580396
  var valid_580397 = query.getOrDefault("oauth_token")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "oauth_token", valid_580397
  var valid_580398 = query.getOrDefault("userIp")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "userIp", valid_580398
  var valid_580399 = query.getOrDefault("key")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "key", valid_580399
  var valid_580400 = query.getOrDefault("prettyPrint")
  valid_580400 = validateParameter(valid_580400, JBool, required = false,
                                 default = newJBool(true))
  if valid_580400 != nil:
    section.add "prettyPrint", valid_580400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580401: Call_ToolresultsProjectsInitializeSettings_580390;
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
  let valid = call_580401.validator(path, query, header, formData, body)
  let scheme = call_580401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580401.url(scheme.get, call_580401.host, call_580401.base,
                         call_580401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580401, url, valid)

proc call*(call_580402: Call_ToolresultsProjectsInitializeSettings_580390;
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
  var path_580403 = newJObject()
  var query_580404 = newJObject()
  add(query_580404, "fields", newJString(fields))
  add(query_580404, "quotaUser", newJString(quotaUser))
  add(query_580404, "alt", newJString(alt))
  add(query_580404, "oauth_token", newJString(oauthToken))
  add(query_580404, "userIp", newJString(userIp))
  add(query_580404, "key", newJString(key))
  add(path_580403, "projectId", newJString(projectId))
  add(query_580404, "prettyPrint", newJBool(prettyPrint))
  result = call_580402.call(path_580403, query_580404, nil, nil, nil)

var toolresultsProjectsInitializeSettings* = Call_ToolresultsProjectsInitializeSettings_580390(
    name: "toolresultsProjectsInitializeSettings", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectId}:initializeSettings",
    validator: validate_ToolresultsProjectsInitializeSettings_580391,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsInitializeSettings_580392, schemes: {Scheme.Https})
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
