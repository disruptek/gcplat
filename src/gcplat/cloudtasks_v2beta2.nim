
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Tasks
## version: v2beta2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages the execution of large numbers of distributed requests.
## 
## https://cloud.google.com/tasks/
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
  gcpServiceName = "cloudtasks"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudtasksProjectsLocationsQueuesTasksGet_578610 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesTasksGet_578612(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksGet_578611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   responseView: JString
  ##               : The response_view specifies which subset of the Task will be
  ## returned.
  ## 
  ## By default response_view is BASIC; not all
  ## information is retrieved by default because some data, such as
  ## payloads, might be desirable to return only when needed because
  ## of its large size or because of the sensitivity of data that it
  ## contains.
  ## 
  ## Authorization for FULL requires
  ## `cloudtasks.tasks.fullView` [Google IAM](https://cloud.google.com/iam/)
  ## permission on the Task resource.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
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
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("responseView")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_578756 != nil:
    section.add "responseView", valid_578756
  var valid_578757 = query.getOrDefault("alt")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = newJString("json"))
  if valid_578757 != nil:
    section.add "alt", valid_578757
  var valid_578758 = query.getOrDefault("uploadType")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "uploadType", valid_578758
  var valid_578759 = query.getOrDefault("quotaUser")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "quotaUser", valid_578759
  var valid_578760 = query.getOrDefault("callback")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "callback", valid_578760
  var valid_578761 = query.getOrDefault("fields")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "fields", valid_578761
  var valid_578762 = query.getOrDefault("access_token")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "access_token", valid_578762
  var valid_578763 = query.getOrDefault("upload_protocol")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "upload_protocol", valid_578763
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578786: Call_CloudtasksProjectsLocationsQueuesTasksGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a task.
  ## 
  let valid = call_578786.validator(path, query, header, formData, body)
  let scheme = call_578786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578786.url(scheme.get, call_578786.host, call_578786.base,
                         call_578786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578786, url, valid)

