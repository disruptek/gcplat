
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
  gcpServiceName = "taskqueue"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TaskqueueTaskqueuesGet_578609 = ref object of OpenApiRestCall_578339
proc url_TaskqueueTaskqueuesGet_578611(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTaskqueuesGet_578610(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get detailed information about a TaskQueue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   taskqueue: JString (required)
  ##            : The id of the taskqueue to get the properties of.
  ##   project: JString (required)
  ##          : The project under which the queue lies.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `taskqueue` field"
  var valid_578737 = path.getOrDefault("taskqueue")
  valid_578737 = validateParameter(valid_578737, JString, required = true,
                                 default = nil)
  if valid_578737 != nil:
    section.add "taskqueue", valid_578737
  var valid_578738 = path.getOrDefault("project")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "project", valid_578738
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   getStats: JBool
  ##           : Whether to get stats. Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("alt")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("json"))
  if valid_578755 != nil:
    section.add "alt", valid_578755
  var valid_578756 = query.getOrDefault("userIp")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "userIp", valid_578756
  var valid_578757 = query.getOrDefault("quotaUser")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "quotaUser", valid_578757
  var valid_578758 = query.getOrDefault("getStats")
  valid_578758 = validateParameter(valid_578758, JBool, required = false, default = nil)
  if valid_578758 != nil:
    section.add "getStats", valid_578758
  var valid_578759 = query.getOrDefault("fields")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "fields", valid_578759
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578782: Call_TaskqueueTaskqueuesGet_578609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get detailed information about a TaskQueue.
  ## 
  let valid = call_578782.validator(path, query, header, formData, body)
  let scheme = call_578782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578782.url(scheme.get, call_578782.host, call_578782.base,
                         call_578782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578782, url, valid)

proc call*(call_578853: Call_TaskqueueTaskqueuesGet_578609; taskqueue: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; getStats: bool = false; fields: string = ""): Recallable =
  ## taskqueueTaskqueuesGet
  ## Get detailed information about a TaskQueue.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   taskqueue: string (required)
  ##            : The id of the taskqueue to get the properties of.
  ##   getStats: bool
  ##           : Whether to get stats. Optional.
  ##   project: string (required)
  ##          : The project under which the queue lies.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578854 = newJObject()
  var query_578856 = newJObject()
  add(query_578856, "key", newJString(key))
  add(query_578856, "prettyPrint", newJBool(prettyPrint))
  add(query_578856, "oauth_token", newJString(oauthToken))
  add(query_578856, "alt", newJString(alt))
  add(query_578856, "userIp", newJString(userIp))
  add(query_578856, "quotaUser", newJString(quotaUser))
  add(path_578854, "taskqueue", newJString(taskqueue))
  add(query_578856, "getStats", newJBool(getStats))
  add(path_578854, "project", newJString(project))
  add(query_578856, "fields", newJString(fields))
  result = call_578853.call(path_578854, query_578856, nil, nil, nil)

var taskqueueTaskqueuesGet* = Call_TaskqueueTaskqueuesGet_578609(
    name: "taskqueueTaskqueuesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/taskqueues/{taskqueue}",
    validator: validate_TaskqueueTaskqueuesGet_578610,
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTaskqueuesGet_578611,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksList_578895 = ref object of OpenApiRestCall_578339
proc url_TaskqueueTasksList_578897(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksList_578896(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List Tasks in a TaskQueue
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   taskqueue: JString (required)
  ##            : The id of the taskqueue to list tasks from.
  ##   project: JString (required)
  ##          : The project under which the queue lies.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `taskqueue` field"
  var valid_578898 = path.getOrDefault("taskqueue")
  valid_578898 = validateParameter(valid_578898, JString, required = true,
                                 default = nil)
  if valid_578898 != nil:
    section.add "taskqueue", valid_578898
  var valid_578899 = path.getOrDefault("project")
  valid_578899 = validateParameter(valid_578899, JString, required = true,
                                 default = nil)
  if valid_578899 != nil:
    section.add "project", valid_578899
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578900 = query.getOrDefault("key")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "key", valid_578900
  var valid_578901 = query.getOrDefault("prettyPrint")
  valid_578901 = validateParameter(valid_578901, JBool, required = false,
                                 default = newJBool(true))
  if valid_578901 != nil:
    section.add "prettyPrint", valid_578901
  var valid_578902 = query.getOrDefault("oauth_token")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "oauth_token", valid_578902
  var valid_578903 = query.getOrDefault("alt")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = newJString("json"))
  if valid_578903 != nil:
    section.add "alt", valid_578903
  var valid_578904 = query.getOrDefault("userIp")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "userIp", valid_578904
  var valid_578905 = query.getOrDefault("quotaUser")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "quotaUser", valid_578905
  var valid_578906 = query.getOrDefault("fields")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "fields", valid_578906
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578907: Call_TaskqueueTasksList_578895; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Tasks in a TaskQueue
  ## 
  let valid = call_578907.validator(path, query, header, formData, body)
  let scheme = call_578907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578907.url(scheme.get, call_578907.host, call_578907.base,
                         call_578907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578907, url, valid)

proc call*(call_578908: Call_TaskqueueTasksList_578895; taskqueue: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## taskqueueTasksList
  ## List Tasks in a TaskQueue
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   taskqueue: string (required)
  ##            : The id of the taskqueue to list tasks from.
  ##   project: string (required)
  ##          : The project under which the queue lies.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578909 = newJObject()
  var query_578910 = newJObject()
  add(query_578910, "key", newJString(key))
  add(query_578910, "prettyPrint", newJBool(prettyPrint))
  add(query_578910, "oauth_token", newJString(oauthToken))
  add(query_578910, "alt", newJString(alt))
  add(query_578910, "userIp", newJString(userIp))
  add(query_578910, "quotaUser", newJString(quotaUser))
  add(path_578909, "taskqueue", newJString(taskqueue))
  add(path_578909, "project", newJString(project))
  add(query_578910, "fields", newJString(fields))
  result = call_578908.call(path_578909, query_578910, nil, nil, nil)

var taskqueueTasksList* = Call_TaskqueueTasksList_578895(
    name: "taskqueueTasksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/taskqueues/{taskqueue}/tasks",
    validator: validate_TaskqueueTasksList_578896,
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTasksList_578897,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksLease_578911 = ref object of OpenApiRestCall_578339
proc url_TaskqueueTasksLease_578913(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksLease_578912(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lease 1 or more tasks from a TaskQueue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   taskqueue: JString (required)
  ##            : The taskqueue to lease a task from.
  ##   project: JString (required)
  ##          : The project under which the queue lies.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `taskqueue` field"
  var valid_578914 = path.getOrDefault("taskqueue")
  valid_578914 = validateParameter(valid_578914, JString, required = true,
                                 default = nil)
  if valid_578914 != nil:
    section.add "taskqueue", valid_578914
  var valid_578915 = path.getOrDefault("project")
  valid_578915 = validateParameter(valid_578915, JString, required = true,
                                 default = nil)
  if valid_578915 != nil:
    section.add "project", valid_578915
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   leaseSecs: JInt (required)
  ##            : The lease in seconds.
  ##   numTasks: JInt (required)
  ##           : The number of tasks to lease.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578916 = query.getOrDefault("key")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "key", valid_578916
  var valid_578917 = query.getOrDefault("prettyPrint")
  valid_578917 = validateParameter(valid_578917, JBool, required = false,
                                 default = newJBool(true))
  if valid_578917 != nil:
    section.add "prettyPrint", valid_578917
  var valid_578918 = query.getOrDefault("oauth_token")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "oauth_token", valid_578918
  var valid_578919 = query.getOrDefault("alt")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = newJString("json"))
  if valid_578919 != nil:
    section.add "alt", valid_578919
  var valid_578920 = query.getOrDefault("userIp")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "userIp", valid_578920
  var valid_578921 = query.getOrDefault("quotaUser")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "quotaUser", valid_578921
  assert query != nil,
        "query argument is necessary due to required `leaseSecs` field"
  var valid_578922 = query.getOrDefault("leaseSecs")
  valid_578922 = validateParameter(valid_578922, JInt, required = true, default = nil)
  if valid_578922 != nil:
    section.add "leaseSecs", valid_578922
  var valid_578923 = query.getOrDefault("numTasks")
  valid_578923 = validateParameter(valid_578923, JInt, required = true, default = nil)
  if valid_578923 != nil:
    section.add "numTasks", valid_578923
  var valid_578924 = query.getOrDefault("fields")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "fields", valid_578924
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578925: Call_TaskqueueTasksLease_578911; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lease 1 or more tasks from a TaskQueue.
  ## 
  let valid = call_578925.validator(path, query, header, formData, body)
  let scheme = call_578925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578925.url(scheme.get, call_578925.host, call_578925.base,
                         call_578925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578925, url, valid)

proc call*(call_578926: Call_TaskqueueTasksLease_578911; taskqueue: string;
          leaseSecs: int; numTasks: int; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## taskqueueTasksLease
  ## Lease 1 or more tasks from a TaskQueue.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   taskqueue: string (required)
  ##            : The taskqueue to lease a task from.
  ##   leaseSecs: int (required)
  ##            : The lease in seconds.
  ##   numTasks: int (required)
  ##           : The number of tasks to lease.
  ##   project: string (required)
  ##          : The project under which the queue lies.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578927 = newJObject()
  var query_578928 = newJObject()
  add(query_578928, "key", newJString(key))
  add(query_578928, "prettyPrint", newJBool(prettyPrint))
  add(query_578928, "oauth_token", newJString(oauthToken))
  add(query_578928, "alt", newJString(alt))
  add(query_578928, "userIp", newJString(userIp))
  add(query_578928, "quotaUser", newJString(quotaUser))
  add(path_578927, "taskqueue", newJString(taskqueue))
  add(query_578928, "leaseSecs", newJInt(leaseSecs))
  add(query_578928, "numTasks", newJInt(numTasks))
  add(path_578927, "project", newJString(project))
  add(query_578928, "fields", newJString(fields))
  result = call_578926.call(path_578927, query_578928, nil, nil, nil)

var taskqueueTasksLease* = Call_TaskqueueTasksLease_578911(
    name: "taskqueueTasksLease", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/lease",
    validator: validate_TaskqueueTasksLease_578912,
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTasksLease_578913,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksGet_578929 = ref object of OpenApiRestCall_578339
proc url_TaskqueueTasksGet_578931(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksGet_578930(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get a particular task from a TaskQueue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   taskqueue: JString (required)
  ##            : The taskqueue in which the task belongs.
  ##   project: JString (required)
  ##          : The project under which the queue lies.
  ##   task: JString (required)
  ##       : The task to get properties of.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `taskqueue` field"
  var valid_578932 = path.getOrDefault("taskqueue")
  valid_578932 = validateParameter(valid_578932, JString, required = true,
                                 default = nil)
  if valid_578932 != nil:
    section.add "taskqueue", valid_578932
  var valid_578933 = path.getOrDefault("project")
  valid_578933 = validateParameter(valid_578933, JString, required = true,
                                 default = nil)
  if valid_578933 != nil:
    section.add "project", valid_578933
  var valid_578934 = path.getOrDefault("task")
  valid_578934 = validateParameter(valid_578934, JString, required = true,
                                 default = nil)
  if valid_578934 != nil:
    section.add "task", valid_578934
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578935 = query.getOrDefault("key")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "key", valid_578935
  var valid_578936 = query.getOrDefault("prettyPrint")
  valid_578936 = validateParameter(valid_578936, JBool, required = false,
                                 default = newJBool(true))
  if valid_578936 != nil:
    section.add "prettyPrint", valid_578936
  var valid_578937 = query.getOrDefault("oauth_token")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "oauth_token", valid_578937
  var valid_578938 = query.getOrDefault("alt")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("json"))
  if valid_578938 != nil:
    section.add "alt", valid_578938
  var valid_578939 = query.getOrDefault("userIp")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "userIp", valid_578939
  var valid_578940 = query.getOrDefault("quotaUser")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "quotaUser", valid_578940
  var valid_578941 = query.getOrDefault("fields")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "fields", valid_578941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578942: Call_TaskqueueTasksGet_578929; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a particular task from a TaskQueue.
  ## 
  let valid = call_578942.validator(path, query, header, formData, body)
  let scheme = call_578942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578942.url(scheme.get, call_578942.host, call_578942.base,
                         call_578942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578942, url, valid)

proc call*(call_578943: Call_TaskqueueTasksGet_578929; taskqueue: string;
          project: string; task: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## taskqueueTasksGet
  ## Get a particular task from a TaskQueue.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   taskqueue: string (required)
  ##            : The taskqueue in which the task belongs.
  ##   project: string (required)
  ##          : The project under which the queue lies.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   task: string (required)
  ##       : The task to get properties of.
  var path_578944 = newJObject()
  var query_578945 = newJObject()
  add(query_578945, "key", newJString(key))
  add(query_578945, "prettyPrint", newJBool(prettyPrint))
  add(query_578945, "oauth_token", newJString(oauthToken))
  add(query_578945, "alt", newJString(alt))
  add(query_578945, "userIp", newJString(userIp))
  add(query_578945, "quotaUser", newJString(quotaUser))
  add(path_578944, "taskqueue", newJString(taskqueue))
  add(path_578944, "project", newJString(project))
  add(query_578945, "fields", newJString(fields))
  add(path_578944, "task", newJString(task))
  result = call_578943.call(path_578944, query_578945, nil, nil, nil)

var taskqueueTasksGet* = Call_TaskqueueTasksGet_578929(name: "taskqueueTasksGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksGet_578930,
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTasksGet_578931,
    schemes: {Scheme.Https})
type
  Call_TaskqueueTasksDelete_578946 = ref object of OpenApiRestCall_578339
proc url_TaskqueueTasksDelete_578948(protocol: Scheme; host: string; base: string;
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

proc validate_TaskqueueTasksDelete_578947(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a task from a TaskQueue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   taskqueue: JString (required)
  ##            : The taskqueue to delete a task from.
  ##   project: JString (required)
  ##          : The project under which the queue lies.
  ##   task: JString (required)
  ##       : The id of the task to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `taskqueue` field"
  var valid_578949 = path.getOrDefault("taskqueue")
  valid_578949 = validateParameter(valid_578949, JString, required = true,
                                 default = nil)
  if valid_578949 != nil:
    section.add "taskqueue", valid_578949
  var valid_578950 = path.getOrDefault("project")
  valid_578950 = validateParameter(valid_578950, JString, required = true,
                                 default = nil)
  if valid_578950 != nil:
    section.add "project", valid_578950
  var valid_578951 = path.getOrDefault("task")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "task", valid_578951
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578952 = query.getOrDefault("key")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "key", valid_578952
  var valid_578953 = query.getOrDefault("prettyPrint")
  valid_578953 = validateParameter(valid_578953, JBool, required = false,
                                 default = newJBool(true))
  if valid_578953 != nil:
    section.add "prettyPrint", valid_578953
  var valid_578954 = query.getOrDefault("oauth_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "oauth_token", valid_578954
  var valid_578955 = query.getOrDefault("alt")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = newJString("json"))
  if valid_578955 != nil:
    section.add "alt", valid_578955
  var valid_578956 = query.getOrDefault("userIp")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "userIp", valid_578956
  var valid_578957 = query.getOrDefault("quotaUser")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "quotaUser", valid_578957
  var valid_578958 = query.getOrDefault("fields")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "fields", valid_578958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578959: Call_TaskqueueTasksDelete_578946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a task from a TaskQueue.
  ## 
  let valid = call_578959.validator(path, query, header, formData, body)
  let scheme = call_578959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578959.url(scheme.get, call_578959.host, call_578959.base,
                         call_578959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578959, url, valid)

proc call*(call_578960: Call_TaskqueueTasksDelete_578946; taskqueue: string;
          project: string; task: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## taskqueueTasksDelete
  ## Delete a task from a TaskQueue.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   taskqueue: string (required)
  ##            : The taskqueue to delete a task from.
  ##   project: string (required)
  ##          : The project under which the queue lies.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   task: string (required)
  ##       : The id of the task to delete.
  var path_578961 = newJObject()
  var query_578962 = newJObject()
  add(query_578962, "key", newJString(key))
  add(query_578962, "prettyPrint", newJBool(prettyPrint))
  add(query_578962, "oauth_token", newJString(oauthToken))
  add(query_578962, "alt", newJString(alt))
  add(query_578962, "userIp", newJString(userIp))
  add(query_578962, "quotaUser", newJString(quotaUser))
  add(path_578961, "taskqueue", newJString(taskqueue))
  add(path_578961, "project", newJString(project))
  add(query_578962, "fields", newJString(fields))
  add(path_578961, "task", newJString(task))
  result = call_578960.call(path_578961, query_578962, nil, nil, nil)

var taskqueueTasksDelete* = Call_TaskqueueTasksDelete_578946(
    name: "taskqueueTasksDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/taskqueues/{taskqueue}/tasks/{task}",
    validator: validate_TaskqueueTasksDelete_578947,
    base: "/taskqueue/v1beta1/projects", url: url_TaskqueueTasksDelete_578948,
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
