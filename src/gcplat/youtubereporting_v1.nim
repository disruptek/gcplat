
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
  gcpServiceName = "youtubereporting"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_YoutubereportingJobsCreate_579953 = ref object of OpenApiRestCall_579408
proc url_YoutubereportingJobsCreate_579955(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubereportingJobsCreate_579954(path: JsonNode; query: JsonNode;
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
  var valid_579956 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "onBehalfOfContentOwner", valid_579956
  var valid_579957 = query.getOrDefault("upload_protocol")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "upload_protocol", valid_579957
  var valid_579958 = query.getOrDefault("fields")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "fields", valid_579958
  var valid_579959 = query.getOrDefault("quotaUser")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "quotaUser", valid_579959
  var valid_579960 = query.getOrDefault("alt")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = newJString("json"))
  if valid_579960 != nil:
    section.add "alt", valid_579960
  var valid_579961 = query.getOrDefault("oauth_token")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "oauth_token", valid_579961
  var valid_579962 = query.getOrDefault("callback")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "callback", valid_579962
  var valid_579963 = query.getOrDefault("access_token")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "access_token", valid_579963
  var valid_579964 = query.getOrDefault("uploadType")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "uploadType", valid_579964
  var valid_579965 = query.getOrDefault("key")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "key", valid_579965
  var valid_579966 = query.getOrDefault("$.xgafv")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = newJString("1"))
  if valid_579966 != nil:
    section.add "$.xgafv", valid_579966
  var valid_579967 = query.getOrDefault("prettyPrint")
  valid_579967 = validateParameter(valid_579967, JBool, required = false,
                                 default = newJBool(true))
  if valid_579967 != nil:
    section.add "prettyPrint", valid_579967
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

