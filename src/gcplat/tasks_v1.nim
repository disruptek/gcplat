
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "tasks"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TasksTasksClear_578609 = ref object of OpenApiRestCall_578339
proc url_TasksTasksClear_578611(protocol: Scheme; host: string; base: string;
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

proc validate_TasksTasksClear_578610(path: JsonNode; query: JsonNode;
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
  var valid_578737 = path.getOrDefault("tasklist")
  valid_578737 = validateParameter(valid_578737, JString, required = true,
                                 default = nil)
  if valid_578737 != nil:
    section.add "tasklist", valid_578737
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
  var valid_578738 = query.getOrDefault("key")
  valid_578738 = validateParameter(valid_578738, JString, required = false,
                                 default = nil)
  if valid_578738 != nil:
    section.add "key", valid_578738
  var valid_578752 = query.getOrDefault("prettyPrint")
  valid_578752 = validateParameter(valid_578752, JBool, required = false,
                                 default = newJBool(true))
  if valid_578752 != nil:
    section.add "prettyPrint", valid_578752
  var valid_578753 = query.getOrDefault("oauth_token")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "oauth_token", valid_578753
  var valid_578754 = query.getOrDefault("alt")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = newJString("json"))
  if valid_578754 != nil:
    section.add "alt", valid_578754
  var valid_578755 = query.getOrDefault("userIp")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "userIp", valid_578755
  var valid_578756 = query.getOrDefault("quotaUser")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "quotaUser", valid_578756
  var valid_578757 = query.getOrDefault("fields")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "fields", valid_578757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578780: Call_TasksTasksClear_578609; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears all completed tasks from the specified task list. The affected tasks will be marked as 'hidden' and no longer be returned by default when retrieving all tasks for a task list.
  ## 
  let valid = call_578780.validator(path, query, header, formData, body)
  let scheme = call_578780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578780.url(scheme.get, call_578780.host, call_578780.base,
                         call_578780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578780, url, valid)

proc call*(call_578851: Call_TasksTasksClear_578609; tasklist: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## tasksTasksClear
  ## Clears all completed tasks from the specified task list. The affected tasks will be marked as 'hidden' and no longer be returned by default when retrieving all tasks for a task list.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  var path_578852 = newJObject()
  var query_578854 = newJObject()
  add(query_578854, "key", newJString(key))
  add(query_578854, "prettyPrint", newJBool(prettyPrint))
  add(query_578854, "oauth_token", newJString(oauthToken))
  add(query_578854, "alt", newJString(alt))
  add(query_578854, "userIp", newJString(userIp))
  add(query_578854, "quotaUser", newJString(quotaUser))
  add(query_578854, "fields", newJString(fields))
  add(path_578852, "tasklist", newJString(tasklist))
  result = call_578851.call(path_578852, query_578854, nil, nil, nil)

var tasksTasksClear* = Call_TasksTasksClear_578609(name: "tasksTasksClear",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lists/{tasklist}/clear", validator: validate_TasksTasksClear_578610,
    base: "/tasks/v1", url: url_TasksTasksClear_578611, schemes: {Scheme.Https})
type
  Call_TasksTasksInsert_578918 = ref object of OpenApiRestCall_578339
proc url_TasksTasksInsert_578920(protocol: Scheme; host: string; base: string;
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

proc validate_TasksTasksInsert_578919(path: JsonNode; query: JsonNode;
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
  var valid_578921 = path.getOrDefault("tasklist")
  valid_578921 = validateParameter(valid_578921, JString, required = true,
                                 default = nil)
  if valid_578921 != nil:
    section.add "tasklist", valid_578921
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
  ##   parent: JString
  ##         : Parent task identifier. If the task is created at the top level, this parameter is omitted. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   previous: JString
  ##           : Previous sibling task identifier. If the task is created at the first position among its siblings, this parameter is omitted. Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578922 = query.getOrDefault("key")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "key", valid_578922
  var valid_578923 = query.getOrDefault("prettyPrint")
  valid_578923 = validateParameter(valid_578923, JBool, required = false,
                                 default = newJBool(true))
  if valid_578923 != nil:
    section.add "prettyPrint", valid_578923
  var valid_578924 = query.getOrDefault("oauth_token")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "oauth_token", valid_578924
  var valid_578925 = query.getOrDefault("alt")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = newJString("json"))
  if valid_578925 != nil:
    section.add "alt", valid_578925
  var valid_578926 = query.getOrDefault("userIp")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "userIp", valid_578926
  var valid_578927 = query.getOrDefault("parent")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "parent", valid_578927
  var valid_578928 = query.getOrDefault("quotaUser")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "quotaUser", valid_578928
  var valid_578929 = query.getOrDefault("previous")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "previous", valid_578929
  var valid_578930 = query.getOrDefault("fields")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "fields", valid_578930
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

proc call*(call_578932: Call_TasksTasksInsert_578918; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new task on the specified task list.
  ## 
  let valid = call_578932.validator(path, query, header, formData, body)
  let scheme = call_578932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578932.url(scheme.get, call_578932.host, call_578932.base,
                         call_578932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578932, url, valid)

proc call*(call_578933: Call_TasksTasksInsert_578918; tasklist: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; parent: string = "";
          quotaUser: string = ""; body: JsonNode = nil; previous: string = "";
          fields: string = ""): Recallable =
  ## tasksTasksInsert
  ## Creates a new task on the specified task list.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   parent: string
  ##         : Parent task identifier. If the task is created at the top level, this parameter is omitted. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   previous: string
  ##           : Previous sibling task identifier. If the task is created at the first position among its siblings, this parameter is omitted. Optional.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  var path_578934 = newJObject()
  var query_578935 = newJObject()
  var body_578936 = newJObject()
  add(query_578935, "key", newJString(key))
  add(query_578935, "prettyPrint", newJBool(prettyPrint))
  add(query_578935, "oauth_token", newJString(oauthToken))
  add(query_578935, "alt", newJString(alt))
  add(query_578935, "userIp", newJString(userIp))
  add(query_578935, "parent", newJString(parent))
  add(query_578935, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578936 = body
  add(query_578935, "previous", newJString(previous))
  add(query_578935, "fields", newJString(fields))
  add(path_578934, "tasklist", newJString(tasklist))
  result = call_578933.call(path_578934, query_578935, nil, nil, body_578936)

var tasksTasksInsert* = Call_TasksTasksInsert_578918(name: "tasksTasksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks", validator: validate_TasksTasksInsert_578919,
    base: "/tasks/v1", url: url_TasksTasksInsert_578920, schemes: {Scheme.Https})
type
  Call_TasksTasksList_578893 = ref object of OpenApiRestCall_578339
proc url_TasksTasksList_578895(protocol: Scheme; host: string; base: string;
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

proc validate_TasksTasksList_578894(path: JsonNode; query: JsonNode;
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
  var valid_578896 = path.getOrDefault("tasklist")
  valid_578896 = validateParameter(valid_578896, JString, required = true,
                                 default = nil)
  if valid_578896 != nil:
    section.add "tasklist", valid_578896
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   completedMin: JString
  ##               : Lower bound for a task's completion date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by completion date.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   completedMax: JString
  ##               : Upper bound for a task's completion date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by completion date.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   showCompleted: JBool
  ##                : Flag indicating whether completed tasks are returned in the result. Optional. The default is True.
  ##   pageToken: JString
  ##            : Token specifying the result page to return. Optional.
  ##   showHidden: JBool
  ##             : Flag indicating whether hidden tasks are returned in the result. Optional. The default is False.
  ##   dueMax: JString
  ##         : Upper bound for a task's due date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by due date.
  ##   updatedMin: JString
  ##             : Lower bound for a task's last modification time (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by last modification time.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   dueMin: JString
  ##         : Lower bound for a task's due date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by due date.
  ##   showDeleted: JBool
  ##              : Flag indicating whether deleted tasks are returned in the result. Optional. The default is False.
  ##   maxResults: JString
  ##             : Maximum number of task lists returned on one page. Optional. The default is 20 (max allowed: 100).
  section = newJObject()
  var valid_578897 = query.getOrDefault("key")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "key", valid_578897
  var valid_578898 = query.getOrDefault("completedMin")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "completedMin", valid_578898
  var valid_578899 = query.getOrDefault("prettyPrint")
  valid_578899 = validateParameter(valid_578899, JBool, required = false,
                                 default = newJBool(true))
  if valid_578899 != nil:
    section.add "prettyPrint", valid_578899
  var valid_578900 = query.getOrDefault("oauth_token")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "oauth_token", valid_578900
  var valid_578901 = query.getOrDefault("completedMax")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "completedMax", valid_578901
  var valid_578902 = query.getOrDefault("alt")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = newJString("json"))
  if valid_578902 != nil:
    section.add "alt", valid_578902
  var valid_578903 = query.getOrDefault("userIp")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "userIp", valid_578903
  var valid_578904 = query.getOrDefault("quotaUser")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "quotaUser", valid_578904
  var valid_578905 = query.getOrDefault("showCompleted")
  valid_578905 = validateParameter(valid_578905, JBool, required = false, default = nil)
  if valid_578905 != nil:
    section.add "showCompleted", valid_578905
  var valid_578906 = query.getOrDefault("pageToken")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "pageToken", valid_578906
  var valid_578907 = query.getOrDefault("showHidden")
  valid_578907 = validateParameter(valid_578907, JBool, required = false, default = nil)
  if valid_578907 != nil:
    section.add "showHidden", valid_578907
  var valid_578908 = query.getOrDefault("dueMax")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "dueMax", valid_578908
  var valid_578909 = query.getOrDefault("updatedMin")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "updatedMin", valid_578909
  var valid_578910 = query.getOrDefault("fields")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "fields", valid_578910
  var valid_578911 = query.getOrDefault("dueMin")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "dueMin", valid_578911
  var valid_578912 = query.getOrDefault("showDeleted")
  valid_578912 = validateParameter(valid_578912, JBool, required = false, default = nil)
  if valid_578912 != nil:
    section.add "showDeleted", valid_578912
  var valid_578913 = query.getOrDefault("maxResults")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "maxResults", valid_578913
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578914: Call_TasksTasksList_578893; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all tasks in the specified task list.
  ## 
  let valid = call_578914.validator(path, query, header, formData, body)
  let scheme = call_578914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578914.url(scheme.get, call_578914.host, call_578914.base,
                         call_578914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578914, url, valid)

proc call*(call_578915: Call_TasksTasksList_578893; tasklist: string;
          key: string = ""; completedMin: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; completedMax: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; showCompleted: bool = false;
          pageToken: string = ""; showHidden: bool = false; dueMax: string = "";
          updatedMin: string = ""; fields: string = ""; dueMin: string = "";
          showDeleted: bool = false; maxResults: string = ""): Recallable =
  ## tasksTasksList
  ## Returns all tasks in the specified task list.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   completedMin: string
  ##               : Lower bound for a task's completion date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by completion date.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   completedMax: string
  ##               : Upper bound for a task's completion date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by completion date.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   showCompleted: bool
  ##                : Flag indicating whether completed tasks are returned in the result. Optional. The default is True.
  ##   pageToken: string
  ##            : Token specifying the result page to return. Optional.
  ##   showHidden: bool
  ##             : Flag indicating whether hidden tasks are returned in the result. Optional. The default is False.
  ##   dueMax: string
  ##         : Upper bound for a task's due date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by due date.
  ##   updatedMin: string
  ##             : Lower bound for a task's last modification time (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by last modification time.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   dueMin: string
  ##         : Lower bound for a task's due date (as a RFC 3339 timestamp) to filter by. Optional. The default is not to filter by due date.
  ##   showDeleted: bool
  ##              : Flag indicating whether deleted tasks are returned in the result. Optional. The default is False.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  ##   maxResults: string
  ##             : Maximum number of task lists returned on one page. Optional. The default is 20 (max allowed: 100).
  var path_578916 = newJObject()
  var query_578917 = newJObject()
  add(query_578917, "key", newJString(key))
  add(query_578917, "completedMin", newJString(completedMin))
  add(query_578917, "prettyPrint", newJBool(prettyPrint))
  add(query_578917, "oauth_token", newJString(oauthToken))
  add(query_578917, "completedMax", newJString(completedMax))
  add(query_578917, "alt", newJString(alt))
  add(query_578917, "userIp", newJString(userIp))
  add(query_578917, "quotaUser", newJString(quotaUser))
  add(query_578917, "showCompleted", newJBool(showCompleted))
  add(query_578917, "pageToken", newJString(pageToken))
  add(query_578917, "showHidden", newJBool(showHidden))
  add(query_578917, "dueMax", newJString(dueMax))
  add(query_578917, "updatedMin", newJString(updatedMin))
  add(query_578917, "fields", newJString(fields))
  add(query_578917, "dueMin", newJString(dueMin))
  add(query_578917, "showDeleted", newJBool(showDeleted))
  add(path_578916, "tasklist", newJString(tasklist))
  add(query_578917, "maxResults", newJString(maxResults))
  result = call_578915.call(path_578916, query_578917, nil, nil, nil)

var tasksTasksList* = Call_TasksTasksList_578893(name: "tasksTasksList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks", validator: validate_TasksTasksList_578894,
    base: "/tasks/v1", url: url_TasksTasksList_578895, schemes: {Scheme.Https})
type
  Call_TasksTasksUpdate_578953 = ref object of OpenApiRestCall_578339
proc url_TasksTasksUpdate_578955(protocol: Scheme; host: string; base: string;
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

proc validate_TasksTasksUpdate_578954(path: JsonNode; query: JsonNode;
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
  var valid_578956 = path.getOrDefault("task")
  valid_578956 = validateParameter(valid_578956, JString, required = true,
                                 default = nil)
  if valid_578956 != nil:
    section.add "task", valid_578956
  var valid_578957 = path.getOrDefault("tasklist")
  valid_578957 = validateParameter(valid_578957, JString, required = true,
                                 default = nil)
  if valid_578957 != nil:
    section.add "tasklist", valid_578957
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
  var valid_578958 = query.getOrDefault("key")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "key", valid_578958
  var valid_578959 = query.getOrDefault("prettyPrint")
  valid_578959 = validateParameter(valid_578959, JBool, required = false,
                                 default = newJBool(true))
  if valid_578959 != nil:
    section.add "prettyPrint", valid_578959
  var valid_578960 = query.getOrDefault("oauth_token")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "oauth_token", valid_578960
  var valid_578961 = query.getOrDefault("alt")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = newJString("json"))
  if valid_578961 != nil:
    section.add "alt", valid_578961
  var valid_578962 = query.getOrDefault("userIp")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "userIp", valid_578962
  var valid_578963 = query.getOrDefault("quotaUser")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "quotaUser", valid_578963
  var valid_578964 = query.getOrDefault("fields")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "fields", valid_578964
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

proc call*(call_578966: Call_TasksTasksUpdate_578953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified task.
  ## 
  let valid = call_578966.validator(path, query, header, formData, body)
  let scheme = call_578966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578966.url(scheme.get, call_578966.host, call_578966.base,
                         call_578966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578966, url, valid)

proc call*(call_578967: Call_TasksTasksUpdate_578953; task: string; tasklist: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## tasksTasksUpdate
  ## Updates the specified task.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   task: string (required)
  ##       : Task identifier.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  var path_578968 = newJObject()
  var query_578969 = newJObject()
  var body_578970 = newJObject()
  add(query_578969, "key", newJString(key))
  add(query_578969, "prettyPrint", newJBool(prettyPrint))
  add(query_578969, "oauth_token", newJString(oauthToken))
  add(query_578969, "alt", newJString(alt))
  add(query_578969, "userIp", newJString(userIp))
  add(query_578969, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578970 = body
  add(query_578969, "fields", newJString(fields))
  add(path_578968, "task", newJString(task))
  add(path_578968, "tasklist", newJString(tasklist))
  result = call_578967.call(path_578968, query_578969, nil, nil, body_578970)

var tasksTasksUpdate* = Call_TasksTasksUpdate_578953(name: "tasksTasksUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}", validator: validate_TasksTasksUpdate_578954,
    base: "/tasks/v1", url: url_TasksTasksUpdate_578955, schemes: {Scheme.Https})
type
  Call_TasksTasksGet_578937 = ref object of OpenApiRestCall_578339
proc url_TasksTasksGet_578939(protocol: Scheme; host: string; base: string;
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

proc validate_TasksTasksGet_578938(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_578940 = path.getOrDefault("task")
  valid_578940 = validateParameter(valid_578940, JString, required = true,
                                 default = nil)
  if valid_578940 != nil:
    section.add "task", valid_578940
  var valid_578941 = path.getOrDefault("tasklist")
  valid_578941 = validateParameter(valid_578941, JString, required = true,
                                 default = nil)
  if valid_578941 != nil:
    section.add "tasklist", valid_578941
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
  var valid_578942 = query.getOrDefault("key")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "key", valid_578942
  var valid_578943 = query.getOrDefault("prettyPrint")
  valid_578943 = validateParameter(valid_578943, JBool, required = false,
                                 default = newJBool(true))
  if valid_578943 != nil:
    section.add "prettyPrint", valid_578943
  var valid_578944 = query.getOrDefault("oauth_token")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "oauth_token", valid_578944
  var valid_578945 = query.getOrDefault("alt")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = newJString("json"))
  if valid_578945 != nil:
    section.add "alt", valid_578945
  var valid_578946 = query.getOrDefault("userIp")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "userIp", valid_578946
  var valid_578947 = query.getOrDefault("quotaUser")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "quotaUser", valid_578947
  var valid_578948 = query.getOrDefault("fields")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "fields", valid_578948
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578949: Call_TasksTasksGet_578937; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified task.
  ## 
  let valid = call_578949.validator(path, query, header, formData, body)
  let scheme = call_578949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578949.url(scheme.get, call_578949.host, call_578949.base,
                         call_578949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578949, url, valid)

proc call*(call_578950: Call_TasksTasksGet_578937; task: string; tasklist: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## tasksTasksGet
  ## Returns the specified task.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   task: string (required)
  ##       : Task identifier.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  var path_578951 = newJObject()
  var query_578952 = newJObject()
  add(query_578952, "key", newJString(key))
  add(query_578952, "prettyPrint", newJBool(prettyPrint))
  add(query_578952, "oauth_token", newJString(oauthToken))
  add(query_578952, "alt", newJString(alt))
  add(query_578952, "userIp", newJString(userIp))
  add(query_578952, "quotaUser", newJString(quotaUser))
  add(query_578952, "fields", newJString(fields))
  add(path_578951, "task", newJString(task))
  add(path_578951, "tasklist", newJString(tasklist))
  result = call_578950.call(path_578951, query_578952, nil, nil, nil)

var tasksTasksGet* = Call_TasksTasksGet_578937(name: "tasksTasksGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}", validator: validate_TasksTasksGet_578938,
    base: "/tasks/v1", url: url_TasksTasksGet_578939, schemes: {Scheme.Https})
type
  Call_TasksTasksPatch_578987 = ref object of OpenApiRestCall_578339
proc url_TasksTasksPatch_578989(protocol: Scheme; host: string; base: string;
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

proc validate_TasksTasksPatch_578988(path: JsonNode; query: JsonNode;
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
  var valid_578990 = path.getOrDefault("task")
  valid_578990 = validateParameter(valid_578990, JString, required = true,
                                 default = nil)
  if valid_578990 != nil:
    section.add "task", valid_578990
  var valid_578991 = path.getOrDefault("tasklist")
  valid_578991 = validateParameter(valid_578991, JString, required = true,
                                 default = nil)
  if valid_578991 != nil:
    section.add "tasklist", valid_578991
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
  var valid_578992 = query.getOrDefault("key")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "key", valid_578992
  var valid_578993 = query.getOrDefault("prettyPrint")
  valid_578993 = validateParameter(valid_578993, JBool, required = false,
                                 default = newJBool(true))
  if valid_578993 != nil:
    section.add "prettyPrint", valid_578993
  var valid_578994 = query.getOrDefault("oauth_token")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "oauth_token", valid_578994
  var valid_578995 = query.getOrDefault("alt")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = newJString("json"))
  if valid_578995 != nil:
    section.add "alt", valid_578995
  var valid_578996 = query.getOrDefault("userIp")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "userIp", valid_578996
  var valid_578997 = query.getOrDefault("quotaUser")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "quotaUser", valid_578997
  var valid_578998 = query.getOrDefault("fields")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "fields", valid_578998
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

proc call*(call_579000: Call_TasksTasksPatch_578987; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified task. This method supports patch semantics.
  ## 
  let valid = call_579000.validator(path, query, header, formData, body)
  let scheme = call_579000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579000.url(scheme.get, call_579000.host, call_579000.base,
                         call_579000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579000, url, valid)

proc call*(call_579001: Call_TasksTasksPatch_578987; task: string; tasklist: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## tasksTasksPatch
  ## Updates the specified task. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   task: string (required)
  ##       : Task identifier.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  var path_579002 = newJObject()
  var query_579003 = newJObject()
  var body_579004 = newJObject()
  add(query_579003, "key", newJString(key))
  add(query_579003, "prettyPrint", newJBool(prettyPrint))
  add(query_579003, "oauth_token", newJString(oauthToken))
  add(query_579003, "alt", newJString(alt))
  add(query_579003, "userIp", newJString(userIp))
  add(query_579003, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579004 = body
  add(query_579003, "fields", newJString(fields))
  add(path_579002, "task", newJString(task))
  add(path_579002, "tasklist", newJString(tasklist))
  result = call_579001.call(path_579002, query_579003, nil, nil, body_579004)

var tasksTasksPatch* = Call_TasksTasksPatch_578987(name: "tasksTasksPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}", validator: validate_TasksTasksPatch_578988,
    base: "/tasks/v1", url: url_TasksTasksPatch_578989, schemes: {Scheme.Https})
type
  Call_TasksTasksDelete_578971 = ref object of OpenApiRestCall_578339
proc url_TasksTasksDelete_578973(protocol: Scheme; host: string; base: string;
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

proc validate_TasksTasksDelete_578972(path: JsonNode; query: JsonNode;
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
  var valid_578974 = path.getOrDefault("task")
  valid_578974 = validateParameter(valid_578974, JString, required = true,
                                 default = nil)
  if valid_578974 != nil:
    section.add "task", valid_578974
  var valid_578975 = path.getOrDefault("tasklist")
  valid_578975 = validateParameter(valid_578975, JString, required = true,
                                 default = nil)
  if valid_578975 != nil:
    section.add "tasklist", valid_578975
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
  var valid_578976 = query.getOrDefault("key")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "key", valid_578976
  var valid_578977 = query.getOrDefault("prettyPrint")
  valid_578977 = validateParameter(valid_578977, JBool, required = false,
                                 default = newJBool(true))
  if valid_578977 != nil:
    section.add "prettyPrint", valid_578977
  var valid_578978 = query.getOrDefault("oauth_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "oauth_token", valid_578978
  var valid_578979 = query.getOrDefault("alt")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = newJString("json"))
  if valid_578979 != nil:
    section.add "alt", valid_578979
  var valid_578980 = query.getOrDefault("userIp")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "userIp", valid_578980
  var valid_578981 = query.getOrDefault("quotaUser")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "quotaUser", valid_578981
  var valid_578982 = query.getOrDefault("fields")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "fields", valid_578982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578983: Call_TasksTasksDelete_578971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified task from the task list.
  ## 
  let valid = call_578983.validator(path, query, header, formData, body)
  let scheme = call_578983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578983.url(scheme.get, call_578983.host, call_578983.base,
                         call_578983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578983, url, valid)

proc call*(call_578984: Call_TasksTasksDelete_578971; task: string; tasklist: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## tasksTasksDelete
  ## Deletes the specified task from the task list.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   task: string (required)
  ##       : Task identifier.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  var path_578985 = newJObject()
  var query_578986 = newJObject()
  add(query_578986, "key", newJString(key))
  add(query_578986, "prettyPrint", newJBool(prettyPrint))
  add(query_578986, "oauth_token", newJString(oauthToken))
  add(query_578986, "alt", newJString(alt))
  add(query_578986, "userIp", newJString(userIp))
  add(query_578986, "quotaUser", newJString(quotaUser))
  add(query_578986, "fields", newJString(fields))
  add(path_578985, "task", newJString(task))
  add(path_578985, "tasklist", newJString(tasklist))
  result = call_578984.call(path_578985, query_578986, nil, nil, nil)

var tasksTasksDelete* = Call_TasksTasksDelete_578971(name: "tasksTasksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}", validator: validate_TasksTasksDelete_578972,
    base: "/tasks/v1", url: url_TasksTasksDelete_578973, schemes: {Scheme.Https})
type
  Call_TasksTasksMove_579005 = ref object of OpenApiRestCall_578339
proc url_TasksTasksMove_579007(protocol: Scheme; host: string; base: string;
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

proc validate_TasksTasksMove_579006(path: JsonNode; query: JsonNode;
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
  var valid_579008 = path.getOrDefault("task")
  valid_579008 = validateParameter(valid_579008, JString, required = true,
                                 default = nil)
  if valid_579008 != nil:
    section.add "task", valid_579008
  var valid_579009 = path.getOrDefault("tasklist")
  valid_579009 = validateParameter(valid_579009, JString, required = true,
                                 default = nil)
  if valid_579009 != nil:
    section.add "tasklist", valid_579009
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
  ##   parent: JString
  ##         : New parent task identifier. If the task is moved to the top level, this parameter is omitted. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   previous: JString
  ##           : New previous sibling task identifier. If the task is moved to the first position among its siblings, this parameter is omitted. Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579010 = query.getOrDefault("key")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "key", valid_579010
  var valid_579011 = query.getOrDefault("prettyPrint")
  valid_579011 = validateParameter(valid_579011, JBool, required = false,
                                 default = newJBool(true))
  if valid_579011 != nil:
    section.add "prettyPrint", valid_579011
  var valid_579012 = query.getOrDefault("oauth_token")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "oauth_token", valid_579012
  var valid_579013 = query.getOrDefault("alt")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = newJString("json"))
  if valid_579013 != nil:
    section.add "alt", valid_579013
  var valid_579014 = query.getOrDefault("userIp")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "userIp", valid_579014
  var valid_579015 = query.getOrDefault("parent")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "parent", valid_579015
  var valid_579016 = query.getOrDefault("quotaUser")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "quotaUser", valid_579016
  var valid_579017 = query.getOrDefault("previous")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "previous", valid_579017
  var valid_579018 = query.getOrDefault("fields")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "fields", valid_579018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579019: Call_TasksTasksMove_579005; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves the specified task to another position in the task list. This can include putting it as a child task under a new parent and/or move it to a different position among its sibling tasks.
  ## 
  let valid = call_579019.validator(path, query, header, formData, body)
  let scheme = call_579019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579019.url(scheme.get, call_579019.host, call_579019.base,
                         call_579019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579019, url, valid)

proc call*(call_579020: Call_TasksTasksMove_579005; task: string; tasklist: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; parent: string = "";
          quotaUser: string = ""; previous: string = ""; fields: string = ""): Recallable =
  ## tasksTasksMove
  ## Moves the specified task to another position in the task list. This can include putting it as a child task under a new parent and/or move it to a different position among its sibling tasks.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   parent: string
  ##         : New parent task identifier. If the task is moved to the top level, this parameter is omitted. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   previous: string
  ##           : New previous sibling task identifier. If the task is moved to the first position among its siblings, this parameter is omitted. Optional.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   task: string (required)
  ##       : Task identifier.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  var path_579021 = newJObject()
  var query_579022 = newJObject()
  add(query_579022, "key", newJString(key))
  add(query_579022, "prettyPrint", newJBool(prettyPrint))
  add(query_579022, "oauth_token", newJString(oauthToken))
  add(query_579022, "alt", newJString(alt))
  add(query_579022, "userIp", newJString(userIp))
  add(query_579022, "parent", newJString(parent))
  add(query_579022, "quotaUser", newJString(quotaUser))
  add(query_579022, "previous", newJString(previous))
  add(query_579022, "fields", newJString(fields))
  add(path_579021, "task", newJString(task))
  add(path_579021, "tasklist", newJString(tasklist))
  result = call_579020.call(path_579021, query_579022, nil, nil, nil)

var tasksTasksMove* = Call_TasksTasksMove_579005(name: "tasksTasksMove",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lists/{tasklist}/tasks/{task}/move",
    validator: validate_TasksTasksMove_579006, base: "/tasks/v1",
    url: url_TasksTasksMove_579007, schemes: {Scheme.Https})
type
  Call_TasksTasklistsInsert_579038 = ref object of OpenApiRestCall_578339
proc url_TasksTasklistsInsert_579040(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_TasksTasklistsInsert_579039(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new task list and adds it to the authenticated user's task lists.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_579041 = query.getOrDefault("key")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "key", valid_579041
  var valid_579042 = query.getOrDefault("prettyPrint")
  valid_579042 = validateParameter(valid_579042, JBool, required = false,
                                 default = newJBool(true))
  if valid_579042 != nil:
    section.add "prettyPrint", valid_579042
  var valid_579043 = query.getOrDefault("oauth_token")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "oauth_token", valid_579043
  var valid_579044 = query.getOrDefault("alt")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = newJString("json"))
  if valid_579044 != nil:
    section.add "alt", valid_579044
  var valid_579045 = query.getOrDefault("userIp")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "userIp", valid_579045
  var valid_579046 = query.getOrDefault("quotaUser")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "quotaUser", valid_579046
  var valid_579047 = query.getOrDefault("fields")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "fields", valid_579047
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

proc call*(call_579049: Call_TasksTasklistsInsert_579038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new task list and adds it to the authenticated user's task lists.
  ## 
  let valid = call_579049.validator(path, query, header, formData, body)
  let scheme = call_579049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579049.url(scheme.get, call_579049.host, call_579049.base,
                         call_579049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579049, url, valid)

proc call*(call_579050: Call_TasksTasklistsInsert_579038; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## tasksTasklistsInsert
  ## Creates a new task list and adds it to the authenticated user's task lists.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579051 = newJObject()
  var body_579052 = newJObject()
  add(query_579051, "key", newJString(key))
  add(query_579051, "prettyPrint", newJBool(prettyPrint))
  add(query_579051, "oauth_token", newJString(oauthToken))
  add(query_579051, "alt", newJString(alt))
  add(query_579051, "userIp", newJString(userIp))
  add(query_579051, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579052 = body
  add(query_579051, "fields", newJString(fields))
  result = call_579050.call(nil, query_579051, nil, nil, body_579052)

var tasksTasklistsInsert* = Call_TasksTasklistsInsert_579038(
    name: "tasksTasklistsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/@me/lists",
    validator: validate_TasksTasklistsInsert_579039, base: "/tasks/v1",
    url: url_TasksTasklistsInsert_579040, schemes: {Scheme.Https})
type
  Call_TasksTasklistsList_579023 = ref object of OpenApiRestCall_578339
proc url_TasksTasklistsList_579025(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_TasksTasklistsList_579024(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns all the authenticated user's task lists.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   pageToken: JString
  ##            : Token specifying the result page to return. Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JString
  ##             : Maximum number of task lists returned on one page. Optional. The default is 20 (max allowed: 100).
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
  var valid_579029 = query.getOrDefault("alt")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = newJString("json"))
  if valid_579029 != nil:
    section.add "alt", valid_579029
  var valid_579030 = query.getOrDefault("userIp")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "userIp", valid_579030
  var valid_579031 = query.getOrDefault("quotaUser")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "quotaUser", valid_579031
  var valid_579032 = query.getOrDefault("pageToken")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "pageToken", valid_579032
  var valid_579033 = query.getOrDefault("fields")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "fields", valid_579033
  var valid_579034 = query.getOrDefault("maxResults")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "maxResults", valid_579034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579035: Call_TasksTasklistsList_579023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the authenticated user's task lists.
  ## 
  let valid = call_579035.validator(path, query, header, formData, body)
  let scheme = call_579035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579035.url(scheme.get, call_579035.host, call_579035.base,
                         call_579035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579035, url, valid)

proc call*(call_579036: Call_TasksTasklistsList_579023; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: string = ""): Recallable =
  ## tasksTasklistsList
  ## Returns all the authenticated user's task lists.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token specifying the result page to return. Optional.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: string
  ##             : Maximum number of task lists returned on one page. Optional. The default is 20 (max allowed: 100).
  var query_579037 = newJObject()
  add(query_579037, "key", newJString(key))
  add(query_579037, "prettyPrint", newJBool(prettyPrint))
  add(query_579037, "oauth_token", newJString(oauthToken))
  add(query_579037, "alt", newJString(alt))
  add(query_579037, "userIp", newJString(userIp))
  add(query_579037, "quotaUser", newJString(quotaUser))
  add(query_579037, "pageToken", newJString(pageToken))
  add(query_579037, "fields", newJString(fields))
  add(query_579037, "maxResults", newJString(maxResults))
  result = call_579036.call(nil, query_579037, nil, nil, nil)

var tasksTasklistsList* = Call_TasksTasklistsList_579023(
    name: "tasksTasklistsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/@me/lists",
    validator: validate_TasksTasklistsList_579024, base: "/tasks/v1",
    url: url_TasksTasklistsList_579025, schemes: {Scheme.Https})
type
  Call_TasksTasklistsUpdate_579068 = ref object of OpenApiRestCall_578339
proc url_TasksTasklistsUpdate_579070(protocol: Scheme; host: string; base: string;
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

proc validate_TasksTasklistsUpdate_579069(path: JsonNode; query: JsonNode;
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
  var valid_579071 = path.getOrDefault("tasklist")
  valid_579071 = validateParameter(valid_579071, JString, required = true,
                                 default = nil)
  if valid_579071 != nil:
    section.add "tasklist", valid_579071
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
  var valid_579072 = query.getOrDefault("key")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "key", valid_579072
  var valid_579073 = query.getOrDefault("prettyPrint")
  valid_579073 = validateParameter(valid_579073, JBool, required = false,
                                 default = newJBool(true))
  if valid_579073 != nil:
    section.add "prettyPrint", valid_579073
  var valid_579074 = query.getOrDefault("oauth_token")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "oauth_token", valid_579074
  var valid_579075 = query.getOrDefault("alt")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = newJString("json"))
  if valid_579075 != nil:
    section.add "alt", valid_579075
  var valid_579076 = query.getOrDefault("userIp")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "userIp", valid_579076
  var valid_579077 = query.getOrDefault("quotaUser")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "quotaUser", valid_579077
  var valid_579078 = query.getOrDefault("fields")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "fields", valid_579078
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

proc call*(call_579080: Call_TasksTasklistsUpdate_579068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the authenticated user's specified task list.
  ## 
  let valid = call_579080.validator(path, query, header, formData, body)
  let scheme = call_579080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579080.url(scheme.get, call_579080.host, call_579080.base,
                         call_579080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579080, url, valid)

proc call*(call_579081: Call_TasksTasklistsUpdate_579068; tasklist: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## tasksTasklistsUpdate
  ## Updates the authenticated user's specified task list.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  var path_579082 = newJObject()
  var query_579083 = newJObject()
  var body_579084 = newJObject()
  add(query_579083, "key", newJString(key))
  add(query_579083, "prettyPrint", newJBool(prettyPrint))
  add(query_579083, "oauth_token", newJString(oauthToken))
  add(query_579083, "alt", newJString(alt))
  add(query_579083, "userIp", newJString(userIp))
  add(query_579083, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579084 = body
  add(query_579083, "fields", newJString(fields))
  add(path_579082, "tasklist", newJString(tasklist))
  result = call_579081.call(path_579082, query_579083, nil, nil, body_579084)

var tasksTasklistsUpdate* = Call_TasksTasklistsUpdate_579068(
    name: "tasksTasklistsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/@me/lists/{tasklist}",
    validator: validate_TasksTasklistsUpdate_579069, base: "/tasks/v1",
    url: url_TasksTasklistsUpdate_579070, schemes: {Scheme.Https})
type
  Call_TasksTasklistsGet_579053 = ref object of OpenApiRestCall_578339
proc url_TasksTasklistsGet_579055(protocol: Scheme; host: string; base: string;
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

proc validate_TasksTasklistsGet_579054(path: JsonNode; query: JsonNode;
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
  var valid_579056 = path.getOrDefault("tasklist")
  valid_579056 = validateParameter(valid_579056, JString, required = true,
                                 default = nil)
  if valid_579056 != nil:
    section.add "tasklist", valid_579056
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
  var valid_579057 = query.getOrDefault("key")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "key", valid_579057
  var valid_579058 = query.getOrDefault("prettyPrint")
  valid_579058 = validateParameter(valid_579058, JBool, required = false,
                                 default = newJBool(true))
  if valid_579058 != nil:
    section.add "prettyPrint", valid_579058
  var valid_579059 = query.getOrDefault("oauth_token")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "oauth_token", valid_579059
  var valid_579060 = query.getOrDefault("alt")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = newJString("json"))
  if valid_579060 != nil:
    section.add "alt", valid_579060
  var valid_579061 = query.getOrDefault("userIp")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "userIp", valid_579061
  var valid_579062 = query.getOrDefault("quotaUser")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "quotaUser", valid_579062
  var valid_579063 = query.getOrDefault("fields")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "fields", valid_579063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579064: Call_TasksTasklistsGet_579053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the authenticated user's specified task list.
  ## 
  let valid = call_579064.validator(path, query, header, formData, body)
  let scheme = call_579064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579064.url(scheme.get, call_579064.host, call_579064.base,
                         call_579064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579064, url, valid)

proc call*(call_579065: Call_TasksTasklistsGet_579053; tasklist: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## tasksTasklistsGet
  ## Returns the authenticated user's specified task list.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  var path_579066 = newJObject()
  var query_579067 = newJObject()
  add(query_579067, "key", newJString(key))
  add(query_579067, "prettyPrint", newJBool(prettyPrint))
  add(query_579067, "oauth_token", newJString(oauthToken))
  add(query_579067, "alt", newJString(alt))
  add(query_579067, "userIp", newJString(userIp))
  add(query_579067, "quotaUser", newJString(quotaUser))
  add(query_579067, "fields", newJString(fields))
  add(path_579066, "tasklist", newJString(tasklist))
  result = call_579065.call(path_579066, query_579067, nil, nil, nil)

var tasksTasklistsGet* = Call_TasksTasklistsGet_579053(name: "tasksTasklistsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/users/@me/lists/{tasklist}", validator: validate_TasksTasklistsGet_579054,
    base: "/tasks/v1", url: url_TasksTasklistsGet_579055, schemes: {Scheme.Https})
type
  Call_TasksTasklistsPatch_579100 = ref object of OpenApiRestCall_578339
proc url_TasksTasklistsPatch_579102(protocol: Scheme; host: string; base: string;
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

proc validate_TasksTasklistsPatch_579101(path: JsonNode; query: JsonNode;
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
  var valid_579103 = path.getOrDefault("tasklist")
  valid_579103 = validateParameter(valid_579103, JString, required = true,
                                 default = nil)
  if valid_579103 != nil:
    section.add "tasklist", valid_579103
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
  var valid_579104 = query.getOrDefault("key")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "key", valid_579104
  var valid_579105 = query.getOrDefault("prettyPrint")
  valid_579105 = validateParameter(valid_579105, JBool, required = false,
                                 default = newJBool(true))
  if valid_579105 != nil:
    section.add "prettyPrint", valid_579105
  var valid_579106 = query.getOrDefault("oauth_token")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "oauth_token", valid_579106
  var valid_579107 = query.getOrDefault("alt")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = newJString("json"))
  if valid_579107 != nil:
    section.add "alt", valid_579107
  var valid_579108 = query.getOrDefault("userIp")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "userIp", valid_579108
  var valid_579109 = query.getOrDefault("quotaUser")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "quotaUser", valid_579109
  var valid_579110 = query.getOrDefault("fields")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "fields", valid_579110
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

proc call*(call_579112: Call_TasksTasklistsPatch_579100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the authenticated user's specified task list. This method supports patch semantics.
  ## 
  let valid = call_579112.validator(path, query, header, formData, body)
  let scheme = call_579112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579112.url(scheme.get, call_579112.host, call_579112.base,
                         call_579112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579112, url, valid)

proc call*(call_579113: Call_TasksTasklistsPatch_579100; tasklist: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## tasksTasklistsPatch
  ## Updates the authenticated user's specified task list. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  var path_579114 = newJObject()
  var query_579115 = newJObject()
  var body_579116 = newJObject()
  add(query_579115, "key", newJString(key))
  add(query_579115, "prettyPrint", newJBool(prettyPrint))
  add(query_579115, "oauth_token", newJString(oauthToken))
  add(query_579115, "alt", newJString(alt))
  add(query_579115, "userIp", newJString(userIp))
  add(query_579115, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579116 = body
  add(query_579115, "fields", newJString(fields))
  add(path_579114, "tasklist", newJString(tasklist))
  result = call_579113.call(path_579114, query_579115, nil, nil, body_579116)

var tasksTasklistsPatch* = Call_TasksTasklistsPatch_579100(
    name: "tasksTasklistsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/@me/lists/{tasklist}",
    validator: validate_TasksTasklistsPatch_579101, base: "/tasks/v1",
    url: url_TasksTasklistsPatch_579102, schemes: {Scheme.Https})
type
  Call_TasksTasklistsDelete_579085 = ref object of OpenApiRestCall_578339
proc url_TasksTasklistsDelete_579087(protocol: Scheme; host: string; base: string;
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

proc validate_TasksTasklistsDelete_579086(path: JsonNode; query: JsonNode;
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
  var valid_579088 = path.getOrDefault("tasklist")
  valid_579088 = validateParameter(valid_579088, JString, required = true,
                                 default = nil)
  if valid_579088 != nil:
    section.add "tasklist", valid_579088
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
  var valid_579089 = query.getOrDefault("key")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "key", valid_579089
  var valid_579090 = query.getOrDefault("prettyPrint")
  valid_579090 = validateParameter(valid_579090, JBool, required = false,
                                 default = newJBool(true))
  if valid_579090 != nil:
    section.add "prettyPrint", valid_579090
  var valid_579091 = query.getOrDefault("oauth_token")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "oauth_token", valid_579091
  var valid_579092 = query.getOrDefault("alt")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = newJString("json"))
  if valid_579092 != nil:
    section.add "alt", valid_579092
  var valid_579093 = query.getOrDefault("userIp")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "userIp", valid_579093
  var valid_579094 = query.getOrDefault("quotaUser")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "quotaUser", valid_579094
  var valid_579095 = query.getOrDefault("fields")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "fields", valid_579095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579096: Call_TasksTasklistsDelete_579085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the authenticated user's specified task list.
  ## 
  let valid = call_579096.validator(path, query, header, formData, body)
  let scheme = call_579096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579096.url(scheme.get, call_579096.host, call_579096.base,
                         call_579096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579096, url, valid)

proc call*(call_579097: Call_TasksTasklistsDelete_579085; tasklist: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## tasksTasklistsDelete
  ## Deletes the authenticated user's specified task list.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   tasklist: string (required)
  ##           : Task list identifier.
  var path_579098 = newJObject()
  var query_579099 = newJObject()
  add(query_579099, "key", newJString(key))
  add(query_579099, "prettyPrint", newJBool(prettyPrint))
  add(query_579099, "oauth_token", newJString(oauthToken))
  add(query_579099, "alt", newJString(alt))
  add(query_579099, "userIp", newJString(userIp))
  add(query_579099, "quotaUser", newJString(quotaUser))
  add(query_579099, "fields", newJString(fields))
  add(path_579098, "tasklist", newJString(tasklist))
  result = call_579097.call(path_579098, query_579099, nil, nil, nil)

var tasksTasklistsDelete* = Call_TasksTasklistsDelete_579085(
    name: "tasksTasklistsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/@me/lists/{tasklist}",
    validator: validate_TasksTasklistsDelete_579086, base: "/tasks/v1",
    url: url_TasksTasklistsDelete_579087, schemes: {Scheme.Https})
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
