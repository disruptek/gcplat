
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
  gcpServiceName = "jobs"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobsProjectsJobsGet_578619 = ref object of OpenApiRestCall_578348
proc url_JobsProjectsJobsGet_578621(protocol: Scheme; host: string; base: string;
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

proc validate_JobsProjectsJobsGet_578620(path: JsonNode; query: JsonNode;
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
  var valid_578747 = path.getOrDefault("name")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "name", valid_578747
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
  if body != nil:
    result.add "body", body

proc call*(call_578794: Call_JobsProjectsJobsGet_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified job, whose status is OPEN or recently EXPIRED
  ## within the last 90 days.
  ## 
  let valid = call_578794.validator(path, query, header, formData, body)
  let scheme = call_578794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578794.url(scheme.get, call_578794.host, call_578794.base,
                         call_578794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578794, url, valid)

proc call*(call_578865: Call_JobsProjectsJobsGet_578619; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsProjectsJobsGet
  ## Retrieves the specified job, whose status is OPEN or recently EXPIRED
  ## within the last 90 days.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the job to retrieve.
  ## 
  ## The format is "projects/{project_id}/jobs/{job_id}",
  ## for example, "projects/api-test-project/jobs/1234".
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578866 = newJObject()
  var query_578868 = newJObject()
  add(query_578868, "key", newJString(key))
  add(query_578868, "prettyPrint", newJBool(prettyPrint))
  add(query_578868, "oauth_token", newJString(oauthToken))
  add(query_578868, "$.xgafv", newJString(Xgafv))
  add(query_578868, "alt", newJString(alt))
  add(query_578868, "uploadType", newJString(uploadType))
  add(query_578868, "quotaUser", newJString(quotaUser))
  add(path_578866, "name", newJString(name))
  add(query_578868, "callback", newJString(callback))
  add(query_578868, "fields", newJString(fields))
  add(query_578868, "access_token", newJString(accessToken))
  add(query_578868, "upload_protocol", newJString(uploadProtocol))
  result = call_578865.call(path_578866, query_578868, nil, nil, nil)

var jobsProjectsJobsGet* = Call_JobsProjectsJobsGet_578619(
    name: "jobsProjectsJobsGet", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v3/{name}",
    validator: validate_JobsProjectsJobsGet_578620, base: "/",
    url: url_JobsProjectsJobsGet_578621, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsPatch_578926 = ref object of OpenApiRestCall_578348
proc url_JobsProjectsJobsPatch_578928(protocol: Scheme; host: string; base: string;
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

proc validate_JobsProjectsJobsPatch_578927(path: JsonNode; query: JsonNode;
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
  var valid_578929 = path.getOrDefault("name")
  valid_578929 = validateParameter(valid_578929, JString, required = true,
                                 default = nil)
  if valid_578929 != nil:
    section.add "name", valid_578929
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
  var valid_578930 = query.getOrDefault("key")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "key", valid_578930
  var valid_578931 = query.getOrDefault("prettyPrint")
  valid_578931 = validateParameter(valid_578931, JBool, required = false,
                                 default = newJBool(true))
  if valid_578931 != nil:
    section.add "prettyPrint", valid_578931
  var valid_578932 = query.getOrDefault("oauth_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "oauth_token", valid_578932
  var valid_578933 = query.getOrDefault("$.xgafv")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = newJString("1"))
  if valid_578933 != nil:
    section.add "$.xgafv", valid_578933
  var valid_578934 = query.getOrDefault("alt")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = newJString("json"))
  if valid_578934 != nil:
    section.add "alt", valid_578934
  var valid_578935 = query.getOrDefault("uploadType")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "uploadType", valid_578935
  var valid_578936 = query.getOrDefault("quotaUser")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "quotaUser", valid_578936
  var valid_578937 = query.getOrDefault("callback")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "callback", valid_578937
  var valid_578938 = query.getOrDefault("fields")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "fields", valid_578938
  var valid_578939 = query.getOrDefault("access_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "access_token", valid_578939
  var valid_578940 = query.getOrDefault("upload_protocol")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "upload_protocol", valid_578940
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

proc call*(call_578942: Call_JobsProjectsJobsPatch_578926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates specified job.
  ## 
  ## Typically, updated contents become visible in search results within 10
  ## seconds, but it may take up to 5 minutes.
  ## 
  let valid = call_578942.validator(path, query, header, formData, body)
  let scheme = call_578942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578942.url(scheme.get, call_578942.host, call_578942.base,
                         call_578942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578942, url, valid)

proc call*(call_578943: Call_JobsProjectsJobsPatch_578926; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsProjectsJobsPatch
  ## Updates specified job.
  ## 
  ## Typically, updated contents become visible in search results within 10
  ## seconds, but it may take up to 5 minutes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578944 = newJObject()
  var query_578945 = newJObject()
  var body_578946 = newJObject()
  add(query_578945, "key", newJString(key))
  add(query_578945, "prettyPrint", newJBool(prettyPrint))
  add(query_578945, "oauth_token", newJString(oauthToken))
  add(query_578945, "$.xgafv", newJString(Xgafv))
  add(query_578945, "alt", newJString(alt))
  add(query_578945, "uploadType", newJString(uploadType))
  add(query_578945, "quotaUser", newJString(quotaUser))
  add(path_578944, "name", newJString(name))
  if body != nil:
    body_578946 = body
  add(query_578945, "callback", newJString(callback))
  add(query_578945, "fields", newJString(fields))
  add(query_578945, "access_token", newJString(accessToken))
  add(query_578945, "upload_protocol", newJString(uploadProtocol))
  result = call_578943.call(path_578944, query_578945, nil, nil, body_578946)

var jobsProjectsJobsPatch* = Call_JobsProjectsJobsPatch_578926(
    name: "jobsProjectsJobsPatch", meth: HttpMethod.HttpPatch,
    host: "jobs.googleapis.com", route: "/v3/{name}",
    validator: validate_JobsProjectsJobsPatch_578927, base: "/",
    url: url_JobsProjectsJobsPatch_578928, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsDelete_578907 = ref object of OpenApiRestCall_578348
proc url_JobsProjectsJobsDelete_578909(protocol: Scheme; host: string; base: string;
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

proc validate_JobsProjectsJobsDelete_578908(path: JsonNode; query: JsonNode;
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
  var valid_578910 = path.getOrDefault("name")
  valid_578910 = validateParameter(valid_578910, JString, required = true,
                                 default = nil)
  if valid_578910 != nil:
    section.add "name", valid_578910
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
  var valid_578911 = query.getOrDefault("key")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "key", valid_578911
  var valid_578912 = query.getOrDefault("prettyPrint")
  valid_578912 = validateParameter(valid_578912, JBool, required = false,
                                 default = newJBool(true))
  if valid_578912 != nil:
    section.add "prettyPrint", valid_578912
  var valid_578913 = query.getOrDefault("oauth_token")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "oauth_token", valid_578913
  var valid_578914 = query.getOrDefault("$.xgafv")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = newJString("1"))
  if valid_578914 != nil:
    section.add "$.xgafv", valid_578914
  var valid_578915 = query.getOrDefault("alt")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("json"))
  if valid_578915 != nil:
    section.add "alt", valid_578915
  var valid_578916 = query.getOrDefault("uploadType")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "uploadType", valid_578916
  var valid_578917 = query.getOrDefault("quotaUser")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "quotaUser", valid_578917
  var valid_578918 = query.getOrDefault("callback")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "callback", valid_578918
  var valid_578919 = query.getOrDefault("fields")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "fields", valid_578919
  var valid_578920 = query.getOrDefault("access_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "access_token", valid_578920
  var valid_578921 = query.getOrDefault("upload_protocol")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "upload_protocol", valid_578921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578922: Call_JobsProjectsJobsDelete_578907; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified job.
  ## 
  ## Typically, the job becomes unsearchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ## 
  let valid = call_578922.validator(path, query, header, formData, body)
  let scheme = call_578922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578922.url(scheme.get, call_578922.host, call_578922.base,
                         call_578922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578922, url, valid)

proc call*(call_578923: Call_JobsProjectsJobsDelete_578907; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsProjectsJobsDelete
  ## Deletes the specified job.
  ## 
  ## Typically, the job becomes unsearchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the job to be deleted.
  ## 
  ## The format is "projects/{project_id}/jobs/{job_id}",
  ## for example, "projects/api-test-project/jobs/1234".
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578924 = newJObject()
  var query_578925 = newJObject()
  add(query_578925, "key", newJString(key))
  add(query_578925, "prettyPrint", newJBool(prettyPrint))
  add(query_578925, "oauth_token", newJString(oauthToken))
  add(query_578925, "$.xgafv", newJString(Xgafv))
  add(query_578925, "alt", newJString(alt))
  add(query_578925, "uploadType", newJString(uploadType))
  add(query_578925, "quotaUser", newJString(quotaUser))
  add(path_578924, "name", newJString(name))
  add(query_578925, "callback", newJString(callback))
  add(query_578925, "fields", newJString(fields))
  add(query_578925, "access_token", newJString(accessToken))
  add(query_578925, "upload_protocol", newJString(uploadProtocol))
  result = call_578923.call(path_578924, query_578925, nil, nil, nil)

var jobsProjectsJobsDelete* = Call_JobsProjectsJobsDelete_578907(
    name: "jobsProjectsJobsDelete", meth: HttpMethod.HttpDelete,
    host: "jobs.googleapis.com", route: "/v3/{name}",
    validator: validate_JobsProjectsJobsDelete_578908, base: "/",
    url: url_JobsProjectsJobsDelete_578909, schemes: {Scheme.Https})
type
  Call_JobsProjectsComplete_578947 = ref object of OpenApiRestCall_578348
proc url_JobsProjectsComplete_578949(protocol: Scheme; host: string; base: string;
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

proc validate_JobsProjectsComplete_578948(path: JsonNode; query: JsonNode;
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
  var valid_578950 = path.getOrDefault("name")
  valid_578950 = validateParameter(valid_578950, JString, required = true,
                                 default = nil)
  if valid_578950 != nil:
    section.add "name", valid_578950
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
  ##   scope: JString
  ##        : Optional. The scope of the completion. The defaults is CompletionScope.PUBLIC.
  ##   pageSize: JInt
  ##           : Required. Completion result count.
  ## 
  ## The maximum allowed page size is 10.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   type: JString
  ##       : Optional. The completion topic. The default is CompletionType.COMBINED.
  ##   query: JString
  ##        : Required. The query used to generate suggestions.
  ## 
  ## The maximum number of allowed characters is 255.
  ##   callback: JString
  ##           : JSONP
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   companyName: JString
  ##              : Optional. If provided, restricts completion to specified company.
  ## 
  ## The format is "projects/{project_id}/companies/{company_id}", for example,
  ## "projects/api-test-project/companies/foo".
  section = newJObject()
  var valid_578951 = query.getOrDefault("key")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "key", valid_578951
  var valid_578952 = query.getOrDefault("prettyPrint")
  valid_578952 = validateParameter(valid_578952, JBool, required = false,
                                 default = newJBool(true))
  if valid_578952 != nil:
    section.add "prettyPrint", valid_578952
  var valid_578953 = query.getOrDefault("oauth_token")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "oauth_token", valid_578953
  var valid_578954 = query.getOrDefault("$.xgafv")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = newJString("1"))
  if valid_578954 != nil:
    section.add "$.xgafv", valid_578954
  var valid_578955 = query.getOrDefault("languageCodes")
  valid_578955 = validateParameter(valid_578955, JArray, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "languageCodes", valid_578955
  var valid_578956 = query.getOrDefault("scope")
  valid_578956 = validateParameter(valid_578956, JString, required = false, default = newJString(
      "COMPLETION_SCOPE_UNSPECIFIED"))
  if valid_578956 != nil:
    section.add "scope", valid_578956
  var valid_578957 = query.getOrDefault("pageSize")
  valid_578957 = validateParameter(valid_578957, JInt, required = false, default = nil)
  if valid_578957 != nil:
    section.add "pageSize", valid_578957
  var valid_578958 = query.getOrDefault("alt")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = newJString("json"))
  if valid_578958 != nil:
    section.add "alt", valid_578958
  var valid_578959 = query.getOrDefault("uploadType")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "uploadType", valid_578959
  var valid_578960 = query.getOrDefault("quotaUser")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "quotaUser", valid_578960
  var valid_578961 = query.getOrDefault("type")
  valid_578961 = validateParameter(valid_578961, JString, required = false, default = newJString(
      "COMPLETION_TYPE_UNSPECIFIED"))
  if valid_578961 != nil:
    section.add "type", valid_578961
  var valid_578962 = query.getOrDefault("query")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "query", valid_578962
  var valid_578963 = query.getOrDefault("callback")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "callback", valid_578963
  var valid_578964 = query.getOrDefault("languageCode")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "languageCode", valid_578964
  var valid_578965 = query.getOrDefault("fields")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "fields", valid_578965
  var valid_578966 = query.getOrDefault("access_token")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "access_token", valid_578966
  var valid_578967 = query.getOrDefault("upload_protocol")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "upload_protocol", valid_578967
  var valid_578968 = query.getOrDefault("companyName")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "companyName", valid_578968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578969: Call_JobsProjectsComplete_578947; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Completes the specified prefix with keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ## 
  let valid = call_578969.validator(path, query, header, formData, body)
  let scheme = call_578969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578969.url(scheme.get, call_578969.host, call_578969.base,
                         call_578969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578969, url, valid)

proc call*(call_578970: Call_JobsProjectsComplete_578947; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; languageCodes: JsonNode = nil;
          scope: string = "COMPLETION_SCOPE_UNSPECIFIED"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          `type`: string = "COMPLETION_TYPE_UNSPECIFIED"; query: string = "";
          callback: string = ""; languageCode: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          companyName: string = ""): Recallable =
  ## jobsProjectsComplete
  ## Completes the specified prefix with keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  ##   scope: string
  ##        : Optional. The scope of the completion. The defaults is CompletionScope.PUBLIC.
  ##   pageSize: int
  ##           : Required. Completion result count.
  ## 
  ## The maximum allowed page size is 10.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Resource name of project the completion is performed within.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   type: string
  ##       : Optional. The completion topic. The default is CompletionType.COMBINED.
  ##   query: string
  ##        : Required. The query used to generate suggestions.
  ## 
  ## The maximum number of allowed characters is 255.
  ##   callback: string
  ##           : JSONP
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   companyName: string
  ##              : Optional. If provided, restricts completion to specified company.
  ## 
  ## The format is "projects/{project_id}/companies/{company_id}", for example,
  ## "projects/api-test-project/companies/foo".
  var path_578971 = newJObject()
  var query_578972 = newJObject()
  add(query_578972, "key", newJString(key))
  add(query_578972, "prettyPrint", newJBool(prettyPrint))
  add(query_578972, "oauth_token", newJString(oauthToken))
  add(query_578972, "$.xgafv", newJString(Xgafv))
  if languageCodes != nil:
    query_578972.add "languageCodes", languageCodes
  add(query_578972, "scope", newJString(scope))
  add(query_578972, "pageSize", newJInt(pageSize))
  add(query_578972, "alt", newJString(alt))
  add(query_578972, "uploadType", newJString(uploadType))
  add(query_578972, "quotaUser", newJString(quotaUser))
  add(path_578971, "name", newJString(name))
  add(query_578972, "type", newJString(`type`))
  add(query_578972, "query", newJString(query))
  add(query_578972, "callback", newJString(callback))
  add(query_578972, "languageCode", newJString(languageCode))
  add(query_578972, "fields", newJString(fields))
  add(query_578972, "access_token", newJString(accessToken))
  add(query_578972, "upload_protocol", newJString(uploadProtocol))
  add(query_578972, "companyName", newJString(companyName))
  result = call_578970.call(path_578971, query_578972, nil, nil, nil)

var jobsProjectsComplete* = Call_JobsProjectsComplete_578947(
    name: "jobsProjectsComplete", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v3/{name}:complete",
    validator: validate_JobsProjectsComplete_578948, base: "/",
    url: url_JobsProjectsComplete_578949, schemes: {Scheme.Https})
type
  Call_JobsProjectsClientEventsCreate_578973 = ref object of OpenApiRestCall_578348
proc url_JobsProjectsClientEventsCreate_578975(protocol: Scheme; host: string;
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

proc validate_JobsProjectsClientEventsCreate_578974(path: JsonNode;
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
  var valid_578976 = path.getOrDefault("parent")
  valid_578976 = validateParameter(valid_578976, JString, required = true,
                                 default = nil)
  if valid_578976 != nil:
    section.add "parent", valid_578976
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
  var valid_578977 = query.getOrDefault("key")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "key", valid_578977
  var valid_578978 = query.getOrDefault("prettyPrint")
  valid_578978 = validateParameter(valid_578978, JBool, required = false,
                                 default = newJBool(true))
  if valid_578978 != nil:
    section.add "prettyPrint", valid_578978
  var valid_578979 = query.getOrDefault("oauth_token")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "oauth_token", valid_578979
  var valid_578980 = query.getOrDefault("$.xgafv")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = newJString("1"))
  if valid_578980 != nil:
    section.add "$.xgafv", valid_578980
  var valid_578981 = query.getOrDefault("alt")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = newJString("json"))
  if valid_578981 != nil:
    section.add "alt", valid_578981
  var valid_578982 = query.getOrDefault("uploadType")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "uploadType", valid_578982
  var valid_578983 = query.getOrDefault("quotaUser")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "quotaUser", valid_578983
  var valid_578984 = query.getOrDefault("callback")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "callback", valid_578984
  var valid_578985 = query.getOrDefault("fields")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "fields", valid_578985
  var valid_578986 = query.getOrDefault("access_token")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "access_token", valid_578986
  var valid_578987 = query.getOrDefault("upload_protocol")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "upload_protocol", valid_578987
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

proc call*(call_578989: Call_JobsProjectsClientEventsCreate_578973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Report events issued when end user interacts with customer's application
  ## that uses Cloud Talent Solution. You may inspect the created events in
  ## [self service
  ## tools](https://console.cloud.google.com/talent-solution/overview).
  ## [Learn
  ## more](https://cloud.google.com/talent-solution/docs/management-tools)
  ## about self service tools.
  ## 
  let valid = call_578989.validator(path, query, header, formData, body)
  let scheme = call_578989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578989.url(scheme.get, call_578989.host, call_578989.base,
                         call_578989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578989, url, valid)

proc call*(call_578990: Call_JobsProjectsClientEventsCreate_578973; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsProjectsClientEventsCreate
  ## Report events issued when end user interacts with customer's application
  ## that uses Cloud Talent Solution. You may inspect the created events in
  ## [self service
  ## tools](https://console.cloud.google.com/talent-solution/overview).
  ## [Learn
  ## more](https://cloud.google.com/talent-solution/docs/management-tools)
  ## about self service tools.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
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
  ##   parent: string (required)
  ##         : Parent project name.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578991 = newJObject()
  var query_578992 = newJObject()
  var body_578993 = newJObject()
  add(query_578992, "key", newJString(key))
  add(query_578992, "prettyPrint", newJBool(prettyPrint))
  add(query_578992, "oauth_token", newJString(oauthToken))
  add(query_578992, "$.xgafv", newJString(Xgafv))
  add(query_578992, "alt", newJString(alt))
  add(query_578992, "uploadType", newJString(uploadType))
  add(query_578992, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578993 = body
  add(query_578992, "callback", newJString(callback))
  add(path_578991, "parent", newJString(parent))
  add(query_578992, "fields", newJString(fields))
  add(query_578992, "access_token", newJString(accessToken))
  add(query_578992, "upload_protocol", newJString(uploadProtocol))
  result = call_578990.call(path_578991, query_578992, nil, nil, body_578993)

var jobsProjectsClientEventsCreate* = Call_JobsProjectsClientEventsCreate_578973(
    name: "jobsProjectsClientEventsCreate", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3/{parent}/clientEvents",
    validator: validate_JobsProjectsClientEventsCreate_578974, base: "/",
    url: url_JobsProjectsClientEventsCreate_578975, schemes: {Scheme.Https})
type
  Call_JobsProjectsCompaniesCreate_579016 = ref object of OpenApiRestCall_578348
proc url_JobsProjectsCompaniesCreate_579018(protocol: Scheme; host: string;
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

proc validate_JobsProjectsCompaniesCreate_579017(path: JsonNode; query: JsonNode;
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
  var valid_579019 = path.getOrDefault("parent")
  valid_579019 = validateParameter(valid_579019, JString, required = true,
                                 default = nil)
  if valid_579019 != nil:
    section.add "parent", valid_579019
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
  var valid_579020 = query.getOrDefault("key")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "key", valid_579020
  var valid_579021 = query.getOrDefault("prettyPrint")
  valid_579021 = validateParameter(valid_579021, JBool, required = false,
                                 default = newJBool(true))
  if valid_579021 != nil:
    section.add "prettyPrint", valid_579021
  var valid_579022 = query.getOrDefault("oauth_token")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "oauth_token", valid_579022
  var valid_579023 = query.getOrDefault("$.xgafv")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = newJString("1"))
  if valid_579023 != nil:
    section.add "$.xgafv", valid_579023
  var valid_579024 = query.getOrDefault("alt")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = newJString("json"))
  if valid_579024 != nil:
    section.add "alt", valid_579024
  var valid_579025 = query.getOrDefault("uploadType")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "uploadType", valid_579025
  var valid_579026 = query.getOrDefault("quotaUser")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "quotaUser", valid_579026
  var valid_579027 = query.getOrDefault("callback")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "callback", valid_579027
  var valid_579028 = query.getOrDefault("fields")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "fields", valid_579028
  var valid_579029 = query.getOrDefault("access_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "access_token", valid_579029
  var valid_579030 = query.getOrDefault("upload_protocol")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "upload_protocol", valid_579030
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

proc call*(call_579032: Call_JobsProjectsCompaniesCreate_579016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new company entity.
  ## 
  let valid = call_579032.validator(path, query, header, formData, body)
  let scheme = call_579032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579032.url(scheme.get, call_579032.host, call_579032.base,
                         call_579032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579032, url, valid)

proc call*(call_579033: Call_JobsProjectsCompaniesCreate_579016; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsProjectsCompaniesCreate
  ## Creates a new company entity.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
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
  ##   parent: string (required)
  ##         : Required. Resource name of the project under which the company is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579034 = newJObject()
  var query_579035 = newJObject()
  var body_579036 = newJObject()
  add(query_579035, "key", newJString(key))
  add(query_579035, "prettyPrint", newJBool(prettyPrint))
  add(query_579035, "oauth_token", newJString(oauthToken))
  add(query_579035, "$.xgafv", newJString(Xgafv))
  add(query_579035, "alt", newJString(alt))
  add(query_579035, "uploadType", newJString(uploadType))
  add(query_579035, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579036 = body
  add(query_579035, "callback", newJString(callback))
  add(path_579034, "parent", newJString(parent))
  add(query_579035, "fields", newJString(fields))
  add(query_579035, "access_token", newJString(accessToken))
  add(query_579035, "upload_protocol", newJString(uploadProtocol))
  result = call_579033.call(path_579034, query_579035, nil, nil, body_579036)

var jobsProjectsCompaniesCreate* = Call_JobsProjectsCompaniesCreate_579016(
    name: "jobsProjectsCompaniesCreate", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3/{parent}/companies",
    validator: validate_JobsProjectsCompaniesCreate_579017, base: "/",
    url: url_JobsProjectsCompaniesCreate_579018, schemes: {Scheme.Https})
type
  Call_JobsProjectsCompaniesList_578994 = ref object of OpenApiRestCall_578348
proc url_JobsProjectsCompaniesList_578996(protocol: Scheme; host: string;
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

proc validate_JobsProjectsCompaniesList_578995(path: JsonNode; query: JsonNode;
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
  var valid_578997 = path.getOrDefault("parent")
  valid_578997 = validateParameter(valid_578997, JString, required = true,
                                 default = nil)
  if valid_578997 != nil:
    section.add "parent", valid_578997
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
  ##           : Optional. The maximum number of companies to be returned, at most 100.
  ## Default is 100 if a non-positive number is provided.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. The starting indicator from which to return results.
  ##   requireOpenJobs: JBool
  ##                  : Optional. Set to true if the companies requested must have open jobs.
  ## 
  ## Defaults to false.
  ## 
  ## If true, at most page_size of companies are fetched, among which
  ## only those with open jobs are returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578998 = query.getOrDefault("key")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "key", valid_578998
  var valid_578999 = query.getOrDefault("prettyPrint")
  valid_578999 = validateParameter(valid_578999, JBool, required = false,
                                 default = newJBool(true))
  if valid_578999 != nil:
    section.add "prettyPrint", valid_578999
  var valid_579000 = query.getOrDefault("oauth_token")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "oauth_token", valid_579000
  var valid_579001 = query.getOrDefault("$.xgafv")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = newJString("1"))
  if valid_579001 != nil:
    section.add "$.xgafv", valid_579001
  var valid_579002 = query.getOrDefault("pageSize")
  valid_579002 = validateParameter(valid_579002, JInt, required = false, default = nil)
  if valid_579002 != nil:
    section.add "pageSize", valid_579002
  var valid_579003 = query.getOrDefault("alt")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = newJString("json"))
  if valid_579003 != nil:
    section.add "alt", valid_579003
  var valid_579004 = query.getOrDefault("uploadType")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "uploadType", valid_579004
  var valid_579005 = query.getOrDefault("quotaUser")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "quotaUser", valid_579005
  var valid_579006 = query.getOrDefault("pageToken")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "pageToken", valid_579006
  var valid_579007 = query.getOrDefault("requireOpenJobs")
  valid_579007 = validateParameter(valid_579007, JBool, required = false, default = nil)
  if valid_579007 != nil:
    section.add "requireOpenJobs", valid_579007
  var valid_579008 = query.getOrDefault("callback")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "callback", valid_579008
  var valid_579009 = query.getOrDefault("fields")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "fields", valid_579009
  var valid_579010 = query.getOrDefault("access_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "access_token", valid_579010
  var valid_579011 = query.getOrDefault("upload_protocol")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "upload_protocol", valid_579011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579012: Call_JobsProjectsCompaniesList_578994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all companies associated with the service account.
  ## 
  let valid = call_579012.validator(path, query, header, formData, body)
  let scheme = call_579012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579012.url(scheme.get, call_579012.host, call_579012.base,
                         call_579012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579012, url, valid)

proc call*(call_579013: Call_JobsProjectsCompaniesList_578994; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          requireOpenJobs: bool = false; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsProjectsCompaniesList
  ## Lists all companies associated with the service account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of companies to be returned, at most 100.
  ## Default is 100 if a non-positive number is provided.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. The starting indicator from which to return results.
  ##   requireOpenJobs: bool
  ##                  : Optional. Set to true if the companies requested must have open jobs.
  ## 
  ## Defaults to false.
  ## 
  ## If true, at most page_size of companies are fetched, among which
  ## only those with open jobs are returned.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. Resource name of the project under which the company is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579014 = newJObject()
  var query_579015 = newJObject()
  add(query_579015, "key", newJString(key))
  add(query_579015, "prettyPrint", newJBool(prettyPrint))
  add(query_579015, "oauth_token", newJString(oauthToken))
  add(query_579015, "$.xgafv", newJString(Xgafv))
  add(query_579015, "pageSize", newJInt(pageSize))
  add(query_579015, "alt", newJString(alt))
  add(query_579015, "uploadType", newJString(uploadType))
  add(query_579015, "quotaUser", newJString(quotaUser))
  add(query_579015, "pageToken", newJString(pageToken))
  add(query_579015, "requireOpenJobs", newJBool(requireOpenJobs))
  add(query_579015, "callback", newJString(callback))
  add(path_579014, "parent", newJString(parent))
  add(query_579015, "fields", newJString(fields))
  add(query_579015, "access_token", newJString(accessToken))
  add(query_579015, "upload_protocol", newJString(uploadProtocol))
  result = call_579013.call(path_579014, query_579015, nil, nil, nil)

var jobsProjectsCompaniesList* = Call_JobsProjectsCompaniesList_578994(
    name: "jobsProjectsCompaniesList", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v3/{parent}/companies",
    validator: validate_JobsProjectsCompaniesList_578995, base: "/",
    url: url_JobsProjectsCompaniesList_578996, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsCreate_579060 = ref object of OpenApiRestCall_578348
proc url_JobsProjectsJobsCreate_579062(protocol: Scheme; host: string; base: string;
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

proc validate_JobsProjectsJobsCreate_579061(path: JsonNode; query: JsonNode;
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
  var valid_579063 = path.getOrDefault("parent")
  valid_579063 = validateParameter(valid_579063, JString, required = true,
                                 default = nil)
  if valid_579063 != nil:
    section.add "parent", valid_579063
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
  var valid_579064 = query.getOrDefault("key")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "key", valid_579064
  var valid_579065 = query.getOrDefault("prettyPrint")
  valid_579065 = validateParameter(valid_579065, JBool, required = false,
                                 default = newJBool(true))
  if valid_579065 != nil:
    section.add "prettyPrint", valid_579065
  var valid_579066 = query.getOrDefault("oauth_token")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "oauth_token", valid_579066
  var valid_579067 = query.getOrDefault("$.xgafv")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = newJString("1"))
  if valid_579067 != nil:
    section.add "$.xgafv", valid_579067
  var valid_579068 = query.getOrDefault("alt")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = newJString("json"))
  if valid_579068 != nil:
    section.add "alt", valid_579068
  var valid_579069 = query.getOrDefault("uploadType")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "uploadType", valid_579069
  var valid_579070 = query.getOrDefault("quotaUser")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "quotaUser", valid_579070
  var valid_579071 = query.getOrDefault("callback")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "callback", valid_579071
  var valid_579072 = query.getOrDefault("fields")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "fields", valid_579072
  var valid_579073 = query.getOrDefault("access_token")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "access_token", valid_579073
  var valid_579074 = query.getOrDefault("upload_protocol")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "upload_protocol", valid_579074
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

proc call*(call_579076: Call_JobsProjectsJobsCreate_579060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job.
  ## 
  ## Typically, the job becomes searchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ## 
  let valid = call_579076.validator(path, query, header, formData, body)
  let scheme = call_579076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579076.url(scheme.get, call_579076.host, call_579076.base,
                         call_579076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579076, url, valid)

proc call*(call_579077: Call_JobsProjectsJobsCreate_579060; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsProjectsJobsCreate
  ## Creates a new job.
  ## 
  ## Typically, the job becomes searchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
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
  ##   parent: string (required)
  ##         : Required. The resource name of the project under which the job is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579078 = newJObject()
  var query_579079 = newJObject()
  var body_579080 = newJObject()
  add(query_579079, "key", newJString(key))
  add(query_579079, "prettyPrint", newJBool(prettyPrint))
  add(query_579079, "oauth_token", newJString(oauthToken))
  add(query_579079, "$.xgafv", newJString(Xgafv))
  add(query_579079, "alt", newJString(alt))
  add(query_579079, "uploadType", newJString(uploadType))
  add(query_579079, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579080 = body
  add(query_579079, "callback", newJString(callback))
  add(path_579078, "parent", newJString(parent))
  add(query_579079, "fields", newJString(fields))
  add(query_579079, "access_token", newJString(accessToken))
  add(query_579079, "upload_protocol", newJString(uploadProtocol))
  result = call_579077.call(path_579078, query_579079, nil, nil, body_579080)

var jobsProjectsJobsCreate* = Call_JobsProjectsJobsCreate_579060(
    name: "jobsProjectsJobsCreate", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3/{parent}/jobs",
    validator: validate_JobsProjectsJobsCreate_579061, base: "/",
    url: url_JobsProjectsJobsCreate_579062, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsList_579037 = ref object of OpenApiRestCall_578348
proc url_JobsProjectsJobsList_579039(protocol: Scheme; host: string; base: string;
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

proc validate_JobsProjectsJobsList_579038(path: JsonNode; query: JsonNode;
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
  var valid_579040 = path.getOrDefault("parent")
  valid_579040 = validateParameter(valid_579040, JString, required = true,
                                 default = nil)
  if valid_579040 != nil:
    section.add "parent", valid_579040
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
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If job_view is set to JobView.JOB_VIEW_ID_ONLY, the maximum allowed
  ## page size is 1000. Otherwise, the maximum allowed page size is 100.
  ## 
  ## Default is 100 if empty or a number < 1 is specified.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   pageToken: JString
  ##            : Optional. The starting point of a query result.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   jobView: JString
  ##          : Optional. The desired job attributes returned for jobs in the
  ## search response. Defaults to JobView.JOB_VIEW_FULL if no value is
  ## specified.
  section = newJObject()
  var valid_579041 = query.getOrDefault("key")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "key", valid_579041
  var valid_579042 = query.getOrDefault("prettyPrint")
  valid_579042 = validateParameter(valid_579042, JBool, required = false,
                                 default = newJBool(true))
  if valid_579042 != nil:
    section.add "prettyPrint", valid_579042
  var valid_579043 = query.getOrDefault("oauth_token")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "oauth_token", valid_579043
  var valid_579044 = query.getOrDefault("$.xgafv")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = newJString("1"))
  if valid_579044 != nil:
    section.add "$.xgafv", valid_579044
  var valid_579045 = query.getOrDefault("pageSize")
  valid_579045 = validateParameter(valid_579045, JInt, required = false, default = nil)
  if valid_579045 != nil:
    section.add "pageSize", valid_579045
  var valid_579046 = query.getOrDefault("alt")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = newJString("json"))
  if valid_579046 != nil:
    section.add "alt", valid_579046
  var valid_579047 = query.getOrDefault("uploadType")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "uploadType", valid_579047
  var valid_579048 = query.getOrDefault("quotaUser")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "quotaUser", valid_579048
  var valid_579049 = query.getOrDefault("filter")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "filter", valid_579049
  var valid_579050 = query.getOrDefault("pageToken")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "pageToken", valid_579050
  var valid_579051 = query.getOrDefault("callback")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "callback", valid_579051
  var valid_579052 = query.getOrDefault("fields")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "fields", valid_579052
  var valid_579053 = query.getOrDefault("access_token")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "access_token", valid_579053
  var valid_579054 = query.getOrDefault("upload_protocol")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "upload_protocol", valid_579054
  var valid_579055 = query.getOrDefault("jobView")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = newJString("JOB_VIEW_UNSPECIFIED"))
  if valid_579055 != nil:
    section.add "jobView", valid_579055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579056: Call_JobsProjectsJobsList_579037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs by filter.
  ## 
  let valid = call_579056.validator(path, query, header, formData, body)
  let scheme = call_579056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579056.url(scheme.get, call_579056.host, call_579056.base,
                         call_579056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579056, url, valid)

proc call*(call_579057: Call_JobsProjectsJobsList_579037; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          jobView: string = "JOB_VIEW_UNSPECIFIED"): Recallable =
  ## jobsProjectsJobsList
  ## Lists jobs by filter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If job_view is set to JobView.JOB_VIEW_ID_ONLY, the maximum allowed
  ## page size is 1000. Otherwise, the maximum allowed page size is 100.
  ## 
  ## Default is 100 if empty or a number < 1 is specified.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   pageToken: string
  ##            : Optional. The starting point of a query result.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The resource name of the project under which the job is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   jobView: string
  ##          : Optional. The desired job attributes returned for jobs in the
  ## search response. Defaults to JobView.JOB_VIEW_FULL if no value is
  ## specified.
  var path_579058 = newJObject()
  var query_579059 = newJObject()
  add(query_579059, "key", newJString(key))
  add(query_579059, "prettyPrint", newJBool(prettyPrint))
  add(query_579059, "oauth_token", newJString(oauthToken))
  add(query_579059, "$.xgafv", newJString(Xgafv))
  add(query_579059, "pageSize", newJInt(pageSize))
  add(query_579059, "alt", newJString(alt))
  add(query_579059, "uploadType", newJString(uploadType))
  add(query_579059, "quotaUser", newJString(quotaUser))
  add(query_579059, "filter", newJString(filter))
  add(query_579059, "pageToken", newJString(pageToken))
  add(query_579059, "callback", newJString(callback))
  add(path_579058, "parent", newJString(parent))
  add(query_579059, "fields", newJString(fields))
  add(query_579059, "access_token", newJString(accessToken))
  add(query_579059, "upload_protocol", newJString(uploadProtocol))
  add(query_579059, "jobView", newJString(jobView))
  result = call_579057.call(path_579058, query_579059, nil, nil, nil)

var jobsProjectsJobsList* = Call_JobsProjectsJobsList_579037(
    name: "jobsProjectsJobsList", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v3/{parent}/jobs",
    validator: validate_JobsProjectsJobsList_579038, base: "/",
    url: url_JobsProjectsJobsList_579039, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsBatchDelete_579081 = ref object of OpenApiRestCall_578348
proc url_JobsProjectsJobsBatchDelete_579083(protocol: Scheme; host: string;
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

proc validate_JobsProjectsJobsBatchDelete_579082(path: JsonNode; query: JsonNode;
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
  var valid_579084 = path.getOrDefault("parent")
  valid_579084 = validateParameter(valid_579084, JString, required = true,
                                 default = nil)
  if valid_579084 != nil:
    section.add "parent", valid_579084
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
  var valid_579085 = query.getOrDefault("key")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "key", valid_579085
  var valid_579086 = query.getOrDefault("prettyPrint")
  valid_579086 = validateParameter(valid_579086, JBool, required = false,
                                 default = newJBool(true))
  if valid_579086 != nil:
    section.add "prettyPrint", valid_579086
  var valid_579087 = query.getOrDefault("oauth_token")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "oauth_token", valid_579087
  var valid_579088 = query.getOrDefault("$.xgafv")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = newJString("1"))
  if valid_579088 != nil:
    section.add "$.xgafv", valid_579088
  var valid_579089 = query.getOrDefault("alt")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = newJString("json"))
  if valid_579089 != nil:
    section.add "alt", valid_579089
  var valid_579090 = query.getOrDefault("uploadType")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "uploadType", valid_579090
  var valid_579091 = query.getOrDefault("quotaUser")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "quotaUser", valid_579091
  var valid_579092 = query.getOrDefault("callback")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "callback", valid_579092
  var valid_579093 = query.getOrDefault("fields")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "fields", valid_579093
  var valid_579094 = query.getOrDefault("access_token")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "access_token", valid_579094
  var valid_579095 = query.getOrDefault("upload_protocol")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "upload_protocol", valid_579095
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

proc call*(call_579097: Call_JobsProjectsJobsBatchDelete_579081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a list of Jobs by filter.
  ## 
  let valid = call_579097.validator(path, query, header, formData, body)
  let scheme = call_579097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579097.url(scheme.get, call_579097.host, call_579097.base,
                         call_579097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579097, url, valid)

proc call*(call_579098: Call_JobsProjectsJobsBatchDelete_579081; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsProjectsJobsBatchDelete
  ## Deletes a list of Jobs by filter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
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
  ##   parent: string (required)
  ##         : Required. The resource name of the project under which the job is created.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579099 = newJObject()
  var query_579100 = newJObject()
  var body_579101 = newJObject()
  add(query_579100, "key", newJString(key))
  add(query_579100, "prettyPrint", newJBool(prettyPrint))
  add(query_579100, "oauth_token", newJString(oauthToken))
  add(query_579100, "$.xgafv", newJString(Xgafv))
  add(query_579100, "alt", newJString(alt))
  add(query_579100, "uploadType", newJString(uploadType))
  add(query_579100, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579101 = body
  add(query_579100, "callback", newJString(callback))
  add(path_579099, "parent", newJString(parent))
  add(query_579100, "fields", newJString(fields))
  add(query_579100, "access_token", newJString(accessToken))
  add(query_579100, "upload_protocol", newJString(uploadProtocol))
  result = call_579098.call(path_579099, query_579100, nil, nil, body_579101)

var jobsProjectsJobsBatchDelete* = Call_JobsProjectsJobsBatchDelete_579081(
    name: "jobsProjectsJobsBatchDelete", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3/{parent}/jobs:batchDelete",
    validator: validate_JobsProjectsJobsBatchDelete_579082, base: "/",
    url: url_JobsProjectsJobsBatchDelete_579083, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsSearch_579102 = ref object of OpenApiRestCall_578348
proc url_JobsProjectsJobsSearch_579104(protocol: Scheme; host: string; base: string;
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

proc validate_JobsProjectsJobsSearch_579103(path: JsonNode; query: JsonNode;
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
  var valid_579105 = path.getOrDefault("parent")
  valid_579105 = validateParameter(valid_579105, JString, required = true,
                                 default = nil)
  if valid_579105 != nil:
    section.add "parent", valid_579105
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
  var valid_579106 = query.getOrDefault("key")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "key", valid_579106
  var valid_579107 = query.getOrDefault("prettyPrint")
  valid_579107 = validateParameter(valid_579107, JBool, required = false,
                                 default = newJBool(true))
  if valid_579107 != nil:
    section.add "prettyPrint", valid_579107
  var valid_579108 = query.getOrDefault("oauth_token")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "oauth_token", valid_579108
  var valid_579109 = query.getOrDefault("$.xgafv")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = newJString("1"))
  if valid_579109 != nil:
    section.add "$.xgafv", valid_579109
  var valid_579110 = query.getOrDefault("alt")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = newJString("json"))
  if valid_579110 != nil:
    section.add "alt", valid_579110
  var valid_579111 = query.getOrDefault("uploadType")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "uploadType", valid_579111
  var valid_579112 = query.getOrDefault("quotaUser")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "quotaUser", valid_579112
  var valid_579113 = query.getOrDefault("callback")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "callback", valid_579113
  var valid_579114 = query.getOrDefault("fields")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "fields", valid_579114
  var valid_579115 = query.getOrDefault("access_token")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "access_token", valid_579115
  var valid_579116 = query.getOrDefault("upload_protocol")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "upload_protocol", valid_579116
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

proc call*(call_579118: Call_JobsProjectsJobsSearch_579102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs that the caller has
  ## permission to search against.
  ## 
  let valid = call_579118.validator(path, query, header, formData, body)
  let scheme = call_579118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579118.url(scheme.get, call_579118.host, call_579118.base,
                         call_579118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579118, url, valid)

proc call*(call_579119: Call_JobsProjectsJobsSearch_579102; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsProjectsJobsSearch
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs that the caller has
  ## permission to search against.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
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
  ##   parent: string (required)
  ##         : Required. The resource name of the project to search within.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579120 = newJObject()
  var query_579121 = newJObject()
  var body_579122 = newJObject()
  add(query_579121, "key", newJString(key))
  add(query_579121, "prettyPrint", newJBool(prettyPrint))
  add(query_579121, "oauth_token", newJString(oauthToken))
  add(query_579121, "$.xgafv", newJString(Xgafv))
  add(query_579121, "alt", newJString(alt))
  add(query_579121, "uploadType", newJString(uploadType))
  add(query_579121, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579122 = body
  add(query_579121, "callback", newJString(callback))
  add(path_579120, "parent", newJString(parent))
  add(query_579121, "fields", newJString(fields))
  add(query_579121, "access_token", newJString(accessToken))
  add(query_579121, "upload_protocol", newJString(uploadProtocol))
  result = call_579119.call(path_579120, query_579121, nil, nil, body_579122)

var jobsProjectsJobsSearch* = Call_JobsProjectsJobsSearch_579102(
    name: "jobsProjectsJobsSearch", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3/{parent}/jobs:search",
    validator: validate_JobsProjectsJobsSearch_579103, base: "/",
    url: url_JobsProjectsJobsSearch_579104, schemes: {Scheme.Https})
type
  Call_JobsProjectsJobsSearchForAlert_579123 = ref object of OpenApiRestCall_578348
proc url_JobsProjectsJobsSearchForAlert_579125(protocol: Scheme; host: string;
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

proc validate_JobsProjectsJobsSearchForAlert_579124(path: JsonNode;
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
  var valid_579126 = path.getOrDefault("parent")
  valid_579126 = validateParameter(valid_579126, JString, required = true,
                                 default = nil)
  if valid_579126 != nil:
    section.add "parent", valid_579126
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
  var valid_579127 = query.getOrDefault("key")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "key", valid_579127
  var valid_579128 = query.getOrDefault("prettyPrint")
  valid_579128 = validateParameter(valid_579128, JBool, required = false,
                                 default = newJBool(true))
  if valid_579128 != nil:
    section.add "prettyPrint", valid_579128
  var valid_579129 = query.getOrDefault("oauth_token")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "oauth_token", valid_579129
  var valid_579130 = query.getOrDefault("$.xgafv")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = newJString("1"))
  if valid_579130 != nil:
    section.add "$.xgafv", valid_579130
  var valid_579131 = query.getOrDefault("alt")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = newJString("json"))
  if valid_579131 != nil:
    section.add "alt", valid_579131
  var valid_579132 = query.getOrDefault("uploadType")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "uploadType", valid_579132
  var valid_579133 = query.getOrDefault("quotaUser")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "quotaUser", valid_579133
  var valid_579134 = query.getOrDefault("callback")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "callback", valid_579134
  var valid_579135 = query.getOrDefault("fields")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "fields", valid_579135
  var valid_579136 = query.getOrDefault("access_token")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "access_token", valid_579136
  var valid_579137 = query.getOrDefault("upload_protocol")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "upload_protocol", valid_579137
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

proc call*(call_579139: Call_JobsProjectsJobsSearchForAlert_579123; path: JsonNode;
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
  let valid = call_579139.validator(path, query, header, formData, body)
  let scheme = call_579139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579139.url(scheme.get, call_579139.host, call_579139.base,
                         call_579139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579139, url, valid)

proc call*(call_579140: Call_JobsProjectsJobsSearchForAlert_579123; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
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
  ##   parent: string (required)
  ##         : Required. The resource name of the project to search within.
  ## 
  ## The format is "projects/{project_id}", for example,
  ## "projects/api-test-project".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579141 = newJObject()
  var query_579142 = newJObject()
  var body_579143 = newJObject()
  add(query_579142, "key", newJString(key))
  add(query_579142, "prettyPrint", newJBool(prettyPrint))
  add(query_579142, "oauth_token", newJString(oauthToken))
  add(query_579142, "$.xgafv", newJString(Xgafv))
  add(query_579142, "alt", newJString(alt))
  add(query_579142, "uploadType", newJString(uploadType))
  add(query_579142, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579143 = body
  add(query_579142, "callback", newJString(callback))
  add(path_579141, "parent", newJString(parent))
  add(query_579142, "fields", newJString(fields))
  add(query_579142, "access_token", newJString(accessToken))
  add(query_579142, "upload_protocol", newJString(uploadProtocol))
  result = call_579140.call(path_579141, query_579142, nil, nil, body_579143)

var jobsProjectsJobsSearchForAlert* = Call_JobsProjectsJobsSearchForAlert_579123(
    name: "jobsProjectsJobsSearchForAlert", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v3/{parent}/jobs:searchForAlert",
    validator: validate_JobsProjectsJobsSearchForAlert_579124, base: "/",
    url: url_JobsProjectsJobsSearchForAlert_579125, schemes: {Scheme.Https})
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
