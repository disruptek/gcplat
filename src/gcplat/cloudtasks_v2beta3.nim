
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Tasks
## version: v2beta3
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
  gcpServiceName = "cloudtasks"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudtasksProjectsLocationsQueuesTasksGet_579677 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsQueuesTasksGet_579679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksGet_579678(path: JsonNode;
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
  var valid_579805 = path.getOrDefault("name")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "name", valid_579805
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
  var valid_579806 = query.getOrDefault("upload_protocol")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "upload_protocol", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("callback")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "callback", valid_579824
  var valid_579825 = query.getOrDefault("access_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "access_token", valid_579825
  var valid_579826 = query.getOrDefault("uploadType")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "uploadType", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("prettyPrint")
  valid_579829 = validateParameter(valid_579829, JBool, required = false,
                                 default = newJBool(true))
  if valid_579829 != nil:
    section.add "prettyPrint", valid_579829
  var valid_579830 = query.getOrDefault("responseView")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_579830 != nil:
    section.add "responseView", valid_579830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579853: Call_CloudtasksProjectsLocationsQueuesTasksGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a task.
  ## 
  let valid = call_579853.validator(path, query, header, formData, body)
  let scheme = call_579853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579853.url(scheme.get, call_579853.host, call_579853.base,
                         call_579853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579853, url, valid)

proc call*(call_579924: Call_CloudtasksProjectsLocationsQueuesTasksGet_579677;
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
  var path_579925 = newJObject()
  var query_579927 = newJObject()
  add(query_579927, "upload_protocol", newJString(uploadProtocol))
  add(query_579927, "fields", newJString(fields))
  add(query_579927, "quotaUser", newJString(quotaUser))
  add(path_579925, "name", newJString(name))
  add(query_579927, "alt", newJString(alt))
  add(query_579927, "oauth_token", newJString(oauthToken))
  add(query_579927, "callback", newJString(callback))
  add(query_579927, "access_token", newJString(accessToken))
  add(query_579927, "uploadType", newJString(uploadType))
  add(query_579927, "key", newJString(key))
  add(query_579927, "$.xgafv", newJString(Xgafv))
  add(query_579927, "prettyPrint", newJBool(prettyPrint))
  add(query_579927, "responseView", newJString(responseView))
  result = call_579924.call(path_579925, query_579927, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesTasksGet* = Call_CloudtasksProjectsLocationsQueuesTasksGet_579677(
    name: "cloudtasksProjectsLocationsQueuesTasksGet", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2beta3/{name}",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksGet_579678,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksGet_579679,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesPatch_579985 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsQueuesPatch_579987(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesPatch_579986(path: JsonNode;
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
  var valid_579988 = path.getOrDefault("name")
  valid_579988 = validateParameter(valid_579988, JString, required = true,
                                 default = nil)
  if valid_579988 != nil:
    section.add "name", valid_579988
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
  var valid_579989 = query.getOrDefault("upload_protocol")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "upload_protocol", valid_579989
  var valid_579990 = query.getOrDefault("fields")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "fields", valid_579990
  var valid_579991 = query.getOrDefault("quotaUser")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "quotaUser", valid_579991
  var valid_579992 = query.getOrDefault("alt")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = newJString("json"))
  if valid_579992 != nil:
    section.add "alt", valid_579992
  var valid_579993 = query.getOrDefault("oauth_token")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "oauth_token", valid_579993
  var valid_579994 = query.getOrDefault("callback")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "callback", valid_579994
  var valid_579995 = query.getOrDefault("access_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "access_token", valid_579995
  var valid_579996 = query.getOrDefault("uploadType")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "uploadType", valid_579996
  var valid_579997 = query.getOrDefault("key")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "key", valid_579997
  var valid_579998 = query.getOrDefault("$.xgafv")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = newJString("1"))
  if valid_579998 != nil:
    section.add "$.xgafv", valid_579998
  var valid_579999 = query.getOrDefault("prettyPrint")
  valid_579999 = validateParameter(valid_579999, JBool, required = false,
                                 default = newJBool(true))
  if valid_579999 != nil:
    section.add "prettyPrint", valid_579999
  var valid_580000 = query.getOrDefault("updateMask")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "updateMask", valid_580000
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

proc call*(call_580002: Call_CloudtasksProjectsLocationsQueuesPatch_579985;
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
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_CloudtasksProjectsLocationsQueuesPatch_579985;
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
  var path_580004 = newJObject()
  var query_580005 = newJObject()
  var body_580006 = newJObject()
  add(query_580005, "upload_protocol", newJString(uploadProtocol))
  add(query_580005, "fields", newJString(fields))
  add(query_580005, "quotaUser", newJString(quotaUser))
  add(path_580004, "name", newJString(name))
  add(query_580005, "alt", newJString(alt))
  add(query_580005, "oauth_token", newJString(oauthToken))
  add(query_580005, "callback", newJString(callback))
  add(query_580005, "access_token", newJString(accessToken))
  add(query_580005, "uploadType", newJString(uploadType))
  add(query_580005, "key", newJString(key))
  add(query_580005, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580006 = body
  add(query_580005, "prettyPrint", newJBool(prettyPrint))
  add(query_580005, "updateMask", newJString(updateMask))
  result = call_580003.call(path_580004, query_580005, nil, nil, body_580006)

var cloudtasksProjectsLocationsQueuesPatch* = Call_CloudtasksProjectsLocationsQueuesPatch_579985(
    name: "cloudtasksProjectsLocationsQueuesPatch", meth: HttpMethod.HttpPatch,
    host: "cloudtasks.googleapis.com", route: "/v2beta3/{name}",
    validator: validate_CloudtasksProjectsLocationsQueuesPatch_579986, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesPatch_579987,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksDelete_579966 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsQueuesTasksDelete_579968(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksDelete_579967(path: JsonNode;
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
  var valid_579969 = path.getOrDefault("name")
  valid_579969 = validateParameter(valid_579969, JString, required = true,
                                 default = nil)
  if valid_579969 != nil:
    section.add "name", valid_579969
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
  var valid_579970 = query.getOrDefault("upload_protocol")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "upload_protocol", valid_579970
  var valid_579971 = query.getOrDefault("fields")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "fields", valid_579971
  var valid_579972 = query.getOrDefault("quotaUser")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "quotaUser", valid_579972
  var valid_579973 = query.getOrDefault("alt")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = newJString("json"))
  if valid_579973 != nil:
    section.add "alt", valid_579973
  var valid_579974 = query.getOrDefault("oauth_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "oauth_token", valid_579974
  var valid_579975 = query.getOrDefault("callback")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "callback", valid_579975
  var valid_579976 = query.getOrDefault("access_token")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "access_token", valid_579976
  var valid_579977 = query.getOrDefault("uploadType")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "uploadType", valid_579977
  var valid_579978 = query.getOrDefault("key")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "key", valid_579978
  var valid_579979 = query.getOrDefault("$.xgafv")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("1"))
  if valid_579979 != nil:
    section.add "$.xgafv", valid_579979
  var valid_579980 = query.getOrDefault("prettyPrint")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(true))
  if valid_579980 != nil:
    section.add "prettyPrint", valid_579980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579981: Call_CloudtasksProjectsLocationsQueuesTasksDelete_579966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a task.
  ## 
  ## A task can be deleted if it is scheduled or dispatched. A task
  ## cannot be deleted if it has executed successfully or permanently
  ## failed.
  ## 
  let valid = call_579981.validator(path, query, header, formData, body)
  let scheme = call_579981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579981.url(scheme.get, call_579981.host, call_579981.base,
                         call_579981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579981, url, valid)

proc call*(call_579982: Call_CloudtasksProjectsLocationsQueuesTasksDelete_579966;
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
  var path_579983 = newJObject()
  var query_579984 = newJObject()
  add(query_579984, "upload_protocol", newJString(uploadProtocol))
  add(query_579984, "fields", newJString(fields))
  add(query_579984, "quotaUser", newJString(quotaUser))
  add(path_579983, "name", newJString(name))
  add(query_579984, "alt", newJString(alt))
  add(query_579984, "oauth_token", newJString(oauthToken))
  add(query_579984, "callback", newJString(callback))
  add(query_579984, "access_token", newJString(accessToken))
  add(query_579984, "uploadType", newJString(uploadType))
  add(query_579984, "key", newJString(key))
  add(query_579984, "$.xgafv", newJString(Xgafv))
  add(query_579984, "prettyPrint", newJBool(prettyPrint))
  result = call_579982.call(path_579983, query_579984, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesTasksDelete* = Call_CloudtasksProjectsLocationsQueuesTasksDelete_579966(
    name: "cloudtasksProjectsLocationsQueuesTasksDelete",
    meth: HttpMethod.HttpDelete, host: "cloudtasks.googleapis.com",
    route: "/v2beta3/{name}",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksDelete_579967,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksDelete_579968,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsList_580007 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsList_580009(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsList_580008(path: JsonNode;
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
  var valid_580010 = path.getOrDefault("name")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "name", valid_580010
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
  var valid_580011 = query.getOrDefault("upload_protocol")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "upload_protocol", valid_580011
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("pageToken")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "pageToken", valid_580013
  var valid_580014 = query.getOrDefault("quotaUser")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "quotaUser", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("oauth_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "oauth_token", valid_580016
  var valid_580017 = query.getOrDefault("callback")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "callback", valid_580017
  var valid_580018 = query.getOrDefault("access_token")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "access_token", valid_580018
  var valid_580019 = query.getOrDefault("uploadType")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "uploadType", valid_580019
  var valid_580020 = query.getOrDefault("key")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "key", valid_580020
  var valid_580021 = query.getOrDefault("$.xgafv")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("1"))
  if valid_580021 != nil:
    section.add "$.xgafv", valid_580021
  var valid_580022 = query.getOrDefault("pageSize")
  valid_580022 = validateParameter(valid_580022, JInt, required = false, default = nil)
  if valid_580022 != nil:
    section.add "pageSize", valid_580022
  var valid_580023 = query.getOrDefault("prettyPrint")
  valid_580023 = validateParameter(valid_580023, JBool, required = false,
                                 default = newJBool(true))
  if valid_580023 != nil:
    section.add "prettyPrint", valid_580023
  var valid_580024 = query.getOrDefault("filter")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "filter", valid_580024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580025: Call_CloudtasksProjectsLocationsList_580007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580025.validator(path, query, header, formData, body)
  let scheme = call_580025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580025.url(scheme.get, call_580025.host, call_580025.base,
                         call_580025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580025, url, valid)

proc call*(call_580026: Call_CloudtasksProjectsLocationsList_580007; name: string;
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
  var path_580027 = newJObject()
  var query_580028 = newJObject()
  add(query_580028, "upload_protocol", newJString(uploadProtocol))
  add(query_580028, "fields", newJString(fields))
  add(query_580028, "pageToken", newJString(pageToken))
  add(query_580028, "quotaUser", newJString(quotaUser))
  add(path_580027, "name", newJString(name))
  add(query_580028, "alt", newJString(alt))
  add(query_580028, "oauth_token", newJString(oauthToken))
  add(query_580028, "callback", newJString(callback))
  add(query_580028, "access_token", newJString(accessToken))
  add(query_580028, "uploadType", newJString(uploadType))
  add(query_580028, "key", newJString(key))
  add(query_580028, "$.xgafv", newJString(Xgafv))
  add(query_580028, "pageSize", newJInt(pageSize))
  add(query_580028, "prettyPrint", newJBool(prettyPrint))
  add(query_580028, "filter", newJString(filter))
  result = call_580026.call(path_580027, query_580028, nil, nil, nil)

var cloudtasksProjectsLocationsList* = Call_CloudtasksProjectsLocationsList_580007(
    name: "cloudtasksProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2beta3/{name}/locations",
    validator: validate_CloudtasksProjectsLocationsList_580008, base: "/",
    url: url_CloudtasksProjectsLocationsList_580009, schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesPause_580029 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsQueuesPause_580031(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":pause")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesPause_580030(path: JsonNode;
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
  var valid_580032 = path.getOrDefault("name")
  valid_580032 = validateParameter(valid_580032, JString, required = true,
                                 default = nil)
  if valid_580032 != nil:
    section.add "name", valid_580032
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
  var valid_580033 = query.getOrDefault("upload_protocol")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "upload_protocol", valid_580033
  var valid_580034 = query.getOrDefault("fields")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "fields", valid_580034
  var valid_580035 = query.getOrDefault("quotaUser")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "quotaUser", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("oauth_token")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "oauth_token", valid_580037
  var valid_580038 = query.getOrDefault("callback")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "callback", valid_580038
  var valid_580039 = query.getOrDefault("access_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "access_token", valid_580039
  var valid_580040 = query.getOrDefault("uploadType")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "uploadType", valid_580040
  var valid_580041 = query.getOrDefault("key")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "key", valid_580041
  var valid_580042 = query.getOrDefault("$.xgafv")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("1"))
  if valid_580042 != nil:
    section.add "$.xgafv", valid_580042
  var valid_580043 = query.getOrDefault("prettyPrint")
  valid_580043 = validateParameter(valid_580043, JBool, required = false,
                                 default = newJBool(true))
  if valid_580043 != nil:
    section.add "prettyPrint", valid_580043
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

proc call*(call_580045: Call_CloudtasksProjectsLocationsQueuesPause_580029;
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
  let valid = call_580045.validator(path, query, header, formData, body)
  let scheme = call_580045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580045.url(scheme.get, call_580045.host, call_580045.base,
                         call_580045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580045, url, valid)

proc call*(call_580046: Call_CloudtasksProjectsLocationsQueuesPause_580029;
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
  var path_580047 = newJObject()
  var query_580048 = newJObject()
  var body_580049 = newJObject()
  add(query_580048, "upload_protocol", newJString(uploadProtocol))
  add(query_580048, "fields", newJString(fields))
  add(query_580048, "quotaUser", newJString(quotaUser))
  add(path_580047, "name", newJString(name))
  add(query_580048, "alt", newJString(alt))
  add(query_580048, "oauth_token", newJString(oauthToken))
  add(query_580048, "callback", newJString(callback))
  add(query_580048, "access_token", newJString(accessToken))
  add(query_580048, "uploadType", newJString(uploadType))
  add(query_580048, "key", newJString(key))
  add(query_580048, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580049 = body
  add(query_580048, "prettyPrint", newJBool(prettyPrint))
  result = call_580046.call(path_580047, query_580048, nil, nil, body_580049)

var cloudtasksProjectsLocationsQueuesPause* = Call_CloudtasksProjectsLocationsQueuesPause_580029(
    name: "cloudtasksProjectsLocationsQueuesPause", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta3/{name}:pause",
    validator: validate_CloudtasksProjectsLocationsQueuesPause_580030, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesPause_580031,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesPurge_580050 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsQueuesPurge_580052(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":purge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesPurge_580051(path: JsonNode;
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
  var valid_580053 = path.getOrDefault("name")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "name", valid_580053
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
  var valid_580054 = query.getOrDefault("upload_protocol")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "upload_protocol", valid_580054
  var valid_580055 = query.getOrDefault("fields")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "fields", valid_580055
  var valid_580056 = query.getOrDefault("quotaUser")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "quotaUser", valid_580056
  var valid_580057 = query.getOrDefault("alt")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("json"))
  if valid_580057 != nil:
    section.add "alt", valid_580057
  var valid_580058 = query.getOrDefault("oauth_token")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "oauth_token", valid_580058
  var valid_580059 = query.getOrDefault("callback")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "callback", valid_580059
  var valid_580060 = query.getOrDefault("access_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "access_token", valid_580060
  var valid_580061 = query.getOrDefault("uploadType")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "uploadType", valid_580061
  var valid_580062 = query.getOrDefault("key")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "key", valid_580062
  var valid_580063 = query.getOrDefault("$.xgafv")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = newJString("1"))
  if valid_580063 != nil:
    section.add "$.xgafv", valid_580063
  var valid_580064 = query.getOrDefault("prettyPrint")
  valid_580064 = validateParameter(valid_580064, JBool, required = false,
                                 default = newJBool(true))
  if valid_580064 != nil:
    section.add "prettyPrint", valid_580064
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

proc call*(call_580066: Call_CloudtasksProjectsLocationsQueuesPurge_580050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Purges a queue by deleting all of its tasks.
  ## 
  ## All tasks created before this method is called are permanently deleted.
  ## 
  ## Purge operations can take up to one minute to take effect. Tasks
  ## might be dispatched before the purge takes effect. A purge is irreversible.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_CloudtasksProjectsLocationsQueuesPurge_580050;
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
  var path_580068 = newJObject()
  var query_580069 = newJObject()
  var body_580070 = newJObject()
  add(query_580069, "upload_protocol", newJString(uploadProtocol))
  add(query_580069, "fields", newJString(fields))
  add(query_580069, "quotaUser", newJString(quotaUser))
  add(path_580068, "name", newJString(name))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "callback", newJString(callback))
  add(query_580069, "access_token", newJString(accessToken))
  add(query_580069, "uploadType", newJString(uploadType))
  add(query_580069, "key", newJString(key))
  add(query_580069, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580070 = body
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  result = call_580067.call(path_580068, query_580069, nil, nil, body_580070)

var cloudtasksProjectsLocationsQueuesPurge* = Call_CloudtasksProjectsLocationsQueuesPurge_580050(
    name: "cloudtasksProjectsLocationsQueuesPurge", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta3/{name}:purge",
    validator: validate_CloudtasksProjectsLocationsQueuesPurge_580051, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesPurge_580052,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesResume_580071 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsQueuesResume_580073(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesResume_580072(path: JsonNode;
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
  var valid_580074 = path.getOrDefault("name")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "name", valid_580074
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
  var valid_580075 = query.getOrDefault("upload_protocol")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "upload_protocol", valid_580075
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
  var valid_580080 = query.getOrDefault("callback")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "callback", valid_580080
  var valid_580081 = query.getOrDefault("access_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "access_token", valid_580081
  var valid_580082 = query.getOrDefault("uploadType")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "uploadType", valid_580082
  var valid_580083 = query.getOrDefault("key")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "key", valid_580083
  var valid_580084 = query.getOrDefault("$.xgafv")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("1"))
  if valid_580084 != nil:
    section.add "$.xgafv", valid_580084
  var valid_580085 = query.getOrDefault("prettyPrint")
  valid_580085 = validateParameter(valid_580085, JBool, required = false,
                                 default = newJBool(true))
  if valid_580085 != nil:
    section.add "prettyPrint", valid_580085
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

proc call*(call_580087: Call_CloudtasksProjectsLocationsQueuesResume_580071;
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
  let valid = call_580087.validator(path, query, header, formData, body)
  let scheme = call_580087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580087.url(scheme.get, call_580087.host, call_580087.base,
                         call_580087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580087, url, valid)

proc call*(call_580088: Call_CloudtasksProjectsLocationsQueuesResume_580071;
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
  var path_580089 = newJObject()
  var query_580090 = newJObject()
  var body_580091 = newJObject()
  add(query_580090, "upload_protocol", newJString(uploadProtocol))
  add(query_580090, "fields", newJString(fields))
  add(query_580090, "quotaUser", newJString(quotaUser))
  add(path_580089, "name", newJString(name))
  add(query_580090, "alt", newJString(alt))
  add(query_580090, "oauth_token", newJString(oauthToken))
  add(query_580090, "callback", newJString(callback))
  add(query_580090, "access_token", newJString(accessToken))
  add(query_580090, "uploadType", newJString(uploadType))
  add(query_580090, "key", newJString(key))
  add(query_580090, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580091 = body
  add(query_580090, "prettyPrint", newJBool(prettyPrint))
  result = call_580088.call(path_580089, query_580090, nil, nil, body_580091)

var cloudtasksProjectsLocationsQueuesResume* = Call_CloudtasksProjectsLocationsQueuesResume_580071(
    name: "cloudtasksProjectsLocationsQueuesResume", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta3/{name}:resume",
    validator: validate_CloudtasksProjectsLocationsQueuesResume_580072, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesResume_580073,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksRun_580092 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsQueuesTasksRun_580094(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksRun_580093(path: JsonNode;
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
  var valid_580095 = path.getOrDefault("name")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "name", valid_580095
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
  var valid_580096 = query.getOrDefault("upload_protocol")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "upload_protocol", valid_580096
  var valid_580097 = query.getOrDefault("fields")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "fields", valid_580097
  var valid_580098 = query.getOrDefault("quotaUser")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "quotaUser", valid_580098
  var valid_580099 = query.getOrDefault("alt")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("json"))
  if valid_580099 != nil:
    section.add "alt", valid_580099
  var valid_580100 = query.getOrDefault("oauth_token")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "oauth_token", valid_580100
  var valid_580101 = query.getOrDefault("callback")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "callback", valid_580101
  var valid_580102 = query.getOrDefault("access_token")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "access_token", valid_580102
  var valid_580103 = query.getOrDefault("uploadType")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "uploadType", valid_580103
  var valid_580104 = query.getOrDefault("key")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "key", valid_580104
  var valid_580105 = query.getOrDefault("$.xgafv")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = newJString("1"))
  if valid_580105 != nil:
    section.add "$.xgafv", valid_580105
  var valid_580106 = query.getOrDefault("prettyPrint")
  valid_580106 = validateParameter(valid_580106, JBool, required = false,
                                 default = newJBool(true))
  if valid_580106 != nil:
    section.add "prettyPrint", valid_580106
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

proc call*(call_580108: Call_CloudtasksProjectsLocationsQueuesTasksRun_580092;
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
  let valid = call_580108.validator(path, query, header, formData, body)
  let scheme = call_580108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580108.url(scheme.get, call_580108.host, call_580108.base,
                         call_580108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580108, url, valid)

proc call*(call_580109: Call_CloudtasksProjectsLocationsQueuesTasksRun_580092;
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
  var path_580110 = newJObject()
  var query_580111 = newJObject()
  var body_580112 = newJObject()
  add(query_580111, "upload_protocol", newJString(uploadProtocol))
  add(query_580111, "fields", newJString(fields))
  add(query_580111, "quotaUser", newJString(quotaUser))
  add(path_580110, "name", newJString(name))
  add(query_580111, "alt", newJString(alt))
  add(query_580111, "oauth_token", newJString(oauthToken))
  add(query_580111, "callback", newJString(callback))
  add(query_580111, "access_token", newJString(accessToken))
  add(query_580111, "uploadType", newJString(uploadType))
  add(query_580111, "key", newJString(key))
  add(query_580111, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580112 = body
  add(query_580111, "prettyPrint", newJBool(prettyPrint))
  result = call_580109.call(path_580110, query_580111, nil, nil, body_580112)

var cloudtasksProjectsLocationsQueuesTasksRun* = Call_CloudtasksProjectsLocationsQueuesTasksRun_580092(
    name: "cloudtasksProjectsLocationsQueuesTasksRun", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta3/{name}:run",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksRun_580093,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksRun_580094,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesCreate_580135 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsQueuesCreate_580137(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/queues")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesCreate_580136(path: JsonNode;
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
  var valid_580138 = path.getOrDefault("parent")
  valid_580138 = validateParameter(valid_580138, JString, required = true,
                                 default = nil)
  if valid_580138 != nil:
    section.add "parent", valid_580138
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
  var valid_580139 = query.getOrDefault("upload_protocol")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "upload_protocol", valid_580139
  var valid_580140 = query.getOrDefault("fields")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "fields", valid_580140
  var valid_580141 = query.getOrDefault("quotaUser")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "quotaUser", valid_580141
  var valid_580142 = query.getOrDefault("alt")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = newJString("json"))
  if valid_580142 != nil:
    section.add "alt", valid_580142
  var valid_580143 = query.getOrDefault("oauth_token")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "oauth_token", valid_580143
  var valid_580144 = query.getOrDefault("callback")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "callback", valid_580144
  var valid_580145 = query.getOrDefault("access_token")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "access_token", valid_580145
  var valid_580146 = query.getOrDefault("uploadType")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "uploadType", valid_580146
  var valid_580147 = query.getOrDefault("key")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "key", valid_580147
  var valid_580148 = query.getOrDefault("$.xgafv")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = newJString("1"))
  if valid_580148 != nil:
    section.add "$.xgafv", valid_580148
  var valid_580149 = query.getOrDefault("prettyPrint")
  valid_580149 = validateParameter(valid_580149, JBool, required = false,
                                 default = newJBool(true))
  if valid_580149 != nil:
    section.add "prettyPrint", valid_580149
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

proc call*(call_580151: Call_CloudtasksProjectsLocationsQueuesCreate_580135;
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
  let valid = call_580151.validator(path, query, header, formData, body)
  let scheme = call_580151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580151.url(scheme.get, call_580151.host, call_580151.base,
                         call_580151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580151, url, valid)

proc call*(call_580152: Call_CloudtasksProjectsLocationsQueuesCreate_580135;
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
  var path_580153 = newJObject()
  var query_580154 = newJObject()
  var body_580155 = newJObject()
  add(query_580154, "upload_protocol", newJString(uploadProtocol))
  add(query_580154, "fields", newJString(fields))
  add(query_580154, "quotaUser", newJString(quotaUser))
  add(query_580154, "alt", newJString(alt))
  add(query_580154, "oauth_token", newJString(oauthToken))
  add(query_580154, "callback", newJString(callback))
  add(query_580154, "access_token", newJString(accessToken))
  add(query_580154, "uploadType", newJString(uploadType))
  add(path_580153, "parent", newJString(parent))
  add(query_580154, "key", newJString(key))
  add(query_580154, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580155 = body
  add(query_580154, "prettyPrint", newJBool(prettyPrint))
  result = call_580152.call(path_580153, query_580154, nil, nil, body_580155)

var cloudtasksProjectsLocationsQueuesCreate* = Call_CloudtasksProjectsLocationsQueuesCreate_580135(
    name: "cloudtasksProjectsLocationsQueuesCreate", meth: HttpMethod.HttpPost,
    host: "cloudtasks.googleapis.com", route: "/v2beta3/{parent}/queues",
    validator: validate_CloudtasksProjectsLocationsQueuesCreate_580136, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesCreate_580137,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesList_580113 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsQueuesList_580115(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/queues")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesList_580114(path: JsonNode;
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
  var valid_580116 = path.getOrDefault("parent")
  valid_580116 = validateParameter(valid_580116, JString, required = true,
                                 default = nil)
  if valid_580116 != nil:
    section.add "parent", valid_580116
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
  var valid_580117 = query.getOrDefault("upload_protocol")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "upload_protocol", valid_580117
  var valid_580118 = query.getOrDefault("fields")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "fields", valid_580118
  var valid_580119 = query.getOrDefault("pageToken")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "pageToken", valid_580119
  var valid_580120 = query.getOrDefault("quotaUser")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "quotaUser", valid_580120
  var valid_580121 = query.getOrDefault("alt")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("json"))
  if valid_580121 != nil:
    section.add "alt", valid_580121
  var valid_580122 = query.getOrDefault("oauth_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "oauth_token", valid_580122
  var valid_580123 = query.getOrDefault("callback")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "callback", valid_580123
  var valid_580124 = query.getOrDefault("access_token")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "access_token", valid_580124
  var valid_580125 = query.getOrDefault("uploadType")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "uploadType", valid_580125
  var valid_580126 = query.getOrDefault("key")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "key", valid_580126
  var valid_580127 = query.getOrDefault("$.xgafv")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = newJString("1"))
  if valid_580127 != nil:
    section.add "$.xgafv", valid_580127
  var valid_580128 = query.getOrDefault("pageSize")
  valid_580128 = validateParameter(valid_580128, JInt, required = false, default = nil)
  if valid_580128 != nil:
    section.add "pageSize", valid_580128
  var valid_580129 = query.getOrDefault("prettyPrint")
  valid_580129 = validateParameter(valid_580129, JBool, required = false,
                                 default = newJBool(true))
  if valid_580129 != nil:
    section.add "prettyPrint", valid_580129
  var valid_580130 = query.getOrDefault("filter")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "filter", valid_580130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580131: Call_CloudtasksProjectsLocationsQueuesList_580113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists queues.
  ## 
  ## Queues are returned in lexicographical order.
  ## 
  let valid = call_580131.validator(path, query, header, formData, body)
  let scheme = call_580131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580131.url(scheme.get, call_580131.host, call_580131.base,
                         call_580131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580131, url, valid)

proc call*(call_580132: Call_CloudtasksProjectsLocationsQueuesList_580113;
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
  var path_580133 = newJObject()
  var query_580134 = newJObject()
  add(query_580134, "upload_protocol", newJString(uploadProtocol))
  add(query_580134, "fields", newJString(fields))
  add(query_580134, "pageToken", newJString(pageToken))
  add(query_580134, "quotaUser", newJString(quotaUser))
  add(query_580134, "alt", newJString(alt))
  add(query_580134, "oauth_token", newJString(oauthToken))
  add(query_580134, "callback", newJString(callback))
  add(query_580134, "access_token", newJString(accessToken))
  add(query_580134, "uploadType", newJString(uploadType))
  add(path_580133, "parent", newJString(parent))
  add(query_580134, "key", newJString(key))
  add(query_580134, "$.xgafv", newJString(Xgafv))
  add(query_580134, "pageSize", newJInt(pageSize))
  add(query_580134, "prettyPrint", newJBool(prettyPrint))
  add(query_580134, "filter", newJString(filter))
  result = call_580132.call(path_580133, query_580134, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesList* = Call_CloudtasksProjectsLocationsQueuesList_580113(
    name: "cloudtasksProjectsLocationsQueuesList", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2beta3/{parent}/queues",
    validator: validate_CloudtasksProjectsLocationsQueuesList_580114, base: "/",
    url: url_CloudtasksProjectsLocationsQueuesList_580115, schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksCreate_580178 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsQueuesTasksCreate_580180(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksCreate_580179(path: JsonNode;
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
  var valid_580181 = path.getOrDefault("parent")
  valid_580181 = validateParameter(valid_580181, JString, required = true,
                                 default = nil)
  if valid_580181 != nil:
    section.add "parent", valid_580181
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
  var valid_580182 = query.getOrDefault("upload_protocol")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "upload_protocol", valid_580182
  var valid_580183 = query.getOrDefault("fields")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "fields", valid_580183
  var valid_580184 = query.getOrDefault("quotaUser")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "quotaUser", valid_580184
  var valid_580185 = query.getOrDefault("alt")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = newJString("json"))
  if valid_580185 != nil:
    section.add "alt", valid_580185
  var valid_580186 = query.getOrDefault("oauth_token")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "oauth_token", valid_580186
  var valid_580187 = query.getOrDefault("callback")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "callback", valid_580187
  var valid_580188 = query.getOrDefault("access_token")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "access_token", valid_580188
  var valid_580189 = query.getOrDefault("uploadType")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "uploadType", valid_580189
  var valid_580190 = query.getOrDefault("key")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "key", valid_580190
  var valid_580191 = query.getOrDefault("$.xgafv")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = newJString("1"))
  if valid_580191 != nil:
    section.add "$.xgafv", valid_580191
  var valid_580192 = query.getOrDefault("prettyPrint")
  valid_580192 = validateParameter(valid_580192, JBool, required = false,
                                 default = newJBool(true))
  if valid_580192 != nil:
    section.add "prettyPrint", valid_580192
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

proc call*(call_580194: Call_CloudtasksProjectsLocationsQueuesTasksCreate_580178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a task and adds it to a queue.
  ## 
  ## Tasks cannot be updated after creation; there is no UpdateTask command.
  ## 
  ## * The maximum task size is 100KB.
  ## 
  let valid = call_580194.validator(path, query, header, formData, body)
  let scheme = call_580194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580194.url(scheme.get, call_580194.host, call_580194.base,
                         call_580194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580194, url, valid)

proc call*(call_580195: Call_CloudtasksProjectsLocationsQueuesTasksCreate_580178;
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
  var path_580196 = newJObject()
  var query_580197 = newJObject()
  var body_580198 = newJObject()
  add(query_580197, "upload_protocol", newJString(uploadProtocol))
  add(query_580197, "fields", newJString(fields))
  add(query_580197, "quotaUser", newJString(quotaUser))
  add(query_580197, "alt", newJString(alt))
  add(query_580197, "oauth_token", newJString(oauthToken))
  add(query_580197, "callback", newJString(callback))
  add(query_580197, "access_token", newJString(accessToken))
  add(query_580197, "uploadType", newJString(uploadType))
  add(path_580196, "parent", newJString(parent))
  add(query_580197, "key", newJString(key))
  add(query_580197, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580198 = body
  add(query_580197, "prettyPrint", newJBool(prettyPrint))
  result = call_580195.call(path_580196, query_580197, nil, nil, body_580198)

var cloudtasksProjectsLocationsQueuesTasksCreate* = Call_CloudtasksProjectsLocationsQueuesTasksCreate_580178(
    name: "cloudtasksProjectsLocationsQueuesTasksCreate",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta3/{parent}/tasks",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksCreate_580179,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksCreate_580180,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTasksList_580156 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsQueuesTasksList_580158(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTasksList_580157(path: JsonNode;
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
  var valid_580159 = path.getOrDefault("parent")
  valid_580159 = validateParameter(valid_580159, JString, required = true,
                                 default = nil)
  if valid_580159 != nil:
    section.add "parent", valid_580159
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
  var valid_580160 = query.getOrDefault("upload_protocol")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "upload_protocol", valid_580160
  var valid_580161 = query.getOrDefault("fields")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "fields", valid_580161
  var valid_580162 = query.getOrDefault("pageToken")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "pageToken", valid_580162
  var valid_580163 = query.getOrDefault("quotaUser")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "quotaUser", valid_580163
  var valid_580164 = query.getOrDefault("alt")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("json"))
  if valid_580164 != nil:
    section.add "alt", valid_580164
  var valid_580165 = query.getOrDefault("oauth_token")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "oauth_token", valid_580165
  var valid_580166 = query.getOrDefault("callback")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "callback", valid_580166
  var valid_580167 = query.getOrDefault("access_token")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "access_token", valid_580167
  var valid_580168 = query.getOrDefault("uploadType")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "uploadType", valid_580168
  var valid_580169 = query.getOrDefault("key")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "key", valid_580169
  var valid_580170 = query.getOrDefault("$.xgafv")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("1"))
  if valid_580170 != nil:
    section.add "$.xgafv", valid_580170
  var valid_580171 = query.getOrDefault("pageSize")
  valid_580171 = validateParameter(valid_580171, JInt, required = false, default = nil)
  if valid_580171 != nil:
    section.add "pageSize", valid_580171
  var valid_580172 = query.getOrDefault("prettyPrint")
  valid_580172 = validateParameter(valid_580172, JBool, required = false,
                                 default = newJBool(true))
  if valid_580172 != nil:
    section.add "prettyPrint", valid_580172
  var valid_580173 = query.getOrDefault("responseView")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_580173 != nil:
    section.add "responseView", valid_580173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580174: Call_CloudtasksProjectsLocationsQueuesTasksList_580156;
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
  let valid = call_580174.validator(path, query, header, formData, body)
  let scheme = call_580174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580174.url(scheme.get, call_580174.host, call_580174.base,
                         call_580174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580174, url, valid)

proc call*(call_580175: Call_CloudtasksProjectsLocationsQueuesTasksList_580156;
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
  var path_580176 = newJObject()
  var query_580177 = newJObject()
  add(query_580177, "upload_protocol", newJString(uploadProtocol))
  add(query_580177, "fields", newJString(fields))
  add(query_580177, "pageToken", newJString(pageToken))
  add(query_580177, "quotaUser", newJString(quotaUser))
  add(query_580177, "alt", newJString(alt))
  add(query_580177, "oauth_token", newJString(oauthToken))
  add(query_580177, "callback", newJString(callback))
  add(query_580177, "access_token", newJString(accessToken))
  add(query_580177, "uploadType", newJString(uploadType))
  add(path_580176, "parent", newJString(parent))
  add(query_580177, "key", newJString(key))
  add(query_580177, "$.xgafv", newJString(Xgafv))
  add(query_580177, "pageSize", newJInt(pageSize))
  add(query_580177, "prettyPrint", newJBool(prettyPrint))
  add(query_580177, "responseView", newJString(responseView))
  result = call_580175.call(path_580176, query_580177, nil, nil, nil)

var cloudtasksProjectsLocationsQueuesTasksList* = Call_CloudtasksProjectsLocationsQueuesTasksList_580156(
    name: "cloudtasksProjectsLocationsQueuesTasksList", meth: HttpMethod.HttpGet,
    host: "cloudtasks.googleapis.com", route: "/v2beta3/{parent}/tasks",
    validator: validate_CloudtasksProjectsLocationsQueuesTasksList_580157,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTasksList_580158,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_580199 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsQueuesGetIamPolicy_580201(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesGetIamPolicy_580200(
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
  var valid_580202 = path.getOrDefault("resource")
  valid_580202 = validateParameter(valid_580202, JString, required = true,
                                 default = nil)
  if valid_580202 != nil:
    section.add "resource", valid_580202
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
  var valid_580203 = query.getOrDefault("upload_protocol")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "upload_protocol", valid_580203
  var valid_580204 = query.getOrDefault("fields")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "fields", valid_580204
  var valid_580205 = query.getOrDefault("quotaUser")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "quotaUser", valid_580205
  var valid_580206 = query.getOrDefault("alt")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = newJString("json"))
  if valid_580206 != nil:
    section.add "alt", valid_580206
  var valid_580207 = query.getOrDefault("oauth_token")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "oauth_token", valid_580207
  var valid_580208 = query.getOrDefault("callback")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "callback", valid_580208
  var valid_580209 = query.getOrDefault("access_token")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "access_token", valid_580209
  var valid_580210 = query.getOrDefault("uploadType")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "uploadType", valid_580210
  var valid_580211 = query.getOrDefault("key")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "key", valid_580211
  var valid_580212 = query.getOrDefault("$.xgafv")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = newJString("1"))
  if valid_580212 != nil:
    section.add "$.xgafv", valid_580212
  var valid_580213 = query.getOrDefault("prettyPrint")
  valid_580213 = validateParameter(valid_580213, JBool, required = false,
                                 default = newJBool(true))
  if valid_580213 != nil:
    section.add "prettyPrint", valid_580213
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

proc call*(call_580215: Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_580199;
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
  let valid = call_580215.validator(path, query, header, formData, body)
  let scheme = call_580215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580215.url(scheme.get, call_580215.host, call_580215.base,
                         call_580215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580215, url, valid)

proc call*(call_580216: Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_580199;
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
  var path_580217 = newJObject()
  var query_580218 = newJObject()
  var body_580219 = newJObject()
  add(query_580218, "upload_protocol", newJString(uploadProtocol))
  add(query_580218, "fields", newJString(fields))
  add(query_580218, "quotaUser", newJString(quotaUser))
  add(query_580218, "alt", newJString(alt))
  add(query_580218, "oauth_token", newJString(oauthToken))
  add(query_580218, "callback", newJString(callback))
  add(query_580218, "access_token", newJString(accessToken))
  add(query_580218, "uploadType", newJString(uploadType))
  add(query_580218, "key", newJString(key))
  add(query_580218, "$.xgafv", newJString(Xgafv))
  add(path_580217, "resource", newJString(resource))
  if body != nil:
    body_580219 = body
  add(query_580218, "prettyPrint", newJBool(prettyPrint))
  result = call_580216.call(path_580217, query_580218, nil, nil, body_580219)

var cloudtasksProjectsLocationsQueuesGetIamPolicy* = Call_CloudtasksProjectsLocationsQueuesGetIamPolicy_580199(
    name: "cloudtasksProjectsLocationsQueuesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta3/{resource}:getIamPolicy",
    validator: validate_CloudtasksProjectsLocationsQueuesGetIamPolicy_580200,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesGetIamPolicy_580201,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_580220 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsQueuesSetIamPolicy_580222(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesSetIamPolicy_580221(
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
  var valid_580223 = path.getOrDefault("resource")
  valid_580223 = validateParameter(valid_580223, JString, required = true,
                                 default = nil)
  if valid_580223 != nil:
    section.add "resource", valid_580223
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
  var valid_580224 = query.getOrDefault("upload_protocol")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "upload_protocol", valid_580224
  var valid_580225 = query.getOrDefault("fields")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "fields", valid_580225
  var valid_580226 = query.getOrDefault("quotaUser")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "quotaUser", valid_580226
  var valid_580227 = query.getOrDefault("alt")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = newJString("json"))
  if valid_580227 != nil:
    section.add "alt", valid_580227
  var valid_580228 = query.getOrDefault("oauth_token")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "oauth_token", valid_580228
  var valid_580229 = query.getOrDefault("callback")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "callback", valid_580229
  var valid_580230 = query.getOrDefault("access_token")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "access_token", valid_580230
  var valid_580231 = query.getOrDefault("uploadType")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "uploadType", valid_580231
  var valid_580232 = query.getOrDefault("key")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "key", valid_580232
  var valid_580233 = query.getOrDefault("$.xgafv")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = newJString("1"))
  if valid_580233 != nil:
    section.add "$.xgafv", valid_580233
  var valid_580234 = query.getOrDefault("prettyPrint")
  valid_580234 = validateParameter(valid_580234, JBool, required = false,
                                 default = newJBool(true))
  if valid_580234 != nil:
    section.add "prettyPrint", valid_580234
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

proc call*(call_580236: Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_580220;
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
  let valid = call_580236.validator(path, query, header, formData, body)
  let scheme = call_580236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580236.url(scheme.get, call_580236.host, call_580236.base,
                         call_580236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580236, url, valid)

proc call*(call_580237: Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_580220;
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
  var path_580238 = newJObject()
  var query_580239 = newJObject()
  var body_580240 = newJObject()
  add(query_580239, "upload_protocol", newJString(uploadProtocol))
  add(query_580239, "fields", newJString(fields))
  add(query_580239, "quotaUser", newJString(quotaUser))
  add(query_580239, "alt", newJString(alt))
  add(query_580239, "oauth_token", newJString(oauthToken))
  add(query_580239, "callback", newJString(callback))
  add(query_580239, "access_token", newJString(accessToken))
  add(query_580239, "uploadType", newJString(uploadType))
  add(query_580239, "key", newJString(key))
  add(query_580239, "$.xgafv", newJString(Xgafv))
  add(path_580238, "resource", newJString(resource))
  if body != nil:
    body_580240 = body
  add(query_580239, "prettyPrint", newJBool(prettyPrint))
  result = call_580237.call(path_580238, query_580239, nil, nil, body_580240)

var cloudtasksProjectsLocationsQueuesSetIamPolicy* = Call_CloudtasksProjectsLocationsQueuesSetIamPolicy_580220(
    name: "cloudtasksProjectsLocationsQueuesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta3/{resource}:setIamPolicy",
    validator: validate_CloudtasksProjectsLocationsQueuesSetIamPolicy_580221,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesSetIamPolicy_580222,
    schemes: {Scheme.Https})
type
  Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_580241 = ref object of OpenApiRestCall_579408
proc url_CloudtasksProjectsLocationsQueuesTestIamPermissions_580243(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta3/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtasksProjectsLocationsQueuesTestIamPermissions_580242(
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
  var valid_580244 = path.getOrDefault("resource")
  valid_580244 = validateParameter(valid_580244, JString, required = true,
                                 default = nil)
  if valid_580244 != nil:
    section.add "resource", valid_580244
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
  var valid_580245 = query.getOrDefault("upload_protocol")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "upload_protocol", valid_580245
  var valid_580246 = query.getOrDefault("fields")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "fields", valid_580246
  var valid_580247 = query.getOrDefault("quotaUser")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "quotaUser", valid_580247
  var valid_580248 = query.getOrDefault("alt")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = newJString("json"))
  if valid_580248 != nil:
    section.add "alt", valid_580248
  var valid_580249 = query.getOrDefault("oauth_token")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "oauth_token", valid_580249
  var valid_580250 = query.getOrDefault("callback")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "callback", valid_580250
  var valid_580251 = query.getOrDefault("access_token")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "access_token", valid_580251
  var valid_580252 = query.getOrDefault("uploadType")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "uploadType", valid_580252
  var valid_580253 = query.getOrDefault("key")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "key", valid_580253
  var valid_580254 = query.getOrDefault("$.xgafv")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = newJString("1"))
  if valid_580254 != nil:
    section.add "$.xgafv", valid_580254
  var valid_580255 = query.getOrDefault("prettyPrint")
  valid_580255 = validateParameter(valid_580255, JBool, required = false,
                                 default = newJBool(true))
  if valid_580255 != nil:
    section.add "prettyPrint", valid_580255
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

proc call*(call_580257: Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_580241;
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
  let valid = call_580257.validator(path, query, header, formData, body)
  let scheme = call_580257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580257.url(scheme.get, call_580257.host, call_580257.base,
                         call_580257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580257, url, valid)

proc call*(call_580258: Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_580241;
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
  var path_580259 = newJObject()
  var query_580260 = newJObject()
  var body_580261 = newJObject()
  add(query_580260, "upload_protocol", newJString(uploadProtocol))
  add(query_580260, "fields", newJString(fields))
  add(query_580260, "quotaUser", newJString(quotaUser))
  add(query_580260, "alt", newJString(alt))
  add(query_580260, "oauth_token", newJString(oauthToken))
  add(query_580260, "callback", newJString(callback))
  add(query_580260, "access_token", newJString(accessToken))
  add(query_580260, "uploadType", newJString(uploadType))
  add(query_580260, "key", newJString(key))
  add(query_580260, "$.xgafv", newJString(Xgafv))
  add(path_580259, "resource", newJString(resource))
  if body != nil:
    body_580261 = body
  add(query_580260, "prettyPrint", newJBool(prettyPrint))
  result = call_580258.call(path_580259, query_580260, nil, nil, body_580261)

var cloudtasksProjectsLocationsQueuesTestIamPermissions* = Call_CloudtasksProjectsLocationsQueuesTestIamPermissions_580241(
    name: "cloudtasksProjectsLocationsQueuesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudtasks.googleapis.com",
    route: "/v2beta3/{resource}:testIamPermissions",
    validator: validate_CloudtasksProjectsLocationsQueuesTestIamPermissions_580242,
    base: "/", url: url_CloudtasksProjectsLocationsQueuesTestIamPermissions_580243,
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
