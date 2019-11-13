
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579373 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579373](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579373): Option[Scheme] {.used.} =
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
  Call_DataflowProjectsWorkerMessages_579644 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsWorkerMessages_579646(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsWorkerMessages_579645(path: JsonNode;
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
  var valid_579772 = path.getOrDefault("projectId")
  valid_579772 = validateParameter(valid_579772, JString, required = true,
                                 default = nil)
  if valid_579772 != nil:
    section.add "projectId", valid_579772
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
  var valid_579773 = query.getOrDefault("key")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "key", valid_579773
  var valid_579787 = query.getOrDefault("prettyPrint")
  valid_579787 = validateParameter(valid_579787, JBool, required = false,
                                 default = newJBool(true))
  if valid_579787 != nil:
    section.add "prettyPrint", valid_579787
  var valid_579788 = query.getOrDefault("oauth_token")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "oauth_token", valid_579788
  var valid_579789 = query.getOrDefault("$.xgafv")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = newJString("1"))
  if valid_579789 != nil:
    section.add "$.xgafv", valid_579789
  var valid_579790 = query.getOrDefault("alt")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = newJString("json"))
  if valid_579790 != nil:
    section.add "alt", valid_579790
  var valid_579791 = query.getOrDefault("uploadType")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "uploadType", valid_579791
  var valid_579792 = query.getOrDefault("quotaUser")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "quotaUser", valid_579792
  var valid_579793 = query.getOrDefault("callback")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "callback", valid_579793
  var valid_579794 = query.getOrDefault("fields")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "fields", valid_579794
  var valid_579795 = query.getOrDefault("access_token")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "access_token", valid_579795
  var valid_579796 = query.getOrDefault("upload_protocol")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "upload_protocol", valid_579796
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

