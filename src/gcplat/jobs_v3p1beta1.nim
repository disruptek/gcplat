
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Talent Solution
## version: v3p1beta1
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
  gcpServiceName = "jobs"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobsProjectsJobsGet_593690 = ref object of OpenApiRestCall_593421
proc url_JobsProjectsJobsGet_593692(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3p1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsGet_593691(path: JsonNode; query: JsonNode;
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
  var valid_593818 = path.getOrDefault("name")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "name", valid_593818
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
  if body != nil:
    result.add "body", body

proc call*(call_593865: Call_JobsProjectsJobsGet_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified job, whose status is OPEN or recently EXPIRED
  ## within the last 90 days.
  ## 
  let valid = call_593865.validator(path, query, header, formData, body)
  let scheme = call_593865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593865.url(scheme.get, call_593865.host, call_593865.base,
                         call_593865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593865, url, valid)

proc call*(call_593936: Call_JobsProjectsJobsGet_593690; name: string;
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
  var path_593937 = newJObject()
  var query_593939 = newJObject()
  add(query_593939, "upload_protocol", newJString(uploadProtocol))
  add(query_593939, "fields", newJString(fields))
  add(query_593939, "quotaUser", newJString(quotaUser))
  add(path_593937, "name", newJString(name))
  add(query_593939, "alt", newJString(alt))
  add(query_593939, "oauth_token", newJString(oauthToken))
  add(query_593939, "callback", newJString(callback))
  add(query_593939, "access_token", newJString(accessToken))
  add(query_593939, "uploadType", newJString(uploadType))
  add(query_593939, "key", newJString(key))
  add(query_593939, "$.xgafv", newJString(Xgafv))
  add(query_593939, "prettyPrint", newJBool(prettyPrint))
  result = call_593936.call(path_593937, query_593939, nil, nil, nil)

var jobsProjectsJobsGet* = Call_JobsProjectsJobsGet_593690(
    name: "jobsProjectsJobsGet", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v3p1beta1/{name}",
    validator: validate_JobsProjectsJobsGet_593691, base: "/",
    url: url_JobsProjectsJobsGet_593692, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsPatch_593997 = ref object of OpenApiRestCall_593421
proc url_JobsProjectsJobsPatch_593999(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3p1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsPatch_593998(path: JsonNode; query: JsonNode;
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
  var valid_594000 = path.getOrDefault("name")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "name", valid_594000
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
  var valid_594001 = query.getOrDefault("upload_protocol")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "upload_protocol", valid_594001
  var valid_594002 = query.getOrDefault("fields")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "fields", valid_594002
  var valid_594003 = query.getOrDefault("quotaUser")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "quotaUser", valid_594003
  var valid_594004 = query.getOrDefault("alt")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("json"))
  if valid_594004 != nil:
    section.add "alt", valid_594004
  var valid_594005 = query.getOrDefault("oauth_token")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "oauth_token", valid_594005
  var valid_594006 = query.getOrDefault("callback")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "callback", valid_594006
  var valid_594007 = query.getOrDefault("access_token")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "access_token", valid_594007
  var valid_594008 = query.getOrDefault("uploadType")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "uploadType", valid_594008
  var valid_594009 = query.getOrDefault("key")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "key", valid_594009
  var valid_594010 = query.getOrDefault("$.xgafv")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = newJString("1"))
  if valid_594010 != nil:
    section.add "$.xgafv", valid_594010
  var valid_594011 = query.getOrDefault("prettyPrint")
  valid_594011 = validateParameter(valid_594011, JBool, required = false,
                                 default = newJBool(true))
  if valid_594011 != nil:
    section.add "prettyPrint", valid_594011
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

proc call*(call_594013: Call_JobsProjectsJobsPatch_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates specified job.
  ## 
  ## Typically, updated contents become visible in search results within 10
  ## seconds, but it may take up to 5 minutes.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_JobsProjectsJobsPatch_593997; name: string;
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
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  var body_594017 = newJObject()
  add(query_594016, "upload_protocol", newJString(uploadProtocol))
  add(query_594016, "fields", newJString(fields))
  add(query_594016, "quotaUser", newJString(quotaUser))
  add(path_594015, "name", newJString(name))
  add(query_594016, "alt", newJString(alt))
  add(query_594016, "oauth_token", newJString(oauthToken))
  add(query_594016, "callback", newJString(callback))
  add(query_594016, "access_token", newJString(accessToken))
  add(query_594016, "uploadType", newJString(uploadType))
  add(query_594016, "key", newJString(key))
  add(query_594016, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594017 = body
  add(query_594016, "prettyPrint", newJBool(prettyPrint))
  result = call_594014.call(path_594015, query_594016, nil, nil, body_594017)

var jobsProjectsJobsPatch* = Call_JobsProjectsJobsPatch_593997(
    name: "jobsProjectsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "jobs.googleapis.com", route: "/v3p1beta1/{name}",
    validator: validate_JobsProjectsJobsPatch_593998, base: "/",
    url: url_JobsProjectsJobsPatch_593999, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsDelete_593978 = ref object of OpenApiRestCall_593421
proc url_JobsProjectsJobsDelete_593980(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3p1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsDelete_593979(path: JsonNode; query: JsonNode;
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
  var valid_593981 = path.getOrDefault("name")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "name", valid_593981
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
  var valid_593982 = query.getOrDefault("upload_protocol")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "upload_protocol", valid_593982
  var valid_593983 = query.getOrDefault("fields")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "fields", valid_593983
  var valid_593984 = query.getOrDefault("quotaUser")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "quotaUser", valid_593984
  var valid_593985 = query.getOrDefault("alt")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = newJString("json"))
  if valid_593985 != nil:
    section.add "alt", valid_593985
  var valid_593986 = query.getOrDefault("oauth_token")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "oauth_token", valid_593986
  var valid_593987 = query.getOrDefault("callback")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "callback", valid_593987
  var valid_593988 = query.getOrDefault("access_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "access_token", valid_593988
  var valid_593989 = query.getOrDefault("uploadType")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "uploadType", valid_593989
  var valid_593990 = query.getOrDefault("key")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "key", valid_593990
  var valid_593991 = query.getOrDefault("$.xgafv")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("1"))
  if valid_593991 != nil:
    section.add "$.xgafv", valid_593991
  var valid_593992 = query.getOrDefault("prettyPrint")
  valid_593992 = validateParameter(valid_593992, JBool, required = false,
                                 default = newJBool(true))
  if valid_593992 != nil:
    section.add "prettyPrint", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_JobsProjectsJobsDelete_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified job.
  ## 
  ## Typically, the job becomes unsearchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_JobsProjectsJobsDelete_593978; name: string;
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
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "upload_protocol", newJString(uploadProtocol))
  add(query_593996, "fields", newJString(fields))
  add(query_593996, "quotaUser", newJString(quotaUser))
  add(path_593995, "name", newJString(name))
  add(query_593996, "alt", newJString(alt))
  add(query_593996, "oauth_token", newJString(oauthToken))
  add(query_593996, "callback", newJString(callback))
  add(query_593996, "access_token", newJString(accessToken))
  add(query_593996, "uploadType", newJString(uploadType))
  add(query_593996, "key", newJString(key))
  add(query_593996, "$.xgafv", newJString(Xgafv))
  add(query_593996, "prettyPrint", newJBool(prettyPrint))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var jobsProjectsJobsDelete* = Call_JobsProjectsJobsDelete_593978(
    name: "jobsProjectsJobsDelete", meth: HttpMethod.HttpDelete,
    host: "jobs.googleapis.com", route: "/v3p1beta1/{name}",
    validator: validate_JobsProjectsJobsDelete_593979, base: "/",
    url: url_JobsProjectsJobsDelete_593980, schemes: {Scheme.Https})
type
  Call_JobsProjectsComplete_594018 = ref object of OpenApiRestCall_593421
proc url_JobsProjectsComplete_594020(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3p1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":complete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsComplete_594019(path: JsonNode; query: JsonNode;
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
  var valid_594021 = path.getOrDefault("name")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "name", valid_594021
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
  var valid_594022 = query.getOrDefault("upload_protocol")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "upload_protocol", valid_594022
  var valid_594023 = query.getOrDefault("fields")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "fields", valid_594023
  var valid_594024 = query.getOrDefault("quotaUser")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "quotaUser", valid_594024
  var valid_594025 = query.getOrDefault("scope")
  valid_594025 = validateParameter(valid_594025, JString, required = false, default = newJString(
      "COMPLETION_SCOPE_UNSPECIFIED"))
  if valid_594025 != nil:
    section.add "scope", valid_594025
  var valid_594026 = query.getOrDefault("alt")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = newJString("json"))
  if valid_594026 != nil:
    section.add "alt", valid_594026
  var valid_594027 = query.getOrDefault("query")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "query", valid_594027
  var valid_594028 = query.getOrDefault("type")
  valid_594028 = validateParameter(valid_594028, JString, required = false, default = newJString(
      "COMPLETION_TYPE_UNSPECIFIED"))
  if valid_594028 != nil:
    section.add "type", valid_594028
  var valid_594029 = query.getOrDefault("oauth_token")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "oauth_token", valid_594029
  var valid_594030 = query.getOrDefault("callback")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "callback", valid_594030
  var valid_594031 = query.getOrDefault("access_token")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "access_token", valid_594031
  var valid_594032 = query.getOrDefault("uploadType")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "uploadType", valid_594032
  var valid_594033 = query.getOrDefault("key")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "key", valid_594033
  var valid_594034 = query.getOrDefault("$.xgafv")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = newJString("1"))
  if valid_594034 != nil:
    section.add "$.xgafv", valid_594034
  var valid_594035 = query.getOrDefault("languageCode")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "languageCode", valid_594035
  var valid_594036 = query.getOrDefault("pageSize")
  valid_594036 = validateParameter(valid_594036, JInt, required = false, default = nil)
  if valid_594036 != nil:
    section.add "pageSize", valid_594036
  var valid_594037 = query.getOrDefault("languageCodes")
  valid_594037 = validateParameter(valid_594037, JArray, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "languageCodes", valid_594037
  var valid_594038 = query.getOrDefault("companyName")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "companyName", valid_594038
  var valid_594039 = query.getOrDefault("prettyPrint")
  valid_594039 = validateParameter(valid_594039, JBool, required = false,
                                 default = newJBool(true))
  if valid_594039 != nil:
    section.add "prettyPrint", valid_594039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594040: Call_JobsProjectsComplete_594018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Completes the specified prefix with keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_JobsProjectsComplete_594018; name: string;
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
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  add(query_594043, "upload_protocol", newJString(uploadProtocol))
  add(query_594043, "fields", newJString(fields))
  add(query_594043, "quotaUser", newJString(quotaUser))
  add(path_594042, "name", newJString(name))
  add(query_594043, "scope", newJString(scope))
  add(query_594043, "alt", newJString(alt))
  add(query_594043, "query", newJString(query))
  add(query_594043, "type", newJString(`type`))
  add(query_594043, "oauth_token", newJString(oauthToken))
  add(query_594043, "callback", newJString(callback))
  add(query_594043, "access_token", newJString(accessToken))
  add(query_594043, "uploadType", newJString(uploadType))
  add(query_594043, "key", newJString(key))
  add(query_594043, "$.xgafv", newJString(Xgafv))
  add(query_594043, "languageCode", newJString(languageCode))
  add(query_594043, "pageSize", newJInt(pageSize))
  if languageCodes != nil:
    query_594043.add "languageCodes", languageCodes
  add(query_594043, "companyName", newJString(companyName))
  add(query_594043, "prettyPrint", newJBool(prettyPrint))
  result = call_594041.call(path_594042, query_594043, nil, nil, nil)

var jobsProjectsComplete* = Call_JobsProjectsComplete_594018(
    name: "jobsProjectsComplete", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v3p1beta1/{name}:complete",
    validator: validate_JobsProjectsComplete_594019, base: "/",
    url: url_JobsProjectsComplete_594020, schemes: {Scheme.Https})
type
  Call_JobsProjectsClientEventsCreate_594044 = ref object of OpenApiRestCall_593421
proc url_JobsProjectsClientEventsCreate_594046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3p1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clientEvents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsClientEventsCreate_594045(path: JsonNode;
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
  var valid_594047 = path.getOrDefault("parent")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "parent", valid_594047
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
  var valid_594048 = query.getOrDefault("upload_protocol")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "upload_protocol", valid_594048
  var valid_594049 = query.getOrDefault("fields")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "fields", valid_594049
  var valid_594050 = query.getOrDefault("quotaUser")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "quotaUser", valid_594050
  var valid_594051 = query.getOrDefault("alt")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = newJString("json"))
  if valid_594051 != nil:
    section.add "alt", valid_594051
  var valid_594052 = query.getOrDefault("oauth_token")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "oauth_token", valid_594052
  var valid_594053 = query.getOrDefault("callback")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "callback", valid_594053
  var valid_594054 = query.getOrDefault("access_token")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "access_token", valid_594054
  var valid_594055 = query.getOrDefault("uploadType")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "uploadType", valid_594055
  var valid_594056 = query.getOrDefault("key")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "key", valid_594056
  var valid_594057 = query.getOrDefault("$.xgafv")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = newJString("1"))
  if valid_594057 != nil:
    section.add "$.xgafv", valid_594057
  var valid_594058 = query.getOrDefault("prettyPrint")
  valid_594058 = validateParameter(valid_594058, JBool, required = false,
                                 default = newJBool(true))
  if valid_594058 != nil:
    section.add "prettyPrint", valid_594058
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

proc call*(call_594060: Call_JobsProjectsClientEventsCreate_594044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Report events issued when end user interacts with customer's application
  ## that uses Cloud Talent Solution. You may inspect the created events in
  ## [self service
  ## tools](https://console.cloud.google.com/talent-solution/overview).
  ## [Learn
  ## more](https://cloud.google.com/talent-solution/docs/management-tools)
  ## about self service tools.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_JobsProjectsClientEventsCreate_594044; parent: string;
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
  var path_594062 = newJObject()
  var query_594063 = newJObject()
  var body_594064 = newJObject()
  add(query_594063, "upload_protocol", newJString(uploadProtocol))
  add(query_594063, "fields", newJString(fields))
  add(query_594063, "quotaUser", newJString(quotaUser))
  add(query_594063, "alt", newJString(alt))
  add(query_594063, "oauth_token", newJString(oauthToken))
  add(query_594063, "callback", newJString(callback))
  add(query_594063, "access_token", newJString(accessToken))
  add(query_594063, "uploadType", newJString(uploadType))
  add(path_594062, "parent", newJString(parent))
  add(query_594063, "key", newJString(key))
  add(query_594063, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594064 = body
  add(query_594063, "prettyPrint", newJBool(prettyPrint))
  result = call_594061.call(path_594062, query_594063, nil, nil, body_594064)

var jobsProjectsClientEventsCreate* = Call_JobsProjectsClientEventsCreate_594044(
    name: "jobsProjectsClientEventsCreate", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3p1beta1/{parent}/clientEvents",
    validator: validate_JobsProjectsClientEventsCreate_594045, base: "/",
    url: url_JobsProjectsClientEventsCreate_594046, schemes: {Scheme.Https})
type
  Call_JobsProjectsCompaniesCreate_594087 = ref object of OpenApiRestCall_593421
proc url_JobsProjectsCompaniesCreate_594089(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3p1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/companies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsCompaniesCreate_594088(path: JsonNode; query: JsonNode;
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
  var valid_594090 = path.getOrDefault("parent")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "parent", valid_594090
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
  var valid_594091 = query.getOrDefault("upload_protocol")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "upload_protocol", valid_594091
  var valid_594092 = query.getOrDefault("fields")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "fields", valid_594092
  var valid_594093 = query.getOrDefault("quotaUser")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "quotaUser", valid_594093
  var valid_594094 = query.getOrDefault("alt")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = newJString("json"))
  if valid_594094 != nil:
    section.add "alt", valid_594094
  var valid_594095 = query.getOrDefault("oauth_token")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "oauth_token", valid_594095
  var valid_594096 = query.getOrDefault("callback")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "callback", valid_594096
  var valid_594097 = query.getOrDefault("access_token")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "access_token", valid_594097
  var valid_594098 = query.getOrDefault("uploadType")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "uploadType", valid_594098
  var valid_594099 = query.getOrDefault("key")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "key", valid_594099
  var valid_594100 = query.getOrDefault("$.xgafv")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = newJString("1"))
  if valid_594100 != nil:
    section.add "$.xgafv", valid_594100
  var valid_594101 = query.getOrDefault("prettyPrint")
  valid_594101 = validateParameter(valid_594101, JBool, required = false,
                                 default = newJBool(true))
  if valid_594101 != nil:
    section.add "prettyPrint", valid_594101
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

proc call*(call_594103: Call_JobsProjectsCompaniesCreate_594087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new company entity.
  ## 
  let valid = call_594103.validator(path, query, header, formData, body)
  let scheme = call_594103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594103.url(scheme.get, call_594103.host, call_594103.base,
                         call_594103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594103, url, valid)

proc call*(call_594104: Call_JobsProjectsCompaniesCreate_594087; parent: string;
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
  var path_594105 = newJObject()
  var query_594106 = newJObject()
  var body_594107 = newJObject()
  add(query_594106, "upload_protocol", newJString(uploadProtocol))
  add(query_594106, "fields", newJString(fields))
  add(query_594106, "quotaUser", newJString(quotaUser))
  add(query_594106, "alt", newJString(alt))
  add(query_594106, "oauth_token", newJString(oauthToken))
  add(query_594106, "callback", newJString(callback))
  add(query_594106, "access_token", newJString(accessToken))
  add(query_594106, "uploadType", newJString(uploadType))
  add(path_594105, "parent", newJString(parent))
  add(query_594106, "key", newJString(key))
  add(query_594106, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594107 = body
  add(query_594106, "prettyPrint", newJBool(prettyPrint))
  result = call_594104.call(path_594105, query_594106, nil, nil, body_594107)

var jobsProjectsCompaniesCreate* = Call_JobsProjectsCompaniesCreate_594087(
    name: "jobsProjectsCompaniesCreate", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3p1beta1/{parent}/companies",
    validator: validate_JobsProjectsCompaniesCreate_594088, base: "/",
    url: url_JobsProjectsCompaniesCreate_594089, schemes: {Scheme.Https})
type
  Call_JobsProjectsCompaniesList_594065 = ref object of OpenApiRestCall_593421
proc url_JobsProjectsCompaniesList_594067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3p1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/companies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsCompaniesList_594066(path: JsonNode; query: JsonNode;
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
  var valid_594068 = path.getOrDefault("parent")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "parent", valid_594068
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
  var valid_594069 = query.getOrDefault("upload_protocol")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "upload_protocol", valid_594069
  var valid_594070 = query.getOrDefault("fields")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "fields", valid_594070
  var valid_594071 = query.getOrDefault("pageToken")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "pageToken", valid_594071
  var valid_594072 = query.getOrDefault("quotaUser")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "quotaUser", valid_594072
  var valid_594073 = query.getOrDefault("alt")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = newJString("json"))
  if valid_594073 != nil:
    section.add "alt", valid_594073
  var valid_594074 = query.getOrDefault("requireOpenJobs")
  valid_594074 = validateParameter(valid_594074, JBool, required = false, default = nil)
  if valid_594074 != nil:
    section.add "requireOpenJobs", valid_594074
  var valid_594075 = query.getOrDefault("oauth_token")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "oauth_token", valid_594075
  var valid_594076 = query.getOrDefault("callback")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "callback", valid_594076
  var valid_594077 = query.getOrDefault("access_token")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "access_token", valid_594077
  var valid_594078 = query.getOrDefault("uploadType")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "uploadType", valid_594078
  var valid_594079 = query.getOrDefault("key")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "key", valid_594079
  var valid_594080 = query.getOrDefault("$.xgafv")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = newJString("1"))
  if valid_594080 != nil:
    section.add "$.xgafv", valid_594080
  var valid_594081 = query.getOrDefault("pageSize")
  valid_594081 = validateParameter(valid_594081, JInt, required = false, default = nil)
  if valid_594081 != nil:
    section.add "pageSize", valid_594081
  var valid_594082 = query.getOrDefault("prettyPrint")
  valid_594082 = validateParameter(valid_594082, JBool, required = false,
                                 default = newJBool(true))
  if valid_594082 != nil:
    section.add "prettyPrint", valid_594082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594083: Call_JobsProjectsCompaniesList_594065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all companies associated with the service account.
  ## 
  let valid = call_594083.validator(path, query, header, formData, body)
  let scheme = call_594083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594083.url(scheme.get, call_594083.host, call_594083.base,
                         call_594083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594083, url, valid)

proc call*(call_594084: Call_JobsProjectsCompaniesList_594065; parent: string;
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
  var path_594085 = newJObject()
  var query_594086 = newJObject()
  add(query_594086, "upload_protocol", newJString(uploadProtocol))
  add(query_594086, "fields", newJString(fields))
  add(query_594086, "pageToken", newJString(pageToken))
  add(query_594086, "quotaUser", newJString(quotaUser))
  add(query_594086, "alt", newJString(alt))
  add(query_594086, "requireOpenJobs", newJBool(requireOpenJobs))
  add(query_594086, "oauth_token", newJString(oauthToken))
  add(query_594086, "callback", newJString(callback))
  add(query_594086, "access_token", newJString(accessToken))
  add(query_594086, "uploadType", newJString(uploadType))
  add(path_594085, "parent", newJString(parent))
  add(query_594086, "key", newJString(key))
  add(query_594086, "$.xgafv", newJString(Xgafv))
  add(query_594086, "pageSize", newJInt(pageSize))
  add(query_594086, "prettyPrint", newJBool(prettyPrint))
  result = call_594084.call(path_594085, query_594086, nil, nil, nil)

var jobsProjectsCompaniesList* = Call_JobsProjectsCompaniesList_594065(
    name: "jobsProjectsCompaniesList", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v3p1beta1/{parent}/companies",
    validator: validate_JobsProjectsCompaniesList_594066, base: "/",
    url: url_JobsProjectsCompaniesList_594067, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsCreate_594131 = ref object of OpenApiRestCall_593421
proc url_JobsProjectsJobsCreate_594133(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3p1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsCreate_594132(path: JsonNode; query: JsonNode;
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
  var valid_594134 = path.getOrDefault("parent")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "parent", valid_594134
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
  var valid_594135 = query.getOrDefault("upload_protocol")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "upload_protocol", valid_594135
  var valid_594136 = query.getOrDefault("fields")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "fields", valid_594136
  var valid_594137 = query.getOrDefault("quotaUser")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "quotaUser", valid_594137
  var valid_594138 = query.getOrDefault("alt")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = newJString("json"))
  if valid_594138 != nil:
    section.add "alt", valid_594138
  var valid_594139 = query.getOrDefault("oauth_token")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "oauth_token", valid_594139
  var valid_594140 = query.getOrDefault("callback")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "callback", valid_594140
  var valid_594141 = query.getOrDefault("access_token")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "access_token", valid_594141
  var valid_594142 = query.getOrDefault("uploadType")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "uploadType", valid_594142
  var valid_594143 = query.getOrDefault("key")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "key", valid_594143
  var valid_594144 = query.getOrDefault("$.xgafv")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = newJString("1"))
  if valid_594144 != nil:
    section.add "$.xgafv", valid_594144
  var valid_594145 = query.getOrDefault("prettyPrint")
  valid_594145 = validateParameter(valid_594145, JBool, required = false,
                                 default = newJBool(true))
  if valid_594145 != nil:
    section.add "prettyPrint", valid_594145
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

proc call*(call_594147: Call_JobsProjectsJobsCreate_594131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job.
  ## 
  ## Typically, the job becomes searchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ## 
  let valid = call_594147.validator(path, query, header, formData, body)
  let scheme = call_594147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594147.url(scheme.get, call_594147.host, call_594147.base,
                         call_594147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594147, url, valid)

proc call*(call_594148: Call_JobsProjectsJobsCreate_594131; parent: string;
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
  var path_594149 = newJObject()
  var query_594150 = newJObject()
  var body_594151 = newJObject()
  add(query_594150, "upload_protocol", newJString(uploadProtocol))
  add(query_594150, "fields", newJString(fields))
  add(query_594150, "quotaUser", newJString(quotaUser))
  add(query_594150, "alt", newJString(alt))
  add(query_594150, "oauth_token", newJString(oauthToken))
  add(query_594150, "callback", newJString(callback))
  add(query_594150, "access_token", newJString(accessToken))
  add(query_594150, "uploadType", newJString(uploadType))
  add(path_594149, "parent", newJString(parent))
  add(query_594150, "key", newJString(key))
  add(query_594150, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594151 = body
  add(query_594150, "prettyPrint", newJBool(prettyPrint))
  result = call_594148.call(path_594149, query_594150, nil, nil, body_594151)

var jobsProjectsJobsCreate* = Call_JobsProjectsJobsCreate_594131(
    name: "jobsProjectsJobsCreate", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3p1beta1/{parent}/jobs",
    validator: validate_JobsProjectsJobsCreate_594132, base: "/",
    url: url_JobsProjectsJobsCreate_594133, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsList_594108 = ref object of OpenApiRestCall_593421
proc url_JobsProjectsJobsList_594110(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3p1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsList_594109(path: JsonNode; query: JsonNode;
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
  var valid_594111 = path.getOrDefault("parent")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "parent", valid_594111
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
  var valid_594112 = query.getOrDefault("upload_protocol")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "upload_protocol", valid_594112
  var valid_594113 = query.getOrDefault("fields")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "fields", valid_594113
  var valid_594114 = query.getOrDefault("pageToken")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "pageToken", valid_594114
  var valid_594115 = query.getOrDefault("quotaUser")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "quotaUser", valid_594115
  var valid_594116 = query.getOrDefault("alt")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = newJString("json"))
  if valid_594116 != nil:
    section.add "alt", valid_594116
  var valid_594117 = query.getOrDefault("jobView")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = newJString("JOB_VIEW_UNSPECIFIED"))
  if valid_594117 != nil:
    section.add "jobView", valid_594117
  var valid_594118 = query.getOrDefault("oauth_token")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "oauth_token", valid_594118
  var valid_594119 = query.getOrDefault("callback")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "callback", valid_594119
  var valid_594120 = query.getOrDefault("access_token")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "access_token", valid_594120
  var valid_594121 = query.getOrDefault("uploadType")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "uploadType", valid_594121
  var valid_594122 = query.getOrDefault("key")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "key", valid_594122
  var valid_594123 = query.getOrDefault("$.xgafv")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = newJString("1"))
  if valid_594123 != nil:
    section.add "$.xgafv", valid_594123
  var valid_594124 = query.getOrDefault("pageSize")
  valid_594124 = validateParameter(valid_594124, JInt, required = false, default = nil)
  if valid_594124 != nil:
    section.add "pageSize", valid_594124
  var valid_594125 = query.getOrDefault("prettyPrint")
  valid_594125 = validateParameter(valid_594125, JBool, required = false,
                                 default = newJBool(true))
  if valid_594125 != nil:
    section.add "prettyPrint", valid_594125
  var valid_594126 = query.getOrDefault("filter")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "filter", valid_594126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594127: Call_JobsProjectsJobsList_594108; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs by filter.
  ## 
  let valid = call_594127.validator(path, query, header, formData, body)
  let scheme = call_594127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594127.url(scheme.get, call_594127.host, call_594127.base,
                         call_594127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594127, url, valid)

proc call*(call_594128: Call_JobsProjectsJobsList_594108; parent: string;
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
  var path_594129 = newJObject()
  var query_594130 = newJObject()
  add(query_594130, "upload_protocol", newJString(uploadProtocol))
  add(query_594130, "fields", newJString(fields))
  add(query_594130, "pageToken", newJString(pageToken))
  add(query_594130, "quotaUser", newJString(quotaUser))
  add(query_594130, "alt", newJString(alt))
  add(query_594130, "jobView", newJString(jobView))
  add(query_594130, "oauth_token", newJString(oauthToken))
  add(query_594130, "callback", newJString(callback))
  add(query_594130, "access_token", newJString(accessToken))
  add(query_594130, "uploadType", newJString(uploadType))
  add(path_594129, "parent", newJString(parent))
  add(query_594130, "key", newJString(key))
  add(query_594130, "$.xgafv", newJString(Xgafv))
  add(query_594130, "pageSize", newJInt(pageSize))
  add(query_594130, "prettyPrint", newJBool(prettyPrint))
  add(query_594130, "filter", newJString(filter))
  result = call_594128.call(path_594129, query_594130, nil, nil, nil)

var jobsProjectsJobsList* = Call_JobsProjectsJobsList_594108(
    name: "jobsProjectsJobsList", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v3p1beta1/{parent}/jobs",
    validator: validate_JobsProjectsJobsList_594109, base: "/",
    url: url_JobsProjectsJobsList_594110, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsBatchDelete_594152 = ref object of OpenApiRestCall_593421
proc url_JobsProjectsJobsBatchDelete_594154(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3p1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs:batchDelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsBatchDelete_594153(path: JsonNode; query: JsonNode;
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
  var valid_594155 = path.getOrDefault("parent")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "parent", valid_594155
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
  var valid_594156 = query.getOrDefault("upload_protocol")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "upload_protocol", valid_594156
  var valid_594157 = query.getOrDefault("fields")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "fields", valid_594157
  var valid_594158 = query.getOrDefault("quotaUser")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "quotaUser", valid_594158
  var valid_594159 = query.getOrDefault("alt")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = newJString("json"))
  if valid_594159 != nil:
    section.add "alt", valid_594159
  var valid_594160 = query.getOrDefault("oauth_token")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "oauth_token", valid_594160
  var valid_594161 = query.getOrDefault("callback")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "callback", valid_594161
  var valid_594162 = query.getOrDefault("access_token")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "access_token", valid_594162
  var valid_594163 = query.getOrDefault("uploadType")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "uploadType", valid_594163
  var valid_594164 = query.getOrDefault("key")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "key", valid_594164
  var valid_594165 = query.getOrDefault("$.xgafv")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = newJString("1"))
  if valid_594165 != nil:
    section.add "$.xgafv", valid_594165
  var valid_594166 = query.getOrDefault("prettyPrint")
  valid_594166 = validateParameter(valid_594166, JBool, required = false,
                                 default = newJBool(true))
  if valid_594166 != nil:
    section.add "prettyPrint", valid_594166
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

proc call*(call_594168: Call_JobsProjectsJobsBatchDelete_594152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a list of Jobs by filter.
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_JobsProjectsJobsBatchDelete_594152; parent: string;
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
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  var body_594172 = newJObject()
  add(query_594171, "upload_protocol", newJString(uploadProtocol))
  add(query_594171, "fields", newJString(fields))
  add(query_594171, "quotaUser", newJString(quotaUser))
  add(query_594171, "alt", newJString(alt))
  add(query_594171, "oauth_token", newJString(oauthToken))
  add(query_594171, "callback", newJString(callback))
  add(query_594171, "access_token", newJString(accessToken))
  add(query_594171, "uploadType", newJString(uploadType))
  add(path_594170, "parent", newJString(parent))
  add(query_594171, "key", newJString(key))
  add(query_594171, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594172 = body
  add(query_594171, "prettyPrint", newJBool(prettyPrint))
  result = call_594169.call(path_594170, query_594171, nil, nil, body_594172)

var jobsProjectsJobsBatchDelete* = Call_JobsProjectsJobsBatchDelete_594152(
    name: "jobsProjectsJobsBatchDelete", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3p1beta1/{parent}/jobs:batchDelete",
    validator: validate_JobsProjectsJobsBatchDelete_594153, base: "/",
    url: url_JobsProjectsJobsBatchDelete_594154, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsSearch_594173 = ref object of OpenApiRestCall_593421
proc url_JobsProjectsJobsSearch_594175(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3p1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsSearch_594174(path: JsonNode; query: JsonNode;
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
  var valid_594176 = path.getOrDefault("parent")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "parent", valid_594176
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
  var valid_594177 = query.getOrDefault("upload_protocol")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "upload_protocol", valid_594177
  var valid_594178 = query.getOrDefault("fields")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "fields", valid_594178
  var valid_594179 = query.getOrDefault("quotaUser")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "quotaUser", valid_594179
  var valid_594180 = query.getOrDefault("alt")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = newJString("json"))
  if valid_594180 != nil:
    section.add "alt", valid_594180
  var valid_594181 = query.getOrDefault("oauth_token")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "oauth_token", valid_594181
  var valid_594182 = query.getOrDefault("callback")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "callback", valid_594182
  var valid_594183 = query.getOrDefault("access_token")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "access_token", valid_594183
  var valid_594184 = query.getOrDefault("uploadType")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "uploadType", valid_594184
  var valid_594185 = query.getOrDefault("key")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "key", valid_594185
  var valid_594186 = query.getOrDefault("$.xgafv")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = newJString("1"))
  if valid_594186 != nil:
    section.add "$.xgafv", valid_594186
  var valid_594187 = query.getOrDefault("prettyPrint")
  valid_594187 = validateParameter(valid_594187, JBool, required = false,
                                 default = newJBool(true))
  if valid_594187 != nil:
    section.add "prettyPrint", valid_594187
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

proc call*(call_594189: Call_JobsProjectsJobsSearch_594173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs that the caller has
  ## permission to search against.
  ## 
  let valid = call_594189.validator(path, query, header, formData, body)
  let scheme = call_594189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594189.url(scheme.get, call_594189.host, call_594189.base,
                         call_594189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594189, url, valid)

proc call*(call_594190: Call_JobsProjectsJobsSearch_594173; parent: string;
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
  var path_594191 = newJObject()
  var query_594192 = newJObject()
  var body_594193 = newJObject()
  add(query_594192, "upload_protocol", newJString(uploadProtocol))
  add(query_594192, "fields", newJString(fields))
  add(query_594192, "quotaUser", newJString(quotaUser))
  add(query_594192, "alt", newJString(alt))
  add(query_594192, "oauth_token", newJString(oauthToken))
  add(query_594192, "callback", newJString(callback))
  add(query_594192, "access_token", newJString(accessToken))
  add(query_594192, "uploadType", newJString(uploadType))
  add(path_594191, "parent", newJString(parent))
  add(query_594192, "key", newJString(key))
  add(query_594192, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594193 = body
  add(query_594192, "prettyPrint", newJBool(prettyPrint))
  result = call_594190.call(path_594191, query_594192, nil, nil, body_594193)

var jobsProjectsJobsSearch* = Call_JobsProjectsJobsSearch_594173(
    name: "jobsProjectsJobsSearch", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3p1beta1/{parent}/jobs:search",
    validator: validate_JobsProjectsJobsSearch_594174, base: "/",
    url: url_JobsProjectsJobsSearch_594175, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsSearchForAlert_594194 = ref object of OpenApiRestCall_593421
proc url_JobsProjectsJobsSearchForAlert_594196(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3p1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jobs:searchForAlert")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_JobsProjectsJobsSearchForAlert_594195(path: JsonNode;
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
  var valid_594197 = path.getOrDefault("parent")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "parent", valid_594197
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
  var valid_594198 = query.getOrDefault("upload_protocol")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "upload_protocol", valid_594198
  var valid_594199 = query.getOrDefault("fields")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "fields", valid_594199
  var valid_594200 = query.getOrDefault("quotaUser")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "quotaUser", valid_594200
  var valid_594201 = query.getOrDefault("alt")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = newJString("json"))
  if valid_594201 != nil:
    section.add "alt", valid_594201
  var valid_594202 = query.getOrDefault("oauth_token")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "oauth_token", valid_594202
  var valid_594203 = query.getOrDefault("callback")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "callback", valid_594203
  var valid_594204 = query.getOrDefault("access_token")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "access_token", valid_594204
  var valid_594205 = query.getOrDefault("uploadType")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "uploadType", valid_594205
  var valid_594206 = query.getOrDefault("key")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "key", valid_594206
  var valid_594207 = query.getOrDefault("$.xgafv")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = newJString("1"))
  if valid_594207 != nil:
    section.add "$.xgafv", valid_594207
  var valid_594208 = query.getOrDefault("prettyPrint")
  valid_594208 = validateParameter(valid_594208, JBool, required = false,
                                 default = newJBool(true))
  if valid_594208 != nil:
    section.add "prettyPrint", valid_594208
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

proc call*(call_594210: Call_JobsProjectsJobsSearchForAlert_594194; path: JsonNode;
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
  let valid = call_594210.validator(path, query, header, formData, body)
  let scheme = call_594210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594210.url(scheme.get, call_594210.host, call_594210.base,
                         call_594210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594210, url, valid)

proc call*(call_594211: Call_JobsProjectsJobsSearchForAlert_594194; parent: string;
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
  var path_594212 = newJObject()
  var query_594213 = newJObject()
  var body_594214 = newJObject()
  add(query_594213, "upload_protocol", newJString(uploadProtocol))
  add(query_594213, "fields", newJString(fields))
  add(query_594213, "quotaUser", newJString(quotaUser))
  add(query_594213, "alt", newJString(alt))
  add(query_594213, "oauth_token", newJString(oauthToken))
  add(query_594213, "callback", newJString(callback))
  add(query_594213, "access_token", newJString(accessToken))
  add(query_594213, "uploadType", newJString(uploadType))
  add(path_594212, "parent", newJString(parent))
  add(query_594213, "key", newJString(key))
  add(query_594213, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594214 = body
  add(query_594213, "prettyPrint", newJBool(prettyPrint))
  result = call_594211.call(path_594212, query_594213, nil, nil, body_594214)

var jobsProjectsJobsSearchForAlert* = Call_JobsProjectsJobsSearchForAlert_594194(
    name: "jobsProjectsJobsSearchForAlert", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3p1beta1/{parent}/jobs:searchForAlert",
    validator: validate_JobsProjectsJobsSearchForAlert_594195, base: "/",
    url: url_JobsProjectsJobsSearchForAlert_594196, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
