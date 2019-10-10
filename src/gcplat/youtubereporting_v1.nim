
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: YouTube Reporting
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Schedules reporting jobs containing your YouTube Analytics data and downloads the resulting bulk data reports in the form of CSV files.
## 
## https://developers.google.com/youtube/reporting/v1/reports/
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "youtubereporting"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_YoutubereportingJobsCreate_588986 = ref object of OpenApiRestCall_588441
proc url_YoutubereportingJobsCreate_588988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubereportingJobsCreate_588987(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a job and returns it.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
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
  var valid_588989 = query.getOrDefault("onBehalfOfContentOwner")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "onBehalfOfContentOwner", valid_588989
  var valid_588990 = query.getOrDefault("upload_protocol")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = nil)
  if valid_588990 != nil:
    section.add "upload_protocol", valid_588990
  var valid_588991 = query.getOrDefault("fields")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = nil)
  if valid_588991 != nil:
    section.add "fields", valid_588991
  var valid_588992 = query.getOrDefault("quotaUser")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = nil)
  if valid_588992 != nil:
    section.add "quotaUser", valid_588992
  var valid_588993 = query.getOrDefault("alt")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = newJString("json"))
  if valid_588993 != nil:
    section.add "alt", valid_588993
  var valid_588994 = query.getOrDefault("oauth_token")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "oauth_token", valid_588994
  var valid_588995 = query.getOrDefault("callback")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "callback", valid_588995
  var valid_588996 = query.getOrDefault("access_token")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "access_token", valid_588996
  var valid_588997 = query.getOrDefault("uploadType")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "uploadType", valid_588997
  var valid_588998 = query.getOrDefault("key")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "key", valid_588998
  var valid_588999 = query.getOrDefault("$.xgafv")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = newJString("1"))
  if valid_588999 != nil:
    section.add "$.xgafv", valid_588999
  var valid_589000 = query.getOrDefault("prettyPrint")
  valid_589000 = validateParameter(valid_589000, JBool, required = false,
                                 default = newJBool(true))
  if valid_589000 != nil:
    section.add "prettyPrint", valid_589000
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

