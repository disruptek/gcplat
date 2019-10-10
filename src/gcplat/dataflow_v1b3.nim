
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "dataflow"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DataflowProjectsWorkerMessages_588719 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsWorkerMessages_588721(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsWorkerMessages_588720(path: JsonNode;
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
  var valid_588847 = path.getOrDefault("projectId")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "projectId", valid_588847
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
  var valid_588848 = query.getOrDefault("upload_protocol")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "upload_protocol", valid_588848
  var valid_588849 = query.getOrDefault("fields")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "fields", valid_588849
  var valid_588850 = query.getOrDefault("quotaUser")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "quotaUser", valid_588850
  var valid_588864 = query.getOrDefault("alt")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = newJString("json"))
  if valid_588864 != nil:
    section.add "alt", valid_588864
  var valid_588865 = query.getOrDefault("oauth_token")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "oauth_token", valid_588865
  var valid_588866 = query.getOrDefault("callback")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "callback", valid_588866
  var valid_588867 = query.getOrDefault("access_token")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "access_token", valid_588867
  var valid_588868 = query.getOrDefault("uploadType")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "uploadType", valid_588868
  var valid_588869 = query.getOrDefault("key")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "key", valid_588869
  var valid_588870 = query.getOrDefault("$.xgafv")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = newJString("1"))
  if valid_588870 != nil:
    section.add "$.xgafv", valid_588870
  var valid_588871 = query.getOrDefault("prettyPrint")
  valid_588871 = validateParameter(valid_588871, JBool, required = false,
                                 default = newJBool(true))
  if valid_588871 != nil:
    section.add "prettyPrint", valid_588871
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