proc call*(call_578857: Call_CloudtasksProjectsLocationsQueuesTasksGet_578610;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          responseView: string = "VIEW_UNSPECIFIED"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksGet
  ## Gets a task.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   responseView: string
  ##               : The response_view specifies which subset of the Task will be
  ## returned.
  ## 
  ## By default response_view is BASIC; not all
  ## information is retrieved by default because some data, such as
  ## payloads, might be desirable to return only when needed because
  ## of its large size or because of the sensitivity of data that it
  ## contains.
  ## 
  ## Authorization for FULL requires
  ## `cloudtasks.tasks.fullView` [Google IAM](https://cloud.google.com/iam/)
  ## permission on the Task resource.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578858 = newJObject()
  var query_578860 = newJObject()
  add(query_578860, "key", newJString(key))
  add(query_578860, "prettyPrint", newJBool(prettyPrint))
  add(query_578860, "oauth_token", newJString(oauthToken))
  add(query_578860, "$.xgafv", newJString(Xgafv))
  add(query_578860, "responseView", newJString(responseView))
  add(query_578860, "alt", newJString(alt))
  add(query_578860, "uploadType", newJString(uploadType))
  add(query_578860, "quotaUser", newJString(quotaUser))
  add(path_578858, "name", newJString(name))
  add(query_578860, "callback", newJString(callback))
  add(query_578860, "fields", newJString(fields))
  add(query_578860, "access_token", newJString(accessToken))
  add(query_578860, "upload_protocol", newJString(uploadProtocol))
  result = call_578857.call(path_578858, query_578860, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesTasksGet* = Call_CloudtasksProjectsLocationsQueuesTasksGet_578610(
    name: "cloudtasksProjectsLocationsQueuesTasksGet", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksGet_578611,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksGet_578612,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesPatch_578918 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesPatch_578920(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesPatch_578919(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a queue.
  ## 
  ## This method creates the queue if it does not exist and updates
  ## the queue if it does exist.
  ## 
  ## Queues created with this method allow tasks to live for a maximum of 31
  ## days. After a task is 31 days old, the task will be deleted regardless of whether
  ## it was dispatched or not.
  ## 
  ## WARNING: Using this method may have unintended side effects if you are
  ## using an App Engine `queue.yaml` or `queue.xml` file to manage your queues.
  ## Read
  ## [Overview of Queue Management and
  ## queue.yaml](https://cloud.google.com/tasks/docs/queue-yaml) before using
  ## this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Caller-specified and required in CreateQueue,
  ## after which it becomes output only.
  ## 
  ## The queue name.
  ## 
  ## The queue name must have the following format:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID`
  ## 
  ## * `PROJECT_ID` can contain letters ([A-Za-z]), numbers ([0-9]),
  ##    hyphens (-), colons (:), or periods (.).
  ##    For more information, see
  ##    [Identifying
  ##    
  ## projects](https://cloud.google.com/resource-manager/docs/creating-managing-projects#identifying_projects)
  ## * `LOCATION_ID` is the canonical ID for the queue's location.
  ##    The list of available locations can be obtained by calling
  ##    ListLocations.
  ##    For more information, see https://cloud.google.com/about/locations/.
  ## * `QUEUE_ID` can contain letters ([A-Za-z]), numbers ([0-9]), or
  ##   hyphens (-). The maximum length is 100 characters.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578921 = path.getOrDefault("name")
  valid_578921 = validateParameter(valid_578921, JString, required = true,
                                 default = nil)
  if valid_578921 != nil:
    section.add "name", valid_578921
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : A mask used to specify which fields of the queue are being updated.
  ## 
  ## If empty, then all fields will be updated.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
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
  var valid_578925 = query.getOrDefault("$.xgafv")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = newJString("1"))
  if valid_578925 != nil:
    section.add "$.xgafv", valid_578925
  var valid_578926 = query.getOrDefault("alt")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("json"))
  if valid_578926 != nil:
    section.add "alt", valid_578926
  var valid_578927 = query.getOrDefault("uploadType")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "uploadType", valid_578927
  var valid_578928 = query.getOrDefault("quotaUser")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "quotaUser", valid_578928
  var valid_578929 = query.getOrDefault("updateMask")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "updateMask", valid_578929
  var valid_578930 = query.getOrDefault("callback")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "callback", valid_578930
  var valid_578931 = query.getOrDefault("fields")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "fields", valid_578931
  var valid_578932 = query.getOrDefault("access_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "access_token", valid_578932
  var valid_578933 = query.getOrDefault("upload_protocol")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "upload_protocol", valid_578933
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

proc call*(call_578935: Call_CloudtasksProjectsLocationsQueuesPatch_578918;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a queue.
  ## 
  ## This method creates the queue if it does not exist and updates
  ## the queue if it does exist.
  ## 
  ## Queues created with this method allow tasks to live for a maximum of 31
  ## days. After a task is 31 days old, the task will be deleted regardless of whether
  ## it was dispatched or not.
  ## 
  ## WARNING: Using this method may have unintended side effects if you are
  ## using an App Engine `queue.yaml` or `queue.xml` file to manage your queues.
  ## Read
  ## [Overview of Queue Management and
  ## queue.yaml](https://cloud.google.com/tasks/docs/queue-yaml) before using
  ## this method.
  ## 
  let valid = call_578935.validator(path, query, header, formData, body)
  let scheme = call_578935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578935.url(scheme.get, call_578935.host, call_578935.base,
                         call_578935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578935, url, valid)

proc call*(call_578936: Call_CloudtasksProjectsLocationsQueuesPatch_578918;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesPatch
  ## Updates a queue.
  ## 
  ## This method creates the queue if it does not exist and updates
  ## the queue if it does exist.
  ## 
  ## Queues created with this method allow tasks to live for a maximum of 31
  ## days. After a task is 31 days old, the task will be deleted regardless of whether
  ## it was dispatched or not.
  ## 
  ## WARNING: Using this method may have unintended side effects if you are
  ## using an App Engine `queue.yaml` or `queue.xml` file to manage your queues.
  ## Read
  ## [Overview of Queue Management and
  ## queue.yaml](https://cloud.google.com/tasks/docs/queue-yaml) before using
  ## this method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Caller-specified and required in CreateQueue,
  ## after which it becomes output only.
  ## 
  ## The queue name.
  ## 
  ## The queue name must have the following format:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID`
  ## 
  ## * `PROJECT_ID` can contain letters ([A-Za-z]), numbers ([0-9]),
  ##    hyphens (-), colons (:), or periods (.).
  ##    For more information, see
  ##    [Identifying
  ##    
  ## projects](https://cloud.google.com/resource-manager/docs/creating-managing-projects#identifying_projects)
  ## * `LOCATION_ID` is the canonical ID for the queue's location.
  ##    The list of available locations can be obtained by calling
  ##    ListLocations.
  ##    For more information, see https://cloud.google.com/about/locations/.
  ## * `QUEUE_ID` can contain letters ([A-Za-z]), numbers ([0-9]), or
  ##   hyphens (-). The maximum length is 100 characters.
  ##   updateMask: string
  ##             : A mask used to specify which fields of the queue are being updated.
  ## 
  ## If empty, then all fields will be updated.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578937 = newJObject()
  var query_578938 = newJObject()
  var body_578939 = newJObject()
  add(query_578938, "key", newJString(key))
  add(query_578938, "prettyPrint", newJBool(prettyPrint))
  add(query_578938, "oauth_token", newJString(oauthToken))
  add(query_578938, "$.xgafv", newJString(Xgafv))
  add(query_578938, "alt", newJString(alt))
  add(query_578938, "uploadType", newJString(uploadType))
  add(query_578938, "quotaUser", newJString(quotaUser))
  add(path_578937, "name", newJString(name))
  add(query_578938, "updateMask", newJString(updateMask))
  if body != nil:
    body_578939 = body
  add(query_578938, "callback", newJString(callback))
  add(query_578938, "fields", newJString(fields))
  add(query_578938, "access_token", newJString(accessToken))
  add(query_578938, "upload_protocol", newJString(uploadProtocol))
  result = call_578936.call(path_578937, query_578938, nil, nil, body_578939)

var cloudtasksProjectsLocationsQueuesPatch* = Call_CloudtasksProjectsLocationsQueuesPatch_578918(
    name: "cloudtasksProjectsLocationsQueuesPatch", meth: HttpMethod.HttpPatch,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}",
    validator: validate_CloudtasksProjectsLocationsQueuesPatch_578919, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesPatch_578920,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksDelete_578899 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesTasksDelete_578901(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksDelete_578900(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a task.
  ## 
  ## A task can be deleted if it is scheduled or dispatched. A task
  ## cannot be deleted if it has completed successfully or permanently
  ## failed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578902 = path.getOrDefault("name")
  valid_578902 = validateParameter(valid_578902, JString, required = true,
                                 default = nil)
  if valid_578902 != nil:
    section.add "name", valid_578902
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578903 = query.getOrDefault("key")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "key", valid_578903
  var valid_578904 = query.getOrDefault("prettyPrint")
  valid_578904 = validateParameter(valid_578904, JBool, required = false,
                                 default = newJBool(true))
  if valid_578904 != nil:
    section.add "prettyPrint", valid_578904
  var valid_578905 = query.getOrDefault("oauth_token")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "oauth_token", valid_578905
  var valid_578906 = query.getOrDefault("$.xgafv")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("1"))
  if valid_578906 != nil:
    section.add "$.xgafv", valid_578906
  var valid_578907 = query.getOrDefault("alt")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = newJString("json"))
  if valid_578907 != nil:
    section.add "alt", valid_578907
  var valid_578908 = query.getOrDefault("uploadType")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "uploadType", valid_578908
  var valid_578909 = query.getOrDefault("quotaUser")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "quotaUser", valid_578909
  var valid_578910 = query.getOrDefault("callback")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "callback", valid_578910
  var valid_578911 = query.getOrDefault("fields")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "fields", valid_578911
  var valid_578912 = query.getOrDefault("access_token")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "access_token", valid_578912
  var valid_578913 = query.getOrDefault("upload_protocol")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "upload_protocol", valid_578913
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578914: Call_CloudtasksProjectsLocationsQueuesTasksDelete_578899;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a task.
  ## 
  ## A task can be deleted if it is scheduled or dispatched. A task
  ## cannot be deleted if it has completed successfully or permanently
  ## failed.
  ## 
  let valid = call_578914.validator(path, query, header, formData, body)
  let scheme = call_578914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578914.url(scheme.get, call_578914.host, call_578914.base,
                         call_578914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578914, url, valid)

proc call*(call_578915: Call_CloudtasksProjectsLocationsQueuesTasksDelete_578899;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksDelete
  ## Deletes a task.
  ## 
  ## A task can be deleted if it is scheduled or dispatched. A task
  ## cannot be deleted if it has completed successfully or permanently
  ## failed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578916 = newJObject()
  var query_578917 = newJObject()
  add(query_578917, "key", newJString(key))
  add(query_578917, "prettyPrint", newJBool(prettyPrint))
  add(query_578917, "oauth_token", newJString(oauthToken))
  add(query_578917, "$.xgafv", newJString(Xgafv))
  add(query_578917, "alt", newJString(alt))
  add(query_578917, "uploadType", newJString(uploadType))
  add(query_578917, "quotaUser", newJString(quotaUser))
  add(path_578916, "name", newJString(name))
  add(query_578917, "callback", newJString(callback))
  add(query_578917, "fields", newJString(fields))
  add(query_578917, "access_token", newJString(accessToken))
  add(query_578917, "upload_protocol", newJString(uploadProtocol))
  result = call_578915.call(path_578916, query_578917, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesTasksDelete* = Call_CloudtasksProjectsLocationsQueuesTasksDelete_578899(
    name: "cloudtasksProjectsLocationsQueuesTasksDelete",
    meth: HttpMethod.HttpDelete, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{name}",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksDelete_578900,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksDelete_578901,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsList_578940 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsList_578942(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsList_578941(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578943 = path.getOrDefault("name")
  valid_578943 = validateParameter(valid_578943, JString, required = true,
                                 default = nil)
  if valid_578943 != nil:
    section.add "name", valid_578943
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
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
  var valid_578947 = query.getOrDefault("$.xgafv")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = newJString("1"))
  if valid_578947 != nil:
    section.add "$.xgafv", valid_578947
  var valid_578948 = query.getOrDefault("pageSize")
  valid_578948 = validateParameter(valid_578948, JInt, required = false, default = nil)
  if valid_578948 != nil:
    section.add "pageSize", valid_578948
  var valid_578949 = query.getOrDefault("alt")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("json"))
  if valid_578949 != nil:
    section.add "alt", valid_578949
  var valid_578950 = query.getOrDefault("uploadType")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "uploadType", valid_578950
  var valid_578951 = query.getOrDefault("quotaUser")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "quotaUser", valid_578951
  var valid_578952 = query.getOrDefault("filter")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "filter", valid_578952
  var valid_578953 = query.getOrDefault("pageToken")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "pageToken", valid_578953
  var valid_578954 = query.getOrDefault("callback")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "callback", valid_578954
  var valid_578955 = query.getOrDefault("fields")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "fields", valid_578955
  var valid_578956 = query.getOrDefault("access_token")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "access_token", valid_578956
  var valid_578957 = query.getOrDefault("upload_protocol")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "upload_protocol", valid_578957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578958: Call_CloudtasksProjectsLocationsList_578940;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_578958.validator(path, query, header, formData, body)
  let scheme = call_578958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578958.url(scheme.get, call_578958.host, call_578958.base,
                         call_578958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578958, url, valid)

proc call*(call_578959: Call_CloudtasksProjectsLocationsList_578940; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578960 = newJObject()
  var query_578961 = newJObject()
  add(query_578961, "key", newJString(key))
  add(query_578961, "prettyPrint", newJBool(prettyPrint))
  add(query_578961, "oauth_token", newJString(oauthToken))
  add(query_578961, "$.xgafv", newJString(Xgafv))
  add(query_578961, "pageSize", newJInt(pageSize))
  add(query_578961, "alt", newJString(alt))
  add(query_578961, "uploadType", newJString(uploadType))
  add(query_578961, "quotaUser", newJString(quotaUser))
  add(path_578960, "name", newJString(name))
  add(query_578961, "filter", newJString(filter))
  add(query_578961, "pageToken", newJString(pageToken))
  add(query_578961, "callback", newJString(callback))
  add(query_578961, "fields", newJString(fields))
  add(query_578961, "access_token", newJString(accessToken))
  add(query_578961, "upload_protocol", newJString(uploadProtocol))
  result = call_578959.call(path_578960, query_578961, nil, nil, nil)

var cloudtasksProjectsLocationsList* = Call_CloudtasksProjectsLocationsList_578940(
    name: "cloudtasksProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}/locations",
    validator: validate_CloudtasksProjectsLocationsList_578941, base: "/",
    url: url_CloudtasksProjectsLocationsList_578942, schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksAcknowledge_578962 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesTasksAcknowledge_578964(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":acknowledge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksAcknowledge_578963(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Acknowledges a pull task.
  ## 
  ## The worker, that is, the entity that
  ## leased this task must call this method
  ## to indicate that the work associated with the task has finished.
  ## 
  ## The worker must acknowledge a task within the
  ## lease_duration or the lease
  ## will expire and the task will become available to be leased
  ## again. After the task is acknowledged, it will not be returned
  ## by a later LeaseTasks,
  ## GetTask, or
  ## ListTasks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578965 = path.getOrDefault("name")
  valid_578965 = validateParameter(valid_578965, JString, required = true,
                                 default = nil)
  if valid_578965 != nil:
    section.add "name", valid_578965
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578966 = query.getOrDefault("key")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "key", valid_578966
  var valid_578967 = query.getOrDefault("prettyPrint")
  valid_578967 = validateParameter(valid_578967, JBool, required = false,
                                 default = newJBool(true))
  if valid_578967 != nil:
    section.add "prettyPrint", valid_578967
  var valid_578968 = query.getOrDefault("oauth_token")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "oauth_token", valid_578968
  var valid_578969 = query.getOrDefault("$.xgafv")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = newJString("1"))
  if valid_578969 != nil:
    section.add "$.xgafv", valid_578969
  var valid_578970 = query.getOrDefault("alt")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = newJString("json"))
  if valid_578970 != nil:
    section.add "alt", valid_578970
  var valid_578971 = query.getOrDefault("uploadType")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "uploadType", valid_578971
  var valid_578972 = query.getOrDefault("quotaUser")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "quotaUser", valid_578972
  var valid_578973 = query.getOrDefault("callback")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "callback", valid_578973
  var valid_578974 = query.getOrDefault("fields")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "fields", valid_578974
  var valid_578975 = query.getOrDefault("access_token")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "access_token", valid_578975
  var valid_578976 = query.getOrDefault("upload_protocol")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "upload_protocol", valid_578976
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

proc call*(call_578978: Call_CloudtasksProjectsLocationsQueuesTasksAcknowledge_578962;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges a pull task.
  ## 
  ## The worker, that is, the entity that
  ## leased this task must call this method
  ## to indicate that the work associated with the task has finished.
  ## 
  ## The worker must acknowledge a task within the
  ## lease_duration or the lease
  ## will expire and the task will become available to be leased
  ## again. After the task is acknowledged, it will not be returned
  ## by a later LeaseTasks,
  ## GetTask, or
  ## ListTasks.
  ## 
  let valid = call_578978.validator(path, query, header, formData, body)
  let scheme = call_578978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578978.url(scheme.get, call_578978.host, call_578978.base,
                         call_578978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578978, url, valid)

proc call*(call_578979: Call_CloudtasksProjectsLocationsQueuesTasksAcknowledge_578962;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksAcknowledge
  ## Acknowledges a pull task.
  ## 
  ## The worker, that is, the entity that
  ## leased this task must call this method
  ## to indicate that the work associated with the task has finished.
  ## 
  ## The worker must acknowledge a task within the
  ## lease_duration or the lease
  ## will expire and the task will become available to be leased
  ## again. After the task is acknowledged, it will not be returned
  ## by a later LeaseTasks,
  ## GetTask, or
  ## ListTasks.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578980 = newJObject()
  var query_578981 = newJObject()
  var body_578982 = newJObject()
  add(query_578981, "key", newJString(key))
  add(query_578981, "prettyPrint", newJBool(prettyPrint))
  add(query_578981, "oauth_token", newJString(oauthToken))
  add(query_578981, "$.xgafv", newJString(Xgafv))
  add(query_578981, "alt", newJString(alt))
  add(query_578981, "uploadType", newJString(uploadType))
  add(query_578981, "quotaUser", newJString(quotaUser))
  add(path_578980, "name", newJString(name))
  if body != nil:
    body_578982 = body
  add(query_578981, "callback", newJString(callback))
  add(query_578981, "fields", newJString(fields))
  add(query_578981, "access_token", newJString(accessToken))
  add(query_578981, "upload_protocol", newJString(uploadProtocol))
  result = call_578979.call(path_578980, query_578981, nil, nil, body_578982)

var cloudtasksProjectsLocationsQueuesTasksAcknowledge* = Call_CloudtasksProjectsLocationsQueuesTasksAcknowledge_578962(
    name: "cloudtasksProjectsLocationsQueuesTasksAcknowledge",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{name}:acknowledge",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksAcknowledge_578963,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksAcknowledge_578964,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksCancelLease_578983 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesTasksCancelLease_578985(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancelLease")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksCancelLease_578984(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Cancel a pull task's lease.
  ## 
  ## The worker can use this method to cancel a task's lease by
  ## setting its schedule_time to now. This will
  ## make the task available to be leased to the next caller of
  ## LeaseTasks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578986 = path.getOrDefault("name")
  valid_578986 = validateParameter(valid_578986, JString, required = true,
                                 default = nil)
  if valid_578986 != nil:
    section.add "name", valid_578986
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578987 = query.getOrDefault("key")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "key", valid_578987
  var valid_578988 = query.getOrDefault("prettyPrint")
  valid_578988 = validateParameter(valid_578988, JBool, required = false,
                                 default = newJBool(true))
  if valid_578988 != nil:
    section.add "prettyPrint", valid_578988
  var valid_578989 = query.getOrDefault("oauth_token")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "oauth_token", valid_578989
  var valid_578990 = query.getOrDefault("$.xgafv")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = newJString("1"))
  if valid_578990 != nil:
    section.add "$.xgafv", valid_578990
  var valid_578991 = query.getOrDefault("alt")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = newJString("json"))
  if valid_578991 != nil:
    section.add "alt", valid_578991
  var valid_578992 = query.getOrDefault("uploadType")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "uploadType", valid_578992
  var valid_578993 = query.getOrDefault("quotaUser")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "quotaUser", valid_578993
  var valid_578994 = query.getOrDefault("callback")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "callback", valid_578994
  var valid_578995 = query.getOrDefault("fields")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "fields", valid_578995
  var valid_578996 = query.getOrDefault("access_token")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "access_token", valid_578996
  var valid_578997 = query.getOrDefault("upload_protocol")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "upload_protocol", valid_578997
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

proc call*(call_578999: Call_CloudtasksProjectsLocationsQueuesTasksCancelLease_578983;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancel a pull task's lease.
  ## 
  ## The worker can use this method to cancel a task's lease by
  ## setting its schedule_time to now. This will
  ## make the task available to be leased to the next caller of
  ## LeaseTasks.
  ## 
  let valid = call_578999.validator(path, query, header, formData, body)
  let scheme = call_578999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578999.url(scheme.get, call_578999.host, call_578999.base,
                         call_578999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578999, url, valid)

proc call*(call_579000: Call_CloudtasksProjectsLocationsQueuesTasksCancelLease_578983;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksCancelLease
  ## Cancel a pull task's lease.
  ## 
  ## The worker can use this method to cancel a task's lease by
  ## setting its schedule_time to now. This will
  ## make the task available to be leased to the next caller of
  ## LeaseTasks.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579001 = newJObject()
  var query_579002 = newJObject()
  var body_579003 = newJObject()
  add(query_579002, "key", newJString(key))
  add(query_579002, "prettyPrint", newJBool(prettyPrint))
  add(query_579002, "oauth_token", newJString(oauthToken))
  add(query_579002, "$.xgafv", newJString(Xgafv))
  add(query_579002, "alt", newJString(alt))
  add(query_579002, "uploadType", newJString(uploadType))
  add(query_579002, "quotaUser", newJString(quotaUser))
  add(path_579001, "name", newJString(name))
  if body != nil:
    body_579003 = body
  add(query_579002, "callback", newJString(callback))
  add(query_579002, "fields", newJString(fields))
  add(query_579002, "access_token", newJString(accessToken))
  add(query_579002, "upload_protocol", newJString(uploadProtocol))
  result = call_579000.call(path_579001, query_579002, nil, nil, body_579003)

var cloudtasksProjectsLocationsQueuesTasksCancelLease* = Call_CloudtasksProjectsLocationsQueuesTasksCancelLease_578983(
    name: "cloudtasksProjectsLocationsQueuesTasksCancelLease",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{name}:cancelLease",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksCancelLease_578984,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksCancelLease_578985,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesPause_579004 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesPause_579006(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":pause")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesPause_579005(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pauses the queue.
  ## 
  ## If a queue is paused then the system will stop dispatching tasks
  ## until the queue is resumed via
  ## ResumeQueue. Tasks can still be added
  ## when the queue is paused. A queue is paused if its
  ## state is PAUSED.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The queue name. For example:
  ## `projects/PROJECT_ID/location/LOCATION_ID/queues/QUEUE_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579007 = path.getOrDefault("name")
  valid_579007 = validateParameter(valid_579007, JString, required = true,
                                 default = nil)
  if valid_579007 != nil:
    section.add "name", valid_579007
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579008 = query.getOrDefault("key")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "key", valid_579008
  var valid_579009 = query.getOrDefault("prettyPrint")
  valid_579009 = validateParameter(valid_579009, JBool, required = false,
                                 default = newJBool(true))
  if valid_579009 != nil:
    section.add "prettyPrint", valid_579009
  var valid_579010 = query.getOrDefault("oauth_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "oauth_token", valid_579010
  var valid_579011 = query.getOrDefault("$.xgafv")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = newJString("1"))
  if valid_579011 != nil:
    section.add "$.xgafv", valid_579011
  var valid_579012 = query.getOrDefault("alt")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = newJString("json"))
  if valid_579012 != nil:
    section.add "alt", valid_579012
  var valid_579013 = query.getOrDefault("uploadType")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "uploadType", valid_579013
  var valid_579014 = query.getOrDefault("quotaUser")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "quotaUser", valid_579014
  var valid_579015 = query.getOrDefault("callback")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "callback", valid_579015
  var valid_579016 = query.getOrDefault("fields")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "fields", valid_579016
  var valid_579017 = query.getOrDefault("access_token")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "access_token", valid_579017
  var valid_579018 = query.getOrDefault("upload_protocol")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "upload_protocol", valid_579018
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

proc call*(call_579020: Call_CloudtasksProjectsLocationsQueuesPause_579004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pauses the queue.
  ## 
  ## If a queue is paused then the system will stop dispatching tasks
  ## until the queue is resumed via
  ## ResumeQueue. Tasks can still be added
  ## when the queue is paused. A queue is paused if its
  ## state is PAUSED.
  ## 
  let valid = call_579020.validator(path, query, header, formData, body)
  let scheme = call_579020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579020.url(scheme.get, call_579020.host, call_579020.base,
                         call_579020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579020, url, valid)

proc call*(call_579021: Call_CloudtasksProjectsLocationsQueuesPause_579004;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesPause
  ## Pauses the queue.
  ## 
  ## If a queue is paused then the system will stop dispatching tasks
  ## until the queue is resumed via
  ## ResumeQueue. Tasks can still be added
  ## when the queue is paused. A queue is paused if its
  ## state is PAUSED.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The queue name. For example:
  ## `projects/PROJECT_ID/location/LOCATION_ID/queues/QUEUE_ID`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579022 = newJObject()
  var query_579023 = newJObject()
  var body_579024 = newJObject()
  add(query_579023, "key", newJString(key))
  add(query_579023, "prettyPrint", newJBool(prettyPrint))
  add(query_579023, "oauth_token", newJString(oauthToken))
  add(query_579023, "$.xgafv", newJString(Xgafv))
  add(query_579023, "alt", newJString(alt))
  add(query_579023, "uploadType", newJString(uploadType))
  add(query_579023, "quotaUser", newJString(quotaUser))
  add(path_579022, "name", newJString(name))
  if body != nil:
    body_579024 = body
  add(query_579023, "callback", newJString(callback))
  add(query_579023, "fields", newJString(fields))
  add(query_579023, "access_token", newJString(accessToken))
  add(query_579023, "upload_protocol", newJString(uploadProtocol))
  result = call_579021.call(path_579022, query_579023, nil, nil, body_579024)

var cloudtasksProjectsLocationsQueuesPause* = Call_CloudtasksProjectsLocationsQueuesPause_579004(
    name: "cloudtasksProjectsLocationsQueuesPause", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}:pause",
    validator: validate_CloudtasksProjectsLocationsQueuesPause_579005, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesPause_579006,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesPurge_579025 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesPurge_579027(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":purge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesPurge_579026(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Purges a queue by deleting all of its tasks.
  ## 
  ## All tasks created before this method is called are permanently deleted.
  ## 
  ## Purge operations can take up to one minute to take effect. Tasks
  ## might be dispatched before the purge takes effect. A purge is irreversible.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The queue name. For example:
  ## `projects/PROJECT_ID/location/LOCATION_ID/queues/QUEUE_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579028 = path.getOrDefault("name")
  valid_579028 = validateParameter(valid_579028, JString, required = true,
                                 default = nil)
  if valid_579028 != nil:
    section.add "name", valid_579028
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579029 = query.getOrDefault("key")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "key", valid_579029
  var valid_579030 = query.getOrDefault("prettyPrint")
  valid_579030 = validateParameter(valid_579030, JBool, required = false,
                                 default = newJBool(true))
  if valid_579030 != nil:
    section.add "prettyPrint", valid_579030
  var valid_579031 = query.getOrDefault("oauth_token")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "oauth_token", valid_579031
  var valid_579032 = query.getOrDefault("$.xgafv")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = newJString("1"))
  if valid_579032 != nil:
    section.add "$.xgafv", valid_579032
  var valid_579033 = query.getOrDefault("alt")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = newJString("json"))
  if valid_579033 != nil:
    section.add "alt", valid_579033
  var valid_579034 = query.getOrDefault("uploadType")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "uploadType", valid_579034
  var valid_579035 = query.getOrDefault("quotaUser")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "quotaUser", valid_579035
  var valid_579036 = query.getOrDefault("callback")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "callback", valid_579036
  var valid_579037 = query.getOrDefault("fields")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "fields", valid_579037
  var valid_579038 = query.getOrDefault("access_token")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "access_token", valid_579038
  var valid_579039 = query.getOrDefault("upload_protocol")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "upload_protocol", valid_579039
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

proc call*(call_579041: Call_CloudtasksProjectsLocationsQueuesPurge_579025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Purges a queue by deleting all of its tasks.
  ## 
  ## All tasks created before this method is called are permanently deleted.
  ## 
  ## Purge operations can take up to one minute to take effect. Tasks
  ## might be dispatched before the purge takes effect. A purge is irreversible.
  ## 
  let valid = call_579041.validator(path, query, header, formData, body)
  let scheme = call_579041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579041.url(scheme.get, call_579041.host, call_579041.base,
                         call_579041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579041, url, valid)

proc call*(call_579042: Call_CloudtasksProjectsLocationsQueuesPurge_579025;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesPurge
  ## Purges a queue by deleting all of its tasks.
  ## 
  ## All tasks created before this method is called are permanently deleted.
  ## 
  ## Purge operations can take up to one minute to take effect. Tasks
  ## might be dispatched before the purge takes effect. A purge is irreversible.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The queue name. For example:
  ## `projects/PROJECT_ID/location/LOCATION_ID/queues/QUEUE_ID`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579043 = newJObject()
  var query_579044 = newJObject()
  var body_579045 = newJObject()
  add(query_579044, "key", newJString(key))
  add(query_579044, "prettyPrint", newJBool(prettyPrint))
  add(query_579044, "oauth_token", newJString(oauthToken))
  add(query_579044, "$.xgafv", newJString(Xgafv))
  add(query_579044, "alt", newJString(alt))
  add(query_579044, "uploadType", newJString(uploadType))
  add(query_579044, "quotaUser", newJString(quotaUser))
  add(path_579043, "name", newJString(name))
  if body != nil:
    body_579045 = body
  add(query_579044, "callback", newJString(callback))
  add(query_579044, "fields", newJString(fields))
  add(query_579044, "access_token", newJString(accessToken))
  add(query_579044, "upload_protocol", newJString(uploadProtocol))
  result = call_579042.call(path_579043, query_579044, nil, nil, body_579045)

var cloudtasksProjectsLocationsQueuesPurge* = Call_CloudtasksProjectsLocationsQueuesPurge_579025(
    name: "cloudtasksProjectsLocationsQueuesPurge", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}:purge",
    validator: validate_CloudtasksProjectsLocationsQueuesPurge_579026, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesPurge_579027,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksRenewLease_579046 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesTasksRenewLease_579048(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":renewLease")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksRenewLease_579047(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Renew the current lease of a pull task.
  ## 
  ## The worker can use this method to extend the lease by a new
  ## duration, starting from now. The new task lease will be
  ## returned in the task's schedule_time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579049 = path.getOrDefault("name")
  valid_579049 = validateParameter(valid_579049, JString, required = true,
                                 default = nil)
  if valid_579049 != nil:
    section.add "name", valid_579049
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579050 = query.getOrDefault("key")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "key", valid_579050
  var valid_579051 = query.getOrDefault("prettyPrint")
  valid_579051 = validateParameter(valid_579051, JBool, required = false,
                                 default = newJBool(true))
  if valid_579051 != nil:
    section.add "prettyPrint", valid_579051
  var valid_579052 = query.getOrDefault("oauth_token")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "oauth_token", valid_579052
  var valid_579053 = query.getOrDefault("$.xgafv")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = newJString("1"))
  if valid_579053 != nil:
    section.add "$.xgafv", valid_579053
  var valid_579054 = query.getOrDefault("alt")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = newJString("json"))
  if valid_579054 != nil:
    section.add "alt", valid_579054
  var valid_579055 = query.getOrDefault("uploadType")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "uploadType", valid_579055
  var valid_579056 = query.getOrDefault("quotaUser")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "quotaUser", valid_579056
  var valid_579057 = query.getOrDefault("callback")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "callback", valid_579057
  var valid_579058 = query.getOrDefault("fields")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "fields", valid_579058
  var valid_579059 = query.getOrDefault("access_token")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "access_token", valid_579059
  var valid_579060 = query.getOrDefault("upload_protocol")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "upload_protocol", valid_579060
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

proc call*(call_579062: Call_CloudtasksProjectsLocationsQueuesTasksRenewLease_579046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renew the current lease of a pull task.
  ## 
  ## The worker can use this method to extend the lease by a new
  ## duration, starting from now. The new task lease will be
  ## returned in the task's schedule_time.
  ## 
  let valid = call_579062.validator(path, query, header, formData, body)
  let scheme = call_579062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579062.url(scheme.get, call_579062.host, call_579062.base,
                         call_579062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579062, url, valid)

proc call*(call_579063: Call_CloudtasksProjectsLocationsQueuesTasksRenewLease_579046;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksRenewLease
  ## Renew the current lease of a pull task.
  ## 
  ## The worker can use this method to extend the lease by a new
  ## duration, starting from now. The new task lease will be
  ## returned in the task's schedule_time.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579064 = newJObject()
  var query_579065 = newJObject()
  var body_579066 = newJObject()
  add(query_579065, "key", newJString(key))
  add(query_579065, "prettyPrint", newJBool(prettyPrint))
  add(query_579065, "oauth_token", newJString(oauthToken))
  add(query_579065, "$.xgafv", newJString(Xgafv))
  add(query_579065, "alt", newJString(alt))
  add(query_579065, "uploadType", newJString(uploadType))
  add(query_579065, "quotaUser", newJString(quotaUser))
  add(path_579064, "name", newJString(name))
  if body != nil:
    body_579066 = body
  add(query_579065, "callback", newJString(callback))
  add(query_579065, "fields", newJString(fields))
  add(query_579065, "access_token", newJString(accessToken))
  add(query_579065, "upload_protocol", newJString(uploadProtocol))
  result = call_579063.call(path_579064, query_579065, nil, nil, body_579066)

var cloudtasksProjectsLocationsQueuesTasksRenewLease* = Call_CloudtasksProjectsLocationsQueuesTasksRenewLease_579046(
    name: "cloudtasksProjectsLocationsQueuesTasksRenewLease",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{name}:renewLease",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksRenewLease_579047,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksRenewLease_579048,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesResume_579067 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesResume_579069(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesResume_579068(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resume a queue.
  ## 
  ## This method resumes a queue after it has been
  ## PAUSED or
  ## DISABLED. The state of a queue is stored
  ## in the queue's state; after calling this method it
  ## will be set to RUNNING.
  ## 
  ## WARNING: Resuming many high-QPS queues at the same time can
  ## lead to target overloading. If you are resuming high-QPS
  ## queues, follow the 500/50/5 pattern described in
  ## [Managing Cloud Tasks Scaling
  ## Risks](https://cloud.google.com/tasks/docs/manage-cloud-task-scaling).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The queue name. For example:
  ## `projects/PROJECT_ID/location/LOCATION_ID/queues/QUEUE_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579070 = path.getOrDefault("name")
  valid_579070 = validateParameter(valid_579070, JString, required = true,
                                 default = nil)
  if valid_579070 != nil:
    section.add "name", valid_579070
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579071 = query.getOrDefault("key")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "key", valid_579071
  var valid_579072 = query.getOrDefault("prettyPrint")
  valid_579072 = validateParameter(valid_579072, JBool, required = false,
                                 default = newJBool(true))
  if valid_579072 != nil:
    section.add "prettyPrint", valid_579072
  var valid_579073 = query.getOrDefault("oauth_token")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "oauth_token", valid_579073
  var valid_579074 = query.getOrDefault("$.xgafv")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = newJString("1"))
  if valid_579074 != nil:
    section.add "$.xgafv", valid_579074
  var valid_579075 = query.getOrDefault("alt")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = newJString("json"))
  if valid_579075 != nil:
    section.add "alt", valid_579075
  var valid_579076 = query.getOrDefault("uploadType")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "uploadType", valid_579076
  var valid_579077 = query.getOrDefault("quotaUser")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "quotaUser", valid_579077
  var valid_579078 = query.getOrDefault("callback")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "callback", valid_579078
  var valid_579079 = query.getOrDefault("fields")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "fields", valid_579079
  var valid_579080 = query.getOrDefault("access_token")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "access_token", valid_579080
  var valid_579081 = query.getOrDefault("upload_protocol")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "upload_protocol", valid_579081
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

proc call*(call_579083: Call_CloudtasksProjectsLocationsQueuesResume_579067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resume a queue.
  ## 
  ## This method resumes a queue after it has been
  ## PAUSED or
  ## DISABLED. The state of a queue is stored
  ## in the queue's state; after calling this method it
  ## will be set to RUNNING.
  ## 
  ## WARNING: Resuming many high-QPS queues at the same time can
  ## lead to target overloading. If you are resuming high-QPS
  ## queues, follow the 500/50/5 pattern described in
  ## [Managing Cloud Tasks Scaling
  ## Risks](https://cloud.google.com/tasks/docs/manage-cloud-task-scaling).
  ## 
  let valid = call_579083.validator(path, query, header, formData, body)
  let scheme = call_579083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579083.url(scheme.get, call_579083.host, call_579083.base,
                         call_579083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579083, url, valid)

proc call*(call_579084: Call_CloudtasksProjectsLocationsQueuesResume_579067;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesResume
  ## Resume a queue.
  ## 
  ## This method resumes a queue after it has been
  ## PAUSED or
  ## DISABLED. The state of a queue is stored
  ## in the queue's state; after calling this method it
  ## will be set to RUNNING.
  ## 
  ## WARNING: Resuming many high-QPS queues at the same time can
  ## lead to target overloading. If you are resuming high-QPS
  ## queues, follow the 500/50/5 pattern described in
  ## [Managing Cloud Tasks Scaling
  ## Risks](https://cloud.google.com/tasks/docs/manage-cloud-task-scaling).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The queue name. For example:
  ## `projects/PROJECT_ID/location/LOCATION_ID/queues/QUEUE_ID`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579085 = newJObject()
  var query_579086 = newJObject()
  var body_579087 = newJObject()
  add(query_579086, "key", newJString(key))
  add(query_579086, "prettyPrint", newJBool(prettyPrint))
  add(query_579086, "oauth_token", newJString(oauthToken))
  add(query_579086, "$.xgafv", newJString(Xgafv))
  add(query_579086, "alt", newJString(alt))
  add(query_579086, "uploadType", newJString(uploadType))
  add(query_579086, "quotaUser", newJString(quotaUser))
  add(path_579085, "name", newJString(name))
  if body != nil:
    body_579087 = body
  add(query_579086, "callback", newJString(callback))
  add(query_579086, "fields", newJString(fields))
  add(query_579086, "access_token", newJString(accessToken))
  add(query_579086, "upload_protocol", newJString(uploadProtocol))
  result = call_579084.call(path_579085, query_579086, nil, nil, body_579087)

var cloudtasksProjectsLocationsQueuesResume* = Call_CloudtasksProjectsLocationsQueuesResume_579067(
    name: "cloudtasksProjectsLocationsQueuesResume", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}:resume",
    validator: validate_CloudtasksProjectsLocationsQueuesResume_579068, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesResume_579069,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksRun_579088 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesTasksRun_579090(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksRun_579089(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Forces a task to run now.
  ## 
  ## When this method is called, Cloud Tasks will dispatch the task, even if
  ## the task is already running, the queue has reached its RateLimits or
  ## is PAUSED.
  ## 
  ## This command is meant to be used for manual debugging. For
  ## example, RunTask can be used to retry a failed
  ## task after a fix has been made or to manually force a task to be
  ## dispatched now.
  ## 
  ## The dispatched task is returned. That is, the task that is returned
  ## contains the status after the task is dispatched but
  ## before the task is received by its target.
  ## 
  ## If Cloud Tasks receives a successful response from the task's
  ## target, then the task will be deleted; otherwise the task's
  ## schedule_time will be reset to the time that
  ## RunTask was called plus the retry delay specified
  ## in the queue's RetryConfig.
  ## 
  ## RunTask returns
  ## NOT_FOUND when it is called on a
  ## task that has already succeeded or permanently failed.
  ## 
  ## RunTask cannot be called on a
  ## pull task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579091 = path.getOrDefault("name")
  valid_579091 = validateParameter(valid_579091, JString, required = true,
                                 default = nil)
  if valid_579091 != nil:
    section.add "name", valid_579091
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579092 = query.getOrDefault("key")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "key", valid_579092
  var valid_579093 = query.getOrDefault("prettyPrint")
  valid_579093 = validateParameter(valid_579093, JBool, required = false,
                                 default = newJBool(true))
  if valid_579093 != nil:
    section.add "prettyPrint", valid_579093
  var valid_579094 = query.getOrDefault("oauth_token")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "oauth_token", valid_579094
  var valid_579095 = query.getOrDefault("$.xgafv")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = newJString("1"))
  if valid_579095 != nil:
    section.add "$.xgafv", valid_579095
  var valid_579096 = query.getOrDefault("alt")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = newJString("json"))
  if valid_579096 != nil:
    section.add "alt", valid_579096
  var valid_579097 = query.getOrDefault("uploadType")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "uploadType", valid_579097
  var valid_579098 = query.getOrDefault("quotaUser")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "quotaUser", valid_579098
  var valid_579099 = query.getOrDefault("callback")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "callback", valid_579099
  var valid_579100 = query.getOrDefault("fields")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "fields", valid_579100
  var valid_579101 = query.getOrDefault("access_token")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "access_token", valid_579101
  var valid_579102 = query.getOrDefault("upload_protocol")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "upload_protocol", valid_579102
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

proc call*(call_579104: Call_CloudtasksProjectsLocationsQueuesTasksRun_579088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Forces a task to run now.
  ## 
  ## When this method is called, Cloud Tasks will dispatch the task, even if
  ## the task is already running, the queue has reached its RateLimits or
  ## is PAUSED.
  ## 
  ## This command is meant to be used for manual debugging. For
  ## example, RunTask can be used to retry a failed
  ## task after a fix has been made or to manually force a task to be
  ## dispatched now.
  ## 
  ## The dispatched task is returned. That is, the task that is returned
  ## contains the status after the task is dispatched but
  ## before the task is received by its target.
  ## 
  ## If Cloud Tasks receives a successful response from the task's
  ## target, then the task will be deleted; otherwise the task's
  ## schedule_time will be reset to the time that
  ## RunTask was called plus the retry delay specified
  ## in the queue's RetryConfig.
  ## 
  ## RunTask returns
  ## NOT_FOUND when it is called on a
  ## task that has already succeeded or permanently failed.
  ## 
  ## RunTask cannot be called on a
  ## pull task.
  ## 
  let valid = call_579104.validator(path, query, header, formData, body)
  let scheme = call_579104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579104.url(scheme.get, call_579104.host, call_579104.base,
                         call_579104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579104, url, valid)

proc call*(call_579105: Call_CloudtasksProjectsLocationsQueuesTasksRun_579088;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksRun
  ## Forces a task to run now.
  ## 
  ## When this method is called, Cloud Tasks will dispatch the task, even if
  ## the task is already running, the queue has reached its RateLimits or
  ## is PAUSED.
  ## 
  ## This command is meant to be used for manual debugging. For
  ## example, RunTask can be used to retry a failed
  ## task after a fix has been made or to manually force a task to be
  ## dispatched now.
  ## 
  ## The dispatched task is returned. That is, the task that is returned
  ## contains the status after the task is dispatched but
  ## before the task is received by its target.
  ## 
  ## If Cloud Tasks receives a successful response from the task's
  ## target, then the task will be deleted; otherwise the task's
  ## schedule_time will be reset to the time that
  ## RunTask was called plus the retry delay specified
  ## in the queue's RetryConfig.
  ## 
  ## RunTask returns
  ## NOT_FOUND when it is called on a
  ## task that has already succeeded or permanently failed.
  ## 
  ## RunTask cannot be called on a
  ## pull task.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579106 = newJObject()
  var query_579107 = newJObject()
  var body_579108 = newJObject()
  add(query_579107, "key", newJString(key))
  add(query_579107, "prettyPrint", newJBool(prettyPrint))
  add(query_579107, "oauth_token", newJString(oauthToken))
  add(query_579107, "$.xgafv", newJString(Xgafv))
  add(query_579107, "alt", newJString(alt))
  add(query_579107, "uploadType", newJString(uploadType))
  add(query_579107, "quotaUser", newJString(quotaUser))
  add(path_579106, "name", newJString(name))
  if body != nil:
    body_579108 = body
  add(query_579107, "callback", newJString(callback))
  add(query_579107, "fields", newJString(fields))
  add(query_579107, "access_token", newJString(accessToken))
  add(query_579107, "upload_protocol", newJString(uploadProtocol))
  result = call_579105.call(path_579106, query_579107, nil, nil, body_579108)

var cloudtasksProjectsLocationsQueuesTasksRun* = Call_CloudtasksProjectsLocationsQueuesTasksRun_579088(
    name: "cloudtasksProjectsLocationsQueuesTasksRun", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}:run",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksRun_579089,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksRun_579090,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesCreate_579131 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesCreate_579133(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/queues")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesCreate_579132(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a queue.
  ## 
  ## Queues created with this method allow tasks to live for a maximum of 31
  ## days. After a task is 31 days old, the task will be deleted regardless of whether
  ## it was dispatched or not.
  ## 
  ## WARNING: Using this method may have unintended side effects if you are
  ## using an App Engine `queue.yaml` or `queue.xml` file to manage your queues.
  ## Read
  ## [Overview of Queue Management and
  ## queue.yaml](https://cloud.google.com/tasks/docs/queue-yaml) before using
  ## this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The location name in which the queue will be created.
  ## For example: `projects/PROJECT_ID/locations/LOCATION_ID`
  ## 
  ## The list of allowed locations can be obtained by calling Cloud
  ## Tasks' implementation of
  ## ListLocations.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579134 = path.getOrDefault("parent")
  valid_579134 = validateParameter(valid_579134, JString, required = true,
                                 default = nil)
  if valid_579134 != nil:
    section.add "parent", valid_579134
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579135 = query.getOrDefault("key")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "key", valid_579135
  var valid_579136 = query.getOrDefault("prettyPrint")
  valid_579136 = validateParameter(valid_579136, JBool, required = false,
                                 default = newJBool(true))
  if valid_579136 != nil:
    section.add "prettyPrint", valid_579136
  var valid_579137 = query.getOrDefault("oauth_token")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "oauth_token", valid_579137
  var valid_579138 = query.getOrDefault("$.xgafv")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = newJString("1"))
  if valid_579138 != nil:
    section.add "$.xgafv", valid_579138
  var valid_579139 = query.getOrDefault("alt")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = newJString("json"))
  if valid_579139 != nil:
    section.add "alt", valid_579139
  var valid_579140 = query.getOrDefault("uploadType")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "uploadType", valid_579140
  var valid_579141 = query.getOrDefault("quotaUser")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "quotaUser", valid_579141
  var valid_579142 = query.getOrDefault("callback")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "callback", valid_579142
  var valid_579143 = query.getOrDefault("fields")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "fields", valid_579143
  var valid_579144 = query.getOrDefault("access_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "access_token", valid_579144
  var valid_579145 = query.getOrDefault("upload_protocol")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "upload_protocol", valid_579145
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

proc call*(call_579147: Call_CloudtasksProjectsLocationsQueuesCreate_579131;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a queue.
  ## 
  ## Queues created with this method allow tasks to live for a maximum of 31
  ## days. After a task is 31 days old, the task will be deleted regardless of whether
  ## it was dispatched or not.
  ## 
  ## WARNING: Using this method may have unintended side effects if you are
  ## using an App Engine `queue.yaml` or `queue.xml` file to manage your queues.
  ## Read
  ## [Overview of Queue Management and
  ## queue.yaml](https://cloud.google.com/tasks/docs/queue-yaml) before using
  ## this method.
  ## 
  let valid = call_579147.validator(path, query, header, formData, body)
  let scheme = call_579147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579147.url(scheme.get, call_579147.host, call_579147.base,
                         call_579147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579147, url, valid)

proc call*(call_579148: Call_CloudtasksProjectsLocationsQueuesCreate_579131;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesCreate
  ## Creates a queue.
  ## 
  ## Queues created with this method allow tasks to live for a maximum of 31
  ## days. After a task is 31 days old, the task will be deleted regardless of whether
  ## it was dispatched or not.
  ## 
  ## WARNING: Using this method may have unintended side effects if you are
  ## using an App Engine `queue.yaml` or `queue.xml` file to manage your queues.
  ## Read
  ## [Overview of Queue Management and
  ## queue.yaml](https://cloud.google.com/tasks/docs/queue-yaml) before using
  ## this method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The location name in which the queue will be created.
  ## For example: `projects/PROJECT_ID/locations/LOCATION_ID`
  ## 
  ## The list of allowed locations can be obtained by calling Cloud
  ## Tasks' implementation of
  ## ListLocations.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579149 = newJObject()
  var query_579150 = newJObject()
  var body_579151 = newJObject()
  add(query_579150, "key", newJString(key))
  add(query_579150, "prettyPrint", newJBool(prettyPrint))
  add(query_579150, "oauth_token", newJString(oauthToken))
  add(query_579150, "$.xgafv", newJString(Xgafv))
  add(query_579150, "alt", newJString(alt))
  add(query_579150, "uploadType", newJString(uploadType))
  add(query_579150, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579151 = body
  add(query_579150, "callback", newJString(callback))
  add(path_579149, "parent", newJString(parent))
  add(query_579150, "fields", newJString(fields))
  add(query_579150, "access_token", newJString(accessToken))
  add(query_579150, "upload_protocol", newJString(uploadProtocol))
  result = call_579148.call(path_579149, query_579150, nil, nil, body_579151)

var cloudtasksProjectsLocationsQueuesCreate* = Call_CloudtasksProjectsLocationsQueuesCreate_579131(
    name: "cloudtasksProjectsLocationsQueuesCreate", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{parent}/queues",
    validator: validate_CloudtasksProjectsLocationsQueuesCreate_579132, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesCreate_579133,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesList_579109 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesList_579111(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/queues")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesList_579110(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists queues.
  ## 
  ## Queues are returned in lexicographical order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The location name.
  ## For example: `projects/PROJECT_ID/locations/LOCATION_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579112 = path.getOrDefault("parent")
  valid_579112 = validateParameter(valid_579112, JString, required = true,
                                 default = nil)
  if valid_579112 != nil:
    section.add "parent", valid_579112
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size.
  ## 
  ## The maximum page size is 9800. If unspecified, the page size will
  ## be the maximum. Fewer queues than requested might be returned,
  ## even if more queues exist; use the
  ## next_page_token in the
  ## response to determine if more queues exist.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : `filter` can be used to specify a subset of queues. Any Queue
  ## field can be used as a filter and several operators as supported.
  ## For example: `<=, <, >=, >, !=, =, :`. The filter syntax is the same as
  ## described in
  ## [Stackdriver's Advanced Logs
  ## Filters](https://cloud.google.com/logging/docs/view/advanced_filters).
  ## 
  ## Sample filter "app_engine_http_target: *".
  ## 
  ## Note that using filters might cause fewer queues than the
  ## requested_page size to be returned.
  ##   pageToken: JString
  ##            : A token identifying the page of results to return.
  ## 
  ## To request the first page results, page_token must be empty. To
  ## request the next page of results, page_token must be the value of
  ## next_page_token returned
  ## from the previous call to ListQueues
  ## method. It is an error to switch the value of the
  ## filter while iterating through pages.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579113 = query.getOrDefault("key")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "key", valid_579113
  var valid_579114 = query.getOrDefault("prettyPrint")
  valid_579114 = validateParameter(valid_579114, JBool, required = false,
                                 default = newJBool(true))
  if valid_579114 != nil:
    section.add "prettyPrint", valid_579114
  var valid_579115 = query.getOrDefault("oauth_token")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "oauth_token", valid_579115
  var valid_579116 = query.getOrDefault("$.xgafv")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = newJString("1"))
  if valid_579116 != nil:
    section.add "$.xgafv", valid_579116
  var valid_579117 = query.getOrDefault("pageSize")
  valid_579117 = validateParameter(valid_579117, JInt, required = false, default = nil)
  if valid_579117 != nil:
    section.add "pageSize", valid_579117
  var valid_579118 = query.getOrDefault("alt")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = newJString("json"))
  if valid_579118 != nil:
    section.add "alt", valid_579118
  var valid_579119 = query.getOrDefault("uploadType")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "uploadType", valid_579119
  var valid_579120 = query.getOrDefault("quotaUser")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "quotaUser", valid_579120
  var valid_579121 = query.getOrDefault("filter")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "filter", valid_579121
  var valid_579122 = query.getOrDefault("pageToken")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "pageToken", valid_579122
  var valid_579123 = query.getOrDefault("callback")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "callback", valid_579123
  var valid_579124 = query.getOrDefault("fields")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "fields", valid_579124
  var valid_579125 = query.getOrDefault("access_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "access_token", valid_579125
  var valid_579126 = query.getOrDefault("upload_protocol")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "upload_protocol", valid_579126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579127: Call_CloudtasksProjectsLocationsQueuesList_579109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists queues.
  ## 
  ## Queues are returned in lexicographical order.
  ## 
  let valid = call_579127.validator(path, query, header, formData, body)
  let scheme = call_579127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579127.url(scheme.get, call_579127.host, call_579127.base,
                         call_579127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579127, url, valid)

proc call*(call_579128: Call_CloudtasksProjectsLocationsQueuesList_579109;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesList
  ## Lists queues.
  ## 
  ## Queues are returned in lexicographical order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size.
  ## 
  ## The maximum page size is 9800. If unspecified, the page size will
  ## be the maximum. Fewer queues than requested might be returned,
  ## even if more queues exist; use the
  ## next_page_token in the
  ## response to determine if more queues exist.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : `filter` can be used to specify a subset of queues. Any Queue
  ## field can be used as a filter and several operators as supported.
  ## For example: `<=, <, >=, >, !=, =, :`. The filter syntax is the same as
  ## described in
  ## [Stackdriver's Advanced Logs
  ## Filters](https://cloud.google.com/logging/docs/view/advanced_filters).
  ## 
  ## Sample filter "app_engine_http_target: *".
  ## 
  ## Note that using filters might cause fewer queues than the
  ## requested_page size to be returned.
  ##   pageToken: string
  ##            : A token identifying the page of results to return.
  ## 
  ## To request the first page results, page_token must be empty. To
  ## request the next page of results, page_token must be the value of
  ## next_page_token returned
  ## from the previous call to ListQueues
  ## method. It is an error to switch the value of the
  ## filter while iterating through pages.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The location name.
  ## For example: `projects/PROJECT_ID/locations/LOCATION_ID`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579129 = newJObject()
  var query_579130 = newJObject()
  add(query_579130, "key", newJString(key))
  add(query_579130, "prettyPrint", newJBool(prettyPrint))
  add(query_579130, "oauth_token", newJString(oauthToken))
  add(query_579130, "$.xgafv", newJString(Xgafv))
  add(query_579130, "pageSize", newJInt(pageSize))
  add(query_579130, "alt", newJString(alt))
  add(query_579130, "uploadType", newJString(uploadType))
  add(query_579130, "quotaUser", newJString(quotaUser))
  add(query_579130, "filter", newJString(filter))
  add(query_579130, "pageToken", newJString(pageToken))
  add(query_579130, "callback", newJString(callback))
  add(path_579129, "parent", newJString(parent))
  add(query_579130, "fields", newJString(fields))
  add(query_579130, "access_token", newJString(accessToken))
  add(query_579130, "upload_protocol", newJString(uploadProtocol))
  result = call_579128.call(path_579129, query_579130, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesList* = Call_CloudtasksProjectsLocationsQueuesList_579109(
    name: "cloudtasksProjectsLocationsQueuesList", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{parent}/queues",
    validator: validate_CloudtasksProjectsLocationsQueuesList_579110, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesList_579111, schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksCreate_579174 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesTasksCreate_579176(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksCreate_579175(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task and adds it to a queue.
  ## 
  ## Tasks cannot be updated after creation; there is no UpdateTask command.
  ## 
  ## * For App Engine queues, the maximum task size is
  ##   100KB.
  ## * For pull queues, the maximum task size is 1MB.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The queue name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID`
  ## 
  ## The queue must already exist.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579177 = path.getOrDefault("parent")
  valid_579177 = validateParameter(valid_579177, JString, required = true,
                                 default = nil)
  if valid_579177 != nil:
    section.add "parent", valid_579177
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579178 = query.getOrDefault("key")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "key", valid_579178
  var valid_579179 = query.getOrDefault("prettyPrint")
  valid_579179 = validateParameter(valid_579179, JBool, required = false,
                                 default = newJBool(true))
  if valid_579179 != nil:
    section.add "prettyPrint", valid_579179
  var valid_579180 = query.getOrDefault("oauth_token")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "oauth_token", valid_579180
  var valid_579181 = query.getOrDefault("$.xgafv")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = newJString("1"))
  if valid_579181 != nil:
    section.add "$.xgafv", valid_579181
  var valid_579182 = query.getOrDefault("alt")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = newJString("json"))
  if valid_579182 != nil:
    section.add "alt", valid_579182
  var valid_579183 = query.getOrDefault("uploadType")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "uploadType", valid_579183
  var valid_579184 = query.getOrDefault("quotaUser")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "quotaUser", valid_579184
  var valid_579185 = query.getOrDefault("callback")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "callback", valid_579185
  var valid_579186 = query.getOrDefault("fields")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "fields", valid_579186
  var valid_579187 = query.getOrDefault("access_token")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "access_token", valid_579187
  var valid_579188 = query.getOrDefault("upload_protocol")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "upload_protocol", valid_579188
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

proc call*(call_579190: Call_CloudtasksProjectsLocationsQueuesTasksCreate_579174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a task and adds it to a queue.
  ## 
  ## Tasks cannot be updated after creation; there is no UpdateTask command.
  ## 
  ## * For App Engine queues, the maximum task size is
  ##   100KB.
  ## * For pull queues, the maximum task size is 1MB.
  ## 
  let valid = call_579190.validator(path, query, header, formData, body)
  let scheme = call_579190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579190.url(scheme.get, call_579190.host, call_579190.base,
                         call_579190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579190, url, valid)

proc call*(call_579191: Call_CloudtasksProjectsLocationsQueuesTasksCreate_579174;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksCreate
  ## Creates a task and adds it to a queue.
  ## 
  ## Tasks cannot be updated after creation; there is no UpdateTask command.
  ## 
  ## * For App Engine queues, the maximum task size is
  ##   100KB.
  ## * For pull queues, the maximum task size is 1MB.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The queue name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID`
  ## 
  ## The queue must already exist.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579192 = newJObject()
  var query_579193 = newJObject()
  var body_579194 = newJObject()
  add(query_579193, "key", newJString(key))
  add(query_579193, "prettyPrint", newJBool(prettyPrint))
  add(query_579193, "oauth_token", newJString(oauthToken))
  add(query_579193, "$.xgafv", newJString(Xgafv))
  add(query_579193, "alt", newJString(alt))
  add(query_579193, "uploadType", newJString(uploadType))
  add(query_579193, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579194 = body
  add(query_579193, "callback", newJString(callback))
  add(path_579192, "parent", newJString(parent))
  add(query_579193, "fields", newJString(fields))
  add(query_579193, "access_token", newJString(accessToken))
  add(query_579193, "upload_protocol", newJString(uploadProtocol))
  result = call_579191.call(path_579192, query_579193, nil, nil, body_579194)

var cloudtasksProjectsLocationsQueuesTasksCreate* = Call_CloudtasksProjectsLocationsQueuesTasksCreate_579174(
    name: "cloudtasksProjectsLocationsQueuesTasksCreate",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{parent}/tasks",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksCreate_579175,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksCreate_579176,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksList_579152 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesTasksList_579154(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksList_579153(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the tasks in a queue.
  ## 
  ## By default, only the BASIC view is retrieved
  ## due to performance considerations;
  ## response_view controls the
  ## subset of information which is returned.
  ## 
  ## The tasks may be returned in any order. The ordering may change at any
  ## time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The queue name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579155 = path.getOrDefault("parent")
  valid_579155 = validateParameter(valid_579155, JString, required = true,
                                 default = nil)
  if valid_579155 != nil:
    section.add "parent", valid_579155
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum page size.
  ## 
  ## Fewer tasks than requested might be returned, even if more tasks exist; use
  ## next_page_token in the response to
  ## determine if more tasks exist.
  ## 
  ## The maximum page size is 1000. If unspecified, the page size will be the
  ## maximum.
  ##   responseView: JString
  ##               : The response_view specifies which subset of the Task will be
  ## returned.
  ## 
  ## By default response_view is BASIC; not all
  ## information is retrieved by default because some data, such as
  ## payloads, might be desirable to return only when needed because
  ## of its large size or because of the sensitivity of data that it
  ## contains.
  ## 
  ## Authorization for FULL requires
  ## `cloudtasks.tasks.fullView` [Google IAM](https://cloud.google.com/iam/)
  ## permission on the Task resource.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying the page of results to return.
  ## 
  ## To request the first page results, page_token must be empty. To
  ## request the next page of results, page_token must be the value of
  ## next_page_token returned
  ## from the previous call to ListTasks
  ## method.
  ## 
  ## The page token is valid for only 2 hours.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579156 = query.getOrDefault("key")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "key", valid_579156
  var valid_579157 = query.getOrDefault("prettyPrint")
  valid_579157 = validateParameter(valid_579157, JBool, required = false,
                                 default = newJBool(true))
  if valid_579157 != nil:
    section.add "prettyPrint", valid_579157
  var valid_579158 = query.getOrDefault("oauth_token")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "oauth_token", valid_579158
  var valid_579159 = query.getOrDefault("$.xgafv")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = newJString("1"))
  if valid_579159 != nil:
    section.add "$.xgafv", valid_579159
  var valid_579160 = query.getOrDefault("pageSize")
  valid_579160 = validateParameter(valid_579160, JInt, required = false, default = nil)
  if valid_579160 != nil:
    section.add "pageSize", valid_579160
  var valid_579161 = query.getOrDefault("responseView")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_579161 != nil:
    section.add "responseView", valid_579161
  var valid_579162 = query.getOrDefault("alt")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = newJString("json"))
  if valid_579162 != nil:
    section.add "alt", valid_579162
  var valid_579163 = query.getOrDefault("uploadType")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "uploadType", valid_579163
  var valid_579164 = query.getOrDefault("quotaUser")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "quotaUser", valid_579164
  var valid_579165 = query.getOrDefault("pageToken")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "pageToken", valid_579165
  var valid_579166 = query.getOrDefault("callback")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "callback", valid_579166
  var valid_579167 = query.getOrDefault("fields")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "fields", valid_579167
  var valid_579168 = query.getOrDefault("access_token")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "access_token", valid_579168
  var valid_579169 = query.getOrDefault("upload_protocol")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "upload_protocol", valid_579169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579170: Call_CloudtasksProjectsLocationsQueuesTasksList_579152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the tasks in a queue.
  ## 
  ## By default, only the BASIC view is retrieved
  ## due to performance considerations;
  ## response_view controls the
  ## subset of information which is returned.
  ## 
  ## The tasks may be returned in any order. The ordering may change at any
  ## time.
  ## 
  let valid = call_579170.validator(path, query, header, formData, body)
  let scheme = call_579170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579170.url(scheme.get, call_579170.host, call_579170.base,
                         call_579170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579170, url, valid)

proc call*(call_579171: Call_CloudtasksProjectsLocationsQueuesTasksList_579152;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          responseView: string = "VIEW_UNSPECIFIED"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksList
  ## Lists the tasks in a queue.
  ## 
  ## By default, only the BASIC view is retrieved
  ## due to performance considerations;
  ## response_view controls the
  ## subset of information which is returned.
  ## 
  ## The tasks may be returned in any order. The ordering may change at any
  ## time.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum page size.
  ## 
  ## Fewer tasks than requested might be returned, even if more tasks exist; use
  ## next_page_token in the response to
  ## determine if more tasks exist.
  ## 
  ## The maximum page size is 1000. If unspecified, the page size will be the
  ## maximum.
  ##   responseView: string
  ##               : The response_view specifies which subset of the Task will be
  ## returned.
  ## 
  ## By default response_view is BASIC; not all
  ## information is retrieved by default because some data, such as
  ## payloads, might be desirable to return only when needed because
  ## of its large size or because of the sensitivity of data that it
  ## contains.
  ## 
  ## Authorization for FULL requires
  ## `cloudtasks.tasks.fullView` [Google IAM](https://cloud.google.com/iam/)
  ## permission on the Task resource.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying the page of results to return.
  ## 
  ## To request the first page results, page_token must be empty. To
  ## request the next page of results, page_token must be the value of
  ## next_page_token returned
  ## from the previous call to ListTasks
  ## method.
  ## 
  ## The page token is valid for only 2 hours.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The queue name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579172 = newJObject()
  var query_579173 = newJObject()
  add(query_579173, "key", newJString(key))
  add(query_579173, "prettyPrint", newJBool(prettyPrint))
  add(query_579173, "oauth_token", newJString(oauthToken))
  add(query_579173, "$.xgafv", newJString(Xgafv))
  add(query_579173, "pageSize", newJInt(pageSize))
  add(query_579173, "responseView", newJString(responseView))
  add(query_579173, "alt", newJString(alt))
  add(query_579173, "uploadType", newJString(uploadType))
  add(query_579173, "quotaUser", newJString(quotaUser))
  add(query_579173, "pageToken", newJString(pageToken))
  add(query_579173, "callback", newJString(callback))
  add(path_579172, "parent", newJString(parent))
  add(query_579173, "fields", newJString(fields))
  add(query_579173, "access_token", newJString(accessToken))
  add(query_579173, "upload_protocol", newJString(uploadProtocol))
  result = call_579171.call(path_579172, query_579173, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesTasksList* = Call_CloudtasksProjectsLocationsQueuesTasksList_579152(
    name: "cloudtasksProjectsLocationsQueuesTasksList", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{parent}/tasks",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksList_579153,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksList_579154,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksLease_579195 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesTasksLease_579197(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tasks:lease")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksLease_579196(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Leases tasks from a pull queue for
  ## lease_duration.
  ## 
  ## This method is invoked by the worker to obtain a lease. The
  ## worker must acknowledge the task via
  ## AcknowledgeTask after they have
  ## performed the work associated with the task.
  ## 
  ## The payload is intended to store data that
  ## the worker needs to perform the work associated with the task. To
  ## return the payloads in the response, set
  ## response_view to
  ## FULL.
  ## 
  ## A maximum of 10 qps of LeaseTasks
  ## requests are allowed per
  ## queue. RESOURCE_EXHAUSTED
  ## is returned when this limit is
  ## exceeded. RESOURCE_EXHAUSTED
  ## is also returned when
  ## max_tasks_dispatched_per_second
  ## is exceeded.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The queue name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579198 = path.getOrDefault("parent")
  valid_579198 = validateParameter(valid_579198, JString, required = true,
                                 default = nil)
  if valid_579198 != nil:
    section.add "parent", valid_579198
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579199 = query.getOrDefault("key")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "key", valid_579199
  var valid_579200 = query.getOrDefault("prettyPrint")
  valid_579200 = validateParameter(valid_579200, JBool, required = false,
                                 default = newJBool(true))
  if valid_579200 != nil:
    section.add "prettyPrint", valid_579200
  var valid_579201 = query.getOrDefault("oauth_token")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "oauth_token", valid_579201
  var valid_579202 = query.getOrDefault("$.xgafv")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = newJString("1"))
  if valid_579202 != nil:
    section.add "$.xgafv", valid_579202
  var valid_579203 = query.getOrDefault("alt")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = newJString("json"))
  if valid_579203 != nil:
    section.add "alt", valid_579203
  var valid_579204 = query.getOrDefault("uploadType")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "uploadType", valid_579204
  var valid_579205 = query.getOrDefault("quotaUser")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "quotaUser", valid_579205
  var valid_579206 = query.getOrDefault("callback")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "callback", valid_579206
  var valid_579207 = query.getOrDefault("fields")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "fields", valid_579207
  var valid_579208 = query.getOrDefault("access_token")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "access_token", valid_579208
  var valid_579209 = query.getOrDefault("upload_protocol")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "upload_protocol", valid_579209
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

proc call*(call_579211: Call_CloudtasksProjectsLocationsQueuesTasksLease_579195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Leases tasks from a pull queue for
  ## lease_duration.
  ## 
  ## This method is invoked by the worker to obtain a lease. The
  ## worker must acknowledge the task via
  ## AcknowledgeTask after they have
  ## performed the work associated with the task.
  ## 
  ## The payload is intended to store data that
  ## the worker needs to perform the work associated with the task. To
  ## return the payloads in the response, set
  ## response_view to
  ## FULL.
  ## 
  ## A maximum of 10 qps of LeaseTasks
  ## requests are allowed per
  ## queue. RESOURCE_EXHAUSTED
  ## is returned when this limit is
  ## exceeded. RESOURCE_EXHAUSTED
  ## is also returned when
  ## max_tasks_dispatched_per_second
  ## is exceeded.
  ## 
  let valid = call_579211.validator(path, query, header, formData, body)
  let scheme = call_579211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579211.url(scheme.get, call_579211.host, call_579211.base,
                         call_579211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579211, url, valid)

proc call*(call_579212: Call_CloudtasksProjectsLocationsQueuesTasksLease_579195;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksLease
  ## Leases tasks from a pull queue for
  ## lease_duration.
  ## 
  ## This method is invoked by the worker to obtain a lease. The
  ## worker must acknowledge the task via
  ## AcknowledgeTask after they have
  ## performed the work associated with the task.
  ## 
  ## The payload is intended to store data that
  ## the worker needs to perform the work associated with the task. To
  ## return the payloads in the response, set
  ## response_view to
  ## FULL.
  ## 
  ## A maximum of 10 qps of LeaseTasks
  ## requests are allowed per
  ## queue. RESOURCE_EXHAUSTED
  ## is returned when this limit is
  ## exceeded. RESOURCE_EXHAUSTED
  ## is also returned when
  ## max_tasks_dispatched_per_second
  ## is exceeded.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The queue name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579213 = newJObject()
  var query_579214 = newJObject()
  var body_579215 = newJObject()
  add(query_579214, "key", newJString(key))
  add(query_579214, "prettyPrint", newJBool(prettyPrint))
  add(query_579214, "oauth_token", newJString(oauthToken))
  add(query_579214, "$.xgafv", newJString(Xgafv))
  add(query_579214, "alt", newJString(alt))
  add(query_579214, "uploadType", newJString(uploadType))
  add(query_579214, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579215 = body
  add(query_579214, "callback", newJString(callback))
  add(path_579213, "parent", newJString(parent))
  add(query_579214, "fields", newJString(fields))
  add(query_579214, "access_token", newJString(accessToken))
  add(query_579214, "upload_protocol", newJString(uploadProtocol))
  result = call_579212.call(path_579213, query_579214, nil, nil, body_579215)

var cloudtasksProjectsLocationsQueuesTasksLease* = Call_CloudtasksProjectsLocationsQueuesTasksLease_579195(
    name: "cloudtasksProjectsLocationsQueuesTasksLease",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{parent}/tasks:lease",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksLease_579196,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksLease_579197,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_579216 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesGetIamPolicy_579218(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesGetIamPolicy_579217(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for a Queue.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  ## Authorization requires the following
  ## [Google IAM](https://cloud.google.com/iam) permission on the specified
  ## resource parent:
  ## 
  ## * `cloudtasks.queues.getIamPolicy`
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579219 = path.getOrDefault("resource")
  valid_579219 = validateParameter(valid_579219, JString, required = true,
                                 default = nil)
  if valid_579219 != nil:
    section.add "resource", valid_579219
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579220 = query.getOrDefault("key")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "key", valid_579220
  var valid_579221 = query.getOrDefault("prettyPrint")
  valid_579221 = validateParameter(valid_579221, JBool, required = false,
                                 default = newJBool(true))
  if valid_579221 != nil:
    section.add "prettyPrint", valid_579221
  var valid_579222 = query.getOrDefault("oauth_token")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "oauth_token", valid_579222
  var valid_579223 = query.getOrDefault("$.xgafv")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = newJString("1"))
  if valid_579223 != nil:
    section.add "$.xgafv", valid_579223
  var valid_579224 = query.getOrDefault("alt")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = newJString("json"))
  if valid_579224 != nil:
    section.add "alt", valid_579224
  var valid_579225 = query.getOrDefault("uploadType")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "uploadType", valid_579225
  var valid_579226 = query.getOrDefault("quotaUser")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "quotaUser", valid_579226
  var valid_579227 = query.getOrDefault("callback")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "callback", valid_579227
  var valid_579228 = query.getOrDefault("fields")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "fields", valid_579228
  var valid_579229 = query.getOrDefault("access_token")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "access_token", valid_579229
  var valid_579230 = query.getOrDefault("upload_protocol")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "upload_protocol", valid_579230
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

proc call*(call_579232: Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_579216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a Queue.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  ## Authorization requires the following
  ## [Google IAM](https://cloud.google.com/iam) permission on the specified
  ## resource parent:
  ## 
  ## * `cloudtasks.queues.getIamPolicy`
  ## 
  let valid = call_579232.validator(path, query, header, formData, body)
  let scheme = call_579232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579232.url(scheme.get, call_579232.host, call_579232.base,
                         call_579232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579232, url, valid)

proc call*(call_579233: Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_579216;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesGetIamPolicy
  ## Gets the access control policy for a Queue.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  ## Authorization requires the following
  ## [Google IAM](https://cloud.google.com/iam) permission on the specified
  ## resource parent:
  ## 
  ## * `cloudtasks.queues.getIamPolicy`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579234 = newJObject()
  var query_579235 = newJObject()
  var body_579236 = newJObject()
  add(query_579235, "key", newJString(key))
  add(query_579235, "prettyPrint", newJBool(prettyPrint))
  add(query_579235, "oauth_token", newJString(oauthToken))
  add(query_579235, "$.xgafv", newJString(Xgafv))
  add(query_579235, "alt", newJString(alt))
  add(query_579235, "uploadType", newJString(uploadType))
  add(query_579235, "quotaUser", newJString(quotaUser))
  add(path_579234, "resource", newJString(resource))
  if body != nil:
    body_579236 = body
  add(query_579235, "callback", newJString(callback))
  add(query_579235, "fields", newJString(fields))
  add(query_579235, "access_token", newJString(accessToken))
  add(query_579235, "upload_protocol", newJString(uploadProtocol))
  result = call_579233.call(path_579234, query_579235, nil, nil, body_579236)

var cloudtasksProjectsLocationsQueuesGetIamPolicy* = Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_579216(
    name: "cloudtasksProjectsLocationsQueuesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{resource}:getIamPolicy",
    validator: validate_CloudtasksProjectsLocationsQueuesGetIamPolicy_579217,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesGetIamPolicy_579218,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_579237 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesSetIamPolicy_579239(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesSetIamPolicy_579238(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy for a Queue. Replaces any existing
  ## policy.
  ## 
  ## Note: The Cloud Console does not check queue-level IAM permissions yet.
  ## Project-level permissions are required to use the Cloud Console.
  ## 
  ## Authorization requires the following
  ## [Google IAM](https://cloud.google.com/iam) permission on the specified
  ## resource parent:
  ## 
  ## * `cloudtasks.queues.setIamPolicy`
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579240 = path.getOrDefault("resource")
  valid_579240 = validateParameter(valid_579240, JString, required = true,
                                 default = nil)
  if valid_579240 != nil:
    section.add "resource", valid_579240
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579241 = query.getOrDefault("key")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "key", valid_579241
  var valid_579242 = query.getOrDefault("prettyPrint")
  valid_579242 = validateParameter(valid_579242, JBool, required = false,
                                 default = newJBool(true))
  if valid_579242 != nil:
    section.add "prettyPrint", valid_579242
  var valid_579243 = query.getOrDefault("oauth_token")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "oauth_token", valid_579243
  var valid_579244 = query.getOrDefault("$.xgafv")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = newJString("1"))
  if valid_579244 != nil:
    section.add "$.xgafv", valid_579244
  var valid_579245 = query.getOrDefault("alt")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = newJString("json"))
  if valid_579245 != nil:
    section.add "alt", valid_579245
  var valid_579246 = query.getOrDefault("uploadType")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "uploadType", valid_579246
  var valid_579247 = query.getOrDefault("quotaUser")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "quotaUser", valid_579247
  var valid_579248 = query.getOrDefault("callback")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "callback", valid_579248
  var valid_579249 = query.getOrDefault("fields")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "fields", valid_579249
  var valid_579250 = query.getOrDefault("access_token")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "access_token", valid_579250
  var valid_579251 = query.getOrDefault("upload_protocol")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "upload_protocol", valid_579251
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

proc call*(call_579253: Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_579237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy for a Queue. Replaces any existing
  ## policy.
  ## 
  ## Note: The Cloud Console does not check queue-level IAM permissions yet.
  ## Project-level permissions are required to use the Cloud Console.
  ## 
  ## Authorization requires the following
  ## [Google IAM](https://cloud.google.com/iam) permission on the specified
  ## resource parent:
  ## 
  ## * `cloudtasks.queues.setIamPolicy`
  ## 
  let valid = call_579253.validator(path, query, header, formData, body)
  let scheme = call_579253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579253.url(scheme.get, call_579253.host, call_579253.base,
                         call_579253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579253, url, valid)

proc call*(call_579254: Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_579237;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesSetIamPolicy
  ## Sets the access control policy for a Queue. Replaces any existing
  ## policy.
  ## 
  ## Note: The Cloud Console does not check queue-level IAM permissions yet.
  ## Project-level permissions are required to use the Cloud Console.
  ## 
  ## Authorization requires the following
  ## [Google IAM](https://cloud.google.com/iam) permission on the specified
  ## resource parent:
  ## 
  ## * `cloudtasks.queues.setIamPolicy`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579255 = newJObject()
  var query_579256 = newJObject()
  var body_579257 = newJObject()
  add(query_579256, "key", newJString(key))
  add(query_579256, "prettyPrint", newJBool(prettyPrint))
  add(query_579256, "oauth_token", newJString(oauthToken))
  add(query_579256, "$.xgafv", newJString(Xgafv))
  add(query_579256, "alt", newJString(alt))
  add(query_579256, "uploadType", newJString(uploadType))
  add(query_579256, "quotaUser", newJString(quotaUser))
  add(path_579255, "resource", newJString(resource))
  if body != nil:
    body_579257 = body
  add(query_579256, "callback", newJString(callback))
  add(query_579256, "fields", newJString(fields))
  add(query_579256, "access_token", newJString(accessToken))
  add(query_579256, "upload_protocol", newJString(uploadProtocol))
  result = call_579254.call(path_579255, query_579256, nil, nil, body_579257)

var cloudtasksProjectsLocationsQueuesSetIamPolicy* = Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_579237(
    name: "cloudtasksProjectsLocationsQueuesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{resource}:setIamPolicy",
    validator: validate_CloudtasksProjectsLocationsQueuesSetIamPolicy_579238,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesSetIamPolicy_579239,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_579258 = ref object of OpenApiRestCall_578339
proc url_CloudtasksProjectsLocationsQueuesTestIamPermissions_579260(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTestIamPermissions_579259(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on a Queue.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579261 = path.getOrDefault("resource")
  valid_579261 = validateParameter(valid_579261, JString, required = true,
                                 default = nil)
  if valid_579261 != nil:
    section.add "resource", valid_579261
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579262 = query.getOrDefault("key")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "key", valid_579262
  var valid_579263 = query.getOrDefault("prettyPrint")
  valid_579263 = validateParameter(valid_579263, JBool, required = false,
                                 default = newJBool(true))
  if valid_579263 != nil:
    section.add "prettyPrint", valid_579263
  var valid_579264 = query.getOrDefault("oauth_token")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "oauth_token", valid_579264
  var valid_579265 = query.getOrDefault("$.xgafv")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = newJString("1"))
  if valid_579265 != nil:
    section.add "$.xgafv", valid_579265
  var valid_579266 = query.getOrDefault("alt")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = newJString("json"))
  if valid_579266 != nil:
    section.add "alt", valid_579266
  var valid_579267 = query.getOrDefault("uploadType")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "uploadType", valid_579267
  var valid_579268 = query.getOrDefault("quotaUser")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "quotaUser", valid_579268
  var valid_579269 = query.getOrDefault("callback")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "callback", valid_579269
  var valid_579270 = query.getOrDefault("fields")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "fields", valid_579270
  var valid_579271 = query.getOrDefault("access_token")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "access_token", valid_579271
  var valid_579272 = query.getOrDefault("upload_protocol")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "upload_protocol", valid_579272
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

proc call*(call_579274: Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_579258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on a Queue.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  let valid = call_579274.validator(path, query, header, formData, body)
  let scheme = call_579274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579274.url(scheme.get, call_579274.host, call_579274.base,
                         call_579274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579274, url, valid)

proc call*(call_579275: Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_579258;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesTestIamPermissions
  ## Returns permissions that a caller has on a Queue.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579276 = newJObject()
  var query_579277 = newJObject()
  var body_579278 = newJObject()
  add(query_579277, "key", newJString(key))
  add(query_579277, "prettyPrint", newJBool(prettyPrint))
  add(query_579277, "oauth_token", newJString(oauthToken))
  add(query_579277, "$.xgafv", newJString(Xgafv))
  add(query_579277, "alt", newJString(alt))
  add(query_579277, "uploadType", newJString(uploadType))
  add(query_579277, "quotaUser", newJString(quotaUser))
  add(path_579276, "resource", newJString(resource))
  if body != nil:
    body_579278 = body
  add(query_579277, "callback", newJString(callback))
  add(query_579277, "fields", newJString(fields))
  add(query_579277, "access_token", newJString(accessToken))
  add(query_579277, "upload_protocol", newJString(uploadProtocol))
  result = call_579275.call(path_579276, query_579277, nil, nil, body_579278)

var cloudtasksProjectsLocationsQueuesTestIamPermissions* = Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_579258(
    name: "cloudtasksProjectsLocationsQueuesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{resource}:testIamPermissions",
    validator: validate_CloudtasksProjectsLocationsQueuesTestIamPermissions_579259,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTestIamPermissions_579260,
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
