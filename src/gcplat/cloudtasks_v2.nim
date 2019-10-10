
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Tasks
## version: v2
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
  gcpServiceName = "cloudtasks"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudtasksProjectsLocationsQueuesTasksGet_588710 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesTasksGet_588712(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksGet_588711(path: JsonNode;
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
  var valid_588838 = path.getOrDefault("name")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "name", valid_588838
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
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("callback")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "callback", valid_588857
  var valid_588858 = query.getOrDefault("access_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "access_token", valid_588858
  var valid_588859 = query.getOrDefault("uploadType")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "uploadType", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("$.xgafv")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = newJString("1"))
  if valid_588861 != nil:
    section.add "$.xgafv", valid_588861
  var valid_588862 = query.getOrDefault("prettyPrint")
  valid_588862 = validateParameter(valid_588862, JBool, required = false,
                                 default = newJBool(true))
  if valid_588862 != nil:
    section.add "prettyPrint", valid_588862
  var valid_588863 = query.getOrDefault("responseView")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_588863 != nil:
    section.add "responseView", valid_588863
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588886: Call_CloudtasksProjectsLocationsQueuesTasksGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a task.
  ## 
  let valid = call_588886.validator(path, query, header, formData, body)
  let scheme = call_588886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588886.url(scheme.get, call_588886.host, call_588886.base,
                         call_588886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588886, url, valid)

proc call*(call_588957: Call_CloudtasksProjectsLocationsQueuesTasksGet_588710;
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
  var path_588958 = newJObject()
  var query_588960 = newJObject()
  add(query_588960, "upload_protocol", newJString(uploadProtocol))
  add(query_588960, "fields", newJString(fields))
  add(query_588960, "quotaUser", newJString(quotaUser))
  add(path_588958, "name", newJString(name))
  add(query_588960, "alt", newJString(alt))
  add(query_588960, "oauth_token", newJString(oauthToken))
  add(query_588960, "callback", newJString(callback))
  add(query_588960, "access_token", newJString(accessToken))
  add(query_588960, "uploadType", newJString(uploadType))
  add(query_588960, "key", newJString(key))
  add(query_588960, "$.xgafv", newJString(Xgafv))
  add(query_588960, "prettyPrint", newJBool(prettyPrint))
  add(query_588960, "responseView", newJString(responseView))
  result = call_588957.call(path_588958, query_588960, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesTasksGet* = Call_CloudtasksProjectsLocationsQueuesTasksGet_588710(
    name: "cloudtasksProjectsLocationsQueuesTasksGet", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksGet_588711,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksGet_588712,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesPatch_589018 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesPatch_589020(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesPatch_589019(path: JsonNode;
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
  var valid_589021 = path.getOrDefault("name")
  valid_589021 = validateParameter(valid_589021, JString, required = true,
                                 default = nil)
  if valid_589021 != nil:
    section.add "name", valid_589021
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
  var valid_589022 = query.getOrDefault("upload_protocol")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "upload_protocol", valid_589022
  var valid_589023 = query.getOrDefault("fields")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "fields", valid_589023
  var valid_589024 = query.getOrDefault("quotaUser")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "quotaUser", valid_589024
  var valid_589025 = query.getOrDefault("alt")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = newJString("json"))
  if valid_589025 != nil:
    section.add "alt", valid_589025
  var valid_589026 = query.getOrDefault("oauth_token")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "oauth_token", valid_589026
  var valid_589027 = query.getOrDefault("callback")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "callback", valid_589027
  var valid_589028 = query.getOrDefault("access_token")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "access_token", valid_589028
  var valid_589029 = query.getOrDefault("uploadType")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "uploadType", valid_589029
  var valid_589030 = query.getOrDefault("key")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "key", valid_589030
  var valid_589031 = query.getOrDefault("$.xgafv")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = newJString("1"))
  if valid_589031 != nil:
    section.add "$.xgafv", valid_589031
  var valid_589032 = query.getOrDefault("prettyPrint")
  valid_589032 = validateParameter(valid_589032, JBool, required = false,
                                 default = newJBool(true))
  if valid_589032 != nil:
    section.add "prettyPrint", valid_589032
  var valid_589033 = query.getOrDefault("updateMask")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "updateMask", valid_589033
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

proc call*(call_589035: Call_CloudtasksProjectsLocationsQueuesPatch_589018;
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
  let valid = call_589035.validator(path, query, header, formData, body)
  let scheme = call_589035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589035.url(scheme.get, call_589035.host, call_589035.base,
                         call_589035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589035, url, valid)

proc call*(call_589036: Call_CloudtasksProjectsLocationsQueuesPatch_589018;
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
  var path_589037 = newJObject()
  var query_589038 = newJObject()
  var body_589039 = newJObject()
  add(query_589038, "upload_protocol", newJString(uploadProtocol))
  add(query_589038, "fields", newJString(fields))
  add(query_589038, "quotaUser", newJString(quotaUser))
  add(path_589037, "name", newJString(name))
  add(query_589038, "alt", newJString(alt))
  add(query_589038, "oauth_token", newJString(oauthToken))
  add(query_589038, "callback", newJString(callback))
  add(query_589038, "access_token", newJString(accessToken))
  add(query_589038, "uploadType", newJString(uploadType))
  add(query_589038, "key", newJString(key))
  add(query_589038, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589039 = body
  add(query_589038, "prettyPrint", newJBool(prettyPrint))
  add(query_589038, "updateMask", newJString(updateMask))
  result = call_589036.call(path_589037, query_589038, nil, nil, body_589039)

var cloudtasksProjectsLocationsQueuesPatch* = Call_CloudtasksProjectsLocationsQueuesPatch_589018(
    name: "cloudtasksProjectsLocationsQueuesPatch", meth: HttpMethod.HttpPatch,
    host: "cloudtasks.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudtasksProjectsLocationsQueuesPatch_589019, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesPatch_589020,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksDelete_588999 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesTasksDelete_589001(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksDelete_589000(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a task.
  ## 
  ## A task can be deleted if it is scheduled or dispatched. A task
  ## cannot be deleted if it has executed successfully or permanently
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
  var valid_589002 = path.getOrDefault("name")
  valid_589002 = validateParameter(valid_589002, JString, required = true,
                                 default = nil)
  if valid_589002 != nil:
    section.add "name", valid_589002
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
  var valid_589003 = query.getOrDefault("upload_protocol")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "upload_protocol", valid_589003
  var valid_589004 = query.getOrDefault("fields")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "fields", valid_589004
  var valid_589005 = query.getOrDefault("quotaUser")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "quotaUser", valid_589005
  var valid_589006 = query.getOrDefault("alt")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = newJString("json"))
  if valid_589006 != nil:
    section.add "alt", valid_589006
  var valid_589007 = query.getOrDefault("oauth_token")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "oauth_token", valid_589007
  var valid_589008 = query.getOrDefault("callback")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "callback", valid_589008
  var valid_589009 = query.getOrDefault("access_token")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "access_token", valid_589009
  var valid_589010 = query.getOrDefault("uploadType")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "uploadType", valid_589010
  var valid_589011 = query.getOrDefault("key")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "key", valid_589011
  var valid_589012 = query.getOrDefault("$.xgafv")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("1"))
  if valid_589012 != nil:
    section.add "$.xgafv", valid_589012
  var valid_589013 = query.getOrDefault("prettyPrint")
  valid_589013 = validateParameter(valid_589013, JBool, required = false,
                                 default = newJBool(true))
  if valid_589013 != nil:
    section.add "prettyPrint", valid_589013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589014: Call_CloudtasksProjectsLocationsQueuesTasksDelete_588999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a task.
  ## 
  ## A task can be deleted if it is scheduled or dispatched. A task
  ## cannot be deleted if it has executed successfully or permanently
  ## failed.
  ## 
  let valid = call_589014.validator(path, query, header, formData, body)
  let scheme = call_589014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589014.url(scheme.get, call_589014.host, call_589014.base,
                         call_589014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589014, url, valid)

proc call*(call_589015: Call_CloudtasksProjectsLocationsQueuesTasksDelete_588999;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudtasksProjectsLocationsQueuesTasksDelete
  ## Deletes a task.
  ## 
  ## A task can be deleted if it is scheduled or dispatched. A task
  ## cannot be deleted if it has executed successfully or permanently
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
  var path_589016 = newJObject()
  var query_589017 = newJObject()
  add(query_589017, "upload_protocol", newJString(uploadProtocol))
  add(query_589017, "fields", newJString(fields))
  add(query_589017, "quotaUser", newJString(quotaUser))
  add(path_589016, "name", newJString(name))
  add(query_589017, "alt", newJString(alt))
  add(query_589017, "oauth_token", newJString(oauthToken))
  add(query_589017, "callback", newJString(callback))
  add(query_589017, "access_token", newJString(accessToken))
  add(query_589017, "uploadType", newJString(uploadType))
  add(query_589017, "key", newJString(key))
  add(query_589017, "$.xgafv", newJString(Xgafv))
  add(query_589017, "prettyPrint", newJBool(prettyPrint))
  result = call_589015.call(path_589016, query_589017, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesTasksDelete* = Call_CloudtasksProjectsLocationsQueuesTasksDelete_588999(
    name: "cloudtasksProjectsLocationsQueuesTasksDelete",
    meth: HttpMethod.HttpDelete, host: "cloudtasks.googleapis.com",
    route: "/v2/{name}",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksDelete_589000,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksDelete_589001,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsList_589040 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsList_589042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsList_589041(path: JsonNode;
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
  var valid_589043 = path.getOrDefault("name")
  valid_589043 = validateParameter(valid_589043, JString, required = true,
                                 default = nil)
  if valid_589043 != nil:
    section.add "name", valid_589043
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
  var valid_589044 = query.getOrDefault("upload_protocol")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "upload_protocol", valid_589044
  var valid_589045 = query.getOrDefault("fields")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "fields", valid_589045
  var valid_589046 = query.getOrDefault("pageToken")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "pageToken", valid_589046
  var valid_589047 = query.getOrDefault("quotaUser")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "quotaUser", valid_589047
  var valid_589048 = query.getOrDefault("alt")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = newJString("json"))
  if valid_589048 != nil:
    section.add "alt", valid_589048
  var valid_589049 = query.getOrDefault("oauth_token")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "oauth_token", valid_589049
  var valid_589050 = query.getOrDefault("callback")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "callback", valid_589050
  var valid_589051 = query.getOrDefault("access_token")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "access_token", valid_589051
  var valid_589052 = query.getOrDefault("uploadType")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "uploadType", valid_589052
  var valid_589053 = query.getOrDefault("key")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "key", valid_589053
  var valid_589054 = query.getOrDefault("$.xgafv")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("1"))
  if valid_589054 != nil:
    section.add "$.xgafv", valid_589054
  var valid_589055 = query.getOrDefault("pageSize")
  valid_589055 = validateParameter(valid_589055, JInt, required = false, default = nil)
  if valid_589055 != nil:
    section.add "pageSize", valid_589055
  var valid_589056 = query.getOrDefault("prettyPrint")
  valid_589056 = validateParameter(valid_589056, JBool, required = false,
                                 default = newJBool(true))
  if valid_589056 != nil:
    section.add "prettyPrint", valid_589056
  var valid_589057 = query.getOrDefault("filter")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "filter", valid_589057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589058: Call_CloudtasksProjectsLocationsList_589040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_589058.validator(path, query, header, formData, body)
  let scheme = call_589058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589058.url(scheme.get, call_589058.host, call_589058.base,
                         call_589058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589058, url, valid)

proc call*(call_589059: Call_CloudtasksProjectsLocationsList_589040; name: string;
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
  var path_589060 = newJObject()
  var query_589061 = newJObject()
  add(query_589061, "upload_protocol", newJString(uploadProtocol))
  add(query_589061, "fields", newJString(fields))
  add(query_589061, "pageToken", newJString(pageToken))
  add(query_589061, "quotaUser", newJString(quotaUser))
  add(path_589060, "name", newJString(name))
  add(query_589061, "alt", newJString(alt))
  add(query_589061, "oauth_token", newJString(oauthToken))
  add(query_589061, "callback", newJString(callback))
  add(query_589061, "access_token", newJString(accessToken))
  add(query_589061, "uploadType", newJString(uploadType))
  add(query_589061, "key", newJString(key))
  add(query_589061, "$.xgafv", newJString(Xgafv))
  add(query_589061, "pageSize", newJInt(pageSize))
  add(query_589061, "prettyPrint", newJBool(prettyPrint))
  add(query_589061, "filter", newJString(filter))
  result = call_589059.call(path_589060, query_589061, nil, nil, nil)

var cloudtasksProjectsLocationsList* = Call_CloudtasksProjectsLocationsList_589040(
    name: "cloudtasksProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2/{name}/locations",
    validator: validate_CloudtasksProjectsLocationsList_589041, base: "/",
    url: url_CloudtasksProjectsLocationsList_589042, schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesPause_589062 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesPause_589064(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":pause")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesPause_589063(path: JsonNode;
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
  var valid_589065 = path.getOrDefault("name")
  valid_589065 = validateParameter(valid_589065, JString, required = true,
                                 default = nil)
  if valid_589065 != nil:
    section.add "name", valid_589065
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
  var valid_589066 = query.getOrDefault("upload_protocol")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "upload_protocol", valid_589066
  var valid_589067 = query.getOrDefault("fields")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "fields", valid_589067
  var valid_589068 = query.getOrDefault("quotaUser")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "quotaUser", valid_589068
  var valid_589069 = query.getOrDefault("alt")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = newJString("json"))
  if valid_589069 != nil:
    section.add "alt", valid_589069
  var valid_589070 = query.getOrDefault("oauth_token")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "oauth_token", valid_589070
  var valid_589071 = query.getOrDefault("callback")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "callback", valid_589071
  var valid_589072 = query.getOrDefault("access_token")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "access_token", valid_589072
  var valid_589073 = query.getOrDefault("uploadType")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "uploadType", valid_589073
  var valid_589074 = query.getOrDefault("key")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "key", valid_589074
  var valid_589075 = query.getOrDefault("$.xgafv")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("1"))
  if valid_589075 != nil:
    section.add "$.xgafv", valid_589075
  var valid_589076 = query.getOrDefault("prettyPrint")
  valid_589076 = validateParameter(valid_589076, JBool, required = false,
                                 default = newJBool(true))
  if valid_589076 != nil:
    section.add "prettyPrint", valid_589076
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

proc call*(call_589078: Call_CloudtasksProjectsLocationsQueuesPause_589062;
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
  let valid = call_589078.validator(path, query, header, formData, body)
  let scheme = call_589078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589078.url(scheme.get, call_589078.host, call_589078.base,
                         call_589078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589078, url, valid)

proc call*(call_589079: Call_CloudtasksProjectsLocationsQueuesPause_589062;
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
  var path_589080 = newJObject()
  var query_589081 = newJObject()
  var body_589082 = newJObject()
  add(query_589081, "upload_protocol", newJString(uploadProtocol))
  add(query_589081, "fields", newJString(fields))
  add(query_589081, "quotaUser", newJString(quotaUser))
  add(path_589080, "name", newJString(name))
  add(query_589081, "alt", newJString(alt))
  add(query_589081, "oauth_token", newJString(oauthToken))
  add(query_589081, "callback", newJString(callback))
  add(query_589081, "access_token", newJString(accessToken))
  add(query_589081, "uploadType", newJString(uploadType))
  add(query_589081, "key", newJString(key))
  add(query_589081, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589082 = body
  add(query_589081, "prettyPrint", newJBool(prettyPrint))
  result = call_589079.call(path_589080, query_589081, nil, nil, body_589082)

var cloudtasksProjectsLocationsQueuesPause* = Call_CloudtasksProjectsLocationsQueuesPause_589062(
    name: "cloudtasksProjectsLocationsQueuesPause", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2/{name}:pause",
    validator: validate_CloudtasksProjectsLocationsQueuesPause_589063, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesPause_589064,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesPurge_589083 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesPurge_589085(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":purge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesPurge_589084(path: JsonNode;
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
  var valid_589086 = path.getOrDefault("name")
  valid_589086 = validateParameter(valid_589086, JString, required = true,
                                 default = nil)
  if valid_589086 != nil:
    section.add "name", valid_589086
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
  var valid_589087 = query.getOrDefault("upload_protocol")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "upload_protocol", valid_589087
  var valid_589088 = query.getOrDefault("fields")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "fields", valid_589088
  var valid_589089 = query.getOrDefault("quotaUser")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "quotaUser", valid_589089
  var valid_589090 = query.getOrDefault("alt")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = newJString("json"))
  if valid_589090 != nil:
    section.add "alt", valid_589090
  var valid_589091 = query.getOrDefault("oauth_token")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "oauth_token", valid_589091
  var valid_589092 = query.getOrDefault("callback")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "callback", valid_589092
  var valid_589093 = query.getOrDefault("access_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "access_token", valid_589093
  var valid_589094 = query.getOrDefault("uploadType")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "uploadType", valid_589094
  var valid_589095 = query.getOrDefault("key")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "key", valid_589095
  var valid_589096 = query.getOrDefault("$.xgafv")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = newJString("1"))
  if valid_589096 != nil:
    section.add "$.xgafv", valid_589096
  var valid_589097 = query.getOrDefault("prettyPrint")
  valid_589097 = validateParameter(valid_589097, JBool, required = false,
                                 default = newJBool(true))
  if valid_589097 != nil:
    section.add "prettyPrint", valid_589097
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

proc call*(call_589099: Call_CloudtasksProjectsLocationsQueuesPurge_589083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Purges a queue by deleting all of its tasks.
  ## 
  ## All tasks created before this method is called are permanently deleted.
  ## 
  ## Purge operations can take up to one minute to take effect. Tasks
  ## might be dispatched before the purge takes effect. A purge is irreversible.
  ## 
  let valid = call_589099.validator(path, query, header, formData, body)
  let scheme = call_589099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589099.url(scheme.get, call_589099.host, call_589099.base,
                         call_589099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589099, url, valid)

proc call*(call_589100: Call_CloudtasksProjectsLocationsQueuesPurge_589083;
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
  var path_589101 = newJObject()
  var query_589102 = newJObject()
  var body_589103 = newJObject()
  add(query_589102, "upload_protocol", newJString(uploadProtocol))
  add(query_589102, "fields", newJString(fields))
  add(query_589102, "quotaUser", newJString(quotaUser))
  add(path_589101, "name", newJString(name))
  add(query_589102, "alt", newJString(alt))
  add(query_589102, "oauth_token", newJString(oauthToken))
  add(query_589102, "callback", newJString(callback))
  add(query_589102, "access_token", newJString(accessToken))
  add(query_589102, "uploadType", newJString(uploadType))
  add(query_589102, "key", newJString(key))
  add(query_589102, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589103 = body
  add(query_589102, "prettyPrint", newJBool(prettyPrint))
  result = call_589100.call(path_589101, query_589102, nil, nil, body_589103)

var cloudtasksProjectsLocationsQueuesPurge* = Call_CloudtasksProjectsLocationsQueuesPurge_589083(
    name: "cloudtasksProjectsLocationsQueuesPurge", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2/{name}:purge",
    validator: validate_CloudtasksProjectsLocationsQueuesPurge_589084, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesPurge_589085,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesResume_589104 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesResume_589106(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesResume_589105(path: JsonNode;
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
  var valid_589107 = path.getOrDefault("name")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "name", valid_589107
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
  var valid_589108 = query.getOrDefault("upload_protocol")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "upload_protocol", valid_589108
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
  var valid_589113 = query.getOrDefault("callback")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "callback", valid_589113
  var valid_589114 = query.getOrDefault("access_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "access_token", valid_589114
  var valid_589115 = query.getOrDefault("uploadType")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "uploadType", valid_589115
  var valid_589116 = query.getOrDefault("key")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "key", valid_589116
  var valid_589117 = query.getOrDefault("$.xgafv")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = newJString("1"))
  if valid_589117 != nil:
    section.add "$.xgafv", valid_589117
  var valid_589118 = query.getOrDefault("prettyPrint")
  valid_589118 = validateParameter(valid_589118, JBool, required = false,
                                 default = newJBool(true))
  if valid_589118 != nil:
    section.add "prettyPrint", valid_589118
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

proc call*(call_589120: Call_CloudtasksProjectsLocationsQueuesResume_589104;
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
  let valid = call_589120.validator(path, query, header, formData, body)
  let scheme = call_589120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589120.url(scheme.get, call_589120.host, call_589120.base,
                         call_589120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589120, url, valid)

proc call*(call_589121: Call_CloudtasksProjectsLocationsQueuesResume_589104;
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
  var path_589122 = newJObject()
  var query_589123 = newJObject()
  var body_589124 = newJObject()
  add(query_589123, "upload_protocol", newJString(uploadProtocol))
  add(query_589123, "fields", newJString(fields))
  add(query_589123, "quotaUser", newJString(quotaUser))
  add(path_589122, "name", newJString(name))
  add(query_589123, "alt", newJString(alt))
  add(query_589123, "oauth_token", newJString(oauthToken))
  add(query_589123, "callback", newJString(callback))
  add(query_589123, "access_token", newJString(accessToken))
  add(query_589123, "uploadType", newJString(uploadType))
  add(query_589123, "key", newJString(key))
  add(query_589123, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589124 = body
  add(query_589123, "prettyPrint", newJBool(prettyPrint))
  result = call_589121.call(path_589122, query_589123, nil, nil, body_589124)

var cloudtasksProjectsLocationsQueuesResume* = Call_CloudtasksProjectsLocationsQueuesResume_589104(
    name: "cloudtasksProjectsLocationsQueuesResume", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2/{name}:resume",
    validator: validate_CloudtasksProjectsLocationsQueuesResume_589105, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesResume_589106,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksRun_589125 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesTasksRun_589127(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksRun_589126(path: JsonNode;
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
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The task name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/queues/QUEUE_ID/tasks/TASK_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589128 = path.getOrDefault("name")
  valid_589128 = validateParameter(valid_589128, JString, required = true,
                                 default = nil)
  if valid_589128 != nil:
    section.add "name", valid_589128
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
  var valid_589129 = query.getOrDefault("upload_protocol")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "upload_protocol", valid_589129
  var valid_589130 = query.getOrDefault("fields")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "fields", valid_589130
  var valid_589131 = query.getOrDefault("quotaUser")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "quotaUser", valid_589131
  var valid_589132 = query.getOrDefault("alt")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = newJString("json"))
  if valid_589132 != nil:
    section.add "alt", valid_589132
  var valid_589133 = query.getOrDefault("oauth_token")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "oauth_token", valid_589133
  var valid_589134 = query.getOrDefault("callback")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "callback", valid_589134
  var valid_589135 = query.getOrDefault("access_token")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "access_token", valid_589135
  var valid_589136 = query.getOrDefault("uploadType")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "uploadType", valid_589136
  var valid_589137 = query.getOrDefault("key")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "key", valid_589137
  var valid_589138 = query.getOrDefault("$.xgafv")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = newJString("1"))
  if valid_589138 != nil:
    section.add "$.xgafv", valid_589138
  var valid_589139 = query.getOrDefault("prettyPrint")
  valid_589139 = validateParameter(valid_589139, JBool, required = false,
                                 default = newJBool(true))
  if valid_589139 != nil:
    section.add "prettyPrint", valid_589139
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

proc call*(call_589141: Call_CloudtasksProjectsLocationsQueuesTasksRun_589125;
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
  let valid = call_589141.validator(path, query, header, formData, body)
  let scheme = call_589141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589141.url(scheme.get, call_589141.host, call_589141.base,
                         call_589141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589141, url, valid)

proc call*(call_589142: Call_CloudtasksProjectsLocationsQueuesTasksRun_589125;
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
  var path_589143 = newJObject()
  var query_589144 = newJObject()
  var body_589145 = newJObject()
  add(query_589144, "upload_protocol", newJString(uploadProtocol))
  add(query_589144, "fields", newJString(fields))
  add(query_589144, "quotaUser", newJString(quotaUser))
  add(path_589143, "name", newJString(name))
  add(query_589144, "alt", newJString(alt))
  add(query_589144, "oauth_token", newJString(oauthToken))
  add(query_589144, "callback", newJString(callback))
  add(query_589144, "access_token", newJString(accessToken))
  add(query_589144, "uploadType", newJString(uploadType))
  add(query_589144, "key", newJString(key))
  add(query_589144, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589145 = body
  add(query_589144, "prettyPrint", newJBool(prettyPrint))
  result = call_589142.call(path_589143, query_589144, nil, nil, body_589145)

var cloudtasksProjectsLocationsQueuesTasksRun* = Call_CloudtasksProjectsLocationsQueuesTasksRun_589125(
    name: "cloudtasksProjectsLocationsQueuesTasksRun", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2/{name}:run",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksRun_589126,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksRun_589127,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesCreate_589168 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesCreate_589170(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/queues")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesCreate_589169(path: JsonNode;
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
  var valid_589171 = path.getOrDefault("parent")
  valid_589171 = validateParameter(valid_589171, JString, required = true,
                                 default = nil)
  if valid_589171 != nil:
    section.add "parent", valid_589171
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
  var valid_589172 = query.getOrDefault("upload_protocol")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "upload_protocol", valid_589172
  var valid_589173 = query.getOrDefault("fields")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "fields", valid_589173
  var valid_589174 = query.getOrDefault("quotaUser")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "quotaUser", valid_589174
  var valid_589175 = query.getOrDefault("alt")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = newJString("json"))
  if valid_589175 != nil:
    section.add "alt", valid_589175
  var valid_589176 = query.getOrDefault("oauth_token")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "oauth_token", valid_589176
  var valid_589177 = query.getOrDefault("callback")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "callback", valid_589177
  var valid_589178 = query.getOrDefault("access_token")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "access_token", valid_589178
  var valid_589179 = query.getOrDefault("uploadType")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "uploadType", valid_589179
  var valid_589180 = query.getOrDefault("key")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "key", valid_589180
  var valid_589181 = query.getOrDefault("$.xgafv")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = newJString("1"))
  if valid_589181 != nil:
    section.add "$.xgafv", valid_589181
  var valid_589182 = query.getOrDefault("prettyPrint")
  valid_589182 = validateParameter(valid_589182, JBool, required = false,
                                 default = newJBool(true))
  if valid_589182 != nil:
    section.add "prettyPrint", valid_589182
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

proc call*(call_589184: Call_CloudtasksProjectsLocationsQueuesCreate_589168;
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
  let valid = call_589184.validator(path, query, header, formData, body)
  let scheme = call_589184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589184.url(scheme.get, call_589184.host, call_589184.base,
                         call_589184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589184, url, valid)

proc call*(call_589185: Call_CloudtasksProjectsLocationsQueuesCreate_589168;
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
  var path_589186 = newJObject()
  var query_589187 = newJObject()
  var body_589188 = newJObject()
  add(query_589187, "upload_protocol", newJString(uploadProtocol))
  add(query_589187, "fields", newJString(fields))
  add(query_589187, "quotaUser", newJString(quotaUser))
  add(query_589187, "alt", newJString(alt))
  add(query_589187, "oauth_token", newJString(oauthToken))
  add(query_589187, "callback", newJString(callback))
  add(query_589187, "access_token", newJString(accessToken))
  add(query_589187, "uploadType", newJString(uploadType))
  add(path_589186, "parent", newJString(parent))
  add(query_589187, "key", newJString(key))
  add(query_589187, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589188 = body
  add(query_589187, "prettyPrint", newJBool(prettyPrint))
  result = call_589185.call(path_589186, query_589187, nil, nil, body_589188)

var cloudtasksProjectsLocationsQueuesCreate* = Call_CloudtasksProjectsLocationsQueuesCreate_589168(
    name: "cloudtasksProjectsLocationsQueuesCreate", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2/{parent}/queues",
    validator: validate_CloudtasksProjectsLocationsQueuesCreate_589169, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesCreate_589170,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesList_589146 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesList_589148(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/queues")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesList_589147(path: JsonNode;
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
  var valid_589149 = path.getOrDefault("parent")
  valid_589149 = validateParameter(valid_589149, JString, required = true,
                                 default = nil)
  if valid_589149 != nil:
    section.add "parent", valid_589149
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
  ## Sample filter "state: PAUSED".
  ## 
  ## Note that using filters might cause fewer queues than the
  ## requested page_size to be returned.
  section = newJObject()
  var valid_589150 = query.getOrDefault("upload_protocol")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "upload_protocol", valid_589150
  var valid_589151 = query.getOrDefault("fields")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "fields", valid_589151
  var valid_589152 = query.getOrDefault("pageToken")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "pageToken", valid_589152
  var valid_589153 = query.getOrDefault("quotaUser")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "quotaUser", valid_589153
  var valid_589154 = query.getOrDefault("alt")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = newJString("json"))
  if valid_589154 != nil:
    section.add "alt", valid_589154
  var valid_589155 = query.getOrDefault("oauth_token")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "oauth_token", valid_589155
  var valid_589156 = query.getOrDefault("callback")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "callback", valid_589156
  var valid_589157 = query.getOrDefault("access_token")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "access_token", valid_589157
  var valid_589158 = query.getOrDefault("uploadType")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "uploadType", valid_589158
  var valid_589159 = query.getOrDefault("key")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "key", valid_589159
  var valid_589160 = query.getOrDefault("$.xgafv")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = newJString("1"))
  if valid_589160 != nil:
    section.add "$.xgafv", valid_589160
  var valid_589161 = query.getOrDefault("pageSize")
  valid_589161 = validateParameter(valid_589161, JInt, required = false, default = nil)
  if valid_589161 != nil:
    section.add "pageSize", valid_589161
  var valid_589162 = query.getOrDefault("prettyPrint")
  valid_589162 = validateParameter(valid_589162, JBool, required = false,
                                 default = newJBool(true))
  if valid_589162 != nil:
    section.add "prettyPrint", valid_589162
  var valid_589163 = query.getOrDefault("filter")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "filter", valid_589163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589164: Call_CloudtasksProjectsLocationsQueuesList_589146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists queues.
  ## 
  ## Queues are returned in lexicographical order.
  ## 
  let valid = call_589164.validator(path, query, header, formData, body)
  let scheme = call_589164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589164.url(scheme.get, call_589164.host, call_589164.base,
                         call_589164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589164, url, valid)

proc call*(call_589165: Call_CloudtasksProjectsLocationsQueuesList_589146;
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
  ## Sample filter "state: PAUSED".
  ## 
  ## Note that using filters might cause fewer queues than the
  ## requested page_size to be returned.
  var path_589166 = newJObject()
  var query_589167 = newJObject()
  add(query_589167, "upload_protocol", newJString(uploadProtocol))
  add(query_589167, "fields", newJString(fields))
  add(query_589167, "pageToken", newJString(pageToken))
  add(query_589167, "quotaUser", newJString(quotaUser))
  add(query_589167, "alt", newJString(alt))
  add(query_589167, "oauth_token", newJString(oauthToken))
  add(query_589167, "callback", newJString(callback))
  add(query_589167, "access_token", newJString(accessToken))
  add(query_589167, "uploadType", newJString(uploadType))
  add(path_589166, "parent", newJString(parent))
  add(query_589167, "key", newJString(key))
  add(query_589167, "$.xgafv", newJString(Xgafv))
  add(query_589167, "pageSize", newJInt(pageSize))
  add(query_589167, "prettyPrint", newJBool(prettyPrint))
  add(query_589167, "filter", newJString(filter))
  result = call_589165.call(path_589166, query_589167, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesList* = Call_CloudtasksProjectsLocationsQueuesList_589146(
    name: "cloudtasksProjectsLocationsQueuesList", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2/{parent}/queues",
    validator: validate_CloudtasksProjectsLocationsQueuesList_589147, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesList_589148, schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksCreate_589211 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesTasksCreate_589213(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksCreate_589212(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task and adds it to a queue.
  ## 
  ## Tasks cannot be updated after creation; there is no UpdateTask command.
  ## 
  ## * The maximum task size is 100KB.
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
  var valid_589214 = path.getOrDefault("parent")
  valid_589214 = validateParameter(valid_589214, JString, required = true,
                                 default = nil)
  if valid_589214 != nil:
    section.add "parent", valid_589214
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
  var valid_589215 = query.getOrDefault("upload_protocol")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "upload_protocol", valid_589215
  var valid_589216 = query.getOrDefault("fields")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "fields", valid_589216
  var valid_589217 = query.getOrDefault("quotaUser")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "quotaUser", valid_589217
  var valid_589218 = query.getOrDefault("alt")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = newJString("json"))
  if valid_589218 != nil:
    section.add "alt", valid_589218
  var valid_589219 = query.getOrDefault("oauth_token")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "oauth_token", valid_589219
  var valid_589220 = query.getOrDefault("callback")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "callback", valid_589220
  var valid_589221 = query.getOrDefault("access_token")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "access_token", valid_589221
  var valid_589222 = query.getOrDefault("uploadType")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "uploadType", valid_589222
  var valid_589223 = query.getOrDefault("key")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "key", valid_589223
  var valid_589224 = query.getOrDefault("$.xgafv")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = newJString("1"))
  if valid_589224 != nil:
    section.add "$.xgafv", valid_589224
  var valid_589225 = query.getOrDefault("prettyPrint")
  valid_589225 = validateParameter(valid_589225, JBool, required = false,
                                 default = newJBool(true))
  if valid_589225 != nil:
    section.add "prettyPrint", valid_589225
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

proc call*(call_589227: Call_CloudtasksProjectsLocationsQueuesTasksCreate_589211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a task and adds it to a queue.
  ## 
  ## Tasks cannot be updated after creation; there is no UpdateTask command.
  ## 
  ## * The maximum task size is 100KB.
  ## 
  let valid = call_589227.validator(path, query, header, formData, body)
  let scheme = call_589227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589227.url(scheme.get, call_589227.host, call_589227.base,
                         call_589227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589227, url, valid)

proc call*(call_589228: Call_CloudtasksProjectsLocationsQueuesTasksCreate_589211;
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
  ## * The maximum task size is 100KB.
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
  var path_589229 = newJObject()
  var query_589230 = newJObject()
  var body_589231 = newJObject()
  add(query_589230, "upload_protocol", newJString(uploadProtocol))
  add(query_589230, "fields", newJString(fields))
  add(query_589230, "quotaUser", newJString(quotaUser))
  add(query_589230, "alt", newJString(alt))
  add(query_589230, "oauth_token", newJString(oauthToken))
  add(query_589230, "callback", newJString(callback))
  add(query_589230, "access_token", newJString(accessToken))
  add(query_589230, "uploadType", newJString(uploadType))
  add(path_589229, "parent", newJString(parent))
  add(query_589230, "key", newJString(key))
  add(query_589230, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589231 = body
  add(query_589230, "prettyPrint", newJBool(prettyPrint))
  result = call_589228.call(path_589229, query_589230, nil, nil, body_589231)

var cloudtasksProjectsLocationsQueuesTasksCreate* = Call_CloudtasksProjectsLocationsQueuesTasksCreate_589211(
    name: "cloudtasksProjectsLocationsQueuesTasksCreate",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2/{parent}/tasks",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksCreate_589212,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksCreate_589213,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksList_589189 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesTasksList_589191(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksList_589190(path: JsonNode;
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
  var valid_589192 = path.getOrDefault("parent")
  valid_589192 = validateParameter(valid_589192, JString, required = true,
                                 default = nil)
  if valid_589192 != nil:
    section.add "parent", valid_589192
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
  var valid_589193 = query.getOrDefault("upload_protocol")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "upload_protocol", valid_589193
  var valid_589194 = query.getOrDefault("fields")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "fields", valid_589194
  var valid_589195 = query.getOrDefault("pageToken")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "pageToken", valid_589195
  var valid_589196 = query.getOrDefault("quotaUser")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "quotaUser", valid_589196
  var valid_589197 = query.getOrDefault("alt")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = newJString("json"))
  if valid_589197 != nil:
    section.add "alt", valid_589197
  var valid_589198 = query.getOrDefault("oauth_token")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "oauth_token", valid_589198
  var valid_589199 = query.getOrDefault("callback")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "callback", valid_589199
  var valid_589200 = query.getOrDefault("access_token")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "access_token", valid_589200
  var valid_589201 = query.getOrDefault("uploadType")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "uploadType", valid_589201
  var valid_589202 = query.getOrDefault("key")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "key", valid_589202
  var valid_589203 = query.getOrDefault("$.xgafv")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = newJString("1"))
  if valid_589203 != nil:
    section.add "$.xgafv", valid_589203
  var valid_589204 = query.getOrDefault("pageSize")
  valid_589204 = validateParameter(valid_589204, JInt, required = false, default = nil)
  if valid_589204 != nil:
    section.add "pageSize", valid_589204
  var valid_589205 = query.getOrDefault("prettyPrint")
  valid_589205 = validateParameter(valid_589205, JBool, required = false,
                                 default = newJBool(true))
  if valid_589205 != nil:
    section.add "prettyPrint", valid_589205
  var valid_589206 = query.getOrDefault("responseView")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_589206 != nil:
    section.add "responseView", valid_589206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589207: Call_CloudtasksProjectsLocationsQueuesTasksList_589189;
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
  let valid = call_589207.validator(path, query, header, formData, body)
  let scheme = call_589207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589207.url(scheme.get, call_589207.host, call_589207.base,
                         call_589207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589207, url, valid)

proc call*(call_589208: Call_CloudtasksProjectsLocationsQueuesTasksList_589189;
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
  var path_589209 = newJObject()
  var query_589210 = newJObject()
  add(query_589210, "upload_protocol", newJString(uploadProtocol))
  add(query_589210, "fields", newJString(fields))
  add(query_589210, "pageToken", newJString(pageToken))
  add(query_589210, "quotaUser", newJString(quotaUser))
  add(query_589210, "alt", newJString(alt))
  add(query_589210, "oauth_token", newJString(oauthToken))
  add(query_589210, "callback", newJString(callback))
  add(query_589210, "access_token", newJString(accessToken))
  add(query_589210, "uploadType", newJString(uploadType))
  add(path_589209, "parent", newJString(parent))
  add(query_589210, "key", newJString(key))
  add(query_589210, "$.xgafv", newJString(Xgafv))
  add(query_589210, "pageSize", newJInt(pageSize))
  add(query_589210, "prettyPrint", newJBool(prettyPrint))
  add(query_589210, "responseView", newJString(responseView))
  result = call_589208.call(path_589209, query_589210, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesTasksList* = Call_CloudtasksProjectsLocationsQueuesTasksList_589189(
    name: "cloudtasksProjectsLocationsQueuesTasksList", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2/{parent}/tasks",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksList_589190,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksList_589191,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_589232 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesGetIamPolicy_589234(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesGetIamPolicy_589233(
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
  var valid_589235 = path.getOrDefault("resource")
  valid_589235 = validateParameter(valid_589235, JString, required = true,
                                 default = nil)
  if valid_589235 != nil:
    section.add "resource", valid_589235
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
  var valid_589236 = query.getOrDefault("upload_protocol")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "upload_protocol", valid_589236
  var valid_589237 = query.getOrDefault("fields")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "fields", valid_589237
  var valid_589238 = query.getOrDefault("quotaUser")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "quotaUser", valid_589238
  var valid_589239 = query.getOrDefault("alt")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = newJString("json"))
  if valid_589239 != nil:
    section.add "alt", valid_589239
  var valid_589240 = query.getOrDefault("oauth_token")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "oauth_token", valid_589240
  var valid_589241 = query.getOrDefault("callback")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "callback", valid_589241
  var valid_589242 = query.getOrDefault("access_token")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "access_token", valid_589242
  var valid_589243 = query.getOrDefault("uploadType")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "uploadType", valid_589243
  var valid_589244 = query.getOrDefault("key")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "key", valid_589244
  var valid_589245 = query.getOrDefault("$.xgafv")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = newJString("1"))
  if valid_589245 != nil:
    section.add "$.xgafv", valid_589245
  var valid_589246 = query.getOrDefault("prettyPrint")
  valid_589246 = validateParameter(valid_589246, JBool, required = false,
                                 default = newJBool(true))
  if valid_589246 != nil:
    section.add "prettyPrint", valid_589246
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

proc call*(call_589248: Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_589232;
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
  let valid = call_589248.validator(path, query, header, formData, body)
  let scheme = call_589248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589248.url(scheme.get, call_589248.host, call_589248.base,
                         call_589248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589248, url, valid)

proc call*(call_589249: Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_589232;
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
  var path_589250 = newJObject()
  var query_589251 = newJObject()
  var body_589252 = newJObject()
  add(query_589251, "upload_protocol", newJString(uploadProtocol))
  add(query_589251, "fields", newJString(fields))
  add(query_589251, "quotaUser", newJString(quotaUser))
  add(query_589251, "alt", newJString(alt))
  add(query_589251, "oauth_token", newJString(oauthToken))
  add(query_589251, "callback", newJString(callback))
  add(query_589251, "access_token", newJString(accessToken))
  add(query_589251, "uploadType", newJString(uploadType))
  add(query_589251, "key", newJString(key))
  add(query_589251, "$.xgafv", newJString(Xgafv))
  add(path_589250, "resource", newJString(resource))
  if body != nil:
    body_589252 = body
  add(query_589251, "prettyPrint", newJBool(prettyPrint))
  result = call_589249.call(path_589250, query_589251, nil, nil, body_589252)

var cloudtasksProjectsLocationsQueuesGetIamPolicy* = Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_589232(
    name: "cloudtasksProjectsLocationsQueuesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2/{resource}:getIamPolicy",
    validator: validate_CloudtasksProjectsLocationsQueuesGetIamPolicy_589233,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesGetIamPolicy_589234,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_589253 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesSetIamPolicy_589255(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesSetIamPolicy_589254(
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
  var valid_589256 = path.getOrDefault("resource")
  valid_589256 = validateParameter(valid_589256, JString, required = true,
                                 default = nil)
  if valid_589256 != nil:
    section.add "resource", valid_589256
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
  var valid_589257 = query.getOrDefault("upload_protocol")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "upload_protocol", valid_589257
  var valid_589258 = query.getOrDefault("fields")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "fields", valid_589258
  var valid_589259 = query.getOrDefault("quotaUser")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "quotaUser", valid_589259
  var valid_589260 = query.getOrDefault("alt")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = newJString("json"))
  if valid_589260 != nil:
    section.add "alt", valid_589260
  var valid_589261 = query.getOrDefault("oauth_token")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "oauth_token", valid_589261
  var valid_589262 = query.getOrDefault("callback")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "callback", valid_589262
  var valid_589263 = query.getOrDefault("access_token")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "access_token", valid_589263
  var valid_589264 = query.getOrDefault("uploadType")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "uploadType", valid_589264
  var valid_589265 = query.getOrDefault("key")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "key", valid_589265
  var valid_589266 = query.getOrDefault("$.xgafv")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = newJString("1"))
  if valid_589266 != nil:
    section.add "$.xgafv", valid_589266
  var valid_589267 = query.getOrDefault("prettyPrint")
  valid_589267 = validateParameter(valid_589267, JBool, required = false,
                                 default = newJBool(true))
  if valid_589267 != nil:
    section.add "prettyPrint", valid_589267
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

proc call*(call_589269: Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_589253;
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
  let valid = call_589269.validator(path, query, header, formData, body)
  let scheme = call_589269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589269.url(scheme.get, call_589269.host, call_589269.base,
                         call_589269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589269, url, valid)

proc call*(call_589270: Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_589253;
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
  var path_589271 = newJObject()
  var query_589272 = newJObject()
  var body_589273 = newJObject()
  add(query_589272, "upload_protocol", newJString(uploadProtocol))
  add(query_589272, "fields", newJString(fields))
  add(query_589272, "quotaUser", newJString(quotaUser))
  add(query_589272, "alt", newJString(alt))
  add(query_589272, "oauth_token", newJString(oauthToken))
  add(query_589272, "callback", newJString(callback))
  add(query_589272, "access_token", newJString(accessToken))
  add(query_589272, "uploadType", newJString(uploadType))
  add(query_589272, "key", newJString(key))
  add(query_589272, "$.xgafv", newJString(Xgafv))
  add(path_589271, "resource", newJString(resource))
  if body != nil:
    body_589273 = body
  add(query_589272, "prettyPrint", newJBool(prettyPrint))
  result = call_589270.call(path_589271, query_589272, nil, nil, body_589273)

var cloudtasksProjectsLocationsQueuesSetIamPolicy* = Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_589253(
    name: "cloudtasksProjectsLocationsQueuesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2/{resource}:setIamPolicy",
    validator: validate_CloudtasksProjectsLocationsQueuesSetIamPolicy_589254,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesSetIamPolicy_589255,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_589274 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesTestIamPermissions_589276(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTestIamPermissions_589275(
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
  var valid_589277 = path.getOrDefault("resource")
  valid_589277 = validateParameter(valid_589277, JString, required = true,
                                 default = nil)
  if valid_589277 != nil:
    section.add "resource", valid_589277
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
  var valid_589278 = query.getOrDefault("upload_protocol")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "upload_protocol", valid_589278
  var valid_589279 = query.getOrDefault("fields")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "fields", valid_589279
  var valid_589280 = query.getOrDefault("quotaUser")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "quotaUser", valid_589280
  var valid_589281 = query.getOrDefault("alt")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = newJString("json"))
  if valid_589281 != nil:
    section.add "alt", valid_589281
  var valid_589282 = query.getOrDefault("oauth_token")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "oauth_token", valid_589282
  var valid_589283 = query.getOrDefault("callback")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "callback", valid_589283
  var valid_589284 = query.getOrDefault("access_token")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "access_token", valid_589284
  var valid_589285 = query.getOrDefault("uploadType")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "uploadType", valid_589285
  var valid_589286 = query.getOrDefault("key")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "key", valid_589286
  var valid_589287 = query.getOrDefault("$.xgafv")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = newJString("1"))
  if valid_589287 != nil:
    section.add "$.xgafv", valid_589287
  var valid_589288 = query.getOrDefault("prettyPrint")
  valid_589288 = validateParameter(valid_589288, JBool, required = false,
                                 default = newJBool(true))
  if valid_589288 != nil:
    section.add "prettyPrint", valid_589288
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

proc call*(call_589290: Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_589274;
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
  let valid = call_589290.validator(path, query, header, formData, body)
  let scheme = call_589290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589290.url(scheme.get, call_589290.host, call_589290.base,
                         call_589290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589290, url, valid)

proc call*(call_589291: Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_589274;
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
  var path_589292 = newJObject()
  var query_589293 = newJObject()
  var body_589294 = newJObject()
  add(query_589293, "upload_protocol", newJString(uploadProtocol))
  add(query_589293, "fields", newJString(fields))
  add(query_589293, "quotaUser", newJString(quotaUser))
  add(query_589293, "alt", newJString(alt))
  add(query_589293, "oauth_token", newJString(oauthToken))
  add(query_589293, "callback", newJString(callback))
  add(query_589293, "access_token", newJString(accessToken))
  add(query_589293, "uploadType", newJString(uploadType))
  add(query_589293, "key", newJString(key))
  add(query_589293, "$.xgafv", newJString(Xgafv))
  add(path_589292, "resource", newJString(resource))
  if body != nil:
    body_589294 = body
  add(query_589293, "prettyPrint", newJBool(prettyPrint))
  result = call_589291.call(path_589292, query_589293, nil, nil, body_589294)

var cloudtasksProjectsLocationsQueuesTestIamPermissions* = Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_589274(
    name: "cloudtasksProjectsLocationsQueuesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2/{resource}:testIamPermissions",
    validator: validate_CloudtasksProjectsLocationsQueuesTestIamPermissions_589275,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTestIamPermissions_589276,
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
