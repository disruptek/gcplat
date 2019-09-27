
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TasksTasksClear_593676 = ref object of OpenApiRestCall_593408
proc url_TasksTasksClear_593678(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TasksTasksClear_593677(path: JsonNode; query: JsonNode;
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
  var valid_593804 = path.getOrDefault("tasklist")
  valid_593804 = validateParameter(valid_593804, JString, required = true,
                                 default = nil)
  if valid_593804 != nil:
    section.add "tasklist", valid_593804
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
  var valid_593805 = query.getOrDefault("fields")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = nil)
  if valid_593805 != nil:
    section.add "fields", valid_593805
  var valid_593806 = query.getOrDefault("quotaUser")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "quotaUser", valid_593806
  var valid_593820 = query.getOrDefault("alt")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = newJString("json"))
  if valid_593820 != nil:
    section.add "alt", valid_593820
  var valid_593821 = query.getOrDefault("oauth_token")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "oauth_token", valid_593821
  var valid_593822 = query.getOrDefault("userIp")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "userIp", valid_593822
  var valid_593823 = query.getOrDefault("key")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "key", valid_593823
  var valid_593824 = query.getOrDefault("prettyPrint")
  valid_593824 = validateParameter(valid_593824, JBool, required = false,
                                 default = newJBool(true))
  if valid_593824 != nil:
    section.add "prettyPrint", valid_593824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593847: Call_TasksTasksClear_593676; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears all completed tasks from the specified task list. The affected tasks will be marked as 'hidden' and no longer be returned by default when retrieving all tasks for a task list.
  ## 
  let valid = call_593847.validator(path, query, header, formData, body)
  let scheme = call_593847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593847.url(scheme.get, call_593847.host, call_593847.base,
                         call_593847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593847, url, valid)

