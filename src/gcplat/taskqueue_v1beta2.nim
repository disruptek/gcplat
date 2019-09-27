
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: TaskQueue
## version: v1beta2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Accesses a Google App Engine Pull Task Queue over REST.
## 
## https://developers.google.com/appengine/docs/python/taskqueue/rest
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
  gcpServiceName = "taskqueue"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TaskqueueTaskqueuesGet_593676 = ref object of OpenApiRestCall_593408
proc url_TaskqueueTaskqueuesGet_593678(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "taskqueue" in path, "`taskqueue` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/taskqueues/"),
               (kind: VariableSegment, value: "taskqueue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskqueueTaskqueuesGet_593677(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get detailed information about a TaskQueue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project under which the queue lies.
  ##   taskqueue: JString (required)
  ##            : The id of the taskqueue to get the properties of.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_593804 = path.getOrDefault("project")
  valid_593804 = validateParameter(valid_593804, JString, required = true,
                                 default = nil)
  if valid_593804 != nil:
    section.add "project", valid_593804
  var valid_593805 = path.getOrDefault("taskqueue")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "taskqueue", valid_593805
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   getStats: JBool
  ##           : Whether to get stats. Optional.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593806 = query.getOrDefault("fields")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "fields", valid_593806
  var valid_593807 = query.getOrDefault("quotaUser")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "quotaUser", valid_593807
  var valid_593821 = query.getOrDefault("alt")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = newJString("json"))
  if valid_593821 != nil:
    section.add "alt", valid_593821
  var valid_593822 = query.getOrDefault("getStats")
  valid_593822 = validateParameter(valid_593822, JBool, required = false, default = nil)
  if valid_593822 != nil:
    section.add "getStats", valid_593822
  var valid_593823 = query.getOrDefault("oauth_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "oauth_token", valid_593823
  var valid_593824 = query.getOrDefault("userIp")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "userIp", valid_593824
  var valid_593825 = query.getOrDefault("key")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "key", valid_593825
  var valid_593826 = query.getOrDefault("prettyPrint")
  valid_593826 = validateParameter(valid_593826, JBool, required = false,
                                 default = newJBool(true))
  if valid_593826 != nil:
    section.add "prettyPrint", valid_593826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593849: Call_TaskqueueTaskqueuesGet_593676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get detailed information about a TaskQueue.
  ## 
  let valid = call_593849.validator(path, query, header, formData, body)
  let scheme = call_593849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593849.url(scheme.get, call_593849.host, call_593849.base,
                         call_593849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593849, url, valid)

proc call*(call_593920: Call_TaskqueueTaskqueuesGet_593676; project: string;
          taskqueue: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; getStats: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## taskqueueTaskqueuesGet
  ## Get detailed information about a TaskQueue.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   getStats: bool
  ##           : Whether to get stats. Optional.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project under which the queue lies.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   taskqueue: string (required)
  ##            : The id of the taskqueue to get the properties of.
  var path_593921 = newJObject()
  var query_593923 = newJObject()
  add(query_593923, "fields", newJString(fields))
  add(query_593923, "quotaUser", newJString(quotaUser))
  add(query_593923, "alt", newJString(alt))
  add(query_593923, "getStats", newJBool(getStats))
  add(query_593923, "oauth_token", newJString(oauthToken))
  add(query_593923, "userIp", newJString(userIp))
  add(query_593923, "key", newJString(key))
  add(path_593921, "project", newJString(project))
  add(query_593923, "prettyPrint", newJBool(prettyPrint))
  add(path_593921, "taskqueue", newJString(taskqueue))
  result = call_593920.call(path_593921, query_593923, nil, nil, nil)

var taskqueueTaskqueuesGet* = Call_TaskqueueTaskqueuesGet_593676(
    name: "taskqueueTaskqueuesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/taskqueues/{taskqueue}",
    validator: validate_TaskqueueTaskqueuesGet_593677,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTaskqueuesGet_593678,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksInsert_593978 = ref object of OpenApiRestCall_593408
proc url_TaskqueueTasksInsert_593980(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "taskqueue" in path, "`taskqueue` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/taskqueues/"),
               (kind: VariableSegment, value: "taskqueue"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskqueueTasksInsert_593979(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Insert a new task in a TaskQueue
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project under which the queue lies
  ##   taskqueue: JString (required)
  ##            : The taskqueue to insert the task into
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_593981 = path.getOrDefault("project")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "project", valid_593981
  var valid_593982 = path.getOrDefault("taskqueue")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "taskqueue", valid_593982
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
  var valid_593983 = query.getOrDefault("fields")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "fields", valid_593983
  var valid_593984 = query.getOrDefault("quotaUser")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "quotaUser", valid_593984
  var valid_593985 = query.getOrDefault("alt")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = newJString("json"))
  if valid_593985 != nil:
    section.add "alt", valid_593985
  var valid_593986 = query.getOrDefault("oauth_token")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "oauth_token", valid_593986
  var valid_593987 = query.getOrDefault("userIp")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "userIp", valid_593987
  var valid_593988 = query.getOrDefault("key")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "key", valid_593988
  var valid_593989 = query.getOrDefault("prettyPrint")
  valid_593989 = validateParameter(valid_593989, JBool, required = false,
                                 default = newJBool(true))
  if valid_593989 != nil:
    section.add "prettyPrint", valid_593989
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

proc call*(call_593991: Call_TaskqueueTasksInsert_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Insert a new task in a TaskQueue
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_TaskqueueTasksInsert_593978; project: string;
          taskqueue: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## taskqueueTasksInsert
  ## Insert a new task in a TaskQueue
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
  ##   project: string (required)
  ##          : The project under which the queue lies
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   taskqueue: string (required)
  ##            : The taskqueue to insert the task into
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  var body_593995 = newJObject()
  add(query_593994, "fields", newJString(fields))
  add(query_593994, "quotaUser", newJString(quotaUser))
  add(query_593994, "alt", newJString(alt))
  add(query_593994, "oauth_token", newJString(oauthToken))
  add(query_593994, "userIp", newJString(userIp))
  add(query_593994, "key", newJString(key))
  add(path_593993, "project", newJString(project))
  if body != nil:
    body_593995 = body
  add(query_593994, "prettyPrint", newJBool(prettyPrint))
  add(path_593993, "taskqueue", newJString(taskqueue))
  result = call_593992.call(path_593993, query_593994, nil, nil, body_593995)

var taskqueueTasksInsert* = Call_TaskqueueTasksInsert_593978(
    name: "taskqueueTasksInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/taskqueues/{taskqueue}/tasks",
    validator: validate_TaskqueueTasksInsert_593979,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksInsert_593980,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksList_593962 = ref object of OpenApiRestCall_593408
proc url_TaskqueueTasksList_593964(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "taskqueue" in path, "`taskqueue` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/taskqueues/"),
               (kind: VariableSegment, value: "taskqueue"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskqueueTasksList_593963(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List Tasks in a TaskQueue
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project under which the queue lies.
  ##   taskqueue: JString (required)
  ##            : The id of the taskqueue to list tasks from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_593965 = path.getOrDefault("project")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "project", valid_593965
  var valid_593966 = path.getOrDefault("taskqueue")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "taskqueue", valid_593966
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
  var valid_593967 = query.getOrDefault("fields")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "fields", valid_593967
  var valid_593968 = query.getOrDefault("quotaUser")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "quotaUser", valid_593968
  var valid_593969 = query.getOrDefault("alt")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = newJString("json"))
  if valid_593969 != nil:
    section.add "alt", valid_593969
  var valid_593970 = query.getOrDefault("oauth_token")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "oauth_token", valid_593970
  var valid_593971 = query.getOrDefault("userIp")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "userIp", valid_593971
  var valid_593972 = query.getOrDefault("key")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "key", valid_593972
  var valid_593973 = query.getOrDefault("prettyPrint")
  valid_593973 = validateParameter(valid_593973, JBool, required = false,
                                 default = newJBool(true))
  if valid_593973 != nil:
    section.add "prettyPrint", valid_593973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593974: Call_TaskqueueTasksList_593962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Tasks in a TaskQueue
  ## 
  let valid = call_593974.validator(path, query, header, formData, body)
  let scheme = call_593974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593974.url(scheme.get, call_593974.host, call_593974.base,
                         call_593974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593974, url, valid)

proc call*(call_593975: Call_TaskqueueTasksList_593962; project: string;
          taskqueue: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## taskqueueTasksList
  ## List Tasks in a TaskQueue
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
  ##   project: string (required)
  ##          : The project under which the queue lies.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   taskqueue: string (required)
  ##            : The id of the taskqueue to list tasks from.
  var path_593976 = newJObject()
  var query_593977 = newJObject()
  add(query_593977, "fields", newJString(fields))
  add(query_593977, "quotaUser", newJString(quotaUser))
  add(query_593977, "alt", newJString(alt))
  add(query_593977, "oauth_token", newJString(oauthToken))
  add(query_593977, "userIp", newJString(userIp))
  add(query_593977, "key", newJString(key))
  add(path_593976, "project", newJString(project))
  add(query_593977, "prettyPrint", newJBool(prettyPrint))
  add(path_593976, "taskqueue", newJString(taskqueue))
  result = call_593975.call(path_593976, query_593977, nil, nil, nil)

var taskqueueTasksList* = Call_TaskqueueTasksList_593962(
    name: "taskqueueTasksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/taskqueues/{taskqueue}/tasks",
    validator: validate_TaskqueueTasksList_593963,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksList_593964,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksLease_593996 = ref object of OpenApiRestCall_593408
proc url_TaskqueueTasksLease_593998(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "taskqueue" in path, "`taskqueue` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/taskqueues/"),
               (kind: VariableSegment, value: "taskqueue"),
               (kind: ConstantSegment, value: "/tasks/lease")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskqueueTasksLease_593997(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lease 1 or more tasks from a TaskQueue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project under which the queue lies.
  ##   taskqueue: JString (required)
  ##            : The taskqueue to lease a task from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_593999 = path.getOrDefault("project")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "project", valid_593999
  var valid_594000 = path.getOrDefault("taskqueue")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "taskqueue", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   tag: JString
  ##      : The tag allowed for tasks in the response. Must only be specified if group_by_tag is true. If group_by_tag is true and tag is not specified the tag will be that of the oldest task by eta, i.e. the first available tag
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
  ##   groupByTag: JBool
  ##             : When true, all returned tasks will have the same tag
  ##   leaseSecs: JInt (required)
  ##            : The lease in seconds.
  ##   numTasks: JInt (required)
  ##           : The number of tasks to lease.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594001 = query.getOrDefault("tag")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "tag", valid_594001
  var valid_594002 = query.getOrDefault("fields")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "fields", valid_594002
  var valid_594003 = query.getOrDefault("quotaUser")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "quotaUser", valid_594003
  var valid_594004 = query.getOrDefault("alt")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("json"))
  if valid_594004 != nil:
    section.add "alt", valid_594004
  var valid_594005 = query.getOrDefault("oauth_token")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "oauth_token", valid_594005
  var valid_594006 = query.getOrDefault("userIp")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "userIp", valid_594006
  var valid_594007 = query.getOrDefault("key")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "key", valid_594007
  var valid_594008 = query.getOrDefault("groupByTag")
  valid_594008 = validateParameter(valid_594008, JBool, required = false, default = nil)
  if valid_594008 != nil:
    section.add "groupByTag", valid_594008
  assert query != nil,
        "query argument is necessary due to required `leaseSecs` field"
  var valid_594009 = query.getOrDefault("leaseSecs")
  valid_594009 = validateParameter(valid_594009, JInt, required = true, default = nil)
  if valid_594009 != nil:
    section.add "leaseSecs", valid_594009
  var valid_594010 = query.getOrDefault("numTasks")
  valid_594010 = validateParameter(valid_594010, JInt, required = true, default = nil)
  if valid_594010 != nil:
    section.add "numTasks", valid_594010
  var valid_594011 = query.getOrDefault("prettyPrint")
  valid_594011 = validateParameter(valid_594011, JBool, required = false,
                                 default = newJBool(true))
  if valid_594011 != nil:
    section.add "prettyPrint", valid_594011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594012: Call_TaskqueueTasksLease_593996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lease 1 or more tasks from a TaskQueue.
  ## 
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_TaskqueueTasksLease_593996; leaseSecs: int;
          project: string; numTasks: int; taskqueue: string; tag: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          groupByTag: bool = false; prettyPrint: bool = true): Recallable =
  ## taskqueueTasksLease
  ## Lease 1 or more tasks from a TaskQueue.
  ##   tag: string
  ##      : The tag allowed for tasks in the response. Must only be specified if group_by_tag is true. If group_by_tag is true and tag is not specified the tag will be that of the oldest task by eta, i.e. the first available tag
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
  ##   groupByTag: bool
  ##             : When true, all returned tasks will have the same tag
  ##   leaseSecs: int (required)
  ##            : The lease in seconds.
  ##   project: string (required)
  ##          : The project under which the queue lies.
  ##   numTasks: int (required)
  ##           : The number of tasks to lease.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   taskqueue: string (required)
  ##            : The taskqueue to lease a task from.
  var path_594014 = newJObject()
  var query_594015 = newJObject()
  add(query_594015, "tag", newJString(tag))
  add(query_594015, "fields", newJString(fields))
  add(query_594015, "quotaUser", newJString(quotaUser))
  add(query_594015, "alt", newJString(alt))
  add(query_594015, "oauth_token", newJString(oauthToken))
  add(query_594015, "userIp", newJString(userIp))
  add(query_594015, "key", newJString(key))
  add(query_594015, "groupByTag", newJBool(groupByTag))
  add(query_594015, "leaseSecs", newJInt(leaseSecs))
  add(path_594014, "project", newJString(project))
  add(query_594015, "numTasks", newJInt(numTasks))
  add(query_594015, "prettyPrint", newJBool(prettyPrint))
  add(path_594014, "taskqueue", newJString(taskqueue))
  result = call_594013.call(path_594014, query_594015, nil, nil, nil)

var taskqueueTasksLease* = Call_TaskqueueTasksLease_593996(
    name: "taskqueueTasksLease", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/lease",
    validator: validate_TaskqueueTasksLease_593997,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksLease_593998,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksUpdate_594033 = ref object of OpenApiRestCall_593408
proc url_TaskqueueTasksUpdate_594035(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "taskqueue" in path, "`taskqueue` is a required path parameter"
  assert "task" in path, "`task` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/taskqueues/"),
               (kind: VariableSegment, value: "taskqueue"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "task")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskqueueTasksUpdate_594034(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update tasks that are leased out of a TaskQueue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   task: JString (required)
  ##   project: JString (required)
  ##          : The project under which the queue lies.
  ##   taskqueue: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `task` field"
  var valid_594036 = path.getOrDefault("task")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "task", valid_594036
  var valid_594037 = path.getOrDefault("project")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "project", valid_594037
  var valid_594038 = path.getOrDefault("taskqueue")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "taskqueue", valid_594038
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
  ##   newLeaseSeconds: JInt (required)
  ##                  : The new lease in seconds.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594039 = query.getOrDefault("fields")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "fields", valid_594039
  var valid_594040 = query.getOrDefault("quotaUser")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "quotaUser", valid_594040
  var valid_594041 = query.getOrDefault("alt")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = newJString("json"))
  if valid_594041 != nil:
    section.add "alt", valid_594041
  var valid_594042 = query.getOrDefault("oauth_token")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "oauth_token", valid_594042
  var valid_594043 = query.getOrDefault("userIp")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "userIp", valid_594043
  var valid_594044 = query.getOrDefault("key")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "key", valid_594044
  assert query != nil,
        "query argument is necessary due to required `newLeaseSeconds` field"
  var valid_594045 = query.getOrDefault("newLeaseSeconds")
  valid_594045 = validateParameter(valid_594045, JInt, required = true, default = nil)
  if valid_594045 != nil:
    section.add "newLeaseSeconds", valid_594045
  var valid_594046 = query.getOrDefault("prettyPrint")
  valid_594046 = validateParameter(valid_594046, JBool, required = false,
                                 default = newJBool(true))
  if valid_594046 != nil:
    section.add "prettyPrint", valid_594046
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

proc call*(call_594048: Call_TaskqueueTasksUpdate_594033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tasks that are leased out of a TaskQueue.
  ## 
  let valid = call_594048.validator(path, query, header, formData, body)
  let scheme = call_594048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594048.url(scheme.get, call_594048.host, call_594048.base,
                         call_594048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594048, url, valid)

proc call*(call_594049: Call_TaskqueueTasksUpdate_594033; task: string;
          newLeaseSeconds: int; project: string; taskqueue: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## taskqueueTasksUpdate
  ## Update tasks that are leased out of a TaskQueue.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   task: string (required)
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   newLeaseSeconds: int (required)
  ##                  : The new lease in seconds.
  ##   project: string (required)
  ##          : The project under which the queue lies.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   taskqueue: string (required)
  var path_594050 = newJObject()
  var query_594051 = newJObject()
  var body_594052 = newJObject()
  add(query_594051, "fields", newJString(fields))
  add(query_594051, "quotaUser", newJString(quotaUser))
  add(query_594051, "alt", newJString(alt))
  add(path_594050, "task", newJString(task))
  add(query_594051, "oauth_token", newJString(oauthToken))
  add(query_594051, "userIp", newJString(userIp))
  add(query_594051, "key", newJString(key))
  add(query_594051, "newLeaseSeconds", newJInt(newLeaseSeconds))
  add(path_594050, "project", newJString(project))
  if body != nil:
    body_594052 = body
  add(query_594051, "prettyPrint", newJBool(prettyPrint))
  add(path_594050, "taskqueue", newJString(taskqueue))
  result = call_594049.call(path_594050, query_594051, nil, nil, body_594052)

var taskqueueTasksUpdate* = Call_TaskqueueTasksUpdate_594033(
    name: "taskqueueTasksUpdate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksUpdate_594034,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksUpdate_594035,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksGet_594016 = ref object of OpenApiRestCall_593408
proc url_TaskqueueTasksGet_594018(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "taskqueue" in path, "`taskqueue` is a required path parameter"
  assert "task" in path, "`task` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/taskqueues/"),
               (kind: VariableSegment, value: "taskqueue"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "task")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskqueueTasksGet_594017(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get a particular task from a TaskQueue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   task: JString (required)
  ##       : The task to get properties of.
  ##   project: JString (required)
  ##          : The project under which the queue lies.
  ##   taskqueue: JString (required)
  ##            : The taskqueue in which the task belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `task` field"
  var valid_594019 = path.getOrDefault("task")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "task", valid_594019
  var valid_594020 = path.getOrDefault("project")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "project", valid_594020
  var valid_594021 = path.getOrDefault("taskqueue")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "taskqueue", valid_594021
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
  var valid_594022 = query.getOrDefault("fields")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "fields", valid_594022
  var valid_594023 = query.getOrDefault("quotaUser")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "quotaUser", valid_594023
  var valid_594024 = query.getOrDefault("alt")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = newJString("json"))
  if valid_594024 != nil:
    section.add "alt", valid_594024
  var valid_594025 = query.getOrDefault("oauth_token")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "oauth_token", valid_594025
  var valid_594026 = query.getOrDefault("userIp")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "userIp", valid_594026
  var valid_594027 = query.getOrDefault("key")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "key", valid_594027
  var valid_594028 = query.getOrDefault("prettyPrint")
  valid_594028 = validateParameter(valid_594028, JBool, required = false,
                                 default = newJBool(true))
  if valid_594028 != nil:
    section.add "prettyPrint", valid_594028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_TaskqueueTasksGet_594016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a particular task from a TaskQueue.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_TaskqueueTasksGet_594016; task: string; project: string;
          taskqueue: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## taskqueueTasksGet
  ## Get a particular task from a TaskQueue.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   task: string (required)
  ##       : The task to get properties of.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project under which the queue lies.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   taskqueue: string (required)
  ##            : The taskqueue in which the task belongs.
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  add(query_594032, "fields", newJString(fields))
  add(query_594032, "quotaUser", newJString(quotaUser))
  add(query_594032, "alt", newJString(alt))
  add(path_594031, "task", newJString(task))
  add(query_594032, "oauth_token", newJString(oauthToken))
  add(query_594032, "userIp", newJString(userIp))
  add(query_594032, "key", newJString(key))
  add(path_594031, "project", newJString(project))
  add(query_594032, "prettyPrint", newJBool(prettyPrint))
  add(path_594031, "taskqueue", newJString(taskqueue))
  result = call_594030.call(path_594031, query_594032, nil, nil, nil)

var taskqueueTasksGet* = Call_TaskqueueTasksGet_594016(name: "taskqueueTasksGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksGet_594017,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksGet_594018,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksPatch_594070 = ref object of OpenApiRestCall_593408
proc url_TaskqueueTasksPatch_594072(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "taskqueue" in path, "`taskqueue` is a required path parameter"
  assert "task" in path, "`task` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/taskqueues/"),
               (kind: VariableSegment, value: "taskqueue"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "task")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskqueueTasksPatch_594071(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Update tasks that are leased out of a TaskQueue. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   task: JString (required)
  ##   project: JString (required)
  ##          : The project under which the queue lies.
  ##   taskqueue: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `task` field"
  var valid_594073 = path.getOrDefault("task")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "task", valid_594073
  var valid_594074 = path.getOrDefault("project")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "project", valid_594074
  var valid_594075 = path.getOrDefault("taskqueue")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "taskqueue", valid_594075
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
  ##   newLeaseSeconds: JInt (required)
  ##                  : The new lease in seconds.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594076 = query.getOrDefault("fields")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "fields", valid_594076
  var valid_594077 = query.getOrDefault("quotaUser")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "quotaUser", valid_594077
  var valid_594078 = query.getOrDefault("alt")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = newJString("json"))
  if valid_594078 != nil:
    section.add "alt", valid_594078
  var valid_594079 = query.getOrDefault("oauth_token")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "oauth_token", valid_594079
  var valid_594080 = query.getOrDefault("userIp")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "userIp", valid_594080
  var valid_594081 = query.getOrDefault("key")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "key", valid_594081
  assert query != nil,
        "query argument is necessary due to required `newLeaseSeconds` field"
  var valid_594082 = query.getOrDefault("newLeaseSeconds")
  valid_594082 = validateParameter(valid_594082, JInt, required = true, default = nil)
  if valid_594082 != nil:
    section.add "newLeaseSeconds", valid_594082
  var valid_594083 = query.getOrDefault("prettyPrint")
  valid_594083 = validateParameter(valid_594083, JBool, required = false,
                                 default = newJBool(true))
  if valid_594083 != nil:
    section.add "prettyPrint", valid_594083
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

proc call*(call_594085: Call_TaskqueueTasksPatch_594070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tasks that are leased out of a TaskQueue. This method supports patch semantics.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_TaskqueueTasksPatch_594070; task: string;
          newLeaseSeconds: int; project: string; taskqueue: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## taskqueueTasksPatch
  ## Update tasks that are leased out of a TaskQueue. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   task: string (required)
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   newLeaseSeconds: int (required)
  ##                  : The new lease in seconds.
  ##   project: string (required)
  ##          : The project under which the queue lies.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   taskqueue: string (required)
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  var body_594089 = newJObject()
  add(query_594088, "fields", newJString(fields))
  add(query_594088, "quotaUser", newJString(quotaUser))
  add(query_594088, "alt", newJString(alt))
  add(path_594087, "task", newJString(task))
  add(query_594088, "oauth_token", newJString(oauthToken))
  add(query_594088, "userIp", newJString(userIp))
  add(query_594088, "key", newJString(key))
  add(query_594088, "newLeaseSeconds", newJInt(newLeaseSeconds))
  add(path_594087, "project", newJString(project))
  if body != nil:
    body_594089 = body
  add(query_594088, "prettyPrint", newJBool(prettyPrint))
  add(path_594087, "taskqueue", newJString(taskqueue))
  result = call_594086.call(path_594087, query_594088, nil, nil, body_594089)

var taskqueueTasksPatch* = Call_TaskqueueTasksPatch_594070(
    name: "taskqueueTasksPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksPatch_594071,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksPatch_594072,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksDelete_594053 = ref object of OpenApiRestCall_593408
proc url_TaskqueueTasksDelete_594055(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "taskqueue" in path, "`taskqueue` is a required path parameter"
  assert "task" in path, "`task` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/taskqueues/"),
               (kind: VariableSegment, value: "taskqueue"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "task")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TaskqueueTasksDelete_594054(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a task from a TaskQueue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   task: JString (required)
  ##       : The id of the task to delete.
  ##   project: JString (required)
  ##          : The project under which the queue lies.
  ##   taskqueue: JString (required)
  ##            : The taskqueue to delete a task from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `task` field"
  var valid_594056 = path.getOrDefault("task")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "task", valid_594056
  var valid_594057 = path.getOrDefault("project")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "project", valid_594057
  var valid_594058 = path.getOrDefault("taskqueue")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "taskqueue", valid_594058
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
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_TaskqueueTasksDelete_594053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a task from a TaskQueue.
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_TaskqueueTasksDelete_594053; task: string;
          project: string; taskqueue: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## taskqueueTasksDelete
  ## Delete a task from a TaskQueue.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   task: string (required)
  ##       : The id of the task to delete.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project under which the queue lies.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   taskqueue: string (required)
  ##            : The taskqueue to delete a task from.
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(query_594069, "fields", newJString(fields))
  add(query_594069, "quotaUser", newJString(quotaUser))
  add(query_594069, "alt", newJString(alt))
  add(path_594068, "task", newJString(task))
  add(query_594069, "oauth_token", newJString(oauthToken))
  add(query_594069, "userIp", newJString(userIp))
  add(query_594069, "key", newJString(key))
  add(path_594068, "project", newJString(project))
  add(query_594069, "prettyPrint", newJBool(prettyPrint))
  add(path_594068, "taskqueue", newJString(taskqueue))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var taskqueueTasksDelete* = Call_TaskqueueTasksDelete_594053(
    name: "taskqueueTasksDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksDelete_594054,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksDelete_594055,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