proc call*(call_579820: Call_DataflowProjectsWorkerMessages_579644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send a worker_message to the service.
  ## 
  let valid = call_579820.validator(path, query, header, formData, body)
  let scheme = call_579820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579820.url(scheme.get, call_579820.host, call_579820.base,
                         call_579820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579820, url, valid)

proc call*(call_579891: Call_DataflowProjectsWorkerMessages_579644;
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
  var path_579892 = newJObject()
  var query_579894 = newJObject()
  var body_579895 = newJObject()
  add(query_579894, "key", newJString(key))
  add(query_579894, "prettyPrint", newJBool(prettyPrint))
  add(query_579894, "oauth_token", newJString(oauthToken))
  add(path_579892, "projectId", newJString(projectId))
  add(query_579894, "$.xgafv", newJString(Xgafv))
  add(query_579894, "alt", newJString(alt))
  add(query_579894, "uploadType", newJString(uploadType))
  add(query_579894, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579895 = body
  add(query_579894, "callback", newJString(callback))
  add(query_579894, "fields", newJString(fields))
  add(query_579894, "access_token", newJString(accessToken))
  add(query_579894, "upload_protocol", newJString(uploadProtocol))
  result = call_579891.call(path_579892, query_579894, nil, nil, body_579895)

var dataflowProjectsWorkerMessages* = Call_DataflowProjectsWorkerMessages_579644(
    name: "dataflowProjectsWorkerMessages", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/WorkerMessages",
    validator: validate_DataflowProjectsWorkerMessages_579645, base: "/",
    url: url_DataflowProjectsWorkerMessages_579646, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsCreate_579958 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsJobsCreate_579960(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsJobsCreate_579959(path: JsonNode; query: JsonNode;
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
  var valid_579961 = path.getOrDefault("projectId")
  valid_579961 = validateParameter(valid_579961, JString, required = true,
                                 default = nil)
  if valid_579961 != nil:
    section.add "projectId", valid_579961
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
  var valid_579962 = query.getOrDefault("key")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "key", valid_579962
  var valid_579963 = query.getOrDefault("prettyPrint")
  valid_579963 = validateParameter(valid_579963, JBool, required = false,
                                 default = newJBool(true))
  if valid_579963 != nil:
    section.add "prettyPrint", valid_579963
  var valid_579964 = query.getOrDefault("oauth_token")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "oauth_token", valid_579964
  var valid_579965 = query.getOrDefault("$.xgafv")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = newJString("1"))
  if valid_579965 != nil:
    section.add "$.xgafv", valid_579965
  var valid_579966 = query.getOrDefault("replaceJobId")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "replaceJobId", valid_579966
  var valid_579967 = query.getOrDefault("alt")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = newJString("json"))
  if valid_579967 != nil:
    section.add "alt", valid_579967
  var valid_579968 = query.getOrDefault("uploadType")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "uploadType", valid_579968
  var valid_579969 = query.getOrDefault("quotaUser")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "quotaUser", valid_579969
  var valid_579970 = query.getOrDefault("location")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "location", valid_579970
  var valid_579971 = query.getOrDefault("callback")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "callback", valid_579971
  var valid_579972 = query.getOrDefault("fields")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "fields", valid_579972
  var valid_579973 = query.getOrDefault("access_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "access_token", valid_579973
  var valid_579974 = query.getOrDefault("upload_protocol")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "upload_protocol", valid_579974
  var valid_579975 = query.getOrDefault("view")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_579975 != nil:
    section.add "view", valid_579975
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

proc call*(call_579977: Call_DataflowProjectsJobsCreate_579958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job.
  ## 
  ## To create a job, we recommend using `projects.locations.jobs.create` with a
  ## [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.create` is not recommended, as your job will always start
  ## in `us-central1`.
  ## 
  let valid = call_579977.validator(path, query, header, formData, body)
  let scheme = call_579977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579977.url(scheme.get, call_579977.host, call_579977.base,
                         call_579977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579977, url, valid)

proc call*(call_579978: Call_DataflowProjectsJobsCreate_579958; projectId: string;
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
  var path_579979 = newJObject()
  var query_579980 = newJObject()
  var body_579981 = newJObject()
  add(query_579980, "key", newJString(key))
  add(query_579980, "prettyPrint", newJBool(prettyPrint))
  add(query_579980, "oauth_token", newJString(oauthToken))
  add(path_579979, "projectId", newJString(projectId))
  add(query_579980, "$.xgafv", newJString(Xgafv))
  add(query_579980, "replaceJobId", newJString(replaceJobId))
  add(query_579980, "alt", newJString(alt))
  add(query_579980, "uploadType", newJString(uploadType))
  add(query_579980, "quotaUser", newJString(quotaUser))
  add(query_579980, "location", newJString(location))
  if body != nil:
    body_579981 = body
  add(query_579980, "callback", newJString(callback))
  add(query_579980, "fields", newJString(fields))
  add(query_579980, "access_token", newJString(accessToken))
  add(query_579980, "upload_protocol", newJString(uploadProtocol))
  add(query_579980, "view", newJString(view))
  result = call_579978.call(path_579979, query_579980, nil, nil, body_579981)

var dataflowProjectsJobsCreate* = Call_DataflowProjectsJobsCreate_579958(
    name: "dataflowProjectsJobsCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/jobs",
    validator: validate_DataflowProjectsJobsCreate_579959, base: "/",
    url: url_DataflowProjectsJobsCreate_579960, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsList_579934 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsJobsList_579936(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsJobsList_579935(path: JsonNode; query: JsonNode;
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
  var valid_579937 = path.getOrDefault("projectId")
  valid_579937 = validateParameter(valid_579937, JString, required = true,
                                 default = nil)
  if valid_579937 != nil:
    section.add "projectId", valid_579937
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
  var valid_579938 = query.getOrDefault("key")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "key", valid_579938
  var valid_579939 = query.getOrDefault("prettyPrint")
  valid_579939 = validateParameter(valid_579939, JBool, required = false,
                                 default = newJBool(true))
  if valid_579939 != nil:
    section.add "prettyPrint", valid_579939
  var valid_579940 = query.getOrDefault("oauth_token")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = nil)
  if valid_579940 != nil:
    section.add "oauth_token", valid_579940
  var valid_579941 = query.getOrDefault("$.xgafv")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = newJString("1"))
  if valid_579941 != nil:
    section.add "$.xgafv", valid_579941
  var valid_579942 = query.getOrDefault("pageSize")
  valid_579942 = validateParameter(valid_579942, JInt, required = false, default = nil)
  if valid_579942 != nil:
    section.add "pageSize", valid_579942
  var valid_579943 = query.getOrDefault("alt")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = newJString("json"))
  if valid_579943 != nil:
    section.add "alt", valid_579943
  var valid_579944 = query.getOrDefault("uploadType")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "uploadType", valid_579944
  var valid_579945 = query.getOrDefault("quotaUser")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "quotaUser", valid_579945
  var valid_579946 = query.getOrDefault("filter")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_579946 != nil:
    section.add "filter", valid_579946
  var valid_579947 = query.getOrDefault("pageToken")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "pageToken", valid_579947
  var valid_579948 = query.getOrDefault("location")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "location", valid_579948
  var valid_579949 = query.getOrDefault("callback")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "callback", valid_579949
  var valid_579950 = query.getOrDefault("fields")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "fields", valid_579950
  var valid_579951 = query.getOrDefault("access_token")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "access_token", valid_579951
  var valid_579952 = query.getOrDefault("upload_protocol")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "upload_protocol", valid_579952
  var valid_579953 = query.getOrDefault("view")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_579953 != nil:
    section.add "view", valid_579953
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579954: Call_DataflowProjectsJobsList_579934; path: JsonNode;
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
  let valid = call_579954.validator(path, query, header, formData, body)
  let scheme = call_579954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579954.url(scheme.get, call_579954.host, call_579954.base,
                         call_579954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579954, url, valid)

proc call*(call_579955: Call_DataflowProjectsJobsList_579934; projectId: string;
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
  var path_579956 = newJObject()
  var query_579957 = newJObject()
  add(query_579957, "key", newJString(key))
  add(query_579957, "prettyPrint", newJBool(prettyPrint))
  add(query_579957, "oauth_token", newJString(oauthToken))
  add(path_579956, "projectId", newJString(projectId))
  add(query_579957, "$.xgafv", newJString(Xgafv))
  add(query_579957, "pageSize", newJInt(pageSize))
  add(query_579957, "alt", newJString(alt))
  add(query_579957, "uploadType", newJString(uploadType))
  add(query_579957, "quotaUser", newJString(quotaUser))
  add(query_579957, "filter", newJString(filter))
  add(query_579957, "pageToken", newJString(pageToken))
  add(query_579957, "location", newJString(location))
  add(query_579957, "callback", newJString(callback))
  add(query_579957, "fields", newJString(fields))
  add(query_579957, "access_token", newJString(accessToken))
  add(query_579957, "upload_protocol", newJString(uploadProtocol))
  add(query_579957, "view", newJString(view))
  result = call_579955.call(path_579956, query_579957, nil, nil, nil)

var dataflowProjectsJobsList* = Call_DataflowProjectsJobsList_579934(
    name: "dataflowProjectsJobsList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/jobs",
    validator: validate_DataflowProjectsJobsList_579935, base: "/",
    url: url_DataflowProjectsJobsList_579936, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsUpdate_580004 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsJobsUpdate_580006(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsJobsUpdate_580005(path: JsonNode; query: JsonNode;
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
  var valid_580007 = path.getOrDefault("projectId")
  valid_580007 = validateParameter(valid_580007, JString, required = true,
                                 default = nil)
  if valid_580007 != nil:
    section.add "projectId", valid_580007
  var valid_580008 = path.getOrDefault("jobId")
  valid_580008 = validateParameter(valid_580008, JString, required = true,
                                 default = nil)
  if valid_580008 != nil:
    section.add "jobId", valid_580008
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
  var valid_580009 = query.getOrDefault("key")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "key", valid_580009
  var valid_580010 = query.getOrDefault("prettyPrint")
  valid_580010 = validateParameter(valid_580010, JBool, required = false,
                                 default = newJBool(true))
  if valid_580010 != nil:
    section.add "prettyPrint", valid_580010
  var valid_580011 = query.getOrDefault("oauth_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "oauth_token", valid_580011
  var valid_580012 = query.getOrDefault("$.xgafv")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("1"))
  if valid_580012 != nil:
    section.add "$.xgafv", valid_580012
  var valid_580013 = query.getOrDefault("alt")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("json"))
  if valid_580013 != nil:
    section.add "alt", valid_580013
  var valid_580014 = query.getOrDefault("uploadType")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "uploadType", valid_580014
  var valid_580015 = query.getOrDefault("quotaUser")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "quotaUser", valid_580015
  var valid_580016 = query.getOrDefault("location")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "location", valid_580016
  var valid_580017 = query.getOrDefault("callback")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "callback", valid_580017
  var valid_580018 = query.getOrDefault("fields")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "fields", valid_580018
  var valid_580019 = query.getOrDefault("access_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "access_token", valid_580019
  var valid_580020 = query.getOrDefault("upload_protocol")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "upload_protocol", valid_580020
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

proc call*(call_580022: Call_DataflowProjectsJobsUpdate_580004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the state of an existing Cloud Dataflow job.
  ## 
  ## To update the state of an existing job, we recommend using
  ## `projects.locations.jobs.update` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.update` is not recommended, as you can only update the state
  ## of jobs that are running in `us-central1`.
  ## 
  let valid = call_580022.validator(path, query, header, formData, body)
  let scheme = call_580022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580022.url(scheme.get, call_580022.host, call_580022.base,
                         call_580022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580022, url, valid)

proc call*(call_580023: Call_DataflowProjectsJobsUpdate_580004; projectId: string;
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
  var path_580024 = newJObject()
  var query_580025 = newJObject()
  var body_580026 = newJObject()
  add(query_580025, "key", newJString(key))
  add(query_580025, "prettyPrint", newJBool(prettyPrint))
  add(query_580025, "oauth_token", newJString(oauthToken))
  add(path_580024, "projectId", newJString(projectId))
  add(path_580024, "jobId", newJString(jobId))
  add(query_580025, "$.xgafv", newJString(Xgafv))
  add(query_580025, "alt", newJString(alt))
  add(query_580025, "uploadType", newJString(uploadType))
  add(query_580025, "quotaUser", newJString(quotaUser))
  add(query_580025, "location", newJString(location))
  if body != nil:
    body_580026 = body
  add(query_580025, "callback", newJString(callback))
  add(query_580025, "fields", newJString(fields))
  add(query_580025, "access_token", newJString(accessToken))
  add(query_580025, "upload_protocol", newJString(uploadProtocol))
  result = call_580023.call(path_580024, query_580025, nil, nil, body_580026)

var dataflowProjectsJobsUpdate* = Call_DataflowProjectsJobsUpdate_580004(
    name: "dataflowProjectsJobsUpdate", meth: HttpMethod.HttpPut,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataflowProjectsJobsUpdate_580005, base: "/",
    url: url_DataflowProjectsJobsUpdate_580006, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsGet_579982 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsJobsGet_579984(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsJobsGet_579983(path: JsonNode; query: JsonNode;
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
  var valid_579985 = path.getOrDefault("projectId")
  valid_579985 = validateParameter(valid_579985, JString, required = true,
                                 default = nil)
  if valid_579985 != nil:
    section.add "projectId", valid_579985
  var valid_579986 = path.getOrDefault("jobId")
  valid_579986 = validateParameter(valid_579986, JString, required = true,
                                 default = nil)
  if valid_579986 != nil:
    section.add "jobId", valid_579986
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
  var valid_579987 = query.getOrDefault("key")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "key", valid_579987
  var valid_579988 = query.getOrDefault("prettyPrint")
  valid_579988 = validateParameter(valid_579988, JBool, required = false,
                                 default = newJBool(true))
  if valid_579988 != nil:
    section.add "prettyPrint", valid_579988
  var valid_579989 = query.getOrDefault("oauth_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "oauth_token", valid_579989
  var valid_579990 = query.getOrDefault("$.xgafv")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = newJString("1"))
  if valid_579990 != nil:
    section.add "$.xgafv", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("uploadType")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "uploadType", valid_579992
  var valid_579993 = query.getOrDefault("quotaUser")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "quotaUser", valid_579993
  var valid_579994 = query.getOrDefault("location")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "location", valid_579994
  var valid_579995 = query.getOrDefault("callback")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "callback", valid_579995
  var valid_579996 = query.getOrDefault("fields")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "fields", valid_579996
  var valid_579997 = query.getOrDefault("access_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "access_token", valid_579997
  var valid_579998 = query.getOrDefault("upload_protocol")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "upload_protocol", valid_579998
  var valid_579999 = query.getOrDefault("view")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_579999 != nil:
    section.add "view", valid_579999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580000: Call_DataflowProjectsJobsGet_579982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the state of the specified Cloud Dataflow job.
  ## 
  ## To get the state of a job, we recommend using `projects.locations.jobs.get`
  ## with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.get` is not recommended, as you can only get the state of
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

proc call*(call_580001: Call_DataflowProjectsJobsGet_579982; projectId: string;
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
  var path_580002 = newJObject()
  var query_580003 = newJObject()
  add(query_580003, "key", newJString(key))
  add(query_580003, "prettyPrint", newJBool(prettyPrint))
  add(query_580003, "oauth_token", newJString(oauthToken))
  add(path_580002, "projectId", newJString(projectId))
  add(path_580002, "jobId", newJString(jobId))
  add(query_580003, "$.xgafv", newJString(Xgafv))
  add(query_580003, "alt", newJString(alt))
  add(query_580003, "uploadType", newJString(uploadType))
  add(query_580003, "quotaUser", newJString(quotaUser))
  add(query_580003, "location", newJString(location))
  add(query_580003, "callback", newJString(callback))
  add(query_580003, "fields", newJString(fields))
  add(query_580003, "access_token", newJString(accessToken))
  add(query_580003, "upload_protocol", newJString(uploadProtocol))
  add(query_580003, "view", newJString(view))
  result = call_580001.call(path_580002, query_580003, nil, nil, nil)

var dataflowProjectsJobsGet* = Call_DataflowProjectsJobsGet_579982(
    name: "dataflowProjectsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}",
    validator: validate_DataflowProjectsJobsGet_579983, base: "/",
    url: url_DataflowProjectsJobsGet_579984, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsDebugGetConfig_580027 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsJobsDebugGetConfig_580029(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsJobsDebugGetConfig_580028(path: JsonNode;
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
  var valid_580030 = path.getOrDefault("projectId")
  valid_580030 = validateParameter(valid_580030, JString, required = true,
                                 default = nil)
  if valid_580030 != nil:
    section.add "projectId", valid_580030
  var valid_580031 = path.getOrDefault("jobId")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "jobId", valid_580031
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
  var valid_580032 = query.getOrDefault("key")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "key", valid_580032
  var valid_580033 = query.getOrDefault("prettyPrint")
  valid_580033 = validateParameter(valid_580033, JBool, required = false,
                                 default = newJBool(true))
  if valid_580033 != nil:
    section.add "prettyPrint", valid_580033
  var valid_580034 = query.getOrDefault("oauth_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "oauth_token", valid_580034
  var valid_580035 = query.getOrDefault("$.xgafv")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("1"))
  if valid_580035 != nil:
    section.add "$.xgafv", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("uploadType")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "uploadType", valid_580037
  var valid_580038 = query.getOrDefault("quotaUser")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "quotaUser", valid_580038
  var valid_580039 = query.getOrDefault("callback")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "callback", valid_580039
  var valid_580040 = query.getOrDefault("fields")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "fields", valid_580040
  var valid_580041 = query.getOrDefault("access_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "access_token", valid_580041
  var valid_580042 = query.getOrDefault("upload_protocol")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "upload_protocol", valid_580042
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

proc call*(call_580044: Call_DataflowProjectsJobsDebugGetConfig_580027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get encoded debug configuration for component. Not cacheable.
  ## 
  let valid = call_580044.validator(path, query, header, formData, body)
  let scheme = call_580044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580044.url(scheme.get, call_580044.host, call_580044.base,
                         call_580044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580044, url, valid)

proc call*(call_580045: Call_DataflowProjectsJobsDebugGetConfig_580027;
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
  var path_580046 = newJObject()
  var query_580047 = newJObject()
  var body_580048 = newJObject()
  add(query_580047, "key", newJString(key))
  add(query_580047, "prettyPrint", newJBool(prettyPrint))
  add(query_580047, "oauth_token", newJString(oauthToken))
  add(path_580046, "projectId", newJString(projectId))
  add(path_580046, "jobId", newJString(jobId))
  add(query_580047, "$.xgafv", newJString(Xgafv))
  add(query_580047, "alt", newJString(alt))
  add(query_580047, "uploadType", newJString(uploadType))
  add(query_580047, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580048 = body
  add(query_580047, "callback", newJString(callback))
  add(query_580047, "fields", newJString(fields))
  add(query_580047, "access_token", newJString(accessToken))
  add(query_580047, "upload_protocol", newJString(uploadProtocol))
  result = call_580045.call(path_580046, query_580047, nil, nil, body_580048)

var dataflowProjectsJobsDebugGetConfig* = Call_DataflowProjectsJobsDebugGetConfig_580027(
    name: "dataflowProjectsJobsDebugGetConfig", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/debug/getConfig",
    validator: validate_DataflowProjectsJobsDebugGetConfig_580028, base: "/",
    url: url_DataflowProjectsJobsDebugGetConfig_580029, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsDebugSendCapture_580049 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsJobsDebugSendCapture_580051(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsJobsDebugSendCapture_580050(path: JsonNode;
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
  var valid_580052 = path.getOrDefault("projectId")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "projectId", valid_580052
  var valid_580053 = path.getOrDefault("jobId")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "jobId", valid_580053
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
  var valid_580054 = query.getOrDefault("key")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "key", valid_580054
  var valid_580055 = query.getOrDefault("prettyPrint")
  valid_580055 = validateParameter(valid_580055, JBool, required = false,
                                 default = newJBool(true))
  if valid_580055 != nil:
    section.add "prettyPrint", valid_580055
  var valid_580056 = query.getOrDefault("oauth_token")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "oauth_token", valid_580056
  var valid_580057 = query.getOrDefault("$.xgafv")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("1"))
  if valid_580057 != nil:
    section.add "$.xgafv", valid_580057
  var valid_580058 = query.getOrDefault("alt")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("json"))
  if valid_580058 != nil:
    section.add "alt", valid_580058
  var valid_580059 = query.getOrDefault("uploadType")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "uploadType", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("callback")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "callback", valid_580061
  var valid_580062 = query.getOrDefault("fields")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "fields", valid_580062
  var valid_580063 = query.getOrDefault("access_token")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "access_token", valid_580063
  var valid_580064 = query.getOrDefault("upload_protocol")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "upload_protocol", valid_580064
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

proc call*(call_580066: Call_DataflowProjectsJobsDebugSendCapture_580049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send encoded debug capture data for component.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_DataflowProjectsJobsDebugSendCapture_580049;
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
  var path_580068 = newJObject()
  var query_580069 = newJObject()
  var body_580070 = newJObject()
  add(query_580069, "key", newJString(key))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(path_580068, "projectId", newJString(projectId))
  add(path_580068, "jobId", newJString(jobId))
  add(query_580069, "$.xgafv", newJString(Xgafv))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "uploadType", newJString(uploadType))
  add(query_580069, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580070 = body
  add(query_580069, "callback", newJString(callback))
  add(query_580069, "fields", newJString(fields))
  add(query_580069, "access_token", newJString(accessToken))
  add(query_580069, "upload_protocol", newJString(uploadProtocol))
  result = call_580067.call(path_580068, query_580069, nil, nil, body_580070)

var dataflowProjectsJobsDebugSendCapture* = Call_DataflowProjectsJobsDebugSendCapture_580049(
    name: "dataflowProjectsJobsDebugSendCapture", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/debug/sendCapture",
    validator: validate_DataflowProjectsJobsDebugSendCapture_580050, base: "/",
    url: url_DataflowProjectsJobsDebugSendCapture_580051, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsMessagesList_580071 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsJobsMessagesList_580073(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsJobsMessagesList_580072(path: JsonNode;
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
  var valid_580074 = path.getOrDefault("projectId")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "projectId", valid_580074
  var valid_580075 = path.getOrDefault("jobId")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "jobId", valid_580075
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
  var valid_580076 = query.getOrDefault("key")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "key", valid_580076
  var valid_580077 = query.getOrDefault("prettyPrint")
  valid_580077 = validateParameter(valid_580077, JBool, required = false,
                                 default = newJBool(true))
  if valid_580077 != nil:
    section.add "prettyPrint", valid_580077
  var valid_580078 = query.getOrDefault("oauth_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "oauth_token", valid_580078
  var valid_580079 = query.getOrDefault("minimumImportance")
  valid_580079 = validateParameter(valid_580079, JString, required = false, default = newJString(
      "JOB_MESSAGE_IMPORTANCE_UNKNOWN"))
  if valid_580079 != nil:
    section.add "minimumImportance", valid_580079
  var valid_580080 = query.getOrDefault("$.xgafv")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = newJString("1"))
  if valid_580080 != nil:
    section.add "$.xgafv", valid_580080
  var valid_580081 = query.getOrDefault("pageSize")
  valid_580081 = validateParameter(valid_580081, JInt, required = false, default = nil)
  if valid_580081 != nil:
    section.add "pageSize", valid_580081
  var valid_580082 = query.getOrDefault("startTime")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "startTime", valid_580082
  var valid_580083 = query.getOrDefault("alt")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = newJString("json"))
  if valid_580083 != nil:
    section.add "alt", valid_580083
  var valid_580084 = query.getOrDefault("uploadType")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "uploadType", valid_580084
  var valid_580085 = query.getOrDefault("quotaUser")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "quotaUser", valid_580085
  var valid_580086 = query.getOrDefault("pageToken")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "pageToken", valid_580086
  var valid_580087 = query.getOrDefault("location")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "location", valid_580087
  var valid_580088 = query.getOrDefault("callback")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "callback", valid_580088
  var valid_580089 = query.getOrDefault("fields")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "fields", valid_580089
  var valid_580090 = query.getOrDefault("access_token")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "access_token", valid_580090
  var valid_580091 = query.getOrDefault("upload_protocol")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "upload_protocol", valid_580091
  var valid_580092 = query.getOrDefault("endTime")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "endTime", valid_580092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580093: Call_DataflowProjectsJobsMessagesList_580071;
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
  let valid = call_580093.validator(path, query, header, formData, body)
  let scheme = call_580093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580093.url(scheme.get, call_580093.host, call_580093.base,
                         call_580093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580093, url, valid)

proc call*(call_580094: Call_DataflowProjectsJobsMessagesList_580071;
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
  var path_580095 = newJObject()
  var query_580096 = newJObject()
  add(query_580096, "key", newJString(key))
  add(query_580096, "prettyPrint", newJBool(prettyPrint))
  add(query_580096, "oauth_token", newJString(oauthToken))
  add(query_580096, "minimumImportance", newJString(minimumImportance))
  add(path_580095, "projectId", newJString(projectId))
  add(path_580095, "jobId", newJString(jobId))
  add(query_580096, "$.xgafv", newJString(Xgafv))
  add(query_580096, "pageSize", newJInt(pageSize))
  add(query_580096, "startTime", newJString(startTime))
  add(query_580096, "alt", newJString(alt))
  add(query_580096, "uploadType", newJString(uploadType))
  add(query_580096, "quotaUser", newJString(quotaUser))
  add(query_580096, "pageToken", newJString(pageToken))
  add(query_580096, "location", newJString(location))
  add(query_580096, "callback", newJString(callback))
  add(query_580096, "fields", newJString(fields))
  add(query_580096, "access_token", newJString(accessToken))
  add(query_580096, "upload_protocol", newJString(uploadProtocol))
  add(query_580096, "endTime", newJString(endTime))
  result = call_580094.call(path_580095, query_580096, nil, nil, nil)

var dataflowProjectsJobsMessagesList* = Call_DataflowProjectsJobsMessagesList_580071(
    name: "dataflowProjectsJobsMessagesList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/messages",
    validator: validate_DataflowProjectsJobsMessagesList_580072, base: "/",
    url: url_DataflowProjectsJobsMessagesList_580073, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsGetMetrics_580097 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsJobsGetMetrics_580099(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsJobsGetMetrics_580098(path: JsonNode;
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
  var valid_580100 = path.getOrDefault("projectId")
  valid_580100 = validateParameter(valid_580100, JString, required = true,
                                 default = nil)
  if valid_580100 != nil:
    section.add "projectId", valid_580100
  var valid_580101 = path.getOrDefault("jobId")
  valid_580101 = validateParameter(valid_580101, JString, required = true,
                                 default = nil)
  if valid_580101 != nil:
    section.add "jobId", valid_580101
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
  var valid_580102 = query.getOrDefault("key")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "key", valid_580102
  var valid_580103 = query.getOrDefault("prettyPrint")
  valid_580103 = validateParameter(valid_580103, JBool, required = false,
                                 default = newJBool(true))
  if valid_580103 != nil:
    section.add "prettyPrint", valid_580103
  var valid_580104 = query.getOrDefault("oauth_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "oauth_token", valid_580104
  var valid_580105 = query.getOrDefault("$.xgafv")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = newJString("1"))
  if valid_580105 != nil:
    section.add "$.xgafv", valid_580105
  var valid_580106 = query.getOrDefault("startTime")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "startTime", valid_580106
  var valid_580107 = query.getOrDefault("alt")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = newJString("json"))
  if valid_580107 != nil:
    section.add "alt", valid_580107
  var valid_580108 = query.getOrDefault("uploadType")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "uploadType", valid_580108
  var valid_580109 = query.getOrDefault("quotaUser")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "quotaUser", valid_580109
  var valid_580110 = query.getOrDefault("location")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "location", valid_580110
  var valid_580111 = query.getOrDefault("callback")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "callback", valid_580111
  var valid_580112 = query.getOrDefault("fields")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "fields", valid_580112
  var valid_580113 = query.getOrDefault("access_token")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "access_token", valid_580113
  var valid_580114 = query.getOrDefault("upload_protocol")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "upload_protocol", valid_580114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580115: Call_DataflowProjectsJobsGetMetrics_580097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Request the job status.
  ## 
  ## To request the status of a job, we recommend using
  ## `projects.locations.jobs.getMetrics` with a [regional endpoint]
  ## (https://cloud.google.com/dataflow/docs/concepts/regional-endpoints). Using
  ## `projects.jobs.getMetrics` is not recommended, as you can only request the
  ## status of jobs that are running in `us-central1`.
  ## 
  let valid = call_580115.validator(path, query, header, formData, body)
  let scheme = call_580115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580115.url(scheme.get, call_580115.host, call_580115.base,
                         call_580115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580115, url, valid)

proc call*(call_580116: Call_DataflowProjectsJobsGetMetrics_580097;
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
  var path_580117 = newJObject()
  var query_580118 = newJObject()
  add(query_580118, "key", newJString(key))
  add(query_580118, "prettyPrint", newJBool(prettyPrint))
  add(query_580118, "oauth_token", newJString(oauthToken))
  add(path_580117, "projectId", newJString(projectId))
  add(path_580117, "jobId", newJString(jobId))
  add(query_580118, "$.xgafv", newJString(Xgafv))
  add(query_580118, "startTime", newJString(startTime))
  add(query_580118, "alt", newJString(alt))
  add(query_580118, "uploadType", newJString(uploadType))
  add(query_580118, "quotaUser", newJString(quotaUser))
  add(query_580118, "location", newJString(location))
  add(query_580118, "callback", newJString(callback))
  add(query_580118, "fields", newJString(fields))
  add(query_580118, "access_token", newJString(accessToken))
  add(query_580118, "upload_protocol", newJString(uploadProtocol))
  result = call_580116.call(path_580117, query_580118, nil, nil, nil)

var dataflowProjectsJobsGetMetrics* = Call_DataflowProjectsJobsGetMetrics_580097(
    name: "dataflowProjectsJobsGetMetrics", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/metrics",
    validator: validate_DataflowProjectsJobsGetMetrics_580098, base: "/",
    url: url_DataflowProjectsJobsGetMetrics_580099, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsWorkItemsLease_580119 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsJobsWorkItemsLease_580121(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsJobsWorkItemsLease_580120(path: JsonNode;
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
  var valid_580122 = path.getOrDefault("projectId")
  valid_580122 = validateParameter(valid_580122, JString, required = true,
                                 default = nil)
  if valid_580122 != nil:
    section.add "projectId", valid_580122
  var valid_580123 = path.getOrDefault("jobId")
  valid_580123 = validateParameter(valid_580123, JString, required = true,
                                 default = nil)
  if valid_580123 != nil:
    section.add "jobId", valid_580123
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
  var valid_580124 = query.getOrDefault("key")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "key", valid_580124
  var valid_580125 = query.getOrDefault("prettyPrint")
  valid_580125 = validateParameter(valid_580125, JBool, required = false,
                                 default = newJBool(true))
  if valid_580125 != nil:
    section.add "prettyPrint", valid_580125
  var valid_580126 = query.getOrDefault("oauth_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "oauth_token", valid_580126
  var valid_580127 = query.getOrDefault("$.xgafv")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = newJString("1"))
  if valid_580127 != nil:
    section.add "$.xgafv", valid_580127
  var valid_580128 = query.getOrDefault("alt")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = newJString("json"))
  if valid_580128 != nil:
    section.add "alt", valid_580128
  var valid_580129 = query.getOrDefault("uploadType")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "uploadType", valid_580129
  var valid_580130 = query.getOrDefault("quotaUser")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "quotaUser", valid_580130
  var valid_580131 = query.getOrDefault("callback")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "callback", valid_580131
  var valid_580132 = query.getOrDefault("fields")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "fields", valid_580132
  var valid_580133 = query.getOrDefault("access_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "access_token", valid_580133
  var valid_580134 = query.getOrDefault("upload_protocol")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "upload_protocol", valid_580134
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

proc call*(call_580136: Call_DataflowProjectsJobsWorkItemsLease_580119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Leases a dataflow WorkItem to run.
  ## 
  let valid = call_580136.validator(path, query, header, formData, body)
  let scheme = call_580136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580136.url(scheme.get, call_580136.host, call_580136.base,
                         call_580136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580136, url, valid)

proc call*(call_580137: Call_DataflowProjectsJobsWorkItemsLease_580119;
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
  var path_580138 = newJObject()
  var query_580139 = newJObject()
  var body_580140 = newJObject()
  add(query_580139, "key", newJString(key))
  add(query_580139, "prettyPrint", newJBool(prettyPrint))
  add(query_580139, "oauth_token", newJString(oauthToken))
  add(path_580138, "projectId", newJString(projectId))
  add(path_580138, "jobId", newJString(jobId))
  add(query_580139, "$.xgafv", newJString(Xgafv))
  add(query_580139, "alt", newJString(alt))
  add(query_580139, "uploadType", newJString(uploadType))
  add(query_580139, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580140 = body
  add(query_580139, "callback", newJString(callback))
  add(query_580139, "fields", newJString(fields))
  add(query_580139, "access_token", newJString(accessToken))
  add(query_580139, "upload_protocol", newJString(uploadProtocol))
  result = call_580137.call(path_580138, query_580139, nil, nil, body_580140)

var dataflowProjectsJobsWorkItemsLease* = Call_DataflowProjectsJobsWorkItemsLease_580119(
    name: "dataflowProjectsJobsWorkItemsLease", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/workItems:lease",
    validator: validate_DataflowProjectsJobsWorkItemsLease_580120, base: "/",
    url: url_DataflowProjectsJobsWorkItemsLease_580121, schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsWorkItemsReportStatus_580141 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsJobsWorkItemsReportStatus_580143(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsJobsWorkItemsReportStatus_580142(path: JsonNode;
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
  var valid_580144 = path.getOrDefault("projectId")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "projectId", valid_580144
  var valid_580145 = path.getOrDefault("jobId")
  valid_580145 = validateParameter(valid_580145, JString, required = true,
                                 default = nil)
  if valid_580145 != nil:
    section.add "jobId", valid_580145
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
  var valid_580146 = query.getOrDefault("key")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "key", valid_580146
  var valid_580147 = query.getOrDefault("prettyPrint")
  valid_580147 = validateParameter(valid_580147, JBool, required = false,
                                 default = newJBool(true))
  if valid_580147 != nil:
    section.add "prettyPrint", valid_580147
  var valid_580148 = query.getOrDefault("oauth_token")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "oauth_token", valid_580148
  var valid_580149 = query.getOrDefault("$.xgafv")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = newJString("1"))
  if valid_580149 != nil:
    section.add "$.xgafv", valid_580149
  var valid_580150 = query.getOrDefault("alt")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("json"))
  if valid_580150 != nil:
    section.add "alt", valid_580150
  var valid_580151 = query.getOrDefault("uploadType")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "uploadType", valid_580151
  var valid_580152 = query.getOrDefault("quotaUser")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "quotaUser", valid_580152
  var valid_580153 = query.getOrDefault("callback")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "callback", valid_580153
  var valid_580154 = query.getOrDefault("fields")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "fields", valid_580154
  var valid_580155 = query.getOrDefault("access_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "access_token", valid_580155
  var valid_580156 = query.getOrDefault("upload_protocol")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "upload_protocol", valid_580156
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

proc call*(call_580158: Call_DataflowProjectsJobsWorkItemsReportStatus_580141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports the status of dataflow WorkItems leased by a worker.
  ## 
  let valid = call_580158.validator(path, query, header, formData, body)
  let scheme = call_580158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580158.url(scheme.get, call_580158.host, call_580158.base,
                         call_580158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580158, url, valid)

proc call*(call_580159: Call_DataflowProjectsJobsWorkItemsReportStatus_580141;
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
  var path_580160 = newJObject()
  var query_580161 = newJObject()
  var body_580162 = newJObject()
  add(query_580161, "key", newJString(key))
  add(query_580161, "prettyPrint", newJBool(prettyPrint))
  add(query_580161, "oauth_token", newJString(oauthToken))
  add(path_580160, "projectId", newJString(projectId))
  add(path_580160, "jobId", newJString(jobId))
  add(query_580161, "$.xgafv", newJString(Xgafv))
  add(query_580161, "alt", newJString(alt))
  add(query_580161, "uploadType", newJString(uploadType))
  add(query_580161, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580162 = body
  add(query_580161, "callback", newJString(callback))
  add(query_580161, "fields", newJString(fields))
  add(query_580161, "access_token", newJString(accessToken))
  add(query_580161, "upload_protocol", newJString(uploadProtocol))
  result = call_580159.call(path_580160, query_580161, nil, nil, body_580162)

var dataflowProjectsJobsWorkItemsReportStatus* = Call_DataflowProjectsJobsWorkItemsReportStatus_580141(
    name: "dataflowProjectsJobsWorkItemsReportStatus", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs/{jobId}/workItems:reportStatus",
    validator: validate_DataflowProjectsJobsWorkItemsReportStatus_580142,
    base: "/", url: url_DataflowProjectsJobsWorkItemsReportStatus_580143,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsJobsAggregated_580163 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsJobsAggregated_580165(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsJobsAggregated_580164(path: JsonNode;
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
  var valid_580166 = path.getOrDefault("projectId")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = nil)
  if valid_580166 != nil:
    section.add "projectId", valid_580166
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
  var valid_580167 = query.getOrDefault("key")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "key", valid_580167
  var valid_580168 = query.getOrDefault("prettyPrint")
  valid_580168 = validateParameter(valid_580168, JBool, required = false,
                                 default = newJBool(true))
  if valid_580168 != nil:
    section.add "prettyPrint", valid_580168
  var valid_580169 = query.getOrDefault("oauth_token")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "oauth_token", valid_580169
  var valid_580170 = query.getOrDefault("$.xgafv")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("1"))
  if valid_580170 != nil:
    section.add "$.xgafv", valid_580170
  var valid_580171 = query.getOrDefault("pageSize")
  valid_580171 = validateParameter(valid_580171, JInt, required = false, default = nil)
  if valid_580171 != nil:
    section.add "pageSize", valid_580171
  var valid_580172 = query.getOrDefault("alt")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = newJString("json"))
  if valid_580172 != nil:
    section.add "alt", valid_580172
  var valid_580173 = query.getOrDefault("uploadType")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "uploadType", valid_580173
  var valid_580174 = query.getOrDefault("quotaUser")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "quotaUser", valid_580174
  var valid_580175 = query.getOrDefault("filter")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_580175 != nil:
    section.add "filter", valid_580175
  var valid_580176 = query.getOrDefault("pageToken")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "pageToken", valid_580176
  var valid_580177 = query.getOrDefault("location")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "location", valid_580177
  var valid_580178 = query.getOrDefault("callback")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "callback", valid_580178
  var valid_580179 = query.getOrDefault("fields")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "fields", valid_580179
  var valid_580180 = query.getOrDefault("access_token")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "access_token", valid_580180
  var valid_580181 = query.getOrDefault("upload_protocol")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "upload_protocol", valid_580181
  var valid_580182 = query.getOrDefault("view")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_580182 != nil:
    section.add "view", valid_580182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580183: Call_DataflowProjectsJobsAggregated_580163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the jobs of a project across all regions.
  ## 
  let valid = call_580183.validator(path, query, header, formData, body)
  let scheme = call_580183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580183.url(scheme.get, call_580183.host, call_580183.base,
                         call_580183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580183, url, valid)

proc call*(call_580184: Call_DataflowProjectsJobsAggregated_580163;
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
  var path_580185 = newJObject()
  var query_580186 = newJObject()
  add(query_580186, "key", newJString(key))
  add(query_580186, "prettyPrint", newJBool(prettyPrint))
  add(query_580186, "oauth_token", newJString(oauthToken))
  add(path_580185, "projectId", newJString(projectId))
  add(query_580186, "$.xgafv", newJString(Xgafv))
  add(query_580186, "pageSize", newJInt(pageSize))
  add(query_580186, "alt", newJString(alt))
  add(query_580186, "uploadType", newJString(uploadType))
  add(query_580186, "quotaUser", newJString(quotaUser))
  add(query_580186, "filter", newJString(filter))
  add(query_580186, "pageToken", newJString(pageToken))
  add(query_580186, "location", newJString(location))
  add(query_580186, "callback", newJString(callback))
  add(query_580186, "fields", newJString(fields))
  add(query_580186, "access_token", newJString(accessToken))
  add(query_580186, "upload_protocol", newJString(uploadProtocol))
  add(query_580186, "view", newJString(view))
  result = call_580184.call(path_580185, query_580186, nil, nil, nil)

var dataflowProjectsJobsAggregated* = Call_DataflowProjectsJobsAggregated_580163(
    name: "dataflowProjectsJobsAggregated", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/jobs:aggregated",
    validator: validate_DataflowProjectsJobsAggregated_580164, base: "/",
    url: url_DataflowProjectsJobsAggregated_580165, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsWorkerMessages_580187 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsWorkerMessages_580189(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsWorkerMessages_580188(path: JsonNode;
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
  var valid_580190 = path.getOrDefault("projectId")
  valid_580190 = validateParameter(valid_580190, JString, required = true,
                                 default = nil)
  if valid_580190 != nil:
    section.add "projectId", valid_580190
  var valid_580191 = path.getOrDefault("location")
  valid_580191 = validateParameter(valid_580191, JString, required = true,
                                 default = nil)
  if valid_580191 != nil:
    section.add "location", valid_580191
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
  var valid_580192 = query.getOrDefault("key")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "key", valid_580192
  var valid_580193 = query.getOrDefault("prettyPrint")
  valid_580193 = validateParameter(valid_580193, JBool, required = false,
                                 default = newJBool(true))
  if valid_580193 != nil:
    section.add "prettyPrint", valid_580193
  var valid_580194 = query.getOrDefault("oauth_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "oauth_token", valid_580194
  var valid_580195 = query.getOrDefault("$.xgafv")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = newJString("1"))
  if valid_580195 != nil:
    section.add "$.xgafv", valid_580195
  var valid_580196 = query.getOrDefault("alt")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = newJString("json"))
  if valid_580196 != nil:
    section.add "alt", valid_580196
  var valid_580197 = query.getOrDefault("uploadType")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "uploadType", valid_580197
  var valid_580198 = query.getOrDefault("quotaUser")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "quotaUser", valid_580198
  var valid_580199 = query.getOrDefault("callback")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "callback", valid_580199
  var valid_580200 = query.getOrDefault("fields")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "fields", valid_580200
  var valid_580201 = query.getOrDefault("access_token")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "access_token", valid_580201
  var valid_580202 = query.getOrDefault("upload_protocol")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "upload_protocol", valid_580202
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

proc call*(call_580204: Call_DataflowProjectsLocationsWorkerMessages_580187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send a worker_message to the service.
  ## 
  let valid = call_580204.validator(path, query, header, formData, body)
  let scheme = call_580204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580204.url(scheme.get, call_580204.host, call_580204.base,
                         call_580204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580204, url, valid)

proc call*(call_580205: Call_DataflowProjectsLocationsWorkerMessages_580187;
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
  var path_580206 = newJObject()
  var query_580207 = newJObject()
  var body_580208 = newJObject()
  add(query_580207, "key", newJString(key))
  add(query_580207, "prettyPrint", newJBool(prettyPrint))
  add(query_580207, "oauth_token", newJString(oauthToken))
  add(path_580206, "projectId", newJString(projectId))
  add(query_580207, "$.xgafv", newJString(Xgafv))
  add(query_580207, "alt", newJString(alt))
  add(query_580207, "uploadType", newJString(uploadType))
  add(query_580207, "quotaUser", newJString(quotaUser))
  add(path_580206, "location", newJString(location))
  if body != nil:
    body_580208 = body
  add(query_580207, "callback", newJString(callback))
  add(query_580207, "fields", newJString(fields))
  add(query_580207, "access_token", newJString(accessToken))
  add(query_580207, "upload_protocol", newJString(uploadProtocol))
  result = call_580205.call(path_580206, query_580207, nil, nil, body_580208)

var dataflowProjectsLocationsWorkerMessages* = Call_DataflowProjectsLocationsWorkerMessages_580187(
    name: "dataflowProjectsLocationsWorkerMessages", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/WorkerMessages",
    validator: validate_DataflowProjectsLocationsWorkerMessages_580188, base: "/",
    url: url_DataflowProjectsLocationsWorkerMessages_580189,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsCreate_580233 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsJobsCreate_580235(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsCreate_580234(path: JsonNode;
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
  var valid_580238 = query.getOrDefault("key")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "key", valid_580238
  var valid_580239 = query.getOrDefault("prettyPrint")
  valid_580239 = validateParameter(valid_580239, JBool, required = false,
                                 default = newJBool(true))
  if valid_580239 != nil:
    section.add "prettyPrint", valid_580239
  var valid_580240 = query.getOrDefault("oauth_token")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "oauth_token", valid_580240
  var valid_580241 = query.getOrDefault("$.xgafv")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = newJString("1"))
  if valid_580241 != nil:
    section.add "$.xgafv", valid_580241
  var valid_580242 = query.getOrDefault("replaceJobId")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "replaceJobId", valid_580242
  var valid_580243 = query.getOrDefault("alt")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = newJString("json"))
  if valid_580243 != nil:
    section.add "alt", valid_580243
  var valid_580244 = query.getOrDefault("uploadType")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "uploadType", valid_580244
  var valid_580245 = query.getOrDefault("quotaUser")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "quotaUser", valid_580245
  var valid_580246 = query.getOrDefault("callback")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "callback", valid_580246
  var valid_580247 = query.getOrDefault("fields")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "fields", valid_580247
  var valid_580248 = query.getOrDefault("access_token")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "access_token", valid_580248
  var valid_580249 = query.getOrDefault("upload_protocol")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "upload_protocol", valid_580249
  var valid_580250 = query.getOrDefault("view")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_580250 != nil:
    section.add "view", valid_580250
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

proc call*(call_580252: Call_DataflowProjectsLocationsJobsCreate_580233;
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
  let valid = call_580252.validator(path, query, header, formData, body)
  let scheme = call_580252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580252.url(scheme.get, call_580252.host, call_580252.base,
                         call_580252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580252, url, valid)

proc call*(call_580253: Call_DataflowProjectsLocationsJobsCreate_580233;
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
  var path_580254 = newJObject()
  var query_580255 = newJObject()
  var body_580256 = newJObject()
  add(query_580255, "key", newJString(key))
  add(query_580255, "prettyPrint", newJBool(prettyPrint))
  add(query_580255, "oauth_token", newJString(oauthToken))
  add(path_580254, "projectId", newJString(projectId))
  add(query_580255, "$.xgafv", newJString(Xgafv))
  add(query_580255, "replaceJobId", newJString(replaceJobId))
  add(query_580255, "alt", newJString(alt))
  add(query_580255, "uploadType", newJString(uploadType))
  add(query_580255, "quotaUser", newJString(quotaUser))
  add(path_580254, "location", newJString(location))
  if body != nil:
    body_580256 = body
  add(query_580255, "callback", newJString(callback))
  add(query_580255, "fields", newJString(fields))
  add(query_580255, "access_token", newJString(accessToken))
  add(query_580255, "upload_protocol", newJString(uploadProtocol))
  add(query_580255, "view", newJString(view))
  result = call_580253.call(path_580254, query_580255, nil, nil, body_580256)

var dataflowProjectsLocationsJobsCreate* = Call_DataflowProjectsLocationsJobsCreate_580233(
    name: "dataflowProjectsLocationsJobsCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs",
    validator: validate_DataflowProjectsLocationsJobsCreate_580234, base: "/",
    url: url_DataflowProjectsLocationsJobsCreate_580235, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsList_580209 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsJobsList_580211(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsList_580210(path: JsonNode;
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
  var valid_580212 = path.getOrDefault("projectId")
  valid_580212 = validateParameter(valid_580212, JString, required = true,
                                 default = nil)
  if valid_580212 != nil:
    section.add "projectId", valid_580212
  var valid_580213 = path.getOrDefault("location")
  valid_580213 = validateParameter(valid_580213, JString, required = true,
                                 default = nil)
  if valid_580213 != nil:
    section.add "location", valid_580213
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
  var valid_580214 = query.getOrDefault("key")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "key", valid_580214
  var valid_580215 = query.getOrDefault("prettyPrint")
  valid_580215 = validateParameter(valid_580215, JBool, required = false,
                                 default = newJBool(true))
  if valid_580215 != nil:
    section.add "prettyPrint", valid_580215
  var valid_580216 = query.getOrDefault("oauth_token")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "oauth_token", valid_580216
  var valid_580217 = query.getOrDefault("$.xgafv")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = newJString("1"))
  if valid_580217 != nil:
    section.add "$.xgafv", valid_580217
  var valid_580218 = query.getOrDefault("pageSize")
  valid_580218 = validateParameter(valid_580218, JInt, required = false, default = nil)
  if valid_580218 != nil:
    section.add "pageSize", valid_580218
  var valid_580219 = query.getOrDefault("alt")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = newJString("json"))
  if valid_580219 != nil:
    section.add "alt", valid_580219
  var valid_580220 = query.getOrDefault("uploadType")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "uploadType", valid_580220
  var valid_580221 = query.getOrDefault("quotaUser")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "quotaUser", valid_580221
  var valid_580222 = query.getOrDefault("filter")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = newJString("UNKNOWN"))
  if valid_580222 != nil:
    section.add "filter", valid_580222
  var valid_580223 = query.getOrDefault("pageToken")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "pageToken", valid_580223
  var valid_580224 = query.getOrDefault("callback")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "callback", valid_580224
  var valid_580225 = query.getOrDefault("fields")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "fields", valid_580225
  var valid_580226 = query.getOrDefault("access_token")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "access_token", valid_580226
  var valid_580227 = query.getOrDefault("upload_protocol")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "upload_protocol", valid_580227
  var valid_580228 = query.getOrDefault("view")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_580228 != nil:
    section.add "view", valid_580228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580229: Call_DataflowProjectsLocationsJobsList_580209;
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
  let valid = call_580229.validator(path, query, header, formData, body)
  let scheme = call_580229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580229.url(scheme.get, call_580229.host, call_580229.base,
                         call_580229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580229, url, valid)

proc call*(call_580230: Call_DataflowProjectsLocationsJobsList_580209;
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
  var path_580231 = newJObject()
  var query_580232 = newJObject()
  add(query_580232, "key", newJString(key))
  add(query_580232, "prettyPrint", newJBool(prettyPrint))
  add(query_580232, "oauth_token", newJString(oauthToken))
  add(path_580231, "projectId", newJString(projectId))
  add(query_580232, "$.xgafv", newJString(Xgafv))
  add(query_580232, "pageSize", newJInt(pageSize))
  add(query_580232, "alt", newJString(alt))
  add(query_580232, "uploadType", newJString(uploadType))
  add(query_580232, "quotaUser", newJString(quotaUser))
  add(query_580232, "filter", newJString(filter))
  add(query_580232, "pageToken", newJString(pageToken))
  add(path_580231, "location", newJString(location))
  add(query_580232, "callback", newJString(callback))
  add(query_580232, "fields", newJString(fields))
  add(query_580232, "access_token", newJString(accessToken))
  add(query_580232, "upload_protocol", newJString(uploadProtocol))
  add(query_580232, "view", newJString(view))
  result = call_580230.call(path_580231, query_580232, nil, nil, nil)

var dataflowProjectsLocationsJobsList* = Call_DataflowProjectsLocationsJobsList_580209(
    name: "dataflowProjectsLocationsJobsList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs",
    validator: validate_DataflowProjectsLocationsJobsList_580210, base: "/",
    url: url_DataflowProjectsLocationsJobsList_580211, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsUpdate_580279 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsJobsUpdate_580281(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsUpdate_580280(path: JsonNode;
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
  var valid_580282 = path.getOrDefault("projectId")
  valid_580282 = validateParameter(valid_580282, JString, required = true,
                                 default = nil)
  if valid_580282 != nil:
    section.add "projectId", valid_580282
  var valid_580283 = path.getOrDefault("jobId")
  valid_580283 = validateParameter(valid_580283, JString, required = true,
                                 default = nil)
  if valid_580283 != nil:
    section.add "jobId", valid_580283
  var valid_580284 = path.getOrDefault("location")
  valid_580284 = validateParameter(valid_580284, JString, required = true,
                                 default = nil)
  if valid_580284 != nil:
    section.add "location", valid_580284
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
  var valid_580285 = query.getOrDefault("key")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "key", valid_580285
  var valid_580286 = query.getOrDefault("prettyPrint")
  valid_580286 = validateParameter(valid_580286, JBool, required = false,
                                 default = newJBool(true))
  if valid_580286 != nil:
    section.add "prettyPrint", valid_580286
  var valid_580287 = query.getOrDefault("oauth_token")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "oauth_token", valid_580287
  var valid_580288 = query.getOrDefault("$.xgafv")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("1"))
  if valid_580288 != nil:
    section.add "$.xgafv", valid_580288
  var valid_580289 = query.getOrDefault("alt")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = newJString("json"))
  if valid_580289 != nil:
    section.add "alt", valid_580289
  var valid_580290 = query.getOrDefault("uploadType")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "uploadType", valid_580290
  var valid_580291 = query.getOrDefault("quotaUser")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "quotaUser", valid_580291
  var valid_580292 = query.getOrDefault("callback")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "callback", valid_580292
  var valid_580293 = query.getOrDefault("fields")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "fields", valid_580293
  var valid_580294 = query.getOrDefault("access_token")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "access_token", valid_580294
  var valid_580295 = query.getOrDefault("upload_protocol")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "upload_protocol", valid_580295
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

proc call*(call_580297: Call_DataflowProjectsLocationsJobsUpdate_580279;
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
  let valid = call_580297.validator(path, query, header, formData, body)
  let scheme = call_580297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580297.url(scheme.get, call_580297.host, call_580297.base,
                         call_580297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580297, url, valid)

proc call*(call_580298: Call_DataflowProjectsLocationsJobsUpdate_580279;
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
  var path_580299 = newJObject()
  var query_580300 = newJObject()
  var body_580301 = newJObject()
  add(query_580300, "key", newJString(key))
  add(query_580300, "prettyPrint", newJBool(prettyPrint))
  add(query_580300, "oauth_token", newJString(oauthToken))
  add(path_580299, "projectId", newJString(projectId))
  add(path_580299, "jobId", newJString(jobId))
  add(query_580300, "$.xgafv", newJString(Xgafv))
  add(query_580300, "alt", newJString(alt))
  add(query_580300, "uploadType", newJString(uploadType))
  add(query_580300, "quotaUser", newJString(quotaUser))
  add(path_580299, "location", newJString(location))
  if body != nil:
    body_580301 = body
  add(query_580300, "callback", newJString(callback))
  add(query_580300, "fields", newJString(fields))
  add(query_580300, "access_token", newJString(accessToken))
  add(query_580300, "upload_protocol", newJString(uploadProtocol))
  result = call_580298.call(path_580299, query_580300, nil, nil, body_580301)

var dataflowProjectsLocationsJobsUpdate* = Call_DataflowProjectsLocationsJobsUpdate_580279(
    name: "dataflowProjectsLocationsJobsUpdate", meth: HttpMethod.HttpPut,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}",
    validator: validate_DataflowProjectsLocationsJobsUpdate_580280, base: "/",
    url: url_DataflowProjectsLocationsJobsUpdate_580281, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsGet_580257 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsJobsGet_580259(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsGet_580258(path: JsonNode;
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
  var valid_580260 = path.getOrDefault("projectId")
  valid_580260 = validateParameter(valid_580260, JString, required = true,
                                 default = nil)
  if valid_580260 != nil:
    section.add "projectId", valid_580260
  var valid_580261 = path.getOrDefault("jobId")
  valid_580261 = validateParameter(valid_580261, JString, required = true,
                                 default = nil)
  if valid_580261 != nil:
    section.add "jobId", valid_580261
  var valid_580262 = path.getOrDefault("location")
  valid_580262 = validateParameter(valid_580262, JString, required = true,
                                 default = nil)
  if valid_580262 != nil:
    section.add "location", valid_580262
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
  var valid_580263 = query.getOrDefault("key")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "key", valid_580263
  var valid_580264 = query.getOrDefault("prettyPrint")
  valid_580264 = validateParameter(valid_580264, JBool, required = false,
                                 default = newJBool(true))
  if valid_580264 != nil:
    section.add "prettyPrint", valid_580264
  var valid_580265 = query.getOrDefault("oauth_token")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "oauth_token", valid_580265
  var valid_580266 = query.getOrDefault("$.xgafv")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = newJString("1"))
  if valid_580266 != nil:
    section.add "$.xgafv", valid_580266
  var valid_580267 = query.getOrDefault("alt")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = newJString("json"))
  if valid_580267 != nil:
    section.add "alt", valid_580267
  var valid_580268 = query.getOrDefault("uploadType")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "uploadType", valid_580268
  var valid_580269 = query.getOrDefault("quotaUser")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "quotaUser", valid_580269
  var valid_580270 = query.getOrDefault("callback")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "callback", valid_580270
  var valid_580271 = query.getOrDefault("fields")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "fields", valid_580271
  var valid_580272 = query.getOrDefault("access_token")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "access_token", valid_580272
  var valid_580273 = query.getOrDefault("upload_protocol")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "upload_protocol", valid_580273
  var valid_580274 = query.getOrDefault("view")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = newJString("JOB_VIEW_UNKNOWN"))
  if valid_580274 != nil:
    section.add "view", valid_580274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580275: Call_DataflowProjectsLocationsJobsGet_580257;
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
  let valid = call_580275.validator(path, query, header, formData, body)
  let scheme = call_580275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580275.url(scheme.get, call_580275.host, call_580275.base,
                         call_580275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580275, url, valid)

proc call*(call_580276: Call_DataflowProjectsLocationsJobsGet_580257;
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
  var path_580277 = newJObject()
  var query_580278 = newJObject()
  add(query_580278, "key", newJString(key))
  add(query_580278, "prettyPrint", newJBool(prettyPrint))
  add(query_580278, "oauth_token", newJString(oauthToken))
  add(path_580277, "projectId", newJString(projectId))
  add(path_580277, "jobId", newJString(jobId))
  add(query_580278, "$.xgafv", newJString(Xgafv))
  add(query_580278, "alt", newJString(alt))
  add(query_580278, "uploadType", newJString(uploadType))
  add(query_580278, "quotaUser", newJString(quotaUser))
  add(path_580277, "location", newJString(location))
  add(query_580278, "callback", newJString(callback))
  add(query_580278, "fields", newJString(fields))
  add(query_580278, "access_token", newJString(accessToken))
  add(query_580278, "upload_protocol", newJString(uploadProtocol))
  add(query_580278, "view", newJString(view))
  result = call_580276.call(path_580277, query_580278, nil, nil, nil)

var dataflowProjectsLocationsJobsGet* = Call_DataflowProjectsLocationsJobsGet_580257(
    name: "dataflowProjectsLocationsJobsGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}",
    validator: validate_DataflowProjectsLocationsJobsGet_580258, base: "/",
    url: url_DataflowProjectsLocationsJobsGet_580259, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsDebugGetConfig_580302 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsJobsDebugGetConfig_580304(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsDebugGetConfig_580303(path: JsonNode;
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
  var valid_580305 = path.getOrDefault("projectId")
  valid_580305 = validateParameter(valid_580305, JString, required = true,
                                 default = nil)
  if valid_580305 != nil:
    section.add "projectId", valid_580305
  var valid_580306 = path.getOrDefault("jobId")
  valid_580306 = validateParameter(valid_580306, JString, required = true,
                                 default = nil)
  if valid_580306 != nil:
    section.add "jobId", valid_580306
  var valid_580307 = path.getOrDefault("location")
  valid_580307 = validateParameter(valid_580307, JString, required = true,
                                 default = nil)
  if valid_580307 != nil:
    section.add "location", valid_580307
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
  var valid_580308 = query.getOrDefault("key")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "key", valid_580308
  var valid_580309 = query.getOrDefault("prettyPrint")
  valid_580309 = validateParameter(valid_580309, JBool, required = false,
                                 default = newJBool(true))
  if valid_580309 != nil:
    section.add "prettyPrint", valid_580309
  var valid_580310 = query.getOrDefault("oauth_token")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "oauth_token", valid_580310
  var valid_580311 = query.getOrDefault("$.xgafv")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = newJString("1"))
  if valid_580311 != nil:
    section.add "$.xgafv", valid_580311
  var valid_580312 = query.getOrDefault("alt")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = newJString("json"))
  if valid_580312 != nil:
    section.add "alt", valid_580312
  var valid_580313 = query.getOrDefault("uploadType")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "uploadType", valid_580313
  var valid_580314 = query.getOrDefault("quotaUser")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "quotaUser", valid_580314
  var valid_580315 = query.getOrDefault("callback")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "callback", valid_580315
  var valid_580316 = query.getOrDefault("fields")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "fields", valid_580316
  var valid_580317 = query.getOrDefault("access_token")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "access_token", valid_580317
  var valid_580318 = query.getOrDefault("upload_protocol")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "upload_protocol", valid_580318
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

proc call*(call_580320: Call_DataflowProjectsLocationsJobsDebugGetConfig_580302;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get encoded debug configuration for component. Not cacheable.
  ## 
  let valid = call_580320.validator(path, query, header, formData, body)
  let scheme = call_580320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580320.url(scheme.get, call_580320.host, call_580320.base,
                         call_580320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580320, url, valid)

proc call*(call_580321: Call_DataflowProjectsLocationsJobsDebugGetConfig_580302;
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
  var path_580322 = newJObject()
  var query_580323 = newJObject()
  var body_580324 = newJObject()
  add(query_580323, "key", newJString(key))
  add(query_580323, "prettyPrint", newJBool(prettyPrint))
  add(query_580323, "oauth_token", newJString(oauthToken))
  add(path_580322, "projectId", newJString(projectId))
  add(path_580322, "jobId", newJString(jobId))
  add(query_580323, "$.xgafv", newJString(Xgafv))
  add(query_580323, "alt", newJString(alt))
  add(query_580323, "uploadType", newJString(uploadType))
  add(query_580323, "quotaUser", newJString(quotaUser))
  add(path_580322, "location", newJString(location))
  if body != nil:
    body_580324 = body
  add(query_580323, "callback", newJString(callback))
  add(query_580323, "fields", newJString(fields))
  add(query_580323, "access_token", newJString(accessToken))
  add(query_580323, "upload_protocol", newJString(uploadProtocol))
  result = call_580321.call(path_580322, query_580323, nil, nil, body_580324)

var dataflowProjectsLocationsJobsDebugGetConfig* = Call_DataflowProjectsLocationsJobsDebugGetConfig_580302(
    name: "dataflowProjectsLocationsJobsDebugGetConfig",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/debug/getConfig",
    validator: validate_DataflowProjectsLocationsJobsDebugGetConfig_580303,
    base: "/", url: url_DataflowProjectsLocationsJobsDebugGetConfig_580304,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsDebugSendCapture_580325 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsJobsDebugSendCapture_580327(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsDebugSendCapture_580326(
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
  var valid_580328 = path.getOrDefault("projectId")
  valid_580328 = validateParameter(valid_580328, JString, required = true,
                                 default = nil)
  if valid_580328 != nil:
    section.add "projectId", valid_580328
  var valid_580329 = path.getOrDefault("jobId")
  valid_580329 = validateParameter(valid_580329, JString, required = true,
                                 default = nil)
  if valid_580329 != nil:
    section.add "jobId", valid_580329
  var valid_580330 = path.getOrDefault("location")
  valid_580330 = validateParameter(valid_580330, JString, required = true,
                                 default = nil)
  if valid_580330 != nil:
    section.add "location", valid_580330
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
  var valid_580331 = query.getOrDefault("key")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "key", valid_580331
  var valid_580332 = query.getOrDefault("prettyPrint")
  valid_580332 = validateParameter(valid_580332, JBool, required = false,
                                 default = newJBool(true))
  if valid_580332 != nil:
    section.add "prettyPrint", valid_580332
  var valid_580333 = query.getOrDefault("oauth_token")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "oauth_token", valid_580333
  var valid_580334 = query.getOrDefault("$.xgafv")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = newJString("1"))
  if valid_580334 != nil:
    section.add "$.xgafv", valid_580334
  var valid_580335 = query.getOrDefault("alt")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = newJString("json"))
  if valid_580335 != nil:
    section.add "alt", valid_580335
  var valid_580336 = query.getOrDefault("uploadType")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "uploadType", valid_580336
  var valid_580337 = query.getOrDefault("quotaUser")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "quotaUser", valid_580337
  var valid_580338 = query.getOrDefault("callback")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "callback", valid_580338
  var valid_580339 = query.getOrDefault("fields")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "fields", valid_580339
  var valid_580340 = query.getOrDefault("access_token")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "access_token", valid_580340
  var valid_580341 = query.getOrDefault("upload_protocol")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "upload_protocol", valid_580341
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

proc call*(call_580343: Call_DataflowProjectsLocationsJobsDebugSendCapture_580325;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send encoded debug capture data for component.
  ## 
  let valid = call_580343.validator(path, query, header, formData, body)
  let scheme = call_580343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580343.url(scheme.get, call_580343.host, call_580343.base,
                         call_580343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580343, url, valid)

proc call*(call_580344: Call_DataflowProjectsLocationsJobsDebugSendCapture_580325;
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
  var path_580345 = newJObject()
  var query_580346 = newJObject()
  var body_580347 = newJObject()
  add(query_580346, "key", newJString(key))
  add(query_580346, "prettyPrint", newJBool(prettyPrint))
  add(query_580346, "oauth_token", newJString(oauthToken))
  add(path_580345, "projectId", newJString(projectId))
  add(path_580345, "jobId", newJString(jobId))
  add(query_580346, "$.xgafv", newJString(Xgafv))
  add(query_580346, "alt", newJString(alt))
  add(query_580346, "uploadType", newJString(uploadType))
  add(query_580346, "quotaUser", newJString(quotaUser))
  add(path_580345, "location", newJString(location))
  if body != nil:
    body_580347 = body
  add(query_580346, "callback", newJString(callback))
  add(query_580346, "fields", newJString(fields))
  add(query_580346, "access_token", newJString(accessToken))
  add(query_580346, "upload_protocol", newJString(uploadProtocol))
  result = call_580344.call(path_580345, query_580346, nil, nil, body_580347)

var dataflowProjectsLocationsJobsDebugSendCapture* = Call_DataflowProjectsLocationsJobsDebugSendCapture_580325(
    name: "dataflowProjectsLocationsJobsDebugSendCapture",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/debug/sendCapture",
    validator: validate_DataflowProjectsLocationsJobsDebugSendCapture_580326,
    base: "/", url: url_DataflowProjectsLocationsJobsDebugSendCapture_580327,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsMessagesList_580348 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsJobsMessagesList_580350(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsMessagesList_580349(path: JsonNode;
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
  var valid_580351 = path.getOrDefault("projectId")
  valid_580351 = validateParameter(valid_580351, JString, required = true,
                                 default = nil)
  if valid_580351 != nil:
    section.add "projectId", valid_580351
  var valid_580352 = path.getOrDefault("jobId")
  valid_580352 = validateParameter(valid_580352, JString, required = true,
                                 default = nil)
  if valid_580352 != nil:
    section.add "jobId", valid_580352
  var valid_580353 = path.getOrDefault("location")
  valid_580353 = validateParameter(valid_580353, JString, required = true,
                                 default = nil)
  if valid_580353 != nil:
    section.add "location", valid_580353
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
  var valid_580354 = query.getOrDefault("key")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "key", valid_580354
  var valid_580355 = query.getOrDefault("prettyPrint")
  valid_580355 = validateParameter(valid_580355, JBool, required = false,
                                 default = newJBool(true))
  if valid_580355 != nil:
    section.add "prettyPrint", valid_580355
  var valid_580356 = query.getOrDefault("oauth_token")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "oauth_token", valid_580356
  var valid_580357 = query.getOrDefault("minimumImportance")
  valid_580357 = validateParameter(valid_580357, JString, required = false, default = newJString(
      "JOB_MESSAGE_IMPORTANCE_UNKNOWN"))
  if valid_580357 != nil:
    section.add "minimumImportance", valid_580357
  var valid_580358 = query.getOrDefault("$.xgafv")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = newJString("1"))
  if valid_580358 != nil:
    section.add "$.xgafv", valid_580358
  var valid_580359 = query.getOrDefault("pageSize")
  valid_580359 = validateParameter(valid_580359, JInt, required = false, default = nil)
  if valid_580359 != nil:
    section.add "pageSize", valid_580359
  var valid_580360 = query.getOrDefault("startTime")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "startTime", valid_580360
  var valid_580361 = query.getOrDefault("alt")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = newJString("json"))
  if valid_580361 != nil:
    section.add "alt", valid_580361
  var valid_580362 = query.getOrDefault("uploadType")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "uploadType", valid_580362
  var valid_580363 = query.getOrDefault("quotaUser")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "quotaUser", valid_580363
  var valid_580364 = query.getOrDefault("pageToken")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "pageToken", valid_580364
  var valid_580365 = query.getOrDefault("callback")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "callback", valid_580365
  var valid_580366 = query.getOrDefault("fields")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "fields", valid_580366
  var valid_580367 = query.getOrDefault("access_token")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "access_token", valid_580367
  var valid_580368 = query.getOrDefault("upload_protocol")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "upload_protocol", valid_580368
  var valid_580369 = query.getOrDefault("endTime")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "endTime", valid_580369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580370: Call_DataflowProjectsLocationsJobsMessagesList_580348;
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
  let valid = call_580370.validator(path, query, header, formData, body)
  let scheme = call_580370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580370.url(scheme.get, call_580370.host, call_580370.base,
                         call_580370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580370, url, valid)

proc call*(call_580371: Call_DataflowProjectsLocationsJobsMessagesList_580348;
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
  var path_580372 = newJObject()
  var query_580373 = newJObject()
  add(query_580373, "key", newJString(key))
  add(query_580373, "prettyPrint", newJBool(prettyPrint))
  add(query_580373, "oauth_token", newJString(oauthToken))
  add(query_580373, "minimumImportance", newJString(minimumImportance))
  add(path_580372, "projectId", newJString(projectId))
  add(path_580372, "jobId", newJString(jobId))
  add(query_580373, "$.xgafv", newJString(Xgafv))
  add(query_580373, "pageSize", newJInt(pageSize))
  add(query_580373, "startTime", newJString(startTime))
  add(query_580373, "alt", newJString(alt))
  add(query_580373, "uploadType", newJString(uploadType))
  add(query_580373, "quotaUser", newJString(quotaUser))
  add(query_580373, "pageToken", newJString(pageToken))
  add(path_580372, "location", newJString(location))
  add(query_580373, "callback", newJString(callback))
  add(query_580373, "fields", newJString(fields))
  add(query_580373, "access_token", newJString(accessToken))
  add(query_580373, "upload_protocol", newJString(uploadProtocol))
  add(query_580373, "endTime", newJString(endTime))
  result = call_580371.call(path_580372, query_580373, nil, nil, nil)

var dataflowProjectsLocationsJobsMessagesList* = Call_DataflowProjectsLocationsJobsMessagesList_580348(
    name: "dataflowProjectsLocationsJobsMessagesList", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/messages",
    validator: validate_DataflowProjectsLocationsJobsMessagesList_580349,
    base: "/", url: url_DataflowProjectsLocationsJobsMessagesList_580350,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsGetMetrics_580374 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsJobsGetMetrics_580376(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsGetMetrics_580375(path: JsonNode;
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
  var valid_580377 = path.getOrDefault("projectId")
  valid_580377 = validateParameter(valid_580377, JString, required = true,
                                 default = nil)
  if valid_580377 != nil:
    section.add "projectId", valid_580377
  var valid_580378 = path.getOrDefault("jobId")
  valid_580378 = validateParameter(valid_580378, JString, required = true,
                                 default = nil)
  if valid_580378 != nil:
    section.add "jobId", valid_580378
  var valid_580379 = path.getOrDefault("location")
  valid_580379 = validateParameter(valid_580379, JString, required = true,
                                 default = nil)
  if valid_580379 != nil:
    section.add "location", valid_580379
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
  var valid_580380 = query.getOrDefault("key")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "key", valid_580380
  var valid_580381 = query.getOrDefault("prettyPrint")
  valid_580381 = validateParameter(valid_580381, JBool, required = false,
                                 default = newJBool(true))
  if valid_580381 != nil:
    section.add "prettyPrint", valid_580381
  var valid_580382 = query.getOrDefault("oauth_token")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "oauth_token", valid_580382
  var valid_580383 = query.getOrDefault("$.xgafv")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = newJString("1"))
  if valid_580383 != nil:
    section.add "$.xgafv", valid_580383
  var valid_580384 = query.getOrDefault("startTime")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "startTime", valid_580384
  var valid_580385 = query.getOrDefault("alt")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = newJString("json"))
  if valid_580385 != nil:
    section.add "alt", valid_580385
  var valid_580386 = query.getOrDefault("uploadType")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "uploadType", valid_580386
  var valid_580387 = query.getOrDefault("quotaUser")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "quotaUser", valid_580387
  var valid_580388 = query.getOrDefault("callback")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "callback", valid_580388
  var valid_580389 = query.getOrDefault("fields")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "fields", valid_580389
  var valid_580390 = query.getOrDefault("access_token")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "access_token", valid_580390
  var valid_580391 = query.getOrDefault("upload_protocol")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "upload_protocol", valid_580391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580392: Call_DataflowProjectsLocationsJobsGetMetrics_580374;
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
  let valid = call_580392.validator(path, query, header, formData, body)
  let scheme = call_580392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580392.url(scheme.get, call_580392.host, call_580392.base,
                         call_580392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580392, url, valid)

proc call*(call_580393: Call_DataflowProjectsLocationsJobsGetMetrics_580374;
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
  var path_580394 = newJObject()
  var query_580395 = newJObject()
  add(query_580395, "key", newJString(key))
  add(query_580395, "prettyPrint", newJBool(prettyPrint))
  add(query_580395, "oauth_token", newJString(oauthToken))
  add(path_580394, "projectId", newJString(projectId))
  add(path_580394, "jobId", newJString(jobId))
  add(query_580395, "$.xgafv", newJString(Xgafv))
  add(query_580395, "startTime", newJString(startTime))
  add(query_580395, "alt", newJString(alt))
  add(query_580395, "uploadType", newJString(uploadType))
  add(query_580395, "quotaUser", newJString(quotaUser))
  add(path_580394, "location", newJString(location))
  add(query_580395, "callback", newJString(callback))
  add(query_580395, "fields", newJString(fields))
  add(query_580395, "access_token", newJString(accessToken))
  add(query_580395, "upload_protocol", newJString(uploadProtocol))
  result = call_580393.call(path_580394, query_580395, nil, nil, nil)

var dataflowProjectsLocationsJobsGetMetrics* = Call_DataflowProjectsLocationsJobsGetMetrics_580374(
    name: "dataflowProjectsLocationsJobsGetMetrics", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/metrics",
    validator: validate_DataflowProjectsLocationsJobsGetMetrics_580375, base: "/",
    url: url_DataflowProjectsLocationsJobsGetMetrics_580376,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsWorkItemsLease_580396 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsJobsWorkItemsLease_580398(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsWorkItemsLease_580397(path: JsonNode;
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
  var valid_580399 = path.getOrDefault("projectId")
  valid_580399 = validateParameter(valid_580399, JString, required = true,
                                 default = nil)
  if valid_580399 != nil:
    section.add "projectId", valid_580399
  var valid_580400 = path.getOrDefault("jobId")
  valid_580400 = validateParameter(valid_580400, JString, required = true,
                                 default = nil)
  if valid_580400 != nil:
    section.add "jobId", valid_580400
  var valid_580401 = path.getOrDefault("location")
  valid_580401 = validateParameter(valid_580401, JString, required = true,
                                 default = nil)
  if valid_580401 != nil:
    section.add "location", valid_580401
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
  var valid_580402 = query.getOrDefault("key")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "key", valid_580402
  var valid_580403 = query.getOrDefault("prettyPrint")
  valid_580403 = validateParameter(valid_580403, JBool, required = false,
                                 default = newJBool(true))
  if valid_580403 != nil:
    section.add "prettyPrint", valid_580403
  var valid_580404 = query.getOrDefault("oauth_token")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "oauth_token", valid_580404
  var valid_580405 = query.getOrDefault("$.xgafv")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = newJString("1"))
  if valid_580405 != nil:
    section.add "$.xgafv", valid_580405
  var valid_580406 = query.getOrDefault("alt")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = newJString("json"))
  if valid_580406 != nil:
    section.add "alt", valid_580406
  var valid_580407 = query.getOrDefault("uploadType")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "uploadType", valid_580407
  var valid_580408 = query.getOrDefault("quotaUser")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "quotaUser", valid_580408
  var valid_580409 = query.getOrDefault("callback")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "callback", valid_580409
  var valid_580410 = query.getOrDefault("fields")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "fields", valid_580410
  var valid_580411 = query.getOrDefault("access_token")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "access_token", valid_580411
  var valid_580412 = query.getOrDefault("upload_protocol")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "upload_protocol", valid_580412
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

proc call*(call_580414: Call_DataflowProjectsLocationsJobsWorkItemsLease_580396;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Leases a dataflow WorkItem to run.
  ## 
  let valid = call_580414.validator(path, query, header, formData, body)
  let scheme = call_580414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580414.url(scheme.get, call_580414.host, call_580414.base,
                         call_580414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580414, url, valid)

proc call*(call_580415: Call_DataflowProjectsLocationsJobsWorkItemsLease_580396;
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
  var path_580416 = newJObject()
  var query_580417 = newJObject()
  var body_580418 = newJObject()
  add(query_580417, "key", newJString(key))
  add(query_580417, "prettyPrint", newJBool(prettyPrint))
  add(query_580417, "oauth_token", newJString(oauthToken))
  add(path_580416, "projectId", newJString(projectId))
  add(path_580416, "jobId", newJString(jobId))
  add(query_580417, "$.xgafv", newJString(Xgafv))
  add(query_580417, "alt", newJString(alt))
  add(query_580417, "uploadType", newJString(uploadType))
  add(query_580417, "quotaUser", newJString(quotaUser))
  add(path_580416, "location", newJString(location))
  if body != nil:
    body_580418 = body
  add(query_580417, "callback", newJString(callback))
  add(query_580417, "fields", newJString(fields))
  add(query_580417, "access_token", newJString(accessToken))
  add(query_580417, "upload_protocol", newJString(uploadProtocol))
  result = call_580415.call(path_580416, query_580417, nil, nil, body_580418)

var dataflowProjectsLocationsJobsWorkItemsLease* = Call_DataflowProjectsLocationsJobsWorkItemsLease_580396(
    name: "dataflowProjectsLocationsJobsWorkItemsLease",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/workItems:lease",
    validator: validate_DataflowProjectsLocationsJobsWorkItemsLease_580397,
    base: "/", url: url_DataflowProjectsLocationsJobsWorkItemsLease_580398,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_580419 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsJobsWorkItemsReportStatus_580421(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsJobsWorkItemsReportStatus_580420(
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
  var valid_580422 = path.getOrDefault("projectId")
  valid_580422 = validateParameter(valid_580422, JString, required = true,
                                 default = nil)
  if valid_580422 != nil:
    section.add "projectId", valid_580422
  var valid_580423 = path.getOrDefault("jobId")
  valid_580423 = validateParameter(valid_580423, JString, required = true,
                                 default = nil)
  if valid_580423 != nil:
    section.add "jobId", valid_580423
  var valid_580424 = path.getOrDefault("location")
  valid_580424 = validateParameter(valid_580424, JString, required = true,
                                 default = nil)
  if valid_580424 != nil:
    section.add "location", valid_580424
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
  var valid_580425 = query.getOrDefault("key")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "key", valid_580425
  var valid_580426 = query.getOrDefault("prettyPrint")
  valid_580426 = validateParameter(valid_580426, JBool, required = false,
                                 default = newJBool(true))
  if valid_580426 != nil:
    section.add "prettyPrint", valid_580426
  var valid_580427 = query.getOrDefault("oauth_token")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "oauth_token", valid_580427
  var valid_580428 = query.getOrDefault("$.xgafv")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = newJString("1"))
  if valid_580428 != nil:
    section.add "$.xgafv", valid_580428
  var valid_580429 = query.getOrDefault("alt")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = newJString("json"))
  if valid_580429 != nil:
    section.add "alt", valid_580429
  var valid_580430 = query.getOrDefault("uploadType")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "uploadType", valid_580430
  var valid_580431 = query.getOrDefault("quotaUser")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "quotaUser", valid_580431
  var valid_580432 = query.getOrDefault("callback")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "callback", valid_580432
  var valid_580433 = query.getOrDefault("fields")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "fields", valid_580433
  var valid_580434 = query.getOrDefault("access_token")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "access_token", valid_580434
  var valid_580435 = query.getOrDefault("upload_protocol")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "upload_protocol", valid_580435
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

proc call*(call_580437: Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_580419;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports the status of dataflow WorkItems leased by a worker.
  ## 
  let valid = call_580437.validator(path, query, header, formData, body)
  let scheme = call_580437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580437.url(scheme.get, call_580437.host, call_580437.base,
                         call_580437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580437, url, valid)

proc call*(call_580438: Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_580419;
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
  var path_580439 = newJObject()
  var query_580440 = newJObject()
  var body_580441 = newJObject()
  add(query_580440, "key", newJString(key))
  add(query_580440, "prettyPrint", newJBool(prettyPrint))
  add(query_580440, "oauth_token", newJString(oauthToken))
  add(path_580439, "projectId", newJString(projectId))
  add(path_580439, "jobId", newJString(jobId))
  add(query_580440, "$.xgafv", newJString(Xgafv))
  add(query_580440, "alt", newJString(alt))
  add(query_580440, "uploadType", newJString(uploadType))
  add(query_580440, "quotaUser", newJString(quotaUser))
  add(path_580439, "location", newJString(location))
  if body != nil:
    body_580441 = body
  add(query_580440, "callback", newJString(callback))
  add(query_580440, "fields", newJString(fields))
  add(query_580440, "access_token", newJString(accessToken))
  add(query_580440, "upload_protocol", newJString(uploadProtocol))
  result = call_580438.call(path_580439, query_580440, nil, nil, body_580441)

var dataflowProjectsLocationsJobsWorkItemsReportStatus* = Call_DataflowProjectsLocationsJobsWorkItemsReportStatus_580419(
    name: "dataflowProjectsLocationsJobsWorkItemsReportStatus",
    meth: HttpMethod.HttpPost, host: "dataflow.googleapis.com", route: "/v1b3/projects/{projectId}/locations/{location}/jobs/{jobId}/workItems:reportStatus",
    validator: validate_DataflowProjectsLocationsJobsWorkItemsReportStatus_580420,
    base: "/", url: url_DataflowProjectsLocationsJobsWorkItemsReportStatus_580421,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsSqlValidate_580442 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsSqlValidate_580444(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsSqlValidate_580443(path: JsonNode;
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
  var valid_580445 = path.getOrDefault("projectId")
  valid_580445 = validateParameter(valid_580445, JString, required = true,
                                 default = nil)
  if valid_580445 != nil:
    section.add "projectId", valid_580445
  var valid_580446 = path.getOrDefault("location")
  valid_580446 = validateParameter(valid_580446, JString, required = true,
                                 default = nil)
  if valid_580446 != nil:
    section.add "location", valid_580446
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
  var valid_580447 = query.getOrDefault("key")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "key", valid_580447
  var valid_580448 = query.getOrDefault("prettyPrint")
  valid_580448 = validateParameter(valid_580448, JBool, required = false,
                                 default = newJBool(true))
  if valid_580448 != nil:
    section.add "prettyPrint", valid_580448
  var valid_580449 = query.getOrDefault("oauth_token")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "oauth_token", valid_580449
  var valid_580450 = query.getOrDefault("$.xgafv")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = newJString("1"))
  if valid_580450 != nil:
    section.add "$.xgafv", valid_580450
  var valid_580451 = query.getOrDefault("alt")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = newJString("json"))
  if valid_580451 != nil:
    section.add "alt", valid_580451
  var valid_580452 = query.getOrDefault("uploadType")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "uploadType", valid_580452
  var valid_580453 = query.getOrDefault("quotaUser")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "quotaUser", valid_580453
  var valid_580454 = query.getOrDefault("query")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "query", valid_580454
  var valid_580455 = query.getOrDefault("callback")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "callback", valid_580455
  var valid_580456 = query.getOrDefault("fields")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "fields", valid_580456
  var valid_580457 = query.getOrDefault("access_token")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "access_token", valid_580457
  var valid_580458 = query.getOrDefault("upload_protocol")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "upload_protocol", valid_580458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580459: Call_DataflowProjectsLocationsSqlValidate_580442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates a GoogleSQL query for Cloud Dataflow syntax. Will always
  ## confirm the given query parses correctly, and if able to look up
  ## schema information from DataCatalog, will validate that the query
  ## analyzes properly as well.
  ## 
  let valid = call_580459.validator(path, query, header, formData, body)
  let scheme = call_580459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580459.url(scheme.get, call_580459.host, call_580459.base,
                         call_580459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580459, url, valid)

proc call*(call_580460: Call_DataflowProjectsLocationsSqlValidate_580442;
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
  var path_580461 = newJObject()
  var query_580462 = newJObject()
  add(query_580462, "key", newJString(key))
  add(query_580462, "prettyPrint", newJBool(prettyPrint))
  add(query_580462, "oauth_token", newJString(oauthToken))
  add(path_580461, "projectId", newJString(projectId))
  add(query_580462, "$.xgafv", newJString(Xgafv))
  add(query_580462, "alt", newJString(alt))
  add(query_580462, "uploadType", newJString(uploadType))
  add(query_580462, "quotaUser", newJString(quotaUser))
  add(path_580461, "location", newJString(location))
  add(query_580462, "query", newJString(query))
  add(query_580462, "callback", newJString(callback))
  add(query_580462, "fields", newJString(fields))
  add(query_580462, "access_token", newJString(accessToken))
  add(query_580462, "upload_protocol", newJString(uploadProtocol))
  result = call_580460.call(path_580461, query_580462, nil, nil, nil)

var dataflowProjectsLocationsSqlValidate* = Call_DataflowProjectsLocationsSqlValidate_580442(
    name: "dataflowProjectsLocationsSqlValidate", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/sql:validate",
    validator: validate_DataflowProjectsLocationsSqlValidate_580443, base: "/",
    url: url_DataflowProjectsLocationsSqlValidate_580444, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesCreate_580463 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsTemplatesCreate_580465(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsTemplatesCreate_580464(path: JsonNode;
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
  var valid_580466 = path.getOrDefault("projectId")
  valid_580466 = validateParameter(valid_580466, JString, required = true,
                                 default = nil)
  if valid_580466 != nil:
    section.add "projectId", valid_580466
  var valid_580467 = path.getOrDefault("location")
  valid_580467 = validateParameter(valid_580467, JString, required = true,
                                 default = nil)
  if valid_580467 != nil:
    section.add "location", valid_580467
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
  var valid_580468 = query.getOrDefault("key")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "key", valid_580468
  var valid_580469 = query.getOrDefault("prettyPrint")
  valid_580469 = validateParameter(valid_580469, JBool, required = false,
                                 default = newJBool(true))
  if valid_580469 != nil:
    section.add "prettyPrint", valid_580469
  var valid_580470 = query.getOrDefault("oauth_token")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "oauth_token", valid_580470
  var valid_580471 = query.getOrDefault("$.xgafv")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = newJString("1"))
  if valid_580471 != nil:
    section.add "$.xgafv", valid_580471
  var valid_580472 = query.getOrDefault("alt")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = newJString("json"))
  if valid_580472 != nil:
    section.add "alt", valid_580472
  var valid_580473 = query.getOrDefault("uploadType")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "uploadType", valid_580473
  var valid_580474 = query.getOrDefault("quotaUser")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "quotaUser", valid_580474
  var valid_580475 = query.getOrDefault("callback")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "callback", valid_580475
  var valid_580476 = query.getOrDefault("fields")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "fields", valid_580476
  var valid_580477 = query.getOrDefault("access_token")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "access_token", valid_580477
  var valid_580478 = query.getOrDefault("upload_protocol")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "upload_protocol", valid_580478
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

proc call*(call_580480: Call_DataflowProjectsLocationsTemplatesCreate_580463;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job from a template.
  ## 
  let valid = call_580480.validator(path, query, header, formData, body)
  let scheme = call_580480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580480.url(scheme.get, call_580480.host, call_580480.base,
                         call_580480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580480, url, valid)

proc call*(call_580481: Call_DataflowProjectsLocationsTemplatesCreate_580463;
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
  var path_580482 = newJObject()
  var query_580483 = newJObject()
  var body_580484 = newJObject()
  add(query_580483, "key", newJString(key))
  add(query_580483, "prettyPrint", newJBool(prettyPrint))
  add(query_580483, "oauth_token", newJString(oauthToken))
  add(path_580482, "projectId", newJString(projectId))
  add(query_580483, "$.xgafv", newJString(Xgafv))
  add(query_580483, "alt", newJString(alt))
  add(query_580483, "uploadType", newJString(uploadType))
  add(query_580483, "quotaUser", newJString(quotaUser))
  add(path_580482, "location", newJString(location))
  if body != nil:
    body_580484 = body
  add(query_580483, "callback", newJString(callback))
  add(query_580483, "fields", newJString(fields))
  add(query_580483, "access_token", newJString(accessToken))
  add(query_580483, "upload_protocol", newJString(uploadProtocol))
  result = call_580481.call(path_580482, query_580483, nil, nil, body_580484)

var dataflowProjectsLocationsTemplatesCreate* = Call_DataflowProjectsLocationsTemplatesCreate_580463(
    name: "dataflowProjectsLocationsTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates",
    validator: validate_DataflowProjectsLocationsTemplatesCreate_580464,
    base: "/", url: url_DataflowProjectsLocationsTemplatesCreate_580465,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesGet_580485 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsTemplatesGet_580487(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsTemplatesGet_580486(path: JsonNode;
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
  var valid_580488 = path.getOrDefault("projectId")
  valid_580488 = validateParameter(valid_580488, JString, required = true,
                                 default = nil)
  if valid_580488 != nil:
    section.add "projectId", valid_580488
  var valid_580489 = path.getOrDefault("location")
  valid_580489 = validateParameter(valid_580489, JString, required = true,
                                 default = nil)
  if valid_580489 != nil:
    section.add "location", valid_580489
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
  var valid_580490 = query.getOrDefault("key")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "key", valid_580490
  var valid_580491 = query.getOrDefault("prettyPrint")
  valid_580491 = validateParameter(valid_580491, JBool, required = false,
                                 default = newJBool(true))
  if valid_580491 != nil:
    section.add "prettyPrint", valid_580491
  var valid_580492 = query.getOrDefault("oauth_token")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "oauth_token", valid_580492
  var valid_580493 = query.getOrDefault("$.xgafv")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = newJString("1"))
  if valid_580493 != nil:
    section.add "$.xgafv", valid_580493
  var valid_580494 = query.getOrDefault("alt")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = newJString("json"))
  if valid_580494 != nil:
    section.add "alt", valid_580494
  var valid_580495 = query.getOrDefault("uploadType")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "uploadType", valid_580495
  var valid_580496 = query.getOrDefault("quotaUser")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = nil)
  if valid_580496 != nil:
    section.add "quotaUser", valid_580496
  var valid_580497 = query.getOrDefault("gcsPath")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "gcsPath", valid_580497
  var valid_580498 = query.getOrDefault("callback")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "callback", valid_580498
  var valid_580499 = query.getOrDefault("fields")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "fields", valid_580499
  var valid_580500 = query.getOrDefault("access_token")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "access_token", valid_580500
  var valid_580501 = query.getOrDefault("upload_protocol")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "upload_protocol", valid_580501
  var valid_580502 = query.getOrDefault("view")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = newJString("METADATA_ONLY"))
  if valid_580502 != nil:
    section.add "view", valid_580502
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580503: Call_DataflowProjectsLocationsTemplatesGet_580485;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the template associated with a template.
  ## 
  let valid = call_580503.validator(path, query, header, formData, body)
  let scheme = call_580503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580503.url(scheme.get, call_580503.host, call_580503.base,
                         call_580503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580503, url, valid)

proc call*(call_580504: Call_DataflowProjectsLocationsTemplatesGet_580485;
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
  var path_580505 = newJObject()
  var query_580506 = newJObject()
  add(query_580506, "key", newJString(key))
  add(query_580506, "prettyPrint", newJBool(prettyPrint))
  add(query_580506, "oauth_token", newJString(oauthToken))
  add(path_580505, "projectId", newJString(projectId))
  add(query_580506, "$.xgafv", newJString(Xgafv))
  add(query_580506, "alt", newJString(alt))
  add(query_580506, "uploadType", newJString(uploadType))
  add(query_580506, "quotaUser", newJString(quotaUser))
  add(path_580505, "location", newJString(location))
  add(query_580506, "gcsPath", newJString(gcsPath))
  add(query_580506, "callback", newJString(callback))
  add(query_580506, "fields", newJString(fields))
  add(query_580506, "access_token", newJString(accessToken))
  add(query_580506, "upload_protocol", newJString(uploadProtocol))
  add(query_580506, "view", newJString(view))
  result = call_580504.call(path_580505, query_580506, nil, nil, nil)

var dataflowProjectsLocationsTemplatesGet* = Call_DataflowProjectsLocationsTemplatesGet_580485(
    name: "dataflowProjectsLocationsTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates:get",
    validator: validate_DataflowProjectsLocationsTemplatesGet_580486, base: "/",
    url: url_DataflowProjectsLocationsTemplatesGet_580487, schemes: {Scheme.Https})
type
  Call_DataflowProjectsLocationsTemplatesLaunch_580507 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsLocationsTemplatesLaunch_580509(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsLocationsTemplatesLaunch_580508(path: JsonNode;
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
  var valid_580510 = path.getOrDefault("projectId")
  valid_580510 = validateParameter(valid_580510, JString, required = true,
                                 default = nil)
  if valid_580510 != nil:
    section.add "projectId", valid_580510
  var valid_580511 = path.getOrDefault("location")
  valid_580511 = validateParameter(valid_580511, JString, required = true,
                                 default = nil)
  if valid_580511 != nil:
    section.add "location", valid_580511
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
  var valid_580512 = query.getOrDefault("key")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "key", valid_580512
  var valid_580513 = query.getOrDefault("prettyPrint")
  valid_580513 = validateParameter(valid_580513, JBool, required = false,
                                 default = newJBool(true))
  if valid_580513 != nil:
    section.add "prettyPrint", valid_580513
  var valid_580514 = query.getOrDefault("oauth_token")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "oauth_token", valid_580514
  var valid_580515 = query.getOrDefault("dynamicTemplate.gcsPath")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "dynamicTemplate.gcsPath", valid_580515
  var valid_580516 = query.getOrDefault("$.xgafv")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = newJString("1"))
  if valid_580516 != nil:
    section.add "$.xgafv", valid_580516
  var valid_580517 = query.getOrDefault("alt")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = newJString("json"))
  if valid_580517 != nil:
    section.add "alt", valid_580517
  var valid_580518 = query.getOrDefault("uploadType")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "uploadType", valid_580518
  var valid_580519 = query.getOrDefault("quotaUser")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "quotaUser", valid_580519
  var valid_580520 = query.getOrDefault("validateOnly")
  valid_580520 = validateParameter(valid_580520, JBool, required = false, default = nil)
  if valid_580520 != nil:
    section.add "validateOnly", valid_580520
  var valid_580521 = query.getOrDefault("gcsPath")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "gcsPath", valid_580521
  var valid_580522 = query.getOrDefault("callback")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "callback", valid_580522
  var valid_580523 = query.getOrDefault("fields")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "fields", valid_580523
  var valid_580524 = query.getOrDefault("access_token")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "access_token", valid_580524
  var valid_580525 = query.getOrDefault("upload_protocol")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = nil)
  if valid_580525 != nil:
    section.add "upload_protocol", valid_580525
  var valid_580526 = query.getOrDefault("dynamicTemplate.stagingLocation")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "dynamicTemplate.stagingLocation", valid_580526
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

proc call*(call_580528: Call_DataflowProjectsLocationsTemplatesLaunch_580507;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Launch a template.
  ## 
  let valid = call_580528.validator(path, query, header, formData, body)
  let scheme = call_580528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580528.url(scheme.get, call_580528.host, call_580528.base,
                         call_580528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580528, url, valid)

proc call*(call_580529: Call_DataflowProjectsLocationsTemplatesLaunch_580507;
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
  var path_580530 = newJObject()
  var query_580531 = newJObject()
  var body_580532 = newJObject()
  add(query_580531, "key", newJString(key))
  add(query_580531, "prettyPrint", newJBool(prettyPrint))
  add(query_580531, "oauth_token", newJString(oauthToken))
  add(path_580530, "projectId", newJString(projectId))
  add(query_580531, "dynamicTemplate.gcsPath", newJString(dynamicTemplateGcsPath))
  add(query_580531, "$.xgafv", newJString(Xgafv))
  add(query_580531, "alt", newJString(alt))
  add(query_580531, "uploadType", newJString(uploadType))
  add(query_580531, "quotaUser", newJString(quotaUser))
  add(path_580530, "location", newJString(location))
  add(query_580531, "validateOnly", newJBool(validateOnly))
  if body != nil:
    body_580532 = body
  add(query_580531, "gcsPath", newJString(gcsPath))
  add(query_580531, "callback", newJString(callback))
  add(query_580531, "fields", newJString(fields))
  add(query_580531, "access_token", newJString(accessToken))
  add(query_580531, "upload_protocol", newJString(uploadProtocol))
  add(query_580531, "dynamicTemplate.stagingLocation",
      newJString(dynamicTemplateStagingLocation))
  result = call_580529.call(path_580530, query_580531, nil, nil, body_580532)

var dataflowProjectsLocationsTemplatesLaunch* = Call_DataflowProjectsLocationsTemplatesLaunch_580507(
    name: "dataflowProjectsLocationsTemplatesLaunch", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/locations/{location}/templates:launch",
    validator: validate_DataflowProjectsLocationsTemplatesLaunch_580508,
    base: "/", url: url_DataflowProjectsLocationsTemplatesLaunch_580509,
    schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesCreate_580533 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsTemplatesCreate_580535(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsTemplatesCreate_580534(path: JsonNode;
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
  var valid_580536 = path.getOrDefault("projectId")
  valid_580536 = validateParameter(valid_580536, JString, required = true,
                                 default = nil)
  if valid_580536 != nil:
    section.add "projectId", valid_580536
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
  var valid_580537 = query.getOrDefault("key")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "key", valid_580537
  var valid_580538 = query.getOrDefault("prettyPrint")
  valid_580538 = validateParameter(valid_580538, JBool, required = false,
                                 default = newJBool(true))
  if valid_580538 != nil:
    section.add "prettyPrint", valid_580538
  var valid_580539 = query.getOrDefault("oauth_token")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "oauth_token", valid_580539
  var valid_580540 = query.getOrDefault("$.xgafv")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = newJString("1"))
  if valid_580540 != nil:
    section.add "$.xgafv", valid_580540
  var valid_580541 = query.getOrDefault("alt")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = newJString("json"))
  if valid_580541 != nil:
    section.add "alt", valid_580541
  var valid_580542 = query.getOrDefault("uploadType")
  valid_580542 = validateParameter(valid_580542, JString, required = false,
                                 default = nil)
  if valid_580542 != nil:
    section.add "uploadType", valid_580542
  var valid_580543 = query.getOrDefault("quotaUser")
  valid_580543 = validateParameter(valid_580543, JString, required = false,
                                 default = nil)
  if valid_580543 != nil:
    section.add "quotaUser", valid_580543
  var valid_580544 = query.getOrDefault("callback")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "callback", valid_580544
  var valid_580545 = query.getOrDefault("fields")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "fields", valid_580545
  var valid_580546 = query.getOrDefault("access_token")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "access_token", valid_580546
  var valid_580547 = query.getOrDefault("upload_protocol")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "upload_protocol", valid_580547
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

proc call*(call_580549: Call_DataflowProjectsTemplatesCreate_580533;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Cloud Dataflow job from a template.
  ## 
  let valid = call_580549.validator(path, query, header, formData, body)
  let scheme = call_580549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580549.url(scheme.get, call_580549.host, call_580549.base,
                         call_580549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580549, url, valid)

proc call*(call_580550: Call_DataflowProjectsTemplatesCreate_580533;
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
  var path_580551 = newJObject()
  var query_580552 = newJObject()
  var body_580553 = newJObject()
  add(query_580552, "key", newJString(key))
  add(query_580552, "prettyPrint", newJBool(prettyPrint))
  add(query_580552, "oauth_token", newJString(oauthToken))
  add(path_580551, "projectId", newJString(projectId))
  add(query_580552, "$.xgafv", newJString(Xgafv))
  add(query_580552, "alt", newJString(alt))
  add(query_580552, "uploadType", newJString(uploadType))
  add(query_580552, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580553 = body
  add(query_580552, "callback", newJString(callback))
  add(query_580552, "fields", newJString(fields))
  add(query_580552, "access_token", newJString(accessToken))
  add(query_580552, "upload_protocol", newJString(uploadProtocol))
  result = call_580550.call(path_580551, query_580552, nil, nil, body_580553)

var dataflowProjectsTemplatesCreate* = Call_DataflowProjectsTemplatesCreate_580533(
    name: "dataflowProjectsTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates",
    validator: validate_DataflowProjectsTemplatesCreate_580534, base: "/",
    url: url_DataflowProjectsTemplatesCreate_580535, schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesGet_580554 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsTemplatesGet_580556(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsTemplatesGet_580555(path: JsonNode; query: JsonNode;
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
  var valid_580557 = path.getOrDefault("projectId")
  valid_580557 = validateParameter(valid_580557, JString, required = true,
                                 default = nil)
  if valid_580557 != nil:
    section.add "projectId", valid_580557
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
  var valid_580558 = query.getOrDefault("key")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "key", valid_580558
  var valid_580559 = query.getOrDefault("prettyPrint")
  valid_580559 = validateParameter(valid_580559, JBool, required = false,
                                 default = newJBool(true))
  if valid_580559 != nil:
    section.add "prettyPrint", valid_580559
  var valid_580560 = query.getOrDefault("oauth_token")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = nil)
  if valid_580560 != nil:
    section.add "oauth_token", valid_580560
  var valid_580561 = query.getOrDefault("$.xgafv")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = newJString("1"))
  if valid_580561 != nil:
    section.add "$.xgafv", valid_580561
  var valid_580562 = query.getOrDefault("alt")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = newJString("json"))
  if valid_580562 != nil:
    section.add "alt", valid_580562
  var valid_580563 = query.getOrDefault("uploadType")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "uploadType", valid_580563
  var valid_580564 = query.getOrDefault("quotaUser")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = nil)
  if valid_580564 != nil:
    section.add "quotaUser", valid_580564
  var valid_580565 = query.getOrDefault("location")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "location", valid_580565
  var valid_580566 = query.getOrDefault("gcsPath")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "gcsPath", valid_580566
  var valid_580567 = query.getOrDefault("callback")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = nil)
  if valid_580567 != nil:
    section.add "callback", valid_580567
  var valid_580568 = query.getOrDefault("fields")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "fields", valid_580568
  var valid_580569 = query.getOrDefault("access_token")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "access_token", valid_580569
  var valid_580570 = query.getOrDefault("upload_protocol")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "upload_protocol", valid_580570
  var valid_580571 = query.getOrDefault("view")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = newJString("METADATA_ONLY"))
  if valid_580571 != nil:
    section.add "view", valid_580571
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580572: Call_DataflowProjectsTemplatesGet_580554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the template associated with a template.
  ## 
  let valid = call_580572.validator(path, query, header, formData, body)
  let scheme = call_580572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580572.url(scheme.get, call_580572.host, call_580572.base,
                         call_580572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580572, url, valid)

proc call*(call_580573: Call_DataflowProjectsTemplatesGet_580554;
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
  var path_580574 = newJObject()
  var query_580575 = newJObject()
  add(query_580575, "key", newJString(key))
  add(query_580575, "prettyPrint", newJBool(prettyPrint))
  add(query_580575, "oauth_token", newJString(oauthToken))
  add(path_580574, "projectId", newJString(projectId))
  add(query_580575, "$.xgafv", newJString(Xgafv))
  add(query_580575, "alt", newJString(alt))
  add(query_580575, "uploadType", newJString(uploadType))
  add(query_580575, "quotaUser", newJString(quotaUser))
  add(query_580575, "location", newJString(location))
  add(query_580575, "gcsPath", newJString(gcsPath))
  add(query_580575, "callback", newJString(callback))
  add(query_580575, "fields", newJString(fields))
  add(query_580575, "access_token", newJString(accessToken))
  add(query_580575, "upload_protocol", newJString(uploadProtocol))
  add(query_580575, "view", newJString(view))
  result = call_580573.call(path_580574, query_580575, nil, nil, nil)

var dataflowProjectsTemplatesGet* = Call_DataflowProjectsTemplatesGet_580554(
    name: "dataflowProjectsTemplatesGet", meth: HttpMethod.HttpGet,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates:get",
    validator: validate_DataflowProjectsTemplatesGet_580555, base: "/",
    url: url_DataflowProjectsTemplatesGet_580556, schemes: {Scheme.Https})
type
  Call_DataflowProjectsTemplatesLaunch_580576 = ref object of OpenApiRestCall_579373
proc url_DataflowProjectsTemplatesLaunch_580578(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DataflowProjectsTemplatesLaunch_580577(path: JsonNode;
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
  var valid_580579 = path.getOrDefault("projectId")
  valid_580579 = validateParameter(valid_580579, JString, required = true,
                                 default = nil)
  if valid_580579 != nil:
    section.add "projectId", valid_580579
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
  var valid_580580 = query.getOrDefault("key")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "key", valid_580580
  var valid_580581 = query.getOrDefault("prettyPrint")
  valid_580581 = validateParameter(valid_580581, JBool, required = false,
                                 default = newJBool(true))
  if valid_580581 != nil:
    section.add "prettyPrint", valid_580581
  var valid_580582 = query.getOrDefault("oauth_token")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "oauth_token", valid_580582
  var valid_580583 = query.getOrDefault("dynamicTemplate.gcsPath")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "dynamicTemplate.gcsPath", valid_580583
  var valid_580584 = query.getOrDefault("$.xgafv")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = newJString("1"))
  if valid_580584 != nil:
    section.add "$.xgafv", valid_580584
  var valid_580585 = query.getOrDefault("alt")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = newJString("json"))
  if valid_580585 != nil:
    section.add "alt", valid_580585
  var valid_580586 = query.getOrDefault("uploadType")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = nil)
  if valid_580586 != nil:
    section.add "uploadType", valid_580586
  var valid_580587 = query.getOrDefault("quotaUser")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "quotaUser", valid_580587
  var valid_580588 = query.getOrDefault("validateOnly")
  valid_580588 = validateParameter(valid_580588, JBool, required = false, default = nil)
  if valid_580588 != nil:
    section.add "validateOnly", valid_580588
  var valid_580589 = query.getOrDefault("location")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "location", valid_580589
  var valid_580590 = query.getOrDefault("gcsPath")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "gcsPath", valid_580590
  var valid_580591 = query.getOrDefault("callback")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "callback", valid_580591
  var valid_580592 = query.getOrDefault("fields")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "fields", valid_580592
  var valid_580593 = query.getOrDefault("access_token")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "access_token", valid_580593
  var valid_580594 = query.getOrDefault("upload_protocol")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "upload_protocol", valid_580594
  var valid_580595 = query.getOrDefault("dynamicTemplate.stagingLocation")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "dynamicTemplate.stagingLocation", valid_580595
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

proc call*(call_580597: Call_DataflowProjectsTemplatesLaunch_580576;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Launch a template.
  ## 
  let valid = call_580597.validator(path, query, header, formData, body)
  let scheme = call_580597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580597.url(scheme.get, call_580597.host, call_580597.base,
                         call_580597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580597, url, valid)

proc call*(call_580598: Call_DataflowProjectsTemplatesLaunch_580576;
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
  var path_580599 = newJObject()
  var query_580600 = newJObject()
  var body_580601 = newJObject()
  add(query_580600, "key", newJString(key))
  add(query_580600, "prettyPrint", newJBool(prettyPrint))
  add(query_580600, "oauth_token", newJString(oauthToken))
  add(path_580599, "projectId", newJString(projectId))
  add(query_580600, "dynamicTemplate.gcsPath", newJString(dynamicTemplateGcsPath))
  add(query_580600, "$.xgafv", newJString(Xgafv))
  add(query_580600, "alt", newJString(alt))
  add(query_580600, "uploadType", newJString(uploadType))
  add(query_580600, "quotaUser", newJString(quotaUser))
  add(query_580600, "validateOnly", newJBool(validateOnly))
  add(query_580600, "location", newJString(location))
  if body != nil:
    body_580601 = body
  add(query_580600, "gcsPath", newJString(gcsPath))
  add(query_580600, "callback", newJString(callback))
  add(query_580600, "fields", newJString(fields))
  add(query_580600, "access_token", newJString(accessToken))
  add(query_580600, "upload_protocol", newJString(uploadProtocol))
  add(query_580600, "dynamicTemplate.stagingLocation",
      newJString(dynamicTemplateStagingLocation))
  result = call_580598.call(path_580599, query_580600, nil, nil, body_580601)

var dataflowProjectsTemplatesLaunch* = Call_DataflowProjectsTemplatesLaunch_580576(
    name: "dataflowProjectsTemplatesLaunch", meth: HttpMethod.HttpPost,
    host: "dataflow.googleapis.com",
    route: "/v1b3/projects/{projectId}/templates:launch",
    validator: validate_DataflowProjectsTemplatesLaunch_580577, base: "/",
    url: url_DataflowProjectsTemplatesLaunch_580578, schemes: {Scheme.Https})
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
