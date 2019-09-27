
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DataflowProjectsWorkerMessages_593690 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsWorkerMessages_593692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsWorkerMessages_593691(path: JsonNode;
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
  var valid_593818 = path.getOrDefault("projectId")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "projectId", valid_593818
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
  var valid_593819 = query.getOrDefault("upload_protocol")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = nil)
  if valid_593819 != nil:
    section.add "upload_protocol", valid_593819
  var valid_593820 = query.getOrDefault("fields")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "fields", valid_593820
  var valid_593821 = query.getOrDefault("quotaUser")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "quotaUser", valid_593821
  var valid_593835 = query.getOrDefault("alt")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = newJString("json"))
  if valid_593835 != nil:
    section.add "alt", valid_593835
  var valid_593836 = query.getOrDefault("oauth_token")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "oauth_token", valid_593836
  var valid_593837 = query.getOrDefault("callback")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "callback", valid_593837
  var valid_593838 = query.getOrDefault("access_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "access_token", valid_593838
  var valid_593839 = query.getOrDefault("uploadType")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "uploadType", valid_593839
  var valid_593840 = query.getOrDefault("key")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "key", valid_593840
  var valid_593841 = query.getOrDefault("$.xgafv")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = newJString("1"))
  if valid_593841 != nil:
    section.add "$.xgafv", valid_593841
  var valid_593842 = query.getOrDefault("prettyPrint")
  valid_593842 = validateParameter(valid_593842, JBool, required = false,
                                 default = newJBool(true))
  if valid_593842 != nil:
    section.add "prettyPrint", valid_593842
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

