
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Tool Results
## version: v1beta3
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
  gcpServiceName = "toolresults"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ToolresultsProjectsHistoriesCreate_578905 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesCreate_578907(protocol: Scheme; host: string;
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

proc validate_ToolresultsProjectsHistoriesCreate_578906(path: JsonNode;
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
  var valid_578908 = path.getOrDefault("projectId")
  valid_578908 = validateParameter(valid_578908, JString, required = true,
                                 default = nil)
  if valid_578908 != nil:
    section.add "projectId", valid_578908
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   requestId: JString
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578909 = query.getOrDefault("key")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "key", valid_578909
  var valid_578910 = query.getOrDefault("prettyPrint")
  valid_578910 = validateParameter(valid_578910, JBool, required = false,
                                 default = newJBool(true))
  if valid_578910 != nil:
    section.add "prettyPrint", valid_578910
  var valid_578911 = query.getOrDefault("oauth_token")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "oauth_token", valid_578911
  var valid_578912 = query.getOrDefault("alt")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = newJString("json"))
  if valid_578912 != nil:
    section.add "alt", valid_578912
  var valid_578913 = query.getOrDefault("userIp")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "userIp", valid_578913
  var valid_578914 = query.getOrDefault("quotaUser")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "quotaUser", valid_578914
  var valid_578915 = query.getOrDefault("requestId")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "requestId", valid_578915
  var valid_578916 = query.getOrDefault("fields")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "fields", valid_578916
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

proc call*(call_578918: Call_ToolresultsProjectsHistoriesCreate_578905;
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
  let valid = call_578918.validator(path, query, header, formData, body)
  let scheme = call_578918.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578918.url(scheme.get, call_578918.host, call_578918.base,
                         call_578918.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578918, url, valid)

proc call*(call_578919: Call_ToolresultsProjectsHistoriesCreate_578905;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; requestId: string = "";
          fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesCreate
  ## Creates a History.
  ## 
  ## The returned History will have the id set.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing project does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   requestId: string
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578920 = newJObject()
  var query_578921 = newJObject()
  var body_578922 = newJObject()
  add(query_578921, "key", newJString(key))
  add(query_578921, "prettyPrint", newJBool(prettyPrint))
  add(query_578921, "oauth_token", newJString(oauthToken))
  add(path_578920, "projectId", newJString(projectId))
  add(query_578921, "alt", newJString(alt))
  add(query_578921, "userIp", newJString(userIp))
  add(query_578921, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578922 = body
  add(query_578921, "requestId", newJString(requestId))
  add(query_578921, "fields", newJString(fields))
  result = call_578919.call(path_578920, query_578921, nil, nil, body_578922)

var toolresultsProjectsHistoriesCreate* = Call_ToolresultsProjectsHistoriesCreate_578905(
    name: "toolresultsProjectsHistoriesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectId}/histories",
    validator: validate_ToolresultsProjectsHistoriesCreate_578906,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesCreate_578907, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesList_578618 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesList_578620(protocol: Scheme; host: string;
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

proc validate_ToolresultsProjectsHistoriesList_578619(path: JsonNode;
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
  var valid_578746 = path.getOrDefault("projectId")
  valid_578746 = validateParameter(valid_578746, JString, required = true,
                                 default = nil)
  if valid_578746 != nil:
    section.add "projectId", valid_578746
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   pageSize: JInt
  ##           : The maximum number of Histories to fetch.
  ## 
  ## Default value: 20. The server will use this default if the field is not set or has a value of 0. Any value greater than 100 will be treated as 100.
  ## 
  ## Optional.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   filterByName: JString
  ##               : If set, only return histories with the given name.
  ## 
  ## Optional.
  ##   pageToken: JString
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578747 = query.getOrDefault("key")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "key", valid_578747
  var valid_578761 = query.getOrDefault("prettyPrint")
  valid_578761 = validateParameter(valid_578761, JBool, required = false,
                                 default = newJBool(true))
  if valid_578761 != nil:
    section.add "prettyPrint", valid_578761
  var valid_578762 = query.getOrDefault("oauth_token")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "oauth_token", valid_578762
  var valid_578763 = query.getOrDefault("pageSize")
  valid_578763 = validateParameter(valid_578763, JInt, required = false, default = nil)
  if valid_578763 != nil:
    section.add "pageSize", valid_578763
  var valid_578764 = query.getOrDefault("alt")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = newJString("json"))
  if valid_578764 != nil:
    section.add "alt", valid_578764
  var valid_578765 = query.getOrDefault("userIp")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "userIp", valid_578765
  var valid_578766 = query.getOrDefault("quotaUser")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "quotaUser", valid_578766
  var valid_578767 = query.getOrDefault("filterByName")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "filterByName", valid_578767
  var valid_578768 = query.getOrDefault("pageToken")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "pageToken", valid_578768
  var valid_578769 = query.getOrDefault("fields")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "fields", valid_578769
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578792: Call_ToolresultsProjectsHistoriesList_578618;
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
  let valid = call_578792.validator(path, query, header, formData, body)
  let scheme = call_578792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578792.url(scheme.get, call_578792.host, call_578792.base,
                         call_578792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578792, url, valid)

proc call*(call_578863: Call_ToolresultsProjectsHistoriesList_578618;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; pageSize: int = 0; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; filterByName: string = "";
          pageToken: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesList
  ## Lists Histories for a given Project.
  ## 
  ## The histories are sorted by modification time in descending order. The history_id key will be used to order the history with the same modification time.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the History does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
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
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   filterByName: string
  ##               : If set, only return histories with the given name.
  ## 
  ## Optional.
  ##   pageToken: string
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578864 = newJObject()
  var query_578866 = newJObject()
  add(query_578866, "key", newJString(key))
  add(query_578866, "prettyPrint", newJBool(prettyPrint))
  add(query_578866, "oauth_token", newJString(oauthToken))
  add(path_578864, "projectId", newJString(projectId))
  add(query_578866, "pageSize", newJInt(pageSize))
  add(query_578866, "alt", newJString(alt))
  add(query_578866, "userIp", newJString(userIp))
  add(query_578866, "quotaUser", newJString(quotaUser))
  add(query_578866, "filterByName", newJString(filterByName))
  add(query_578866, "pageToken", newJString(pageToken))
  add(query_578866, "fields", newJString(fields))
  result = call_578863.call(path_578864, query_578866, nil, nil, nil)

var toolresultsProjectsHistoriesList* = Call_ToolresultsProjectsHistoriesList_578618(
    name: "toolresultsProjectsHistoriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectId}/histories",
    validator: validate_ToolresultsProjectsHistoriesList_578619,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesList_578620, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesGet_578923 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesGet_578925(protocol: Scheme; host: string;
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

proc validate_ToolresultsProjectsHistoriesGet_578924(path: JsonNode;
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
  var valid_578926 = path.getOrDefault("projectId")
  valid_578926 = validateParameter(valid_578926, JString, required = true,
                                 default = nil)
  if valid_578926 != nil:
    section.add "projectId", valid_578926
  var valid_578927 = path.getOrDefault("historyId")
  valid_578927 = validateParameter(valid_578927, JString, required = true,
                                 default = nil)
  if valid_578927 != nil:
    section.add "historyId", valid_578927
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578928 = query.getOrDefault("key")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "key", valid_578928
  var valid_578929 = query.getOrDefault("prettyPrint")
  valid_578929 = validateParameter(valid_578929, JBool, required = false,
                                 default = newJBool(true))
  if valid_578929 != nil:
    section.add "prettyPrint", valid_578929
  var valid_578930 = query.getOrDefault("oauth_token")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "oauth_token", valid_578930
  var valid_578931 = query.getOrDefault("alt")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = newJString("json"))
  if valid_578931 != nil:
    section.add "alt", valid_578931
  var valid_578932 = query.getOrDefault("userIp")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "userIp", valid_578932
  var valid_578933 = query.getOrDefault("quotaUser")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "quotaUser", valid_578933
  var valid_578934 = query.getOrDefault("fields")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "fields", valid_578934
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578935: Call_ToolresultsProjectsHistoriesGet_578923;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a History.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the History does not exist
  ## 
  let valid = call_578935.validator(path, query, header, formData, body)
  let scheme = call_578935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578935.url(scheme.get, call_578935.host, call_578935.base,
                         call_578935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578935, url, valid)

proc call*(call_578936: Call_ToolresultsProjectsHistoriesGet_578923;
          projectId: string; historyId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesGet
  ## Gets a History.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the History does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578937 = newJObject()
  var query_578938 = newJObject()
  add(query_578938, "key", newJString(key))
  add(query_578938, "prettyPrint", newJBool(prettyPrint))
  add(query_578938, "oauth_token", newJString(oauthToken))
  add(path_578937, "projectId", newJString(projectId))
  add(path_578937, "historyId", newJString(historyId))
  add(query_578938, "alt", newJString(alt))
  add(query_578938, "userIp", newJString(userIp))
  add(query_578938, "quotaUser", newJString(quotaUser))
  add(query_578938, "fields", newJString(fields))
  result = call_578936.call(path_578937, query_578938, nil, nil, nil)

var toolresultsProjectsHistoriesGet* = Call_ToolresultsProjectsHistoriesGet_578923(
    name: "toolresultsProjectsHistoriesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}",
    validator: validate_ToolresultsProjectsHistoriesGet_578924,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesGet_578925, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsCreate_578957 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsCreate_578959(protocol: Scheme;
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

proc validate_ToolresultsProjectsHistoriesExecutionsCreate_578958(path: JsonNode;
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
  var valid_578960 = path.getOrDefault("projectId")
  valid_578960 = validateParameter(valid_578960, JString, required = true,
                                 default = nil)
  if valid_578960 != nil:
    section.add "projectId", valid_578960
  var valid_578961 = path.getOrDefault("historyId")
  valid_578961 = validateParameter(valid_578961, JString, required = true,
                                 default = nil)
  if valid_578961 != nil:
    section.add "historyId", valid_578961
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   requestId: JString
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578962 = query.getOrDefault("key")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "key", valid_578962
  var valid_578963 = query.getOrDefault("prettyPrint")
  valid_578963 = validateParameter(valid_578963, JBool, required = false,
                                 default = newJBool(true))
  if valid_578963 != nil:
    section.add "prettyPrint", valid_578963
  var valid_578964 = query.getOrDefault("oauth_token")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "oauth_token", valid_578964
  var valid_578965 = query.getOrDefault("alt")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("json"))
  if valid_578965 != nil:
    section.add "alt", valid_578965
  var valid_578966 = query.getOrDefault("userIp")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "userIp", valid_578966
  var valid_578967 = query.getOrDefault("quotaUser")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "quotaUser", valid_578967
  var valid_578968 = query.getOrDefault("requestId")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "requestId", valid_578968
  var valid_578969 = query.getOrDefault("fields")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "fields", valid_578969
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

proc call*(call_578971: Call_ToolresultsProjectsHistoriesExecutionsCreate_578957;
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
  let valid = call_578971.validator(path, query, header, formData, body)
  let scheme = call_578971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578971.url(scheme.get, call_578971.host, call_578971.base,
                         call_578971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578971, url, valid)

proc call*(call_578972: Call_ToolresultsProjectsHistoriesExecutionsCreate_578957;
          projectId: string; historyId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          requestId: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsCreate
  ## Creates an Execution.
  ## 
  ## The returned Execution will have the id set.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing History does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   requestId: string
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578973 = newJObject()
  var query_578974 = newJObject()
  var body_578975 = newJObject()
  add(query_578974, "key", newJString(key))
  add(query_578974, "prettyPrint", newJBool(prettyPrint))
  add(query_578974, "oauth_token", newJString(oauthToken))
  add(path_578973, "projectId", newJString(projectId))
  add(path_578973, "historyId", newJString(historyId))
  add(query_578974, "alt", newJString(alt))
  add(query_578974, "userIp", newJString(userIp))
  add(query_578974, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578975 = body
  add(query_578974, "requestId", newJString(requestId))
  add(query_578974, "fields", newJString(fields))
  result = call_578972.call(path_578973, query_578974, nil, nil, body_578975)

var toolresultsProjectsHistoriesExecutionsCreate* = Call_ToolresultsProjectsHistoriesExecutionsCreate_578957(
    name: "toolresultsProjectsHistoriesExecutionsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions",
    validator: validate_ToolresultsProjectsHistoriesExecutionsCreate_578958,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsCreate_578959,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsList_578939 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsList_578941(protocol: Scheme;
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

proc validate_ToolresultsProjectsHistoriesExecutionsList_578940(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Executions for a given History.
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
  var valid_578942 = path.getOrDefault("projectId")
  valid_578942 = validateParameter(valid_578942, JString, required = true,
                                 default = nil)
  if valid_578942 != nil:
    section.add "projectId", valid_578942
  var valid_578943 = path.getOrDefault("historyId")
  valid_578943 = validateParameter(valid_578943, JString, required = true,
                                 default = nil)
  if valid_578943 != nil:
    section.add "historyId", valid_578943
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   pageSize: JInt
  ##           : The maximum number of Executions to fetch.
  ## 
  ## Default value: 25. The server will use this default if the field is not set or has a value of 0.
  ## 
  ## Optional.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578944 = query.getOrDefault("key")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "key", valid_578944
  var valid_578945 = query.getOrDefault("prettyPrint")
  valid_578945 = validateParameter(valid_578945, JBool, required = false,
                                 default = newJBool(true))
  if valid_578945 != nil:
    section.add "prettyPrint", valid_578945
  var valid_578946 = query.getOrDefault("oauth_token")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "oauth_token", valid_578946
  var valid_578947 = query.getOrDefault("pageSize")
  valid_578947 = validateParameter(valid_578947, JInt, required = false, default = nil)
  if valid_578947 != nil:
    section.add "pageSize", valid_578947
  var valid_578948 = query.getOrDefault("alt")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("json"))
  if valid_578948 != nil:
    section.add "alt", valid_578948
  var valid_578949 = query.getOrDefault("userIp")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "userIp", valid_578949
  var valid_578950 = query.getOrDefault("quotaUser")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "quotaUser", valid_578950
  var valid_578951 = query.getOrDefault("pageToken")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "pageToken", valid_578951
  var valid_578952 = query.getOrDefault("fields")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "fields", valid_578952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578953: Call_ToolresultsProjectsHistoriesExecutionsList_578939;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Executions for a given History.
  ## 
  ## The executions are sorted by creation_time in descending order. The execution_id key will be used to order the executions with the same creation_time.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing History does not exist
  ## 
  let valid = call_578953.validator(path, query, header, formData, body)
  let scheme = call_578953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578953.url(scheme.get, call_578953.host, call_578953.base,
                         call_578953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578953, url, valid)

proc call*(call_578954: Call_ToolresultsProjectsHistoriesExecutionsList_578939;
          projectId: string; historyId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; pageSize: int = 0;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsList
  ## Lists Executions for a given History.
  ## 
  ## The executions are sorted by creation_time in descending order. The execution_id key will be used to order the executions with the same creation_time.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing History does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
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
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578955 = newJObject()
  var query_578956 = newJObject()
  add(query_578956, "key", newJString(key))
  add(query_578956, "prettyPrint", newJBool(prettyPrint))
  add(query_578956, "oauth_token", newJString(oauthToken))
  add(path_578955, "projectId", newJString(projectId))
  add(query_578956, "pageSize", newJInt(pageSize))
  add(path_578955, "historyId", newJString(historyId))
  add(query_578956, "alt", newJString(alt))
  add(query_578956, "userIp", newJString(userIp))
  add(query_578956, "quotaUser", newJString(quotaUser))
  add(query_578956, "pageToken", newJString(pageToken))
  add(query_578956, "fields", newJString(fields))
  result = call_578954.call(path_578955, query_578956, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsList* = Call_ToolresultsProjectsHistoriesExecutionsList_578939(
    name: "toolresultsProjectsHistoriesExecutionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions",
    validator: validate_ToolresultsProjectsHistoriesExecutionsList_578940,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsList_578941,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsGet_578976 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsGet_578978(protocol: Scheme;
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

proc validate_ToolresultsProjectsHistoriesExecutionsGet_578977(path: JsonNode;
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
  var valid_578979 = path.getOrDefault("projectId")
  valid_578979 = validateParameter(valid_578979, JString, required = true,
                                 default = nil)
  if valid_578979 != nil:
    section.add "projectId", valid_578979
  var valid_578980 = path.getOrDefault("historyId")
  valid_578980 = validateParameter(valid_578980, JString, required = true,
                                 default = nil)
  if valid_578980 != nil:
    section.add "historyId", valid_578980
  var valid_578981 = path.getOrDefault("executionId")
  valid_578981 = validateParameter(valid_578981, JString, required = true,
                                 default = nil)
  if valid_578981 != nil:
    section.add "executionId", valid_578981
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578982 = query.getOrDefault("key")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "key", valid_578982
  var valid_578983 = query.getOrDefault("prettyPrint")
  valid_578983 = validateParameter(valid_578983, JBool, required = false,
                                 default = newJBool(true))
  if valid_578983 != nil:
    section.add "prettyPrint", valid_578983
  var valid_578984 = query.getOrDefault("oauth_token")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "oauth_token", valid_578984
  var valid_578985 = query.getOrDefault("alt")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = newJString("json"))
  if valid_578985 != nil:
    section.add "alt", valid_578985
  var valid_578986 = query.getOrDefault("userIp")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "userIp", valid_578986
  var valid_578987 = query.getOrDefault("quotaUser")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "quotaUser", valid_578987
  var valid_578988 = query.getOrDefault("fields")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "fields", valid_578988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578989: Call_ToolresultsProjectsHistoriesExecutionsGet_578976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an Execution.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the Execution does not exist
  ## 
  let valid = call_578989.validator(path, query, header, formData, body)
  let scheme = call_578989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578989.url(scheme.get, call_578989.host, call_578989.base,
                         call_578989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578989, url, valid)

proc call*(call_578990: Call_ToolresultsProjectsHistoriesExecutionsGet_578976;
          projectId: string; historyId: string; executionId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsGet
  ## Gets an Execution.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the Execution does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   executionId: string (required)
  ##              : An Execution id.
  ## 
  ## Required.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578991 = newJObject()
  var query_578992 = newJObject()
  add(query_578992, "key", newJString(key))
  add(query_578992, "prettyPrint", newJBool(prettyPrint))
  add(query_578992, "oauth_token", newJString(oauthToken))
  add(path_578991, "projectId", newJString(projectId))
  add(path_578991, "historyId", newJString(historyId))
  add(query_578992, "alt", newJString(alt))
  add(query_578992, "userIp", newJString(userIp))
  add(query_578992, "quotaUser", newJString(quotaUser))
  add(path_578991, "executionId", newJString(executionId))
  add(query_578992, "fields", newJString(fields))
  result = call_578990.call(path_578991, query_578992, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsGet* = Call_ToolresultsProjectsHistoriesExecutionsGet_578976(
    name: "toolresultsProjectsHistoriesExecutionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsGet_578977,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsGet_578978,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsPatch_578993 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsPatch_578995(protocol: Scheme;
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

proc validate_ToolresultsProjectsHistoriesExecutionsPatch_578994(path: JsonNode;
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
  var valid_578996 = path.getOrDefault("projectId")
  valid_578996 = validateParameter(valid_578996, JString, required = true,
                                 default = nil)
  if valid_578996 != nil:
    section.add "projectId", valid_578996
  var valid_578997 = path.getOrDefault("historyId")
  valid_578997 = validateParameter(valid_578997, JString, required = true,
                                 default = nil)
  if valid_578997 != nil:
    section.add "historyId", valid_578997
  var valid_578998 = path.getOrDefault("executionId")
  valid_578998 = validateParameter(valid_578998, JString, required = true,
                                 default = nil)
  if valid_578998 != nil:
    section.add "executionId", valid_578998
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   requestId: JString
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578999 = query.getOrDefault("key")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "key", valid_578999
  var valid_579000 = query.getOrDefault("prettyPrint")
  valid_579000 = validateParameter(valid_579000, JBool, required = false,
                                 default = newJBool(true))
  if valid_579000 != nil:
    section.add "prettyPrint", valid_579000
  var valid_579001 = query.getOrDefault("oauth_token")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "oauth_token", valid_579001
  var valid_579002 = query.getOrDefault("alt")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = newJString("json"))
  if valid_579002 != nil:
    section.add "alt", valid_579002
  var valid_579003 = query.getOrDefault("userIp")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "userIp", valid_579003
  var valid_579004 = query.getOrDefault("quotaUser")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "quotaUser", valid_579004
  var valid_579005 = query.getOrDefault("requestId")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "requestId", valid_579005
  var valid_579006 = query.getOrDefault("fields")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "fields", valid_579006
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

proc call*(call_579008: Call_ToolresultsProjectsHistoriesExecutionsPatch_578993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing Execution with the supplied partial entity.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal - NOT_FOUND - if the containing History does not exist
  ## 
  let valid = call_579008.validator(path, query, header, formData, body)
  let scheme = call_579008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579008.url(scheme.get, call_579008.host, call_579008.base,
                         call_579008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579008, url, valid)

proc call*(call_579009: Call_ToolresultsProjectsHistoriesExecutionsPatch_578993;
          projectId: string; historyId: string; executionId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          requestId: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsPatch
  ## Updates an existing Execution with the supplied partial entity.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal - NOT_FOUND - if the containing History does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A Project id. Required.
  ##   historyId: string (required)
  ##            : Required.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   executionId: string (required)
  ##              : Required.
  ##   body: JObject
  ##   requestId: string
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579010 = newJObject()
  var query_579011 = newJObject()
  var body_579012 = newJObject()
  add(query_579011, "key", newJString(key))
  add(query_579011, "prettyPrint", newJBool(prettyPrint))
  add(query_579011, "oauth_token", newJString(oauthToken))
  add(path_579010, "projectId", newJString(projectId))
  add(path_579010, "historyId", newJString(historyId))
  add(query_579011, "alt", newJString(alt))
  add(query_579011, "userIp", newJString(userIp))
  add(query_579011, "quotaUser", newJString(quotaUser))
  add(path_579010, "executionId", newJString(executionId))
  if body != nil:
    body_579012 = body
  add(query_579011, "requestId", newJString(requestId))
  add(query_579011, "fields", newJString(fields))
  result = call_579009.call(path_579010, query_579011, nil, nil, body_579012)

var toolresultsProjectsHistoriesExecutionsPatch* = Call_ToolresultsProjectsHistoriesExecutionsPatch_578993(
    name: "toolresultsProjectsHistoriesExecutionsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsPatch_578994,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsPatch_578995,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsClustersList_579013 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsClustersList_579015(
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

proc validate_ToolresultsProjectsHistoriesExecutionsClustersList_579014(
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
  var valid_579016 = path.getOrDefault("projectId")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "projectId", valid_579016
  var valid_579017 = path.getOrDefault("historyId")
  valid_579017 = validateParameter(valid_579017, JString, required = true,
                                 default = nil)
  if valid_579017 != nil:
    section.add "historyId", valid_579017
  var valid_579018 = path.getOrDefault("executionId")
  valid_579018 = validateParameter(valid_579018, JString, required = true,
                                 default = nil)
  if valid_579018 != nil:
    section.add "executionId", valid_579018
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579019 = query.getOrDefault("key")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "key", valid_579019
  var valid_579020 = query.getOrDefault("prettyPrint")
  valid_579020 = validateParameter(valid_579020, JBool, required = false,
                                 default = newJBool(true))
  if valid_579020 != nil:
    section.add "prettyPrint", valid_579020
  var valid_579021 = query.getOrDefault("oauth_token")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "oauth_token", valid_579021
  var valid_579022 = query.getOrDefault("alt")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = newJString("json"))
  if valid_579022 != nil:
    section.add "alt", valid_579022
  var valid_579023 = query.getOrDefault("userIp")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "userIp", valid_579023
  var valid_579024 = query.getOrDefault("quotaUser")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "quotaUser", valid_579024
  var valid_579025 = query.getOrDefault("fields")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "fields", valid_579025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579026: Call_ToolresultsProjectsHistoriesExecutionsClustersList_579013;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Screenshot Clusters
  ## 
  ## Returns the list of screenshot clusters corresponding to an execution. Screenshot clusters are created after the execution is finished. Clusters are created from a set of screenshots. Between any two screenshots, a matching score is calculated based off their metadata that determines how similar they are. Screenshots are placed in the cluster that has screens which have the highest matching scores.
  ## 
  let valid = call_579026.validator(path, query, header, formData, body)
  let scheme = call_579026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579026.url(scheme.get, call_579026.host, call_579026.base,
                         call_579026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579026, url, valid)

proc call*(call_579027: Call_ToolresultsProjectsHistoriesExecutionsClustersList_579013;
          projectId: string; historyId: string; executionId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsClustersList
  ## Lists Screenshot Clusters
  ## 
  ## Returns the list of screenshot clusters corresponding to an execution. Screenshot clusters are created after the execution is finished. Clusters are created from a set of screenshots. Between any two screenshots, a matching score is calculated based off their metadata that determines how similar they are. Screenshots are placed in the cluster that has screens which have the highest matching scores.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   executionId: string (required)
  ##              : An Execution id.
  ## 
  ## Required.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579028 = newJObject()
  var query_579029 = newJObject()
  add(query_579029, "key", newJString(key))
  add(query_579029, "prettyPrint", newJBool(prettyPrint))
  add(query_579029, "oauth_token", newJString(oauthToken))
  add(path_579028, "projectId", newJString(projectId))
  add(path_579028, "historyId", newJString(historyId))
  add(query_579029, "alt", newJString(alt))
  add(query_579029, "userIp", newJString(userIp))
  add(query_579029, "quotaUser", newJString(quotaUser))
  add(path_579028, "executionId", newJString(executionId))
  add(query_579029, "fields", newJString(fields))
  result = call_579027.call(path_579028, query_579029, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsClustersList* = Call_ToolresultsProjectsHistoriesExecutionsClustersList_579013(
    name: "toolresultsProjectsHistoriesExecutionsClustersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/clusters",
    validator: validate_ToolresultsProjectsHistoriesExecutionsClustersList_579014,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsClustersList_579015,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsClustersGet_579030 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsClustersGet_579032(
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

proc validate_ToolresultsProjectsHistoriesExecutionsClustersGet_579031(
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
  var valid_579033 = path.getOrDefault("projectId")
  valid_579033 = validateParameter(valid_579033, JString, required = true,
                                 default = nil)
  if valid_579033 != nil:
    section.add "projectId", valid_579033
  var valid_579034 = path.getOrDefault("historyId")
  valid_579034 = validateParameter(valid_579034, JString, required = true,
                                 default = nil)
  if valid_579034 != nil:
    section.add "historyId", valid_579034
  var valid_579035 = path.getOrDefault("clusterId")
  valid_579035 = validateParameter(valid_579035, JString, required = true,
                                 default = nil)
  if valid_579035 != nil:
    section.add "clusterId", valid_579035
  var valid_579036 = path.getOrDefault("executionId")
  valid_579036 = validateParameter(valid_579036, JString, required = true,
                                 default = nil)
  if valid_579036 != nil:
    section.add "executionId", valid_579036
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579037 = query.getOrDefault("key")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "key", valid_579037
  var valid_579038 = query.getOrDefault("prettyPrint")
  valid_579038 = validateParameter(valid_579038, JBool, required = false,
                                 default = newJBool(true))
  if valid_579038 != nil:
    section.add "prettyPrint", valid_579038
  var valid_579039 = query.getOrDefault("oauth_token")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "oauth_token", valid_579039
  var valid_579040 = query.getOrDefault("alt")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = newJString("json"))
  if valid_579040 != nil:
    section.add "alt", valid_579040
  var valid_579041 = query.getOrDefault("userIp")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "userIp", valid_579041
  var valid_579042 = query.getOrDefault("quotaUser")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "quotaUser", valid_579042
  var valid_579043 = query.getOrDefault("fields")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "fields", valid_579043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579044: Call_ToolresultsProjectsHistoriesExecutionsClustersGet_579030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a single screenshot cluster by its ID
  ## 
  let valid = call_579044.validator(path, query, header, formData, body)
  let scheme = call_579044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579044.url(scheme.get, call_579044.host, call_579044.base,
                         call_579044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579044, url, valid)

proc call*(call_579045: Call_ToolresultsProjectsHistoriesExecutionsClustersGet_579030;
          projectId: string; historyId: string; clusterId: string;
          executionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsClustersGet
  ## Retrieves a single screenshot cluster by its ID
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : A Cluster id
  ## 
  ## Required.
  ##   executionId: string (required)
  ##              : An Execution id.
  ## 
  ## Required.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579046 = newJObject()
  var query_579047 = newJObject()
  add(query_579047, "key", newJString(key))
  add(query_579047, "prettyPrint", newJBool(prettyPrint))
  add(query_579047, "oauth_token", newJString(oauthToken))
  add(path_579046, "projectId", newJString(projectId))
  add(path_579046, "historyId", newJString(historyId))
  add(query_579047, "alt", newJString(alt))
  add(query_579047, "userIp", newJString(userIp))
  add(query_579047, "quotaUser", newJString(quotaUser))
  add(path_579046, "clusterId", newJString(clusterId))
  add(path_579046, "executionId", newJString(executionId))
  add(query_579047, "fields", newJString(fields))
  result = call_579045.call(path_579046, query_579047, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsClustersGet* = Call_ToolresultsProjectsHistoriesExecutionsClustersGet_579030(
    name: "toolresultsProjectsHistoriesExecutionsClustersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/clusters/{clusterId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsClustersGet_579031,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsClustersGet_579032,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_579067 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsCreate_579069(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsCreate_579068(
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
  ##            : Required. A Project id.
  ##   historyId: JString (required)
  ##            : Required. A History id.
  ##   executionId: JString (required)
  ##              : Required. An Execution id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579070 = path.getOrDefault("projectId")
  valid_579070 = validateParameter(valid_579070, JString, required = true,
                                 default = nil)
  if valid_579070 != nil:
    section.add "projectId", valid_579070
  var valid_579071 = path.getOrDefault("historyId")
  valid_579071 = validateParameter(valid_579071, JString, required = true,
                                 default = nil)
  if valid_579071 != nil:
    section.add "historyId", valid_579071
  var valid_579072 = path.getOrDefault("executionId")
  valid_579072 = validateParameter(valid_579072, JString, required = true,
                                 default = nil)
  if valid_579072 != nil:
    section.add "executionId", valid_579072
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   requestId: JString
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579073 = query.getOrDefault("key")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "key", valid_579073
  var valid_579074 = query.getOrDefault("prettyPrint")
  valid_579074 = validateParameter(valid_579074, JBool, required = false,
                                 default = newJBool(true))
  if valid_579074 != nil:
    section.add "prettyPrint", valid_579074
  var valid_579075 = query.getOrDefault("oauth_token")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "oauth_token", valid_579075
  var valid_579076 = query.getOrDefault("alt")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = newJString("json"))
  if valid_579076 != nil:
    section.add "alt", valid_579076
  var valid_579077 = query.getOrDefault("userIp")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "userIp", valid_579077
  var valid_579078 = query.getOrDefault("quotaUser")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "quotaUser", valid_579078
  var valid_579079 = query.getOrDefault("requestId")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "requestId", valid_579079
  var valid_579080 = query.getOrDefault("fields")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "fields", valid_579080
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

proc call*(call_579082: Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_579067;
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
  let valid = call_579082.validator(path, query, header, formData, body)
  let scheme = call_579082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579082.url(scheme.get, call_579082.host, call_579082.base,
                         call_579082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579082, url, valid)

proc call*(call_579083: Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_579067;
          projectId: string; historyId: string; executionId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          requestId: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsCreate
  ## Creates a Step.
  ## 
  ## The returned Step will have the id set.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the step is too large (more than 10Mib) - NOT_FOUND - if the containing Execution does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. A Project id.
  ##   historyId: string (required)
  ##            : Required. A History id.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   executionId: string (required)
  ##              : Required. An Execution id.
  ##   body: JObject
  ##   requestId: string
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579084 = newJObject()
  var query_579085 = newJObject()
  var body_579086 = newJObject()
  add(query_579085, "key", newJString(key))
  add(query_579085, "prettyPrint", newJBool(prettyPrint))
  add(query_579085, "oauth_token", newJString(oauthToken))
  add(path_579084, "projectId", newJString(projectId))
  add(path_579084, "historyId", newJString(historyId))
  add(query_579085, "alt", newJString(alt))
  add(query_579085, "userIp", newJString(userIp))
  add(query_579085, "quotaUser", newJString(quotaUser))
  add(path_579084, "executionId", newJString(executionId))
  if body != nil:
    body_579086 = body
  add(query_579085, "requestId", newJString(requestId))
  add(query_579085, "fields", newJString(fields))
  result = call_579083.call(path_579084, query_579085, nil, nil, body_579086)

var toolresultsProjectsHistoriesExecutionsStepsCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsCreate_579067(
    name: "toolresultsProjectsHistoriesExecutionsStepsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsCreate_579068,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsCreate_579069,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsList_579048 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsList_579050(protocol: Scheme;
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsList_579049(
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
  var valid_579051 = path.getOrDefault("projectId")
  valid_579051 = validateParameter(valid_579051, JString, required = true,
                                 default = nil)
  if valid_579051 != nil:
    section.add "projectId", valid_579051
  var valid_579052 = path.getOrDefault("historyId")
  valid_579052 = validateParameter(valid_579052, JString, required = true,
                                 default = nil)
  if valid_579052 != nil:
    section.add "historyId", valid_579052
  var valid_579053 = path.getOrDefault("executionId")
  valid_579053 = validateParameter(valid_579053, JString, required = true,
                                 default = nil)
  if valid_579053 != nil:
    section.add "executionId", valid_579053
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   pageSize: JInt
  ##           : The maximum number of Steps to fetch.
  ## 
  ## Default value: 25. The server will use this default if the field is not set or has a value of 0.
  ## 
  ## Optional.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579054 = query.getOrDefault("key")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "key", valid_579054
  var valid_579055 = query.getOrDefault("prettyPrint")
  valid_579055 = validateParameter(valid_579055, JBool, required = false,
                                 default = newJBool(true))
  if valid_579055 != nil:
    section.add "prettyPrint", valid_579055
  var valid_579056 = query.getOrDefault("oauth_token")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "oauth_token", valid_579056
  var valid_579057 = query.getOrDefault("pageSize")
  valid_579057 = validateParameter(valid_579057, JInt, required = false, default = nil)
  if valid_579057 != nil:
    section.add "pageSize", valid_579057
  var valid_579058 = query.getOrDefault("alt")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = newJString("json"))
  if valid_579058 != nil:
    section.add "alt", valid_579058
  var valid_579059 = query.getOrDefault("userIp")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "userIp", valid_579059
  var valid_579060 = query.getOrDefault("quotaUser")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "quotaUser", valid_579060
  var valid_579061 = query.getOrDefault("pageToken")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "pageToken", valid_579061
  var valid_579062 = query.getOrDefault("fields")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "fields", valid_579062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579063: Call_ToolresultsProjectsHistoriesExecutionsStepsList_579048;
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
  let valid = call_579063.validator(path, query, header, formData, body)
  let scheme = call_579063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579063.url(scheme.get, call_579063.host, call_579063.base,
                         call_579063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579063, url, valid)

proc call*(call_579064: Call_ToolresultsProjectsHistoriesExecutionsStepsList_579048;
          projectId: string; historyId: string; executionId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; pageSize: int = 0;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsList
  ## Lists Steps for a given Execution.
  ## 
  ## The steps are sorted by creation_time in descending order. The step_id key will be used to order the steps with the same creation_time.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if an argument in the request happens to be invalid; e.g. if an attempt is made to list the children of a nonexistent Step - NOT_FOUND - if the containing Execution does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
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
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   executionId: string (required)
  ##              : A Execution id.
  ## 
  ## Required.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579065 = newJObject()
  var query_579066 = newJObject()
  add(query_579066, "key", newJString(key))
  add(query_579066, "prettyPrint", newJBool(prettyPrint))
  add(query_579066, "oauth_token", newJString(oauthToken))
  add(path_579065, "projectId", newJString(projectId))
  add(query_579066, "pageSize", newJInt(pageSize))
  add(path_579065, "historyId", newJString(historyId))
  add(query_579066, "alt", newJString(alt))
  add(query_579066, "userIp", newJString(userIp))
  add(query_579066, "quotaUser", newJString(quotaUser))
  add(query_579066, "pageToken", newJString(pageToken))
  add(path_579065, "executionId", newJString(executionId))
  add(query_579066, "fields", newJString(fields))
  result = call_579064.call(path_579065, query_579066, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsList* = Call_ToolresultsProjectsHistoriesExecutionsStepsList_579048(
    name: "toolresultsProjectsHistoriesExecutionsStepsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsList_579049,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsList_579050,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsGet_579087 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsGet_579089(protocol: Scheme;
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsGet_579088(
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
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   stepId: JString (required)
  ##         : A Step id.
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : A Execution id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579090 = path.getOrDefault("projectId")
  valid_579090 = validateParameter(valid_579090, JString, required = true,
                                 default = nil)
  if valid_579090 != nil:
    section.add "projectId", valid_579090
  var valid_579091 = path.getOrDefault("historyId")
  valid_579091 = validateParameter(valid_579091, JString, required = true,
                                 default = nil)
  if valid_579091 != nil:
    section.add "historyId", valid_579091
  var valid_579092 = path.getOrDefault("stepId")
  valid_579092 = validateParameter(valid_579092, JString, required = true,
                                 default = nil)
  if valid_579092 != nil:
    section.add "stepId", valid_579092
  var valid_579093 = path.getOrDefault("executionId")
  valid_579093 = validateParameter(valid_579093, JString, required = true,
                                 default = nil)
  if valid_579093 != nil:
    section.add "executionId", valid_579093
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579094 = query.getOrDefault("key")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "key", valid_579094
  var valid_579095 = query.getOrDefault("prettyPrint")
  valid_579095 = validateParameter(valid_579095, JBool, required = false,
                                 default = newJBool(true))
  if valid_579095 != nil:
    section.add "prettyPrint", valid_579095
  var valid_579096 = query.getOrDefault("oauth_token")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "oauth_token", valid_579096
  var valid_579097 = query.getOrDefault("alt")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = newJString("json"))
  if valid_579097 != nil:
    section.add "alt", valid_579097
  var valid_579098 = query.getOrDefault("userIp")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "userIp", valid_579098
  var valid_579099 = query.getOrDefault("quotaUser")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "quotaUser", valid_579099
  var valid_579100 = query.getOrDefault("fields")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "fields", valid_579100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579101: Call_ToolresultsProjectsHistoriesExecutionsStepsGet_579087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a Step.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the Step does not exist
  ## 
  let valid = call_579101.validator(path, query, header, formData, body)
  let scheme = call_579101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579101.url(scheme.get, call_579101.host, call_579101.base,
                         call_579101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579101, url, valid)

proc call*(call_579102: Call_ToolresultsProjectsHistoriesExecutionsStepsGet_579087;
          projectId: string; historyId: string; stepId: string; executionId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsGet
  ## Gets a Step.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the Step does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   stepId: string (required)
  ##         : A Step id.
  ## 
  ## Required.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   executionId: string (required)
  ##              : A Execution id.
  ## 
  ## Required.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579103 = newJObject()
  var query_579104 = newJObject()
  add(query_579104, "key", newJString(key))
  add(query_579104, "prettyPrint", newJBool(prettyPrint))
  add(query_579104, "oauth_token", newJString(oauthToken))
  add(path_579103, "projectId", newJString(projectId))
  add(path_579103, "historyId", newJString(historyId))
  add(query_579104, "alt", newJString(alt))
  add(query_579104, "userIp", newJString(userIp))
  add(path_579103, "stepId", newJString(stepId))
  add(query_579104, "quotaUser", newJString(quotaUser))
  add(path_579103, "executionId", newJString(executionId))
  add(query_579104, "fields", newJString(fields))
  result = call_579102.call(path_579103, query_579104, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsGet* = Call_ToolresultsProjectsHistoriesExecutionsStepsGet_579087(
    name: "toolresultsProjectsHistoriesExecutionsStepsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsGet_579088,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsGet_579089,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_579105 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsPatch_579107(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPatch_579106(
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
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   stepId: JString (required)
  ##         : A Step id.
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : A Execution id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579108 = path.getOrDefault("projectId")
  valid_579108 = validateParameter(valid_579108, JString, required = true,
                                 default = nil)
  if valid_579108 != nil:
    section.add "projectId", valid_579108
  var valid_579109 = path.getOrDefault("historyId")
  valid_579109 = validateParameter(valid_579109, JString, required = true,
                                 default = nil)
  if valid_579109 != nil:
    section.add "historyId", valid_579109
  var valid_579110 = path.getOrDefault("stepId")
  valid_579110 = validateParameter(valid_579110, JString, required = true,
                                 default = nil)
  if valid_579110 != nil:
    section.add "stepId", valid_579110
  var valid_579111 = path.getOrDefault("executionId")
  valid_579111 = validateParameter(valid_579111, JString, required = true,
                                 default = nil)
  if valid_579111 != nil:
    section.add "executionId", valid_579111
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   requestId: JString
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579112 = query.getOrDefault("key")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "key", valid_579112
  var valid_579113 = query.getOrDefault("prettyPrint")
  valid_579113 = validateParameter(valid_579113, JBool, required = false,
                                 default = newJBool(true))
  if valid_579113 != nil:
    section.add "prettyPrint", valid_579113
  var valid_579114 = query.getOrDefault("oauth_token")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "oauth_token", valid_579114
  var valid_579115 = query.getOrDefault("alt")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = newJString("json"))
  if valid_579115 != nil:
    section.add "alt", valid_579115
  var valid_579116 = query.getOrDefault("userIp")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "userIp", valid_579116
  var valid_579117 = query.getOrDefault("quotaUser")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "quotaUser", valid_579117
  var valid_579118 = query.getOrDefault("requestId")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "requestId", valid_579118
  var valid_579119 = query.getOrDefault("fields")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "fields", valid_579119
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

proc call*(call_579121: Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_579105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing Step with the supplied partial entity.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal (e.g try to upload a duplicate xml file), if the updated step is too large (more than 10Mib) - NOT_FOUND - if the containing Execution does not exist
  ## 
  let valid = call_579121.validator(path, query, header, formData, body)
  let scheme = call_579121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579121.url(scheme.get, call_579121.host, call_579121.base,
                         call_579121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579121, url, valid)

proc call*(call_579122: Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_579105;
          projectId: string; historyId: string; stepId: string; executionId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; requestId: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPatch
  ## Updates an existing Step with the supplied partial entity.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal (e.g try to upload a duplicate xml file), if the updated step is too large (more than 10Mib) - NOT_FOUND - if the containing Execution does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   stepId: string (required)
  ##         : A Step id.
  ## 
  ## Required.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   executionId: string (required)
  ##              : A Execution id.
  ## 
  ## Required.
  ##   body: JObject
  ##   requestId: string
  ##            : A unique request ID for server to detect duplicated requests. For example, a UUID.
  ## 
  ## Optional, but strongly recommended.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579123 = newJObject()
  var query_579124 = newJObject()
  var body_579125 = newJObject()
  add(query_579124, "key", newJString(key))
  add(query_579124, "prettyPrint", newJBool(prettyPrint))
  add(query_579124, "oauth_token", newJString(oauthToken))
  add(path_579123, "projectId", newJString(projectId))
  add(path_579123, "historyId", newJString(historyId))
  add(query_579124, "alt", newJString(alt))
  add(query_579124, "userIp", newJString(userIp))
  add(path_579123, "stepId", newJString(stepId))
  add(query_579124, "quotaUser", newJString(quotaUser))
  add(path_579123, "executionId", newJString(executionId))
  if body != nil:
    body_579125 = body
  add(query_579124, "requestId", newJString(requestId))
  add(query_579124, "fields", newJString(fields))
  result = call_579122.call(path_579123, query_579124, nil, nil, body_579125)

var toolresultsProjectsHistoriesExecutionsStepsPatch* = Call_ToolresultsProjectsHistoriesExecutionsStepsPatch_579105(
    name: "toolresultsProjectsHistoriesExecutionsStepsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}",
    validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPatch_579106,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPatch_579107,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_579144 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_579146(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_579145(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a PerfMetricsSummary resource. Returns the existing one if it has already been created.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The containing Step does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The cloud project
  ##   historyId: JString (required)
  ##            : A tool results history ID.
  ##   stepId: JString (required)
  ##         : A tool results step ID.
  ##   executionId: JString (required)
  ##              : A tool results execution ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579147 = path.getOrDefault("projectId")
  valid_579147 = validateParameter(valid_579147, JString, required = true,
                                 default = nil)
  if valid_579147 != nil:
    section.add "projectId", valid_579147
  var valid_579148 = path.getOrDefault("historyId")
  valid_579148 = validateParameter(valid_579148, JString, required = true,
                                 default = nil)
  if valid_579148 != nil:
    section.add "historyId", valid_579148
  var valid_579149 = path.getOrDefault("stepId")
  valid_579149 = validateParameter(valid_579149, JString, required = true,
                                 default = nil)
  if valid_579149 != nil:
    section.add "stepId", valid_579149
  var valid_579150 = path.getOrDefault("executionId")
  valid_579150 = validateParameter(valid_579150, JString, required = true,
                                 default = nil)
  if valid_579150 != nil:
    section.add "executionId", valid_579150
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579151 = query.getOrDefault("key")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "key", valid_579151
  var valid_579152 = query.getOrDefault("prettyPrint")
  valid_579152 = validateParameter(valid_579152, JBool, required = false,
                                 default = newJBool(true))
  if valid_579152 != nil:
    section.add "prettyPrint", valid_579152
  var valid_579153 = query.getOrDefault("oauth_token")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "oauth_token", valid_579153
  var valid_579154 = query.getOrDefault("alt")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = newJString("json"))
  if valid_579154 != nil:
    section.add "alt", valid_579154
  var valid_579155 = query.getOrDefault("userIp")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "userIp", valid_579155
  var valid_579156 = query.getOrDefault("quotaUser")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "quotaUser", valid_579156
  var valid_579157 = query.getOrDefault("fields")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "fields", valid_579157
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

proc call*(call_579159: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_579144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a PerfMetricsSummary resource. Returns the existing one if it has already been created.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The containing Step does not exist
  ## 
  let valid = call_579159.validator(path, query, header, formData, body)
  let scheme = call_579159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579159.url(scheme.get, call_579159.host, call_579159.base,
                         call_579159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579159, url, valid)

proc call*(call_579160: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_579144;
          projectId: string; historyId: string; stepId: string; executionId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate
  ## Creates a PerfMetricsSummary resource. Returns the existing one if it has already been created.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The containing Step does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The cloud project
  ##   historyId: string (required)
  ##            : A tool results history ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   stepId: string (required)
  ##         : A tool results step ID.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   executionId: string (required)
  ##              : A tool results execution ID.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579161 = newJObject()
  var query_579162 = newJObject()
  var body_579163 = newJObject()
  add(query_579162, "key", newJString(key))
  add(query_579162, "prettyPrint", newJBool(prettyPrint))
  add(query_579162, "oauth_token", newJString(oauthToken))
  add(path_579161, "projectId", newJString(projectId))
  add(path_579161, "historyId", newJString(historyId))
  add(query_579162, "alt", newJString(alt))
  add(query_579162, "userIp", newJString(userIp))
  add(path_579161, "stepId", newJString(stepId))
  add(query_579162, "quotaUser", newJString(quotaUser))
  add(path_579161, "executionId", newJString(executionId))
  if body != nil:
    body_579163 = body
  add(query_579162, "fields", newJString(fields))
  result = call_579160.call(path_579161, query_579162, nil, nil, body_579163)

var toolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_579144(name: "toolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfMetricsSummary", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_579145,
    base: "/toolresults/v1beta3/projects", url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfMetricsSummaryCreate_579146,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_579126 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_579128(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_579127(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves a PerfMetricsSummary.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfMetricsSummary does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The cloud project
  ##   historyId: JString (required)
  ##            : A tool results history ID.
  ##   stepId: JString (required)
  ##         : A tool results step ID.
  ##   executionId: JString (required)
  ##              : A tool results execution ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579129 = path.getOrDefault("projectId")
  valid_579129 = validateParameter(valid_579129, JString, required = true,
                                 default = nil)
  if valid_579129 != nil:
    section.add "projectId", valid_579129
  var valid_579130 = path.getOrDefault("historyId")
  valid_579130 = validateParameter(valid_579130, JString, required = true,
                                 default = nil)
  if valid_579130 != nil:
    section.add "historyId", valid_579130
  var valid_579131 = path.getOrDefault("stepId")
  valid_579131 = validateParameter(valid_579131, JString, required = true,
                                 default = nil)
  if valid_579131 != nil:
    section.add "stepId", valid_579131
  var valid_579132 = path.getOrDefault("executionId")
  valid_579132 = validateParameter(valid_579132, JString, required = true,
                                 default = nil)
  if valid_579132 != nil:
    section.add "executionId", valid_579132
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579133 = query.getOrDefault("key")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "key", valid_579133
  var valid_579134 = query.getOrDefault("prettyPrint")
  valid_579134 = validateParameter(valid_579134, JBool, required = false,
                                 default = newJBool(true))
  if valid_579134 != nil:
    section.add "prettyPrint", valid_579134
  var valid_579135 = query.getOrDefault("oauth_token")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "oauth_token", valid_579135
  var valid_579136 = query.getOrDefault("alt")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = newJString("json"))
  if valid_579136 != nil:
    section.add "alt", valid_579136
  var valid_579137 = query.getOrDefault("userIp")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "userIp", valid_579137
  var valid_579138 = query.getOrDefault("quotaUser")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "quotaUser", valid_579138
  var valid_579139 = query.getOrDefault("fields")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "fields", valid_579139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579140: Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_579126;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a PerfMetricsSummary.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfMetricsSummary does not exist
  ## 
  let valid = call_579140.validator(path, query, header, formData, body)
  let scheme = call_579140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579140.url(scheme.get, call_579140.host, call_579140.base,
                         call_579140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579140, url, valid)

proc call*(call_579141: Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_579126;
          projectId: string; historyId: string; stepId: string; executionId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary
  ## Retrieves a PerfMetricsSummary.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfMetricsSummary does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The cloud project
  ##   historyId: string (required)
  ##            : A tool results history ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   stepId: string (required)
  ##         : A tool results step ID.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   executionId: string (required)
  ##              : A tool results execution ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579142 = newJObject()
  var query_579143 = newJObject()
  add(query_579143, "key", newJString(key))
  add(query_579143, "prettyPrint", newJBool(prettyPrint))
  add(query_579143, "oauth_token", newJString(oauthToken))
  add(path_579142, "projectId", newJString(projectId))
  add(path_579142, "historyId", newJString(historyId))
  add(query_579143, "alt", newJString(alt))
  add(query_579143, "userIp", newJString(userIp))
  add(path_579142, "stepId", newJString(stepId))
  add(query_579143, "quotaUser", newJString(quotaUser))
  add(path_579142, "executionId", newJString(executionId))
  add(query_579143, "fields", newJString(fields))
  result = call_579141.call(path_579142, query_579143, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary* = Call_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_579126(
    name: "toolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfMetricsSummary", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_579127,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsGetPerfMetricsSummary_579128,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_579183 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_579185(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_579184(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - ALREADY_EXISTS - PerfMetricSummary already exists for the given Step - NOT_FOUND - The containing Step does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The cloud project
  ##   historyId: JString (required)
  ##            : A tool results history ID.
  ##   stepId: JString (required)
  ##         : A tool results step ID.
  ##   executionId: JString (required)
  ##              : A tool results execution ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579186 = path.getOrDefault("projectId")
  valid_579186 = validateParameter(valid_579186, JString, required = true,
                                 default = nil)
  if valid_579186 != nil:
    section.add "projectId", valid_579186
  var valid_579187 = path.getOrDefault("historyId")
  valid_579187 = validateParameter(valid_579187, JString, required = true,
                                 default = nil)
  if valid_579187 != nil:
    section.add "historyId", valid_579187
  var valid_579188 = path.getOrDefault("stepId")
  valid_579188 = validateParameter(valid_579188, JString, required = true,
                                 default = nil)
  if valid_579188 != nil:
    section.add "stepId", valid_579188
  var valid_579189 = path.getOrDefault("executionId")
  valid_579189 = validateParameter(valid_579189, JString, required = true,
                                 default = nil)
  if valid_579189 != nil:
    section.add "executionId", valid_579189
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579190 = query.getOrDefault("key")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "key", valid_579190
  var valid_579191 = query.getOrDefault("prettyPrint")
  valid_579191 = validateParameter(valid_579191, JBool, required = false,
                                 default = newJBool(true))
  if valid_579191 != nil:
    section.add "prettyPrint", valid_579191
  var valid_579192 = query.getOrDefault("oauth_token")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "oauth_token", valid_579192
  var valid_579193 = query.getOrDefault("alt")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = newJString("json"))
  if valid_579193 != nil:
    section.add "alt", valid_579193
  var valid_579194 = query.getOrDefault("userIp")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "userIp", valid_579194
  var valid_579195 = query.getOrDefault("quotaUser")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "quotaUser", valid_579195
  var valid_579196 = query.getOrDefault("fields")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "fields", valid_579196
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

proc call*(call_579198: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_579183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - ALREADY_EXISTS - PerfMetricSummary already exists for the given Step - NOT_FOUND - The containing Step does not exist
  ## 
  let valid = call_579198.validator(path, query, header, formData, body)
  let scheme = call_579198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579198.url(scheme.get, call_579198.host, call_579198.base,
                         call_579198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579198, url, valid)

proc call*(call_579199: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_579183;
          projectId: string; historyId: string; stepId: string; executionId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate
  ## Creates a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - ALREADY_EXISTS - PerfMetricSummary already exists for the given Step - NOT_FOUND - The containing Step does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The cloud project
  ##   historyId: string (required)
  ##            : A tool results history ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   stepId: string (required)
  ##         : A tool results step ID.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   executionId: string (required)
  ##              : A tool results execution ID.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579200 = newJObject()
  var query_579201 = newJObject()
  var body_579202 = newJObject()
  add(query_579201, "key", newJString(key))
  add(query_579201, "prettyPrint", newJBool(prettyPrint))
  add(query_579201, "oauth_token", newJString(oauthToken))
  add(path_579200, "projectId", newJString(projectId))
  add(path_579200, "historyId", newJString(historyId))
  add(query_579201, "alt", newJString(alt))
  add(query_579201, "userIp", newJString(userIp))
  add(path_579200, "stepId", newJString(stepId))
  add(query_579201, "quotaUser", newJString(quotaUser))
  add(path_579200, "executionId", newJString(executionId))
  if body != nil:
    body_579202 = body
  add(query_579201, "fields", newJString(fields))
  result = call_579199.call(path_579200, query_579201, nil, nil, body_579202)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_579183(
    name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_579184,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesCreate_579185,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_579164 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_579166(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_579165(
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
  ##   projectId: JString (required)
  ##            : The cloud project
  ##   historyId: JString (required)
  ##            : A tool results history ID.
  ##   stepId: JString (required)
  ##         : A tool results step ID.
  ##   executionId: JString (required)
  ##              : A tool results execution ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579167 = path.getOrDefault("projectId")
  valid_579167 = validateParameter(valid_579167, JString, required = true,
                                 default = nil)
  if valid_579167 != nil:
    section.add "projectId", valid_579167
  var valid_579168 = path.getOrDefault("historyId")
  valid_579168 = validateParameter(valid_579168, JString, required = true,
                                 default = nil)
  if valid_579168 != nil:
    section.add "historyId", valid_579168
  var valid_579169 = path.getOrDefault("stepId")
  valid_579169 = validateParameter(valid_579169, JString, required = true,
                                 default = nil)
  if valid_579169 != nil:
    section.add "stepId", valid_579169
  var valid_579170 = path.getOrDefault("executionId")
  valid_579170 = validateParameter(valid_579170, JString, required = true,
                                 default = nil)
  if valid_579170 != nil:
    section.add "executionId", valid_579170
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   filter: JArray
  ##         : Specify one or more PerfMetricType values such as CPU to filter the result
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579171 = query.getOrDefault("key")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "key", valid_579171
  var valid_579172 = query.getOrDefault("prettyPrint")
  valid_579172 = validateParameter(valid_579172, JBool, required = false,
                                 default = newJBool(true))
  if valid_579172 != nil:
    section.add "prettyPrint", valid_579172
  var valid_579173 = query.getOrDefault("oauth_token")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "oauth_token", valid_579173
  var valid_579174 = query.getOrDefault("alt")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = newJString("json"))
  if valid_579174 != nil:
    section.add "alt", valid_579174
  var valid_579175 = query.getOrDefault("userIp")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "userIp", valid_579175
  var valid_579176 = query.getOrDefault("quotaUser")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "quotaUser", valid_579176
  var valid_579177 = query.getOrDefault("filter")
  valid_579177 = validateParameter(valid_579177, JArray, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "filter", valid_579177
  var valid_579178 = query.getOrDefault("fields")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "fields", valid_579178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579179: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_579164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists PerfSampleSeries for a given Step.
  ## 
  ## The request provides an optional filter which specifies one or more PerfMetricsType to include in the result; if none returns all. The resulting PerfSampleSeries are sorted by ids.
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing Step does not exist
  ## 
  let valid = call_579179.validator(path, query, header, formData, body)
  let scheme = call_579179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579179.url(scheme.get, call_579179.host, call_579179.base,
                         call_579179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579179, url, valid)

proc call*(call_579180: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_579164;
          projectId: string; historyId: string; stepId: string; executionId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          filter: JsonNode = nil; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList
  ## Lists PerfSampleSeries for a given Step.
  ## 
  ## The request provides an optional filter which specifies one or more PerfMetricsType to include in the result; if none returns all. The resulting PerfSampleSeries are sorted by ids.
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing Step does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The cloud project
  ##   historyId: string (required)
  ##            : A tool results history ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   stepId: string (required)
  ##         : A tool results step ID.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   filter: JArray
  ##         : Specify one or more PerfMetricType values such as CPU to filter the result
  ##   executionId: string (required)
  ##              : A tool results execution ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579181 = newJObject()
  var query_579182 = newJObject()
  add(query_579182, "key", newJString(key))
  add(query_579182, "prettyPrint", newJBool(prettyPrint))
  add(query_579182, "oauth_token", newJString(oauthToken))
  add(path_579181, "projectId", newJString(projectId))
  add(path_579181, "historyId", newJString(historyId))
  add(query_579182, "alt", newJString(alt))
  add(query_579182, "userIp", newJString(userIp))
  add(path_579181, "stepId", newJString(stepId))
  add(query_579182, "quotaUser", newJString(quotaUser))
  if filter != nil:
    query_579182.add "filter", filter
  add(path_579181, "executionId", newJString(executionId))
  add(query_579182, "fields", newJString(fields))
  result = call_579180.call(path_579181, query_579182, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_579164(
    name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_579165,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesList_579166,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_579203 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_579205(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_579204(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfSampleSeries does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The cloud project
  ##   historyId: JString (required)
  ##            : A tool results history ID.
  ##   stepId: JString (required)
  ##         : A tool results step ID.
  ##   sampleSeriesId: JString (required)
  ##                 : A sample series id
  ##   executionId: JString (required)
  ##              : A tool results execution ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579206 = path.getOrDefault("projectId")
  valid_579206 = validateParameter(valid_579206, JString, required = true,
                                 default = nil)
  if valid_579206 != nil:
    section.add "projectId", valid_579206
  var valid_579207 = path.getOrDefault("historyId")
  valid_579207 = validateParameter(valid_579207, JString, required = true,
                                 default = nil)
  if valid_579207 != nil:
    section.add "historyId", valid_579207
  var valid_579208 = path.getOrDefault("stepId")
  valid_579208 = validateParameter(valid_579208, JString, required = true,
                                 default = nil)
  if valid_579208 != nil:
    section.add "stepId", valid_579208
  var valid_579209 = path.getOrDefault("sampleSeriesId")
  valid_579209 = validateParameter(valid_579209, JString, required = true,
                                 default = nil)
  if valid_579209 != nil:
    section.add "sampleSeriesId", valid_579209
  var valid_579210 = path.getOrDefault("executionId")
  valid_579210 = validateParameter(valid_579210, JString, required = true,
                                 default = nil)
  if valid_579210 != nil:
    section.add "executionId", valid_579210
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579211 = query.getOrDefault("key")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "key", valid_579211
  var valid_579212 = query.getOrDefault("prettyPrint")
  valid_579212 = validateParameter(valid_579212, JBool, required = false,
                                 default = newJBool(true))
  if valid_579212 != nil:
    section.add "prettyPrint", valid_579212
  var valid_579213 = query.getOrDefault("oauth_token")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "oauth_token", valid_579213
  var valid_579214 = query.getOrDefault("alt")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = newJString("json"))
  if valid_579214 != nil:
    section.add "alt", valid_579214
  var valid_579215 = query.getOrDefault("userIp")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "userIp", valid_579215
  var valid_579216 = query.getOrDefault("quotaUser")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "quotaUser", valid_579216
  var valid_579217 = query.getOrDefault("fields")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "fields", valid_579217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579218: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_579203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfSampleSeries does not exist
  ## 
  let valid = call_579218.validator(path, query, header, formData, body)
  let scheme = call_579218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579218.url(scheme.get, call_579218.host, call_579218.base,
                         call_579218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579218, url, valid)

proc call*(call_579219: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_579203;
          projectId: string; historyId: string; stepId: string;
          sampleSeriesId: string; executionId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet
  ## Gets a PerfSampleSeries.
  ## 
  ## May return any of the following error code(s): - NOT_FOUND - The specified PerfSampleSeries does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The cloud project
  ##   historyId: string (required)
  ##            : A tool results history ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   stepId: string (required)
  ##         : A tool results step ID.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sampleSeriesId: string (required)
  ##                 : A sample series id
  ##   executionId: string (required)
  ##              : A tool results execution ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579220 = newJObject()
  var query_579221 = newJObject()
  add(query_579221, "key", newJString(key))
  add(query_579221, "prettyPrint", newJBool(prettyPrint))
  add(query_579221, "oauth_token", newJString(oauthToken))
  add(path_579220, "projectId", newJString(projectId))
  add(path_579220, "historyId", newJString(historyId))
  add(query_579221, "alt", newJString(alt))
  add(query_579221, "userIp", newJString(userIp))
  add(path_579220, "stepId", newJString(stepId))
  add(query_579221, "quotaUser", newJString(quotaUser))
  add(path_579220, "sampleSeriesId", newJString(sampleSeriesId))
  add(path_579220, "executionId", newJString(executionId))
  add(query_579221, "fields", newJString(fields))
  result = call_579219.call(path_579220, query_579221, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_579203(
    name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries/{sampleSeriesId}", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_579204,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesGet_579205,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_579222 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_579224(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_579223(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the Performance Samples of a given Sample Series - The list results are sorted by timestamps ascending - The default page size is 500 samples; and maximum size allowed 5000 - The response token indicates the last returned PerfSample timestamp - When the results size exceeds the page size, submit a subsequent request including the page token to return the rest of the samples up to the page limit
  ## 
  ## May return any of the following canonical error codes: - OUT_OF_RANGE - The specified request page_token is out of valid range - NOT_FOUND - The containing PerfSampleSeries does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The cloud project
  ##   historyId: JString (required)
  ##            : A tool results history ID.
  ##   stepId: JString (required)
  ##         : A tool results step ID.
  ##   sampleSeriesId: JString (required)
  ##                 : A sample series id
  ##   executionId: JString (required)
  ##              : A tool results execution ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579225 = path.getOrDefault("projectId")
  valid_579225 = validateParameter(valid_579225, JString, required = true,
                                 default = nil)
  if valid_579225 != nil:
    section.add "projectId", valid_579225
  var valid_579226 = path.getOrDefault("historyId")
  valid_579226 = validateParameter(valid_579226, JString, required = true,
                                 default = nil)
  if valid_579226 != nil:
    section.add "historyId", valid_579226
  var valid_579227 = path.getOrDefault("stepId")
  valid_579227 = validateParameter(valid_579227, JString, required = true,
                                 default = nil)
  if valid_579227 != nil:
    section.add "stepId", valid_579227
  var valid_579228 = path.getOrDefault("sampleSeriesId")
  valid_579228 = validateParameter(valid_579228, JString, required = true,
                                 default = nil)
  if valid_579228 != nil:
    section.add "sampleSeriesId", valid_579228
  var valid_579229 = path.getOrDefault("executionId")
  valid_579229 = validateParameter(valid_579229, JString, required = true,
                                 default = nil)
  if valid_579229 != nil:
    section.add "executionId", valid_579229
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   pageSize: JInt
  ##           : The default page size is 500 samples, and the maximum size is 5000. If the page_size is greater than 5000, the effective page size will be 5000
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional, the next_page_token returned in the previous response
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579230 = query.getOrDefault("key")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "key", valid_579230
  var valid_579231 = query.getOrDefault("prettyPrint")
  valid_579231 = validateParameter(valid_579231, JBool, required = false,
                                 default = newJBool(true))
  if valid_579231 != nil:
    section.add "prettyPrint", valid_579231
  var valid_579232 = query.getOrDefault("oauth_token")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "oauth_token", valid_579232
  var valid_579233 = query.getOrDefault("pageSize")
  valid_579233 = validateParameter(valid_579233, JInt, required = false, default = nil)
  if valid_579233 != nil:
    section.add "pageSize", valid_579233
  var valid_579234 = query.getOrDefault("alt")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = newJString("json"))
  if valid_579234 != nil:
    section.add "alt", valid_579234
  var valid_579235 = query.getOrDefault("userIp")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "userIp", valid_579235
  var valid_579236 = query.getOrDefault("quotaUser")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "quotaUser", valid_579236
  var valid_579237 = query.getOrDefault("pageToken")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "pageToken", valid_579237
  var valid_579238 = query.getOrDefault("fields")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "fields", valid_579238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579239: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_579222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Performance Samples of a given Sample Series - The list results are sorted by timestamps ascending - The default page size is 500 samples; and maximum size allowed 5000 - The response token indicates the last returned PerfSample timestamp - When the results size exceeds the page size, submit a subsequent request including the page token to return the rest of the samples up to the page limit
  ## 
  ## May return any of the following canonical error codes: - OUT_OF_RANGE - The specified request page_token is out of valid range - NOT_FOUND - The containing PerfSampleSeries does not exist
  ## 
  let valid = call_579239.validator(path, query, header, formData, body)
  let scheme = call_579239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579239.url(scheme.get, call_579239.host, call_579239.base,
                         call_579239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579239, url, valid)

proc call*(call_579240: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_579222;
          projectId: string; historyId: string; stepId: string;
          sampleSeriesId: string; executionId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; pageSize: int = 0;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList
  ## Lists the Performance Samples of a given Sample Series - The list results are sorted by timestamps ascending - The default page size is 500 samples; and maximum size allowed 5000 - The response token indicates the last returned PerfSample timestamp - When the results size exceeds the page size, submit a subsequent request including the page token to return the rest of the samples up to the page limit
  ## 
  ## May return any of the following canonical error codes: - OUT_OF_RANGE - The specified request page_token is out of valid range - NOT_FOUND - The containing PerfSampleSeries does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The cloud project
  ##   pageSize: int
  ##           : The default page size is 500 samples, and the maximum size is 5000. If the page_size is greater than 5000, the effective page size will be 5000
  ##   historyId: string (required)
  ##            : A tool results history ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   stepId: string (required)
  ##         : A tool results step ID.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional, the next_page_token returned in the previous response
  ##   sampleSeriesId: string (required)
  ##                 : A sample series id
  ##   executionId: string (required)
  ##              : A tool results execution ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579241 = newJObject()
  var query_579242 = newJObject()
  add(query_579242, "key", newJString(key))
  add(query_579242, "prettyPrint", newJBool(prettyPrint))
  add(query_579242, "oauth_token", newJString(oauthToken))
  add(path_579241, "projectId", newJString(projectId))
  add(query_579242, "pageSize", newJInt(pageSize))
  add(path_579241, "historyId", newJString(historyId))
  add(query_579242, "alt", newJString(alt))
  add(query_579242, "userIp", newJString(userIp))
  add(path_579241, "stepId", newJString(stepId))
  add(query_579242, "quotaUser", newJString(quotaUser))
  add(query_579242, "pageToken", newJString(pageToken))
  add(path_579241, "sampleSeriesId", newJString(sampleSeriesId))
  add(path_579241, "executionId", newJString(executionId))
  add(query_579242, "fields", newJString(fields))
  result = call_579240.call(path_579241, query_579242, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_579222(name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries/{sampleSeriesId}/samples", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_579223,
    base: "/toolresults/v1beta3/projects", url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesList_579224,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_579243 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_579245(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_579244(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a batch of PerfSamples - a client can submit multiple batches of Perf Samples through repeated calls to this method in order to split up a large request payload - duplicates and existing timestamp entries will be ignored. - the batch operation may partially succeed - the set of elements successfully inserted is returned in the response (omits items which already existed in the database).
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing PerfSampleSeries does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The cloud project
  ##   historyId: JString (required)
  ##            : A tool results history ID.
  ##   stepId: JString (required)
  ##         : A tool results step ID.
  ##   sampleSeriesId: JString (required)
  ##                 : A sample series id
  ##   executionId: JString (required)
  ##              : A tool results execution ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579246 = path.getOrDefault("projectId")
  valid_579246 = validateParameter(valid_579246, JString, required = true,
                                 default = nil)
  if valid_579246 != nil:
    section.add "projectId", valid_579246
  var valid_579247 = path.getOrDefault("historyId")
  valid_579247 = validateParameter(valid_579247, JString, required = true,
                                 default = nil)
  if valid_579247 != nil:
    section.add "historyId", valid_579247
  var valid_579248 = path.getOrDefault("stepId")
  valid_579248 = validateParameter(valid_579248, JString, required = true,
                                 default = nil)
  if valid_579248 != nil:
    section.add "stepId", valid_579248
  var valid_579249 = path.getOrDefault("sampleSeriesId")
  valid_579249 = validateParameter(valid_579249, JString, required = true,
                                 default = nil)
  if valid_579249 != nil:
    section.add "sampleSeriesId", valid_579249
  var valid_579250 = path.getOrDefault("executionId")
  valid_579250 = validateParameter(valid_579250, JString, required = true,
                                 default = nil)
  if valid_579250 != nil:
    section.add "executionId", valid_579250
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579251 = query.getOrDefault("key")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "key", valid_579251
  var valid_579252 = query.getOrDefault("prettyPrint")
  valid_579252 = validateParameter(valid_579252, JBool, required = false,
                                 default = newJBool(true))
  if valid_579252 != nil:
    section.add "prettyPrint", valid_579252
  var valid_579253 = query.getOrDefault("oauth_token")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "oauth_token", valid_579253
  var valid_579254 = query.getOrDefault("alt")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = newJString("json"))
  if valid_579254 != nil:
    section.add "alt", valid_579254
  var valid_579255 = query.getOrDefault("userIp")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "userIp", valid_579255
  var valid_579256 = query.getOrDefault("quotaUser")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "quotaUser", valid_579256
  var valid_579257 = query.getOrDefault("fields")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "fields", valid_579257
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

proc call*(call_579259: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_579243;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a batch of PerfSamples - a client can submit multiple batches of Perf Samples through repeated calls to this method in order to split up a large request payload - duplicates and existing timestamp entries will be ignored. - the batch operation may partially succeed - the set of elements successfully inserted is returned in the response (omits items which already existed in the database).
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing PerfSampleSeries does not exist
  ## 
  let valid = call_579259.validator(path, query, header, formData, body)
  let scheme = call_579259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579259.url(scheme.get, call_579259.host, call_579259.base,
                         call_579259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579259, url, valid)

proc call*(call_579260: Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_579243;
          projectId: string; historyId: string; stepId: string;
          sampleSeriesId: string; executionId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate
  ## Creates a batch of PerfSamples - a client can submit multiple batches of Perf Samples through repeated calls to this method in order to split up a large request payload - duplicates and existing timestamp entries will be ignored. - the batch operation may partially succeed - the set of elements successfully inserted is returned in the response (omits items which already existed in the database).
  ## 
  ## May return any of the following canonical error codes: - NOT_FOUND - The containing PerfSampleSeries does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The cloud project
  ##   historyId: string (required)
  ##            : A tool results history ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   stepId: string (required)
  ##         : A tool results step ID.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sampleSeriesId: string (required)
  ##                 : A sample series id
  ##   executionId: string (required)
  ##              : A tool results execution ID.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579261 = newJObject()
  var query_579262 = newJObject()
  var body_579263 = newJObject()
  add(query_579262, "key", newJString(key))
  add(query_579262, "prettyPrint", newJBool(prettyPrint))
  add(query_579262, "oauth_token", newJString(oauthToken))
  add(path_579261, "projectId", newJString(projectId))
  add(path_579261, "historyId", newJString(historyId))
  add(query_579262, "alt", newJString(alt))
  add(query_579262, "userIp", newJString(userIp))
  add(path_579261, "stepId", newJString(stepId))
  add(query_579262, "quotaUser", newJString(quotaUser))
  add(path_579261, "sampleSeriesId", newJString(sampleSeriesId))
  add(path_579261, "executionId", newJString(executionId))
  if body != nil:
    body_579263 = body
  add(query_579262, "fields", newJString(fields))
  result = call_579260.call(path_579261, query_579262, nil, nil, body_579263)

var toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate* = Call_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_579243(name: "toolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/perfSampleSeries/{sampleSeriesId}/samples:batchCreate", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_579244,
    base: "/toolresults/v1beta3/projects", url: url_ToolresultsProjectsHistoriesExecutionsStepsPerfSampleSeriesSamplesBatchCreate_579245,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsTestCasesList_579264 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsTestCasesList_579266(
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
               (kind: ConstantSegment, value: "/testCases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsTestCasesList_579265(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists Test Cases attached to a Step. Experimental test cases API. Still in active development.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing Step does not exist
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
  ##   stepId: JString (required)
  ##         : A Step id. Note: This step must include a TestExecutionStep.
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : A Execution id
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579267 = path.getOrDefault("projectId")
  valid_579267 = validateParameter(valid_579267, JString, required = true,
                                 default = nil)
  if valid_579267 != nil:
    section.add "projectId", valid_579267
  var valid_579268 = path.getOrDefault("historyId")
  valid_579268 = validateParameter(valid_579268, JString, required = true,
                                 default = nil)
  if valid_579268 != nil:
    section.add "historyId", valid_579268
  var valid_579269 = path.getOrDefault("stepId")
  valid_579269 = validateParameter(valid_579269, JString, required = true,
                                 default = nil)
  if valid_579269 != nil:
    section.add "stepId", valid_579269
  var valid_579270 = path.getOrDefault("executionId")
  valid_579270 = validateParameter(valid_579270, JString, required = true,
                                 default = nil)
  if valid_579270 != nil:
    section.add "executionId", valid_579270
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   pageSize: JInt
  ##           : The maximum number of TestCases to fetch.
  ## 
  ## Default value: 100. The server will use this default if the field is not set or has a value of 0.
  ## 
  ## Optional.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579271 = query.getOrDefault("key")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "key", valid_579271
  var valid_579272 = query.getOrDefault("prettyPrint")
  valid_579272 = validateParameter(valid_579272, JBool, required = false,
                                 default = newJBool(true))
  if valid_579272 != nil:
    section.add "prettyPrint", valid_579272
  var valid_579273 = query.getOrDefault("oauth_token")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "oauth_token", valid_579273
  var valid_579274 = query.getOrDefault("pageSize")
  valid_579274 = validateParameter(valid_579274, JInt, required = false, default = nil)
  if valid_579274 != nil:
    section.add "pageSize", valid_579274
  var valid_579275 = query.getOrDefault("alt")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = newJString("json"))
  if valid_579275 != nil:
    section.add "alt", valid_579275
  var valid_579276 = query.getOrDefault("userIp")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "userIp", valid_579276
  var valid_579277 = query.getOrDefault("quotaUser")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "quotaUser", valid_579277
  var valid_579278 = query.getOrDefault("pageToken")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "pageToken", valid_579278
  var valid_579279 = query.getOrDefault("fields")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "fields", valid_579279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579280: Call_ToolresultsProjectsHistoriesExecutionsStepsTestCasesList_579264;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Test Cases attached to a Step. Experimental test cases API. Still in active development.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing Step does not exist
  ## 
  let valid = call_579280.validator(path, query, header, formData, body)
  let scheme = call_579280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579280.url(scheme.get, call_579280.host, call_579280.base,
                         call_579280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579280, url, valid)

proc call*(call_579281: Call_ToolresultsProjectsHistoriesExecutionsStepsTestCasesList_579264;
          projectId: string; historyId: string; stepId: string; executionId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          pageSize: int = 0; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsTestCasesList
  ## Lists Test Cases attached to a Step. Experimental test cases API. Still in active development.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing Step does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   pageSize: int
  ##           : The maximum number of TestCases to fetch.
  ## 
  ## Default value: 100. The server will use this default if the field is not set or has a value of 0.
  ## 
  ## Optional.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   stepId: string (required)
  ##         : A Step id. Note: This step must include a TestExecutionStep.
  ## 
  ## Required.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   executionId: string (required)
  ##              : A Execution id
  ## 
  ## Required.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579282 = newJObject()
  var query_579283 = newJObject()
  add(query_579283, "key", newJString(key))
  add(query_579283, "prettyPrint", newJBool(prettyPrint))
  add(query_579283, "oauth_token", newJString(oauthToken))
  add(path_579282, "projectId", newJString(projectId))
  add(query_579283, "pageSize", newJInt(pageSize))
  add(path_579282, "historyId", newJString(historyId))
  add(query_579283, "alt", newJString(alt))
  add(query_579283, "userIp", newJString(userIp))
  add(path_579282, "stepId", newJString(stepId))
  add(query_579283, "quotaUser", newJString(quotaUser))
  add(query_579283, "pageToken", newJString(pageToken))
  add(path_579282, "executionId", newJString(executionId))
  add(query_579283, "fields", newJString(fields))
  result = call_579281.call(path_579282, query_579283, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsTestCasesList* = Call_ToolresultsProjectsHistoriesExecutionsStepsTestCasesList_579264(
    name: "toolresultsProjectsHistoriesExecutionsStepsTestCasesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/testCases", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsTestCasesList_579265,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsTestCasesList_579266,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsTestCasesGet_579284 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsTestCasesGet_579286(
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
  assert "testCaseId" in path, "`testCaseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/histories/"),
               (kind: VariableSegment, value: "historyId"),
               (kind: ConstantSegment, value: "/executions/"),
               (kind: VariableSegment, value: "executionId"),
               (kind: ConstantSegment, value: "/steps/"),
               (kind: VariableSegment, value: "stepId"),
               (kind: ConstantSegment, value: "/testCases/"),
               (kind: VariableSegment, value: "testCaseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ToolresultsProjectsHistoriesExecutionsStepsTestCasesGet_579285(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets details of a Test Case for a Step. Experimental test cases API. Still in active development.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing Test Case does not exist
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
  ##   stepId: JString (required)
  ##         : A Step id. Note: This step must include a TestExecutionStep.
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : A Execution id
  ## 
  ## Required.
  ##   testCaseId: JString (required)
  ##             : A Test Case id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579287 = path.getOrDefault("projectId")
  valid_579287 = validateParameter(valid_579287, JString, required = true,
                                 default = nil)
  if valid_579287 != nil:
    section.add "projectId", valid_579287
  var valid_579288 = path.getOrDefault("historyId")
  valid_579288 = validateParameter(valid_579288, JString, required = true,
                                 default = nil)
  if valid_579288 != nil:
    section.add "historyId", valid_579288
  var valid_579289 = path.getOrDefault("stepId")
  valid_579289 = validateParameter(valid_579289, JString, required = true,
                                 default = nil)
  if valid_579289 != nil:
    section.add "stepId", valid_579289
  var valid_579290 = path.getOrDefault("executionId")
  valid_579290 = validateParameter(valid_579290, JString, required = true,
                                 default = nil)
  if valid_579290 != nil:
    section.add "executionId", valid_579290
  var valid_579291 = path.getOrDefault("testCaseId")
  valid_579291 = validateParameter(valid_579291, JString, required = true,
                                 default = nil)
  if valid_579291 != nil:
    section.add "testCaseId", valid_579291
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579292 = query.getOrDefault("key")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "key", valid_579292
  var valid_579293 = query.getOrDefault("prettyPrint")
  valid_579293 = validateParameter(valid_579293, JBool, required = false,
                                 default = newJBool(true))
  if valid_579293 != nil:
    section.add "prettyPrint", valid_579293
  var valid_579294 = query.getOrDefault("oauth_token")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "oauth_token", valid_579294
  var valid_579295 = query.getOrDefault("alt")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = newJString("json"))
  if valid_579295 != nil:
    section.add "alt", valid_579295
  var valid_579296 = query.getOrDefault("userIp")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "userIp", valid_579296
  var valid_579297 = query.getOrDefault("quotaUser")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "quotaUser", valid_579297
  var valid_579298 = query.getOrDefault("fields")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "fields", valid_579298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579299: Call_ToolresultsProjectsHistoriesExecutionsStepsTestCasesGet_579284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets details of a Test Case for a Step. Experimental test cases API. Still in active development.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing Test Case does not exist
  ## 
  let valid = call_579299.validator(path, query, header, formData, body)
  let scheme = call_579299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579299.url(scheme.get, call_579299.host, call_579299.base,
                         call_579299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579299, url, valid)

proc call*(call_579300: Call_ToolresultsProjectsHistoriesExecutionsStepsTestCasesGet_579284;
          projectId: string; historyId: string; stepId: string; executionId: string;
          testCaseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsTestCasesGet
  ## Gets details of a Test Case for a Step. Experimental test cases API. Still in active development.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the containing Test Case does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   stepId: string (required)
  ##         : A Step id. Note: This step must include a TestExecutionStep.
  ## 
  ## Required.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   executionId: string (required)
  ##              : A Execution id
  ## 
  ## Required.
  ##   testCaseId: string (required)
  ##             : A Test Case id.
  ## 
  ## Required.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579301 = newJObject()
  var query_579302 = newJObject()
  add(query_579302, "key", newJString(key))
  add(query_579302, "prettyPrint", newJBool(prettyPrint))
  add(query_579302, "oauth_token", newJString(oauthToken))
  add(path_579301, "projectId", newJString(projectId))
  add(path_579301, "historyId", newJString(historyId))
  add(query_579302, "alt", newJString(alt))
  add(query_579302, "userIp", newJString(userIp))
  add(path_579301, "stepId", newJString(stepId))
  add(query_579302, "quotaUser", newJString(quotaUser))
  add(path_579301, "executionId", newJString(executionId))
  add(path_579301, "testCaseId", newJString(testCaseId))
  add(query_579302, "fields", newJString(fields))
  result = call_579300.call(path_579301, query_579302, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsTestCasesGet* = Call_ToolresultsProjectsHistoriesExecutionsStepsTestCasesGet_579284(
    name: "toolresultsProjectsHistoriesExecutionsStepsTestCasesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/testCases/{testCaseId}", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsTestCasesGet_579285,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsTestCasesGet_579286,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_579303 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_579305(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_579304(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists thumbnails of images attached to a step.
  ## 
  ## May return any of the following canonical error codes: - PERMISSION_DENIED - if the user is not authorized to read from the project, or from any of the images - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the step does not exist, or if any of the images do not exist
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
  ##   stepId: JString (required)
  ##         : A Step id.
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : An Execution id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579306 = path.getOrDefault("projectId")
  valid_579306 = validateParameter(valid_579306, JString, required = true,
                                 default = nil)
  if valid_579306 != nil:
    section.add "projectId", valid_579306
  var valid_579307 = path.getOrDefault("historyId")
  valid_579307 = validateParameter(valid_579307, JString, required = true,
                                 default = nil)
  if valid_579307 != nil:
    section.add "historyId", valid_579307
  var valid_579308 = path.getOrDefault("stepId")
  valid_579308 = validateParameter(valid_579308, JString, required = true,
                                 default = nil)
  if valid_579308 != nil:
    section.add "stepId", valid_579308
  var valid_579309 = path.getOrDefault("executionId")
  valid_579309 = validateParameter(valid_579309, JString, required = true,
                                 default = nil)
  if valid_579309 != nil:
    section.add "executionId", valid_579309
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   pageSize: JInt
  ##           : The maximum number of thumbnails to fetch.
  ## 
  ## Default value: 50. The server will use this default if the field is not set or has a value of 0.
  ## 
  ## Optional.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579310 = query.getOrDefault("key")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "key", valid_579310
  var valid_579311 = query.getOrDefault("prettyPrint")
  valid_579311 = validateParameter(valid_579311, JBool, required = false,
                                 default = newJBool(true))
  if valid_579311 != nil:
    section.add "prettyPrint", valid_579311
  var valid_579312 = query.getOrDefault("oauth_token")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "oauth_token", valid_579312
  var valid_579313 = query.getOrDefault("pageSize")
  valid_579313 = validateParameter(valid_579313, JInt, required = false, default = nil)
  if valid_579313 != nil:
    section.add "pageSize", valid_579313
  var valid_579314 = query.getOrDefault("alt")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = newJString("json"))
  if valid_579314 != nil:
    section.add "alt", valid_579314
  var valid_579315 = query.getOrDefault("userIp")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "userIp", valid_579315
  var valid_579316 = query.getOrDefault("quotaUser")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "quotaUser", valid_579316
  var valid_579317 = query.getOrDefault("pageToken")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "pageToken", valid_579317
  var valid_579318 = query.getOrDefault("fields")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "fields", valid_579318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579319: Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_579303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists thumbnails of images attached to a step.
  ## 
  ## May return any of the following canonical error codes: - PERMISSION_DENIED - if the user is not authorized to read from the project, or from any of the images - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the step does not exist, or if any of the images do not exist
  ## 
  let valid = call_579319.validator(path, query, header, formData, body)
  let scheme = call_579319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579319.url(scheme.get, call_579319.host, call_579319.base,
                         call_579319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579319, url, valid)

proc call*(call_579320: Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_579303;
          projectId: string; historyId: string; stepId: string; executionId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          pageSize: int = 0; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsThumbnailsList
  ## Lists thumbnails of images attached to a step.
  ## 
  ## May return any of the following canonical error codes: - PERMISSION_DENIED - if the user is not authorized to read from the project, or from any of the images - INVALID_ARGUMENT - if the request is malformed - NOT_FOUND - if the step does not exist, or if any of the images do not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
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
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   stepId: string (required)
  ##         : A Step id.
  ## 
  ## Required.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token to resume the query at the next item.
  ## 
  ## Optional.
  ##   executionId: string (required)
  ##              : An Execution id.
  ## 
  ## Required.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579321 = newJObject()
  var query_579322 = newJObject()
  add(query_579322, "key", newJString(key))
  add(query_579322, "prettyPrint", newJBool(prettyPrint))
  add(query_579322, "oauth_token", newJString(oauthToken))
  add(path_579321, "projectId", newJString(projectId))
  add(query_579322, "pageSize", newJInt(pageSize))
  add(path_579321, "historyId", newJString(historyId))
  add(query_579322, "alt", newJString(alt))
  add(query_579322, "userIp", newJString(userIp))
  add(path_579321, "stepId", newJString(stepId))
  add(query_579322, "quotaUser", newJString(quotaUser))
  add(query_579322, "pageToken", newJString(pageToken))
  add(path_579321, "executionId", newJString(executionId))
  add(query_579322, "fields", newJString(fields))
  result = call_579320.call(path_579321, query_579322, nil, nil, nil)

var toolresultsProjectsHistoriesExecutionsStepsThumbnailsList* = Call_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_579303(
    name: "toolresultsProjectsHistoriesExecutionsStepsThumbnailsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}/thumbnails", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_579304,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsThumbnailsList_579305,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_579323 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_579325(
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

proc validate_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_579324(
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
  ##   projectId: JString (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: JString (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   stepId: JString (required)
  ##         : A Step id. Note: This step must include a TestExecutionStep.
  ## 
  ## Required.
  ##   executionId: JString (required)
  ##              : A Execution id.
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579326 = path.getOrDefault("projectId")
  valid_579326 = validateParameter(valid_579326, JString, required = true,
                                 default = nil)
  if valid_579326 != nil:
    section.add "projectId", valid_579326
  var valid_579327 = path.getOrDefault("historyId")
  valid_579327 = validateParameter(valid_579327, JString, required = true,
                                 default = nil)
  if valid_579327 != nil:
    section.add "historyId", valid_579327
  var valid_579328 = path.getOrDefault("stepId")
  valid_579328 = validateParameter(valid_579328, JString, required = true,
                                 default = nil)
  if valid_579328 != nil:
    section.add "stepId", valid_579328
  var valid_579329 = path.getOrDefault("executionId")
  valid_579329 = validateParameter(valid_579329, JString, required = true,
                                 default = nil)
  if valid_579329 != nil:
    section.add "executionId", valid_579329
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579330 = query.getOrDefault("key")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "key", valid_579330
  var valid_579331 = query.getOrDefault("prettyPrint")
  valid_579331 = validateParameter(valid_579331, JBool, required = false,
                                 default = newJBool(true))
  if valid_579331 != nil:
    section.add "prettyPrint", valid_579331
  var valid_579332 = query.getOrDefault("oauth_token")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "oauth_token", valid_579332
  var valid_579333 = query.getOrDefault("alt")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = newJString("json"))
  if valid_579333 != nil:
    section.add "alt", valid_579333
  var valid_579334 = query.getOrDefault("userIp")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = nil)
  if valid_579334 != nil:
    section.add "userIp", valid_579334
  var valid_579335 = query.getOrDefault("quotaUser")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "quotaUser", valid_579335
  var valid_579336 = query.getOrDefault("fields")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "fields", valid_579336
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

proc call*(call_579338: Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_579323;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Publish xml files to an existing Step.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal, e.g try to upload a duplicate xml file or a file too large. - NOT_FOUND - if the containing Execution does not exist
  ## 
  let valid = call_579338.validator(path, query, header, formData, body)
  let scheme = call_579338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579338.url(scheme.get, call_579338.host, call_579338.base,
                         call_579338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579338, url, valid)

proc call*(call_579339: Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_579323;
          projectId: string; historyId: string; stepId: string; executionId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## toolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles
  ## Publish xml files to an existing Step.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write project - INVALID_ARGUMENT - if the request is malformed - FAILED_PRECONDITION - if the requested state transition is illegal, e.g try to upload a duplicate xml file or a file too large. - NOT_FOUND - if the containing Execution does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   historyId: string (required)
  ##            : A History id.
  ## 
  ## Required.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   stepId: string (required)
  ##         : A Step id. Note: This step must include a TestExecutionStep.
  ## 
  ## Required.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   executionId: string (required)
  ##              : A Execution id.
  ## 
  ## Required.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579340 = newJObject()
  var query_579341 = newJObject()
  var body_579342 = newJObject()
  add(query_579341, "key", newJString(key))
  add(query_579341, "prettyPrint", newJBool(prettyPrint))
  add(query_579341, "oauth_token", newJString(oauthToken))
  add(path_579340, "projectId", newJString(projectId))
  add(path_579340, "historyId", newJString(historyId))
  add(query_579341, "alt", newJString(alt))
  add(query_579341, "userIp", newJString(userIp))
  add(path_579340, "stepId", newJString(stepId))
  add(query_579341, "quotaUser", newJString(quotaUser))
  add(path_579340, "executionId", newJString(executionId))
  if body != nil:
    body_579342 = body
  add(query_579341, "fields", newJString(fields))
  result = call_579339.call(path_579340, query_579341, nil, nil, body_579342)

var toolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles* = Call_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_579323(
    name: "toolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{projectId}/histories/{historyId}/executions/{executionId}/steps/{stepId}:publishXunitXmlFiles", validator: validate_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_579324,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsHistoriesExecutionsStepsPublishXunitXmlFiles_579325,
    schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsGetSettings_579343 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsGetSettings_579345(protocol: Scheme; host: string;
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

proc validate_ToolresultsProjectsGetSettings_579344(path: JsonNode;
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
  var valid_579346 = path.getOrDefault("projectId")
  valid_579346 = validateParameter(valid_579346, JString, required = true,
                                 default = nil)
  if valid_579346 != nil:
    section.add "projectId", valid_579346
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579347 = query.getOrDefault("key")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "key", valid_579347
  var valid_579348 = query.getOrDefault("prettyPrint")
  valid_579348 = validateParameter(valid_579348, JBool, required = false,
                                 default = newJBool(true))
  if valid_579348 != nil:
    section.add "prettyPrint", valid_579348
  var valid_579349 = query.getOrDefault("oauth_token")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "oauth_token", valid_579349
  var valid_579350 = query.getOrDefault("alt")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = newJString("json"))
  if valid_579350 != nil:
    section.add "alt", valid_579350
  var valid_579351 = query.getOrDefault("userIp")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "userIp", valid_579351
  var valid_579352 = query.getOrDefault("quotaUser")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "quotaUser", valid_579352
  var valid_579353 = query.getOrDefault("fields")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "fields", valid_579353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579354: Call_ToolresultsProjectsGetSettings_579343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Tool Results settings for a project.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read from project
  ## 
  let valid = call_579354.validator(path, query, header, formData, body)
  let scheme = call_579354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579354.url(scheme.get, call_579354.host, call_579354.base,
                         call_579354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579354, url, valid)

proc call*(call_579355: Call_ToolresultsProjectsGetSettings_579343;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## toolresultsProjectsGetSettings
  ## Gets the Tool Results settings for a project.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read from project
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579356 = newJObject()
  var query_579357 = newJObject()
  add(query_579357, "key", newJString(key))
  add(query_579357, "prettyPrint", newJBool(prettyPrint))
  add(query_579357, "oauth_token", newJString(oauthToken))
  add(path_579356, "projectId", newJString(projectId))
  add(query_579357, "alt", newJString(alt))
  add(query_579357, "userIp", newJString(userIp))
  add(query_579357, "quotaUser", newJString(quotaUser))
  add(query_579357, "fields", newJString(fields))
  result = call_579355.call(path_579356, query_579357, nil, nil, nil)

var toolresultsProjectsGetSettings* = Call_ToolresultsProjectsGetSettings_579343(
    name: "toolresultsProjectsGetSettings", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectId}/settings",
    validator: validate_ToolresultsProjectsGetSettings_579344,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsGetSettings_579345, schemes: {Scheme.Https})
type
  Call_ToolresultsProjectsInitializeSettings_579358 = ref object of OpenApiRestCall_578348
proc url_ToolresultsProjectsInitializeSettings_579360(protocol: Scheme;
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

proc validate_ToolresultsProjectsInitializeSettings_579359(path: JsonNode;
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
  var valid_579361 = path.getOrDefault("projectId")
  valid_579361 = validateParameter(valid_579361, JString, required = true,
                                 default = nil)
  if valid_579361 != nil:
    section.add "projectId", valid_579361
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579362 = query.getOrDefault("key")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "key", valid_579362
  var valid_579363 = query.getOrDefault("prettyPrint")
  valid_579363 = validateParameter(valid_579363, JBool, required = false,
                                 default = newJBool(true))
  if valid_579363 != nil:
    section.add "prettyPrint", valid_579363
  var valid_579364 = query.getOrDefault("oauth_token")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "oauth_token", valid_579364
  var valid_579365 = query.getOrDefault("alt")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = newJString("json"))
  if valid_579365 != nil:
    section.add "alt", valid_579365
  var valid_579366 = query.getOrDefault("userIp")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "userIp", valid_579366
  var valid_579367 = query.getOrDefault("quotaUser")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "quotaUser", valid_579367
  var valid_579368 = query.getOrDefault("fields")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = nil)
  if valid_579368 != nil:
    section.add "fields", valid_579368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579369: Call_ToolresultsProjectsInitializeSettings_579358;
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
  let valid = call_579369.validator(path, query, header, formData, body)
  let scheme = call_579369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579369.url(scheme.get, call_579369.host, call_579369.base,
                         call_579369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579369, url, valid)

proc call*(call_579370: Call_ToolresultsProjectsInitializeSettings_579358;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A Project id.
  ## 
  ## Required.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579371 = newJObject()
  var query_579372 = newJObject()
  add(query_579372, "key", newJString(key))
  add(query_579372, "prettyPrint", newJBool(prettyPrint))
  add(query_579372, "oauth_token", newJString(oauthToken))
  add(path_579371, "projectId", newJString(projectId))
  add(query_579372, "alt", newJString(alt))
  add(query_579372, "userIp", newJString(userIp))
  add(query_579372, "quotaUser", newJString(quotaUser))
  add(query_579372, "fields", newJString(fields))
  result = call_579370.call(path_579371, query_579372, nil, nil, nil)

var toolresultsProjectsInitializeSettings* = Call_ToolresultsProjectsInitializeSettings_579358(
    name: "toolresultsProjectsInitializeSettings", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectId}:initializeSettings",
    validator: validate_ToolresultsProjectsInitializeSettings_579359,
    base: "/toolresults/v1beta3/projects",
    url: url_ToolresultsProjectsInitializeSettings_579360, schemes: {Scheme.Https})
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
