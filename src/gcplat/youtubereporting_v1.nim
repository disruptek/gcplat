
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_YoutubereportingJobsCreate_593953 = ref object of OpenApiRestCall_593408
proc url_YoutubereportingJobsCreate_593955(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubereportingJobsCreate_593954(path: JsonNode; query: JsonNode;
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
  var valid_593956 = query.getOrDefault("onBehalfOfContentOwner")
  valid_593956 = validateParameter(valid_593956, JString, required = false,
                                 default = nil)
  if valid_593956 != nil:
    section.add "onBehalfOfContentOwner", valid_593956
  var valid_593957 = query.getOrDefault("upload_protocol")
  valid_593957 = validateParameter(valid_593957, JString, required = false,
                                 default = nil)
  if valid_593957 != nil:
    section.add "upload_protocol", valid_593957
  var valid_593958 = query.getOrDefault("fields")
  valid_593958 = validateParameter(valid_593958, JString, required = false,
                                 default = nil)
  if valid_593958 != nil:
    section.add "fields", valid_593958
  var valid_593959 = query.getOrDefault("quotaUser")
  valid_593959 = validateParameter(valid_593959, JString, required = false,
                                 default = nil)
  if valid_593959 != nil:
    section.add "quotaUser", valid_593959
  var valid_593960 = query.getOrDefault("alt")
  valid_593960 = validateParameter(valid_593960, JString, required = false,
                                 default = newJString("json"))
  if valid_593960 != nil:
    section.add "alt", valid_593960
  var valid_593961 = query.getOrDefault("oauth_token")
  valid_593961 = validateParameter(valid_593961, JString, required = false,
                                 default = nil)
  if valid_593961 != nil:
    section.add "oauth_token", valid_593961
  var valid_593962 = query.getOrDefault("callback")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "callback", valid_593962
  var valid_593963 = query.getOrDefault("access_token")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "access_token", valid_593963
  var valid_593964 = query.getOrDefault("uploadType")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "uploadType", valid_593964
  var valid_593965 = query.getOrDefault("key")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "key", valid_593965
  var valid_593966 = query.getOrDefault("$.xgafv")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = newJString("1"))
  if valid_593966 != nil:
    section.add "$.xgafv", valid_593966
  var valid_593967 = query.getOrDefault("prettyPrint")
  valid_593967 = validateParameter(valid_593967, JBool, required = false,
                                 default = newJBool(true))
  if valid_593967 != nil:
    section.add "prettyPrint", valid_593967
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

proc call*(call_593969: Call_YoutubereportingJobsCreate_593953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job and returns it.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_YoutubereportingJobsCreate_593953;
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
  var query_593971 = newJObject()
  var body_593972 = newJObject()
  add(query_593971, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_593971, "upload_protocol", newJString(uploadProtocol))
  add(query_593971, "fields", newJString(fields))
  add(query_593971, "quotaUser", newJString(quotaUser))
  add(query_593971, "alt", newJString(alt))
  add(query_593971, "oauth_token", newJString(oauthToken))
  add(query_593971, "callback", newJString(callback))
  add(query_593971, "access_token", newJString(accessToken))
  add(query_593971, "uploadType", newJString(uploadType))
  add(query_593971, "key", newJString(key))
  add(query_593971, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593972 = body
  add(query_593971, "prettyPrint", newJBool(prettyPrint))
  result = call_593970.call(nil, query_593971, nil, nil, body_593972)

var youtubereportingJobsCreate* = Call_YoutubereportingJobsCreate_593953(
    name: "youtubereportingJobsCreate", meth: HttpMethod.HttpPost,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs",
    validator: validate_YoutubereportingJobsCreate_593954, base: "/",
    url: url_YoutubereportingJobsCreate_593955, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsList_593677 = ref object of OpenApiRestCall_593408
proc url_YoutubereportingJobsList_593679(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubereportingJobsList_593678(path: JsonNode; query: JsonNode;
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
  var valid_593791 = query.getOrDefault("onBehalfOfContentOwner")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "onBehalfOfContentOwner", valid_593791
  var valid_593792 = query.getOrDefault("upload_protocol")
  valid_593792 = validateParameter(valid_593792, JString, required = false,
                                 default = nil)
  if valid_593792 != nil:
    section.add "upload_protocol", valid_593792
  var valid_593793 = query.getOrDefault("fields")
  valid_593793 = validateParameter(valid_593793, JString, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "fields", valid_593793
  var valid_593794 = query.getOrDefault("pageToken")
  valid_593794 = validateParameter(valid_593794, JString, required = false,
                                 default = nil)
  if valid_593794 != nil:
    section.add "pageToken", valid_593794
  var valid_593795 = query.getOrDefault("quotaUser")
  valid_593795 = validateParameter(valid_593795, JString, required = false,
                                 default = nil)
  if valid_593795 != nil:
    section.add "quotaUser", valid_593795
  var valid_593809 = query.getOrDefault("alt")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = newJString("json"))
  if valid_593809 != nil:
    section.add "alt", valid_593809
  var valid_593810 = query.getOrDefault("oauth_token")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "oauth_token", valid_593810
  var valid_593811 = query.getOrDefault("callback")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "callback", valid_593811
  var valid_593812 = query.getOrDefault("access_token")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "access_token", valid_593812
  var valid_593813 = query.getOrDefault("uploadType")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "uploadType", valid_593813
  var valid_593814 = query.getOrDefault("key")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "key", valid_593814
  var valid_593815 = query.getOrDefault("$.xgafv")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = newJString("1"))
  if valid_593815 != nil:
    section.add "$.xgafv", valid_593815
  var valid_593816 = query.getOrDefault("pageSize")
  valid_593816 = validateParameter(valid_593816, JInt, required = false, default = nil)
  if valid_593816 != nil:
    section.add "pageSize", valid_593816
  var valid_593817 = query.getOrDefault("includeSystemManaged")
  valid_593817 = validateParameter(valid_593817, JBool, required = false, default = nil)
  if valid_593817 != nil:
    section.add "includeSystemManaged", valid_593817
  var valid_593818 = query.getOrDefault("prettyPrint")
  valid_593818 = validateParameter(valid_593818, JBool, required = false,
                                 default = newJBool(true))
  if valid_593818 != nil:
    section.add "prettyPrint", valid_593818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593841: Call_YoutubereportingJobsList_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs.
  ## 
  let valid = call_593841.validator(path, query, header, formData, body)
  let scheme = call_593841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593841.url(scheme.get, call_593841.host, call_593841.base,
                         call_593841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593841, url, valid)

proc call*(call_593912: Call_YoutubereportingJobsList_593677;
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
  var query_593913 = newJObject()
  add(query_593913, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_593913, "upload_protocol", newJString(uploadProtocol))
  add(query_593913, "fields", newJString(fields))
  add(query_593913, "pageToken", newJString(pageToken))
  add(query_593913, "quotaUser", newJString(quotaUser))
  add(query_593913, "alt", newJString(alt))
  add(query_593913, "oauth_token", newJString(oauthToken))
  add(query_593913, "callback", newJString(callback))
  add(query_593913, "access_token", newJString(accessToken))
  add(query_593913, "uploadType", newJString(uploadType))
  add(query_593913, "key", newJString(key))
  add(query_593913, "$.xgafv", newJString(Xgafv))
  add(query_593913, "pageSize", newJInt(pageSize))
  add(query_593913, "includeSystemManaged", newJBool(includeSystemManaged))
  add(query_593913, "prettyPrint", newJBool(prettyPrint))
  result = call_593912.call(nil, query_593913, nil, nil, nil)

var youtubereportingJobsList* = Call_YoutubereportingJobsList_593677(
    name: "youtubereportingJobsList", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs",
    validator: validate_YoutubereportingJobsList_593678, base: "/",
    url: url_YoutubereportingJobsList_593679, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsGet_593973 = ref object of OpenApiRestCall_593408
proc url_YoutubereportingJobsGet_593975(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_YoutubereportingJobsGet_593974(path: JsonNode; query: JsonNode;
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
  var valid_593990 = path.getOrDefault("jobId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "jobId", valid_593990
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
  var valid_593991 = query.getOrDefault("onBehalfOfContentOwner")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "onBehalfOfContentOwner", valid_593991
  var valid_593992 = query.getOrDefault("upload_protocol")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "upload_protocol", valid_593992
  var valid_593993 = query.getOrDefault("fields")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "fields", valid_593993
  var valid_593994 = query.getOrDefault("quotaUser")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "quotaUser", valid_593994
  var valid_593995 = query.getOrDefault("alt")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = newJString("json"))
  if valid_593995 != nil:
    section.add "alt", valid_593995
  var valid_593996 = query.getOrDefault("oauth_token")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "oauth_token", valid_593996
  var valid_593997 = query.getOrDefault("callback")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "callback", valid_593997
  var valid_593998 = query.getOrDefault("access_token")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "access_token", valid_593998
  var valid_593999 = query.getOrDefault("uploadType")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "uploadType", valid_593999
  var valid_594000 = query.getOrDefault("key")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "key", valid_594000
  var valid_594001 = query.getOrDefault("$.xgafv")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = newJString("1"))
  if valid_594001 != nil:
    section.add "$.xgafv", valid_594001
  var valid_594002 = query.getOrDefault("prettyPrint")
  valid_594002 = validateParameter(valid_594002, JBool, required = false,
                                 default = newJBool(true))
  if valid_594002 != nil:
    section.add "prettyPrint", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_YoutubereportingJobsGet_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job.
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_YoutubereportingJobsGet_593973; jobId: string;
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
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  add(query_594006, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594006, "upload_protocol", newJString(uploadProtocol))
  add(query_594006, "fields", newJString(fields))
  add(query_594006, "quotaUser", newJString(quotaUser))
  add(query_594006, "alt", newJString(alt))
  add(path_594005, "jobId", newJString(jobId))
  add(query_594006, "oauth_token", newJString(oauthToken))
  add(query_594006, "callback", newJString(callback))
  add(query_594006, "access_token", newJString(accessToken))
  add(query_594006, "uploadType", newJString(uploadType))
  add(query_594006, "key", newJString(key))
  add(query_594006, "$.xgafv", newJString(Xgafv))
  add(query_594006, "prettyPrint", newJBool(prettyPrint))
  result = call_594004.call(path_594005, query_594006, nil, nil, nil)

var youtubereportingJobsGet* = Call_YoutubereportingJobsGet_593973(
    name: "youtubereportingJobsGet", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs/{jobId}",
    validator: validate_YoutubereportingJobsGet_593974, base: "/",
    url: url_YoutubereportingJobsGet_593975, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsDelete_594007 = ref object of OpenApiRestCall_593408
proc url_YoutubereportingJobsDelete_594009(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_YoutubereportingJobsDelete_594008(path: JsonNode; query: JsonNode;
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
  var valid_594010 = path.getOrDefault("jobId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "jobId", valid_594010
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
  var valid_594011 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "onBehalfOfContentOwner", valid_594011
  var valid_594012 = query.getOrDefault("upload_protocol")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "upload_protocol", valid_594012
  var valid_594013 = query.getOrDefault("fields")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "fields", valid_594013
  var valid_594014 = query.getOrDefault("quotaUser")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "quotaUser", valid_594014
  var valid_594015 = query.getOrDefault("alt")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = newJString("json"))
  if valid_594015 != nil:
    section.add "alt", valid_594015
  var valid_594016 = query.getOrDefault("oauth_token")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "oauth_token", valid_594016
  var valid_594017 = query.getOrDefault("callback")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "callback", valid_594017
  var valid_594018 = query.getOrDefault("access_token")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "access_token", valid_594018
  var valid_594019 = query.getOrDefault("uploadType")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "uploadType", valid_594019
  var valid_594020 = query.getOrDefault("key")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "key", valid_594020
  var valid_594021 = query.getOrDefault("$.xgafv")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = newJString("1"))
  if valid_594021 != nil:
    section.add "$.xgafv", valid_594021
  var valid_594022 = query.getOrDefault("prettyPrint")
  valid_594022 = validateParameter(valid_594022, JBool, required = false,
                                 default = newJBool(true))
  if valid_594022 != nil:
    section.add "prettyPrint", valid_594022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594023: Call_YoutubereportingJobsDelete_594007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job.
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_YoutubereportingJobsDelete_594007; jobId: string;
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
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  add(query_594026, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594026, "upload_protocol", newJString(uploadProtocol))
  add(query_594026, "fields", newJString(fields))
  add(query_594026, "quotaUser", newJString(quotaUser))
  add(query_594026, "alt", newJString(alt))
  add(path_594025, "jobId", newJString(jobId))
  add(query_594026, "oauth_token", newJString(oauthToken))
  add(query_594026, "callback", newJString(callback))
  add(query_594026, "access_token", newJString(accessToken))
  add(query_594026, "uploadType", newJString(uploadType))
  add(query_594026, "key", newJString(key))
  add(query_594026, "$.xgafv", newJString(Xgafv))
  add(query_594026, "prettyPrint", newJBool(prettyPrint))
  result = call_594024.call(path_594025, query_594026, nil, nil, nil)

var youtubereportingJobsDelete* = Call_YoutubereportingJobsDelete_594007(
    name: "youtubereportingJobsDelete", meth: HttpMethod.HttpDelete,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs/{jobId}",
    validator: validate_YoutubereportingJobsDelete_594008, base: "/",
    url: url_YoutubereportingJobsDelete_594009, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsReportsList_594027 = ref object of OpenApiRestCall_593408
proc url_YoutubereportingJobsReportsList_594029(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_YoutubereportingJobsReportsList_594028(path: JsonNode;
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
  var valid_594030 = path.getOrDefault("jobId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "jobId", valid_594030
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
  var valid_594031 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "onBehalfOfContentOwner", valid_594031
  var valid_594032 = query.getOrDefault("upload_protocol")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "upload_protocol", valid_594032
  var valid_594033 = query.getOrDefault("fields")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "fields", valid_594033
  var valid_594034 = query.getOrDefault("pageToken")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "pageToken", valid_594034
  var valid_594035 = query.getOrDefault("quotaUser")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "quotaUser", valid_594035
  var valid_594036 = query.getOrDefault("alt")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = newJString("json"))
  if valid_594036 != nil:
    section.add "alt", valid_594036
  var valid_594037 = query.getOrDefault("createdAfter")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "createdAfter", valid_594037
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
  var valid_594042 = query.getOrDefault("startTimeAtOrAfter")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "startTimeAtOrAfter", valid_594042
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
  var valid_594045 = query.getOrDefault("pageSize")
  valid_594045 = validateParameter(valid_594045, JInt, required = false, default = nil)
  if valid_594045 != nil:
    section.add "pageSize", valid_594045
  var valid_594046 = query.getOrDefault("prettyPrint")
  valid_594046 = validateParameter(valid_594046, JBool, required = false,
                                 default = newJBool(true))
  if valid_594046 != nil:
    section.add "prettyPrint", valid_594046
  var valid_594047 = query.getOrDefault("startTimeBefore")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "startTimeBefore", valid_594047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594048: Call_YoutubereportingJobsReportsList_594027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists reports created by a specific job.
  ## Returns NOT_FOUND if the job does not exist.
  ## 
  let valid = call_594048.validator(path, query, header, formData, body)
  let scheme = call_594048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594048.url(scheme.get, call_594048.host, call_594048.base,
                         call_594048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594048, url, valid)

proc call*(call_594049: Call_YoutubereportingJobsReportsList_594027; jobId: string;
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
  var path_594050 = newJObject()
  var query_594051 = newJObject()
  add(query_594051, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594051, "upload_protocol", newJString(uploadProtocol))
  add(query_594051, "fields", newJString(fields))
  add(query_594051, "pageToken", newJString(pageToken))
  add(query_594051, "quotaUser", newJString(quotaUser))
  add(query_594051, "alt", newJString(alt))
  add(query_594051, "createdAfter", newJString(createdAfter))
  add(path_594050, "jobId", newJString(jobId))
  add(query_594051, "oauth_token", newJString(oauthToken))
  add(query_594051, "callback", newJString(callback))
  add(query_594051, "access_token", newJString(accessToken))
  add(query_594051, "uploadType", newJString(uploadType))
  add(query_594051, "startTimeAtOrAfter", newJString(startTimeAtOrAfter))
  add(query_594051, "key", newJString(key))
  add(query_594051, "$.xgafv", newJString(Xgafv))
  add(query_594051, "pageSize", newJInt(pageSize))
  add(query_594051, "prettyPrint", newJBool(prettyPrint))
  add(query_594051, "startTimeBefore", newJString(startTimeBefore))
  result = call_594049.call(path_594050, query_594051, nil, nil, nil)

var youtubereportingJobsReportsList* = Call_YoutubereportingJobsReportsList_594027(
    name: "youtubereportingJobsReportsList", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs/{jobId}/reports",
    validator: validate_YoutubereportingJobsReportsList_594028, base: "/",
    url: url_YoutubereportingJobsReportsList_594029, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsReportsGet_594052 = ref object of OpenApiRestCall_593408
proc url_YoutubereportingJobsReportsGet_594054(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_YoutubereportingJobsReportsGet_594053(path: JsonNode;
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
  var valid_594055 = path.getOrDefault("jobId")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "jobId", valid_594055
  var valid_594056 = path.getOrDefault("reportId")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "reportId", valid_594056
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
  var valid_594057 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "onBehalfOfContentOwner", valid_594057
  var valid_594058 = query.getOrDefault("upload_protocol")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "upload_protocol", valid_594058
  var valid_594059 = query.getOrDefault("fields")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "fields", valid_594059
  var valid_594060 = query.getOrDefault("quotaUser")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "quotaUser", valid_594060
  var valid_594061 = query.getOrDefault("alt")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = newJString("json"))
  if valid_594061 != nil:
    section.add "alt", valid_594061
  var valid_594062 = query.getOrDefault("oauth_token")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "oauth_token", valid_594062
  var valid_594063 = query.getOrDefault("callback")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "callback", valid_594063
  var valid_594064 = query.getOrDefault("access_token")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "access_token", valid_594064
  var valid_594065 = query.getOrDefault("uploadType")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "uploadType", valid_594065
  var valid_594066 = query.getOrDefault("key")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "key", valid_594066
  var valid_594067 = query.getOrDefault("$.xgafv")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = newJString("1"))
  if valid_594067 != nil:
    section.add "$.xgafv", valid_594067
  var valid_594068 = query.getOrDefault("prettyPrint")
  valid_594068 = validateParameter(valid_594068, JBool, required = false,
                                 default = newJBool(true))
  if valid_594068 != nil:
    section.add "prettyPrint", valid_594068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594069: Call_YoutubereportingJobsReportsGet_594052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metadata of a specific report.
  ## 
  let valid = call_594069.validator(path, query, header, formData, body)
  let scheme = call_594069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594069.url(scheme.get, call_594069.host, call_594069.base,
                         call_594069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594069, url, valid)

proc call*(call_594070: Call_YoutubereportingJobsReportsGet_594052; jobId: string;
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
  var path_594071 = newJObject()
  var query_594072 = newJObject()
  add(query_594072, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594072, "upload_protocol", newJString(uploadProtocol))
  add(query_594072, "fields", newJString(fields))
  add(query_594072, "quotaUser", newJString(quotaUser))
  add(query_594072, "alt", newJString(alt))
  add(path_594071, "jobId", newJString(jobId))
  add(query_594072, "oauth_token", newJString(oauthToken))
  add(query_594072, "callback", newJString(callback))
  add(query_594072, "access_token", newJString(accessToken))
  add(query_594072, "uploadType", newJString(uploadType))
  add(query_594072, "key", newJString(key))
  add(query_594072, "$.xgafv", newJString(Xgafv))
  add(path_594071, "reportId", newJString(reportId))
  add(query_594072, "prettyPrint", newJBool(prettyPrint))
  result = call_594070.call(path_594071, query_594072, nil, nil, nil)

var youtubereportingJobsReportsGet* = Call_YoutubereportingJobsReportsGet_594052(
    name: "youtubereportingJobsReportsGet", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com",
    route: "/v1/jobs/{jobId}/reports/{reportId}",
    validator: validate_YoutubereportingJobsReportsGet_594053, base: "/",
    url: url_YoutubereportingJobsReportsGet_594054, schemes: {Scheme.Https})
type
  Call_YoutubereportingMediaDownload_594073 = ref object of OpenApiRestCall_593408
proc url_YoutubereportingMediaDownload_594075(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/media/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_YoutubereportingMediaDownload_594074(path: JsonNode; query: JsonNode;
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
  var valid_594076 = path.getOrDefault("resourceName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "resourceName", valid_594076
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
  var valid_594077 = query.getOrDefault("upload_protocol")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "upload_protocol", valid_594077
  var valid_594078 = query.getOrDefault("fields")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "fields", valid_594078
  var valid_594079 = query.getOrDefault("quotaUser")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "quotaUser", valid_594079
  var valid_594080 = query.getOrDefault("alt")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = newJString("json"))
  if valid_594080 != nil:
    section.add "alt", valid_594080
  var valid_594081 = query.getOrDefault("oauth_token")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "oauth_token", valid_594081
  var valid_594082 = query.getOrDefault("callback")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "callback", valid_594082
  var valid_594083 = query.getOrDefault("access_token")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "access_token", valid_594083
  var valid_594084 = query.getOrDefault("uploadType")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "uploadType", valid_594084
  var valid_594085 = query.getOrDefault("key")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "key", valid_594085
  var valid_594086 = query.getOrDefault("$.xgafv")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = newJString("1"))
  if valid_594086 != nil:
    section.add "$.xgafv", valid_594086
  var valid_594087 = query.getOrDefault("prettyPrint")
  valid_594087 = validateParameter(valid_594087, JBool, required = false,
                                 default = newJBool(true))
  if valid_594087 != nil:
    section.add "prettyPrint", valid_594087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594088: Call_YoutubereportingMediaDownload_594073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Method for media download. Download is supported
  ## on the URI `/v1/media/{+name}?alt=media`.
  ## 
  let valid = call_594088.validator(path, query, header, formData, body)
  let scheme = call_594088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594088.url(scheme.get, call_594088.host, call_594088.base,
                         call_594088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594088, url, valid)

proc call*(call_594089: Call_YoutubereportingMediaDownload_594073;
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
  var path_594090 = newJObject()
  var query_594091 = newJObject()
  add(query_594091, "upload_protocol", newJString(uploadProtocol))
  add(query_594091, "fields", newJString(fields))
  add(query_594091, "quotaUser", newJString(quotaUser))
  add(query_594091, "alt", newJString(alt))
  add(query_594091, "oauth_token", newJString(oauthToken))
  add(query_594091, "callback", newJString(callback))
  add(query_594091, "access_token", newJString(accessToken))
  add(query_594091, "uploadType", newJString(uploadType))
  add(path_594090, "resourceName", newJString(resourceName))
  add(query_594091, "key", newJString(key))
  add(query_594091, "$.xgafv", newJString(Xgafv))
  add(query_594091, "prettyPrint", newJBool(prettyPrint))
  result = call_594089.call(path_594090, query_594091, nil, nil, nil)

var youtubereportingMediaDownload* = Call_YoutubereportingMediaDownload_594073(
    name: "youtubereportingMediaDownload", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/media/{resourceName}",
    validator: validate_YoutubereportingMediaDownload_594074, base: "/",
    url: url_YoutubereportingMediaDownload_594075, schemes: {Scheme.Https})
type
  Call_YoutubereportingReportTypesList_594092 = ref object of OpenApiRestCall_593408
proc url_YoutubereportingReportTypesList_594094(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubereportingReportTypesList_594093(path: JsonNode;
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
  var valid_594095 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "onBehalfOfContentOwner", valid_594095
  var valid_594096 = query.getOrDefault("upload_protocol")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "upload_protocol", valid_594096
  var valid_594097 = query.getOrDefault("fields")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "fields", valid_594097
  var valid_594098 = query.getOrDefault("pageToken")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "pageToken", valid_594098
  var valid_594099 = query.getOrDefault("quotaUser")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "quotaUser", valid_594099
  var valid_594100 = query.getOrDefault("alt")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = newJString("json"))
  if valid_594100 != nil:
    section.add "alt", valid_594100
  var valid_594101 = query.getOrDefault("oauth_token")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "oauth_token", valid_594101
  var valid_594102 = query.getOrDefault("callback")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "callback", valid_594102
  var valid_594103 = query.getOrDefault("access_token")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "access_token", valid_594103
  var valid_594104 = query.getOrDefault("uploadType")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "uploadType", valid_594104
  var valid_594105 = query.getOrDefault("key")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "key", valid_594105
  var valid_594106 = query.getOrDefault("$.xgafv")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = newJString("1"))
  if valid_594106 != nil:
    section.add "$.xgafv", valid_594106
  var valid_594107 = query.getOrDefault("pageSize")
  valid_594107 = validateParameter(valid_594107, JInt, required = false, default = nil)
  if valid_594107 != nil:
    section.add "pageSize", valid_594107
  var valid_594108 = query.getOrDefault("includeSystemManaged")
  valid_594108 = validateParameter(valid_594108, JBool, required = false, default = nil)
  if valid_594108 != nil:
    section.add "includeSystemManaged", valid_594108
  var valid_594109 = query.getOrDefault("prettyPrint")
  valid_594109 = validateParameter(valid_594109, JBool, required = false,
                                 default = newJBool(true))
  if valid_594109 != nil:
    section.add "prettyPrint", valid_594109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594110: Call_YoutubereportingReportTypesList_594092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists report types.
  ## 
  let valid = call_594110.validator(path, query, header, formData, body)
  let scheme = call_594110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594110.url(scheme.get, call_594110.host, call_594110.base,
                         call_594110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594110, url, valid)

proc call*(call_594111: Call_YoutubereportingReportTypesList_594092;
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
  var query_594112 = newJObject()
  add(query_594112, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594112, "upload_protocol", newJString(uploadProtocol))
  add(query_594112, "fields", newJString(fields))
  add(query_594112, "pageToken", newJString(pageToken))
  add(query_594112, "quotaUser", newJString(quotaUser))
  add(query_594112, "alt", newJString(alt))
  add(query_594112, "oauth_token", newJString(oauthToken))
  add(query_594112, "callback", newJString(callback))
  add(query_594112, "access_token", newJString(accessToken))
  add(query_594112, "uploadType", newJString(uploadType))
  add(query_594112, "key", newJString(key))
  add(query_594112, "$.xgafv", newJString(Xgafv))
  add(query_594112, "pageSize", newJInt(pageSize))
  add(query_594112, "includeSystemManaged", newJBool(includeSystemManaged))
  add(query_594112, "prettyPrint", newJBool(prettyPrint))
  result = call_594111.call(nil, query_594112, nil, nil, nil)

var youtubereportingReportTypesList* = Call_YoutubereportingReportTypesList_594092(
    name: "youtubereportingReportTypesList", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/reportTypes",
    validator: validate_YoutubereportingReportTypesList_594093, base: "/",
    url: url_YoutubereportingReportTypesList_594094, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
