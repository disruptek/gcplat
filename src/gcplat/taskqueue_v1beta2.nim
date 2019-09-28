
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  gcpServiceName = "taskqueue"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TaskqueueTaskqueuesGet_579676 = ref object of OpenApiRestCall_579408
proc url_TaskqueueTaskqueuesGet_579678(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_TaskqueueTaskqueuesGet_579677(path: JsonNode; query: JsonNode;
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
  var valid_579804 = path.getOrDefault("project")
  valid_579804 = validateParameter(valid_579804, JString, required = true,
                                 default = nil)
  if valid_579804 != nil:
    section.add "project", valid_579804
  var valid_579805 = path.getOrDefault("taskqueue")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "taskqueue", valid_579805
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
  var valid_579806 = query.getOrDefault("fields")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "fields", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579821 = query.getOrDefault("alt")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = newJString("json"))
  if valid_579821 != nil:
    section.add "alt", valid_579821
  var valid_579822 = query.getOrDefault("getStats")
  valid_579822 = validateParameter(valid_579822, JBool, required = false, default = nil)
  if valid_579822 != nil:
    section.add "getStats", valid_579822
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("userIp")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "userIp", valid_579824
  var valid_579825 = query.getOrDefault("key")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "key", valid_579825
  var valid_579826 = query.getOrDefault("prettyPrint")
  valid_579826 = validateParameter(valid_579826, JBool, required = false,
                                 default = newJBool(true))
  if valid_579826 != nil:
    section.add "prettyPrint", valid_579826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579849: Call_TaskqueueTaskqueuesGet_579676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get detailed information about a TaskQueue.
  ## 
  let valid = call_579849.validator(path, query, header, formData, body)
  let scheme = call_579849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579849.url(scheme.get, call_579849.host, call_579849.base,
                         call_579849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579849, url, valid)

proc call*(call_579920: Call_TaskqueueTaskqueuesGet_579676; project: string;
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
  var path_579921 = newJObject()
  var query_579923 = newJObject()
  add(query_579923, "fields", newJString(fields))
  add(query_579923, "quotaUser", newJString(quotaUser))
  add(query_579923, "alt", newJString(alt))
  add(query_579923, "getStats", newJBool(getStats))
  add(query_579923, "oauth_token", newJString(oauthToken))
  add(query_579923, "userIp", newJString(userIp))
  add(query_579923, "key", newJString(key))
  add(path_579921, "project", newJString(project))
  add(query_579923, "prettyPrint", newJBool(prettyPrint))
  add(path_579921, "taskqueue", newJString(taskqueue))
  result = call_579920.call(path_579921, query_579923, nil, nil, nil)

var taskqueueTaskqueuesGet* = Call_TaskqueueTaskqueuesGet_579676(
    name: "taskqueueTaskqueuesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/taskqueues/{taskqueue}",
    validator: validate_TaskqueueTaskqueuesGet_579677,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTaskqueuesGet_579678,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksInsert_579978 = ref object of OpenApiRestCall_579408
proc url_TaskqueueTasksInsert_579980(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_TaskqueueTasksInsert_579979(path: JsonNode; query: JsonNode;
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
  var valid_579981 = path.getOrDefault("project")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "project", valid_579981
  var valid_579982 = path.getOrDefault("taskqueue")
  valid_579982 = validateParameter(valid_579982, JString, required = true,
                                 default = nil)
  if valid_579982 != nil:
    section.add "taskqueue", valid_579982
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
  var valid_579983 = query.getOrDefault("fields")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "fields", valid_579983
  var valid_579984 = query.getOrDefault("quotaUser")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "quotaUser", valid_579984
  var valid_579985 = query.getOrDefault("alt")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("json"))
  if valid_579985 != nil:
    section.add "alt", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("userIp")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "userIp", valid_579987
  var valid_579988 = query.getOrDefault("key")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "key", valid_579988
  var valid_579989 = query.getOrDefault("prettyPrint")
  valid_579989 = validateParameter(valid_579989, JBool, required = false,
                                 default = newJBool(true))
  if valid_579989 != nil:
    section.add "prettyPrint", valid_579989
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

proc call*(call_579991: Call_TaskqueueTasksInsert_579978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Insert a new task in a TaskQueue
  ## 
  let valid = call_579991.validator(path, query, header, formData, body)
  let scheme = call_579991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579991.url(scheme.get, call_579991.host, call_579991.base,
                         call_579991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579991, url, valid)

proc call*(call_579992: Call_TaskqueueTasksInsert_579978; project: string;
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
  var path_579993 = newJObject()
  var query_579994 = newJObject()
  var body_579995 = newJObject()
  add(query_579994, "fields", newJString(fields))
  add(query_579994, "quotaUser", newJString(quotaUser))
  add(query_579994, "alt", newJString(alt))
  add(query_579994, "oauth_token", newJString(oauthToken))
  add(query_579994, "userIp", newJString(userIp))
  add(query_579994, "key", newJString(key))
  add(path_579993, "project", newJString(project))
  if body != nil:
    body_579995 = body
  add(query_579994, "prettyPrint", newJBool(prettyPrint))
  add(path_579993, "taskqueue", newJString(taskqueue))
  result = call_579992.call(path_579993, query_579994, nil, nil, body_579995)

var taskqueueTasksInsert* = Call_TaskqueueTasksInsert_579978(
    name: "taskqueueTasksInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/taskqueues/{taskqueue}/tasks",
    validator: validate_TaskqueueTasksInsert_579979,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksInsert_579980,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksList_579962 = ref object of OpenApiRestCall_579408
proc url_TaskqueueTasksList_579964(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_TaskqueueTasksList_579963(path: JsonNode; query: JsonNode;
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
  var valid_579965 = path.getOrDefault("project")
  valid_579965 = validateParameter(valid_579965, JString, required = true,
                                 default = nil)
  if valid_579965 != nil:
    section.add "project", valid_579965
  var valid_579966 = path.getOrDefault("taskqueue")
  valid_579966 = validateParameter(valid_579966, JString, required = true,
                                 default = nil)
  if valid_579966 != nil:
    section.add "taskqueue", valid_579966
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
  var valid_579967 = query.getOrDefault("fields")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "fields", valid_579967
  var valid_579968 = query.getOrDefault("quotaUser")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "quotaUser", valid_579968
  var valid_579969 = query.getOrDefault("alt")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = newJString("json"))
  if valid_579969 != nil:
    section.add "alt", valid_579969
  var valid_579970 = query.getOrDefault("oauth_token")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "oauth_token", valid_579970
  var valid_579971 = query.getOrDefault("userIp")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "userIp", valid_579971
  var valid_579972 = query.getOrDefault("key")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "key", valid_579972
  var valid_579973 = query.getOrDefault("prettyPrint")
  valid_579973 = validateParameter(valid_579973, JBool, required = false,
                                 default = newJBool(true))
  if valid_579973 != nil:
    section.add "prettyPrint", valid_579973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579974: Call_TaskqueueTasksList_579962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Tasks in a TaskQueue
  ## 
  let valid = call_579974.validator(path, query, header, formData, body)
  let scheme = call_579974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579974.url(scheme.get, call_579974.host, call_579974.base,
                         call_579974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579974, url, valid)

proc call*(call_579975: Call_TaskqueueTasksList_579962; project: string;
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
  var path_579976 = newJObject()
  var query_579977 = newJObject()
  add(query_579977, "fields", newJString(fields))
  add(query_579977, "quotaUser", newJString(quotaUser))
  add(query_579977, "alt", newJString(alt))
  add(query_579977, "oauth_token", newJString(oauthToken))
  add(query_579977, "userIp", newJString(userIp))
  add(query_579977, "key", newJString(key))
  add(path_579976, "project", newJString(project))
  add(query_579977, "prettyPrint", newJBool(prettyPrint))
  add(path_579976, "taskqueue", newJString(taskqueue))
  result = call_579975.call(path_579976, query_579977, nil, nil, nil)

var taskqueueTasksList* = Call_TaskqueueTasksList_579962(
    name: "taskqueueTasksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/taskqueues/{taskqueue}/tasks",
    validator: validate_TaskqueueTasksList_579963,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksList_579964,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksLease_579996 = ref object of OpenApiRestCall_579408
proc url_TaskqueueTasksLease_579998(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_TaskqueueTasksLease_579997(path: JsonNode; query: JsonNode;
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
  var valid_579999 = path.getOrDefault("project")
  valid_579999 = validateParameter(valid_579999, JString, required = true,
                                 default = nil)
  if valid_579999 != nil:
    section.add "project", valid_579999
  var valid_580000 = path.getOrDefault("taskqueue")
  valid_580000 = validateParameter(valid_580000, JString, required = true,
                                 default = nil)
  if valid_580000 != nil:
    section.add "taskqueue", valid_580000
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
  var valid_580001 = query.getOrDefault("tag")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "tag", valid_580001
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("oauth_token")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "oauth_token", valid_580005
  var valid_580006 = query.getOrDefault("userIp")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "userIp", valid_580006
  var valid_580007 = query.getOrDefault("key")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "key", valid_580007
  var valid_580008 = query.getOrDefault("groupByTag")
  valid_580008 = validateParameter(valid_580008, JBool, required = false, default = nil)
  if valid_580008 != nil:
    section.add "groupByTag", valid_580008
  assert query != nil,
        "query argument is necessary due to required `leaseSecs` field"
  var valid_580009 = query.getOrDefault("leaseSecs")
  valid_580009 = validateParameter(valid_580009, JInt, required = true, default = nil)
  if valid_580009 != nil:
    section.add "leaseSecs", valid_580009
  var valid_580010 = query.getOrDefault("numTasks")
  valid_580010 = validateParameter(valid_580010, JInt, required = true, default = nil)
  if valid_580010 != nil:
    section.add "numTasks", valid_580010
  var valid_580011 = query.getOrDefault("prettyPrint")
  valid_580011 = validateParameter(valid_580011, JBool, required = false,
                                 default = newJBool(true))
  if valid_580011 != nil:
    section.add "prettyPrint", valid_580011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580012: Call_TaskqueueTasksLease_579996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lease 1 or more tasks from a TaskQueue.
  ## 
  let valid = call_580012.validator(path, query, header, formData, body)
  let scheme = call_580012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580012.url(scheme.get, call_580012.host, call_580012.base,
                         call_580012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580012, url, valid)

proc call*(call_580013: Call_TaskqueueTasksLease_579996; leaseSecs: int;
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
  var path_580014 = newJObject()
  var query_580015 = newJObject()
  add(query_580015, "tag", newJString(tag))
  add(query_580015, "fields", newJString(fields))
  add(query_580015, "quotaUser", newJString(quotaUser))
  add(query_580015, "alt", newJString(alt))
  add(query_580015, "oauth_token", newJString(oauthToken))
  add(query_580015, "userIp", newJString(userIp))
  add(query_580015, "key", newJString(key))
  add(query_580015, "groupByTag", newJBool(groupByTag))
  add(query_580015, "leaseSecs", newJInt(leaseSecs))
  add(path_580014, "project", newJString(project))
  add(query_580015, "numTasks", newJInt(numTasks))
  add(query_580015, "prettyPrint", newJBool(prettyPrint))
  add(path_580014, "taskqueue", newJString(taskqueue))
  result = call_580013.call(path_580014, query_580015, nil, nil, nil)

var taskqueueTasksLease* = Call_TaskqueueTasksLease_579996(
    name: "taskqueueTasksLease", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/lease",
    validator: validate_TaskqueueTasksLease_579997,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksLease_579998,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksUpdate_580033 = ref object of OpenApiRestCall_579408
proc url_TaskqueueTasksUpdate_580035(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_TaskqueueTasksUpdate_580034(path: JsonNode; query: JsonNode;
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
  var valid_580036 = path.getOrDefault("task")
  valid_580036 = validateParameter(valid_580036, JString, required = true,
                                 default = nil)
  if valid_580036 != nil:
    section.add "task", valid_580036
  var valid_580037 = path.getOrDefault("project")
  valid_580037 = validateParameter(valid_580037, JString, required = true,
                                 default = nil)
  if valid_580037 != nil:
    section.add "project", valid_580037
  var valid_580038 = path.getOrDefault("taskqueue")
  valid_580038 = validateParameter(valid_580038, JString, required = true,
                                 default = nil)
  if valid_580038 != nil:
    section.add "taskqueue", valid_580038
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
  var valid_580039 = query.getOrDefault("fields")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "fields", valid_580039
  var valid_580040 = query.getOrDefault("quotaUser")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "quotaUser", valid_580040
  var valid_580041 = query.getOrDefault("alt")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("json"))
  if valid_580041 != nil:
    section.add "alt", valid_580041
  var valid_580042 = query.getOrDefault("oauth_token")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "oauth_token", valid_580042
  var valid_580043 = query.getOrDefault("userIp")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "userIp", valid_580043
  var valid_580044 = query.getOrDefault("key")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "key", valid_580044
  assert query != nil,
        "query argument is necessary due to required `newLeaseSeconds` field"
  var valid_580045 = query.getOrDefault("newLeaseSeconds")
  valid_580045 = validateParameter(valid_580045, JInt, required = true, default = nil)
  if valid_580045 != nil:
    section.add "newLeaseSeconds", valid_580045
  var valid_580046 = query.getOrDefault("prettyPrint")
  valid_580046 = validateParameter(valid_580046, JBool, required = false,
                                 default = newJBool(true))
  if valid_580046 != nil:
    section.add "prettyPrint", valid_580046
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

proc call*(call_580048: Call_TaskqueueTasksUpdate_580033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tasks that are leased out of a TaskQueue.
  ## 
  let valid = call_580048.validator(path, query, header, formData, body)
  let scheme = call_580048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580048.url(scheme.get, call_580048.host, call_580048.base,
                         call_580048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580048, url, valid)

proc call*(call_580049: Call_TaskqueueTasksUpdate_580033; task: string;
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
  var path_580050 = newJObject()
  var query_580051 = newJObject()
  var body_580052 = newJObject()
  add(query_580051, "fields", newJString(fields))
  add(query_580051, "quotaUser", newJString(quotaUser))
  add(query_580051, "alt", newJString(alt))
  add(path_580050, "task", newJString(task))
  add(query_580051, "oauth_token", newJString(oauthToken))
  add(query_580051, "userIp", newJString(userIp))
  add(query_580051, "key", newJString(key))
  add(query_580051, "newLeaseSeconds", newJInt(newLeaseSeconds))
  add(path_580050, "project", newJString(project))
  if body != nil:
    body_580052 = body
  add(query_580051, "prettyPrint", newJBool(prettyPrint))
  add(path_580050, "taskqueue", newJString(taskqueue))
  result = call_580049.call(path_580050, query_580051, nil, nil, body_580052)

var taskqueueTasksUpdate* = Call_TaskqueueTasksUpdate_580033(
    name: "taskqueueTasksUpdate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksUpdate_580034,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksUpdate_580035,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksGet_580016 = ref object of OpenApiRestCall_579408
proc url_TaskqueueTasksGet_580018(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_TaskqueueTasksGet_580017(path: JsonNode; query: JsonNode;
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
  var valid_580019 = path.getOrDefault("task")
  valid_580019 = validateParameter(valid_580019, JString, required = true,
                                 default = nil)
  if valid_580019 != nil:
    section.add "task", valid_580019
  var valid_580020 = path.getOrDefault("project")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "project", valid_580020
  var valid_580021 = path.getOrDefault("taskqueue")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = nil)
  if valid_580021 != nil:
    section.add "taskqueue", valid_580021
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
  var valid_580022 = query.getOrDefault("fields")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "fields", valid_580022
  var valid_580023 = query.getOrDefault("quotaUser")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "quotaUser", valid_580023
  var valid_580024 = query.getOrDefault("alt")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = newJString("json"))
  if valid_580024 != nil:
    section.add "alt", valid_580024
  var valid_580025 = query.getOrDefault("oauth_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "oauth_token", valid_580025
  var valid_580026 = query.getOrDefault("userIp")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "userIp", valid_580026
  var valid_580027 = query.getOrDefault("key")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "key", valid_580027
  var valid_580028 = query.getOrDefault("prettyPrint")
  valid_580028 = validateParameter(valid_580028, JBool, required = false,
                                 default = newJBool(true))
  if valid_580028 != nil:
    section.add "prettyPrint", valid_580028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580029: Call_TaskqueueTasksGet_580016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a particular task from a TaskQueue.
  ## 
  let valid = call_580029.validator(path, query, header, formData, body)
  let scheme = call_580029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580029.url(scheme.get, call_580029.host, call_580029.base,
                         call_580029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580029, url, valid)

proc call*(call_580030: Call_TaskqueueTasksGet_580016; task: string; project: string;
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
  var path_580031 = newJObject()
  var query_580032 = newJObject()
  add(query_580032, "fields", newJString(fields))
  add(query_580032, "quotaUser", newJString(quotaUser))
  add(query_580032, "alt", newJString(alt))
  add(path_580031, "task", newJString(task))
  add(query_580032, "oauth_token", newJString(oauthToken))
  add(query_580032, "userIp", newJString(userIp))
  add(query_580032, "key", newJString(key))
  add(path_580031, "project", newJString(project))
  add(query_580032, "prettyPrint", newJBool(prettyPrint))
  add(path_580031, "taskqueue", newJString(taskqueue))
  result = call_580030.call(path_580031, query_580032, nil, nil, nil)

var taskqueueTasksGet* = Call_TaskqueueTasksGet_580016(name: "taskqueueTasksGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksGet_580017,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksGet_580018,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksPatch_580070 = ref object of OpenApiRestCall_579408
proc url_TaskqueueTasksPatch_580072(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_TaskqueueTasksPatch_580071(path: JsonNode; query: JsonNode;
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
  var valid_580073 = path.getOrDefault("task")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "task", valid_580073
  var valid_580074 = path.getOrDefault("project")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "project", valid_580074
  var valid_580075 = path.getOrDefault("taskqueue")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "taskqueue", valid_580075
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
  var valid_580076 = query.getOrDefault("fields")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "fields", valid_580076
  var valid_580077 = query.getOrDefault("quotaUser")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "quotaUser", valid_580077
  var valid_580078 = query.getOrDefault("alt")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("json"))
  if valid_580078 != nil:
    section.add "alt", valid_580078
  var valid_580079 = query.getOrDefault("oauth_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "oauth_token", valid_580079
  var valid_580080 = query.getOrDefault("userIp")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "userIp", valid_580080
  var valid_580081 = query.getOrDefault("key")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "key", valid_580081
  assert query != nil,
        "query argument is necessary due to required `newLeaseSeconds` field"
  var valid_580082 = query.getOrDefault("newLeaseSeconds")
  valid_580082 = validateParameter(valid_580082, JInt, required = true, default = nil)
  if valid_580082 != nil:
    section.add "newLeaseSeconds", valid_580082
  var valid_580083 = query.getOrDefault("prettyPrint")
  valid_580083 = validateParameter(valid_580083, JBool, required = false,
                                 default = newJBool(true))
  if valid_580083 != nil:
    section.add "prettyPrint", valid_580083
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

proc call*(call_580085: Call_TaskqueueTasksPatch_580070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tasks that are leased out of a TaskQueue. This method supports patch semantics.
  ## 
  let valid = call_580085.validator(path, query, header, formData, body)
  let scheme = call_580085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580085.url(scheme.get, call_580085.host, call_580085.base,
                         call_580085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580085, url, valid)

proc call*(call_580086: Call_TaskqueueTasksPatch_580070; task: string;
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
  var path_580087 = newJObject()
  var query_580088 = newJObject()
  var body_580089 = newJObject()
  add(query_580088, "fields", newJString(fields))
  add(query_580088, "quotaUser", newJString(quotaUser))
  add(query_580088, "alt", newJString(alt))
  add(path_580087, "task", newJString(task))
  add(query_580088, "oauth_token", newJString(oauthToken))
  add(query_580088, "userIp", newJString(userIp))
  add(query_580088, "key", newJString(key))
  add(query_580088, "newLeaseSeconds", newJInt(newLeaseSeconds))
  add(path_580087, "project", newJString(project))
  if body != nil:
    body_580089 = body
  add(query_580088, "prettyPrint", newJBool(prettyPrint))
  add(path_580087, "taskqueue", newJString(taskqueue))
  result = call_580086.call(path_580087, query_580088, nil, nil, body_580089)

var taskqueueTasksPatch* = Call_TaskqueueTasksPatch_580070(
    name: "taskqueueTasksPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksPatch_580071,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksPatch_580072,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksDelete_580053 = ref object of OpenApiRestCall_579408
proc url_TaskqueueTasksDelete_580055(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_TaskqueueTasksDelete_580054(path: JsonNode; query: JsonNode;
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
  var valid_580056 = path.getOrDefault("task")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "task", valid_580056
  var valid_580057 = path.getOrDefault("project")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "project", valid_580057
  var valid_580058 = path.getOrDefault("taskqueue")
  valid_580058 = validateParameter(valid_580058, JString, required = true,
                                 default = nil)
  if valid_580058 != nil:
    section.add "taskqueue", valid_580058
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
  if body != nil:
    result.add "body", body

proc call*(call_580066: Call_TaskqueueTasksDelete_580053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a task from a TaskQueue.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_TaskqueueTasksDelete_580053; task: string;
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
  var path_580068 = newJObject()
  var query_580069 = newJObject()
  add(query_580069, "fields", newJString(fields))
  add(query_580069, "quotaUser", newJString(quotaUser))
  add(query_580069, "alt", newJString(alt))
  add(path_580068, "task", newJString(task))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "userIp", newJString(userIp))
  add(query_580069, "key", newJString(key))
  add(path_580068, "project", newJString(project))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  add(path_580068, "taskqueue", newJString(taskqueue))
  result = call_580067.call(path_580068, query_580069, nil, nil, nil)

var taskqueueTasksDelete* = Call_TaskqueueTasksDelete_580053(
    name: "taskqueueTasksDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksDelete_580054,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksDelete_580055,
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
