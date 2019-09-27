
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Scheduler
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Creates and manages jobs run on a regular recurring schedule.
## 
## https://cloud.google.com/scheduler/
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
  gcpServiceName = "cloudscheduler"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudschedulerProjectsLocationsJobsGet_597677 = ref object of OpenApiRestCall_597408
proc url_CloudschedulerProjectsLocationsJobsGet_597679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudschedulerProjectsLocationsJobsGet_597678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The job name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/jobs/JOB_ID`.
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597852: Call_CloudschedulerProjectsLocationsJobsGet_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a job.
  ## 
  let valid = call_597852.validator(path, query, header, formData, body)
  let scheme = call_597852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597852.url(scheme.get, call_597852.host, call_597852.base,
                         call_597852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597852, url, valid)

proc call*(call_597923: Call_CloudschedulerProjectsLocationsJobsGet_597677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudschedulerProjectsLocationsJobsGet
  ## Gets a job.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The job name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/jobs/JOB_ID`.
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
  var path_597924 = newJObject()
  var query_597926 = newJObject()
  add(query_597926, "upload_protocol", newJString(uploadProtocol))
  add(query_597926, "fields", newJString(fields))
  add(query_597926, "quotaUser", newJString(quotaUser))
  add(path_597924, "name", newJString(name))
  add(query_597926, "alt", newJString(alt))
  add(query_597926, "oauth_token", newJString(oauthToken))
  add(query_597926, "callback", newJString(callback))
  add(query_597926, "access_token", newJString(accessToken))
  add(query_597926, "uploadType", newJString(uploadType))
  add(query_597926, "key", newJString(key))
  add(query_597926, "$.xgafv", newJString(Xgafv))
  add(query_597926, "prettyPrint", newJBool(prettyPrint))
  result = call_597923.call(path_597924, query_597926, nil, nil, nil)

var cloudschedulerProjectsLocationsJobsGet* = Call_CloudschedulerProjectsLocationsJobsGet_597677(
    name: "cloudschedulerProjectsLocationsJobsGet", meth: HttpMethod.HttpGet,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudschedulerProjectsLocationsJobsGet_597678, base: "/",
    url: url_CloudschedulerProjectsLocationsJobsGet_597679,
    schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsJobsPatch_597984 = ref object of OpenApiRestCall_597408
proc url_CloudschedulerProjectsLocationsJobsPatch_597986(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudschedulerProjectsLocationsJobsPatch_597985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a job.
  ## 
  ## If successful, the updated Job is returned. If the job does
  ## not exist, `NOT_FOUND` is returned.
  ## 
  ## If UpdateJob does not successfully return, it is possible for the
  ## job to be in an Job.State.UPDATE_FAILED state. A job in this state may
  ## not be executed. If this happens, retry the UpdateJob request
  ## until a successful response is received.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Optionally caller-specified in CreateJob, after
  ## which it becomes output only.
  ## 
  ## The job name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/jobs/JOB_ID`.
  ## 
  ## * `PROJECT_ID` can contain letters ([A-Za-z]), numbers ([0-9]),
  ##    hyphens (-), colons (:), or periods (.).
  ##    For more information, see
  ##    [Identifying
  ##    
  ## projects](https://cloud.google.com/resource-manager/docs/creating-managing-projects#identifying_projects)
  ## * `LOCATION_ID` is the canonical ID for the job's location.
  ##    The list of available locations can be obtained by calling
  ##    ListLocations.
  ##    For more information, see https://cloud.google.com/about/locations/.
  ## * `JOB_ID` can contain only letters ([A-Za-z]), numbers ([0-9]),
  ##    hyphens (-), or underscores (_). The maximum length is 500 characters.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_597987 = path.getOrDefault("name")
  valid_597987 = validateParameter(valid_597987, JString, required = true,
                                 default = nil)
  if valid_597987 != nil:
    section.add "name", valid_597987
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
  ##             : A  mask used to specify which fields of the job are being updated.
  section = newJObject()
  var valid_597988 = query.getOrDefault("upload_protocol")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = nil)
  if valid_597988 != nil:
    section.add "upload_protocol", valid_597988
  var valid_597989 = query.getOrDefault("fields")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "fields", valid_597989
  var valid_597990 = query.getOrDefault("quotaUser")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "quotaUser", valid_597990
  var valid_597991 = query.getOrDefault("alt")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = newJString("json"))
  if valid_597991 != nil:
    section.add "alt", valid_597991
  var valid_597992 = query.getOrDefault("oauth_token")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "oauth_token", valid_597992
  var valid_597993 = query.getOrDefault("callback")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "callback", valid_597993
  var valid_597994 = query.getOrDefault("access_token")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "access_token", valid_597994
  var valid_597995 = query.getOrDefault("uploadType")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "uploadType", valid_597995
  var valid_597996 = query.getOrDefault("key")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "key", valid_597996
  var valid_597997 = query.getOrDefault("$.xgafv")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = newJString("1"))
  if valid_597997 != nil:
    section.add "$.xgafv", valid_597997
  var valid_597998 = query.getOrDefault("prettyPrint")
  valid_597998 = validateParameter(valid_597998, JBool, required = false,
                                 default = newJBool(true))
  if valid_597998 != nil:
    section.add "prettyPrint", valid_597998
  var valid_597999 = query.getOrDefault("updateMask")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "updateMask", valid_597999
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

