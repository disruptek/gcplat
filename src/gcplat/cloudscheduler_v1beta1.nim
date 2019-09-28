
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  gcpServiceName = "cloudscheduler"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudschedulerProjectsLocationsJobsGet_579677 = ref object of OpenApiRestCall_579408
proc url_CloudschedulerProjectsLocationsJobsGet_579679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudschedulerProjectsLocationsJobsGet_579678(path: JsonNode;
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579852: Call_CloudschedulerProjectsLocationsJobsGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a job.
  ## 
  let valid = call_579852.validator(path, query, header, formData, body)
  let scheme = call_579852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579852.url(scheme.get, call_579852.host, call_579852.base,
                         call_579852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579852, url, valid)

proc call*(call_579923: Call_CloudschedulerProjectsLocationsJobsGet_579677;
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
  var path_579924 = newJObject()
  var query_579926 = newJObject()
  add(query_579926, "upload_protocol", newJString(uploadProtocol))
  add(query_579926, "fields", newJString(fields))
  add(query_579926, "quotaUser", newJString(quotaUser))
  add(path_579924, "name", newJString(name))
  add(query_579926, "alt", newJString(alt))
  add(query_579926, "oauth_token", newJString(oauthToken))
  add(query_579926, "callback", newJString(callback))
  add(query_579926, "access_token", newJString(accessToken))
  add(query_579926, "uploadType", newJString(uploadType))
  add(query_579926, "key", newJString(key))
  add(query_579926, "$.xgafv", newJString(Xgafv))
  add(query_579926, "prettyPrint", newJBool(prettyPrint))
  result = call_579923.call(path_579924, query_579926, nil, nil, nil)

var cloudschedulerProjectsLocationsJobsGet* = Call_CloudschedulerProjectsLocationsJobsGet_579677(
    name: "cloudschedulerProjectsLocationsJobsGet", meth: HttpMethod.HttpGet,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudschedulerProjectsLocationsJobsGet_579678, base: "/",
    url: url_CloudschedulerProjectsLocationsJobsGet_579679,
    schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsJobsPatch_579984 = ref object of OpenApiRestCall_579408
proc url_CloudschedulerProjectsLocationsJobsPatch_579986(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudschedulerProjectsLocationsJobsPatch_579985(path: JsonNode;
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
  var valid_579987 = path.getOrDefault("name")
  valid_579987 = validateParameter(valid_579987, JString, required = true,
                                 default = nil)
  if valid_579987 != nil:
    section.add "name", valid_579987
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
  var valid_579988 = query.getOrDefault("upload_protocol")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "upload_protocol", valid_579988
  var valid_579989 = query.getOrDefault("fields")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "fields", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("callback")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "callback", valid_579993
  var valid_579994 = query.getOrDefault("access_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "access_token", valid_579994
  var valid_579995 = query.getOrDefault("uploadType")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "uploadType", valid_579995
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("$.xgafv")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("1"))
  if valid_579997 != nil:
    section.add "$.xgafv", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
  var valid_579999 = query.getOrDefault("updateMask")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "updateMask", valid_579999
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

proc call*(call_580001: Call_CloudschedulerProjectsLocationsJobsPatch_579984;
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
  let valid = call_580001.validator(path, query, header, formData, body)
  let scheme = call_580001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580001.url(scheme.get, call_580001.host, call_580001.base,
                         call_580001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580001, url, valid)

proc call*(call_580002: Call_CloudschedulerProjectsLocationsJobsPatch_579984;
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
  var path_580003 = newJObject()
  var query_580004 = newJObject()
  var body_580005 = newJObject()
  add(query_580004, "upload_protocol", newJString(uploadProtocol))
  add(query_580004, "fields", newJString(fields))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(path_580003, "name", newJString(name))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "callback", newJString(callback))
  add(query_580004, "access_token", newJString(accessToken))
  add(query_580004, "uploadType", newJString(uploadType))
  add(query_580004, "key", newJString(key))
  add(query_580004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580005 = body
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  add(query_580004, "updateMask", newJString(updateMask))
  result = call_580002.call(path_580003, query_580004, nil, nil, body_580005)

var cloudschedulerProjectsLocationsJobsPatch* = Call_CloudschedulerProjectsLocationsJobsPatch_579984(
    name: "cloudschedulerProjectsLocationsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudschedulerProjectsLocationsJobsPatch_579985,
    base: "/", url: url_CloudschedulerProjectsLocationsJobsPatch_579986,
    schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsJobsDelete_579965 = ref object of OpenApiRestCall_579408
proc url_CloudschedulerProjectsLocationsJobsDelete_579967(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudschedulerProjectsLocationsJobsDelete_579966(path: JsonNode;
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
  var valid_579968 = path.getOrDefault("name")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "name", valid_579968
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
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("access_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "access_token", valid_579975
  var valid_579976 = query.getOrDefault("uploadType")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "uploadType", valid_579976
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("$.xgafv")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("1"))
  if valid_579978 != nil:
    section.add "$.xgafv", valid_579978
  var valid_579979 = query.getOrDefault("prettyPrint")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(true))
  if valid_579979 != nil:
    section.add "prettyPrint", valid_579979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579980: Call_CloudschedulerProjectsLocationsJobsDelete_579965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a job.
  ## 
  let valid = call_579980.validator(path, query, header, formData, body)
  let scheme = call_579980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579980.url(scheme.get, call_579980.host, call_579980.base,
                         call_579980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579980, url, valid)

proc call*(call_579981: Call_CloudschedulerProjectsLocationsJobsDelete_579965;
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
  var path_579982 = newJObject()
  var query_579983 = newJObject()
  add(query_579983, "upload_protocol", newJString(uploadProtocol))
  add(query_579983, "fields", newJString(fields))
  add(query_579983, "quotaUser", newJString(quotaUser))
  add(path_579982, "name", newJString(name))
  add(query_579983, "alt", newJString(alt))
  add(query_579983, "oauth_token", newJString(oauthToken))
  add(query_579983, "callback", newJString(callback))
  add(query_579983, "access_token", newJString(accessToken))
  add(query_579983, "uploadType", newJString(uploadType))
  add(query_579983, "key", newJString(key))
  add(query_579983, "$.xgafv", newJString(Xgafv))
  add(query_579983, "prettyPrint", newJBool(prettyPrint))
  result = call_579981.call(path_579982, query_579983, nil, nil, nil)

var cloudschedulerProjectsLocationsJobsDelete* = Call_CloudschedulerProjectsLocationsJobsDelete_579965(
    name: "cloudschedulerProjectsLocationsJobsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudscheduler.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_CloudschedulerProjectsLocationsJobsDelete_579966,
    base: "/", url: url_CloudschedulerProjectsLocationsJobsDelete_579967,
    schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsList_580006 = ref object of OpenApiRestCall_579408
proc url_CloudschedulerProjectsLocationsList_580008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudschedulerProjectsLocationsList_580007(path: JsonNode;
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
  var valid_580009 = path.getOrDefault("name")
  valid_580009 = validateParameter(valid_580009, JString, required = true,
                                 default = nil)
  if valid_580009 != nil:
    section.add "name", valid_580009
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
  var valid_580010 = query.getOrDefault("upload_protocol")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "upload_protocol", valid_580010
  var valid_580011 = query.getOrDefault("fields")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "fields", valid_580011
  var valid_580012 = query.getOrDefault("pageToken")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "pageToken", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("callback")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "callback", valid_580016
  var valid_580017 = query.getOrDefault("access_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "access_token", valid_580017
  var valid_580018 = query.getOrDefault("uploadType")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "uploadType", valid_580018
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
  var valid_580021 = query.getOrDefault("pageSize")
  valid_580021 = validateParameter(valid_580021, JInt, required = false, default = nil)
  if valid_580021 != nil:
    section.add "pageSize", valid_580021
  var valid_580022 = query.getOrDefault("prettyPrint")
  valid_580022 = validateParameter(valid_580022, JBool, required = false,
                                 default = newJBool(true))
  if valid_580022 != nil:
    section.add "prettyPrint", valid_580022
  var valid_580023 = query.getOrDefault("filter")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "filter", valid_580023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580024: Call_CloudschedulerProjectsLocationsList_580006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580024.validator(path, query, header, formData, body)
  let scheme = call_580024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580024.url(scheme.get, call_580024.host, call_580024.base,
                         call_580024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580024, url, valid)

proc call*(call_580025: Call_CloudschedulerProjectsLocationsList_580006;
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
  var path_580026 = newJObject()
  var query_580027 = newJObject()
  add(query_580027, "upload_protocol", newJString(uploadProtocol))
  add(query_580027, "fields", newJString(fields))
  add(query_580027, "pageToken", newJString(pageToken))
  add(query_580027, "quotaUser", newJString(quotaUser))
  add(path_580026, "name", newJString(name))
  add(query_580027, "alt", newJString(alt))
  add(query_580027, "oauth_token", newJString(oauthToken))
  add(query_580027, "callback", newJString(callback))
  add(query_580027, "access_token", newJString(accessToken))
  add(query_580027, "uploadType", newJString(uploadType))
  add(query_580027, "key", newJString(key))
  add(query_580027, "$.xgafv", newJString(Xgafv))
  add(query_580027, "pageSize", newJInt(pageSize))
  add(query_580027, "prettyPrint", newJBool(prettyPrint))
  add(query_580027, "filter", newJString(filter))
  result = call_580025.call(path_580026, query_580027, nil, nil, nil)

var cloudschedulerProjectsLocationsList* = Call_CloudschedulerProjectsLocationsList_580006(
    name: "cloudschedulerProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{name}/locations",
    validator: validate_CloudschedulerProjectsLocationsList_580007, base: "/",
    url: url_CloudschedulerProjectsLocationsList_580008, schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsJobsPause_580028 = ref object of OpenApiRestCall_579408
proc url_CloudschedulerProjectsLocationsJobsPause_580030(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudschedulerProjectsLocationsJobsPause_580029(path: JsonNode;
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
  var valid_580031 = path.getOrDefault("name")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "name", valid_580031
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
  var valid_580032 = query.getOrDefault("upload_protocol")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "upload_protocol", valid_580032
  var valid_580033 = query.getOrDefault("fields")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "fields", valid_580033
  var valid_580034 = query.getOrDefault("quotaUser")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "quotaUser", valid_580034
  var valid_580035 = query.getOrDefault("alt")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("json"))
  if valid_580035 != nil:
    section.add "alt", valid_580035
  var valid_580036 = query.getOrDefault("oauth_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "oauth_token", valid_580036
  var valid_580037 = query.getOrDefault("callback")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "callback", valid_580037
  var valid_580038 = query.getOrDefault("access_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "access_token", valid_580038
  var valid_580039 = query.getOrDefault("uploadType")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "uploadType", valid_580039
  var valid_580040 = query.getOrDefault("key")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "key", valid_580040
  var valid_580041 = query.getOrDefault("$.xgafv")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("1"))
  if valid_580041 != nil:
    section.add "$.xgafv", valid_580041
  var valid_580042 = query.getOrDefault("prettyPrint")
  valid_580042 = validateParameter(valid_580042, JBool, required = false,
                                 default = newJBool(true))
  if valid_580042 != nil:
    section.add "prettyPrint", valid_580042
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

proc call*(call_580044: Call_CloudschedulerProjectsLocationsJobsPause_580028;
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
  let valid = call_580044.validator(path, query, header, formData, body)
  let scheme = call_580044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580044.url(scheme.get, call_580044.host, call_580044.base,
                         call_580044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580044, url, valid)

proc call*(call_580045: Call_CloudschedulerProjectsLocationsJobsPause_580028;
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
  var path_580046 = newJObject()
  var query_580047 = newJObject()
  var body_580048 = newJObject()
  add(query_580047, "upload_protocol", newJString(uploadProtocol))
  add(query_580047, "fields", newJString(fields))
  add(query_580047, "quotaUser", newJString(quotaUser))
  add(path_580046, "name", newJString(name))
  add(query_580047, "alt", newJString(alt))
  add(query_580047, "oauth_token", newJString(oauthToken))
  add(query_580047, "callback", newJString(callback))
  add(query_580047, "access_token", newJString(accessToken))
  add(query_580047, "uploadType", newJString(uploadType))
  add(query_580047, "key", newJString(key))
  add(query_580047, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580048 = body
  add(query_580047, "prettyPrint", newJBool(prettyPrint))
  result = call_580045.call(path_580046, query_580047, nil, nil, body_580048)

var cloudschedulerProjectsLocationsJobsPause* = Call_CloudschedulerProjectsLocationsJobsPause_580028(
    name: "cloudschedulerProjectsLocationsJobsPause", meth: HttpMethod.HttpPost,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{name}:pause",
    validator: validate_CloudschedulerProjectsLocationsJobsPause_580029,
    base: "/", url: url_CloudschedulerProjectsLocationsJobsPause_580030,
    schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsJobsResume_580049 = ref object of OpenApiRestCall_579408
proc url_CloudschedulerProjectsLocationsJobsResume_580051(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudschedulerProjectsLocationsJobsResume_580050(path: JsonNode;
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
  var valid_580052 = path.getOrDefault("name")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "name", valid_580052
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
  var valid_580053 = query.getOrDefault("upload_protocol")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "upload_protocol", valid_580053
  var valid_580054 = query.getOrDefault("fields")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "fields", valid_580054
  var valid_580055 = query.getOrDefault("quotaUser")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "quotaUser", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("oauth_token")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "oauth_token", valid_580057
  var valid_580058 = query.getOrDefault("callback")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "callback", valid_580058
  var valid_580059 = query.getOrDefault("access_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "access_token", valid_580059
  var valid_580060 = query.getOrDefault("uploadType")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "uploadType", valid_580060
  var valid_580061 = query.getOrDefault("key")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "key", valid_580061
  var valid_580062 = query.getOrDefault("$.xgafv")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("1"))
  if valid_580062 != nil:
    section.add "$.xgafv", valid_580062
  var valid_580063 = query.getOrDefault("prettyPrint")
  valid_580063 = validateParameter(valid_580063, JBool, required = false,
                                 default = newJBool(true))
  if valid_580063 != nil:
    section.add "prettyPrint", valid_580063
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

proc call*(call_580065: Call_CloudschedulerProjectsLocationsJobsResume_580049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resume a job.
  ## 
  ## This method reenables a job after it has been Job.State.PAUSED. The
  ## state of a job is stored in Job.state; after calling this method it
  ## will be set to Job.State.ENABLED. A job must be in
  ## Job.State.PAUSED to be resumed.
  ## 
  let valid = call_580065.validator(path, query, header, formData, body)
  let scheme = call_580065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580065.url(scheme.get, call_580065.host, call_580065.base,
                         call_580065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580065, url, valid)

proc call*(call_580066: Call_CloudschedulerProjectsLocationsJobsResume_580049;
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
  var path_580067 = newJObject()
  var query_580068 = newJObject()
  var body_580069 = newJObject()
  add(query_580068, "upload_protocol", newJString(uploadProtocol))
  add(query_580068, "fields", newJString(fields))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(path_580067, "name", newJString(name))
  add(query_580068, "alt", newJString(alt))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(query_580068, "callback", newJString(callback))
  add(query_580068, "access_token", newJString(accessToken))
  add(query_580068, "uploadType", newJString(uploadType))
  add(query_580068, "key", newJString(key))
  add(query_580068, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580069 = body
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  result = call_580066.call(path_580067, query_580068, nil, nil, body_580069)

var cloudschedulerProjectsLocationsJobsResume* = Call_CloudschedulerProjectsLocationsJobsResume_580049(
    name: "cloudschedulerProjectsLocationsJobsResume", meth: HttpMethod.HttpPost,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{name}:resume",
    validator: validate_CloudschedulerProjectsLocationsJobsResume_580050,
    base: "/", url: url_CloudschedulerProjectsLocationsJobsResume_580051,
    schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsJobsRun_580070 = ref object of OpenApiRestCall_579408
proc url_CloudschedulerProjectsLocationsJobsRun_580072(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudschedulerProjectsLocationsJobsRun_580071(path: JsonNode;
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
  var valid_580073 = path.getOrDefault("name")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "name", valid_580073
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
  var valid_580074 = query.getOrDefault("upload_protocol")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "upload_protocol", valid_580074
  var valid_580075 = query.getOrDefault("fields")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "fields", valid_580075
  var valid_580076 = query.getOrDefault("quotaUser")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "quotaUser", valid_580076
  var valid_580077 = query.getOrDefault("alt")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("json"))
  if valid_580077 != nil:
    section.add "alt", valid_580077
  var valid_580078 = query.getOrDefault("oauth_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "oauth_token", valid_580078
  var valid_580079 = query.getOrDefault("callback")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "callback", valid_580079
  var valid_580080 = query.getOrDefault("access_token")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "access_token", valid_580080
  var valid_580081 = query.getOrDefault("uploadType")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "uploadType", valid_580081
  var valid_580082 = query.getOrDefault("key")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "key", valid_580082
  var valid_580083 = query.getOrDefault("$.xgafv")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = newJString("1"))
  if valid_580083 != nil:
    section.add "$.xgafv", valid_580083
  var valid_580084 = query.getOrDefault("prettyPrint")
  valid_580084 = validateParameter(valid_580084, JBool, required = false,
                                 default = newJBool(true))
  if valid_580084 != nil:
    section.add "prettyPrint", valid_580084
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

proc call*(call_580086: Call_CloudschedulerProjectsLocationsJobsRun_580070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Forces a job to run now.
  ## 
  ## When this method is called, Cloud Scheduler will dispatch the job, even
  ## if the job is already running.
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_CloudschedulerProjectsLocationsJobsRun_580070;
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
  var path_580088 = newJObject()
  var query_580089 = newJObject()
  var body_580090 = newJObject()
  add(query_580089, "upload_protocol", newJString(uploadProtocol))
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "quotaUser", newJString(quotaUser))
  add(path_580088, "name", newJString(name))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "callback", newJString(callback))
  add(query_580089, "access_token", newJString(accessToken))
  add(query_580089, "uploadType", newJString(uploadType))
  add(query_580089, "key", newJString(key))
  add(query_580089, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580090 = body
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  result = call_580087.call(path_580088, query_580089, nil, nil, body_580090)

var cloudschedulerProjectsLocationsJobsRun* = Call_CloudschedulerProjectsLocationsJobsRun_580070(
    name: "cloudschedulerProjectsLocationsJobsRun", meth: HttpMethod.HttpPost,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{name}:run",
    validator: validate_CloudschedulerProjectsLocationsJobsRun_580071, base: "/",
    url: url_CloudschedulerProjectsLocationsJobsRun_580072,
    schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsJobsCreate_580112 = ref object of OpenApiRestCall_579408
proc url_CloudschedulerProjectsLocationsJobsCreate_580114(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudschedulerProjectsLocationsJobsCreate_580113(path: JsonNode;
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
  var valid_580115 = path.getOrDefault("parent")
  valid_580115 = validateParameter(valid_580115, JString, required = true,
                                 default = nil)
  if valid_580115 != nil:
    section.add "parent", valid_580115
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
  var valid_580116 = query.getOrDefault("upload_protocol")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "upload_protocol", valid_580116
  var valid_580117 = query.getOrDefault("fields")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "fields", valid_580117
  var valid_580118 = query.getOrDefault("quotaUser")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "quotaUser", valid_580118
  var valid_580119 = query.getOrDefault("alt")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = newJString("json"))
  if valid_580119 != nil:
    section.add "alt", valid_580119
  var valid_580120 = query.getOrDefault("oauth_token")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "oauth_token", valid_580120
  var valid_580121 = query.getOrDefault("callback")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "callback", valid_580121
  var valid_580122 = query.getOrDefault("access_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "access_token", valid_580122
  var valid_580123 = query.getOrDefault("uploadType")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "uploadType", valid_580123
  var valid_580124 = query.getOrDefault("key")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "key", valid_580124
  var valid_580125 = query.getOrDefault("$.xgafv")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = newJString("1"))
  if valid_580125 != nil:
    section.add "$.xgafv", valid_580125
  var valid_580126 = query.getOrDefault("prettyPrint")
  valid_580126 = validateParameter(valid_580126, JBool, required = false,
                                 default = newJBool(true))
  if valid_580126 != nil:
    section.add "prettyPrint", valid_580126
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

proc call*(call_580128: Call_CloudschedulerProjectsLocationsJobsCreate_580112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a job.
  ## 
  let valid = call_580128.validator(path, query, header, formData, body)
  let scheme = call_580128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580128.url(scheme.get, call_580128.host, call_580128.base,
                         call_580128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580128, url, valid)

proc call*(call_580129: Call_CloudschedulerProjectsLocationsJobsCreate_580112;
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
  var path_580130 = newJObject()
  var query_580131 = newJObject()
  var body_580132 = newJObject()
  add(query_580131, "upload_protocol", newJString(uploadProtocol))
  add(query_580131, "fields", newJString(fields))
  add(query_580131, "quotaUser", newJString(quotaUser))
  add(query_580131, "alt", newJString(alt))
  add(query_580131, "oauth_token", newJString(oauthToken))
  add(query_580131, "callback", newJString(callback))
  add(query_580131, "access_token", newJString(accessToken))
  add(query_580131, "uploadType", newJString(uploadType))
  add(path_580130, "parent", newJString(parent))
  add(query_580131, "key", newJString(key))
  add(query_580131, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580132 = body
  add(query_580131, "prettyPrint", newJBool(prettyPrint))
  result = call_580129.call(path_580130, query_580131, nil, nil, body_580132)

var cloudschedulerProjectsLocationsJobsCreate* = Call_CloudschedulerProjectsLocationsJobsCreate_580112(
    name: "cloudschedulerProjectsLocationsJobsCreate", meth: HttpMethod.HttpPost,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{parent}/jobs",
    validator: validate_CloudschedulerProjectsLocationsJobsCreate_580113,
    base: "/", url: url_CloudschedulerProjectsLocationsJobsCreate_580114,
    schemes: {Scheme.Https})
type
  Call_CloudschedulerProjectsLocationsJobsList_580091 = ref object of OpenApiRestCall_579408
proc url_CloudschedulerProjectsLocationsJobsList_580093(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudschedulerProjectsLocationsJobsList_580092(path: JsonNode;
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
  var valid_580094 = path.getOrDefault("parent")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "parent", valid_580094
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
  var valid_580095 = query.getOrDefault("upload_protocol")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "upload_protocol", valid_580095
  var valid_580096 = query.getOrDefault("fields")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "fields", valid_580096
  var valid_580097 = query.getOrDefault("pageToken")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "pageToken", valid_580097
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
  var valid_580106 = query.getOrDefault("pageSize")
  valid_580106 = validateParameter(valid_580106, JInt, required = false, default = nil)
  if valid_580106 != nil:
    section.add "pageSize", valid_580106
  var valid_580107 = query.getOrDefault("prettyPrint")
  valid_580107 = validateParameter(valid_580107, JBool, required = false,
                                 default = newJBool(true))
  if valid_580107 != nil:
    section.add "prettyPrint", valid_580107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580108: Call_CloudschedulerProjectsLocationsJobsList_580091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists jobs.
  ## 
  let valid = call_580108.validator(path, query, header, formData, body)
  let scheme = call_580108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580108.url(scheme.get, call_580108.host, call_580108.base,
                         call_580108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580108, url, valid)

proc call*(call_580109: Call_CloudschedulerProjectsLocationsJobsList_580091;
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
  var path_580110 = newJObject()
  var query_580111 = newJObject()
  add(query_580111, "upload_protocol", newJString(uploadProtocol))
  add(query_580111, "fields", newJString(fields))
  add(query_580111, "pageToken", newJString(pageToken))
  add(query_580111, "quotaUser", newJString(quotaUser))
  add(query_580111, "alt", newJString(alt))
  add(query_580111, "oauth_token", newJString(oauthToken))
  add(query_580111, "callback", newJString(callback))
  add(query_580111, "access_token", newJString(accessToken))
  add(query_580111, "uploadType", newJString(uploadType))
  add(path_580110, "parent", newJString(parent))
  add(query_580111, "key", newJString(key))
  add(query_580111, "$.xgafv", newJString(Xgafv))
  add(query_580111, "pageSize", newJInt(pageSize))
  add(query_580111, "prettyPrint", newJBool(prettyPrint))
  result = call_580109.call(path_580110, query_580111, nil, nil, nil)

var cloudschedulerProjectsLocationsJobsList* = Call_CloudschedulerProjectsLocationsJobsList_580091(
    name: "cloudschedulerProjectsLocationsJobsList", meth: HttpMethod.HttpGet,
    host: "cloudscheduler.googleapis.com", route: "/v1beta1/{parent}/jobs",
    validator: validate_CloudschedulerProjectsLocationsJobsList_580092, base: "/",
    url: url_CloudschedulerProjectsLocationsJobsList_580093,
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
