
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
  gcpServiceName = "toolresults"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ToolresultsProjectsHistoriesCreate_589005 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesCreate_589007(protocol: Scheme; host: string;
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

proc validate_ToolresultsProjectsHistoriesCreate_589006(path: JsonNode;
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
  var valid_589008 = path.getOrDefault("projectId")
  valid_589008 = validateParameter(valid_589008, JString, required = true,
                                 default = nil)
  if valid_589008 != nil:
    section.add "projectId", valid_589008
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
  var valid_589009 = query.getOrDefault("fields")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "fields", valid_589009
  var valid_589010 = query.getOrDefault("requestId")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "requestId", valid_589010
  var valid_589011 = query.getOrDefault("quotaUser")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "quotaUser", valid_589011
  var valid_589012 = query.getOrDefault("alt")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("json"))
  if valid_589012 != nil:
    section.add "alt", valid_589012
  var valid_589013 = query.getOrDefault("oauth_token")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "oauth_token", valid_589013
  var valid_589014 = query.getOrDefault("userIp")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "userIp", valid_589014
  var valid_589015 = query.getOrDefault("key")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "key", valid_589015
  var valid_589016 = query.getOrDefault("prettyPrint")
  valid_589016 = validateParameter(valid_589016, JBool, required = false,
                                 default = newJBool(true))
  if valid_589016 != nil:
    section.add "prettyPrint", valid_589016
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

proc call*(call_589018: Call_ToolresultsProjectsHistoriesCreate_589005;
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
  let valid = call_589018.validator(path, query, header, formData, body)
  let scheme = call_589018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589018.url(scheme.get, call_589018.host, call_589018.base,
                         call_589018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589018, url, valid)

proc call*(call_589019: Call_ToolresultsProjectsHistoriesCreate_589005;
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
  var path_589020 = newJObject()
  var query_589021 = newJObject()
  var body_589022 = newJObject()
  add(query_589021, "fields", newJString(fields))
  add(query_589021, "requestId", newJString(requestId))
  add(query_589021, "quotaUser", newJString(quotaUser))
  add(query_589021, "alt", newJString(alt))
  add(query_589021, "oauth_token", newJString(oauthToken))
  add(query_589021, "userIp", newJString(userIp))
  add(query_589021, "key", newJString(key))
  add(path_589020, "projectId", newJString(projectId))
  if body != nil:
    body_589022 = body
  add(query_589021, "prettyPrint", newJBool(prettyPrint))
  result = call_589019.call(path_589020, query_589021, nil, nil, body_589022)

var toolresultsProjectsHistoriesCreate* = Call_ToolresultsProjectsHistoriesCreate_589005(
    name: "toolresultsProjectsHistoriesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectId}/histories",
    validator: validate_ToolresultsProjectsHistoriesCreate_589006,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesCreate_589007, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesList_588718 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesList_588720(protocol: Scheme; host: string;
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

proc validate_ToolresultsProjectsHistoriesList_588719(path: JsonNode;
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
  var valid_588846 = path.getOrDefault("projectId")
  valid_588846 = validateParameter(valid_588846, JString, required = true,
                                 default = nil)
  if valid_588846 != nil:
    section.add "projectId", valid_588846
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
  var valid_588847 = query.getOrDefault("fields")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "fields", valid_588847
  var valid_588848 = query.getOrDefault("pageToken")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "pageToken", valid_588848
  var valid_588849 = query.getOrDefault("quotaUser")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "quotaUser", valid_588849
  var valid_588863 = query.getOrDefault("alt")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = newJString("json"))
  if valid_588863 != nil:
    section.add "alt", valid_588863
  var valid_588864 = query.getOrDefault("oauth_token")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "oauth_token", valid_588864
  var valid_588865 = query.getOrDefault("userIp")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "userIp", valid_588865
  var valid_588866 = query.getOrDefault("key")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "key", valid_588866
  var valid_588867 = query.getOrDefault("pageSize")
  valid_588867 = validateParameter(valid_588867, JInt, required = false, default = nil)
  if valid_588867 != nil:
    section.add "pageSize", valid_588867
  var valid_588868 = query.getOrDefault("filterByName")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "filterByName", valid_588868
  var valid_588869 = query.getOrDefault("prettyPrint")
  valid_588869 = validateParameter(valid_588869, JBool, required = false,
                                 default = newJBool(true))
  if valid_588869 != nil:
    section.add "prettyPrint", valid_588869
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588892: Call_ToolresultsProjectsHistoriesList_588718;
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
  let valid = call_588892.validator(path, query, header, formData, body)
  let scheme = call_588892.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588892.url(scheme.get, call_588892.host, call_588892.base,
                         call_588892.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588892, url, valid)

proc call*(call_588963: Call_ToolresultsProjectsHistoriesList_588718;
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
  var path_588964 = newJObject()
  var query_588966 = newJObject()
  add(query_588966, "fields", newJString(fields))
  add(query_588966, "pageToken", newJString(pageToken))
  add(query_588966, "quotaUser", newJString(quotaUser))
  add(query_588966, "alt", newJString(alt))
  add(query_588966, "oauth_token", newJString(oauthToken))
  add(query_588966, "userIp", newJString(userIp))
  add(query_588966, "key", newJString(key))
  add(path_588964, "projectId", newJString(projectId))
  add(query_588966, "pageSize", newJInt(pageSize))
  add(query_588966, "filterByName", newJString(filterByName))
  add(query_588966, "prettyPrint", newJBool(prettyPrint))
  result = call_588963.call(path_588964, query_588966, nil, nil, nil)

var toolresultsProjectsHistoriesList* = Call_ToolresultsProjectsHistoriesList_588718(
    name: "toolresultsProjectsHistoriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectId}/histories",
    validator: validate_ToolresultsProjectsHistoriesList_588719,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesList_588720, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesGet_589023 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesGet_589025(protocol: Scheme; host: string;
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

proc validate_ToolresultsProjectsHistoriesGet_589024(path: JsonNode;
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
  var valid_589026 = path.getOrDefault("projectId")
  valid_589026 = validateParameter(valid_589026, JString, required = true,
                                 default = nil)
  if valid_589026 != nil:
    section.add "projectId", valid_589026
  var valid_589027 = path.getOrDefault("historyId")
  valid_589027 = validateParameter(valid_589027, JString, required = true,
                                 default = nil)
  if valid_589027 != nil:
    section.add "historyId", valid_589027
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
  var valid_589028 = query.getOrDefault("fields")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "fields", valid_589028
  var valid_589029 = query.getOrDefault("quotaUser")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "quotaUser", valid_589029
  var valid_589030 = query.getOrDefault("alt")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = newJString("json"))
  if valid_589030 != nil:
    section.add "alt", valid_589030
  var valid_589031 = query.getOrDefault("oauth_token")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "oauth_token", valid_589031
  var valid_589032 = query.getOrDefault("userIp")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "userIp", valid_589032
  var valid_589033 = query.getOrDefault("key")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "key", valid_589033
  var valid_589034 = query.getOrDefault("prettyPrint")
  valid_589034 = validateParameter(valid_589034, JBool, required = false,
                                 default = newJBool(true))
  if valid_589034 != nil:
    section.add "prettyPrint", valid_589034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589035: Call_ToolresultsProjectsHistoriesGet_589023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a History.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the History does not exist
  ## 
  let valid = call_589035.validator(path, query, header, formData, body)
  let scheme = call_589035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589035.url(scheme.get, call_589035.host, call_589035.base,
                         call_589035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589035, url, valid)

proc call*(call_589036: Call_ToolresultsProjectsHistoriesGet_589023;
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
  var path_589037 = newJObject()
  var query_589038 = newJObject()
  add(query_589038, "fields", newJString(fields))
  add(query_589038, "quotaUser", newJString(quotaUser))
  add(query_589038, "alt", newJString(alt))
  add(query_589038, "oauth_token", newJString(oauthToken))
  add(query_589038, "userIp", newJString(userIp))
  add(query_589038, "key", newJString(key))
  add(path_589037, "projectId", newJString(projectId))
  add(path_589037, "historyId", newJString(historyId))
  add(query_589038, "prettyPrint", newJBool(prettyPrint))
  result = call_589036.call(path_589037, query_589038, nil, nil, nil)

var toolresultsProjectsHistoriesGet* = Call_ToolresultsProjectsHistoriesGet_589023(
    name: "toolresultsProjectsHistoriesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}",
    validator: validate_ToolresultsProjectsHistoriesGet_589024,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesGet_589025, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsCreate_589057 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsCreate_589059(protocol: Scheme;
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

proc validate_ToolresultsProjectsHistoriesExecutionsCreate_589058(path: JsonNode;
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
  var valid_589060 = path.getOrDefault("projectId")
  valid_589060 = validateParameter(valid_589060, JString, required = true,
                                 default = nil)
  if valid_589060 != nil:
    section.add "projectId", valid_589060
  var valid_589061 = path.getOrDefault("historyId")
  valid_589061 = validateParameter(valid_589061, JString, required = true,
                                 default = nil)
  if valid_589061 != nil:
    section.add "historyId", valid_589061
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
  var valid_589062 = query.getOrDefault("fields")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "fields", valid_589062
  var valid_589063 = query.getOrDefault("requestId")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "requestId", valid_589063
  var valid_589064 = query.getOrDefault("quotaUser")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "quotaUser", valid_589064
  var valid_589065 = query.getOrDefault("alt")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = newJString("json"))
  if valid_589065 != nil:
    section.add "alt", valid_589065
  var valid_589066 = query.getOrDefault("oauth_token")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "oauth_token", valid_589066
  var valid_589067 = query.getOrDefault("userIp")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "userIp", valid_589067
  var valid_589068 = query.getOrDefault("key")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "key", valid_589068
  var valid_589069 = query.getOrDefault("prettyPrint")
  valid_589069 = validateParameter(valid_589069, JBool, required = false,
                                 default = newJBool(true))
  if valid_589069 != nil:
    section.add "prettyPrint", valid_589069
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

proc call*(call_589071: Call_ToolresultsProjectsHistoriesExecutionsCreate_589057;
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
  let valid = call_589071.validator(path, query, header, formData, body)
  let scheme = call_589071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589071.url(scheme.get, call_589071.host, call_589071.base,
                         call_589071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589071, url, valid)

proc call*(call_589072: Call_ToolresultsProjectsHistoriesExecutionsCreate_589057;
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
  var path_589073 = newJObject()
  var query_589074 = newJObject()
  var body_589075 = newJObject()
  add(query_589074, "fields", newJString(fields))
  add(query_589074, "requestId", newJString(requestId))
  add(query_589074, "quotaUser", newJString(quotaUser))
  add(query_589074, "alt", newJString(alt))
  add(query_589074, "oauth_token", newJString(oauthToken))
  add(query_589074, "userIp", newJString(userIp))
  add(query_589074, "key", newJString(key))
  add(path_589073, "projectId", newJString(projectId))
  add(path_589073, "historyId", newJString(historyId))
  if body != nil:
    body_589075 = body
  add(query_589074, "prettyPrint", newJBool(prettyPrint))
  result = call_589072.call(path_589073, query_589074, nil, nil, body_589075)

var toolresultsProjectsHistoriesExecutionsCreate* = Call_ToolresultsProjectsHistoriesExecutionsCreate_589057(
    name: "toolresultsProjectsHistoriesExecutionsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions",
    validator: validate_ToolresultsProjectsHistoriesExecutionsCreate_589058,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsCreate_589059,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsList_589039 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsList_589041(protocol: Scheme;
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

proc validate_ToolresultsProjectsHistoriesExecutionsList_589040(path: JsonNode;
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
  var valid_589042 = path.getOrDefault("projectId")
  valid_589042 = validateParameter(valid_589042, JString, required = true,
                                 default = nil)
  if valid_589042 != nil:
    section.add "projectId", valid_589042
  var valid_589043 = path.getOrDefault("historyId")
  valid_589043 = validateParameter(valid_589043, JString, required = true,
                                 default = nil)
  if valid_589043 != nil:
    section.add "historyId", valid_589043
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
  var valid_589044 = query.getOrDefault("fields")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "fields", valid_589044
  var valid_589045 = query.getOrDefault("pageToken")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "pageToken", valid_589045
  var valid_589046 = query.getOrDefault("quotaUser")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "quotaUser", valid_589046
  var valid_589047 = query.getOrDefault("alt")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("json"))
  if valid_589047 != nil:
    section.add "alt", valid_589047
  var valid_589048 = query.getOrDefault("oauth_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "oauth_token", valid_589048
  var valid_589049 = query.getOrDefault("userIp")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "userIp", valid_589049
  var valid_589050 = query.getOrDefault("key")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "key", valid_589050
  var valid_589051 = query.getOrDefault("pageSize")
  valid_589051 = validateParameter(valid_589051, JInt, required = false, default = nil)
  if valid_589051 != nil:
    section.add "pageSize", valid_589051
  var valid_589052 = query.getOrDefault("prettyPrint")
  valid_589052 = validateParameter(valid_589052, JBool, required = false,
                                 default = newJBool(true))
  if valid_589052 != nil:
    section.add "prettyPrint", valid_589052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589053: Call_ToolresultsProjectsHistoriesExecutionsList_589039;
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
  let valid = call_589053.validator(path, query, header, formData, body)
  let scheme = call_589053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589053.url(scheme.get, call_589053.host, call_589053.base,
                         call_589053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589053, url, valid)

proc call*(call_589054: Call_ToolresultsProjectsHistoriesExecutionsList_589039;
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
  var path_589055 = newJObject()
  var query_589056 = newJObject()
  add(query_589056, "fields", newJString(fields))
  add(query_589056, "pageToken", newJString(pageToken))
  add(query_589056, "quotaUser", newJString(quotaUser))
  add(query_589056, "alt", newJString(alt))
  add(query_589056, "oauth_token", newJString(oauthToken))
  add(query_589056, "userIp", newJString(userIp))
  add(query_589056, "key", newJString(key))
  add(path_589055, "projectId", newJString(projectId))
  add(query_589056, "pageSize", newJInt(pageSize))
  add(path_589055, "historyId", newJString(historyId))
  add(query_589056, "prettyPrint", newJBool(prettyPrint))
  result = call_589054.call(path_589055, query_589056, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsList* = Call_ToolresultsProjectsHistoriesExecutionsList_589039(
    name: "toolresultsProjectsHistoriesExecutionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions",
    validator: validate_ToolresultsProjectsHistoriesExecutionsList_589040,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsList_589041,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsGet_589076 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsGet_589078(protocol: Scheme;
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

proc validate_ToolresultsProjectsHistoriesExecutionsGet_589077(path: JsonNode;
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
  var valid_589079 = path.getOrDefault("projectId")
  valid_589079 = validateParameter(valid_589079, JString, required = true,
                                 default = nil)
  if valid_589079 != nil:
    section.add "projectId", valid_589079
  var valid_589080 = path.getOrDefault("historyId")
  valid_589080 = validateParameter(valid_589080, JString, required = true,
                                 default = nil)
  if valid_589080 != nil:
    section.add "historyId", valid_589080
  var valid_589081 = path.getOrDefault("executionId")
  valid_589081 = validateParameter(valid_589081, JString, required = true,
                                 default = nil)
  if valid_589081 != nil:
    section.add "executionId", valid_589081
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
  var valid_589082 = query.getOrDefault("fields")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "fields", valid_589082
  var valid_589083 = query.getOrDefault("quotaUser")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "quotaUser", valid_589083
  var valid_589084 = query.getOrDefault("alt")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = newJString("json"))
  if valid_589084 != nil:
    section.add "alt", valid_589084
  var valid_589085 = query.getOrDefault("oauth_token")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "oauth_token", valid_589085
  var valid_589086 = query.getOrDefault("userIp")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "userIp", valid_589086
  var valid_589087 = query.getOrDefault("key")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "key", valid_589087
  var valid_589088 = query.getOrDefault("prettyPrint")
  valid_589088 = validateParameter(valid_589088, JBool, required = false,
                                 default = newJBool(true))
  if valid_589088 != nil:
    section.add "prettyPrint", valid_589088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589089: Call_ToolresultsProjectsHistoriesExecutionsGet_589076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an Execution.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the Execution does not exist
  ## 
  let valid = call_589089.validator(path, query, header, formData, body)
  let scheme = call_589089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589089.url(scheme.get, call_589089.host, call_589089.base,
                         call_589089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589089, url, valid)

proc call*(call_589090: Call_ToolresultsProjectsHistoriesExecutionsGet_589076;
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
  var path_589091 = newJObject()
  var query_589092 = newJObject()
  add(query_589092, "fields", newJString(fields))
  add(query_589092, "quotaUser", newJString(quotaUser))
  add(query_589092, "alt", newJString(alt))
  add(query_589092, "oauth_token", newJString(oauthToken))
  add(query_589092, "userIp", newJString(userIp))
  add(query_589092, "key", newJString(key))
  add(path_589091, "projectId", newJString(projectId))
  add(path_589091, "historyId", newJString(historyId))
  add(query_589092, "prettyPrint", newJBool(prettyPrint))
  add(path_589091, "executionId", newJString(executionId))
  result = call_589090.call(path_589091, query_589092, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsGet* = Call_ToolresultsProjectsHistoriesExecutionsGet_589076(
    name: "toolresultsProjectsHistoriesExecutionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsGet_589077,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsGet_589078,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsPatch_589093 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsPatch_589095(protocol: Scheme;
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

proc validate_ToolresultsProjectsHistoriesExecutionsPatch_589094(path: JsonNode;
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
  var valid_589096 = path.getOrDefault("projectId")
  valid_589096 = validateParameter(valid_589096, JString, required = true,
                                 default = nil)
  if valid_589096 != nil:
    section.add "projectId", valid_589096
  var valid_589097 = path.getOrDefault("historyId")
  valid_589097 = validateParameter(valid_589097, JString, required = true,
                                 default = nil)
  if valid_589097 != nil:
    section.add "historyId", valid_589097
  var valid_589098 = path.getOrDefault("executionId")
  valid_589098 = validateParameter(valid_589098, JString, required = true,
                                 default = nil)
  if valid_589098 != nil:
    section.add "executionId", valid_589098
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
  var valid_589099 = query.getOrDefault("fields")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "fields", valid_589099
  var valid_589100 = query.getOrDefault("requestId")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "requestId", valid_589100
  var valid_589101 = query.getOrDefault("quotaUser")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "quotaUser", valid_589101
  var valid_589102 = query.getOrDefault("alt")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = newJString("json"))
  if valid_589102 != nil:
    section.add "alt", valid_589102
  var valid_589103 = query.getOrDefault("oauth_token")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "oauth_token", valid_589103
  var valid_589104 = query.getOrDefault("userIp")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "userIp", valid_589104
  var valid_589105 = query.getOrDefault("key")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "key", valid_589105
  var valid_589106 = query.getOrDefault("prettyPrint")
  valid_589106 = validateParameter(valid_589106, JBool, required = false,
                                 default = newJBool(true))
  if valid_589106 != nil:
    section.add "prettyPrint", valid_589106
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

proc call*(call_589108: Call_ToolresultsProjectsHistoriesExecutionsPatch_589093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing Execution with the supplied partial entity.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal - NOT_FOUND - if the containing History does not exist
  ## 
  let valid = call_589108.validator(path, query, header, formData, body)
  let scheme = call_589108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589108.url(scheme.get, call_589108.host, call_589108.base,
                         call_589108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589108, url, valid)

proc call*(call_589109: Call_ToolresultsProjectsHistoriesExecutionsPatch_589093;
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
  var path_589110 = newJObject()
  var query_589111 = newJObject()
  var body_589112 = newJObject()
  add(query_589111, "fields", newJString(fields))
  add(query_589111, "requestId", newJString(requestId))
  add(query_589111, "quotaUser", newJString(quotaUser))
  add(query_589111, "alt", newJString(alt))
  add(query_589111, "oauth_token", newJString(oauthToken))
  add(query_589111, "userIp", newJString(userIp))
  add(query_589111, "key", newJString(key))
  add(path_589110, "projectId", newJString(projectId))
  add(path_589110, "historyId", newJString(historyId))
  if body != nil:
    body_589112 = body
  add(query_589111, "prettyPrint", newJBool(prettyPrint))
  add(path_589110, "executionId", newJString(executionId))
  result = call_589109.call(path_589110, query_589111, nil, nil, body_589112)

var toolresultsProjectsHistoriesExecutionsPatch* = Call_ToolresultsProjectsHistoriesExecutionsPatch_589093(
    name: "toolresultsProjectsHistoriesExecutionsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsPatch_589094,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsPatch_589095,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsClustersList_589113 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsClustersList_589115(
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

proc validate_ToolresultsProjectsHistoriesExecutionsClustersList_589114(
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
  var valid_589116 = path.getOrDefault("projectId")
  valid_589116 = validateParameter(valid_589116, JString, required = true,
                                 default = nil)
  if valid_589116 != nil:
    section.add "projectId", valid_589116
  var valid_589117 = path.getOrDefault("historyId")
  valid_589117 = validateParameter(valid_589117, JString, required = true,
                                 default = nil)
  if valid_589117 != nil:
    section.add "historyId", valid_589117
  var valid_589118 = path.getOrDefault("executionId")
  valid_589118 = validateParameter(valid_589118, JString, required = true,
                                 default = nil)
  if valid_589118 != nil:
    section.add "executionId", valid_589118
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
  var valid_589119 = query.getOrDefault("fields")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "fields", valid_589119
  var valid_589120 = query.getOrDefault("quotaUser")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "quotaUser", valid_589120
  var valid_589121 = query.getOrDefault("alt")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = newJString("json"))
  if valid_589121 != nil:
    section.add "alt", valid_589121
  var valid_589122 = query.getOrDefault("oauth_token")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "oauth_token", valid_589122
  var valid_589123 = query.getOrDefault("userIp")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "userIp", valid_589123
  var valid_589124 = query.getOrDefault("key")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "key", valid_589124
  var valid_589125 = query.getOrDefault("prettyPrint")
  valid_589125 = validateParameter(valid_589125, JBool, required = false,
                                 default = newJBool(true))
  if valid_589125 != nil:
    section.add "prettyPrint", valid_589125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589126: Call_ToolresultsProjectsHistoriesExecutionsClustersList_589113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Screenshot Clusters
  ## 
  ## Returns the list of screenshot clusters corresponding to an execution. Screenshot clusters are created after the execution is finished. Clusters are created from a set of screenshots. Between any two screenshots, a matching score is calculated based off their metadata that determines how similar they are. Screenshots are placed in the cluster that has screens which have the highest matching scores.
  ## 
  let valid = call_589126.validator(path, query, header, formData, body)
  let scheme = call_589126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589126.url(scheme.get, call_589126.host, call_589126.base,
                         call_589126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589126, url, valid)

proc call*(call_589127: Call_ToolresultsProjectsHistoriesExecutionsClustersList_589113;
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
  var path_589128 = newJObject()
  var query_589129 = newJObject()
  add(query_589129, "fields", newJString(fields))
  add(query_589129, "quotaUser", newJString(quotaUser))
  add(query_589129, "alt", newJString(alt))
  add(query_589129, "oauth_token", newJString(oauthToken))
  add(query_589129, "userIp", newJString(userIp))
  add(query_589129, "key", newJString(key))
  add(path_589128, "projectId", newJString(projectId))
  add(path_589128, "historyId", newJString(historyId))
  add(query_589129, "prettyPrint", newJBool(prettyPrint))
  add(path_589128, "executionId", newJString(executionId))
  result = call_589127.call(path_589128, query_589129, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsClustersList* = Call_ToolresultsProjectsHistoriesExecutionsClustersList_589113(
    name: "toolresultsProjectsHistoriesExecutionsClustersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/clusters",
    validator: validate_ToolresultsProjectsHistoriesExecutionsClustersList_589114,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsClustersList_589115,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsClustersGet_589130 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsClustersGet_589132(
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

proc validate_ToolresultsProjectsHistoriesExecutionsClustersGet_589131(
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
  var valid_589133 = path.getOrDefault("projectId")
  valid_589133 = validateParameter(valid_589133, JString, required = true,
                                 default = nil)
  if valid_589133 != nil:
    section.add "projectId", valid_589133
  var valid_589134 = path.getOrDefault("historyId")
  valid_589134 = validateParameter(valid_589134, JString, required = true,
                                 default = nil)
  if valid_589134 != nil:
    section.add "historyId", valid_589134
  var valid_589135 = path.getOrDefault("clusterId")
  valid_589135 = validateParameter(valid_589135, JString, required = true,
                                 default = nil)
  if valid_589135 != nil:
    section.add "clusterId", valid_589135
  var valid_589136 = path.getOrDefault("executionId")
  valid_589136 = validateParameter(valid_589136, JString, required = true,
                                 default = nil)
  if valid_589136 != nil:
    section.add "executionId", valid_589136
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
  var valid_589137 = query.getOrDefault("fields")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "fields", valid_589137
  var valid_589138 = query.getOrDefault("quotaUser")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "quotaUser", valid_589138
  var valid_589139 = query.getOrDefault("alt")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = newJString("json"))
  if valid_589139 != nil:
    section.add "alt", valid_589139
  var valid_589140 = query.getOrDefault("oauth_token")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "oauth_token", valid_589140
  var valid_589141 = query.getOrDefault("userIp")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "userIp", valid_589141
  var valid_589142 = query.getOrDefault("key")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "key", valid_589142
  var valid_589143 = query.getOrDefault("prettyPrint")
  valid_589143 = validateParameter(valid_589143, JBool, required = false,
                                 default = newJBool(true))
  if valid_589143 != nil:
    section.add "prettyPrint", valid_589143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589144: Call_ToolresultsProjectsHistoriesExecutionsClustersGet_589130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a single screenshot cluster by its ID
  ## 
  let valid = call_589144.validator(path, query, header, formData, body)
  let scheme = call_589144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589144.url(scheme.get, call_589144.host, call_589144.base,
                         call_589144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589144, url, valid)

proc call*(call_589145: Call_ToolresultsProjectsHistoriesExecutionsClustersGet_589130;
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
  var path_589146 = newJObject()
  var query_589147 = newJObject()
  add(query_589147, "fields", newJString(fields))
  add(query_589147, "quotaUser", newJString(quotaUser))
  add(query_589147, "alt", newJString(alt))
  add(query_589147, "oauth_token", newJString(oauthToken))
  add(query_589147, "userIp", newJString(userIp))
  add(query_589147, "key", newJString(key))
  add(path_589146, "projectId", newJString(projectId))
  add(path_589146, "historyId", newJString(historyId))
  add(query_589147, "prettyPrint", newJBool(prettyPrint))
  add(path_589146, "clusterId", newJString(clusterId))
  add(path_589146, "executionId", newJString(executionId))
  result = call_589145.call(path_589146, query_589147, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsClustersGet* = Call_ToolresultsProjectsHistoriesExecutionsClustersGet_589130(
    name: "toolresultsProjectsHistoriesExecutionsClustersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/clusters/{clusterId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsClustersGet_589131,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsClustersGet_589132,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_589167 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsStepsCreate_589169(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsCreate_589168(
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
  var valid_589170 = path.getOrDefault("projectId")
  valid_589170 = validateParameter(valid_589170, JString, required = true,
                                 default = nil)
  if valid_589170 != nil:
    section.add "projectId", valid_589170
  var valid_589171 = path.getOrDefault("historyId")
  valid_589171 = validateParameter(valid_589171, JString, required = true,
                                 default = nil)
  if valid_589171 != nil:
    section.add "historyId", valid_589171
  var valid_589172 = path.getOrDefault("executionId")
  valid_589172 = validateParameter(valid_589172, JString, required = true,
                                 default = nil)
  if valid_589172 != nil:
    section.add "executionId", valid_589172
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
  var valid_589173 = query.getOrDefault("fields")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "fields", valid_589173
  var valid_589174 = query.getOrDefault("requestId")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "requestId", valid_589174
  var valid_589175 = query.getOrDefault("quotaUser")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "quotaUser", valid_589175
  var valid_589176 = query.getOrDefault("alt")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = newJString("json"))
  if valid_589176 != nil:
    section.add "alt", valid_589176
  var valid_589177 = query.getOrDefault("oauth_token")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "oauth_token", valid_589177
  var valid_589178 = query.getOrDefault("userIp")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "userIp", valid_589178
  var valid_589179 = query.getOrDefault("key")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "key", valid_589179
  var valid_589180 = query.getOrDefault("prettyPrint")
  valid_589180 = validateParameter(valid_589180, JBool, required = false,
                                 default = newJBool(true))
  if valid_589180 != nil:
    section.add "prettyPrint", valid_589180
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

proc call*(call_589182: Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_589167;
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
  let valid = call_589182.validator(path, query, header, formData, body)
  let scheme = call_589182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589182.url(scheme.get, call_589182.host, call_589182.base,
                         call_589182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589182, url, valid)

proc call*(call_589183: Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_589167;
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
  var path_589184 = newJObject()
  var query_589185 = newJObject()
  var body_589186 = newJObject()
  add(query_589185, "fields", newJString(fields))
  add(query_589185, "requestId", newJString(requestId))
  add(query_589185, "quotaUser", newJString(quotaUser))
  add(query_589185, "alt", newJString(alt))
  add(query_589185, "oauth_token", newJString(oauthToken))
  add(query_589185, "userIp", newJString(userIp))
  add(query_589185, "key", newJString(key))
  add(path_589184, "projectId", newJString(projectId))
  add(path_589184, "historyId", newJString(historyId))
  if body != nil:
    body_589186 = body
  add(query_589185, "prettyPrint", newJBool(prettyPrint))
  add(path_589184, "executionId", newJString(executionId))
  result = call_589183.call(path_589184, query_589185, nil, nil, body_589186)

var toolresultsProjectsHistoriesExecutionsStepsCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_589167(
    name: "toolresultsProjectsHistoriesExecutionsStepsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsCreate_589168,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsCreate_589169,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsList_589148 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsStepsList_589150(protocol: Scheme;
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsList_589149(
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
  var valid_589151 = path.getOrDefault("projectId")
  valid_589151 = validateParameter(valid_589151, JString, required = true,
                                 default = nil)
  if valid_589151 != nil:
    section.add "projectId", valid_589151
  var valid_589152 = path.getOrDefault("historyId")
  valid_589152 = validateParameter(valid_589152, JString, required = true,
                                 default = nil)
  if valid_589152 != nil:
    section.add "historyId", valid_589152
  var valid_589153 = path.getOrDefault("executionId")
  valid_589153 = validateParameter(valid_589153, JString, required = true,
                                 default = nil)
  if valid_589153 != nil:
    section.add "executionId", valid_589153
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
  var valid_589154 = query.getOrDefault("fields")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "fields", valid_589154
  var valid_589155 = query.getOrDefault("pageToken")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "pageToken", valid_589155
  var valid_589156 = query.getOrDefault("quotaUser")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "quotaUser", valid_589156
  var valid_589157 = query.getOrDefault("alt")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = newJString("json"))
  if valid_589157 != nil:
    section.add "alt", valid_589157
  var valid_589158 = query.getOrDefault("oauth_token")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "oauth_token", valid_589158
  var valid_589159 = query.getOrDefault("userIp")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "userIp", valid_589159
  var valid_589160 = query.getOrDefault("key")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "key", valid_589160
  var valid_589161 = query.getOrDefault("pageSize")
  valid_589161 = validateParameter(valid_589161, JInt, required = false, default = nil)
  if valid_589161 != nil:
    section.add "pageSize", valid_589161
  var valid_589162 = query.getOrDefault("prettyPrint")
  valid_589162 = validateParameter(valid_589162, JBool, required = false,
                                 default = newJBool(true))
  if valid_589162 != nil:
    section.add "prettyPrint", valid_589162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589163: Call_ToolresultsProjectsHistoriesExecutionsStepsList_589148;
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
  let valid = call_589163.validator(path, query, header, formData, body)
  let scheme = call_589163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589163.url(scheme.get, call_589163.host, call_589163.base,
                         call_589163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589163, url, valid)

proc call*(call_589164: Call_ToolresultsProjectsHistoriesExecutionsStepsList_589148;
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
  var path_589165 = newJObject()
  var query_589166 = newJObject()
  add(query_589166, "fields", newJString(fields))
  add(query_589166, "pageToken", newJString(pageToken))
  add(query_589166, "quotaUser", newJString(quotaUser))
  add(query_589166, "alt", newJString(alt))
  add(query_589166, "oauth_token", newJString(oauthToken))
  add(query_589166, "userIp", newJString(userIp))
  add(query_589166, "key", newJString(key))
  add(path_589165, "projectId", newJString(projectId))
  add(query_589166, "pageSize", newJInt(pageSize))
  add(path_589165, "historyId", newJString(historyId))
  add(query_589166, "prettyPrint", newJBool(prettyPrint))
  add(path_589165, "executionId", newJString(executionId))
  result = call_589164.call(path_589165, query_589166, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsList* = Call_ToolresultsProjectsHistoriesExecutionsStepsList_589148(
    name: "toolresultsProjectsHistoriesExecutionsStepsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsList_589149,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsList_589150,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsGet_589187 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsStepsGet_589189(protocol: Scheme;
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsGet_589188(
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
  var valid_589190 = path.getOrDefault("stepId")
  valid_589190 = validateParameter(valid_589190, JString, required = true,
                                 default = nil)
  if valid_589190 != nil:
    section.add "stepId", valid_589190
  var valid_589191 = path.getOrDefault("projectId")
  valid_589191 = validateParameter(valid_589191, JString, required = true,
                                 default = nil)
  if valid_589191 != nil:
    section.add "projectId", valid_589191
  var valid_589192 = path.getOrDefault("historyId")
  valid_589192 = validateParameter(valid_589192, JString, required = true,
                                 default = nil)
  if valid_589192 != nil:
    section.add "historyId", valid_589192
  var valid_589193 = path.getOrDefault("executionId")
  valid_589193 = validateParameter(valid_589193, JString, required = true,
                                 default = nil)
  if valid_589193 != nil:
    section.add "executionId", valid_589193
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
  var valid_589194 = query.getOrDefault("fields")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "fields", valid_589194
  var valid_589195 = query.getOrDefault("quotaUser")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "quotaUser", valid_589195
  var valid_589196 = query.getOrDefault("alt")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = newJString("json"))
  if valid_589196 != nil:
    section.add "alt", valid_589196
  var valid_589197 = query.getOrDefault("oauth_token")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "oauth_token", valid_589197
  var valid_589198 = query.getOrDefault("userIp")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "userIp", valid_589198
  var valid_589199 = query.getOrDefault("key")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "key", valid_589199
  var valid_589200 = query.getOrDefault("prettyPrint")
  valid_589200 = validateParameter(valid_589200, JBool, required = false,
                                 default = newJBool(true))
  if valid_589200 != nil:
    section.add "prettyPrint", valid_589200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589201: Call_ToolresultsProjectsHistoriesExecutionsStepsGet_589187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a Step.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the Step does not exist
  ## 
  let valid = call_589201.validator(path, query, header, formData, body)
  let scheme = call_589201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589201.url(scheme.get, call_589201.host, call_589201.base,
                         call_589201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589201, url, valid)

proc call*(call_589202: Call_ToolresultsProjectsHistoriesExecutionsStepsGet_589187;
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
  var path_589203 = newJObject()
  var query_589204 = newJObject()
  add(path_589203, "stepId", newJString(stepId))
  add(query_589204, "fields", newJString(fields))
  add(query_589204, "quotaUser", newJString(quotaUser))
  add(query_589204, "alt", newJString(alt))
  add(query_589204, "oauth_token", newJString(oauthToken))
  add(query_589204, "userIp", newJString(userIp))
  add(query_589204, "key", newJString(key))
  add(path_589203, "projectId", newJString(projectId))
  add(path_589203, "historyId", newJString(historyId))
  add(query_589204, "prettyPrint", newJBool(prettyPrint))
  add(path_589203, "executionId", newJString(executionId))
  result = call_589202.call(path_589203, query_589204, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsGet* = Call_ToolresultsProjectsHistoriesExecutionsStepsGet_589187(
    name: "toolresultsProjectsHistoriesExecutionsStepsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsGet_589188,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsGet_589189,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_589205 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsStepsPatch_589207(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPatch_589206(
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
  var valid_589208 = path.getOrDefault("stepId")
  valid_589208 = validateParameter(valid_589208, JString, required = true,
                                 default = nil)
  if valid_589208 != nil:
    section.add "stepId", valid_589208
  var valid_589209 = path.getOrDefault("projectId")
  valid_589209 = validateParameter(valid_589209, JString, required = true,
                                 default = nil)
  if valid_589209 != nil:
    section.add "projectId", valid_589209
  var valid_589210 = path.getOrDefault("historyId")
  valid_589210 = validateParameter(valid_589210, JString, required = true,
                                 default = nil)
  if valid_589210 != nil:
    section.add "historyId", valid_589210
  var valid_589211 = path.getOrDefault("executionId")
  valid_589211 = validateParameter(valid_589211, JString, required = true,
                                 default = nil)
  if valid_589211 != nil:
    section.add "executionId", valid_589211
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
  var valid_589212 = query.getOrDefault("fields")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "fields", valid_589212
  var valid_589213 = query.getOrDefault("requestId")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "requestId", valid_589213
  var valid_589214 = query.getOrDefault("quotaUser")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "quotaUser", valid_589214
  var valid_589215 = query.getOrDefault("alt")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = newJString("json"))
  if valid_589215 != nil:
    section.add "alt", valid_589215
  var valid_589216 = query.getOrDefault("oauth_token")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "oauth_token", valid_589216
  var valid_589217 = query.getOrDefault("userIp")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "userIp", valid_589217
  var valid_589218 = query.getOrDefault("key")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "key", valid_589218
  var valid_589219 = query.getOrDefault("prettyPrint")
  valid_589219 = validateParameter(valid_589219, JBool, required = false,
                                 default = newJBool(true))
  if valid_589219 != nil:
    section.add "prettyPrint", valid_589219
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

proc call*(call_589221: Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_589205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing Step with the supplied partial entity.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal (e.g try to upload a duplicate xml file), if the updated step is too large (more than 10Mib) - NOT_FOUND - if the containing Execution does not exist
  ## 
  let valid = call_589221.validator(path, query, header, formData, body)
  let scheme = call_589221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589221.url(scheme.get, call_589221.host, call_589221.base,
                         call_589221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589221, url, valid)

proc call*(call_589222: Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_589205;
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
  var path_589223 = newJObject()
  var query_589224 = newJObject()
  var body_589225 = newJObject()
  add(path_589223, "stepId", newJString(stepId))
  add(query_589224, "fields", newJString(fields))
  add(query_589224, "requestId", newJString(requestId))
  add(query_589224, "quotaUser", newJString(quotaUser))
  add(query_589224, "alt", newJString(alt))
  add(query_589224, "oauth_token", newJString(oauthToken))
  add(query_589224, "userIp", newJString(userIp))
  add(query_589224, "key", newJString(key))
  add(path_589223, "projectId", newJString(projectId))
  add(path_589223, "historyId", newJString(historyId))
  if body != nil:
    body_589225 = body
  add(query_589224, "prettyPrint", newJBool(prettyPrint))
  add(path_589223, "executionId", newJString(executionId))
  result = call_589222.call(path_589223, query_589224, nil, nil, body_589225)

var toolresultsProjectsHistoriesExecutionsStepsPatch* = Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_589205(
    name: "toolresultsProjectsHistoriesExecutionsStepsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPatch_589206,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPatch_589207,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_589244 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_589246(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_589245(
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
  var valid_589247 = path.getOrDefault("stepId")
  valid_589247 = validateParameter(valid_589247, JString, required = true,
                                 default = nil)
  if valid_589247 != nil:
    section.add "stepId", valid_589247
  var valid_589248 = path.getOrDefault("projectId")
  valid_589248 = validateParameter(valid_589248, JString, required = true,
                                 default = nil)
  if valid_589248 != nil:
    section.add "projectId", valid_589248
  var valid_589249 = path.getOrDefault("historyId")
  valid_589249 = validateParameter(valid_589249, JString, required = true,
                                 default = nil)
  if valid_589249 != nil:
    section.add "historyId", valid_589249
  var valid_589250 = path.getOrDefault("executionId")
  valid_589250 = validateParameter(valid_589250, JString, required = true,
                                 default = nil)
  if valid_589250 != nil:
    section.add "executionId", valid_589250
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
  var valid_589251 = query.getOrDefault("fields")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "fields", valid_589251
  var valid_589252 = query.getOrDefault("quotaUser")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "quotaUser", valid_589252
  var valid_589253 = query.getOrDefault("alt")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = newJString("json"))
  if valid_589253 != nil:
    section.add "alt", valid_589253
  var valid_589254 = query.getOrDefault("oauth_token")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "oauth_token", valid_589254
  var valid_589255 = query.getOrDefault("userIp")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "userIp", valid_589255
  var valid_589256 = query.getOrDefault("key")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "key", valid_589256
  var valid_589257 = query.getOrDefault("prettyPrint")
  valid_589257 = validateParameter(valid_589257, JBool, required = false,
                                 default = newJBool(true))
  if valid_589257 != nil:
    section.add "prettyPrint", valid_589257
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

proc call*(call_589259: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_589244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a PerfMetricsSummary resource.
  ## 
  ## May return any of the following error code(s): - ALREADY_EXISTS - A PerfMetricSummary already exists for the given Step - NOT_FOUND - The containing Step does not exist
  ## 
  let valid = call_589259.validator(path, query, header, formData, body)
  let scheme = call_589259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589259.url(scheme.get, call_589259.host, call_589259.base,
                         call_589259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589259, url, valid)

proc call*(call_589260: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_589244;
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
  var path_589261 = newJObject()
  var query_589262 = newJObject()
  var body_589263 = newJObject()
  add(path_589261, "stepId", newJString(stepId))
  add(query_589262, "fields", newJString(fields))
  add(query_589262, "quotaUser", newJString(quotaUser))
  add(query_589262, "alt", newJString(alt))
  add(query_589262, "oauth_token", newJString(oauthToken))
  add(query_589262, "userIp", newJString(userIp))
  add(query_589262, "key", newJString(key))
  add(path_589261, "projectId", newJString(projectId))
  add(path_589261, "historyId", newJString(historyId))
  if body != nil:
    body_589263 = body
  add(query_589262, "prettyPrint", newJBool(prettyPrint))
  add(path_589261, "executionId", newJString(executionId))
  result = call_589260.call(path_589261, query_589262, nil, nil, body_589263)

var toolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_589244(name: "toolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfMetricsSummary", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_589245,
    base: "/toolresults/v1beta3firstparty/projects", url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_589246,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_589226 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_589228(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_589227(
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
  var valid_589229 = path.getOrDefault("stepId")
  valid_589229 = validateParameter(valid_589229, JString, required = true,
                                 default = nil)
  if valid_589229 != nil:
    section.add "stepId", valid_589229
  var valid_589230 = path.getOrDefault("projectId")
  valid_589230 = validateParameter(valid_589230, JString, required = true,
                                 default = nil)
  if valid_589230 != nil:
    section.add "projectId", valid_589230
  var valid_589231 = path.getOrDefault("historyId")
  valid_589231 = validateParameter(valid_589231, JString, required = true,
                                 default = nil)
  if valid_589231 != nil:
    section.add "historyId", valid_589231
  var valid_589232 = path.getOrDefault("executionId")
  valid_589232 = validateParameter(valid_589232, JString, required = true,
                                 default = nil)
  if valid_589232 != nil:
    section.add "executionId", valid_589232
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
  var valid_589233 = query.getOrDefault("fields")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "fields", valid_589233
  var valid_589234 = query.getOrDefault("quotaUser")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "quotaUser", valid_589234
  var valid_589235 = query.getOrDefault("alt")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = newJString("json"))
  if valid_589235 != nil:
    section.add "alt", valid_589235
  var valid_589236 = query.getOrDefault("oauth_token")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "oauth_token", valid_589236
  var valid_589237 = query.getOrDefault("userIp")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "userIp", valid_589237
  var valid_589238 = query.getOrDefault("key")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "key", valid_589238
  var valid_589239 = query.getOrDefault("prettyPrint")
  valid_589239 = validateParameter(valid_589239, JBool, required = false,
                                 default = newJBool(true))
  if valid_589239 != nil:
    section.add "prettyPrint", valid_589239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589240: Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_589226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a PerfMetricsSummary.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfMetricsSummary does not exist
  ## 
  let valid = call_589240.validator(path, query, header, formData, body)
  let scheme = call_589240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589240.url(scheme.get, call_589240.host, call_589240.base,
                         call_589240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589240, url, valid)

proc call*(call_589241: Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_589226;
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
  var path_589242 = newJObject()
  var query_589243 = newJObject()
  add(path_589242, "stepId", newJString(stepId))
  add(query_589243, "fields", newJString(fields))
  add(query_589243, "quotaUser", newJString(quotaUser))
  add(query_589243, "alt", newJString(alt))
  add(query_589243, "oauth_token", newJString(oauthToken))
  add(query_589243, "userIp", newJString(userIp))
  add(query_589243, "key", newJString(key))
  add(path_589242, "projectId", newJString(projectId))
  add(path_589242, "historyId", newJString(historyId))
  add(query_589243, "prettyPrint", newJBool(prettyPrint))
  add(path_589242, "executionId", newJString(executionId))
  result = call_589241.call(path_589242, query_589243, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary* = Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_589226(
    name: "toolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfMetricsSummary", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_589227,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_589228,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_589283 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_589285(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_589284(
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
  var valid_589286 = path.getOrDefault("stepId")
  valid_589286 = validateParameter(valid_589286, JString, required = true,
                                 default = nil)
  if valid_589286 != nil:
    section.add "stepId", valid_589286
  var valid_589287 = path.getOrDefault("projectId")
  valid_589287 = validateParameter(valid_589287, JString, required = true,
                                 default = nil)
  if valid_589287 != nil:
    section.add "projectId", valid_589287
  var valid_589288 = path.getOrDefault("historyId")
  valid_589288 = validateParameter(valid_589288, JString, required = true,
                                 default = nil)
  if valid_589288 != nil:
    section.add "historyId", valid_589288
  var valid_589289 = path.getOrDefault("executionId")
  valid_589289 = validateParameter(valid_589289, JString, required = true,
                                 default = nil)
  if valid_589289 != nil:
    section.add "executionId", valid_589289
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
  var valid_589290 = query.getOrDefault("fields")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "fields", valid_589290
  var valid_589291 = query.getOrDefault("quotaUser")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "quotaUser", valid_589291
  var valid_589292 = query.getOrDefault("alt")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = newJString("json"))
  if valid_589292 != nil:
    section.add "alt", valid_589292
  var valid_589293 = query.getOrDefault("oauth_token")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "oauth_token", valid_589293
  var valid_589294 = query.getOrDefault("userIp")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "userIp", valid_589294
  var valid_589295 = query.getOrDefault("key")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "key", valid_589295
  var valid_589296 = query.getOrDefault("prettyPrint")
  valid_589296 = validateParameter(valid_589296, JBool, required = false,
                                 default = newJBool(true))
  if valid_589296 != nil:
    section.add "prettyPrint", valid_589296
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

proc call*(call_589298: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_589283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - ALREADY_EXISTS - PerfMetricSummary already exists for the given Step - NOT_FOUND - The containing Step does not exist
  ## 
  let valid = call_589298.validator(path, query, header, formData, body)
  let scheme = call_589298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589298.url(scheme.get, call_589298.host, call_589298.base,
                         call_589298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589298, url, valid)

proc call*(call_589299: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_589283;
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
  var path_589300 = newJObject()
  var query_589301 = newJObject()
  var body_589302 = newJObject()
  add(path_589300, "stepId", newJString(stepId))
  add(query_589301, "fields", newJString(fields))
  add(query_589301, "quotaUser", newJString(quotaUser))
  add(query_589301, "alt", newJString(alt))
  add(query_589301, "oauth_token", newJString(oauthToken))
  add(query_589301, "userIp", newJString(userIp))
  add(query_589301, "key", newJString(key))
  add(path_589300, "projectId", newJString(projectId))
  add(path_589300, "historyId", newJString(historyId))
  if body != nil:
    body_589302 = body
  add(query_589301, "prettyPrint", newJBool(prettyPrint))
  add(path_589300, "executionId", newJString(executionId))
  result = call_589299.call(path_589300, query_589301, nil, nil, body_589302)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_589283(
    name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_589284,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_589285,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_589264 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_589266(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_589265(
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
  var valid_589267 = path.getOrDefault("stepId")
  valid_589267 = validateParameter(valid_589267, JString, required = true,
                                 default = nil)
  if valid_589267 != nil:
    section.add "stepId", valid_589267
  var valid_589268 = path.getOrDefault("projectId")
  valid_589268 = validateParameter(valid_589268, JString, required = true,
                                 default = nil)
  if valid_589268 != nil:
    section.add "projectId", valid_589268
  var valid_589269 = path.getOrDefault("historyId")
  valid_589269 = validateParameter(valid_589269, JString, required = true,
                                 default = nil)
  if valid_589269 != nil:
    section.add "historyId", valid_589269
  var valid_589270 = path.getOrDefault("executionId")
  valid_589270 = validateParameter(valid_589270, JString, required = true,
                                 default = nil)
  if valid_589270 != nil:
    section.add "executionId", valid_589270
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
  var valid_589271 = query.getOrDefault("fields")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "fields", valid_589271
  var valid_589272 = query.getOrDefault("quotaUser")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "quotaUser", valid_589272
  var valid_589273 = query.getOrDefault("alt")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = newJString("json"))
  if valid_589273 != nil:
    section.add "alt", valid_589273
  var valid_589274 = query.getOrDefault("oauth_token")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "oauth_token", valid_589274
  var valid_589275 = query.getOrDefault("userIp")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "userIp", valid_589275
  var valid_589276 = query.getOrDefault("key")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "key", valid_589276
  var valid_589277 = query.getOrDefault("prettyPrint")
  valid_589277 = validateParameter(valid_589277, JBool, required = false,
                                 default = newJBool(true))
  if valid_589277 != nil:
    section.add "prettyPrint", valid_589277
  var valid_589278 = query.getOrDefault("filter")
  valid_589278 = validateParameter(valid_589278, JArray, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "filter", valid_589278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589279: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_589264;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists PerfSampleSeries for a given Step.
  ## 
  ## The request provides an optional filter which specifies one or more PerfMetricsType to include in the result; if none returns all. The resulting PerfSampleSeries are sorted by ids.
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing Step does not exist
  ## 
  let valid = call_589279.validator(path, query, header, formData, body)
  let scheme = call_589279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589279.url(scheme.get, call_589279.host, call_589279.base,
                         call_589279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589279, url, valid)

proc call*(call_589280: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_589264;
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
  var path_589281 = newJObject()
  var query_589282 = newJObject()
  add(path_589281, "stepId", newJString(stepId))
  add(query_589282, "fields", newJString(fields))
  add(query_589282, "quotaUser", newJString(quotaUser))
  add(query_589282, "alt", newJString(alt))
  add(query_589282, "oauth_token", newJString(oauthToken))
  add(query_589282, "userIp", newJString(userIp))
  add(query_589282, "key", newJString(key))
  add(path_589281, "projectId", newJString(projectId))
  add(path_589281, "historyId", newJString(historyId))
  add(query_589282, "prettyPrint", newJBool(prettyPrint))
  add(path_589281, "executionId", newJString(executionId))
  if filter != nil:
    query_589282.add "filter", filter
  result = call_589280.call(path_589281, query_589282, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_589264(
    name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_589265,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_589266,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_589303 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_589305(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_589304(
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
  var valid_589306 = path.getOrDefault("stepId")
  valid_589306 = validateParameter(valid_589306, JString, required = true,
                                 default = nil)
  if valid_589306 != nil:
    section.add "stepId", valid_589306
  var valid_589307 = path.getOrDefault("projectId")
  valid_589307 = validateParameter(valid_589307, JString, required = true,
                                 default = nil)
  if valid_589307 != nil:
    section.add "projectId", valid_589307
  var valid_589308 = path.getOrDefault("sampleSeriesId")
  valid_589308 = validateParameter(valid_589308, JString, required = true,
                                 default = nil)
  if valid_589308 != nil:
    section.add "sampleSeriesId", valid_589308
  var valid_589309 = path.getOrDefault("historyId")
  valid_589309 = validateParameter(valid_589309, JString, required = true,
                                 default = nil)
  if valid_589309 != nil:
    section.add "historyId", valid_589309
  var valid_589310 = path.getOrDefault("executionId")
  valid_589310 = validateParameter(valid_589310, JString, required = true,
                                 default = nil)
  if valid_589310 != nil:
    section.add "executionId", valid_589310
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
  var valid_589311 = query.getOrDefault("fields")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "fields", valid_589311
  var valid_589312 = query.getOrDefault("quotaUser")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "quotaUser", valid_589312
  var valid_589313 = query.getOrDefault("alt")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = newJString("json"))
  if valid_589313 != nil:
    section.add "alt", valid_589313
  var valid_589314 = query.getOrDefault("oauth_token")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "oauth_token", valid_589314
  var valid_589315 = query.getOrDefault("userIp")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "userIp", valid_589315
  var valid_589316 = query.getOrDefault("key")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "key", valid_589316
  var valid_589317 = query.getOrDefault("prettyPrint")
  valid_589317 = validateParameter(valid_589317, JBool, required = false,
                                 default = newJBool(true))
  if valid_589317 != nil:
    section.add "prettyPrint", valid_589317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589318: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_589303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfSampleSeries does not exist
  ## 
  let valid = call_589318.validator(path, query, header, formData, body)
  let scheme = call_589318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589318.url(scheme.get, call_589318.host, call_589318.base,
                         call_589318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589318, url, valid)

proc call*(call_589319: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_589303;
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
  var path_589320 = newJObject()
  var query_589321 = newJObject()
  add(path_589320, "stepId", newJString(stepId))
  add(query_589321, "fields", newJString(fields))
  add(query_589321, "quotaUser", newJString(quotaUser))
  add(query_589321, "alt", newJString(alt))
  add(query_589321, "oauth_token", newJString(oauthToken))
  add(query_589321, "userIp", newJString(userIp))
  add(query_589321, "key", newJString(key))
  add(path_589320, "projectId", newJString(projectId))
  add(path_589320, "sampleSeriesId", newJString(sampleSeriesId))
  add(path_589320, "historyId", newJString(historyId))
  add(query_589321, "prettyPrint", newJBool(prettyPrint))
  add(path_589320, "executionId", newJString(executionId))
  result = call_589319.call(path_589320, query_589321, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_589303(
    name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries/{sampleSeriesId}", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_589304,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_589305,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_589322 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_589324(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_589323(
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
  var valid_589325 = path.getOrDefault("stepId")
  valid_589325 = validateParameter(valid_589325, JString, required = true,
                                 default = nil)
  if valid_589325 != nil:
    section.add "stepId", valid_589325
  var valid_589326 = path.getOrDefault("projectId")
  valid_589326 = validateParameter(valid_589326, JString, required = true,
                                 default = nil)
  if valid_589326 != nil:
    section.add "projectId", valid_589326
  var valid_589327 = path.getOrDefault("sampleSeriesId")
  valid_589327 = validateParameter(valid_589327, JString, required = true,
                                 default = nil)
  if valid_589327 != nil:
    section.add "sampleSeriesId", valid_589327
  var valid_589328 = path.getOrDefault("historyId")
  valid_589328 = validateParameter(valid_589328, JString, required = true,
                                 default = nil)
  if valid_589328 != nil:
    section.add "historyId", valid_589328
  var valid_589329 = path.getOrDefault("executionId")
  valid_589329 = validateParameter(valid_589329, JString, required = true,
                                 default = nil)
  if valid_589329 != nil:
    section.add "executionId", valid_589329
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
  var valid_589330 = query.getOrDefault("fields")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "fields", valid_589330
  var valid_589331 = query.getOrDefault("pageToken")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "pageToken", valid_589331
  var valid_589332 = query.getOrDefault("quotaUser")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "quotaUser", valid_589332
  var valid_589333 = query.getOrDefault("alt")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = newJString("json"))
  if valid_589333 != nil:
    section.add "alt", valid_589333
  var valid_589334 = query.getOrDefault("oauth_token")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "oauth_token", valid_589334
  var valid_589335 = query.getOrDefault("userIp")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "userIp", valid_589335
  var valid_589336 = query.getOrDefault("key")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "key", valid_589336
  var valid_589337 = query.getOrDefault("pageSize")
  valid_589337 = validateParameter(valid_589337, JInt, required = false, default = nil)
  if valid_589337 != nil:
    section.add "pageSize", valid_589337
  var valid_589338 = query.getOrDefault("prettyPrint")
  valid_589338 = validateParameter(valid_589338, JBool, required = false,
                                 default = newJBool(true))
  if valid_589338 != nil:
    section.add "prettyPrint", valid_589338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589339: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_589322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Performance Samples of a given Sample Series - The list results are sorted by timestamps ascending - The default page size is 500 samples; and maximum size allowed 5000 - The response token indicates the last returned PerfSample timestamp - When the results size exceeds the page size, submit a subsequent request including the page token to return the rest of the samples up to the page limit
  ## 
  ## May return any of the following canonical error codes: - OUT_OF_RANGE - The specified request page_token is out of valid range - NOT_FOUND - The containing PerfSampleSeries does not exist
  ## 
  let valid = call_589339.validator(path, query, header, formData, body)
  let scheme = call_589339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589339.url(scheme.get, call_589339.host, call_589339.base,
                         call_589339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589339, url, valid)

proc call*(call_589340: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_589322;
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
  var path_589341 = newJObject()
  var query_589342 = newJObject()
  add(path_589341, "stepId", newJString(stepId))
  add(query_589342, "fields", newJString(fields))
  add(query_589342, "pageToken", newJString(pageToken))
  add(query_589342, "quotaUser", newJString(quotaUser))
  add(query_589342, "alt", newJString(alt))
  add(query_589342, "oauth_token", newJString(oauthToken))
  add(query_589342, "userIp", newJString(userIp))
  add(query_589342, "key", newJString(key))
  add(path_589341, "projectId", newJString(projectId))
  add(path_589341, "sampleSeriesId", newJString(sampleSeriesId))
  add(query_589342, "pageSize", newJInt(pageSize))
  add(path_589341, "historyId", newJString(historyId))
  add(query_589342, "prettyPrint", newJBool(prettyPrint))
  add(path_589341, "executionId", newJString(executionId))
  result = call_589340.call(path_589341, query_589342, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_589322(name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries/{sampleSeriesId}/samples", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_589323,
    base: "/toolresults/v1beta3firstparty/projects", url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_589324,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_589343 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_589345(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_589344(
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
  var valid_589346 = path.getOrDefault("stepId")
  valid_589346 = validateParameter(valid_589346, JString, required = true,
                                 default = nil)
  if valid_589346 != nil:
    section.add "stepId", valid_589346
  var valid_589347 = path.getOrDefault("projectId")
  valid_589347 = validateParameter(valid_589347, JString, required = true,
                                 default = nil)
  if valid_589347 != nil:
    section.add "projectId", valid_589347
  var valid_589348 = path.getOrDefault("sampleSeriesId")
  valid_589348 = validateParameter(valid_589348, JString, required = true,
                                 default = nil)
  if valid_589348 != nil:
    section.add "sampleSeriesId", valid_589348
  var valid_589349 = path.getOrDefault("historyId")
  valid_589349 = validateParameter(valid_589349, JString, required = true,
                                 default = nil)
  if valid_589349 != nil:
    section.add "historyId", valid_589349
  var valid_589350 = path.getOrDefault("executionId")
  valid_589350 = validateParameter(valid_589350, JString, required = true,
                                 default = nil)
  if valid_589350 != nil:
    section.add "executionId", valid_589350
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
  var valid_589351 = query.getOrDefault("fields")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "fields", valid_589351
  var valid_589352 = query.getOrDefault("quotaUser")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "quotaUser", valid_589352
  var valid_589353 = query.getOrDefault("alt")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = newJString("json"))
  if valid_589353 != nil:
    section.add "alt", valid_589353
  var valid_589354 = query.getOrDefault("oauth_token")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "oauth_token", valid_589354
  var valid_589355 = query.getOrDefault("userIp")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "userIp", valid_589355
  var valid_589356 = query.getOrDefault("key")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "key", valid_589356
  var valid_589357 = query.getOrDefault("prettyPrint")
  valid_589357 = validateParameter(valid_589357, JBool, required = false,
                                 default = newJBool(true))
  if valid_589357 != nil:
    section.add "prettyPrint", valid_589357
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

proc call*(call_589359: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_589343;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a batch of PerfSamples - a client can submit multiple batches of Perf Samples through repeated calls to this method in order to split up a large request payload - duplicates and existing timestamp entries will be ignored. - the batch operation may partially succeed - the set of elements successfully inserted is returned in the response (omits items which already existed in the database).
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing PerfSampleSeries does not exist
  ## 
  let valid = call_589359.validator(path, query, header, formData, body)
  let scheme = call_589359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589359.url(scheme.get, call_589359.host, call_589359.base,
                         call_589359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589359, url, valid)

proc call*(call_589360: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_589343;
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
  var path_589361 = newJObject()
  var query_589362 = newJObject()
  var body_589363 = newJObject()
  add(path_589361, "stepId", newJString(stepId))
  add(query_589362, "fields", newJString(fields))
  add(query_589362, "quotaUser", newJString(quotaUser))
  add(query_589362, "alt", newJString(alt))
  add(query_589362, "oauth_token", newJString(oauthToken))
  add(query_589362, "userIp", newJString(userIp))
  add(query_589362, "key", newJString(key))
  add(path_589361, "projectId", newJString(projectId))
  add(path_589361, "sampleSeriesId", newJString(sampleSeriesId))
  add(path_589361, "historyId", newJString(historyId))
  if body != nil:
    body_589363 = body
  add(query_589362, "prettyPrint", newJBool(prettyPrint))
  add(path_589361, "executionId", newJString(executionId))
  result = call_589360.call(path_589361, query_589362, nil, nil, body_589363)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_589343(name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries/{sampleSeriesId}/samples:batchCreate", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_589344,
    base: "/toolresults/v1beta3firstparty/projects", url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_589345,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_589364 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_589366(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_589365(
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
  var valid_589367 = path.getOrDefault("stepId")
  valid_589367 = validateParameter(valid_589367, JString, required = true,
                                 default = nil)
  if valid_589367 != nil:
    section.add "stepId", valid_589367
  var valid_589368 = path.getOrDefault("projectId")
  valid_589368 = validateParameter(valid_589368, JString, required = true,
                                 default = nil)
  if valid_589368 != nil:
    section.add "projectId", valid_589368
  var valid_589369 = path.getOrDefault("historyId")
  valid_589369 = validateParameter(valid_589369, JString, required = true,
                                 default = nil)
  if valid_589369 != nil:
    section.add "historyId", valid_589369
  var valid_589370 = path.getOrDefault("executionId")
  valid_589370 = validateParameter(valid_589370, JString, required = true,
                                 default = nil)
  if valid_589370 != nil:
    section.add "executionId", valid_589370
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
  var valid_589371 = query.getOrDefault("fields")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "fields", valid_589371
  var valid_589372 = query.getOrDefault("pageToken")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "pageToken", valid_589372
  var valid_589373 = query.getOrDefault("quotaUser")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "quotaUser", valid_589373
  var valid_589374 = query.getOrDefault("alt")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = newJString("json"))
  if valid_589374 != nil:
    section.add "alt", valid_589374
  var valid_589375 = query.getOrDefault("oauth_token")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "oauth_token", valid_589375
  var valid_589376 = query.getOrDefault("userIp")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "userIp", valid_589376
  var valid_589377 = query.getOrDefault("key")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "key", valid_589377
  var valid_589378 = query.getOrDefault("pageSize")
  valid_589378 = validateParameter(valid_589378, JInt, required = false, default = nil)
  if valid_589378 != nil:
    section.add "pageSize", valid_589378
  var valid_589379 = query.getOrDefault("prettyPrint")
  valid_589379 = validateParameter(valid_589379, JBool, required = false,
                                 default = newJBool(true))
  if valid_589379 != nil:
    section.add "prettyPrint", valid_589379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589380: Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_589364;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists thumbnails of images attached to a step.
  ## 
  ## May return any of the following canonical error codes: - PERMISSION_DENIED - if the user is not authorized to read from the project, or from any of the images - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the step does not exist, or if any of the images do not exist
  ## 
  let valid = call_589380.validator(path, query, header, formData, body)
  let scheme = call_589380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589380.url(scheme.get, call_589380.host, call_589380.base,
                         call_589380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589380, url, valid)

proc call*(call_589381: Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_589364;
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
  var path_589382 = newJObject()
  var query_589383 = newJObject()
  add(path_589382, "stepId", newJString(stepId))
  add(query_589383, "fields", newJString(fields))
  add(query_589383, "pageToken", newJString(pageToken))
  add(query_589383, "quotaUser", newJString(quotaUser))
  add(query_589383, "alt", newJString(alt))
  add(query_589383, "oauth_token", newJString(oauthToken))
  add(query_589383, "userIp", newJString(userIp))
  add(query_589383, "key", newJString(key))
  add(path_589382, "projectId", newJString(projectId))
  add(query_589383, "pageSize", newJInt(pageSize))
  add(path_589382, "historyId", newJString(historyId))
  add(query_589383, "prettyPrint", newJBool(prettyPrint))
  add(path_589382, "executionId", newJString(executionId))
  result = call_589381.call(path_589382, query_589383, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsThumbnailsList* = Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_589364(
    name: "toolresultsProjectsHistoriesExecutionsStepsThumbnailsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/thumbnails", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_589365,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_589366,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_589384 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_589386(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_589385(
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
  var valid_589387 = path.getOrDefault("stepId")
  valid_589387 = validateParameter(valid_589387, JString, required = true,
                                 default = nil)
  if valid_589387 != nil:
    section.add "stepId", valid_589387
  var valid_589388 = path.getOrDefault("projectId")
  valid_589388 = validateParameter(valid_589388, JString, required = true,
                                 default = nil)
  if valid_589388 != nil:
    section.add "projectId", valid_589388
  var valid_589389 = path.getOrDefault("historyId")
  valid_589389 = validateParameter(valid_589389, JString, required = true,
                                 default = nil)
  if valid_589389 != nil:
    section.add "historyId", valid_589389
  var valid_589390 = path.getOrDefault("executionId")
  valid_589390 = validateParameter(valid_589390, JString, required = true,
                                 default = nil)
  if valid_589390 != nil:
    section.add "executionId", valid_589390
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
  var valid_589391 = query.getOrDefault("fields")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "fields", valid_589391
  var valid_589392 = query.getOrDefault("quotaUser")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "quotaUser", valid_589392
  var valid_589393 = query.getOrDefault("alt")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = newJString("json"))
  if valid_589393 != nil:
    section.add "alt", valid_589393
  var valid_589394 = query.getOrDefault("oauth_token")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "oauth_token", valid_589394
  var valid_589395 = query.getOrDefault("userIp")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "userIp", valid_589395
  var valid_589396 = query.getOrDefault("key")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "key", valid_589396
  var valid_589397 = query.getOrDefault("prettyPrint")
  valid_589397 = validateParameter(valid_589397, JBool, required = false,
                                 default = newJBool(true))
  if valid_589397 != nil:
    section.add "prettyPrint", valid_589397
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

proc call*(call_589399: Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_589384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Publish xml files to an existing Step.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal, e.g try to upload a duplicate xml file or a file too large. - NOT_FOUND - if the containing Execution does not exist
  ## 
  let valid = call_589399.validator(path, query, header, formData, body)
  let scheme = call_589399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589399.url(scheme.get, call_589399.host, call_589399.base,
                         call_589399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589399, url, valid)

proc call*(call_589400: Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_589384;
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
  var path_589401 = newJObject()
  var query_589402 = newJObject()
  var body_589403 = newJObject()
  add(path_589401, "stepId", newJString(stepId))
  add(query_589402, "fields", newJString(fields))
  add(query_589402, "quotaUser", newJString(quotaUser))
  add(query_589402, "alt", newJString(alt))
  add(query_589402, "oauth_token", newJString(oauthToken))
  add(query_589402, "userIp", newJString(userIp))
  add(query_589402, "key", newJString(key))
  add(path_589401, "projectId", newJString(projectId))
  add(path_589401, "historyId", newJString(historyId))
  if body != nil:
    body_589403 = body
  add(query_589402, "prettyPrint", newJBool(prettyPrint))
  add(path_589401, "executionId", newJString(executionId))
  result = call_589400.call(path_589401, query_589402, nil, nil, body_589403)

var toolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles* = Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_589384(
    name: "toolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}:publishXunitXmlFiles", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_589385,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_589386,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsGetSettings_589404 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsGetSettings_589406(protocol: Scheme; host: string;
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

proc validate_ToolresultsProjectsGetSettings_589405(path: JsonNode;
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
  var valid_589407 = path.getOrDefault("projectId")
  valid_589407 = validateParameter(valid_589407, JString, required = true,
                                 default = nil)
  if valid_589407 != nil:
    section.add "projectId", valid_589407
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
  var valid_589408 = query.getOrDefault("fields")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "fields", valid_589408
  var valid_589409 = query.getOrDefault("quotaUser")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "quotaUser", valid_589409
  var valid_589410 = query.getOrDefault("alt")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = newJString("json"))
  if valid_589410 != nil:
    section.add "alt", valid_589410
  var valid_589411 = query.getOrDefault("oauth_token")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "oauth_token", valid_589411
  var valid_589412 = query.getOrDefault("userIp")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "userIp", valid_589412
  var valid_589413 = query.getOrDefault("key")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "key", valid_589413
  var valid_589414 = query.getOrDefault("prettyPrint")
  valid_589414 = validateParameter(valid_589414, JBool, required = false,
                                 default = newJBool(true))
  if valid_589414 != nil:
    section.add "prettyPrint", valid_589414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589415: Call_ToolresultsProjectsGetSettings_589404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Tool Results settings for a project.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read from project
  ## 
  let valid = call_589415.validator(path, query, header, formData, body)
  let scheme = call_589415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589415.url(scheme.get, call_589415.host, call_589415.base,
                         call_589415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589415, url, valid)

proc call*(call_589416: Call_ToolresultsProjectsGetSettings_589404;
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
  var path_589417 = newJObject()
  var query_589418 = newJObject()
  add(query_589418, "fields", newJString(fields))
  add(query_589418, "quotaUser", newJString(quotaUser))
  add(query_589418, "alt", newJString(alt))
  add(query_589418, "oauth_token", newJString(oauthToken))
  add(query_589418, "userIp", newJString(userIp))
  add(query_589418, "key", newJString(key))
  add(path_589417, "projectId", newJString(projectId))
  add(query_589418, "prettyPrint", newJBool(prettyPrint))
  result = call_589416.call(path_589417, query_589418, nil, nil, nil)

var toolresultsProjectsGetSettings* = Call_ToolresultsProjectsGetSettings_589404(
    name: "toolresultsProjectsGetSettings", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectId}/settings",
    validator: validate_ToolresultsProjectsGetSettings_589405,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsGetSettings_589406, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsInitializeSettings_589419 = ref object of OpenApiRestCall_588450
proc url_ToolresultsProjectsInitializeSettings_589421(protocol: Scheme;
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

proc validate_ToolresultsProjectsInitializeSettings_589420(path: JsonNode;
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
  var valid_589422 = path.getOrDefault("projectId")
  valid_589422 = validateParameter(valid_589422, JString, required = true,
                                 default = nil)
  if valid_589422 != nil:
    section.add "projectId", valid_589422
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
  var valid_589423 = query.getOrDefault("fields")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "fields", valid_589423
  var valid_589424 = query.getOrDefault("quotaUser")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "quotaUser", valid_589424
  var valid_589425 = query.getOrDefault("alt")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = newJString("json"))
  if valid_589425 != nil:
    section.add "alt", valid_589425
  var valid_589426 = query.getOrDefault("oauth_token")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "oauth_token", valid_589426
  var valid_589427 = query.getOrDefault("userIp")
  valid_589427 = validateParameter(valid_589427, JString, required = false,
                                 default = nil)
  if valid_589427 != nil:
    section.add "userIp", valid_589427
  var valid_589428 = query.getOrDefault("key")
  valid_589428 = validateParameter(valid_589428, JString, required = false,
                                 default = nil)
  if valid_589428 != nil:
    section.add "key", valid_589428
  var valid_589429 = query.getOrDefault("prettyPrint")
  valid_589429 = validateParameter(valid_589429, JBool, required = false,
                                 default = newJBool(true))
  if valid_589429 != nil:
    section.add "prettyPrint", valid_589429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589430: Call_ToolresultsProjectsInitializeSettings_589419;
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
  let valid = call_589430.validator(path, query, header, formData, body)
  let scheme = call_589430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589430.url(scheme.get, call_589430.host, call_589430.base,
                         call_589430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589430, url, valid)

proc call*(call_589431: Call_ToolresultsProjectsInitializeSettings_589419;
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
  var path_589432 = newJObject()
  var query_589433 = newJObject()
  add(query_589433, "fields", newJString(fields))
  add(query_589433, "quotaUser", newJString(quotaUser))
  add(query_589433, "alt", newJString(alt))
  add(query_589433, "oauth_token", newJString(oauthToken))
  add(query_589433, "userIp", newJString(userIp))
  add(query_589433, "key", newJString(key))
  add(path_589432, "projectId", newJString(projectId))
  add(query_589433, "prettyPrint", newJBool(prettyPrint))
  result = call_589431.call(path_589432, query_589433, nil, nil, nil)

var toolresultsProjectsInitializeSettings* = Call_ToolresultsProjectsInitializeSettings_589419(
    name: "toolresultsProjectsInitializeSettings", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectId}:initializeSettings",
    validator: validate_ToolresultsProjectsInitializeSettings_589420,
    base: "/toolresults/v1beta3firstparty/projects",
    url: url_ToolresultsProjectsInitializeSettings_589421, schemes: {Scheme.Https})
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
