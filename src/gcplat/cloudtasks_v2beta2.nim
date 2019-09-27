
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudtasks"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudtasksProjectsLocationsQueuesTasksGet_597677 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesTasksGet_597679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksGet_597678(path: JsonNode;
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
  var valid_597805 = path.getOrDefault("name")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "name", valid_597805
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  section = newJObject()
  var valid_597806 = query.getOrDefault("upload_protocol")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "upload_protocol", valid_597806
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("quotaUser")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "quotaUser", valid_597808
  var valid_597822 = query.getOrDefault("alt")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = newJString("json"))
  if valid_597822 != nil:
    section.add "alt", valid_597822
  var valid_597823 = query.getOrDefault("oauth_token")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "oauth_token", valid_597823
  var valid_597824 = query.getOrDefault("callback")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "callback", valid_597824
  var valid_597825 = query.getOrDefault("access_token")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "access_token", valid_597825
  var valid_597826 = query.getOrDefault("uploadType")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "uploadType", valid_597826
  var valid_597827 = query.getOrDefault("key")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "key", valid_597827
  var valid_597828 = query.getOrDefault("$.xgafv")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = newJString("1"))
  if valid_597828 != nil:
    section.add "$.xgafv", valid_597828
  var valid_597829 = query.getOrDefault("prettyPrint")
  valid_597829 = validateParameter(valid_597829, JBool, required = false,
                                 default = newJBool(true))
  if valid_597829 != nil:
    section.add "prettyPrint", valid_597829
  var valid_597830 = query.getOrDefault("responseView")
  valid_597830 = validateParameter(valid_597830, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_597830 != nil:
    section.add "responseView", valid_597830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597853: Call_CloudtasksProjectsLocationsQueuesTasksGet_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a task.
  ## 
  let valid = call_597853.validator(path, query, header, formData, body)
  let scheme = call_597853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597853.url(scheme.get, call_597853.host, call_597853.base,
                         call_597853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597853, url, valid)

proc call*(call_597924: Call_CloudtasksProjectsLocationsQueuesTasksGet_597677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          responseView: string = "VIEW_UNSPECIFIED"): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksGet
  ## Gets a task.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  var path_597925 = newJObject()
  var query_597927 = newJObject()
  add(query_597927, "upload_protocol", newJString(uploadProtocol))
  add(query_597927, "fields", newJString(fields))
  add(query_597927, "quotaUser", newJString(quotaUser))
  add(path_597925, "name", newJString(name))
  add(query_597927, "alt", newJString(alt))
  add(query_597927, "oauth_token", newJString(oauthToken))
  add(query_597927, "callback", newJString(callback))
  add(query_597927, "access_token", newJString(accessToken))
  add(query_597927, "uploadType", newJString(uploadType))
  add(query_597927, "key", newJString(key))
  add(query_597927, "$.xgafv", newJString(Xgafv))
  add(query_597927, "prettyPrint", newJBool(prettyPrint))
  add(query_597927, "responseView", newJString(responseView))
  result = call_597924.call(path_597925, query_597927, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesTasksGet* = Call_CloudtasksProjectsLocationsQueuesTasksGet_597677(
    name: "cloudtasksProjectsLocationsQueuesTasksGet", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksGet_597678,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksGet_597679,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesPatch_597985 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesPatch_597987(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesPatch_597986(path: JsonNode;
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
  var valid_597988 = path.getOrDefault("name")
  valid_597988 = validateParameter(valid_597988, JString, required = true,
                                 default = nil)
  if valid_597988 != nil:
    section.add "name", valid_597988
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : A mask used to specify which fields of the queue are being updated.
  ## 
  ## If empty, then all fields will be updated.
  section = newJObject()
  var valid_597989 = query.getOrDefault("upload_protocol")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "upload_protocol", valid_597989
  var valid_597990 = query.getOrDefault("fields")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "fields", valid_597990
  var valid_597991 = query.getOrDefault("quotaUser")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "quotaUser", valid_597991
  var valid_597992 = query.getOrDefault("alt")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = newJString("json"))
  if valid_597992 != nil:
    section.add "alt", valid_597992
  var valid_597993 = query.getOrDefault("oauth_token")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "oauth_token", valid_597993
  var valid_597994 = query.getOrDefault("callback")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "callback", valid_597994
  var valid_597995 = query.getOrDefault("access_token")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "access_token", valid_597995
  var valid_597996 = query.getOrDefault("uploadType")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "uploadType", valid_597996
  var valid_597997 = query.getOrDefault("key")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "key", valid_597997
  var valid_597998 = query.getOrDefault("$.xgafv")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = newJString("1"))
  if valid_597998 != nil:
    section.add "$.xgafv", valid_597998
  var valid_597999 = query.getOrDefault("prettyPrint")
  valid_597999 = validateParameter(valid_597999, JBool, required = false,
                                 default = newJBool(true))
  if valid_597999 != nil:
    section.add "prettyPrint", valid_597999
  var valid_598000 = query.getOrDefault("updateMask")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "updateMask", valid_598000
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

proc call*(call_598002: Call_CloudtasksProjectsLocationsQueuesPatch_597985;
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
  let valid = call_598002.validator(path, query, header, formData, body)
  let scheme = call_598002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598002.url(scheme.get, call_598002.host, call_598002.base,
                         call_598002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598002, url, valid)

proc call*(call_598003: Call_CloudtasksProjectsLocationsQueuesPatch_597985;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
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
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : A mask used to specify which fields of the queue are being updated.
  ## 
  ## If empty, then all fields will be updated.
  var path_598004 = newJObject()
  var query_598005 = newJObject()
  var body_598006 = newJObject()
  add(query_598005, "upload_protocol", newJString(uploadProtocol))
  add(query_598005, "fields", newJString(fields))
  add(query_598005, "quotaUser", newJString(quotaUser))
  add(path_598004, "name", newJString(name))
  add(query_598005, "alt", newJString(alt))
  add(query_598005, "oauth_token", newJString(oauthToken))
  add(query_598005, "callback", newJString(callback))
  add(query_598005, "access_token", newJString(accessToken))
  add(query_598005, "uploadType", newJString(uploadType))
  add(query_598005, "key", newJString(key))
  add(query_598005, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598006 = body
  add(query_598005, "prettyPrint", newJBool(prettyPrint))
  add(query_598005, "updateMask", newJString(updateMask))
  result = call_598003.call(path_598004, query_598005, nil, nil, body_598006)

var cloudtasksProjectsLocationsQueuesPatch* = Call_CloudtasksProjectsLocationsQueuesPatch_597985(
    name: "cloudtasksProjectsLocationsQueuesPatch", meth: HttpMethod.HttpPatch,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}",
    validator: validate_CloudtasksProjectsLocationsQueuesPatch_597986, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesPatch_597987,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksDelete_597966 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesTasksDelete_597968(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksDelete_597967(path: JsonNode;
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
  var valid_597969 = path.getOrDefault("name")
  valid_597969 = validateParameter(valid_597969, JString, required = true,
                                 default = nil)
  if valid_597969 != nil:
    section.add "name", valid_597969
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597970 = query.getOrDefault("upload_protocol")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "upload_protocol", valid_597970
  var valid_597971 = query.getOrDefault("fields")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "fields", valid_597971
  var valid_597972 = query.getOrDefault("quotaUser")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "quotaUser", valid_597972
  var valid_597973 = query.getOrDefault("alt")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = newJString("json"))
  if valid_597973 != nil:
    section.add "alt", valid_597973
  var valid_597974 = query.getOrDefault("oauth_token")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "oauth_token", valid_597974
  var valid_597975 = query.getOrDefault("callback")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "callback", valid_597975
  var valid_597976 = query.getOrDefault("access_token")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "access_token", valid_597976
  var valid_597977 = query.getOrDefault("uploadType")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "uploadType", valid_597977
  var valid_597978 = query.getOrDefault("key")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "key", valid_597978
  var valid_597979 = query.getOrDefault("$.xgafv")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = newJString("1"))
  if valid_597979 != nil:
    section.add "$.xgafv", valid_597979
  var valid_597980 = query.getOrDefault("prettyPrint")
  valid_597980 = validateParameter(valid_597980, JBool, required = false,
                                 default = newJBool(true))
  if valid_597980 != nil:
    section.add "prettyPrint", valid_597980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597981: Call_CloudtasksProjectsLocationsQueuesTasksDelete_597966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a task.
  ## 
  ## A task can be deleted if it is scheduled or dispatched. A task
  ## cannot be deleted if it has completed successfully or permanently
  ## failed.
  ## 
  let valid = call_597981.validator(path, query, header, formData, body)
  let scheme = call_597981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597981.url(scheme.get, call_597981.host, call_597981.base,
                         call_597981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597981, url, valid)

proc call*(call_597982: Call_CloudtasksProjectsLocationsQueuesTasksDelete_597966;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksDelete
  ## Deletes a task.
  ## 
  ## A task can be deleted if it is scheduled or dispatched. A task
  ## cannot be deleted if it has completed successfully or permanently
  ## failed.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_597983 = newJObject()
  var query_597984 = newJObject()
  add(query_597984, "upload_protocol", newJString(uploadProtocol))
  add(query_597984, "fields", newJString(fields))
  add(query_597984, "quotaUser", newJString(quotaUser))
  add(path_597983, "name", newJString(name))
  add(query_597984, "alt", newJString(alt))
  add(query_597984, "oauth_token", newJString(oauthToken))
  add(query_597984, "callback", newJString(callback))
  add(query_597984, "access_token", newJString(accessToken))
  add(query_597984, "uploadType", newJString(uploadType))
  add(query_597984, "key", newJString(key))
  add(query_597984, "$.xgafv", newJString(Xgafv))
  add(query_597984, "prettyPrint", newJBool(prettyPrint))
  result = call_597982.call(path_597983, query_597984, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesTasksDelete* = Call_CloudtasksProjectsLocationsQueuesTasksDelete_597966(
    name: "cloudtasksProjectsLocationsQueuesTasksDelete",
    meth: HttpMethod.HttpDelete, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{name}",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksDelete_597967,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksDelete_597968,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsList_598007 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsList_598009(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsList_598008(path: JsonNode;
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
  var valid_598010 = path.getOrDefault("name")
  valid_598010 = validateParameter(valid_598010, JString, required = true,
                                 default = nil)
  if valid_598010 != nil:
    section.add "name", valid_598010
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_598011 = query.getOrDefault("upload_protocol")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "upload_protocol", valid_598011
  var valid_598012 = query.getOrDefault("fields")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "fields", valid_598012
  var valid_598013 = query.getOrDefault("pageToken")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "pageToken", valid_598013
  var valid_598014 = query.getOrDefault("quotaUser")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "quotaUser", valid_598014
  var valid_598015 = query.getOrDefault("alt")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = newJString("json"))
  if valid_598015 != nil:
    section.add "alt", valid_598015
  var valid_598016 = query.getOrDefault("oauth_token")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "oauth_token", valid_598016
  var valid_598017 = query.getOrDefault("callback")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "callback", valid_598017
  var valid_598018 = query.getOrDefault("access_token")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "access_token", valid_598018
  var valid_598019 = query.getOrDefault("uploadType")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "uploadType", valid_598019
  var valid_598020 = query.getOrDefault("key")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "key", valid_598020
  var valid_598021 = query.getOrDefault("$.xgafv")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = newJString("1"))
  if valid_598021 != nil:
    section.add "$.xgafv", valid_598021
  var valid_598022 = query.getOrDefault("pageSize")
  valid_598022 = validateParameter(valid_598022, JInt, required = false, default = nil)
  if valid_598022 != nil:
    section.add "pageSize", valid_598022
  var valid_598023 = query.getOrDefault("prettyPrint")
  valid_598023 = validateParameter(valid_598023, JBool, required = false,
                                 default = newJBool(true))
  if valid_598023 != nil:
    section.add "prettyPrint", valid_598023
  var valid_598024 = query.getOrDefault("filter")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = nil)
  if valid_598024 != nil:
    section.add "filter", valid_598024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598025: Call_CloudtasksProjectsLocationsList_598007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_598025.validator(path, query, header, formData, body)
  let scheme = call_598025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598025.url(scheme.get, call_598025.host, call_598025.base,
                         call_598025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598025, url, valid)

proc call*(call_598026: Call_CloudtasksProjectsLocationsList_598007; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudtasksProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_598027 = newJObject()
  var query_598028 = newJObject()
  add(query_598028, "upload_protocol", newJString(uploadProtocol))
  add(query_598028, "fields", newJString(fields))
  add(query_598028, "pageToken", newJString(pageToken))
  add(query_598028, "quotaUser", newJString(quotaUser))
  add(path_598027, "name", newJString(name))
  add(query_598028, "alt", newJString(alt))
  add(query_598028, "oauth_token", newJString(oauthToken))
  add(query_598028, "callback", newJString(callback))
  add(query_598028, "access_token", newJString(accessToken))
  add(query_598028, "uploadType", newJString(uploadType))
  add(query_598028, "key", newJString(key))
  add(query_598028, "$.xgafv", newJString(Xgafv))
  add(query_598028, "pageSize", newJInt(pageSize))
  add(query_598028, "prettyPrint", newJBool(prettyPrint))
  add(query_598028, "filter", newJString(filter))
  result = call_598026.call(path_598027, query_598028, nil, nil, nil)

var cloudtasksProjectsLocationsList* = Call_CloudtasksProjectsLocationsList_598007(
    name: "cloudtasksProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}/locations",
    validator: validate_CloudtasksProjectsLocationsList_598008, base: "/",
    url: url_CloudtasksProjectsLocationsList_598009, schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksAcknowledge_598029 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesTasksAcknowledge_598031(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesTasksAcknowledge_598030(
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
  var valid_598032 = path.getOrDefault("name")
  valid_598032 = validateParameter(valid_598032, JString, required = true,
                                 default = nil)
  if valid_598032 != nil:
    section.add "name", valid_598032
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598033 = query.getOrDefault("upload_protocol")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "upload_protocol", valid_598033
  var valid_598034 = query.getOrDefault("fields")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "fields", valid_598034
  var valid_598035 = query.getOrDefault("quotaUser")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "quotaUser", valid_598035
  var valid_598036 = query.getOrDefault("alt")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = newJString("json"))
  if valid_598036 != nil:
    section.add "alt", valid_598036
  var valid_598037 = query.getOrDefault("oauth_token")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "oauth_token", valid_598037
  var valid_598038 = query.getOrDefault("callback")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "callback", valid_598038
  var valid_598039 = query.getOrDefault("access_token")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "access_token", valid_598039
  var valid_598040 = query.getOrDefault("uploadType")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "uploadType", valid_598040
  var valid_598041 = query.getOrDefault("key")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "key", valid_598041
  var valid_598042 = query.getOrDefault("$.xgafv")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = newJString("1"))
  if valid_598042 != nil:
    section.add "$.xgafv", valid_598042
  var valid_598043 = query.getOrDefault("prettyPrint")
  valid_598043 = validateParameter(valid_598043, JBool, required = false,
                                 default = newJBool(true))
  if valid_598043 != nil:
    section.add "prettyPrint", valid_598043
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

proc call*(call_598045: Call_CloudtasksProjectsLocationsQueuesTasksAcknowledge_598029;
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
  let valid = call_598045.validator(path, query, header, formData, body)
  let scheme = call_598045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598045.url(scheme.get, call_598045.host, call_598045.base,
                         call_598045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598045, url, valid)

proc call*(call_598046: Call_CloudtasksProjectsLocationsQueuesTasksAcknowledge_598029;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598047 = newJObject()
  var query_598048 = newJObject()
  var body_598049 = newJObject()
  add(query_598048, "upload_protocol", newJString(uploadProtocol))
  add(query_598048, "fields", newJString(fields))
  add(query_598048, "quotaUser", newJString(quotaUser))
  add(path_598047, "name", newJString(name))
  add(query_598048, "alt", newJString(alt))
  add(query_598048, "oauth_token", newJString(oauthToken))
  add(query_598048, "callback", newJString(callback))
  add(query_598048, "access_token", newJString(accessToken))
  add(query_598048, "uploadType", newJString(uploadType))
  add(query_598048, "key", newJString(key))
  add(query_598048, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598049 = body
  add(query_598048, "prettyPrint", newJBool(prettyPrint))
  result = call_598046.call(path_598047, query_598048, nil, nil, body_598049)

var cloudtasksProjectsLocationsQueuesTasksAcknowledge* = Call_CloudtasksProjectsLocationsQueuesTasksAcknowledge_598029(
    name: "cloudtasksProjectsLocationsQueuesTasksAcknowledge",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{name}:acknowledge",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksAcknowledge_598030,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksAcknowledge_598031,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksCancelLease_598050 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesTasksCancelLease_598052(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesTasksCancelLease_598051(
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
  var valid_598053 = path.getOrDefault("name")
  valid_598053 = validateParameter(valid_598053, JString, required = true,
                                 default = nil)
  if valid_598053 != nil:
    section.add "name", valid_598053
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598054 = query.getOrDefault("upload_protocol")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "upload_protocol", valid_598054
  var valid_598055 = query.getOrDefault("fields")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "fields", valid_598055
  var valid_598056 = query.getOrDefault("quotaUser")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "quotaUser", valid_598056
  var valid_598057 = query.getOrDefault("alt")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = newJString("json"))
  if valid_598057 != nil:
    section.add "alt", valid_598057
  var valid_598058 = query.getOrDefault("oauth_token")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "oauth_token", valid_598058
  var valid_598059 = query.getOrDefault("callback")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "callback", valid_598059
  var valid_598060 = query.getOrDefault("access_token")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "access_token", valid_598060
  var valid_598061 = query.getOrDefault("uploadType")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "uploadType", valid_598061
  var valid_598062 = query.getOrDefault("key")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = nil)
  if valid_598062 != nil:
    section.add "key", valid_598062
  var valid_598063 = query.getOrDefault("$.xgafv")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = newJString("1"))
  if valid_598063 != nil:
    section.add "$.xgafv", valid_598063
  var valid_598064 = query.getOrDefault("prettyPrint")
  valid_598064 = validateParameter(valid_598064, JBool, required = false,
                                 default = newJBool(true))
  if valid_598064 != nil:
    section.add "prettyPrint", valid_598064
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

proc call*(call_598066: Call_CloudtasksProjectsLocationsQueuesTasksCancelLease_598050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancel a pull task's lease.
  ## 
  ## The worker can use this method to cancel a task's lease by
  ## setting its schedule_time to now. This will
  ## make the task available to be leased to the next caller of
  ## LeaseTasks.
  ## 
  let valid = call_598066.validator(path, query, header, formData, body)
  let scheme = call_598066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598066.url(scheme.get, call_598066.host, call_598066.base,
                         call_598066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598066, url, valid)

proc call*(call_598067: Call_CloudtasksProjectsLocationsQueuesTasksCancelLease_598050;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksCancelLease
  ## Cancel a pull task's lease.
  ## 
  ## The worker can use this method to cancel a task's lease by
  ## setting its schedule_time to now. This will
  ## make the task available to be leased to the next caller of
  ## LeaseTasks.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598068 = newJObject()
  var query_598069 = newJObject()
  var body_598070 = newJObject()
  add(query_598069, "upload_protocol", newJString(uploadProtocol))
  add(query_598069, "fields", newJString(fields))
  add(query_598069, "quotaUser", newJString(quotaUser))
  add(path_598068, "name", newJString(name))
  add(query_598069, "alt", newJString(alt))
  add(query_598069, "oauth_token", newJString(oauthToken))
  add(query_598069, "callback", newJString(callback))
  add(query_598069, "access_token", newJString(accessToken))
  add(query_598069, "uploadType", newJString(uploadType))
  add(query_598069, "key", newJString(key))
  add(query_598069, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598070 = body
  add(query_598069, "prettyPrint", newJBool(prettyPrint))
  result = call_598067.call(path_598068, query_598069, nil, nil, body_598070)

var cloudtasksProjectsLocationsQueuesTasksCancelLease* = Call_CloudtasksProjectsLocationsQueuesTasksCancelLease_598050(
    name: "cloudtasksProjectsLocationsQueuesTasksCancelLease",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{name}:cancelLease",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksCancelLease_598051,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksCancelLease_598052,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesPause_598071 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesPause_598073(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesPause_598072(path: JsonNode;
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
  var valid_598074 = path.getOrDefault("name")
  valid_598074 = validateParameter(valid_598074, JString, required = true,
                                 default = nil)
  if valid_598074 != nil:
    section.add "name", valid_598074
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598075 = query.getOrDefault("upload_protocol")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "upload_protocol", valid_598075
  var valid_598076 = query.getOrDefault("fields")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "fields", valid_598076
  var valid_598077 = query.getOrDefault("quotaUser")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "quotaUser", valid_598077
  var valid_598078 = query.getOrDefault("alt")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = newJString("json"))
  if valid_598078 != nil:
    section.add "alt", valid_598078
  var valid_598079 = query.getOrDefault("oauth_token")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "oauth_token", valid_598079
  var valid_598080 = query.getOrDefault("callback")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "callback", valid_598080
  var valid_598081 = query.getOrDefault("access_token")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "access_token", valid_598081
  var valid_598082 = query.getOrDefault("uploadType")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "uploadType", valid_598082
  var valid_598083 = query.getOrDefault("key")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "key", valid_598083
  var valid_598084 = query.getOrDefault("$.xgafv")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = newJString("1"))
  if valid_598084 != nil:
    section.add "$.xgafv", valid_598084
  var valid_598085 = query.getOrDefault("prettyPrint")
  valid_598085 = validateParameter(valid_598085, JBool, required = false,
                                 default = newJBool(true))
  if valid_598085 != nil:
    section.add "prettyPrint", valid_598085
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

proc call*(call_598087: Call_CloudtasksProjectsLocationsQueuesPause_598071;
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
  let valid = call_598087.validator(path, query, header, formData, body)
  let scheme = call_598087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598087.url(scheme.get, call_598087.host, call_598087.base,
                         call_598087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598087, url, valid)

proc call*(call_598088: Call_CloudtasksProjectsLocationsQueuesPause_598071;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudtasksProjectsLocationsQueuesPause
  ## Pauses the queue.
  ## 
  ## If a queue is paused then the system will stop dispatching tasks
  ## until the queue is resumed via
  ## ResumeQueue. Tasks can still be added
  ## when the queue is paused. A queue is paused if its
  ## state is PAUSED.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The queue name. For example:
  ## `projects/PROJECT_ID/location/LOCATION_ID/queues/QUEUE_ID`
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598089 = newJObject()
  var query_598090 = newJObject()
  var body_598091 = newJObject()
  add(query_598090, "upload_protocol", newJString(uploadProtocol))
  add(query_598090, "fields", newJString(fields))
  add(query_598090, "quotaUser", newJString(quotaUser))
  add(path_598089, "name", newJString(name))
  add(query_598090, "alt", newJString(alt))
  add(query_598090, "oauth_token", newJString(oauthToken))
  add(query_598090, "callback", newJString(callback))
  add(query_598090, "access_token", newJString(accessToken))
  add(query_598090, "uploadType", newJString(uploadType))
  add(query_598090, "key", newJString(key))
  add(query_598090, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598091 = body
  add(query_598090, "prettyPrint", newJBool(prettyPrint))
  result = call_598088.call(path_598089, query_598090, nil, nil, body_598091)

var cloudtasksProjectsLocationsQueuesPause* = Call_CloudtasksProjectsLocationsQueuesPause_598071(
    name: "cloudtasksProjectsLocationsQueuesPause", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}:pause",
    validator: validate_CloudtasksProjectsLocationsQueuesPause_598072, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesPause_598073,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesPurge_598092 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesPurge_598094(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesPurge_598093(path: JsonNode;
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
  var valid_598095 = path.getOrDefault("name")
  valid_598095 = validateParameter(valid_598095, JString, required = true,
                                 default = nil)
  if valid_598095 != nil:
    section.add "name", valid_598095
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598096 = query.getOrDefault("upload_protocol")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "upload_protocol", valid_598096
  var valid_598097 = query.getOrDefault("fields")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "fields", valid_598097
  var valid_598098 = query.getOrDefault("quotaUser")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "quotaUser", valid_598098
  var valid_598099 = query.getOrDefault("alt")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = newJString("json"))
  if valid_598099 != nil:
    section.add "alt", valid_598099
  var valid_598100 = query.getOrDefault("oauth_token")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "oauth_token", valid_598100
  var valid_598101 = query.getOrDefault("callback")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "callback", valid_598101
  var valid_598102 = query.getOrDefault("access_token")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "access_token", valid_598102
  var valid_598103 = query.getOrDefault("uploadType")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "uploadType", valid_598103
  var valid_598104 = query.getOrDefault("key")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "key", valid_598104
  var valid_598105 = query.getOrDefault("$.xgafv")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = newJString("1"))
  if valid_598105 != nil:
    section.add "$.xgafv", valid_598105
  var valid_598106 = query.getOrDefault("prettyPrint")
  valid_598106 = validateParameter(valid_598106, JBool, required = false,
                                 default = newJBool(true))
  if valid_598106 != nil:
    section.add "prettyPrint", valid_598106
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

proc call*(call_598108: Call_CloudtasksProjectsLocationsQueuesPurge_598092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Purges a queue by deleting all of its tasks.
  ## 
  ## All tasks created before this method is called are permanently deleted.
  ## 
  ## Purge operations can take up to one minute to take effect. Tasks
  ## might be dispatched before the purge takes effect. A purge is irreversible.
  ## 
  let valid = call_598108.validator(path, query, header, formData, body)
  let scheme = call_598108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598108.url(scheme.get, call_598108.host, call_598108.base,
                         call_598108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598108, url, valid)

proc call*(call_598109: Call_CloudtasksProjectsLocationsQueuesPurge_598092;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudtasksProjectsLocationsQueuesPurge
  ## Purges a queue by deleting all of its tasks.
  ## 
  ## All tasks created before this method is called are permanently deleted.
  ## 
  ## Purge operations can take up to one minute to take effect. Tasks
  ## might be dispatched before the purge takes effect. A purge is irreversible.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The queue name. For example:
  ## `projects/PROJECT_ID/location/LOCATION_ID/queues/QUEUE_ID`
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598110 = newJObject()
  var query_598111 = newJObject()
  var body_598112 = newJObject()
  add(query_598111, "upload_protocol", newJString(uploadProtocol))
  add(query_598111, "fields", newJString(fields))
  add(query_598111, "quotaUser", newJString(quotaUser))
  add(path_598110, "name", newJString(name))
  add(query_598111, "alt", newJString(alt))
  add(query_598111, "oauth_token", newJString(oauthToken))
  add(query_598111, "callback", newJString(callback))
  add(query_598111, "access_token", newJString(accessToken))
  add(query_598111, "uploadType", newJString(uploadType))
  add(query_598111, "key", newJString(key))
  add(query_598111, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598112 = body
  add(query_598111, "prettyPrint", newJBool(prettyPrint))
  result = call_598109.call(path_598110, query_598111, nil, nil, body_598112)

var cloudtasksProjectsLocationsQueuesPurge* = Call_CloudtasksProjectsLocationsQueuesPurge_598092(
    name: "cloudtasksProjectsLocationsQueuesPurge", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}:purge",
    validator: validate_CloudtasksProjectsLocationsQueuesPurge_598093, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesPurge_598094,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksRenewLease_598113 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesTasksRenewLease_598115(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesTasksRenewLease_598114(
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
  var valid_598116 = path.getOrDefault("name")
  valid_598116 = validateParameter(valid_598116, JString, required = true,
                                 default = nil)
  if valid_598116 != nil:
    section.add "name", valid_598116
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598117 = query.getOrDefault("upload_protocol")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "upload_protocol", valid_598117
  var valid_598118 = query.getOrDefault("fields")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "fields", valid_598118
  var valid_598119 = query.getOrDefault("quotaUser")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "quotaUser", valid_598119
  var valid_598120 = query.getOrDefault("alt")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = newJString("json"))
  if valid_598120 != nil:
    section.add "alt", valid_598120
  var valid_598121 = query.getOrDefault("oauth_token")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "oauth_token", valid_598121
  var valid_598122 = query.getOrDefault("callback")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "callback", valid_598122
  var valid_598123 = query.getOrDefault("access_token")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "access_token", valid_598123
  var valid_598124 = query.getOrDefault("uploadType")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "uploadType", valid_598124
  var valid_598125 = query.getOrDefault("key")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "key", valid_598125
  var valid_598126 = query.getOrDefault("$.xgafv")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = newJString("1"))
  if valid_598126 != nil:
    section.add "$.xgafv", valid_598126
  var valid_598127 = query.getOrDefault("prettyPrint")
  valid_598127 = validateParameter(valid_598127, JBool, required = false,
                                 default = newJBool(true))
  if valid_598127 != nil:
    section.add "prettyPrint", valid_598127
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

proc call*(call_598129: Call_CloudtasksProjectsLocationsQueuesTasksRenewLease_598113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renew the current lease of a pull task.
  ## 
  ## The worker can use this method to extend the lease by a new
  ## duration, starting from now. The new task lease will be
  ## returned in the task's schedule_time.
  ## 
  let valid = call_598129.validator(path, query, header, formData, body)
  let scheme = call_598129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598129.url(scheme.get, call_598129.host, call_598129.base,
                         call_598129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598129, url, valid)

proc call*(call_598130: Call_CloudtasksProjectsLocationsQueuesTasksRenewLease_598113;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksRenewLease
  ## Renew the current lease of a pull task.
  ## 
  ## The worker can use this method to extend the lease by a new
  ## duration, starting from now. The new task lease will be
  ## returned in the task's schedule_time.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598131 = newJObject()
  var query_598132 = newJObject()
  var body_598133 = newJObject()
  add(query_598132, "upload_protocol", newJString(uploadProtocol))
  add(query_598132, "fields", newJString(fields))
  add(query_598132, "quotaUser", newJString(quotaUser))
  add(path_598131, "name", newJString(name))
  add(query_598132, "alt", newJString(alt))
  add(query_598132, "oauth_token", newJString(oauthToken))
  add(query_598132, "callback", newJString(callback))
  add(query_598132, "access_token", newJString(accessToken))
  add(query_598132, "uploadType", newJString(uploadType))
  add(query_598132, "key", newJString(key))
  add(query_598132, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598133 = body
  add(query_598132, "prettyPrint", newJBool(prettyPrint))
  result = call_598130.call(path_598131, query_598132, nil, nil, body_598133)

var cloudtasksProjectsLocationsQueuesTasksRenewLease* = Call_CloudtasksProjectsLocationsQueuesTasksRenewLease_598113(
    name: "cloudtasksProjectsLocationsQueuesTasksRenewLease",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{name}:renewLease",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksRenewLease_598114,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksRenewLease_598115,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesResume_598134 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesResume_598136(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesResume_598135(path: JsonNode;
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
  var valid_598137 = path.getOrDefault("name")
  valid_598137 = validateParameter(valid_598137, JString, required = true,
                                 default = nil)
  if valid_598137 != nil:
    section.add "name", valid_598137
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598138 = query.getOrDefault("upload_protocol")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "upload_protocol", valid_598138
  var valid_598139 = query.getOrDefault("fields")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "fields", valid_598139
  var valid_598140 = query.getOrDefault("quotaUser")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "quotaUser", valid_598140
  var valid_598141 = query.getOrDefault("alt")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = newJString("json"))
  if valid_598141 != nil:
    section.add "alt", valid_598141
  var valid_598142 = query.getOrDefault("oauth_token")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "oauth_token", valid_598142
  var valid_598143 = query.getOrDefault("callback")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "callback", valid_598143
  var valid_598144 = query.getOrDefault("access_token")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "access_token", valid_598144
  var valid_598145 = query.getOrDefault("uploadType")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "uploadType", valid_598145
  var valid_598146 = query.getOrDefault("key")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "key", valid_598146
  var valid_598147 = query.getOrDefault("$.xgafv")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = newJString("1"))
  if valid_598147 != nil:
    section.add "$.xgafv", valid_598147
  var valid_598148 = query.getOrDefault("prettyPrint")
  valid_598148 = validateParameter(valid_598148, JBool, required = false,
                                 default = newJBool(true))
  if valid_598148 != nil:
    section.add "prettyPrint", valid_598148
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

proc call*(call_598150: Call_CloudtasksProjectsLocationsQueuesResume_598134;
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
  let valid = call_598150.validator(path, query, header, formData, body)
  let scheme = call_598150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598150.url(scheme.get, call_598150.host, call_598150.base,
                         call_598150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598150, url, valid)

proc call*(call_598151: Call_CloudtasksProjectsLocationsQueuesResume_598134;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The queue name. For example:
  ## `projects/PROJECT_ID/location/LOCATION_ID/queues/QUEUE_ID`
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598152 = newJObject()
  var query_598153 = newJObject()
  var body_598154 = newJObject()
  add(query_598153, "upload_protocol", newJString(uploadProtocol))
  add(query_598153, "fields", newJString(fields))
  add(query_598153, "quotaUser", newJString(quotaUser))
  add(path_598152, "name", newJString(name))
  add(query_598153, "alt", newJString(alt))
  add(query_598153, "oauth_token", newJString(oauthToken))
  add(query_598153, "callback", newJString(callback))
  add(query_598153, "access_token", newJString(accessToken))
  add(query_598153, "uploadType", newJString(uploadType))
  add(query_598153, "key", newJString(key))
  add(query_598153, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598154 = body
  add(query_598153, "prettyPrint", newJBool(prettyPrint))
  result = call_598151.call(path_598152, query_598153, nil, nil, body_598154)

var cloudtasksProjectsLocationsQueuesResume* = Call_CloudtasksProjectsLocationsQueuesResume_598134(
    name: "cloudtasksProjectsLocationsQueuesResume", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}:resume",
    validator: validate_CloudtasksProjectsLocationsQueuesResume_598135, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesResume_598136,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksRun_598155 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesTasksRun_598157(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesTasksRun_598156(path: JsonNode;
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
  var valid_598158 = path.getOrDefault("name")
  valid_598158 = validateParameter(valid_598158, JString, required = true,
                                 default = nil)
  if valid_598158 != nil:
    section.add "name", valid_598158
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598159 = query.getOrDefault("upload_protocol")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "upload_protocol", valid_598159
  var valid_598160 = query.getOrDefault("fields")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "fields", valid_598160
  var valid_598161 = query.getOrDefault("quotaUser")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "quotaUser", valid_598161
  var valid_598162 = query.getOrDefault("alt")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = newJString("json"))
  if valid_598162 != nil:
    section.add "alt", valid_598162
  var valid_598163 = query.getOrDefault("oauth_token")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "oauth_token", valid_598163
  var valid_598164 = query.getOrDefault("callback")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = nil)
  if valid_598164 != nil:
    section.add "callback", valid_598164
  var valid_598165 = query.getOrDefault("access_token")
  valid_598165 = validateParameter(valid_598165, JString, required = false,
                                 default = nil)
  if valid_598165 != nil:
    section.add "access_token", valid_598165
  var valid_598166 = query.getOrDefault("uploadType")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = nil)
  if valid_598166 != nil:
    section.add "uploadType", valid_598166
  var valid_598167 = query.getOrDefault("key")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "key", valid_598167
  var valid_598168 = query.getOrDefault("$.xgafv")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = newJString("1"))
  if valid_598168 != nil:
    section.add "$.xgafv", valid_598168
  var valid_598169 = query.getOrDefault("prettyPrint")
  valid_598169 = validateParameter(valid_598169, JBool, required = false,
                                 default = newJBool(true))
  if valid_598169 != nil:
    section.add "prettyPrint", valid_598169
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

proc call*(call_598171: Call_CloudtasksProjectsLocationsQueuesTasksRun_598155;
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
  let valid = call_598171.validator(path, query, header, formData, body)
  let scheme = call_598171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598171.url(scheme.get, call_598171.host, call_598171.base,
                         call_598171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598171, url, valid)

proc call*(call_598172: Call_CloudtasksProjectsLocationsQueuesTasksRun_598155;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598173 = newJObject()
  var query_598174 = newJObject()
  var body_598175 = newJObject()
  add(query_598174, "upload_protocol", newJString(uploadProtocol))
  add(query_598174, "fields", newJString(fields))
  add(query_598174, "quotaUser", newJString(quotaUser))
  add(path_598173, "name", newJString(name))
  add(query_598174, "alt", newJString(alt))
  add(query_598174, "oauth_token", newJString(oauthToken))
  add(query_598174, "callback", newJString(callback))
  add(query_598174, "access_token", newJString(accessToken))
  add(query_598174, "uploadType", newJString(uploadType))
  add(query_598174, "key", newJString(key))
  add(query_598174, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598175 = body
  add(query_598174, "prettyPrint", newJBool(prettyPrint))
  result = call_598172.call(path_598173, query_598174, nil, nil, body_598175)

var cloudtasksProjectsLocationsQueuesTasksRun* = Call_CloudtasksProjectsLocationsQueuesTasksRun_598155(
    name: "cloudtasksProjectsLocationsQueuesTasksRun", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}:run",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksRun_598156,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksRun_598157,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesCreate_598198 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesCreate_598200(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesCreate_598199(path: JsonNode;
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
  var valid_598201 = path.getOrDefault("parent")
  valid_598201 = validateParameter(valid_598201, JString, required = true,
                                 default = nil)
  if valid_598201 != nil:
    section.add "parent", valid_598201
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598202 = query.getOrDefault("upload_protocol")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = nil)
  if valid_598202 != nil:
    section.add "upload_protocol", valid_598202
  var valid_598203 = query.getOrDefault("fields")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "fields", valid_598203
  var valid_598204 = query.getOrDefault("quotaUser")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "quotaUser", valid_598204
  var valid_598205 = query.getOrDefault("alt")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = newJString("json"))
  if valid_598205 != nil:
    section.add "alt", valid_598205
  var valid_598206 = query.getOrDefault("oauth_token")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "oauth_token", valid_598206
  var valid_598207 = query.getOrDefault("callback")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = nil)
  if valid_598207 != nil:
    section.add "callback", valid_598207
  var valid_598208 = query.getOrDefault("access_token")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "access_token", valid_598208
  var valid_598209 = query.getOrDefault("uploadType")
  valid_598209 = validateParameter(valid_598209, JString, required = false,
                                 default = nil)
  if valid_598209 != nil:
    section.add "uploadType", valid_598209
  var valid_598210 = query.getOrDefault("key")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "key", valid_598210
  var valid_598211 = query.getOrDefault("$.xgafv")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = newJString("1"))
  if valid_598211 != nil:
    section.add "$.xgafv", valid_598211
  var valid_598212 = query.getOrDefault("prettyPrint")
  valid_598212 = validateParameter(valid_598212, JBool, required = false,
                                 default = newJBool(true))
  if valid_598212 != nil:
    section.add "prettyPrint", valid_598212
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

proc call*(call_598214: Call_CloudtasksProjectsLocationsQueuesCreate_598198;
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
  let valid = call_598214.validator(path, query, header, formData, body)
  let scheme = call_598214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598214.url(scheme.get, call_598214.host, call_598214.base,
                         call_598214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598214, url, valid)

proc call*(call_598215: Call_CloudtasksProjectsLocationsQueuesCreate_598198;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The location name in which the queue will be created.
  ## For example: `projects/PROJECT_ID/locations/LOCATION_ID`
  ## 
  ## The list of allowed locations can be obtained by calling Cloud
  ## Tasks' implementation of
  ## ListLocations.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598216 = newJObject()
  var query_598217 = newJObject()
  var body_598218 = newJObject()
  add(query_598217, "upload_protocol", newJString(uploadProtocol))
  add(query_598217, "fields", newJString(fields))
  add(query_598217, "quotaUser", newJString(quotaUser))
  add(query_598217, "alt", newJString(alt))
  add(query_598217, "oauth_token", newJString(oauthToken))
  add(query_598217, "callback", newJString(callback))
  add(query_598217, "access_token", newJString(accessToken))
  add(query_598217, "uploadType", newJString(uploadType))
  add(path_598216, "parent", newJString(parent))
  add(query_598217, "key", newJString(key))
  add(query_598217, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598218 = body
  add(query_598217, "prettyPrint", newJBool(prettyPrint))
  result = call_598215.call(path_598216, query_598217, nil, nil, body_598218)

var cloudtasksProjectsLocationsQueuesCreate* = Call_CloudtasksProjectsLocationsQueuesCreate_598198(
    name: "cloudtasksProjectsLocationsQueuesCreate", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{parent}/queues",
    validator: validate_CloudtasksProjectsLocationsQueuesCreate_598199, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesCreate_598200,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesList_598176 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesList_598178(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesList_598177(path: JsonNode;
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
  var valid_598179 = path.getOrDefault("parent")
  valid_598179 = validateParameter(valid_598179, JString, required = true,
                                 default = nil)
  if valid_598179 != nil:
    section.add "parent", valid_598179
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying the page of results to return.
  ## 
  ## To request the first page results, page_token must be empty. To
  ## request the next page of results, page_token must be the value of
  ## next_page_token returned
  ## from the previous call to ListQueues
  ## method. It is an error to switch the value of the
  ## filter while iterating through pages.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  section = newJObject()
  var valid_598180 = query.getOrDefault("upload_protocol")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "upload_protocol", valid_598180
  var valid_598181 = query.getOrDefault("fields")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = nil)
  if valid_598181 != nil:
    section.add "fields", valid_598181
  var valid_598182 = query.getOrDefault("pageToken")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = nil)
  if valid_598182 != nil:
    section.add "pageToken", valid_598182
  var valid_598183 = query.getOrDefault("quotaUser")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "quotaUser", valid_598183
  var valid_598184 = query.getOrDefault("alt")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = newJString("json"))
  if valid_598184 != nil:
    section.add "alt", valid_598184
  var valid_598185 = query.getOrDefault("oauth_token")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "oauth_token", valid_598185
  var valid_598186 = query.getOrDefault("callback")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "callback", valid_598186
  var valid_598187 = query.getOrDefault("access_token")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = nil)
  if valid_598187 != nil:
    section.add "access_token", valid_598187
  var valid_598188 = query.getOrDefault("uploadType")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = nil)
  if valid_598188 != nil:
    section.add "uploadType", valid_598188
  var valid_598189 = query.getOrDefault("key")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "key", valid_598189
  var valid_598190 = query.getOrDefault("$.xgafv")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = newJString("1"))
  if valid_598190 != nil:
    section.add "$.xgafv", valid_598190
  var valid_598191 = query.getOrDefault("pageSize")
  valid_598191 = validateParameter(valid_598191, JInt, required = false, default = nil)
  if valid_598191 != nil:
    section.add "pageSize", valid_598191
  var valid_598192 = query.getOrDefault("prettyPrint")
  valid_598192 = validateParameter(valid_598192, JBool, required = false,
                                 default = newJBool(true))
  if valid_598192 != nil:
    section.add "prettyPrint", valid_598192
  var valid_598193 = query.getOrDefault("filter")
  valid_598193 = validateParameter(valid_598193, JString, required = false,
                                 default = nil)
  if valid_598193 != nil:
    section.add "filter", valid_598193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598194: Call_CloudtasksProjectsLocationsQueuesList_598176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists queues.
  ## 
  ## Queues are returned in lexicographical order.
  ## 
  let valid = call_598194.validator(path, query, header, formData, body)
  let scheme = call_598194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598194.url(scheme.get, call_598194.host, call_598194.base,
                         call_598194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598194, url, valid)

proc call*(call_598195: Call_CloudtasksProjectsLocationsQueuesList_598176;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudtasksProjectsLocationsQueuesList
  ## Lists queues.
  ## 
  ## Queues are returned in lexicographical order.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying the page of results to return.
  ## 
  ## To request the first page results, page_token must be empty. To
  ## request the next page of results, page_token must be the value of
  ## next_page_token returned
  ## from the previous call to ListQueues
  ## method. It is an error to switch the value of the
  ## filter while iterating through pages.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The location name.
  ## For example: `projects/PROJECT_ID/locations/LOCATION_ID`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  var path_598196 = newJObject()
  var query_598197 = newJObject()
  add(query_598197, "upload_protocol", newJString(uploadProtocol))
  add(query_598197, "fields", newJString(fields))
  add(query_598197, "pageToken", newJString(pageToken))
  add(query_598197, "quotaUser", newJString(quotaUser))
  add(query_598197, "alt", newJString(alt))
  add(query_598197, "oauth_token", newJString(oauthToken))
  add(query_598197, "callback", newJString(callback))
  add(query_598197, "access_token", newJString(accessToken))
  add(query_598197, "uploadType", newJString(uploadType))
  add(path_598196, "parent", newJString(parent))
  add(query_598197, "key", newJString(key))
  add(query_598197, "$.xgafv", newJString(Xgafv))
  add(query_598197, "pageSize", newJInt(pageSize))
  add(query_598197, "prettyPrint", newJBool(prettyPrint))
  add(query_598197, "filter", newJString(filter))
  result = call_598195.call(path_598196, query_598197, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesList* = Call_CloudtasksProjectsLocationsQueuesList_598176(
    name: "cloudtasksProjectsLocationsQueuesList", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{parent}/queues",
    validator: validate_CloudtasksProjectsLocationsQueuesList_598177, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesList_598178, schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksCreate_598241 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesTasksCreate_598243(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesTasksCreate_598242(path: JsonNode;
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
  var valid_598244 = path.getOrDefault("parent")
  valid_598244 = validateParameter(valid_598244, JString, required = true,
                                 default = nil)
  if valid_598244 != nil:
    section.add "parent", valid_598244
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598245 = query.getOrDefault("upload_protocol")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "upload_protocol", valid_598245
  var valid_598246 = query.getOrDefault("fields")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "fields", valid_598246
  var valid_598247 = query.getOrDefault("quotaUser")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = nil)
  if valid_598247 != nil:
    section.add "quotaUser", valid_598247
  var valid_598248 = query.getOrDefault("alt")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = newJString("json"))
  if valid_598248 != nil:
    section.add "alt", valid_598248
  var valid_598249 = query.getOrDefault("oauth_token")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "oauth_token", valid_598249
  var valid_598250 = query.getOrDefault("callback")
  valid_598250 = validateParameter(valid_598250, JString, required = false,
                                 default = nil)
  if valid_598250 != nil:
    section.add "callback", valid_598250
  var valid_598251 = query.getOrDefault("access_token")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = nil)
  if valid_598251 != nil:
    section.add "access_token", valid_598251
  var valid_598252 = query.getOrDefault("uploadType")
  valid_598252 = validateParameter(valid_598252, JString, required = false,
                                 default = nil)
  if valid_598252 != nil:
    section.add "uploadType", valid_598252
  var valid_598253 = query.getOrDefault("key")
  valid_598253 = validateParameter(valid_598253, JString, required = false,
                                 default = nil)
  if valid_598253 != nil:
    section.add "key", valid_598253
  var valid_598254 = query.getOrDefault("$.xgafv")
  valid_598254 = validateParameter(valid_598254, JString, required = false,
                                 default = newJString("1"))
  if valid_598254 != nil:
    section.add "$.xgafv", valid_598254
  var valid_598255 = query.getOrDefault("prettyPrint")
  valid_598255 = validateParameter(valid_598255, JBool, required = false,
                                 default = newJBool(true))
  if valid_598255 != nil:
    section.add "prettyPrint", valid_598255
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

proc call*(call_598257: Call_CloudtasksProjectsLocationsQueuesTasksCreate_598241;
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
  let valid = call_598257.validator(path, query, header, formData, body)
  let scheme = call_598257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598257.url(scheme.get, call_598257.host, call_598257.base,
                         call_598257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598257, url, valid)

proc call*(call_598258: Call_CloudtasksProjectsLocationsQueuesTasksCreate_598241;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksCreate
  ## Creates a task and adds it to a queue.
  ## 
  ## Tasks cannot be updated after creation; there is no UpdateTask command.
  ## 
  ## * For App Engine queues, the maximum task size is
  ##   100KB.
  ## * For pull queues, the maximum task size is 1MB.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The queue name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID`
  ## 
  ## The queue must already exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598259 = newJObject()
  var query_598260 = newJObject()
  var body_598261 = newJObject()
  add(query_598260, "upload_protocol", newJString(uploadProtocol))
  add(query_598260, "fields", newJString(fields))
  add(query_598260, "quotaUser", newJString(quotaUser))
  add(query_598260, "alt", newJString(alt))
  add(query_598260, "oauth_token", newJString(oauthToken))
  add(query_598260, "callback", newJString(callback))
  add(query_598260, "access_token", newJString(accessToken))
  add(query_598260, "uploadType", newJString(uploadType))
  add(path_598259, "parent", newJString(parent))
  add(query_598260, "key", newJString(key))
  add(query_598260, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598261 = body
  add(query_598260, "prettyPrint", newJBool(prettyPrint))
  result = call_598258.call(path_598259, query_598260, nil, nil, body_598261)

var cloudtasksProjectsLocationsQueuesTasksCreate* = Call_CloudtasksProjectsLocationsQueuesTasksCreate_598241(
    name: "cloudtasksProjectsLocationsQueuesTasksCreate",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{parent}/tasks",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksCreate_598242,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksCreate_598243,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksList_598219 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesTasksList_598221(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesTasksList_598220(path: JsonNode;
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
  var valid_598222 = path.getOrDefault("parent")
  valid_598222 = validateParameter(valid_598222, JString, required = true,
                                 default = nil)
  if valid_598222 != nil:
    section.add "parent", valid_598222
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  section = newJObject()
  var valid_598223 = query.getOrDefault("upload_protocol")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = nil)
  if valid_598223 != nil:
    section.add "upload_protocol", valid_598223
  var valid_598224 = query.getOrDefault("fields")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "fields", valid_598224
  var valid_598225 = query.getOrDefault("pageToken")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "pageToken", valid_598225
  var valid_598226 = query.getOrDefault("quotaUser")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "quotaUser", valid_598226
  var valid_598227 = query.getOrDefault("alt")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = newJString("json"))
  if valid_598227 != nil:
    section.add "alt", valid_598227
  var valid_598228 = query.getOrDefault("oauth_token")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = nil)
  if valid_598228 != nil:
    section.add "oauth_token", valid_598228
  var valid_598229 = query.getOrDefault("callback")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = nil)
  if valid_598229 != nil:
    section.add "callback", valid_598229
  var valid_598230 = query.getOrDefault("access_token")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "access_token", valid_598230
  var valid_598231 = query.getOrDefault("uploadType")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = nil)
  if valid_598231 != nil:
    section.add "uploadType", valid_598231
  var valid_598232 = query.getOrDefault("key")
  valid_598232 = validateParameter(valid_598232, JString, required = false,
                                 default = nil)
  if valid_598232 != nil:
    section.add "key", valid_598232
  var valid_598233 = query.getOrDefault("$.xgafv")
  valid_598233 = validateParameter(valid_598233, JString, required = false,
                                 default = newJString("1"))
  if valid_598233 != nil:
    section.add "$.xgafv", valid_598233
  var valid_598234 = query.getOrDefault("pageSize")
  valid_598234 = validateParameter(valid_598234, JInt, required = false, default = nil)
  if valid_598234 != nil:
    section.add "pageSize", valid_598234
  var valid_598235 = query.getOrDefault("prettyPrint")
  valid_598235 = validateParameter(valid_598235, JBool, required = false,
                                 default = newJBool(true))
  if valid_598235 != nil:
    section.add "prettyPrint", valid_598235
  var valid_598236 = query.getOrDefault("responseView")
  valid_598236 = validateParameter(valid_598236, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_598236 != nil:
    section.add "responseView", valid_598236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598237: Call_CloudtasksProjectsLocationsQueuesTasksList_598219;
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
  let valid = call_598237.validator(path, query, header, formData, body)
  let scheme = call_598237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598237.url(scheme.get, call_598237.host, call_598237.base,
                         call_598237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598237, url, valid)

proc call*(call_598238: Call_CloudtasksProjectsLocationsQueuesTasksList_598219;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; responseView: string = "VIEW_UNSPECIFIED"): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
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
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The queue name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  var path_598239 = newJObject()
  var query_598240 = newJObject()
  add(query_598240, "upload_protocol", newJString(uploadProtocol))
  add(query_598240, "fields", newJString(fields))
  add(query_598240, "pageToken", newJString(pageToken))
  add(query_598240, "quotaUser", newJString(quotaUser))
  add(query_598240, "alt", newJString(alt))
  add(query_598240, "oauth_token", newJString(oauthToken))
  add(query_598240, "callback", newJString(callback))
  add(query_598240, "access_token", newJString(accessToken))
  add(query_598240, "uploadType", newJString(uploadType))
  add(path_598239, "parent", newJString(parent))
  add(query_598240, "key", newJString(key))
  add(query_598240, "$.xgafv", newJString(Xgafv))
  add(query_598240, "pageSize", newJInt(pageSize))
  add(query_598240, "prettyPrint", newJBool(prettyPrint))
  add(query_598240, "responseView", newJString(responseView))
  result = call_598238.call(path_598239, query_598240, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesTasksList* = Call_CloudtasksProjectsLocationsQueuesTasksList_598219(
    name: "cloudtasksProjectsLocationsQueuesTasksList", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{parent}/tasks",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksList_598220,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksList_598221,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksLease_598262 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesTasksLease_598264(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesTasksLease_598263(path: JsonNode;
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
  var valid_598265 = path.getOrDefault("parent")
  valid_598265 = validateParameter(valid_598265, JString, required = true,
                                 default = nil)
  if valid_598265 != nil:
    section.add "parent", valid_598265
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598266 = query.getOrDefault("upload_protocol")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "upload_protocol", valid_598266
  var valid_598267 = query.getOrDefault("fields")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "fields", valid_598267
  var valid_598268 = query.getOrDefault("quotaUser")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = nil)
  if valid_598268 != nil:
    section.add "quotaUser", valid_598268
  var valid_598269 = query.getOrDefault("alt")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = newJString("json"))
  if valid_598269 != nil:
    section.add "alt", valid_598269
  var valid_598270 = query.getOrDefault("oauth_token")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = nil)
  if valid_598270 != nil:
    section.add "oauth_token", valid_598270
  var valid_598271 = query.getOrDefault("callback")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = nil)
  if valid_598271 != nil:
    section.add "callback", valid_598271
  var valid_598272 = query.getOrDefault("access_token")
  valid_598272 = validateParameter(valid_598272, JString, required = false,
                                 default = nil)
  if valid_598272 != nil:
    section.add "access_token", valid_598272
  var valid_598273 = query.getOrDefault("uploadType")
  valid_598273 = validateParameter(valid_598273, JString, required = false,
                                 default = nil)
  if valid_598273 != nil:
    section.add "uploadType", valid_598273
  var valid_598274 = query.getOrDefault("key")
  valid_598274 = validateParameter(valid_598274, JString, required = false,
                                 default = nil)
  if valid_598274 != nil:
    section.add "key", valid_598274
  var valid_598275 = query.getOrDefault("$.xgafv")
  valid_598275 = validateParameter(valid_598275, JString, required = false,
                                 default = newJString("1"))
  if valid_598275 != nil:
    section.add "$.xgafv", valid_598275
  var valid_598276 = query.getOrDefault("prettyPrint")
  valid_598276 = validateParameter(valid_598276, JBool, required = false,
                                 default = newJBool(true))
  if valid_598276 != nil:
    section.add "prettyPrint", valid_598276
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

proc call*(call_598278: Call_CloudtasksProjectsLocationsQueuesTasksLease_598262;
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
  let valid = call_598278.validator(path, query, header, formData, body)
  let scheme = call_598278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598278.url(scheme.get, call_598278.host, call_598278.base,
                         call_598278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598278, url, valid)

proc call*(call_598279: Call_CloudtasksProjectsLocationsQueuesTasksLease_598262;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The queue name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598280 = newJObject()
  var query_598281 = newJObject()
  var body_598282 = newJObject()
  add(query_598281, "upload_protocol", newJString(uploadProtocol))
  add(query_598281, "fields", newJString(fields))
  add(query_598281, "quotaUser", newJString(quotaUser))
  add(query_598281, "alt", newJString(alt))
  add(query_598281, "oauth_token", newJString(oauthToken))
  add(query_598281, "callback", newJString(callback))
  add(query_598281, "access_token", newJString(accessToken))
  add(query_598281, "uploadType", newJString(uploadType))
  add(path_598280, "parent", newJString(parent))
  add(query_598281, "key", newJString(key))
  add(query_598281, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598282 = body
  add(query_598281, "prettyPrint", newJBool(prettyPrint))
  result = call_598279.call(path_598280, query_598281, nil, nil, body_598282)

var cloudtasksProjectsLocationsQueuesTasksLease* = Call_CloudtasksProjectsLocationsQueuesTasksLease_598262(
    name: "cloudtasksProjectsLocationsQueuesTasksLease",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{parent}/tasks:lease",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksLease_598263,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksLease_598264,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_598283 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesGetIamPolicy_598285(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesGetIamPolicy_598284(
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
  var valid_598286 = path.getOrDefault("resource")
  valid_598286 = validateParameter(valid_598286, JString, required = true,
                                 default = nil)
  if valid_598286 != nil:
    section.add "resource", valid_598286
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598287 = query.getOrDefault("upload_protocol")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "upload_protocol", valid_598287
  var valid_598288 = query.getOrDefault("fields")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = nil)
  if valid_598288 != nil:
    section.add "fields", valid_598288
  var valid_598289 = query.getOrDefault("quotaUser")
  valid_598289 = validateParameter(valid_598289, JString, required = false,
                                 default = nil)
  if valid_598289 != nil:
    section.add "quotaUser", valid_598289
  var valid_598290 = query.getOrDefault("alt")
  valid_598290 = validateParameter(valid_598290, JString, required = false,
                                 default = newJString("json"))
  if valid_598290 != nil:
    section.add "alt", valid_598290
  var valid_598291 = query.getOrDefault("oauth_token")
  valid_598291 = validateParameter(valid_598291, JString, required = false,
                                 default = nil)
  if valid_598291 != nil:
    section.add "oauth_token", valid_598291
  var valid_598292 = query.getOrDefault("callback")
  valid_598292 = validateParameter(valid_598292, JString, required = false,
                                 default = nil)
  if valid_598292 != nil:
    section.add "callback", valid_598292
  var valid_598293 = query.getOrDefault("access_token")
  valid_598293 = validateParameter(valid_598293, JString, required = false,
                                 default = nil)
  if valid_598293 != nil:
    section.add "access_token", valid_598293
  var valid_598294 = query.getOrDefault("uploadType")
  valid_598294 = validateParameter(valid_598294, JString, required = false,
                                 default = nil)
  if valid_598294 != nil:
    section.add "uploadType", valid_598294
  var valid_598295 = query.getOrDefault("key")
  valid_598295 = validateParameter(valid_598295, JString, required = false,
                                 default = nil)
  if valid_598295 != nil:
    section.add "key", valid_598295
  var valid_598296 = query.getOrDefault("$.xgafv")
  valid_598296 = validateParameter(valid_598296, JString, required = false,
                                 default = newJString("1"))
  if valid_598296 != nil:
    section.add "$.xgafv", valid_598296
  var valid_598297 = query.getOrDefault("prettyPrint")
  valid_598297 = validateParameter(valid_598297, JBool, required = false,
                                 default = newJBool(true))
  if valid_598297 != nil:
    section.add "prettyPrint", valid_598297
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

proc call*(call_598299: Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_598283;
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
  let valid = call_598299.validator(path, query, header, formData, body)
  let scheme = call_598299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598299.url(scheme.get, call_598299.host, call_598299.base,
                         call_598299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598299, url, valid)

proc call*(call_598300: Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_598283;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598301 = newJObject()
  var query_598302 = newJObject()
  var body_598303 = newJObject()
  add(query_598302, "upload_protocol", newJString(uploadProtocol))
  add(query_598302, "fields", newJString(fields))
  add(query_598302, "quotaUser", newJString(quotaUser))
  add(query_598302, "alt", newJString(alt))
  add(query_598302, "oauth_token", newJString(oauthToken))
  add(query_598302, "callback", newJString(callback))
  add(query_598302, "access_token", newJString(accessToken))
  add(query_598302, "uploadType", newJString(uploadType))
  add(query_598302, "key", newJString(key))
  add(query_598302, "$.xgafv", newJString(Xgafv))
  add(path_598301, "resource", newJString(resource))
  if body != nil:
    body_598303 = body
  add(query_598302, "prettyPrint", newJBool(prettyPrint))
  result = call_598300.call(path_598301, query_598302, nil, nil, body_598303)

var cloudtasksProjectsLocationsQueuesGetIamPolicy* = Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_598283(
    name: "cloudtasksProjectsLocationsQueuesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{resource}:getIamPolicy",
    validator: validate_CloudtasksProjectsLocationsQueuesGetIamPolicy_598284,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesGetIamPolicy_598285,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_598304 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesSetIamPolicy_598306(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesSetIamPolicy_598305(
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
  var valid_598307 = path.getOrDefault("resource")
  valid_598307 = validateParameter(valid_598307, JString, required = true,
                                 default = nil)
  if valid_598307 != nil:
    section.add "resource", valid_598307
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598308 = query.getOrDefault("upload_protocol")
  valid_598308 = validateParameter(valid_598308, JString, required = false,
                                 default = nil)
  if valid_598308 != nil:
    section.add "upload_protocol", valid_598308
  var valid_598309 = query.getOrDefault("fields")
  valid_598309 = validateParameter(valid_598309, JString, required = false,
                                 default = nil)
  if valid_598309 != nil:
    section.add "fields", valid_598309
  var valid_598310 = query.getOrDefault("quotaUser")
  valid_598310 = validateParameter(valid_598310, JString, required = false,
                                 default = nil)
  if valid_598310 != nil:
    section.add "quotaUser", valid_598310
  var valid_598311 = query.getOrDefault("alt")
  valid_598311 = validateParameter(valid_598311, JString, required = false,
                                 default = newJString("json"))
  if valid_598311 != nil:
    section.add "alt", valid_598311
  var valid_598312 = query.getOrDefault("oauth_token")
  valid_598312 = validateParameter(valid_598312, JString, required = false,
                                 default = nil)
  if valid_598312 != nil:
    section.add "oauth_token", valid_598312
  var valid_598313 = query.getOrDefault("callback")
  valid_598313 = validateParameter(valid_598313, JString, required = false,
                                 default = nil)
  if valid_598313 != nil:
    section.add "callback", valid_598313
  var valid_598314 = query.getOrDefault("access_token")
  valid_598314 = validateParameter(valid_598314, JString, required = false,
                                 default = nil)
  if valid_598314 != nil:
    section.add "access_token", valid_598314
  var valid_598315 = query.getOrDefault("uploadType")
  valid_598315 = validateParameter(valid_598315, JString, required = false,
                                 default = nil)
  if valid_598315 != nil:
    section.add "uploadType", valid_598315
  var valid_598316 = query.getOrDefault("key")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = nil)
  if valid_598316 != nil:
    section.add "key", valid_598316
  var valid_598317 = query.getOrDefault("$.xgafv")
  valid_598317 = validateParameter(valid_598317, JString, required = false,
                                 default = newJString("1"))
  if valid_598317 != nil:
    section.add "$.xgafv", valid_598317
  var valid_598318 = query.getOrDefault("prettyPrint")
  valid_598318 = validateParameter(valid_598318, JBool, required = false,
                                 default = newJBool(true))
  if valid_598318 != nil:
    section.add "prettyPrint", valid_598318
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

proc call*(call_598320: Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_598304;
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
  let valid = call_598320.validator(path, query, header, formData, body)
  let scheme = call_598320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598320.url(scheme.get, call_598320.host, call_598320.base,
                         call_598320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598320, url, valid)

proc call*(call_598321: Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_598304;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598322 = newJObject()
  var query_598323 = newJObject()
  var body_598324 = newJObject()
  add(query_598323, "upload_protocol", newJString(uploadProtocol))
  add(query_598323, "fields", newJString(fields))
  add(query_598323, "quotaUser", newJString(quotaUser))
  add(query_598323, "alt", newJString(alt))
  add(query_598323, "oauth_token", newJString(oauthToken))
  add(query_598323, "callback", newJString(callback))
  add(query_598323, "access_token", newJString(accessToken))
  add(query_598323, "uploadType", newJString(uploadType))
  add(query_598323, "key", newJString(key))
  add(query_598323, "$.xgafv", newJString(Xgafv))
  add(path_598322, "resource", newJString(resource))
  if body != nil:
    body_598324 = body
  add(query_598323, "prettyPrint", newJBool(prettyPrint))
  result = call_598321.call(path_598322, query_598323, nil, nil, body_598324)

var cloudtasksProjectsLocationsQueuesSetIamPolicy* = Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_598304(
    name: "cloudtasksProjectsLocationsQueuesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{resource}:setIamPolicy",
    validator: validate_CloudtasksProjectsLocationsQueuesSetIamPolicy_598305,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesSetIamPolicy_598306,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_598325 = ref object of OpenApiRestCall_597408
proc url_CloudtasksProjectsLocationsQueuesTestIamPermissions_598327(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtasksProjectsLocationsQueuesTestIamPermissions_598326(
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
  var valid_598328 = path.getOrDefault("resource")
  valid_598328 = validateParameter(valid_598328, JString, required = true,
                                 default = nil)
  if valid_598328 != nil:
    section.add "resource", valid_598328
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598329 = query.getOrDefault("upload_protocol")
  valid_598329 = validateParameter(valid_598329, JString, required = false,
                                 default = nil)
  if valid_598329 != nil:
    section.add "upload_protocol", valid_598329
  var valid_598330 = query.getOrDefault("fields")
  valid_598330 = validateParameter(valid_598330, JString, required = false,
                                 default = nil)
  if valid_598330 != nil:
    section.add "fields", valid_598330
  var valid_598331 = query.getOrDefault("quotaUser")
  valid_598331 = validateParameter(valid_598331, JString, required = false,
                                 default = nil)
  if valid_598331 != nil:
    section.add "quotaUser", valid_598331
  var valid_598332 = query.getOrDefault("alt")
  valid_598332 = validateParameter(valid_598332, JString, required = false,
                                 default = newJString("json"))
  if valid_598332 != nil:
    section.add "alt", valid_598332
  var valid_598333 = query.getOrDefault("oauth_token")
  valid_598333 = validateParameter(valid_598333, JString, required = false,
                                 default = nil)
  if valid_598333 != nil:
    section.add "oauth_token", valid_598333
  var valid_598334 = query.getOrDefault("callback")
  valid_598334 = validateParameter(valid_598334, JString, required = false,
                                 default = nil)
  if valid_598334 != nil:
    section.add "callback", valid_598334
  var valid_598335 = query.getOrDefault("access_token")
  valid_598335 = validateParameter(valid_598335, JString, required = false,
                                 default = nil)
  if valid_598335 != nil:
    section.add "access_token", valid_598335
  var valid_598336 = query.getOrDefault("uploadType")
  valid_598336 = validateParameter(valid_598336, JString, required = false,
                                 default = nil)
  if valid_598336 != nil:
    section.add "uploadType", valid_598336
  var valid_598337 = query.getOrDefault("key")
  valid_598337 = validateParameter(valid_598337, JString, required = false,
                                 default = nil)
  if valid_598337 != nil:
    section.add "key", valid_598337
  var valid_598338 = query.getOrDefault("$.xgafv")
  valid_598338 = validateParameter(valid_598338, JString, required = false,
                                 default = newJString("1"))
  if valid_598338 != nil:
    section.add "$.xgafv", valid_598338
  var valid_598339 = query.getOrDefault("prettyPrint")
  valid_598339 = validateParameter(valid_598339, JBool, required = false,
                                 default = newJBool(true))
  if valid_598339 != nil:
    section.add "prettyPrint", valid_598339
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

proc call*(call_598341: Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_598325;
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
  let valid = call_598341.validator(path, query, header, formData, body)
  let scheme = call_598341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598341.url(scheme.get, call_598341.host, call_598341.base,
                         call_598341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598341, url, valid)

proc call*(call_598342: Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_598325;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudtasksProjectsLocationsQueuesTestIamPermissions
  ## Returns permissions that a caller has on a Queue.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598343 = newJObject()
  var query_598344 = newJObject()
  var body_598345 = newJObject()
  add(query_598344, "upload_protocol", newJString(uploadProtocol))
  add(query_598344, "fields", newJString(fields))
  add(query_598344, "quotaUser", newJString(quotaUser))
  add(query_598344, "alt", newJString(alt))
  add(query_598344, "oauth_token", newJString(oauthToken))
  add(query_598344, "callback", newJString(callback))
  add(query_598344, "access_token", newJString(accessToken))
  add(query_598344, "uploadType", newJString(uploadType))
  add(query_598344, "key", newJString(key))
  add(query_598344, "$.xgafv", newJString(Xgafv))
  add(path_598343, "resource", newJString(resource))
  if body != nil:
    body_598345 = body
  add(query_598344, "prettyPrint", newJBool(prettyPrint))
  result = call_598342.call(path_598343, query_598344, nil, nil, body_598345)

var cloudtasksProjectsLocationsQueuesTestIamPermissions* = Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_598325(
    name: "cloudtasksProjectsLocationsQueuesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{resource}:testIamPermissions",
    validator: validate_CloudtasksProjectsLocationsQueuesTestIamPermissions_598326,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTestIamPermissions_598327,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
