
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: TaskQueue
## version: v1beta1
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
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTaskqueuesGet_593678,
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
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTasksList_593964,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksLease_593978 = ref object of OpenApiRestCall_593408
proc url_TaskqueueTasksLease_593980(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksLease_593979(path: JsonNode; query: JsonNode;
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
  ##   leaseSecs: JInt (required)
  ##            : The lease in seconds.
  ##   numTasks: JInt (required)
  ##           : The number of tasks to lease.
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
  assert query != nil,
        "query argument is necessary due to required `leaseSecs` field"
  var valid_593989 = query.getOrDefault("leaseSecs")
  valid_593989 = validateParameter(valid_593989, JInt, required = true, default = nil)
  if valid_593989 != nil:
    section.add "leaseSecs", valid_593989
  var valid_593990 = query.getOrDefault("numTasks")
  valid_593990 = validateParameter(valid_593990, JInt, required = true, default = nil)
  if valid_593990 != nil:
    section.add "numTasks", valid_593990
  var valid_593991 = query.getOrDefault("prettyPrint")
  valid_593991 = validateParameter(valid_593991, JBool, required = false,
                                 default = newJBool(true))
  if valid_593991 != nil:
    section.add "prettyPrint", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593992: Call_TaskqueueTasksLease_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lease 1 or more tasks from a TaskQueue.
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_TaskqueueTasksLease_593978; leaseSecs: int;
          project: string; numTasks: int; taskqueue: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## taskqueueTasksLease
  ## Lease 1 or more tasks from a TaskQueue.
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
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  add(query_593995, "fields", newJString(fields))
  add(query_593995, "quotaUser", newJString(quotaUser))
  add(query_593995, "alt", newJString(alt))
  add(query_593995, "oauth_token", newJString(oauthToken))
  add(query_593995, "userIp", newJString(userIp))
  add(query_593995, "key", newJString(key))
  add(query_593995, "leaseSecs", newJInt(leaseSecs))
  add(path_593994, "project", newJString(project))
  add(query_593995, "numTasks", newJInt(numTasks))
  add(query_593995, "prettyPrint", newJBool(prettyPrint))
  add(path_593994, "taskqueue", newJString(taskqueue))
  result = call_593993.call(path_593994, query_593995, nil, nil, nil)

var taskqueueTasksLease* = Call_TaskqueueTasksLease_593978(
    name: "taskqueueTasksLease", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/lease",
    validator: validate_TaskqueueTasksLease_593979,
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTasksLease_593980,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksGet_593996 = ref object of OpenApiRestCall_593408
proc url_TaskqueueTasksGet_593998(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksGet_593997(path: JsonNode; query: JsonNode;
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
  var valid_593999 = path.getOrDefault("task")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "task", valid_593999
  var valid_594000 = path.getOrDefault("project")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "project", valid_594000
  var valid_594001 = path.getOrDefault("taskqueue")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "taskqueue", valid_594001
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
  var valid_594008 = query.getOrDefault("prettyPrint")
  valid_594008 = validateParameter(valid_594008, JBool, required = false,
                                 default = newJBool(true))
  if valid_594008 != nil:
    section.add "prettyPrint", valid_594008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_TaskqueueTasksGet_593996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a particular task from a TaskQueue.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_TaskqueueTasksGet_593996; task: string; project: string;
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
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  add(query_594012, "fields", newJString(fields))
  add(query_594012, "quotaUser", newJString(quotaUser))
  add(query_594012, "alt", newJString(alt))
  add(path_594011, "task", newJString(task))
  add(query_594012, "oauth_token", newJString(oauthToken))
  add(query_594012, "userIp", newJString(userIp))
  add(query_594012, "key", newJString(key))
  add(path_594011, "project", newJString(project))
  add(query_594012, "prettyPrint", newJBool(prettyPrint))
  add(path_594011, "taskqueue", newJString(taskqueue))
  result = call_594010.call(path_594011, query_594012, nil, nil, nil)

var taskqueueTasksGet* = Call_TaskqueueTasksGet_593996(name: "taskqueueTasksGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksGet_593997,
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTasksGet_593998,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksDelete_594013 = ref object of OpenApiRestCall_593408
proc url_TaskqueueTasksDelete_594015(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksDelete_594014(path: JsonNode; query: JsonNode;
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
  var valid_594016 = path.getOrDefault("task")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "task", valid_594016
  var valid_594017 = path.getOrDefault("project")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "project", valid_594017
  var valid_594018 = path.getOrDefault("taskqueue")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "taskqueue", valid_594018
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
  var valid_594019 = query.getOrDefault("fields")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "fields", valid_594019
  var valid_594020 = query.getOrDefault("quotaUser")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "quotaUser", valid_594020
  var valid_594021 = query.getOrDefault("alt")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = newJString("json"))
  if valid_594021 != nil:
    section.add "alt", valid_594021
  var valid_594022 = query.getOrDefault("oauth_token")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "oauth_token", valid_594022
  var valid_594023 = query.getOrDefault("userIp")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "userIp", valid_594023
  var valid_594024 = query.getOrDefault("key")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "key", valid_594024
  var valid_594025 = query.getOrDefault("prettyPrint")
  valid_594025 = validateParameter(valid_594025, JBool, required = false,
                                 default = newJBool(true))
  if valid_594025 != nil:
    section.add "prettyPrint", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_TaskqueueTasksDelete_594013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a task from a TaskQueue.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_TaskqueueTasksDelete_594013; task: string;
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
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(query_594029, "fields", newJString(fields))
  add(query_594029, "quotaUser", newJString(quotaUser))
  add(query_594029, "alt", newJString(alt))
  add(path_594028, "task", newJString(task))
  add(query_594029, "oauth_token", newJString(oauthToken))
  add(query_594029, "userIp", newJString(userIp))
  add(query_594029, "key", newJString(key))
  add(path_594028, "project", newJString(project))
  add(query_594029, "prettyPrint", newJBool(prettyPrint))
  add(path_594028, "taskqueue", newJString(taskqueue))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var taskqueueTasksDelete* = Call_TaskqueueTasksDelete_594013(
    name: "taskqueueTasksDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksDelete_594014,
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTasksDelete_594015,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