proc call*(call_588895: Call_DataflowProjectsWorkerMessages_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send a worker_message to the service.
  ## 
  let valid = call_588895.validator(path, query, header, formData, body)
  let scheme = call_588895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588895.url(scheme.get, call_588895.host, call_588895.base,
                         call_588895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588895, url, valid)

proc call*(call_588966: Call_DataflowProjectsWorkerMessages_588719;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dataflowProjectsWorkerMessages
  ## Send a worker_message to the service.
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
  ##   projectId: string (required)
  ##            : The project to send the WorkerMessages to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_588967 = newJObject()
  var query_588969 = newJObject()
  var body_588970 = newJObject()
  add(query_588969, "upload_protocol", newJString(uploadProtocol))
  add(query_588969, "fields", newJString(fields))
  add(query_588969, "quotaUser", newJString(quotaUser))
  add(query_588969, "alt", newJString(alt))
  add(query_588969, "oauth_token", newJString(oauthToken))
  add(query_588969, "callback", newJString(callback))
  add(query_588969, "access_token", newJString(accessToken))
  add(query_588969, "uploadType", newJString(uploadType))
  add(query_588969, "key", newJString(key))
  add(path_588967, "projectId", newJString(projectId))
  add(query_588969, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588970 = body
  add(query_588969, "prettyPrint", newJBool(prettyPrint))
  result = call_588966.call(path_588967, query_588969, nil, nil, body_588970)

var dataflowProjectsWorkerMessages* = Call_DataflowProjectsWorkerMessages_588719(
    name: "dataflowProjectsWorkerMessages", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/WorkerMessages",
    validator: validate_DataflowProjectsWorkerMessages_588720, base: "/",
    url: url_DataflowProjectsWorkerMessages_588721, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsCreate_589033 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsJobsCreate_589035(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsCreate_589034(path: JsonNode; query: JsonNode;
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
  var valid_589036 = path.getOrDefault("projectId")
  valid_589036 = validateParameter(valid_589036, JString, required = true,
                                 default = nil)
  if valid_589036 != nil:
    section.add "projectId", valid_589036
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : The level of information requested in response.
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
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   replaceJobId: JString
  ##               : Deprecated. This field is now in the Job message.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589037 = query.getOrDefault("upload_protocol")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "upload_protocol", valid_589037
  var valid_589038 = query.getOrDefault("fields")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "fields", valid_589038
  var valid_589039 = query.getOrDefault("view")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_589039 != nil:
    section.add "view", valid_589039
  var valid_589040 = query.getOrDefault("quotaUser")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "quotaUser", valid_589040
  var valid_589041 = query.getOrDefault("alt")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = newJString("json"))
  if valid_589041 != nil:
    section.add "alt", valid_589041
  var valid_589042 = query.getOrDefault("oauth_token")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "oauth_token", valid_589042
  var valid_589043 = query.getOrDefault("callback")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "callback", valid_589043
  var valid_589044 = query.getOrDefault("access_token")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "access_token", valid_589044
  var valid_589045 = query.getOrDefault("uploadType")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "uploadType", valid_589045
  var valid_589046 = query.getOrDefault("location")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "location", valid_589046
  var valid_589047 = query.getOrDefault("replaceJobId")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "replaceJobId", valid_589047
  var valid_589048 = query.getOrDefault("key")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "key", valid_589048
  var valid_589049 = query.getOrDefault("$.xgafv")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = newJString("1"))
  if valid_589049 != nil:
    section.add "$.xgafv", valid_589049
  var valid_589050 = query.getOrDefault("prettyPrint")
  valid_589050 = validateParameter(valid_589050, JBool, required = false,
                                 default = newJBool(true))
  if valid_589050 != nil:
    section.add "prettyPrint", valid_589050
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

proc call*(call_589052: Call_DataflowProjectsJobsCreate_589033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job.
  ## 
  ## To create a job, we recommend using `projects.locations.jobs.create` with a
  ## [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.create` is not recommended, as your job will always start
  ## in `us-central1`.
  ## 
  let valid = call_589052.validator(path, query, header, formData, body)
  let scheme = call_589052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589052.url(scheme.get, call_589052.host, call_589052.base,
                         call_589052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589052, url, valid)

proc call*(call_589053: Call_DataflowProjectsJobsCreate_589033; projectId: string;
          uploadProtocol: string = ""; fields: string = "";
          view: string = "JOB_VIEW_UNKNOWN"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; location: string = "";
          replaceJobId: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsJobsCreate
  ## Creates a Cloud Dataflow job.
  ## 
  ## To create a job, we recommend using `projects.locations.jobs.create` with a
  ## [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.create` is not recommended, as your job will always start
  ## in `us-central1`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : The level of information requested in response.
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
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   replaceJobId: string
  ##               : Deprecated. This field is now in the Job message.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589054 = newJObject()
  var query_589055 = newJObject()
  var body_589056 = newJObject()
  add(query_589055, "upload_protocol", newJString(uploadProtocol))
  add(query_589055, "fields", newJString(fields))
  add(query_589055, "view", newJString(view))
  add(query_589055, "quotaUser", newJString(quotaUser))
  add(query_589055, "alt", newJString(alt))
  add(query_589055, "oauth_token", newJString(oauthToken))
  add(query_589055, "callback", newJString(callback))
  add(query_589055, "access_token", newJString(accessToken))
  add(query_589055, "uploadType", newJString(uploadType))
  add(query_589055, "location", newJString(location))
  add(query_589055, "replaceJobId", newJString(replaceJobId))
  add(query_589055, "key", newJString(key))
  add(path_589054, "projectId", newJString(projectId))
  add(query_589055, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589056 = body
  add(query_589055, "prettyPrint", newJBool(prettyPrint))
  result = call_589053.call(path_589054, query_589055, nil, nil, body_589056)

var dataflowProjectsJobsCreate* = Call_DataflowProjectsJobsCreate_589033(
    name: "dataflowProjectsJobsCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/jobs",
    validator: validate_DataflowProjectsJobsCreate_589034, base: "/",
    url: url_DataflowProjectsJobsCreate_589035, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsList_589009 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsJobsList_589011(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsList_589010(path: JsonNode; query: JsonNode;
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
  var valid_589012 = path.getOrDefault("projectId")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "projectId", valid_589012
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Set this to the 'next_page_token' field of a previous response
  ## to request additional results in a long list.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Level of information requested in response. Default is `JOB_VIEW_SUMMARY`.
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
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : If there are many jobs, limit response to at most this many.
  ## The actual number of jobs returned will be the lesser of max_responses
  ## and an unspecified server-defined limit.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The kind of filter to use.
  section = newJObject()
  var valid_589013 = query.getOrDefault("upload_protocol")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "upload_protocol", valid_589013
  var valid_589014 = query.getOrDefault("fields")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "fields", valid_589014
  var valid_589015 = query.getOrDefault("pageToken")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "pageToken", valid_589015
  var valid_589016 = query.getOrDefault("quotaUser")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "quotaUser", valid_589016
  var valid_589017 = query.getOrDefault("view")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_589017 != nil:
    section.add "view", valid_589017
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
  var valid_589020 = query.getOrDefault("callback")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "callback", valid_589020
  var valid_589021 = query.getOrDefault("access_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "access_token", valid_589021
  var valid_589022 = query.getOrDefault("uploadType")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "uploadType", valid_589022
  var valid_589023 = query.getOrDefault("location")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "location", valid_589023
  var valid_589024 = query.getOrDefault("key")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "key", valid_589024
  var valid_589025 = query.getOrDefault("$.xgafv")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = newJString("1"))
  if valid_589025 != nil:
    section.add "$.xgafv", valid_589025
  var valid_589026 = query.getOrDefault("pageSize")
  valid_589026 = validateParameter(valid_589026, JInt, required = false, default = nil)
  if valid_589026 != nil:
    section.add "pageSize", valid_589026
  var valid_589027 = query.getOrDefault("prettyPrint")
  valid_589027 = validateParameter(valid_589027, JBool, required = false,
                                 default = newJBool(true))
  if valid_589027 != nil:
    section.add "prettyPrint", valid_589027
  var valid_589028 = query.getOrDefault("filter")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_589028 != nil:
    section.add "filter", valid_589028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589029: Call_DataflowProjectsJobsList_589009; path: JsonNode;
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
  let valid = call_589029.validator(path, query, header, formData, body)
  let scheme = call_589029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589029.url(scheme.get, call_589029.host, call_589029.base,
                         call_589029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589029, url, valid)

proc call*(call_589030: Call_DataflowProjectsJobsList_589009; projectId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; view: string = "JOB_VIEW_UNKNOWN";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; location: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = "UNKNOWN"): Recallable =
  ## dataflowProjectsJobsList
  ## List the jobs of a project.
  ## 
  ## To list the jobs of a project in a region, we recommend using
  ## `projects.locations.jobs.get` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). To
  ## list the all jobs across all regions, use `projects.jobs.aggregated`. Using
  ## `projects.jobs.list` is not recommended, as you can only get the list of
  ## jobs that are running in `us-central1`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Set this to the 'next_page_token' field of a previous response
  ## to request additional results in a long list.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Level of information requested in response. Default is `JOB_VIEW_SUMMARY`.
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
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The project which owns the jobs.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : If there are many jobs, limit response to at most this many.
  ## The actual number of jobs returned will be the lesser of max_responses
  ## and an unspecified server-defined limit.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The kind of filter to use.
  var path_589031 = newJObject()
  var query_589032 = newJObject()
  add(query_589032, "upload_protocol", newJString(uploadProtocol))
  add(query_589032, "fields", newJString(fields))
  add(query_589032, "pageToken", newJString(pageToken))
  add(query_589032, "quotaUser", newJString(quotaUser))
  add(query_589032, "view", newJString(view))
  add(query_589032, "alt", newJString(alt))
  add(query_589032, "oauth_token", newJString(oauthToken))
  add(query_589032, "callback", newJString(callback))
  add(query_589032, "access_token", newJString(accessToken))
  add(query_589032, "uploadType", newJString(uploadType))
  add(query_589032, "location", newJString(location))
  add(query_589032, "key", newJString(key))
  add(path_589031, "projectId", newJString(projectId))
  add(query_589032, "$.xgafv", newJString(Xgafv))
  add(query_589032, "pageSize", newJInt(pageSize))
  add(query_589032, "prettyPrint", newJBool(prettyPrint))
  add(query_589032, "filter", newJString(filter))
  result = call_589030.call(path_589031, query_589032, nil, nil, nil)

var dataflowProjectsJobsList* = Call_DataflowProjectsJobsList_589009(
    name: "dataflowProjectsJobsList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/jobs",
    validator: validate_DataflowProjectsJobsList_589010, base: "/",
    url: url_DataflowProjectsJobsList_589011, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsUpdate_589079 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsJobsUpdate_589081(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsUpdate_589080(path: JsonNode; query: JsonNode;
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
  ##   jobId: JString (required)
  ##        : The job ID.
  ##   projectId: JString (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589082 = path.getOrDefault("jobId")
  valid_589082 = validateParameter(valid_589082, JString, required = true,
                                 default = nil)
  if valid_589082 != nil:
    section.add "jobId", valid_589082
  var valid_589083 = path.getOrDefault("projectId")
  valid_589083 = validateParameter(valid_589083, JString, required = true,
                                 default = nil)
  if valid_589083 != nil:
    section.add "projectId", valid_589083
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
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589084 = query.getOrDefault("upload_protocol")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "upload_protocol", valid_589084
  var valid_589085 = query.getOrDefault("fields")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "fields", valid_589085
  var valid_589086 = query.getOrDefault("quotaUser")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "quotaUser", valid_589086
  var valid_589087 = query.getOrDefault("alt")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = newJString("json"))
  if valid_589087 != nil:
    section.add "alt", valid_589087
  var valid_589088 = query.getOrDefault("oauth_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "oauth_token", valid_589088
  var valid_589089 = query.getOrDefault("callback")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "callback", valid_589089
  var valid_589090 = query.getOrDefault("access_token")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "access_token", valid_589090
  var valid_589091 = query.getOrDefault("uploadType")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "uploadType", valid_589091
  var valid_589092 = query.getOrDefault("location")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "location", valid_589092
  var valid_589093 = query.getOrDefault("key")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "key", valid_589093
  var valid_589094 = query.getOrDefault("$.xgafv")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = newJString("1"))
  if valid_589094 != nil:
    section.add "$.xgafv", valid_589094
  var valid_589095 = query.getOrDefault("prettyPrint")
  valid_589095 = validateParameter(valid_589095, JBool, required = false,
                                 default = newJBool(true))
  if valid_589095 != nil:
    section.add "prettyPrint", valid_589095
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

proc call*(call_589097: Call_DataflowProjectsJobsUpdate_589079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the state of an existing Cloud Dataflow job.
  ## 
  ## To update the state of an existing job, we recommend using
  ## `projects.locations.jobs.update` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.update` is not recommended, as you can only update the state
  ## of jobs that are running in `us-central1`.
  ## 
  let valid = call_589097.validator(path, query, header, formData, body)
  let scheme = call_589097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589097.url(scheme.get, call_589097.host, call_589097.base,
                         call_589097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589097, url, valid)

proc call*(call_589098: Call_DataflowProjectsJobsUpdate_589079; jobId: string;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          location: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsJobsUpdate
  ## Updates the state of an existing Cloud Dataflow job.
  ## 
  ## To update the state of an existing job, we recommend using
  ## `projects.locations.jobs.update` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.update` is not recommended, as you can only update the state
  ## of jobs that are running in `us-central1`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The job ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589099 = newJObject()
  var query_589100 = newJObject()
  var body_589101 = newJObject()
  add(query_589100, "upload_protocol", newJString(uploadProtocol))
  add(query_589100, "fields", newJString(fields))
  add(query_589100, "quotaUser", newJString(quotaUser))
  add(query_589100, "alt", newJString(alt))
  add(path_589099, "jobId", newJString(jobId))
  add(query_589100, "oauth_token", newJString(oauthToken))
  add(query_589100, "callback", newJString(callback))
  add(query_589100, "access_token", newJString(accessToken))
  add(query_589100, "uploadType", newJString(uploadType))
  add(query_589100, "location", newJString(location))
  add(query_589100, "key", newJString(key))
  add(path_589099, "projectId", newJString(projectId))
  add(query_589100, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589101 = body
  add(query_589100, "prettyPrint", newJBool(prettyPrint))
  result = call_589098.call(path_589099, query_589100, nil, nil, body_589101)

var dataflowProjectsJobsUpdate* = Call_DataflowProjectsJobsUpdate_589079(
    name: "dataflowProjectsJobsUpdate", meth: HttpMethod.HttpPut,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataflowProjectsJobsUpdate_589080, base: "/",
    url: url_DataflowProjectsJobsUpdate_589081, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsGet_589057 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsJobsGet_589059(protocol: Scheme; host: string; base: string;
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

proc validate_DataflowProjectsJobsGet_589058(path: JsonNode; query: JsonNode;
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
  ##   jobId: JString (required)
  ##        : The job ID.
  ##   projectId: JString (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589060 = path.getOrDefault("jobId")
  valid_589060 = validateParameter(valid_589060, JString, required = true,
                                 default = nil)
  if valid_589060 != nil:
    section.add "jobId", valid_589060
  var valid_589061 = path.getOrDefault("projectId")
  valid_589061 = validateParameter(valid_589061, JString, required = true,
                                 default = nil)
  if valid_589061 != nil:
    section.add "projectId", valid_589061
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : The level of information requested in response.
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
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589062 = query.getOrDefault("upload_protocol")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "upload_protocol", valid_589062
  var valid_589063 = query.getOrDefault("fields")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "fields", valid_589063
  var valid_589064 = query.getOrDefault("view")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_589064 != nil:
    section.add "view", valid_589064
  var valid_589065 = query.getOrDefault("quotaUser")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "quotaUser", valid_589065
  var valid_589066 = query.getOrDefault("alt")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = newJString("json"))
  if valid_589066 != nil:
    section.add "alt", valid_589066
  var valid_589067 = query.getOrDefault("oauth_token")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "oauth_token", valid_589067
  var valid_589068 = query.getOrDefault("callback")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "callback", valid_589068
  var valid_589069 = query.getOrDefault("access_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "access_token", valid_589069
  var valid_589070 = query.getOrDefault("uploadType")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "uploadType", valid_589070
  var valid_589071 = query.getOrDefault("location")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "location", valid_589071
  var valid_589072 = query.getOrDefault("key")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "key", valid_589072
  var valid_589073 = query.getOrDefault("$.xgafv")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = newJString("1"))
  if valid_589073 != nil:
    section.add "$.xgafv", valid_589073
  var valid_589074 = query.getOrDefault("prettyPrint")
  valid_589074 = validateParameter(valid_589074, JBool, required = false,
                                 default = newJBool(true))
  if valid_589074 != nil:
    section.add "prettyPrint", valid_589074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589075: Call_DataflowProjectsJobsGet_589057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the state of the specified Cloud Dataflow job.
  ## 
  ## To get the state of a job, we recommend using `projects.locations.jobs.get`
  ## with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.get` is not recommended, as you can only get the state of
  ## jobs that are running in `us-central1`.
  ## 
  let valid = call_589075.validator(path, query, header, formData, body)
  let scheme = call_589075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589075.url(scheme.get, call_589075.host, call_589075.base,
                         call_589075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589075, url, valid)

proc call*(call_589076: Call_DataflowProjectsJobsGet_589057; jobId: string;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          view: string = "JOB_VIEW_UNKNOWN"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; location: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsJobsGet
  ## Gets the state of the specified Cloud Dataflow job.
  ## 
  ## To get the state of a job, we recommend using `projects.locations.jobs.get`
  ## with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.get` is not recommended, as you can only get the state of
  ## jobs that are running in `us-central1`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : The level of information requested in response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The job ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589077 = newJObject()
  var query_589078 = newJObject()
  add(query_589078, "upload_protocol", newJString(uploadProtocol))
  add(query_589078, "fields", newJString(fields))
  add(query_589078, "view", newJString(view))
  add(query_589078, "quotaUser", newJString(quotaUser))
  add(query_589078, "alt", newJString(alt))
  add(path_589077, "jobId", newJString(jobId))
  add(query_589078, "oauth_token", newJString(oauthToken))
  add(query_589078, "callback", newJString(callback))
  add(query_589078, "access_token", newJString(accessToken))
  add(query_589078, "uploadType", newJString(uploadType))
  add(query_589078, "location", newJString(location))
  add(query_589078, "key", newJString(key))
  add(path_589077, "projectId", newJString(projectId))
  add(query_589078, "$.xgafv", newJString(Xgafv))
  add(query_589078, "prettyPrint", newJBool(prettyPrint))
  result = call_589076.call(path_589077, query_589078, nil, nil, nil)

var dataflowProjectsJobsGet* = Call_DataflowProjectsJobsGet_589057(
    name: "dataflowProjectsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataflowProjectsJobsGet_589058, base: "/",
    url: url_DataflowProjectsJobsGet_589059, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsDebugGetConfig_589102 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsJobsDebugGetConfig_589104(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsDebugGetConfig_589103(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get encoded debug configuration for component. Not cacheable.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The job id.
  ##   projectId: JString (required)
  ##            : The project id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589105 = path.getOrDefault("jobId")
  valid_589105 = validateParameter(valid_589105, JString, required = true,
                                 default = nil)
  if valid_589105 != nil:
    section.add "jobId", valid_589105
  var valid_589106 = path.getOrDefault("projectId")
  valid_589106 = validateParameter(valid_589106, JString, required = true,
                                 default = nil)
  if valid_589106 != nil:
    section.add "projectId", valid_589106
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
  var valid_589107 = query.getOrDefault("upload_protocol")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "upload_protocol", valid_589107
  var valid_589108 = query.getOrDefault("fields")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "fields", valid_589108
  var valid_589109 = query.getOrDefault("quotaUser")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "quotaUser", valid_589109
  var valid_589110 = query.getOrDefault("alt")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = newJString("json"))
  if valid_589110 != nil:
    section.add "alt", valid_589110
  var valid_589111 = query.getOrDefault("oauth_token")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "oauth_token", valid_589111
  var valid_589112 = query.getOrDefault("callback")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "callback", valid_589112
  var valid_589113 = query.getOrDefault("access_token")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "access_token", valid_589113
  var valid_589114 = query.getOrDefault("uploadType")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "uploadType", valid_589114
  var valid_589115 = query.getOrDefault("key")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "key", valid_589115
  var valid_589116 = query.getOrDefault("$.xgafv")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = newJString("1"))
  if valid_589116 != nil:
    section.add "$.xgafv", valid_589116
  var valid_589117 = query.getOrDefault("prettyPrint")
  valid_589117 = validateParameter(valid_589117, JBool, required = false,
                                 default = newJBool(true))
  if valid_589117 != nil:
    section.add "prettyPrint", valid_589117
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

proc call*(call_589119: Call_DataflowProjectsJobsDebugGetConfig_589102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get encoded debug configuration for component. Not cacheable.
  ## 
  let valid = call_589119.validator(path, query, header, formData, body)
  let scheme = call_589119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589119.url(scheme.get, call_589119.host, call_589119.base,
                         call_589119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589119, url, valid)

proc call*(call_589120: Call_DataflowProjectsJobsDebugGetConfig_589102;
          jobId: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsJobsDebugGetConfig
  ## Get encoded debug configuration for component. Not cacheable.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The job id.
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
  ##   projectId: string (required)
  ##            : The project id.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589121 = newJObject()
  var query_589122 = newJObject()
  var body_589123 = newJObject()
  add(query_589122, "upload_protocol", newJString(uploadProtocol))
  add(query_589122, "fields", newJString(fields))
  add(query_589122, "quotaUser", newJString(quotaUser))
  add(query_589122, "alt", newJString(alt))
  add(path_589121, "jobId", newJString(jobId))
  add(query_589122, "oauth_token", newJString(oauthToken))
  add(query_589122, "callback", newJString(callback))
  add(query_589122, "access_token", newJString(accessToken))
  add(query_589122, "uploadType", newJString(uploadType))
  add(query_589122, "key", newJString(key))
  add(path_589121, "projectId", newJString(projectId))
  add(query_589122, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589123 = body
  add(query_589122, "prettyPrint", newJBool(prettyPrint))
  result = call_589120.call(path_589121, query_589122, nil, nil, body_589123)

var dataflowProjectsJobsDebugGetConfig* = Call_DataflowProjectsJobsDebugGetConfig_589102(
    name: "dataflowProjectsJobsDebugGetConfig", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/debug/getConfig",
    validator: validate_DataflowProjectsJobsDebugGetConfig_589103, base: "/",
    url: url_DataflowProjectsJobsDebugGetConfig_589104, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsDebugSendCapture_589124 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsJobsDebugSendCapture_589126(protocol: Scheme;
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

proc validate_DataflowProjectsJobsDebugSendCapture_589125(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Send encoded debug capture data for component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The job id.
  ##   projectId: JString (required)
  ##            : The project id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589127 = path.getOrDefault("jobId")
  valid_589127 = validateParameter(valid_589127, JString, required = true,
                                 default = nil)
  if valid_589127 != nil:
    section.add "jobId", valid_589127
  var valid_589128 = path.getOrDefault("projectId")
  valid_589128 = validateParameter(valid_589128, JString, required = true,
                                 default = nil)
  if valid_589128 != nil:
    section.add "projectId", valid_589128
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

proc call*(call_589141: Call_DataflowProjectsJobsDebugSendCapture_589124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send encoded debug capture data for component.
  ## 
  let valid = call_589141.validator(path, query, header, formData, body)
  let scheme = call_589141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589141.url(scheme.get, call_589141.host, call_589141.base,
                         call_589141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589141, url, valid)

proc call*(call_589142: Call_DataflowProjectsJobsDebugSendCapture_589124;
          jobId: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsJobsDebugSendCapture
  ## Send encoded debug capture data for component.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The job id.
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
  ##   projectId: string (required)
  ##            : The project id.
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
  add(query_589144, "alt", newJString(alt))
  add(path_589143, "jobId", newJString(jobId))
  add(query_589144, "oauth_token", newJString(oauthToken))
  add(query_589144, "callback", newJString(callback))
  add(query_589144, "access_token", newJString(accessToken))
  add(query_589144, "uploadType", newJString(uploadType))
  add(query_589144, "key", newJString(key))
  add(path_589143, "projectId", newJString(projectId))
  add(query_589144, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589145 = body
  add(query_589144, "prettyPrint", newJBool(prettyPrint))
  result = call_589142.call(path_589143, query_589144, nil, nil, body_589145)

var dataflowProjectsJobsDebugSendCapture* = Call_DataflowProjectsJobsDebugSendCapture_589124(
    name: "dataflowProjectsJobsDebugSendCapture", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/debug/sendCapture",
    validator: validate_DataflowProjectsJobsDebugSendCapture_589125, base: "/",
    url: url_DataflowProjectsJobsDebugSendCapture_589126, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsMessagesList_589146 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsJobsMessagesList_589148(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsMessagesList_589147(path: JsonNode;
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
  ##   jobId: JString (required)
  ##        : The job to get messages about.
  ##   projectId: JString (required)
  ##            : A project id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589149 = path.getOrDefault("jobId")
  valid_589149 = validateParameter(valid_589149, JString, required = true,
                                 default = nil)
  if valid_589149 != nil:
    section.add "jobId", valid_589149
  var valid_589150 = path.getOrDefault("projectId")
  valid_589150 = validateParameter(valid_589150, JString, required = true,
                                 default = nil)
  if valid_589150 != nil:
    section.add "projectId", valid_589150
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If supplied, this should be the value of next_page_token returned
  ## by an earlier call. This will cause the next page of results to
  ## be returned.
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
  ##   endTime: JString
  ##          : Return only messages with timestamps < end_time. The default is now
  ## (i.e. return up to the latest messages available).
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   minimumImportance: JString
  ##                    : Filter to only get messages with importance >= level
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : If specified, determines the maximum number of messages to
  ## return.  If unspecified, the service may choose an appropriate
  ## default, or may return an arbitrarily large number of results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: JString
  ##            : If specified, return only messages with timestamps >= start_time.
  ## The default is the job creation time (i.e. beginning of messages).
  section = newJObject()
  var valid_589151 = query.getOrDefault("upload_protocol")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "upload_protocol", valid_589151
  var valid_589152 = query.getOrDefault("fields")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "fields", valid_589152
  var valid_589153 = query.getOrDefault("pageToken")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "pageToken", valid_589153
  var valid_589154 = query.getOrDefault("quotaUser")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "quotaUser", valid_589154
  var valid_589155 = query.getOrDefault("alt")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = newJString("json"))
  if valid_589155 != nil:
    section.add "alt", valid_589155
  var valid_589156 = query.getOrDefault("oauth_token")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "oauth_token", valid_589156
  var valid_589157 = query.getOrDefault("callback")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "callback", valid_589157
  var valid_589158 = query.getOrDefault("access_token")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "access_token", valid_589158
  var valid_589159 = query.getOrDefault("uploadType")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "uploadType", valid_589159
  var valid_589160 = query.getOrDefault("endTime")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "endTime", valid_589160
  var valid_589161 = query.getOrDefault("location")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "location", valid_589161
  var valid_589162 = query.getOrDefault("key")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "key", valid_589162
  var valid_589163 = query.getOrDefault("minimumImportance")
  valid_589163 = validateParameter(valid_589163, JString, required = false, default = newJString(
      "JOB_MESSAGE_IMPORTANCE_UNKNOWN"))
  if valid_589163 != nil:
    section.add "minimumImportance", valid_589163
  var valid_589164 = query.getOrDefault("$.xgafv")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = newJString("1"))
  if valid_589164 != nil:
    section.add "$.xgafv", valid_589164
  var valid_589165 = query.getOrDefault("pageSize")
  valid_589165 = validateParameter(valid_589165, JInt, required = false, default = nil)
  if valid_589165 != nil:
    section.add "pageSize", valid_589165
  var valid_589166 = query.getOrDefault("prettyPrint")
  valid_589166 = validateParameter(valid_589166, JBool, required = false,
                                 default = newJBool(true))
  if valid_589166 != nil:
    section.add "prettyPrint", valid_589166
  var valid_589167 = query.getOrDefault("startTime")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "startTime", valid_589167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589168: Call_DataflowProjectsJobsMessagesList_589146;
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
  let valid = call_589168.validator(path, query, header, formData, body)
  let scheme = call_589168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589168.url(scheme.get, call_589168.host, call_589168.base,
                         call_589168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589168, url, valid)

proc call*(call_589169: Call_DataflowProjectsJobsMessagesList_589146;
          jobId: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; endTime: string = "";
          location: string = ""; key: string = "";
          minimumImportance: string = "JOB_MESSAGE_IMPORTANCE_UNKNOWN";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          startTime: string = ""): Recallable =
  ## dataflowProjectsJobsMessagesList
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.messages.list` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.messages.list` is not recommended, as you can only request
  ## the status of jobs that are running in `us-central1`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If supplied, this should be the value of next_page_token returned
  ## by an earlier call. This will cause the next page of results to
  ## be returned.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The job to get messages about.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   endTime: string
  ##          : Return only messages with timestamps < end_time. The default is now
  ## (i.e. return up to the latest messages available).
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   minimumImportance: string
  ##                    : Filter to only get messages with importance >= level
  ##   projectId: string (required)
  ##            : A project id.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : If specified, determines the maximum number of messages to
  ## return.  If unspecified, the service may choose an appropriate
  ## default, or may return an arbitrarily large number of results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: string
  ##            : If specified, return only messages with timestamps >= start_time.
  ## The default is the job creation time (i.e. beginning of messages).
  var path_589170 = newJObject()
  var query_589171 = newJObject()
  add(query_589171, "upload_protocol", newJString(uploadProtocol))
  add(query_589171, "fields", newJString(fields))
  add(query_589171, "pageToken", newJString(pageToken))
  add(query_589171, "quotaUser", newJString(quotaUser))
  add(query_589171, "alt", newJString(alt))
  add(path_589170, "jobId", newJString(jobId))
  add(query_589171, "oauth_token", newJString(oauthToken))
  add(query_589171, "callback", newJString(callback))
  add(query_589171, "access_token", newJString(accessToken))
  add(query_589171, "uploadType", newJString(uploadType))
  add(query_589171, "endTime", newJString(endTime))
  add(query_589171, "location", newJString(location))
  add(query_589171, "key", newJString(key))
  add(query_589171, "minimumImportance", newJString(minimumImportance))
  add(path_589170, "projectId", newJString(projectId))
  add(query_589171, "$.xgafv", newJString(Xgafv))
  add(query_589171, "pageSize", newJInt(pageSize))
  add(query_589171, "prettyPrint", newJBool(prettyPrint))
  add(query_589171, "startTime", newJString(startTime))
  result = call_589169.call(path_589170, query_589171, nil, nil, nil)

var dataflowProjectsJobsMessagesList* = Call_DataflowProjectsJobsMessagesList_589146(
    name: "dataflowProjectsJobsMessagesList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/messages",
    validator: validate_DataflowProjectsJobsMessagesList_589147, base: "/",
    url: url_DataflowProjectsJobsMessagesList_589148, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsGetMetrics_589172 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsJobsGetMetrics_589174(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsGetMetrics_589173(path: JsonNode;
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
  ##   jobId: JString (required)
  ##        : The job to get messages for.
  ##   projectId: JString (required)
  ##            : A project id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589175 = path.getOrDefault("jobId")
  valid_589175 = validateParameter(valid_589175, JString, required = true,
                                 default = nil)
  if valid_589175 != nil:
    section.add "jobId", valid_589175
  var valid_589176 = path.getOrDefault("projectId")
  valid_589176 = validateParameter(valid_589176, JString, required = true,
                                 default = nil)
  if valid_589176 != nil:
    section.add "projectId", valid_589176
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
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: JString
  ##            : Return only metric data that has changed since this time.
  ## Default is to return all information about all metrics for the job.
  section = newJObject()
  var valid_589177 = query.getOrDefault("upload_protocol")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "upload_protocol", valid_589177
  var valid_589178 = query.getOrDefault("fields")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "fields", valid_589178
  var valid_589179 = query.getOrDefault("quotaUser")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "quotaUser", valid_589179
  var valid_589180 = query.getOrDefault("alt")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = newJString("json"))
  if valid_589180 != nil:
    section.add "alt", valid_589180
  var valid_589181 = query.getOrDefault("oauth_token")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "oauth_token", valid_589181
  var valid_589182 = query.getOrDefault("callback")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "callback", valid_589182
  var valid_589183 = query.getOrDefault("access_token")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "access_token", valid_589183
  var valid_589184 = query.getOrDefault("uploadType")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "uploadType", valid_589184
  var valid_589185 = query.getOrDefault("location")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "location", valid_589185
  var valid_589186 = query.getOrDefault("key")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "key", valid_589186
  var valid_589187 = query.getOrDefault("$.xgafv")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = newJString("1"))
  if valid_589187 != nil:
    section.add "$.xgafv", valid_589187
  var valid_589188 = query.getOrDefault("prettyPrint")
  valid_589188 = validateParameter(valid_589188, JBool, required = false,
                                 default = newJBool(true))
  if valid_589188 != nil:
    section.add "prettyPrint", valid_589188
  var valid_589189 = query.getOrDefault("startTime")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "startTime", valid_589189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589190: Call_DataflowProjectsJobsGetMetrics_589172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.getMetrics` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.getMetrics` is not recommended, as you can only request the
  ## status of jobs that are running in `us-central1`.
  ## 
  let valid = call_589190.validator(path, query, header, formData, body)
  let scheme = call_589190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589190.url(scheme.get, call_589190.host, call_589190.base,
                         call_589190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589190, url, valid)

proc call*(call_589191: Call_DataflowProjectsJobsGetMetrics_589172; jobId: string;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          location: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; startTime: string = ""): Recallable =
  ## dataflowProjectsJobsGetMetrics
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.getMetrics` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.getMetrics` is not recommended, as you can only request the
  ## status of jobs that are running in `us-central1`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The job to get messages for.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : A project id.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: string
  ##            : Return only metric data that has changed since this time.
  ## Default is to return all information about all metrics for the job.
  var path_589192 = newJObject()
  var query_589193 = newJObject()
  add(query_589193, "upload_protocol", newJString(uploadProtocol))
  add(query_589193, "fields", newJString(fields))
  add(query_589193, "quotaUser", newJString(quotaUser))
  add(query_589193, "alt", newJString(alt))
  add(path_589192, "jobId", newJString(jobId))
  add(query_589193, "oauth_token", newJString(oauthToken))
  add(query_589193, "callback", newJString(callback))
  add(query_589193, "access_token", newJString(accessToken))
  add(query_589193, "uploadType", newJString(uploadType))
  add(query_589193, "location", newJString(location))
  add(query_589193, "key", newJString(key))
  add(path_589192, "projectId", newJString(projectId))
  add(query_589193, "$.xgafv", newJString(Xgafv))
  add(query_589193, "prettyPrint", newJBool(prettyPrint))
  add(query_589193, "startTime", newJString(startTime))
  result = call_589191.call(path_589192, query_589193, nil, nil, nil)

var dataflowProjectsJobsGetMetrics* = Call_DataflowProjectsJobsGetMetrics_589172(
    name: "dataflowProjectsJobsGetMetrics", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/metrics",
    validator: validate_DataflowProjectsJobsGetMetrics_589173, base: "/",
    url: url_DataflowProjectsJobsGetMetrics_589174, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsWorkItemsLease_589194 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsJobsWorkItemsLease_589196(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsWorkItemsLease_589195(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Leases a dataflow WorkItem to run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : Identifies the workflow job this worker belongs to.
  ##   projectId: JString (required)
  ##            : Identifies the project this worker belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589197 = path.getOrDefault("jobId")
  valid_589197 = validateParameter(valid_589197, JString, required = true,
                                 default = nil)
  if valid_589197 != nil:
    section.add "jobId", valid_589197
  var valid_589198 = path.getOrDefault("projectId")
  valid_589198 = validateParameter(valid_589198, JString, required = true,
                                 default = nil)
  if valid_589198 != nil:
    section.add "projectId", valid_589198
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
  var valid_589199 = query.getOrDefault("upload_protocol")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "upload_protocol", valid_589199
  var valid_589200 = query.getOrDefault("fields")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "fields", valid_589200
  var valid_589201 = query.getOrDefault("quotaUser")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "quotaUser", valid_589201
  var valid_589202 = query.getOrDefault("alt")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = newJString("json"))
  if valid_589202 != nil:
    section.add "alt", valid_589202
  var valid_589203 = query.getOrDefault("oauth_token")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "oauth_token", valid_589203
  var valid_589204 = query.getOrDefault("callback")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "callback", valid_589204
  var valid_589205 = query.getOrDefault("access_token")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "access_token", valid_589205
  var valid_589206 = query.getOrDefault("uploadType")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "uploadType", valid_589206
  var valid_589207 = query.getOrDefault("key")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "key", valid_589207
  var valid_589208 = query.getOrDefault("$.xgafv")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = newJString("1"))
  if valid_589208 != nil:
    section.add "$.xgafv", valid_589208
  var valid_589209 = query.getOrDefault("prettyPrint")
  valid_589209 = validateParameter(valid_589209, JBool, required = false,
                                 default = newJBool(true))
  if valid_589209 != nil:
    section.add "prettyPrint", valid_589209
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

proc call*(call_589211: Call_DataflowProjectsJobsWorkItemsLease_589194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Leases a dataflow WorkItem to run.
  ## 
  let valid = call_589211.validator(path, query, header, formData, body)
  let scheme = call_589211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589211.url(scheme.get, call_589211.host, call_589211.base,
                         call_589211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589211, url, valid)

proc call*(call_589212: Call_DataflowProjectsJobsWorkItemsLease_589194;
          jobId: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsJobsWorkItemsLease
  ## Leases a dataflow WorkItem to run.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : Identifies the workflow job this worker belongs to.
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
  ##   projectId: string (required)
  ##            : Identifies the project this worker belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589213 = newJObject()
  var query_589214 = newJObject()
  var body_589215 = newJObject()
  add(query_589214, "upload_protocol", newJString(uploadProtocol))
  add(query_589214, "fields", newJString(fields))
  add(query_589214, "quotaUser", newJString(quotaUser))
  add(query_589214, "alt", newJString(alt))
  add(path_589213, "jobId", newJString(jobId))
  add(query_589214, "oauth_token", newJString(oauthToken))
  add(query_589214, "callback", newJString(callback))
  add(query_589214, "access_token", newJString(accessToken))
  add(query_589214, "uploadType", newJString(uploadType))
  add(query_589214, "key", newJString(key))
  add(path_589213, "projectId", newJString(projectId))
  add(query_589214, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589215 = body
  add(query_589214, "prettyPrint", newJBool(prettyPrint))
  result = call_589212.call(path_589213, query_589214, nil, nil, body_589215)

var dataflowProjectsJobsWorkItemsLease* = Call_DataflowProjectsJobsWorkItemsLease_589194(
    name: "dataflowProjectsJobsWorkItemsLease", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/workItems:lease",
    validator: validate_DataflowProjectsJobsWorkItemsLease_589195, base: "/",
    url: url_DataflowProjectsJobsWorkItemsLease_589196, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsWorkItemsReportStatus_589216 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsJobsWorkItemsReportStatus_589218(protocol: Scheme;
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

proc validate_DataflowProjectsJobsWorkItemsReportStatus_589217(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reports the status of dataflow WorkItems leased by a worker.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The job which the WorkItem is part of.
  ##   projectId: JString (required)
  ##            : The project which owns the WorkItem's job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589219 = path.getOrDefault("jobId")
  valid_589219 = validateParameter(valid_589219, JString, required = true,
                                 default = nil)
  if valid_589219 != nil:
    section.add "jobId", valid_589219
  var valid_589220 = path.getOrDefault("projectId")
  valid_589220 = validateParameter(valid_589220, JString, required = true,
                                 default = nil)
  if valid_589220 != nil:
    section.add "projectId", valid_589220
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
  var valid_589221 = query.getOrDefault("upload_protocol")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "upload_protocol", valid_589221
  var valid_589222 = query.getOrDefault("fields")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "fields", valid_589222
  var valid_589223 = query.getOrDefault("quotaUser")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "quotaUser", valid_589223
  var valid_589224 = query.getOrDefault("alt")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = newJString("json"))
  if valid_589224 != nil:
    section.add "alt", valid_589224
  var valid_589225 = query.getOrDefault("oauth_token")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "oauth_token", valid_589225
  var valid_589226 = query.getOrDefault("callback")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "callback", valid_589226
  var valid_589227 = query.getOrDefault("access_token")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "access_token", valid_589227
  var valid_589228 = query.getOrDefault("uploadType")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "uploadType", valid_589228
  var valid_589229 = query.getOrDefault("key")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "key", valid_589229
  var valid_589230 = query.getOrDefault("$.xgafv")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = newJString("1"))
  if valid_589230 != nil:
    section.add "$.xgafv", valid_589230
  var valid_589231 = query.getOrDefault("prettyPrint")
  valid_589231 = validateParameter(valid_589231, JBool, required = false,
                                 default = newJBool(true))
  if valid_589231 != nil:
    section.add "prettyPrint", valid_589231
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

proc call*(call_589233: Call_DataflowProjectsJobsWorkItemsReportStatus_589216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports the status of dataflow WorkItems leased by a worker.
  ## 
  let valid = call_589233.validator(path, query, header, formData, body)
  let scheme = call_589233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589233.url(scheme.get, call_589233.host, call_589233.base,
                         call_589233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589233, url, valid)

proc call*(call_589234: Call_DataflowProjectsJobsWorkItemsReportStatus_589216;
          jobId: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsJobsWorkItemsReportStatus
  ## Reports the status of dataflow WorkItems leased by a worker.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The job which the WorkItem is part of.
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
  ##   projectId: string (required)
  ##            : The project which owns the WorkItem's job.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589235 = newJObject()
  var query_589236 = newJObject()
  var body_589237 = newJObject()
  add(query_589236, "upload_protocol", newJString(uploadProtocol))
  add(query_589236, "fields", newJString(fields))
  add(query_589236, "quotaUser", newJString(quotaUser))
  add(query_589236, "alt", newJString(alt))
  add(path_589235, "jobId", newJString(jobId))
  add(query_589236, "oauth_token", newJString(oauthToken))
  add(query_589236, "callback", newJString(callback))
  add(query_589236, "access_token", newJString(accessToken))
  add(query_589236, "uploadType", newJString(uploadType))
  add(query_589236, "key", newJString(key))
  add(path_589235, "projectId", newJString(projectId))
  add(query_589236, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589237 = body
  add(query_589236, "prettyPrint", newJBool(prettyPrint))
  result = call_589234.call(path_589235, query_589236, nil, nil, body_589237)

var dataflowProjectsJobsWorkItemsReportStatus* = Call_DataflowProjectsJobsWorkItemsReportStatus_589216(
    name: "dataflowProjectsJobsWorkItemsReportStatus", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/workItems:reportStatus",
    validator: validate_DataflowProjectsJobsWorkItemsReportStatus_589217,
    base: "/", url: url_DataflowProjectsJobsWorkItemsReportStatus_589218,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsAggregated_589238 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsJobsAggregated_589240(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsAggregated_589239(path: JsonNode;
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
  var valid_589241 = path.getOrDefault("projectId")
  valid_589241 = validateParameter(valid_589241, JString, required = true,
                                 default = nil)
  if valid_589241 != nil:
    section.add "projectId", valid_589241
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Set this to the 'next_page_token' field of a previous response
  ## to request additional results in a long list.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Level of information requested in response. Default is `JOB_VIEW_SUMMARY`.
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
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : If there are many jobs, limit response to at most this many.
  ## The actual number of jobs returned will be the lesser of max_responses
  ## and an unspecified server-defined limit.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The kind of filter to use.
  section = newJObject()
  var valid_589242 = query.getOrDefault("upload_protocol")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "upload_protocol", valid_589242
  var valid_589243 = query.getOrDefault("fields")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "fields", valid_589243
  var valid_589244 = query.getOrDefault("pageToken")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "pageToken", valid_589244
  var valid_589245 = query.getOrDefault("quotaUser")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "quotaUser", valid_589245
  var valid_589246 = query.getOrDefault("view")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_589246 != nil:
    section.add "view", valid_589246
  var valid_589247 = query.getOrDefault("alt")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = newJString("json"))
  if valid_589247 != nil:
    section.add "alt", valid_589247
  var valid_589248 = query.getOrDefault("oauth_token")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "oauth_token", valid_589248
  var valid_589249 = query.getOrDefault("callback")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "callback", valid_589249
  var valid_589250 = query.getOrDefault("access_token")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "access_token", valid_589250
  var valid_589251 = query.getOrDefault("uploadType")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "uploadType", valid_589251
  var valid_589252 = query.getOrDefault("location")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "location", valid_589252
  var valid_589253 = query.getOrDefault("key")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "key", valid_589253
  var valid_589254 = query.getOrDefault("$.xgafv")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = newJString("1"))
  if valid_589254 != nil:
    section.add "$.xgafv", valid_589254
  var valid_589255 = query.getOrDefault("pageSize")
  valid_589255 = validateParameter(valid_589255, JInt, required = false, default = nil)
  if valid_589255 != nil:
    section.add "pageSize", valid_589255
  var valid_589256 = query.getOrDefault("prettyPrint")
  valid_589256 = validateParameter(valid_589256, JBool, required = false,
                                 default = newJBool(true))
  if valid_589256 != nil:
    section.add "prettyPrint", valid_589256
  var valid_589257 = query.getOrDefault("filter")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_589257 != nil:
    section.add "filter", valid_589257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589258: Call_DataflowProjectsJobsAggregated_589238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the jobs of a project across all regions.
  ## 
  let valid = call_589258.validator(path, query, header, formData, body)
  let scheme = call_589258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589258.url(scheme.get, call_589258.host, call_589258.base,
                         call_589258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589258, url, valid)

proc call*(call_589259: Call_DataflowProjectsJobsAggregated_589238;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = "";
          view: string = "JOB_VIEW_UNKNOWN"; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; location: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = "UNKNOWN"): Recallable =
  ## dataflowProjectsJobsAggregated
  ## List the jobs of a project across all regions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Set this to the 'next_page_token' field of a previous response
  ## to request additional results in a long list.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Level of information requested in response. Default is `JOB_VIEW_SUMMARY`.
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
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The project which owns the jobs.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : If there are many jobs, limit response to at most this many.
  ## The actual number of jobs returned will be the lesser of max_responses
  ## and an unspecified server-defined limit.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The kind of filter to use.
  var path_589260 = newJObject()
  var query_589261 = newJObject()
  add(query_589261, "upload_protocol", newJString(uploadProtocol))
  add(query_589261, "fields", newJString(fields))
  add(query_589261, "pageToken", newJString(pageToken))
  add(query_589261, "quotaUser", newJString(quotaUser))
  add(query_589261, "view", newJString(view))
  add(query_589261, "alt", newJString(alt))
  add(query_589261, "oauth_token", newJString(oauthToken))
  add(query_589261, "callback", newJString(callback))
  add(query_589261, "access_token", newJString(accessToken))
  add(query_589261, "uploadType", newJString(uploadType))
  add(query_589261, "location", newJString(location))
  add(query_589261, "key", newJString(key))
  add(path_589260, "projectId", newJString(projectId))
  add(query_589261, "$.xgafv", newJString(Xgafv))
  add(query_589261, "pageSize", newJInt(pageSize))
  add(query_589261, "prettyPrint", newJBool(prettyPrint))
  add(query_589261, "filter", newJString(filter))
  result = call_589259.call(path_589260, query_589261, nil, nil, nil)

var dataflowProjectsJobsAggregated* = Call_DataflowProjectsJobsAggregated_589238(
    name: "dataflowProjectsJobsAggregated", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs:aggregated",
    validator: validate_DataflowProjectsJobsAggregated_589239, base: "/",
    url: url_DataflowProjectsJobsAggregated_589240, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsWorkerMessages_589262 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsWorkerMessages_589264(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsWorkerMessages_589263(path: JsonNode;
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
  var valid_589265 = path.getOrDefault("projectId")
  valid_589265 = validateParameter(valid_589265, JString, required = true,
                                 default = nil)
  if valid_589265 != nil:
    section.add "projectId", valid_589265
  var valid_589266 = path.getOrDefault("location")
  valid_589266 = validateParameter(valid_589266, JString, required = true,
                                 default = nil)
  if valid_589266 != nil:
    section.add "location", valid_589266
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
  var valid_589267 = query.getOrDefault("upload_protocol")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "upload_protocol", valid_589267
  var valid_589268 = query.getOrDefault("fields")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "fields", valid_589268
  var valid_589269 = query.getOrDefault("quotaUser")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "quotaUser", valid_589269
  var valid_589270 = query.getOrDefault("alt")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = newJString("json"))
  if valid_589270 != nil:
    section.add "alt", valid_589270
  var valid_589271 = query.getOrDefault("oauth_token")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "oauth_token", valid_589271
  var valid_589272 = query.getOrDefault("callback")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "callback", valid_589272
  var valid_589273 = query.getOrDefault("access_token")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "access_token", valid_589273
  var valid_589274 = query.getOrDefault("uploadType")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "uploadType", valid_589274
  var valid_589275 = query.getOrDefault("key")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "key", valid_589275
  var valid_589276 = query.getOrDefault("$.xgafv")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = newJString("1"))
  if valid_589276 != nil:
    section.add "$.xgafv", valid_589276
  var valid_589277 = query.getOrDefault("prettyPrint")
  valid_589277 = validateParameter(valid_589277, JBool, required = false,
                                 default = newJBool(true))
  if valid_589277 != nil:
    section.add "prettyPrint", valid_589277
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

proc call*(call_589279: Call_DataflowProjectsLocationsWorkerMessages_589262;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send a worker_message to the service.
  ## 
  let valid = call_589279.validator(path, query, header, formData, body)
  let scheme = call_589279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589279.url(scheme.get, call_589279.host, call_589279.base,
                         call_589279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589279, url, valid)

proc call*(call_589280: Call_DataflowProjectsLocationsWorkerMessages_589262;
          projectId: string; location: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsLocationsWorkerMessages
  ## Send a worker_message to the service.
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
  ##   projectId: string (required)
  ##            : The project to send the WorkerMessages to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job.
  var path_589281 = newJObject()
  var query_589282 = newJObject()
  var body_589283 = newJObject()
  add(query_589282, "upload_protocol", newJString(uploadProtocol))
  add(query_589282, "fields", newJString(fields))
  add(query_589282, "quotaUser", newJString(quotaUser))
  add(query_589282, "alt", newJString(alt))
  add(query_589282, "oauth_token", newJString(oauthToken))
  add(query_589282, "callback", newJString(callback))
  add(query_589282, "access_token", newJString(accessToken))
  add(query_589282, "uploadType", newJString(uploadType))
  add(query_589282, "key", newJString(key))
  add(path_589281, "projectId", newJString(projectId))
  add(query_589282, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589283 = body
  add(query_589282, "prettyPrint", newJBool(prettyPrint))
  add(path_589281, "location", newJString(location))
  result = call_589280.call(path_589281, query_589282, nil, nil, body_589283)

var dataflowProjectsLocationsWorkerMessages* = Call_DataflowProjectsLocationsWorkerMessages_589262(
    name: "dataflowProjectsLocationsWorkerMessages", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/WorkerMessages",
    validator: validate_DataflowProjectsLocationsWorkerMessages_589263, base: "/",
    url: url_DataflowProjectsLocationsWorkerMessages_589264,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsCreate_589308 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsJobsCreate_589310(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsLocationsJobsCreate_589309(path: JsonNode;
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
  var valid_589311 = path.getOrDefault("projectId")
  valid_589311 = validateParameter(valid_589311, JString, required = true,
                                 default = nil)
  if valid_589311 != nil:
    section.add "projectId", valid_589311
  var valid_589312 = path.getOrDefault("location")
  valid_589312 = validateParameter(valid_589312, JString, required = true,
                                 default = nil)
  if valid_589312 != nil:
    section.add "location", valid_589312
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : The level of information requested in response.
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
  ##   replaceJobId: JString
  ##               : Deprecated. This field is now in the Job message.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589313 = query.getOrDefault("upload_protocol")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "upload_protocol", valid_589313
  var valid_589314 = query.getOrDefault("fields")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "fields", valid_589314
  var valid_589315 = query.getOrDefault("view")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_589315 != nil:
    section.add "view", valid_589315
  var valid_589316 = query.getOrDefault("quotaUser")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "quotaUser", valid_589316
  var valid_589317 = query.getOrDefault("alt")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = newJString("json"))
  if valid_589317 != nil:
    section.add "alt", valid_589317
  var valid_589318 = query.getOrDefault("oauth_token")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "oauth_token", valid_589318
  var valid_589319 = query.getOrDefault("callback")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "callback", valid_589319
  var valid_589320 = query.getOrDefault("access_token")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "access_token", valid_589320
  var valid_589321 = query.getOrDefault("uploadType")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "uploadType", valid_589321
  var valid_589322 = query.getOrDefault("replaceJobId")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "replaceJobId", valid_589322
  var valid_589323 = query.getOrDefault("key")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "key", valid_589323
  var valid_589324 = query.getOrDefault("$.xgafv")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = newJString("1"))
  if valid_589324 != nil:
    section.add "$.xgafv", valid_589324
  var valid_589325 = query.getOrDefault("prettyPrint")
  valid_589325 = validateParameter(valid_589325, JBool, required = false,
                                 default = newJBool(true))
  if valid_589325 != nil:
    section.add "prettyPrint", valid_589325
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

proc call*(call_589327: Call_DataflowProjectsLocationsJobsCreate_589308;
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
  let valid = call_589327.validator(path, query, header, formData, body)
  let scheme = call_589327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589327.url(scheme.get, call_589327.host, call_589327.base,
                         call_589327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589327, url, valid)

proc call*(call_589328: Call_DataflowProjectsLocationsJobsCreate_589308;
          projectId: string; location: string; uploadProtocol: string = "";
          fields: string = ""; view: string = "JOB_VIEW_UNKNOWN";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          replaceJobId: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsLocationsJobsCreate
  ## Creates a Cloud Dataflow job.
  ## 
  ## To create a job, we recommend using `projects.locations.jobs.create` with a
  ## [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.create` is not recommended, as your job will always start
  ## in `us-central1`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : The level of information requested in response.
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
  ##   replaceJobId: string
  ##               : Deprecated. This field is now in the Job message.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  var path_589329 = newJObject()
  var query_589330 = newJObject()
  var body_589331 = newJObject()
  add(query_589330, "upload_protocol", newJString(uploadProtocol))
  add(query_589330, "fields", newJString(fields))
  add(query_589330, "view", newJString(view))
  add(query_589330, "quotaUser", newJString(quotaUser))
  add(query_589330, "alt", newJString(alt))
  add(query_589330, "oauth_token", newJString(oauthToken))
  add(query_589330, "callback", newJString(callback))
  add(query_589330, "access_token", newJString(accessToken))
  add(query_589330, "uploadType", newJString(uploadType))
  add(query_589330, "replaceJobId", newJString(replaceJobId))
  add(query_589330, "key", newJString(key))
  add(path_589329, "projectId", newJString(projectId))
  add(query_589330, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589331 = body
  add(query_589330, "prettyPrint", newJBool(prettyPrint))
  add(path_589329, "location", newJString(location))
  result = call_589328.call(path_589329, query_589330, nil, nil, body_589331)

var dataflowProjectsLocationsJobsCreate* = Call_DataflowProjectsLocationsJobsCreate_589308(
    name: "dataflowProjectsLocationsJobsCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs",
    validator: validate_DataflowProjectsLocationsJobsCreate_589309, base: "/",
    url: url_DataflowProjectsLocationsJobsCreate_589310, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsList_589284 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsJobsList_589286(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsLocationsJobsList_589285(path: JsonNode;
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
  var valid_589287 = path.getOrDefault("projectId")
  valid_589287 = validateParameter(valid_589287, JString, required = true,
                                 default = nil)
  if valid_589287 != nil:
    section.add "projectId", valid_589287
  var valid_589288 = path.getOrDefault("location")
  valid_589288 = validateParameter(valid_589288, JString, required = true,
                                 default = nil)
  if valid_589288 != nil:
    section.add "location", valid_589288
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Set this to the 'next_page_token' field of a previous response
  ## to request additional results in a long list.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Level of information requested in response. Default is `JOB_VIEW_SUMMARY`.
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
  ##           : If there are many jobs, limit response to at most this many.
  ## The actual number of jobs returned will be the lesser of max_responses
  ## and an unspecified server-defined limit.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The kind of filter to use.
  section = newJObject()
  var valid_589289 = query.getOrDefault("upload_protocol")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "upload_protocol", valid_589289
  var valid_589290 = query.getOrDefault("fields")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "fields", valid_589290
  var valid_589291 = query.getOrDefault("pageToken")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "pageToken", valid_589291
  var valid_589292 = query.getOrDefault("quotaUser")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "quotaUser", valid_589292
  var valid_589293 = query.getOrDefault("view")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_589293 != nil:
    section.add "view", valid_589293
  var valid_589294 = query.getOrDefault("alt")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = newJString("json"))
  if valid_589294 != nil:
    section.add "alt", valid_589294
  var valid_589295 = query.getOrDefault("oauth_token")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "oauth_token", valid_589295
  var valid_589296 = query.getOrDefault("callback")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "callback", valid_589296
  var valid_589297 = query.getOrDefault("access_token")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "access_token", valid_589297
  var valid_589298 = query.getOrDefault("uploadType")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "uploadType", valid_589298
  var valid_589299 = query.getOrDefault("key")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "key", valid_589299
  var valid_589300 = query.getOrDefault("$.xgafv")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = newJString("1"))
  if valid_589300 != nil:
    section.add "$.xgafv", valid_589300
  var valid_589301 = query.getOrDefault("pageSize")
  valid_589301 = validateParameter(valid_589301, JInt, required = false, default = nil)
  if valid_589301 != nil:
    section.add "pageSize", valid_589301
  var valid_589302 = query.getOrDefault("prettyPrint")
  valid_589302 = validateParameter(valid_589302, JBool, required = false,
                                 default = newJBool(true))
  if valid_589302 != nil:
    section.add "prettyPrint", valid_589302
  var valid_589303 = query.getOrDefault("filter")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_589303 != nil:
    section.add "filter", valid_589303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589304: Call_DataflowProjectsLocationsJobsList_589284;
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
  let valid = call_589304.validator(path, query, header, formData, body)
  let scheme = call_589304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589304.url(scheme.get, call_589304.host, call_589304.base,
                         call_589304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589304, url, valid)

proc call*(call_589305: Call_DataflowProjectsLocationsJobsList_589284;
          projectId: string; location: string; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          view: string = "JOB_VIEW_UNKNOWN"; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = "UNKNOWN"): Recallable =
  ## dataflowProjectsLocationsJobsList
  ## List the jobs of a project.
  ## 
  ## To list the jobs of a project in a region, we recommend using
  ## `projects.locations.jobs.get` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). To
  ## list the all jobs across all regions, use `projects.jobs.aggregated`. Using
  ## `projects.jobs.list` is not recommended, as you can only get the list of
  ## jobs that are running in `us-central1`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Set this to the 'next_page_token' field of a previous response
  ## to request additional results in a long list.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Level of information requested in response. Default is `JOB_VIEW_SUMMARY`.
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
  ##   projectId: string (required)
  ##            : The project which owns the jobs.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : If there are many jobs, limit response to at most this many.
  ## The actual number of jobs returned will be the lesser of max_responses
  ## and an unspecified server-defined limit.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  ##   filter: string
  ##         : The kind of filter to use.
  var path_589306 = newJObject()
  var query_589307 = newJObject()
  add(query_589307, "upload_protocol", newJString(uploadProtocol))
  add(query_589307, "fields", newJString(fields))
  add(query_589307, "pageToken", newJString(pageToken))
  add(query_589307, "quotaUser", newJString(quotaUser))
  add(query_589307, "view", newJString(view))
  add(query_589307, "alt", newJString(alt))
  add(query_589307, "oauth_token", newJString(oauthToken))
  add(query_589307, "callback", newJString(callback))
  add(query_589307, "access_token", newJString(accessToken))
  add(query_589307, "uploadType", newJString(uploadType))
  add(query_589307, "key", newJString(key))
  add(path_589306, "projectId", newJString(projectId))
  add(query_589307, "$.xgafv", newJString(Xgafv))
  add(query_589307, "pageSize", newJInt(pageSize))
  add(query_589307, "prettyPrint", newJBool(prettyPrint))
  add(path_589306, "location", newJString(location))
  add(query_589307, "filter", newJString(filter))
  result = call_589305.call(path_589306, query_589307, nil, nil, nil)

var dataflowProjectsLocationsJobsList* = Call_DataflowProjectsLocationsJobsList_589284(
    name: "dataflowProjectsLocationsJobsList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs",
    validator: validate_DataflowProjectsLocationsJobsList_589285, base: "/",
    url: url_DataflowProjectsLocationsJobsList_589286, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsUpdate_589354 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsJobsUpdate_589356(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsLocationsJobsUpdate_589355(path: JsonNode;
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
  ##   jobId: JString (required)
  ##        : The job ID.
  ##   projectId: JString (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589357 = path.getOrDefault("jobId")
  valid_589357 = validateParameter(valid_589357, JString, required = true,
                                 default = nil)
  if valid_589357 != nil:
    section.add "jobId", valid_589357
  var valid_589358 = path.getOrDefault("projectId")
  valid_589358 = validateParameter(valid_589358, JString, required = true,
                                 default = nil)
  if valid_589358 != nil:
    section.add "projectId", valid_589358
  var valid_589359 = path.getOrDefault("location")
  valid_589359 = validateParameter(valid_589359, JString, required = true,
                                 default = nil)
  if valid_589359 != nil:
    section.add "location", valid_589359
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
  var valid_589360 = query.getOrDefault("upload_protocol")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "upload_protocol", valid_589360
  var valid_589361 = query.getOrDefault("fields")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "fields", valid_589361
  var valid_589362 = query.getOrDefault("quotaUser")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "quotaUser", valid_589362
  var valid_589363 = query.getOrDefault("alt")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = newJString("json"))
  if valid_589363 != nil:
    section.add "alt", valid_589363
  var valid_589364 = query.getOrDefault("oauth_token")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "oauth_token", valid_589364
  var valid_589365 = query.getOrDefault("callback")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "callback", valid_589365
  var valid_589366 = query.getOrDefault("access_token")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "access_token", valid_589366
  var valid_589367 = query.getOrDefault("uploadType")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "uploadType", valid_589367
  var valid_589368 = query.getOrDefault("key")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "key", valid_589368
  var valid_589369 = query.getOrDefault("$.xgafv")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = newJString("1"))
  if valid_589369 != nil:
    section.add "$.xgafv", valid_589369
  var valid_589370 = query.getOrDefault("prettyPrint")
  valid_589370 = validateParameter(valid_589370, JBool, required = false,
                                 default = newJBool(true))
  if valid_589370 != nil:
    section.add "prettyPrint", valid_589370
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

proc call*(call_589372: Call_DataflowProjectsLocationsJobsUpdate_589354;
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
  let valid = call_589372.validator(path, query, header, formData, body)
  let scheme = call_589372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589372.url(scheme.get, call_589372.host, call_589372.base,
                         call_589372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589372, url, valid)

proc call*(call_589373: Call_DataflowProjectsLocationsJobsUpdate_589354;
          jobId: string; projectId: string; location: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsLocationsJobsUpdate
  ## Updates the state of an existing Cloud Dataflow job.
  ## 
  ## To update the state of an existing job, we recommend using
  ## `projects.locations.jobs.update` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.update` is not recommended, as you can only update the state
  ## of jobs that are running in `us-central1`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The job ID.
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
  ##   projectId: string (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  var path_589374 = newJObject()
  var query_589375 = newJObject()
  var body_589376 = newJObject()
  add(query_589375, "upload_protocol", newJString(uploadProtocol))
  add(query_589375, "fields", newJString(fields))
  add(query_589375, "quotaUser", newJString(quotaUser))
  add(query_589375, "alt", newJString(alt))
  add(path_589374, "jobId", newJString(jobId))
  add(query_589375, "oauth_token", newJString(oauthToken))
  add(query_589375, "callback", newJString(callback))
  add(query_589375, "access_token", newJString(accessToken))
  add(query_589375, "uploadType", newJString(uploadType))
  add(query_589375, "key", newJString(key))
  add(path_589374, "projectId", newJString(projectId))
  add(query_589375, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589376 = body
  add(query_589375, "prettyPrint", newJBool(prettyPrint))
  add(path_589374, "location", newJString(location))
  result = call_589373.call(path_589374, query_589375, nil, nil, body_589376)

var dataflowProjectsLocationsJobsUpdate* = Call_DataflowProjectsLocationsJobsUpdate_589354(
    name: "dataflowProjectsLocationsJobsUpdate", meth: HttpMethod.HttpPut,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}",
    validator: validate_DataflowProjectsLocationsJobsUpdate_589355, base: "/",
    url: url_DataflowProjectsLocationsJobsUpdate_589356, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsGet_589332 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsJobsGet_589334(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsLocationsJobsGet_589333(path: JsonNode;
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
  ##   jobId: JString (required)
  ##        : The job ID.
  ##   projectId: JString (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589335 = path.getOrDefault("jobId")
  valid_589335 = validateParameter(valid_589335, JString, required = true,
                                 default = nil)
  if valid_589335 != nil:
    section.add "jobId", valid_589335
  var valid_589336 = path.getOrDefault("projectId")
  valid_589336 = validateParameter(valid_589336, JString, required = true,
                                 default = nil)
  if valid_589336 != nil:
    section.add "projectId", valid_589336
  var valid_589337 = path.getOrDefault("location")
  valid_589337 = validateParameter(valid_589337, JString, required = true,
                                 default = nil)
  if valid_589337 != nil:
    section.add "location", valid_589337
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : The level of information requested in response.
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
  var valid_589338 = query.getOrDefault("upload_protocol")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "upload_protocol", valid_589338
  var valid_589339 = query.getOrDefault("fields")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "fields", valid_589339
  var valid_589340 = query.getOrDefault("view")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_589340 != nil:
    section.add "view", valid_589340
  var valid_589341 = query.getOrDefault("quotaUser")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "quotaUser", valid_589341
  var valid_589342 = query.getOrDefault("alt")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = newJString("json"))
  if valid_589342 != nil:
    section.add "alt", valid_589342
  var valid_589343 = query.getOrDefault("oauth_token")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "oauth_token", valid_589343
  var valid_589344 = query.getOrDefault("callback")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "callback", valid_589344
  var valid_589345 = query.getOrDefault("access_token")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "access_token", valid_589345
  var valid_589346 = query.getOrDefault("uploadType")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "uploadType", valid_589346
  var valid_589347 = query.getOrDefault("key")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "key", valid_589347
  var valid_589348 = query.getOrDefault("$.xgafv")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = newJString("1"))
  if valid_589348 != nil:
    section.add "$.xgafv", valid_589348
  var valid_589349 = query.getOrDefault("prettyPrint")
  valid_589349 = validateParameter(valid_589349, JBool, required = false,
                                 default = newJBool(true))
  if valid_589349 != nil:
    section.add "prettyPrint", valid_589349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589350: Call_DataflowProjectsLocationsJobsGet_589332;
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
  let valid = call_589350.validator(path, query, header, formData, body)
  let scheme = call_589350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589350.url(scheme.get, call_589350.host, call_589350.base,
                         call_589350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589350, url, valid)

proc call*(call_589351: Call_DataflowProjectsLocationsJobsGet_589332;
          jobId: string; projectId: string; location: string;
          uploadProtocol: string = ""; fields: string = "";
          view: string = "JOB_VIEW_UNKNOWN"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsLocationsJobsGet
  ## Gets the state of the specified Cloud Dataflow job.
  ## 
  ## To get the state of a job, we recommend using `projects.locations.jobs.get`
  ## with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.get` is not recommended, as you can only get the state of
  ## jobs that are running in `us-central1`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : The level of information requested in response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The job ID.
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
  ##   projectId: string (required)
  ##            : The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains this job.
  var path_589352 = newJObject()
  var query_589353 = newJObject()
  add(query_589353, "upload_protocol", newJString(uploadProtocol))
  add(query_589353, "fields", newJString(fields))
  add(query_589353, "view", newJString(view))
  add(query_589353, "quotaUser", newJString(quotaUser))
  add(query_589353, "alt", newJString(alt))
  add(path_589352, "jobId", newJString(jobId))
  add(query_589353, "oauth_token", newJString(oauthToken))
  add(query_589353, "callback", newJString(callback))
  add(query_589353, "access_token", newJString(accessToken))
  add(query_589353, "uploadType", newJString(uploadType))
  add(query_589353, "key", newJString(key))
  add(path_589352, "projectId", newJString(projectId))
  add(query_589353, "$.xgafv", newJString(Xgafv))
  add(query_589353, "prettyPrint", newJBool(prettyPrint))
  add(path_589352, "location", newJString(location))
  result = call_589351.call(path_589352, query_589353, nil, nil, nil)

var dataflowProjectsLocationsJobsGet* = Call_DataflowProjectsLocationsJobsGet_589332(
    name: "dataflowProjectsLocationsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}",
    validator: validate_DataflowProjectsLocationsJobsGet_589333, base: "/",
    url: url_DataflowProjectsLocationsJobsGet_589334, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsDebugGetConfig_589377 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsJobsDebugGetConfig_589379(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsJobsDebugGetConfig_589378(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get encoded debug configuration for component. Not cacheable.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The job id.
  ##   projectId: JString (required)
  ##            : The project id.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589380 = path.getOrDefault("jobId")
  valid_589380 = validateParameter(valid_589380, JString, required = true,
                                 default = nil)
  if valid_589380 != nil:
    section.add "jobId", valid_589380
  var valid_589381 = path.getOrDefault("projectId")
  valid_589381 = validateParameter(valid_589381, JString, required = true,
                                 default = nil)
  if valid_589381 != nil:
    section.add "projectId", valid_589381
  var valid_589382 = path.getOrDefault("location")
  valid_589382 = validateParameter(valid_589382, JString, required = true,
                                 default = nil)
  if valid_589382 != nil:
    section.add "location", valid_589382
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
  var valid_589383 = query.getOrDefault("upload_protocol")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "upload_protocol", valid_589383
  var valid_589384 = query.getOrDefault("fields")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "fields", valid_589384
  var valid_589385 = query.getOrDefault("quotaUser")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "quotaUser", valid_589385
  var valid_589386 = query.getOrDefault("alt")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = newJString("json"))
  if valid_589386 != nil:
    section.add "alt", valid_589386
  var valid_589387 = query.getOrDefault("oauth_token")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "oauth_token", valid_589387
  var valid_589388 = query.getOrDefault("callback")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "callback", valid_589388
  var valid_589389 = query.getOrDefault("access_token")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "access_token", valid_589389
  var valid_589390 = query.getOrDefault("uploadType")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "uploadType", valid_589390
  var valid_589391 = query.getOrDefault("key")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "key", valid_589391
  var valid_589392 = query.getOrDefault("$.xgafv")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = newJString("1"))
  if valid_589392 != nil:
    section.add "$.xgafv", valid_589392
  var valid_589393 = query.getOrDefault("prettyPrint")
  valid_589393 = validateParameter(valid_589393, JBool, required = false,
                                 default = newJBool(true))
  if valid_589393 != nil:
    section.add "prettyPrint", valid_589393
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

proc call*(call_589395: Call_DataflowProjectsLocationsJobsDebugGetConfig_589377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get encoded debug configuration for component. Not cacheable.
  ## 
  let valid = call_589395.validator(path, query, header, formData, body)
  let scheme = call_589395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589395.url(scheme.get, call_589395.host, call_589395.base,
                         call_589395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589395, url, valid)

proc call*(call_589396: Call_DataflowProjectsLocationsJobsDebugGetConfig_589377;
          jobId: string; projectId: string; location: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsLocationsJobsDebugGetConfig
  ## Get encoded debug configuration for component. Not cacheable.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The job id.
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
  ##   projectId: string (required)
  ##            : The project id.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  var path_589397 = newJObject()
  var query_589398 = newJObject()
  var body_589399 = newJObject()
  add(query_589398, "upload_protocol", newJString(uploadProtocol))
  add(query_589398, "fields", newJString(fields))
  add(query_589398, "quotaUser", newJString(quotaUser))
  add(query_589398, "alt", newJString(alt))
  add(path_589397, "jobId", newJString(jobId))
  add(query_589398, "oauth_token", newJString(oauthToken))
  add(query_589398, "callback", newJString(callback))
  add(query_589398, "access_token", newJString(accessToken))
  add(query_589398, "uploadType", newJString(uploadType))
  add(query_589398, "key", newJString(key))
  add(path_589397, "projectId", newJString(projectId))
  add(query_589398, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589399 = body
  add(query_589398, "prettyPrint", newJBool(prettyPrint))
  add(path_589397, "location", newJString(location))
  result = call_589396.call(path_589397, query_589398, nil, nil, body_589399)

var dataflowProjectsLocationsJobsDebugGetConfig* = Call_DataflowProjectsLocationsJobsDebugGetConfig_589377(
    name: "dataflowProjectsLocationsJobsDebugGetConfig",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/debug/getConfig",
    validator: validate_DataflowProjectsLocationsJobsDebugGetConfig_589378,
    base: "/", url: url_DataflowProjectsLocationsJobsDebugGetConfig_589379,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsDebugSendCapture_589400 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsJobsDebugSendCapture_589402(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsJobsDebugSendCapture_589401(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Send encoded debug capture data for component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The job id.
  ##   projectId: JString (required)
  ##            : The project id.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589403 = path.getOrDefault("jobId")
  valid_589403 = validateParameter(valid_589403, JString, required = true,
                                 default = nil)
  if valid_589403 != nil:
    section.add "jobId", valid_589403
  var valid_589404 = path.getOrDefault("projectId")
  valid_589404 = validateParameter(valid_589404, JString, required = true,
                                 default = nil)
  if valid_589404 != nil:
    section.add "projectId", valid_589404
  var valid_589405 = path.getOrDefault("location")
  valid_589405 = validateParameter(valid_589405, JString, required = true,
                                 default = nil)
  if valid_589405 != nil:
    section.add "location", valid_589405
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
  var valid_589406 = query.getOrDefault("upload_protocol")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "upload_protocol", valid_589406
  var valid_589407 = query.getOrDefault("fields")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = nil)
  if valid_589407 != nil:
    section.add "fields", valid_589407
  var valid_589408 = query.getOrDefault("quotaUser")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "quotaUser", valid_589408
  var valid_589409 = query.getOrDefault("alt")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = newJString("json"))
  if valid_589409 != nil:
    section.add "alt", valid_589409
  var valid_589410 = query.getOrDefault("oauth_token")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "oauth_token", valid_589410
  var valid_589411 = query.getOrDefault("callback")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "callback", valid_589411
  var valid_589412 = query.getOrDefault("access_token")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "access_token", valid_589412
  var valid_589413 = query.getOrDefault("uploadType")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "uploadType", valid_589413
  var valid_589414 = query.getOrDefault("key")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "key", valid_589414
  var valid_589415 = query.getOrDefault("$.xgafv")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = newJString("1"))
  if valid_589415 != nil:
    section.add "$.xgafv", valid_589415
  var valid_589416 = query.getOrDefault("prettyPrint")
  valid_589416 = validateParameter(valid_589416, JBool, required = false,
                                 default = newJBool(true))
  if valid_589416 != nil:
    section.add "prettyPrint", valid_589416
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

proc call*(call_589418: Call_DataflowProjectsLocationsJobsDebugSendCapture_589400;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send encoded debug capture data for component.
  ## 
  let valid = call_589418.validator(path, query, header, formData, body)
  let scheme = call_589418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589418.url(scheme.get, call_589418.host, call_589418.base,
                         call_589418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589418, url, valid)

proc call*(call_589419: Call_DataflowProjectsLocationsJobsDebugSendCapture_589400;
          jobId: string; projectId: string; location: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsLocationsJobsDebugSendCapture
  ## Send encoded debug capture data for component.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The job id.
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
  ##   projectId: string (required)
  ##            : The project id.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  var path_589420 = newJObject()
  var query_589421 = newJObject()
  var body_589422 = newJObject()
  add(query_589421, "upload_protocol", newJString(uploadProtocol))
  add(query_589421, "fields", newJString(fields))
  add(query_589421, "quotaUser", newJString(quotaUser))
  add(query_589421, "alt", newJString(alt))
  add(path_589420, "jobId", newJString(jobId))
  add(query_589421, "oauth_token", newJString(oauthToken))
  add(query_589421, "callback", newJString(callback))
  add(query_589421, "access_token", newJString(accessToken))
  add(query_589421, "uploadType", newJString(uploadType))
  add(query_589421, "key", newJString(key))
  add(path_589420, "projectId", newJString(projectId))
  add(query_589421, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589422 = body
  add(query_589421, "prettyPrint", newJBool(prettyPrint))
  add(path_589420, "location", newJString(location))
  result = call_589419.call(path_589420, query_589421, nil, nil, body_589422)

var dataflowProjectsLocationsJobsDebugSendCapture* = Call_DataflowProjectsLocationsJobsDebugSendCapture_589400(
    name: "dataflowProjectsLocationsJobsDebugSendCapture",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/debug/sendCapture",
    validator: validate_DataflowProjectsLocationsJobsDebugSendCapture_589401,
    base: "/", url: url_DataflowProjectsLocationsJobsDebugSendCapture_589402,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsMessagesList_589423 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsJobsMessagesList_589425(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsJobsMessagesList_589424(path: JsonNode;
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
  ##   jobId: JString (required)
  ##        : The job to get messages about.
  ##   projectId: JString (required)
  ##            : A project id.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589426 = path.getOrDefault("jobId")
  valid_589426 = validateParameter(valid_589426, JString, required = true,
                                 default = nil)
  if valid_589426 != nil:
    section.add "jobId", valid_589426
  var valid_589427 = path.getOrDefault("projectId")
  valid_589427 = validateParameter(valid_589427, JString, required = true,
                                 default = nil)
  if valid_589427 != nil:
    section.add "projectId", valid_589427
  var valid_589428 = path.getOrDefault("location")
  valid_589428 = validateParameter(valid_589428, JString, required = true,
                                 default = nil)
  if valid_589428 != nil:
    section.add "location", valid_589428
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If supplied, this should be the value of next_page_token returned
  ## by an earlier call. This will cause the next page of results to
  ## be returned.
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
  ##   endTime: JString
  ##          : Return only messages with timestamps < end_time. The default is now
  ## (i.e. return up to the latest messages available).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   minimumImportance: JString
  ##                    : Filter to only get messages with importance >= level
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : If specified, determines the maximum number of messages to
  ## return.  If unspecified, the service may choose an appropriate
  ## default, or may return an arbitrarily large number of results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: JString
  ##            : If specified, return only messages with timestamps >= start_time.
  ## The default is the job creation time (i.e. beginning of messages).
  section = newJObject()
  var valid_589429 = query.getOrDefault("upload_protocol")
  valid_589429 = validateParameter(valid_589429, JString, required = false,
                                 default = nil)
  if valid_589429 != nil:
    section.add "upload_protocol", valid_589429
  var valid_589430 = query.getOrDefault("fields")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "fields", valid_589430
  var valid_589431 = query.getOrDefault("pageToken")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "pageToken", valid_589431
  var valid_589432 = query.getOrDefault("quotaUser")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "quotaUser", valid_589432
  var valid_589433 = query.getOrDefault("alt")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = newJString("json"))
  if valid_589433 != nil:
    section.add "alt", valid_589433
  var valid_589434 = query.getOrDefault("oauth_token")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "oauth_token", valid_589434
  var valid_589435 = query.getOrDefault("callback")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "callback", valid_589435
  var valid_589436 = query.getOrDefault("access_token")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "access_token", valid_589436
  var valid_589437 = query.getOrDefault("uploadType")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "uploadType", valid_589437
  var valid_589438 = query.getOrDefault("endTime")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "endTime", valid_589438
  var valid_589439 = query.getOrDefault("key")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "key", valid_589439
  var valid_589440 = query.getOrDefault("minimumImportance")
  valid_589440 = validateParameter(valid_589440, JString, required = false, default = newJString(
      "JOB_MESSAGE_IMPORTANCE_UNKNOWN"))
  if valid_589440 != nil:
    section.add "minimumImportance", valid_589440
  var valid_589441 = query.getOrDefault("$.xgafv")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = newJString("1"))
  if valid_589441 != nil:
    section.add "$.xgafv", valid_589441
  var valid_589442 = query.getOrDefault("pageSize")
  valid_589442 = validateParameter(valid_589442, JInt, required = false, default = nil)
  if valid_589442 != nil:
    section.add "pageSize", valid_589442
  var valid_589443 = query.getOrDefault("prettyPrint")
  valid_589443 = validateParameter(valid_589443, JBool, required = false,
                                 default = newJBool(true))
  if valid_589443 != nil:
    section.add "prettyPrint", valid_589443
  var valid_589444 = query.getOrDefault("startTime")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = nil)
  if valid_589444 != nil:
    section.add "startTime", valid_589444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589445: Call_DataflowProjectsLocationsJobsMessagesList_589423;
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
  let valid = call_589445.validator(path, query, header, formData, body)
  let scheme = call_589445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589445.url(scheme.get, call_589445.host, call_589445.base,
                         call_589445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589445, url, valid)

proc call*(call_589446: Call_DataflowProjectsLocationsJobsMessagesList_589423;
          jobId: string; projectId: string; location: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          endTime: string = ""; key: string = "";
          minimumImportance: string = "JOB_MESSAGE_IMPORTANCE_UNKNOWN";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          startTime: string = ""): Recallable =
  ## dataflowProjectsLocationsJobsMessagesList
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.messages.list` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.messages.list` is not recommended, as you can only request
  ## the status of jobs that are running in `us-central1`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If supplied, this should be the value of next_page_token returned
  ## by an earlier call. This will cause the next page of results to
  ## be returned.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The job to get messages about.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   endTime: string
  ##          : Return only messages with timestamps < end_time. The default is now
  ## (i.e. return up to the latest messages available).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   minimumImportance: string
  ##                    : Filter to only get messages with importance >= level
  ##   projectId: string (required)
  ##            : A project id.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : If specified, determines the maximum number of messages to
  ## return.  If unspecified, the service may choose an appropriate
  ## default, or may return an arbitrarily large number of results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: string
  ##            : If specified, return only messages with timestamps >= start_time.
  ## The default is the job creation time (i.e. beginning of messages).
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  var path_589447 = newJObject()
  var query_589448 = newJObject()
  add(query_589448, "upload_protocol", newJString(uploadProtocol))
  add(query_589448, "fields", newJString(fields))
  add(query_589448, "pageToken", newJString(pageToken))
  add(query_589448, "quotaUser", newJString(quotaUser))
  add(query_589448, "alt", newJString(alt))
  add(path_589447, "jobId", newJString(jobId))
  add(query_589448, "oauth_token", newJString(oauthToken))
  add(query_589448, "callback", newJString(callback))
  add(query_589448, "access_token", newJString(accessToken))
  add(query_589448, "uploadType", newJString(uploadType))
  add(query_589448, "endTime", newJString(endTime))
  add(query_589448, "key", newJString(key))
  add(query_589448, "minimumImportance", newJString(minimumImportance))
  add(path_589447, "projectId", newJString(projectId))
  add(query_589448, "$.xgafv", newJString(Xgafv))
  add(query_589448, "pageSize", newJInt(pageSize))
  add(query_589448, "prettyPrint", newJBool(prettyPrint))
  add(query_589448, "startTime", newJString(startTime))
  add(path_589447, "location", newJString(location))
  result = call_589446.call(path_589447, query_589448, nil, nil, nil)

var dataflowProjectsLocationsJobsMessagesList* = Call_DataflowProjectsLocationsJobsMessagesList_589423(
    name: "dataflowProjectsLocationsJobsMessagesList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/messages",
    validator: validate_DataflowProjectsLocationsJobsMessagesList_589424,
    base: "/", url: url_DataflowProjectsLocationsJobsMessagesList_589425,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsGetMetrics_589449 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsJobsGetMetrics_589451(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsJobsGetMetrics_589450(path: JsonNode;
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
  ##   jobId: JString (required)
  ##        : The job to get messages for.
  ##   projectId: JString (required)
  ##            : A project id.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589452 = path.getOrDefault("jobId")
  valid_589452 = validateParameter(valid_589452, JString, required = true,
                                 default = nil)
  if valid_589452 != nil:
    section.add "jobId", valid_589452
  var valid_589453 = path.getOrDefault("projectId")
  valid_589453 = validateParameter(valid_589453, JString, required = true,
                                 default = nil)
  if valid_589453 != nil:
    section.add "projectId", valid_589453
  var valid_589454 = path.getOrDefault("location")
  valid_589454 = validateParameter(valid_589454, JString, required = true,
                                 default = nil)
  if valid_589454 != nil:
    section.add "location", valid_589454
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
  ##   startTime: JString
  ##            : Return only metric data that has changed since this time.
  ## Default is to return all information about all metrics for the job.
  section = newJObject()
  var valid_589455 = query.getOrDefault("upload_protocol")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "upload_protocol", valid_589455
  var valid_589456 = query.getOrDefault("fields")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "fields", valid_589456
  var valid_589457 = query.getOrDefault("quotaUser")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "quotaUser", valid_589457
  var valid_589458 = query.getOrDefault("alt")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = newJString("json"))
  if valid_589458 != nil:
    section.add "alt", valid_589458
  var valid_589459 = query.getOrDefault("oauth_token")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "oauth_token", valid_589459
  var valid_589460 = query.getOrDefault("callback")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "callback", valid_589460
  var valid_589461 = query.getOrDefault("access_token")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "access_token", valid_589461
  var valid_589462 = query.getOrDefault("uploadType")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = nil)
  if valid_589462 != nil:
    section.add "uploadType", valid_589462
  var valid_589463 = query.getOrDefault("key")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "key", valid_589463
  var valid_589464 = query.getOrDefault("$.xgafv")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = newJString("1"))
  if valid_589464 != nil:
    section.add "$.xgafv", valid_589464
  var valid_589465 = query.getOrDefault("prettyPrint")
  valid_589465 = validateParameter(valid_589465, JBool, required = false,
                                 default = newJBool(true))
  if valid_589465 != nil:
    section.add "prettyPrint", valid_589465
  var valid_589466 = query.getOrDefault("startTime")
  valid_589466 = validateParameter(valid_589466, JString, required = false,
                                 default = nil)
  if valid_589466 != nil:
    section.add "startTime", valid_589466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589467: Call_DataflowProjectsLocationsJobsGetMetrics_589449;
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
  let valid = call_589467.validator(path, query, header, formData, body)
  let scheme = call_589467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589467.url(scheme.get, call_589467.host, call_589467.base,
                         call_589467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589467, url, valid)

proc call*(call_589468: Call_DataflowProjectsLocationsJobsGetMetrics_589449;
          jobId: string; projectId: string; location: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; startTime: string = ""): Recallable =
  ## dataflowProjectsLocationsJobsGetMetrics
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.getMetrics` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.getMetrics` is not recommended, as you can only request the
  ## status of jobs that are running in `us-central1`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The job to get messages for.
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
  ##   projectId: string (required)
  ##            : A project id.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: string
  ##            : Return only metric data that has changed since this time.
  ## Default is to return all information about all metrics for the job.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the job specified by job_id.
  var path_589469 = newJObject()
  var query_589470 = newJObject()
  add(query_589470, "upload_protocol", newJString(uploadProtocol))
  add(query_589470, "fields", newJString(fields))
  add(query_589470, "quotaUser", newJString(quotaUser))
  add(query_589470, "alt", newJString(alt))
  add(path_589469, "jobId", newJString(jobId))
  add(query_589470, "oauth_token", newJString(oauthToken))
  add(query_589470, "callback", newJString(callback))
  add(query_589470, "access_token", newJString(accessToken))
  add(query_589470, "uploadType", newJString(uploadType))
  add(query_589470, "key", newJString(key))
  add(path_589469, "projectId", newJString(projectId))
  add(query_589470, "$.xgafv", newJString(Xgafv))
  add(query_589470, "prettyPrint", newJBool(prettyPrint))
  add(query_589470, "startTime", newJString(startTime))
  add(path_589469, "location", newJString(location))
  result = call_589468.call(path_589469, query_589470, nil, nil, nil)

var dataflowProjectsLocationsJobsGetMetrics* = Call_DataflowProjectsLocationsJobsGetMetrics_589449(
    name: "dataflowProjectsLocationsJobsGetMetrics", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/metrics",
    validator: validate_DataflowProjectsLocationsJobsGetMetrics_589450, base: "/",
    url: url_DataflowProjectsLocationsJobsGetMetrics_589451,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsWorkItemsLease_589471 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsJobsWorkItemsLease_589473(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsJobsWorkItemsLease_589472(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Leases a dataflow WorkItem to run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : Identifies the workflow job this worker belongs to.
  ##   projectId: JString (required)
  ##            : Identifies the project this worker belongs to.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the WorkItem's job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589474 = path.getOrDefault("jobId")
  valid_589474 = validateParameter(valid_589474, JString, required = true,
                                 default = nil)
  if valid_589474 != nil:
    section.add "jobId", valid_589474
  var valid_589475 = path.getOrDefault("projectId")
  valid_589475 = validateParameter(valid_589475, JString, required = true,
                                 default = nil)
  if valid_589475 != nil:
    section.add "projectId", valid_589475
  var valid_589476 = path.getOrDefault("location")
  valid_589476 = validateParameter(valid_589476, JString, required = true,
                                 default = nil)
  if valid_589476 != nil:
    section.add "location", valid_589476
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
  var valid_589477 = query.getOrDefault("upload_protocol")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = nil)
  if valid_589477 != nil:
    section.add "upload_protocol", valid_589477
  var valid_589478 = query.getOrDefault("fields")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "fields", valid_589478
  var valid_589479 = query.getOrDefault("quotaUser")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "quotaUser", valid_589479
  var valid_589480 = query.getOrDefault("alt")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = newJString("json"))
  if valid_589480 != nil:
    section.add "alt", valid_589480
  var valid_589481 = query.getOrDefault("oauth_token")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "oauth_token", valid_589481
  var valid_589482 = query.getOrDefault("callback")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "callback", valid_589482
  var valid_589483 = query.getOrDefault("access_token")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "access_token", valid_589483
  var valid_589484 = query.getOrDefault("uploadType")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "uploadType", valid_589484
  var valid_589485 = query.getOrDefault("key")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = nil)
  if valid_589485 != nil:
    section.add "key", valid_589485
  var valid_589486 = query.getOrDefault("$.xgafv")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = newJString("1"))
  if valid_589486 != nil:
    section.add "$.xgafv", valid_589486
  var valid_589487 = query.getOrDefault("prettyPrint")
  valid_589487 = validateParameter(valid_589487, JBool, required = false,
                                 default = newJBool(true))
  if valid_589487 != nil:
    section.add "prettyPrint", valid_589487
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

proc call*(call_589489: Call_DataflowProjectsLocationsJobsWorkItemsLease_589471;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Leases a dataflow WorkItem to run.
  ## 
  let valid = call_589489.validator(path, query, header, formData, body)
  let scheme = call_589489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589489.url(scheme.get, call_589489.host, call_589489.base,
                         call_589489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589489, url, valid)

proc call*(call_589490: Call_DataflowProjectsLocationsJobsWorkItemsLease_589471;
          jobId: string; projectId: string; location: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsLocationsJobsWorkItemsLease
  ## Leases a dataflow WorkItem to run.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : Identifies the workflow job this worker belongs to.
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
  ##   projectId: string (required)
  ##            : Identifies the project this worker belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the WorkItem's job.
  var path_589491 = newJObject()
  var query_589492 = newJObject()
  var body_589493 = newJObject()
  add(query_589492, "upload_protocol", newJString(uploadProtocol))
  add(query_589492, "fields", newJString(fields))
  add(query_589492, "quotaUser", newJString(quotaUser))
  add(query_589492, "alt", newJString(alt))
  add(path_589491, "jobId", newJString(jobId))
  add(query_589492, "oauth_token", newJString(oauthToken))
  add(query_589492, "callback", newJString(callback))
  add(query_589492, "access_token", newJString(accessToken))
  add(query_589492, "uploadType", newJString(uploadType))
  add(query_589492, "key", newJString(key))
  add(path_589491, "projectId", newJString(projectId))
  add(query_589492, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589493 = body
  add(query_589492, "prettyPrint", newJBool(prettyPrint))
  add(path_589491, "location", newJString(location))
  result = call_589490.call(path_589491, query_589492, nil, nil, body_589493)

var dataflowProjectsLocationsJobsWorkItemsLease* = Call_DataflowProjectsLocationsJobsWorkItemsLease_589471(
    name: "dataflowProjectsLocationsJobsWorkItemsLease",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/workItems:lease",
    validator: validate_DataflowProjectsLocationsJobsWorkItemsLease_589472,
    base: "/", url: url_DataflowProjectsLocationsJobsWorkItemsLease_589473,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_589494 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsJobsWorkItemsReportStatus_589496(
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

proc validate_DataflowProjectsLocationsJobsWorkItemsReportStatus_589495(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Reports the status of dataflow WorkItems leased by a worker.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The job which the WorkItem is part of.
  ##   projectId: JString (required)
  ##            : The project which owns the WorkItem's job.
  ##   location: JString (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the WorkItem's job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589497 = path.getOrDefault("jobId")
  valid_589497 = validateParameter(valid_589497, JString, required = true,
                                 default = nil)
  if valid_589497 != nil:
    section.add "jobId", valid_589497
  var valid_589498 = path.getOrDefault("projectId")
  valid_589498 = validateParameter(valid_589498, JString, required = true,
                                 default = nil)
  if valid_589498 != nil:
    section.add "projectId", valid_589498
  var valid_589499 = path.getOrDefault("location")
  valid_589499 = validateParameter(valid_589499, JString, required = true,
                                 default = nil)
  if valid_589499 != nil:
    section.add "location", valid_589499
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
  var valid_589500 = query.getOrDefault("upload_protocol")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "upload_protocol", valid_589500
  var valid_589501 = query.getOrDefault("fields")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "fields", valid_589501
  var valid_589502 = query.getOrDefault("quotaUser")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "quotaUser", valid_589502
  var valid_589503 = query.getOrDefault("alt")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = newJString("json"))
  if valid_589503 != nil:
    section.add "alt", valid_589503
  var valid_589504 = query.getOrDefault("oauth_token")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "oauth_token", valid_589504
  var valid_589505 = query.getOrDefault("callback")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "callback", valid_589505
  var valid_589506 = query.getOrDefault("access_token")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = nil)
  if valid_589506 != nil:
    section.add "access_token", valid_589506
  var valid_589507 = query.getOrDefault("uploadType")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = nil)
  if valid_589507 != nil:
    section.add "uploadType", valid_589507
  var valid_589508 = query.getOrDefault("key")
  valid_589508 = validateParameter(valid_589508, JString, required = false,
                                 default = nil)
  if valid_589508 != nil:
    section.add "key", valid_589508
  var valid_589509 = query.getOrDefault("$.xgafv")
  valid_589509 = validateParameter(valid_589509, JString, required = false,
                                 default = newJString("1"))
  if valid_589509 != nil:
    section.add "$.xgafv", valid_589509
  var valid_589510 = query.getOrDefault("prettyPrint")
  valid_589510 = validateParameter(valid_589510, JBool, required = false,
                                 default = newJBool(true))
  if valid_589510 != nil:
    section.add "prettyPrint", valid_589510
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

proc call*(call_589512: Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_589494;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports the status of dataflow WorkItems leased by a worker.
  ## 
  let valid = call_589512.validator(path, query, header, formData, body)
  let scheme = call_589512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589512.url(scheme.get, call_589512.host, call_589512.base,
                         call_589512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589512, url, valid)

proc call*(call_589513: Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_589494;
          jobId: string; projectId: string; location: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsLocationsJobsWorkItemsReportStatus
  ## Reports the status of dataflow WorkItems leased by a worker.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The job which the WorkItem is part of.
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
  ##   projectId: string (required)
  ##            : The project which owns the WorkItem's job.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) that
  ## contains the WorkItem's job.
  var path_589514 = newJObject()
  var query_589515 = newJObject()
  var body_589516 = newJObject()
  add(query_589515, "upload_protocol", newJString(uploadProtocol))
  add(query_589515, "fields", newJString(fields))
  add(query_589515, "quotaUser", newJString(quotaUser))
  add(query_589515, "alt", newJString(alt))
  add(path_589514, "jobId", newJString(jobId))
  add(query_589515, "oauth_token", newJString(oauthToken))
  add(query_589515, "callback", newJString(callback))
  add(query_589515, "access_token", newJString(accessToken))
  add(query_589515, "uploadType", newJString(uploadType))
  add(query_589515, "key", newJString(key))
  add(path_589514, "projectId", newJString(projectId))
  add(query_589515, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589516 = body
  add(query_589515, "prettyPrint", newJBool(prettyPrint))
  add(path_589514, "location", newJString(location))
  result = call_589513.call(path_589514, query_589515, nil, nil, body_589516)

var dataflowProjectsLocationsJobsWorkItemsReportStatus* = Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_589494(
    name: "dataflowProjectsLocationsJobsWorkItemsReportStatus",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/workItems:reportStatus",
    validator: validate_DataflowProjectsLocationsJobsWorkItemsReportStatus_589495,
    base: "/", url: url_DataflowProjectsLocationsJobsWorkItemsReportStatus_589496,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsSqlValidate_589517 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsSqlValidate_589519(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsSqlValidate_589518(path: JsonNode;
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
  var valid_589520 = path.getOrDefault("projectId")
  valid_589520 = validateParameter(valid_589520, JString, required = true,
                                 default = nil)
  if valid_589520 != nil:
    section.add "projectId", valid_589520
  var valid_589521 = path.getOrDefault("location")
  valid_589521 = validateParameter(valid_589521, JString, required = true,
                                 default = nil)
  if valid_589521 != nil:
    section.add "location", valid_589521
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
  ##   query: JString
  ##        : The sql query to validate.
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
  var valid_589522 = query.getOrDefault("upload_protocol")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "upload_protocol", valid_589522
  var valid_589523 = query.getOrDefault("fields")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "fields", valid_589523
  var valid_589524 = query.getOrDefault("quotaUser")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "quotaUser", valid_589524
  var valid_589525 = query.getOrDefault("alt")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = newJString("json"))
  if valid_589525 != nil:
    section.add "alt", valid_589525
  var valid_589526 = query.getOrDefault("query")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "query", valid_589526
  var valid_589527 = query.getOrDefault("oauth_token")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = nil)
  if valid_589527 != nil:
    section.add "oauth_token", valid_589527
  var valid_589528 = query.getOrDefault("callback")
  valid_589528 = validateParameter(valid_589528, JString, required = false,
                                 default = nil)
  if valid_589528 != nil:
    section.add "callback", valid_589528
  var valid_589529 = query.getOrDefault("access_token")
  valid_589529 = validateParameter(valid_589529, JString, required = false,
                                 default = nil)
  if valid_589529 != nil:
    section.add "access_token", valid_589529
  var valid_589530 = query.getOrDefault("uploadType")
  valid_589530 = validateParameter(valid_589530, JString, required = false,
                                 default = nil)
  if valid_589530 != nil:
    section.add "uploadType", valid_589530
  var valid_589531 = query.getOrDefault("key")
  valid_589531 = validateParameter(valid_589531, JString, required = false,
                                 default = nil)
  if valid_589531 != nil:
    section.add "key", valid_589531
  var valid_589532 = query.getOrDefault("$.xgafv")
  valid_589532 = validateParameter(valid_589532, JString, required = false,
                                 default = newJString("1"))
  if valid_589532 != nil:
    section.add "$.xgafv", valid_589532
  var valid_589533 = query.getOrDefault("prettyPrint")
  valid_589533 = validateParameter(valid_589533, JBool, required = false,
                                 default = newJBool(true))
  if valid_589533 != nil:
    section.add "prettyPrint", valid_589533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589534: Call_DataflowProjectsLocationsSqlValidate_589517;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates a GoogleSQL query for Cloud Dataflow syntax. Will always
  ## confirm the given query parses correctly, and if able to look up
  ## schema information from DataCatalog, will validate that the query
  ## analyzes properly as well.
  ## 
  let valid = call_589534.validator(path, query, header, formData, body)
  let scheme = call_589534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589534.url(scheme.get, call_589534.host, call_589534.base,
                         call_589534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589534, url, valid)

proc call*(call_589535: Call_DataflowProjectsLocationsSqlValidate_589517;
          projectId: string; location: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsLocationsSqlValidate
  ## Validates a GoogleSQL query for Cloud Dataflow syntax. Will always
  ## confirm the given query parses correctly, and if able to look up
  ## schema information from DataCatalog, will validate that the query
  ## analyzes properly as well.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : The sql query to validate.
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
  ##   projectId: string (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  var path_589536 = newJObject()
  var query_589537 = newJObject()
  add(query_589537, "upload_protocol", newJString(uploadProtocol))
  add(query_589537, "fields", newJString(fields))
  add(query_589537, "quotaUser", newJString(quotaUser))
  add(query_589537, "alt", newJString(alt))
  add(query_589537, "query", newJString(query))
  add(query_589537, "oauth_token", newJString(oauthToken))
  add(query_589537, "callback", newJString(callback))
  add(query_589537, "access_token", newJString(accessToken))
  add(query_589537, "uploadType", newJString(uploadType))
  add(query_589537, "key", newJString(key))
  add(path_589536, "projectId", newJString(projectId))
  add(query_589537, "$.xgafv", newJString(Xgafv))
  add(query_589537, "prettyPrint", newJBool(prettyPrint))
  add(path_589536, "location", newJString(location))
  result = call_589535.call(path_589536, query_589537, nil, nil, nil)

var dataflowProjectsLocationsSqlValidate* = Call_DataflowProjectsLocationsSqlValidate_589517(
    name: "dataflowProjectsLocationsSqlValidate", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/sql:validate",
    validator: validate_DataflowProjectsLocationsSqlValidate_589518, base: "/",
    url: url_DataflowProjectsLocationsSqlValidate_589519, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesCreate_589538 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsTemplatesCreate_589540(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsTemplatesCreate_589539(path: JsonNode;
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
  var valid_589541 = path.getOrDefault("projectId")
  valid_589541 = validateParameter(valid_589541, JString, required = true,
                                 default = nil)
  if valid_589541 != nil:
    section.add "projectId", valid_589541
  var valid_589542 = path.getOrDefault("location")
  valid_589542 = validateParameter(valid_589542, JString, required = true,
                                 default = nil)
  if valid_589542 != nil:
    section.add "location", valid_589542
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
  var valid_589543 = query.getOrDefault("upload_protocol")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "upload_protocol", valid_589543
  var valid_589544 = query.getOrDefault("fields")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "fields", valid_589544
  var valid_589545 = query.getOrDefault("quotaUser")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "quotaUser", valid_589545
  var valid_589546 = query.getOrDefault("alt")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = newJString("json"))
  if valid_589546 != nil:
    section.add "alt", valid_589546
  var valid_589547 = query.getOrDefault("oauth_token")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = nil)
  if valid_589547 != nil:
    section.add "oauth_token", valid_589547
  var valid_589548 = query.getOrDefault("callback")
  valid_589548 = validateParameter(valid_589548, JString, required = false,
                                 default = nil)
  if valid_589548 != nil:
    section.add "callback", valid_589548
  var valid_589549 = query.getOrDefault("access_token")
  valid_589549 = validateParameter(valid_589549, JString, required = false,
                                 default = nil)
  if valid_589549 != nil:
    section.add "access_token", valid_589549
  var valid_589550 = query.getOrDefault("uploadType")
  valid_589550 = validateParameter(valid_589550, JString, required = false,
                                 default = nil)
  if valid_589550 != nil:
    section.add "uploadType", valid_589550
  var valid_589551 = query.getOrDefault("key")
  valid_589551 = validateParameter(valid_589551, JString, required = false,
                                 default = nil)
  if valid_589551 != nil:
    section.add "key", valid_589551
  var valid_589552 = query.getOrDefault("$.xgafv")
  valid_589552 = validateParameter(valid_589552, JString, required = false,
                                 default = newJString("1"))
  if valid_589552 != nil:
    section.add "$.xgafv", valid_589552
  var valid_589553 = query.getOrDefault("prettyPrint")
  valid_589553 = validateParameter(valid_589553, JBool, required = false,
                                 default = newJBool(true))
  if valid_589553 != nil:
    section.add "prettyPrint", valid_589553
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

proc call*(call_589555: Call_DataflowProjectsLocationsTemplatesCreate_589538;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job from a template.
  ## 
  let valid = call_589555.validator(path, query, header, formData, body)
  let scheme = call_589555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589555.url(scheme.get, call_589555.host, call_589555.base,
                         call_589555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589555, url, valid)

proc call*(call_589556: Call_DataflowProjectsLocationsTemplatesCreate_589538;
          projectId: string; location: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsLocationsTemplatesCreate
  ## Creates a Cloud Dataflow job from a template.
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
  ##   projectId: string (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  var path_589557 = newJObject()
  var query_589558 = newJObject()
  var body_589559 = newJObject()
  add(query_589558, "upload_protocol", newJString(uploadProtocol))
  add(query_589558, "fields", newJString(fields))
  add(query_589558, "quotaUser", newJString(quotaUser))
  add(query_589558, "alt", newJString(alt))
  add(query_589558, "oauth_token", newJString(oauthToken))
  add(query_589558, "callback", newJString(callback))
  add(query_589558, "access_token", newJString(accessToken))
  add(query_589558, "uploadType", newJString(uploadType))
  add(query_589558, "key", newJString(key))
  add(path_589557, "projectId", newJString(projectId))
  add(query_589558, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589559 = body
  add(query_589558, "prettyPrint", newJBool(prettyPrint))
  add(path_589557, "location", newJString(location))
  result = call_589556.call(path_589557, query_589558, nil, nil, body_589559)

var dataflowProjectsLocationsTemplatesCreate* = Call_DataflowProjectsLocationsTemplatesCreate_589538(
    name: "dataflowProjectsLocationsTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates",
    validator: validate_DataflowProjectsLocationsTemplatesCreate_589539,
    base: "/", url: url_DataflowProjectsLocationsTemplatesCreate_589540,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesGet_589560 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsTemplatesGet_589562(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsTemplatesGet_589561(path: JsonNode;
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
  var valid_589563 = path.getOrDefault("projectId")
  valid_589563 = validateParameter(valid_589563, JString, required = true,
                                 default = nil)
  if valid_589563 != nil:
    section.add "projectId", valid_589563
  var valid_589564 = path.getOrDefault("location")
  valid_589564 = validateParameter(valid_589564, JString, required = true,
                                 default = nil)
  if valid_589564 != nil:
    section.add "location", valid_589564
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : The view to retrieve. Defaults to METADATA_ONLY.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   gcsPath: JString
  ##          : Required. A Cloud Storage path to the template from which to
  ## create the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
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
  var valid_589565 = query.getOrDefault("upload_protocol")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "upload_protocol", valid_589565
  var valid_589566 = query.getOrDefault("fields")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = nil)
  if valid_589566 != nil:
    section.add "fields", valid_589566
  var valid_589567 = query.getOrDefault("view")
  valid_589567 = validateParameter(valid_589567, JString, required = false,
                                 default = newJString("METADATA_ONLY"))
  if valid_589567 != nil:
    section.add "view", valid_589567
  var valid_589568 = query.getOrDefault("quotaUser")
  valid_589568 = validateParameter(valid_589568, JString, required = false,
                                 default = nil)
  if valid_589568 != nil:
    section.add "quotaUser", valid_589568
  var valid_589569 = query.getOrDefault("alt")
  valid_589569 = validateParameter(valid_589569, JString, required = false,
                                 default = newJString("json"))
  if valid_589569 != nil:
    section.add "alt", valid_589569
  var valid_589570 = query.getOrDefault("gcsPath")
  valid_589570 = validateParameter(valid_589570, JString, required = false,
                                 default = nil)
  if valid_589570 != nil:
    section.add "gcsPath", valid_589570
  var valid_589571 = query.getOrDefault("oauth_token")
  valid_589571 = validateParameter(valid_589571, JString, required = false,
                                 default = nil)
  if valid_589571 != nil:
    section.add "oauth_token", valid_589571
  var valid_589572 = query.getOrDefault("callback")
  valid_589572 = validateParameter(valid_589572, JString, required = false,
                                 default = nil)
  if valid_589572 != nil:
    section.add "callback", valid_589572
  var valid_589573 = query.getOrDefault("access_token")
  valid_589573 = validateParameter(valid_589573, JString, required = false,
                                 default = nil)
  if valid_589573 != nil:
    section.add "access_token", valid_589573
  var valid_589574 = query.getOrDefault("uploadType")
  valid_589574 = validateParameter(valid_589574, JString, required = false,
                                 default = nil)
  if valid_589574 != nil:
    section.add "uploadType", valid_589574
  var valid_589575 = query.getOrDefault("key")
  valid_589575 = validateParameter(valid_589575, JString, required = false,
                                 default = nil)
  if valid_589575 != nil:
    section.add "key", valid_589575
  var valid_589576 = query.getOrDefault("$.xgafv")
  valid_589576 = validateParameter(valid_589576, JString, required = false,
                                 default = newJString("1"))
  if valid_589576 != nil:
    section.add "$.xgafv", valid_589576
  var valid_589577 = query.getOrDefault("prettyPrint")
  valid_589577 = validateParameter(valid_589577, JBool, required = false,
                                 default = newJBool(true))
  if valid_589577 != nil:
    section.add "prettyPrint", valid_589577
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589578: Call_DataflowProjectsLocationsTemplatesGet_589560;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the template associated with a template.
  ## 
  let valid = call_589578.validator(path, query, header, formData, body)
  let scheme = call_589578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589578.url(scheme.get, call_589578.host, call_589578.base,
                         call_589578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589578, url, valid)

proc call*(call_589579: Call_DataflowProjectsLocationsTemplatesGet_589560;
          projectId: string; location: string; uploadProtocol: string = "";
          fields: string = ""; view: string = "METADATA_ONLY"; quotaUser: string = "";
          alt: string = "json"; gcsPath: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsLocationsTemplatesGet
  ## Get the template associated with a template.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : The view to retrieve. Defaults to METADATA_ONLY.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   gcsPath: string
  ##          : Required. A Cloud Storage path to the template from which to
  ## create the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
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
  ##   projectId: string (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  var path_589580 = newJObject()
  var query_589581 = newJObject()
  add(query_589581, "upload_protocol", newJString(uploadProtocol))
  add(query_589581, "fields", newJString(fields))
  add(query_589581, "view", newJString(view))
  add(query_589581, "quotaUser", newJString(quotaUser))
  add(query_589581, "alt", newJString(alt))
  add(query_589581, "gcsPath", newJString(gcsPath))
  add(query_589581, "oauth_token", newJString(oauthToken))
  add(query_589581, "callback", newJString(callback))
  add(query_589581, "access_token", newJString(accessToken))
  add(query_589581, "uploadType", newJString(uploadType))
  add(query_589581, "key", newJString(key))
  add(path_589580, "projectId", newJString(projectId))
  add(query_589581, "$.xgafv", newJString(Xgafv))
  add(query_589581, "prettyPrint", newJBool(prettyPrint))
  add(path_589580, "location", newJString(location))
  result = call_589579.call(path_589580, query_589581, nil, nil, nil)

var dataflowProjectsLocationsTemplatesGet* = Call_DataflowProjectsLocationsTemplatesGet_589560(
    name: "dataflowProjectsLocationsTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates:get",
    validator: validate_DataflowProjectsLocationsTemplatesGet_589561, base: "/",
    url: url_DataflowProjectsLocationsTemplatesGet_589562, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesLaunch_589582 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsLocationsTemplatesLaunch_589584(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsTemplatesLaunch_589583(path: JsonNode;
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
  var valid_589585 = path.getOrDefault("projectId")
  valid_589585 = validateParameter(valid_589585, JString, required = true,
                                 default = nil)
  if valid_589585 != nil:
    section.add "projectId", valid_589585
  var valid_589586 = path.getOrDefault("location")
  valid_589586 = validateParameter(valid_589586, JString, required = true,
                                 default = nil)
  if valid_589586 != nil:
    section.add "location", valid_589586
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   dynamicTemplate.stagingLocation: JString
  ##                                  : Cloud Storage path for staging dependencies.
  ## Must be a valid Cloud Storage URL, beginning with `gs://`.
  ##   alt: JString
  ##      : Data format for response.
  ##   dynamicTemplate.gcsPath: JString
  ##                          : Path to dynamic template spec file on GCS.
  ## The file must be a Json serialized DynamicTemplateFieSpec object.
  ##   gcsPath: JString
  ##          : A Cloud Storage path to the template from which to create
  ## the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   validateOnly: JBool
  ##               : If true, the request is validated but not actually executed.
  ## Defaults to false.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589587 = query.getOrDefault("upload_protocol")
  valid_589587 = validateParameter(valid_589587, JString, required = false,
                                 default = nil)
  if valid_589587 != nil:
    section.add "upload_protocol", valid_589587
  var valid_589588 = query.getOrDefault("fields")
  valid_589588 = validateParameter(valid_589588, JString, required = false,
                                 default = nil)
  if valid_589588 != nil:
    section.add "fields", valid_589588
  var valid_589589 = query.getOrDefault("quotaUser")
  valid_589589 = validateParameter(valid_589589, JString, required = false,
                                 default = nil)
  if valid_589589 != nil:
    section.add "quotaUser", valid_589589
  var valid_589590 = query.getOrDefault("dynamicTemplate.stagingLocation")
  valid_589590 = validateParameter(valid_589590, JString, required = false,
                                 default = nil)
  if valid_589590 != nil:
    section.add "dynamicTemplate.stagingLocation", valid_589590
  var valid_589591 = query.getOrDefault("alt")
  valid_589591 = validateParameter(valid_589591, JString, required = false,
                                 default = newJString("json"))
  if valid_589591 != nil:
    section.add "alt", valid_589591
  var valid_589592 = query.getOrDefault("dynamicTemplate.gcsPath")
  valid_589592 = validateParameter(valid_589592, JString, required = false,
                                 default = nil)
  if valid_589592 != nil:
    section.add "dynamicTemplate.gcsPath", valid_589592
  var valid_589593 = query.getOrDefault("gcsPath")
  valid_589593 = validateParameter(valid_589593, JString, required = false,
                                 default = nil)
  if valid_589593 != nil:
    section.add "gcsPath", valid_589593
  var valid_589594 = query.getOrDefault("oauth_token")
  valid_589594 = validateParameter(valid_589594, JString, required = false,
                                 default = nil)
  if valid_589594 != nil:
    section.add "oauth_token", valid_589594
  var valid_589595 = query.getOrDefault("callback")
  valid_589595 = validateParameter(valid_589595, JString, required = false,
                                 default = nil)
  if valid_589595 != nil:
    section.add "callback", valid_589595
  var valid_589596 = query.getOrDefault("access_token")
  valid_589596 = validateParameter(valid_589596, JString, required = false,
                                 default = nil)
  if valid_589596 != nil:
    section.add "access_token", valid_589596
  var valid_589597 = query.getOrDefault("uploadType")
  valid_589597 = validateParameter(valid_589597, JString, required = false,
                                 default = nil)
  if valid_589597 != nil:
    section.add "uploadType", valid_589597
  var valid_589598 = query.getOrDefault("validateOnly")
  valid_589598 = validateParameter(valid_589598, JBool, required = false, default = nil)
  if valid_589598 != nil:
    section.add "validateOnly", valid_589598
  var valid_589599 = query.getOrDefault("key")
  valid_589599 = validateParameter(valid_589599, JString, required = false,
                                 default = nil)
  if valid_589599 != nil:
    section.add "key", valid_589599
  var valid_589600 = query.getOrDefault("$.xgafv")
  valid_589600 = validateParameter(valid_589600, JString, required = false,
                                 default = newJString("1"))
  if valid_589600 != nil:
    section.add "$.xgafv", valid_589600
  var valid_589601 = query.getOrDefault("prettyPrint")
  valid_589601 = validateParameter(valid_589601, JBool, required = false,
                                 default = newJBool(true))
  if valid_589601 != nil:
    section.add "prettyPrint", valid_589601
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

proc call*(call_589603: Call_DataflowProjectsLocationsTemplatesLaunch_589582;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Launch a template.
  ## 
  let valid = call_589603.validator(path, query, header, formData, body)
  let scheme = call_589603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589603.url(scheme.get, call_589603.host, call_589603.base,
                         call_589603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589603, url, valid)

proc call*(call_589604: Call_DataflowProjectsLocationsTemplatesLaunch_589582;
          projectId: string; location: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = "";
          dynamicTemplateStagingLocation: string = ""; alt: string = "json";
          dynamicTemplateGcsPath: string = ""; gcsPath: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; validateOnly: bool = false; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsLocationsTemplatesLaunch
  ## Launch a template.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   dynamicTemplateStagingLocation: string
  ##                                 : Cloud Storage path for staging dependencies.
  ## Must be a valid Cloud Storage URL, beginning with `gs://`.
  ##   alt: string
  ##      : Data format for response.
  ##   dynamicTemplateGcsPath: string
  ##                         : Path to dynamic template spec file on GCS.
  ## The file must be a Json serialized DynamicTemplateFieSpec object.
  ##   gcsPath: string
  ##          : A Cloud Storage path to the template from which to create
  ## the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   validateOnly: bool
  ##               : If true, the request is validated but not actually executed.
  ## Defaults to false.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   location: string (required)
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  var path_589605 = newJObject()
  var query_589606 = newJObject()
  var body_589607 = newJObject()
  add(query_589606, "upload_protocol", newJString(uploadProtocol))
  add(query_589606, "fields", newJString(fields))
  add(query_589606, "quotaUser", newJString(quotaUser))
  add(query_589606, "dynamicTemplate.stagingLocation",
      newJString(dynamicTemplateStagingLocation))
  add(query_589606, "alt", newJString(alt))
  add(query_589606, "dynamicTemplate.gcsPath", newJString(dynamicTemplateGcsPath))
  add(query_589606, "gcsPath", newJString(gcsPath))
  add(query_589606, "oauth_token", newJString(oauthToken))
  add(query_589606, "callback", newJString(callback))
  add(query_589606, "access_token", newJString(accessToken))
  add(query_589606, "uploadType", newJString(uploadType))
  add(query_589606, "validateOnly", newJBool(validateOnly))
  add(query_589606, "key", newJString(key))
  add(path_589605, "projectId", newJString(projectId))
  add(query_589606, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589607 = body
  add(query_589606, "prettyPrint", newJBool(prettyPrint))
  add(path_589605, "location", newJString(location))
  result = call_589604.call(path_589605, query_589606, nil, nil, body_589607)

var dataflowProjectsLocationsTemplatesLaunch* = Call_DataflowProjectsLocationsTemplatesLaunch_589582(
    name: "dataflowProjectsLocationsTemplatesLaunch", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates:launch",
    validator: validate_DataflowProjectsLocationsTemplatesLaunch_589583,
    base: "/", url: url_DataflowProjectsLocationsTemplatesLaunch_589584,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesCreate_589608 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsTemplatesCreate_589610(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsTemplatesCreate_589609(path: JsonNode;
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
  var valid_589611 = path.getOrDefault("projectId")
  valid_589611 = validateParameter(valid_589611, JString, required = true,
                                 default = nil)
  if valid_589611 != nil:
    section.add "projectId", valid_589611
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
  var valid_589612 = query.getOrDefault("upload_protocol")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "upload_protocol", valid_589612
  var valid_589613 = query.getOrDefault("fields")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = nil)
  if valid_589613 != nil:
    section.add "fields", valid_589613
  var valid_589614 = query.getOrDefault("quotaUser")
  valid_589614 = validateParameter(valid_589614, JString, required = false,
                                 default = nil)
  if valid_589614 != nil:
    section.add "quotaUser", valid_589614
  var valid_589615 = query.getOrDefault("alt")
  valid_589615 = validateParameter(valid_589615, JString, required = false,
                                 default = newJString("json"))
  if valid_589615 != nil:
    section.add "alt", valid_589615
  var valid_589616 = query.getOrDefault("oauth_token")
  valid_589616 = validateParameter(valid_589616, JString, required = false,
                                 default = nil)
  if valid_589616 != nil:
    section.add "oauth_token", valid_589616
  var valid_589617 = query.getOrDefault("callback")
  valid_589617 = validateParameter(valid_589617, JString, required = false,
                                 default = nil)
  if valid_589617 != nil:
    section.add "callback", valid_589617
  var valid_589618 = query.getOrDefault("access_token")
  valid_589618 = validateParameter(valid_589618, JString, required = false,
                                 default = nil)
  if valid_589618 != nil:
    section.add "access_token", valid_589618
  var valid_589619 = query.getOrDefault("uploadType")
  valid_589619 = validateParameter(valid_589619, JString, required = false,
                                 default = nil)
  if valid_589619 != nil:
    section.add "uploadType", valid_589619
  var valid_589620 = query.getOrDefault("key")
  valid_589620 = validateParameter(valid_589620, JString, required = false,
                                 default = nil)
  if valid_589620 != nil:
    section.add "key", valid_589620
  var valid_589621 = query.getOrDefault("$.xgafv")
  valid_589621 = validateParameter(valid_589621, JString, required = false,
                                 default = newJString("1"))
  if valid_589621 != nil:
    section.add "$.xgafv", valid_589621
  var valid_589622 = query.getOrDefault("prettyPrint")
  valid_589622 = validateParameter(valid_589622, JBool, required = false,
                                 default = newJBool(true))
  if valid_589622 != nil:
    section.add "prettyPrint", valid_589622
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

proc call*(call_589624: Call_DataflowProjectsTemplatesCreate_589608;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job from a template.
  ## 
  let valid = call_589624.validator(path, query, header, formData, body)
  let scheme = call_589624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589624.url(scheme.get, call_589624.host, call_589624.base,
                         call_589624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589624, url, valid)

proc call*(call_589625: Call_DataflowProjectsTemplatesCreate_589608;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dataflowProjectsTemplatesCreate
  ## Creates a Cloud Dataflow job from a template.
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
  ##   projectId: string (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589626 = newJObject()
  var query_589627 = newJObject()
  var body_589628 = newJObject()
  add(query_589627, "upload_protocol", newJString(uploadProtocol))
  add(query_589627, "fields", newJString(fields))
  add(query_589627, "quotaUser", newJString(quotaUser))
  add(query_589627, "alt", newJString(alt))
  add(query_589627, "oauth_token", newJString(oauthToken))
  add(query_589627, "callback", newJString(callback))
  add(query_589627, "access_token", newJString(accessToken))
  add(query_589627, "uploadType", newJString(uploadType))
  add(query_589627, "key", newJString(key))
  add(path_589626, "projectId", newJString(projectId))
  add(query_589627, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589628 = body
  add(query_589627, "prettyPrint", newJBool(prettyPrint))
  result = call_589625.call(path_589626, query_589627, nil, nil, body_589628)

var dataflowProjectsTemplatesCreate* = Call_DataflowProjectsTemplatesCreate_589608(
    name: "dataflowProjectsTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates",
    validator: validate_DataflowProjectsTemplatesCreate_589609, base: "/",
    url: url_DataflowProjectsTemplatesCreate_589610, schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesGet_589629 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsTemplatesGet_589631(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsTemplatesGet_589630(path: JsonNode; query: JsonNode;
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
  var valid_589632 = path.getOrDefault("projectId")
  valid_589632 = validateParameter(valid_589632, JString, required = true,
                                 default = nil)
  if valid_589632 != nil:
    section.add "projectId", valid_589632
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : The view to retrieve. Defaults to METADATA_ONLY.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   gcsPath: JString
  ##          : Required. A Cloud Storage path to the template from which to
  ## create the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589633 = query.getOrDefault("upload_protocol")
  valid_589633 = validateParameter(valid_589633, JString, required = false,
                                 default = nil)
  if valid_589633 != nil:
    section.add "upload_protocol", valid_589633
  var valid_589634 = query.getOrDefault("fields")
  valid_589634 = validateParameter(valid_589634, JString, required = false,
                                 default = nil)
  if valid_589634 != nil:
    section.add "fields", valid_589634
  var valid_589635 = query.getOrDefault("view")
  valid_589635 = validateParameter(valid_589635, JString, required = false,
                                 default = newJString("METADATA_ONLY"))
  if valid_589635 != nil:
    section.add "view", valid_589635
  var valid_589636 = query.getOrDefault("quotaUser")
  valid_589636 = validateParameter(valid_589636, JString, required = false,
                                 default = nil)
  if valid_589636 != nil:
    section.add "quotaUser", valid_589636
  var valid_589637 = query.getOrDefault("alt")
  valid_589637 = validateParameter(valid_589637, JString, required = false,
                                 default = newJString("json"))
  if valid_589637 != nil:
    section.add "alt", valid_589637
  var valid_589638 = query.getOrDefault("gcsPath")
  valid_589638 = validateParameter(valid_589638, JString, required = false,
                                 default = nil)
  if valid_589638 != nil:
    section.add "gcsPath", valid_589638
  var valid_589639 = query.getOrDefault("oauth_token")
  valid_589639 = validateParameter(valid_589639, JString, required = false,
                                 default = nil)
  if valid_589639 != nil:
    section.add "oauth_token", valid_589639
  var valid_589640 = query.getOrDefault("callback")
  valid_589640 = validateParameter(valid_589640, JString, required = false,
                                 default = nil)
  if valid_589640 != nil:
    section.add "callback", valid_589640
  var valid_589641 = query.getOrDefault("access_token")
  valid_589641 = validateParameter(valid_589641, JString, required = false,
                                 default = nil)
  if valid_589641 != nil:
    section.add "access_token", valid_589641
  var valid_589642 = query.getOrDefault("uploadType")
  valid_589642 = validateParameter(valid_589642, JString, required = false,
                                 default = nil)
  if valid_589642 != nil:
    section.add "uploadType", valid_589642
  var valid_589643 = query.getOrDefault("location")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = nil)
  if valid_589643 != nil:
    section.add "location", valid_589643
  var valid_589644 = query.getOrDefault("key")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "key", valid_589644
  var valid_589645 = query.getOrDefault("$.xgafv")
  valid_589645 = validateParameter(valid_589645, JString, required = false,
                                 default = newJString("1"))
  if valid_589645 != nil:
    section.add "$.xgafv", valid_589645
  var valid_589646 = query.getOrDefault("prettyPrint")
  valid_589646 = validateParameter(valid_589646, JBool, required = false,
                                 default = newJBool(true))
  if valid_589646 != nil:
    section.add "prettyPrint", valid_589646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589647: Call_DataflowProjectsTemplatesGet_589629; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the template associated with a template.
  ## 
  let valid = call_589647.validator(path, query, header, formData, body)
  let scheme = call_589647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589647.url(scheme.get, call_589647.host, call_589647.base,
                         call_589647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589647, url, valid)

proc call*(call_589648: Call_DataflowProjectsTemplatesGet_589629;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          view: string = "METADATA_ONLY"; quotaUser: string = ""; alt: string = "json";
          gcsPath: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; location: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsTemplatesGet
  ## Get the template associated with a template.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : The view to retrieve. Defaults to METADATA_ONLY.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   gcsPath: string
  ##          : Required. A Cloud Storage path to the template from which to
  ## create the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589649 = newJObject()
  var query_589650 = newJObject()
  add(query_589650, "upload_protocol", newJString(uploadProtocol))
  add(query_589650, "fields", newJString(fields))
  add(query_589650, "view", newJString(view))
  add(query_589650, "quotaUser", newJString(quotaUser))
  add(query_589650, "alt", newJString(alt))
  add(query_589650, "gcsPath", newJString(gcsPath))
  add(query_589650, "oauth_token", newJString(oauthToken))
  add(query_589650, "callback", newJString(callback))
  add(query_589650, "access_token", newJString(accessToken))
  add(query_589650, "uploadType", newJString(uploadType))
  add(query_589650, "location", newJString(location))
  add(query_589650, "key", newJString(key))
  add(path_589649, "projectId", newJString(projectId))
  add(query_589650, "$.xgafv", newJString(Xgafv))
  add(query_589650, "prettyPrint", newJBool(prettyPrint))
  result = call_589648.call(path_589649, query_589650, nil, nil, nil)

var dataflowProjectsTemplatesGet* = Call_DataflowProjectsTemplatesGet_589629(
    name: "dataflowProjectsTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates:get",
    validator: validate_DataflowProjectsTemplatesGet_589630, base: "/",
    url: url_DataflowProjectsTemplatesGet_589631, schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesLaunch_589651 = ref object of OpenApiRestCall_588450
proc url_DataflowProjectsTemplatesLaunch_589653(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsTemplatesLaunch_589652(path: JsonNode;
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
  var valid_589654 = path.getOrDefault("projectId")
  valid_589654 = validateParameter(valid_589654, JString, required = true,
                                 default = nil)
  if valid_589654 != nil:
    section.add "projectId", valid_589654
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   dynamicTemplate.stagingLocation: JString
  ##                                  : Cloud Storage path for staging dependencies.
  ## Must be a valid Cloud Storage URL, beginning with `gs://`.
  ##   alt: JString
  ##      : Data format for response.
  ##   dynamicTemplate.gcsPath: JString
  ##                          : Path to dynamic template spec file on GCS.
  ## The file must be a Json serialized DynamicTemplateFieSpec object.
  ##   gcsPath: JString
  ##          : A Cloud Storage path to the template from which to create
  ## the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   location: JString
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  ##   validateOnly: JBool
  ##               : If true, the request is validated but not actually executed.
  ## Defaults to false.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589655 = query.getOrDefault("upload_protocol")
  valid_589655 = validateParameter(valid_589655, JString, required = false,
                                 default = nil)
  if valid_589655 != nil:
    section.add "upload_protocol", valid_589655
  var valid_589656 = query.getOrDefault("fields")
  valid_589656 = validateParameter(valid_589656, JString, required = false,
                                 default = nil)
  if valid_589656 != nil:
    section.add "fields", valid_589656
  var valid_589657 = query.getOrDefault("quotaUser")
  valid_589657 = validateParameter(valid_589657, JString, required = false,
                                 default = nil)
  if valid_589657 != nil:
    section.add "quotaUser", valid_589657
  var valid_589658 = query.getOrDefault("dynamicTemplate.stagingLocation")
  valid_589658 = validateParameter(valid_589658, JString, required = false,
                                 default = nil)
  if valid_589658 != nil:
    section.add "dynamicTemplate.stagingLocation", valid_589658
  var valid_589659 = query.getOrDefault("alt")
  valid_589659 = validateParameter(valid_589659, JString, required = false,
                                 default = newJString("json"))
  if valid_589659 != nil:
    section.add "alt", valid_589659
  var valid_589660 = query.getOrDefault("dynamicTemplate.gcsPath")
  valid_589660 = validateParameter(valid_589660, JString, required = false,
                                 default = nil)
  if valid_589660 != nil:
    section.add "dynamicTemplate.gcsPath", valid_589660
  var valid_589661 = query.getOrDefault("gcsPath")
  valid_589661 = validateParameter(valid_589661, JString, required = false,
                                 default = nil)
  if valid_589661 != nil:
    section.add "gcsPath", valid_589661
  var valid_589662 = query.getOrDefault("oauth_token")
  valid_589662 = validateParameter(valid_589662, JString, required = false,
                                 default = nil)
  if valid_589662 != nil:
    section.add "oauth_token", valid_589662
  var valid_589663 = query.getOrDefault("callback")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = nil)
  if valid_589663 != nil:
    section.add "callback", valid_589663
  var valid_589664 = query.getOrDefault("access_token")
  valid_589664 = validateParameter(valid_589664, JString, required = false,
                                 default = nil)
  if valid_589664 != nil:
    section.add "access_token", valid_589664
  var valid_589665 = query.getOrDefault("uploadType")
  valid_589665 = validateParameter(valid_589665, JString, required = false,
                                 default = nil)
  if valid_589665 != nil:
    section.add "uploadType", valid_589665
  var valid_589666 = query.getOrDefault("location")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = nil)
  if valid_589666 != nil:
    section.add "location", valid_589666
  var valid_589667 = query.getOrDefault("validateOnly")
  valid_589667 = validateParameter(valid_589667, JBool, required = false, default = nil)
  if valid_589667 != nil:
    section.add "validateOnly", valid_589667
  var valid_589668 = query.getOrDefault("key")
  valid_589668 = validateParameter(valid_589668, JString, required = false,
                                 default = nil)
  if valid_589668 != nil:
    section.add "key", valid_589668
  var valid_589669 = query.getOrDefault("$.xgafv")
  valid_589669 = validateParameter(valid_589669, JString, required = false,
                                 default = newJString("1"))
  if valid_589669 != nil:
    section.add "$.xgafv", valid_589669
  var valid_589670 = query.getOrDefault("prettyPrint")
  valid_589670 = validateParameter(valid_589670, JBool, required = false,
                                 default = newJBool(true))
  if valid_589670 != nil:
    section.add "prettyPrint", valid_589670
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

proc call*(call_589672: Call_DataflowProjectsTemplatesLaunch_589651;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Launch a template.
  ## 
  let valid = call_589672.validator(path, query, header, formData, body)
  let scheme = call_589672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589672.url(scheme.get, call_589672.host, call_589672.base,
                         call_589672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589672, url, valid)

proc call*(call_589673: Call_DataflowProjectsTemplatesLaunch_589651;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; dynamicTemplateStagingLocation: string = "";
          alt: string = "json"; dynamicTemplateGcsPath: string = "";
          gcsPath: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; location: string = "";
          validateOnly: bool = false; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dataflowProjectsTemplatesLaunch
  ## Launch a template.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   dynamicTemplateStagingLocation: string
  ##                                 : Cloud Storage path for staging dependencies.
  ## Must be a valid Cloud Storage URL, beginning with `gs://`.
  ##   alt: string
  ##      : Data format for response.
  ##   dynamicTemplateGcsPath: string
  ##                         : Path to dynamic template spec file on GCS.
  ## The file must be a Json serialized DynamicTemplateFieSpec object.
  ##   gcsPath: string
  ##          : A Cloud Storage path to the template from which to create
  ## the job.
  ## Must be valid Cloud Storage URL, beginning with 'gs://'.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   location: string
  ##           : The [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints) to
  ## which to direct the request.
  ##   validateOnly: bool
  ##               : If true, the request is validated but not actually executed.
  ## Defaults to false.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required. The ID of the Cloud Platform project that the job belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589674 = newJObject()
  var query_589675 = newJObject()
  var body_589676 = newJObject()
  add(query_589675, "upload_protocol", newJString(uploadProtocol))
  add(query_589675, "fields", newJString(fields))
  add(query_589675, "quotaUser", newJString(quotaUser))
  add(query_589675, "dynamicTemplate.stagingLocation",
      newJString(dynamicTemplateStagingLocation))
  add(query_589675, "alt", newJString(alt))
  add(query_589675, "dynamicTemplate.gcsPath", newJString(dynamicTemplateGcsPath))
  add(query_589675, "gcsPath", newJString(gcsPath))
  add(query_589675, "oauth_token", newJString(oauthToken))
  add(query_589675, "callback", newJString(callback))
  add(query_589675, "access_token", newJString(accessToken))
  add(query_589675, "uploadType", newJString(uploadType))
  add(query_589675, "location", newJString(location))
  add(query_589675, "validateOnly", newJBool(validateOnly))
  add(query_589675, "key", newJString(key))
  add(path_589674, "projectId", newJString(projectId))
  add(query_589675, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589676 = body
  add(query_589675, "prettyPrint", newJBool(prettyPrint))
  result = call_589673.call(path_589674, query_589675, nil, nil, body_589676)

var dataflowProjectsTemplatesLaunch* = Call_DataflowProjectsTemplatesLaunch_589651(
    name: "dataflowProjectsTemplatesLaunch", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates:launch",
    validator: validate_DataflowProjectsTemplatesLaunch_589652, base: "/",
    url: url_DataflowProjectsTemplatesLaunch_589653, schemes: {Scheme.Https})
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