proc call*(call_598001: Call_CloudschedulerProjectsLocationsJobsPatch_597984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a job.
  ## 
  ## If successful, the updated Job is returned. If the job does
  ## not exist, `NOT_FOUND` is returned.
  ## 
  ## If UpdateJob does not successfully return, it is possible for the
  ## job to be in an Job.State.UPDATE_FAILED state. A job in this state may
  ## not be executed. If this happens, retry the UpdateJob request
  ## until a successful response is received.
  ## 
  let valid = call_598001.validator(path, query, header, formData, body)
  let scheme = call_598001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598001.url(scheme.get, call_598001.host, call_598001.base,
                         call_598001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598001, url, valid)

proc call*(call_598002: Call_CloudschedulerProjectsLocationsJobsPatch_597984;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## cloudschedulerProjectsLocationsJobsPatch
  ## Updates a job.
  ## 
  ## If successful, the updated Job is returned. If the job does
  ## not exist, `NOT_FOUND` is returned.
  ## 
  ## If UpdateJob does not successfully return, it is possible for the
  ## job to be in an Job.State.UPDATE_FAILED state. A job in this state may
  ## not be executed. If this happens, retry the UpdateJob request
  ## until a successful response is received.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Optionally caller-specified in CreateJob, after
  ## which it becomes output only.
  ## 
  ## The job name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/jobs/JOB_ID`.
  ## 
  ## * `PROJECT_ID` can contain letters ([A-Za-z]), numbers ([0-9]),
  ##    hyphens (-), colons (:), or periods (.).
  ##    For more information, see
  ##    [Identifying
  ##    
  ## projects](https://cloud.google.com/resource-manager/docs/creating-managing-projects#identifying_projects)
  ## * `LOCATION_ID` is the canonical ID for the job's location.
  ##    The list of available locations can be obtained by calling
  ##    ListLocations.
  ##    For more information, see https://cloud.google.com/about/locations/.
  ## * `JOB_ID` can contain only letters ([A-Za-z]), numbers ([0-9]),
  ##    hyphens (-), or underscores (_). The maximum length is 500 characters.
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
  ##             : A  mask used to specify which fields of the job are being updated.
  var path_598003 = newJObject()
  var query_598004 = newJObject()
  var body_598005 = newJObject()
  add(query_598004, "upload_protocol", newJString(uploadProtocol))
  add(query_598004, "fields", newJString(fields))
  add(query_598004, "quotaUser", newJString(quotaUser))
  add(path_598003, "name", newJString(name))
  add(query_598004, "alt", newJString(alt))
  add(query_598004, "oauth_token", newJString(oauthToken))
  add(query_598004, "callback", newJString(callback))
  add(query_598004, "access_token", newJString(accessToken))
  add(query_598004, "uploadType", newJString(uploadType))
  add(query_598004, "key", newJString(key))
  add(query_598004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598005 = body
  add(query_598004, "prettyPrint", newJBool(prettyPrint))
  add(query_598004, "updateMask", newJString(updateMask))
  result = call_598002.call(path_598003, query_598004, nil, nil, body_598005)

var cloudschedulerProjectsLocationsJobsPatch* = Call_CloudschedulerProjectsLocationsJobsPatch_597984(
    name: "cloudschedulerProjectsLocationsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudschedulerProjectsLocationsJobsPatch_597985,
    base: "/", url: url_CloudschedulerProjectsLocationsJobsPatch_597986,
    schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsJobsDelete_597965 = ref object of OpenApiRestCall_597408
proc url_CloudschedulerProjectsLocationsJobsDelete_597967(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudschedulerProjectsLocationsJobsDelete_597966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The job name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/jobs/JOB_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_597968 = path.getOrDefault("name")
  valid_597968 = validateParameter(valid_597968, JString, required = true,
                                 default = nil)
  if valid_597968 != nil:
    section.add "name", valid_597968
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
  var valid_597969 = query.getOrDefault("upload_protocol")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "upload_protocol", valid_597969
  var valid_597970 = query.getOrDefault("fields")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "fields", valid_597970
  var valid_597971 = query.getOrDefault("quotaUser")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "quotaUser", valid_597971
  var valid_597972 = query.getOrDefault("alt")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = newJString("json"))
  if valid_597972 != nil:
    section.add "alt", valid_597972
  var valid_597973 = query.getOrDefault("oauth_token")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "oauth_token", valid_597973
  var valid_597974 = query.getOrDefault("callback")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "callback", valid_597974
  var valid_597975 = query.getOrDefault("access_token")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "access_token", valid_597975
  var valid_597976 = query.getOrDefault("uploadType")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "uploadType", valid_597976
  var valid_597977 = query.getOrDefault("key")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "key", valid_597977
  var valid_597978 = query.getOrDefault("$.xgafv")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = newJString("1"))
  if valid_597978 != nil:
    section.add "$.xgafv", valid_597978
  var valid_597979 = query.getOrDefault("prettyPrint")
  valid_597979 = validateParameter(valid_597979, JBool, required = false,
                                 default = newJBool(true))
  if valid_597979 != nil:
    section.add "prettyPrint", valid_597979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597980: Call_CloudschedulerProjectsLocationsJobsDelete_597965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a job.
  ## 
  let valid = call_597980.validator(path, query, header, formData, body)
  let scheme = call_597980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597980.url(scheme.get, call_597980.host, call_597980.base,
                         call_597980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597980, url, valid)

proc call*(call_597981: Call_CloudschedulerProjectsLocationsJobsDelete_597965;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudschedulerProjectsLocationsJobsDelete
  ## Deletes a job.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The job name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/jobs/JOB_ID`.
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
  var path_597982 = newJObject()
  var query_597983 = newJObject()
  add(query_597983, "upload_protocol", newJString(uploadProtocol))
  add(query_597983, "fields", newJString(fields))
  add(query_597983, "quotaUser", newJString(quotaUser))
  add(path_597982, "name", newJString(name))
  add(query_597983, "alt", newJString(alt))
  add(query_597983, "oauth_token", newJString(oauthToken))
  add(query_597983, "callback", newJString(callback))
  add(query_597983, "access_token", newJString(accessToken))
  add(query_597983, "uploadType", newJString(uploadType))
  add(query_597983, "key", newJString(key))
  add(query_597983, "$.xgafv", newJString(Xgafv))
  add(query_597983, "prettyPrint", newJBool(prettyPrint))
  result = call_597981.call(path_597982, query_597983, nil, nil, nil)

var cloudschedulerProjectsLocationsJobsDelete* = Call_CloudschedulerProjectsLocationsJobsDelete_597965(
    name: "cloudschedulerProjectsLocationsJobsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudscheduler.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_CloudschedulerProjectsLocationsJobsDelete_597966,
    base: "/", url: url_CloudschedulerProjectsLocationsJobsDelete_597967,
    schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsList_598006 = ref object of OpenApiRestCall_597408
proc url_CloudschedulerProjectsLocationsList_598008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudschedulerProjectsLocationsList_598007(path: JsonNode;
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
  var valid_598009 = path.getOrDefault("name")
  valid_598009 = validateParameter(valid_598009, JString, required = true,
                                 default = nil)
  if valid_598009 != nil:
    section.add "name", valid_598009
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
  var valid_598010 = query.getOrDefault("upload_protocol")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "upload_protocol", valid_598010
  var valid_598011 = query.getOrDefault("fields")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "fields", valid_598011
  var valid_598012 = query.getOrDefault("pageToken")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "pageToken", valid_598012
  var valid_598013 = query.getOrDefault("quotaUser")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "quotaUser", valid_598013
  var valid_598014 = query.getOrDefault("alt")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = newJString("json"))
  if valid_598014 != nil:
    section.add "alt", valid_598014
  var valid_598015 = query.getOrDefault("oauth_token")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "oauth_token", valid_598015
  var valid_598016 = query.getOrDefault("callback")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "callback", valid_598016
  var valid_598017 = query.getOrDefault("access_token")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "access_token", valid_598017
  var valid_598018 = query.getOrDefault("uploadType")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "uploadType", valid_598018
  var valid_598019 = query.getOrDefault("key")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "key", valid_598019
  var valid_598020 = query.getOrDefault("$.xgafv")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = newJString("1"))
  if valid_598020 != nil:
    section.add "$.xgafv", valid_598020
  var valid_598021 = query.getOrDefault("pageSize")
  valid_598021 = validateParameter(valid_598021, JInt, required = false, default = nil)
  if valid_598021 != nil:
    section.add "pageSize", valid_598021
  var valid_598022 = query.getOrDefault("prettyPrint")
  valid_598022 = validateParameter(valid_598022, JBool, required = false,
                                 default = newJBool(true))
  if valid_598022 != nil:
    section.add "prettyPrint", valid_598022
  var valid_598023 = query.getOrDefault("filter")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = nil)
  if valid_598023 != nil:
    section.add "filter", valid_598023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598024: Call_CloudschedulerProjectsLocationsList_598006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_598024.validator(path, query, header, formData, body)
  let scheme = call_598024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598024.url(scheme.get, call_598024.host, call_598024.base,
                         call_598024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598024, url, valid)

proc call*(call_598025: Call_CloudschedulerProjectsLocationsList_598006;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudschedulerProjectsLocationsList
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
  var path_598026 = newJObject()
  var query_598027 = newJObject()
  add(query_598027, "upload_protocol", newJString(uploadProtocol))
  add(query_598027, "fields", newJString(fields))
  add(query_598027, "pageToken", newJString(pageToken))
  add(query_598027, "quotaUser", newJString(quotaUser))
  add(path_598026, "name", newJString(name))
  add(query_598027, "alt", newJString(alt))
  add(query_598027, "oauth_token", newJString(oauthToken))
  add(query_598027, "callback", newJString(callback))
  add(query_598027, "access_token", newJString(accessToken))
  add(query_598027, "uploadType", newJString(uploadType))
  add(query_598027, "key", newJString(key))
  add(query_598027, "$.xgafv", newJString(Xgafv))
  add(query_598027, "pageSize", newJInt(pageSize))
  add(query_598027, "prettyPrint", newJBool(prettyPrint))
  add(query_598027, "filter", newJString(filter))
  result = call_598025.call(path_598026, query_598027, nil, nil, nil)

var cloudschedulerProjectsLocationsList* = Call_CloudschedulerProjectsLocationsList_598006(
    name: "cloudschedulerProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{name}/locations",
    validator: validate_CloudschedulerProjectsLocationsList_598007, base: "/",
    url: url_CloudschedulerProjectsLocationsList_598008, schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsJobsPause_598028 = ref object of OpenApiRestCall_597408
proc url_CloudschedulerProjectsLocationsJobsPause_598030(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":pause")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudschedulerProjectsLocationsJobsPause_598029(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pauses a job.
  ## 
  ## If a job is paused then the system will stop executing the job
  ## until it is re-enabled via ResumeJob. The
  ## state of the job is stored in state; if paused it
  ## will be set to Job.State.PAUSED. A job must be in Job.State.ENABLED
  ## to be paused.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The job name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/jobs/JOB_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_598031 = path.getOrDefault("name")
  valid_598031 = validateParameter(valid_598031, JString, required = true,
                                 default = nil)
  if valid_598031 != nil:
    section.add "name", valid_598031
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
  var valid_598032 = query.getOrDefault("upload_protocol")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "upload_protocol", valid_598032
  var valid_598033 = query.getOrDefault("fields")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "fields", valid_598033
  var valid_598034 = query.getOrDefault("quotaUser")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "quotaUser", valid_598034
  var valid_598035 = query.getOrDefault("alt")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = newJString("json"))
  if valid_598035 != nil:
    section.add "alt", valid_598035
  var valid_598036 = query.getOrDefault("oauth_token")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "oauth_token", valid_598036
  var valid_598037 = query.getOrDefault("callback")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "callback", valid_598037
  var valid_598038 = query.getOrDefault("access_token")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "access_token", valid_598038
  var valid_598039 = query.getOrDefault("uploadType")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "uploadType", valid_598039
  var valid_598040 = query.getOrDefault("key")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "key", valid_598040
  var valid_598041 = query.getOrDefault("$.xgafv")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = newJString("1"))
  if valid_598041 != nil:
    section.add "$.xgafv", valid_598041
  var valid_598042 = query.getOrDefault("prettyPrint")
  valid_598042 = validateParameter(valid_598042, JBool, required = false,
                                 default = newJBool(true))
  if valid_598042 != nil:
    section.add "prettyPrint", valid_598042
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

proc call*(call_598044: Call_CloudschedulerProjectsLocationsJobsPause_598028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pauses a job.
  ## 
  ## If a job is paused then the system will stop executing the job
  ## until it is re-enabled via ResumeJob. The
  ## state of the job is stored in state; if paused it
  ## will be set to Job.State.PAUSED. A job must be in Job.State.ENABLED
  ## to be paused.
  ## 
  let valid = call_598044.validator(path, query, header, formData, body)
  let scheme = call_598044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598044.url(scheme.get, call_598044.host, call_598044.base,
                         call_598044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598044, url, valid)

proc call*(call_598045: Call_CloudschedulerProjectsLocationsJobsPause_598028;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudschedulerProjectsLocationsJobsPause
  ## Pauses a job.
  ## 
  ## If a job is paused then the system will stop executing the job
  ## until it is re-enabled via ResumeJob. The
  ## state of the job is stored in state; if paused it
  ## will be set to Job.State.PAUSED. A job must be in Job.State.ENABLED
  ## to be paused.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The job name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/jobs/JOB_ID`.
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
  var path_598046 = newJObject()
  var query_598047 = newJObject()
  var body_598048 = newJObject()
  add(query_598047, "upload_protocol", newJString(uploadProtocol))
  add(query_598047, "fields", newJString(fields))
  add(query_598047, "quotaUser", newJString(quotaUser))
  add(path_598046, "name", newJString(name))
  add(query_598047, "alt", newJString(alt))
  add(query_598047, "oauth_token", newJString(oauthToken))
  add(query_598047, "callback", newJString(callback))
  add(query_598047, "access_token", newJString(accessToken))
  add(query_598047, "uploadType", newJString(uploadType))
  add(query_598047, "key", newJString(key))
  add(query_598047, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598048 = body
  add(query_598047, "prettyPrint", newJBool(prettyPrint))
  result = call_598045.call(path_598046, query_598047, nil, nil, body_598048)

var cloudschedulerProjectsLocationsJobsPause* = Call_CloudschedulerProjectsLocationsJobsPause_598028(
    name: "cloudschedulerProjectsLocationsJobsPause", meth: HttpMethod.HttpPost,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{name}:pause",
    validator: validate_CloudschedulerProjectsLocationsJobsPause_598029,
    base: "/", url: url_CloudschedulerProjectsLocationsJobsPause_598030,
    schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsJobsResume_598049 = ref object of OpenApiRestCall_597408
proc url_CloudschedulerProjectsLocationsJobsResume_598051(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudschedulerProjectsLocationsJobsResume_598050(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resume a job.
  ## 
  ## This method reenables a job after it has been Job.State.PAUSED. The
  ## state of a job is stored in Job.state; after calling this method it
  ## will be set to Job.State.ENABLED. A job must be in
  ## Job.State.PAUSED to be resumed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The job name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/jobs/JOB_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_598052 = path.getOrDefault("name")
  valid_598052 = validateParameter(valid_598052, JString, required = true,
                                 default = nil)
  if valid_598052 != nil:
    section.add "name", valid_598052
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
  var valid_598053 = query.getOrDefault("upload_protocol")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "upload_protocol", valid_598053
  var valid_598054 = query.getOrDefault("fields")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "fields", valid_598054
  var valid_598055 = query.getOrDefault("quotaUser")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "quotaUser", valid_598055
  var valid_598056 = query.getOrDefault("alt")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = newJString("json"))
  if valid_598056 != nil:
    section.add "alt", valid_598056
  var valid_598057 = query.getOrDefault("oauth_token")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "oauth_token", valid_598057
  var valid_598058 = query.getOrDefault("callback")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "callback", valid_598058
  var valid_598059 = query.getOrDefault("access_token")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "access_token", valid_598059
  var valid_598060 = query.getOrDefault("uploadType")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "uploadType", valid_598060
  var valid_598061 = query.getOrDefault("key")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "key", valid_598061
  var valid_598062 = query.getOrDefault("$.xgafv")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = newJString("1"))
  if valid_598062 != nil:
    section.add "$.xgafv", valid_598062
  var valid_598063 = query.getOrDefault("prettyPrint")
  valid_598063 = validateParameter(valid_598063, JBool, required = false,
                                 default = newJBool(true))
  if valid_598063 != nil:
    section.add "prettyPrint", valid_598063
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

proc call*(call_598065: Call_CloudschedulerProjectsLocationsJobsResume_598049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resume a job.
  ## 
  ## This method reenables a job after it has been Job.State.PAUSED. The
  ## state of a job is stored in Job.state; after calling this method it
  ## will be set to Job.State.ENABLED. A job must be in
  ## Job.State.PAUSED to be resumed.
  ## 
  let valid = call_598065.validator(path, query, header, formData, body)
  let scheme = call_598065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598065.url(scheme.get, call_598065.host, call_598065.base,
                         call_598065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598065, url, valid)

proc call*(call_598066: Call_CloudschedulerProjectsLocationsJobsResume_598049;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudschedulerProjectsLocationsJobsResume
  ## Resume a job.
  ## 
  ## This method reenables a job after it has been Job.State.PAUSED. The
  ## state of a job is stored in Job.state; after calling this method it
  ## will be set to Job.State.ENABLED. A job must be in
  ## Job.State.PAUSED to be resumed.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The job name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/jobs/JOB_ID`.
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
  var path_598067 = newJObject()
  var query_598068 = newJObject()
  var body_598069 = newJObject()
  add(query_598068, "upload_protocol", newJString(uploadProtocol))
  add(query_598068, "fields", newJString(fields))
  add(query_598068, "quotaUser", newJString(quotaUser))
  add(path_598067, "name", newJString(name))
  add(query_598068, "alt", newJString(alt))
  add(query_598068, "oauth_token", newJString(oauthToken))
  add(query_598068, "callback", newJString(callback))
  add(query_598068, "access_token", newJString(accessToken))
  add(query_598068, "uploadType", newJString(uploadType))
  add(query_598068, "key", newJString(key))
  add(query_598068, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598069 = body
  add(query_598068, "prettyPrint", newJBool(prettyPrint))
  result = call_598066.call(path_598067, query_598068, nil, nil, body_598069)

var cloudschedulerProjectsLocationsJobsResume* = Call_CloudschedulerProjectsLocationsJobsResume_598049(
    name: "cloudschedulerProjectsLocationsJobsResume", meth: HttpMethod.HttpPost,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{name}:resume",
    validator: validate_CloudschedulerProjectsLocationsJobsResume_598050,
    base: "/", url: url_CloudschedulerProjectsLocationsJobsResume_598051,
    schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsJobsRun_598070 = ref object of OpenApiRestCall_597408
proc url_CloudschedulerProjectsLocationsJobsRun_598072(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudschedulerProjectsLocationsJobsRun_598071(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Forces a job to run now.
  ## 
  ## When this method is called, Cloud Scheduler will dispatch the job, even
  ## if the job is already running.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The job name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/jobs/JOB_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_598073 = path.getOrDefault("name")
  valid_598073 = validateParameter(valid_598073, JString, required = true,
                                 default = nil)
  if valid_598073 != nil:
    section.add "name", valid_598073
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
  var valid_598074 = query.getOrDefault("upload_protocol")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "upload_protocol", valid_598074
  var valid_598075 = query.getOrDefault("fields")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "fields", valid_598075
  var valid_598076 = query.getOrDefault("quotaUser")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "quotaUser", valid_598076
  var valid_598077 = query.getOrDefault("alt")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = newJString("json"))
  if valid_598077 != nil:
    section.add "alt", valid_598077
  var valid_598078 = query.getOrDefault("oauth_token")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "oauth_token", valid_598078
  var valid_598079 = query.getOrDefault("callback")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "callback", valid_598079
  var valid_598080 = query.getOrDefault("access_token")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "access_token", valid_598080
  var valid_598081 = query.getOrDefault("uploadType")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "uploadType", valid_598081
  var valid_598082 = query.getOrDefault("key")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "key", valid_598082
  var valid_598083 = query.getOrDefault("$.xgafv")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = newJString("1"))
  if valid_598083 != nil:
    section.add "$.xgafv", valid_598083
  var valid_598084 = query.getOrDefault("prettyPrint")
  valid_598084 = validateParameter(valid_598084, JBool, required = false,
                                 default = newJBool(true))
  if valid_598084 != nil:
    section.add "prettyPrint", valid_598084
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

proc call*(call_598086: Call_CloudschedulerProjectsLocationsJobsRun_598070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Forces a job to run now.
  ## 
  ## When this method is called, Cloud Scheduler will dispatch the job, even
  ## if the job is already running.
  ## 
  let valid = call_598086.validator(path, query, header, formData, body)
  let scheme = call_598086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598086.url(scheme.get, call_598086.host, call_598086.base,
                         call_598086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598086, url, valid)

proc call*(call_598087: Call_CloudschedulerProjectsLocationsJobsRun_598070;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudschedulerProjectsLocationsJobsRun
  ## Forces a job to run now.
  ## 
  ## When this method is called, Cloud Scheduler will dispatch the job, even
  ## if the job is already running.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The job name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID/jobs/JOB_ID`.
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
  var path_598088 = newJObject()
  var query_598089 = newJObject()
  var body_598090 = newJObject()
  add(query_598089, "upload_protocol", newJString(uploadProtocol))
  add(query_598089, "fields", newJString(fields))
  add(query_598089, "quotaUser", newJString(quotaUser))
  add(path_598088, "name", newJString(name))
  add(query_598089, "alt", newJString(alt))
  add(query_598089, "oauth_token", newJString(oauthToken))
  add(query_598089, "callback", newJString(callback))
  add(query_598089, "access_token", newJString(accessToken))
  add(query_598089, "uploadType", newJString(uploadType))
  add(query_598089, "key", newJString(key))
  add(query_598089, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598090 = body
  add(query_598089, "prettyPrint", newJBool(prettyPrint))
  result = call_598087.call(path_598088, query_598089, nil, nil, body_598090)

var cloudschedulerProjectsLocationsJobsRun* = Call_CloudschedulerProjectsLocationsJobsRun_598070(
    name: "cloudschedulerProjectsLocationsJobsRun", meth: HttpMethod.HttpPost,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{name}:run",
    validator: validate_CloudschedulerProjectsLocationsJobsRun_598071, base: "/",
    url: url_CloudschedulerProjectsLocationsJobsRun_598072,
    schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsJobsCreate_598112 = ref object of OpenApiRestCall_597408
proc url_CloudschedulerProjectsLocationsJobsCreate_598114(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudschedulerProjectsLocationsJobsCreate_598113(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The location name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_598115 = path.getOrDefault("parent")
  valid_598115 = validateParameter(valid_598115, JString, required = true,
                                 default = nil)
  if valid_598115 != nil:
    section.add "parent", valid_598115
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
  var valid_598116 = query.getOrDefault("upload_protocol")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "upload_protocol", valid_598116
  var valid_598117 = query.getOrDefault("fields")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "fields", valid_598117
  var valid_598118 = query.getOrDefault("quotaUser")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "quotaUser", valid_598118
  var valid_598119 = query.getOrDefault("alt")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = newJString("json"))
  if valid_598119 != nil:
    section.add "alt", valid_598119
  var valid_598120 = query.getOrDefault("oauth_token")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "oauth_token", valid_598120
  var valid_598121 = query.getOrDefault("callback")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "callback", valid_598121
  var valid_598122 = query.getOrDefault("access_token")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "access_token", valid_598122
  var valid_598123 = query.getOrDefault("uploadType")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "uploadType", valid_598123
  var valid_598124 = query.getOrDefault("key")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "key", valid_598124
  var valid_598125 = query.getOrDefault("$.xgafv")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = newJString("1"))
  if valid_598125 != nil:
    section.add "$.xgafv", valid_598125
  var valid_598126 = query.getOrDefault("prettyPrint")
  valid_598126 = validateParameter(valid_598126, JBool, required = false,
                                 default = newJBool(true))
  if valid_598126 != nil:
    section.add "prettyPrint", valid_598126
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

proc call*(call_598128: Call_CloudschedulerProjectsLocationsJobsCreate_598112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a job.
  ## 
  let valid = call_598128.validator(path, query, header, formData, body)
  let scheme = call_598128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598128.url(scheme.get, call_598128.host, call_598128.base,
                         call_598128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598128, url, valid)

proc call*(call_598129: Call_CloudschedulerProjectsLocationsJobsCreate_598112;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudschedulerProjectsLocationsJobsCreate
  ## Creates a job.
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
  ##         : Required. The location name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598130 = newJObject()
  var query_598131 = newJObject()
  var body_598132 = newJObject()
  add(query_598131, "upload_protocol", newJString(uploadProtocol))
  add(query_598131, "fields", newJString(fields))
  add(query_598131, "quotaUser", newJString(quotaUser))
  add(query_598131, "alt", newJString(alt))
  add(query_598131, "oauth_token", newJString(oauthToken))
  add(query_598131, "callback", newJString(callback))
  add(query_598131, "access_token", newJString(accessToken))
  add(query_598131, "uploadType", newJString(uploadType))
  add(path_598130, "parent", newJString(parent))
  add(query_598131, "key", newJString(key))
  add(query_598131, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598132 = body
  add(query_598131, "prettyPrint", newJBool(prettyPrint))
  result = call_598129.call(path_598130, query_598131, nil, nil, body_598132)

var cloudschedulerProjectsLocationsJobsCreate* = Call_CloudschedulerProjectsLocationsJobsCreate_598112(
    name: "cloudschedulerProjectsLocationsJobsCreate", meth: HttpMethod.HttpPost,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{parent}/jobs",
    validator: validate_CloudschedulerProjectsLocationsJobsCreate_598113,
    base: "/", url: url_CloudschedulerProjectsLocationsJobsCreate_598114,
    schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsJobsList_598091 = ref object of OpenApiRestCall_597408
proc url_CloudschedulerProjectsLocationsJobsList_598093(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudschedulerProjectsLocationsJobsList_598092(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists jobs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The location name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_598094 = path.getOrDefault("parent")
  valid_598094 = validateParameter(valid_598094, JString, required = true,
                                 default = nil)
  if valid_598094 != nil:
    section.add "parent", valid_598094
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results the server will return. To
  ## request the first page results, page_token must be empty. To
  ## request the next page of results, page_token must be the value of
  ## next_page_token returned from
  ## the previous call to ListJobs. It is an error to
  ## switch the value of filter or
  ## order_by while iterating through pages.
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
  ## The maximum page size is 500. If unspecified, the page size will
  ## be the maximum. Fewer jobs than requested might be returned,
  ## even if more jobs exist; use next_page_token to determine if more
  ## jobs exist.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598095 = query.getOrDefault("upload_protocol")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "upload_protocol", valid_598095
  var valid_598096 = query.getOrDefault("fields")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "fields", valid_598096
  var valid_598097 = query.getOrDefault("pageToken")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "pageToken", valid_598097
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
  var valid_598106 = query.getOrDefault("pageSize")
  valid_598106 = validateParameter(valid_598106, JInt, required = false, default = nil)
  if valid_598106 != nil:
    section.add "pageSize", valid_598106
  var valid_598107 = query.getOrDefault("prettyPrint")
  valid_598107 = validateParameter(valid_598107, JBool, required = false,
                                 default = newJBool(true))
  if valid_598107 != nil:
    section.add "prettyPrint", valid_598107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598108: Call_CloudschedulerProjectsLocationsJobsList_598091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists jobs.
  ## 
  let valid = call_598108.validator(path, query, header, formData, body)
  let scheme = call_598108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598108.url(scheme.get, call_598108.host, call_598108.base,
                         call_598108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598108, url, valid)

proc call*(call_598109: Call_CloudschedulerProjectsLocationsJobsList_598091;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudschedulerProjectsLocationsJobsList
  ## Lists jobs.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results the server will return. To
  ## request the first page results, page_token must be empty. To
  ## request the next page of results, page_token must be the value of
  ## next_page_token returned from
  ## the previous call to ListJobs. It is an error to
  ## switch the value of filter or
  ## order_by while iterating through pages.
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
  ##         : Required. The location name. For example:
  ## `projects/PROJECT_ID/locations/LOCATION_ID`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size.
  ## 
  ## The maximum page size is 500. If unspecified, the page size will
  ## be the maximum. Fewer jobs than requested might be returned,
  ## even if more jobs exist; use next_page_token to determine if more
  ## jobs exist.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598110 = newJObject()
  var query_598111 = newJObject()
  add(query_598111, "upload_protocol", newJString(uploadProtocol))
  add(query_598111, "fields", newJString(fields))
  add(query_598111, "pageToken", newJString(pageToken))
  add(query_598111, "quotaUser", newJString(quotaUser))
  add(query_598111, "alt", newJString(alt))
  add(query_598111, "oauth_token", newJString(oauthToken))
  add(query_598111, "callback", newJString(callback))
  add(query_598111, "access_token", newJString(accessToken))
  add(query_598111, "uploadType", newJString(uploadType))
  add(path_598110, "parent", newJString(parent))
  add(query_598111, "key", newJString(key))
  add(query_598111, "$.xgafv", newJString(Xgafv))
  add(query_598111, "pageSize", newJInt(pageSize))
  add(query_598111, "prettyPrint", newJBool(prettyPrint))
  result = call_598109.call(path_598110, query_598111, nil, nil, nil)

var cloudschedulerProjectsLocationsJobsList* = Call_CloudschedulerProjectsLocationsJobsList_598091(
    name: "cloudschedulerProjectsLocationsJobsList", meth: HttpMethod.HttpGet,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{parent}/jobs",
    validator: validate_CloudschedulerProjectsLocationsJobsList_598092, base: "/",
    url: url_CloudschedulerProjectsLocationsJobsList_598093,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
