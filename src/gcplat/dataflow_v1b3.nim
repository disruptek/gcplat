
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  gcpServiceName = "dataflow"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DataflowProjectsWorkerMessages_579690 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsWorkerMessages_579692(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsWorkerMessages_579691(path: JsonNode;
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
  var valid_579818 = path.getOrDefault("projectId")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "projectId", valid_579818
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
  var valid_579819 = query.getOrDefault("upload_protocol")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "upload_protocol", valid_579819
  var valid_579820 = query.getOrDefault("fields")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "fields", valid_579820
  var valid_579821 = query.getOrDefault("quotaUser")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "quotaUser", valid_579821
  var valid_579835 = query.getOrDefault("alt")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = newJString("json"))
  if valid_579835 != nil:
    section.add "alt", valid_579835
  var valid_579836 = query.getOrDefault("oauth_token")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "oauth_token", valid_579836
  var valid_579837 = query.getOrDefault("callback")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "callback", valid_579837
  var valid_579838 = query.getOrDefault("access_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "access_token", valid_579838
  var valid_579839 = query.getOrDefault("uploadType")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "uploadType", valid_579839
  var valid_579840 = query.getOrDefault("key")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "key", valid_579840
  var valid_579841 = query.getOrDefault("$.xgafv")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = newJString("1"))
  if valid_579841 != nil:
    section.add "$.xgafv", valid_579841
  var valid_579842 = query.getOrDefault("prettyPrint")
  valid_579842 = validateParameter(valid_579842, JBool, required = false,
                                 default = newJBool(true))
  if valid_579842 != nil:
    section.add "prettyPrint", valid_579842
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

proc call*(call_579866: Call_DataflowProjectsWorkerMessages_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send a worker_message to the service.
  ## 
  let valid = call_579866.validator(path, query, header, formData, body)
  let scheme = call_579866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579866.url(scheme.get, call_579866.host, call_579866.base,
                         call_579866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579866, url, valid)

proc call*(call_579937: Call_DataflowProjectsWorkerMessages_579690;
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
  var path_579938 = newJObject()
  var query_579940 = newJObject()
  var body_579941 = newJObject()
  add(query_579940, "upload_protocol", newJString(uploadProtocol))
  add(query_579940, "fields", newJString(fields))
  add(query_579940, "quotaUser", newJString(quotaUser))
  add(query_579940, "alt", newJString(alt))
  add(query_579940, "oauth_token", newJString(oauthToken))
  add(query_579940, "callback", newJString(callback))
  add(query_579940, "access_token", newJString(accessToken))
  add(query_579940, "uploadType", newJString(uploadType))
  add(query_579940, "key", newJString(key))
  add(path_579938, "projectId", newJString(projectId))
  add(query_579940, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579941 = body
  add(query_579940, "prettyPrint", newJBool(prettyPrint))
  result = call_579937.call(path_579938, query_579940, nil, nil, body_579941)

var dataflowProjectsWorkerMessages* = Call_DataflowProjectsWorkerMessages_579690(
    name: "dataflowProjectsWorkerMessages", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/WorkerMessages",
    validator: validate_DataflowProjectsWorkerMessages_579691, base: "/",
    url: url_DataflowProjectsWorkerMessages_579692, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsCreate_580004 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsJobsCreate_580006(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsCreate_580005(path: JsonNode; query: JsonNode;
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
  var valid_580007 = path.getOrDefault("projectId")
  valid_580007 = validateParameter(valid_580007, JString, required = true,
                                 default = nil)
  if valid_580007 != nil:
    section.add "projectId", valid_580007
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
  var valid_580008 = query.getOrDefault("upload_protocol")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "upload_protocol", valid_580008
  var valid_580009 = query.getOrDefault("fields")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "fields", valid_580009
  var valid_580010 = query.getOrDefault("view")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_580010 != nil:
    section.add "view", valid_580010
  var valid_580011 = query.getOrDefault("quotaUser")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "quotaUser", valid_580011
  var valid_580012 = query.getOrDefault("alt")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("json"))
  if valid_580012 != nil:
    section.add "alt", valid_580012
  var valid_580013 = query.getOrDefault("oauth_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "oauth_token", valid_580013
  var valid_580014 = query.getOrDefault("callback")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "callback", valid_580014
  var valid_580015 = query.getOrDefault("access_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "access_token", valid_580015
  var valid_580016 = query.getOrDefault("uploadType")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "uploadType", valid_580016
  var valid_580017 = query.getOrDefault("location")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "location", valid_580017
  var valid_580018 = query.getOrDefault("replaceJobId")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "replaceJobId", valid_580018
  var valid_580019 = query.getOrDefault("key")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "key", valid_580019
  var valid_580020 = query.getOrDefault("$.xgafv")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("1"))
  if valid_580020 != nil:
    section.add "$.xgafv", valid_580020
  var valid_580021 = query.getOrDefault("prettyPrint")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(true))
  if valid_580021 != nil:
    section.add "prettyPrint", valid_580021
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

proc call*(call_580023: Call_DataflowProjectsJobsCreate_580004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job.
  ## 
  ## To create a job, we recommend using `projects.locations.jobs.create` with a
  ## [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.create` is not recommended, as your job will always start
  ## in `us-central1`.
  ## 
  let valid = call_580023.validator(path, query, header, formData, body)
  let scheme = call_580023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580023.url(scheme.get, call_580023.host, call_580023.base,
                         call_580023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580023, url, valid)

proc call*(call_580024: Call_DataflowProjectsJobsCreate_580004; projectId: string;
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
  var path_580025 = newJObject()
  var query_580026 = newJObject()
  var body_580027 = newJObject()
  add(query_580026, "upload_protocol", newJString(uploadProtocol))
  add(query_580026, "fields", newJString(fields))
  add(query_580026, "view", newJString(view))
  add(query_580026, "quotaUser", newJString(quotaUser))
  add(query_580026, "alt", newJString(alt))
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "callback", newJString(callback))
  add(query_580026, "access_token", newJString(accessToken))
  add(query_580026, "uploadType", newJString(uploadType))
  add(query_580026, "location", newJString(location))
  add(query_580026, "replaceJobId", newJString(replaceJobId))
  add(query_580026, "key", newJString(key))
  add(path_580025, "projectId", newJString(projectId))
  add(query_580026, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580027 = body
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  result = call_580024.call(path_580025, query_580026, nil, nil, body_580027)

var dataflowProjectsJobsCreate* = Call_DataflowProjectsJobsCreate_580004(
    name: "dataflowProjectsJobsCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/jobs",
    validator: validate_DataflowProjectsJobsCreate_580005, base: "/",
    url: url_DataflowProjectsJobsCreate_580006, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsList_579980 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsJobsList_579982(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsList_579981(path: JsonNode; query: JsonNode;
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
  var valid_579983 = path.getOrDefault("projectId")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "projectId", valid_579983
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
  var valid_579984 = query.getOrDefault("upload_protocol")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "upload_protocol", valid_579984
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  var valid_579986 = query.getOrDefault("pageToken")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "pageToken", valid_579986
  var valid_579987 = query.getOrDefault("quotaUser")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "quotaUser", valid_579987
  var valid_579988 = query.getOrDefault("view")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_579988 != nil:
    section.add "view", valid_579988
  var valid_579989 = query.getOrDefault("alt")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = newJString("json"))
  if valid_579989 != nil:
    section.add "alt", valid_579989
  var valid_579990 = query.getOrDefault("oauth_token")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "oauth_token", valid_579990
  var valid_579991 = query.getOrDefault("callback")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "callback", valid_579991
  var valid_579992 = query.getOrDefault("access_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "access_token", valid_579992
  var valid_579993 = query.getOrDefault("uploadType")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "uploadType", valid_579993
  var valid_579994 = query.getOrDefault("location")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "location", valid_579994
  var valid_579995 = query.getOrDefault("key")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "key", valid_579995
  var valid_579996 = query.getOrDefault("$.xgafv")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("1"))
  if valid_579996 != nil:
    section.add "$.xgafv", valid_579996
  var valid_579997 = query.getOrDefault("pageSize")
  valid_579997 = validateParameter(valid_579997, JInt, required = false, default = nil)
  if valid_579997 != nil:
    section.add "pageSize", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
  var valid_579999 = query.getOrDefault("filter")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_579999 != nil:
    section.add "filter", valid_579999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580000: Call_DataflowProjectsJobsList_579980; path: JsonNode;
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
  let valid = call_580000.validator(path, query, header, formData, body)
  let scheme = call_580000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580000.url(scheme.get, call_580000.host, call_580000.base,
                         call_580000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580000, url, valid)

proc call*(call_580001: Call_DataflowProjectsJobsList_579980; projectId: string;
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
  var path_580002 = newJObject()
  var query_580003 = newJObject()
  add(query_580003, "upload_protocol", newJString(uploadProtocol))
  add(query_580003, "fields", newJString(fields))
  add(query_580003, "pageToken", newJString(pageToken))
  add(query_580003, "quotaUser", newJString(quotaUser))
  add(query_580003, "view", newJString(view))
  add(query_580003, "alt", newJString(alt))
  add(query_580003, "oauth_token", newJString(oauthToken))
  add(query_580003, "callback", newJString(callback))
  add(query_580003, "access_token", newJString(accessToken))
  add(query_580003, "uploadType", newJString(uploadType))
  add(query_580003, "location", newJString(location))
  add(query_580003, "key", newJString(key))
  add(path_580002, "projectId", newJString(projectId))
  add(query_580003, "$.xgafv", newJString(Xgafv))
  add(query_580003, "pageSize", newJInt(pageSize))
  add(query_580003, "prettyPrint", newJBool(prettyPrint))
  add(query_580003, "filter", newJString(filter))
  result = call_580001.call(path_580002, query_580003, nil, nil, nil)

var dataflowProjectsJobsList* = Call_DataflowProjectsJobsList_579980(
    name: "dataflowProjectsJobsList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/jobs",
    validator: validate_DataflowProjectsJobsList_579981, base: "/",
    url: url_DataflowProjectsJobsList_579982, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsUpdate_580050 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsJobsUpdate_580052(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsUpdate_580051(path: JsonNode; query: JsonNode;
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
  var valid_580053 = path.getOrDefault("jobId")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "jobId", valid_580053
  var valid_580054 = path.getOrDefault("projectId")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "projectId", valid_580054
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
  var valid_580055 = query.getOrDefault("upload_protocol")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "upload_protocol", valid_580055
  var valid_580056 = query.getOrDefault("fields")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "fields", valid_580056
  var valid_580057 = query.getOrDefault("quotaUser")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "quotaUser", valid_580057
  var valid_580058 = query.getOrDefault("alt")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("json"))
  if valid_580058 != nil:
    section.add "alt", valid_580058
  var valid_580059 = query.getOrDefault("oauth_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "oauth_token", valid_580059
  var valid_580060 = query.getOrDefault("callback")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "callback", valid_580060
  var valid_580061 = query.getOrDefault("access_token")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "access_token", valid_580061
  var valid_580062 = query.getOrDefault("uploadType")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "uploadType", valid_580062
  var valid_580063 = query.getOrDefault("location")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "location", valid_580063
  var valid_580064 = query.getOrDefault("key")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "key", valid_580064
  var valid_580065 = query.getOrDefault("$.xgafv")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = newJString("1"))
  if valid_580065 != nil:
    section.add "$.xgafv", valid_580065
  var valid_580066 = query.getOrDefault("prettyPrint")
  valid_580066 = validateParameter(valid_580066, JBool, required = false,
                                 default = newJBool(true))
  if valid_580066 != nil:
    section.add "prettyPrint", valid_580066
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

proc call*(call_580068: Call_DataflowProjectsJobsUpdate_580050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the state of an existing Cloud Dataflow job.
  ## 
  ## To update the state of an existing job, we recommend using
  ## `projects.locations.jobs.update` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.update` is not recommended, as you can only update the state
  ## of jobs that are running in `us-central1`.
  ## 
  let valid = call_580068.validator(path, query, header, formData, body)
  let scheme = call_580068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580068.url(scheme.get, call_580068.host, call_580068.base,
                         call_580068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580068, url, valid)

proc call*(call_580069: Call_DataflowProjectsJobsUpdate_580050; jobId: string;
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
  var path_580070 = newJObject()
  var query_580071 = newJObject()
  var body_580072 = newJObject()
  add(query_580071, "upload_protocol", newJString(uploadProtocol))
  add(query_580071, "fields", newJString(fields))
  add(query_580071, "quotaUser", newJString(quotaUser))
  add(query_580071, "alt", newJString(alt))
  add(path_580070, "jobId", newJString(jobId))
  add(query_580071, "oauth_token", newJString(oauthToken))
  add(query_580071, "callback", newJString(callback))
  add(query_580071, "access_token", newJString(accessToken))
  add(query_580071, "uploadType", newJString(uploadType))
  add(query_580071, "location", newJString(location))
  add(query_580071, "key", newJString(key))
  add(path_580070, "projectId", newJString(projectId))
  add(query_580071, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580072 = body
  add(query_580071, "prettyPrint", newJBool(prettyPrint))
  result = call_580069.call(path_580070, query_580071, nil, nil, body_580072)

var dataflowProjectsJobsUpdate* = Call_DataflowProjectsJobsUpdate_580050(
    name: "dataflowProjectsJobsUpdate", meth: HttpMethod.HttpPut,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataflowProjectsJobsUpdate_580051, base: "/",
    url: url_DataflowProjectsJobsUpdate_580052, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsGet_580028 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsJobsGet_580030(protocol: Scheme; host: string; base: string;
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

proc validate_DataflowProjectsJobsGet_580029(path: JsonNode; query: JsonNode;
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
  var valid_580031 = path.getOrDefault("jobId")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "jobId", valid_580031
  var valid_580032 = path.getOrDefault("projectId")
  valid_580032 = validateParameter(valid_580032, JString, required = true,
                                 default = nil)
  if valid_580032 != nil:
    section.add "projectId", valid_580032
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
  var valid_580035 = query.getOrDefault("view")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_580035 != nil:
    section.add "view", valid_580035
  var valid_580036 = query.getOrDefault("quotaUser")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "quotaUser", valid_580036
  var valid_580037 = query.getOrDefault("alt")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = newJString("json"))
  if valid_580037 != nil:
    section.add "alt", valid_580037
  var valid_580038 = query.getOrDefault("oauth_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "oauth_token", valid_580038
  var valid_580039 = query.getOrDefault("callback")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "callback", valid_580039
  var valid_580040 = query.getOrDefault("access_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "access_token", valid_580040
  var valid_580041 = query.getOrDefault("uploadType")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "uploadType", valid_580041
  var valid_580042 = query.getOrDefault("location")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "location", valid_580042
  var valid_580043 = query.getOrDefault("key")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "key", valid_580043
  var valid_580044 = query.getOrDefault("$.xgafv")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = newJString("1"))
  if valid_580044 != nil:
    section.add "$.xgafv", valid_580044
  var valid_580045 = query.getOrDefault("prettyPrint")
  valid_580045 = validateParameter(valid_580045, JBool, required = false,
                                 default = newJBool(true))
  if valid_580045 != nil:
    section.add "prettyPrint", valid_580045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580046: Call_DataflowProjectsJobsGet_580028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the state of the specified Cloud Dataflow job.
  ## 
  ## To get the state of a job, we recommend using `projects.locations.jobs.get`
  ## with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.get` is not recommended, as you can only get the state of
  ## jobs that are running in `us-central1`.
  ## 
  let valid = call_580046.validator(path, query, header, formData, body)
  let scheme = call_580046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580046.url(scheme.get, call_580046.host, call_580046.base,
                         call_580046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580046, url, valid)

proc call*(call_580047: Call_DataflowProjectsJobsGet_580028; jobId: string;
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
  var path_580048 = newJObject()
  var query_580049 = newJObject()
  add(query_580049, "upload_protocol", newJString(uploadProtocol))
  add(query_580049, "fields", newJString(fields))
  add(query_580049, "view", newJString(view))
  add(query_580049, "quotaUser", newJString(quotaUser))
  add(query_580049, "alt", newJString(alt))
  add(path_580048, "jobId", newJString(jobId))
  add(query_580049, "oauth_token", newJString(oauthToken))
  add(query_580049, "callback", newJString(callback))
  add(query_580049, "access_token", newJString(accessToken))
  add(query_580049, "uploadType", newJString(uploadType))
  add(query_580049, "location", newJString(location))
  add(query_580049, "key", newJString(key))
  add(path_580048, "projectId", newJString(projectId))
  add(query_580049, "$.xgafv", newJString(Xgafv))
  add(query_580049, "prettyPrint", newJBool(prettyPrint))
  result = call_580047.call(path_580048, query_580049, nil, nil, nil)

var dataflowProjectsJobsGet* = Call_DataflowProjectsJobsGet_580028(
    name: "dataflowProjectsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataflowProjectsJobsGet_580029, base: "/",
    url: url_DataflowProjectsJobsGet_580030, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsDebugGetConfig_580073 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsJobsDebugGetConfig_580075(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsDebugGetConfig_580074(path: JsonNode;
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
  var valid_580076 = path.getOrDefault("jobId")
  valid_580076 = validateParameter(valid_580076, JString, required = true,
                                 default = nil)
  if valid_580076 != nil:
    section.add "jobId", valid_580076
  var valid_580077 = path.getOrDefault("projectId")
  valid_580077 = validateParameter(valid_580077, JString, required = true,
                                 default = nil)
  if valid_580077 != nil:
    section.add "projectId", valid_580077
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
  var valid_580078 = query.getOrDefault("upload_protocol")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "upload_protocol", valid_580078
  var valid_580079 = query.getOrDefault("fields")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "fields", valid_580079
  var valid_580080 = query.getOrDefault("quotaUser")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "quotaUser", valid_580080
  var valid_580081 = query.getOrDefault("alt")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = newJString("json"))
  if valid_580081 != nil:
    section.add "alt", valid_580081
  var valid_580082 = query.getOrDefault("oauth_token")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "oauth_token", valid_580082
  var valid_580083 = query.getOrDefault("callback")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "callback", valid_580083
  var valid_580084 = query.getOrDefault("access_token")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "access_token", valid_580084
  var valid_580085 = query.getOrDefault("uploadType")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "uploadType", valid_580085
  var valid_580086 = query.getOrDefault("key")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "key", valid_580086
  var valid_580087 = query.getOrDefault("$.xgafv")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = newJString("1"))
  if valid_580087 != nil:
    section.add "$.xgafv", valid_580087
  var valid_580088 = query.getOrDefault("prettyPrint")
  valid_580088 = validateParameter(valid_580088, JBool, required = false,
                                 default = newJBool(true))
  if valid_580088 != nil:
    section.add "prettyPrint", valid_580088
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

proc call*(call_580090: Call_DataflowProjectsJobsDebugGetConfig_580073;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get encoded debug configuration for component. Not cacheable.
  ## 
  let valid = call_580090.validator(path, query, header, formData, body)
  let scheme = call_580090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580090.url(scheme.get, call_580090.host, call_580090.base,
                         call_580090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580090, url, valid)

proc call*(call_580091: Call_DataflowProjectsJobsDebugGetConfig_580073;
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
  var path_580092 = newJObject()
  var query_580093 = newJObject()
  var body_580094 = newJObject()
  add(query_580093, "upload_protocol", newJString(uploadProtocol))
  add(query_580093, "fields", newJString(fields))
  add(query_580093, "quotaUser", newJString(quotaUser))
  add(query_580093, "alt", newJString(alt))
  add(path_580092, "jobId", newJString(jobId))
  add(query_580093, "oauth_token", newJString(oauthToken))
  add(query_580093, "callback", newJString(callback))
  add(query_580093, "access_token", newJString(accessToken))
  add(query_580093, "uploadType", newJString(uploadType))
  add(query_580093, "key", newJString(key))
  add(path_580092, "projectId", newJString(projectId))
  add(query_580093, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580094 = body
  add(query_580093, "prettyPrint", newJBool(prettyPrint))
  result = call_580091.call(path_580092, query_580093, nil, nil, body_580094)

var dataflowProjectsJobsDebugGetConfig* = Call_DataflowProjectsJobsDebugGetConfig_580073(
    name: "dataflowProjectsJobsDebugGetConfig", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/debug/getConfig",
    validator: validate_DataflowProjectsJobsDebugGetConfig_580074, base: "/",
    url: url_DataflowProjectsJobsDebugGetConfig_580075, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsDebugSendCapture_580095 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsJobsDebugSendCapture_580097(protocol: Scheme;
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

proc validate_DataflowProjectsJobsDebugSendCapture_580096(path: JsonNode;
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
  var valid_580098 = path.getOrDefault("jobId")
  valid_580098 = validateParameter(valid_580098, JString, required = true,
                                 default = nil)
  if valid_580098 != nil:
    section.add "jobId", valid_580098
  var valid_580099 = path.getOrDefault("projectId")
  valid_580099 = validateParameter(valid_580099, JString, required = true,
                                 default = nil)
  if valid_580099 != nil:
    section.add "projectId", valid_580099
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
  var valid_580100 = query.getOrDefault("upload_protocol")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "upload_protocol", valid_580100
  var valid_580101 = query.getOrDefault("fields")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "fields", valid_580101
  var valid_580102 = query.getOrDefault("quotaUser")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "quotaUser", valid_580102
  var valid_580103 = query.getOrDefault("alt")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("json"))
  if valid_580103 != nil:
    section.add "alt", valid_580103
  var valid_580104 = query.getOrDefault("oauth_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "oauth_token", valid_580104
  var valid_580105 = query.getOrDefault("callback")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "callback", valid_580105
  var valid_580106 = query.getOrDefault("access_token")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "access_token", valid_580106
  var valid_580107 = query.getOrDefault("uploadType")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "uploadType", valid_580107
  var valid_580108 = query.getOrDefault("key")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "key", valid_580108
  var valid_580109 = query.getOrDefault("$.xgafv")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = newJString("1"))
  if valid_580109 != nil:
    section.add "$.xgafv", valid_580109
  var valid_580110 = query.getOrDefault("prettyPrint")
  valid_580110 = validateParameter(valid_580110, JBool, required = false,
                                 default = newJBool(true))
  if valid_580110 != nil:
    section.add "prettyPrint", valid_580110
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

proc call*(call_580112: Call_DataflowProjectsJobsDebugSendCapture_580095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send encoded debug capture data for component.
  ## 
  let valid = call_580112.validator(path, query, header, formData, body)
  let scheme = call_580112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580112.url(scheme.get, call_580112.host, call_580112.base,
                         call_580112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580112, url, valid)

proc call*(call_580113: Call_DataflowProjectsJobsDebugSendCapture_580095;
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
  var path_580114 = newJObject()
  var query_580115 = newJObject()
  var body_580116 = newJObject()
  add(query_580115, "upload_protocol", newJString(uploadProtocol))
  add(query_580115, "fields", newJString(fields))
  add(query_580115, "quotaUser", newJString(quotaUser))
  add(query_580115, "alt", newJString(alt))
  add(path_580114, "jobId", newJString(jobId))
  add(query_580115, "oauth_token", newJString(oauthToken))
  add(query_580115, "callback", newJString(callback))
  add(query_580115, "access_token", newJString(accessToken))
  add(query_580115, "uploadType", newJString(uploadType))
  add(query_580115, "key", newJString(key))
  add(path_580114, "projectId", newJString(projectId))
  add(query_580115, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580116 = body
  add(query_580115, "prettyPrint", newJBool(prettyPrint))
  result = call_580113.call(path_580114, query_580115, nil, nil, body_580116)

var dataflowProjectsJobsDebugSendCapture* = Call_DataflowProjectsJobsDebugSendCapture_580095(
    name: "dataflowProjectsJobsDebugSendCapture", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/debug/sendCapture",
    validator: validate_DataflowProjectsJobsDebugSendCapture_580096, base: "/",
    url: url_DataflowProjectsJobsDebugSendCapture_580097, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsMessagesList_580117 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsJobsMessagesList_580119(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsMessagesList_580118(path: JsonNode;
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
  var valid_580120 = path.getOrDefault("jobId")
  valid_580120 = validateParameter(valid_580120, JString, required = true,
                                 default = nil)
  if valid_580120 != nil:
    section.add "jobId", valid_580120
  var valid_580121 = path.getOrDefault("projectId")
  valid_580121 = validateParameter(valid_580121, JString, required = true,
                                 default = nil)
  if valid_580121 != nil:
    section.add "projectId", valid_580121
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
  var valid_580122 = query.getOrDefault("upload_protocol")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "upload_protocol", valid_580122
  var valid_580123 = query.getOrDefault("fields")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "fields", valid_580123
  var valid_580124 = query.getOrDefault("pageToken")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "pageToken", valid_580124
  var valid_580125 = query.getOrDefault("quotaUser")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "quotaUser", valid_580125
  var valid_580126 = query.getOrDefault("alt")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = newJString("json"))
  if valid_580126 != nil:
    section.add "alt", valid_580126
  var valid_580127 = query.getOrDefault("oauth_token")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "oauth_token", valid_580127
  var valid_580128 = query.getOrDefault("callback")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "callback", valid_580128
  var valid_580129 = query.getOrDefault("access_token")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "access_token", valid_580129
  var valid_580130 = query.getOrDefault("uploadType")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "uploadType", valid_580130
  var valid_580131 = query.getOrDefault("endTime")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "endTime", valid_580131
  var valid_580132 = query.getOrDefault("location")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "location", valid_580132
  var valid_580133 = query.getOrDefault("key")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "key", valid_580133
  var valid_580134 = query.getOrDefault("minimumImportance")
  valid_580134 = validateParameter(valid_580134, JString, required = false, default = newJString(
      "JOB_MESSAGE_IMPORTANCE_UNKNOWN"))
  if valid_580134 != nil:
    section.add "minimumImportance", valid_580134
  var valid_580135 = query.getOrDefault("$.xgafv")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = newJString("1"))
  if valid_580135 != nil:
    section.add "$.xgafv", valid_580135
  var valid_580136 = query.getOrDefault("pageSize")
  valid_580136 = validateParameter(valid_580136, JInt, required = false, default = nil)
  if valid_580136 != nil:
    section.add "pageSize", valid_580136
  var valid_580137 = query.getOrDefault("prettyPrint")
  valid_580137 = validateParameter(valid_580137, JBool, required = false,
                                 default = newJBool(true))
  if valid_580137 != nil:
    section.add "prettyPrint", valid_580137
  var valid_580138 = query.getOrDefault("startTime")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "startTime", valid_580138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580139: Call_DataflowProjectsJobsMessagesList_580117;
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
  let valid = call_580139.validator(path, query, header, formData, body)
  let scheme = call_580139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580139.url(scheme.get, call_580139.host, call_580139.base,
                         call_580139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580139, url, valid)

proc call*(call_580140: Call_DataflowProjectsJobsMessagesList_580117;
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
  var path_580141 = newJObject()
  var query_580142 = newJObject()
  add(query_580142, "upload_protocol", newJString(uploadProtocol))
  add(query_580142, "fields", newJString(fields))
  add(query_580142, "pageToken", newJString(pageToken))
  add(query_580142, "quotaUser", newJString(quotaUser))
  add(query_580142, "alt", newJString(alt))
  add(path_580141, "jobId", newJString(jobId))
  add(query_580142, "oauth_token", newJString(oauthToken))
  add(query_580142, "callback", newJString(callback))
  add(query_580142, "access_token", newJString(accessToken))
  add(query_580142, "uploadType", newJString(uploadType))
  add(query_580142, "endTime", newJString(endTime))
  add(query_580142, "location", newJString(location))
  add(query_580142, "key", newJString(key))
  add(query_580142, "minimumImportance", newJString(minimumImportance))
  add(path_580141, "projectId", newJString(projectId))
  add(query_580142, "$.xgafv", newJString(Xgafv))
  add(query_580142, "pageSize", newJInt(pageSize))
  add(query_580142, "prettyPrint", newJBool(prettyPrint))
  add(query_580142, "startTime", newJString(startTime))
  result = call_580140.call(path_580141, query_580142, nil, nil, nil)

var dataflowProjectsJobsMessagesList* = Call_DataflowProjectsJobsMessagesList_580117(
    name: "dataflowProjectsJobsMessagesList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/messages",
    validator: validate_DataflowProjectsJobsMessagesList_580118, base: "/",
    url: url_DataflowProjectsJobsMessagesList_580119, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsGetMetrics_580143 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsJobsGetMetrics_580145(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsGetMetrics_580144(path: JsonNode;
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
  var valid_580146 = path.getOrDefault("jobId")
  valid_580146 = validateParameter(valid_580146, JString, required = true,
                                 default = nil)
  if valid_580146 != nil:
    section.add "jobId", valid_580146
  var valid_580147 = path.getOrDefault("projectId")
  valid_580147 = validateParameter(valid_580147, JString, required = true,
                                 default = nil)
  if valid_580147 != nil:
    section.add "projectId", valid_580147
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
  var valid_580148 = query.getOrDefault("upload_protocol")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "upload_protocol", valid_580148
  var valid_580149 = query.getOrDefault("fields")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "fields", valid_580149
  var valid_580150 = query.getOrDefault("quotaUser")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "quotaUser", valid_580150
  var valid_580151 = query.getOrDefault("alt")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = newJString("json"))
  if valid_580151 != nil:
    section.add "alt", valid_580151
  var valid_580152 = query.getOrDefault("oauth_token")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "oauth_token", valid_580152
  var valid_580153 = query.getOrDefault("callback")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "callback", valid_580153
  var valid_580154 = query.getOrDefault("access_token")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "access_token", valid_580154
  var valid_580155 = query.getOrDefault("uploadType")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "uploadType", valid_580155
  var valid_580156 = query.getOrDefault("location")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "location", valid_580156
  var valid_580157 = query.getOrDefault("key")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "key", valid_580157
  var valid_580158 = query.getOrDefault("$.xgafv")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = newJString("1"))
  if valid_580158 != nil:
    section.add "$.xgafv", valid_580158
  var valid_580159 = query.getOrDefault("prettyPrint")
  valid_580159 = validateParameter(valid_580159, JBool, required = false,
                                 default = newJBool(true))
  if valid_580159 != nil:
    section.add "prettyPrint", valid_580159
  var valid_580160 = query.getOrDefault("startTime")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "startTime", valid_580160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580161: Call_DataflowProjectsJobsGetMetrics_580143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.getMetrics` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.getMetrics` is not recommended, as you can only request the
  ## status of jobs that are running in `us-central1`.
  ## 
  let valid = call_580161.validator(path, query, header, formData, body)
  let scheme = call_580161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580161.url(scheme.get, call_580161.host, call_580161.base,
                         call_580161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580161, url, valid)

proc call*(call_580162: Call_DataflowProjectsJobsGetMetrics_580143; jobId: string;
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
  var path_580163 = newJObject()
  var query_580164 = newJObject()
  add(query_580164, "upload_protocol", newJString(uploadProtocol))
  add(query_580164, "fields", newJString(fields))
  add(query_580164, "quotaUser", newJString(quotaUser))
  add(query_580164, "alt", newJString(alt))
  add(path_580163, "jobId", newJString(jobId))
  add(query_580164, "oauth_token", newJString(oauthToken))
  add(query_580164, "callback", newJString(callback))
  add(query_580164, "access_token", newJString(accessToken))
  add(query_580164, "uploadType", newJString(uploadType))
  add(query_580164, "location", newJString(location))
  add(query_580164, "key", newJString(key))
  add(path_580163, "projectId", newJString(projectId))
  add(query_580164, "$.xgafv", newJString(Xgafv))
  add(query_580164, "prettyPrint", newJBool(prettyPrint))
  add(query_580164, "startTime", newJString(startTime))
  result = call_580162.call(path_580163, query_580164, nil, nil, nil)

var dataflowProjectsJobsGetMetrics* = Call_DataflowProjectsJobsGetMetrics_580143(
    name: "dataflowProjectsJobsGetMetrics", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/metrics",
    validator: validate_DataflowProjectsJobsGetMetrics_580144, base: "/",
    url: url_DataflowProjectsJobsGetMetrics_580145, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsWorkItemsLease_580165 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsJobsWorkItemsLease_580167(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsWorkItemsLease_580166(path: JsonNode;
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
  var valid_580168 = path.getOrDefault("jobId")
  valid_580168 = validateParameter(valid_580168, JString, required = true,
                                 default = nil)
  if valid_580168 != nil:
    section.add "jobId", valid_580168
  var valid_580169 = path.getOrDefault("projectId")
  valid_580169 = validateParameter(valid_580169, JString, required = true,
                                 default = nil)
  if valid_580169 != nil:
    section.add "projectId", valid_580169
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
  var valid_580170 = query.getOrDefault("upload_protocol")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "upload_protocol", valid_580170
  var valid_580171 = query.getOrDefault("fields")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "fields", valid_580171
  var valid_580172 = query.getOrDefault("quotaUser")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "quotaUser", valid_580172
  var valid_580173 = query.getOrDefault("alt")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = newJString("json"))
  if valid_580173 != nil:
    section.add "alt", valid_580173
  var valid_580174 = query.getOrDefault("oauth_token")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "oauth_token", valid_580174
  var valid_580175 = query.getOrDefault("callback")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "callback", valid_580175
  var valid_580176 = query.getOrDefault("access_token")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "access_token", valid_580176
  var valid_580177 = query.getOrDefault("uploadType")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "uploadType", valid_580177
  var valid_580178 = query.getOrDefault("key")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "key", valid_580178
  var valid_580179 = query.getOrDefault("$.xgafv")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = newJString("1"))
  if valid_580179 != nil:
    section.add "$.xgafv", valid_580179
  var valid_580180 = query.getOrDefault("prettyPrint")
  valid_580180 = validateParameter(valid_580180, JBool, required = false,
                                 default = newJBool(true))
  if valid_580180 != nil:
    section.add "prettyPrint", valid_580180
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

proc call*(call_580182: Call_DataflowProjectsJobsWorkItemsLease_580165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Leases a dataflow WorkItem to run.
  ## 
  let valid = call_580182.validator(path, query, header, formData, body)
  let scheme = call_580182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580182.url(scheme.get, call_580182.host, call_580182.base,
                         call_580182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580182, url, valid)

proc call*(call_580183: Call_DataflowProjectsJobsWorkItemsLease_580165;
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
  var path_580184 = newJObject()
  var query_580185 = newJObject()
  var body_580186 = newJObject()
  add(query_580185, "upload_protocol", newJString(uploadProtocol))
  add(query_580185, "fields", newJString(fields))
  add(query_580185, "quotaUser", newJString(quotaUser))
  add(query_580185, "alt", newJString(alt))
  add(path_580184, "jobId", newJString(jobId))
  add(query_580185, "oauth_token", newJString(oauthToken))
  add(query_580185, "callback", newJString(callback))
  add(query_580185, "access_token", newJString(accessToken))
  add(query_580185, "uploadType", newJString(uploadType))
  add(query_580185, "key", newJString(key))
  add(path_580184, "projectId", newJString(projectId))
  add(query_580185, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580186 = body
  add(query_580185, "prettyPrint", newJBool(prettyPrint))
  result = call_580183.call(path_580184, query_580185, nil, nil, body_580186)

var dataflowProjectsJobsWorkItemsLease* = Call_DataflowProjectsJobsWorkItemsLease_580165(
    name: "dataflowProjectsJobsWorkItemsLease", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/workItems:lease",
    validator: validate_DataflowProjectsJobsWorkItemsLease_580166, base: "/",
    url: url_DataflowProjectsJobsWorkItemsLease_580167, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsWorkItemsReportStatus_580187 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsJobsWorkItemsReportStatus_580189(protocol: Scheme;
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

proc validate_DataflowProjectsJobsWorkItemsReportStatus_580188(path: JsonNode;
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
  var valid_580190 = path.getOrDefault("jobId")
  valid_580190 = validateParameter(valid_580190, JString, required = true,
                                 default = nil)
  if valid_580190 != nil:
    section.add "jobId", valid_580190
  var valid_580191 = path.getOrDefault("projectId")
  valid_580191 = validateParameter(valid_580191, JString, required = true,
                                 default = nil)
  if valid_580191 != nil:
    section.add "projectId", valid_580191
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
  var valid_580192 = query.getOrDefault("upload_protocol")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "upload_protocol", valid_580192
  var valid_580193 = query.getOrDefault("fields")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "fields", valid_580193
  var valid_580194 = query.getOrDefault("quotaUser")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "quotaUser", valid_580194
  var valid_580195 = query.getOrDefault("alt")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = newJString("json"))
  if valid_580195 != nil:
    section.add "alt", valid_580195
  var valid_580196 = query.getOrDefault("oauth_token")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "oauth_token", valid_580196
  var valid_580197 = query.getOrDefault("callback")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "callback", valid_580197
  var valid_580198 = query.getOrDefault("access_token")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "access_token", valid_580198
  var valid_580199 = query.getOrDefault("uploadType")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "uploadType", valid_580199
  var valid_580200 = query.getOrDefault("key")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "key", valid_580200
  var valid_580201 = query.getOrDefault("$.xgafv")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = newJString("1"))
  if valid_580201 != nil:
    section.add "$.xgafv", valid_580201
  var valid_580202 = query.getOrDefault("prettyPrint")
  valid_580202 = validateParameter(valid_580202, JBool, required = false,
                                 default = newJBool(true))
  if valid_580202 != nil:
    section.add "prettyPrint", valid_580202
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

proc call*(call_580204: Call_DataflowProjectsJobsWorkItemsReportStatus_580187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports the status of dataflow WorkItems leased by a worker.
  ## 
  let valid = call_580204.validator(path, query, header, formData, body)
  let scheme = call_580204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580204.url(scheme.get, call_580204.host, call_580204.base,
                         call_580204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580204, url, valid)

proc call*(call_580205: Call_DataflowProjectsJobsWorkItemsReportStatus_580187;
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
  var path_580206 = newJObject()
  var query_580207 = newJObject()
  var body_580208 = newJObject()
  add(query_580207, "upload_protocol", newJString(uploadProtocol))
  add(query_580207, "fields", newJString(fields))
  add(query_580207, "quotaUser", newJString(quotaUser))
  add(query_580207, "alt", newJString(alt))
  add(path_580206, "jobId", newJString(jobId))
  add(query_580207, "oauth_token", newJString(oauthToken))
  add(query_580207, "callback", newJString(callback))
  add(query_580207, "access_token", newJString(accessToken))
  add(query_580207, "uploadType", newJString(uploadType))
  add(query_580207, "key", newJString(key))
  add(path_580206, "projectId", newJString(projectId))
  add(query_580207, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580208 = body
  add(query_580207, "prettyPrint", newJBool(prettyPrint))
  result = call_580205.call(path_580206, query_580207, nil, nil, body_580208)

var dataflowProjectsJobsWorkItemsReportStatus* = Call_DataflowProjectsJobsWorkItemsReportStatus_580187(
    name: "dataflowProjectsJobsWorkItemsReportStatus", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/workItems:reportStatus",
    validator: validate_DataflowProjectsJobsWorkItemsReportStatus_580188,
    base: "/", url: url_DataflowProjectsJobsWorkItemsReportStatus_580189,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsAggregated_580209 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsJobsAggregated_580211(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsJobsAggregated_580210(path: JsonNode;
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
  var valid_580212 = path.getOrDefault("projectId")
  valid_580212 = validateParameter(valid_580212, JString, required = true,
                                 default = nil)
  if valid_580212 != nil:
    section.add "projectId", valid_580212
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
  var valid_580213 = query.getOrDefault("upload_protocol")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "upload_protocol", valid_580213
  var valid_580214 = query.getOrDefault("fields")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "fields", valid_580214
  var valid_580215 = query.getOrDefault("pageToken")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "pageToken", valid_580215
  var valid_580216 = query.getOrDefault("quotaUser")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "quotaUser", valid_580216
  var valid_580217 = query.getOrDefault("view")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_580217 != nil:
    section.add "view", valid_580217
  var valid_580218 = query.getOrDefault("alt")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = newJString("json"))
  if valid_580218 != nil:
    section.add "alt", valid_580218
  var valid_580219 = query.getOrDefault("oauth_token")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "oauth_token", valid_580219
  var valid_580220 = query.getOrDefault("callback")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "callback", valid_580220
  var valid_580221 = query.getOrDefault("access_token")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "access_token", valid_580221
  var valid_580222 = query.getOrDefault("uploadType")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "uploadType", valid_580222
  var valid_580223 = query.getOrDefault("location")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "location", valid_580223
  var valid_580224 = query.getOrDefault("key")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "key", valid_580224
  var valid_580225 = query.getOrDefault("$.xgafv")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = newJString("1"))
  if valid_580225 != nil:
    section.add "$.xgafv", valid_580225
  var valid_580226 = query.getOrDefault("pageSize")
  valid_580226 = validateParameter(valid_580226, JInt, required = false, default = nil)
  if valid_580226 != nil:
    section.add "pageSize", valid_580226
  var valid_580227 = query.getOrDefault("prettyPrint")
  valid_580227 = validateParameter(valid_580227, JBool, required = false,
                                 default = newJBool(true))
  if valid_580227 != nil:
    section.add "prettyPrint", valid_580227
  var valid_580228 = query.getOrDefault("filter")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_580228 != nil:
    section.add "filter", valid_580228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580229: Call_DataflowProjectsJobsAggregated_580209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the jobs of a project across all regions.
  ## 
  let valid = call_580229.validator(path, query, header, formData, body)
  let scheme = call_580229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580229.url(scheme.get, call_580229.host, call_580229.base,
                         call_580229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580229, url, valid)

proc call*(call_580230: Call_DataflowProjectsJobsAggregated_580209;
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
  var path_580231 = newJObject()
  var query_580232 = newJObject()
  add(query_580232, "upload_protocol", newJString(uploadProtocol))
  add(query_580232, "fields", newJString(fields))
  add(query_580232, "pageToken", newJString(pageToken))
  add(query_580232, "quotaUser", newJString(quotaUser))
  add(query_580232, "view", newJString(view))
  add(query_580232, "alt", newJString(alt))
  add(query_580232, "oauth_token", newJString(oauthToken))
  add(query_580232, "callback", newJString(callback))
  add(query_580232, "access_token", newJString(accessToken))
  add(query_580232, "uploadType", newJString(uploadType))
  add(query_580232, "location", newJString(location))
  add(query_580232, "key", newJString(key))
  add(path_580231, "projectId", newJString(projectId))
  add(query_580232, "$.xgafv", newJString(Xgafv))
  add(query_580232, "pageSize", newJInt(pageSize))
  add(query_580232, "prettyPrint", newJBool(prettyPrint))
  add(query_580232, "filter", newJString(filter))
  result = call_580230.call(path_580231, query_580232, nil, nil, nil)

var dataflowProjectsJobsAggregated* = Call_DataflowProjectsJobsAggregated_580209(
    name: "dataflowProjectsJobsAggregated", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs:aggregated",
    validator: validate_DataflowProjectsJobsAggregated_580210, base: "/",
    url: url_DataflowProjectsJobsAggregated_580211, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsWorkerMessages_580233 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsWorkerMessages_580235(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsWorkerMessages_580234(path: JsonNode;
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
  var valid_580236 = path.getOrDefault("projectId")
  valid_580236 = validateParameter(valid_580236, JString, required = true,
                                 default = nil)
  if valid_580236 != nil:
    section.add "projectId", valid_580236
  var valid_580237 = path.getOrDefault("location")
  valid_580237 = validateParameter(valid_580237, JString, required = true,
                                 default = nil)
  if valid_580237 != nil:
    section.add "location", valid_580237
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
  var valid_580238 = query.getOrDefault("upload_protocol")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "upload_protocol", valid_580238
  var valid_580239 = query.getOrDefault("fields")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "fields", valid_580239
  var valid_580240 = query.getOrDefault("quotaUser")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "quotaUser", valid_580240
  var valid_580241 = query.getOrDefault("alt")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = newJString("json"))
  if valid_580241 != nil:
    section.add "alt", valid_580241
  var valid_580242 = query.getOrDefault("oauth_token")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "oauth_token", valid_580242
  var valid_580243 = query.getOrDefault("callback")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "callback", valid_580243
  var valid_580244 = query.getOrDefault("access_token")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "access_token", valid_580244
  var valid_580245 = query.getOrDefault("uploadType")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "uploadType", valid_580245
  var valid_580246 = query.getOrDefault("key")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "key", valid_580246
  var valid_580247 = query.getOrDefault("$.xgafv")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = newJString("1"))
  if valid_580247 != nil:
    section.add "$.xgafv", valid_580247
  var valid_580248 = query.getOrDefault("prettyPrint")
  valid_580248 = validateParameter(valid_580248, JBool, required = false,
                                 default = newJBool(true))
  if valid_580248 != nil:
    section.add "prettyPrint", valid_580248
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

proc call*(call_580250: Call_DataflowProjectsLocationsWorkerMessages_580233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send a worker_message to the service.
  ## 
  let valid = call_580250.validator(path, query, header, formData, body)
  let scheme = call_580250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580250.url(scheme.get, call_580250.host, call_580250.base,
                         call_580250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580250, url, valid)

proc call*(call_580251: Call_DataflowProjectsLocationsWorkerMessages_580233;
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
  var path_580252 = newJObject()
  var query_580253 = newJObject()
  var body_580254 = newJObject()
  add(query_580253, "upload_protocol", newJString(uploadProtocol))
  add(query_580253, "fields", newJString(fields))
  add(query_580253, "quotaUser", newJString(quotaUser))
  add(query_580253, "alt", newJString(alt))
  add(query_580253, "oauth_token", newJString(oauthToken))
  add(query_580253, "callback", newJString(callback))
  add(query_580253, "access_token", newJString(accessToken))
  add(query_580253, "uploadType", newJString(uploadType))
  add(query_580253, "key", newJString(key))
  add(path_580252, "projectId", newJString(projectId))
  add(query_580253, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580254 = body
  add(query_580253, "prettyPrint", newJBool(prettyPrint))
  add(path_580252, "location", newJString(location))
  result = call_580251.call(path_580252, query_580253, nil, nil, body_580254)

var dataflowProjectsLocationsWorkerMessages* = Call_DataflowProjectsLocationsWorkerMessages_580233(
    name: "dataflowProjectsLocationsWorkerMessages", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/WorkerMessages",
    validator: validate_DataflowProjectsLocationsWorkerMessages_580234, base: "/",
    url: url_DataflowProjectsLocationsWorkerMessages_580235,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsCreate_580279 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsJobsCreate_580281(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsLocationsJobsCreate_580280(path: JsonNode;
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
  var valid_580282 = path.getOrDefault("projectId")
  valid_580282 = validateParameter(valid_580282, JString, required = true,
                                 default = nil)
  if valid_580282 != nil:
    section.add "projectId", valid_580282
  var valid_580283 = path.getOrDefault("location")
  valid_580283 = validateParameter(valid_580283, JString, required = true,
                                 default = nil)
  if valid_580283 != nil:
    section.add "location", valid_580283
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
  var valid_580284 = query.getOrDefault("upload_protocol")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "upload_protocol", valid_580284
  var valid_580285 = query.getOrDefault("fields")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "fields", valid_580285
  var valid_580286 = query.getOrDefault("view")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_580286 != nil:
    section.add "view", valid_580286
  var valid_580287 = query.getOrDefault("quotaUser")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "quotaUser", valid_580287
  var valid_580288 = query.getOrDefault("alt")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("json"))
  if valid_580288 != nil:
    section.add "alt", valid_580288
  var valid_580289 = query.getOrDefault("oauth_token")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "oauth_token", valid_580289
  var valid_580290 = query.getOrDefault("callback")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "callback", valid_580290
  var valid_580291 = query.getOrDefault("access_token")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "access_token", valid_580291
  var valid_580292 = query.getOrDefault("uploadType")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "uploadType", valid_580292
  var valid_580293 = query.getOrDefault("replaceJobId")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "replaceJobId", valid_580293
  var valid_580294 = query.getOrDefault("key")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "key", valid_580294
  var valid_580295 = query.getOrDefault("$.xgafv")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = newJString("1"))
  if valid_580295 != nil:
    section.add "$.xgafv", valid_580295
  var valid_580296 = query.getOrDefault("prettyPrint")
  valid_580296 = validateParameter(valid_580296, JBool, required = false,
                                 default = newJBool(true))
  if valid_580296 != nil:
    section.add "prettyPrint", valid_580296
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

proc call*(call_580298: Call_DataflowProjectsLocationsJobsCreate_580279;
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
  let valid = call_580298.validator(path, query, header, formData, body)
  let scheme = call_580298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580298.url(scheme.get, call_580298.host, call_580298.base,
                         call_580298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580298, url, valid)

proc call*(call_580299: Call_DataflowProjectsLocationsJobsCreate_580279;
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
  var path_580300 = newJObject()
  var query_580301 = newJObject()
  var body_580302 = newJObject()
  add(query_580301, "upload_protocol", newJString(uploadProtocol))
  add(query_580301, "fields", newJString(fields))
  add(query_580301, "view", newJString(view))
  add(query_580301, "quotaUser", newJString(quotaUser))
  add(query_580301, "alt", newJString(alt))
  add(query_580301, "oauth_token", newJString(oauthToken))
  add(query_580301, "callback", newJString(callback))
  add(query_580301, "access_token", newJString(accessToken))
  add(query_580301, "uploadType", newJString(uploadType))
  add(query_580301, "replaceJobId", newJString(replaceJobId))
  add(query_580301, "key", newJString(key))
  add(path_580300, "projectId", newJString(projectId))
  add(query_580301, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580302 = body
  add(query_580301, "prettyPrint", newJBool(prettyPrint))
  add(path_580300, "location", newJString(location))
  result = call_580299.call(path_580300, query_580301, nil, nil, body_580302)

var dataflowProjectsLocationsJobsCreate* = Call_DataflowProjectsLocationsJobsCreate_580279(
    name: "dataflowProjectsLocationsJobsCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs",
    validator: validate_DataflowProjectsLocationsJobsCreate_580280, base: "/",
    url: url_DataflowProjectsLocationsJobsCreate_580281, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsList_580255 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsJobsList_580257(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsLocationsJobsList_580256(path: JsonNode;
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
  var valid_580258 = path.getOrDefault("projectId")
  valid_580258 = validateParameter(valid_580258, JString, required = true,
                                 default = nil)
  if valid_580258 != nil:
    section.add "projectId", valid_580258
  var valid_580259 = path.getOrDefault("location")
  valid_580259 = validateParameter(valid_580259, JString, required = true,
                                 default = nil)
  if valid_580259 != nil:
    section.add "location", valid_580259
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
  var valid_580260 = query.getOrDefault("upload_protocol")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "upload_protocol", valid_580260
  var valid_580261 = query.getOrDefault("fields")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "fields", valid_580261
  var valid_580262 = query.getOrDefault("pageToken")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "pageToken", valid_580262
  var valid_580263 = query.getOrDefault("quotaUser")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "quotaUser", valid_580263
  var valid_580264 = query.getOrDefault("view")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_580264 != nil:
    section.add "view", valid_580264
  var valid_580265 = query.getOrDefault("alt")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = newJString("json"))
  if valid_580265 != nil:
    section.add "alt", valid_580265
  var valid_580266 = query.getOrDefault("oauth_token")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "oauth_token", valid_580266
  var valid_580267 = query.getOrDefault("callback")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "callback", valid_580267
  var valid_580268 = query.getOrDefault("access_token")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "access_token", valid_580268
  var valid_580269 = query.getOrDefault("uploadType")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "uploadType", valid_580269
  var valid_580270 = query.getOrDefault("key")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "key", valid_580270
  var valid_580271 = query.getOrDefault("$.xgafv")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = newJString("1"))
  if valid_580271 != nil:
    section.add "$.xgafv", valid_580271
  var valid_580272 = query.getOrDefault("pageSize")
  valid_580272 = validateParameter(valid_580272, JInt, required = false, default = nil)
  if valid_580272 != nil:
    section.add "pageSize", valid_580272
  var valid_580273 = query.getOrDefault("prettyPrint")
  valid_580273 = validateParameter(valid_580273, JBool, required = false,
                                 default = newJBool(true))
  if valid_580273 != nil:
    section.add "prettyPrint", valid_580273
  var valid_580274 = query.getOrDefault("filter")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_580274 != nil:
    section.add "filter", valid_580274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580275: Call_DataflowProjectsLocationsJobsList_580255;
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
  let valid = call_580275.validator(path, query, header, formData, body)
  let scheme = call_580275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580275.url(scheme.get, call_580275.host, call_580275.base,
                         call_580275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580275, url, valid)

proc call*(call_580276: Call_DataflowProjectsLocationsJobsList_580255;
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
  var path_580277 = newJObject()
  var query_580278 = newJObject()
  add(query_580278, "upload_protocol", newJString(uploadProtocol))
  add(query_580278, "fields", newJString(fields))
  add(query_580278, "pageToken", newJString(pageToken))
  add(query_580278, "quotaUser", newJString(quotaUser))
  add(query_580278, "view", newJString(view))
  add(query_580278, "alt", newJString(alt))
  add(query_580278, "oauth_token", newJString(oauthToken))
  add(query_580278, "callback", newJString(callback))
  add(query_580278, "access_token", newJString(accessToken))
  add(query_580278, "uploadType", newJString(uploadType))
  add(query_580278, "key", newJString(key))
  add(path_580277, "projectId", newJString(projectId))
  add(query_580278, "$.xgafv", newJString(Xgafv))
  add(query_580278, "pageSize", newJInt(pageSize))
  add(query_580278, "prettyPrint", newJBool(prettyPrint))
  add(path_580277, "location", newJString(location))
  add(query_580278, "filter", newJString(filter))
  result = call_580276.call(path_580277, query_580278, nil, nil, nil)

var dataflowProjectsLocationsJobsList* = Call_DataflowProjectsLocationsJobsList_580255(
    name: "dataflowProjectsLocationsJobsList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs",
    validator: validate_DataflowProjectsLocationsJobsList_580256, base: "/",
    url: url_DataflowProjectsLocationsJobsList_580257, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsUpdate_580325 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsJobsUpdate_580327(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsLocationsJobsUpdate_580326(path: JsonNode;
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
  var valid_580328 = path.getOrDefault("jobId")
  valid_580328 = validateParameter(valid_580328, JString, required = true,
                                 default = nil)
  if valid_580328 != nil:
    section.add "jobId", valid_580328
  var valid_580329 = path.getOrDefault("projectId")
  valid_580329 = validateParameter(valid_580329, JString, required = true,
                                 default = nil)
  if valid_580329 != nil:
    section.add "projectId", valid_580329
  var valid_580330 = path.getOrDefault("location")
  valid_580330 = validateParameter(valid_580330, JString, required = true,
                                 default = nil)
  if valid_580330 != nil:
    section.add "location", valid_580330
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
  var valid_580331 = query.getOrDefault("upload_protocol")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "upload_protocol", valid_580331
  var valid_580332 = query.getOrDefault("fields")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "fields", valid_580332
  var valid_580333 = query.getOrDefault("quotaUser")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "quotaUser", valid_580333
  var valid_580334 = query.getOrDefault("alt")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = newJString("json"))
  if valid_580334 != nil:
    section.add "alt", valid_580334
  var valid_580335 = query.getOrDefault("oauth_token")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "oauth_token", valid_580335
  var valid_580336 = query.getOrDefault("callback")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "callback", valid_580336
  var valid_580337 = query.getOrDefault("access_token")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "access_token", valid_580337
  var valid_580338 = query.getOrDefault("uploadType")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "uploadType", valid_580338
  var valid_580339 = query.getOrDefault("key")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "key", valid_580339
  var valid_580340 = query.getOrDefault("$.xgafv")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = newJString("1"))
  if valid_580340 != nil:
    section.add "$.xgafv", valid_580340
  var valid_580341 = query.getOrDefault("prettyPrint")
  valid_580341 = validateParameter(valid_580341, JBool, required = false,
                                 default = newJBool(true))
  if valid_580341 != nil:
    section.add "prettyPrint", valid_580341
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

proc call*(call_580343: Call_DataflowProjectsLocationsJobsUpdate_580325;
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
  let valid = call_580343.validator(path, query, header, formData, body)
  let scheme = call_580343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580343.url(scheme.get, call_580343.host, call_580343.base,
                         call_580343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580343, url, valid)

proc call*(call_580344: Call_DataflowProjectsLocationsJobsUpdate_580325;
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
  var path_580345 = newJObject()
  var query_580346 = newJObject()
  var body_580347 = newJObject()
  add(query_580346, "upload_protocol", newJString(uploadProtocol))
  add(query_580346, "fields", newJString(fields))
  add(query_580346, "quotaUser", newJString(quotaUser))
  add(query_580346, "alt", newJString(alt))
  add(path_580345, "jobId", newJString(jobId))
  add(query_580346, "oauth_token", newJString(oauthToken))
  add(query_580346, "callback", newJString(callback))
  add(query_580346, "access_token", newJString(accessToken))
  add(query_580346, "uploadType", newJString(uploadType))
  add(query_580346, "key", newJString(key))
  add(path_580345, "projectId", newJString(projectId))
  add(query_580346, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580347 = body
  add(query_580346, "prettyPrint", newJBool(prettyPrint))
  add(path_580345, "location", newJString(location))
  result = call_580344.call(path_580345, query_580346, nil, nil, body_580347)

var dataflowProjectsLocationsJobsUpdate* = Call_DataflowProjectsLocationsJobsUpdate_580325(
    name: "dataflowProjectsLocationsJobsUpdate", meth: HttpMethod.HttpPut,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}",
    validator: validate_DataflowProjectsLocationsJobsUpdate_580326, base: "/",
    url: url_DataflowProjectsLocationsJobsUpdate_580327, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsGet_580303 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsJobsGet_580305(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsLocationsJobsGet_580304(path: JsonNode;
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
  var valid_580306 = path.getOrDefault("jobId")
  valid_580306 = validateParameter(valid_580306, JString, required = true,
                                 default = nil)
  if valid_580306 != nil:
    section.add "jobId", valid_580306
  var valid_580307 = path.getOrDefault("projectId")
  valid_580307 = validateParameter(valid_580307, JString, required = true,
                                 default = nil)
  if valid_580307 != nil:
    section.add "projectId", valid_580307
  var valid_580308 = path.getOrDefault("location")
  valid_580308 = validateParameter(valid_580308, JString, required = true,
                                 default = nil)
  if valid_580308 != nil:
    section.add "location", valid_580308
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
  var valid_580309 = query.getOrDefault("upload_protocol")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "upload_protocol", valid_580309
  var valid_580310 = query.getOrDefault("fields")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "fields", valid_580310
  var valid_580311 = query.getOrDefault("view")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_580311 != nil:
    section.add "view", valid_580311
  var valid_580312 = query.getOrDefault("quotaUser")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "quotaUser", valid_580312
  var valid_580313 = query.getOrDefault("alt")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = newJString("json"))
  if valid_580313 != nil:
    section.add "alt", valid_580313
  var valid_580314 = query.getOrDefault("oauth_token")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "oauth_token", valid_580314
  var valid_580315 = query.getOrDefault("callback")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "callback", valid_580315
  var valid_580316 = query.getOrDefault("access_token")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "access_token", valid_580316
  var valid_580317 = query.getOrDefault("uploadType")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "uploadType", valid_580317
  var valid_580318 = query.getOrDefault("key")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "key", valid_580318
  var valid_580319 = query.getOrDefault("$.xgafv")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = newJString("1"))
  if valid_580319 != nil:
    section.add "$.xgafv", valid_580319
  var valid_580320 = query.getOrDefault("prettyPrint")
  valid_580320 = validateParameter(valid_580320, JBool, required = false,
                                 default = newJBool(true))
  if valid_580320 != nil:
    section.add "prettyPrint", valid_580320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580321: Call_DataflowProjectsLocationsJobsGet_580303;
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
  let valid = call_580321.validator(path, query, header, formData, body)
  let scheme = call_580321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580321.url(scheme.get, call_580321.host, call_580321.base,
                         call_580321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580321, url, valid)

proc call*(call_580322: Call_DataflowProjectsLocationsJobsGet_580303;
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
  var path_580323 = newJObject()
  var query_580324 = newJObject()
  add(query_580324, "upload_protocol", newJString(uploadProtocol))
  add(query_580324, "fields", newJString(fields))
  add(query_580324, "view", newJString(view))
  add(query_580324, "quotaUser", newJString(quotaUser))
  add(query_580324, "alt", newJString(alt))
  add(path_580323, "jobId", newJString(jobId))
  add(query_580324, "oauth_token", newJString(oauthToken))
  add(query_580324, "callback", newJString(callback))
  add(query_580324, "access_token", newJString(accessToken))
  add(query_580324, "uploadType", newJString(uploadType))
  add(query_580324, "key", newJString(key))
  add(path_580323, "projectId", newJString(projectId))
  add(query_580324, "$.xgafv", newJString(Xgafv))
  add(query_580324, "prettyPrint", newJBool(prettyPrint))
  add(path_580323, "location", newJString(location))
  result = call_580322.call(path_580323, query_580324, nil, nil, nil)

var dataflowProjectsLocationsJobsGet* = Call_DataflowProjectsLocationsJobsGet_580303(
    name: "dataflowProjectsLocationsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}",
    validator: validate_DataflowProjectsLocationsJobsGet_580304, base: "/",
    url: url_DataflowProjectsLocationsJobsGet_580305, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsDebugGetConfig_580348 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsJobsDebugGetConfig_580350(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsJobsDebugGetConfig_580349(path: JsonNode;
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
  var valid_580351 = path.getOrDefault("jobId")
  valid_580351 = validateParameter(valid_580351, JString, required = true,
                                 default = nil)
  if valid_580351 != nil:
    section.add "jobId", valid_580351
  var valid_580352 = path.getOrDefault("projectId")
  valid_580352 = validateParameter(valid_580352, JString, required = true,
                                 default = nil)
  if valid_580352 != nil:
    section.add "projectId", valid_580352
  var valid_580353 = path.getOrDefault("location")
  valid_580353 = validateParameter(valid_580353, JString, required = true,
                                 default = nil)
  if valid_580353 != nil:
    section.add "location", valid_580353
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
  var valid_580354 = query.getOrDefault("upload_protocol")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "upload_protocol", valid_580354
  var valid_580355 = query.getOrDefault("fields")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "fields", valid_580355
  var valid_580356 = query.getOrDefault("quotaUser")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "quotaUser", valid_580356
  var valid_580357 = query.getOrDefault("alt")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = newJString("json"))
  if valid_580357 != nil:
    section.add "alt", valid_580357
  var valid_580358 = query.getOrDefault("oauth_token")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "oauth_token", valid_580358
  var valid_580359 = query.getOrDefault("callback")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "callback", valid_580359
  var valid_580360 = query.getOrDefault("access_token")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "access_token", valid_580360
  var valid_580361 = query.getOrDefault("uploadType")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "uploadType", valid_580361
  var valid_580362 = query.getOrDefault("key")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "key", valid_580362
  var valid_580363 = query.getOrDefault("$.xgafv")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = newJString("1"))
  if valid_580363 != nil:
    section.add "$.xgafv", valid_580363
  var valid_580364 = query.getOrDefault("prettyPrint")
  valid_580364 = validateParameter(valid_580364, JBool, required = false,
                                 default = newJBool(true))
  if valid_580364 != nil:
    section.add "prettyPrint", valid_580364
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

proc call*(call_580366: Call_DataflowProjectsLocationsJobsDebugGetConfig_580348;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get encoded debug configuration for component. Not cacheable.
  ## 
  let valid = call_580366.validator(path, query, header, formData, body)
  let scheme = call_580366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580366.url(scheme.get, call_580366.host, call_580366.base,
                         call_580366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580366, url, valid)

proc call*(call_580367: Call_DataflowProjectsLocationsJobsDebugGetConfig_580348;
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
  var path_580368 = newJObject()
  var query_580369 = newJObject()
  var body_580370 = newJObject()
  add(query_580369, "upload_protocol", newJString(uploadProtocol))
  add(query_580369, "fields", newJString(fields))
  add(query_580369, "quotaUser", newJString(quotaUser))
  add(query_580369, "alt", newJString(alt))
  add(path_580368, "jobId", newJString(jobId))
  add(query_580369, "oauth_token", newJString(oauthToken))
  add(query_580369, "callback", newJString(callback))
  add(query_580369, "access_token", newJString(accessToken))
  add(query_580369, "uploadType", newJString(uploadType))
  add(query_580369, "key", newJString(key))
  add(path_580368, "projectId", newJString(projectId))
  add(query_580369, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580370 = body
  add(query_580369, "prettyPrint", newJBool(prettyPrint))
  add(path_580368, "location", newJString(location))
  result = call_580367.call(path_580368, query_580369, nil, nil, body_580370)

var dataflowProjectsLocationsJobsDebugGetConfig* = Call_DataflowProjectsLocationsJobsDebugGetConfig_580348(
    name: "dataflowProjectsLocationsJobsDebugGetConfig",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/debug/getConfig",
    validator: validate_DataflowProjectsLocationsJobsDebugGetConfig_580349,
    base: "/", url: url_DataflowProjectsLocationsJobsDebugGetConfig_580350,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsDebugSendCapture_580371 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsJobsDebugSendCapture_580373(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsJobsDebugSendCapture_580372(
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
  var valid_580374 = path.getOrDefault("jobId")
  valid_580374 = validateParameter(valid_580374, JString, required = true,
                                 default = nil)
  if valid_580374 != nil:
    section.add "jobId", valid_580374
  var valid_580375 = path.getOrDefault("projectId")
  valid_580375 = validateParameter(valid_580375, JString, required = true,
                                 default = nil)
  if valid_580375 != nil:
    section.add "projectId", valid_580375
  var valid_580376 = path.getOrDefault("location")
  valid_580376 = validateParameter(valid_580376, JString, required = true,
                                 default = nil)
  if valid_580376 != nil:
    section.add "location", valid_580376
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
  var valid_580377 = query.getOrDefault("upload_protocol")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "upload_protocol", valid_580377
  var valid_580378 = query.getOrDefault("fields")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "fields", valid_580378
  var valid_580379 = query.getOrDefault("quotaUser")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "quotaUser", valid_580379
  var valid_580380 = query.getOrDefault("alt")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = newJString("json"))
  if valid_580380 != nil:
    section.add "alt", valid_580380
  var valid_580381 = query.getOrDefault("oauth_token")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "oauth_token", valid_580381
  var valid_580382 = query.getOrDefault("callback")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "callback", valid_580382
  var valid_580383 = query.getOrDefault("access_token")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "access_token", valid_580383
  var valid_580384 = query.getOrDefault("uploadType")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "uploadType", valid_580384
  var valid_580385 = query.getOrDefault("key")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "key", valid_580385
  var valid_580386 = query.getOrDefault("$.xgafv")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = newJString("1"))
  if valid_580386 != nil:
    section.add "$.xgafv", valid_580386
  var valid_580387 = query.getOrDefault("prettyPrint")
  valid_580387 = validateParameter(valid_580387, JBool, required = false,
                                 default = newJBool(true))
  if valid_580387 != nil:
    section.add "prettyPrint", valid_580387
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

proc call*(call_580389: Call_DataflowProjectsLocationsJobsDebugSendCapture_580371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send encoded debug capture data for component.
  ## 
  let valid = call_580389.validator(path, query, header, formData, body)
  let scheme = call_580389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580389.url(scheme.get, call_580389.host, call_580389.base,
                         call_580389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580389, url, valid)

proc call*(call_580390: Call_DataflowProjectsLocationsJobsDebugSendCapture_580371;
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
  var path_580391 = newJObject()
  var query_580392 = newJObject()
  var body_580393 = newJObject()
  add(query_580392, "upload_protocol", newJString(uploadProtocol))
  add(query_580392, "fields", newJString(fields))
  add(query_580392, "quotaUser", newJString(quotaUser))
  add(query_580392, "alt", newJString(alt))
  add(path_580391, "jobId", newJString(jobId))
  add(query_580392, "oauth_token", newJString(oauthToken))
  add(query_580392, "callback", newJString(callback))
  add(query_580392, "access_token", newJString(accessToken))
  add(query_580392, "uploadType", newJString(uploadType))
  add(query_580392, "key", newJString(key))
  add(path_580391, "projectId", newJString(projectId))
  add(query_580392, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580393 = body
  add(query_580392, "prettyPrint", newJBool(prettyPrint))
  add(path_580391, "location", newJString(location))
  result = call_580390.call(path_580391, query_580392, nil, nil, body_580393)

var dataflowProjectsLocationsJobsDebugSendCapture* = Call_DataflowProjectsLocationsJobsDebugSendCapture_580371(
    name: "dataflowProjectsLocationsJobsDebugSendCapture",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/debug/sendCapture",
    validator: validate_DataflowProjectsLocationsJobsDebugSendCapture_580372,
    base: "/", url: url_DataflowProjectsLocationsJobsDebugSendCapture_580373,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsMessagesList_580394 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsJobsMessagesList_580396(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsJobsMessagesList_580395(path: JsonNode;
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
  var valid_580397 = path.getOrDefault("jobId")
  valid_580397 = validateParameter(valid_580397, JString, required = true,
                                 default = nil)
  if valid_580397 != nil:
    section.add "jobId", valid_580397
  var valid_580398 = path.getOrDefault("projectId")
  valid_580398 = validateParameter(valid_580398, JString, required = true,
                                 default = nil)
  if valid_580398 != nil:
    section.add "projectId", valid_580398
  var valid_580399 = path.getOrDefault("location")
  valid_580399 = validateParameter(valid_580399, JString, required = true,
                                 default = nil)
  if valid_580399 != nil:
    section.add "location", valid_580399
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
  var valid_580400 = query.getOrDefault("upload_protocol")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "upload_protocol", valid_580400
  var valid_580401 = query.getOrDefault("fields")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "fields", valid_580401
  var valid_580402 = query.getOrDefault("pageToken")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "pageToken", valid_580402
  var valid_580403 = query.getOrDefault("quotaUser")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "quotaUser", valid_580403
  var valid_580404 = query.getOrDefault("alt")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = newJString("json"))
  if valid_580404 != nil:
    section.add "alt", valid_580404
  var valid_580405 = query.getOrDefault("oauth_token")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "oauth_token", valid_580405
  var valid_580406 = query.getOrDefault("callback")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "callback", valid_580406
  var valid_580407 = query.getOrDefault("access_token")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "access_token", valid_580407
  var valid_580408 = query.getOrDefault("uploadType")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "uploadType", valid_580408
  var valid_580409 = query.getOrDefault("endTime")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "endTime", valid_580409
  var valid_580410 = query.getOrDefault("key")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "key", valid_580410
  var valid_580411 = query.getOrDefault("minimumImportance")
  valid_580411 = validateParameter(valid_580411, JString, required = false, default = newJString(
      "JOB_MESSAGE_IMPORTANCE_UNKNOWN"))
  if valid_580411 != nil:
    section.add "minimumImportance", valid_580411
  var valid_580412 = query.getOrDefault("$.xgafv")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = newJString("1"))
  if valid_580412 != nil:
    section.add "$.xgafv", valid_580412
  var valid_580413 = query.getOrDefault("pageSize")
  valid_580413 = validateParameter(valid_580413, JInt, required = false, default = nil)
  if valid_580413 != nil:
    section.add "pageSize", valid_580413
  var valid_580414 = query.getOrDefault("prettyPrint")
  valid_580414 = validateParameter(valid_580414, JBool, required = false,
                                 default = newJBool(true))
  if valid_580414 != nil:
    section.add "prettyPrint", valid_580414
  var valid_580415 = query.getOrDefault("startTime")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "startTime", valid_580415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580416: Call_DataflowProjectsLocationsJobsMessagesList_580394;
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
  let valid = call_580416.validator(path, query, header, formData, body)
  let scheme = call_580416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580416.url(scheme.get, call_580416.host, call_580416.base,
                         call_580416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580416, url, valid)

proc call*(call_580417: Call_DataflowProjectsLocationsJobsMessagesList_580394;
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
  var path_580418 = newJObject()
  var query_580419 = newJObject()
  add(query_580419, "upload_protocol", newJString(uploadProtocol))
  add(query_580419, "fields", newJString(fields))
  add(query_580419, "pageToken", newJString(pageToken))
  add(query_580419, "quotaUser", newJString(quotaUser))
  add(query_580419, "alt", newJString(alt))
  add(path_580418, "jobId", newJString(jobId))
  add(query_580419, "oauth_token", newJString(oauthToken))
  add(query_580419, "callback", newJString(callback))
  add(query_580419, "access_token", newJString(accessToken))
  add(query_580419, "uploadType", newJString(uploadType))
  add(query_580419, "endTime", newJString(endTime))
  add(query_580419, "key", newJString(key))
  add(query_580419, "minimumImportance", newJString(minimumImportance))
  add(path_580418, "projectId", newJString(projectId))
  add(query_580419, "$.xgafv", newJString(Xgafv))
  add(query_580419, "pageSize", newJInt(pageSize))
  add(query_580419, "prettyPrint", newJBool(prettyPrint))
  add(query_580419, "startTime", newJString(startTime))
  add(path_580418, "location", newJString(location))
  result = call_580417.call(path_580418, query_580419, nil, nil, nil)

var dataflowProjectsLocationsJobsMessagesList* = Call_DataflowProjectsLocationsJobsMessagesList_580394(
    name: "dataflowProjectsLocationsJobsMessagesList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/messages",
    validator: validate_DataflowProjectsLocationsJobsMessagesList_580395,
    base: "/", url: url_DataflowProjectsLocationsJobsMessagesList_580396,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsGetMetrics_580420 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsJobsGetMetrics_580422(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsJobsGetMetrics_580421(path: JsonNode;
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
  var valid_580423 = path.getOrDefault("jobId")
  valid_580423 = validateParameter(valid_580423, JString, required = true,
                                 default = nil)
  if valid_580423 != nil:
    section.add "jobId", valid_580423
  var valid_580424 = path.getOrDefault("projectId")
  valid_580424 = validateParameter(valid_580424, JString, required = true,
                                 default = nil)
  if valid_580424 != nil:
    section.add "projectId", valid_580424
  var valid_580425 = path.getOrDefault("location")
  valid_580425 = validateParameter(valid_580425, JString, required = true,
                                 default = nil)
  if valid_580425 != nil:
    section.add "location", valid_580425
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
  var valid_580426 = query.getOrDefault("upload_protocol")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "upload_protocol", valid_580426
  var valid_580427 = query.getOrDefault("fields")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "fields", valid_580427
  var valid_580428 = query.getOrDefault("quotaUser")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "quotaUser", valid_580428
  var valid_580429 = query.getOrDefault("alt")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = newJString("json"))
  if valid_580429 != nil:
    section.add "alt", valid_580429
  var valid_580430 = query.getOrDefault("oauth_token")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "oauth_token", valid_580430
  var valid_580431 = query.getOrDefault("callback")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "callback", valid_580431
  var valid_580432 = query.getOrDefault("access_token")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "access_token", valid_580432
  var valid_580433 = query.getOrDefault("uploadType")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "uploadType", valid_580433
  var valid_580434 = query.getOrDefault("key")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "key", valid_580434
  var valid_580435 = query.getOrDefault("$.xgafv")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = newJString("1"))
  if valid_580435 != nil:
    section.add "$.xgafv", valid_580435
  var valid_580436 = query.getOrDefault("prettyPrint")
  valid_580436 = validateParameter(valid_580436, JBool, required = false,
                                 default = newJBool(true))
  if valid_580436 != nil:
    section.add "prettyPrint", valid_580436
  var valid_580437 = query.getOrDefault("startTime")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "startTime", valid_580437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580438: Call_DataflowProjectsLocationsJobsGetMetrics_580420;
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
  let valid = call_580438.validator(path, query, header, formData, body)
  let scheme = call_580438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580438.url(scheme.get, call_580438.host, call_580438.base,
                         call_580438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580438, url, valid)

proc call*(call_580439: Call_DataflowProjectsLocationsJobsGetMetrics_580420;
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
  var path_580440 = newJObject()
  var query_580441 = newJObject()
  add(query_580441, "upload_protocol", newJString(uploadProtocol))
  add(query_580441, "fields", newJString(fields))
  add(query_580441, "quotaUser", newJString(quotaUser))
  add(query_580441, "alt", newJString(alt))
  add(path_580440, "jobId", newJString(jobId))
  add(query_580441, "oauth_token", newJString(oauthToken))
  add(query_580441, "callback", newJString(callback))
  add(query_580441, "access_token", newJString(accessToken))
  add(query_580441, "uploadType", newJString(uploadType))
  add(query_580441, "key", newJString(key))
  add(path_580440, "projectId", newJString(projectId))
  add(query_580441, "$.xgafv", newJString(Xgafv))
  add(query_580441, "prettyPrint", newJBool(prettyPrint))
  add(query_580441, "startTime", newJString(startTime))
  add(path_580440, "location", newJString(location))
  result = call_580439.call(path_580440, query_580441, nil, nil, nil)

var dataflowProjectsLocationsJobsGetMetrics* = Call_DataflowProjectsLocationsJobsGetMetrics_580420(
    name: "dataflowProjectsLocationsJobsGetMetrics", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/metrics",
    validator: validate_DataflowProjectsLocationsJobsGetMetrics_580421, base: "/",
    url: url_DataflowProjectsLocationsJobsGetMetrics_580422,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsWorkItemsLease_580442 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsJobsWorkItemsLease_580444(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsJobsWorkItemsLease_580443(path: JsonNode;
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
  var valid_580445 = path.getOrDefault("jobId")
  valid_580445 = validateParameter(valid_580445, JString, required = true,
                                 default = nil)
  if valid_580445 != nil:
    section.add "jobId", valid_580445
  var valid_580446 = path.getOrDefault("projectId")
  valid_580446 = validateParameter(valid_580446, JString, required = true,
                                 default = nil)
  if valid_580446 != nil:
    section.add "projectId", valid_580446
  var valid_580447 = path.getOrDefault("location")
  valid_580447 = validateParameter(valid_580447, JString, required = true,
                                 default = nil)
  if valid_580447 != nil:
    section.add "location", valid_580447
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
  var valid_580448 = query.getOrDefault("upload_protocol")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "upload_protocol", valid_580448
  var valid_580449 = query.getOrDefault("fields")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "fields", valid_580449
  var valid_580450 = query.getOrDefault("quotaUser")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "quotaUser", valid_580450
  var valid_580451 = query.getOrDefault("alt")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = newJString("json"))
  if valid_580451 != nil:
    section.add "alt", valid_580451
  var valid_580452 = query.getOrDefault("oauth_token")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "oauth_token", valid_580452
  var valid_580453 = query.getOrDefault("callback")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "callback", valid_580453
  var valid_580454 = query.getOrDefault("access_token")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "access_token", valid_580454
  var valid_580455 = query.getOrDefault("uploadType")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "uploadType", valid_580455
  var valid_580456 = query.getOrDefault("key")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "key", valid_580456
  var valid_580457 = query.getOrDefault("$.xgafv")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = newJString("1"))
  if valid_580457 != nil:
    section.add "$.xgafv", valid_580457
  var valid_580458 = query.getOrDefault("prettyPrint")
  valid_580458 = validateParameter(valid_580458, JBool, required = false,
                                 default = newJBool(true))
  if valid_580458 != nil:
    section.add "prettyPrint", valid_580458
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

proc call*(call_580460: Call_DataflowProjectsLocationsJobsWorkItemsLease_580442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Leases a dataflow WorkItem to run.
  ## 
  let valid = call_580460.validator(path, query, header, formData, body)
  let scheme = call_580460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580460.url(scheme.get, call_580460.host, call_580460.base,
                         call_580460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580460, url, valid)

proc call*(call_580461: Call_DataflowProjectsLocationsJobsWorkItemsLease_580442;
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
  var path_580462 = newJObject()
  var query_580463 = newJObject()
  var body_580464 = newJObject()
  add(query_580463, "upload_protocol", newJString(uploadProtocol))
  add(query_580463, "fields", newJString(fields))
  add(query_580463, "quotaUser", newJString(quotaUser))
  add(query_580463, "alt", newJString(alt))
  add(path_580462, "jobId", newJString(jobId))
  add(query_580463, "oauth_token", newJString(oauthToken))
  add(query_580463, "callback", newJString(callback))
  add(query_580463, "access_token", newJString(accessToken))
  add(query_580463, "uploadType", newJString(uploadType))
  add(query_580463, "key", newJString(key))
  add(path_580462, "projectId", newJString(projectId))
  add(query_580463, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580464 = body
  add(query_580463, "prettyPrint", newJBool(prettyPrint))
  add(path_580462, "location", newJString(location))
  result = call_580461.call(path_580462, query_580463, nil, nil, body_580464)

var dataflowProjectsLocationsJobsWorkItemsLease* = Call_DataflowProjectsLocationsJobsWorkItemsLease_580442(
    name: "dataflowProjectsLocationsJobsWorkItemsLease",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/workItems:lease",
    validator: validate_DataflowProjectsLocationsJobsWorkItemsLease_580443,
    base: "/", url: url_DataflowProjectsLocationsJobsWorkItemsLease_580444,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_580465 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsJobsWorkItemsReportStatus_580467(
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

proc validate_DataflowProjectsLocationsJobsWorkItemsReportStatus_580466(
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
  var valid_580468 = path.getOrDefault("jobId")
  valid_580468 = validateParameter(valid_580468, JString, required = true,
                                 default = nil)
  if valid_580468 != nil:
    section.add "jobId", valid_580468
  var valid_580469 = path.getOrDefault("projectId")
  valid_580469 = validateParameter(valid_580469, JString, required = true,
                                 default = nil)
  if valid_580469 != nil:
    section.add "projectId", valid_580469
  var valid_580470 = path.getOrDefault("location")
  valid_580470 = validateParameter(valid_580470, JString, required = true,
                                 default = nil)
  if valid_580470 != nil:
    section.add "location", valid_580470
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
  var valid_580471 = query.getOrDefault("upload_protocol")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "upload_protocol", valid_580471
  var valid_580472 = query.getOrDefault("fields")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "fields", valid_580472
  var valid_580473 = query.getOrDefault("quotaUser")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "quotaUser", valid_580473
  var valid_580474 = query.getOrDefault("alt")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = newJString("json"))
  if valid_580474 != nil:
    section.add "alt", valid_580474
  var valid_580475 = query.getOrDefault("oauth_token")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "oauth_token", valid_580475
  var valid_580476 = query.getOrDefault("callback")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "callback", valid_580476
  var valid_580477 = query.getOrDefault("access_token")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "access_token", valid_580477
  var valid_580478 = query.getOrDefault("uploadType")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "uploadType", valid_580478
  var valid_580479 = query.getOrDefault("key")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "key", valid_580479
  var valid_580480 = query.getOrDefault("$.xgafv")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = newJString("1"))
  if valid_580480 != nil:
    section.add "$.xgafv", valid_580480
  var valid_580481 = query.getOrDefault("prettyPrint")
  valid_580481 = validateParameter(valid_580481, JBool, required = false,
                                 default = newJBool(true))
  if valid_580481 != nil:
    section.add "prettyPrint", valid_580481
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

proc call*(call_580483: Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_580465;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports the status of dataflow WorkItems leased by a worker.
  ## 
  let valid = call_580483.validator(path, query, header, formData, body)
  let scheme = call_580483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580483.url(scheme.get, call_580483.host, call_580483.base,
                         call_580483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580483, url, valid)

proc call*(call_580484: Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_580465;
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
  var path_580485 = newJObject()
  var query_580486 = newJObject()
  var body_580487 = newJObject()
  add(query_580486, "upload_protocol", newJString(uploadProtocol))
  add(query_580486, "fields", newJString(fields))
  add(query_580486, "quotaUser", newJString(quotaUser))
  add(query_580486, "alt", newJString(alt))
  add(path_580485, "jobId", newJString(jobId))
  add(query_580486, "oauth_token", newJString(oauthToken))
  add(query_580486, "callback", newJString(callback))
  add(query_580486, "access_token", newJString(accessToken))
  add(query_580486, "uploadType", newJString(uploadType))
  add(query_580486, "key", newJString(key))
  add(path_580485, "projectId", newJString(projectId))
  add(query_580486, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580487 = body
  add(query_580486, "prettyPrint", newJBool(prettyPrint))
  add(path_580485, "location", newJString(location))
  result = call_580484.call(path_580485, query_580486, nil, nil, body_580487)

var dataflowProjectsLocationsJobsWorkItemsReportStatus* = Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_580465(
    name: "dataflowProjectsLocationsJobsWorkItemsReportStatus",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/workItems:reportStatus",
    validator: validate_DataflowProjectsLocationsJobsWorkItemsReportStatus_580466,
    base: "/", url: url_DataflowProjectsLocationsJobsWorkItemsReportStatus_580467,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsSqlValidate_580488 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsSqlValidate_580490(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsSqlValidate_580489(path: JsonNode;
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
  var valid_580491 = path.getOrDefault("projectId")
  valid_580491 = validateParameter(valid_580491, JString, required = true,
                                 default = nil)
  if valid_580491 != nil:
    section.add "projectId", valid_580491
  var valid_580492 = path.getOrDefault("location")
  valid_580492 = validateParameter(valid_580492, JString, required = true,
                                 default = nil)
  if valid_580492 != nil:
    section.add "location", valid_580492
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
  var valid_580493 = query.getOrDefault("upload_protocol")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "upload_protocol", valid_580493
  var valid_580494 = query.getOrDefault("fields")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "fields", valid_580494
  var valid_580495 = query.getOrDefault("quotaUser")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "quotaUser", valid_580495
  var valid_580496 = query.getOrDefault("alt")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = newJString("json"))
  if valid_580496 != nil:
    section.add "alt", valid_580496
  var valid_580497 = query.getOrDefault("query")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "query", valid_580497
  var valid_580498 = query.getOrDefault("oauth_token")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "oauth_token", valid_580498
  var valid_580499 = query.getOrDefault("callback")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "callback", valid_580499
  var valid_580500 = query.getOrDefault("access_token")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "access_token", valid_580500
  var valid_580501 = query.getOrDefault("uploadType")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "uploadType", valid_580501
  var valid_580502 = query.getOrDefault("key")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "key", valid_580502
  var valid_580503 = query.getOrDefault("$.xgafv")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = newJString("1"))
  if valid_580503 != nil:
    section.add "$.xgafv", valid_580503
  var valid_580504 = query.getOrDefault("prettyPrint")
  valid_580504 = validateParameter(valid_580504, JBool, required = false,
                                 default = newJBool(true))
  if valid_580504 != nil:
    section.add "prettyPrint", valid_580504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580505: Call_DataflowProjectsLocationsSqlValidate_580488;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates a GoogleSQL query for Cloud Dataflow syntax. Will always
  ## confirm the given query parses correctly, and if able to look up
  ## schema information from DataCatalog, will validate that the query
  ## analyzes properly as well.
  ## 
  let valid = call_580505.validator(path, query, header, formData, body)
  let scheme = call_580505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580505.url(scheme.get, call_580505.host, call_580505.base,
                         call_580505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580505, url, valid)

proc call*(call_580506: Call_DataflowProjectsLocationsSqlValidate_580488;
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
  var path_580507 = newJObject()
  var query_580508 = newJObject()
  add(query_580508, "upload_protocol", newJString(uploadProtocol))
  add(query_580508, "fields", newJString(fields))
  add(query_580508, "quotaUser", newJString(quotaUser))
  add(query_580508, "alt", newJString(alt))
  add(query_580508, "query", newJString(query))
  add(query_580508, "oauth_token", newJString(oauthToken))
  add(query_580508, "callback", newJString(callback))
  add(query_580508, "access_token", newJString(accessToken))
  add(query_580508, "uploadType", newJString(uploadType))
  add(query_580508, "key", newJString(key))
  add(path_580507, "projectId", newJString(projectId))
  add(query_580508, "$.xgafv", newJString(Xgafv))
  add(query_580508, "prettyPrint", newJBool(prettyPrint))
  add(path_580507, "location", newJString(location))
  result = call_580506.call(path_580507, query_580508, nil, nil, nil)

var dataflowProjectsLocationsSqlValidate* = Call_DataflowProjectsLocationsSqlValidate_580488(
    name: "dataflowProjectsLocationsSqlValidate", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/sql:validate",
    validator: validate_DataflowProjectsLocationsSqlValidate_580489, base: "/",
    url: url_DataflowProjectsLocationsSqlValidate_580490, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesCreate_580509 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsTemplatesCreate_580511(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsTemplatesCreate_580510(path: JsonNode;
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
  var valid_580512 = path.getOrDefault("projectId")
  valid_580512 = validateParameter(valid_580512, JString, required = true,
                                 default = nil)
  if valid_580512 != nil:
    section.add "projectId", valid_580512
  var valid_580513 = path.getOrDefault("location")
  valid_580513 = validateParameter(valid_580513, JString, required = true,
                                 default = nil)
  if valid_580513 != nil:
    section.add "location", valid_580513
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
  var valid_580514 = query.getOrDefault("upload_protocol")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "upload_protocol", valid_580514
  var valid_580515 = query.getOrDefault("fields")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "fields", valid_580515
  var valid_580516 = query.getOrDefault("quotaUser")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "quotaUser", valid_580516
  var valid_580517 = query.getOrDefault("alt")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = newJString("json"))
  if valid_580517 != nil:
    section.add "alt", valid_580517
  var valid_580518 = query.getOrDefault("oauth_token")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "oauth_token", valid_580518
  var valid_580519 = query.getOrDefault("callback")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "callback", valid_580519
  var valid_580520 = query.getOrDefault("access_token")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "access_token", valid_580520
  var valid_580521 = query.getOrDefault("uploadType")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "uploadType", valid_580521
  var valid_580522 = query.getOrDefault("key")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "key", valid_580522
  var valid_580523 = query.getOrDefault("$.xgafv")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = newJString("1"))
  if valid_580523 != nil:
    section.add "$.xgafv", valid_580523
  var valid_580524 = query.getOrDefault("prettyPrint")
  valid_580524 = validateParameter(valid_580524, JBool, required = false,
                                 default = newJBool(true))
  if valid_580524 != nil:
    section.add "prettyPrint", valid_580524
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

proc call*(call_580526: Call_DataflowProjectsLocationsTemplatesCreate_580509;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job from a template.
  ## 
  let valid = call_580526.validator(path, query, header, formData, body)
  let scheme = call_580526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580526.url(scheme.get, call_580526.host, call_580526.base,
                         call_580526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580526, url, valid)

proc call*(call_580527: Call_DataflowProjectsLocationsTemplatesCreate_580509;
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
  var path_580528 = newJObject()
  var query_580529 = newJObject()
  var body_580530 = newJObject()
  add(query_580529, "upload_protocol", newJString(uploadProtocol))
  add(query_580529, "fields", newJString(fields))
  add(query_580529, "quotaUser", newJString(quotaUser))
  add(query_580529, "alt", newJString(alt))
  add(query_580529, "oauth_token", newJString(oauthToken))
  add(query_580529, "callback", newJString(callback))
  add(query_580529, "access_token", newJString(accessToken))
  add(query_580529, "uploadType", newJString(uploadType))
  add(query_580529, "key", newJString(key))
  add(path_580528, "projectId", newJString(projectId))
  add(query_580529, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580530 = body
  add(query_580529, "prettyPrint", newJBool(prettyPrint))
  add(path_580528, "location", newJString(location))
  result = call_580527.call(path_580528, query_580529, nil, nil, body_580530)

var dataflowProjectsLocationsTemplatesCreate* = Call_DataflowProjectsLocationsTemplatesCreate_580509(
    name: "dataflowProjectsLocationsTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates",
    validator: validate_DataflowProjectsLocationsTemplatesCreate_580510,
    base: "/", url: url_DataflowProjectsLocationsTemplatesCreate_580511,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesGet_580531 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsTemplatesGet_580533(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsTemplatesGet_580532(path: JsonNode;
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
  var valid_580534 = path.getOrDefault("projectId")
  valid_580534 = validateParameter(valid_580534, JString, required = true,
                                 default = nil)
  if valid_580534 != nil:
    section.add "projectId", valid_580534
  var valid_580535 = path.getOrDefault("location")
  valid_580535 = validateParameter(valid_580535, JString, required = true,
                                 default = nil)
  if valid_580535 != nil:
    section.add "location", valid_580535
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
  var valid_580536 = query.getOrDefault("upload_protocol")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "upload_protocol", valid_580536
  var valid_580537 = query.getOrDefault("fields")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "fields", valid_580537
  var valid_580538 = query.getOrDefault("view")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = newJString("METADATA_ONLY"))
  if valid_580538 != nil:
    section.add "view", valid_580538
  var valid_580539 = query.getOrDefault("quotaUser")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "quotaUser", valid_580539
  var valid_580540 = query.getOrDefault("alt")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = newJString("json"))
  if valid_580540 != nil:
    section.add "alt", valid_580540
  var valid_580541 = query.getOrDefault("gcsPath")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = nil)
  if valid_580541 != nil:
    section.add "gcsPath", valid_580541
  var valid_580542 = query.getOrDefault("oauth_token")
  valid_580542 = validateParameter(valid_580542, JString, required = false,
                                 default = nil)
  if valid_580542 != nil:
    section.add "oauth_token", valid_580542
  var valid_580543 = query.getOrDefault("callback")
  valid_580543 = validateParameter(valid_580543, JString, required = false,
                                 default = nil)
  if valid_580543 != nil:
    section.add "callback", valid_580543
  var valid_580544 = query.getOrDefault("access_token")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "access_token", valid_580544
  var valid_580545 = query.getOrDefault("uploadType")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "uploadType", valid_580545
  var valid_580546 = query.getOrDefault("key")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "key", valid_580546
  var valid_580547 = query.getOrDefault("$.xgafv")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = newJString("1"))
  if valid_580547 != nil:
    section.add "$.xgafv", valid_580547
  var valid_580548 = query.getOrDefault("prettyPrint")
  valid_580548 = validateParameter(valid_580548, JBool, required = false,
                                 default = newJBool(true))
  if valid_580548 != nil:
    section.add "prettyPrint", valid_580548
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580549: Call_DataflowProjectsLocationsTemplatesGet_580531;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the template associated with a template.
  ## 
  let valid = call_580549.validator(path, query, header, formData, body)
  let scheme = call_580549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580549.url(scheme.get, call_580549.host, call_580549.base,
                         call_580549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580549, url, valid)

proc call*(call_580550: Call_DataflowProjectsLocationsTemplatesGet_580531;
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
  var path_580551 = newJObject()
  var query_580552 = newJObject()
  add(query_580552, "upload_protocol", newJString(uploadProtocol))
  add(query_580552, "fields", newJString(fields))
  add(query_580552, "view", newJString(view))
  add(query_580552, "quotaUser", newJString(quotaUser))
  add(query_580552, "alt", newJString(alt))
  add(query_580552, "gcsPath", newJString(gcsPath))
  add(query_580552, "oauth_token", newJString(oauthToken))
  add(query_580552, "callback", newJString(callback))
  add(query_580552, "access_token", newJString(accessToken))
  add(query_580552, "uploadType", newJString(uploadType))
  add(query_580552, "key", newJString(key))
  add(path_580551, "projectId", newJString(projectId))
  add(query_580552, "$.xgafv", newJString(Xgafv))
  add(query_580552, "prettyPrint", newJBool(prettyPrint))
  add(path_580551, "location", newJString(location))
  result = call_580550.call(path_580551, query_580552, nil, nil, nil)

var dataflowProjectsLocationsTemplatesGet* = Call_DataflowProjectsLocationsTemplatesGet_580531(
    name: "dataflowProjectsLocationsTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates:get",
    validator: validate_DataflowProjectsLocationsTemplatesGet_580532, base: "/",
    url: url_DataflowProjectsLocationsTemplatesGet_580533, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesLaunch_580553 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsLocationsTemplatesLaunch_580555(protocol: Scheme;
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

proc validate_DataflowProjectsLocationsTemplatesLaunch_580554(path: JsonNode;
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
  var valid_580556 = path.getOrDefault("projectId")
  valid_580556 = validateParameter(valid_580556, JString, required = true,
                                 default = nil)
  if valid_580556 != nil:
    section.add "projectId", valid_580556
  var valid_580557 = path.getOrDefault("location")
  valid_580557 = validateParameter(valid_580557, JString, required = true,
                                 default = nil)
  if valid_580557 != nil:
    section.add "location", valid_580557
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
  var valid_580558 = query.getOrDefault("upload_protocol")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "upload_protocol", valid_580558
  var valid_580559 = query.getOrDefault("fields")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = nil)
  if valid_580559 != nil:
    section.add "fields", valid_580559
  var valid_580560 = query.getOrDefault("quotaUser")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = nil)
  if valid_580560 != nil:
    section.add "quotaUser", valid_580560
  var valid_580561 = query.getOrDefault("dynamicTemplate.stagingLocation")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = nil)
  if valid_580561 != nil:
    section.add "dynamicTemplate.stagingLocation", valid_580561
  var valid_580562 = query.getOrDefault("alt")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = newJString("json"))
  if valid_580562 != nil:
    section.add "alt", valid_580562
  var valid_580563 = query.getOrDefault("dynamicTemplate.gcsPath")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "dynamicTemplate.gcsPath", valid_580563
  var valid_580564 = query.getOrDefault("gcsPath")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = nil)
  if valid_580564 != nil:
    section.add "gcsPath", valid_580564
  var valid_580565 = query.getOrDefault("oauth_token")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "oauth_token", valid_580565
  var valid_580566 = query.getOrDefault("callback")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "callback", valid_580566
  var valid_580567 = query.getOrDefault("access_token")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = nil)
  if valid_580567 != nil:
    section.add "access_token", valid_580567
  var valid_580568 = query.getOrDefault("uploadType")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "uploadType", valid_580568
  var valid_580569 = query.getOrDefault("validateOnly")
  valid_580569 = validateParameter(valid_580569, JBool, required = false, default = nil)
  if valid_580569 != nil:
    section.add "validateOnly", valid_580569
  var valid_580570 = query.getOrDefault("key")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "key", valid_580570
  var valid_580571 = query.getOrDefault("$.xgafv")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = newJString("1"))
  if valid_580571 != nil:
    section.add "$.xgafv", valid_580571
  var valid_580572 = query.getOrDefault("prettyPrint")
  valid_580572 = validateParameter(valid_580572, JBool, required = false,
                                 default = newJBool(true))
  if valid_580572 != nil:
    section.add "prettyPrint", valid_580572
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

proc call*(call_580574: Call_DataflowProjectsLocationsTemplatesLaunch_580553;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Launch a template.
  ## 
  let valid = call_580574.validator(path, query, header, formData, body)
  let scheme = call_580574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580574.url(scheme.get, call_580574.host, call_580574.base,
                         call_580574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580574, url, valid)

proc call*(call_580575: Call_DataflowProjectsLocationsTemplatesLaunch_580553;
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
  var path_580576 = newJObject()
  var query_580577 = newJObject()
  var body_580578 = newJObject()
  add(query_580577, "upload_protocol", newJString(uploadProtocol))
  add(query_580577, "fields", newJString(fields))
  add(query_580577, "quotaUser", newJString(quotaUser))
  add(query_580577, "dynamicTemplate.stagingLocation",
      newJString(dynamicTemplateStagingLocation))
  add(query_580577, "alt", newJString(alt))
  add(query_580577, "dynamicTemplate.gcsPath", newJString(dynamicTemplateGcsPath))
  add(query_580577, "gcsPath", newJString(gcsPath))
  add(query_580577, "oauth_token", newJString(oauthToken))
  add(query_580577, "callback", newJString(callback))
  add(query_580577, "access_token", newJString(accessToken))
  add(query_580577, "uploadType", newJString(uploadType))
  add(query_580577, "validateOnly", newJBool(validateOnly))
  add(query_580577, "key", newJString(key))
  add(path_580576, "projectId", newJString(projectId))
  add(query_580577, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580578 = body
  add(query_580577, "prettyPrint", newJBool(prettyPrint))
  add(path_580576, "location", newJString(location))
  result = call_580575.call(path_580576, query_580577, nil, nil, body_580578)

var dataflowProjectsLocationsTemplatesLaunch* = Call_DataflowProjectsLocationsTemplatesLaunch_580553(
    name: "dataflowProjectsLocationsTemplatesLaunch", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates:launch",
    validator: validate_DataflowProjectsLocationsTemplatesLaunch_580554,
    base: "/", url: url_DataflowProjectsLocationsTemplatesLaunch_580555,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesCreate_580579 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsTemplatesCreate_580581(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsTemplatesCreate_580580(path: JsonNode;
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
  var valid_580582 = path.getOrDefault("projectId")
  valid_580582 = validateParameter(valid_580582, JString, required = true,
                                 default = nil)
  if valid_580582 != nil:
    section.add "projectId", valid_580582
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
  var valid_580583 = query.getOrDefault("upload_protocol")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "upload_protocol", valid_580583
  var valid_580584 = query.getOrDefault("fields")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "fields", valid_580584
  var valid_580585 = query.getOrDefault("quotaUser")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "quotaUser", valid_580585
  var valid_580586 = query.getOrDefault("alt")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = newJString("json"))
  if valid_580586 != nil:
    section.add "alt", valid_580586
  var valid_580587 = query.getOrDefault("oauth_token")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "oauth_token", valid_580587
  var valid_580588 = query.getOrDefault("callback")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = nil)
  if valid_580588 != nil:
    section.add "callback", valid_580588
  var valid_580589 = query.getOrDefault("access_token")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "access_token", valid_580589
  var valid_580590 = query.getOrDefault("uploadType")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "uploadType", valid_580590
  var valid_580591 = query.getOrDefault("key")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "key", valid_580591
  var valid_580592 = query.getOrDefault("$.xgafv")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = newJString("1"))
  if valid_580592 != nil:
    section.add "$.xgafv", valid_580592
  var valid_580593 = query.getOrDefault("prettyPrint")
  valid_580593 = validateParameter(valid_580593, JBool, required = false,
                                 default = newJBool(true))
  if valid_580593 != nil:
    section.add "prettyPrint", valid_580593
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

proc call*(call_580595: Call_DataflowProjectsTemplatesCreate_580579;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job from a template.
  ## 
  let valid = call_580595.validator(path, query, header, formData, body)
  let scheme = call_580595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580595.url(scheme.get, call_580595.host, call_580595.base,
                         call_580595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580595, url, valid)

proc call*(call_580596: Call_DataflowProjectsTemplatesCreate_580579;
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
  var path_580597 = newJObject()
  var query_580598 = newJObject()
  var body_580599 = newJObject()
  add(query_580598, "upload_protocol", newJString(uploadProtocol))
  add(query_580598, "fields", newJString(fields))
  add(query_580598, "quotaUser", newJString(quotaUser))
  add(query_580598, "alt", newJString(alt))
  add(query_580598, "oauth_token", newJString(oauthToken))
  add(query_580598, "callback", newJString(callback))
  add(query_580598, "access_token", newJString(accessToken))
  add(query_580598, "uploadType", newJString(uploadType))
  add(query_580598, "key", newJString(key))
  add(path_580597, "projectId", newJString(projectId))
  add(query_580598, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580599 = body
  add(query_580598, "prettyPrint", newJBool(prettyPrint))
  result = call_580596.call(path_580597, query_580598, nil, nil, body_580599)

var dataflowProjectsTemplatesCreate* = Call_DataflowProjectsTemplatesCreate_580579(
    name: "dataflowProjectsTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates",
    validator: validate_DataflowProjectsTemplatesCreate_580580, base: "/",
    url: url_DataflowProjectsTemplatesCreate_580581, schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesGet_580600 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsTemplatesGet_580602(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsTemplatesGet_580601(path: JsonNode; query: JsonNode;
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
  var valid_580603 = path.getOrDefault("projectId")
  valid_580603 = validateParameter(valid_580603, JString, required = true,
                                 default = nil)
  if valid_580603 != nil:
    section.add "projectId", valid_580603
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
  var valid_580604 = query.getOrDefault("upload_protocol")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "upload_protocol", valid_580604
  var valid_580605 = query.getOrDefault("fields")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "fields", valid_580605
  var valid_580606 = query.getOrDefault("view")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = newJString("METADATA_ONLY"))
  if valid_580606 != nil:
    section.add "view", valid_580606
  var valid_580607 = query.getOrDefault("quotaUser")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "quotaUser", valid_580607
  var valid_580608 = query.getOrDefault("alt")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = newJString("json"))
  if valid_580608 != nil:
    section.add "alt", valid_580608
  var valid_580609 = query.getOrDefault("gcsPath")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "gcsPath", valid_580609
  var valid_580610 = query.getOrDefault("oauth_token")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "oauth_token", valid_580610
  var valid_580611 = query.getOrDefault("callback")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "callback", valid_580611
  var valid_580612 = query.getOrDefault("access_token")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "access_token", valid_580612
  var valid_580613 = query.getOrDefault("uploadType")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "uploadType", valid_580613
  var valid_580614 = query.getOrDefault("location")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "location", valid_580614
  var valid_580615 = query.getOrDefault("key")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "key", valid_580615
  var valid_580616 = query.getOrDefault("$.xgafv")
  valid_580616 = validateParameter(valid_580616, JString, required = false,
                                 default = newJString("1"))
  if valid_580616 != nil:
    section.add "$.xgafv", valid_580616
  var valid_580617 = query.getOrDefault("prettyPrint")
  valid_580617 = validateParameter(valid_580617, JBool, required = false,
                                 default = newJBool(true))
  if valid_580617 != nil:
    section.add "prettyPrint", valid_580617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580618: Call_DataflowProjectsTemplatesGet_580600; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the template associated with a template.
  ## 
  let valid = call_580618.validator(path, query, header, formData, body)
  let scheme = call_580618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580618.url(scheme.get, call_580618.host, call_580618.base,
                         call_580618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580618, url, valid)

proc call*(call_580619: Call_DataflowProjectsTemplatesGet_580600;
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
  var path_580620 = newJObject()
  var query_580621 = newJObject()
  add(query_580621, "upload_protocol", newJString(uploadProtocol))
  add(query_580621, "fields", newJString(fields))
  add(query_580621, "view", newJString(view))
  add(query_580621, "quotaUser", newJString(quotaUser))
  add(query_580621, "alt", newJString(alt))
  add(query_580621, "gcsPath", newJString(gcsPath))
  add(query_580621, "oauth_token", newJString(oauthToken))
  add(query_580621, "callback", newJString(callback))
  add(query_580621, "access_token", newJString(accessToken))
  add(query_580621, "uploadType", newJString(uploadType))
  add(query_580621, "location", newJString(location))
  add(query_580621, "key", newJString(key))
  add(path_580620, "projectId", newJString(projectId))
  add(query_580621, "$.xgafv", newJString(Xgafv))
  add(query_580621, "prettyPrint", newJBool(prettyPrint))
  result = call_580619.call(path_580620, query_580621, nil, nil, nil)

var dataflowProjectsTemplatesGet* = Call_DataflowProjectsTemplatesGet_580600(
    name: "dataflowProjectsTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates:get",
    validator: validate_DataflowProjectsTemplatesGet_580601, base: "/",
    url: url_DataflowProjectsTemplatesGet_580602, schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesLaunch_580622 = ref object of OpenApiRestCall_579421
proc url_DataflowProjectsTemplatesLaunch_580624(protocol: Scheme; host: string;
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

proc validate_DataflowProjectsTemplatesLaunch_580623(path: JsonNode;
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
  var valid_580625 = path.getOrDefault("projectId")
  valid_580625 = validateParameter(valid_580625, JString, required = true,
                                 default = nil)
  if valid_580625 != nil:
    section.add "projectId", valid_580625
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
  var valid_580626 = query.getOrDefault("upload_protocol")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "upload_protocol", valid_580626
  var valid_580627 = query.getOrDefault("fields")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "fields", valid_580627
  var valid_580628 = query.getOrDefault("quotaUser")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "quotaUser", valid_580628
  var valid_580629 = query.getOrDefault("dynamicTemplate.stagingLocation")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "dynamicTemplate.stagingLocation", valid_580629
  var valid_580630 = query.getOrDefault("alt")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = newJString("json"))
  if valid_580630 != nil:
    section.add "alt", valid_580630
  var valid_580631 = query.getOrDefault("dynamicTemplate.gcsPath")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "dynamicTemplate.gcsPath", valid_580631
  var valid_580632 = query.getOrDefault("gcsPath")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "gcsPath", valid_580632
  var valid_580633 = query.getOrDefault("oauth_token")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "oauth_token", valid_580633
  var valid_580634 = query.getOrDefault("callback")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = nil)
  if valid_580634 != nil:
    section.add "callback", valid_580634
  var valid_580635 = query.getOrDefault("access_token")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "access_token", valid_580635
  var valid_580636 = query.getOrDefault("uploadType")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = nil)
  if valid_580636 != nil:
    section.add "uploadType", valid_580636
  var valid_580637 = query.getOrDefault("location")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = nil)
  if valid_580637 != nil:
    section.add "location", valid_580637
  var valid_580638 = query.getOrDefault("validateOnly")
  valid_580638 = validateParameter(valid_580638, JBool, required = false, default = nil)
  if valid_580638 != nil:
    section.add "validateOnly", valid_580638
  var valid_580639 = query.getOrDefault("key")
  valid_580639 = validateParameter(valid_580639, JString, required = false,
                                 default = nil)
  if valid_580639 != nil:
    section.add "key", valid_580639
  var valid_580640 = query.getOrDefault("$.xgafv")
  valid_580640 = validateParameter(valid_580640, JString, required = false,
                                 default = newJString("1"))
  if valid_580640 != nil:
    section.add "$.xgafv", valid_580640
  var valid_580641 = query.getOrDefault("prettyPrint")
  valid_580641 = validateParameter(valid_580641, JBool, required = false,
                                 default = newJBool(true))
  if valid_580641 != nil:
    section.add "prettyPrint", valid_580641
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

proc call*(call_580643: Call_DataflowProjectsTemplatesLaunch_580622;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Launch a template.
  ## 
  let valid = call_580643.validator(path, query, header, formData, body)
  let scheme = call_580643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580643.url(scheme.get, call_580643.host, call_580643.base,
                         call_580643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580643, url, valid)

proc call*(call_580644: Call_DataflowProjectsTemplatesLaunch_580622;
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
  var path_580645 = newJObject()
  var query_580646 = newJObject()
  var body_580647 = newJObject()
  add(query_580646, "upload_protocol", newJString(uploadProtocol))
  add(query_580646, "fields", newJString(fields))
  add(query_580646, "quotaUser", newJString(quotaUser))
  add(query_580646, "dynamicTemplate.stagingLocation",
      newJString(dynamicTemplateStagingLocation))
  add(query_580646, "alt", newJString(alt))
  add(query_580646, "dynamicTemplate.gcsPath", newJString(dynamicTemplateGcsPath))
  add(query_580646, "gcsPath", newJString(gcsPath))
  add(query_580646, "oauth_token", newJString(oauthToken))
  add(query_580646, "callback", newJString(callback))
  add(query_580646, "access_token", newJString(accessToken))
  add(query_580646, "uploadType", newJString(uploadType))
  add(query_580646, "location", newJString(location))
  add(query_580646, "validateOnly", newJBool(validateOnly))
  add(query_580646, "key", newJString(key))
  add(path_580645, "projectId", newJString(projectId))
  add(query_580646, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580647 = body
  add(query_580646, "prettyPrint", newJBool(prettyPrint))
  result = call_580644.call(path_580645, query_580646, nil, nil, body_580647)

var dataflowProjectsTemplatesLaunch* = Call_DataflowProjectsTemplatesLaunch_580622(
    name: "dataflowProjectsTemplatesLaunch", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates:launch",
    validator: validate_DataflowProjectsTemplatesLaunch_580623, base: "/",
    url: url_DataflowProjectsTemplatesLaunch_580624, schemes: {Scheme.Https})
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