proc call*(call_589002: Call_YoutubereportingJobsCreate_588986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job and returns it.
  ## 
  let valid = call_589002.validator(path, query, header, formData, body)
  let scheme = call_589002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589002.url(scheme.get, call_589002.host, call_589002.base,
                         call_589002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589002, url, valid)

proc call*(call_589003: Call_YoutubereportingJobsCreate_588986;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubereportingJobsCreate
  ## Creates a job and returns it.
  ##   onBehalfOfContentOwner: string
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589004 = newJObject()
  var body_589005 = newJObject()
  add(query_589004, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589004, "upload_protocol", newJString(uploadProtocol))
  add(query_589004, "fields", newJString(fields))
  add(query_589004, "quotaUser", newJString(quotaUser))
  add(query_589004, "alt", newJString(alt))
  add(query_589004, "oauth_token", newJString(oauthToken))
  add(query_589004, "callback", newJString(callback))
  add(query_589004, "access_token", newJString(accessToken))
  add(query_589004, "uploadType", newJString(uploadType))
  add(query_589004, "key", newJString(key))
  add(query_589004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589005 = body
  add(query_589004, "prettyPrint", newJBool(prettyPrint))
  result = call_589003.call(nil, query_589004, nil, nil, body_589005)

var youtubereportingJobsCreate* = Call_YoutubereportingJobsCreate_588986(
    name: "youtubereportingJobsCreate", meth: HttpMethod.HttpPost,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs",
    validator: validate_YoutubereportingJobsCreate_588987, base: "/",
    url: url_YoutubereportingJobsCreate_588988, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsList_588710 = ref object of OpenApiRestCall_588441
proc url_YoutubereportingJobsList_588712(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubereportingJobsList_588711(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists jobs.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of
  ## ListReportTypesResponse.next_page_token
  ## returned in response to the previous call to the `ListJobs` method.
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
  ##           : Requested page size. Server may return fewer jobs than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   includeSystemManaged: JBool
  ##                       : If set to true, also system-managed jobs will be returned; otherwise only
  ## user-created jobs will be returned. System-managed jobs can neither be
  ## modified nor deleted.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588824 = query.getOrDefault("onBehalfOfContentOwner")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "onBehalfOfContentOwner", valid_588824
  var valid_588825 = query.getOrDefault("upload_protocol")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "upload_protocol", valid_588825
  var valid_588826 = query.getOrDefault("fields")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "fields", valid_588826
  var valid_588827 = query.getOrDefault("pageToken")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "pageToken", valid_588827
  var valid_588828 = query.getOrDefault("quotaUser")
  valid_588828 = validateParameter(valid_588828, JString, required = false,
                                 default = nil)
  if valid_588828 != nil:
    section.add "quotaUser", valid_588828
  var valid_588842 = query.getOrDefault("alt")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = newJString("json"))
  if valid_588842 != nil:
    section.add "alt", valid_588842
  var valid_588843 = query.getOrDefault("oauth_token")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "oauth_token", valid_588843
  var valid_588844 = query.getOrDefault("callback")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "callback", valid_588844
  var valid_588845 = query.getOrDefault("access_token")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "access_token", valid_588845
  var valid_588846 = query.getOrDefault("uploadType")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "uploadType", valid_588846
  var valid_588847 = query.getOrDefault("key")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "key", valid_588847
  var valid_588848 = query.getOrDefault("$.xgafv")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = newJString("1"))
  if valid_588848 != nil:
    section.add "$.xgafv", valid_588848
  var valid_588849 = query.getOrDefault("pageSize")
  valid_588849 = validateParameter(valid_588849, JInt, required = false, default = nil)
  if valid_588849 != nil:
    section.add "pageSize", valid_588849
  var valid_588850 = query.getOrDefault("includeSystemManaged")
  valid_588850 = validateParameter(valid_588850, JBool, required = false, default = nil)
  if valid_588850 != nil:
    section.add "includeSystemManaged", valid_588850
  var valid_588851 = query.getOrDefault("prettyPrint")
  valid_588851 = validateParameter(valid_588851, JBool, required = false,
                                 default = newJBool(true))
  if valid_588851 != nil:
    section.add "prettyPrint", valid_588851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588874: Call_YoutubereportingJobsList_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs.
  ## 
  let valid = call_588874.validator(path, query, header, formData, body)
  let scheme = call_588874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588874.url(scheme.get, call_588874.host, call_588874.base,
                         call_588874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588874, url, valid)

proc call*(call_588945: Call_YoutubereportingJobsList_588710;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; includeSystemManaged: bool = false;
          prettyPrint: bool = true): Recallable =
  ## youtubereportingJobsList
  ## Lists jobs.
  ##   onBehalfOfContentOwner: string
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of
  ## ListReportTypesResponse.next_page_token
  ## returned in response to the previous call to the `ListJobs` method.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer jobs than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   includeSystemManaged: bool
  ##                       : If set to true, also system-managed jobs will be returned; otherwise only
  ## user-created jobs will be returned. System-managed jobs can neither be
  ## modified nor deleted.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588946 = newJObject()
  add(query_588946, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_588946, "upload_protocol", newJString(uploadProtocol))
  add(query_588946, "fields", newJString(fields))
  add(query_588946, "pageToken", newJString(pageToken))
  add(query_588946, "quotaUser", newJString(quotaUser))
  add(query_588946, "alt", newJString(alt))
  add(query_588946, "oauth_token", newJString(oauthToken))
  add(query_588946, "callback", newJString(callback))
  add(query_588946, "access_token", newJString(accessToken))
  add(query_588946, "uploadType", newJString(uploadType))
  add(query_588946, "key", newJString(key))
  add(query_588946, "$.xgafv", newJString(Xgafv))
  add(query_588946, "pageSize", newJInt(pageSize))
  add(query_588946, "includeSystemManaged", newJBool(includeSystemManaged))
  add(query_588946, "prettyPrint", newJBool(prettyPrint))
  result = call_588945.call(nil, query_588946, nil, nil, nil)

var youtubereportingJobsList* = Call_YoutubereportingJobsList_588710(
    name: "youtubereportingJobsList", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs",
    validator: validate_YoutubereportingJobsList_588711, base: "/",
    url: url_YoutubereportingJobsList_588712, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsGet_589006 = ref object of OpenApiRestCall_588441
proc url_YoutubereportingJobsGet_589008(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_YoutubereportingJobsGet_589007(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589023 = path.getOrDefault("jobId")
  valid_589023 = validateParameter(valid_589023, JString, required = true,
                                 default = nil)
  if valid_589023 != nil:
    section.add "jobId", valid_589023
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
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
  var valid_589024 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "onBehalfOfContentOwner", valid_589024
  var valid_589025 = query.getOrDefault("upload_protocol")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "upload_protocol", valid_589025
  var valid_589026 = query.getOrDefault("fields")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "fields", valid_589026
  var valid_589027 = query.getOrDefault("quotaUser")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "quotaUser", valid_589027
  var valid_589028 = query.getOrDefault("alt")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = newJString("json"))
  if valid_589028 != nil:
    section.add "alt", valid_589028
  var valid_589029 = query.getOrDefault("oauth_token")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "oauth_token", valid_589029
  var valid_589030 = query.getOrDefault("callback")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "callback", valid_589030
  var valid_589031 = query.getOrDefault("access_token")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "access_token", valid_589031
  var valid_589032 = query.getOrDefault("uploadType")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "uploadType", valid_589032
  var valid_589033 = query.getOrDefault("key")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "key", valid_589033
  var valid_589034 = query.getOrDefault("$.xgafv")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = newJString("1"))
  if valid_589034 != nil:
    section.add "$.xgafv", valid_589034
  var valid_589035 = query.getOrDefault("prettyPrint")
  valid_589035 = validateParameter(valid_589035, JBool, required = false,
                                 default = newJBool(true))
  if valid_589035 != nil:
    section.add "prettyPrint", valid_589035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589036: Call_YoutubereportingJobsGet_589006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job.
  ## 
  let valid = call_589036.validator(path, query, header, formData, body)
  let scheme = call_589036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589036.url(scheme.get, call_589036.host, call_589036.base,
                         call_589036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589036, url, valid)

proc call*(call_589037: Call_YoutubereportingJobsGet_589006; jobId: string;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## youtubereportingJobsGet
  ## Gets a job.
  ##   onBehalfOfContentOwner: string
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The ID of the job to retrieve.
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
  var path_589038 = newJObject()
  var query_589039 = newJObject()
  add(query_589039, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589039, "upload_protocol", newJString(uploadProtocol))
  add(query_589039, "fields", newJString(fields))
  add(query_589039, "quotaUser", newJString(quotaUser))
  add(query_589039, "alt", newJString(alt))
  add(path_589038, "jobId", newJString(jobId))
  add(query_589039, "oauth_token", newJString(oauthToken))
  add(query_589039, "callback", newJString(callback))
  add(query_589039, "access_token", newJString(accessToken))
  add(query_589039, "uploadType", newJString(uploadType))
  add(query_589039, "key", newJString(key))
  add(query_589039, "$.xgafv", newJString(Xgafv))
  add(query_589039, "prettyPrint", newJBool(prettyPrint))
  result = call_589037.call(path_589038, query_589039, nil, nil, nil)

var youtubereportingJobsGet* = Call_YoutubereportingJobsGet_589006(
    name: "youtubereportingJobsGet", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs/{jobId}",
    validator: validate_YoutubereportingJobsGet_589007, base: "/",
    url: url_YoutubereportingJobsGet_589008, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsDelete_589040 = ref object of OpenApiRestCall_588441
proc url_YoutubereportingJobsDelete_589042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_YoutubereportingJobsDelete_589041(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589043 = path.getOrDefault("jobId")
  valid_589043 = validateParameter(valid_589043, JString, required = true,
                                 default = nil)
  if valid_589043 != nil:
    section.add "jobId", valid_589043
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
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
  var valid_589044 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "onBehalfOfContentOwner", valid_589044
  var valid_589045 = query.getOrDefault("upload_protocol")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "upload_protocol", valid_589045
  var valid_589046 = query.getOrDefault("fields")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "fields", valid_589046
  var valid_589047 = query.getOrDefault("quotaUser")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "quotaUser", valid_589047
  var valid_589048 = query.getOrDefault("alt")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = newJString("json"))
  if valid_589048 != nil:
    section.add "alt", valid_589048
  var valid_589049 = query.getOrDefault("oauth_token")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "oauth_token", valid_589049
  var valid_589050 = query.getOrDefault("callback")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "callback", valid_589050
  var valid_589051 = query.getOrDefault("access_token")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "access_token", valid_589051
  var valid_589052 = query.getOrDefault("uploadType")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "uploadType", valid_589052
  var valid_589053 = query.getOrDefault("key")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "key", valid_589053
  var valid_589054 = query.getOrDefault("$.xgafv")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("1"))
  if valid_589054 != nil:
    section.add "$.xgafv", valid_589054
  var valid_589055 = query.getOrDefault("prettyPrint")
  valid_589055 = validateParameter(valid_589055, JBool, required = false,
                                 default = newJBool(true))
  if valid_589055 != nil:
    section.add "prettyPrint", valid_589055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589056: Call_YoutubereportingJobsDelete_589040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job.
  ## 
  let valid = call_589056.validator(path, query, header, formData, body)
  let scheme = call_589056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589056.url(scheme.get, call_589056.host, call_589056.base,
                         call_589056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589056, url, valid)

proc call*(call_589057: Call_YoutubereportingJobsDelete_589040; jobId: string;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## youtubereportingJobsDelete
  ## Deletes a job.
  ##   onBehalfOfContentOwner: string
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The ID of the job to delete.
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
  var path_589058 = newJObject()
  var query_589059 = newJObject()
  add(query_589059, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589059, "upload_protocol", newJString(uploadProtocol))
  add(query_589059, "fields", newJString(fields))
  add(query_589059, "quotaUser", newJString(quotaUser))
  add(query_589059, "alt", newJString(alt))
  add(path_589058, "jobId", newJString(jobId))
  add(query_589059, "oauth_token", newJString(oauthToken))
  add(query_589059, "callback", newJString(callback))
  add(query_589059, "access_token", newJString(accessToken))
  add(query_589059, "uploadType", newJString(uploadType))
  add(query_589059, "key", newJString(key))
  add(query_589059, "$.xgafv", newJString(Xgafv))
  add(query_589059, "prettyPrint", newJBool(prettyPrint))
  result = call_589057.call(path_589058, query_589059, nil, nil, nil)

var youtubereportingJobsDelete* = Call_YoutubereportingJobsDelete_589040(
    name: "youtubereportingJobsDelete", meth: HttpMethod.HttpDelete,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs/{jobId}",
    validator: validate_YoutubereportingJobsDelete_589041, base: "/",
    url: url_YoutubereportingJobsDelete_589042, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsReportsList_589060 = ref object of OpenApiRestCall_588441
proc url_YoutubereportingJobsReportsList_589062(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/reports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_YoutubereportingJobsReportsList_589061(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists reports created by a specific job.
  ## Returns NOT_FOUND if the job does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589063 = path.getOrDefault("jobId")
  valid_589063 = validateParameter(valid_589063, JString, required = true,
                                 default = nil)
  if valid_589063 != nil:
    section.add "jobId", valid_589063
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of
  ## ListReportsResponse.next_page_token
  ## returned in response to the previous call to the `ListReports` method.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   createdAfter: JString
  ##               : If set, only reports created after the specified date/time are returned.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   startTimeAtOrAfter: JString
  ##                     : If set, only reports whose start time is greater than or equal the
  ## specified date/time are returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. Server may return fewer report types than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startTimeBefore: JString
  ##                  : If set, only reports whose start time is smaller than the specified
  ## date/time are returned.
  section = newJObject()
  var valid_589064 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "onBehalfOfContentOwner", valid_589064
  var valid_589065 = query.getOrDefault("upload_protocol")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "upload_protocol", valid_589065
  var valid_589066 = query.getOrDefault("fields")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "fields", valid_589066
  var valid_589067 = query.getOrDefault("pageToken")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "pageToken", valid_589067
  var valid_589068 = query.getOrDefault("quotaUser")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "quotaUser", valid_589068
  var valid_589069 = query.getOrDefault("alt")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = newJString("json"))
  if valid_589069 != nil:
    section.add "alt", valid_589069
  var valid_589070 = query.getOrDefault("createdAfter")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "createdAfter", valid_589070
  var valid_589071 = query.getOrDefault("oauth_token")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "oauth_token", valid_589071
  var valid_589072 = query.getOrDefault("callback")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "callback", valid_589072
  var valid_589073 = query.getOrDefault("access_token")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "access_token", valid_589073
  var valid_589074 = query.getOrDefault("uploadType")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "uploadType", valid_589074
  var valid_589075 = query.getOrDefault("startTimeAtOrAfter")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "startTimeAtOrAfter", valid_589075
  var valid_589076 = query.getOrDefault("key")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "key", valid_589076
  var valid_589077 = query.getOrDefault("$.xgafv")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = newJString("1"))
  if valid_589077 != nil:
    section.add "$.xgafv", valid_589077
  var valid_589078 = query.getOrDefault("pageSize")
  valid_589078 = validateParameter(valid_589078, JInt, required = false, default = nil)
  if valid_589078 != nil:
    section.add "pageSize", valid_589078
  var valid_589079 = query.getOrDefault("prettyPrint")
  valid_589079 = validateParameter(valid_589079, JBool, required = false,
                                 default = newJBool(true))
  if valid_589079 != nil:
    section.add "prettyPrint", valid_589079
  var valid_589080 = query.getOrDefault("startTimeBefore")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "startTimeBefore", valid_589080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589081: Call_YoutubereportingJobsReportsList_589060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists reports created by a specific job.
  ## Returns NOT_FOUND if the job does not exist.
  ## 
  let valid = call_589081.validator(path, query, header, formData, body)
  let scheme = call_589081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589081.url(scheme.get, call_589081.host, call_589081.base,
                         call_589081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589081, url, valid)

proc call*(call_589082: Call_YoutubereportingJobsReportsList_589060; jobId: string;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; createdAfter: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          startTimeAtOrAfter: string = ""; key: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true; startTimeBefore: string = ""): Recallable =
  ## youtubereportingJobsReportsList
  ## Lists reports created by a specific job.
  ## Returns NOT_FOUND if the job does not exist.
  ##   onBehalfOfContentOwner: string
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of
  ## ListReportsResponse.next_page_token
  ## returned in response to the previous call to the `ListReports` method.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   createdAfter: string
  ##               : If set, only reports created after the specified date/time are returned.
  ##   jobId: string (required)
  ##        : The ID of the job.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   startTimeAtOrAfter: string
  ##                     : If set, only reports whose start time is greater than or equal the
  ## specified date/time are returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer report types than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTimeBefore: string
  ##                  : If set, only reports whose start time is smaller than the specified
  ## date/time are returned.
  var path_589083 = newJObject()
  var query_589084 = newJObject()
  add(query_589084, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589084, "upload_protocol", newJString(uploadProtocol))
  add(query_589084, "fields", newJString(fields))
  add(query_589084, "pageToken", newJString(pageToken))
  add(query_589084, "quotaUser", newJString(quotaUser))
  add(query_589084, "alt", newJString(alt))
  add(query_589084, "createdAfter", newJString(createdAfter))
  add(path_589083, "jobId", newJString(jobId))
  add(query_589084, "oauth_token", newJString(oauthToken))
  add(query_589084, "callback", newJString(callback))
  add(query_589084, "access_token", newJString(accessToken))
  add(query_589084, "uploadType", newJString(uploadType))
  add(query_589084, "startTimeAtOrAfter", newJString(startTimeAtOrAfter))
  add(query_589084, "key", newJString(key))
  add(query_589084, "$.xgafv", newJString(Xgafv))
  add(query_589084, "pageSize", newJInt(pageSize))
  add(query_589084, "prettyPrint", newJBool(prettyPrint))
  add(query_589084, "startTimeBefore", newJString(startTimeBefore))
  result = call_589082.call(path_589083, query_589084, nil, nil, nil)

var youtubereportingJobsReportsList* = Call_YoutubereportingJobsReportsList_589060(
    name: "youtubereportingJobsReportsList", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs/{jobId}/reports",
    validator: validate_YoutubereportingJobsReportsList_589061, base: "/",
    url: url_YoutubereportingJobsReportsList_589062, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsReportsGet_589085 = ref object of OpenApiRestCall_588441
proc url_YoutubereportingJobsReportsGet_589087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  assert "reportId" in path, "`reportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "reportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_YoutubereportingJobsReportsGet_589086(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the metadata of a specific report.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : The ID of the job.
  ##   reportId: JString (required)
  ##           : The ID of the report to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589088 = path.getOrDefault("jobId")
  valid_589088 = validateParameter(valid_589088, JString, required = true,
                                 default = nil)
  if valid_589088 != nil:
    section.add "jobId", valid_589088
  var valid_589089 = path.getOrDefault("reportId")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "reportId", valid_589089
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
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
  var valid_589090 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "onBehalfOfContentOwner", valid_589090
  var valid_589091 = query.getOrDefault("upload_protocol")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "upload_protocol", valid_589091
  var valid_589092 = query.getOrDefault("fields")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "fields", valid_589092
  var valid_589093 = query.getOrDefault("quotaUser")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "quotaUser", valid_589093
  var valid_589094 = query.getOrDefault("alt")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = newJString("json"))
  if valid_589094 != nil:
    section.add "alt", valid_589094
  var valid_589095 = query.getOrDefault("oauth_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "oauth_token", valid_589095
  var valid_589096 = query.getOrDefault("callback")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "callback", valid_589096
  var valid_589097 = query.getOrDefault("access_token")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "access_token", valid_589097
  var valid_589098 = query.getOrDefault("uploadType")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "uploadType", valid_589098
  var valid_589099 = query.getOrDefault("key")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "key", valid_589099
  var valid_589100 = query.getOrDefault("$.xgafv")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = newJString("1"))
  if valid_589100 != nil:
    section.add "$.xgafv", valid_589100
  var valid_589101 = query.getOrDefault("prettyPrint")
  valid_589101 = validateParameter(valid_589101, JBool, required = false,
                                 default = newJBool(true))
  if valid_589101 != nil:
    section.add "prettyPrint", valid_589101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589102: Call_YoutubereportingJobsReportsGet_589085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metadata of a specific report.
  ## 
  let valid = call_589102.validator(path, query, header, formData, body)
  let scheme = call_589102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589102.url(scheme.get, call_589102.host, call_589102.base,
                         call_589102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589102, url, valid)

proc call*(call_589103: Call_YoutubereportingJobsReportsGet_589085; jobId: string;
          reportId: string; onBehalfOfContentOwner: string = "";
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## youtubereportingJobsReportsGet
  ## Gets the metadata of a specific report.
  ##   onBehalfOfContentOwner: string
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   jobId: string (required)
  ##        : The ID of the job.
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
  ##   reportId: string (required)
  ##           : The ID of the report to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589104 = newJObject()
  var query_589105 = newJObject()
  add(query_589105, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589105, "upload_protocol", newJString(uploadProtocol))
  add(query_589105, "fields", newJString(fields))
  add(query_589105, "quotaUser", newJString(quotaUser))
  add(query_589105, "alt", newJString(alt))
  add(path_589104, "jobId", newJString(jobId))
  add(query_589105, "oauth_token", newJString(oauthToken))
  add(query_589105, "callback", newJString(callback))
  add(query_589105, "access_token", newJString(accessToken))
  add(query_589105, "uploadType", newJString(uploadType))
  add(query_589105, "key", newJString(key))
  add(query_589105, "$.xgafv", newJString(Xgafv))
  add(path_589104, "reportId", newJString(reportId))
  add(query_589105, "prettyPrint", newJBool(prettyPrint))
  result = call_589103.call(path_589104, query_589105, nil, nil, nil)

var youtubereportingJobsReportsGet* = Call_YoutubereportingJobsReportsGet_589085(
    name: "youtubereportingJobsReportsGet", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com",
    route: "/v1/jobs/{jobId}/reports/{reportId}",
    validator: validate_YoutubereportingJobsReportsGet_589086, base: "/",
    url: url_YoutubereportingJobsReportsGet_589087, schemes: {Scheme.Https})
type
  Call_YoutubereportingMediaDownload_589106 = ref object of OpenApiRestCall_588441
proc url_YoutubereportingMediaDownload_589108(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/media/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_YoutubereportingMediaDownload_589107(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Method for media download. Download is supported
  ## on the URI `/v1/media/{+name}?alt=media`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : Name of the media that is being downloaded.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_589109 = path.getOrDefault("resourceName")
  valid_589109 = validateParameter(valid_589109, JString, required = true,
                                 default = nil)
  if valid_589109 != nil:
    section.add "resourceName", valid_589109
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
  var valid_589110 = query.getOrDefault("upload_protocol")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "upload_protocol", valid_589110
  var valid_589111 = query.getOrDefault("fields")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "fields", valid_589111
  var valid_589112 = query.getOrDefault("quotaUser")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "quotaUser", valid_589112
  var valid_589113 = query.getOrDefault("alt")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = newJString("json"))
  if valid_589113 != nil:
    section.add "alt", valid_589113
  var valid_589114 = query.getOrDefault("oauth_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "oauth_token", valid_589114
  var valid_589115 = query.getOrDefault("callback")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "callback", valid_589115
  var valid_589116 = query.getOrDefault("access_token")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "access_token", valid_589116
  var valid_589117 = query.getOrDefault("uploadType")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "uploadType", valid_589117
  var valid_589118 = query.getOrDefault("key")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "key", valid_589118
  var valid_589119 = query.getOrDefault("$.xgafv")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = newJString("1"))
  if valid_589119 != nil:
    section.add "$.xgafv", valid_589119
  var valid_589120 = query.getOrDefault("prettyPrint")
  valid_589120 = validateParameter(valid_589120, JBool, required = false,
                                 default = newJBool(true))
  if valid_589120 != nil:
    section.add "prettyPrint", valid_589120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589121: Call_YoutubereportingMediaDownload_589106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Method for media download. Download is supported
  ## on the URI `/v1/media/{+name}?alt=media`.
  ## 
  let valid = call_589121.validator(path, query, header, formData, body)
  let scheme = call_589121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589121.url(scheme.get, call_589121.host, call_589121.base,
                         call_589121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589121, url, valid)

proc call*(call_589122: Call_YoutubereportingMediaDownload_589106;
          resourceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## youtubereportingMediaDownload
  ## Method for media download. Download is supported
  ## on the URI `/v1/media/{+name}?alt=media`.
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
  ##   resourceName: string (required)
  ##               : Name of the media that is being downloaded.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589123 = newJObject()
  var query_589124 = newJObject()
  add(query_589124, "upload_protocol", newJString(uploadProtocol))
  add(query_589124, "fields", newJString(fields))
  add(query_589124, "quotaUser", newJString(quotaUser))
  add(query_589124, "alt", newJString(alt))
  add(query_589124, "oauth_token", newJString(oauthToken))
  add(query_589124, "callback", newJString(callback))
  add(query_589124, "access_token", newJString(accessToken))
  add(query_589124, "uploadType", newJString(uploadType))
  add(path_589123, "resourceName", newJString(resourceName))
  add(query_589124, "key", newJString(key))
  add(query_589124, "$.xgafv", newJString(Xgafv))
  add(query_589124, "prettyPrint", newJBool(prettyPrint))
  result = call_589122.call(path_589123, query_589124, nil, nil, nil)

var youtubereportingMediaDownload* = Call_YoutubereportingMediaDownload_589106(
    name: "youtubereportingMediaDownload", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/media/{resourceName}",
    validator: validate_YoutubereportingMediaDownload_589107, base: "/",
    url: url_YoutubereportingMediaDownload_589108, schemes: {Scheme.Https})
type
  Call_YoutubereportingReportTypesList_589125 = ref object of OpenApiRestCall_588441
proc url_YoutubereportingReportTypesList_589127(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubereportingReportTypesList_589126(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists report types.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of
  ## ListReportTypesResponse.next_page_token
  ## returned in response to the previous call to the `ListReportTypes` method.
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
  ##           : Requested page size. Server may return fewer report types than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   includeSystemManaged: JBool
  ##                       : If set to true, also system-managed report types will be returned;
  ## otherwise only the report types that can be used to create new reporting
  ## jobs will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589128 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "onBehalfOfContentOwner", valid_589128
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
  var valid_589131 = query.getOrDefault("pageToken")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "pageToken", valid_589131
  var valid_589132 = query.getOrDefault("quotaUser")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "quotaUser", valid_589132
  var valid_589133 = query.getOrDefault("alt")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = newJString("json"))
  if valid_589133 != nil:
    section.add "alt", valid_589133
  var valid_589134 = query.getOrDefault("oauth_token")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "oauth_token", valid_589134
  var valid_589135 = query.getOrDefault("callback")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "callback", valid_589135
  var valid_589136 = query.getOrDefault("access_token")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "access_token", valid_589136
  var valid_589137 = query.getOrDefault("uploadType")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "uploadType", valid_589137
  var valid_589138 = query.getOrDefault("key")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "key", valid_589138
  var valid_589139 = query.getOrDefault("$.xgafv")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = newJString("1"))
  if valid_589139 != nil:
    section.add "$.xgafv", valid_589139
  var valid_589140 = query.getOrDefault("pageSize")
  valid_589140 = validateParameter(valid_589140, JInt, required = false, default = nil)
  if valid_589140 != nil:
    section.add "pageSize", valid_589140
  var valid_589141 = query.getOrDefault("includeSystemManaged")
  valid_589141 = validateParameter(valid_589141, JBool, required = false, default = nil)
  if valid_589141 != nil:
    section.add "includeSystemManaged", valid_589141
  var valid_589142 = query.getOrDefault("prettyPrint")
  valid_589142 = validateParameter(valid_589142, JBool, required = false,
                                 default = newJBool(true))
  if valid_589142 != nil:
    section.add "prettyPrint", valid_589142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589143: Call_YoutubereportingReportTypesList_589125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists report types.
  ## 
  let valid = call_589143.validator(path, query, header, formData, body)
  let scheme = call_589143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589143.url(scheme.get, call_589143.host, call_589143.base,
                         call_589143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589143, url, valid)

proc call*(call_589144: Call_YoutubereportingReportTypesList_589125;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; includeSystemManaged: bool = false;
          prettyPrint: bool = true): Recallable =
  ## youtubereportingReportTypesList
  ## Lists report types.
  ##   onBehalfOfContentOwner: string
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of
  ## ListReportTypesResponse.next_page_token
  ## returned in response to the previous call to the `ListReportTypes` method.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer report types than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   includeSystemManaged: bool
  ##                       : If set to true, also system-managed report types will be returned;
  ## otherwise only the report types that can be used to create new reporting
  ## jobs will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589145 = newJObject()
  add(query_589145, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589145, "upload_protocol", newJString(uploadProtocol))
  add(query_589145, "fields", newJString(fields))
  add(query_589145, "pageToken", newJString(pageToken))
  add(query_589145, "quotaUser", newJString(quotaUser))
  add(query_589145, "alt", newJString(alt))
  add(query_589145, "oauth_token", newJString(oauthToken))
  add(query_589145, "callback", newJString(callback))
  add(query_589145, "access_token", newJString(accessToken))
  add(query_589145, "uploadType", newJString(uploadType))
  add(query_589145, "key", newJString(key))
  add(query_589145, "$.xgafv", newJString(Xgafv))
  add(query_589145, "pageSize", newJInt(pageSize))
  add(query_589145, "includeSystemManaged", newJBool(includeSystemManaged))
  add(query_589145, "prettyPrint", newJBool(prettyPrint))
  result = call_589144.call(nil, query_589145, nil, nil, nil)

var youtubereportingReportTypesList* = Call_YoutubereportingReportTypesList_589125(
    name: "youtubereportingReportTypesList", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/reportTypes",
    validator: validate_YoutubereportingReportTypesList_589126, base: "/",
    url: url_YoutubereportingReportTypesList_589127, schemes: {Scheme.Https})
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
