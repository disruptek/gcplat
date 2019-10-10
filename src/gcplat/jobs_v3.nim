
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Talent Solution
## version: v3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Cloud Talent Solution provides the capability to create, read, update, and delete job postings, as well as search jobs based on keywords and filters.
## 
## 
## https://cloud.google.com/talent-solution/job-search/docs/
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
  gcpServiceName = "jobs"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobsProjectsJobsGet_588719 = ref object of OpenApiRestCall_588450
proc url_JobsProjectsJobsGet_588721(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsGet_588720(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves the specified job, whose status is OPEN or recently EXPIRED
  ## within the last 90 days.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the job to retrieve.
  ## 
  ## The format is "projects/{project_id}/jobs/{job_id}",
  ## for example, "projects/api-test-project/jobs/1234".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_588847 = path.getOrDefault("name")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "name", valid_588847
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
  if body != nil:
    result.add "body", body

proc call*(call_588894: Call_JobsProjectsJobsGet_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified job, whose status is OPEN or recently EXPIRED
  ## within the last 90 days.
  ## 
  let valid = call_588894.validator(path, query, header, formData, body)
  let scheme = call_588894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588894.url(scheme.get, call_588894.host, call_588894.base,
                         call_588894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588894, url, valid)

proc call*(call_588965: Call_JobsProjectsJobsGet_588719; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## jobsProjectsJobsGet
  ## Retrieves the specified job, whose status is OPEN or recently EXPIRED
  ## within the last 90 days.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the job to retrieve.
  ## 
  ## The format is "projects/{project_id}/jobs/{job_id}",
  ## for example, "projects/api-test-project/jobs/1234".
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
  var path_588966 = newJObject()
  var query_588968 = newJObject()
  add(query_588968, "upload_protocol", newJString(uploadProtocol))
  add(query_588968, "fields", newJString(fields))
  add(query_588968, "quotaUser", newJString(quotaUser))
  add(path_588966, "name", newJString(name))
  add(query_588968, "alt", newJString(alt))
  add(query_588968, "oauth_token", newJString(oauthToken))
  add(query_588968, "callback", newJString(callback))
  add(query_588968, "access_token", newJString(accessToken))
  add(query_588968, "uploadType", newJString(uploadType))
  add(query_588968, "key", newJString(key))
  add(query_588968, "$.xgafv", newJString(Xgafv))
  add(query_588968, "prettyPrint", newJBool(prettyPrint))
  result = call_588965.call(path_588966, query_588968, nil, nil, nil)

var jobsProjectsJobsGet* = Call_JobsProjectsJobsGet_588719(
    name: "jobsProjectsJobsGet", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v3/{name}",
    validator: validate_JobsProjectsJobsGet_588720, base: "/",
    url: url_JobsProjectsJobsGet_588721, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsPatch_589026 = ref object of OpenApiRestCall_588450
proc url_JobsProjectsJobsPatch_589028(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsPatch_589027(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates specified job.
  ## 
  ## Typically, updated contents become visible in search results within 10
  ## seconds, but it may take up to 5 minutes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required during job update.
  ## 
  ## The resource name for the job. This is generated by the service when a
  ## job is created.
  ## 
  ## The format is "projects/{project_id}/jobs/{job_id}",
  ## for example, "projects/api-test-project/jobs/1234".
  ## 
  ## Use of this field in job queries and API calls is preferred over the use of
  ## requisition_id since this value is unique.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589029 = path.getOrDefault("name")
  valid_589029 = validateParameter(valid_589029, JString, required = true,
                                 default = nil)
  if valid_589029 != nil:
    section.add "name", valid_589029
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
  var valid_589030 = query.getOrDefault("upload_protocol")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "upload_protocol", valid_589030
  var valid_589031 = query.getOrDefault("fields")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "fields", valid_589031
  var valid_589032 = query.getOrDefault("quotaUser")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "quotaUser", valid_589032
  var valid_589033 = query.getOrDefault("alt")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("json"))
  if valid_589033 != nil:
    section.add "alt", valid_589033
  var valid_589034 = query.getOrDefault("oauth_token")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "oauth_token", valid_589034
  var valid_589035 = query.getOrDefault("callback")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "callback", valid_589035
  var valid_589036 = query.getOrDefault("access_token")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "access_token", valid_589036
  var valid_589037 = query.getOrDefault("uploadType")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "uploadType", valid_589037
  var valid_589038 = query.getOrDefault("key")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "key", valid_589038
  var valid_589039 = query.getOrDefault("$.xgafv")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("1"))
  if valid_589039 != nil:
    section.add "$.xgafv", valid_589039
  var valid_589040 = query.getOrDefault("prettyPrint")
  valid_589040 = validateParameter(valid_589040, JBool, required = false,
                                 default = newJBool(true))
  if valid_589040 != nil:
    section.add "prettyPrint", valid_589040
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

proc call*(call_589042: Call_JobsProjectsJobsPatch_589026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates specified job.
  ## 
  ## Typically, updated contents become visible in search results within 10
  ## seconds, but it may take up to 5 minutes.
  ## 
  let valid = call_589042.validator(path, query, header, formData, body)
  let scheme = call_589042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589042.url(scheme.get, call_589042.host, call_589042.base,
                         call_589042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589042, url, valid)

proc call*(call_589043: Call_JobsProjectsJobsPatch_589026; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsProjectsJobsPatch
  ## Updates specified job.
  ## 
  ## Typically, updated contents become visible in search results within 10
  ## seconds, but it may take up to 5 minutes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required during job update.
  ## 
  ## The resource name for the job. This is generated by the service when a
  ## job is created.
  ## 
  ## The format is "projects/{project_id}/jobs/{job_id}",
  ## for example, "projects/api-test-project/jobs/1234".
  ## 
  ## Use of this field in job queries and API calls is preferred over the use of
  ## requisition_id since this value is unique.
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
  var path_589044 = newJObject()
  var query_589045 = newJObject()
  var body_589046 = newJObject()
  add(query_589045, "upload_protocol", newJString(uploadProtocol))
  add(query_589045, "fields", newJString(fields))
  add(query_589045, "quotaUser", newJString(quotaUser))
  add(path_589044, "name", newJString(name))
  add(query_589045, "alt", newJString(alt))
  add(query_589045, "oauth_token", newJString(oauthToken))
  add(query_589045, "callback", newJString(callback))
  add(query_589045, "access_token", newJString(accessToken))
  add(query_589045, "uploadType", newJString(uploadType))
  add(query_589045, "key", newJString(key))
  add(query_589045, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589046 = body
  add(query_589045, "prettyPrint", newJBool(prettyPrint))
  result = call_589043.call(path_589044, query_589045, nil, nil, body_589046)

var jobsProjectsJobsPatch* = Call_JobsProjectsJobsPatch_589026(
    name: "jobsProjectsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "jobs.googleapis.com", route: "/v3/{name}",
    validator: validate_JobsProjectsJobsPatch_589027, base: "/",
    url: url_JobsProjectsJobsPatch_589028, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsDelete_589007 = ref object of OpenApiRestCall_588450
proc url_JobsProjectsJobsDelete_589009(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsDelete_589008(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified job.
  ## 
  ## Typically, the job becomes unsearchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the job to be deleted.
  ## 
  ## The format is "projects/{project_id}/jobs/{job_id}",
  ## for example, "projects/api-test-project/jobs/1234".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589010 = path.getOrDefault("name")
  valid_589010 = validateParameter(valid_589010, JString, required = true,
                                 default = nil)
  if valid_589010 != nil:
    section.add "name", valid_589010
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
  var valid_589011 = query.getOrDefault("upload_protocol")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "upload_protocol", valid_589011
  var valid_589012 = query.getOrDefault("fields")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "fields", valid_589012
  var valid_589013 = query.getOrDefault("quotaUser")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "quotaUser", valid_589013
  var valid_589014 = query.getOrDefault("alt")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("json"))
  if valid_589014 != nil:
    section.add "alt", valid_589014
  var valid_589015 = query.getOrDefault("oauth_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "oauth_token", valid_589015
  var valid_589016 = query.getOrDefault("callback")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "callback", valid_589016
  var valid_589017 = query.getOrDefault("access_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "access_token", valid_589017
  var valid_589018 = query.getOrDefault("uploadType")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "uploadType", valid_589018
  var valid_589019 = query.getOrDefault("key")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "key", valid_589019
  var valid_589020 = query.getOrDefault("$.xgafv")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("1"))
  if valid_589020 != nil:
    section.add "$.xgafv", valid_589020
  var valid_589021 = query.getOrDefault("prettyPrint")
  valid_589021 = validateParameter(valid_589021, JBool, required = false,
                                 default = newJBool(true))
  if valid_589021 != nil:
    section.add "prettyPrint", valid_589021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589022: Call_JobsProjectsJobsDelete_589007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified job.
  ## 
  ## Typically, the job becomes unsearchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ## 
  let valid = call_589022.validator(path, query, header, formData, body)
  let scheme = call_589022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589022.url(scheme.get, call_589022.host, call_589022.base,
                         call_589022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589022, url, valid)

proc call*(call_589023: Call_JobsProjectsJobsDelete_589007; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## jobsProjectsJobsDelete
  ## Deletes the specified job.
  ## 
  ## Typically, the job becomes unsearchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the job to be deleted.
  ## 
  ## The format is "projects/{project_id}/jobs/{job_id}",
  ## for example, "projects/api-test-project/jobs/1234".
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
  var path_589024 = newJObject()
  var query_589025 = newJObject()
  add(query_589025, "upload_protocol", newJString(uploadProtocol))
  add(query_589025, "fields", newJString(fields))
  add(query_589025, "quotaUser", newJString(quotaUser))
  add(path_589024, "name", newJString(name))
  add(query_589025, "alt", newJString(alt))
  add(query_589025, "oauth_token", newJString(oauthToken))
  add(query_589025, "callback", newJString(callback))
  add(query_589025, "access_token", newJString(accessToken))
  add(query_589025, "uploadType", newJString(uploadType))
  add(query_589025, "key", newJString(key))
  add(query_589025, "$.xgafv", newJString(Xgafv))
  add(query_589025, "prettyPrint", newJBool(prettyPrint))
  result = call_589023.call(path_589024, query_589025, nil, nil, nil)

var jobsProjectsJobsDelete* = Call_JobsProjectsJobsDelete_589007(
    name: "jobsProjectsJobsDelete", meth: HttpMethod.HttpDelete,
    host: "jobs.googleapis.com", route: "/v3/{name}",
    validator: validate_JobsProjectsJobsDelete_589008, base: "/",
    url: url_JobsProjectsJobsDelete_589009, schemes: {Scheme.Https})
type
  Call_JobsProjectsComplete_589047 = ref object of OpenApiRestCall_588450
proc url_JobsProjectsComplete_589049(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":complete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsComplete_589048(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Completes the specified prefix with keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name of project the completion is performed within.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589050 = path.getOrDefault("name")
  valid_589050 = validateParameter(valid_589050, JString, required = true,
                                 default = nil)
  if valid_589050 != nil:
    section.add "name", valid_589050
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scope: JString
  ##        : Optional. The scope of the completion. The defaults is CompletionScope.PUBLIC.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : Required. The query used to generate suggestions.
  ## 
  ## The maximum number of allowed characters is 255.
  ##   type: JString
  ##       : Optional. The completion topic. The default is CompletionType.COMBINED.
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
  ##   languageCode: JString
  ##               : Deprecated. Use language_codes instead.
  ## 
  ## Optional.
  ## 
  ## The language of the query. This is
  ## the BCP-47 language code, such as "en-US" or "sr-Latn".
  ## For more information, see
  ## [Tags for Identifying Languages](https://tools.ietf.org/html/bcp47).
  ## 
  ## For CompletionType.JOB_TITLE type, only open jobs with the same
  ## language_code are returned.
  ## 
  ## For CompletionType.COMPANY_NAME type,
  ## only companies having open jobs with the same language_code are
  ## returned.
  ## 
  ## For CompletionType.COMBINED type, only open jobs with the same
  ## language_code or companies having open jobs with the same
  ## language_code are returned.
  ## 
  ## The maximum number of allowed characters is 255.
  ##   pageSize: JInt
  ##           : Required. Completion result count.
  ## 
  ## The maximum allowed page size is 10.
  ##   languageCodes: JArray
  ##                : Optional. The list of languages of the query. This is
  ## the BCP-47 language code, such as "en-US" or "sr-Latn".
  ## For more information, see
  ## [Tags for Identifying Languages](https://tools.ietf.org/html/bcp47).
  ## 
  ## For CompletionType.JOB_TITLE type, only open jobs with the same
  ## language_codes are returned.
  ## 
  ## For CompletionType.COMPANY_NAME type,
  ## only companies having open jobs with the same language_codes are
  ## returned.
  ## 
  ## For CompletionType.COMBINED type, only open jobs with the same
  ## language_codes or companies having open jobs with the same
  ## language_codes are returned.
  ## 
  ## The maximum number of allowed characters is 255.
  ##   companyName: JString
  ##              : Optional. If provided, restricts completion to specified company.
  ## 
  ## The format is "projects/{project_id}/companies/{company_id}", for example,
  ## "projects/api-test-project/companies/foo".
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589051 = query.getOrDefault("upload_protocol")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "upload_protocol", valid_589051
  var valid_589052 = query.getOrDefault("fields")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "fields", valid_589052
  var valid_589053 = query.getOrDefault("quotaUser")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "quotaUser", valid_589053
  var valid_589054 = query.getOrDefault("scope")
  valid_589054 = validateParameter(valid_589054, JString, required = false, default = newJString(
      "COMPLETION_SCOPE_UNSPECIFIED"))
  if valid_589054 != nil:
    section.add "scope", valid_589054
  var valid_589055 = query.getOrDefault("alt")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = newJString("json"))
  if valid_589055 != nil:
    section.add "alt", valid_589055
  var valid_589056 = query.getOrDefault("query")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "query", valid_589056
  var valid_589057 = query.getOrDefault("type")
  valid_589057 = validateParameter(valid_589057, JString, required = false, default = newJString(
      "COMPLETION_TYPE_UNSPECIFIED"))
  if valid_589057 != nil:
    section.add "type", valid_589057
  var valid_589058 = query.getOrDefault("oauth_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "oauth_token", valid_589058
  var valid_589059 = query.getOrDefault("callback")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "callback", valid_589059
  var valid_589060 = query.getOrDefault("access_token")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "access_token", valid_589060
  var valid_589061 = query.getOrDefault("uploadType")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "uploadType", valid_589061
  var valid_589062 = query.getOrDefault("key")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "key", valid_589062
  var valid_589063 = query.getOrDefault("$.xgafv")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("1"))
  if valid_589063 != nil:
    section.add "$.xgafv", valid_589063
  var valid_589064 = query.getOrDefault("languageCode")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "languageCode", valid_589064
  var valid_589065 = query.getOrDefault("pageSize")
  valid_589065 = validateParameter(valid_589065, JInt, required = false, default = nil)
  if valid_589065 != nil:
    section.add "pageSize", valid_589065
  var valid_589066 = query.getOrDefault("languageCodes")
  valid_589066 = validateParameter(valid_589066, JArray, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "languageCodes", valid_589066
  var valid_589067 = query.getOrDefault("companyName")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "companyName", valid_589067
  var valid_589068 = query.getOrDefault("prettyPrint")
  valid_589068 = validateParameter(valid_589068, JBool, required = false,
                                 default = newJBool(true))
  if valid_589068 != nil:
    section.add "prettyPrint", valid_589068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589069: Call_JobsProjectsComplete_589047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Completes the specified prefix with keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ## 
  let valid = call_589069.validator(path, query, header, formData, body)
  let scheme = call_589069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589069.url(scheme.get, call_589069.host, call_589069.base,
                         call_589069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589069, url, valid)

proc call*(call_589070: Call_JobsProjectsComplete_589047; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          scope: string = "COMPLETION_SCOPE_UNSPECIFIED"; alt: string = "json";
          query: string = ""; `type`: string = "COMPLETION_TYPE_UNSPECIFIED";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          languageCode: string = ""; pageSize: int = 0; languageCodes: JsonNode = nil;
          companyName: string = ""; prettyPrint: bool = true): Recallable =
  ## jobsProjectsComplete
  ## Completes the specified prefix with keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Resource name of project the completion is performed within.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   scope: string
  ##        : Optional. The scope of the completion. The defaults is CompletionScope.PUBLIC.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : Required. The query used to generate suggestions.
  ## 
  ## The maximum number of allowed characters is 255.
  ##   type: string
  ##       : Optional. The completion topic. The default is CompletionType.COMBINED.
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
  ##   languageCode: string
  ##               : Deprecated. Use language_codes instead.
  ## 
  ## Optional.
  ## 
  ## The language of the query. This is
  ## the BCP-47 language code, such as "en-US" or "sr-Latn".
  ## For more information, see
  ## [Tags for Identifying Languages](https://tools.ietf.org/html/bcp47).
  ## 
  ## For CompletionType.JOB_TITLE type, only open jobs with the same
  ## language_code are returned.
  ## 
  ## For CompletionType.COMPANY_NAME type,
  ## only companies having open jobs with the same language_code are
  ## returned.
  ## 
  ## For CompletionType.COMBINED type, only open jobs with the same
  ## language_code or companies having open jobs with the same
  ## language_code are returned.
  ## 
  ## The maximum number of allowed characters is 255.
  ##   pageSize: int
  ##           : Required. Completion result count.
  ## 
  ## The maximum allowed page size is 10.
  ##   languageCodes: JArray
  ##                : Optional. The list of languages of the query. This is
  ## the BCP-47 language code, such as "en-US" or "sr-Latn".
  ## For more information, see
  ## [Tags for Identifying Languages](https://tools.ietf.org/html/bcp47).
  ## 
  ## For CompletionType.JOB_TITLE type, only open jobs with the same
  ## language_codes are returned.
  ## 
  ## For CompletionType.COMPANY_NAME type,
  ## only companies having open jobs with the same language_codes are
  ## returned.
  ## 
  ## For CompletionType.COMBINED type, only open jobs with the same
  ## language_codes or companies having open jobs with the same
  ## language_codes are returned.
  ## 
  ## The maximum number of allowed characters is 255.
  ##   companyName: string
  ##              : Optional. If provided, restricts completion to specified company.
  ## 
  ## The format is "projects/{project_id}/companies/{company_id}", for example,
  ## "projects/api-test-project/companies/foo".
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589071 = newJObject()
  var query_589072 = newJObject()
  add(query_589072, "upload_protocol", newJString(uploadProtocol))
  add(query_589072, "fields", newJString(fields))
  add(query_589072, "quotaUser", newJString(quotaUser))
  add(path_589071, "name", newJString(name))
  add(query_589072, "scope", newJString(scope))
  add(query_589072, "alt", newJString(alt))
  add(query_589072, "query", newJString(query))
  add(query_589072, "type", newJString(`type`))
  add(query_589072, "oauth_token", newJString(oauthToken))
  add(query_589072, "callback", newJString(callback))
  add(query_589072, "access_token", newJString(accessToken))
  add(query_589072, "uploadType", newJString(uploadType))
  add(query_589072, "key", newJString(key))
  add(query_589072, "$.xgafv", newJString(Xgafv))
  add(query_589072, "languageCode", newJString(languageCode))
  add(query_589072, "pageSize", newJInt(pageSize))
  if languageCodes != nil:
    query_589072.add "languageCodes", languageCodes
  add(query_589072, "companyName", newJString(companyName))
  add(query_589072, "prettyPrint", newJBool(prettyPrint))
  result = call_589070.call(path_589071, query_589072, nil, nil, nil)

var jobsProjectsComplete* = Call_JobsProjectsComplete_589047(
    name: "jobsProjectsComplete", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v3/{name}:complete",
    validator: validate_JobsProjectsComplete_589048, base: "/",
    url: url_JobsProjectsComplete_589049, schemes: {Scheme.Https})
type
  Call_JobsProjectsClientEventsCreate_589073 = ref object of OpenApiRestCall_588450
proc url_JobsProjectsClientEventsCreate_589075(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clientEvents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsClientEventsCreate_589074(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Report events issued when end user interacts with customer's application
  ## that uses Cloud Talent Solution. You may inspect the created events in
  ## [self service
  ## tools](https://console.cloud.google.com/talent-solution/overview).
  ## [Learn
  ## more](https://cloud.google.com/talent-solution/docs/management-tools)
  ## about self service tools.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589076 = path.getOrDefault("parent")
  valid_589076 = validateParameter(valid_589076, JString, required = true,
                                 default = nil)
  if valid_589076 != nil:
    section.add "parent", valid_589076
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
  var valid_589077 = query.getOrDefault("upload_protocol")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "upload_protocol", valid_589077
  var valid_589078 = query.getOrDefault("fields")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "fields", valid_589078
  var valid_589079 = query.getOrDefault("quotaUser")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "quotaUser", valid_589079
  var valid_589080 = query.getOrDefault("alt")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = newJString("json"))
  if valid_589080 != nil:
    section.add "alt", valid_589080
  var valid_589081 = query.getOrDefault("oauth_token")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "oauth_token", valid_589081
  var valid_589082 = query.getOrDefault("callback")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "callback", valid_589082
  var valid_589083 = query.getOrDefault("access_token")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "access_token", valid_589083
  var valid_589084 = query.getOrDefault("uploadType")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "uploadType", valid_589084
  var valid_589085 = query.getOrDefault("key")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "key", valid_589085
  var valid_589086 = query.getOrDefault("$.xgafv")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = newJString("1"))
  if valid_589086 != nil:
    section.add "$.xgafv", valid_589086
  var valid_589087 = query.getOrDefault("prettyPrint")
  valid_589087 = validateParameter(valid_589087, JBool, required = false,
                                 default = newJBool(true))
  if valid_589087 != nil:
    section.add "prettyPrint", valid_589087
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

proc call*(call_589089: Call_JobsProjectsClientEventsCreate_589073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Report events issued when end user interacts with customer's application
  ## that uses Cloud Talent Solution. You may inspect the created events in
  ## [self service
  ## tools](https://console.cloud.google.com/talent-solution/overview).
  ## [Learn
  ## more](https://cloud.google.com/talent-solution/docs/management-tools)
  ## about self service tools.
  ## 
  let valid = call_589089.validator(path, query, header, formData, body)
  let scheme = call_589089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589089.url(scheme.get, call_589089.host, call_589089.base,
                         call_589089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589089, url, valid)

proc call*(call_589090: Call_JobsProjectsClientEventsCreate_589073; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsProjectsClientEventsCreate
  ## Report events issued when end user interacts with customer's application
  ## that uses Cloud Talent Solution. You may inspect the created events in
  ## [self service
  ## tools](https://console.cloud.google.com/talent-solution/overview).
  ## [Learn
  ## more](https://cloud.google.com/talent-solution/docs/management-tools)
  ## about self service tools.
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
  ##         : Parent project name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589091 = newJObject()
  var query_589092 = newJObject()
  var body_589093 = newJObject()
  add(query_589092, "upload_protocol", newJString(uploadProtocol))
  add(query_589092, "fields", newJString(fields))
  add(query_589092, "quotaUser", newJString(quotaUser))
  add(query_589092, "alt", newJString(alt))
  add(query_589092, "oauth_token", newJString(oauthToken))
  add(query_589092, "callback", newJString(callback))
  add(query_589092, "access_token", newJString(accessToken))
  add(query_589092, "uploadType", newJString(uploadType))
  add(path_589091, "parent", newJString(parent))
  add(query_589092, "key", newJString(key))
  add(query_589092, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589093 = body
  add(query_589092, "prettyPrint", newJBool(prettyPrint))
  result = call_589090.call(path_589091, query_589092, nil, nil, body_589093)

var jobsProjectsClientEventsCreate* = Call_JobsProjectsClientEventsCreate_589073(
    name: "jobsProjectsClientEventsCreate", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3/{parent}/clientEvents",
    validator: validate_JobsProjectsClientEventsCreate_589074, base: "/",
    url: url_JobsProjectsClientEventsCreate_589075, schemes: {Scheme.Https})
type
  Call_JobsProjectsCompaniesCreate_589116 = ref object of OpenApiRestCall_588450
proc url_JobsProjectsCompaniesCreate_589118(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/companies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsCompaniesCreate_589117(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new company entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Resource name of the project under which the company is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589119 = path.getOrDefault("parent")
  valid_589119 = validateParameter(valid_589119, JString, required = true,
                                 default = nil)
  if valid_589119 != nil:
    section.add "parent", valid_589119
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
  var valid_589120 = query.getOrDefault("upload_protocol")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "upload_protocol", valid_589120
  var valid_589121 = query.getOrDefault("fields")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "fields", valid_589121
  var valid_589122 = query.getOrDefault("quotaUser")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "quotaUser", valid_589122
  var valid_589123 = query.getOrDefault("alt")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = newJString("json"))
  if valid_589123 != nil:
    section.add "alt", valid_589123
  var valid_589124 = query.getOrDefault("oauth_token")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "oauth_token", valid_589124
  var valid_589125 = query.getOrDefault("callback")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "callback", valid_589125
  var valid_589126 = query.getOrDefault("access_token")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "access_token", valid_589126
  var valid_589127 = query.getOrDefault("uploadType")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "uploadType", valid_589127
  var valid_589128 = query.getOrDefault("key")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "key", valid_589128
  var valid_589129 = query.getOrDefault("$.xgafv")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = newJString("1"))
  if valid_589129 != nil:
    section.add "$.xgafv", valid_589129
  var valid_589130 = query.getOrDefault("prettyPrint")
  valid_589130 = validateParameter(valid_589130, JBool, required = false,
                                 default = newJBool(true))
  if valid_589130 != nil:
    section.add "prettyPrint", valid_589130
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

proc call*(call_589132: Call_JobsProjectsCompaniesCreate_589116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new company entity.
  ## 
  let valid = call_589132.validator(path, query, header, formData, body)
  let scheme = call_589132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589132.url(scheme.get, call_589132.host, call_589132.base,
                         call_589132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589132, url, valid)

proc call*(call_589133: Call_JobsProjectsCompaniesCreate_589116; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsProjectsCompaniesCreate
  ## Creates a new company entity.
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
  ##         : Required. Resource name of the project under which the company is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589134 = newJObject()
  var query_589135 = newJObject()
  var body_589136 = newJObject()
  add(query_589135, "upload_protocol", newJString(uploadProtocol))
  add(query_589135, "fields", newJString(fields))
  add(query_589135, "quotaUser", newJString(quotaUser))
  add(query_589135, "alt", newJString(alt))
  add(query_589135, "oauth_token", newJString(oauthToken))
  add(query_589135, "callback", newJString(callback))
  add(query_589135, "access_token", newJString(accessToken))
  add(query_589135, "uploadType", newJString(uploadType))
  add(path_589134, "parent", newJString(parent))
  add(query_589135, "key", newJString(key))
  add(query_589135, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589136 = body
  add(query_589135, "prettyPrint", newJBool(prettyPrint))
  result = call_589133.call(path_589134, query_589135, nil, nil, body_589136)

var jobsProjectsCompaniesCreate* = Call_JobsProjectsCompaniesCreate_589116(
    name: "jobsProjectsCompaniesCreate", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3/{parent}/companies",
    validator: validate_JobsProjectsCompaniesCreate_589117, base: "/",
    url: url_JobsProjectsCompaniesCreate_589118, schemes: {Scheme.Https})
type
  Call_JobsProjectsCompaniesList_589094 = ref object of OpenApiRestCall_588450
proc url_JobsProjectsCompaniesList_589096(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/companies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsCompaniesList_589095(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all companies associated with the service account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Resource name of the project under which the company is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589097 = path.getOrDefault("parent")
  valid_589097 = validateParameter(valid_589097, JString, required = true,
                                 default = nil)
  if valid_589097 != nil:
    section.add "parent", valid_589097
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. The starting indicator from which to return results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   requireOpenJobs: JBool
  ##                  : Optional. Set to true if the companies requested must have open jobs.
  ## 
  ## Defaults to false.
  ## 
  ## If true, at most page_size of companies are fetched, among which
  ## only those with open jobs are returned.
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
  ##           : Optional. The maximum number of companies to be returned, at most 100.
  ## Default is 100 if a non-positive number is provided.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589098 = query.getOrDefault("upload_protocol")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "upload_protocol", valid_589098
  var valid_589099 = query.getOrDefault("fields")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "fields", valid_589099
  var valid_589100 = query.getOrDefault("pageToken")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "pageToken", valid_589100
  var valid_589101 = query.getOrDefault("quotaUser")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "quotaUser", valid_589101
  var valid_589102 = query.getOrDefault("alt")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = newJString("json"))
  if valid_589102 != nil:
    section.add "alt", valid_589102
  var valid_589103 = query.getOrDefault("requireOpenJobs")
  valid_589103 = validateParameter(valid_589103, JBool, required = false, default = nil)
  if valid_589103 != nil:
    section.add "requireOpenJobs", valid_589103
  var valid_589104 = query.getOrDefault("oauth_token")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "oauth_token", valid_589104
  var valid_589105 = query.getOrDefault("callback")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "callback", valid_589105
  var valid_589106 = query.getOrDefault("access_token")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "access_token", valid_589106
  var valid_589107 = query.getOrDefault("uploadType")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "uploadType", valid_589107
  var valid_589108 = query.getOrDefault("key")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "key", valid_589108
  var valid_589109 = query.getOrDefault("$.xgafv")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = newJString("1"))
  if valid_589109 != nil:
    section.add "$.xgafv", valid_589109
  var valid_589110 = query.getOrDefault("pageSize")
  valid_589110 = validateParameter(valid_589110, JInt, required = false, default = nil)
  if valid_589110 != nil:
    section.add "pageSize", valid_589110
  var valid_589111 = query.getOrDefault("prettyPrint")
  valid_589111 = validateParameter(valid_589111, JBool, required = false,
                                 default = newJBool(true))
  if valid_589111 != nil:
    section.add "prettyPrint", valid_589111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589112: Call_JobsProjectsCompaniesList_589094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all companies associated with the service account.
  ## 
  let valid = call_589112.validator(path, query, header, formData, body)
  let scheme = call_589112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589112.url(scheme.get, call_589112.host, call_589112.base,
                         call_589112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589112, url, valid)

proc call*(call_589113: Call_JobsProjectsCompaniesList_589094; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; requireOpenJobs: bool = false;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## jobsProjectsCompaniesList
  ## Lists all companies associated with the service account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. The starting indicator from which to return results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   requireOpenJobs: bool
  ##                  : Optional. Set to true if the companies requested must have open jobs.
  ## 
  ## Defaults to false.
  ## 
  ## If true, at most page_size of companies are fetched, among which
  ## only those with open jobs are returned.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. Resource name of the project under which the company is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of companies to be returned, at most 100.
  ## Default is 100 if a non-positive number is provided.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589114 = newJObject()
  var query_589115 = newJObject()
  add(query_589115, "upload_protocol", newJString(uploadProtocol))
  add(query_589115, "fields", newJString(fields))
  add(query_589115, "pageToken", newJString(pageToken))
  add(query_589115, "quotaUser", newJString(quotaUser))
  add(query_589115, "alt", newJString(alt))
  add(query_589115, "requireOpenJobs", newJBool(requireOpenJobs))
  add(query_589115, "oauth_token", newJString(oauthToken))
  add(query_589115, "callback", newJString(callback))
  add(query_589115, "access_token", newJString(accessToken))
  add(query_589115, "uploadType", newJString(uploadType))
  add(path_589114, "parent", newJString(parent))
  add(query_589115, "key", newJString(key))
  add(query_589115, "$.xgafv", newJString(Xgafv))
  add(query_589115, "pageSize", newJInt(pageSize))
  add(query_589115, "prettyPrint", newJBool(prettyPrint))
  result = call_589113.call(path_589114, query_589115, nil, nil, nil)

var jobsProjectsCompaniesList* = Call_JobsProjectsCompaniesList_589094(
    name: "jobsProjectsCompaniesList", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v3/{parent}/companies",
    validator: validate_JobsProjectsCompaniesList_589095, base: "/",
    url: url_JobsProjectsCompaniesList_589096, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsCreate_589160 = ref object of OpenApiRestCall_588450
proc url_JobsProjectsJobsCreate_589162(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsCreate_589161(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new job.
  ## 
  ## Typically, the job becomes searchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the project under which the job is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589163 = path.getOrDefault("parent")
  valid_589163 = validateParameter(valid_589163, JString, required = true,
                                 default = nil)
  if valid_589163 != nil:
    section.add "parent", valid_589163
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
  var valid_589164 = query.getOrDefault("upload_protocol")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "upload_protocol", valid_589164
  var valid_589165 = query.getOrDefault("fields")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "fields", valid_589165
  var valid_589166 = query.getOrDefault("quotaUser")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "quotaUser", valid_589166
  var valid_589167 = query.getOrDefault("alt")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = newJString("json"))
  if valid_589167 != nil:
    section.add "alt", valid_589167
  var valid_589168 = query.getOrDefault("oauth_token")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "oauth_token", valid_589168
  var valid_589169 = query.getOrDefault("callback")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "callback", valid_589169
  var valid_589170 = query.getOrDefault("access_token")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "access_token", valid_589170
  var valid_589171 = query.getOrDefault("uploadType")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "uploadType", valid_589171
  var valid_589172 = query.getOrDefault("key")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "key", valid_589172
  var valid_589173 = query.getOrDefault("$.xgafv")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = newJString("1"))
  if valid_589173 != nil:
    section.add "$.xgafv", valid_589173
  var valid_589174 = query.getOrDefault("prettyPrint")
  valid_589174 = validateParameter(valid_589174, JBool, required = false,
                                 default = newJBool(true))
  if valid_589174 != nil:
    section.add "prettyPrint", valid_589174
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

proc call*(call_589176: Call_JobsProjectsJobsCreate_589160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job.
  ## 
  ## Typically, the job becomes searchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ## 
  let valid = call_589176.validator(path, query, header, formData, body)
  let scheme = call_589176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589176.url(scheme.get, call_589176.host, call_589176.base,
                         call_589176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589176, url, valid)

proc call*(call_589177: Call_JobsProjectsJobsCreate_589160; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsProjectsJobsCreate
  ## Creates a new job.
  ## 
  ## Typically, the job becomes searchable within 10 seconds, but it may take
  ## up to 5 minutes.
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
  ##         : Required. The resource name of the project under which the job is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589178 = newJObject()
  var query_589179 = newJObject()
  var body_589180 = newJObject()
  add(query_589179, "upload_protocol", newJString(uploadProtocol))
  add(query_589179, "fields", newJString(fields))
  add(query_589179, "quotaUser", newJString(quotaUser))
  add(query_589179, "alt", newJString(alt))
  add(query_589179, "oauth_token", newJString(oauthToken))
  add(query_589179, "callback", newJString(callback))
  add(query_589179, "access_token", newJString(accessToken))
  add(query_589179, "uploadType", newJString(uploadType))
  add(path_589178, "parent", newJString(parent))
  add(query_589179, "key", newJString(key))
  add(query_589179, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589180 = body
  add(query_589179, "prettyPrint", newJBool(prettyPrint))
  result = call_589177.call(path_589178, query_589179, nil, nil, body_589180)

var jobsProjectsJobsCreate* = Call_JobsProjectsJobsCreate_589160(
    name: "jobsProjectsJobsCreate", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3/{parent}/jobs",
    validator: validate_JobsProjectsJobsCreate_589161, base: "/",
    url: url_JobsProjectsJobsCreate_589162, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsList_589137 = ref object of OpenApiRestCall_588450
proc url_JobsProjectsJobsList_589139(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsList_589138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists jobs by filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the project under which the job is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589140 = path.getOrDefault("parent")
  valid_589140 = validateParameter(valid_589140, JString, required = true,
                                 default = nil)
  if valid_589140 != nil:
    section.add "parent", valid_589140
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. The starting point of a query result.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   jobView: JString
  ##          : Optional. The desired job attributes returned for jobs in the
  ## search response. Defaults to JobView.JOB_VIEW_FULL if no value is
  ## specified.
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
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If job_view is set to JobView.JOB_VIEW_ID_ONLY, the maximum allowed
  ## page size is 1000. Otherwise, the maximum allowed page size is 100.
  ## 
  ## Default is 100 if empty or a number < 1 is specified.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Required. The filter string specifies the jobs to be enumerated.
  ## 
  ## Supported operator: =, AND
  ## 
  ## The fields eligible for filtering are:
  ## 
  ## * `companyName` (Required)
  ## * `requisitionId` (Optional)
  ## 
  ## Sample Query:
  ## 
  ## * companyName = "projects/api-test-project/companies/123"
  ## * companyName = "projects/api-test-project/companies/123" AND requisitionId
  ## = "req-1"
  section = newJObject()
  var valid_589141 = query.getOrDefault("upload_protocol")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "upload_protocol", valid_589141
  var valid_589142 = query.getOrDefault("fields")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "fields", valid_589142
  var valid_589143 = query.getOrDefault("pageToken")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "pageToken", valid_589143
  var valid_589144 = query.getOrDefault("quotaUser")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "quotaUser", valid_589144
  var valid_589145 = query.getOrDefault("alt")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = newJString("json"))
  if valid_589145 != nil:
    section.add "alt", valid_589145
  var valid_589146 = query.getOrDefault("jobView")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = newJString("JOB_VIEW_UNSPECIFIED"))
  if valid_589146 != nil:
    section.add "jobView", valid_589146
  var valid_589147 = query.getOrDefault("oauth_token")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "oauth_token", valid_589147
  var valid_589148 = query.getOrDefault("callback")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "callback", valid_589148
  var valid_589149 = query.getOrDefault("access_token")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "access_token", valid_589149
  var valid_589150 = query.getOrDefault("uploadType")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "uploadType", valid_589150
  var valid_589151 = query.getOrDefault("key")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "key", valid_589151
  var valid_589152 = query.getOrDefault("$.xgafv")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = newJString("1"))
  if valid_589152 != nil:
    section.add "$.xgafv", valid_589152
  var valid_589153 = query.getOrDefault("pageSize")
  valid_589153 = validateParameter(valid_589153, JInt, required = false, default = nil)
  if valid_589153 != nil:
    section.add "pageSize", valid_589153
  var valid_589154 = query.getOrDefault("prettyPrint")
  valid_589154 = validateParameter(valid_589154, JBool, required = false,
                                 default = newJBool(true))
  if valid_589154 != nil:
    section.add "prettyPrint", valid_589154
  var valid_589155 = query.getOrDefault("filter")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "filter", valid_589155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589156: Call_JobsProjectsJobsList_589137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs by filter.
  ## 
  let valid = call_589156.validator(path, query, header, formData, body)
  let scheme = call_589156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589156.url(scheme.get, call_589156.host, call_589156.base,
                         call_589156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589156, url, valid)

proc call*(call_589157: Call_JobsProjectsJobsList_589137; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json";
          jobView: string = "JOB_VIEW_UNSPECIFIED"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## jobsProjectsJobsList
  ## Lists jobs by filter.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. The starting point of a query result.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobView: string
  ##          : Optional. The desired job attributes returned for jobs in the
  ## search response. Defaults to JobView.JOB_VIEW_FULL if no value is
  ## specified.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The resource name of the project under which the job is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If job_view is set to JobView.JOB_VIEW_ID_ONLY, the maximum allowed
  ## page size is 1000. Otherwise, the maximum allowed page size is 100.
  ## 
  ## Default is 100 if empty or a number < 1 is specified.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Required. The filter string specifies the jobs to be enumerated.
  ## 
  ## Supported operator: =, AND
  ## 
  ## The fields eligible for filtering are:
  ## 
  ## * `companyName` (Required)
  ## * `requisitionId` (Optional)
  ## 
  ## Sample Query:
  ## 
  ## * companyName = "projects/api-test-project/companies/123"
  ## * companyName = "projects/api-test-project/companies/123" AND requisitionId
  ## = "req-1"
  var path_589158 = newJObject()
  var query_589159 = newJObject()
  add(query_589159, "upload_protocol", newJString(uploadProtocol))
  add(query_589159, "fields", newJString(fields))
  add(query_589159, "pageToken", newJString(pageToken))
  add(query_589159, "quotaUser", newJString(quotaUser))
  add(query_589159, "alt", newJString(alt))
  add(query_589159, "jobView", newJString(jobView))
  add(query_589159, "oauth_token", newJString(oauthToken))
  add(query_589159, "callback", newJString(callback))
  add(query_589159, "access_token", newJString(accessToken))
  add(query_589159, "uploadType", newJString(uploadType))
  add(path_589158, "parent", newJString(parent))
  add(query_589159, "key", newJString(key))
  add(query_589159, "$.xgafv", newJString(Xgafv))
  add(query_589159, "pageSize", newJInt(pageSize))
  add(query_589159, "prettyPrint", newJBool(prettyPrint))
  add(query_589159, "filter", newJString(filter))
  result = call_589157.call(path_589158, query_589159, nil, nil, nil)

var jobsProjectsJobsList* = Call_JobsProjectsJobsList_589137(
    name: "jobsProjectsJobsList", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v3/{parent}/jobs",
    validator: validate_JobsProjectsJobsList_589138, base: "/",
    url: url_JobsProjectsJobsList_589139, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsBatchDelete_589181 = ref object of OpenApiRestCall_588450
proc url_JobsProjectsJobsBatchDelete_589183(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs:batchDelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsBatchDelete_589182(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a list of Jobs by filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the project under which the job is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589184 = path.getOrDefault("parent")
  valid_589184 = validateParameter(valid_589184, JString, required = true,
                                 default = nil)
  if valid_589184 != nil:
    section.add "parent", valid_589184
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
  var valid_589185 = query.getOrDefault("upload_protocol")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "upload_protocol", valid_589185
  var valid_589186 = query.getOrDefault("fields")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "fields", valid_589186
  var valid_589187 = query.getOrDefault("quotaUser")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "quotaUser", valid_589187
  var valid_589188 = query.getOrDefault("alt")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = newJString("json"))
  if valid_589188 != nil:
    section.add "alt", valid_589188
  var valid_589189 = query.getOrDefault("oauth_token")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "oauth_token", valid_589189
  var valid_589190 = query.getOrDefault("callback")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "callback", valid_589190
  var valid_589191 = query.getOrDefault("access_token")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "access_token", valid_589191
  var valid_589192 = query.getOrDefault("uploadType")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "uploadType", valid_589192
  var valid_589193 = query.getOrDefault("key")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "key", valid_589193
  var valid_589194 = query.getOrDefault("$.xgafv")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = newJString("1"))
  if valid_589194 != nil:
    section.add "$.xgafv", valid_589194
  var valid_589195 = query.getOrDefault("prettyPrint")
  valid_589195 = validateParameter(valid_589195, JBool, required = false,
                                 default = newJBool(true))
  if valid_589195 != nil:
    section.add "prettyPrint", valid_589195
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

proc call*(call_589197: Call_JobsProjectsJobsBatchDelete_589181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a list of Jobs by filter.
  ## 
  let valid = call_589197.validator(path, query, header, formData, body)
  let scheme = call_589197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589197.url(scheme.get, call_589197.host, call_589197.base,
                         call_589197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589197, url, valid)

proc call*(call_589198: Call_JobsProjectsJobsBatchDelete_589181; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsProjectsJobsBatchDelete
  ## Deletes a list of Jobs by filter.
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
  ##         : Required. The resource name of the project under which the job is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589199 = newJObject()
  var query_589200 = newJObject()
  var body_589201 = newJObject()
  add(query_589200, "upload_protocol", newJString(uploadProtocol))
  add(query_589200, "fields", newJString(fields))
  add(query_589200, "quotaUser", newJString(quotaUser))
  add(query_589200, "alt", newJString(alt))
  add(query_589200, "oauth_token", newJString(oauthToken))
  add(query_589200, "callback", newJString(callback))
  add(query_589200, "access_token", newJString(accessToken))
  add(query_589200, "uploadType", newJString(uploadType))
  add(path_589199, "parent", newJString(parent))
  add(query_589200, "key", newJString(key))
  add(query_589200, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589201 = body
  add(query_589200, "prettyPrint", newJBool(prettyPrint))
  result = call_589198.call(path_589199, query_589200, nil, nil, body_589201)

var jobsProjectsJobsBatchDelete* = Call_JobsProjectsJobsBatchDelete_589181(
    name: "jobsProjectsJobsBatchDelete", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3/{parent}/jobs:batchDelete",
    validator: validate_JobsProjectsJobsBatchDelete_589182, base: "/",
    url: url_JobsProjectsJobsBatchDelete_589183, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsSearch_589202 = ref object of OpenApiRestCall_588450
proc url_JobsProjectsJobsSearch_589204(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsSearch_589203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs that the caller has
  ## permission to search against.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the project to search within.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589205 = path.getOrDefault("parent")
  valid_589205 = validateParameter(valid_589205, JString, required = true,
                                 default = nil)
  if valid_589205 != nil:
    section.add "parent", valid_589205
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
  var valid_589206 = query.getOrDefault("upload_protocol")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "upload_protocol", valid_589206
  var valid_589207 = query.getOrDefault("fields")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "fields", valid_589207
  var valid_589208 = query.getOrDefault("quotaUser")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "quotaUser", valid_589208
  var valid_589209 = query.getOrDefault("alt")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = newJString("json"))
  if valid_589209 != nil:
    section.add "alt", valid_589209
  var valid_589210 = query.getOrDefault("oauth_token")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "oauth_token", valid_589210
  var valid_589211 = query.getOrDefault("callback")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "callback", valid_589211
  var valid_589212 = query.getOrDefault("access_token")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "access_token", valid_589212
  var valid_589213 = query.getOrDefault("uploadType")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "uploadType", valid_589213
  var valid_589214 = query.getOrDefault("key")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "key", valid_589214
  var valid_589215 = query.getOrDefault("$.xgafv")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = newJString("1"))
  if valid_589215 != nil:
    section.add "$.xgafv", valid_589215
  var valid_589216 = query.getOrDefault("prettyPrint")
  valid_589216 = validateParameter(valid_589216, JBool, required = false,
                                 default = newJBool(true))
  if valid_589216 != nil:
    section.add "prettyPrint", valid_589216
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

proc call*(call_589218: Call_JobsProjectsJobsSearch_589202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs that the caller has
  ## permission to search against.
  ## 
  let valid = call_589218.validator(path, query, header, formData, body)
  let scheme = call_589218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589218.url(scheme.get, call_589218.host, call_589218.base,
                         call_589218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589218, url, valid)

proc call*(call_589219: Call_JobsProjectsJobsSearch_589202; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsProjectsJobsSearch
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs that the caller has
  ## permission to search against.
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
  ##         : Required. The resource name of the project to search within.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589220 = newJObject()
  var query_589221 = newJObject()
  var body_589222 = newJObject()
  add(query_589221, "upload_protocol", newJString(uploadProtocol))
  add(query_589221, "fields", newJString(fields))
  add(query_589221, "quotaUser", newJString(quotaUser))
  add(query_589221, "alt", newJString(alt))
  add(query_589221, "oauth_token", newJString(oauthToken))
  add(query_589221, "callback", newJString(callback))
  add(query_589221, "access_token", newJString(accessToken))
  add(query_589221, "uploadType", newJString(uploadType))
  add(path_589220, "parent", newJString(parent))
  add(query_589221, "key", newJString(key))
  add(query_589221, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589222 = body
  add(query_589221, "prettyPrint", newJBool(prettyPrint))
  result = call_589219.call(path_589220, query_589221, nil, nil, body_589222)

var jobsProjectsJobsSearch* = Call_JobsProjectsJobsSearch_589202(
    name: "jobsProjectsJobsSearch", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3/{parent}/jobs:search",
    validator: validate_JobsProjectsJobsSearch_589203, base: "/",
    url: url_JobsProjectsJobsSearch_589204, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsSearchForAlert_589223 = ref object of OpenApiRestCall_588450
proc url_JobsProjectsJobsSearchForAlert_589225(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs:searchForAlert")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsSearchForAlert_589224(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This API call is intended for the use case of targeting passive job
  ## seekers (for example, job seekers who have signed up to receive email
  ## alerts about potential job opportunities), and has different algorithmic
  ## adjustments that are targeted to passive job seekers.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs the caller has
  ## permission to search against.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the project to search within.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589226 = path.getOrDefault("parent")
  valid_589226 = validateParameter(valid_589226, JString, required = true,
                                 default = nil)
  if valid_589226 != nil:
    section.add "parent", valid_589226
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
  var valid_589227 = query.getOrDefault("upload_protocol")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "upload_protocol", valid_589227
  var valid_589228 = query.getOrDefault("fields")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "fields", valid_589228
  var valid_589229 = query.getOrDefault("quotaUser")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "quotaUser", valid_589229
  var valid_589230 = query.getOrDefault("alt")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = newJString("json"))
  if valid_589230 != nil:
    section.add "alt", valid_589230
  var valid_589231 = query.getOrDefault("oauth_token")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "oauth_token", valid_589231
  var valid_589232 = query.getOrDefault("callback")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "callback", valid_589232
  var valid_589233 = query.getOrDefault("access_token")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "access_token", valid_589233
  var valid_589234 = query.getOrDefault("uploadType")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "uploadType", valid_589234
  var valid_589235 = query.getOrDefault("key")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "key", valid_589235
  var valid_589236 = query.getOrDefault("$.xgafv")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = newJString("1"))
  if valid_589236 != nil:
    section.add "$.xgafv", valid_589236
  var valid_589237 = query.getOrDefault("prettyPrint")
  valid_589237 = validateParameter(valid_589237, JBool, required = false,
                                 default = newJBool(true))
  if valid_589237 != nil:
    section.add "prettyPrint", valid_589237
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

proc call*(call_589239: Call_JobsProjectsJobsSearchForAlert_589223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This API call is intended for the use case of targeting passive job
  ## seekers (for example, job seekers who have signed up to receive email
  ## alerts about potential job opportunities), and has different algorithmic
  ## adjustments that are targeted to passive job seekers.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs the caller has
  ## permission to search against.
  ## 
  let valid = call_589239.validator(path, query, header, formData, body)
  let scheme = call_589239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589239.url(scheme.get, call_589239.host, call_589239.base,
                         call_589239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589239, url, valid)

proc call*(call_589240: Call_JobsProjectsJobsSearchForAlert_589223; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsProjectsJobsSearchForAlert
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This API call is intended for the use case of targeting passive job
  ## seekers (for example, job seekers who have signed up to receive email
  ## alerts about potential job opportunities), and has different algorithmic
  ## adjustments that are targeted to passive job seekers.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs the caller has
  ## permission to search against.
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
  ##         : Required. The resource name of the project to search within.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589241 = newJObject()
  var query_589242 = newJObject()
  var body_589243 = newJObject()
  add(query_589242, "upload_protocol", newJString(uploadProtocol))
  add(query_589242, "fields", newJString(fields))
  add(query_589242, "quotaUser", newJString(quotaUser))
  add(query_589242, "alt", newJString(alt))
  add(query_589242, "oauth_token", newJString(oauthToken))
  add(query_589242, "callback", newJString(callback))
  add(query_589242, "access_token", newJString(accessToken))
  add(query_589242, "uploadType", newJString(uploadType))
  add(path_589241, "parent", newJString(parent))
  add(query_589242, "key", newJString(key))
  add(query_589242, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589243 = body
  add(query_589242, "prettyPrint", newJBool(prettyPrint))
  result = call_589240.call(path_589241, query_589242, nil, nil, body_589243)

var jobsProjectsJobsSearchForAlert* = Call_JobsProjectsJobsSearchForAlert_589223(
    name: "jobsProjectsJobsSearchForAlert", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3/{parent}/jobs:searchForAlert",
    validator: validate_JobsProjectsJobsSearchForAlert_589224, base: "/",
    url: url_JobsProjectsJobsSearchForAlert_589225, schemes: {Scheme.Https})
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