proc call*(call_593918: Call_TasksTasksClear_593676; tasklist: string;
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
  var path_593919 = newJObject()
  var query_593921 = newJObject()
  add(query_593921, "fields", newJString(fields))
  add(query_593921, "quotaUser", newJString(quotaUser))
  add(query_593921, "alt", newJString(alt))
  add(path_593919, "tasklist", newJString(tasklist))
  add(query_593921, "oauth_token", newJString(oauthToken))
  add(query_593921, "userIp", newJString(userIp))
  add(query_593921, "key", newJString(key))
  add(query_593921, "prettyPrint", newJBool(prettyPrint))
  result = call_593918.call(path_593919, query_593921, nil, nil, nil)

var tasksTasksClear* = Call_TasksTasksClear_593676(name: "tasksTasksClear",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lists/{tasklist}/clear", validator: validate_TasksTasksClear_593677,
    base: "/tasks/v1", url: url_TasksTasksClear_593678, schemes: {Scheme.Https})
type
  Call_TasksTasksInsert_593985 = ref object of OpenApiRestCall_593408
proc url_TasksTasksInsert_593987(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TasksTasksInsert_593986(path: JsonNode; query: JsonNode;
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
  var valid_593988 = path.getOrDefault("tasklist")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "tasklist", valid_593988
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
  var valid_593989 = query.getOrDefault("fields")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "fields", valid_593989
  var valid_593990 = query.getOrDefault("quotaUser")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "quotaUser", valid_593990
  var valid_593991 = query.getOrDefault("alt")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("json"))
  if valid_593991 != nil:
    section.add "alt", valid_593991
  var valid_593992 = query.getOrDefault("oauth_token")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "oauth_token", valid_593992
  var valid_593993 = query.getOrDefault("userIp")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "userIp", valid_593993
  var valid_593994 = query.getOrDefault("parent")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "parent", valid_593994
  var valid_593995 = query.getOrDefault("key")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "key", valid_593995
  var valid_593996 = query.getOrDefault("prettyPrint")
  valid_593996 = validateParameter(valid_593996, JBool, required = false,
                                 default = newJBool(true))
  if valid_593996 != nil:
    section.add "prettyPrint", valid_593996
  var valid_593997 = query.getOrDefault("previous")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "previous", valid_593997
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

proc call*(call_593999: Call_TasksTasksInsert_593985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new task on the specified task list.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_TasksTasksInsert_593985; tasklist: string;
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
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  var body_594003 = newJObject()
  add(query_594002, "fields", newJString(fields))
  add(query_594002, "quotaUser", newJString(quotaUser))
  add(query_594002, "alt", newJString(alt))
  add(path_594001, "tasklist", newJString(tasklist))
  add(query_594002, "oauth_token", newJString(oauthToken))
  add(query_594002, "userIp", newJString(userIp))
  add(query_594002, "parent", newJString(parent))
  add(query_594002, "key", newJString(key))
  if body != nil:
    body_594003 = body
  add(query_594002, "prettyPrint", newJBool(prettyPrint))
  add(query_594002, "previous", newJString(previous))
  result = call_594000.call(path_594001, query_594002, nil, nil, body_594003)

var tasksTasksInsert* = Call_TasksTasksInsert_593985(name: "tasksTasksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks", validator: validate_TasksTasksInsert_593986,
    base: "/tasks/v1", url: url_TasksTasksInsert_593987, schemes: {Scheme.Https})
type
  Call_TasksTasksList_593960 = ref object of OpenApiRestCall_593408
proc url_TasksTasksList_593962(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TasksTasksList_593961(path: JsonNode; query: JsonNode;
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
  var valid_593963 = path.getOrDefault("tasklist")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "tasklist", valid_593963
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
  var valid_593964 = query.getOrDefault("fields")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "fields", valid_593964
  var valid_593965 = query.getOrDefault("pageToken")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "pageToken", valid_593965
  var valid_593966 = query.getOrDefault("quotaUser")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "quotaUser", valid_593966
  var valid_593967 = query.getOrDefault("dueMax")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "dueMax", valid_593967
  var valid_593968 = query.getOrDefault("alt")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = newJString("json"))
  if valid_593968 != nil:
    section.add "alt", valid_593968
  var valid_593969 = query.getOrDefault("completedMax")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "completedMax", valid_593969
  var valid_593970 = query.getOrDefault("completedMin")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "completedMin", valid_593970
  var valid_593971 = query.getOrDefault("oauth_token")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "oauth_token", valid_593971
  var valid_593972 = query.getOrDefault("userIp")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "userIp", valid_593972
  var valid_593973 = query.getOrDefault("maxResults")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "maxResults", valid_593973
  var valid_593974 = query.getOrDefault("showHidden")
  valid_593974 = validateParameter(valid_593974, JBool, required = false, default = nil)
  if valid_593974 != nil:
    section.add "showHidden", valid_593974
  var valid_593975 = query.getOrDefault("showDeleted")
  valid_593975 = validateParameter(valid_593975, JBool, required = false, default = nil)
  if valid_593975 != nil:
    section.add "showDeleted", valid_593975
  var valid_593976 = query.getOrDefault("updatedMin")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "updatedMin", valid_593976
  var valid_593977 = query.getOrDefault("key")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "key", valid_593977
  var valid_593978 = query.getOrDefault("dueMin")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "dueMin", valid_593978
  var valid_593979 = query.getOrDefault("showCompleted")
  valid_593979 = validateParameter(valid_593979, JBool, required = false, default = nil)
  if valid_593979 != nil:
    section.add "showCompleted", valid_593979
  var valid_593980 = query.getOrDefault("prettyPrint")
  valid_593980 = validateParameter(valid_593980, JBool, required = false,
                                 default = newJBool(true))
  if valid_593980 != nil:
    section.add "prettyPrint", valid_593980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593981: Call_TasksTasksList_593960; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all tasks in the specified task list.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_TasksTasksList_593960; tasklist: string;
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
  var path_593983 = newJObject()
  var query_593984 = newJObject()
  add(query_593984, "fields", newJString(fields))
  add(query_593984, "pageToken", newJString(pageToken))
  add(query_593984, "quotaUser", newJString(quotaUser))
  add(query_593984, "dueMax", newJString(dueMax))
  add(query_593984, "alt", newJString(alt))
  add(path_593983, "tasklist", newJString(tasklist))
  add(query_593984, "completedMax", newJString(completedMax))
  add(query_593984, "completedMin", newJString(completedMin))
  add(query_593984, "oauth_token", newJString(oauthToken))
  add(query_593984, "userIp", newJString(userIp))
  add(query_593984, "maxResults", newJString(maxResults))
  add(query_593984, "showHidden", newJBool(showHidden))
  add(query_593984, "showDeleted", newJBool(showDeleted))
  add(query_593984, "updatedMin", newJString(updatedMin))
  add(query_593984, "key", newJString(key))
  add(query_593984, "dueMin", newJString(dueMin))
  add(query_593984, "showCompleted", newJBool(showCompleted))
  add(query_593984, "prettyPrint", newJBool(prettyPrint))
  result = call_593982.call(path_593983, query_593984, nil, nil, nil)

var tasksTasksList* = Call_TasksTasksList_593960(name: "tasksTasksList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks", validator: validate_TasksTasksList_593961,
    base: "/tasks/v1", url: url_TasksTasksList_593962, schemes: {Scheme.Https})
type
  Call_TasksTasksUpdate_594020 = ref object of OpenApiRestCall_593408
proc url_TasksTasksUpdate_594022(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TasksTasksUpdate_594021(path: JsonNode; query: JsonNode;
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
  var valid_594023 = path.getOrDefault("task")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "task", valid_594023
  var valid_594024 = path.getOrDefault("tasklist")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "tasklist", valid_594024
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
  var valid_594025 = query.getOrDefault("fields")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "fields", valid_594025
  var valid_594026 = query.getOrDefault("quotaUser")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "quotaUser", valid_594026
  var valid_594027 = query.getOrDefault("alt")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = newJString("json"))
  if valid_594027 != nil:
    section.add "alt", valid_594027
  var valid_594028 = query.getOrDefault("oauth_token")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "oauth_token", valid_594028
  var valid_594029 = query.getOrDefault("userIp")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "userIp", valid_594029
  var valid_594030 = query.getOrDefault("key")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "key", valid_594030
  var valid_594031 = query.getOrDefault("prettyPrint")
  valid_594031 = validateParameter(valid_594031, JBool, required = false,
                                 default = newJBool(true))
  if valid_594031 != nil:
    section.add "prettyPrint", valid_594031
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

proc call*(call_594033: Call_TasksTasksUpdate_594020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified task.
  ## 
  let valid = call_594033.validator(path, query, header, formData, body)
  let scheme = call_594033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594033.url(scheme.get, call_594033.host, call_594033.base,
                         call_594033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594033, url, valid)

proc call*(call_594034: Call_TasksTasksUpdate_594020; task: string; tasklist: string;
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
  var path_594035 = newJObject()
  var query_594036 = newJObject()
  var body_594037 = newJObject()
  add(query_594036, "fields", newJString(fields))
  add(query_594036, "quotaUser", newJString(quotaUser))
  add(query_594036, "alt", newJString(alt))
  add(path_594035, "task", newJString(task))
  add(path_594035, "tasklist", newJString(tasklist))
  add(query_594036, "oauth_token", newJString(oauthToken))
  add(query_594036, "userIp", newJString(userIp))
  add(query_594036, "key", newJString(key))
  if body != nil:
    body_594037 = body
  add(query_594036, "prettyPrint", newJBool(prettyPrint))
  result = call_594034.call(path_594035, query_594036, nil, nil, body_594037)

var tasksTasksUpdate* = Call_TasksTasksUpdate_594020(name: "tasksTasksUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}", validator: validate_TasksTasksUpdate_594021,
    base: "/tasks/v1", url: url_TasksTasksUpdate_594022, schemes: {Scheme.Https})
type
  Call_TasksTasksGet_594004 = ref object of OpenApiRestCall_593408
proc url_TasksTasksGet_594006(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TasksTasksGet_594005(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594007 = path.getOrDefault("task")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "task", valid_594007
  var valid_594008 = path.getOrDefault("tasklist")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "tasklist", valid_594008
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
  var valid_594009 = query.getOrDefault("fields")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "fields", valid_594009
  var valid_594010 = query.getOrDefault("quotaUser")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "quotaUser", valid_594010
  var valid_594011 = query.getOrDefault("alt")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = newJString("json"))
  if valid_594011 != nil:
    section.add "alt", valid_594011
  var valid_594012 = query.getOrDefault("oauth_token")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "oauth_token", valid_594012
  var valid_594013 = query.getOrDefault("userIp")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "userIp", valid_594013
  var valid_594014 = query.getOrDefault("key")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "key", valid_594014
  var valid_594015 = query.getOrDefault("prettyPrint")
  valid_594015 = validateParameter(valid_594015, JBool, required = false,
                                 default = newJBool(true))
  if valid_594015 != nil:
    section.add "prettyPrint", valid_594015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594016: Call_TasksTasksGet_594004; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified task.
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_TasksTasksGet_594004; task: string; tasklist: string;
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
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  add(query_594019, "fields", newJString(fields))
  add(query_594019, "quotaUser", newJString(quotaUser))
  add(query_594019, "alt", newJString(alt))
  add(path_594018, "task", newJString(task))
  add(path_594018, "tasklist", newJString(tasklist))
  add(query_594019, "oauth_token", newJString(oauthToken))
  add(query_594019, "userIp", newJString(userIp))
  add(query_594019, "key", newJString(key))
  add(query_594019, "prettyPrint", newJBool(prettyPrint))
  result = call_594017.call(path_594018, query_594019, nil, nil, nil)

var tasksTasksGet* = Call_TasksTasksGet_594004(name: "tasksTasksGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}", validator: validate_TasksTasksGet_594005,
    base: "/tasks/v1", url: url_TasksTasksGet_594006, schemes: {Scheme.Https})
type
  Call_TasksTasksPatch_594054 = ref object of OpenApiRestCall_593408
proc url_TasksTasksPatch_594056(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TasksTasksPatch_594055(path: JsonNode; query: JsonNode;
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
  var valid_594057 = path.getOrDefault("task")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "task", valid_594057
  var valid_594058 = path.getOrDefault("tasklist")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "tasklist", valid_594058
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
  var valid_594059 = query.getOrDefault("fields")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "fields", valid_594059
  var valid_594060 = query.getOrDefault("quotaUser")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "quotaUser", valid_594060
  var valid_594061 = query.getOrDefault("alt")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = newJString("json"))
  if valid_594061 != nil:
    section.add "alt", valid_594061
  var valid_594062 = query.getOrDefault("oauth_token")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "oauth_token", valid_594062
  var valid_594063 = query.getOrDefault("userIp")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "userIp", valid_594063
  var valid_594064 = query.getOrDefault("key")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "key", valid_594064
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

proc call*(call_594067: Call_TasksTasksPatch_594054; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified task. This method supports patch semantics.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_TasksTasksPatch_594054; task: string; tasklist: string;
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
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  var body_594071 = newJObject()
  add(query_594070, "fields", newJString(fields))
  add(query_594070, "quotaUser", newJString(quotaUser))
  add(query_594070, "alt", newJString(alt))
  add(path_594069, "task", newJString(task))
  add(path_594069, "tasklist", newJString(tasklist))
  add(query_594070, "oauth_token", newJString(oauthToken))
  add(query_594070, "userIp", newJString(userIp))
  add(query_594070, "key", newJString(key))
  if body != nil:
    body_594071 = body
  add(query_594070, "prettyPrint", newJBool(prettyPrint))
  result = call_594068.call(path_594069, query_594070, nil, nil, body_594071)

var tasksTasksPatch* = Call_TasksTasksPatch_594054(name: "tasksTasksPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}", validator: validate_TasksTasksPatch_594055,
    base: "/tasks/v1", url: url_TasksTasksPatch_594056, schemes: {Scheme.Https})
type
  Call_TasksTasksDelete_594038 = ref object of OpenApiRestCall_593408
proc url_TasksTasksDelete_594040(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TasksTasksDelete_594039(path: JsonNode; query: JsonNode;
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
  var valid_594041 = path.getOrDefault("task")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "task", valid_594041
  var valid_594042 = path.getOrDefault("tasklist")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "tasklist", valid_594042
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
  var valid_594043 = query.getOrDefault("fields")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "fields", valid_594043
  var valid_594044 = query.getOrDefault("quotaUser")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "quotaUser", valid_594044
  var valid_594045 = query.getOrDefault("alt")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = newJString("json"))
  if valid_594045 != nil:
    section.add "alt", valid_594045
  var valid_594046 = query.getOrDefault("oauth_token")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "oauth_token", valid_594046
  var valid_594047 = query.getOrDefault("userIp")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "userIp", valid_594047
  var valid_594048 = query.getOrDefault("key")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "key", valid_594048
  var valid_594049 = query.getOrDefault("prettyPrint")
  valid_594049 = validateParameter(valid_594049, JBool, required = false,
                                 default = newJBool(true))
  if valid_594049 != nil:
    section.add "prettyPrint", valid_594049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594050: Call_TasksTasksDelete_594038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified task from the task list.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_TasksTasksDelete_594038; task: string; tasklist: string;
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
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  add(query_594053, "fields", newJString(fields))
  add(query_594053, "quotaUser", newJString(quotaUser))
  add(query_594053, "alt", newJString(alt))
  add(path_594052, "task", newJString(task))
  add(path_594052, "tasklist", newJString(tasklist))
  add(query_594053, "oauth_token", newJString(oauthToken))
  add(query_594053, "userIp", newJString(userIp))
  add(query_594053, "key", newJString(key))
  add(query_594053, "prettyPrint", newJBool(prettyPrint))
  result = call_594051.call(path_594052, query_594053, nil, nil, nil)

var tasksTasksDelete* = Call_TasksTasksDelete_594038(name: "tasksTasksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}", validator: validate_TasksTasksDelete_594039,
    base: "/tasks/v1", url: url_TasksTasksDelete_594040, schemes: {Scheme.Https})
type
  Call_TasksTasksMove_594072 = ref object of OpenApiRestCall_593408
proc url_TasksTasksMove_594074(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TasksTasksMove_594073(path: JsonNode; query: JsonNode;
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
  var valid_594075 = path.getOrDefault("task")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "task", valid_594075
  var valid_594076 = path.getOrDefault("tasklist")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "tasklist", valid_594076
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
  var valid_594081 = query.getOrDefault("userIp")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "userIp", valid_594081
  var valid_594082 = query.getOrDefault("parent")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "parent", valid_594082
  var valid_594083 = query.getOrDefault("key")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "key", valid_594083
  var valid_594084 = query.getOrDefault("prettyPrint")
  valid_594084 = validateParameter(valid_594084, JBool, required = false,
                                 default = newJBool(true))
  if valid_594084 != nil:
    section.add "prettyPrint", valid_594084
  var valid_594085 = query.getOrDefault("previous")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "previous", valid_594085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594086: Call_TasksTasksMove_594072; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves the specified task to another position in the task list. This can include putting it as a child task under a new parent and/or move it to a different position among its sibling tasks.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_TasksTasksMove_594072; task: string; tasklist: string;
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
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  add(query_594089, "fields", newJString(fields))
  add(query_594089, "quotaUser", newJString(quotaUser))
  add(query_594089, "alt", newJString(alt))
  add(path_594088, "task", newJString(task))
  add(path_594088, "tasklist", newJString(tasklist))
  add(query_594089, "oauth_token", newJString(oauthToken))
  add(query_594089, "userIp", newJString(userIp))
  add(query_594089, "parent", newJString(parent))
  add(query_594089, "key", newJString(key))
  add(query_594089, "prettyPrint", newJBool(prettyPrint))
  add(query_594089, "previous", newJString(previous))
  result = call_594087.call(path_594088, query_594089, nil, nil, nil)

var tasksTasksMove* = Call_TasksTasksMove_594072(name: "tasksTasksMove",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}/move",
    validator: validate_TasksTasksMove_594073, base: "/tasks/v1",
    url: url_TasksTasksMove_594074, schemes: {Scheme.Https})
type
  Call_TasksTasklistsInsert_594105 = ref object of OpenApiRestCall_593408
proc url_TasksTasklistsInsert_594107(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TasksTasklistsInsert_594106(path: JsonNode; query: JsonNode;
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594116: Call_TasksTasklistsInsert_594105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new task list and adds it to the authenticated user's task lists.
  ## 
  let valid = call_594116.validator(path, query, header, formData, body)
  let scheme = call_594116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594116.url(scheme.get, call_594116.host, call_594116.base,
                         call_594116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594116, url, valid)

proc call*(call_594117: Call_TasksTasklistsInsert_594105; fields: string = "";
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
  var query_594118 = newJObject()
  var body_594119 = newJObject()
  add(query_594118, "fields", newJString(fields))
  add(query_594118, "quotaUser", newJString(quotaUser))
  add(query_594118, "alt", newJString(alt))
  add(query_594118, "oauth_token", newJString(oauthToken))
  add(query_594118, "userIp", newJString(userIp))
  add(query_594118, "key", newJString(key))
  if body != nil:
    body_594119 = body
  add(query_594118, "prettyPrint", newJBool(prettyPrint))
  result = call_594117.call(nil, query_594118, nil, nil, body_594119)

var tasksTasklistsInsert* = Call_TasksTasklistsInsert_594105(
    name: "tasksTasklistsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/@me/lists",
    validator: validate_TasksTasklistsInsert_594106, base: "/tasks/v1",
    url: url_TasksTasklistsInsert_594107, schemes: {Scheme.Https})
type
  Call_TasksTasklistsList_594090 = ref object of OpenApiRestCall_593408
proc url_TasksTasklistsList_594092(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TasksTasklistsList_594091(path: JsonNode; query: JsonNode;
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
  var valid_594093 = query.getOrDefault("fields")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "fields", valid_594093
  var valid_594094 = query.getOrDefault("pageToken")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "pageToken", valid_594094
  var valid_594095 = query.getOrDefault("quotaUser")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "quotaUser", valid_594095
  var valid_594096 = query.getOrDefault("alt")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = newJString("json"))
  if valid_594096 != nil:
    section.add "alt", valid_594096
  var valid_594097 = query.getOrDefault("oauth_token")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "oauth_token", valid_594097
  var valid_594098 = query.getOrDefault("userIp")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "userIp", valid_594098
  var valid_594099 = query.getOrDefault("maxResults")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "maxResults", valid_594099
  var valid_594100 = query.getOrDefault("key")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "key", valid_594100
  var valid_594101 = query.getOrDefault("prettyPrint")
  valid_594101 = validateParameter(valid_594101, JBool, required = false,
                                 default = newJBool(true))
  if valid_594101 != nil:
    section.add "prettyPrint", valid_594101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594102: Call_TasksTasklistsList_594090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the authenticated user's task lists.
  ## 
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_TasksTasklistsList_594090; fields: string = "";
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
  var query_594104 = newJObject()
  add(query_594104, "fields", newJString(fields))
  add(query_594104, "pageToken", newJString(pageToken))
  add(query_594104, "quotaUser", newJString(quotaUser))
  add(query_594104, "alt", newJString(alt))
  add(query_594104, "oauth_token", newJString(oauthToken))
  add(query_594104, "userIp", newJString(userIp))
  add(query_594104, "maxResults", newJString(maxResults))
  add(query_594104, "key", newJString(key))
  add(query_594104, "prettyPrint", newJBool(prettyPrint))
  result = call_594103.call(nil, query_594104, nil, nil, nil)

var tasksTasklistsList* = Call_TasksTasklistsList_594090(
    name: "tasksTasklistsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/@me/lists",
    validator: validate_TasksTasklistsList_594091, base: "/tasks/v1",
    url: url_TasksTasklistsList_594092, schemes: {Scheme.Https})
type
  Call_TasksTasklistsUpdate_594135 = ref object of OpenApiRestCall_593408
proc url_TasksTasklistsUpdate_594137(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/@me/lists/"),
               (kind: VariableSegment, value: "tasklist")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasklistsUpdate_594136(path: JsonNode; query: JsonNode;
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
  var valid_594138 = path.getOrDefault("tasklist")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "tasklist", valid_594138
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
  var valid_594139 = query.getOrDefault("fields")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "fields", valid_594139
  var valid_594140 = query.getOrDefault("quotaUser")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "quotaUser", valid_594140
  var valid_594141 = query.getOrDefault("alt")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = newJString("json"))
  if valid_594141 != nil:
    section.add "alt", valid_594141
  var valid_594142 = query.getOrDefault("oauth_token")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "oauth_token", valid_594142
  var valid_594143 = query.getOrDefault("userIp")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "userIp", valid_594143
  var valid_594144 = query.getOrDefault("key")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "key", valid_594144
  var valid_594145 = query.getOrDefault("prettyPrint")
  valid_594145 = validateParameter(valid_594145, JBool, required = false,
                                 default = newJBool(true))
  if valid_594145 != nil:
    section.add "prettyPrint", valid_594145
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

proc call*(call_594147: Call_TasksTasklistsUpdate_594135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the authenticated user's specified task list.
  ## 
  let valid = call_594147.validator(path, query, header, formData, body)
  let scheme = call_594147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594147.url(scheme.get, call_594147.host, call_594147.base,
                         call_594147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594147, url, valid)

proc call*(call_594148: Call_TasksTasklistsUpdate_594135; tasklist: string;
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
  var path_594149 = newJObject()
  var query_594150 = newJObject()
  var body_594151 = newJObject()
  add(query_594150, "fields", newJString(fields))
  add(query_594150, "quotaUser", newJString(quotaUser))
  add(query_594150, "alt", newJString(alt))
  add(path_594149, "tasklist", newJString(tasklist))
  add(query_594150, "oauth_token", newJString(oauthToken))
  add(query_594150, "userIp", newJString(userIp))
  add(query_594150, "key", newJString(key))
  if body != nil:
    body_594151 = body
  add(query_594150, "prettyPrint", newJBool(prettyPrint))
  result = call_594148.call(path_594149, query_594150, nil, nil, body_594151)

var tasksTasklistsUpdate* = Call_TasksTasklistsUpdate_594135(
    name: "tasksTasklistsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/@me/lists/{tasklist}",
    validator: validate_TasksTasklistsUpdate_594136, base: "/tasks/v1",
    url: url_TasksTasklistsUpdate_594137, schemes: {Scheme.Https})
type
  Call_TasksTasklistsGet_594120 = ref object of OpenApiRestCall_593408
proc url_TasksTasklistsGet_594122(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/@me/lists/"),
               (kind: VariableSegment, value: "tasklist")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasklistsGet_594121(path: JsonNode; query: JsonNode;
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
  var valid_594123 = path.getOrDefault("tasklist")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "tasklist", valid_594123
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
  var valid_594124 = query.getOrDefault("fields")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "fields", valid_594124
  var valid_594125 = query.getOrDefault("quotaUser")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "quotaUser", valid_594125
  var valid_594126 = query.getOrDefault("alt")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = newJString("json"))
  if valid_594126 != nil:
    section.add "alt", valid_594126
  var valid_594127 = query.getOrDefault("oauth_token")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "oauth_token", valid_594127
  var valid_594128 = query.getOrDefault("userIp")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "userIp", valid_594128
  var valid_594129 = query.getOrDefault("key")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "key", valid_594129
  var valid_594130 = query.getOrDefault("prettyPrint")
  valid_594130 = validateParameter(valid_594130, JBool, required = false,
                                 default = newJBool(true))
  if valid_594130 != nil:
    section.add "prettyPrint", valid_594130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594131: Call_TasksTasklistsGet_594120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the authenticated user's specified task list.
  ## 
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_TasksTasklistsGet_594120; tasklist: string;
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
  var path_594133 = newJObject()
  var query_594134 = newJObject()
  add(query_594134, "fields", newJString(fields))
  add(query_594134, "quotaUser", newJString(quotaUser))
  add(query_594134, "alt", newJString(alt))
  add(path_594133, "tasklist", newJString(tasklist))
  add(query_594134, "oauth_token", newJString(oauthToken))
  add(query_594134, "userIp", newJString(userIp))
  add(query_594134, "key", newJString(key))
  add(query_594134, "prettyPrint", newJBool(prettyPrint))
  result = call_594132.call(path_594133, query_594134, nil, nil, nil)

var tasksTasklistsGet* = Call_TasksTasklistsGet_594120(name: "tasksTasklistsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/users/@me/lists/{tasklist}", validator: validate_TasksTasklistsGet_594121,
    base: "/tasks/v1", url: url_TasksTasklistsGet_594122, schemes: {Scheme.Https})
type
  Call_TasksTasklistsPatch_594167 = ref object of OpenApiRestCall_593408
proc url_TasksTasklistsPatch_594169(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/@me/lists/"),
               (kind: VariableSegment, value: "tasklist")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasklistsPatch_594168(path: JsonNode; query: JsonNode;
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
  var valid_594170 = path.getOrDefault("tasklist")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "tasklist", valid_594170
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
  var valid_594171 = query.getOrDefault("fields")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "fields", valid_594171
  var valid_594172 = query.getOrDefault("quotaUser")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "quotaUser", valid_594172
  var valid_594173 = query.getOrDefault("alt")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = newJString("json"))
  if valid_594173 != nil:
    section.add "alt", valid_594173
  var valid_594174 = query.getOrDefault("oauth_token")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "oauth_token", valid_594174
  var valid_594175 = query.getOrDefault("userIp")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "userIp", valid_594175
  var valid_594176 = query.getOrDefault("key")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "key", valid_594176
  var valid_594177 = query.getOrDefault("prettyPrint")
  valid_594177 = validateParameter(valid_594177, JBool, required = false,
                                 default = newJBool(true))
  if valid_594177 != nil:
    section.add "prettyPrint", valid_594177
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

proc call*(call_594179: Call_TasksTasklistsPatch_594167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the authenticated user's specified task list. This method supports patch semantics.
  ## 
  let valid = call_594179.validator(path, query, header, formData, body)
  let scheme = call_594179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594179.url(scheme.get, call_594179.host, call_594179.base,
                         call_594179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594179, url, valid)

proc call*(call_594180: Call_TasksTasklistsPatch_594167; tasklist: string;
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
  var path_594181 = newJObject()
  var query_594182 = newJObject()
  var body_594183 = newJObject()
  add(query_594182, "fields", newJString(fields))
  add(query_594182, "quotaUser", newJString(quotaUser))
  add(query_594182, "alt", newJString(alt))
  add(path_594181, "tasklist", newJString(tasklist))
  add(query_594182, "oauth_token", newJString(oauthToken))
  add(query_594182, "userIp", newJString(userIp))
  add(query_594182, "key", newJString(key))
  if body != nil:
    body_594183 = body
  add(query_594182, "prettyPrint", newJBool(prettyPrint))
  result = call_594180.call(path_594181, query_594182, nil, nil, body_594183)

var tasksTasklistsPatch* = Call_TasksTasklistsPatch_594167(
    name: "tasksTasklistsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/@me/lists/{tasklist}",
    validator: validate_TasksTasklistsPatch_594168, base: "/tasks/v1",
    url: url_TasksTasklistsPatch_594169, schemes: {Scheme.Https})
type
  Call_TasksTasklistsDelete_594152 = ref object of OpenApiRestCall_593408
proc url_TasksTasklistsDelete_594154(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tasklist" in path, "`tasklist` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/@me/lists/"),
               (kind: VariableSegment, value: "tasklist")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksTasklistsDelete_594153(path: JsonNode; query: JsonNode;
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
  var valid_594155 = path.getOrDefault("tasklist")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "tasklist", valid_594155
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
  var valid_594156 = query.getOrDefault("fields")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "fields", valid_594156
  var valid_594157 = query.getOrDefault("quotaUser")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "quotaUser", valid_594157
  var valid_594158 = query.getOrDefault("alt")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = newJString("json"))
  if valid_594158 != nil:
    section.add "alt", valid_594158
  var valid_594159 = query.getOrDefault("oauth_token")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "oauth_token", valid_594159
  var valid_594160 = query.getOrDefault("userIp")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "userIp", valid_594160
  var valid_594161 = query.getOrDefault("key")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "key", valid_594161
  var valid_594162 = query.getOrDefault("prettyPrint")
  valid_594162 = validateParameter(valid_594162, JBool, required = false,
                                 default = newJBool(true))
  if valid_594162 != nil:
    section.add "prettyPrint", valid_594162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594163: Call_TasksTasklistsDelete_594152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the authenticated user's specified task list.
  ## 
  let valid = call_594163.validator(path, query, header, formData, body)
  let scheme = call_594163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594163.url(scheme.get, call_594163.host, call_594163.base,
                         call_594163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594163, url, valid)

proc call*(call_594164: Call_TasksTasklistsDelete_594152; tasklist: string;
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
  var path_594165 = newJObject()
  var query_594166 = newJObject()
  add(query_594166, "fields", newJString(fields))
  add(query_594166, "quotaUser", newJString(quotaUser))
  add(query_594166, "alt", newJString(alt))
  add(path_594165, "tasklist", newJString(tasklist))
  add(query_594166, "oauth_token", newJString(oauthToken))
  add(query_594166, "userIp", newJString(userIp))
  add(query_594166, "key", newJString(key))
  add(query_594166, "prettyPrint", newJBool(prettyPrint))
  result = call_594164.call(path_594165, query_594166, nil, nil, nil)

var tasksTasklistsDelete* = Call_TasksTasklistsDelete_594152(
    name: "tasksTasklistsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/@me/lists/{tasklist}",
    validator: validate_TasksTasklistsDelete_594153, base: "/tasks/v1",
    url: url_TasksTasklistsDelete_594154, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
