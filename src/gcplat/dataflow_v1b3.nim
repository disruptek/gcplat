
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Dataflow
## version: v1b3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages Google Cloud Dataflow projects on Google Cloud Platform.
## 
## https://cloud.google.com/dataflow
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  gcpServiceName = "dataflow"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DataflowProjectsWorkerMessages_578619 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsWorkerMessages_578621(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/WorkerMessages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsWorkerMessages_578620(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Send a worker_message to the service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project to send the WorkerMessages to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578747 = path.getOrDefault("projectId")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "projectId", valid_578747
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
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("prettyPrint")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "prettyPrint", valid_578762
  var valid_578763 = query.getOrDefault("oauth_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "oauth_token", valid_578763
  var valid_578764 = query.getOrDefault("$.xgafv")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = newJString("1"))
  if valid_578764 != nil:
    section.add "$.xgafv", valid_578764
  var valid_578765 = query.getOrDefault("alt")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("json"))
  if valid_578765 != nil:
    section.add "alt", valid_578765
  var valid_578766 = query.getOrDefault("uploadType")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "uploadType", valid_578766
  var valid_578767 = query.getOrDefault("quotaUser")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "quotaUser", valid_578767
  var valid_578768 = query.getOrDefault("callback")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "callback", valid_578768
  var valid_578769 = query.getOrDefault("fields")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "fields", valid_578769
  var valid_578770 = query.getOrDefault("access_token")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "access_token", valid_578770
  var valid_578771 = query.getOrDefault("upload_protocol")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "upload_protocol", valid_578771
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

proc call*(call_578795: Call_DataflowProjectsWorkerMessages_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send a worker_message to the service.
  ## 
  let valid = call_578795.validator(path, query, header, formData, body)
  let scheme = call_578795.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578795.url(scheme.get, call_578795.host, call_578795.base,
                         call_578795.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578795, url, valid)

proc call*(call_578866: Call_DataflowProjectsWorkerMessages_578619;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsWorkerMessages
  ## Send a worker_message to the service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The project to send the WorkerMessages to.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578867 = newJObject()
  var query_578869 = newJObject()
  var body_578870 = newJObject()
  add(query_578869, "key", newJString(key))
  add(query_578869, "prettyPrint", newJBool(prettyPrint))
  add(query_578869, "oauth_token", newJString(oauthToken))
  add(path_578867, "projectId", newJString(projectId))
  add(query_578869, "$.xgafv", newJString(Xgafv))
  add(query_578869, "alt", newJString(alt))
  add(query_578869, "uploadType", newJString(uploadType))
  add(query_578869, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578870 = body
  add(query_578869, "callback", newJString(callback))
  add(query_578869, "fields", newJString(fields))
  add(query_578869, "access_token", newJString(accessToken))
  add(query_578869, "upload_protocol", newJString(uploadProtocol))
  result = call_578866.call(path_578867, query_578869, nil, nil, body_578870)

var dataflowProjectsWorkerMessages* = Call_DataflowProjectsWorkerMessages_578619(
    name: "dataflowProjectsWorkerMessages", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/WorkerMessages",
    validator: validate_DataflowProjectsWorkerMessages_578620, base: "/",
    url: url_DataflowProjectsWorkerMessages_578621, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsCreate_578933 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsJobsCreate_578935(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsJobsCreate_578934(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Cloud Dataflow job.
  ## 
  ## To create a job, we recommend using `projects.locations.jobs.create` with a
  ## [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.create` is not recommended, as your job will always start
  ## in `us-central1`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578936 = path.getOrDefault("projectId")
  valid_578936 = validateParameter(valid_578936, JString, required = true,
                                 default = nil)
  if valid_578936 != nil:
    section.add "projectId", valid_578936
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
  ##   replaceJobId: JString
  ##               : Deprecated. This field is now in the Job message.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : The level of information requested in response.
  section = newJObject()
  var valid_578937 = query.getOrDefault("key")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "key", valid_578937
  var valid_578938 = query.getOrDefault("prettyPrint")
  valid_578938 = validateParameter(valid_578938, JBool, required = false,
                                 default = newJBool(true))
  if valid_578938 != nil:
    section.add "prettyPrint", valid_578938
  var valid_578939 = query.getOrDefault("oauth_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "oauth_token", valid_578939
  var valid_578940 = query.getOrDefault("$.xgafv")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = newJString("1"))
  if valid_578940 != nil:
    section.add "$.xgafv", valid_578940
  var valid_578941 = query.getOrDefault("replaceJobId")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "replaceJobId", valid_578941
  var valid_578942 = query.getOrDefault("alt")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = newJString("json"))
  if valid_578942 != nil:
    section.add "alt", valid_578942
  var valid_578943 = query.getOrDefault("uploadType")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "uploadType", valid_578943
  var valid_578944 = query.getOrDefault("quotaUser")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "quotaUser", valid_578944
  var valid_578945 = query.getOrDefault("location")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "location", valid_578945
  var valid_578946 = query.getOrDefault("callback")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "callback", valid_578946
  var valid_578947 = query.getOrDefault("fields")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "fields", valid_578947
  var valid_578948 = query.getOrDefault("access_token")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "access_token", valid_578948
  var valid_578949 = query.getOrDefault("upload_protocol")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "upload_protocol", valid_578949
  var valid_578950 = query.getOrDefault("view")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_578950 != nil:
    section.add "view", valid_578950
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

proc call*(call_578952: Call_DataflowProjectsJobsCreate_578933; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job.
  ## 
  ## To create a job, we recommend using `projects.locations.jobs.create` with a
  ## [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.create` is not recommended, as your job will always start
  ## in `us-central1`.
  ## 
  let valid = call_578952.validator(path, query, header, formData, body)
  let scheme = call_578952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578952.url(scheme.get, call_578952.host, call_578952.base,
                         call_578952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578952, url, valid)

proc call*(call_578953: Call_DataflowProjectsJobsCreate_578933; projectId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; replaceJobId: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; location: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          view: string = "JOB_VIEW_UNKNOWN"): Recallable =
  ## dataflowProjectsJobsCreate
  ## Creates a Cloud Dataflow job.
  ## 
  ## To create a job, we recommend using `projects.locations.jobs.create` with a
  ## [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.create` is not recommended, as your job will always start
  ## in `us-central1`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   replaceJobId: string
  ##               : Deprecated. This field is now in the Job message.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : The level of information requested in response.
  var path_578954 = newJObject()
  var query_578955 = newJObject()
  var body_578956 = newJObject()
  add(query_578955, "key", newJString(key))
  add(query_578955, "prettyPrint", newJBool(prettyPrint))
  add(query_578955, "oauth_token", newJString(oauthToken))
  add(path_578954, "projectId", newJString(projectId))
  add(query_578955, "$.xgafv", newJString(Xgafv))
  add(query_578955, "replaceJobId", newJString(replaceJobId))
  add(query_578955, "alt", newJString(alt))
  add(query_578955, "uploadType", newJString(uploadType))
  add(query_578955, "quotaUser", newJString(quotaUser))
  add(query_578955, "location", newJString(location))
  if body != nil:
    body_578956 = body
  add(query_578955, "callback", newJString(callback))
  add(query_578955, "fields", newJString(fields))
  add(query_578955, "access_token", newJString(accessToken))
  add(query_578955, "upload_protocol", newJString(uploadProtocol))
  add(query_578955, "view", newJString(view))
  result = call_578953.call(path_578954, query_578955, nil, nil, body_578956)

var dataflowProjectsJobsCreate* = Call_DataflowProjectsJobsCreate_578933(
    name: "dataflowProjectsJobsCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/jobs",
    validator: validate_DataflowProjectsJobsCreate_578934, base: "/",
    url: url_DataflowProjectsJobsCreate_578935, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsList_578909 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsJobsList_578911(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsJobsList_578910(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the jobs of a project.
  ## 
  ## To list the jobs of a project in a region, we recommend using
  ## `projects.locations.jobs.get` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). To
  ## list the all jobs across all regions, use `projects.jobs.aggregated`. Using
  ## `projects.jobs.list` is not recommended, as you can only get the list of
  ## jobs that are running in `us-central1`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project which owns the jobs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578912 = path.getOrDefault("projectId")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "projectId", valid_578912
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
  ##           : If there are many jobs, limit response to at most this many.
  ## The actual number of jobs returned will be the lesser of max_responses
  ## and an unspecified server-defined limit.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The kind of filter to use.
  ##   pageToken: JString
  ##            : Set this to the 'next_page_token' field of a previous response
  ## to request additional results in a long list.
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : Level of information requested in response. Default is `JOB_VIEW_SUMMARY`.
  section = newJObject()
  var valid_578913 = query.getOrDefault("key")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "key", valid_578913
  var valid_578914 = query.getOrDefault("prettyPrint")
  valid_578914 = validateParameter(valid_578914, JBool, required = false,
                                 default = newJBool(true))
  if valid_578914 != nil:
    section.add "prettyPrint", valid_578914
  var valid_578915 = query.getOrDefault("oauth_token")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "oauth_token", valid_578915
  var valid_578916 = query.getOrDefault("$.xgafv")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = newJString("1"))
  if valid_578916 != nil:
    section.add "$.xgafv", valid_578916
  var valid_578917 = query.getOrDefault("pageSize")
  valid_578917 = validateParameter(valid_578917, JInt, required = false, default = nil)
  if valid_578917 != nil:
    section.add "pageSize", valid_578917
  var valid_578918 = query.getOrDefault("alt")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = newJString("json"))
  if valid_578918 != nil:
    section.add "alt", valid_578918
  var valid_578919 = query.getOrDefault("uploadType")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "uploadType", valid_578919
  var valid_578920 = query.getOrDefault("quotaUser")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "quotaUser", valid_578920
  var valid_578921 = query.getOrDefault("filter")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_578921 != nil:
    section.add "filter", valid_578921
  var valid_578922 = query.getOrDefault("pageToken")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "pageToken", valid_578922
  var valid_578923 = query.getOrDefault("location")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "location", valid_578923
  var valid_578924 = query.getOrDefault("callback")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "callback", valid_578924
  var valid_578925 = query.getOrDefault("fields")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "fields", valid_578925
  var valid_578926 = query.getOrDefault("access_token")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "access_token", valid_578926
  var valid_578927 = query.getOrDefault("upload_protocol")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "upload_protocol", valid_578927
  var valid_578928 = query.getOrDefault("view")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_578928 != nil:
    section.add "view", valid_578928
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578929: Call_DataflowProjectsJobsList_578909; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the jobs of a project.
  ## 
  ## To list the jobs of a project in a region, we recommend using
  ## `projects.locations.jobs.get` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). To
  ## list the all jobs across all regions, use `projects.jobs.aggregated`. Using
  ## `projects.jobs.list` is not recommended, as you can only get the list of
  ## jobs that are running in `us-central1`.
  ## 
  let valid = call_578929.validator(path, query, header, formData, body)
  let scheme = call_578929.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578929.url(scheme.get, call_578929.host, call_578929.base,
                         call_578929.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578929, url, valid)

proc call*(call_578930: Call_DataflowProjectsJobsList_578909; projectId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "UNKNOWN";
          pageToken: string = ""; location: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          view: string = "JOB_VIEW_UNKNOWN"): Recallable =
  ## dataflowProjectsJobsList
  ## List the jobs of a project.
  ## 
  ## To list the jobs of a project in a region, we recommend using
  ## `projects.locations.jobs.get` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). To
  ## list the all jobs across all regions, use `projects.jobs.aggregated`. Using
  ## `projects.jobs.list` is not recommended, as you can only get the list of
  ## jobs that are running in `us-central1`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The project which owns the jobs.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : If there are many jobs, limit response to at most this many.
  ## The actual number of jobs returned will be the lesser of max_responses
  ## and an unspecified server-defined limit.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The kind of filter to use.
  ##   pageToken: string
  ##            : Set this to the 'next_page_token' field of a previous response
  ## to request additional results in a long list.
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Level of information requested in response. Default is `JOB_VIEW_SUMMARY`.
  var path_578931 = newJObject()
  var query_578932 = newJObject()
  add(query_578932, "key", newJString(key))
  add(query_578932, "prettyPrint", newJBool(prettyPrint))
  add(query_578932, "oauth_token", newJString(oauthToken))
  add(path_578931, "projectId", newJString(projectId))
  add(query_578932, "$.xgafv", newJString(Xgafv))
  add(query_578932, "pageSize", newJInt(pageSize))
  add(query_578932, "alt", newJString(alt))
  add(query_578932, "uploadType", newJString(uploadType))
  add(query_578932, "quotaUser", newJString(quotaUser))
  add(query_578932, "filter", newJString(filter))
  add(query_578932, "pageToken", newJString(pageToken))
  add(query_578932, "location", newJString(location))
  add(query_578932, "callback", newJString(callback))
  add(query_578932, "fields", newJString(fields))
  add(query_578932, "access_token", newJString(accessToken))
  add(query_578932, "upload_protocol", newJString(uploadProtocol))
  add(query_578932, "view", newJString(view))
  result = call_578930.call(path_578931, query_578932, nil, nil, nil)

var dataflowProjectsJobsList* = Call_DataflowProjectsJobsList_578909(
    name: "dataflowProjectsJobsList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/jobs",
    validator: validate_DataflowProjectsJobsList_578910, base: "/",
    url: url_DataflowProjectsJobsList_578911, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsUpdate_578979 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsJobsUpdate_578981(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsJobsUpdate_578980(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the state of an existing Cloud Dataflow job.
  ## 
  ## To update the state of an existing job, we recommend using
  ## `projects.locations.jobs.update` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.update` is not recommended, as you can only update the state
  ## of jobs that are running in `us-central1`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : The job ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578982 = path.getOrDefault("projectId")
  valid_578982 = validateParameter(valid_578982, JString, required = true,
                                 default = nil)
  if valid_578982 != nil:
    section.add "projectId", valid_578982
  var valid_578983 = path.getOrDefault("jobId")
  valid_578983 = validateParameter(valid_578983, JString, required = true,
                                 default = nil)
  if valid_578983 != nil:
    section.add "jobId", valid_578983
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
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578984 = query.getOrDefault("key")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "key", valid_578984
  var valid_578985 = query.getOrDefault("prettyPrint")
  valid_578985 = validateParameter(valid_578985, JBool, required = false,
                                 default = newJBool(true))
  if valid_578985 != nil:
    section.add "prettyPrint", valid_578985
  var valid_578986 = query.getOrDefault("oauth_token")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "oauth_token", valid_578986
  var valid_578987 = query.getOrDefault("$.xgafv")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = newJString("1"))
  if valid_578987 != nil:
    section.add "$.xgafv", valid_578987
  var valid_578988 = query.getOrDefault("alt")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("json"))
  if valid_578988 != nil:
    section.add "alt", valid_578988
  var valid_578989 = query.getOrDefault("uploadType")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "uploadType", valid_578989
  var valid_578990 = query.getOrDefault("quotaUser")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "quotaUser", valid_578990
  var valid_578991 = query.getOrDefault("location")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "location", valid_578991
  var valid_578992 = query.getOrDefault("callback")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "callback", valid_578992
  var valid_578993 = query.getOrDefault("fields")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "fields", valid_578993
  var valid_578994 = query.getOrDefault("access_token")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "access_token", valid_578994
  var valid_578995 = query.getOrDefault("upload_protocol")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "upload_protocol", valid_578995
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

proc call*(call_578997: Call_DataflowProjectsJobsUpdate_578979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the state of an existing Cloud Dataflow job.
  ## 
  ## To update the state of an existing job, we recommend using
  ## `projects.locations.jobs.update` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.update` is not recommended, as you can only update the state
  ## of jobs that are running in `us-central1`.
  ## 
  let valid = call_578997.validator(path, query, header, formData, body)
  let scheme = call_578997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578997.url(scheme.get, call_578997.host, call_578997.base,
                         call_578997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578997, url, valid)

proc call*(call_578998: Call_DataflowProjectsJobsUpdate_578979; projectId: string;
          jobId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; location: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsJobsUpdate
  ## Updates the state of an existing Cloud Dataflow job.
  ## 
  ## To update the state of an existing job, we recommend using
  ## `projects.locations.jobs.update` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.update` is not recommended, as you can only update the state
  ## of jobs that are running in `us-central1`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   jobId: string (required)
  ##        : The job ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578999 = newJObject()
  var query_579000 = newJObject()
  var body_579001 = newJObject()
  add(query_579000, "key", newJString(key))
  add(query_579000, "prettyPrint", newJBool(prettyPrint))
  add(query_579000, "oauth_token", newJString(oauthToken))
  add(path_578999, "projectId", newJString(projectId))
  add(path_578999, "jobId", newJString(jobId))
  add(query_579000, "$.xgafv", newJString(Xgafv))
  add(query_579000, "alt", newJString(alt))
  add(query_579000, "uploadType", newJString(uploadType))
  add(query_579000, "quotaUser", newJString(quotaUser))
  add(query_579000, "location", newJString(location))
  if body != nil:
    body_579001 = body
  add(query_579000, "callback", newJString(callback))
  add(query_579000, "fields", newJString(fields))
  add(query_579000, "access_token", newJString(accessToken))
  add(query_579000, "upload_protocol", newJString(uploadProtocol))
  result = call_578998.call(path_578999, query_579000, nil, nil, body_579001)

var dataflowProjectsJobsUpdate* = Call_DataflowProjectsJobsUpdate_578979(
    name: "dataflowProjectsJobsUpdate", meth: HttpMethod.HttpPut,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataflowProjectsJobsUpdate_578980, base: "/",
    url: url_DataflowProjectsJobsUpdate_578981, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsGet_578957 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsJobsGet_578959(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsJobsGet_578958(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the state of the specified Cloud Dataflow job.
  ## 
  ## To get the state of a job, we recommend using `projects.locations.jobs.get`
  ## with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.get` is not recommended, as you can only get the state of
  ## jobs that are running in `us-central1`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : The job ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578960 = path.getOrDefault("projectId")
  valid_578960 = validateParameter(valid_578960, JString, required = true,
                                 default = nil)
  if valid_578960 != nil:
    section.add "projectId", valid_578960
  var valid_578961 = path.getOrDefault("jobId")
  valid_578961 = validateParameter(valid_578961, JString, required = true,
                                 default = nil)
  if valid_578961 != nil:
    section.add "jobId", valid_578961
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
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : The level of information requested in response.
  section = newJObject()
  var valid_578962 = query.getOrDefault("key")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "key", valid_578962
  var valid_578963 = query.getOrDefault("prettyPrint")
  valid_578963 = validateParameter(valid_578963, JBool, required = false,
                                 default = newJBool(true))
  if valid_578963 != nil:
    section.add "prettyPrint", valid_578963
  var valid_578964 = query.getOrDefault("oauth_token")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "oauth_token", valid_578964
  var valid_578965 = query.getOrDefault("$.xgafv")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("1"))
  if valid_578965 != nil:
    section.add "$.xgafv", valid_578965
  var valid_578966 = query.getOrDefault("alt")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = newJString("json"))
  if valid_578966 != nil:
    section.add "alt", valid_578966
  var valid_578967 = query.getOrDefault("uploadType")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "uploadType", valid_578967
  var valid_578968 = query.getOrDefault("quotaUser")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "quotaUser", valid_578968
  var valid_578969 = query.getOrDefault("location")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "location", valid_578969
  var valid_578970 = query.getOrDefault("callback")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "callback", valid_578970
  var valid_578971 = query.getOrDefault("fields")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "fields", valid_578971
  var valid_578972 = query.getOrDefault("access_token")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "access_token", valid_578972
  var valid_578973 = query.getOrDefault("upload_protocol")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "upload_protocol", valid_578973
  var valid_578974 = query.getOrDefault("view")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_578974 != nil:
    section.add "view", valid_578974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578975: Call_DataflowProjectsJobsGet_578957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the state of the specified Cloud Dataflow job.
  ## 
  ## To get the state of a job, we recommend using `projects.locations.jobs.get`
  ## with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.get` is not recommended, as you can only get the state of
  ## jobs that are running in `us-central1`.
  ## 
  let valid = call_578975.validator(path, query, header, formData, body)
  let scheme = call_578975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578975.url(scheme.get, call_578975.host, call_578975.base,
                         call_578975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578975, url, valid)

proc call*(call_578976: Call_DataflowProjectsJobsGet_578957; projectId: string;
          jobId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; location: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; view: string = "JOB_VIEW_UNKNOWN"): Recallable =
  ## dataflowProjectsJobsGet
  ## Gets the state of the specified Cloud Dataflow job.
  ## 
  ## To get the state of a job, we recommend using `projects.locations.jobs.get`
  ## with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.get` is not recommended, as you can only get the state of
  ## jobs that are running in `us-central1`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   jobId: string (required)
  ##        : The job ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : The level of information requested in response.
  var path_578977 = newJObject()
  var query_578978 = newJObject()
  add(query_578978, "key", newJString(key))
  add(query_578978, "prettyPrint", newJBool(prettyPrint))
  add(query_578978, "oauth_token", newJString(oauthToken))
  add(path_578977, "projectId", newJString(projectId))
  add(path_578977, "jobId", newJString(jobId))
  add(query_578978, "$.xgafv", newJString(Xgafv))
  add(query_578978, "alt", newJString(alt))
  add(query_578978, "uploadType", newJString(uploadType))
  add(query_578978, "quotaUser", newJString(quotaUser))
  add(query_578978, "location", newJString(location))
  add(query_578978, "callback", newJString(callback))
  add(query_578978, "fields", newJString(fields))
  add(query_578978, "access_token", newJString(accessToken))
  add(query_578978, "upload_protocol", newJString(uploadProtocol))
  add(query_578978, "view", newJString(view))
  result = call_578976.call(path_578977, query_578978, nil, nil, nil)

var dataflowProjectsJobsGet* = Call_DataflowProjectsJobsGet_578957(
    name: "dataflowProjectsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataflowProjectsJobsGet_578958, base: "/",
    url: url_DataflowProjectsJobsGet_578959, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsDebugGetConfig_579002 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsJobsDebugGetConfig_579004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/debug/getConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsJobsDebugGetConfig_579003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get encoded debug configuration for component. Not cacheable.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project id.
  ##   jobId: JString (required)
  ##        : The job id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579005 = path.getOrDefault("projectId")
  valid_579005 = validateParameter(valid_579005, JString, required = true,
                                 default = nil)
  if valid_579005 != nil:
    section.add "projectId", valid_579005
  var valid_579006 = path.getOrDefault("jobId")
  valid_579006 = validateParameter(valid_579006, JString, required = true,
                                 default = nil)
  if valid_579006 != nil:
    section.add "jobId", valid_579006
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
  var valid_579007 = query.getOrDefault("key")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "key", valid_579007
  var valid_579008 = query.getOrDefault("prettyPrint")
  valid_579008 = validateParameter(valid_579008, JBool, required = false,
                                 default = newJBool(true))
  if valid_579008 != nil:
    section.add "prettyPrint", valid_579008
  var valid_579009 = query.getOrDefault("oauth_token")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "oauth_token", valid_579009
  var valid_579010 = query.getOrDefault("$.xgafv")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = newJString("1"))
  if valid_579010 != nil:
    section.add "$.xgafv", valid_579010
  var valid_579011 = query.getOrDefault("alt")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = newJString("json"))
  if valid_579011 != nil:
    section.add "alt", valid_579011
  var valid_579012 = query.getOrDefault("uploadType")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "uploadType", valid_579012
  var valid_579013 = query.getOrDefault("quotaUser")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "quotaUser", valid_579013
  var valid_579014 = query.getOrDefault("callback")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "callback", valid_579014
  var valid_579015 = query.getOrDefault("fields")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "fields", valid_579015
  var valid_579016 = query.getOrDefault("access_token")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "access_token", valid_579016
  var valid_579017 = query.getOrDefault("upload_protocol")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "upload_protocol", valid_579017
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

proc call*(call_579019: Call_DataflowProjectsJobsDebugGetConfig_579002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get encoded debug configuration for component. Not cacheable.
  ## 
  let valid = call_579019.validator(path, query, header, formData, body)
  let scheme = call_579019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579019.url(scheme.get, call_579019.host, call_579019.base,
                         call_579019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579019, url, valid)

proc call*(call_579020: Call_DataflowProjectsJobsDebugGetConfig_579002;
          projectId: string; jobId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsJobsDebugGetConfig
  ## Get encoded debug configuration for component. Not cacheable.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The project id.
  ##   jobId: string (required)
  ##        : The job id.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579021 = newJObject()
  var query_579022 = newJObject()
  var body_579023 = newJObject()
  add(query_579022, "key", newJString(key))
  add(query_579022, "prettyPrint", newJBool(prettyPrint))
  add(query_579022, "oauth_token", newJString(oauthToken))
  add(path_579021, "projectId", newJString(projectId))
  add(path_579021, "jobId", newJString(jobId))
  add(query_579022, "$.xgafv", newJString(Xgafv))
  add(query_579022, "alt", newJString(alt))
  add(query_579022, "uploadType", newJString(uploadType))
  add(query_579022, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579023 = body
  add(query_579022, "callback", newJString(callback))
  add(query_579022, "fields", newJString(fields))
  add(query_579022, "access_token", newJString(accessToken))
  add(query_579022, "upload_protocol", newJString(uploadProtocol))
  result = call_579020.call(path_579021, query_579022, nil, nil, body_579023)

var dataflowProjectsJobsDebugGetConfig* = Call_DataflowProjectsJobsDebugGetConfig_579002(
    name: "dataflowProjectsJobsDebugGetConfig", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/debug/getConfig",
    validator: validate_DataflowProjectsJobsDebugGetConfig_579003, base: "/",
    url: url_DataflowProjectsJobsDebugGetConfig_579004, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsDebugSendCapture_579024 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsJobsDebugSendCapture_579026(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/debug/sendCapture")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsJobsDebugSendCapture_579025(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Send encoded debug capture data for component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project id.
  ##   jobId: JString (required)
  ##        : The job id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579027 = path.getOrDefault("projectId")
  valid_579027 = validateParameter(valid_579027, JString, required = true,
                                 default = nil)
  if valid_579027 != nil:
    section.add "projectId", valid_579027
  var valid_579028 = path.getOrDefault("jobId")
  valid_579028 = validateParameter(valid_579028, JString, required = true,
                                 default = nil)
  if valid_579028 != nil:
    section.add "jobId", valid_579028
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

proc call*(call_579041: Call_DataflowProjectsJobsDebugSendCapture_579024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send encoded debug capture data for component.
  ## 
  let valid = call_579041.validator(path, query, header, formData, body)
  let scheme = call_579041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579041.url(scheme.get, call_579041.host, call_579041.base,
                         call_579041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579041, url, valid)

proc call*(call_579042: Call_DataflowProjectsJobsDebugSendCapture_579024;
          projectId: string; jobId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsJobsDebugSendCapture
  ## Send encoded debug capture data for component.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The project id.
  ##   jobId: string (required)
  ##        : The job id.
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
  add(path_579043, "projectId", newJString(projectId))
  add(path_579043, "jobId", newJString(jobId))
  add(query_579044, "$.xgafv", newJString(Xgafv))
  add(query_579044, "alt", newJString(alt))
  add(query_579044, "uploadType", newJString(uploadType))
  add(query_579044, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579045 = body
  add(query_579044, "callback", newJString(callback))
  add(query_579044, "fields", newJString(fields))
  add(query_579044, "access_token", newJString(accessToken))
  add(query_579044, "upload_protocol", newJString(uploadProtocol))
  result = call_579042.call(path_579043, query_579044, nil, nil, body_579045)

var dataflowProjectsJobsDebugSendCapture* = Call_DataflowProjectsJobsDebugSendCapture_579024(
    name: "dataflowProjectsJobsDebugSendCapture", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/debug/sendCapture",
    validator: validate_DataflowProjectsJobsDebugSendCapture_579025, base: "/",
    url: url_DataflowProjectsJobsDebugSendCapture_579026, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsMessagesList_579046 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsJobsMessagesList_579048(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsJobsMessagesList_579047(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.messages.list` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.messages.list` is not recommended, as you can only request
  ## the status of jobs that are running in `us-central1`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A project id.
  ##   jobId: JString (required)
  ##        : The job to get messages about.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579049 = path.getOrDefault("projectId")
  valid_579049 = validateParameter(valid_579049, JString, required = true,
                                 default = nil)
  if valid_579049 != nil:
    section.add "projectId", valid_579049
  var valid_579050 = path.getOrDefault("jobId")
  valid_579050 = validateParameter(valid_579050, JString, required = true,
                                 default = nil)
  if valid_579050 != nil:
    section.add "jobId", valid_579050
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   minimumImportance: JString
  ##                    : Filter to only get messages with importance >= level
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : If specified, determines the maximum number of messages to
  ## return.  If unspecified, the service may choose an appropriate
  ## default, or may return an arbitrarily large number of results.
  ##   startTime: JString
  ##            : If specified, return only messages with timestamps >= start_time.
  ## The default is the job creation time (i.e. beginning of messages).
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : If supplied, this should be the value of next_page_token returned
  ## by an earlier call. This will cause the next page of results to
  ## be returned.
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   endTime: JString
  ##          : Return only messages with timestamps < end_time. The default is now
  ## (i.e. return up to the latest messages available).
  section = newJObject()
  var valid_579051 = query.getOrDefault("key")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "key", valid_579051
  var valid_579052 = query.getOrDefault("prettyPrint")
  valid_579052 = validateParameter(valid_579052, JBool, required = false,
                                 default = newJBool(true))
  if valid_579052 != nil:
    section.add "prettyPrint", valid_579052
  var valid_579053 = query.getOrDefault("oauth_token")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "oauth_token", valid_579053
  var valid_579054 = query.getOrDefault("minimumImportance")
  valid_579054 = validateParameter(valid_579054, JString, required = false, default = newJString(
      "JOB_MESSAGE_IMPORTANCE_UNKNOWN"))
  if valid_579054 != nil:
    section.add "minimumImportance", valid_579054
  var valid_579055 = query.getOrDefault("$.xgafv")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = newJString("1"))
  if valid_579055 != nil:
    section.add "$.xgafv", valid_579055
  var valid_579056 = query.getOrDefault("pageSize")
  valid_579056 = validateParameter(valid_579056, JInt, required = false, default = nil)
  if valid_579056 != nil:
    section.add "pageSize", valid_579056
  var valid_579057 = query.getOrDefault("startTime")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "startTime", valid_579057
  var valid_579058 = query.getOrDefault("alt")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = newJString("json"))
  if valid_579058 != nil:
    section.add "alt", valid_579058
  var valid_579059 = query.getOrDefault("uploadType")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "uploadType", valid_579059
  var valid_579060 = query.getOrDefault("quotaUser")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "quotaUser", valid_579060
  var valid_579061 = query.getOrDefault("pageToken")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "pageToken", valid_579061
  var valid_579062 = query.getOrDefault("location")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "location", valid_579062
  var valid_579063 = query.getOrDefault("callback")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "callback", valid_579063
  var valid_579064 = query.getOrDefault("fields")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "fields", valid_579064
  var valid_579065 = query.getOrDefault("access_token")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "access_token", valid_579065
  var valid_579066 = query.getOrDefault("upload_protocol")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "upload_protocol", valid_579066
  var valid_579067 = query.getOrDefault("endTime")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "endTime", valid_579067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579068: Call_DataflowProjectsJobsMessagesList_579046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.messages.list` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.messages.list` is not recommended, as you can only request
  ## the status of jobs that are running in `us-central1`.
  ## 
  let valid = call_579068.validator(path, query, header, formData, body)
  let scheme = call_579068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579068.url(scheme.get, call_579068.host, call_579068.base,
                         call_579068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579068, url, valid)

proc call*(call_579069: Call_DataflowProjectsJobsMessagesList_579046;
          projectId: string; jobId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = "";
          minimumImportance: string = "JOB_MESSAGE_IMPORTANCE_UNKNOWN";
          Xgafv: string = "1"; pageSize: int = 0; startTime: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; location: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          endTime: string = ""): Recallable =
  ## dataflowProjectsJobsMessagesList
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.messages.list` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.messages.list` is not recommended, as you can only request
  ## the status of jobs that are running in `us-central1`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   minimumImportance: string
  ##                    : Filter to only get messages with importance >= level
  ##   projectId: string (required)
  ##            : A project id.
  ##   jobId: string (required)
  ##        : The job to get messages about.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : If specified, determines the maximum number of messages to
  ## return.  If unspecified, the service may choose an appropriate
  ## default, or may return an arbitrarily large number of results.
  ##   startTime: string
  ##            : If specified, return only messages with timestamps >= start_time.
  ## The default is the job creation time (i.e. beginning of messages).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : If supplied, this should be the value of next_page_token returned
  ## by an earlier call. This will cause the next page of results to
  ## be returned.
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   endTime: string
  ##          : Return only messages with timestamps < end_time. The default is now
  ## (i.e. return up to the latest messages available).
  var path_579070 = newJObject()
  var query_579071 = newJObject()
  add(query_579071, "key", newJString(key))
  add(query_579071, "prettyPrint", newJBool(prettyPrint))
  add(query_579071, "oauth_token", newJString(oauthToken))
  add(query_579071, "minimumImportance", newJString(minimumImportance))
  add(path_579070, "projectId", newJString(projectId))
  add(path_579070, "jobId", newJString(jobId))
  add(query_579071, "$.xgafv", newJString(Xgafv))
  add(query_579071, "pageSize", newJInt(pageSize))
  add(query_579071, "startTime", newJString(startTime))
  add(query_579071, "alt", newJString(alt))
  add(query_579071, "uploadType", newJString(uploadType))
  add(query_579071, "quotaUser", newJString(quotaUser))
  add(query_579071, "pageToken", newJString(pageToken))
  add(query_579071, "location", newJString(location))
  add(query_579071, "callback", newJString(callback))
  add(query_579071, "fields", newJString(fields))
  add(query_579071, "access_token", newJString(accessToken))
  add(query_579071, "upload_protocol", newJString(uploadProtocol))
  add(query_579071, "endTime", newJString(endTime))
  result = call_579069.call(path_579070, query_579071, nil, nil, nil)

var dataflowProjectsJobsMessagesList* = Call_DataflowProjectsJobsMessagesList_579046(
    name: "dataflowProjectsJobsMessagesList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/messages",
    validator: validate_DataflowProjectsJobsMessagesList_579047, base: "/",
    url: url_DataflowProjectsJobsMessagesList_579048, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsGetMetrics_579072 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsJobsGetMetrics_579074(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsJobsGetMetrics_579073(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.getMetrics` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.getMetrics` is not recommended, as you can only request the
  ## status of jobs that are running in `us-central1`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A project id.
  ##   jobId: JString (required)
  ##        : The job to get messages for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579075 = path.getOrDefault("projectId")
  valid_579075 = validateParameter(valid_579075, JString, required = true,
                                 default = nil)
  if valid_579075 != nil:
    section.add "projectId", valid_579075
  var valid_579076 = path.getOrDefault("jobId")
  valid_579076 = validateParameter(valid_579076, JString, required = true,
                                 default = nil)
  if valid_579076 != nil:
    section.add "jobId", valid_579076
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
  ##   startTime: JString
  ##            : Return only metric data that has changed since this time.
  ## Default is to return all information about all metrics for the job.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579077 = query.getOrDefault("key")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "key", valid_579077
  var valid_579078 = query.getOrDefault("prettyPrint")
  valid_579078 = validateParameter(valid_579078, JBool, required = false,
                                 default = newJBool(true))
  if valid_579078 != nil:
    section.add "prettyPrint", valid_579078
  var valid_579079 = query.getOrDefault("oauth_token")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "oauth_token", valid_579079
  var valid_579080 = query.getOrDefault("$.xgafv")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = newJString("1"))
  if valid_579080 != nil:
    section.add "$.xgafv", valid_579080
  var valid_579081 = query.getOrDefault("startTime")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "startTime", valid_579081
  var valid_579082 = query.getOrDefault("alt")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = newJString("json"))
  if valid_579082 != nil:
    section.add "alt", valid_579082
  var valid_579083 = query.getOrDefault("uploadType")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "uploadType", valid_579083
  var valid_579084 = query.getOrDefault("quotaUser")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "quotaUser", valid_579084
  var valid_579085 = query.getOrDefault("location")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "location", valid_579085
  var valid_579086 = query.getOrDefault("callback")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "callback", valid_579086
  var valid_579087 = query.getOrDefault("fields")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "fields", valid_579087
  var valid_579088 = query.getOrDefault("access_token")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "access_token", valid_579088
  var valid_579089 = query.getOrDefault("upload_protocol")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "upload_protocol", valid_579089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579090: Call_DataflowProjectsJobsGetMetrics_579072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.getMetrics` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.getMetrics` is not recommended, as you can only request the
  ## status of jobs that are running in `us-central1`.
  ## 
  let valid = call_579090.validator(path, query, header, formData, body)
  let scheme = call_579090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579090.url(scheme.get, call_579090.host, call_579090.base,
                         call_579090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579090, url, valid)

proc call*(call_579091: Call_DataflowProjectsJobsGetMetrics_579072;
          projectId: string; jobId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; startTime: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          location: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsJobsGetMetrics
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.getMetrics` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.getMetrics` is not recommended, as you can only request the
  ## status of jobs that are running in `us-central1`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A project id.
  ##   jobId: string (required)
  ##        : The job to get messages for.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   startTime: string
  ##            : Return only metric data that has changed since this time.
  ## Default is to return all information about all metrics for the job.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579092 = newJObject()
  var query_579093 = newJObject()
  add(query_579093, "key", newJString(key))
  add(query_579093, "prettyPrint", newJBool(prettyPrint))
  add(query_579093, "oauth_token", newJString(oauthToken))
  add(path_579092, "projectId", newJString(projectId))
  add(path_579092, "jobId", newJString(jobId))
  add(query_579093, "$.xgafv", newJString(Xgafv))
  add(query_579093, "startTime", newJString(startTime))
  add(query_579093, "alt", newJString(alt))
  add(query_579093, "uploadType", newJString(uploadType))
  add(query_579093, "quotaUser", newJString(quotaUser))
  add(query_579093, "location", newJString(location))
  add(query_579093, "callback", newJString(callback))
  add(query_579093, "fields", newJString(fields))
  add(query_579093, "access_token", newJString(accessToken))
  add(query_579093, "upload_protocol", newJString(uploadProtocol))
  result = call_579091.call(path_579092, query_579093, nil, nil, nil)

var dataflowProjectsJobsGetMetrics* = Call_DataflowProjectsJobsGetMetrics_579072(
    name: "dataflowProjectsJobsGetMetrics", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/metrics",
    validator: validate_DataflowProjectsJobsGetMetrics_579073, base: "/",
    url: url_DataflowProjectsJobsGetMetrics_579074, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsWorkItemsLease_579094 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsJobsWorkItemsLease_579096(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/workItems:lease")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsJobsWorkItemsLease_579095(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Leases a dataflow WorkItem to run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Identifies the project this worker belongs to.
  ##   jobId: JString (required)
  ##        : Identifies the workflow job this worker belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579097 = path.getOrDefault("projectId")
  valid_579097 = validateParameter(valid_579097, JString, required = true,
                                 default = nil)
  if valid_579097 != nil:
    section.add "projectId", valid_579097
  var valid_579098 = path.getOrDefault("jobId")
  valid_579098 = validateParameter(valid_579098, JString, required = true,
                                 default = nil)
  if valid_579098 != nil:
    section.add "jobId", valid_579098
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
  var valid_579099 = query.getOrDefault("key")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "key", valid_579099
  var valid_579100 = query.getOrDefault("prettyPrint")
  valid_579100 = validateParameter(valid_579100, JBool, required = false,
                                 default = newJBool(true))
  if valid_579100 != nil:
    section.add "prettyPrint", valid_579100
  var valid_579101 = query.getOrDefault("oauth_token")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "oauth_token", valid_579101
  var valid_579102 = query.getOrDefault("$.xgafv")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = newJString("1"))
  if valid_579102 != nil:
    section.add "$.xgafv", valid_579102
  var valid_579103 = query.getOrDefault("alt")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = newJString("json"))
  if valid_579103 != nil:
    section.add "alt", valid_579103
  var valid_579104 = query.getOrDefault("uploadType")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "uploadType", valid_579104
  var valid_579105 = query.getOrDefault("quotaUser")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "quotaUser", valid_579105
  var valid_579106 = query.getOrDefault("callback")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "callback", valid_579106
  var valid_579107 = query.getOrDefault("fields")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "fields", valid_579107
  var valid_579108 = query.getOrDefault("access_token")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "access_token", valid_579108
  var valid_579109 = query.getOrDefault("upload_protocol")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "upload_protocol", valid_579109
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

proc call*(call_579111: Call_DataflowProjectsJobsWorkItemsLease_579094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Leases a dataflow WorkItem to run.
  ## 
  let valid = call_579111.validator(path, query, header, formData, body)
  let scheme = call_579111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579111.url(scheme.get, call_579111.host, call_579111.base,
                         call_579111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579111, url, valid)

proc call*(call_579112: Call_DataflowProjectsJobsWorkItemsLease_579094;
          projectId: string; jobId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsJobsWorkItemsLease
  ## Leases a dataflow WorkItem to run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Identifies the project this worker belongs to.
  ##   jobId: string (required)
  ##        : Identifies the workflow job this worker belongs to.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579113 = newJObject()
  var query_579114 = newJObject()
  var body_579115 = newJObject()
  add(query_579114, "key", newJString(key))
  add(query_579114, "prettyPrint", newJBool(prettyPrint))
  add(query_579114, "oauth_token", newJString(oauthToken))
  add(path_579113, "projectId", newJString(projectId))
  add(path_579113, "jobId", newJString(jobId))
  add(query_579114, "$.xgafv", newJString(Xgafv))
  add(query_579114, "alt", newJString(alt))
  add(query_579114, "uploadType", newJString(uploadType))
  add(query_579114, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579115 = body
  add(query_579114, "callback", newJString(callback))
  add(query_579114, "fields", newJString(fields))
  add(query_579114, "access_token", newJString(accessToken))
  add(query_579114, "upload_protocol", newJString(uploadProtocol))
  result = call_579112.call(path_579113, query_579114, nil, nil, body_579115)

var dataflowProjectsJobsWorkItemsLease* = Call_DataflowProjectsJobsWorkItemsLease_579094(
    name: "dataflowProjectsJobsWorkItemsLease", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/workItems:lease",
    validator: validate_DataflowProjectsJobsWorkItemsLease_579095, base: "/",
    url: url_DataflowProjectsJobsWorkItemsLease_579096, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsWorkItemsReportStatus_579116 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsJobsWorkItemsReportStatus_579118(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/workItems:reportStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsJobsWorkItemsReportStatus_579117(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reports the status of dataflow WorkItems leased by a worker.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project which owns the WorkItem's job.
  ##   jobId: JString (required)
  ##        : The job which the WorkItem is part of.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579119 = path.getOrDefault("projectId")
  valid_579119 = validateParameter(valid_579119, JString, required = true,
                                 default = nil)
  if valid_579119 != nil:
    section.add "projectId", valid_579119
  var valid_579120 = path.getOrDefault("jobId")
  valid_579120 = validateParameter(valid_579120, JString, required = true,
                                 default = nil)
  if valid_579120 != nil:
    section.add "jobId", valid_579120
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
  var valid_579121 = query.getOrDefault("key")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "key", valid_579121
  var valid_579122 = query.getOrDefault("prettyPrint")
  valid_579122 = validateParameter(valid_579122, JBool, required = false,
                                 default = newJBool(true))
  if valid_579122 != nil:
    section.add "prettyPrint", valid_579122
  var valid_579123 = query.getOrDefault("oauth_token")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "oauth_token", valid_579123
  var valid_579124 = query.getOrDefault("$.xgafv")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = newJString("1"))
  if valid_579124 != nil:
    section.add "$.xgafv", valid_579124
  var valid_579125 = query.getOrDefault("alt")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = newJString("json"))
  if valid_579125 != nil:
    section.add "alt", valid_579125
  var valid_579126 = query.getOrDefault("uploadType")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "uploadType", valid_579126
  var valid_579127 = query.getOrDefault("quotaUser")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "quotaUser", valid_579127
  var valid_579128 = query.getOrDefault("callback")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "callback", valid_579128
  var valid_579129 = query.getOrDefault("fields")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "fields", valid_579129
  var valid_579130 = query.getOrDefault("access_token")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "access_token", valid_579130
  var valid_579131 = query.getOrDefault("upload_protocol")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "upload_protocol", valid_579131
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

proc call*(call_579133: Call_DataflowProjectsJobsWorkItemsReportStatus_579116;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports the status of dataflow WorkItems leased by a worker.
  ## 
  let valid = call_579133.validator(path, query, header, formData, body)
  let scheme = call_579133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579133.url(scheme.get, call_579133.host, call_579133.base,
                         call_579133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579133, url, valid)

proc call*(call_579134: Call_DataflowProjectsJobsWorkItemsReportStatus_579116;
          projectId: string; jobId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsJobsWorkItemsReportStatus
  ## Reports the status of dataflow WorkItems leased by a worker.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The project which owns the WorkItem's job.
  ##   jobId: string (required)
  ##        : The job which the WorkItem is part of.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579135 = newJObject()
  var query_579136 = newJObject()
  var body_579137 = newJObject()
  add(query_579136, "key", newJString(key))
  add(query_579136, "prettyPrint", newJBool(prettyPrint))
  add(query_579136, "oauth_token", newJString(oauthToken))
  add(path_579135, "projectId", newJString(projectId))
  add(path_579135, "jobId", newJString(jobId))
  add(query_579136, "$.xgafv", newJString(Xgafv))
  add(query_579136, "alt", newJString(alt))
  add(query_579136, "uploadType", newJString(uploadType))
  add(query_579136, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579137 = body
  add(query_579136, "callback", newJString(callback))
  add(query_579136, "fields", newJString(fields))
  add(query_579136, "access_token", newJString(accessToken))
  add(query_579136, "upload_protocol", newJString(uploadProtocol))
  result = call_579134.call(path_579135, query_579136, nil, nil, body_579137)

var dataflowProjectsJobsWorkItemsReportStatus* = Call_DataflowProjectsJobsWorkItemsReportStatus_579116(
    name: "dataflowProjectsJobsWorkItemsReportStatus", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/workItems:reportStatus",
    validator: validate_DataflowProjectsJobsWorkItemsReportStatus_579117,
    base: "/", url: url_DataflowProjectsJobsWorkItemsReportStatus_579118,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsAggregated_579138 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsJobsAggregated_579140(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs:aggregated")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsJobsAggregated_579139(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the jobs of a project across all regions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project which owns the jobs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579141 = path.getOrDefault("projectId")
  valid_579141 = validateParameter(valid_579141, JString, required = true,
                                 default = nil)
  if valid_579141 != nil:
    section.add "projectId", valid_579141
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
  ##           : If there are many jobs, limit response to at most this many.
  ## The actual number of jobs returned will be the lesser of max_responses
  ## and an unspecified server-defined limit.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The kind of filter to use.
  ##   pageToken: JString
  ##            : Set this to the 'next_page_token' field of a previous response
  ## to request additional results in a long list.
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : Level of information requested in response. Default is `JOB_VIEW_SUMMARY`.
  section = newJObject()
  var valid_579142 = query.getOrDefault("key")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "key", valid_579142
  var valid_579143 = query.getOrDefault("prettyPrint")
  valid_579143 = validateParameter(valid_579143, JBool, required = false,
                                 default = newJBool(true))
  if valid_579143 != nil:
    section.add "prettyPrint", valid_579143
  var valid_579144 = query.getOrDefault("oauth_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "oauth_token", valid_579144
  var valid_579145 = query.getOrDefault("$.xgafv")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("1"))
  if valid_579145 != nil:
    section.add "$.xgafv", valid_579145
  var valid_579146 = query.getOrDefault("pageSize")
  valid_579146 = validateParameter(valid_579146, JInt, required = false, default = nil)
  if valid_579146 != nil:
    section.add "pageSize", valid_579146
  var valid_579147 = query.getOrDefault("alt")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = newJString("json"))
  if valid_579147 != nil:
    section.add "alt", valid_579147
  var valid_579148 = query.getOrDefault("uploadType")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "uploadType", valid_579148
  var valid_579149 = query.getOrDefault("quotaUser")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "quotaUser", valid_579149
  var valid_579150 = query.getOrDefault("filter")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_579150 != nil:
    section.add "filter", valid_579150
  var valid_579151 = query.getOrDefault("pageToken")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "pageToken", valid_579151
  var valid_579152 = query.getOrDefault("location")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "location", valid_579152
  var valid_579153 = query.getOrDefault("callback")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "callback", valid_579153
  var valid_579154 = query.getOrDefault("fields")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "fields", valid_579154
  var valid_579155 = query.getOrDefault("access_token")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "access_token", valid_579155
  var valid_579156 = query.getOrDefault("upload_protocol")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "upload_protocol", valid_579156
  var valid_579157 = query.getOrDefault("view")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_579157 != nil:
    section.add "view", valid_579157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579158: Call_DataflowProjectsJobsAggregated_579138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the jobs of a project across all regions.
  ## 
  let valid = call_579158.validator(path, query, header, formData, body)
  let scheme = call_579158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579158.url(scheme.get, call_579158.host, call_579158.base,
                         call_579158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579158, url, valid)

proc call*(call_579159: Call_DataflowProjectsJobsAggregated_579138;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = "UNKNOWN"; pageToken: string = ""; location: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; view: string = "JOB_VIEW_UNKNOWN"): Recallable =
  ## dataflowProjectsJobsAggregated
  ## List the jobs of a project across all regions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The project which owns the jobs.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : If there are many jobs, limit response to at most this many.
  ## The actual number of jobs returned will be the lesser of max_responses
  ## and an unspecified server-defined limit.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The kind of filter to use.
  ##   pageToken: string
  ##            : Set this to the 'next_page_token' field of a previous response
  ## to request additional results in a long list.
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Level of information requested in response. Default is `JOB_VIEW_SUMMARY`.
  var path_579160 = newJObject()
  var query_579161 = newJObject()
  add(query_579161, "key", newJString(key))
  add(query_579161, "prettyPrint", newJBool(prettyPrint))
  add(query_579161, "oauth_token", newJString(oauthToken))
  add(path_579160, "projectId", newJString(projectId))
  add(query_579161, "$.xgafv", newJString(Xgafv))
  add(query_579161, "pageSize", newJInt(pageSize))
  add(query_579161, "alt", newJString(alt))
  add(query_579161, "uploadType", newJString(uploadType))
  add(query_579161, "quotaUser", newJString(quotaUser))
  add(query_579161, "filter", newJString(filter))
  add(query_579161, "pageToken", newJString(pageToken))
  add(query_579161, "location", newJString(location))
  add(query_579161, "callback", newJString(callback))
  add(query_579161, "fields", newJString(fields))
  add(query_579161, "access_token", newJString(accessToken))
  add(query_579161, "upload_protocol", newJString(uploadProtocol))
  add(query_579161, "view", newJString(view))
  result = call_579159.call(path_579160, query_579161, nil, nil, nil)

var dataflowProjectsJobsAggregated* = Call_DataflowProjectsJobsAggregated_579138(
    name: "dataflowProjectsJobsAggregated", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs:aggregated",
    validator: validate_DataflowProjectsJobsAggregated_579139, base: "/",
    url: url_DataflowProjectsJobsAggregated_579140, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsWorkerMessages_579162 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsWorkerMessages_579164(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/WorkerMessages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsWorkerMessages_579163(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Send a worker_message to the service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project to send the WorkerMessages to.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579165 = path.getOrDefault("projectId")
  valid_579165 = validateParameter(valid_579165, JString, required = true,
                                 default = nil)
  if valid_579165 != nil:
    section.add "projectId", valid_579165
  var valid_579166 = path.getOrDefault("location")
  valid_579166 = validateParameter(valid_579166, JString, required = true,
                                 default = nil)
  if valid_579166 != nil:
    section.add "location", valid_579166
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
  var valid_579167 = query.getOrDefault("key")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "key", valid_579167
  var valid_579168 = query.getOrDefault("prettyPrint")
  valid_579168 = validateParameter(valid_579168, JBool, required = false,
                                 default = newJBool(true))
  if valid_579168 != nil:
    section.add "prettyPrint", valid_579168
  var valid_579169 = query.getOrDefault("oauth_token")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "oauth_token", valid_579169
  var valid_579170 = query.getOrDefault("$.xgafv")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = newJString("1"))
  if valid_579170 != nil:
    section.add "$.xgafv", valid_579170
  var valid_579171 = query.getOrDefault("alt")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = newJString("json"))
  if valid_579171 != nil:
    section.add "alt", valid_579171
  var valid_579172 = query.getOrDefault("uploadType")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "uploadType", valid_579172
  var valid_579173 = query.getOrDefault("quotaUser")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "quotaUser", valid_579173
  var valid_579174 = query.getOrDefault("callback")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "callback", valid_579174
  var valid_579175 = query.getOrDefault("fields")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "fields", valid_579175
  var valid_579176 = query.getOrDefault("access_token")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "access_token", valid_579176
  var valid_579177 = query.getOrDefault("upload_protocol")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "upload_protocol", valid_579177
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

proc call*(call_579179: Call_DataflowProjectsLocationsWorkerMessages_579162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send a worker_message to the service.
  ## 
  let valid = call_579179.validator(path, query, header, formData, body)
  let scheme = call_579179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579179.url(scheme.get, call_579179.host, call_579179.base,
                         call_579179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579179, url, valid)

proc call*(call_579180: Call_DataflowProjectsLocationsWorkerMessages_579162;
          projectId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsLocationsWorkerMessages
  ## Send a worker_message to the service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The project to send the WorkerMessages to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579181 = newJObject()
  var query_579182 = newJObject()
  var body_579183 = newJObject()
  add(query_579182, "key", newJString(key))
  add(query_579182, "prettyPrint", newJBool(prettyPrint))
  add(query_579182, "oauth_token", newJString(oauthToken))
  add(path_579181, "projectId", newJString(projectId))
  add(query_579182, "$.xgafv", newJString(Xgafv))
  add(query_579182, "alt", newJString(alt))
  add(query_579182, "uploadType", newJString(uploadType))
  add(query_579182, "quotaUser", newJString(quotaUser))
  add(path_579181, "location", newJString(location))
  if body != nil:
    body_579183 = body
  add(query_579182, "callback", newJString(callback))
  add(query_579182, "fields", newJString(fields))
  add(query_579182, "access_token", newJString(accessToken))
  add(query_579182, "upload_protocol", newJString(uploadProtocol))
  result = call_579180.call(path_579181, query_579182, nil, nil, body_579183)

var dataflowProjectsLocationsWorkerMessages* = Call_DataflowProjectsLocationsWorkerMessages_579162(
    name: "dataflowProjectsLocationsWorkerMessages", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/WorkerMessages",
    validator: validate_DataflowProjectsLocationsWorkerMessages_579163, base: "/",
    url: url_DataflowProjectsLocationsWorkerMessages_579164,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsCreate_579208 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsJobsCreate_579210(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsCreate_579209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Cloud Dataflow job.
  ## 
  ## To create a job, we recommend using `projects.locations.jobs.create` with a
  ## [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.create` is not recommended, as your job will always start
  ## in `us-central1`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579211 = path.getOrDefault("projectId")
  valid_579211 = validateParameter(valid_579211, JString, required = true,
                                 default = nil)
  if valid_579211 != nil:
    section.add "projectId", valid_579211
  var valid_579212 = path.getOrDefault("location")
  valid_579212 = validateParameter(valid_579212, JString, required = true,
                                 default = nil)
  if valid_579212 != nil:
    section.add "location", valid_579212
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
  ##   replaceJobId: JString
  ##               : Deprecated. This field is now in the Job message.
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
  ##   view: JString
  ##       : The level of information requested in response.
  section = newJObject()
  var valid_579213 = query.getOrDefault("key")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "key", valid_579213
  var valid_579214 = query.getOrDefault("prettyPrint")
  valid_579214 = validateParameter(valid_579214, JBool, required = false,
                                 default = newJBool(true))
  if valid_579214 != nil:
    section.add "prettyPrint", valid_579214
  var valid_579215 = query.getOrDefault("oauth_token")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "oauth_token", valid_579215
  var valid_579216 = query.getOrDefault("$.xgafv")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = newJString("1"))
  if valid_579216 != nil:
    section.add "$.xgafv", valid_579216
  var valid_579217 = query.getOrDefault("replaceJobId")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "replaceJobId", valid_579217
  var valid_579218 = query.getOrDefault("alt")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = newJString("json"))
  if valid_579218 != nil:
    section.add "alt", valid_579218
  var valid_579219 = query.getOrDefault("uploadType")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "uploadType", valid_579219
  var valid_579220 = query.getOrDefault("quotaUser")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "quotaUser", valid_579220
  var valid_579221 = query.getOrDefault("callback")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "callback", valid_579221
  var valid_579222 = query.getOrDefault("fields")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "fields", valid_579222
  var valid_579223 = query.getOrDefault("access_token")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "access_token", valid_579223
  var valid_579224 = query.getOrDefault("upload_protocol")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "upload_protocol", valid_579224
  var valid_579225 = query.getOrDefault("view")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_579225 != nil:
    section.add "view", valid_579225
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

proc call*(call_579227: Call_DataflowProjectsLocationsJobsCreate_579208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job.
  ## 
  ## To create a job, we recommend using `projects.locations.jobs.create` with a
  ## [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.create` is not recommended, as your job will always start
  ## in `us-central1`.
  ## 
  let valid = call_579227.validator(path, query, header, formData, body)
  let scheme = call_579227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579227.url(scheme.get, call_579227.host, call_579227.base,
                         call_579227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579227, url, valid)

proc call*(call_579228: Call_DataflowProjectsLocationsJobsCreate_579208;
          projectId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          replaceJobId: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          view: string = "JOB_VIEW_UNKNOWN"): Recallable =
  ## dataflowProjectsLocationsJobsCreate
  ## Creates a Cloud Dataflow job.
  ## 
  ## To create a job, we recommend using `projects.locations.jobs.create` with a
  ## [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.create` is not recommended, as your job will always start
  ## in `us-central1`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   replaceJobId: string
  ##               : Deprecated. This field is now in the Job message.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : The level of information requested in response.
  var path_579229 = newJObject()
  var query_579230 = newJObject()
  var body_579231 = newJObject()
  add(query_579230, "key", newJString(key))
  add(query_579230, "prettyPrint", newJBool(prettyPrint))
  add(query_579230, "oauth_token", newJString(oauthToken))
  add(path_579229, "projectId", newJString(projectId))
  add(query_579230, "$.xgafv", newJString(Xgafv))
  add(query_579230, "replaceJobId", newJString(replaceJobId))
  add(query_579230, "alt", newJString(alt))
  add(query_579230, "uploadType", newJString(uploadType))
  add(query_579230, "quotaUser", newJString(quotaUser))
  add(path_579229, "location", newJString(location))
  if body != nil:
    body_579231 = body
  add(query_579230, "callback", newJString(callback))
  add(query_579230, "fields", newJString(fields))
  add(query_579230, "access_token", newJString(accessToken))
  add(query_579230, "upload_protocol", newJString(uploadProtocol))
  add(query_579230, "view", newJString(view))
  result = call_579228.call(path_579229, query_579230, nil, nil, body_579231)

var dataflowProjectsLocationsJobsCreate* = Call_DataflowProjectsLocationsJobsCreate_579208(
    name: "dataflowProjectsLocationsJobsCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs",
    validator: validate_DataflowProjectsLocationsJobsCreate_579209, base: "/",
    url: url_DataflowProjectsLocationsJobsCreate_579210, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsList_579184 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsJobsList_579186(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsList_579185(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the jobs of a project.
  ## 
  ## To list the jobs of a project in a region, we recommend using
  ## `projects.locations.jobs.get` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). To
  ## list the all jobs across all regions, use `projects.jobs.aggregated`. Using
  ## `projects.jobs.list` is not recommended, as you can only get the list of
  ## jobs that are running in `us-central1`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project which owns the jobs.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579187 = path.getOrDefault("projectId")
  valid_579187 = validateParameter(valid_579187, JString, required = true,
                                 default = nil)
  if valid_579187 != nil:
    section.add "projectId", valid_579187
  var valid_579188 = path.getOrDefault("location")
  valid_579188 = validateParameter(valid_579188, JString, required = true,
                                 default = nil)
  if valid_579188 != nil:
    section.add "location", valid_579188
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
  ##           : If there are many jobs, limit response to at most this many.
  ## The actual number of jobs returned will be the lesser of max_responses
  ## and an unspecified server-defined limit.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The kind of filter to use.
  ##   pageToken: JString
  ##            : Set this to the 'next_page_token' field of a previous response
  ## to request additional results in a long list.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : Level of information requested in response. Default is `JOB_VIEW_SUMMARY`.
  section = newJObject()
  var valid_579189 = query.getOrDefault("key")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "key", valid_579189
  var valid_579190 = query.getOrDefault("prettyPrint")
  valid_579190 = validateParameter(valid_579190, JBool, required = false,
                                 default = newJBool(true))
  if valid_579190 != nil:
    section.add "prettyPrint", valid_579190
  var valid_579191 = query.getOrDefault("oauth_token")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "oauth_token", valid_579191
  var valid_579192 = query.getOrDefault("$.xgafv")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = newJString("1"))
  if valid_579192 != nil:
    section.add "$.xgafv", valid_579192
  var valid_579193 = query.getOrDefault("pageSize")
  valid_579193 = validateParameter(valid_579193, JInt, required = false, default = nil)
  if valid_579193 != nil:
    section.add "pageSize", valid_579193
  var valid_579194 = query.getOrDefault("alt")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = newJString("json"))
  if valid_579194 != nil:
    section.add "alt", valid_579194
  var valid_579195 = query.getOrDefault("uploadType")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "uploadType", valid_579195
  var valid_579196 = query.getOrDefault("quotaUser")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "quotaUser", valid_579196
  var valid_579197 = query.getOrDefault("filter")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_579197 != nil:
    section.add "filter", valid_579197
  var valid_579198 = query.getOrDefault("pageToken")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "pageToken", valid_579198
  var valid_579199 = query.getOrDefault("callback")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "callback", valid_579199
  var valid_579200 = query.getOrDefault("fields")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "fields", valid_579200
  var valid_579201 = query.getOrDefault("access_token")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "access_token", valid_579201
  var valid_579202 = query.getOrDefault("upload_protocol")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "upload_protocol", valid_579202
  var valid_579203 = query.getOrDefault("view")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_579203 != nil:
    section.add "view", valid_579203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579204: Call_DataflowProjectsLocationsJobsList_579184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the jobs of a project.
  ## 
  ## To list the jobs of a project in a region, we recommend using
  ## `projects.locations.jobs.get` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). To
  ## list the all jobs across all regions, use `projects.jobs.aggregated`. Using
  ## `projects.jobs.list` is not recommended, as you can only get the list of
  ## jobs that are running in `us-central1`.
  ## 
  let valid = call_579204.validator(path, query, header, formData, body)
  let scheme = call_579204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579204.url(scheme.get, call_579204.host, call_579204.base,
                         call_579204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579204, url, valid)

proc call*(call_579205: Call_DataflowProjectsLocationsJobsList_579184;
          projectId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; filter: string = "UNKNOWN"; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; view: string = "JOB_VIEW_UNKNOWN"): Recallable =
  ## dataflowProjectsLocationsJobsList
  ## List the jobs of a project.
  ## 
  ## To list the jobs of a project in a region, we recommend using
  ## `projects.locations.jobs.get` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). To
  ## list the all jobs across all regions, use `projects.jobs.aggregated`. Using
  ## `projects.jobs.list` is not recommended, as you can only get the list of
  ## jobs that are running in `us-central1`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The project which owns the jobs.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : If there are many jobs, limit response to at most this many.
  ## The actual number of jobs returned will be the lesser of max_responses
  ## and an unspecified server-defined limit.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The kind of filter to use.
  ##   pageToken: string
  ##            : Set this to the 'next_page_token' field of a previous response
  ## to request additional results in a long list.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Level of information requested in response. Default is `JOB_VIEW_SUMMARY`.
  var path_579206 = newJObject()
  var query_579207 = newJObject()
  add(query_579207, "key", newJString(key))
  add(query_579207, "prettyPrint", newJBool(prettyPrint))
  add(query_579207, "oauth_token", newJString(oauthToken))
  add(path_579206, "projectId", newJString(projectId))
  add(query_579207, "$.xgafv", newJString(Xgafv))
  add(query_579207, "pageSize", newJInt(pageSize))
  add(query_579207, "alt", newJString(alt))
  add(query_579207, "uploadType", newJString(uploadType))
  add(query_579207, "quotaUser", newJString(quotaUser))
  add(query_579207, "filter", newJString(filter))
  add(query_579207, "pageToken", newJString(pageToken))
  add(path_579206, "location", newJString(location))
  add(query_579207, "callback", newJString(callback))
  add(query_579207, "fields", newJString(fields))
  add(query_579207, "access_token", newJString(accessToken))
  add(query_579207, "upload_protocol", newJString(uploadProtocol))
  add(query_579207, "view", newJString(view))
  result = call_579205.call(path_579206, query_579207, nil, nil, nil)

var dataflowProjectsLocationsJobsList* = Call_DataflowProjectsLocationsJobsList_579184(
    name: "dataflowProjectsLocationsJobsList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs",
    validator: validate_DataflowProjectsLocationsJobsList_579185, base: "/",
    url: url_DataflowProjectsLocationsJobsList_579186, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsUpdate_579254 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsJobsUpdate_579256(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsUpdate_579255(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the state of an existing Cloud Dataflow job.
  ## 
  ## To update the state of an existing job, we recommend using
  ## `projects.locations.jobs.update` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.update` is not recommended, as you can only update the state
  ## of jobs that are running in `us-central1`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : The job ID.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579257 = path.getOrDefault("projectId")
  valid_579257 = validateParameter(valid_579257, JString, required = true,
                                 default = nil)
  if valid_579257 != nil:
    section.add "projectId", valid_579257
  var valid_579258 = path.getOrDefault("jobId")
  valid_579258 = validateParameter(valid_579258, JString, required = true,
                                 default = nil)
  if valid_579258 != nil:
    section.add "jobId", valid_579258
  var valid_579259 = path.getOrDefault("location")
  valid_579259 = validateParameter(valid_579259, JString, required = true,
                                 default = nil)
  if valid_579259 != nil:
    section.add "location", valid_579259
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
  var valid_579260 = query.getOrDefault("key")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "key", valid_579260
  var valid_579261 = query.getOrDefault("prettyPrint")
  valid_579261 = validateParameter(valid_579261, JBool, required = false,
                                 default = newJBool(true))
  if valid_579261 != nil:
    section.add "prettyPrint", valid_579261
  var valid_579262 = query.getOrDefault("oauth_token")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "oauth_token", valid_579262
  var valid_579263 = query.getOrDefault("$.xgafv")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = newJString("1"))
  if valid_579263 != nil:
    section.add "$.xgafv", valid_579263
  var valid_579264 = query.getOrDefault("alt")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = newJString("json"))
  if valid_579264 != nil:
    section.add "alt", valid_579264
  var valid_579265 = query.getOrDefault("uploadType")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "uploadType", valid_579265
  var valid_579266 = query.getOrDefault("quotaUser")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "quotaUser", valid_579266
  var valid_579267 = query.getOrDefault("callback")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "callback", valid_579267
  var valid_579268 = query.getOrDefault("fields")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "fields", valid_579268
  var valid_579269 = query.getOrDefault("access_token")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "access_token", valid_579269
  var valid_579270 = query.getOrDefault("upload_protocol")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "upload_protocol", valid_579270
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

proc call*(call_579272: Call_DataflowProjectsLocationsJobsUpdate_579254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the state of an existing Cloud Dataflow job.
  ## 
  ## To update the state of an existing job, we recommend using
  ## `projects.locations.jobs.update` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.update` is not recommended, as you can only update the state
  ## of jobs that are running in `us-central1`.
  ## 
  let valid = call_579272.validator(path, query, header, formData, body)
  let scheme = call_579272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579272.url(scheme.get, call_579272.host, call_579272.base,
                         call_579272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579272, url, valid)

proc call*(call_579273: Call_DataflowProjectsLocationsJobsUpdate_579254;
          projectId: string; jobId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsLocationsJobsUpdate
  ## Updates the state of an existing Cloud Dataflow job.
  ## 
  ## To update the state of an existing job, we recommend using
  ## `projects.locations.jobs.update` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.update` is not recommended, as you can only update the state
  ## of jobs that are running in `us-central1`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   jobId: string (required)
  ##        : The job ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579274 = newJObject()
  var query_579275 = newJObject()
  var body_579276 = newJObject()
  add(query_579275, "key", newJString(key))
  add(query_579275, "prettyPrint", newJBool(prettyPrint))
  add(query_579275, "oauth_token", newJString(oauthToken))
  add(path_579274, "projectId", newJString(projectId))
  add(path_579274, "jobId", newJString(jobId))
  add(query_579275, "$.xgafv", newJString(Xgafv))
  add(query_579275, "alt", newJString(alt))
  add(query_579275, "uploadType", newJString(uploadType))
  add(query_579275, "quotaUser", newJString(quotaUser))
  add(path_579274, "location", newJString(location))
  if body != nil:
    body_579276 = body
  add(query_579275, "callback", newJString(callback))
  add(query_579275, "fields", newJString(fields))
  add(query_579275, "access_token", newJString(accessToken))
  add(query_579275, "upload_protocol", newJString(uploadProtocol))
  result = call_579273.call(path_579274, query_579275, nil, nil, body_579276)

var dataflowProjectsLocationsJobsUpdate* = Call_DataflowProjectsLocationsJobsUpdate_579254(
    name: "dataflowProjectsLocationsJobsUpdate", meth: HttpMethod.HttpPut,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}",
    validator: validate_DataflowProjectsLocationsJobsUpdate_579255, base: "/",
    url: url_DataflowProjectsLocationsJobsUpdate_579256, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsGet_579232 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsJobsGet_579234(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsGet_579233(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the state of the specified Cloud Dataflow job.
  ## 
  ## To get the state of a job, we recommend using `projects.locations.jobs.get`
  ## with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.get` is not recommended, as you can only get the state of
  ## jobs that are running in `us-central1`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   jobId: JString (required)
  ##        : The job ID.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579235 = path.getOrDefault("projectId")
  valid_579235 = validateParameter(valid_579235, JString, required = true,
                                 default = nil)
  if valid_579235 != nil:
    section.add "projectId", valid_579235
  var valid_579236 = path.getOrDefault("jobId")
  valid_579236 = validateParameter(valid_579236, JString, required = true,
                                 default = nil)
  if valid_579236 != nil:
    section.add "jobId", valid_579236
  var valid_579237 = path.getOrDefault("location")
  valid_579237 = validateParameter(valid_579237, JString, required = true,
                                 default = nil)
  if valid_579237 != nil:
    section.add "location", valid_579237
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
  ##   view: JString
  ##       : The level of information requested in response.
  section = newJObject()
  var valid_579238 = query.getOrDefault("key")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "key", valid_579238
  var valid_579239 = query.getOrDefault("prettyPrint")
  valid_579239 = validateParameter(valid_579239, JBool, required = false,
                                 default = newJBool(true))
  if valid_579239 != nil:
    section.add "prettyPrint", valid_579239
  var valid_579240 = query.getOrDefault("oauth_token")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "oauth_token", valid_579240
  var valid_579241 = query.getOrDefault("$.xgafv")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = newJString("1"))
  if valid_579241 != nil:
    section.add "$.xgafv", valid_579241
  var valid_579242 = query.getOrDefault("alt")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = newJString("json"))
  if valid_579242 != nil:
    section.add "alt", valid_579242
  var valid_579243 = query.getOrDefault("uploadType")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "uploadType", valid_579243
  var valid_579244 = query.getOrDefault("quotaUser")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "quotaUser", valid_579244
  var valid_579245 = query.getOrDefault("callback")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "callback", valid_579245
  var valid_579246 = query.getOrDefault("fields")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "fields", valid_579246
  var valid_579247 = query.getOrDefault("access_token")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "access_token", valid_579247
  var valid_579248 = query.getOrDefault("upload_protocol")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "upload_protocol", valid_579248
  var valid_579249 = query.getOrDefault("view")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_579249 != nil:
    section.add "view", valid_579249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579250: Call_DataflowProjectsLocationsJobsGet_579232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the state of the specified Cloud Dataflow job.
  ## 
  ## To get the state of a job, we recommend using `projects.locations.jobs.get`
  ## with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.get` is not recommended, as you can only get the state of
  ## jobs that are running in `us-central1`.
  ## 
  let valid = call_579250.validator(path, query, header, formData, body)
  let scheme = call_579250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579250.url(scheme.get, call_579250.host, call_579250.base,
                         call_579250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579250, url, valid)

proc call*(call_579251: Call_DataflowProjectsLocationsJobsGet_579232;
          projectId: string; jobId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; view: string = "JOB_VIEW_UNKNOWN"): Recallable =
  ## dataflowProjectsLocationsJobsGet
  ## Gets the state of the specified Cloud Dataflow job.
  ## 
  ## To get the state of a job, we recommend using `projects.locations.jobs.get`
  ## with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.get` is not recommended, as you can only get the state of
  ## jobs that are running in `us-central1`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   jobId: string (required)
  ##        : The job ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : The level of information requested in response.
  var path_579252 = newJObject()
  var query_579253 = newJObject()
  add(query_579253, "key", newJString(key))
  add(query_579253, "prettyPrint", newJBool(prettyPrint))
  add(query_579253, "oauth_token", newJString(oauthToken))
  add(path_579252, "projectId", newJString(projectId))
  add(path_579252, "jobId", newJString(jobId))
  add(query_579253, "$.xgafv", newJString(Xgafv))
  add(query_579253, "alt", newJString(alt))
  add(query_579253, "uploadType", newJString(uploadType))
  add(query_579253, "quotaUser", newJString(quotaUser))
  add(path_579252, "location", newJString(location))
  add(query_579253, "callback", newJString(callback))
  add(query_579253, "fields", newJString(fields))
  add(query_579253, "access_token", newJString(accessToken))
  add(query_579253, "upload_protocol", newJString(uploadProtocol))
  add(query_579253, "view", newJString(view))
  result = call_579251.call(path_579252, query_579253, nil, nil, nil)

var dataflowProjectsLocationsJobsGet* = Call_DataflowProjectsLocationsJobsGet_579232(
    name: "dataflowProjectsLocationsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}",
    validator: validate_DataflowProjectsLocationsJobsGet_579233, base: "/",
    url: url_DataflowProjectsLocationsJobsGet_579234, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsDebugGetConfig_579277 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsJobsDebugGetConfig_579279(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/debug/getConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsDebugGetConfig_579278(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get encoded debug configuration for component. Not cacheable.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project id.
  ##   jobId: JString (required)
  ##        : The job id.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579280 = path.getOrDefault("projectId")
  valid_579280 = validateParameter(valid_579280, JString, required = true,
                                 default = nil)
  if valid_579280 != nil:
    section.add "projectId", valid_579280
  var valid_579281 = path.getOrDefault("jobId")
  valid_579281 = validateParameter(valid_579281, JString, required = true,
                                 default = nil)
  if valid_579281 != nil:
    section.add "jobId", valid_579281
  var valid_579282 = path.getOrDefault("location")
  valid_579282 = validateParameter(valid_579282, JString, required = true,
                                 default = nil)
  if valid_579282 != nil:
    section.add "location", valid_579282
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
  var valid_579283 = query.getOrDefault("key")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "key", valid_579283
  var valid_579284 = query.getOrDefault("prettyPrint")
  valid_579284 = validateParameter(valid_579284, JBool, required = false,
                                 default = newJBool(true))
  if valid_579284 != nil:
    section.add "prettyPrint", valid_579284
  var valid_579285 = query.getOrDefault("oauth_token")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = nil)
  if valid_579285 != nil:
    section.add "oauth_token", valid_579285
  var valid_579286 = query.getOrDefault("$.xgafv")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = newJString("1"))
  if valid_579286 != nil:
    section.add "$.xgafv", valid_579286
  var valid_579287 = query.getOrDefault("alt")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = newJString("json"))
  if valid_579287 != nil:
    section.add "alt", valid_579287
  var valid_579288 = query.getOrDefault("uploadType")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "uploadType", valid_579288
  var valid_579289 = query.getOrDefault("quotaUser")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "quotaUser", valid_579289
  var valid_579290 = query.getOrDefault("callback")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "callback", valid_579290
  var valid_579291 = query.getOrDefault("fields")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "fields", valid_579291
  var valid_579292 = query.getOrDefault("access_token")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "access_token", valid_579292
  var valid_579293 = query.getOrDefault("upload_protocol")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "upload_protocol", valid_579293
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

proc call*(call_579295: Call_DataflowProjectsLocationsJobsDebugGetConfig_579277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get encoded debug configuration for component. Not cacheable.
  ## 
  let valid = call_579295.validator(path, query, header, formData, body)
  let scheme = call_579295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579295.url(scheme.get, call_579295.host, call_579295.base,
                         call_579295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579295, url, valid)

proc call*(call_579296: Call_DataflowProjectsLocationsJobsDebugGetConfig_579277;
          projectId: string; jobId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsLocationsJobsDebugGetConfig
  ## Get encoded debug configuration for component. Not cacheable.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The project id.
  ##   jobId: string (required)
  ##        : The job id.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579297 = newJObject()
  var query_579298 = newJObject()
  var body_579299 = newJObject()
  add(query_579298, "key", newJString(key))
  add(query_579298, "prettyPrint", newJBool(prettyPrint))
  add(query_579298, "oauth_token", newJString(oauthToken))
  add(path_579297, "projectId", newJString(projectId))
  add(path_579297, "jobId", newJString(jobId))
  add(query_579298, "$.xgafv", newJString(Xgafv))
  add(query_579298, "alt", newJString(alt))
  add(query_579298, "uploadType", newJString(uploadType))
  add(query_579298, "quotaUser", newJString(quotaUser))
  add(path_579297, "location", newJString(location))
  if body != nil:
    body_579299 = body
  add(query_579298, "callback", newJString(callback))
  add(query_579298, "fields", newJString(fields))
  add(query_579298, "access_token", newJString(accessToken))
  add(query_579298, "upload_protocol", newJString(uploadProtocol))
  result = call_579296.call(path_579297, query_579298, nil, nil, body_579299)

var dataflowProjectsLocationsJobsDebugGetConfig* = Call_DataflowProjectsLocationsJobsDebugGetConfig_579277(
    name: "dataflowProjectsLocationsJobsDebugGetConfig",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/debug/getConfig",
    validator: validate_DataflowProjectsLocationsJobsDebugGetConfig_579278,
    base: "/", url: url_DataflowProjectsLocationsJobsDebugGetConfig_579279,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsDebugSendCapture_579300 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsJobsDebugSendCapture_579302(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/debug/sendCapture")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsDebugSendCapture_579301(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Send encoded debug capture data for component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project id.
  ##   jobId: JString (required)
  ##        : The job id.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579303 = path.getOrDefault("projectId")
  valid_579303 = validateParameter(valid_579303, JString, required = true,
                                 default = nil)
  if valid_579303 != nil:
    section.add "projectId", valid_579303
  var valid_579304 = path.getOrDefault("jobId")
  valid_579304 = validateParameter(valid_579304, JString, required = true,
                                 default = nil)
  if valid_579304 != nil:
    section.add "jobId", valid_579304
  var valid_579305 = path.getOrDefault("location")
  valid_579305 = validateParameter(valid_579305, JString, required = true,
                                 default = nil)
  if valid_579305 != nil:
    section.add "location", valid_579305
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
  var valid_579306 = query.getOrDefault("key")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "key", valid_579306
  var valid_579307 = query.getOrDefault("prettyPrint")
  valid_579307 = validateParameter(valid_579307, JBool, required = false,
                                 default = newJBool(true))
  if valid_579307 != nil:
    section.add "prettyPrint", valid_579307
  var valid_579308 = query.getOrDefault("oauth_token")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "oauth_token", valid_579308
  var valid_579309 = query.getOrDefault("$.xgafv")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = newJString("1"))
  if valid_579309 != nil:
    section.add "$.xgafv", valid_579309
  var valid_579310 = query.getOrDefault("alt")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = newJString("json"))
  if valid_579310 != nil:
    section.add "alt", valid_579310
  var valid_579311 = query.getOrDefault("uploadType")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "uploadType", valid_579311
  var valid_579312 = query.getOrDefault("quotaUser")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "quotaUser", valid_579312
  var valid_579313 = query.getOrDefault("callback")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "callback", valid_579313
  var valid_579314 = query.getOrDefault("fields")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "fields", valid_579314
  var valid_579315 = query.getOrDefault("access_token")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "access_token", valid_579315
  var valid_579316 = query.getOrDefault("upload_protocol")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "upload_protocol", valid_579316
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

proc call*(call_579318: Call_DataflowProjectsLocationsJobsDebugSendCapture_579300;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send encoded debug capture data for component.
  ## 
  let valid = call_579318.validator(path, query, header, formData, body)
  let scheme = call_579318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579318.url(scheme.get, call_579318.host, call_579318.base,
                         call_579318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579318, url, valid)

proc call*(call_579319: Call_DataflowProjectsLocationsJobsDebugSendCapture_579300;
          projectId: string; jobId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsLocationsJobsDebugSendCapture
  ## Send encoded debug capture data for component.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The project id.
  ##   jobId: string (required)
  ##        : The job id.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579320 = newJObject()
  var query_579321 = newJObject()
  var body_579322 = newJObject()
  add(query_579321, "key", newJString(key))
  add(query_579321, "prettyPrint", newJBool(prettyPrint))
  add(query_579321, "oauth_token", newJString(oauthToken))
  add(path_579320, "projectId", newJString(projectId))
  add(path_579320, "jobId", newJString(jobId))
  add(query_579321, "$.xgafv", newJString(Xgafv))
  add(query_579321, "alt", newJString(alt))
  add(query_579321, "uploadType", newJString(uploadType))
  add(query_579321, "quotaUser", newJString(quotaUser))
  add(path_579320, "location", newJString(location))
  if body != nil:
    body_579322 = body
  add(query_579321, "callback", newJString(callback))
  add(query_579321, "fields", newJString(fields))
  add(query_579321, "access_token", newJString(accessToken))
  add(query_579321, "upload_protocol", newJString(uploadProtocol))
  result = call_579319.call(path_579320, query_579321, nil, nil, body_579322)

var dataflowProjectsLocationsJobsDebugSendCapture* = Call_DataflowProjectsLocationsJobsDebugSendCapture_579300(
    name: "dataflowProjectsLocationsJobsDebugSendCapture",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/debug/sendCapture",
    validator: validate_DataflowProjectsLocationsJobsDebugSendCapture_579301,
    base: "/", url: url_DataflowProjectsLocationsJobsDebugSendCapture_579302,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsMessagesList_579323 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsJobsMessagesList_579325(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsMessagesList_579324(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.messages.list` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.messages.list` is not recommended, as you can only request
  ## the status of jobs that are running in `us-central1`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A project id.
  ##   jobId: JString (required)
  ##        : The job to get messages about.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579326 = path.getOrDefault("projectId")
  valid_579326 = validateParameter(valid_579326, JString, required = true,
                                 default = nil)
  if valid_579326 != nil:
    section.add "projectId", valid_579326
  var valid_579327 = path.getOrDefault("jobId")
  valid_579327 = validateParameter(valid_579327, JString, required = true,
                                 default = nil)
  if valid_579327 != nil:
    section.add "jobId", valid_579327
  var valid_579328 = path.getOrDefault("location")
  valid_579328 = validateParameter(valid_579328, JString, required = true,
                                 default = nil)
  if valid_579328 != nil:
    section.add "location", valid_579328
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   minimumImportance: JString
  ##                    : Filter to only get messages with importance >= level
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : If specified, determines the maximum number of messages to
  ## return.  If unspecified, the service may choose an appropriate
  ## default, or may return an arbitrarily large number of results.
  ##   startTime: JString
  ##            : If specified, return only messages with timestamps >= start_time.
  ## The default is the job creation time (i.e. beginning of messages).
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : If supplied, this should be the value of next_page_token returned
  ## by an earlier call. This will cause the next page of results to
  ## be returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   endTime: JString
  ##          : Return only messages with timestamps < end_time. The default is now
  ## (i.e. return up to the latest messages available).
  section = newJObject()
  var valid_579329 = query.getOrDefault("key")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = nil)
  if valid_579329 != nil:
    section.add "key", valid_579329
  var valid_579330 = query.getOrDefault("prettyPrint")
  valid_579330 = validateParameter(valid_579330, JBool, required = false,
                                 default = newJBool(true))
  if valid_579330 != nil:
    section.add "prettyPrint", valid_579330
  var valid_579331 = query.getOrDefault("oauth_token")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "oauth_token", valid_579331
  var valid_579332 = query.getOrDefault("minimumImportance")
  valid_579332 = validateParameter(valid_579332, JString, required = false, default = newJString(
      "JOB_MESSAGE_IMPORTANCE_UNKNOWN"))
  if valid_579332 != nil:
    section.add "minimumImportance", valid_579332
  var valid_579333 = query.getOrDefault("$.xgafv")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = newJString("1"))
  if valid_579333 != nil:
    section.add "$.xgafv", valid_579333
  var valid_579334 = query.getOrDefault("pageSize")
  valid_579334 = validateParameter(valid_579334, JInt, required = false, default = nil)
  if valid_579334 != nil:
    section.add "pageSize", valid_579334
  var valid_579335 = query.getOrDefault("startTime")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "startTime", valid_579335
  var valid_579336 = query.getOrDefault("alt")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = newJString("json"))
  if valid_579336 != nil:
    section.add "alt", valid_579336
  var valid_579337 = query.getOrDefault("uploadType")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "uploadType", valid_579337
  var valid_579338 = query.getOrDefault("quotaUser")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "quotaUser", valid_579338
  var valid_579339 = query.getOrDefault("pageToken")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "pageToken", valid_579339
  var valid_579340 = query.getOrDefault("callback")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "callback", valid_579340
  var valid_579341 = query.getOrDefault("fields")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "fields", valid_579341
  var valid_579342 = query.getOrDefault("access_token")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "access_token", valid_579342
  var valid_579343 = query.getOrDefault("upload_protocol")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "upload_protocol", valid_579343
  var valid_579344 = query.getOrDefault("endTime")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "endTime", valid_579344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579345: Call_DataflowProjectsLocationsJobsMessagesList_579323;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.messages.list` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.messages.list` is not recommended, as you can only request
  ## the status of jobs that are running in `us-central1`.
  ## 
  let valid = call_579345.validator(path, query, header, formData, body)
  let scheme = call_579345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579345.url(scheme.get, call_579345.host, call_579345.base,
                         call_579345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579345, url, valid)

proc call*(call_579346: Call_DataflowProjectsLocationsJobsMessagesList_579323;
          projectId: string; jobId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          minimumImportance: string = "JOB_MESSAGE_IMPORTANCE_UNKNOWN";
          Xgafv: string = "1"; pageSize: int = 0; startTime: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; endTime: string = ""): Recallable =
  ## dataflowProjectsLocationsJobsMessagesList
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.messages.list` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.messages.list` is not recommended, as you can only request
  ## the status of jobs that are running in `us-central1`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   minimumImportance: string
  ##                    : Filter to only get messages with importance >= level
  ##   projectId: string (required)
  ##            : A project id.
  ##   jobId: string (required)
  ##        : The job to get messages about.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : If specified, determines the maximum number of messages to
  ## return.  If unspecified, the service may choose an appropriate
  ## default, or may return an arbitrarily large number of results.
  ##   startTime: string
  ##            : If specified, return only messages with timestamps >= start_time.
  ## The default is the job creation time (i.e. beginning of messages).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : If supplied, this should be the value of next_page_token returned
  ## by an earlier call. This will cause the next page of results to
  ## be returned.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   endTime: string
  ##          : Return only messages with timestamps < end_time. The default is now
  ## (i.e. return up to the latest messages available).
  var path_579347 = newJObject()
  var query_579348 = newJObject()
  add(query_579348, "key", newJString(key))
  add(query_579348, "prettyPrint", newJBool(prettyPrint))
  add(query_579348, "oauth_token", newJString(oauthToken))
  add(query_579348, "minimumImportance", newJString(minimumImportance))
  add(path_579347, "projectId", newJString(projectId))
  add(path_579347, "jobId", newJString(jobId))
  add(query_579348, "$.xgafv", newJString(Xgafv))
  add(query_579348, "pageSize", newJInt(pageSize))
  add(query_579348, "startTime", newJString(startTime))
  add(query_579348, "alt", newJString(alt))
  add(query_579348, "uploadType", newJString(uploadType))
  add(query_579348, "quotaUser", newJString(quotaUser))
  add(query_579348, "pageToken", newJString(pageToken))
  add(path_579347, "location", newJString(location))
  add(query_579348, "callback", newJString(callback))
  add(query_579348, "fields", newJString(fields))
  add(query_579348, "access_token", newJString(accessToken))
  add(query_579348, "upload_protocol", newJString(uploadProtocol))
  add(query_579348, "endTime", newJString(endTime))
  result = call_579346.call(path_579347, query_579348, nil, nil, nil)

var dataflowProjectsLocationsJobsMessagesList* = Call_DataflowProjectsLocationsJobsMessagesList_579323(
    name: "dataflowProjectsLocationsJobsMessagesList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/messages",
    validator: validate_DataflowProjectsLocationsJobsMessagesList_579324,
    base: "/", url: url_DataflowProjectsLocationsJobsMessagesList_579325,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsGetMetrics_579349 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsJobsGetMetrics_579351(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsGetMetrics_579350(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.getMetrics` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.getMetrics` is not recommended, as you can only request the
  ## status of jobs that are running in `us-central1`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : A project id.
  ##   jobId: JString (required)
  ##        : The job to get messages for.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579352 = path.getOrDefault("projectId")
  valid_579352 = validateParameter(valid_579352, JString, required = true,
                                 default = nil)
  if valid_579352 != nil:
    section.add "projectId", valid_579352
  var valid_579353 = path.getOrDefault("jobId")
  valid_579353 = validateParameter(valid_579353, JString, required = true,
                                 default = nil)
  if valid_579353 != nil:
    section.add "jobId", valid_579353
  var valid_579354 = path.getOrDefault("location")
  valid_579354 = validateParameter(valid_579354, JString, required = true,
                                 default = nil)
  if valid_579354 != nil:
    section.add "location", valid_579354
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
  ##   startTime: JString
  ##            : Return only metric data that has changed since this time.
  ## Default is to return all information about all metrics for the job.
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
  var valid_579355 = query.getOrDefault("key")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "key", valid_579355
  var valid_579356 = query.getOrDefault("prettyPrint")
  valid_579356 = validateParameter(valid_579356, JBool, required = false,
                                 default = newJBool(true))
  if valid_579356 != nil:
    section.add "prettyPrint", valid_579356
  var valid_579357 = query.getOrDefault("oauth_token")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "oauth_token", valid_579357
  var valid_579358 = query.getOrDefault("$.xgafv")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = newJString("1"))
  if valid_579358 != nil:
    section.add "$.xgafv", valid_579358
  var valid_579359 = query.getOrDefault("startTime")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "startTime", valid_579359
  var valid_579360 = query.getOrDefault("alt")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = newJString("json"))
  if valid_579360 != nil:
    section.add "alt", valid_579360
  var valid_579361 = query.getOrDefault("uploadType")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "uploadType", valid_579361
  var valid_579362 = query.getOrDefault("quotaUser")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "quotaUser", valid_579362
  var valid_579363 = query.getOrDefault("callback")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "callback", valid_579363
  var valid_579364 = query.getOrDefault("fields")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "fields", valid_579364
  var valid_579365 = query.getOrDefault("access_token")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "access_token", valid_579365
  var valid_579366 = query.getOrDefault("upload_protocol")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "upload_protocol", valid_579366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579367: Call_DataflowProjectsLocationsJobsGetMetrics_579349;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.getMetrics` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.getMetrics` is not recommended, as you can only request the
  ## status of jobs that are running in `us-central1`.
  ## 
  let valid = call_579367.validator(path, query, header, formData, body)
  let scheme = call_579367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579367.url(scheme.get, call_579367.host, call_579367.base,
                         call_579367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579367, url, valid)

proc call*(call_579368: Call_DataflowProjectsLocationsJobsGetMetrics_579349;
          projectId: string; jobId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          startTime: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsLocationsJobsGetMetrics
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.getMetrics` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.getMetrics` is not recommended, as you can only request the
  ## status of jobs that are running in `us-central1`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : A project id.
  ##   jobId: string (required)
  ##        : The job to get messages for.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   startTime: string
  ##            : Return only metric data that has changed since this time.
  ## Default is to return all information about all metrics for the job.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579369 = newJObject()
  var query_579370 = newJObject()
  add(query_579370, "key", newJString(key))
  add(query_579370, "prettyPrint", newJBool(prettyPrint))
  add(query_579370, "oauth_token", newJString(oauthToken))
  add(path_579369, "projectId", newJString(projectId))
  add(path_579369, "jobId", newJString(jobId))
  add(query_579370, "$.xgafv", newJString(Xgafv))
  add(query_579370, "startTime", newJString(startTime))
  add(query_579370, "alt", newJString(alt))
  add(query_579370, "uploadType", newJString(uploadType))
  add(query_579370, "quotaUser", newJString(quotaUser))
  add(path_579369, "location", newJString(location))
  add(query_579370, "callback", newJString(callback))
  add(query_579370, "fields", newJString(fields))
  add(query_579370, "access_token", newJString(accessToken))
  add(query_579370, "upload_protocol", newJString(uploadProtocol))
  result = call_579368.call(path_579369, query_579370, nil, nil, nil)

var dataflowProjectsLocationsJobsGetMetrics* = Call_DataflowProjectsLocationsJobsGetMetrics_579349(
    name: "dataflowProjectsLocationsJobsGetMetrics", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/metrics",
    validator: validate_DataflowProjectsLocationsJobsGetMetrics_579350, base: "/",
    url: url_DataflowProjectsLocationsJobsGetMetrics_579351,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsWorkItemsLease_579371 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsJobsWorkItemsLease_579373(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/workItems:lease")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsWorkItemsLease_579372(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Leases a dataflow WorkItem to run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Identifies the project this worker belongs to.
  ##   jobId: JString (required)
  ##        : Identifies the workflow job this worker belongs to.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the WorkItem's job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579374 = path.getOrDefault("projectId")
  valid_579374 = validateParameter(valid_579374, JString, required = true,
                                 default = nil)
  if valid_579374 != nil:
    section.add "projectId", valid_579374
  var valid_579375 = path.getOrDefault("jobId")
  valid_579375 = validateParameter(valid_579375, JString, required = true,
                                 default = nil)
  if valid_579375 != nil:
    section.add "jobId", valid_579375
  var valid_579376 = path.getOrDefault("location")
  valid_579376 = validateParameter(valid_579376, JString, required = true,
                                 default = nil)
  if valid_579376 != nil:
    section.add "location", valid_579376
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
  var valid_579377 = query.getOrDefault("key")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "key", valid_579377
  var valid_579378 = query.getOrDefault("prettyPrint")
  valid_579378 = validateParameter(valid_579378, JBool, required = false,
                                 default = newJBool(true))
  if valid_579378 != nil:
    section.add "prettyPrint", valid_579378
  var valid_579379 = query.getOrDefault("oauth_token")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "oauth_token", valid_579379
  var valid_579380 = query.getOrDefault("$.xgafv")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = newJString("1"))
  if valid_579380 != nil:
    section.add "$.xgafv", valid_579380
  var valid_579381 = query.getOrDefault("alt")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = newJString("json"))
  if valid_579381 != nil:
    section.add "alt", valid_579381
  var valid_579382 = query.getOrDefault("uploadType")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "uploadType", valid_579382
  var valid_579383 = query.getOrDefault("quotaUser")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "quotaUser", valid_579383
  var valid_579384 = query.getOrDefault("callback")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "callback", valid_579384
  var valid_579385 = query.getOrDefault("fields")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "fields", valid_579385
  var valid_579386 = query.getOrDefault("access_token")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "access_token", valid_579386
  var valid_579387 = query.getOrDefault("upload_protocol")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = nil)
  if valid_579387 != nil:
    section.add "upload_protocol", valid_579387
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

proc call*(call_579389: Call_DataflowProjectsLocationsJobsWorkItemsLease_579371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Leases a dataflow WorkItem to run.
  ## 
  let valid = call_579389.validator(path, query, header, formData, body)
  let scheme = call_579389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579389.url(scheme.get, call_579389.host, call_579389.base,
                         call_579389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579389, url, valid)

proc call*(call_579390: Call_DataflowProjectsLocationsJobsWorkItemsLease_579371;
          projectId: string; jobId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsLocationsJobsWorkItemsLease
  ## Leases a dataflow WorkItem to run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Identifies the project this worker belongs to.
  ##   jobId: string (required)
  ##        : Identifies the workflow job this worker belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the WorkItem's job.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579391 = newJObject()
  var query_579392 = newJObject()
  var body_579393 = newJObject()
  add(query_579392, "key", newJString(key))
  add(query_579392, "prettyPrint", newJBool(prettyPrint))
  add(query_579392, "oauth_token", newJString(oauthToken))
  add(path_579391, "projectId", newJString(projectId))
  add(path_579391, "jobId", newJString(jobId))
  add(query_579392, "$.xgafv", newJString(Xgafv))
  add(query_579392, "alt", newJString(alt))
  add(query_579392, "uploadType", newJString(uploadType))
  add(query_579392, "quotaUser", newJString(quotaUser))
  add(path_579391, "location", newJString(location))
  if body != nil:
    body_579393 = body
  add(query_579392, "callback", newJString(callback))
  add(query_579392, "fields", newJString(fields))
  add(query_579392, "access_token", newJString(accessToken))
  add(query_579392, "upload_protocol", newJString(uploadProtocol))
  result = call_579390.call(path_579391, query_579392, nil, nil, body_579393)

var dataflowProjectsLocationsJobsWorkItemsLease* = Call_DataflowProjectsLocationsJobsWorkItemsLease_579371(
    name: "dataflowProjectsLocationsJobsWorkItemsLease",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/workItems:lease",
    validator: validate_DataflowProjectsLocationsJobsWorkItemsLease_579372,
    base: "/", url: url_DataflowProjectsLocationsJobsWorkItemsLease_579373,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_579394 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsJobsWorkItemsReportStatus_579396(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/workItems:reportStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsWorkItemsReportStatus_579395(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Reports the status of dataflow WorkItems leased by a worker.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project which owns the WorkItem's job.
  ##   jobId: JString (required)
  ##        : The job which the WorkItem is part of.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the WorkItem's job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579397 = path.getOrDefault("projectId")
  valid_579397 = validateParameter(valid_579397, JString, required = true,
                                 default = nil)
  if valid_579397 != nil:
    section.add "projectId", valid_579397
  var valid_579398 = path.getOrDefault("jobId")
  valid_579398 = validateParameter(valid_579398, JString, required = true,
                                 default = nil)
  if valid_579398 != nil:
    section.add "jobId", valid_579398
  var valid_579399 = path.getOrDefault("location")
  valid_579399 = validateParameter(valid_579399, JString, required = true,
                                 default = nil)
  if valid_579399 != nil:
    section.add "location", valid_579399
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
  var valid_579400 = query.getOrDefault("key")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = nil)
  if valid_579400 != nil:
    section.add "key", valid_579400
  var valid_579401 = query.getOrDefault("prettyPrint")
  valid_579401 = validateParameter(valid_579401, JBool, required = false,
                                 default = newJBool(true))
  if valid_579401 != nil:
    section.add "prettyPrint", valid_579401
  var valid_579402 = query.getOrDefault("oauth_token")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = nil)
  if valid_579402 != nil:
    section.add "oauth_token", valid_579402
  var valid_579403 = query.getOrDefault("$.xgafv")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = newJString("1"))
  if valid_579403 != nil:
    section.add "$.xgafv", valid_579403
  var valid_579404 = query.getOrDefault("alt")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = newJString("json"))
  if valid_579404 != nil:
    section.add "alt", valid_579404
  var valid_579405 = query.getOrDefault("uploadType")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "uploadType", valid_579405
  var valid_579406 = query.getOrDefault("quotaUser")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "quotaUser", valid_579406
  var valid_579407 = query.getOrDefault("callback")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "callback", valid_579407
  var valid_579408 = query.getOrDefault("fields")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "fields", valid_579408
  var valid_579409 = query.getOrDefault("access_token")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = nil)
  if valid_579409 != nil:
    section.add "access_token", valid_579409
  var valid_579410 = query.getOrDefault("upload_protocol")
  valid_579410 = validateParameter(valid_579410, JString, required = false,
                                 default = nil)
  if valid_579410 != nil:
    section.add "upload_protocol", valid_579410
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

proc call*(call_579412: Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_579394;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports the status of dataflow WorkItems leased by a worker.
  ## 
  let valid = call_579412.validator(path, query, header, formData, body)
  let scheme = call_579412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579412.url(scheme.get, call_579412.host, call_579412.base,
                         call_579412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579412, url, valid)

proc call*(call_579413: Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_579394;
          projectId: string; jobId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsLocationsJobsWorkItemsReportStatus
  ## Reports the status of dataflow WorkItems leased by a worker.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The project which owns the WorkItem's job.
  ##   jobId: string (required)
  ##        : The job which the WorkItem is part of.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the WorkItem's job.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579414 = newJObject()
  var query_579415 = newJObject()
  var body_579416 = newJObject()
  add(query_579415, "key", newJString(key))
  add(query_579415, "prettyPrint", newJBool(prettyPrint))
  add(query_579415, "oauth_token", newJString(oauthToken))
  add(path_579414, "projectId", newJString(projectId))
  add(path_579414, "jobId", newJString(jobId))
  add(query_579415, "$.xgafv", newJString(Xgafv))
  add(query_579415, "alt", newJString(alt))
  add(query_579415, "uploadType", newJString(uploadType))
  add(query_579415, "quotaUser", newJString(quotaUser))
  add(path_579414, "location", newJString(location))
  if body != nil:
    body_579416 = body
  add(query_579415, "callback", newJString(callback))
  add(query_579415, "fields", newJString(fields))
  add(query_579415, "access_token", newJString(accessToken))
  add(query_579415, "upload_protocol", newJString(uploadProtocol))
  result = call_579413.call(path_579414, query_579415, nil, nil, body_579416)

var dataflowProjectsLocationsJobsWorkItemsReportStatus* = Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_579394(
    name: "dataflowProjectsLocationsJobsWorkItemsReportStatus",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/workItems:reportStatus",
    validator: validate_DataflowProjectsLocationsJobsWorkItemsReportStatus_579395,
    base: "/", url: url_DataflowProjectsLocationsJobsWorkItemsReportStatus_579396,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsSqlValidate_579417 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsSqlValidate_579419(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/sql:validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsSqlValidate_579418(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates a GoogleSQL query for Cloud Dataflow syntax. Will always
  ## confirm the given query parses correctly, and if able to look up
  ## schema information from DataCatalog, will validate that the query
  ## analyzes properly as well.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579420 = path.getOrDefault("projectId")
  valid_579420 = validateParameter(valid_579420, JString, required = true,
                                 default = nil)
  if valid_579420 != nil:
    section.add "projectId", valid_579420
  var valid_579421 = path.getOrDefault("location")
  valid_579421 = validateParameter(valid_579421, JString, required = true,
                                 default = nil)
  if valid_579421 != nil:
    section.add "location", valid_579421
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
  ##   query: JString
  ##        : The sql query to validate.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579422 = query.getOrDefault("key")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "key", valid_579422
  var valid_579423 = query.getOrDefault("prettyPrint")
  valid_579423 = validateParameter(valid_579423, JBool, required = false,
                                 default = newJBool(true))
  if valid_579423 != nil:
    section.add "prettyPrint", valid_579423
  var valid_579424 = query.getOrDefault("oauth_token")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "oauth_token", valid_579424
  var valid_579425 = query.getOrDefault("$.xgafv")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = newJString("1"))
  if valid_579425 != nil:
    section.add "$.xgafv", valid_579425
  var valid_579426 = query.getOrDefault("alt")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = newJString("json"))
  if valid_579426 != nil:
    section.add "alt", valid_579426
  var valid_579427 = query.getOrDefault("uploadType")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "uploadType", valid_579427
  var valid_579428 = query.getOrDefault("quotaUser")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = nil)
  if valid_579428 != nil:
    section.add "quotaUser", valid_579428
  var valid_579429 = query.getOrDefault("query")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "query", valid_579429
  var valid_579430 = query.getOrDefault("callback")
  valid_579430 = validateParameter(valid_579430, JString, required = false,
                                 default = nil)
  if valid_579430 != nil:
    section.add "callback", valid_579430
  var valid_579431 = query.getOrDefault("fields")
  valid_579431 = validateParameter(valid_579431, JString, required = false,
                                 default = nil)
  if valid_579431 != nil:
    section.add "fields", valid_579431
  var valid_579432 = query.getOrDefault("access_token")
  valid_579432 = validateParameter(valid_579432, JString, required = false,
                                 default = nil)
  if valid_579432 != nil:
    section.add "access_token", valid_579432
  var valid_579433 = query.getOrDefault("upload_protocol")
  valid_579433 = validateParameter(valid_579433, JString, required = false,
                                 default = nil)
  if valid_579433 != nil:
    section.add "upload_protocol", valid_579433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579434: Call_DataflowProjectsLocationsSqlValidate_579417;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates a GoogleSQL query for Cloud Dataflow syntax. Will always
  ## confirm the given query parses correctly, and if able to look up
  ## schema information from DataCatalog, will validate that the query
  ## analyzes properly as well.
  ## 
  let valid = call_579434.validator(path, query, header, formData, body)
  let scheme = call_579434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579434.url(scheme.get, call_579434.host, call_579434.base,
                         call_579434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579434, url, valid)

proc call*(call_579435: Call_DataflowProjectsLocationsSqlValidate_579417;
          projectId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          query: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsLocationsSqlValidate
  ## Validates a GoogleSQL query for Cloud Dataflow syntax. Will always
  ## confirm the given query parses correctly, and if able to look up
  ## schema information from DataCatalog, will validate that the query
  ## analyzes properly as well.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  ##   query: string
  ##        : The sql query to validate.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579436 = newJObject()
  var query_579437 = newJObject()
  add(query_579437, "key", newJString(key))
  add(query_579437, "prettyPrint", newJBool(prettyPrint))
  add(query_579437, "oauth_token", newJString(oauthToken))
  add(path_579436, "projectId", newJString(projectId))
  add(query_579437, "$.xgafv", newJString(Xgafv))
  add(query_579437, "alt", newJString(alt))
  add(query_579437, "uploadType", newJString(uploadType))
  add(query_579437, "quotaUser", newJString(quotaUser))
  add(path_579436, "location", newJString(location))
  add(query_579437, "query", newJString(query))
  add(query_579437, "callback", newJString(callback))
  add(query_579437, "fields", newJString(fields))
  add(query_579437, "access_token", newJString(accessToken))
  add(query_579437, "upload_protocol", newJString(uploadProtocol))
  result = call_579435.call(path_579436, query_579437, nil, nil, nil)

var dataflowProjectsLocationsSqlValidate* = Call_DataflowProjectsLocationsSqlValidate_579417(
    name: "dataflowProjectsLocationsSqlValidate", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/sql:validate",
    validator: validate_DataflowProjectsLocationsSqlValidate_579418, base: "/",
    url: url_DataflowProjectsLocationsSqlValidate_579419, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesCreate_579438 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsTemplatesCreate_579440(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/templates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsTemplatesCreate_579439(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Cloud Dataflow job from a template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579441 = path.getOrDefault("projectId")
  valid_579441 = validateParameter(valid_579441, JString, required = true,
                                 default = nil)
  if valid_579441 != nil:
    section.add "projectId", valid_579441
  var valid_579442 = path.getOrDefault("location")
  valid_579442 = validateParameter(valid_579442, JString, required = true,
                                 default = nil)
  if valid_579442 != nil:
    section.add "location", valid_579442
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
  var valid_579443 = query.getOrDefault("key")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "key", valid_579443
  var valid_579444 = query.getOrDefault("prettyPrint")
  valid_579444 = validateParameter(valid_579444, JBool, required = false,
                                 default = newJBool(true))
  if valid_579444 != nil:
    section.add "prettyPrint", valid_579444
  var valid_579445 = query.getOrDefault("oauth_token")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "oauth_token", valid_579445
  var valid_579446 = query.getOrDefault("$.xgafv")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = newJString("1"))
  if valid_579446 != nil:
    section.add "$.xgafv", valid_579446
  var valid_579447 = query.getOrDefault("alt")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = newJString("json"))
  if valid_579447 != nil:
    section.add "alt", valid_579447
  var valid_579448 = query.getOrDefault("uploadType")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "uploadType", valid_579448
  var valid_579449 = query.getOrDefault("quotaUser")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "quotaUser", valid_579449
  var valid_579450 = query.getOrDefault("callback")
  valid_579450 = validateParameter(valid_579450, JString, required = false,
                                 default = nil)
  if valid_579450 != nil:
    section.add "callback", valid_579450
  var valid_579451 = query.getOrDefault("fields")
  valid_579451 = validateParameter(valid_579451, JString, required = false,
                                 default = nil)
  if valid_579451 != nil:
    section.add "fields", valid_579451
  var valid_579452 = query.getOrDefault("access_token")
  valid_579452 = validateParameter(valid_579452, JString, required = false,
                                 default = nil)
  if valid_579452 != nil:
    section.add "access_token", valid_579452
  var valid_579453 = query.getOrDefault("upload_protocol")
  valid_579453 = validateParameter(valid_579453, JString, required = false,
                                 default = nil)
  if valid_579453 != nil:
    section.add "upload_protocol", valid_579453
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

proc call*(call_579455: Call_DataflowProjectsLocationsTemplatesCreate_579438;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job from a template.
  ## 
  let valid = call_579455.validator(path, query, header, formData, body)
  let scheme = call_579455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579455.url(scheme.get, call_579455.host, call_579455.base,
                         call_579455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579455, url, valid)

proc call*(call_579456: Call_DataflowProjectsLocationsTemplatesCreate_579438;
          projectId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsLocationsTemplatesCreate
  ## Creates a Cloud Dataflow job from a template.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579457 = newJObject()
  var query_579458 = newJObject()
  var body_579459 = newJObject()
  add(query_579458, "key", newJString(key))
  add(query_579458, "prettyPrint", newJBool(prettyPrint))
  add(query_579458, "oauth_token", newJString(oauthToken))
  add(path_579457, "projectId", newJString(projectId))
  add(query_579458, "$.xgafv", newJString(Xgafv))
  add(query_579458, "alt", newJString(alt))
  add(query_579458, "uploadType", newJString(uploadType))
  add(query_579458, "quotaUser", newJString(quotaUser))
  add(path_579457, "location", newJString(location))
  if body != nil:
    body_579459 = body
  add(query_579458, "callback", newJString(callback))
  add(query_579458, "fields", newJString(fields))
  add(query_579458, "access_token", newJString(accessToken))
  add(query_579458, "upload_protocol", newJString(uploadProtocol))
  result = call_579456.call(path_579457, query_579458, nil, nil, body_579459)

var dataflowProjectsLocationsTemplatesCreate* = Call_DataflowProjectsLocationsTemplatesCreate_579438(
    name: "dataflowProjectsLocationsTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates",
    validator: validate_DataflowProjectsLocationsTemplatesCreate_579439,
    base: "/", url: url_DataflowProjectsLocationsTemplatesCreate_579440,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesGet_579460 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsTemplatesGet_579462(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/templates:get")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsTemplatesGet_579461(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the template associated with a template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579463 = path.getOrDefault("projectId")
  valid_579463 = validateParameter(valid_579463, JString, required = true,
                                 default = nil)
  if valid_579463 != nil:
    section.add "projectId", valid_579463
  var valid_579464 = path.getOrDefault("location")
  valid_579464 = validateParameter(valid_579464, JString, required = true,
                                 default = nil)
  if valid_579464 != nil:
    section.add "location", valid_579464
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
  ##   gcsPath: JString
  ##          : Required. A Cloud Storage path to the template from which to
  ## create the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : The view to retrieve. Defaults to METADATA_ONLY.
  section = newJObject()
  var valid_579465 = query.getOrDefault("key")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = nil)
  if valid_579465 != nil:
    section.add "key", valid_579465
  var valid_579466 = query.getOrDefault("prettyPrint")
  valid_579466 = validateParameter(valid_579466, JBool, required = false,
                                 default = newJBool(true))
  if valid_579466 != nil:
    section.add "prettyPrint", valid_579466
  var valid_579467 = query.getOrDefault("oauth_token")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "oauth_token", valid_579467
  var valid_579468 = query.getOrDefault("$.xgafv")
  valid_579468 = validateParameter(valid_579468, JString, required = false,
                                 default = newJString("1"))
  if valid_579468 != nil:
    section.add "$.xgafv", valid_579468
  var valid_579469 = query.getOrDefault("alt")
  valid_579469 = validateParameter(valid_579469, JString, required = false,
                                 default = newJString("json"))
  if valid_579469 != nil:
    section.add "alt", valid_579469
  var valid_579470 = query.getOrDefault("uploadType")
  valid_579470 = validateParameter(valid_579470, JString, required = false,
                                 default = nil)
  if valid_579470 != nil:
    section.add "uploadType", valid_579470
  var valid_579471 = query.getOrDefault("quotaUser")
  valid_579471 = validateParameter(valid_579471, JString, required = false,
                                 default = nil)
  if valid_579471 != nil:
    section.add "quotaUser", valid_579471
  var valid_579472 = query.getOrDefault("gcsPath")
  valid_579472 = validateParameter(valid_579472, JString, required = false,
                                 default = nil)
  if valid_579472 != nil:
    section.add "gcsPath", valid_579472
  var valid_579473 = query.getOrDefault("callback")
  valid_579473 = validateParameter(valid_579473, JString, required = false,
                                 default = nil)
  if valid_579473 != nil:
    section.add "callback", valid_579473
  var valid_579474 = query.getOrDefault("fields")
  valid_579474 = validateParameter(valid_579474, JString, required = false,
                                 default = nil)
  if valid_579474 != nil:
    section.add "fields", valid_579474
  var valid_579475 = query.getOrDefault("access_token")
  valid_579475 = validateParameter(valid_579475, JString, required = false,
                                 default = nil)
  if valid_579475 != nil:
    section.add "access_token", valid_579475
  var valid_579476 = query.getOrDefault("upload_protocol")
  valid_579476 = validateParameter(valid_579476, JString, required = false,
                                 default = nil)
  if valid_579476 != nil:
    section.add "upload_protocol", valid_579476
  var valid_579477 = query.getOrDefault("view")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = newJString("METADATA_ONLY"))
  if valid_579477 != nil:
    section.add "view", valid_579477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579478: Call_DataflowProjectsLocationsTemplatesGet_579460;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the template associated with a template.
  ## 
  let valid = call_579478.validator(path, query, header, formData, body)
  let scheme = call_579478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579478.url(scheme.get, call_579478.host, call_579478.base,
                         call_579478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579478, url, valid)

proc call*(call_579479: Call_DataflowProjectsLocationsTemplatesGet_579460;
          projectId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          gcsPath: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          view: string = "METADATA_ONLY"): Recallable =
  ## dataflowProjectsLocationsTemplatesGet
  ## Get the template associated with a template.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  ##   gcsPath: string
  ##          : Required. A Cloud Storage path to the template from which to
  ## create the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : The view to retrieve. Defaults to METADATA_ONLY.
  var path_579480 = newJObject()
  var query_579481 = newJObject()
  add(query_579481, "key", newJString(key))
  add(query_579481, "prettyPrint", newJBool(prettyPrint))
  add(query_579481, "oauth_token", newJString(oauthToken))
  add(path_579480, "projectId", newJString(projectId))
  add(query_579481, "$.xgafv", newJString(Xgafv))
  add(query_579481, "alt", newJString(alt))
  add(query_579481, "uploadType", newJString(uploadType))
  add(query_579481, "quotaUser", newJString(quotaUser))
  add(path_579480, "location", newJString(location))
  add(query_579481, "gcsPath", newJString(gcsPath))
  add(query_579481, "callback", newJString(callback))
  add(query_579481, "fields", newJString(fields))
  add(query_579481, "access_token", newJString(accessToken))
  add(query_579481, "upload_protocol", newJString(uploadProtocol))
  add(query_579481, "view", newJString(view))
  result = call_579479.call(path_579480, query_579481, nil, nil, nil)

var dataflowProjectsLocationsTemplatesGet* = Call_DataflowProjectsLocationsTemplatesGet_579460(
    name: "dataflowProjectsLocationsTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates:get",
    validator: validate_DataflowProjectsLocationsTemplatesGet_579461, base: "/",
    url: url_DataflowProjectsLocationsTemplatesGet_579462, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesLaunch_579482 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsLocationsTemplatesLaunch_579484(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/templates:launch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsTemplatesLaunch_579483(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Launch a template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579485 = path.getOrDefault("projectId")
  valid_579485 = validateParameter(valid_579485, JString, required = true,
                                 default = nil)
  if valid_579485 != nil:
    section.add "projectId", valid_579485
  var valid_579486 = path.getOrDefault("location")
  valid_579486 = validateParameter(valid_579486, JString, required = true,
                                 default = nil)
  if valid_579486 != nil:
    section.add "location", valid_579486
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   dynamicTemplate.gcsPath: JString
  ##                          : Path to dynamic template spec file on GCS.
  ## The file must be a Json serialized DynamicTemplateFieSpec object.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   validateOnly: JBool
  ##               : If true, the request is validated but not actually executed.
  ## Defaults to false.
  ##   gcsPath: JString
  ##          : A Cloud Storage path to the template from which to create
  ## the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   dynamicTemplate.stagingLocation: JString
  ##                                  : Cloud Storage path for staging dependencies.
  ## Must be a valid Cloud Storage URL, beginning with `gs://`.
  section = newJObject()
  var valid_579487 = query.getOrDefault("key")
  valid_579487 = validateParameter(valid_579487, JString, required = false,
                                 default = nil)
  if valid_579487 != nil:
    section.add "key", valid_579487
  var valid_579488 = query.getOrDefault("prettyPrint")
  valid_579488 = validateParameter(valid_579488, JBool, required = false,
                                 default = newJBool(true))
  if valid_579488 != nil:
    section.add "prettyPrint", valid_579488
  var valid_579489 = query.getOrDefault("oauth_token")
  valid_579489 = validateParameter(valid_579489, JString, required = false,
                                 default = nil)
  if valid_579489 != nil:
    section.add "oauth_token", valid_579489
  var valid_579490 = query.getOrDefault("dynamicTemplate.gcsPath")
  valid_579490 = validateParameter(valid_579490, JString, required = false,
                                 default = nil)
  if valid_579490 != nil:
    section.add "dynamicTemplate.gcsPath", valid_579490
  var valid_579491 = query.getOrDefault("$.xgafv")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = newJString("1"))
  if valid_579491 != nil:
    section.add "$.xgafv", valid_579491
  var valid_579492 = query.getOrDefault("alt")
  valid_579492 = validateParameter(valid_579492, JString, required = false,
                                 default = newJString("json"))
  if valid_579492 != nil:
    section.add "alt", valid_579492
  var valid_579493 = query.getOrDefault("uploadType")
  valid_579493 = validateParameter(valid_579493, JString, required = false,
                                 default = nil)
  if valid_579493 != nil:
    section.add "uploadType", valid_579493
  var valid_579494 = query.getOrDefault("quotaUser")
  valid_579494 = validateParameter(valid_579494, JString, required = false,
                                 default = nil)
  if valid_579494 != nil:
    section.add "quotaUser", valid_579494
  var valid_579495 = query.getOrDefault("validateOnly")
  valid_579495 = validateParameter(valid_579495, JBool, required = false, default = nil)
  if valid_579495 != nil:
    section.add "validateOnly", valid_579495
  var valid_579496 = query.getOrDefault("gcsPath")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = nil)
  if valid_579496 != nil:
    section.add "gcsPath", valid_579496
  var valid_579497 = query.getOrDefault("callback")
  valid_579497 = validateParameter(valid_579497, JString, required = false,
                                 default = nil)
  if valid_579497 != nil:
    section.add "callback", valid_579497
  var valid_579498 = query.getOrDefault("fields")
  valid_579498 = validateParameter(valid_579498, JString, required = false,
                                 default = nil)
  if valid_579498 != nil:
    section.add "fields", valid_579498
  var valid_579499 = query.getOrDefault("access_token")
  valid_579499 = validateParameter(valid_579499, JString, required = false,
                                 default = nil)
  if valid_579499 != nil:
    section.add "access_token", valid_579499
  var valid_579500 = query.getOrDefault("upload_protocol")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "upload_protocol", valid_579500
  var valid_579501 = query.getOrDefault("dynamicTemplate.stagingLocation")
  valid_579501 = validateParameter(valid_579501, JString, required = false,
                                 default = nil)
  if valid_579501 != nil:
    section.add "dynamicTemplate.stagingLocation", valid_579501
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

proc call*(call_579503: Call_DataflowProjectsLocationsTemplatesLaunch_579482;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Launch a template.
  ## 
  let valid = call_579503.validator(path, query, header, formData, body)
  let scheme = call_579503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579503.url(scheme.get, call_579503.host, call_579503.base,
                         call_579503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579503, url, valid)

proc call*(call_579504: Call_DataflowProjectsLocationsTemplatesLaunch_579482;
          projectId: string; location: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          dynamicTemplateGcsPath: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          validateOnly: bool = false; body: JsonNode = nil; gcsPath: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; dynamicTemplateStagingLocation: string = ""): Recallable =
  ## dataflowProjectsLocationsTemplatesLaunch
  ## Launch a template.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   dynamicTemplateGcsPath: string
  ##                         : Path to dynamic template spec file on GCS.
  ## The file must be a Json serialized DynamicTemplateFieSpec object.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  ##   validateOnly: bool
  ##               : If true, the request is validated but not actually executed.
  ## Defaults to false.
  ##   body: JObject
  ##   gcsPath: string
  ##          : A Cloud Storage path to the template from which to create
  ## the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   dynamicTemplateStagingLocation: string
  ##                                 : Cloud Storage path for staging dependencies.
  ## Must be a valid Cloud Storage URL, beginning with `gs://`.
  var path_579505 = newJObject()
  var query_579506 = newJObject()
  var body_579507 = newJObject()
  add(query_579506, "key", newJString(key))
  add(query_579506, "prettyPrint", newJBool(prettyPrint))
  add(query_579506, "oauth_token", newJString(oauthToken))
  add(path_579505, "projectId", newJString(projectId))
  add(query_579506, "dynamicTemplate.gcsPath", newJString(dynamicTemplateGcsPath))
  add(query_579506, "$.xgafv", newJString(Xgafv))
  add(query_579506, "alt", newJString(alt))
  add(query_579506, "uploadType", newJString(uploadType))
  add(query_579506, "quotaUser", newJString(quotaUser))
  add(path_579505, "location", newJString(location))
  add(query_579506, "validateOnly", newJBool(validateOnly))
  if body != nil:
    body_579507 = body
  add(query_579506, "gcsPath", newJString(gcsPath))
  add(query_579506, "callback", newJString(callback))
  add(query_579506, "fields", newJString(fields))
  add(query_579506, "access_token", newJString(accessToken))
  add(query_579506, "upload_protocol", newJString(uploadProtocol))
  add(query_579506, "dynamicTemplate.stagingLocation",
      newJString(dynamicTemplateStagingLocation))
  result = call_579504.call(path_579505, query_579506, nil, nil, body_579507)

var dataflowProjectsLocationsTemplatesLaunch* = Call_DataflowProjectsLocationsTemplatesLaunch_579482(
    name: "dataflowProjectsLocationsTemplatesLaunch", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates:launch",
    validator: validate_DataflowProjectsLocationsTemplatesLaunch_579483,
    base: "/", url: url_DataflowProjectsLocationsTemplatesLaunch_579484,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesCreate_579508 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsTemplatesCreate_579510(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/templates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsTemplatesCreate_579509(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Cloud Dataflow job from a template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579511 = path.getOrDefault("projectId")
  valid_579511 = validateParameter(valid_579511, JString, required = true,
                                 default = nil)
  if valid_579511 != nil:
    section.add "projectId", valid_579511
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
  var valid_579512 = query.getOrDefault("key")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "key", valid_579512
  var valid_579513 = query.getOrDefault("prettyPrint")
  valid_579513 = validateParameter(valid_579513, JBool, required = false,
                                 default = newJBool(true))
  if valid_579513 != nil:
    section.add "prettyPrint", valid_579513
  var valid_579514 = query.getOrDefault("oauth_token")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "oauth_token", valid_579514
  var valid_579515 = query.getOrDefault("$.xgafv")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = newJString("1"))
  if valid_579515 != nil:
    section.add "$.xgafv", valid_579515
  var valid_579516 = query.getOrDefault("alt")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = newJString("json"))
  if valid_579516 != nil:
    section.add "alt", valid_579516
  var valid_579517 = query.getOrDefault("uploadType")
  valid_579517 = validateParameter(valid_579517, JString, required = false,
                                 default = nil)
  if valid_579517 != nil:
    section.add "uploadType", valid_579517
  var valid_579518 = query.getOrDefault("quotaUser")
  valid_579518 = validateParameter(valid_579518, JString, required = false,
                                 default = nil)
  if valid_579518 != nil:
    section.add "quotaUser", valid_579518
  var valid_579519 = query.getOrDefault("callback")
  valid_579519 = validateParameter(valid_579519, JString, required = false,
                                 default = nil)
  if valid_579519 != nil:
    section.add "callback", valid_579519
  var valid_579520 = query.getOrDefault("fields")
  valid_579520 = validateParameter(valid_579520, JString, required = false,
                                 default = nil)
  if valid_579520 != nil:
    section.add "fields", valid_579520
  var valid_579521 = query.getOrDefault("access_token")
  valid_579521 = validateParameter(valid_579521, JString, required = false,
                                 default = nil)
  if valid_579521 != nil:
    section.add "access_token", valid_579521
  var valid_579522 = query.getOrDefault("upload_protocol")
  valid_579522 = validateParameter(valid_579522, JString, required = false,
                                 default = nil)
  if valid_579522 != nil:
    section.add "upload_protocol", valid_579522
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

proc call*(call_579524: Call_DataflowProjectsTemplatesCreate_579508;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job from a template.
  ## 
  let valid = call_579524.validator(path, query, header, formData, body)
  let scheme = call_579524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579524.url(scheme.get, call_579524.host, call_579524.base,
                         call_579524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579524, url, valid)

proc call*(call_579525: Call_DataflowProjectsTemplatesCreate_579508;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dataflowProjectsTemplatesCreate
  ## Creates a Cloud Dataflow job from a template.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579526 = newJObject()
  var query_579527 = newJObject()
  var body_579528 = newJObject()
  add(query_579527, "key", newJString(key))
  add(query_579527, "prettyPrint", newJBool(prettyPrint))
  add(query_579527, "oauth_token", newJString(oauthToken))
  add(path_579526, "projectId", newJString(projectId))
  add(query_579527, "$.xgafv", newJString(Xgafv))
  add(query_579527, "alt", newJString(alt))
  add(query_579527, "uploadType", newJString(uploadType))
  add(query_579527, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579528 = body
  add(query_579527, "callback", newJString(callback))
  add(query_579527, "fields", newJString(fields))
  add(query_579527, "access_token", newJString(accessToken))
  add(query_579527, "upload_protocol", newJString(uploadProtocol))
  result = call_579525.call(path_579526, query_579527, nil, nil, body_579528)

var dataflowProjectsTemplatesCreate* = Call_DataflowProjectsTemplatesCreate_579508(
    name: "dataflowProjectsTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates",
    validator: validate_DataflowProjectsTemplatesCreate_579509, base: "/",
    url: url_DataflowProjectsTemplatesCreate_579510, schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesGet_579529 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsTemplatesGet_579531(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/templates:get")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsTemplatesGet_579530(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the template associated with a template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579532 = path.getOrDefault("projectId")
  valid_579532 = validateParameter(valid_579532, JString, required = true,
                                 default = nil)
  if valid_579532 != nil:
    section.add "projectId", valid_579532
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
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  ##   gcsPath: JString
  ##          : Required. A Cloud Storage path to the template from which to
  ## create the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : The view to retrieve. Defaults to METADATA_ONLY.
  section = newJObject()
  var valid_579533 = query.getOrDefault("key")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = nil)
  if valid_579533 != nil:
    section.add "key", valid_579533
  var valid_579534 = query.getOrDefault("prettyPrint")
  valid_579534 = validateParameter(valid_579534, JBool, required = false,
                                 default = newJBool(true))
  if valid_579534 != nil:
    section.add "prettyPrint", valid_579534
  var valid_579535 = query.getOrDefault("oauth_token")
  valid_579535 = validateParameter(valid_579535, JString, required = false,
                                 default = nil)
  if valid_579535 != nil:
    section.add "oauth_token", valid_579535
  var valid_579536 = query.getOrDefault("$.xgafv")
  valid_579536 = validateParameter(valid_579536, JString, required = false,
                                 default = newJString("1"))
  if valid_579536 != nil:
    section.add "$.xgafv", valid_579536
  var valid_579537 = query.getOrDefault("alt")
  valid_579537 = validateParameter(valid_579537, JString, required = false,
                                 default = newJString("json"))
  if valid_579537 != nil:
    section.add "alt", valid_579537
  var valid_579538 = query.getOrDefault("uploadType")
  valid_579538 = validateParameter(valid_579538, JString, required = false,
                                 default = nil)
  if valid_579538 != nil:
    section.add "uploadType", valid_579538
  var valid_579539 = query.getOrDefault("quotaUser")
  valid_579539 = validateParameter(valid_579539, JString, required = false,
                                 default = nil)
  if valid_579539 != nil:
    section.add "quotaUser", valid_579539
  var valid_579540 = query.getOrDefault("location")
  valid_579540 = validateParameter(valid_579540, JString, required = false,
                                 default = nil)
  if valid_579540 != nil:
    section.add "location", valid_579540
  var valid_579541 = query.getOrDefault("gcsPath")
  valid_579541 = validateParameter(valid_579541, JString, required = false,
                                 default = nil)
  if valid_579541 != nil:
    section.add "gcsPath", valid_579541
  var valid_579542 = query.getOrDefault("callback")
  valid_579542 = validateParameter(valid_579542, JString, required = false,
                                 default = nil)
  if valid_579542 != nil:
    section.add "callback", valid_579542
  var valid_579543 = query.getOrDefault("fields")
  valid_579543 = validateParameter(valid_579543, JString, required = false,
                                 default = nil)
  if valid_579543 != nil:
    section.add "fields", valid_579543
  var valid_579544 = query.getOrDefault("access_token")
  valid_579544 = validateParameter(valid_579544, JString, required = false,
                                 default = nil)
  if valid_579544 != nil:
    section.add "access_token", valid_579544
  var valid_579545 = query.getOrDefault("upload_protocol")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = nil)
  if valid_579545 != nil:
    section.add "upload_protocol", valid_579545
  var valid_579546 = query.getOrDefault("view")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = newJString("METADATA_ONLY"))
  if valid_579546 != nil:
    section.add "view", valid_579546
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579547: Call_DataflowProjectsTemplatesGet_579529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the template associated with a template.
  ## 
  let valid = call_579547.validator(path, query, header, formData, body)
  let scheme = call_579547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579547.url(scheme.get, call_579547.host, call_579547.base,
                         call_579547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579547, url, valid)

proc call*(call_579548: Call_DataflowProjectsTemplatesGet_579529;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; location: string = "";
          gcsPath: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          view: string = "METADATA_ONLY"): Recallable =
  ## dataflowProjectsTemplatesGet
  ## Get the template associated with a template.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  ##   gcsPath: string
  ##          : Required. A Cloud Storage path to the template from which to
  ## create the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : The view to retrieve. Defaults to METADATA_ONLY.
  var path_579549 = newJObject()
  var query_579550 = newJObject()
  add(query_579550, "key", newJString(key))
  add(query_579550, "prettyPrint", newJBool(prettyPrint))
  add(query_579550, "oauth_token", newJString(oauthToken))
  add(path_579549, "projectId", newJString(projectId))
  add(query_579550, "$.xgafv", newJString(Xgafv))
  add(query_579550, "alt", newJString(alt))
  add(query_579550, "uploadType", newJString(uploadType))
  add(query_579550, "quotaUser", newJString(quotaUser))
  add(query_579550, "location", newJString(location))
  add(query_579550, "gcsPath", newJString(gcsPath))
  add(query_579550, "callback", newJString(callback))
  add(query_579550, "fields", newJString(fields))
  add(query_579550, "access_token", newJString(accessToken))
  add(query_579550, "upload_protocol", newJString(uploadProtocol))
  add(query_579550, "view", newJString(view))
  result = call_579548.call(path_579549, query_579550, nil, nil, nil)

var dataflowProjectsTemplatesGet* = Call_DataflowProjectsTemplatesGet_579529(
    name: "dataflowProjectsTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates:get",
    validator: validate_DataflowProjectsTemplatesGet_579530, base: "/",
    url: url_DataflowProjectsTemplatesGet_579531, schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesLaunch_579551 = ref object of OpenApiRestCall_578348
proc url_DataflowProjectsTemplatesLaunch_579553(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1b3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/templates:launch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataflowProjectsTemplatesLaunch_579552(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Launch a template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579554 = path.getOrDefault("projectId")
  valid_579554 = validateParameter(valid_579554, JString, required = true,
                                 default = nil)
  if valid_579554 != nil:
    section.add "projectId", valid_579554
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   dynamicTemplate.gcsPath: JString
  ##                          : Path to dynamic template spec file on GCS.
  ## The file must be a Json serialized DynamicTemplateFieSpec object.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   validateOnly: JBool
  ##               : If true, the request is validated but not actually executed.
  ## Defaults to false.
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  ##   gcsPath: JString
  ##          : A Cloud Storage path to the template from which to create
  ## the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   dynamicTemplate.stagingLocation: JString
  ##                                  : Cloud Storage path for staging dependencies.
  ## Must be a valid Cloud Storage URL, beginning with `gs://`.
  section = newJObject()
  var valid_579555 = query.getOrDefault("key")
  valid_579555 = validateParameter(valid_579555, JString, required = false,
                                 default = nil)
  if valid_579555 != nil:
    section.add "key", valid_579555
  var valid_579556 = query.getOrDefault("prettyPrint")
  valid_579556 = validateParameter(valid_579556, JBool, required = false,
                                 default = newJBool(true))
  if valid_579556 != nil:
    section.add "prettyPrint", valid_579556
  var valid_579557 = query.getOrDefault("oauth_token")
  valid_579557 = validateParameter(valid_579557, JString, required = false,
                                 default = nil)
  if valid_579557 != nil:
    section.add "oauth_token", valid_579557
  var valid_579558 = query.getOrDefault("dynamicTemplate.gcsPath")
  valid_579558 = validateParameter(valid_579558, JString, required = false,
                                 default = nil)
  if valid_579558 != nil:
    section.add "dynamicTemplate.gcsPath", valid_579558
  var valid_579559 = query.getOrDefault("$.xgafv")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = newJString("1"))
  if valid_579559 != nil:
    section.add "$.xgafv", valid_579559
  var valid_579560 = query.getOrDefault("alt")
  valid_579560 = validateParameter(valid_579560, JString, required = false,
                                 default = newJString("json"))
  if valid_579560 != nil:
    section.add "alt", valid_579560
  var valid_579561 = query.getOrDefault("uploadType")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "uploadType", valid_579561
  var valid_579562 = query.getOrDefault("quotaUser")
  valid_579562 = validateParameter(valid_579562, JString, required = false,
                                 default = nil)
  if valid_579562 != nil:
    section.add "quotaUser", valid_579562
  var valid_579563 = query.getOrDefault("validateOnly")
  valid_579563 = validateParameter(valid_579563, JBool, required = false, default = nil)
  if valid_579563 != nil:
    section.add "validateOnly", valid_579563
  var valid_579564 = query.getOrDefault("location")
  valid_579564 = validateParameter(valid_579564, JString, required = false,
                                 default = nil)
  if valid_579564 != nil:
    section.add "location", valid_579564
  var valid_579565 = query.getOrDefault("gcsPath")
  valid_579565 = validateParameter(valid_579565, JString, required = false,
                                 default = nil)
  if valid_579565 != nil:
    section.add "gcsPath", valid_579565
  var valid_579566 = query.getOrDefault("callback")
  valid_579566 = validateParameter(valid_579566, JString, required = false,
                                 default = nil)
  if valid_579566 != nil:
    section.add "callback", valid_579566
  var valid_579567 = query.getOrDefault("fields")
  valid_579567 = validateParameter(valid_579567, JString, required = false,
                                 default = nil)
  if valid_579567 != nil:
    section.add "fields", valid_579567
  var valid_579568 = query.getOrDefault("access_token")
  valid_579568 = validateParameter(valid_579568, JString, required = false,
                                 default = nil)
  if valid_579568 != nil:
    section.add "access_token", valid_579568
  var valid_579569 = query.getOrDefault("upload_protocol")
  valid_579569 = validateParameter(valid_579569, JString, required = false,
                                 default = nil)
  if valid_579569 != nil:
    section.add "upload_protocol", valid_579569
  var valid_579570 = query.getOrDefault("dynamicTemplate.stagingLocation")
  valid_579570 = validateParameter(valid_579570, JString, required = false,
                                 default = nil)
  if valid_579570 != nil:
    section.add "dynamicTemplate.stagingLocation", valid_579570
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

proc call*(call_579572: Call_DataflowProjectsTemplatesLaunch_579551;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Launch a template.
  ## 
  let valid = call_579572.validator(path, query, header, formData, body)
  let scheme = call_579572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579572.url(scheme.get, call_579572.host, call_579572.base,
                         call_579572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579572, url, valid)

proc call*(call_579573: Call_DataflowProjectsTemplatesLaunch_579551;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; dynamicTemplateGcsPath: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; validateOnly: bool = false; location: string = "";
          body: JsonNode = nil; gcsPath: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          dynamicTemplateStagingLocation: string = ""): Recallable =
  ## dataflowProjectsTemplatesLaunch
  ## Launch a template.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   dynamicTemplateGcsPath: string
  ##                         : Path to dynamic template spec file on GCS.
  ## The file must be a Json serialized DynamicTemplateFieSpec object.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   validateOnly: bool
  ##               : If true, the request is validated but not actually executed.
  ## Defaults to false.
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  ##   body: JObject
  ##   gcsPath: string
  ##          : A Cloud Storage path to the template from which to create
  ## the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   dynamicTemplateStagingLocation: string
  ##                                 : Cloud Storage path for staging dependencies.
  ## Must be a valid Cloud Storage URL, beginning with `gs://`.
  var path_579574 = newJObject()
  var query_579575 = newJObject()
  var body_579576 = newJObject()
  add(query_579575, "key", newJString(key))
  add(query_579575, "prettyPrint", newJBool(prettyPrint))
  add(query_579575, "oauth_token", newJString(oauthToken))
  add(path_579574, "projectId", newJString(projectId))
  add(query_579575, "dynamicTemplate.gcsPath", newJString(dynamicTemplateGcsPath))
  add(query_579575, "$.xgafv", newJString(Xgafv))
  add(query_579575, "alt", newJString(alt))
  add(query_579575, "uploadType", newJString(uploadType))
  add(query_579575, "quotaUser", newJString(quotaUser))
  add(query_579575, "validateOnly", newJBool(validateOnly))
  add(query_579575, "location", newJString(location))
  if body != nil:
    body_579576 = body
  add(query_579575, "gcsPath", newJString(gcsPath))
  add(query_579575, "callback", newJString(callback))
  add(query_579575, "fields", newJString(fields))
  add(query_579575, "access_token", newJString(accessToken))
  add(query_579575, "upload_protocol", newJString(uploadProtocol))
  add(query_579575, "dynamicTemplate.stagingLocation",
      newJString(dynamicTemplateStagingLocation))
  result = call_579573.call(path_579574, query_579575, nil, nil, body_579576)

var dataflowProjectsTemplatesLaunch* = Call_DataflowProjectsTemplatesLaunch_579551(
    name: "dataflowProjectsTemplatesLaunch", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates:launch",
    validator: validate_DataflowProjectsTemplatesLaunch_579552, base: "/",
    url: url_DataflowProjectsTemplatesLaunch_579553, schemes: {Scheme.Https})
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
