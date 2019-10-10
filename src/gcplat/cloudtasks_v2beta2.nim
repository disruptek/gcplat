
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
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
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
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}",
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
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
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
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}",
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
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
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
  ## cannot be deleted if it has completed successfully or permanently
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
    route: "/v2beta2/{name}",
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
    segments = @[(kind: ConstantSegment, value: "/v2beta2/"),
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
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}/locations",
    validator: validate_CloudtasksProjectsLocationsList_589041, base: "/",
    url: url_CloudtasksProjectsLocationsList_589042, schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksAcknowledge_589062 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesTasksAcknowledge_589064(
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

proc validate_CloudtasksProjectsLocationsQueuesTasksAcknowledge_589063(
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

proc call*(call_589078: Call_CloudtasksProjectsLocationsQueuesTasksAcknowledge_589062;
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
  let valid = call_589078.validator(path, query, header, formData, body)
  let scheme = call_589078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589078.url(scheme.get, call_589078.host, call_589078.base,
                         call_589078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589078, url, valid)

proc call*(call_589079: Call_CloudtasksProjectsLocationsQueuesTasksAcknowledge_589062;
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

var cloudtasksProjectsLocationsQueuesTasksAcknowledge* = Call_CloudtasksProjectsLocationsQueuesTasksAcknowledge_589062(
    name: "cloudtasksProjectsLocationsQueuesTasksAcknowledge",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{name}:acknowledge",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksAcknowledge_589063,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksAcknowledge_589064,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksCancelLease_589083 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesTasksCancelLease_589085(
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

proc validate_CloudtasksProjectsLocationsQueuesTasksCancelLease_589084(
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

proc call*(call_589099: Call_CloudtasksProjectsLocationsQueuesTasksCancelLease_589083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancel a pull task's lease.
  ## 
  ## The worker can use this method to cancel a task's lease by
  ## setting its schedule_time to now. This will
  ## make the task available to be leased to the next caller of
  ## LeaseTasks.
  ## 
  let valid = call_589099.validator(path, query, header, formData, body)
  let scheme = call_589099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589099.url(scheme.get, call_589099.host, call_589099.base,
                         call_589099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589099, url, valid)

proc call*(call_589100: Call_CloudtasksProjectsLocationsQueuesTasksCancelLease_589083;
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

var cloudtasksProjectsLocationsQueuesTasksCancelLease* = Call_CloudtasksProjectsLocationsQueuesTasksCancelLease_589083(
    name: "cloudtasksProjectsLocationsQueuesTasksCancelLease",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{name}:cancelLease",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksCancelLease_589084,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksCancelLease_589085,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesPause_589104 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesPause_589106(protocol: Scheme;
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

proc validate_CloudtasksProjectsLocationsQueuesPause_589105(path: JsonNode;
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

proc call*(call_589120: Call_CloudtasksProjectsLocationsQueuesPause_589104;
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
  let valid = call_589120.validator(path, query, header, formData, body)
  let scheme = call_589120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589120.url(scheme.get, call_589120.host, call_589120.base,
                         call_589120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589120, url, valid)

proc call*(call_589121: Call_CloudtasksProjectsLocationsQueuesPause_589104;
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

var cloudtasksProjectsLocationsQueuesPause* = Call_CloudtasksProjectsLocationsQueuesPause_589104(
    name: "cloudtasksProjectsLocationsQueuesPause", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}:pause",
    validator: validate_CloudtasksProjectsLocationsQueuesPause_589105, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesPause_589106,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesPurge_589125 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesPurge_589127(protocol: Scheme;
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

proc validate_CloudtasksProjectsLocationsQueuesPurge_589126(path: JsonNode;
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

proc call*(call_589141: Call_CloudtasksProjectsLocationsQueuesPurge_589125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Purges a queue by deleting all of its tasks.
  ## 
  ## All tasks created before this method is called are permanently deleted.
  ## 
  ## Purge operations can take up to one minute to take effect. Tasks
  ## might be dispatched before the purge takes effect. A purge is irreversible.
  ## 
  let valid = call_589141.validator(path, query, header, formData, body)
  let scheme = call_589141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589141.url(scheme.get, call_589141.host, call_589141.base,
                         call_589141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589141, url, valid)

proc call*(call_589142: Call_CloudtasksProjectsLocationsQueuesPurge_589125;
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

var cloudtasksProjectsLocationsQueuesPurge* = Call_CloudtasksProjectsLocationsQueuesPurge_589125(
    name: "cloudtasksProjectsLocationsQueuesPurge", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}:purge",
    validator: validate_CloudtasksProjectsLocationsQueuesPurge_589126, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesPurge_589127,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksRenewLease_589146 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesTasksRenewLease_589148(
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

proc validate_CloudtasksProjectsLocationsQueuesTasksRenewLease_589147(
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
  var valid_589149 = path.getOrDefault("name")
  valid_589149 = validateParameter(valid_589149, JString, required = true,
                                 default = nil)
  if valid_589149 != nil:
    section.add "name", valid_589149
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
  var valid_589152 = query.getOrDefault("quotaUser")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "quotaUser", valid_589152
  var valid_589153 = query.getOrDefault("alt")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = newJString("json"))
  if valid_589153 != nil:
    section.add "alt", valid_589153
  var valid_589154 = query.getOrDefault("oauth_token")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "oauth_token", valid_589154
  var valid_589155 = query.getOrDefault("callback")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "callback", valid_589155
  var valid_589156 = query.getOrDefault("access_token")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "access_token", valid_589156
  var valid_589157 = query.getOrDefault("uploadType")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "uploadType", valid_589157
  var valid_589158 = query.getOrDefault("key")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "key", valid_589158
  var valid_589159 = query.getOrDefault("$.xgafv")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = newJString("1"))
  if valid_589159 != nil:
    section.add "$.xgafv", valid_589159
  var valid_589160 = query.getOrDefault("prettyPrint")
  valid_589160 = validateParameter(valid_589160, JBool, required = false,
                                 default = newJBool(true))
  if valid_589160 != nil:
    section.add "prettyPrint", valid_589160
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

proc call*(call_589162: Call_CloudtasksProjectsLocationsQueuesTasksRenewLease_589146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renew the current lease of a pull task.
  ## 
  ## The worker can use this method to extend the lease by a new
  ## duration, starting from now. The new task lease will be
  ## returned in the task's schedule_time.
  ## 
  let valid = call_589162.validator(path, query, header, formData, body)
  let scheme = call_589162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589162.url(scheme.get, call_589162.host, call_589162.base,
                         call_589162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589162, url, valid)

proc call*(call_589163: Call_CloudtasksProjectsLocationsQueuesTasksRenewLease_589146;
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
  var path_589164 = newJObject()
  var query_589165 = newJObject()
  var body_589166 = newJObject()
  add(query_589165, "upload_protocol", newJString(uploadProtocol))
  add(query_589165, "fields", newJString(fields))
  add(query_589165, "quotaUser", newJString(quotaUser))
  add(path_589164, "name", newJString(name))
  add(query_589165, "alt", newJString(alt))
  add(query_589165, "oauth_token", newJString(oauthToken))
  add(query_589165, "callback", newJString(callback))
  add(query_589165, "access_token", newJString(accessToken))
  add(query_589165, "uploadType", newJString(uploadType))
  add(query_589165, "key", newJString(key))
  add(query_589165, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589166 = body
  add(query_589165, "prettyPrint", newJBool(prettyPrint))
  result = call_589163.call(path_589164, query_589165, nil, nil, body_589166)

var cloudtasksProjectsLocationsQueuesTasksRenewLease* = Call_CloudtasksProjectsLocationsQueuesTasksRenewLease_589146(
    name: "cloudtasksProjectsLocationsQueuesTasksRenewLease",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{name}:renewLease",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksRenewLease_589147,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksRenewLease_589148,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesResume_589167 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesResume_589169(protocol: Scheme;
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

proc validate_CloudtasksProjectsLocationsQueuesResume_589168(path: JsonNode;
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
  var valid_589170 = path.getOrDefault("name")
  valid_589170 = validateParameter(valid_589170, JString, required = true,
                                 default = nil)
  if valid_589170 != nil:
    section.add "name", valid_589170
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
  var valid_589171 = query.getOrDefault("upload_protocol")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "upload_protocol", valid_589171
  var valid_589172 = query.getOrDefault("fields")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "fields", valid_589172
  var valid_589173 = query.getOrDefault("quotaUser")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "quotaUser", valid_589173
  var valid_589174 = query.getOrDefault("alt")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = newJString("json"))
  if valid_589174 != nil:
    section.add "alt", valid_589174
  var valid_589175 = query.getOrDefault("oauth_token")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "oauth_token", valid_589175
  var valid_589176 = query.getOrDefault("callback")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "callback", valid_589176
  var valid_589177 = query.getOrDefault("access_token")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "access_token", valid_589177
  var valid_589178 = query.getOrDefault("uploadType")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "uploadType", valid_589178
  var valid_589179 = query.getOrDefault("key")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "key", valid_589179
  var valid_589180 = query.getOrDefault("$.xgafv")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = newJString("1"))
  if valid_589180 != nil:
    section.add "$.xgafv", valid_589180
  var valid_589181 = query.getOrDefault("prettyPrint")
  valid_589181 = validateParameter(valid_589181, JBool, required = false,
                                 default = newJBool(true))
  if valid_589181 != nil:
    section.add "prettyPrint", valid_589181
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

proc call*(call_589183: Call_CloudtasksProjectsLocationsQueuesResume_589167;
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
  let valid = call_589183.validator(path, query, header, formData, body)
  let scheme = call_589183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589183.url(scheme.get, call_589183.host, call_589183.base,
                         call_589183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589183, url, valid)

proc call*(call_589184: Call_CloudtasksProjectsLocationsQueuesResume_589167;
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
  var path_589185 = newJObject()
  var query_589186 = newJObject()
  var body_589187 = newJObject()
  add(query_589186, "upload_protocol", newJString(uploadProtocol))
  add(query_589186, "fields", newJString(fields))
  add(query_589186, "quotaUser", newJString(quotaUser))
  add(path_589185, "name", newJString(name))
  add(query_589186, "alt", newJString(alt))
  add(query_589186, "oauth_token", newJString(oauthToken))
  add(query_589186, "callback", newJString(callback))
  add(query_589186, "access_token", newJString(accessToken))
  add(query_589186, "uploadType", newJString(uploadType))
  add(query_589186, "key", newJString(key))
  add(query_589186, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589187 = body
  add(query_589186, "prettyPrint", newJBool(prettyPrint))
  result = call_589184.call(path_589185, query_589186, nil, nil, body_589187)

var cloudtasksProjectsLocationsQueuesResume* = Call_CloudtasksProjectsLocationsQueuesResume_589167(
    name: "cloudtasksProjectsLocationsQueuesResume", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}:resume",
    validator: validate_CloudtasksProjectsLocationsQueuesResume_589168, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesResume_589169,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksRun_589188 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesTasksRun_589190(protocol: Scheme;
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

proc validate_CloudtasksProjectsLocationsQueuesTasksRun_589189(path: JsonNode;
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
  var valid_589191 = path.getOrDefault("name")
  valid_589191 = validateParameter(valid_589191, JString, required = true,
                                 default = nil)
  if valid_589191 != nil:
    section.add "name", valid_589191
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
  var valid_589192 = query.getOrDefault("upload_protocol")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "upload_protocol", valid_589192
  var valid_589193 = query.getOrDefault("fields")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "fields", valid_589193
  var valid_589194 = query.getOrDefault("quotaUser")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "quotaUser", valid_589194
  var valid_589195 = query.getOrDefault("alt")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = newJString("json"))
  if valid_589195 != nil:
    section.add "alt", valid_589195
  var valid_589196 = query.getOrDefault("oauth_token")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "oauth_token", valid_589196
  var valid_589197 = query.getOrDefault("callback")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "callback", valid_589197
  var valid_589198 = query.getOrDefault("access_token")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "access_token", valid_589198
  var valid_589199 = query.getOrDefault("uploadType")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "uploadType", valid_589199
  var valid_589200 = query.getOrDefault("key")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "key", valid_589200
  var valid_589201 = query.getOrDefault("$.xgafv")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = newJString("1"))
  if valid_589201 != nil:
    section.add "$.xgafv", valid_589201
  var valid_589202 = query.getOrDefault("prettyPrint")
  valid_589202 = validateParameter(valid_589202, JBool, required = false,
                                 default = newJBool(true))
  if valid_589202 != nil:
    section.add "prettyPrint", valid_589202
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

proc call*(call_589204: Call_CloudtasksProjectsLocationsQueuesTasksRun_589188;
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
  let valid = call_589204.validator(path, query, header, formData, body)
  let scheme = call_589204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589204.url(scheme.get, call_589204.host, call_589204.base,
                         call_589204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589204, url, valid)

proc call*(call_589205: Call_CloudtasksProjectsLocationsQueuesTasksRun_589188;
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
  var path_589206 = newJObject()
  var query_589207 = newJObject()
  var body_589208 = newJObject()
  add(query_589207, "upload_protocol", newJString(uploadProtocol))
  add(query_589207, "fields", newJString(fields))
  add(query_589207, "quotaUser", newJString(quotaUser))
  add(path_589206, "name", newJString(name))
  add(query_589207, "alt", newJString(alt))
  add(query_589207, "oauth_token", newJString(oauthToken))
  add(query_589207, "callback", newJString(callback))
  add(query_589207, "access_token", newJString(accessToken))
  add(query_589207, "uploadType", newJString(uploadType))
  add(query_589207, "key", newJString(key))
  add(query_589207, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589208 = body
  add(query_589207, "prettyPrint", newJBool(prettyPrint))
  result = call_589205.call(path_589206, query_589207, nil, nil, body_589208)

var cloudtasksProjectsLocationsQueuesTasksRun* = Call_CloudtasksProjectsLocationsQueuesTasksRun_589188(
    name: "cloudtasksProjectsLocationsQueuesTasksRun", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{name}:run",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksRun_589189,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksRun_589190,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesCreate_589231 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesCreate_589233(protocol: Scheme;
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

proc validate_CloudtasksProjectsLocationsQueuesCreate_589232(path: JsonNode;
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
  var valid_589234 = path.getOrDefault("parent")
  valid_589234 = validateParameter(valid_589234, JString, required = true,
                                 default = nil)
  if valid_589234 != nil:
    section.add "parent", valid_589234
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
  var valid_589235 = query.getOrDefault("upload_protocol")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "upload_protocol", valid_589235
  var valid_589236 = query.getOrDefault("fields")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "fields", valid_589236
  var valid_589237 = query.getOrDefault("quotaUser")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "quotaUser", valid_589237
  var valid_589238 = query.getOrDefault("alt")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = newJString("json"))
  if valid_589238 != nil:
    section.add "alt", valid_589238
  var valid_589239 = query.getOrDefault("oauth_token")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "oauth_token", valid_589239
  var valid_589240 = query.getOrDefault("callback")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "callback", valid_589240
  var valid_589241 = query.getOrDefault("access_token")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "access_token", valid_589241
  var valid_589242 = query.getOrDefault("uploadType")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "uploadType", valid_589242
  var valid_589243 = query.getOrDefault("key")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "key", valid_589243
  var valid_589244 = query.getOrDefault("$.xgafv")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = newJString("1"))
  if valid_589244 != nil:
    section.add "$.xgafv", valid_589244
  var valid_589245 = query.getOrDefault("prettyPrint")
  valid_589245 = validateParameter(valid_589245, JBool, required = false,
                                 default = newJBool(true))
  if valid_589245 != nil:
    section.add "prettyPrint", valid_589245
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

proc call*(call_589247: Call_CloudtasksProjectsLocationsQueuesCreate_589231;
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
  let valid = call_589247.validator(path, query, header, formData, body)
  let scheme = call_589247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589247.url(scheme.get, call_589247.host, call_589247.base,
                         call_589247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589247, url, valid)

proc call*(call_589248: Call_CloudtasksProjectsLocationsQueuesCreate_589231;
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
  var path_589249 = newJObject()
  var query_589250 = newJObject()
  var body_589251 = newJObject()
  add(query_589250, "upload_protocol", newJString(uploadProtocol))
  add(query_589250, "fields", newJString(fields))
  add(query_589250, "quotaUser", newJString(quotaUser))
  add(query_589250, "alt", newJString(alt))
  add(query_589250, "oauth_token", newJString(oauthToken))
  add(query_589250, "callback", newJString(callback))
  add(query_589250, "access_token", newJString(accessToken))
  add(query_589250, "uploadType", newJString(uploadType))
  add(path_589249, "parent", newJString(parent))
  add(query_589250, "key", newJString(key))
  add(query_589250, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589251 = body
  add(query_589250, "prettyPrint", newJBool(prettyPrint))
  result = call_589248.call(path_589249, query_589250, nil, nil, body_589251)

var cloudtasksProjectsLocationsQueuesCreate* = Call_CloudtasksProjectsLocationsQueuesCreate_589231(
    name: "cloudtasksProjectsLocationsQueuesCreate", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{parent}/queues",
    validator: validate_CloudtasksProjectsLocationsQueuesCreate_589232, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesCreate_589233,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesList_589209 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesList_589211(protocol: Scheme;
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

proc validate_CloudtasksProjectsLocationsQueuesList_589210(path: JsonNode;
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
  var valid_589212 = path.getOrDefault("parent")
  valid_589212 = validateParameter(valid_589212, JString, required = true,
                                 default = nil)
  if valid_589212 != nil:
    section.add "parent", valid_589212
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
  var valid_589213 = query.getOrDefault("upload_protocol")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "upload_protocol", valid_589213
  var valid_589214 = query.getOrDefault("fields")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "fields", valid_589214
  var valid_589215 = query.getOrDefault("pageToken")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "pageToken", valid_589215
  var valid_589216 = query.getOrDefault("quotaUser")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "quotaUser", valid_589216
  var valid_589217 = query.getOrDefault("alt")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = newJString("json"))
  if valid_589217 != nil:
    section.add "alt", valid_589217
  var valid_589218 = query.getOrDefault("oauth_token")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "oauth_token", valid_589218
  var valid_589219 = query.getOrDefault("callback")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "callback", valid_589219
  var valid_589220 = query.getOrDefault("access_token")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "access_token", valid_589220
  var valid_589221 = query.getOrDefault("uploadType")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "uploadType", valid_589221
  var valid_589222 = query.getOrDefault("key")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "key", valid_589222
  var valid_589223 = query.getOrDefault("$.xgafv")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = newJString("1"))
  if valid_589223 != nil:
    section.add "$.xgafv", valid_589223
  var valid_589224 = query.getOrDefault("pageSize")
  valid_589224 = validateParameter(valid_589224, JInt, required = false, default = nil)
  if valid_589224 != nil:
    section.add "pageSize", valid_589224
  var valid_589225 = query.getOrDefault("prettyPrint")
  valid_589225 = validateParameter(valid_589225, JBool, required = false,
                                 default = newJBool(true))
  if valid_589225 != nil:
    section.add "prettyPrint", valid_589225
  var valid_589226 = query.getOrDefault("filter")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "filter", valid_589226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589227: Call_CloudtasksProjectsLocationsQueuesList_589209;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists queues.
  ## 
  ## Queues are returned in lexicographical order.
  ## 
  let valid = call_589227.validator(path, query, header, formData, body)
  let scheme = call_589227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589227.url(scheme.get, call_589227.host, call_589227.base,
                         call_589227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589227, url, valid)

proc call*(call_589228: Call_CloudtasksProjectsLocationsQueuesList_589209;
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
  var path_589229 = newJObject()
  var query_589230 = newJObject()
  add(query_589230, "upload_protocol", newJString(uploadProtocol))
  add(query_589230, "fields", newJString(fields))
  add(query_589230, "pageToken", newJString(pageToken))
  add(query_589230, "quotaUser", newJString(quotaUser))
  add(query_589230, "alt", newJString(alt))
  add(query_589230, "oauth_token", newJString(oauthToken))
  add(query_589230, "callback", newJString(callback))
  add(query_589230, "access_token", newJString(accessToken))
  add(query_589230, "uploadType", newJString(uploadType))
  add(path_589229, "parent", newJString(parent))
  add(query_589230, "key", newJString(key))
  add(query_589230, "$.xgafv", newJString(Xgafv))
  add(query_589230, "pageSize", newJInt(pageSize))
  add(query_589230, "prettyPrint", newJBool(prettyPrint))
  add(query_589230, "filter", newJString(filter))
  result = call_589228.call(path_589229, query_589230, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesList* = Call_CloudtasksProjectsLocationsQueuesList_589209(
    name: "cloudtasksProjectsLocationsQueuesList", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{parent}/queues",
    validator: validate_CloudtasksProjectsLocationsQueuesList_589210, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesList_589211, schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksCreate_589274 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesTasksCreate_589276(protocol: Scheme;
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

proc validate_CloudtasksProjectsLocationsQueuesTasksCreate_589275(path: JsonNode;
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
  var valid_589277 = path.getOrDefault("parent")
  valid_589277 = validateParameter(valid_589277, JString, required = true,
                                 default = nil)
  if valid_589277 != nil:
    section.add "parent", valid_589277
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

proc call*(call_589290: Call_CloudtasksProjectsLocationsQueuesTasksCreate_589274;
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
  let valid = call_589290.validator(path, query, header, formData, body)
  let scheme = call_589290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589290.url(scheme.get, call_589290.host, call_589290.base,
                         call_589290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589290, url, valid)

proc call*(call_589291: Call_CloudtasksProjectsLocationsQueuesTasksCreate_589274;
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
  add(path_589292, "parent", newJString(parent))
  add(query_589293, "key", newJString(key))
  add(query_589293, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589294 = body
  add(query_589293, "prettyPrint", newJBool(prettyPrint))
  result = call_589291.call(path_589292, query_589293, nil, nil, body_589294)

var cloudtasksProjectsLocationsQueuesTasksCreate* = Call_CloudtasksProjectsLocationsQueuesTasksCreate_589274(
    name: "cloudtasksProjectsLocationsQueuesTasksCreate",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{parent}/tasks",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksCreate_589275,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksCreate_589276,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksList_589252 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesTasksList_589254(protocol: Scheme;
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

proc validate_CloudtasksProjectsLocationsQueuesTasksList_589253(path: JsonNode;
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
  var valid_589255 = path.getOrDefault("parent")
  valid_589255 = validateParameter(valid_589255, JString, required = true,
                                 default = nil)
  if valid_589255 != nil:
    section.add "parent", valid_589255
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
  var valid_589256 = query.getOrDefault("upload_protocol")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "upload_protocol", valid_589256
  var valid_589257 = query.getOrDefault("fields")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "fields", valid_589257
  var valid_589258 = query.getOrDefault("pageToken")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "pageToken", valid_589258
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
  var valid_589267 = query.getOrDefault("pageSize")
  valid_589267 = validateParameter(valid_589267, JInt, required = false, default = nil)
  if valid_589267 != nil:
    section.add "pageSize", valid_589267
  var valid_589268 = query.getOrDefault("prettyPrint")
  valid_589268 = validateParameter(valid_589268, JBool, required = false,
                                 default = newJBool(true))
  if valid_589268 != nil:
    section.add "prettyPrint", valid_589268
  var valid_589269 = query.getOrDefault("responseView")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_589269 != nil:
    section.add "responseView", valid_589269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589270: Call_CloudtasksProjectsLocationsQueuesTasksList_589252;
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
  let valid = call_589270.validator(path, query, header, formData, body)
  let scheme = call_589270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589270.url(scheme.get, call_589270.host, call_589270.base,
                         call_589270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589270, url, valid)

proc call*(call_589271: Call_CloudtasksProjectsLocationsQueuesTasksList_589252;
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
  var path_589272 = newJObject()
  var query_589273 = newJObject()
  add(query_589273, "upload_protocol", newJString(uploadProtocol))
  add(query_589273, "fields", newJString(fields))
  add(query_589273, "pageToken", newJString(pageToken))
  add(query_589273, "quotaUser", newJString(quotaUser))
  add(query_589273, "alt", newJString(alt))
  add(query_589273, "oauth_token", newJString(oauthToken))
  add(query_589273, "callback", newJString(callback))
  add(query_589273, "access_token", newJString(accessToken))
  add(query_589273, "uploadType", newJString(uploadType))
  add(path_589272, "parent", newJString(parent))
  add(query_589273, "key", newJString(key))
  add(query_589273, "$.xgafv", newJString(Xgafv))
  add(query_589273, "pageSize", newJInt(pageSize))
  add(query_589273, "prettyPrint", newJBool(prettyPrint))
  add(query_589273, "responseView", newJString(responseView))
  result = call_589271.call(path_589272, query_589273, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesTasksList* = Call_CloudtasksProjectsLocationsQueuesTasksList_589252(
    name: "cloudtasksProjectsLocationsQueuesTasksList", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2beta2/{parent}/tasks",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksList_589253,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksList_589254,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksLease_589295 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesTasksLease_589297(protocol: Scheme;
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

proc validate_CloudtasksProjectsLocationsQueuesTasksLease_589296(path: JsonNode;
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
  var valid_589298 = path.getOrDefault("parent")
  valid_589298 = validateParameter(valid_589298, JString, required = true,
                                 default = nil)
  if valid_589298 != nil:
    section.add "parent", valid_589298
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
  var valid_589299 = query.getOrDefault("upload_protocol")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "upload_protocol", valid_589299
  var valid_589300 = query.getOrDefault("fields")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "fields", valid_589300
  var valid_589301 = query.getOrDefault("quotaUser")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "quotaUser", valid_589301
  var valid_589302 = query.getOrDefault("alt")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = newJString("json"))
  if valid_589302 != nil:
    section.add "alt", valid_589302
  var valid_589303 = query.getOrDefault("oauth_token")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "oauth_token", valid_589303
  var valid_589304 = query.getOrDefault("callback")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "callback", valid_589304
  var valid_589305 = query.getOrDefault("access_token")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "access_token", valid_589305
  var valid_589306 = query.getOrDefault("uploadType")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "uploadType", valid_589306
  var valid_589307 = query.getOrDefault("key")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "key", valid_589307
  var valid_589308 = query.getOrDefault("$.xgafv")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = newJString("1"))
  if valid_589308 != nil:
    section.add "$.xgafv", valid_589308
  var valid_589309 = query.getOrDefault("prettyPrint")
  valid_589309 = validateParameter(valid_589309, JBool, required = false,
                                 default = newJBool(true))
  if valid_589309 != nil:
    section.add "prettyPrint", valid_589309
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

proc call*(call_589311: Call_CloudtasksProjectsLocationsQueuesTasksLease_589295;
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
  let valid = call_589311.validator(path, query, header, formData, body)
  let scheme = call_589311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589311.url(scheme.get, call_589311.host, call_589311.base,
                         call_589311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589311, url, valid)

proc call*(call_589312: Call_CloudtasksProjectsLocationsQueuesTasksLease_589295;
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
  var path_589313 = newJObject()
  var query_589314 = newJObject()
  var body_589315 = newJObject()
  add(query_589314, "upload_protocol", newJString(uploadProtocol))
  add(query_589314, "fields", newJString(fields))
  add(query_589314, "quotaUser", newJString(quotaUser))
  add(query_589314, "alt", newJString(alt))
  add(query_589314, "oauth_token", newJString(oauthToken))
  add(query_589314, "callback", newJString(callback))
  add(query_589314, "access_token", newJString(accessToken))
  add(query_589314, "uploadType", newJString(uploadType))
  add(path_589313, "parent", newJString(parent))
  add(query_589314, "key", newJString(key))
  add(query_589314, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589315 = body
  add(query_589314, "prettyPrint", newJBool(prettyPrint))
  result = call_589312.call(path_589313, query_589314, nil, nil, body_589315)

var cloudtasksProjectsLocationsQueuesTasksLease* = Call_CloudtasksProjectsLocationsQueuesTasksLease_589295(
    name: "cloudtasksProjectsLocationsQueuesTasksLease",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{parent}/tasks:lease",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksLease_589296,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksLease_589297,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_589316 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesGetIamPolicy_589318(protocol: Scheme;
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

proc validate_CloudtasksProjectsLocationsQueuesGetIamPolicy_589317(
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
  var valid_589319 = path.getOrDefault("resource")
  valid_589319 = validateParameter(valid_589319, JString, required = true,
                                 default = nil)
  if valid_589319 != nil:
    section.add "resource", valid_589319
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
  var valid_589320 = query.getOrDefault("upload_protocol")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "upload_protocol", valid_589320
  var valid_589321 = query.getOrDefault("fields")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "fields", valid_589321
  var valid_589322 = query.getOrDefault("quotaUser")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "quotaUser", valid_589322
  var valid_589323 = query.getOrDefault("alt")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = newJString("json"))
  if valid_589323 != nil:
    section.add "alt", valid_589323
  var valid_589324 = query.getOrDefault("oauth_token")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "oauth_token", valid_589324
  var valid_589325 = query.getOrDefault("callback")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "callback", valid_589325
  var valid_589326 = query.getOrDefault("access_token")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "access_token", valid_589326
  var valid_589327 = query.getOrDefault("uploadType")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "uploadType", valid_589327
  var valid_589328 = query.getOrDefault("key")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "key", valid_589328
  var valid_589329 = query.getOrDefault("$.xgafv")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = newJString("1"))
  if valid_589329 != nil:
    section.add "$.xgafv", valid_589329
  var valid_589330 = query.getOrDefault("prettyPrint")
  valid_589330 = validateParameter(valid_589330, JBool, required = false,
                                 default = newJBool(true))
  if valid_589330 != nil:
    section.add "prettyPrint", valid_589330
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

proc call*(call_589332: Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_589316;
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
  let valid = call_589332.validator(path, query, header, formData, body)
  let scheme = call_589332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589332.url(scheme.get, call_589332.host, call_589332.base,
                         call_589332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589332, url, valid)

proc call*(call_589333: Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_589316;
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
  var path_589334 = newJObject()
  var query_589335 = newJObject()
  var body_589336 = newJObject()
  add(query_589335, "upload_protocol", newJString(uploadProtocol))
  add(query_589335, "fields", newJString(fields))
  add(query_589335, "quotaUser", newJString(quotaUser))
  add(query_589335, "alt", newJString(alt))
  add(query_589335, "oauth_token", newJString(oauthToken))
  add(query_589335, "callback", newJString(callback))
  add(query_589335, "access_token", newJString(accessToken))
  add(query_589335, "uploadType", newJString(uploadType))
  add(query_589335, "key", newJString(key))
  add(query_589335, "$.xgafv", newJString(Xgafv))
  add(path_589334, "resource", newJString(resource))
  if body != nil:
    body_589336 = body
  add(query_589335, "prettyPrint", newJBool(prettyPrint))
  result = call_589333.call(path_589334, query_589335, nil, nil, body_589336)

var cloudtasksProjectsLocationsQueuesGetIamPolicy* = Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_589316(
    name: "cloudtasksProjectsLocationsQueuesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{resource}:getIamPolicy",
    validator: validate_CloudtasksProjectsLocationsQueuesGetIamPolicy_589317,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesGetIamPolicy_589318,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_589337 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesSetIamPolicy_589339(protocol: Scheme;
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

proc validate_CloudtasksProjectsLocationsQueuesSetIamPolicy_589338(
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
  var valid_589340 = path.getOrDefault("resource")
  valid_589340 = validateParameter(valid_589340, JString, required = true,
                                 default = nil)
  if valid_589340 != nil:
    section.add "resource", valid_589340
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
  var valid_589341 = query.getOrDefault("upload_protocol")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "upload_protocol", valid_589341
  var valid_589342 = query.getOrDefault("fields")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "fields", valid_589342
  var valid_589343 = query.getOrDefault("quotaUser")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "quotaUser", valid_589343
  var valid_589344 = query.getOrDefault("alt")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = newJString("json"))
  if valid_589344 != nil:
    section.add "alt", valid_589344
  var valid_589345 = query.getOrDefault("oauth_token")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "oauth_token", valid_589345
  var valid_589346 = query.getOrDefault("callback")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "callback", valid_589346
  var valid_589347 = query.getOrDefault("access_token")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "access_token", valid_589347
  var valid_589348 = query.getOrDefault("uploadType")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "uploadType", valid_589348
  var valid_589349 = query.getOrDefault("key")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "key", valid_589349
  var valid_589350 = query.getOrDefault("$.xgafv")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = newJString("1"))
  if valid_589350 != nil:
    section.add "$.xgafv", valid_589350
  var valid_589351 = query.getOrDefault("prettyPrint")
  valid_589351 = validateParameter(valid_589351, JBool, required = false,
                                 default = newJBool(true))
  if valid_589351 != nil:
    section.add "prettyPrint", valid_589351
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

proc call*(call_589353: Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_589337;
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
  let valid = call_589353.validator(path, query, header, formData, body)
  let scheme = call_589353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589353.url(scheme.get, call_589353.host, call_589353.base,
                         call_589353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589353, url, valid)

proc call*(call_589354: Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_589337;
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
  var path_589355 = newJObject()
  var query_589356 = newJObject()
  var body_589357 = newJObject()
  add(query_589356, "upload_protocol", newJString(uploadProtocol))
  add(query_589356, "fields", newJString(fields))
  add(query_589356, "quotaUser", newJString(quotaUser))
  add(query_589356, "alt", newJString(alt))
  add(query_589356, "oauth_token", newJString(oauthToken))
  add(query_589356, "callback", newJString(callback))
  add(query_589356, "access_token", newJString(accessToken))
  add(query_589356, "uploadType", newJString(uploadType))
  add(query_589356, "key", newJString(key))
  add(query_589356, "$.xgafv", newJString(Xgafv))
  add(path_589355, "resource", newJString(resource))
  if body != nil:
    body_589357 = body
  add(query_589356, "prettyPrint", newJBool(prettyPrint))
  result = call_589354.call(path_589355, query_589356, nil, nil, body_589357)

var cloudtasksProjectsLocationsQueuesSetIamPolicy* = Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_589337(
    name: "cloudtasksProjectsLocationsQueuesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{resource}:setIamPolicy",
    validator: validate_CloudtasksProjectsLocationsQueuesSetIamPolicy_589338,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesSetIamPolicy_589339,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_589358 = ref object of OpenApiRestCall_588441
proc url_CloudtasksProjectsLocationsQueuesTestIamPermissions_589360(
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

proc validate_CloudtasksProjectsLocationsQueuesTestIamPermissions_589359(
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
  var valid_589361 = path.getOrDefault("resource")
  valid_589361 = validateParameter(valid_589361, JString, required = true,
                                 default = nil)
  if valid_589361 != nil:
    section.add "resource", valid_589361
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
  var valid_589362 = query.getOrDefault("upload_protocol")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "upload_protocol", valid_589362
  var valid_589363 = query.getOrDefault("fields")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "fields", valid_589363
  var valid_589364 = query.getOrDefault("quotaUser")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "quotaUser", valid_589364
  var valid_589365 = query.getOrDefault("alt")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = newJString("json"))
  if valid_589365 != nil:
    section.add "alt", valid_589365
  var valid_589366 = query.getOrDefault("oauth_token")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "oauth_token", valid_589366
  var valid_589367 = query.getOrDefault("callback")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "callback", valid_589367
  var valid_589368 = query.getOrDefault("access_token")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "access_token", valid_589368
  var valid_589369 = query.getOrDefault("uploadType")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "uploadType", valid_589369
  var valid_589370 = query.getOrDefault("key")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "key", valid_589370
  var valid_589371 = query.getOrDefault("$.xgafv")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = newJString("1"))
  if valid_589371 != nil:
    section.add "$.xgafv", valid_589371
  var valid_589372 = query.getOrDefault("prettyPrint")
  valid_589372 = validateParameter(valid_589372, JBool, required = false,
                                 default = newJBool(true))
  if valid_589372 != nil:
    section.add "prettyPrint", valid_589372
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

proc call*(call_589374: Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_589358;
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
  let valid = call_589374.validator(path, query, header, formData, body)
  let scheme = call_589374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589374.url(scheme.get, call_589374.host, call_589374.base,
                         call_589374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589374, url, valid)

proc call*(call_589375: Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_589358;
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
  var path_589376 = newJObject()
  var query_589377 = newJObject()
  var body_589378 = newJObject()
  add(query_589377, "upload_protocol", newJString(uploadProtocol))
  add(query_589377, "fields", newJString(fields))
  add(query_589377, "quotaUser", newJString(quotaUser))
  add(query_589377, "alt", newJString(alt))
  add(query_589377, "oauth_token", newJString(oauthToken))
  add(query_589377, "callback", newJString(callback))
  add(query_589377, "access_token", newJString(accessToken))
  add(query_589377, "uploadType", newJString(uploadType))
  add(query_589377, "key", newJString(key))
  add(query_589377, "$.xgafv", newJString(Xgafv))
  add(path_589376, "resource", newJString(resource))
  if body != nil:
    body_589378 = body
  add(query_589377, "prettyPrint", newJBool(prettyPrint))
  result = call_589375.call(path_589376, query_589377, nil, nil, body_589378)

var cloudtasksProjectsLocationsQueuesTestIamPermissions* = Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_589358(
    name: "cloudtasksProjectsLocationsQueuesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta2/{resource}:testIamPermissions",
    validator: validate_CloudtasksProjectsLocationsQueuesTestIamPermissions_589359,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTestIamPermissions_589360,
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