proc call*(call_593866: Call_DataflowProjectsWorkerMessages_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send a worker_message to the service.
  ## 
  let valid = call_593866.validator(path, query, header, formData, body)
  let scheme = call_593866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593866.url(scheme.get, call_593866.host, call_593866.base,
                         call_593866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593866, url, valid)

proc call*(call_593937: Call_DataflowProjectsWorkerMessages_593690;
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
  var path_593938 = newJObject()
  var query_593940 = newJObject()
  var body_593941 = newJObject()
  add(query_593940, "upload_protocol", newJString(uploadProtocol))
  add(query_593940, "fields", newJString(fields))
  add(query_593940, "quotaUser", newJString(quotaUser))
  add(query_593940, "alt", newJString(alt))
  add(query_593940, "oauth_token", newJString(oauthToken))
  add(query_593940, "callback", newJString(callback))
  add(query_593940, "access_token", newJString(accessToken))
  add(query_593940, "uploadType", newJString(uploadType))
  add(query_593940, "key", newJString(key))
  add(path_593938, "projectId", newJString(projectId))
  add(query_593940, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593941 = body
  add(query_593940, "prettyPrint", newJBool(prettyPrint))
  result = call_593937.call(path_593938, query_593940, nil, nil, body_593941)

var dataflowProjectsWorkerMessages* = Call_DataflowProjectsWorkerMessages_593690(
    name: "dataflowProjectsWorkerMessages", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/WorkerMessages",
    validator: validate_DataflowProjectsWorkerMessages_593691, base: "/",
    url: url_DataflowProjectsWorkerMessages_593692, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsCreate_594004 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsJobsCreate_594006(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsJobsCreate_594005(path: JsonNode; query: JsonNode;
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
  var valid_594007 = path.getOrDefault("projectId")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "projectId", valid_594007
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
  var valid_594008 = query.getOrDefault("upload_protocol")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "upload_protocol", valid_594008
  var valid_594009 = query.getOrDefault("fields")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "fields", valid_594009
  var valid_594010 = query.getOrDefault("view")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_594010 != nil:
    section.add "view", valid_594010
  var valid_594011 = query.getOrDefault("quotaUser")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "quotaUser", valid_594011
  var valid_594012 = query.getOrDefault("alt")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = newJString("json"))
  if valid_594012 != nil:
    section.add "alt", valid_594012
  var valid_594013 = query.getOrDefault("oauth_token")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "oauth_token", valid_594013
  var valid_594014 = query.getOrDefault("callback")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "callback", valid_594014
  var valid_594015 = query.getOrDefault("access_token")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "access_token", valid_594015
  var valid_594016 = query.getOrDefault("uploadType")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "uploadType", valid_594016
  var valid_594017 = query.getOrDefault("location")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "location", valid_594017
  var valid_594018 = query.getOrDefault("replaceJobId")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "replaceJobId", valid_594018
  var valid_594019 = query.getOrDefault("key")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "key", valid_594019
  var valid_594020 = query.getOrDefault("$.xgafv")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = newJString("1"))
  if valid_594020 != nil:
    section.add "$.xgafv", valid_594020
  var valid_594021 = query.getOrDefault("prettyPrint")
  valid_594021 = validateParameter(valid_594021, JBool, required = false,
                                 default = newJBool(true))
  if valid_594021 != nil:
    section.add "prettyPrint", valid_594021
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

proc call*(call_594023: Call_DataflowProjectsJobsCreate_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job.
  ## 
  ## To create a job, we recommend using `projects.locations.jobs.create` with a
  ## [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.create` is not recommended, as your job will always start
  ## in `us-central1`.
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_DataflowProjectsJobsCreate_594004; projectId: string;
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
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  var body_594027 = newJObject()
  add(query_594026, "upload_protocol", newJString(uploadProtocol))
  add(query_594026, "fields", newJString(fields))
  add(query_594026, "view", newJString(view))
  add(query_594026, "quotaUser", newJString(quotaUser))
  add(query_594026, "alt", newJString(alt))
  add(query_594026, "oauth_token", newJString(oauthToken))
  add(query_594026, "callback", newJString(callback))
  add(query_594026, "access_token", newJString(accessToken))
  add(query_594026, "uploadType", newJString(uploadType))
  add(query_594026, "location", newJString(location))
  add(query_594026, "replaceJobId", newJString(replaceJobId))
  add(query_594026, "key", newJString(key))
  add(path_594025, "projectId", newJString(projectId))
  add(query_594026, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594027 = body
  add(query_594026, "prettyPrint", newJBool(prettyPrint))
  result = call_594024.call(path_594025, query_594026, nil, nil, body_594027)

var dataflowProjectsJobsCreate* = Call_DataflowProjectsJobsCreate_594004(
    name: "dataflowProjectsJobsCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/jobs",
    validator: validate_DataflowProjectsJobsCreate_594005, base: "/",
    url: url_DataflowProjectsJobsCreate_594006, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsList_593980 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsJobsList_593982(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsJobsList_593981(path: JsonNode; query: JsonNode;
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
  var valid_593983 = path.getOrDefault("projectId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "projectId", valid_593983
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
  var valid_593984 = query.getOrDefault("upload_protocol")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "upload_protocol", valid_593984
  var valid_593985 = query.getOrDefault("fields")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "fields", valid_593985
  var valid_593986 = query.getOrDefault("pageToken")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "pageToken", valid_593986
  var valid_593987 = query.getOrDefault("quotaUser")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "quotaUser", valid_593987
  var valid_593988 = query.getOrDefault("view")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_593988 != nil:
    section.add "view", valid_593988
  var valid_593989 = query.getOrDefault("alt")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = newJString("json"))
  if valid_593989 != nil:
    section.add "alt", valid_593989
  var valid_593990 = query.getOrDefault("oauth_token")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "oauth_token", valid_593990
  var valid_593991 = query.getOrDefault("callback")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "callback", valid_593991
  var valid_593992 = query.getOrDefault("access_token")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "access_token", valid_593992
  var valid_593993 = query.getOrDefault("uploadType")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "uploadType", valid_593993
  var valid_593994 = query.getOrDefault("location")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "location", valid_593994
  var valid_593995 = query.getOrDefault("key")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "key", valid_593995
  var valid_593996 = query.getOrDefault("$.xgafv")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = newJString("1"))
  if valid_593996 != nil:
    section.add "$.xgafv", valid_593996
  var valid_593997 = query.getOrDefault("pageSize")
  valid_593997 = validateParameter(valid_593997, JInt, required = false, default = nil)
  if valid_593997 != nil:
    section.add "pageSize", valid_593997
  var valid_593998 = query.getOrDefault("prettyPrint")
  valid_593998 = validateParameter(valid_593998, JBool, required = false,
                                 default = newJBool(true))
  if valid_593998 != nil:
    section.add "prettyPrint", valid_593998
  var valid_593999 = query.getOrDefault("filter")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_593999 != nil:
    section.add "filter", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_DataflowProjectsJobsList_593980; path: JsonNode;
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
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_DataflowProjectsJobsList_593980; projectId: string;
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
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(query_594003, "upload_protocol", newJString(uploadProtocol))
  add(query_594003, "fields", newJString(fields))
  add(query_594003, "pageToken", newJString(pageToken))
  add(query_594003, "quotaUser", newJString(quotaUser))
  add(query_594003, "view", newJString(view))
  add(query_594003, "alt", newJString(alt))
  add(query_594003, "oauth_token", newJString(oauthToken))
  add(query_594003, "callback", newJString(callback))
  add(query_594003, "access_token", newJString(accessToken))
  add(query_594003, "uploadType", newJString(uploadType))
  add(query_594003, "location", newJString(location))
  add(query_594003, "key", newJString(key))
  add(path_594002, "projectId", newJString(projectId))
  add(query_594003, "$.xgafv", newJString(Xgafv))
  add(query_594003, "pageSize", newJInt(pageSize))
  add(query_594003, "prettyPrint", newJBool(prettyPrint))
  add(query_594003, "filter", newJString(filter))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var dataflowProjectsJobsList* = Call_DataflowProjectsJobsList_593980(
    name: "dataflowProjectsJobsList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/jobs",
    validator: validate_DataflowProjectsJobsList_593981, base: "/",
    url: url_DataflowProjectsJobsList_593982, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsUpdate_594050 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsJobsUpdate_594052(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsJobsUpdate_594051(path: JsonNode; query: JsonNode;
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
  var valid_594053 = path.getOrDefault("jobId")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "jobId", valid_594053
  var valid_594054 = path.getOrDefault("projectId")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "projectId", valid_594054
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
  var valid_594055 = query.getOrDefault("upload_protocol")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "upload_protocol", valid_594055
  var valid_594056 = query.getOrDefault("fields")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "fields", valid_594056
  var valid_594057 = query.getOrDefault("quotaUser")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "quotaUser", valid_594057
  var valid_594058 = query.getOrDefault("alt")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = newJString("json"))
  if valid_594058 != nil:
    section.add "alt", valid_594058
  var valid_594059 = query.getOrDefault("oauth_token")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "oauth_token", valid_594059
  var valid_594060 = query.getOrDefault("callback")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "callback", valid_594060
  var valid_594061 = query.getOrDefault("access_token")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "access_token", valid_594061
  var valid_594062 = query.getOrDefault("uploadType")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "uploadType", valid_594062
  var valid_594063 = query.getOrDefault("location")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "location", valid_594063
  var valid_594064 = query.getOrDefault("key")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "key", valid_594064
  var valid_594065 = query.getOrDefault("$.xgafv")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = newJString("1"))
  if valid_594065 != nil:
    section.add "$.xgafv", valid_594065
  var valid_594066 = query.getOrDefault("prettyPrint")
  valid_594066 = validateParameter(valid_594066, JBool, required = false,
                                 default = newJBool(true))
  if valid_594066 != nil:
    section.add "prettyPrint", valid_594066
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

proc call*(call_594068: Call_DataflowProjectsJobsUpdate_594050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the state of an existing Cloud Dataflow job.
  ## 
  ## To update the state of an existing job, we recommend using
  ## `projects.locations.jobs.update` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.update` is not recommended, as you can only update the state
  ## of jobs that are running in `us-central1`.
  ## 
  let valid = call_594068.validator(path, query, header, formData, body)
  let scheme = call_594068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594068.url(scheme.get, call_594068.host, call_594068.base,
                         call_594068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594068, url, valid)

proc call*(call_594069: Call_DataflowProjectsJobsUpdate_594050; jobId: string;
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
  var path_594070 = newJObject()
  var query_594071 = newJObject()
  var body_594072 = newJObject()
  add(query_594071, "upload_protocol", newJString(uploadProtocol))
  add(query_594071, "fields", newJString(fields))
  add(query_594071, "quotaUser", newJString(quotaUser))
  add(query_594071, "alt", newJString(alt))
  add(path_594070, "jobId", newJString(jobId))
  add(query_594071, "oauth_token", newJString(oauthToken))
  add(query_594071, "callback", newJString(callback))
  add(query_594071, "access_token", newJString(accessToken))
  add(query_594071, "uploadType", newJString(uploadType))
  add(query_594071, "location", newJString(location))
  add(query_594071, "key", newJString(key))
  add(path_594070, "projectId", newJString(projectId))
  add(query_594071, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594072 = body
  add(query_594071, "prettyPrint", newJBool(prettyPrint))
  result = call_594069.call(path_594070, query_594071, nil, nil, body_594072)

var dataflowProjectsJobsUpdate* = Call_DataflowProjectsJobsUpdate_594050(
    name: "dataflowProjectsJobsUpdate", meth: HttpMethod.HttpPut,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataflowProjectsJobsUpdate_594051, base: "/",
    url: url_DataflowProjectsJobsUpdate_594052, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsGet_594028 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsJobsGet_594030(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsJobsGet_594029(path: JsonNode; query: JsonNode;
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
  var valid_594031 = path.getOrDefault("jobId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "jobId", valid_594031
  var valid_594032 = path.getOrDefault("projectId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "projectId", valid_594032
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
  var valid_594033 = query.getOrDefault("upload_protocol")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "upload_protocol", valid_594033
  var valid_594034 = query.getOrDefault("fields")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "fields", valid_594034
  var valid_594035 = query.getOrDefault("view")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_594035 != nil:
    section.add "view", valid_594035
  var valid_594036 = query.getOrDefault("quotaUser")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "quotaUser", valid_594036
  var valid_594037 = query.getOrDefault("alt")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = newJString("json"))
  if valid_594037 != nil:
    section.add "alt", valid_594037
  var valid_594038 = query.getOrDefault("oauth_token")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "oauth_token", valid_594038
  var valid_594039 = query.getOrDefault("callback")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "callback", valid_594039
  var valid_594040 = query.getOrDefault("access_token")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "access_token", valid_594040
  var valid_594041 = query.getOrDefault("uploadType")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "uploadType", valid_594041
  var valid_594042 = query.getOrDefault("location")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "location", valid_594042
  var valid_594043 = query.getOrDefault("key")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "key", valid_594043
  var valid_594044 = query.getOrDefault("$.xgafv")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = newJString("1"))
  if valid_594044 != nil:
    section.add "$.xgafv", valid_594044
  var valid_594045 = query.getOrDefault("prettyPrint")
  valid_594045 = validateParameter(valid_594045, JBool, required = false,
                                 default = newJBool(true))
  if valid_594045 != nil:
    section.add "prettyPrint", valid_594045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_DataflowProjectsJobsGet_594028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the state of the specified Cloud Dataflow job.
  ## 
  ## To get the state of a job, we recommend using `projects.locations.jobs.get`
  ## with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.get` is not recommended, as you can only get the state of
  ## jobs that are running in `us-central1`.
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_DataflowProjectsJobsGet_594028; jobId: string;
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
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  add(query_594049, "upload_protocol", newJString(uploadProtocol))
  add(query_594049, "fields", newJString(fields))
  add(query_594049, "view", newJString(view))
  add(query_594049, "quotaUser", newJString(quotaUser))
  add(query_594049, "alt", newJString(alt))
  add(path_594048, "jobId", newJString(jobId))
  add(query_594049, "oauth_token", newJString(oauthToken))
  add(query_594049, "callback", newJString(callback))
  add(query_594049, "access_token", newJString(accessToken))
  add(query_594049, "uploadType", newJString(uploadType))
  add(query_594049, "location", newJString(location))
  add(query_594049, "key", newJString(key))
  add(path_594048, "projectId", newJString(projectId))
  add(query_594049, "$.xgafv", newJString(Xgafv))
  add(query_594049, "prettyPrint", newJBool(prettyPrint))
  result = call_594047.call(path_594048, query_594049, nil, nil, nil)

var dataflowProjectsJobsGet* = Call_DataflowProjectsJobsGet_594028(
    name: "dataflowProjectsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataflowProjectsJobsGet_594029, base: "/",
    url: url_DataflowProjectsJobsGet_594030, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsDebugGetConfig_594073 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsJobsDebugGetConfig_594075(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsJobsDebugGetConfig_594074(path: JsonNode;
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
  var valid_594076 = path.getOrDefault("jobId")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "jobId", valid_594076
  var valid_594077 = path.getOrDefault("projectId")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "projectId", valid_594077
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
  var valid_594078 = query.getOrDefault("upload_protocol")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "upload_protocol", valid_594078
  var valid_594079 = query.getOrDefault("fields")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "fields", valid_594079
  var valid_594080 = query.getOrDefault("quotaUser")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "quotaUser", valid_594080
  var valid_594081 = query.getOrDefault("alt")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = newJString("json"))
  if valid_594081 != nil:
    section.add "alt", valid_594081
  var valid_594082 = query.getOrDefault("oauth_token")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "oauth_token", valid_594082
  var valid_594083 = query.getOrDefault("callback")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "callback", valid_594083
  var valid_594084 = query.getOrDefault("access_token")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "access_token", valid_594084
  var valid_594085 = query.getOrDefault("uploadType")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "uploadType", valid_594085
  var valid_594086 = query.getOrDefault("key")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "key", valid_594086
  var valid_594087 = query.getOrDefault("$.xgafv")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = newJString("1"))
  if valid_594087 != nil:
    section.add "$.xgafv", valid_594087
  var valid_594088 = query.getOrDefault("prettyPrint")
  valid_594088 = validateParameter(valid_594088, JBool, required = false,
                                 default = newJBool(true))
  if valid_594088 != nil:
    section.add "prettyPrint", valid_594088
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

proc call*(call_594090: Call_DataflowProjectsJobsDebugGetConfig_594073;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get encoded debug configuration for component. Not cacheable.
  ## 
  let valid = call_594090.validator(path, query, header, formData, body)
  let scheme = call_594090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594090.url(scheme.get, call_594090.host, call_594090.base,
                         call_594090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594090, url, valid)

proc call*(call_594091: Call_DataflowProjectsJobsDebugGetConfig_594073;
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
  var path_594092 = newJObject()
  var query_594093 = newJObject()
  var body_594094 = newJObject()
  add(query_594093, "upload_protocol", newJString(uploadProtocol))
  add(query_594093, "fields", newJString(fields))
  add(query_594093, "quotaUser", newJString(quotaUser))
  add(query_594093, "alt", newJString(alt))
  add(path_594092, "jobId", newJString(jobId))
  add(query_594093, "oauth_token", newJString(oauthToken))
  add(query_594093, "callback", newJString(callback))
  add(query_594093, "access_token", newJString(accessToken))
  add(query_594093, "uploadType", newJString(uploadType))
  add(query_594093, "key", newJString(key))
  add(path_594092, "projectId", newJString(projectId))
  add(query_594093, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594094 = body
  add(query_594093, "prettyPrint", newJBool(prettyPrint))
  result = call_594091.call(path_594092, query_594093, nil, nil, body_594094)

var dataflowProjectsJobsDebugGetConfig* = Call_DataflowProjectsJobsDebugGetConfig_594073(
    name: "dataflowProjectsJobsDebugGetConfig", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/debug/getConfig",
    validator: validate_DataflowProjectsJobsDebugGetConfig_594074, base: "/",
    url: url_DataflowProjectsJobsDebugGetConfig_594075, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsDebugSendCapture_594095 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsJobsDebugSendCapture_594097(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsJobsDebugSendCapture_594096(path: JsonNode;
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
  var valid_594098 = path.getOrDefault("jobId")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "jobId", valid_594098
  var valid_594099 = path.getOrDefault("projectId")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "projectId", valid_594099
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
  var valid_594100 = query.getOrDefault("upload_protocol")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "upload_protocol", valid_594100
  var valid_594101 = query.getOrDefault("fields")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "fields", valid_594101
  var valid_594102 = query.getOrDefault("quotaUser")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "quotaUser", valid_594102
  var valid_594103 = query.getOrDefault("alt")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = newJString("json"))
  if valid_594103 != nil:
    section.add "alt", valid_594103
  var valid_594104 = query.getOrDefault("oauth_token")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "oauth_token", valid_594104
  var valid_594105 = query.getOrDefault("callback")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "callback", valid_594105
  var valid_594106 = query.getOrDefault("access_token")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "access_token", valid_594106
  var valid_594107 = query.getOrDefault("uploadType")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "uploadType", valid_594107
  var valid_594108 = query.getOrDefault("key")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "key", valid_594108
  var valid_594109 = query.getOrDefault("$.xgafv")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = newJString("1"))
  if valid_594109 != nil:
    section.add "$.xgafv", valid_594109
  var valid_594110 = query.getOrDefault("prettyPrint")
  valid_594110 = validateParameter(valid_594110, JBool, required = false,
                                 default = newJBool(true))
  if valid_594110 != nil:
    section.add "prettyPrint", valid_594110
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

proc call*(call_594112: Call_DataflowProjectsJobsDebugSendCapture_594095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send encoded debug capture data for component.
  ## 
  let valid = call_594112.validator(path, query, header, formData, body)
  let scheme = call_594112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594112.url(scheme.get, call_594112.host, call_594112.base,
                         call_594112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594112, url, valid)

proc call*(call_594113: Call_DataflowProjectsJobsDebugSendCapture_594095;
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
  var path_594114 = newJObject()
  var query_594115 = newJObject()
  var body_594116 = newJObject()
  add(query_594115, "upload_protocol", newJString(uploadProtocol))
  add(query_594115, "fields", newJString(fields))
  add(query_594115, "quotaUser", newJString(quotaUser))
  add(query_594115, "alt", newJString(alt))
  add(path_594114, "jobId", newJString(jobId))
  add(query_594115, "oauth_token", newJString(oauthToken))
  add(query_594115, "callback", newJString(callback))
  add(query_594115, "access_token", newJString(accessToken))
  add(query_594115, "uploadType", newJString(uploadType))
  add(query_594115, "key", newJString(key))
  add(path_594114, "projectId", newJString(projectId))
  add(query_594115, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594116 = body
  add(query_594115, "prettyPrint", newJBool(prettyPrint))
  result = call_594113.call(path_594114, query_594115, nil, nil, body_594116)

var dataflowProjectsJobsDebugSendCapture* = Call_DataflowProjectsJobsDebugSendCapture_594095(
    name: "dataflowProjectsJobsDebugSendCapture", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/debug/sendCapture",
    validator: validate_DataflowProjectsJobsDebugSendCapture_594096, base: "/",
    url: url_DataflowProjectsJobsDebugSendCapture_594097, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsMessagesList_594117 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsJobsMessagesList_594119(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsJobsMessagesList_594118(path: JsonNode;
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
  var valid_594120 = path.getOrDefault("jobId")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "jobId", valid_594120
  var valid_594121 = path.getOrDefault("projectId")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "projectId", valid_594121
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
  var valid_594122 = query.getOrDefault("upload_protocol")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "upload_protocol", valid_594122
  var valid_594123 = query.getOrDefault("fields")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "fields", valid_594123
  var valid_594124 = query.getOrDefault("pageToken")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "pageToken", valid_594124
  var valid_594125 = query.getOrDefault("quotaUser")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "quotaUser", valid_594125
  var valid_594126 = query.getOrDefault("alt")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = newJString("json"))
  if valid_594126 != nil:
    section.add "alt", valid_594126
  var valid_594127 = query.getOrDefault("oauth_token")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "oauth_token", valid_594127
  var valid_594128 = query.getOrDefault("callback")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "callback", valid_594128
  var valid_594129 = query.getOrDefault("access_token")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "access_token", valid_594129
  var valid_594130 = query.getOrDefault("uploadType")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "uploadType", valid_594130
  var valid_594131 = query.getOrDefault("endTime")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "endTime", valid_594131
  var valid_594132 = query.getOrDefault("location")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "location", valid_594132
  var valid_594133 = query.getOrDefault("key")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "key", valid_594133
  var valid_594134 = query.getOrDefault("minimumImportance")
  valid_594134 = validateParameter(valid_594134, JString, required = false, default = newJString(
      "JOB_MESSAGE_IMPORTANCE_UNKNOWN"))
  if valid_594134 != nil:
    section.add "minimumImportance", valid_594134
  var valid_594135 = query.getOrDefault("$.xgafv")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = newJString("1"))
  if valid_594135 != nil:
    section.add "$.xgafv", valid_594135
  var valid_594136 = query.getOrDefault("pageSize")
  valid_594136 = validateParameter(valid_594136, JInt, required = false, default = nil)
  if valid_594136 != nil:
    section.add "pageSize", valid_594136
  var valid_594137 = query.getOrDefault("prettyPrint")
  valid_594137 = validateParameter(valid_594137, JBool, required = false,
                                 default = newJBool(true))
  if valid_594137 != nil:
    section.add "prettyPrint", valid_594137
  var valid_594138 = query.getOrDefault("startTime")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "startTime", valid_594138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594139: Call_DataflowProjectsJobsMessagesList_594117;
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
  let valid = call_594139.validator(path, query, header, formData, body)
  let scheme = call_594139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594139.url(scheme.get, call_594139.host, call_594139.base,
                         call_594139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594139, url, valid)

proc call*(call_594140: Call_DataflowProjectsJobsMessagesList_594117;
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
  var path_594141 = newJObject()
  var query_594142 = newJObject()
  add(query_594142, "upload_protocol", newJString(uploadProtocol))
  add(query_594142, "fields", newJString(fields))
  add(query_594142, "pageToken", newJString(pageToken))
  add(query_594142, "quotaUser", newJString(quotaUser))
  add(query_594142, "alt", newJString(alt))
  add(path_594141, "jobId", newJString(jobId))
  add(query_594142, "oauth_token", newJString(oauthToken))
  add(query_594142, "callback", newJString(callback))
  add(query_594142, "access_token", newJString(accessToken))
  add(query_594142, "uploadType", newJString(uploadType))
  add(query_594142, "endTime", newJString(endTime))
  add(query_594142, "location", newJString(location))
  add(query_594142, "key", newJString(key))
  add(query_594142, "minimumImportance", newJString(minimumImportance))
  add(path_594141, "projectId", newJString(projectId))
  add(query_594142, "$.xgafv", newJString(Xgafv))
  add(query_594142, "pageSize", newJInt(pageSize))
  add(query_594142, "prettyPrint", newJBool(prettyPrint))
  add(query_594142, "startTime", newJString(startTime))
  result = call_594140.call(path_594141, query_594142, nil, nil, nil)

var dataflowProjectsJobsMessagesList* = Call_DataflowProjectsJobsMessagesList_594117(
    name: "dataflowProjectsJobsMessagesList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/messages",
    validator: validate_DataflowProjectsJobsMessagesList_594118, base: "/",
    url: url_DataflowProjectsJobsMessagesList_594119, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsGetMetrics_594143 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsJobsGetMetrics_594145(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsJobsGetMetrics_594144(path: JsonNode;
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
  var valid_594146 = path.getOrDefault("jobId")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "jobId", valid_594146
  var valid_594147 = path.getOrDefault("projectId")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "projectId", valid_594147
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
  var valid_594148 = query.getOrDefault("upload_protocol")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "upload_protocol", valid_594148
  var valid_594149 = query.getOrDefault("fields")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "fields", valid_594149
  var valid_594150 = query.getOrDefault("quotaUser")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "quotaUser", valid_594150
  var valid_594151 = query.getOrDefault("alt")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = newJString("json"))
  if valid_594151 != nil:
    section.add "alt", valid_594151
  var valid_594152 = query.getOrDefault("oauth_token")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "oauth_token", valid_594152
  var valid_594153 = query.getOrDefault("callback")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "callback", valid_594153
  var valid_594154 = query.getOrDefault("access_token")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "access_token", valid_594154
  var valid_594155 = query.getOrDefault("uploadType")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "uploadType", valid_594155
  var valid_594156 = query.getOrDefault("location")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "location", valid_594156
  var valid_594157 = query.getOrDefault("key")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "key", valid_594157
  var valid_594158 = query.getOrDefault("$.xgafv")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = newJString("1"))
  if valid_594158 != nil:
    section.add "$.xgafv", valid_594158
  var valid_594159 = query.getOrDefault("prettyPrint")
  valid_594159 = validateParameter(valid_594159, JBool, required = false,
                                 default = newJBool(true))
  if valid_594159 != nil:
    section.add "prettyPrint", valid_594159
  var valid_594160 = query.getOrDefault("startTime")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "startTime", valid_594160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594161: Call_DataflowProjectsJobsGetMetrics_594143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.getMetrics` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.getMetrics` is not recommended, as you can only request the
  ## status of jobs that are running in `us-central1`.
  ## 
  let valid = call_594161.validator(path, query, header, formData, body)
  let scheme = call_594161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594161.url(scheme.get, call_594161.host, call_594161.base,
                         call_594161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594161, url, valid)

proc call*(call_594162: Call_DataflowProjectsJobsGetMetrics_594143; jobId: string;
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
  var path_594163 = newJObject()
  var query_594164 = newJObject()
  add(query_594164, "upload_protocol", newJString(uploadProtocol))
  add(query_594164, "fields", newJString(fields))
  add(query_594164, "quotaUser", newJString(quotaUser))
  add(query_594164, "alt", newJString(alt))
  add(path_594163, "jobId", newJString(jobId))
  add(query_594164, "oauth_token", newJString(oauthToken))
  add(query_594164, "callback", newJString(callback))
  add(query_594164, "access_token", newJString(accessToken))
  add(query_594164, "uploadType", newJString(uploadType))
  add(query_594164, "location", newJString(location))
  add(query_594164, "key", newJString(key))
  add(path_594163, "projectId", newJString(projectId))
  add(query_594164, "$.xgafv", newJString(Xgafv))
  add(query_594164, "prettyPrint", newJBool(prettyPrint))
  add(query_594164, "startTime", newJString(startTime))
  result = call_594162.call(path_594163, query_594164, nil, nil, nil)

var dataflowProjectsJobsGetMetrics* = Call_DataflowProjectsJobsGetMetrics_594143(
    name: "dataflowProjectsJobsGetMetrics", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/metrics",
    validator: validate_DataflowProjectsJobsGetMetrics_594144, base: "/",
    url: url_DataflowProjectsJobsGetMetrics_594145, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsWorkItemsLease_594165 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsJobsWorkItemsLease_594167(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsJobsWorkItemsLease_594166(path: JsonNode;
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
  var valid_594168 = path.getOrDefault("jobId")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "jobId", valid_594168
  var valid_594169 = path.getOrDefault("projectId")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "projectId", valid_594169
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
  var valid_594170 = query.getOrDefault("upload_protocol")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "upload_protocol", valid_594170
  var valid_594171 = query.getOrDefault("fields")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "fields", valid_594171
  var valid_594172 = query.getOrDefault("quotaUser")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "quotaUser", valid_594172
  var valid_594173 = query.getOrDefault("alt")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = newJString("json"))
  if valid_594173 != nil:
    section.add "alt", valid_594173
  var valid_594174 = query.getOrDefault("oauth_token")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "oauth_token", valid_594174
  var valid_594175 = query.getOrDefault("callback")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "callback", valid_594175
  var valid_594176 = query.getOrDefault("access_token")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "access_token", valid_594176
  var valid_594177 = query.getOrDefault("uploadType")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "uploadType", valid_594177
  var valid_594178 = query.getOrDefault("key")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "key", valid_594178
  var valid_594179 = query.getOrDefault("$.xgafv")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = newJString("1"))
  if valid_594179 != nil:
    section.add "$.xgafv", valid_594179
  var valid_594180 = query.getOrDefault("prettyPrint")
  valid_594180 = validateParameter(valid_594180, JBool, required = false,
                                 default = newJBool(true))
  if valid_594180 != nil:
    section.add "prettyPrint", valid_594180
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

proc call*(call_594182: Call_DataflowProjectsJobsWorkItemsLease_594165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Leases a dataflow WorkItem to run.
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_DataflowProjectsJobsWorkItemsLease_594165;
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
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  var body_594186 = newJObject()
  add(query_594185, "upload_protocol", newJString(uploadProtocol))
  add(query_594185, "fields", newJString(fields))
  add(query_594185, "quotaUser", newJString(quotaUser))
  add(query_594185, "alt", newJString(alt))
  add(path_594184, "jobId", newJString(jobId))
  add(query_594185, "oauth_token", newJString(oauthToken))
  add(query_594185, "callback", newJString(callback))
  add(query_594185, "access_token", newJString(accessToken))
  add(query_594185, "uploadType", newJString(uploadType))
  add(query_594185, "key", newJString(key))
  add(path_594184, "projectId", newJString(projectId))
  add(query_594185, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594186 = body
  add(query_594185, "prettyPrint", newJBool(prettyPrint))
  result = call_594183.call(path_594184, query_594185, nil, nil, body_594186)

var dataflowProjectsJobsWorkItemsLease* = Call_DataflowProjectsJobsWorkItemsLease_594165(
    name: "dataflowProjectsJobsWorkItemsLease", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/workItems:lease",
    validator: validate_DataflowProjectsJobsWorkItemsLease_594166, base: "/",
    url: url_DataflowProjectsJobsWorkItemsLease_594167, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsWorkItemsReportStatus_594187 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsJobsWorkItemsReportStatus_594189(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsJobsWorkItemsReportStatus_594188(path: JsonNode;
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
  var valid_594190 = path.getOrDefault("jobId")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "jobId", valid_594190
  var valid_594191 = path.getOrDefault("projectId")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "projectId", valid_594191
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
  var valid_594192 = query.getOrDefault("upload_protocol")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "upload_protocol", valid_594192
  var valid_594193 = query.getOrDefault("fields")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "fields", valid_594193
  var valid_594194 = query.getOrDefault("quotaUser")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "quotaUser", valid_594194
  var valid_594195 = query.getOrDefault("alt")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = newJString("json"))
  if valid_594195 != nil:
    section.add "alt", valid_594195
  var valid_594196 = query.getOrDefault("oauth_token")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "oauth_token", valid_594196
  var valid_594197 = query.getOrDefault("callback")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "callback", valid_594197
  var valid_594198 = query.getOrDefault("access_token")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "access_token", valid_594198
  var valid_594199 = query.getOrDefault("uploadType")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "uploadType", valid_594199
  var valid_594200 = query.getOrDefault("key")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "key", valid_594200
  var valid_594201 = query.getOrDefault("$.xgafv")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = newJString("1"))
  if valid_594201 != nil:
    section.add "$.xgafv", valid_594201
  var valid_594202 = query.getOrDefault("prettyPrint")
  valid_594202 = validateParameter(valid_594202, JBool, required = false,
                                 default = newJBool(true))
  if valid_594202 != nil:
    section.add "prettyPrint", valid_594202
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

proc call*(call_594204: Call_DataflowProjectsJobsWorkItemsReportStatus_594187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports the status of dataflow WorkItems leased by a worker.
  ## 
  let valid = call_594204.validator(path, query, header, formData, body)
  let scheme = call_594204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594204.url(scheme.get, call_594204.host, call_594204.base,
                         call_594204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594204, url, valid)

proc call*(call_594205: Call_DataflowProjectsJobsWorkItemsReportStatus_594187;
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
  var path_594206 = newJObject()
  var query_594207 = newJObject()
  var body_594208 = newJObject()
  add(query_594207, "upload_protocol", newJString(uploadProtocol))
  add(query_594207, "fields", newJString(fields))
  add(query_594207, "quotaUser", newJString(quotaUser))
  add(query_594207, "alt", newJString(alt))
  add(path_594206, "jobId", newJString(jobId))
  add(query_594207, "oauth_token", newJString(oauthToken))
  add(query_594207, "callback", newJString(callback))
  add(query_594207, "access_token", newJString(accessToken))
  add(query_594207, "uploadType", newJString(uploadType))
  add(query_594207, "key", newJString(key))
  add(path_594206, "projectId", newJString(projectId))
  add(query_594207, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594208 = body
  add(query_594207, "prettyPrint", newJBool(prettyPrint))
  result = call_594205.call(path_594206, query_594207, nil, nil, body_594208)

var dataflowProjectsJobsWorkItemsReportStatus* = Call_DataflowProjectsJobsWorkItemsReportStatus_594187(
    name: "dataflowProjectsJobsWorkItemsReportStatus", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/workItems:reportStatus",
    validator: validate_DataflowProjectsJobsWorkItemsReportStatus_594188,
    base: "/", url: url_DataflowProjectsJobsWorkItemsReportStatus_594189,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsAggregated_594209 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsJobsAggregated_594211(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsJobsAggregated_594210(path: JsonNode;
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
  var valid_594212 = path.getOrDefault("projectId")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "projectId", valid_594212
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
  var valid_594213 = query.getOrDefault("upload_protocol")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "upload_protocol", valid_594213
  var valid_594214 = query.getOrDefault("fields")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "fields", valid_594214
  var valid_594215 = query.getOrDefault("pageToken")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "pageToken", valid_594215
  var valid_594216 = query.getOrDefault("quotaUser")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "quotaUser", valid_594216
  var valid_594217 = query.getOrDefault("view")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_594217 != nil:
    section.add "view", valid_594217
  var valid_594218 = query.getOrDefault("alt")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = newJString("json"))
  if valid_594218 != nil:
    section.add "alt", valid_594218
  var valid_594219 = query.getOrDefault("oauth_token")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "oauth_token", valid_594219
  var valid_594220 = query.getOrDefault("callback")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "callback", valid_594220
  var valid_594221 = query.getOrDefault("access_token")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "access_token", valid_594221
  var valid_594222 = query.getOrDefault("uploadType")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "uploadType", valid_594222
  var valid_594223 = query.getOrDefault("location")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "location", valid_594223
  var valid_594224 = query.getOrDefault("key")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = nil)
  if valid_594224 != nil:
    section.add "key", valid_594224
  var valid_594225 = query.getOrDefault("$.xgafv")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = newJString("1"))
  if valid_594225 != nil:
    section.add "$.xgafv", valid_594225
  var valid_594226 = query.getOrDefault("pageSize")
  valid_594226 = validateParameter(valid_594226, JInt, required = false, default = nil)
  if valid_594226 != nil:
    section.add "pageSize", valid_594226
  var valid_594227 = query.getOrDefault("prettyPrint")
  valid_594227 = validateParameter(valid_594227, JBool, required = false,
                                 default = newJBool(true))
  if valid_594227 != nil:
    section.add "prettyPrint", valid_594227
  var valid_594228 = query.getOrDefault("filter")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_594228 != nil:
    section.add "filter", valid_594228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594229: Call_DataflowProjectsJobsAggregated_594209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the jobs of a project across all regions.
  ## 
  let valid = call_594229.validator(path, query, header, formData, body)
  let scheme = call_594229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594229.url(scheme.get, call_594229.host, call_594229.base,
                         call_594229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594229, url, valid)

proc call*(call_594230: Call_DataflowProjectsJobsAggregated_594209;
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
  var path_594231 = newJObject()
  var query_594232 = newJObject()
  add(query_594232, "upload_protocol", newJString(uploadProtocol))
  add(query_594232, "fields", newJString(fields))
  add(query_594232, "pageToken", newJString(pageToken))
  add(query_594232, "quotaUser", newJString(quotaUser))
  add(query_594232, "view", newJString(view))
  add(query_594232, "alt", newJString(alt))
  add(query_594232, "oauth_token", newJString(oauthToken))
  add(query_594232, "callback", newJString(callback))
  add(query_594232, "access_token", newJString(accessToken))
  add(query_594232, "uploadType", newJString(uploadType))
  add(query_594232, "location", newJString(location))
  add(query_594232, "key", newJString(key))
  add(path_594231, "projectId", newJString(projectId))
  add(query_594232, "$.xgafv", newJString(Xgafv))
  add(query_594232, "pageSize", newJInt(pageSize))
  add(query_594232, "prettyPrint", newJBool(prettyPrint))
  add(query_594232, "filter", newJString(filter))
  result = call_594230.call(path_594231, query_594232, nil, nil, nil)

var dataflowProjectsJobsAggregated* = Call_DataflowProjectsJobsAggregated_594209(
    name: "dataflowProjectsJobsAggregated", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs:aggregated",
    validator: validate_DataflowProjectsJobsAggregated_594210, base: "/",
    url: url_DataflowProjectsJobsAggregated_594211, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsWorkerMessages_594233 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsWorkerMessages_594235(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsWorkerMessages_594234(path: JsonNode;
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
  var valid_594236 = path.getOrDefault("projectId")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "projectId", valid_594236
  var valid_594237 = path.getOrDefault("location")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "location", valid_594237
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
  var valid_594238 = query.getOrDefault("upload_protocol")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = nil)
  if valid_594238 != nil:
    section.add "upload_protocol", valid_594238
  var valid_594239 = query.getOrDefault("fields")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "fields", valid_594239
  var valid_594240 = query.getOrDefault("quotaUser")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "quotaUser", valid_594240
  var valid_594241 = query.getOrDefault("alt")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = newJString("json"))
  if valid_594241 != nil:
    section.add "alt", valid_594241
  var valid_594242 = query.getOrDefault("oauth_token")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "oauth_token", valid_594242
  var valid_594243 = query.getOrDefault("callback")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "callback", valid_594243
  var valid_594244 = query.getOrDefault("access_token")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = nil)
  if valid_594244 != nil:
    section.add "access_token", valid_594244
  var valid_594245 = query.getOrDefault("uploadType")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "uploadType", valid_594245
  var valid_594246 = query.getOrDefault("key")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "key", valid_594246
  var valid_594247 = query.getOrDefault("$.xgafv")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = newJString("1"))
  if valid_594247 != nil:
    section.add "$.xgafv", valid_594247
  var valid_594248 = query.getOrDefault("prettyPrint")
  valid_594248 = validateParameter(valid_594248, JBool, required = false,
                                 default = newJBool(true))
  if valid_594248 != nil:
    section.add "prettyPrint", valid_594248
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

proc call*(call_594250: Call_DataflowProjectsLocationsWorkerMessages_594233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send a worker_message to the service.
  ## 
  let valid = call_594250.validator(path, query, header, formData, body)
  let scheme = call_594250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594250.url(scheme.get, call_594250.host, call_594250.base,
                         call_594250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594250, url, valid)

proc call*(call_594251: Call_DataflowProjectsLocationsWorkerMessages_594233;
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
  var path_594252 = newJObject()
  var query_594253 = newJObject()
  var body_594254 = newJObject()
  add(query_594253, "upload_protocol", newJString(uploadProtocol))
  add(query_594253, "fields", newJString(fields))
  add(query_594253, "quotaUser", newJString(quotaUser))
  add(query_594253, "alt", newJString(alt))
  add(query_594253, "oauth_token", newJString(oauthToken))
  add(query_594253, "callback", newJString(callback))
  add(query_594253, "access_token", newJString(accessToken))
  add(query_594253, "uploadType", newJString(uploadType))
  add(query_594253, "key", newJString(key))
  add(path_594252, "projectId", newJString(projectId))
  add(query_594253, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594254 = body
  add(query_594253, "prettyPrint", newJBool(prettyPrint))
  add(path_594252, "location", newJString(location))
  result = call_594251.call(path_594252, query_594253, nil, nil, body_594254)

var dataflowProjectsLocationsWorkerMessages* = Call_DataflowProjectsLocationsWorkerMessages_594233(
    name: "dataflowProjectsLocationsWorkerMessages", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/WorkerMessages",
    validator: validate_DataflowProjectsLocationsWorkerMessages_594234, base: "/",
    url: url_DataflowProjectsLocationsWorkerMessages_594235,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsCreate_594279 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsJobsCreate_594281(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsJobsCreate_594280(path: JsonNode;
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
  var valid_594282 = path.getOrDefault("projectId")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "projectId", valid_594282
  var valid_594283 = path.getOrDefault("location")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "location", valid_594283
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
  var valid_594284 = query.getOrDefault("upload_protocol")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "upload_protocol", valid_594284
  var valid_594285 = query.getOrDefault("fields")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "fields", valid_594285
  var valid_594286 = query.getOrDefault("view")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_594286 != nil:
    section.add "view", valid_594286
  var valid_594287 = query.getOrDefault("quotaUser")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "quotaUser", valid_594287
  var valid_594288 = query.getOrDefault("alt")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = newJString("json"))
  if valid_594288 != nil:
    section.add "alt", valid_594288
  var valid_594289 = query.getOrDefault("oauth_token")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = nil)
  if valid_594289 != nil:
    section.add "oauth_token", valid_594289
  var valid_594290 = query.getOrDefault("callback")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = nil)
  if valid_594290 != nil:
    section.add "callback", valid_594290
  var valid_594291 = query.getOrDefault("access_token")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "access_token", valid_594291
  var valid_594292 = query.getOrDefault("uploadType")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = nil)
  if valid_594292 != nil:
    section.add "uploadType", valid_594292
  var valid_594293 = query.getOrDefault("replaceJobId")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "replaceJobId", valid_594293
  var valid_594294 = query.getOrDefault("key")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "key", valid_594294
  var valid_594295 = query.getOrDefault("$.xgafv")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = newJString("1"))
  if valid_594295 != nil:
    section.add "$.xgafv", valid_594295
  var valid_594296 = query.getOrDefault("prettyPrint")
  valid_594296 = validateParameter(valid_594296, JBool, required = false,
                                 default = newJBool(true))
  if valid_594296 != nil:
    section.add "prettyPrint", valid_594296
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

proc call*(call_594298: Call_DataflowProjectsLocationsJobsCreate_594279;
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
  let valid = call_594298.validator(path, query, header, formData, body)
  let scheme = call_594298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594298.url(scheme.get, call_594298.host, call_594298.base,
                         call_594298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594298, url, valid)

proc call*(call_594299: Call_DataflowProjectsLocationsJobsCreate_594279;
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
  var path_594300 = newJObject()
  var query_594301 = newJObject()
  var body_594302 = newJObject()
  add(query_594301, "upload_protocol", newJString(uploadProtocol))
  add(query_594301, "fields", newJString(fields))
  add(query_594301, "view", newJString(view))
  add(query_594301, "quotaUser", newJString(quotaUser))
  add(query_594301, "alt", newJString(alt))
  add(query_594301, "oauth_token", newJString(oauthToken))
  add(query_594301, "callback", newJString(callback))
  add(query_594301, "access_token", newJString(accessToken))
  add(query_594301, "uploadType", newJString(uploadType))
  add(query_594301, "replaceJobId", newJString(replaceJobId))
  add(query_594301, "key", newJString(key))
  add(path_594300, "projectId", newJString(projectId))
  add(query_594301, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594302 = body
  add(query_594301, "prettyPrint", newJBool(prettyPrint))
  add(path_594300, "location", newJString(location))
  result = call_594299.call(path_594300, query_594301, nil, nil, body_594302)

var dataflowProjectsLocationsJobsCreate* = Call_DataflowProjectsLocationsJobsCreate_594279(
    name: "dataflowProjectsLocationsJobsCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs",
    validator: validate_DataflowProjectsLocationsJobsCreate_594280, base: "/",
    url: url_DataflowProjectsLocationsJobsCreate_594281, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsList_594255 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsJobsList_594257(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsJobsList_594256(path: JsonNode;
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
  var valid_594258 = path.getOrDefault("projectId")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "projectId", valid_594258
  var valid_594259 = path.getOrDefault("location")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "location", valid_594259
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
  var valid_594260 = query.getOrDefault("upload_protocol")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "upload_protocol", valid_594260
  var valid_594261 = query.getOrDefault("fields")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "fields", valid_594261
  var valid_594262 = query.getOrDefault("pageToken")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "pageToken", valid_594262
  var valid_594263 = query.getOrDefault("quotaUser")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "quotaUser", valid_594263
  var valid_594264 = query.getOrDefault("view")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_594264 != nil:
    section.add "view", valid_594264
  var valid_594265 = query.getOrDefault("alt")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = newJString("json"))
  if valid_594265 != nil:
    section.add "alt", valid_594265
  var valid_594266 = query.getOrDefault("oauth_token")
  valid_594266 = validateParameter(valid_594266, JString, required = false,
                                 default = nil)
  if valid_594266 != nil:
    section.add "oauth_token", valid_594266
  var valid_594267 = query.getOrDefault("callback")
  valid_594267 = validateParameter(valid_594267, JString, required = false,
                                 default = nil)
  if valid_594267 != nil:
    section.add "callback", valid_594267
  var valid_594268 = query.getOrDefault("access_token")
  valid_594268 = validateParameter(valid_594268, JString, required = false,
                                 default = nil)
  if valid_594268 != nil:
    section.add "access_token", valid_594268
  var valid_594269 = query.getOrDefault("uploadType")
  valid_594269 = validateParameter(valid_594269, JString, required = false,
                                 default = nil)
  if valid_594269 != nil:
    section.add "uploadType", valid_594269
  var valid_594270 = query.getOrDefault("key")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = nil)
  if valid_594270 != nil:
    section.add "key", valid_594270
  var valid_594271 = query.getOrDefault("$.xgafv")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = newJString("1"))
  if valid_594271 != nil:
    section.add "$.xgafv", valid_594271
  var valid_594272 = query.getOrDefault("pageSize")
  valid_594272 = validateParameter(valid_594272, JInt, required = false, default = nil)
  if valid_594272 != nil:
    section.add "pageSize", valid_594272
  var valid_594273 = query.getOrDefault("prettyPrint")
  valid_594273 = validateParameter(valid_594273, JBool, required = false,
                                 default = newJBool(true))
  if valid_594273 != nil:
    section.add "prettyPrint", valid_594273
  var valid_594274 = query.getOrDefault("filter")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_594274 != nil:
    section.add "filter", valid_594274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594275: Call_DataflowProjectsLocationsJobsList_594255;
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
  let valid = call_594275.validator(path, query, header, formData, body)
  let scheme = call_594275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594275.url(scheme.get, call_594275.host, call_594275.base,
                         call_594275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594275, url, valid)

proc call*(call_594276: Call_DataflowProjectsLocationsJobsList_594255;
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
  var path_594277 = newJObject()
  var query_594278 = newJObject()
  add(query_594278, "upload_protocol", newJString(uploadProtocol))
  add(query_594278, "fields", newJString(fields))
  add(query_594278, "pageToken", newJString(pageToken))
  add(query_594278, "quotaUser", newJString(quotaUser))
  add(query_594278, "view", newJString(view))
  add(query_594278, "alt", newJString(alt))
  add(query_594278, "oauth_token", newJString(oauthToken))
  add(query_594278, "callback", newJString(callback))
  add(query_594278, "access_token", newJString(accessToken))
  add(query_594278, "uploadType", newJString(uploadType))
  add(query_594278, "key", newJString(key))
  add(path_594277, "projectId", newJString(projectId))
  add(query_594278, "$.xgafv", newJString(Xgafv))
  add(query_594278, "pageSize", newJInt(pageSize))
  add(query_594278, "prettyPrint", newJBool(prettyPrint))
  add(path_594277, "location", newJString(location))
  add(query_594278, "filter", newJString(filter))
  result = call_594276.call(path_594277, query_594278, nil, nil, nil)

var dataflowProjectsLocationsJobsList* = Call_DataflowProjectsLocationsJobsList_594255(
    name: "dataflowProjectsLocationsJobsList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs",
    validator: validate_DataflowProjectsLocationsJobsList_594256, base: "/",
    url: url_DataflowProjectsLocationsJobsList_594257, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsUpdate_594325 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsJobsUpdate_594327(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsJobsUpdate_594326(path: JsonNode;
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
  var valid_594328 = path.getOrDefault("jobId")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "jobId", valid_594328
  var valid_594329 = path.getOrDefault("projectId")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "projectId", valid_594329
  var valid_594330 = path.getOrDefault("location")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "location", valid_594330
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
  var valid_594331 = query.getOrDefault("upload_protocol")
  valid_594331 = validateParameter(valid_594331, JString, required = false,
                                 default = nil)
  if valid_594331 != nil:
    section.add "upload_protocol", valid_594331
  var valid_594332 = query.getOrDefault("fields")
  valid_594332 = validateParameter(valid_594332, JString, required = false,
                                 default = nil)
  if valid_594332 != nil:
    section.add "fields", valid_594332
  var valid_594333 = query.getOrDefault("quotaUser")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = nil)
  if valid_594333 != nil:
    section.add "quotaUser", valid_594333
  var valid_594334 = query.getOrDefault("alt")
  valid_594334 = validateParameter(valid_594334, JString, required = false,
                                 default = newJString("json"))
  if valid_594334 != nil:
    section.add "alt", valid_594334
  var valid_594335 = query.getOrDefault("oauth_token")
  valid_594335 = validateParameter(valid_594335, JString, required = false,
                                 default = nil)
  if valid_594335 != nil:
    section.add "oauth_token", valid_594335
  var valid_594336 = query.getOrDefault("callback")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "callback", valid_594336
  var valid_594337 = query.getOrDefault("access_token")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "access_token", valid_594337
  var valid_594338 = query.getOrDefault("uploadType")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "uploadType", valid_594338
  var valid_594339 = query.getOrDefault("key")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "key", valid_594339
  var valid_594340 = query.getOrDefault("$.xgafv")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = newJString("1"))
  if valid_594340 != nil:
    section.add "$.xgafv", valid_594340
  var valid_594341 = query.getOrDefault("prettyPrint")
  valid_594341 = validateParameter(valid_594341, JBool, required = false,
                                 default = newJBool(true))
  if valid_594341 != nil:
    section.add "prettyPrint", valid_594341
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

proc call*(call_594343: Call_DataflowProjectsLocationsJobsUpdate_594325;
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
  let valid = call_594343.validator(path, query, header, formData, body)
  let scheme = call_594343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594343.url(scheme.get, call_594343.host, call_594343.base,
                         call_594343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594343, url, valid)

proc call*(call_594344: Call_DataflowProjectsLocationsJobsUpdate_594325;
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
  var path_594345 = newJObject()
  var query_594346 = newJObject()
  var body_594347 = newJObject()
  add(query_594346, "upload_protocol", newJString(uploadProtocol))
  add(query_594346, "fields", newJString(fields))
  add(query_594346, "quotaUser", newJString(quotaUser))
  add(query_594346, "alt", newJString(alt))
  add(path_594345, "jobId", newJString(jobId))
  add(query_594346, "oauth_token", newJString(oauthToken))
  add(query_594346, "callback", newJString(callback))
  add(query_594346, "access_token", newJString(accessToken))
  add(query_594346, "uploadType", newJString(uploadType))
  add(query_594346, "key", newJString(key))
  add(path_594345, "projectId", newJString(projectId))
  add(query_594346, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594347 = body
  add(query_594346, "prettyPrint", newJBool(prettyPrint))
  add(path_594345, "location", newJString(location))
  result = call_594344.call(path_594345, query_594346, nil, nil, body_594347)

var dataflowProjectsLocationsJobsUpdate* = Call_DataflowProjectsLocationsJobsUpdate_594325(
    name: "dataflowProjectsLocationsJobsUpdate", meth: HttpMethod.HttpPut,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}",
    validator: validate_DataflowProjectsLocationsJobsUpdate_594326, base: "/",
    url: url_DataflowProjectsLocationsJobsUpdate_594327, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsGet_594303 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsJobsGet_594305(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsJobsGet_594304(path: JsonNode;
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
  var valid_594306 = path.getOrDefault("jobId")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "jobId", valid_594306
  var valid_594307 = path.getOrDefault("projectId")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = nil)
  if valid_594307 != nil:
    section.add "projectId", valid_594307
  var valid_594308 = path.getOrDefault("location")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "location", valid_594308
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
  var valid_594309 = query.getOrDefault("upload_protocol")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = nil)
  if valid_594309 != nil:
    section.add "upload_protocol", valid_594309
  var valid_594310 = query.getOrDefault("fields")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = nil)
  if valid_594310 != nil:
    section.add "fields", valid_594310
  var valid_594311 = query.getOrDefault("view")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_594311 != nil:
    section.add "view", valid_594311
  var valid_594312 = query.getOrDefault("quotaUser")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = nil)
  if valid_594312 != nil:
    section.add "quotaUser", valid_594312
  var valid_594313 = query.getOrDefault("alt")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = newJString("json"))
  if valid_594313 != nil:
    section.add "alt", valid_594313
  var valid_594314 = query.getOrDefault("oauth_token")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = nil)
  if valid_594314 != nil:
    section.add "oauth_token", valid_594314
  var valid_594315 = query.getOrDefault("callback")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "callback", valid_594315
  var valid_594316 = query.getOrDefault("access_token")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "access_token", valid_594316
  var valid_594317 = query.getOrDefault("uploadType")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "uploadType", valid_594317
  var valid_594318 = query.getOrDefault("key")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "key", valid_594318
  var valid_594319 = query.getOrDefault("$.xgafv")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = newJString("1"))
  if valid_594319 != nil:
    section.add "$.xgafv", valid_594319
  var valid_594320 = query.getOrDefault("prettyPrint")
  valid_594320 = validateParameter(valid_594320, JBool, required = false,
                                 default = newJBool(true))
  if valid_594320 != nil:
    section.add "prettyPrint", valid_594320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594321: Call_DataflowProjectsLocationsJobsGet_594303;
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
  let valid = call_594321.validator(path, query, header, formData, body)
  let scheme = call_594321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594321.url(scheme.get, call_594321.host, call_594321.base,
                         call_594321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594321, url, valid)

proc call*(call_594322: Call_DataflowProjectsLocationsJobsGet_594303;
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
  var path_594323 = newJObject()
  var query_594324 = newJObject()
  add(query_594324, "upload_protocol", newJString(uploadProtocol))
  add(query_594324, "fields", newJString(fields))
  add(query_594324, "view", newJString(view))
  add(query_594324, "quotaUser", newJString(quotaUser))
  add(query_594324, "alt", newJString(alt))
  add(path_594323, "jobId", newJString(jobId))
  add(query_594324, "oauth_token", newJString(oauthToken))
  add(query_594324, "callback", newJString(callback))
  add(query_594324, "access_token", newJString(accessToken))
  add(query_594324, "uploadType", newJString(uploadType))
  add(query_594324, "key", newJString(key))
  add(path_594323, "projectId", newJString(projectId))
  add(query_594324, "$.xgafv", newJString(Xgafv))
  add(query_594324, "prettyPrint", newJBool(prettyPrint))
  add(path_594323, "location", newJString(location))
  result = call_594322.call(path_594323, query_594324, nil, nil, nil)

var dataflowProjectsLocationsJobsGet* = Call_DataflowProjectsLocationsJobsGet_594303(
    name: "dataflowProjectsLocationsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}",
    validator: validate_DataflowProjectsLocationsJobsGet_594304, base: "/",
    url: url_DataflowProjectsLocationsJobsGet_594305, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsDebugGetConfig_594348 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsJobsDebugGetConfig_594350(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsJobsDebugGetConfig_594349(path: JsonNode;
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
  var valid_594351 = path.getOrDefault("jobId")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "jobId", valid_594351
  var valid_594352 = path.getOrDefault("projectId")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "projectId", valid_594352
  var valid_594353 = path.getOrDefault("location")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "location", valid_594353
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
  var valid_594354 = query.getOrDefault("upload_protocol")
  valid_594354 = validateParameter(valid_594354, JString, required = false,
                                 default = nil)
  if valid_594354 != nil:
    section.add "upload_protocol", valid_594354
  var valid_594355 = query.getOrDefault("fields")
  valid_594355 = validateParameter(valid_594355, JString, required = false,
                                 default = nil)
  if valid_594355 != nil:
    section.add "fields", valid_594355
  var valid_594356 = query.getOrDefault("quotaUser")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = nil)
  if valid_594356 != nil:
    section.add "quotaUser", valid_594356
  var valid_594357 = query.getOrDefault("alt")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = newJString("json"))
  if valid_594357 != nil:
    section.add "alt", valid_594357
  var valid_594358 = query.getOrDefault("oauth_token")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "oauth_token", valid_594358
  var valid_594359 = query.getOrDefault("callback")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = nil)
  if valid_594359 != nil:
    section.add "callback", valid_594359
  var valid_594360 = query.getOrDefault("access_token")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "access_token", valid_594360
  var valid_594361 = query.getOrDefault("uploadType")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "uploadType", valid_594361
  var valid_594362 = query.getOrDefault("key")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = nil)
  if valid_594362 != nil:
    section.add "key", valid_594362
  var valid_594363 = query.getOrDefault("$.xgafv")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = newJString("1"))
  if valid_594363 != nil:
    section.add "$.xgafv", valid_594363
  var valid_594364 = query.getOrDefault("prettyPrint")
  valid_594364 = validateParameter(valid_594364, JBool, required = false,
                                 default = newJBool(true))
  if valid_594364 != nil:
    section.add "prettyPrint", valid_594364
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

proc call*(call_594366: Call_DataflowProjectsLocationsJobsDebugGetConfig_594348;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get encoded debug configuration for component. Not cacheable.
  ## 
  let valid = call_594366.validator(path, query, header, formData, body)
  let scheme = call_594366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594366.url(scheme.get, call_594366.host, call_594366.base,
                         call_594366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594366, url, valid)

proc call*(call_594367: Call_DataflowProjectsLocationsJobsDebugGetConfig_594348;
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
  var path_594368 = newJObject()
  var query_594369 = newJObject()
  var body_594370 = newJObject()
  add(query_594369, "upload_protocol", newJString(uploadProtocol))
  add(query_594369, "fields", newJString(fields))
  add(query_594369, "quotaUser", newJString(quotaUser))
  add(query_594369, "alt", newJString(alt))
  add(path_594368, "jobId", newJString(jobId))
  add(query_594369, "oauth_token", newJString(oauthToken))
  add(query_594369, "callback", newJString(callback))
  add(query_594369, "access_token", newJString(accessToken))
  add(query_594369, "uploadType", newJString(uploadType))
  add(query_594369, "key", newJString(key))
  add(path_594368, "projectId", newJString(projectId))
  add(query_594369, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594370 = body
  add(query_594369, "prettyPrint", newJBool(prettyPrint))
  add(path_594368, "location", newJString(location))
  result = call_594367.call(path_594368, query_594369, nil, nil, body_594370)

var dataflowProjectsLocationsJobsDebugGetConfig* = Call_DataflowProjectsLocationsJobsDebugGetConfig_594348(
    name: "dataflowProjectsLocationsJobsDebugGetConfig",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/debug/getConfig",
    validator: validate_DataflowProjectsLocationsJobsDebugGetConfig_594349,
    base: "/", url: url_DataflowProjectsLocationsJobsDebugGetConfig_594350,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsDebugSendCapture_594371 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsJobsDebugSendCapture_594373(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsJobsDebugSendCapture_594372(
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
  var valid_594374 = path.getOrDefault("jobId")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "jobId", valid_594374
  var valid_594375 = path.getOrDefault("projectId")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "projectId", valid_594375
  var valid_594376 = path.getOrDefault("location")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "location", valid_594376
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
  var valid_594377 = query.getOrDefault("upload_protocol")
  valid_594377 = validateParameter(valid_594377, JString, required = false,
                                 default = nil)
  if valid_594377 != nil:
    section.add "upload_protocol", valid_594377
  var valid_594378 = query.getOrDefault("fields")
  valid_594378 = validateParameter(valid_594378, JString, required = false,
                                 default = nil)
  if valid_594378 != nil:
    section.add "fields", valid_594378
  var valid_594379 = query.getOrDefault("quotaUser")
  valid_594379 = validateParameter(valid_594379, JString, required = false,
                                 default = nil)
  if valid_594379 != nil:
    section.add "quotaUser", valid_594379
  var valid_594380 = query.getOrDefault("alt")
  valid_594380 = validateParameter(valid_594380, JString, required = false,
                                 default = newJString("json"))
  if valid_594380 != nil:
    section.add "alt", valid_594380
  var valid_594381 = query.getOrDefault("oauth_token")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "oauth_token", valid_594381
  var valid_594382 = query.getOrDefault("callback")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "callback", valid_594382
  var valid_594383 = query.getOrDefault("access_token")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = nil)
  if valid_594383 != nil:
    section.add "access_token", valid_594383
  var valid_594384 = query.getOrDefault("uploadType")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = nil)
  if valid_594384 != nil:
    section.add "uploadType", valid_594384
  var valid_594385 = query.getOrDefault("key")
  valid_594385 = validateParameter(valid_594385, JString, required = false,
                                 default = nil)
  if valid_594385 != nil:
    section.add "key", valid_594385
  var valid_594386 = query.getOrDefault("$.xgafv")
  valid_594386 = validateParameter(valid_594386, JString, required = false,
                                 default = newJString("1"))
  if valid_594386 != nil:
    section.add "$.xgafv", valid_594386
  var valid_594387 = query.getOrDefault("prettyPrint")
  valid_594387 = validateParameter(valid_594387, JBool, required = false,
                                 default = newJBool(true))
  if valid_594387 != nil:
    section.add "prettyPrint", valid_594387
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

proc call*(call_594389: Call_DataflowProjectsLocationsJobsDebugSendCapture_594371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send encoded debug capture data for component.
  ## 
  let valid = call_594389.validator(path, query, header, formData, body)
  let scheme = call_594389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594389.url(scheme.get, call_594389.host, call_594389.base,
                         call_594389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594389, url, valid)

proc call*(call_594390: Call_DataflowProjectsLocationsJobsDebugSendCapture_594371;
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
  var path_594391 = newJObject()
  var query_594392 = newJObject()
  var body_594393 = newJObject()
  add(query_594392, "upload_protocol", newJString(uploadProtocol))
  add(query_594392, "fields", newJString(fields))
  add(query_594392, "quotaUser", newJString(quotaUser))
  add(query_594392, "alt", newJString(alt))
  add(path_594391, "jobId", newJString(jobId))
  add(query_594392, "oauth_token", newJString(oauthToken))
  add(query_594392, "callback", newJString(callback))
  add(query_594392, "access_token", newJString(accessToken))
  add(query_594392, "uploadType", newJString(uploadType))
  add(query_594392, "key", newJString(key))
  add(path_594391, "projectId", newJString(projectId))
  add(query_594392, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594393 = body
  add(query_594392, "prettyPrint", newJBool(prettyPrint))
  add(path_594391, "location", newJString(location))
  result = call_594390.call(path_594391, query_594392, nil, nil, body_594393)

var dataflowProjectsLocationsJobsDebugSendCapture* = Call_DataflowProjectsLocationsJobsDebugSendCapture_594371(
    name: "dataflowProjectsLocationsJobsDebugSendCapture",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/debug/sendCapture",
    validator: validate_DataflowProjectsLocationsJobsDebugSendCapture_594372,
    base: "/", url: url_DataflowProjectsLocationsJobsDebugSendCapture_594373,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsMessagesList_594394 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsJobsMessagesList_594396(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsJobsMessagesList_594395(path: JsonNode;
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
  var valid_594397 = path.getOrDefault("jobId")
  valid_594397 = validateParameter(valid_594397, JString, required = true,
                                 default = nil)
  if valid_594397 != nil:
    section.add "jobId", valid_594397
  var valid_594398 = path.getOrDefault("projectId")
  valid_594398 = validateParameter(valid_594398, JString, required = true,
                                 default = nil)
  if valid_594398 != nil:
    section.add "projectId", valid_594398
  var valid_594399 = path.getOrDefault("location")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "location", valid_594399
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
  var valid_594400 = query.getOrDefault("upload_protocol")
  valid_594400 = validateParameter(valid_594400, JString, required = false,
                                 default = nil)
  if valid_594400 != nil:
    section.add "upload_protocol", valid_594400
  var valid_594401 = query.getOrDefault("fields")
  valid_594401 = validateParameter(valid_594401, JString, required = false,
                                 default = nil)
  if valid_594401 != nil:
    section.add "fields", valid_594401
  var valid_594402 = query.getOrDefault("pageToken")
  valid_594402 = validateParameter(valid_594402, JString, required = false,
                                 default = nil)
  if valid_594402 != nil:
    section.add "pageToken", valid_594402
  var valid_594403 = query.getOrDefault("quotaUser")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = nil)
  if valid_594403 != nil:
    section.add "quotaUser", valid_594403
  var valid_594404 = query.getOrDefault("alt")
  valid_594404 = validateParameter(valid_594404, JString, required = false,
                                 default = newJString("json"))
  if valid_594404 != nil:
    section.add "alt", valid_594404
  var valid_594405 = query.getOrDefault("oauth_token")
  valid_594405 = validateParameter(valid_594405, JString, required = false,
                                 default = nil)
  if valid_594405 != nil:
    section.add "oauth_token", valid_594405
  var valid_594406 = query.getOrDefault("callback")
  valid_594406 = validateParameter(valid_594406, JString, required = false,
                                 default = nil)
  if valid_594406 != nil:
    section.add "callback", valid_594406
  var valid_594407 = query.getOrDefault("access_token")
  valid_594407 = validateParameter(valid_594407, JString, required = false,
                                 default = nil)
  if valid_594407 != nil:
    section.add "access_token", valid_594407
  var valid_594408 = query.getOrDefault("uploadType")
  valid_594408 = validateParameter(valid_594408, JString, required = false,
                                 default = nil)
  if valid_594408 != nil:
    section.add "uploadType", valid_594408
  var valid_594409 = query.getOrDefault("endTime")
  valid_594409 = validateParameter(valid_594409, JString, required = false,
                                 default = nil)
  if valid_594409 != nil:
    section.add "endTime", valid_594409
  var valid_594410 = query.getOrDefault("key")
  valid_594410 = validateParameter(valid_594410, JString, required = false,
                                 default = nil)
  if valid_594410 != nil:
    section.add "key", valid_594410
  var valid_594411 = query.getOrDefault("minimumImportance")
  valid_594411 = validateParameter(valid_594411, JString, required = false, default = newJString(
      "JOB_MESSAGE_IMPORTANCE_UNKNOWN"))
  if valid_594411 != nil:
    section.add "minimumImportance", valid_594411
  var valid_594412 = query.getOrDefault("$.xgafv")
  valid_594412 = validateParameter(valid_594412, JString, required = false,
                                 default = newJString("1"))
  if valid_594412 != nil:
    section.add "$.xgafv", valid_594412
  var valid_594413 = query.getOrDefault("pageSize")
  valid_594413 = validateParameter(valid_594413, JInt, required = false, default = nil)
  if valid_594413 != nil:
    section.add "pageSize", valid_594413
  var valid_594414 = query.getOrDefault("prettyPrint")
  valid_594414 = validateParameter(valid_594414, JBool, required = false,
                                 default = newJBool(true))
  if valid_594414 != nil:
    section.add "prettyPrint", valid_594414
  var valid_594415 = query.getOrDefault("startTime")
  valid_594415 = validateParameter(valid_594415, JString, required = false,
                                 default = nil)
  if valid_594415 != nil:
    section.add "startTime", valid_594415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594416: Call_DataflowProjectsLocationsJobsMessagesList_594394;
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
  let valid = call_594416.validator(path, query, header, formData, body)
  let scheme = call_594416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594416.url(scheme.get, call_594416.host, call_594416.base,
                         call_594416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594416, url, valid)

proc call*(call_594417: Call_DataflowProjectsLocationsJobsMessagesList_594394;
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
  var path_594418 = newJObject()
  var query_594419 = newJObject()
  add(query_594419, "upload_protocol", newJString(uploadProtocol))
  add(query_594419, "fields", newJString(fields))
  add(query_594419, "pageToken", newJString(pageToken))
  add(query_594419, "quotaUser", newJString(quotaUser))
  add(query_594419, "alt", newJString(alt))
  add(path_594418, "jobId", newJString(jobId))
  add(query_594419, "oauth_token", newJString(oauthToken))
  add(query_594419, "callback", newJString(callback))
  add(query_594419, "access_token", newJString(accessToken))
  add(query_594419, "uploadType", newJString(uploadType))
  add(query_594419, "endTime", newJString(endTime))
  add(query_594419, "key", newJString(key))
  add(query_594419, "minimumImportance", newJString(minimumImportance))
  add(path_594418, "projectId", newJString(projectId))
  add(query_594419, "$.xgafv", newJString(Xgafv))
  add(query_594419, "pageSize", newJInt(pageSize))
  add(query_594419, "prettyPrint", newJBool(prettyPrint))
  add(query_594419, "startTime", newJString(startTime))
  add(path_594418, "location", newJString(location))
  result = call_594417.call(path_594418, query_594419, nil, nil, nil)

var dataflowProjectsLocationsJobsMessagesList* = Call_DataflowProjectsLocationsJobsMessagesList_594394(
    name: "dataflowProjectsLocationsJobsMessagesList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/messages",
    validator: validate_DataflowProjectsLocationsJobsMessagesList_594395,
    base: "/", url: url_DataflowProjectsLocationsJobsMessagesList_594396,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsGetMetrics_594420 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsJobsGetMetrics_594422(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsJobsGetMetrics_594421(path: JsonNode;
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
  var valid_594423 = path.getOrDefault("jobId")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "jobId", valid_594423
  var valid_594424 = path.getOrDefault("projectId")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "projectId", valid_594424
  var valid_594425 = path.getOrDefault("location")
  valid_594425 = validateParameter(valid_594425, JString, required = true,
                                 default = nil)
  if valid_594425 != nil:
    section.add "location", valid_594425
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
  var valid_594426 = query.getOrDefault("upload_protocol")
  valid_594426 = validateParameter(valid_594426, JString, required = false,
                                 default = nil)
  if valid_594426 != nil:
    section.add "upload_protocol", valid_594426
  var valid_594427 = query.getOrDefault("fields")
  valid_594427 = validateParameter(valid_594427, JString, required = false,
                                 default = nil)
  if valid_594427 != nil:
    section.add "fields", valid_594427
  var valid_594428 = query.getOrDefault("quotaUser")
  valid_594428 = validateParameter(valid_594428, JString, required = false,
                                 default = nil)
  if valid_594428 != nil:
    section.add "quotaUser", valid_594428
  var valid_594429 = query.getOrDefault("alt")
  valid_594429 = validateParameter(valid_594429, JString, required = false,
                                 default = newJString("json"))
  if valid_594429 != nil:
    section.add "alt", valid_594429
  var valid_594430 = query.getOrDefault("oauth_token")
  valid_594430 = validateParameter(valid_594430, JString, required = false,
                                 default = nil)
  if valid_594430 != nil:
    section.add "oauth_token", valid_594430
  var valid_594431 = query.getOrDefault("callback")
  valid_594431 = validateParameter(valid_594431, JString, required = false,
                                 default = nil)
  if valid_594431 != nil:
    section.add "callback", valid_594431
  var valid_594432 = query.getOrDefault("access_token")
  valid_594432 = validateParameter(valid_594432, JString, required = false,
                                 default = nil)
  if valid_594432 != nil:
    section.add "access_token", valid_594432
  var valid_594433 = query.getOrDefault("uploadType")
  valid_594433 = validateParameter(valid_594433, JString, required = false,
                                 default = nil)
  if valid_594433 != nil:
    section.add "uploadType", valid_594433
  var valid_594434 = query.getOrDefault("key")
  valid_594434 = validateParameter(valid_594434, JString, required = false,
                                 default = nil)
  if valid_594434 != nil:
    section.add "key", valid_594434
  var valid_594435 = query.getOrDefault("$.xgafv")
  valid_594435 = validateParameter(valid_594435, JString, required = false,
                                 default = newJString("1"))
  if valid_594435 != nil:
    section.add "$.xgafv", valid_594435
  var valid_594436 = query.getOrDefault("prettyPrint")
  valid_594436 = validateParameter(valid_594436, JBool, required = false,
                                 default = newJBool(true))
  if valid_594436 != nil:
    section.add "prettyPrint", valid_594436
  var valid_594437 = query.getOrDefault("startTime")
  valid_594437 = validateParameter(valid_594437, JString, required = false,
                                 default = nil)
  if valid_594437 != nil:
    section.add "startTime", valid_594437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594438: Call_DataflowProjectsLocationsJobsGetMetrics_594420;
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
  let valid = call_594438.validator(path, query, header, formData, body)
  let scheme = call_594438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594438.url(scheme.get, call_594438.host, call_594438.base,
                         call_594438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594438, url, valid)

proc call*(call_594439: Call_DataflowProjectsLocationsJobsGetMetrics_594420;
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
  var path_594440 = newJObject()
  var query_594441 = newJObject()
  add(query_594441, "upload_protocol", newJString(uploadProtocol))
  add(query_594441, "fields", newJString(fields))
  add(query_594441, "quotaUser", newJString(quotaUser))
  add(query_594441, "alt", newJString(alt))
  add(path_594440, "jobId", newJString(jobId))
  add(query_594441, "oauth_token", newJString(oauthToken))
  add(query_594441, "callback", newJString(callback))
  add(query_594441, "access_token", newJString(accessToken))
  add(query_594441, "uploadType", newJString(uploadType))
  add(query_594441, "key", newJString(key))
  add(path_594440, "projectId", newJString(projectId))
  add(query_594441, "$.xgafv", newJString(Xgafv))
  add(query_594441, "prettyPrint", newJBool(prettyPrint))
  add(query_594441, "startTime", newJString(startTime))
  add(path_594440, "location", newJString(location))
  result = call_594439.call(path_594440, query_594441, nil, nil, nil)

var dataflowProjectsLocationsJobsGetMetrics* = Call_DataflowProjectsLocationsJobsGetMetrics_594420(
    name: "dataflowProjectsLocationsJobsGetMetrics", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/metrics",
    validator: validate_DataflowProjectsLocationsJobsGetMetrics_594421, base: "/",
    url: url_DataflowProjectsLocationsJobsGetMetrics_594422,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsWorkItemsLease_594442 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsJobsWorkItemsLease_594444(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsJobsWorkItemsLease_594443(path: JsonNode;
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
  var valid_594445 = path.getOrDefault("jobId")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "jobId", valid_594445
  var valid_594446 = path.getOrDefault("projectId")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "projectId", valid_594446
  var valid_594447 = path.getOrDefault("location")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "location", valid_594447
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
  var valid_594448 = query.getOrDefault("upload_protocol")
  valid_594448 = validateParameter(valid_594448, JString, required = false,
                                 default = nil)
  if valid_594448 != nil:
    section.add "upload_protocol", valid_594448
  var valid_594449 = query.getOrDefault("fields")
  valid_594449 = validateParameter(valid_594449, JString, required = false,
                                 default = nil)
  if valid_594449 != nil:
    section.add "fields", valid_594449
  var valid_594450 = query.getOrDefault("quotaUser")
  valid_594450 = validateParameter(valid_594450, JString, required = false,
                                 default = nil)
  if valid_594450 != nil:
    section.add "quotaUser", valid_594450
  var valid_594451 = query.getOrDefault("alt")
  valid_594451 = validateParameter(valid_594451, JString, required = false,
                                 default = newJString("json"))
  if valid_594451 != nil:
    section.add "alt", valid_594451
  var valid_594452 = query.getOrDefault("oauth_token")
  valid_594452 = validateParameter(valid_594452, JString, required = false,
                                 default = nil)
  if valid_594452 != nil:
    section.add "oauth_token", valid_594452
  var valid_594453 = query.getOrDefault("callback")
  valid_594453 = validateParameter(valid_594453, JString, required = false,
                                 default = nil)
  if valid_594453 != nil:
    section.add "callback", valid_594453
  var valid_594454 = query.getOrDefault("access_token")
  valid_594454 = validateParameter(valid_594454, JString, required = false,
                                 default = nil)
  if valid_594454 != nil:
    section.add "access_token", valid_594454
  var valid_594455 = query.getOrDefault("uploadType")
  valid_594455 = validateParameter(valid_594455, JString, required = false,
                                 default = nil)
  if valid_594455 != nil:
    section.add "uploadType", valid_594455
  var valid_594456 = query.getOrDefault("key")
  valid_594456 = validateParameter(valid_594456, JString, required = false,
                                 default = nil)
  if valid_594456 != nil:
    section.add "key", valid_594456
  var valid_594457 = query.getOrDefault("$.xgafv")
  valid_594457 = validateParameter(valid_594457, JString, required = false,
                                 default = newJString("1"))
  if valid_594457 != nil:
    section.add "$.xgafv", valid_594457
  var valid_594458 = query.getOrDefault("prettyPrint")
  valid_594458 = validateParameter(valid_594458, JBool, required = false,
                                 default = newJBool(true))
  if valid_594458 != nil:
    section.add "prettyPrint", valid_594458
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

proc call*(call_594460: Call_DataflowProjectsLocationsJobsWorkItemsLease_594442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Leases a dataflow WorkItem to run.
  ## 
  let valid = call_594460.validator(path, query, header, formData, body)
  let scheme = call_594460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594460.url(scheme.get, call_594460.host, call_594460.base,
                         call_594460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594460, url, valid)

proc call*(call_594461: Call_DataflowProjectsLocationsJobsWorkItemsLease_594442;
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
  var path_594462 = newJObject()
  var query_594463 = newJObject()
  var body_594464 = newJObject()
  add(query_594463, "upload_protocol", newJString(uploadProtocol))
  add(query_594463, "fields", newJString(fields))
  add(query_594463, "quotaUser", newJString(quotaUser))
  add(query_594463, "alt", newJString(alt))
  add(path_594462, "jobId", newJString(jobId))
  add(query_594463, "oauth_token", newJString(oauthToken))
  add(query_594463, "callback", newJString(callback))
  add(query_594463, "access_token", newJString(accessToken))
  add(query_594463, "uploadType", newJString(uploadType))
  add(query_594463, "key", newJString(key))
  add(path_594462, "projectId", newJString(projectId))
  add(query_594463, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594464 = body
  add(query_594463, "prettyPrint", newJBool(prettyPrint))
  add(path_594462, "location", newJString(location))
  result = call_594461.call(path_594462, query_594463, nil, nil, body_594464)

var dataflowProjectsLocationsJobsWorkItemsLease* = Call_DataflowProjectsLocationsJobsWorkItemsLease_594442(
    name: "dataflowProjectsLocationsJobsWorkItemsLease",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/workItems:lease",
    validator: validate_DataflowProjectsLocationsJobsWorkItemsLease_594443,
    base: "/", url: url_DataflowProjectsLocationsJobsWorkItemsLease_594444,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_594465 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsJobsWorkItemsReportStatus_594467(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsJobsWorkItemsReportStatus_594466(
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
  var valid_594468 = path.getOrDefault("jobId")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "jobId", valid_594468
  var valid_594469 = path.getOrDefault("projectId")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "projectId", valid_594469
  var valid_594470 = path.getOrDefault("location")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "location", valid_594470
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
  var valid_594471 = query.getOrDefault("upload_protocol")
  valid_594471 = validateParameter(valid_594471, JString, required = false,
                                 default = nil)
  if valid_594471 != nil:
    section.add "upload_protocol", valid_594471
  var valid_594472 = query.getOrDefault("fields")
  valid_594472 = validateParameter(valid_594472, JString, required = false,
                                 default = nil)
  if valid_594472 != nil:
    section.add "fields", valid_594472
  var valid_594473 = query.getOrDefault("quotaUser")
  valid_594473 = validateParameter(valid_594473, JString, required = false,
                                 default = nil)
  if valid_594473 != nil:
    section.add "quotaUser", valid_594473
  var valid_594474 = query.getOrDefault("alt")
  valid_594474 = validateParameter(valid_594474, JString, required = false,
                                 default = newJString("json"))
  if valid_594474 != nil:
    section.add "alt", valid_594474
  var valid_594475 = query.getOrDefault("oauth_token")
  valid_594475 = validateParameter(valid_594475, JString, required = false,
                                 default = nil)
  if valid_594475 != nil:
    section.add "oauth_token", valid_594475
  var valid_594476 = query.getOrDefault("callback")
  valid_594476 = validateParameter(valid_594476, JString, required = false,
                                 default = nil)
  if valid_594476 != nil:
    section.add "callback", valid_594476
  var valid_594477 = query.getOrDefault("access_token")
  valid_594477 = validateParameter(valid_594477, JString, required = false,
                                 default = nil)
  if valid_594477 != nil:
    section.add "access_token", valid_594477
  var valid_594478 = query.getOrDefault("uploadType")
  valid_594478 = validateParameter(valid_594478, JString, required = false,
                                 default = nil)
  if valid_594478 != nil:
    section.add "uploadType", valid_594478
  var valid_594479 = query.getOrDefault("key")
  valid_594479 = validateParameter(valid_594479, JString, required = false,
                                 default = nil)
  if valid_594479 != nil:
    section.add "key", valid_594479
  var valid_594480 = query.getOrDefault("$.xgafv")
  valid_594480 = validateParameter(valid_594480, JString, required = false,
                                 default = newJString("1"))
  if valid_594480 != nil:
    section.add "$.xgafv", valid_594480
  var valid_594481 = query.getOrDefault("prettyPrint")
  valid_594481 = validateParameter(valid_594481, JBool, required = false,
                                 default = newJBool(true))
  if valid_594481 != nil:
    section.add "prettyPrint", valid_594481
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

proc call*(call_594483: Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_594465;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports the status of dataflow WorkItems leased by a worker.
  ## 
  let valid = call_594483.validator(path, query, header, formData, body)
  let scheme = call_594483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594483.url(scheme.get, call_594483.host, call_594483.base,
                         call_594483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594483, url, valid)

proc call*(call_594484: Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_594465;
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
  var path_594485 = newJObject()
  var query_594486 = newJObject()
  var body_594487 = newJObject()
  add(query_594486, "upload_protocol", newJString(uploadProtocol))
  add(query_594486, "fields", newJString(fields))
  add(query_594486, "quotaUser", newJString(quotaUser))
  add(query_594486, "alt", newJString(alt))
  add(path_594485, "jobId", newJString(jobId))
  add(query_594486, "oauth_token", newJString(oauthToken))
  add(query_594486, "callback", newJString(callback))
  add(query_594486, "access_token", newJString(accessToken))
  add(query_594486, "uploadType", newJString(uploadType))
  add(query_594486, "key", newJString(key))
  add(path_594485, "projectId", newJString(projectId))
  add(query_594486, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594487 = body
  add(query_594486, "prettyPrint", newJBool(prettyPrint))
  add(path_594485, "location", newJString(location))
  result = call_594484.call(path_594485, query_594486, nil, nil, body_594487)

var dataflowProjectsLocationsJobsWorkItemsReportStatus* = Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_594465(
    name: "dataflowProjectsLocationsJobsWorkItemsReportStatus",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/workItems:reportStatus",
    validator: validate_DataflowProjectsLocationsJobsWorkItemsReportStatus_594466,
    base: "/", url: url_DataflowProjectsLocationsJobsWorkItemsReportStatus_594467,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsSqlValidate_594488 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsSqlValidate_594490(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsSqlValidate_594489(path: JsonNode;
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
  var valid_594491 = path.getOrDefault("projectId")
  valid_594491 = validateParameter(valid_594491, JString, required = true,
                                 default = nil)
  if valid_594491 != nil:
    section.add "projectId", valid_594491
  var valid_594492 = path.getOrDefault("location")
  valid_594492 = validateParameter(valid_594492, JString, required = true,
                                 default = nil)
  if valid_594492 != nil:
    section.add "location", valid_594492
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
  var valid_594493 = query.getOrDefault("upload_protocol")
  valid_594493 = validateParameter(valid_594493, JString, required = false,
                                 default = nil)
  if valid_594493 != nil:
    section.add "upload_protocol", valid_594493
  var valid_594494 = query.getOrDefault("fields")
  valid_594494 = validateParameter(valid_594494, JString, required = false,
                                 default = nil)
  if valid_594494 != nil:
    section.add "fields", valid_594494
  var valid_594495 = query.getOrDefault("quotaUser")
  valid_594495 = validateParameter(valid_594495, JString, required = false,
                                 default = nil)
  if valid_594495 != nil:
    section.add "quotaUser", valid_594495
  var valid_594496 = query.getOrDefault("alt")
  valid_594496 = validateParameter(valid_594496, JString, required = false,
                                 default = newJString("json"))
  if valid_594496 != nil:
    section.add "alt", valid_594496
  var valid_594497 = query.getOrDefault("query")
  valid_594497 = validateParameter(valid_594497, JString, required = false,
                                 default = nil)
  if valid_594497 != nil:
    section.add "query", valid_594497
  var valid_594498 = query.getOrDefault("oauth_token")
  valid_594498 = validateParameter(valid_594498, JString, required = false,
                                 default = nil)
  if valid_594498 != nil:
    section.add "oauth_token", valid_594498
  var valid_594499 = query.getOrDefault("callback")
  valid_594499 = validateParameter(valid_594499, JString, required = false,
                                 default = nil)
  if valid_594499 != nil:
    section.add "callback", valid_594499
  var valid_594500 = query.getOrDefault("access_token")
  valid_594500 = validateParameter(valid_594500, JString, required = false,
                                 default = nil)
  if valid_594500 != nil:
    section.add "access_token", valid_594500
  var valid_594501 = query.getOrDefault("uploadType")
  valid_594501 = validateParameter(valid_594501, JString, required = false,
                                 default = nil)
  if valid_594501 != nil:
    section.add "uploadType", valid_594501
  var valid_594502 = query.getOrDefault("key")
  valid_594502 = validateParameter(valid_594502, JString, required = false,
                                 default = nil)
  if valid_594502 != nil:
    section.add "key", valid_594502
  var valid_594503 = query.getOrDefault("$.xgafv")
  valid_594503 = validateParameter(valid_594503, JString, required = false,
                                 default = newJString("1"))
  if valid_594503 != nil:
    section.add "$.xgafv", valid_594503
  var valid_594504 = query.getOrDefault("prettyPrint")
  valid_594504 = validateParameter(valid_594504, JBool, required = false,
                                 default = newJBool(true))
  if valid_594504 != nil:
    section.add "prettyPrint", valid_594504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594505: Call_DataflowProjectsLocationsSqlValidate_594488;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates a GoogleSQL query for Cloud Dataflow syntax. Will always
  ## confirm the given query parses correctly, and if able to look up
  ## schema information from DataCatalog, will validate that the query
  ## analyzes properly as well.
  ## 
  let valid = call_594505.validator(path, query, header, formData, body)
  let scheme = call_594505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594505.url(scheme.get, call_594505.host, call_594505.base,
                         call_594505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594505, url, valid)

proc call*(call_594506: Call_DataflowProjectsLocationsSqlValidate_594488;
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
  var path_594507 = newJObject()
  var query_594508 = newJObject()
  add(query_594508, "upload_protocol", newJString(uploadProtocol))
  add(query_594508, "fields", newJString(fields))
  add(query_594508, "quotaUser", newJString(quotaUser))
  add(query_594508, "alt", newJString(alt))
  add(query_594508, "query", newJString(query))
  add(query_594508, "oauth_token", newJString(oauthToken))
  add(query_594508, "callback", newJString(callback))
  add(query_594508, "access_token", newJString(accessToken))
  add(query_594508, "uploadType", newJString(uploadType))
  add(query_594508, "key", newJString(key))
  add(path_594507, "projectId", newJString(projectId))
  add(query_594508, "$.xgafv", newJString(Xgafv))
  add(query_594508, "prettyPrint", newJBool(prettyPrint))
  add(path_594507, "location", newJString(location))
  result = call_594506.call(path_594507, query_594508, nil, nil, nil)

var dataflowProjectsLocationsSqlValidate* = Call_DataflowProjectsLocationsSqlValidate_594488(
    name: "dataflowProjectsLocationsSqlValidate", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/sql:validate",
    validator: validate_DataflowProjectsLocationsSqlValidate_594489, base: "/",
    url: url_DataflowProjectsLocationsSqlValidate_594490, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesCreate_594509 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsTemplatesCreate_594511(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsTemplatesCreate_594510(path: JsonNode;
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
  var valid_594512 = path.getOrDefault("projectId")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "projectId", valid_594512
  var valid_594513 = path.getOrDefault("location")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "location", valid_594513
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
  var valid_594514 = query.getOrDefault("upload_protocol")
  valid_594514 = validateParameter(valid_594514, JString, required = false,
                                 default = nil)
  if valid_594514 != nil:
    section.add "upload_protocol", valid_594514
  var valid_594515 = query.getOrDefault("fields")
  valid_594515 = validateParameter(valid_594515, JString, required = false,
                                 default = nil)
  if valid_594515 != nil:
    section.add "fields", valid_594515
  var valid_594516 = query.getOrDefault("quotaUser")
  valid_594516 = validateParameter(valid_594516, JString, required = false,
                                 default = nil)
  if valid_594516 != nil:
    section.add "quotaUser", valid_594516
  var valid_594517 = query.getOrDefault("alt")
  valid_594517 = validateParameter(valid_594517, JString, required = false,
                                 default = newJString("json"))
  if valid_594517 != nil:
    section.add "alt", valid_594517
  var valid_594518 = query.getOrDefault("oauth_token")
  valid_594518 = validateParameter(valid_594518, JString, required = false,
                                 default = nil)
  if valid_594518 != nil:
    section.add "oauth_token", valid_594518
  var valid_594519 = query.getOrDefault("callback")
  valid_594519 = validateParameter(valid_594519, JString, required = false,
                                 default = nil)
  if valid_594519 != nil:
    section.add "callback", valid_594519
  var valid_594520 = query.getOrDefault("access_token")
  valid_594520 = validateParameter(valid_594520, JString, required = false,
                                 default = nil)
  if valid_594520 != nil:
    section.add "access_token", valid_594520
  var valid_594521 = query.getOrDefault("uploadType")
  valid_594521 = validateParameter(valid_594521, JString, required = false,
                                 default = nil)
  if valid_594521 != nil:
    section.add "uploadType", valid_594521
  var valid_594522 = query.getOrDefault("key")
  valid_594522 = validateParameter(valid_594522, JString, required = false,
                                 default = nil)
  if valid_594522 != nil:
    section.add "key", valid_594522
  var valid_594523 = query.getOrDefault("$.xgafv")
  valid_594523 = validateParameter(valid_594523, JString, required = false,
                                 default = newJString("1"))
  if valid_594523 != nil:
    section.add "$.xgafv", valid_594523
  var valid_594524 = query.getOrDefault("prettyPrint")
  valid_594524 = validateParameter(valid_594524, JBool, required = false,
                                 default = newJBool(true))
  if valid_594524 != nil:
    section.add "prettyPrint", valid_594524
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

proc call*(call_594526: Call_DataflowProjectsLocationsTemplatesCreate_594509;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job from a template.
  ## 
  let valid = call_594526.validator(path, query, header, formData, body)
  let scheme = call_594526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594526.url(scheme.get, call_594526.host, call_594526.base,
                         call_594526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594526, url, valid)

proc call*(call_594527: Call_DataflowProjectsLocationsTemplatesCreate_594509;
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
  var path_594528 = newJObject()
  var query_594529 = newJObject()
  var body_594530 = newJObject()
  add(query_594529, "upload_protocol", newJString(uploadProtocol))
  add(query_594529, "fields", newJString(fields))
  add(query_594529, "quotaUser", newJString(quotaUser))
  add(query_594529, "alt", newJString(alt))
  add(query_594529, "oauth_token", newJString(oauthToken))
  add(query_594529, "callback", newJString(callback))
  add(query_594529, "access_token", newJString(accessToken))
  add(query_594529, "uploadType", newJString(uploadType))
  add(query_594529, "key", newJString(key))
  add(path_594528, "projectId", newJString(projectId))
  add(query_594529, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594530 = body
  add(query_594529, "prettyPrint", newJBool(prettyPrint))
  add(path_594528, "location", newJString(location))
  result = call_594527.call(path_594528, query_594529, nil, nil, body_594530)

var dataflowProjectsLocationsTemplatesCreate* = Call_DataflowProjectsLocationsTemplatesCreate_594509(
    name: "dataflowProjectsLocationsTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates",
    validator: validate_DataflowProjectsLocationsTemplatesCreate_594510,
    base: "/", url: url_DataflowProjectsLocationsTemplatesCreate_594511,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesGet_594531 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsTemplatesGet_594533(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsTemplatesGet_594532(path: JsonNode;
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
  var valid_594534 = path.getOrDefault("projectId")
  valid_594534 = validateParameter(valid_594534, JString, required = true,
                                 default = nil)
  if valid_594534 != nil:
    section.add "projectId", valid_594534
  var valid_594535 = path.getOrDefault("location")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "location", valid_594535
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
  var valid_594536 = query.getOrDefault("upload_protocol")
  valid_594536 = validateParameter(valid_594536, JString, required = false,
                                 default = nil)
  if valid_594536 != nil:
    section.add "upload_protocol", valid_594536
  var valid_594537 = query.getOrDefault("fields")
  valid_594537 = validateParameter(valid_594537, JString, required = false,
                                 default = nil)
  if valid_594537 != nil:
    section.add "fields", valid_594537
  var valid_594538 = query.getOrDefault("view")
  valid_594538 = validateParameter(valid_594538, JString, required = false,
                                 default = newJString("METADATA_ONLY"))
  if valid_594538 != nil:
    section.add "view", valid_594538
  var valid_594539 = query.getOrDefault("quotaUser")
  valid_594539 = validateParameter(valid_594539, JString, required = false,
                                 default = nil)
  if valid_594539 != nil:
    section.add "quotaUser", valid_594539
  var valid_594540 = query.getOrDefault("alt")
  valid_594540 = validateParameter(valid_594540, JString, required = false,
                                 default = newJString("json"))
  if valid_594540 != nil:
    section.add "alt", valid_594540
  var valid_594541 = query.getOrDefault("gcsPath")
  valid_594541 = validateParameter(valid_594541, JString, required = false,
                                 default = nil)
  if valid_594541 != nil:
    section.add "gcsPath", valid_594541
  var valid_594542 = query.getOrDefault("oauth_token")
  valid_594542 = validateParameter(valid_594542, JString, required = false,
                                 default = nil)
  if valid_594542 != nil:
    section.add "oauth_token", valid_594542
  var valid_594543 = query.getOrDefault("callback")
  valid_594543 = validateParameter(valid_594543, JString, required = false,
                                 default = nil)
  if valid_594543 != nil:
    section.add "callback", valid_594543
  var valid_594544 = query.getOrDefault("access_token")
  valid_594544 = validateParameter(valid_594544, JString, required = false,
                                 default = nil)
  if valid_594544 != nil:
    section.add "access_token", valid_594544
  var valid_594545 = query.getOrDefault("uploadType")
  valid_594545 = validateParameter(valid_594545, JString, required = false,
                                 default = nil)
  if valid_594545 != nil:
    section.add "uploadType", valid_594545
  var valid_594546 = query.getOrDefault("key")
  valid_594546 = validateParameter(valid_594546, JString, required = false,
                                 default = nil)
  if valid_594546 != nil:
    section.add "key", valid_594546
  var valid_594547 = query.getOrDefault("$.xgafv")
  valid_594547 = validateParameter(valid_594547, JString, required = false,
                                 default = newJString("1"))
  if valid_594547 != nil:
    section.add "$.xgafv", valid_594547
  var valid_594548 = query.getOrDefault("prettyPrint")
  valid_594548 = validateParameter(valid_594548, JBool, required = false,
                                 default = newJBool(true))
  if valid_594548 != nil:
    section.add "prettyPrint", valid_594548
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594549: Call_DataflowProjectsLocationsTemplatesGet_594531;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the template associated with a template.
  ## 
  let valid = call_594549.validator(path, query, header, formData, body)
  let scheme = call_594549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594549.url(scheme.get, call_594549.host, call_594549.base,
                         call_594549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594549, url, valid)

proc call*(call_594550: Call_DataflowProjectsLocationsTemplatesGet_594531;
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
  var path_594551 = newJObject()
  var query_594552 = newJObject()
  add(query_594552, "upload_protocol", newJString(uploadProtocol))
  add(query_594552, "fields", newJString(fields))
  add(query_594552, "view", newJString(view))
  add(query_594552, "quotaUser", newJString(quotaUser))
  add(query_594552, "alt", newJString(alt))
  add(query_594552, "gcsPath", newJString(gcsPath))
  add(query_594552, "oauth_token", newJString(oauthToken))
  add(query_594552, "callback", newJString(callback))
  add(query_594552, "access_token", newJString(accessToken))
  add(query_594552, "uploadType", newJString(uploadType))
  add(query_594552, "key", newJString(key))
  add(path_594551, "projectId", newJString(projectId))
  add(query_594552, "$.xgafv", newJString(Xgafv))
  add(query_594552, "prettyPrint", newJBool(prettyPrint))
  add(path_594551, "location", newJString(location))
  result = call_594550.call(path_594551, query_594552, nil, nil, nil)

var dataflowProjectsLocationsTemplatesGet* = Call_DataflowProjectsLocationsTemplatesGet_594531(
    name: "dataflowProjectsLocationsTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates:get",
    validator: validate_DataflowProjectsLocationsTemplatesGet_594532, base: "/",
    url: url_DataflowProjectsLocationsTemplatesGet_594533, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesLaunch_594553 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsLocationsTemplatesLaunch_594555(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsLocationsTemplatesLaunch_594554(path: JsonNode;
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
  var valid_594556 = path.getOrDefault("projectId")
  valid_594556 = validateParameter(valid_594556, JString, required = true,
                                 default = nil)
  if valid_594556 != nil:
    section.add "projectId", valid_594556
  var valid_594557 = path.getOrDefault("location")
  valid_594557 = validateParameter(valid_594557, JString, required = true,
                                 default = nil)
  if valid_594557 != nil:
    section.add "location", valid_594557
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
  var valid_594558 = query.getOrDefault("upload_protocol")
  valid_594558 = validateParameter(valid_594558, JString, required = false,
                                 default = nil)
  if valid_594558 != nil:
    section.add "upload_protocol", valid_594558
  var valid_594559 = query.getOrDefault("fields")
  valid_594559 = validateParameter(valid_594559, JString, required = false,
                                 default = nil)
  if valid_594559 != nil:
    section.add "fields", valid_594559
  var valid_594560 = query.getOrDefault("quotaUser")
  valid_594560 = validateParameter(valid_594560, JString, required = false,
                                 default = nil)
  if valid_594560 != nil:
    section.add "quotaUser", valid_594560
  var valid_594561 = query.getOrDefault("dynamicTemplate.stagingLocation")
  valid_594561 = validateParameter(valid_594561, JString, required = false,
                                 default = nil)
  if valid_594561 != nil:
    section.add "dynamicTemplate.stagingLocation", valid_594561
  var valid_594562 = query.getOrDefault("alt")
  valid_594562 = validateParameter(valid_594562, JString, required = false,
                                 default = newJString("json"))
  if valid_594562 != nil:
    section.add "alt", valid_594562
  var valid_594563 = query.getOrDefault("dynamicTemplate.gcsPath")
  valid_594563 = validateParameter(valid_594563, JString, required = false,
                                 default = nil)
  if valid_594563 != nil:
    section.add "dynamicTemplate.gcsPath", valid_594563
  var valid_594564 = query.getOrDefault("gcsPath")
  valid_594564 = validateParameter(valid_594564, JString, required = false,
                                 default = nil)
  if valid_594564 != nil:
    section.add "gcsPath", valid_594564
  var valid_594565 = query.getOrDefault("oauth_token")
  valid_594565 = validateParameter(valid_594565, JString, required = false,
                                 default = nil)
  if valid_594565 != nil:
    section.add "oauth_token", valid_594565
  var valid_594566 = query.getOrDefault("callback")
  valid_594566 = validateParameter(valid_594566, JString, required = false,
                                 default = nil)
  if valid_594566 != nil:
    section.add "callback", valid_594566
  var valid_594567 = query.getOrDefault("access_token")
  valid_594567 = validateParameter(valid_594567, JString, required = false,
                                 default = nil)
  if valid_594567 != nil:
    section.add "access_token", valid_594567
  var valid_594568 = query.getOrDefault("uploadType")
  valid_594568 = validateParameter(valid_594568, JString, required = false,
                                 default = nil)
  if valid_594568 != nil:
    section.add "uploadType", valid_594568
  var valid_594569 = query.getOrDefault("validateOnly")
  valid_594569 = validateParameter(valid_594569, JBool, required = false, default = nil)
  if valid_594569 != nil:
    section.add "validateOnly", valid_594569
  var valid_594570 = query.getOrDefault("key")
  valid_594570 = validateParameter(valid_594570, JString, required = false,
                                 default = nil)
  if valid_594570 != nil:
    section.add "key", valid_594570
  var valid_594571 = query.getOrDefault("$.xgafv")
  valid_594571 = validateParameter(valid_594571, JString, required = false,
                                 default = newJString("1"))
  if valid_594571 != nil:
    section.add "$.xgafv", valid_594571
  var valid_594572 = query.getOrDefault("prettyPrint")
  valid_594572 = validateParameter(valid_594572, JBool, required = false,
                                 default = newJBool(true))
  if valid_594572 != nil:
    section.add "prettyPrint", valid_594572
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

proc call*(call_594574: Call_DataflowProjectsLocationsTemplatesLaunch_594553;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Launch a template.
  ## 
  let valid = call_594574.validator(path, query, header, formData, body)
  let scheme = call_594574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594574.url(scheme.get, call_594574.host, call_594574.base,
                         call_594574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594574, url, valid)

proc call*(call_594575: Call_DataflowProjectsLocationsTemplatesLaunch_594553;
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
  var path_594576 = newJObject()
  var query_594577 = newJObject()
  var body_594578 = newJObject()
  add(query_594577, "upload_protocol", newJString(uploadProtocol))
  add(query_594577, "fields", newJString(fields))
  add(query_594577, "quotaUser", newJString(quotaUser))
  add(query_594577, "dynamicTemplate.stagingLocation",
      newJString(dynamicTemplateStagingLocation))
  add(query_594577, "alt", newJString(alt))
  add(query_594577, "dynamicTemplate.gcsPath", newJString(dynamicTemplateGcsPath))
  add(query_594577, "gcsPath", newJString(gcsPath))
  add(query_594577, "oauth_token", newJString(oauthToken))
  add(query_594577, "callback", newJString(callback))
  add(query_594577, "access_token", newJString(accessToken))
  add(query_594577, "uploadType", newJString(uploadType))
  add(query_594577, "validateOnly", newJBool(validateOnly))
  add(query_594577, "key", newJString(key))
  add(path_594576, "projectId", newJString(projectId))
  add(query_594577, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594578 = body
  add(query_594577, "prettyPrint", newJBool(prettyPrint))
  add(path_594576, "location", newJString(location))
  result = call_594575.call(path_594576, query_594577, nil, nil, body_594578)

var dataflowProjectsLocationsTemplatesLaunch* = Call_DataflowProjectsLocationsTemplatesLaunch_594553(
    name: "dataflowProjectsLocationsTemplatesLaunch", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates:launch",
    validator: validate_DataflowProjectsLocationsTemplatesLaunch_594554,
    base: "/", url: url_DataflowProjectsLocationsTemplatesLaunch_594555,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesCreate_594579 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsTemplatesCreate_594581(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsTemplatesCreate_594580(path: JsonNode;
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
  var valid_594582 = path.getOrDefault("projectId")
  valid_594582 = validateParameter(valid_594582, JString, required = true,
                                 default = nil)
  if valid_594582 != nil:
    section.add "projectId", valid_594582
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
  var valid_594583 = query.getOrDefault("upload_protocol")
  valid_594583 = validateParameter(valid_594583, JString, required = false,
                                 default = nil)
  if valid_594583 != nil:
    section.add "upload_protocol", valid_594583
  var valid_594584 = query.getOrDefault("fields")
  valid_594584 = validateParameter(valid_594584, JString, required = false,
                                 default = nil)
  if valid_594584 != nil:
    section.add "fields", valid_594584
  var valid_594585 = query.getOrDefault("quotaUser")
  valid_594585 = validateParameter(valid_594585, JString, required = false,
                                 default = nil)
  if valid_594585 != nil:
    section.add "quotaUser", valid_594585
  var valid_594586 = query.getOrDefault("alt")
  valid_594586 = validateParameter(valid_594586, JString, required = false,
                                 default = newJString("json"))
  if valid_594586 != nil:
    section.add "alt", valid_594586
  var valid_594587 = query.getOrDefault("oauth_token")
  valid_594587 = validateParameter(valid_594587, JString, required = false,
                                 default = nil)
  if valid_594587 != nil:
    section.add "oauth_token", valid_594587
  var valid_594588 = query.getOrDefault("callback")
  valid_594588 = validateParameter(valid_594588, JString, required = false,
                                 default = nil)
  if valid_594588 != nil:
    section.add "callback", valid_594588
  var valid_594589 = query.getOrDefault("access_token")
  valid_594589 = validateParameter(valid_594589, JString, required = false,
                                 default = nil)
  if valid_594589 != nil:
    section.add "access_token", valid_594589
  var valid_594590 = query.getOrDefault("uploadType")
  valid_594590 = validateParameter(valid_594590, JString, required = false,
                                 default = nil)
  if valid_594590 != nil:
    section.add "uploadType", valid_594590
  var valid_594591 = query.getOrDefault("key")
  valid_594591 = validateParameter(valid_594591, JString, required = false,
                                 default = nil)
  if valid_594591 != nil:
    section.add "key", valid_594591
  var valid_594592 = query.getOrDefault("$.xgafv")
  valid_594592 = validateParameter(valid_594592, JString, required = false,
                                 default = newJString("1"))
  if valid_594592 != nil:
    section.add "$.xgafv", valid_594592
  var valid_594593 = query.getOrDefault("prettyPrint")
  valid_594593 = validateParameter(valid_594593, JBool, required = false,
                                 default = newJBool(true))
  if valid_594593 != nil:
    section.add "prettyPrint", valid_594593
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

proc call*(call_594595: Call_DataflowProjectsTemplatesCreate_594579;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job from a template.
  ## 
  let valid = call_594595.validator(path, query, header, formData, body)
  let scheme = call_594595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594595.url(scheme.get, call_594595.host, call_594595.base,
                         call_594595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594595, url, valid)

proc call*(call_594596: Call_DataflowProjectsTemplatesCreate_594579;
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
  var path_594597 = newJObject()
  var query_594598 = newJObject()
  var body_594599 = newJObject()
  add(query_594598, "upload_protocol", newJString(uploadProtocol))
  add(query_594598, "fields", newJString(fields))
  add(query_594598, "quotaUser", newJString(quotaUser))
  add(query_594598, "alt", newJString(alt))
  add(query_594598, "oauth_token", newJString(oauthToken))
  add(query_594598, "callback", newJString(callback))
  add(query_594598, "access_token", newJString(accessToken))
  add(query_594598, "uploadType", newJString(uploadType))
  add(query_594598, "key", newJString(key))
  add(path_594597, "projectId", newJString(projectId))
  add(query_594598, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594599 = body
  add(query_594598, "prettyPrint", newJBool(prettyPrint))
  result = call_594596.call(path_594597, query_594598, nil, nil, body_594599)

var dataflowProjectsTemplatesCreate* = Call_DataflowProjectsTemplatesCreate_594579(
    name: "dataflowProjectsTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates",
    validator: validate_DataflowProjectsTemplatesCreate_594580, base: "/",
    url: url_DataflowProjectsTemplatesCreate_594581, schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesGet_594600 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsTemplatesGet_594602(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsTemplatesGet_594601(path: JsonNode; query: JsonNode;
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
  var valid_594603 = path.getOrDefault("projectId")
  valid_594603 = validateParameter(valid_594603, JString, required = true,
                                 default = nil)
  if valid_594603 != nil:
    section.add "projectId", valid_594603
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
  var valid_594604 = query.getOrDefault("upload_protocol")
  valid_594604 = validateParameter(valid_594604, JString, required = false,
                                 default = nil)
  if valid_594604 != nil:
    section.add "upload_protocol", valid_594604
  var valid_594605 = query.getOrDefault("fields")
  valid_594605 = validateParameter(valid_594605, JString, required = false,
                                 default = nil)
  if valid_594605 != nil:
    section.add "fields", valid_594605
  var valid_594606 = query.getOrDefault("view")
  valid_594606 = validateParameter(valid_594606, JString, required = false,
                                 default = newJString("METADATA_ONLY"))
  if valid_594606 != nil:
    section.add "view", valid_594606
  var valid_594607 = query.getOrDefault("quotaUser")
  valid_594607 = validateParameter(valid_594607, JString, required = false,
                                 default = nil)
  if valid_594607 != nil:
    section.add "quotaUser", valid_594607
  var valid_594608 = query.getOrDefault("alt")
  valid_594608 = validateParameter(valid_594608, JString, required = false,
                                 default = newJString("json"))
  if valid_594608 != nil:
    section.add "alt", valid_594608
  var valid_594609 = query.getOrDefault("gcsPath")
  valid_594609 = validateParameter(valid_594609, JString, required = false,
                                 default = nil)
  if valid_594609 != nil:
    section.add "gcsPath", valid_594609
  var valid_594610 = query.getOrDefault("oauth_token")
  valid_594610 = validateParameter(valid_594610, JString, required = false,
                                 default = nil)
  if valid_594610 != nil:
    section.add "oauth_token", valid_594610
  var valid_594611 = query.getOrDefault("callback")
  valid_594611 = validateParameter(valid_594611, JString, required = false,
                                 default = nil)
  if valid_594611 != nil:
    section.add "callback", valid_594611
  var valid_594612 = query.getOrDefault("access_token")
  valid_594612 = validateParameter(valid_594612, JString, required = false,
                                 default = nil)
  if valid_594612 != nil:
    section.add "access_token", valid_594612
  var valid_594613 = query.getOrDefault("uploadType")
  valid_594613 = validateParameter(valid_594613, JString, required = false,
                                 default = nil)
  if valid_594613 != nil:
    section.add "uploadType", valid_594613
  var valid_594614 = query.getOrDefault("location")
  valid_594614 = validateParameter(valid_594614, JString, required = false,
                                 default = nil)
  if valid_594614 != nil:
    section.add "location", valid_594614
  var valid_594615 = query.getOrDefault("key")
  valid_594615 = validateParameter(valid_594615, JString, required = false,
                                 default = nil)
  if valid_594615 != nil:
    section.add "key", valid_594615
  var valid_594616 = query.getOrDefault("$.xgafv")
  valid_594616 = validateParameter(valid_594616, JString, required = false,
                                 default = newJString("1"))
  if valid_594616 != nil:
    section.add "$.xgafv", valid_594616
  var valid_594617 = query.getOrDefault("prettyPrint")
  valid_594617 = validateParameter(valid_594617, JBool, required = false,
                                 default = newJBool(true))
  if valid_594617 != nil:
    section.add "prettyPrint", valid_594617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594618: Call_DataflowProjectsTemplatesGet_594600; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the template associated with a template.
  ## 
  let valid = call_594618.validator(path, query, header, formData, body)
  let scheme = call_594618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594618.url(scheme.get, call_594618.host, call_594618.base,
                         call_594618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594618, url, valid)

proc call*(call_594619: Call_DataflowProjectsTemplatesGet_594600;
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
  var path_594620 = newJObject()
  var query_594621 = newJObject()
  add(query_594621, "upload_protocol", newJString(uploadProtocol))
  add(query_594621, "fields", newJString(fields))
  add(query_594621, "view", newJString(view))
  add(query_594621, "quotaUser", newJString(quotaUser))
  add(query_594621, "alt", newJString(alt))
  add(query_594621, "gcsPath", newJString(gcsPath))
  add(query_594621, "oauth_token", newJString(oauthToken))
  add(query_594621, "callback", newJString(callback))
  add(query_594621, "access_token", newJString(accessToken))
  add(query_594621, "uploadType", newJString(uploadType))
  add(query_594621, "location", newJString(location))
  add(query_594621, "key", newJString(key))
  add(path_594620, "projectId", newJString(projectId))
  add(query_594621, "$.xgafv", newJString(Xgafv))
  add(query_594621, "prettyPrint", newJBool(prettyPrint))
  result = call_594619.call(path_594620, query_594621, nil, nil, nil)

var dataflowProjectsTemplatesGet* = Call_DataflowProjectsTemplatesGet_594600(
    name: "dataflowProjectsTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates:get",
    validator: validate_DataflowProjectsTemplatesGet_594601, base: "/",
    url: url_DataflowProjectsTemplatesGet_594602, schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesLaunch_594622 = ref object of OpenApiRestCall_593421
proc url_DataflowProjectsTemplatesLaunch_594624(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DataflowProjectsTemplatesLaunch_594623(path: JsonNode;
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
  var valid_594625 = path.getOrDefault("projectId")
  valid_594625 = validateParameter(valid_594625, JString, required = true,
                                 default = nil)
  if valid_594625 != nil:
    section.add "projectId", valid_594625
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
  var valid_594626 = query.getOrDefault("upload_protocol")
  valid_594626 = validateParameter(valid_594626, JString, required = false,
                                 default = nil)
  if valid_594626 != nil:
    section.add "upload_protocol", valid_594626
  var valid_594627 = query.getOrDefault("fields")
  valid_594627 = validateParameter(valid_594627, JString, required = false,
                                 default = nil)
  if valid_594627 != nil:
    section.add "fields", valid_594627
  var valid_594628 = query.getOrDefault("quotaUser")
  valid_594628 = validateParameter(valid_594628, JString, required = false,
                                 default = nil)
  if valid_594628 != nil:
    section.add "quotaUser", valid_594628
  var valid_594629 = query.getOrDefault("dynamicTemplate.stagingLocation")
  valid_594629 = validateParameter(valid_594629, JString, required = false,
                                 default = nil)
  if valid_594629 != nil:
    section.add "dynamicTemplate.stagingLocation", valid_594629
  var valid_594630 = query.getOrDefault("alt")
  valid_594630 = validateParameter(valid_594630, JString, required = false,
                                 default = newJString("json"))
  if valid_594630 != nil:
    section.add "alt", valid_594630
  var valid_594631 = query.getOrDefault("dynamicTemplate.gcsPath")
  valid_594631 = validateParameter(valid_594631, JString, required = false,
                                 default = nil)
  if valid_594631 != nil:
    section.add "dynamicTemplate.gcsPath", valid_594631
  var valid_594632 = query.getOrDefault("gcsPath")
  valid_594632 = validateParameter(valid_594632, JString, required = false,
                                 default = nil)
  if valid_594632 != nil:
    section.add "gcsPath", valid_594632
  var valid_594633 = query.getOrDefault("oauth_token")
  valid_594633 = validateParameter(valid_594633, JString, required = false,
                                 default = nil)
  if valid_594633 != nil:
    section.add "oauth_token", valid_594633
  var valid_594634 = query.getOrDefault("callback")
  valid_594634 = validateParameter(valid_594634, JString, required = false,
                                 default = nil)
  if valid_594634 != nil:
    section.add "callback", valid_594634
  var valid_594635 = query.getOrDefault("access_token")
  valid_594635 = validateParameter(valid_594635, JString, required = false,
                                 default = nil)
  if valid_594635 != nil:
    section.add "access_token", valid_594635
  var valid_594636 = query.getOrDefault("uploadType")
  valid_594636 = validateParameter(valid_594636, JString, required = false,
                                 default = nil)
  if valid_594636 != nil:
    section.add "uploadType", valid_594636
  var valid_594637 = query.getOrDefault("location")
  valid_594637 = validateParameter(valid_594637, JString, required = false,
                                 default = nil)
  if valid_594637 != nil:
    section.add "location", valid_594637
  var valid_594638 = query.getOrDefault("validateOnly")
  valid_594638 = validateParameter(valid_594638, JBool, required = false, default = nil)
  if valid_594638 != nil:
    section.add "validateOnly", valid_594638
  var valid_594639 = query.getOrDefault("key")
  valid_594639 = validateParameter(valid_594639, JString, required = false,
                                 default = nil)
  if valid_594639 != nil:
    section.add "key", valid_594639
  var valid_594640 = query.getOrDefault("$.xgafv")
  valid_594640 = validateParameter(valid_594640, JString, required = false,
                                 default = newJString("1"))
  if valid_594640 != nil:
    section.add "$.xgafv", valid_594640
  var valid_594641 = query.getOrDefault("prettyPrint")
  valid_594641 = validateParameter(valid_594641, JBool, required = false,
                                 default = newJBool(true))
  if valid_594641 != nil:
    section.add "prettyPrint", valid_594641
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

proc call*(call_594643: Call_DataflowProjectsTemplatesLaunch_594622;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Launch a template.
  ## 
  let valid = call_594643.validator(path, query, header, formData, body)
  let scheme = call_594643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594643.url(scheme.get, call_594643.host, call_594643.base,
                         call_594643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594643, url, valid)

proc call*(call_594644: Call_DataflowProjectsTemplatesLaunch_594622;
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
  var path_594645 = newJObject()
  var query_594646 = newJObject()
  var body_594647 = newJObject()
  add(query_594646, "upload_protocol", newJString(uploadProtocol))
  add(query_594646, "fields", newJString(fields))
  add(query_594646, "quotaUser", newJString(quotaUser))
  add(query_594646, "dynamicTemplate.stagingLocation",
      newJString(dynamicTemplateStagingLocation))
  add(query_594646, "alt", newJString(alt))
  add(query_594646, "dynamicTemplate.gcsPath", newJString(dynamicTemplateGcsPath))
  add(query_594646, "gcsPath", newJString(gcsPath))
  add(query_594646, "oauth_token", newJString(oauthToken))
  add(query_594646, "callback", newJString(callback))
  add(query_594646, "access_token", newJString(accessToken))
  add(query_594646, "uploadType", newJString(uploadType))
  add(query_594646, "location", newJString(location))
  add(query_594646, "validateOnly", newJBool(validateOnly))
  add(query_594646, "key", newJString(key))
  add(path_594645, "projectId", newJString(projectId))
  add(query_594646, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594647 = body
  add(query_594646, "prettyPrint", newJBool(prettyPrint))
  result = call_594644.call(path_594645, query_594646, nil, nil, body_594647)

var dataflowProjectsTemplatesLaunch* = Call_DataflowProjectsTemplatesLaunch_594622(
    name: "dataflowProjectsTemplatesLaunch", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates:launch",
    validator: validate_DataflowProjectsTemplatesLaunch_594623, base: "/",
    url: url_DataflowProjectsTemplatesLaunch_594624, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
