
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTaskqueuesGet_588711,
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
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTasksList_588997,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksLease_589011 = ref object of OpenApiRestCall_588441
proc url_TaskqueueTasksLease_589013(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksLease_589012(path: JsonNode; query: JsonNode;
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
  ##   leaseSecs: JInt (required)
  ##            : The lease in seconds.
  ##   numTasks: JInt (required)
  ##           : The number of tasks to lease.
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
  assert query != nil,
        "query argument is necessary due to required `leaseSecs` field"
  var valid_589022 = query.getOrDefault("leaseSecs")
  valid_589022 = validateParameter(valid_589022, JInt, required = true, default = nil)
  if valid_589022 != nil:
    section.add "leaseSecs", valid_589022
  var valid_589023 = query.getOrDefault("numTasks")
  valid_589023 = validateParameter(valid_589023, JInt, required = true, default = nil)
  if valid_589023 != nil:
    section.add "numTasks", valid_589023
  var valid_589024 = query.getOrDefault("prettyPrint")
  valid_589024 = validateParameter(valid_589024, JBool, required = false,
                                 default = newJBool(true))
  if valid_589024 != nil:
    section.add "prettyPrint", valid_589024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589025: Call_TaskqueueTasksLease_589011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lease 1 or more tasks from a TaskQueue.
  ## 
  let valid = call_589025.validator(path, query, header, formData, body)
  let scheme = call_589025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589025.url(scheme.get, call_589025.host, call_589025.base,
                         call_589025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589025, url, valid)

proc call*(call_589026: Call_TaskqueueTasksLease_589011; leaseSecs: int;
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
  var path_589027 = newJObject()
  var query_589028 = newJObject()
  add(query_589028, "fields", newJString(fields))
  add(query_589028, "quotaUser", newJString(quotaUser))
  add(query_589028, "alt", newJString(alt))
  add(query_589028, "oauth_token", newJString(oauthToken))
  add(query_589028, "userIp", newJString(userIp))
  add(query_589028, "key", newJString(key))
  add(query_589028, "leaseSecs", newJInt(leaseSecs))
  add(path_589027, "project", newJString(project))
  add(query_589028, "numTasks", newJInt(numTasks))
  add(query_589028, "prettyPrint", newJBool(prettyPrint))
  add(path_589027, "taskqueue", newJString(taskqueue))
  result = call_589026.call(path_589027, query_589028, nil, nil, nil)

var taskqueueTasksLease* = Call_TaskqueueTasksLease_589011(
    name: "taskqueueTasksLease", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/lease",
    validator: validate_TaskqueueTasksLease_589012,
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTasksLease_589013,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksGet_589029 = ref object of OpenApiRestCall_588441
proc url_TaskqueueTasksGet_589031(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksGet_589030(path: JsonNode; query: JsonNode;
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
  var valid_589032 = path.getOrDefault("task")
  valid_589032 = validateParameter(valid_589032, JString, required = true,
                                 default = nil)
  if valid_589032 != nil:
    section.add "task", valid_589032
  var valid_589033 = path.getOrDefault("project")
  valid_589033 = validateParameter(valid_589033, JString, required = true,
                                 default = nil)
  if valid_589033 != nil:
    section.add "project", valid_589033
  var valid_589034 = path.getOrDefault("taskqueue")
  valid_589034 = validateParameter(valid_589034, JString, required = true,
                                 default = nil)
  if valid_589034 != nil:
    section.add "taskqueue", valid_589034
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
  var valid_589041 = query.getOrDefault("prettyPrint")
  valid_589041 = validateParameter(valid_589041, JBool, required = false,
                                 default = newJBool(true))
  if valid_589041 != nil:
    section.add "prettyPrint", valid_589041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589042: Call_TaskqueueTasksGet_589029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a particular task from a TaskQueue.
  ## 
  let valid = call_589042.validator(path, query, header, formData, body)
  let scheme = call_589042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589042.url(scheme.get, call_589042.host, call_589042.base,
                         call_589042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589042, url, valid)

proc call*(call_589043: Call_TaskqueueTasksGet_589029; task: string; project: string;
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
  var path_589044 = newJObject()
  var query_589045 = newJObject()
  add(query_589045, "fields", newJString(fields))
  add(query_589045, "quotaUser", newJString(quotaUser))
  add(query_589045, "alt", newJString(alt))
  add(path_589044, "task", newJString(task))
  add(query_589045, "oauth_token", newJString(oauthToken))
  add(query_589045, "userIp", newJString(userIp))
  add(query_589045, "key", newJString(key))
  add(path_589044, "project", newJString(project))
  add(query_589045, "prettyPrint", newJBool(prettyPrint))
  add(path_589044, "taskqueue", newJString(taskqueue))
  result = call_589043.call(path_589044, query_589045, nil, nil, nil)

var taskqueueTasksGet* = Call_TaskqueueTasksGet_589029(name: "taskqueueTasksGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksGet_589030,
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTasksGet_589031,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksDelete_589046 = ref object of OpenApiRestCall_588441
proc url_TaskqueueTasksDelete_589048(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksDelete_589047(path: JsonNode; query: JsonNode;
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
  var valid_589049 = path.getOrDefault("task")
  valid_589049 = validateParameter(valid_589049, JString, required = true,
                                 default = nil)
  if valid_589049 != nil:
    section.add "task", valid_589049
  var valid_589050 = path.getOrDefault("project")
  valid_589050 = validateParameter(valid_589050, JString, required = true,
                                 default = nil)
  if valid_589050 != nil:
    section.add "project", valid_589050
  var valid_589051 = path.getOrDefault("taskqueue")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "taskqueue", valid_589051
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
  var valid_589052 = query.getOrDefault("fields")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "fields", valid_589052
  var valid_589053 = query.getOrDefault("quotaUser")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "quotaUser", valid_589053
  var valid_589054 = query.getOrDefault("alt")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("json"))
  if valid_589054 != nil:
    section.add "alt", valid_589054
  var valid_589055 = query.getOrDefault("oauth_token")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "oauth_token", valid_589055
  var valid_589056 = query.getOrDefault("userIp")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "userIp", valid_589056
  var valid_589057 = query.getOrDefault("key")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "key", valid_589057
  var valid_589058 = query.getOrDefault("prettyPrint")
  valid_589058 = validateParameter(valid_589058, JBool, required = false,
                                 default = newJBool(true))
  if valid_589058 != nil:
    section.add "prettyPrint", valid_589058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589059: Call_TaskqueueTasksDelete_589046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a task from a TaskQueue.
  ## 
  let valid = call_589059.validator(path, query, header, formData, body)
  let scheme = call_589059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589059.url(scheme.get, call_589059.host, call_589059.base,
                         call_589059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589059, url, valid)

proc call*(call_589060: Call_TaskqueueTasksDelete_589046; task: string;
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
  var path_589061 = newJObject()
  var query_589062 = newJObject()
  add(query_589062, "fields", newJString(fields))
  add(query_589062, "quotaUser", newJString(quotaUser))
  add(query_589062, "alt", newJString(alt))
  add(path_589061, "task", newJString(task))
  add(query_589062, "oauth_token", newJString(oauthToken))
  add(query_589062, "userIp", newJString(userIp))
  add(query_589062, "key", newJString(key))
  add(path_589061, "project", newJString(project))
  add(query_589062, "prettyPrint", newJBool(prettyPrint))
  add(path_589061, "taskqueue", newJString(taskqueue))
  result = call_589060.call(path_589061, query_589062, nil, nil, nil)

var taskqueueTasksDelete* = Call_TaskqueueTasksDelete_589046(
    name: "taskqueueTasksDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksDelete_589047,
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTasksDelete_589048,
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
