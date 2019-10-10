
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "taskqueue"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TaskqueueTaskqueuesGet_588709 = ref object of OpenApiRestCall_588441
proc url_TaskqueueTaskqueuesGet_588711(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTaskqueuesGet_588710(path: JsonNode; query: JsonNode;
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
  var valid_588837 = path.getOrDefault("project")
  valid_588837 = validateParameter(valid_588837, JString, required = true,
                                 default = nil)
  if valid_588837 != nil:
    section.add "project", valid_588837
  var valid_588838 = path.getOrDefault("taskqueue")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "taskqueue", valid_588838
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
  var valid_588839 = query.getOrDefault("fields")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "fields", valid_588839
  var valid_588840 = query.getOrDefault("quotaUser")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "quotaUser", valid_588840
  var valid_588854 = query.getOrDefault("alt")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = newJString("json"))
  if valid_588854 != nil:
    section.add "alt", valid_588854
  var valid_588855 = query.getOrDefault("getStats")
  valid_588855 = validateParameter(valid_588855, JBool, required = false, default = nil)
  if valid_588855 != nil:
    section.add "getStats", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("userIp")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "userIp", valid_588857
  var valid_588858 = query.getOrDefault("key")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "key", valid_588858
  var valid_588859 = query.getOrDefault("prettyPrint")
  valid_588859 = validateParameter(valid_588859, JBool, required = false,
                                 default = newJBool(true))
  if valid_588859 != nil:
    section.add "prettyPrint", valid_588859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588882: Call_TaskqueueTaskqueuesGet_588709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get detailed information about a TaskQueue.
  ## 
  let valid = call_588882.validator(path, query, header, formData, body)
  let scheme = call_588882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588882.url(scheme.get, call_588882.host, call_588882.base,
                         call_588882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588882, url, valid)

proc call*(call_588953: Call_TaskqueueTaskqueuesGet_588709; project: string;
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
  var path_588954 = newJObject()
  var query_588956 = newJObject()
  add(query_588956, "fields", newJString(fields))
  add(query_588956, "quotaUser", newJString(quotaUser))
  add(query_588956, "alt", newJString(alt))
  add(query_588956, "getStats", newJBool(getStats))
  add(query_588956, "oauth_token", newJString(oauthToken))
  add(query_588956, "userIp", newJString(userIp))
  add(query_588956, "key", newJString(key))
  add(path_588954, "project", newJString(project))
  add(query_588956, "prettyPrint", newJBool(prettyPrint))
  add(path_588954, "taskqueue", newJString(taskqueue))
  result = call_588953.call(path_588954, query_588956, nil, nil, nil)

var taskqueueTaskqueuesGet* = Call_TaskqueueTaskqueuesGet_588709(
    name: "taskqueueTaskqueuesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/taskqueues/{taskqueue}",
    validator: validate_TaskqueueTaskqueuesGet_588710,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTaskqueuesGet_588711,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksInsert_589011 = ref object of OpenApiRestCall_588441
proc url_TaskqueueTasksInsert_589013(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksInsert_589012(path: JsonNode; query: JsonNode;
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
  var valid_589014 = path.getOrDefault("project")
  valid_589014 = validateParameter(valid_589014, JString, required = true,
                                 default = nil)
  if valid_589014 != nil:
    section.add "project", valid_589014
  var valid_589015 = path.getOrDefault("taskqueue")
  valid_589015 = validateParameter(valid_589015, JString, required = true,
                                 default = nil)
  if valid_589015 != nil:
    section.add "taskqueue", valid_589015
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
  var valid_589016 = query.getOrDefault("fields")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "fields", valid_589016
  var valid_589017 = query.getOrDefault("quotaUser")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "quotaUser", valid_589017
  var valid_589018 = query.getOrDefault("alt")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = newJString("json"))
  if valid_589018 != nil:
    section.add "alt", valid_589018
  var valid_589019 = query.getOrDefault("oauth_token")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "oauth_token", valid_589019
  var valid_589020 = query.getOrDefault("userIp")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "userIp", valid_589020
  var valid_589021 = query.getOrDefault("key")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "key", valid_589021
  var valid_589022 = query.getOrDefault("prettyPrint")
  valid_589022 = validateParameter(valid_589022, JBool, required = false,
                                 default = newJBool(true))
  if valid_589022 != nil:
    section.add "prettyPrint", valid_589022
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

proc call*(call_589024: Call_TaskqueueTasksInsert_589011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Insert a new task in a TaskQueue
  ## 
  let valid = call_589024.validator(path, query, header, formData, body)
  let scheme = call_589024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589024.url(scheme.get, call_589024.host, call_589024.base,
                         call_589024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589024, url, valid)

proc call*(call_589025: Call_TaskqueueTasksInsert_589011; project: string;
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
  var path_589026 = newJObject()
  var query_589027 = newJObject()
  var body_589028 = newJObject()
  add(query_589027, "fields", newJString(fields))
  add(query_589027, "quotaUser", newJString(quotaUser))
  add(query_589027, "alt", newJString(alt))
  add(query_589027, "oauth_token", newJString(oauthToken))
  add(query_589027, "userIp", newJString(userIp))
  add(query_589027, "key", newJString(key))
  add(path_589026, "project", newJString(project))
  if body != nil:
    body_589028 = body
  add(query_589027, "prettyPrint", newJBool(prettyPrint))
  add(path_589026, "taskqueue", newJString(taskqueue))
  result = call_589025.call(path_589026, query_589027, nil, nil, body_589028)

var taskqueueTasksInsert* = Call_TaskqueueTasksInsert_589011(
    name: "taskqueueTasksInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/taskqueues/{taskqueue}/tasks",
    validator: validate_TaskqueueTasksInsert_589012,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksInsert_589013,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksList_588995 = ref object of OpenApiRestCall_588441
proc url_TaskqueueTasksList_588997(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksList_588996(path: JsonNode; query: JsonNode;
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
  var valid_588998 = path.getOrDefault("project")
  valid_588998 = validateParameter(valid_588998, JString, required = true,
                                 default = nil)
  if valid_588998 != nil:
    section.add "project", valid_588998
  var valid_588999 = path.getOrDefault("taskqueue")
  valid_588999 = validateParameter(valid_588999, JString, required = true,
                                 default = nil)
  if valid_588999 != nil:
    section.add "taskqueue", valid_588999
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
  var valid_589000 = query.getOrDefault("fields")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "fields", valid_589000
  var valid_589001 = query.getOrDefault("quotaUser")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "quotaUser", valid_589001
  var valid_589002 = query.getOrDefault("alt")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = newJString("json"))
  if valid_589002 != nil:
    section.add "alt", valid_589002
  var valid_589003 = query.getOrDefault("oauth_token")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "oauth_token", valid_589003
  var valid_589004 = query.getOrDefault("userIp")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "userIp", valid_589004
  var valid_589005 = query.getOrDefault("key")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "key", valid_589005
  var valid_589006 = query.getOrDefault("prettyPrint")
  valid_589006 = validateParameter(valid_589006, JBool, required = false,
                                 default = newJBool(true))
  if valid_589006 != nil:
    section.add "prettyPrint", valid_589006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589007: Call_TaskqueueTasksList_588995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Tasks in a TaskQueue
  ## 
  let valid = call_589007.validator(path, query, header, formData, body)
  let scheme = call_589007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589007.url(scheme.get, call_589007.host, call_589007.base,
                         call_589007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589007, url, valid)

proc call*(call_589008: Call_TaskqueueTasksList_588995; project: string;
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
  var path_589009 = newJObject()
  var query_589010 = newJObject()
  add(query_589010, "fields", newJString(fields))
  add(query_589010, "quotaUser", newJString(quotaUser))
  add(query_589010, "alt", newJString(alt))
  add(query_589010, "oauth_token", newJString(oauthToken))
  add(query_589010, "userIp", newJString(userIp))
  add(query_589010, "key", newJString(key))
  add(path_589009, "project", newJString(project))
  add(query_589010, "prettyPrint", newJBool(prettyPrint))
  add(path_589009, "taskqueue", newJString(taskqueue))
  result = call_589008.call(path_589009, query_589010, nil, nil, nil)

var taskqueueTasksList* = Call_TaskqueueTasksList_588995(
    name: "taskqueueTasksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/taskqueues/{taskqueue}/tasks",
    validator: validate_TaskqueueTasksList_588996,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksList_588997,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksLease_589029 = ref object of OpenApiRestCall_588441
proc url_TaskqueueTasksLease_589031(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksLease_589030(path: JsonNode; query: JsonNode;
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
  var valid_589032 = path.getOrDefault("project")
  valid_589032 = validateParameter(valid_589032, JString, required = true,
                                 default = nil)
  if valid_589032 != nil:
    section.add "project", valid_589032
  var valid_589033 = path.getOrDefault("taskqueue")
  valid_589033 = validateParameter(valid_589033, JString, required = true,
                                 default = nil)
  if valid_589033 != nil:
    section.add "taskqueue", valid_589033
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
  var valid_589034 = query.getOrDefault("tag")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "tag", valid_589034
  var valid_589035 = query.getOrDefault("fields")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "fields", valid_589035
  var valid_589036 = query.getOrDefault("quotaUser")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "quotaUser", valid_589036
  var valid_589037 = query.getOrDefault("alt")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = newJString("json"))
  if valid_589037 != nil:
    section.add "alt", valid_589037
  var valid_589038 = query.getOrDefault("oauth_token")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "oauth_token", valid_589038
  var valid_589039 = query.getOrDefault("userIp")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "userIp", valid_589039
  var valid_589040 = query.getOrDefault("key")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "key", valid_589040
  var valid_589041 = query.getOrDefault("groupByTag")
  valid_589041 = validateParameter(valid_589041, JBool, required = false, default = nil)
  if valid_589041 != nil:
    section.add "groupByTag", valid_589041
  assert query != nil,
        "query argument is necessary due to required `leaseSecs` field"
  var valid_589042 = query.getOrDefault("leaseSecs")
  valid_589042 = validateParameter(valid_589042, JInt, required = true, default = nil)
  if valid_589042 != nil:
    section.add "leaseSecs", valid_589042
  var valid_589043 = query.getOrDefault("numTasks")
  valid_589043 = validateParameter(valid_589043, JInt, required = true, default = nil)
  if valid_589043 != nil:
    section.add "numTasks", valid_589043
  var valid_589044 = query.getOrDefault("prettyPrint")
  valid_589044 = validateParameter(valid_589044, JBool, required = false,
                                 default = newJBool(true))
  if valid_589044 != nil:
    section.add "prettyPrint", valid_589044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589045: Call_TaskqueueTasksLease_589029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lease 1 or more tasks from a TaskQueue.
  ## 
  let valid = call_589045.validator(path, query, header, formData, body)
  let scheme = call_589045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589045.url(scheme.get, call_589045.host, call_589045.base,
                         call_589045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589045, url, valid)

proc call*(call_589046: Call_TaskqueueTasksLease_589029; leaseSecs: int;
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
  var path_589047 = newJObject()
  var query_589048 = newJObject()
  add(query_589048, "tag", newJString(tag))
  add(query_589048, "fields", newJString(fields))
  add(query_589048, "quotaUser", newJString(quotaUser))
  add(query_589048, "alt", newJString(alt))
  add(query_589048, "oauth_token", newJString(oauthToken))
  add(query_589048, "userIp", newJString(userIp))
  add(query_589048, "key", newJString(key))
  add(query_589048, "groupByTag", newJBool(groupByTag))
  add(query_589048, "leaseSecs", newJInt(leaseSecs))
  add(path_589047, "project", newJString(project))
  add(query_589048, "numTasks", newJInt(numTasks))
  add(query_589048, "prettyPrint", newJBool(prettyPrint))
  add(path_589047, "taskqueue", newJString(taskqueue))
  result = call_589046.call(path_589047, query_589048, nil, nil, nil)

var taskqueueTasksLease* = Call_TaskqueueTasksLease_589029(
    name: "taskqueueTasksLease", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/lease",
    validator: validate_TaskqueueTasksLease_589030,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksLease_589031,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksUpdate_589066 = ref object of OpenApiRestCall_588441
proc url_TaskqueueTasksUpdate_589068(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksUpdate_589067(path: JsonNode; query: JsonNode;
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
  var valid_589069 = path.getOrDefault("task")
  valid_589069 = validateParameter(valid_589069, JString, required = true,
                                 default = nil)
  if valid_589069 != nil:
    section.add "task", valid_589069
  var valid_589070 = path.getOrDefault("project")
  valid_589070 = validateParameter(valid_589070, JString, required = true,
                                 default = nil)
  if valid_589070 != nil:
    section.add "project", valid_589070
  var valid_589071 = path.getOrDefault("taskqueue")
  valid_589071 = validateParameter(valid_589071, JString, required = true,
                                 default = nil)
  if valid_589071 != nil:
    section.add "taskqueue", valid_589071
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
  var valid_589072 = query.getOrDefault("fields")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "fields", valid_589072
  var valid_589073 = query.getOrDefault("quotaUser")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "quotaUser", valid_589073
  var valid_589074 = query.getOrDefault("alt")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = newJString("json"))
  if valid_589074 != nil:
    section.add "alt", valid_589074
  var valid_589075 = query.getOrDefault("oauth_token")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "oauth_token", valid_589075
  var valid_589076 = query.getOrDefault("userIp")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "userIp", valid_589076
  var valid_589077 = query.getOrDefault("key")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "key", valid_589077
  assert query != nil,
        "query argument is necessary due to required `newLeaseSeconds` field"
  var valid_589078 = query.getOrDefault("newLeaseSeconds")
  valid_589078 = validateParameter(valid_589078, JInt, required = true, default = nil)
  if valid_589078 != nil:
    section.add "newLeaseSeconds", valid_589078
  var valid_589079 = query.getOrDefault("prettyPrint")
  valid_589079 = validateParameter(valid_589079, JBool, required = false,
                                 default = newJBool(true))
  if valid_589079 != nil:
    section.add "prettyPrint", valid_589079
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

proc call*(call_589081: Call_TaskqueueTasksUpdate_589066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tasks that are leased out of a TaskQueue.
  ## 
  let valid = call_589081.validator(path, query, header, formData, body)
  let scheme = call_589081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589081.url(scheme.get, call_589081.host, call_589081.base,
                         call_589081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589081, url, valid)

proc call*(call_589082: Call_TaskqueueTasksUpdate_589066; task: string;
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
  var path_589083 = newJObject()
  var query_589084 = newJObject()
  var body_589085 = newJObject()
  add(query_589084, "fields", newJString(fields))
  add(query_589084, "quotaUser", newJString(quotaUser))
  add(query_589084, "alt", newJString(alt))
  add(path_589083, "task", newJString(task))
  add(query_589084, "oauth_token", newJString(oauthToken))
  add(query_589084, "userIp", newJString(userIp))
  add(query_589084, "key", newJString(key))
  add(query_589084, "newLeaseSeconds", newJInt(newLeaseSeconds))
  add(path_589083, "project", newJString(project))
  if body != nil:
    body_589085 = body
  add(query_589084, "prettyPrint", newJBool(prettyPrint))
  add(path_589083, "taskqueue", newJString(taskqueue))
  result = call_589082.call(path_589083, query_589084, nil, nil, body_589085)

var taskqueueTasksUpdate* = Call_TaskqueueTasksUpdate_589066(
    name: "taskqueueTasksUpdate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksUpdate_589067,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksUpdate_589068,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksGet_589049 = ref object of OpenApiRestCall_588441
proc url_TaskqueueTasksGet_589051(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksGet_589050(path: JsonNode; query: JsonNode;
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
  var valid_589052 = path.getOrDefault("task")
  valid_589052 = validateParameter(valid_589052, JString, required = true,
                                 default = nil)
  if valid_589052 != nil:
    section.add "task", valid_589052
  var valid_589053 = path.getOrDefault("project")
  valid_589053 = validateParameter(valid_589053, JString, required = true,
                                 default = nil)
  if valid_589053 != nil:
    section.add "project", valid_589053
  var valid_589054 = path.getOrDefault("taskqueue")
  valid_589054 = validateParameter(valid_589054, JString, required = true,
                                 default = nil)
  if valid_589054 != nil:
    section.add "taskqueue", valid_589054
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
  var valid_589055 = query.getOrDefault("fields")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "fields", valid_589055
  var valid_589056 = query.getOrDefault("quotaUser")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "quotaUser", valid_589056
  var valid_589057 = query.getOrDefault("alt")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = newJString("json"))
  if valid_589057 != nil:
    section.add "alt", valid_589057
  var valid_589058 = query.getOrDefault("oauth_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "oauth_token", valid_589058
  var valid_589059 = query.getOrDefault("userIp")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "userIp", valid_589059
  var valid_589060 = query.getOrDefault("key")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "key", valid_589060
  var valid_589061 = query.getOrDefault("prettyPrint")
  valid_589061 = validateParameter(valid_589061, JBool, required = false,
                                 default = newJBool(true))
  if valid_589061 != nil:
    section.add "prettyPrint", valid_589061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589062: Call_TaskqueueTasksGet_589049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a particular task from a TaskQueue.
  ## 
  let valid = call_589062.validator(path, query, header, formData, body)
  let scheme = call_589062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589062.url(scheme.get, call_589062.host, call_589062.base,
                         call_589062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589062, url, valid)

proc call*(call_589063: Call_TaskqueueTasksGet_589049; task: string; project: string;
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
  var path_589064 = newJObject()
  var query_589065 = newJObject()
  add(query_589065, "fields", newJString(fields))
  add(query_589065, "quotaUser", newJString(quotaUser))
  add(query_589065, "alt", newJString(alt))
  add(path_589064, "task", newJString(task))
  add(query_589065, "oauth_token", newJString(oauthToken))
  add(query_589065, "userIp", newJString(userIp))
  add(query_589065, "key", newJString(key))
  add(path_589064, "project", newJString(project))
  add(query_589065, "prettyPrint", newJBool(prettyPrint))
  add(path_589064, "taskqueue", newJString(taskqueue))
  result = call_589063.call(path_589064, query_589065, nil, nil, nil)

var taskqueueTasksGet* = Call_TaskqueueTasksGet_589049(name: "taskqueueTasksGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksGet_589050,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksGet_589051,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksPatch_589103 = ref object of OpenApiRestCall_588441
proc url_TaskqueueTasksPatch_589105(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksPatch_589104(path: JsonNode; query: JsonNode;
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
  var valid_589106 = path.getOrDefault("task")
  valid_589106 = validateParameter(valid_589106, JString, required = true,
                                 default = nil)
  if valid_589106 != nil:
    section.add "task", valid_589106
  var valid_589107 = path.getOrDefault("project")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "project", valid_589107
  var valid_589108 = path.getOrDefault("taskqueue")
  valid_589108 = validateParameter(valid_589108, JString, required = true,
                                 default = nil)
  if valid_589108 != nil:
    section.add "taskqueue", valid_589108
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
  var valid_589109 = query.getOrDefault("fields")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "fields", valid_589109
  var valid_589110 = query.getOrDefault("quotaUser")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "quotaUser", valid_589110
  var valid_589111 = query.getOrDefault("alt")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("json"))
  if valid_589111 != nil:
    section.add "alt", valid_589111
  var valid_589112 = query.getOrDefault("oauth_token")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "oauth_token", valid_589112
  var valid_589113 = query.getOrDefault("userIp")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "userIp", valid_589113
  var valid_589114 = query.getOrDefault("key")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "key", valid_589114
  assert query != nil,
        "query argument is necessary due to required `newLeaseSeconds` field"
  var valid_589115 = query.getOrDefault("newLeaseSeconds")
  valid_589115 = validateParameter(valid_589115, JInt, required = true, default = nil)
  if valid_589115 != nil:
    section.add "newLeaseSeconds", valid_589115
  var valid_589116 = query.getOrDefault("prettyPrint")
  valid_589116 = validateParameter(valid_589116, JBool, required = false,
                                 default = newJBool(true))
  if valid_589116 != nil:
    section.add "prettyPrint", valid_589116
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

proc call*(call_589118: Call_TaskqueueTasksPatch_589103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tasks that are leased out of a TaskQueue. This method supports patch semantics.
  ## 
  let valid = call_589118.validator(path, query, header, formData, body)
  let scheme = call_589118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589118.url(scheme.get, call_589118.host, call_589118.base,
                         call_589118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589118, url, valid)

proc call*(call_589119: Call_TaskqueueTasksPatch_589103; task: string;
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
  var path_589120 = newJObject()
  var query_589121 = newJObject()
  var body_589122 = newJObject()
  add(query_589121, "fields", newJString(fields))
  add(query_589121, "quotaUser", newJString(quotaUser))
  add(query_589121, "alt", newJString(alt))
  add(path_589120, "task", newJString(task))
  add(query_589121, "oauth_token", newJString(oauthToken))
  add(query_589121, "userIp", newJString(userIp))
  add(query_589121, "key", newJString(key))
  add(query_589121, "newLeaseSeconds", newJInt(newLeaseSeconds))
  add(path_589120, "project", newJString(project))
  if body != nil:
    body_589122 = body
  add(query_589121, "prettyPrint", newJBool(prettyPrint))
  add(path_589120, "taskqueue", newJString(taskqueue))
  result = call_589119.call(path_589120, query_589121, nil, nil, body_589122)

var taskqueueTasksPatch* = Call_TaskqueueTasksPatch_589103(
    name: "taskqueueTasksPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksPatch_589104,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksPatch_589105,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksDelete_589086 = ref object of OpenApiRestCall_588441
proc url_TaskqueueTasksDelete_589088(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksDelete_589087(path: JsonNode; query: JsonNode;
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
  var valid_589089 = path.getOrDefault("task")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "task", valid_589089
  var valid_589090 = path.getOrDefault("project")
  valid_589090 = validateParameter(valid_589090, JString, required = true,
                                 default = nil)
  if valid_589090 != nil:
    section.add "project", valid_589090
  var valid_589091 = path.getOrDefault("taskqueue")
  valid_589091 = validateParameter(valid_589091, JString, required = true,
                                 default = nil)
  if valid_589091 != nil:
    section.add "taskqueue", valid_589091
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
  var valid_589092 = query.getOrDefault("fields")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "fields", valid_589092
  var valid_589093 = query.getOrDefault("quotaUser")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "quotaUser", valid_589093
  var valid_589094 = query.getOrDefault("alt")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = newJString("json"))
  if valid_589094 != nil:
    section.add "alt", valid_589094
  var valid_589095 = query.getOrDefault("oauth_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "oauth_token", valid_589095
  var valid_589096 = query.getOrDefault("userIp")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "userIp", valid_589096
  var valid_589097 = query.getOrDefault("key")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "key", valid_589097
  var valid_589098 = query.getOrDefault("prettyPrint")
  valid_589098 = validateParameter(valid_589098, JBool, required = false,
                                 default = newJBool(true))
  if valid_589098 != nil:
    section.add "prettyPrint", valid_589098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589099: Call_TaskqueueTasksDelete_589086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a task from a TaskQueue.
  ## 
  let valid = call_589099.validator(path, query, header, formData, body)
  let scheme = call_589099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589099.url(scheme.get, call_589099.host, call_589099.base,
                         call_589099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589099, url, valid)

proc call*(call_589100: Call_TaskqueueTasksDelete_589086; task: string;
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
  var path_589101 = newJObject()
  var query_589102 = newJObject()
  add(query_589102, "fields", newJString(fields))
  add(query_589102, "quotaUser", newJString(quotaUser))
  add(query_589102, "alt", newJString(alt))
  add(path_589101, "task", newJString(task))
  add(query_589102, "oauth_token", newJString(oauthToken))
  add(query_589102, "userIp", newJString(userIp))
  add(query_589102, "key", newJString(key))
  add(path_589101, "project", newJString(project))
  add(query_589102, "prettyPrint", newJBool(prettyPrint))
  add(path_589101, "taskqueue", newJString(taskqueue))
  result = call_589100.call(path_589101, query_589102, nil, nil, nil)

var taskqueueTasksDelete* = Call_TaskqueueTasksDelete_589086(
    name: "taskqueueTasksDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksDelete_589087,
    base: "/taskqueue/v1beta2/projects", url: url_TaskqueueTasksDelete_589088,
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