proc call*(call_579969: Call_YoutubereportingJobsCreate_579953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job and returns it.
  ## 
  let valid = call_579969.validator(path, query, header, formData, body)
  let scheme = call_579969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579969.url(scheme.get, call_579969.host, call_579969.base,
                         call_579969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579969, url, valid)

proc call*(call_579970: Call_YoutubereportingJobsCreate_579953;
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
  var query_579971 = newJObject()
  var body_579972 = newJObject()
  add(query_579971, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579971, "upload_protocol", newJString(uploadProtocol))
  add(query_579971, "fields", newJString(fields))
  add(query_579971, "quotaUser", newJString(quotaUser))
  add(query_579971, "alt", newJString(alt))
  add(query_579971, "oauth_token", newJString(oauthToken))
  add(query_579971, "callback", newJString(callback))
  add(query_579971, "access_token", newJString(accessToken))
  add(query_579971, "uploadType", newJString(uploadType))
  add(query_579971, "key", newJString(key))
  add(query_579971, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579972 = body
  add(query_579971, "prettyPrint", newJBool(prettyPrint))
  result = call_579970.call(nil, query_579971, nil, nil, body_579972)

var youtubereportingJobsCreate* = Call_YoutubereportingJobsCreate_579953(
    name: "youtubereportingJobsCreate", meth: HttpMethod.HttpPost,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs",
    validator: validate_YoutubereportingJobsCreate_579954, base: "/",
    url: url_YoutubereportingJobsCreate_579955, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsList_579677 = ref object of OpenApiRestCall_579408
proc url_YoutubereportingJobsList_579679(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubereportingJobsList_579678(path: JsonNode; query: JsonNode;
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
  var valid_579791 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "onBehalfOfContentOwner", valid_579791
  var valid_579792 = query.getOrDefault("upload_protocol")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "upload_protocol", valid_579792
  var valid_579793 = query.getOrDefault("fields")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "fields", valid_579793
  var valid_579794 = query.getOrDefault("pageToken")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "pageToken", valid_579794
  var valid_579795 = query.getOrDefault("quotaUser")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "quotaUser", valid_579795
  var valid_579809 = query.getOrDefault("alt")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = newJString("json"))
  if valid_579809 != nil:
    section.add "alt", valid_579809
  var valid_579810 = query.getOrDefault("oauth_token")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "oauth_token", valid_579810
  var valid_579811 = query.getOrDefault("callback")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "callback", valid_579811
  var valid_579812 = query.getOrDefault("access_token")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "access_token", valid_579812
  var valid_579813 = query.getOrDefault("uploadType")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "uploadType", valid_579813
  var valid_579814 = query.getOrDefault("key")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "key", valid_579814
  var valid_579815 = query.getOrDefault("$.xgafv")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = newJString("1"))
  if valid_579815 != nil:
    section.add "$.xgafv", valid_579815
  var valid_579816 = query.getOrDefault("pageSize")
  valid_579816 = validateParameter(valid_579816, JInt, required = false, default = nil)
  if valid_579816 != nil:
    section.add "pageSize", valid_579816
  var valid_579817 = query.getOrDefault("includeSystemManaged")
  valid_579817 = validateParameter(valid_579817, JBool, required = false, default = nil)
  if valid_579817 != nil:
    section.add "includeSystemManaged", valid_579817
  var valid_579818 = query.getOrDefault("prettyPrint")
  valid_579818 = validateParameter(valid_579818, JBool, required = false,
                                 default = newJBool(true))
  if valid_579818 != nil:
    section.add "prettyPrint", valid_579818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579841: Call_YoutubereportingJobsList_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs.
  ## 
  let valid = call_579841.validator(path, query, header, formData, body)
  let scheme = call_579841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579841.url(scheme.get, call_579841.host, call_579841.base,
                         call_579841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579841, url, valid)

proc call*(call_579912: Call_YoutubereportingJobsList_579677;
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
  var query_579913 = newJObject()
  add(query_579913, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579913, "upload_protocol", newJString(uploadProtocol))
  add(query_579913, "fields", newJString(fields))
  add(query_579913, "pageToken", newJString(pageToken))
  add(query_579913, "quotaUser", newJString(quotaUser))
  add(query_579913, "alt", newJString(alt))
  add(query_579913, "oauth_token", newJString(oauthToken))
  add(query_579913, "callback", newJString(callback))
  add(query_579913, "access_token", newJString(accessToken))
  add(query_579913, "uploadType", newJString(uploadType))
  add(query_579913, "key", newJString(key))
  add(query_579913, "$.xgafv", newJString(Xgafv))
  add(query_579913, "pageSize", newJInt(pageSize))
  add(query_579913, "includeSystemManaged", newJBool(includeSystemManaged))
  add(query_579913, "prettyPrint", newJBool(prettyPrint))
  result = call_579912.call(nil, query_579913, nil, nil, nil)

var youtubereportingJobsList* = Call_YoutubereportingJobsList_579677(
    name: "youtubereportingJobsList", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs",
    validator: validate_YoutubereportingJobsList_579678, base: "/",
    url: url_YoutubereportingJobsList_579679, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsGet_579973 = ref object of OpenApiRestCall_579408
proc url_YoutubereportingJobsGet_579975(protocol: Scheme; host: string; base: string;
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

proc validate_YoutubereportingJobsGet_579974(path: JsonNode; query: JsonNode;
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
  var valid_579990 = path.getOrDefault("jobId")
  valid_579990 = validateParameter(valid_579990, JString, required = true,
                                 default = nil)
  if valid_579990 != nil:
    section.add "jobId", valid_579990
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
  var valid_579991 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "onBehalfOfContentOwner", valid_579991
  var valid_579992 = query.getOrDefault("upload_protocol")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "upload_protocol", valid_579992
  var valid_579993 = query.getOrDefault("fields")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "fields", valid_579993
  var valid_579994 = query.getOrDefault("quotaUser")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "quotaUser", valid_579994
  var valid_579995 = query.getOrDefault("alt")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("json"))
  if valid_579995 != nil:
    section.add "alt", valid_579995
  var valid_579996 = query.getOrDefault("oauth_token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "oauth_token", valid_579996
  var valid_579997 = query.getOrDefault("callback")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "callback", valid_579997
  var valid_579998 = query.getOrDefault("access_token")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "access_token", valid_579998
  var valid_579999 = query.getOrDefault("uploadType")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "uploadType", valid_579999
  var valid_580000 = query.getOrDefault("key")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "key", valid_580000
  var valid_580001 = query.getOrDefault("$.xgafv")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("1"))
  if valid_580001 != nil:
    section.add "$.xgafv", valid_580001
  var valid_580002 = query.getOrDefault("prettyPrint")
  valid_580002 = validateParameter(valid_580002, JBool, required = false,
                                 default = newJBool(true))
  if valid_580002 != nil:
    section.add "prettyPrint", valid_580002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580003: Call_YoutubereportingJobsGet_579973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job.
  ## 
  let valid = call_580003.validator(path, query, header, formData, body)
  let scheme = call_580003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580003.url(scheme.get, call_580003.host, call_580003.base,
                         call_580003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580003, url, valid)

proc call*(call_580004: Call_YoutubereportingJobsGet_579973; jobId: string;
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
  var path_580005 = newJObject()
  var query_580006 = newJObject()
  add(query_580006, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580006, "upload_protocol", newJString(uploadProtocol))
  add(query_580006, "fields", newJString(fields))
  add(query_580006, "quotaUser", newJString(quotaUser))
  add(query_580006, "alt", newJString(alt))
  add(path_580005, "jobId", newJString(jobId))
  add(query_580006, "oauth_token", newJString(oauthToken))
  add(query_580006, "callback", newJString(callback))
  add(query_580006, "access_token", newJString(accessToken))
  add(query_580006, "uploadType", newJString(uploadType))
  add(query_580006, "key", newJString(key))
  add(query_580006, "$.xgafv", newJString(Xgafv))
  add(query_580006, "prettyPrint", newJBool(prettyPrint))
  result = call_580004.call(path_580005, query_580006, nil, nil, nil)

var youtubereportingJobsGet* = Call_YoutubereportingJobsGet_579973(
    name: "youtubereportingJobsGet", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs/{jobId}",
    validator: validate_YoutubereportingJobsGet_579974, base: "/",
    url: url_YoutubereportingJobsGet_579975, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsDelete_580007 = ref object of OpenApiRestCall_579408
proc url_YoutubereportingJobsDelete_580009(protocol: Scheme; host: string;
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

proc validate_YoutubereportingJobsDelete_580008(path: JsonNode; query: JsonNode;
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
  var valid_580010 = path.getOrDefault("jobId")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "jobId", valid_580010
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
  var valid_580011 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "onBehalfOfContentOwner", valid_580011
  var valid_580012 = query.getOrDefault("upload_protocol")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "upload_protocol", valid_580012
  var valid_580013 = query.getOrDefault("fields")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "fields", valid_580013
  var valid_580014 = query.getOrDefault("quotaUser")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "quotaUser", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("oauth_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "oauth_token", valid_580016
  var valid_580017 = query.getOrDefault("callback")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "callback", valid_580017
  var valid_580018 = query.getOrDefault("access_token")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "access_token", valid_580018
  var valid_580019 = query.getOrDefault("uploadType")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "uploadType", valid_580019
  var valid_580020 = query.getOrDefault("key")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "key", valid_580020
  var valid_580021 = query.getOrDefault("$.xgafv")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("1"))
  if valid_580021 != nil:
    section.add "$.xgafv", valid_580021
  var valid_580022 = query.getOrDefault("prettyPrint")
  valid_580022 = validateParameter(valid_580022, JBool, required = false,
                                 default = newJBool(true))
  if valid_580022 != nil:
    section.add "prettyPrint", valid_580022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580023: Call_YoutubereportingJobsDelete_580007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job.
  ## 
  let valid = call_580023.validator(path, query, header, formData, body)
  let scheme = call_580023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580023.url(scheme.get, call_580023.host, call_580023.base,
                         call_580023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580023, url, valid)

proc call*(call_580024: Call_YoutubereportingJobsDelete_580007; jobId: string;
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
  var path_580025 = newJObject()
  var query_580026 = newJObject()
  add(query_580026, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580026, "upload_protocol", newJString(uploadProtocol))
  add(query_580026, "fields", newJString(fields))
  add(query_580026, "quotaUser", newJString(quotaUser))
  add(query_580026, "alt", newJString(alt))
  add(path_580025, "jobId", newJString(jobId))
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "callback", newJString(callback))
  add(query_580026, "access_token", newJString(accessToken))
  add(query_580026, "uploadType", newJString(uploadType))
  add(query_580026, "key", newJString(key))
  add(query_580026, "$.xgafv", newJString(Xgafv))
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  result = call_580024.call(path_580025, query_580026, nil, nil, nil)

var youtubereportingJobsDelete* = Call_YoutubereportingJobsDelete_580007(
    name: "youtubereportingJobsDelete", meth: HttpMethod.HttpDelete,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs/{jobId}",
    validator: validate_YoutubereportingJobsDelete_580008, base: "/",
    url: url_YoutubereportingJobsDelete_580009, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsReportsList_580027 = ref object of OpenApiRestCall_579408
proc url_YoutubereportingJobsReportsList_580029(protocol: Scheme; host: string;
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

proc validate_YoutubereportingJobsReportsList_580028(path: JsonNode;
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
  var valid_580030 = path.getOrDefault("jobId")
  valid_580030 = validateParameter(valid_580030, JString, required = true,
                                 default = nil)
  if valid_580030 != nil:
    section.add "jobId", valid_580030
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
  var valid_580031 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "onBehalfOfContentOwner", valid_580031
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
  var valid_580034 = query.getOrDefault("pageToken")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "pageToken", valid_580034
  var valid_580035 = query.getOrDefault("quotaUser")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "quotaUser", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("createdAfter")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "createdAfter", valid_580037
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
  var valid_580042 = query.getOrDefault("startTimeAtOrAfter")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "startTimeAtOrAfter", valid_580042
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
  var valid_580045 = query.getOrDefault("pageSize")
  valid_580045 = validateParameter(valid_580045, JInt, required = false, default = nil)
  if valid_580045 != nil:
    section.add "pageSize", valid_580045
  var valid_580046 = query.getOrDefault("prettyPrint")
  valid_580046 = validateParameter(valid_580046, JBool, required = false,
                                 default = newJBool(true))
  if valid_580046 != nil:
    section.add "prettyPrint", valid_580046
  var valid_580047 = query.getOrDefault("startTimeBefore")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "startTimeBefore", valid_580047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580048: Call_YoutubereportingJobsReportsList_580027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists reports created by a specific job.
  ## Returns NOT_FOUND if the job does not exist.
  ## 
  let valid = call_580048.validator(path, query, header, formData, body)
  let scheme = call_580048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580048.url(scheme.get, call_580048.host, call_580048.base,
                         call_580048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580048, url, valid)

proc call*(call_580049: Call_YoutubereportingJobsReportsList_580027; jobId: string;
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
  var path_580050 = newJObject()
  var query_580051 = newJObject()
  add(query_580051, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580051, "upload_protocol", newJString(uploadProtocol))
  add(query_580051, "fields", newJString(fields))
  add(query_580051, "pageToken", newJString(pageToken))
  add(query_580051, "quotaUser", newJString(quotaUser))
  add(query_580051, "alt", newJString(alt))
  add(query_580051, "createdAfter", newJString(createdAfter))
  add(path_580050, "jobId", newJString(jobId))
  add(query_580051, "oauth_token", newJString(oauthToken))
  add(query_580051, "callback", newJString(callback))
  add(query_580051, "access_token", newJString(accessToken))
  add(query_580051, "uploadType", newJString(uploadType))
  add(query_580051, "startTimeAtOrAfter", newJString(startTimeAtOrAfter))
  add(query_580051, "key", newJString(key))
  add(query_580051, "$.xgafv", newJString(Xgafv))
  add(query_580051, "pageSize", newJInt(pageSize))
  add(query_580051, "prettyPrint", newJBool(prettyPrint))
  add(query_580051, "startTimeBefore", newJString(startTimeBefore))
  result = call_580049.call(path_580050, query_580051, nil, nil, nil)

var youtubereportingJobsReportsList* = Call_YoutubereportingJobsReportsList_580027(
    name: "youtubereportingJobsReportsList", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs/{jobId}/reports",
    validator: validate_YoutubereportingJobsReportsList_580028, base: "/",
    url: url_YoutubereportingJobsReportsList_580029, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsReportsGet_580052 = ref object of OpenApiRestCall_579408
proc url_YoutubereportingJobsReportsGet_580054(protocol: Scheme; host: string;
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

proc validate_YoutubereportingJobsReportsGet_580053(path: JsonNode;
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
  var valid_580055 = path.getOrDefault("jobId")
  valid_580055 = validateParameter(valid_580055, JString, required = true,
                                 default = nil)
  if valid_580055 != nil:
    section.add "jobId", valid_580055
  var valid_580056 = path.getOrDefault("reportId")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "reportId", valid_580056
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
  var valid_580057 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "onBehalfOfContentOwner", valid_580057
  var valid_580058 = query.getOrDefault("upload_protocol")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "upload_protocol", valid_580058
  var valid_580059 = query.getOrDefault("fields")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "fields", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("alt")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("json"))
  if valid_580061 != nil:
    section.add "alt", valid_580061
  var valid_580062 = query.getOrDefault("oauth_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "oauth_token", valid_580062
  var valid_580063 = query.getOrDefault("callback")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "callback", valid_580063
  var valid_580064 = query.getOrDefault("access_token")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "access_token", valid_580064
  var valid_580065 = query.getOrDefault("uploadType")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "uploadType", valid_580065
  var valid_580066 = query.getOrDefault("key")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "key", valid_580066
  var valid_580067 = query.getOrDefault("$.xgafv")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = newJString("1"))
  if valid_580067 != nil:
    section.add "$.xgafv", valid_580067
  var valid_580068 = query.getOrDefault("prettyPrint")
  valid_580068 = validateParameter(valid_580068, JBool, required = false,
                                 default = newJBool(true))
  if valid_580068 != nil:
    section.add "prettyPrint", valid_580068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580069: Call_YoutubereportingJobsReportsGet_580052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metadata of a specific report.
  ## 
  let valid = call_580069.validator(path, query, header, formData, body)
  let scheme = call_580069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580069.url(scheme.get, call_580069.host, call_580069.base,
                         call_580069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580069, url, valid)

proc call*(call_580070: Call_YoutubereportingJobsReportsGet_580052; jobId: string;
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
  var path_580071 = newJObject()
  var query_580072 = newJObject()
  add(query_580072, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580072, "upload_protocol", newJString(uploadProtocol))
  add(query_580072, "fields", newJString(fields))
  add(query_580072, "quotaUser", newJString(quotaUser))
  add(query_580072, "alt", newJString(alt))
  add(path_580071, "jobId", newJString(jobId))
  add(query_580072, "oauth_token", newJString(oauthToken))
  add(query_580072, "callback", newJString(callback))
  add(query_580072, "access_token", newJString(accessToken))
  add(query_580072, "uploadType", newJString(uploadType))
  add(query_580072, "key", newJString(key))
  add(query_580072, "$.xgafv", newJString(Xgafv))
  add(path_580071, "reportId", newJString(reportId))
  add(query_580072, "prettyPrint", newJBool(prettyPrint))
  result = call_580070.call(path_580071, query_580072, nil, nil, nil)

var youtubereportingJobsReportsGet* = Call_YoutubereportingJobsReportsGet_580052(
    name: "youtubereportingJobsReportsGet", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com",
    route: "/v1/jobs/{jobId}/reports/{reportId}",
    validator: validate_YoutubereportingJobsReportsGet_580053, base: "/",
    url: url_YoutubereportingJobsReportsGet_580054, schemes: {Scheme.Https})
type
  Call_YoutubereportingMediaDownload_580073 = ref object of OpenApiRestCall_579408
proc url_YoutubereportingMediaDownload_580075(protocol: Scheme; host: string;
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

proc validate_YoutubereportingMediaDownload_580074(path: JsonNode; query: JsonNode;
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
  var valid_580076 = path.getOrDefault("resourceName")
  valid_580076 = validateParameter(valid_580076, JString, required = true,
                                 default = nil)
  if valid_580076 != nil:
    section.add "resourceName", valid_580076
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
  var valid_580077 = query.getOrDefault("upload_protocol")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "upload_protocol", valid_580077
  var valid_580078 = query.getOrDefault("fields")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "fields", valid_580078
  var valid_580079 = query.getOrDefault("quotaUser")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "quotaUser", valid_580079
  var valid_580080 = query.getOrDefault("alt")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = newJString("json"))
  if valid_580080 != nil:
    section.add "alt", valid_580080
  var valid_580081 = query.getOrDefault("oauth_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "oauth_token", valid_580081
  var valid_580082 = query.getOrDefault("callback")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "callback", valid_580082
  var valid_580083 = query.getOrDefault("access_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "access_token", valid_580083
  var valid_580084 = query.getOrDefault("uploadType")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "uploadType", valid_580084
  var valid_580085 = query.getOrDefault("key")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "key", valid_580085
  var valid_580086 = query.getOrDefault("$.xgafv")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = newJString("1"))
  if valid_580086 != nil:
    section.add "$.xgafv", valid_580086
  var valid_580087 = query.getOrDefault("prettyPrint")
  valid_580087 = validateParameter(valid_580087, JBool, required = false,
                                 default = newJBool(true))
  if valid_580087 != nil:
    section.add "prettyPrint", valid_580087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580088: Call_YoutubereportingMediaDownload_580073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Method for media download. Download is supported
  ## on the URI `/v1/media/{+name}?alt=media`.
  ## 
  let valid = call_580088.validator(path, query, header, formData, body)
  let scheme = call_580088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580088.url(scheme.get, call_580088.host, call_580088.base,
                         call_580088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580088, url, valid)

proc call*(call_580089: Call_YoutubereportingMediaDownload_580073;
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
  var path_580090 = newJObject()
  var query_580091 = newJObject()
  add(query_580091, "upload_protocol", newJString(uploadProtocol))
  add(query_580091, "fields", newJString(fields))
  add(query_580091, "quotaUser", newJString(quotaUser))
  add(query_580091, "alt", newJString(alt))
  add(query_580091, "oauth_token", newJString(oauthToken))
  add(query_580091, "callback", newJString(callback))
  add(query_580091, "access_token", newJString(accessToken))
  add(query_580091, "uploadType", newJString(uploadType))
  add(path_580090, "resourceName", newJString(resourceName))
  add(query_580091, "key", newJString(key))
  add(query_580091, "$.xgafv", newJString(Xgafv))
  add(query_580091, "prettyPrint", newJBool(prettyPrint))
  result = call_580089.call(path_580090, query_580091, nil, nil, nil)

var youtubereportingMediaDownload* = Call_YoutubereportingMediaDownload_580073(
    name: "youtubereportingMediaDownload", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/media/{resourceName}",
    validator: validate_YoutubereportingMediaDownload_580074, base: "/",
    url: url_YoutubereportingMediaDownload_580075, schemes: {Scheme.Https})
type
  Call_YoutubereportingReportTypesList_580092 = ref object of OpenApiRestCall_579408
proc url_YoutubereportingReportTypesList_580094(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubereportingReportTypesList_580093(path: JsonNode;
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
  var valid_580095 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "onBehalfOfContentOwner", valid_580095
  var valid_580096 = query.getOrDefault("upload_protocol")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "upload_protocol", valid_580096
  var valid_580097 = query.getOrDefault("fields")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "fields", valid_580097
  var valid_580098 = query.getOrDefault("pageToken")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "pageToken", valid_580098
  var valid_580099 = query.getOrDefault("quotaUser")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "quotaUser", valid_580099
  var valid_580100 = query.getOrDefault("alt")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("json"))
  if valid_580100 != nil:
    section.add "alt", valid_580100
  var valid_580101 = query.getOrDefault("oauth_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "oauth_token", valid_580101
  var valid_580102 = query.getOrDefault("callback")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "callback", valid_580102
  var valid_580103 = query.getOrDefault("access_token")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "access_token", valid_580103
  var valid_580104 = query.getOrDefault("uploadType")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "uploadType", valid_580104
  var valid_580105 = query.getOrDefault("key")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "key", valid_580105
  var valid_580106 = query.getOrDefault("$.xgafv")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = newJString("1"))
  if valid_580106 != nil:
    section.add "$.xgafv", valid_580106
  var valid_580107 = query.getOrDefault("pageSize")
  valid_580107 = validateParameter(valid_580107, JInt, required = false, default = nil)
  if valid_580107 != nil:
    section.add "pageSize", valid_580107
  var valid_580108 = query.getOrDefault("includeSystemManaged")
  valid_580108 = validateParameter(valid_580108, JBool, required = false, default = nil)
  if valid_580108 != nil:
    section.add "includeSystemManaged", valid_580108
  var valid_580109 = query.getOrDefault("prettyPrint")
  valid_580109 = validateParameter(valid_580109, JBool, required = false,
                                 default = newJBool(true))
  if valid_580109 != nil:
    section.add "prettyPrint", valid_580109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580110: Call_YoutubereportingReportTypesList_580092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists report types.
  ## 
  let valid = call_580110.validator(path, query, header, formData, body)
  let scheme = call_580110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580110.url(scheme.get, call_580110.host, call_580110.base,
                         call_580110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580110, url, valid)

proc call*(call_580111: Call_YoutubereportingReportTypesList_580092;
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
  var query_580112 = newJObject()
  add(query_580112, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580112, "upload_protocol", newJString(uploadProtocol))
  add(query_580112, "fields", newJString(fields))
  add(query_580112, "pageToken", newJString(pageToken))
  add(query_580112, "quotaUser", newJString(quotaUser))
  add(query_580112, "alt", newJString(alt))
  add(query_580112, "oauth_token", newJString(oauthToken))
  add(query_580112, "callback", newJString(callback))
  add(query_580112, "access_token", newJString(accessToken))
  add(query_580112, "uploadType", newJString(uploadType))
  add(query_580112, "key", newJString(key))
  add(query_580112, "$.xgafv", newJString(Xgafv))
  add(query_580112, "pageSize", newJInt(pageSize))
  add(query_580112, "includeSystemManaged", newJBool(includeSystemManaged))
  add(query_580112, "prettyPrint", newJBool(prettyPrint))
  result = call_580111.call(nil, query_580112, nil, nil, nil)

var youtubereportingReportTypesList* = Call_YoutubereportingReportTypesList_580092(
    name: "youtubereportingReportTypesList", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/reportTypes",
    validator: validate_YoutubereportingReportTypesList_580093, base: "/",
    url: url_YoutubereportingReportTypesList_580094, schemes: {Scheme.Https})
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
