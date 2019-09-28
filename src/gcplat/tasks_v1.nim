
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Tasks
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages your tasks and task lists.
## 
## https://developers.google.com/google-apps/tasks/firstapp
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "tasks"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TasksTasksClear_579676 = ref object of OpenApiRestCall_579408
proc url_TasksTasksClear_579678(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/lists/"),
               (kind: VariableSegment, value: "tasklist"),
               (kind: ConstantSegment, value: "/clear")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasksClear_579677(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Clears all completed tasks from the specified task list. The affected tasks will be marked as 'hidden' and no longer be returned by default when retrieving all tasks for a task list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tasklist: JString (required)
  ##           : Task list identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tasklist` field"
  var valid_579804 = path.getOrDefault("tasklist")
  valid_579804 = validateParameter(valid_579804, JString, required = true,
                                 default = nil)
  if valid_579804 != nil:
    section.add "tasklist", valid_579804
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579805 = query.getOrDefault("fields")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "fields", valid_579805
  var valid_579806 = query.getOrDefault("quotaUser")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "quotaUser", valid_579806
  var valid_579820 = query.getOrDefault("alt")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = newJString("json"))
  if valid_579820 != nil:
    section.add "alt", valid_579820
  var valid_579821 = query.getOrDefault("oauth_token")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "oauth_token", valid_579821
  var valid_579822 = query.getOrDefault("userIp")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "userIp", valid_579822
  var valid_579823 = query.getOrDefault("key")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "key", valid_579823
  var valid_579824 = query.getOrDefault("prettyPrint")
  valid_579824 = validateParameter(valid_579824, JBool, required = false,
                                 default = newJBool(true))
  if valid_579824 != nil:
    section.add "prettyPrint", valid_579824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579847: Call_TasksTasksClear_579676; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears all completed tasks from the specified task list. The affected tasks will be marked as 'hidden' and no longer be returned by default when retrieving all tasks for a task list.
  ## 
  let valid = call_579847.validator(path, query, header, formData, body)
  let scheme = call_579847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579847.url(scheme.get, call_579847.host, call_579847.base,
                         call_579847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579847, url, valid)

proc call*(call_579918: Call_TasksTasksClear_579676; tasklist: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tasksTasksClear
  ## Clears all completed tasks from the specified task list. The affected tasks will be marked as 'hidden' and no longer be returned by default when retrieving all tasks for a task list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579919 = newJObject()
  var query_579921 = newJObject()
  add(query_579921, "fields", newJString(fields))
  add(query_579921, "quotaUser", newJString(quotaUser))
  add(query_579921, "alt", newJString(alt))
  add(path_579919, "tasklist", newJString(tasklist))
  add(query_579921, "oauth_token", newJString(oauthToken))
  add(query_579921, "userIp", newJString(userIp))
  add(query_579921, "key", newJString(key))
  add(query_579921, "prettyPrint", newJBool(prettyPrint))
  result = call_579918.call(path_579919, query_579921, nil, nil, nil)

var tasksTasksClear* = Call_TasksTasksClear_579676(name: "tasksTasksClear",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lists/{tasklist}/clear", validator: validate_TasksTasksClear_579677,
    base: "/tasks/v1", url: url_TasksTasksClear_579678, schemes: {Scheme.Https})
type
  Call_TasksTasksInsert_579985 = ref object of OpenApiRestCall_579408
proc url_TasksTasksInsert_579987(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/lists/"),
               (kind: VariableSegment, value: "tasklist"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasksInsert_579986(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a new task on the specified task list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tasklist: JString (required)
  ##           : Task list identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tasklist` field"
  var valid_579988 = path.getOrDefault("tasklist")
  valid_579988 = validateParameter(valid_579988, JString, required = true,
                                 default = nil)
  if valid_579988 != nil:
    section.add "tasklist", valid_579988
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   parent: JString
  ##         : Parent task identifier. If the task is created at the top level, this parameter is omitted. Optional.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   previous: JString
  ##           : Previous sibling task identifier. If the task is created at the first position among its siblings, this parameter is omitted. Optional.
  section = newJObject()
  var valid_579989 = query.getOrDefault("fields")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "fields", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("userIp")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "userIp", valid_579993
  var valid_579994 = query.getOrDefault("parent")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "parent", valid_579994
  var valid_579995 = query.getOrDefault("key")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "key", valid_579995
  var valid_579996 = query.getOrDefault("prettyPrint")
  valid_579996 = validateParameter(valid_579996, JBool, required = false,
                                 default = newJBool(true))
  if valid_579996 != nil:
    section.add "prettyPrint", valid_579996
  var valid_579997 = query.getOrDefault("previous")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "previous", valid_579997
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

proc call*(call_579999: Call_TasksTasksInsert_579985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new task on the specified task list.
  ## 
  let valid = call_579999.validator(path, query, header, formData, body)
  let scheme = call_579999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579999.url(scheme.get, call_579999.host, call_579999.base,
                         call_579999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579999, url, valid)

proc call*(call_580000: Call_TasksTasksInsert_579985; tasklist: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; parent: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          previous: string = ""): Recallable =
  ## tasksTasksInsert
  ## Creates a new task on the specified task list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   parent: string
  ##         : Parent task identifier. If the task is created at the top level, this parameter is omitted. Optional.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   previous: string
  ##           : Previous sibling task identifier. If the task is created at the first position among its siblings, this parameter is omitted. Optional.
  var path_580001 = newJObject()
  var query_580002 = newJObject()
  var body_580003 = newJObject()
  add(query_580002, "fields", newJString(fields))
  add(query_580002, "quotaUser", newJString(quotaUser))
  add(query_580002, "alt", newJString(alt))
  add(path_580001, "tasklist", newJString(tasklist))
  add(query_580002, "oauth_token", newJString(oauthToken))
  add(query_580002, "userIp", newJString(userIp))
  add(query_580002, "parent", newJString(parent))
  add(query_580002, "key", newJString(key))
  if body != nil:
    body_580003 = body
  add(query_580002, "prettyPrint", newJBool(prettyPrint))
  add(query_580002, "previous", newJString(previous))
  result = call_580000.call(path_580001, query_580002, nil, nil, body_580003)

var tasksTasksInsert* = Call_TasksTasksInsert_579985(name: "tasksTasksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks", validator: validate_TasksTasksInsert_579986,
    base: "/tasks/v1", url: url_TasksTasksInsert_579987, schemes: {Scheme.Https})
type
  Call_TasksTasksList_579960 = ref object of OpenApiRestCall_579408
proc url_TasksTasksList_579962(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/lists/"),
               (kind: VariableSegment, value: "tasklist"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasksList_579961(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns all tasks in the specified task list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tasklist: JString (required)
  ##           : Task list identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tasklist` field"
  var valid_579963 = path.getOrDefault("tasklist")
  valid_579963 = validateParameter(valid_579963, JString, required = true,
                                 default = nil)
  if valid_579963 != nil:
    section.add "tasklist", valid_579963
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token specifying the result page to return. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dueMax: JString
  ##         : Upper bound for a task's due date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by due date.
  ##   alt: JString
  ##      : Data format for the response.
  ##   completedMax: JString
  ##               : Upper bound for a task's completion date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by completion date.
  ##   completedMin: JString
  ##               : Lower bound for a task's completion date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by completion date.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JString
  ##             : Maximum number of task lists returned on one page. Optional. The default is 20 (max allowed: 100).
  ##   showHidden: JBool
  ##             : Flag indicating whether hidden tasks are returned in the result. Optional. The default is False.
  ##   showDeleted: JBool
  ##              : Flag indicating whether deleted tasks are returned in the result. Optional. The default is False.
  ##   updatedMin: JString
  ##             : Lower bound for a task's last modification time (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by last modification time.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   dueMin: JString
  ##         : Lower bound for a task's due date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by due date.
  ##   showCompleted: JBool
  ##                : Flag indicating whether completed tasks are returned in the result. Optional. The default is True.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579964 = query.getOrDefault("fields")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "fields", valid_579964
  var valid_579965 = query.getOrDefault("pageToken")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "pageToken", valid_579965
  var valid_579966 = query.getOrDefault("quotaUser")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "quotaUser", valid_579966
  var valid_579967 = query.getOrDefault("dueMax")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "dueMax", valid_579967
  var valid_579968 = query.getOrDefault("alt")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = newJString("json"))
  if valid_579968 != nil:
    section.add "alt", valid_579968
  var valid_579969 = query.getOrDefault("completedMax")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "completedMax", valid_579969
  var valid_579970 = query.getOrDefault("completedMin")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "completedMin", valid_579970
  var valid_579971 = query.getOrDefault("oauth_token")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "oauth_token", valid_579971
  var valid_579972 = query.getOrDefault("userIp")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "userIp", valid_579972
  var valid_579973 = query.getOrDefault("maxResults")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "maxResults", valid_579973
  var valid_579974 = query.getOrDefault("showHidden")
  valid_579974 = validateParameter(valid_579974, JBool, required = false, default = nil)
  if valid_579974 != nil:
    section.add "showHidden", valid_579974
  var valid_579975 = query.getOrDefault("showDeleted")
  valid_579975 = validateParameter(valid_579975, JBool, required = false, default = nil)
  if valid_579975 != nil:
    section.add "showDeleted", valid_579975
  var valid_579976 = query.getOrDefault("updatedMin")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "updatedMin", valid_579976
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("dueMin")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "dueMin", valid_579978
  var valid_579979 = query.getOrDefault("showCompleted")
  valid_579979 = validateParameter(valid_579979, JBool, required = false, default = nil)
  if valid_579979 != nil:
    section.add "showCompleted", valid_579979
  var valid_579980 = query.getOrDefault("prettyPrint")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(true))
  if valid_579980 != nil:
    section.add "prettyPrint", valid_579980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579981: Call_TasksTasksList_579960; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all tasks in the specified task list.
  ## 
  let valid = call_579981.validator(path, query, header, formData, body)
  let scheme = call_579981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579981.url(scheme.get, call_579981.host, call_579981.base,
                         call_579981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579981, url, valid)

proc call*(call_579982: Call_TasksTasksList_579960; tasklist: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          dueMax: string = ""; alt: string = "json"; completedMax: string = "";
          completedMin: string = ""; oauthToken: string = ""; userIp: string = "";
          maxResults: string = ""; showHidden: bool = false; showDeleted: bool = false;
          updatedMin: string = ""; key: string = ""; dueMin: string = "";
          showCompleted: bool = false; prettyPrint: bool = true): Recallable =
  ## tasksTasksList
  ## Returns all tasks in the specified task list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token specifying the result page to return. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   dueMax: string
  ##         : Upper bound for a task's due date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by due date.
  ##   alt: string
  ##      : Data format for the response.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  ##   completedMax: string
  ##               : Upper bound for a task's completion date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by completion date.
  ##   completedMin: string
  ##               : Lower bound for a task's completion date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by completion date.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: string
  ##             : Maximum number of task lists returned on one page. Optional. The default is 20 (max allowed: 100).
  ##   showHidden: bool
  ##             : Flag indicating whether hidden tasks are returned in the result. Optional. The default is False.
  ##   showDeleted: bool
  ##              : Flag indicating whether deleted tasks are returned in the result. Optional. The default is False.
  ##   updatedMin: string
  ##             : Lower bound for a task's last modification time (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by last modification time.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   dueMin: string
  ##         : Lower bound for a task's due date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by due date.
  ##   showCompleted: bool
  ##                : Flag indicating whether completed tasks are returned in the result. Optional. The default is True.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579983 = newJObject()
  var query_579984 = newJObject()
  add(query_579984, "fields", newJString(fields))
  add(query_579984, "pageToken", newJString(pageToken))
  add(query_579984, "quotaUser", newJString(quotaUser))
  add(query_579984, "dueMax", newJString(dueMax))
  add(query_579984, "alt", newJString(alt))
  add(path_579983, "tasklist", newJString(tasklist))
  add(query_579984, "completedMax", newJString(completedMax))
  add(query_579984, "completedMin", newJString(completedMin))
  add(query_579984, "oauth_token", newJString(oauthToken))
  add(query_579984, "userIp", newJString(userIp))
  add(query_579984, "maxResults", newJString(maxResults))
  add(query_579984, "showHidden", newJBool(showHidden))
  add(query_579984, "showDeleted", newJBool(showDeleted))
  add(query_579984, "updatedMin", newJString(updatedMin))
  add(query_579984, "key", newJString(key))
  add(query_579984, "dueMin", newJString(dueMin))
  add(query_579984, "showCompleted", newJBool(showCompleted))
  add(query_579984, "prettyPrint", newJBool(prettyPrint))
  result = call_579982.call(path_579983, query_579984, nil, nil, nil)

var tasksTasksList* = Call_TasksTasksList_579960(name: "tasksTasksList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks", validator: validate_TasksTasksList_579961,
    base: "/tasks/v1", url: url_TasksTasksList_579962, schemes: {Scheme.Https})
type
  Call_TasksTasksUpdate_580020 = ref object of OpenApiRestCall_579408
proc url_TasksTasksUpdate_580022(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  assert "task" in path, "`task` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/lists/"),
               (kind: VariableSegment, value: "tasklist"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "task")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasksUpdate_580021(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates the specified task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   task: JString (required)
  ##       : Task identifier.
  ##   tasklist: JString (required)
  ##           : Task list identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `task` field"
  var valid_580023 = path.getOrDefault("task")
  valid_580023 = validateParameter(valid_580023, JString, required = true,
                                 default = nil)
  if valid_580023 != nil:
    section.add "task", valid_580023
  var valid_580024 = path.getOrDefault("tasklist")
  valid_580024 = validateParameter(valid_580024, JString, required = true,
                                 default = nil)
  if valid_580024 != nil:
    section.add "tasklist", valid_580024
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580025 = query.getOrDefault("fields")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "fields", valid_580025
  var valid_580026 = query.getOrDefault("quotaUser")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "quotaUser", valid_580026
  var valid_580027 = query.getOrDefault("alt")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("json"))
  if valid_580027 != nil:
    section.add "alt", valid_580027
  var valid_580028 = query.getOrDefault("oauth_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "oauth_token", valid_580028
  var valid_580029 = query.getOrDefault("userIp")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "userIp", valid_580029
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

proc call*(call_580033: Call_TasksTasksUpdate_580020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified task.
  ## 
  let valid = call_580033.validator(path, query, header, formData, body)
  let scheme = call_580033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580033.url(scheme.get, call_580033.host, call_580033.base,
                         call_580033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580033, url, valid)

proc call*(call_580034: Call_TasksTasksUpdate_580020; task: string; tasklist: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tasksTasksUpdate
  ## Updates the specified task.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   task: string (required)
  ##       : Task identifier.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580035 = newJObject()
  var query_580036 = newJObject()
  var body_580037 = newJObject()
  add(query_580036, "fields", newJString(fields))
  add(query_580036, "quotaUser", newJString(quotaUser))
  add(query_580036, "alt", newJString(alt))
  add(path_580035, "task", newJString(task))
  add(path_580035, "tasklist", newJString(tasklist))
  add(query_580036, "oauth_token", newJString(oauthToken))
  add(query_580036, "userIp", newJString(userIp))
  add(query_580036, "key", newJString(key))
  if body != nil:
    body_580037 = body
  add(query_580036, "prettyPrint", newJBool(prettyPrint))
  result = call_580034.call(path_580035, query_580036, nil, nil, body_580037)

var tasksTasksUpdate* = Call_TasksTasksUpdate_580020(name: "tasksTasksUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}", validator: validate_TasksTasksUpdate_580021,
    base: "/tasks/v1", url: url_TasksTasksUpdate_580022, schemes: {Scheme.Https})
type
  Call_TasksTasksGet_580004 = ref object of OpenApiRestCall_579408
proc url_TasksTasksGet_580006(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  assert "task" in path, "`task` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/lists/"),
               (kind: VariableSegment, value: "tasklist"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "task")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasksGet_580005(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   task: JString (required)
  ##       : Task identifier.
  ##   tasklist: JString (required)
  ##           : Task list identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `task` field"
  var valid_580007 = path.getOrDefault("task")
  valid_580007 = validateParameter(valid_580007, JString, required = true,
                                 default = nil)
  if valid_580007 != nil:
    section.add "task", valid_580007
  var valid_580008 = path.getOrDefault("tasklist")
  valid_580008 = validateParameter(valid_580008, JString, required = true,
                                 default = nil)
  if valid_580008 != nil:
    section.add "tasklist", valid_580008
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580009 = query.getOrDefault("fields")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "fields", valid_580009
  var valid_580010 = query.getOrDefault("quotaUser")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "quotaUser", valid_580010
  var valid_580011 = query.getOrDefault("alt")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("json"))
  if valid_580011 != nil:
    section.add "alt", valid_580011
  var valid_580012 = query.getOrDefault("oauth_token")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "oauth_token", valid_580012
  var valid_580013 = query.getOrDefault("userIp")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "userIp", valid_580013
  var valid_580014 = query.getOrDefault("key")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "key", valid_580014
  var valid_580015 = query.getOrDefault("prettyPrint")
  valid_580015 = validateParameter(valid_580015, JBool, required = false,
                                 default = newJBool(true))
  if valid_580015 != nil:
    section.add "prettyPrint", valid_580015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580016: Call_TasksTasksGet_580004; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified task.
  ## 
  let valid = call_580016.validator(path, query, header, formData, body)
  let scheme = call_580016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580016.url(scheme.get, call_580016.host, call_580016.base,
                         call_580016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580016, url, valid)

proc call*(call_580017: Call_TasksTasksGet_580004; task: string; tasklist: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tasksTasksGet
  ## Returns the specified task.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   task: string (required)
  ##       : Task identifier.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580018 = newJObject()
  var query_580019 = newJObject()
  add(query_580019, "fields", newJString(fields))
  add(query_580019, "quotaUser", newJString(quotaUser))
  add(query_580019, "alt", newJString(alt))
  add(path_580018, "task", newJString(task))
  add(path_580018, "tasklist", newJString(tasklist))
  add(query_580019, "oauth_token", newJString(oauthToken))
  add(query_580019, "userIp", newJString(userIp))
  add(query_580019, "key", newJString(key))
  add(query_580019, "prettyPrint", newJBool(prettyPrint))
  result = call_580017.call(path_580018, query_580019, nil, nil, nil)

var tasksTasksGet* = Call_TasksTasksGet_580004(name: "tasksTasksGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}", validator: validate_TasksTasksGet_580005,
    base: "/tasks/v1", url: url_TasksTasksGet_580006, schemes: {Scheme.Https})
type
  Call_TasksTasksPatch_580054 = ref object of OpenApiRestCall_579408
proc url_TasksTasksPatch_580056(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  assert "task" in path, "`task` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/lists/"),
               (kind: VariableSegment, value: "tasklist"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "task")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasksPatch_580055(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates the specified task. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   task: JString (required)
  ##       : Task identifier.
  ##   tasklist: JString (required)
  ##           : Task list identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `task` field"
  var valid_580057 = path.getOrDefault("task")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "task", valid_580057
  var valid_580058 = path.getOrDefault("tasklist")
  valid_580058 = validateParameter(valid_580058, JString, required = true,
                                 default = nil)
  if valid_580058 != nil:
    section.add "tasklist", valid_580058
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580059 = query.getOrDefault("fields")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "fields", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("alt")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("json"))
  if valid_580061 != nil:
    section.add "alt", valid_580061
  var valid_580062 = query.getOrDefault("oauth_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "oauth_token", valid_580062
  var valid_580063 = query.getOrDefault("userIp")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "userIp", valid_580063
  var valid_580064 = query.getOrDefault("key")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "key", valid_580064
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

proc call*(call_580067: Call_TasksTasksPatch_580054; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified task. This method supports patch semantics.
  ## 
  let valid = call_580067.validator(path, query, header, formData, body)
  let scheme = call_580067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580067.url(scheme.get, call_580067.host, call_580067.base,
                         call_580067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580067, url, valid)

proc call*(call_580068: Call_TasksTasksPatch_580054; task: string; tasklist: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tasksTasksPatch
  ## Updates the specified task. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   task: string (required)
  ##       : Task identifier.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580069 = newJObject()
  var query_580070 = newJObject()
  var body_580071 = newJObject()
  add(query_580070, "fields", newJString(fields))
  add(query_580070, "quotaUser", newJString(quotaUser))
  add(query_580070, "alt", newJString(alt))
  add(path_580069, "task", newJString(task))
  add(path_580069, "tasklist", newJString(tasklist))
  add(query_580070, "oauth_token", newJString(oauthToken))
  add(query_580070, "userIp", newJString(userIp))
  add(query_580070, "key", newJString(key))
  if body != nil:
    body_580071 = body
  add(query_580070, "prettyPrint", newJBool(prettyPrint))
  result = call_580068.call(path_580069, query_580070, nil, nil, body_580071)

var tasksTasksPatch* = Call_TasksTasksPatch_580054(name: "tasksTasksPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}", validator: validate_TasksTasksPatch_580055,
    base: "/tasks/v1", url: url_TasksTasksPatch_580056, schemes: {Scheme.Https})
type
  Call_TasksTasksDelete_580038 = ref object of OpenApiRestCall_579408
proc url_TasksTasksDelete_580040(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  assert "task" in path, "`task` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/lists/"),
               (kind: VariableSegment, value: "tasklist"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "task")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasksDelete_580039(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the specified task from the task list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   task: JString (required)
  ##       : Task identifier.
  ##   tasklist: JString (required)
  ##           : Task list identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `task` field"
  var valid_580041 = path.getOrDefault("task")
  valid_580041 = validateParameter(valid_580041, JString, required = true,
                                 default = nil)
  if valid_580041 != nil:
    section.add "task", valid_580041
  var valid_580042 = path.getOrDefault("tasklist")
  valid_580042 = validateParameter(valid_580042, JString, required = true,
                                 default = nil)
  if valid_580042 != nil:
    section.add "tasklist", valid_580042
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580043 = query.getOrDefault("fields")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "fields", valid_580043
  var valid_580044 = query.getOrDefault("quotaUser")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "quotaUser", valid_580044
  var valid_580045 = query.getOrDefault("alt")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = newJString("json"))
  if valid_580045 != nil:
    section.add "alt", valid_580045
  var valid_580046 = query.getOrDefault("oauth_token")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "oauth_token", valid_580046
  var valid_580047 = query.getOrDefault("userIp")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "userIp", valid_580047
  var valid_580048 = query.getOrDefault("key")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "key", valid_580048
  var valid_580049 = query.getOrDefault("prettyPrint")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(true))
  if valid_580049 != nil:
    section.add "prettyPrint", valid_580049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580050: Call_TasksTasksDelete_580038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified task from the task list.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_TasksTasksDelete_580038; task: string; tasklist: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tasksTasksDelete
  ## Deletes the specified task from the task list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   task: string (required)
  ##       : Task identifier.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580052 = newJObject()
  var query_580053 = newJObject()
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "quotaUser", newJString(quotaUser))
  add(query_580053, "alt", newJString(alt))
  add(path_580052, "task", newJString(task))
  add(path_580052, "tasklist", newJString(tasklist))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(query_580053, "userIp", newJString(userIp))
  add(query_580053, "key", newJString(key))
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  result = call_580051.call(path_580052, query_580053, nil, nil, nil)

var tasksTasksDelete* = Call_TasksTasksDelete_580038(name: "tasksTasksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}", validator: validate_TasksTasksDelete_580039,
    base: "/tasks/v1", url: url_TasksTasksDelete_580040, schemes: {Scheme.Https})
type
  Call_TasksTasksMove_580072 = ref object of OpenApiRestCall_579408
proc url_TasksTasksMove_580074(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  assert "task" in path, "`task` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/lists/"),
               (kind: VariableSegment, value: "tasklist"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "task"),
               (kind: ConstantSegment, value: "/move")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasksMove_580073(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Moves the specified task to another position in the task list. This can include putting it as a child task under a new parent and/or move it to a different position among its sibling tasks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   task: JString (required)
  ##       : Task identifier.
  ##   tasklist: JString (required)
  ##           : Task list identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `task` field"
  var valid_580075 = path.getOrDefault("task")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "task", valid_580075
  var valid_580076 = path.getOrDefault("tasklist")
  valid_580076 = validateParameter(valid_580076, JString, required = true,
                                 default = nil)
  if valid_580076 != nil:
    section.add "tasklist", valid_580076
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   parent: JString
  ##         : New parent task identifier. If the task is moved to the top level, this parameter is omitted. Optional.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   previous: JString
  ##           : New previous sibling task identifier. If the task is moved to the first position among its siblings, this parameter is omitted. Optional.
  section = newJObject()
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
  var valid_580081 = query.getOrDefault("userIp")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "userIp", valid_580081
  var valid_580082 = query.getOrDefault("parent")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "parent", valid_580082
  var valid_580083 = query.getOrDefault("key")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "key", valid_580083
  var valid_580084 = query.getOrDefault("prettyPrint")
  valid_580084 = validateParameter(valid_580084, JBool, required = false,
                                 default = newJBool(true))
  if valid_580084 != nil:
    section.add "prettyPrint", valid_580084
  var valid_580085 = query.getOrDefault("previous")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "previous", valid_580085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580086: Call_TasksTasksMove_580072; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves the specified task to another position in the task list. This can include putting it as a child task under a new parent and/or move it to a different position among its sibling tasks.
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_TasksTasksMove_580072; task: string; tasklist: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; parent: string = "";
          key: string = ""; prettyPrint: bool = true; previous: string = ""): Recallable =
  ## tasksTasksMove
  ## Moves the specified task to another position in the task list. This can include putting it as a child task under a new parent and/or move it to a different position among its sibling tasks.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   task: string (required)
  ##       : Task identifier.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   parent: string
  ##         : New parent task identifier. If the task is moved to the top level, this parameter is omitted. Optional.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   previous: string
  ##           : New previous sibling task identifier. If the task is moved to the first position among its siblings, this parameter is omitted. Optional.
  var path_580088 = newJObject()
  var query_580089 = newJObject()
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "quotaUser", newJString(quotaUser))
  add(query_580089, "alt", newJString(alt))
  add(path_580088, "task", newJString(task))
  add(path_580088, "tasklist", newJString(tasklist))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "userIp", newJString(userIp))
  add(query_580089, "parent", newJString(parent))
  add(query_580089, "key", newJString(key))
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  add(query_580089, "previous", newJString(previous))
  result = call_580087.call(path_580088, query_580089, nil, nil, nil)

var tasksTasksMove* = Call_TasksTasksMove_580072(name: "tasksTasksMove",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}/move",
    validator: validate_TasksTasksMove_580073, base: "/tasks/v1",
    url: url_TasksTasksMove_580074, schemes: {Scheme.Https})
type
  Call_TasksTasklistsInsert_580105 = ref object of OpenApiRestCall_579408
proc url_TasksTasklistsInsert_580107(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_TasksTasklistsInsert_580106(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new task list and adds it to the authenticated user's task lists.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580116: Call_TasksTasklistsInsert_580105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new task list and adds it to the authenticated user's task lists.
  ## 
  let valid = call_580116.validator(path, query, header, formData, body)
  let scheme = call_580116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580116.url(scheme.get, call_580116.host, call_580116.base,
                         call_580116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580116, url, valid)

proc call*(call_580117: Call_TasksTasklistsInsert_580105; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## tasksTasklistsInsert
  ## Creates a new task list and adds it to the authenticated user's task lists.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580118 = newJObject()
  var body_580119 = newJObject()
  add(query_580118, "fields", newJString(fields))
  add(query_580118, "quotaUser", newJString(quotaUser))
  add(query_580118, "alt", newJString(alt))
  add(query_580118, "oauth_token", newJString(oauthToken))
  add(query_580118, "userIp", newJString(userIp))
  add(query_580118, "key", newJString(key))
  if body != nil:
    body_580119 = body
  add(query_580118, "prettyPrint", newJBool(prettyPrint))
  result = call_580117.call(nil, query_580118, nil, nil, body_580119)

var tasksTasklistsInsert* = Call_TasksTasklistsInsert_580105(
    name: "tasksTasklistsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/@me/lists",
    validator: validate_TasksTasklistsInsert_580106, base: "/tasks/v1",
    url: url_TasksTasklistsInsert_580107, schemes: {Scheme.Https})
type
  Call_TasksTasklistsList_580090 = ref object of OpenApiRestCall_579408
proc url_TasksTasklistsList_580092(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_TasksTasklistsList_580091(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns all the authenticated user's task lists.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token specifying the result page to return. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JString
  ##             : Maximum number of task lists returned on one page. Optional. The default is 20 (max allowed: 100).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580093 = query.getOrDefault("fields")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "fields", valid_580093
  var valid_580094 = query.getOrDefault("pageToken")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "pageToken", valid_580094
  var valid_580095 = query.getOrDefault("quotaUser")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "quotaUser", valid_580095
  var valid_580096 = query.getOrDefault("alt")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = newJString("json"))
  if valid_580096 != nil:
    section.add "alt", valid_580096
  var valid_580097 = query.getOrDefault("oauth_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "oauth_token", valid_580097
  var valid_580098 = query.getOrDefault("userIp")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "userIp", valid_580098
  var valid_580099 = query.getOrDefault("maxResults")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "maxResults", valid_580099
  var valid_580100 = query.getOrDefault("key")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "key", valid_580100
  var valid_580101 = query.getOrDefault("prettyPrint")
  valid_580101 = validateParameter(valid_580101, JBool, required = false,
                                 default = newJBool(true))
  if valid_580101 != nil:
    section.add "prettyPrint", valid_580101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580102: Call_TasksTasklistsList_580090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the authenticated user's task lists.
  ## 
  let valid = call_580102.validator(path, query, header, formData, body)
  let scheme = call_580102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580102.url(scheme.get, call_580102.host, call_580102.base,
                         call_580102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580102, url, valid)

proc call*(call_580103: Call_TasksTasklistsList_580090; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## tasksTasklistsList
  ## Returns all the authenticated user's task lists.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token specifying the result page to return. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: string
  ##             : Maximum number of task lists returned on one page. Optional. The default is 20 (max allowed: 100).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580104 = newJObject()
  add(query_580104, "fields", newJString(fields))
  add(query_580104, "pageToken", newJString(pageToken))
  add(query_580104, "quotaUser", newJString(quotaUser))
  add(query_580104, "alt", newJString(alt))
  add(query_580104, "oauth_token", newJString(oauthToken))
  add(query_580104, "userIp", newJString(userIp))
  add(query_580104, "maxResults", newJString(maxResults))
  add(query_580104, "key", newJString(key))
  add(query_580104, "prettyPrint", newJBool(prettyPrint))
  result = call_580103.call(nil, query_580104, nil, nil, nil)

var tasksTasklistsList* = Call_TasksTasklistsList_580090(
    name: "tasksTasklistsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/@me/lists",
    validator: validate_TasksTasklistsList_580091, base: "/tasks/v1",
    url: url_TasksTasklistsList_580092, schemes: {Scheme.Https})
type
  Call_TasksTasklistsUpdate_580135 = ref object of OpenApiRestCall_579408
proc url_TasksTasklistsUpdate_580137(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/@me/lists/"),
               (kind: VariableSegment, value: "tasklist")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasklistsUpdate_580136(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the authenticated user's specified task list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tasklist: JString (required)
  ##           : Task list identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tasklist` field"
  var valid_580138 = path.getOrDefault("tasklist")
  valid_580138 = validateParameter(valid_580138, JString, required = true,
                                 default = nil)
  if valid_580138 != nil:
    section.add "tasklist", valid_580138
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580139 = query.getOrDefault("fields")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "fields", valid_580139
  var valid_580140 = query.getOrDefault("quotaUser")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "quotaUser", valid_580140
  var valid_580141 = query.getOrDefault("alt")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = newJString("json"))
  if valid_580141 != nil:
    section.add "alt", valid_580141
  var valid_580142 = query.getOrDefault("oauth_token")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "oauth_token", valid_580142
  var valid_580143 = query.getOrDefault("userIp")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "userIp", valid_580143
  var valid_580144 = query.getOrDefault("key")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "key", valid_580144
  var valid_580145 = query.getOrDefault("prettyPrint")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(true))
  if valid_580145 != nil:
    section.add "prettyPrint", valid_580145
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

proc call*(call_580147: Call_TasksTasklistsUpdate_580135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the authenticated user's specified task list.
  ## 
  let valid = call_580147.validator(path, query, header, formData, body)
  let scheme = call_580147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580147.url(scheme.get, call_580147.host, call_580147.base,
                         call_580147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580147, url, valid)

proc call*(call_580148: Call_TasksTasklistsUpdate_580135; tasklist: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tasksTasklistsUpdate
  ## Updates the authenticated user's specified task list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580149 = newJObject()
  var query_580150 = newJObject()
  var body_580151 = newJObject()
  add(query_580150, "fields", newJString(fields))
  add(query_580150, "quotaUser", newJString(quotaUser))
  add(query_580150, "alt", newJString(alt))
  add(path_580149, "tasklist", newJString(tasklist))
  add(query_580150, "oauth_token", newJString(oauthToken))
  add(query_580150, "userIp", newJString(userIp))
  add(query_580150, "key", newJString(key))
  if body != nil:
    body_580151 = body
  add(query_580150, "prettyPrint", newJBool(prettyPrint))
  result = call_580148.call(path_580149, query_580150, nil, nil, body_580151)

var tasksTasklistsUpdate* = Call_TasksTasklistsUpdate_580135(
    name: "tasksTasklistsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/@me/lists/{tasklist}",
    validator: validate_TasksTasklistsUpdate_580136, base: "/tasks/v1",
    url: url_TasksTasklistsUpdate_580137, schemes: {Scheme.Https})
type
  Call_TasksTasklistsGet_580120 = ref object of OpenApiRestCall_579408
proc url_TasksTasklistsGet_580122(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/@me/lists/"),
               (kind: VariableSegment, value: "tasklist")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasklistsGet_580121(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns the authenticated user's specified task list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tasklist: JString (required)
  ##           : Task list identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tasklist` field"
  var valid_580123 = path.getOrDefault("tasklist")
  valid_580123 = validateParameter(valid_580123, JString, required = true,
                                 default = nil)
  if valid_580123 != nil:
    section.add "tasklist", valid_580123
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580124 = query.getOrDefault("fields")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "fields", valid_580124
  var valid_580125 = query.getOrDefault("quotaUser")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "quotaUser", valid_580125
  var valid_580126 = query.getOrDefault("alt")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = newJString("json"))
  if valid_580126 != nil:
    section.add "alt", valid_580126
  var valid_580127 = query.getOrDefault("oauth_token")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "oauth_token", valid_580127
  var valid_580128 = query.getOrDefault("userIp")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "userIp", valid_580128
  var valid_580129 = query.getOrDefault("key")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "key", valid_580129
  var valid_580130 = query.getOrDefault("prettyPrint")
  valid_580130 = validateParameter(valid_580130, JBool, required = false,
                                 default = newJBool(true))
  if valid_580130 != nil:
    section.add "prettyPrint", valid_580130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580131: Call_TasksTasklistsGet_580120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the authenticated user's specified task list.
  ## 
  let valid = call_580131.validator(path, query, header, formData, body)
  let scheme = call_580131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580131.url(scheme.get, call_580131.host, call_580131.base,
                         call_580131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580131, url, valid)

proc call*(call_580132: Call_TasksTasklistsGet_580120; tasklist: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tasksTasklistsGet
  ## Returns the authenticated user's specified task list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580133 = newJObject()
  var query_580134 = newJObject()
  add(query_580134, "fields", newJString(fields))
  add(query_580134, "quotaUser", newJString(quotaUser))
  add(query_580134, "alt", newJString(alt))
  add(path_580133, "tasklist", newJString(tasklist))
  add(query_580134, "oauth_token", newJString(oauthToken))
  add(query_580134, "userIp", newJString(userIp))
  add(query_580134, "key", newJString(key))
  add(query_580134, "prettyPrint", newJBool(prettyPrint))
  result = call_580132.call(path_580133, query_580134, nil, nil, nil)

var tasksTasklistsGet* = Call_TasksTasklistsGet_580120(name: "tasksTasklistsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/users/@me/lists/{tasklist}", validator: validate_TasksTasklistsGet_580121,
    base: "/tasks/v1", url: url_TasksTasklistsGet_580122, schemes: {Scheme.Https})
type
  Call_TasksTasklistsPatch_580167 = ref object of OpenApiRestCall_579408
proc url_TasksTasklistsPatch_580169(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/@me/lists/"),
               (kind: VariableSegment, value: "tasklist")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasklistsPatch_580168(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates the authenticated user's specified task list. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tasklist: JString (required)
  ##           : Task list identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tasklist` field"
  var valid_580170 = path.getOrDefault("tasklist")
  valid_580170 = validateParameter(valid_580170, JString, required = true,
                                 default = nil)
  if valid_580170 != nil:
    section.add "tasklist", valid_580170
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580171 = query.getOrDefault("fields")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "fields", valid_580171
  var valid_580172 = query.getOrDefault("quotaUser")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "quotaUser", valid_580172
  var valid_580173 = query.getOrDefault("alt")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = newJString("json"))
  if valid_580173 != nil:
    section.add "alt", valid_580173
  var valid_580174 = query.getOrDefault("oauth_token")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "oauth_token", valid_580174
  var valid_580175 = query.getOrDefault("userIp")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "userIp", valid_580175
  var valid_580176 = query.getOrDefault("key")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "key", valid_580176
  var valid_580177 = query.getOrDefault("prettyPrint")
  valid_580177 = validateParameter(valid_580177, JBool, required = false,
                                 default = newJBool(true))
  if valid_580177 != nil:
    section.add "prettyPrint", valid_580177
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

proc call*(call_580179: Call_TasksTasklistsPatch_580167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the authenticated user's specified task list. This method supports patch semantics.
  ## 
  let valid = call_580179.validator(path, query, header, formData, body)
  let scheme = call_580179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580179.url(scheme.get, call_580179.host, call_580179.base,
                         call_580179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580179, url, valid)

proc call*(call_580180: Call_TasksTasklistsPatch_580167; tasklist: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tasksTasklistsPatch
  ## Updates the authenticated user's specified task list. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580181 = newJObject()
  var query_580182 = newJObject()
  var body_580183 = newJObject()
  add(query_580182, "fields", newJString(fields))
  add(query_580182, "quotaUser", newJString(quotaUser))
  add(query_580182, "alt", newJString(alt))
  add(path_580181, "tasklist", newJString(tasklist))
  add(query_580182, "oauth_token", newJString(oauthToken))
  add(query_580182, "userIp", newJString(userIp))
  add(query_580182, "key", newJString(key))
  if body != nil:
    body_580183 = body
  add(query_580182, "prettyPrint", newJBool(prettyPrint))
  result = call_580180.call(path_580181, query_580182, nil, nil, body_580183)

var tasksTasklistsPatch* = Call_TasksTasklistsPatch_580167(
    name: "tasksTasklistsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/@me/lists/{tasklist}",
    validator: validate_TasksTasklistsPatch_580168, base: "/tasks/v1",
    url: url_TasksTasklistsPatch_580169, schemes: {Scheme.Https})
type
  Call_TasksTasklistsDelete_580152 = ref object of OpenApiRestCall_579408
proc url_TasksTasklistsDelete_580154(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/@me/lists/"),
               (kind: VariableSegment, value: "tasklist")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasklistsDelete_580153(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the authenticated user's specified task list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tasklist: JString (required)
  ##           : Task list identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tasklist` field"
  var valid_580155 = path.getOrDefault("tasklist")
  valid_580155 = validateParameter(valid_580155, JString, required = true,
                                 default = nil)
  if valid_580155 != nil:
    section.add "tasklist", valid_580155
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580156 = query.getOrDefault("fields")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "fields", valid_580156
  var valid_580157 = query.getOrDefault("quotaUser")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "quotaUser", valid_580157
  var valid_580158 = query.getOrDefault("alt")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = newJString("json"))
  if valid_580158 != nil:
    section.add "alt", valid_580158
  var valid_580159 = query.getOrDefault("oauth_token")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "oauth_token", valid_580159
  var valid_580160 = query.getOrDefault("userIp")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "userIp", valid_580160
  var valid_580161 = query.getOrDefault("key")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "key", valid_580161
  var valid_580162 = query.getOrDefault("prettyPrint")
  valid_580162 = validateParameter(valid_580162, JBool, required = false,
                                 default = newJBool(true))
  if valid_580162 != nil:
    section.add "prettyPrint", valid_580162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580163: Call_TasksTasklistsDelete_580152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the authenticated user's specified task list.
  ## 
  let valid = call_580163.validator(path, query, header, formData, body)
  let scheme = call_580163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580163.url(scheme.get, call_580163.host, call_580163.base,
                         call_580163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580163, url, valid)

proc call*(call_580164: Call_TasksTasklistsDelete_580152; tasklist: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## tasksTasklistsDelete
  ## Deletes the authenticated user's specified task list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580165 = newJObject()
  var query_580166 = newJObject()
  add(query_580166, "fields", newJString(fields))
  add(query_580166, "quotaUser", newJString(quotaUser))
  add(query_580166, "alt", newJString(alt))
  add(path_580165, "tasklist", newJString(tasklist))
  add(query_580166, "oauth_token", newJString(oauthToken))
  add(query_580166, "userIp", newJString(userIp))
  add(query_580166, "key", newJString(key))
  add(query_580166, "prettyPrint", newJBool(prettyPrint))
  result = call_580164.call(path_580165, query_580166, nil, nil, nil)

var tasksTasklistsDelete* = Call_TasksTasklistsDelete_580152(
    name: "tasksTasklistsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/@me/lists/{tasklist}",
    validator: validate_TasksTasklistsDelete_580153, base: "/tasks/v1",
    url: url_TasksTasklistsDelete_580154, schemes: {Scheme.Https})
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
