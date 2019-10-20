
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "youtubereporting"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_YoutubereportingJobsCreate_578886 = ref object of OpenApiRestCall_578339
proc url_YoutubereportingJobsCreate_578888(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubereportingJobsCreate_578887(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a job and returns it.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   onBehalfOfContentOwner: JString
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
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
  var valid_578889 = query.getOrDefault("key")
  valid_578889 = validateParameter(valid_578889, JString, required = false,
                                 default = nil)
  if valid_578889 != nil:
    section.add "key", valid_578889
  var valid_578890 = query.getOrDefault("prettyPrint")
  valid_578890 = validateParameter(valid_578890, JBool, required = false,
                                 default = newJBool(true))
  if valid_578890 != nil:
    section.add "prettyPrint", valid_578890
  var valid_578891 = query.getOrDefault("oauth_token")
  valid_578891 = validateParameter(valid_578891, JString, required = false,
                                 default = nil)
  if valid_578891 != nil:
    section.add "oauth_token", valid_578891
  var valid_578892 = query.getOrDefault("$.xgafv")
  valid_578892 = validateParameter(valid_578892, JString, required = false,
                                 default = newJString("1"))
  if valid_578892 != nil:
    section.add "$.xgafv", valid_578892
  var valid_578893 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578893 = validateParameter(valid_578893, JString, required = false,
                                 default = nil)
  if valid_578893 != nil:
    section.add "onBehalfOfContentOwner", valid_578893
  var valid_578894 = query.getOrDefault("alt")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = newJString("json"))
  if valid_578894 != nil:
    section.add "alt", valid_578894
  var valid_578895 = query.getOrDefault("uploadType")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "uploadType", valid_578895
  var valid_578896 = query.getOrDefault("quotaUser")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "quotaUser", valid_578896
  var valid_578897 = query.getOrDefault("callback")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "callback", valid_578897
  var valid_578898 = query.getOrDefault("fields")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "fields", valid_578898
  var valid_578899 = query.getOrDefault("access_token")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "access_token", valid_578899
  var valid_578900 = query.getOrDefault("upload_protocol")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "upload_protocol", valid_578900
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

proc call*(call_578902: Call_YoutubereportingJobsCreate_578886; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job and returns it.
  ## 
  let valid = call_578902.validator(path, query, header, formData, body)
  let scheme = call_578902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578902.url(scheme.get, call_578902.host, call_578902.base,
                         call_578902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578902, url, valid)

proc call*(call_578903: Call_YoutubereportingJobsCreate_578886; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## youtubereportingJobsCreate
  ## Creates a job and returns it.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   onBehalfOfContentOwner: string
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
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
  var query_578904 = newJObject()
  var body_578905 = newJObject()
  add(query_578904, "key", newJString(key))
  add(query_578904, "prettyPrint", newJBool(prettyPrint))
  add(query_578904, "oauth_token", newJString(oauthToken))
  add(query_578904, "$.xgafv", newJString(Xgafv))
  add(query_578904, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578904, "alt", newJString(alt))
  add(query_578904, "uploadType", newJString(uploadType))
  add(query_578904, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578905 = body
  add(query_578904, "callback", newJString(callback))
  add(query_578904, "fields", newJString(fields))
  add(query_578904, "access_token", newJString(accessToken))
  add(query_578904, "upload_protocol", newJString(uploadProtocol))
  result = call_578903.call(nil, query_578904, nil, nil, body_578905)

var youtubereportingJobsCreate* = Call_YoutubereportingJobsCreate_578886(
    name: "youtubereportingJobsCreate", meth: HttpMethod.HttpPost,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs",
    validator: validate_YoutubereportingJobsCreate_578887, base: "/",
    url: url_YoutubereportingJobsCreate_578888, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsList_578610 = ref object of OpenApiRestCall_578339
proc url_YoutubereportingJobsList_578612(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubereportingJobsList_578611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists jobs.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##           : Requested page size. Server may return fewer jobs than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   onBehalfOfContentOwner: JString
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of
  ## ListReportTypesResponse.next_page_token
  ## returned in response to the previous call to the `ListJobs` method.
  ##   includeSystemManaged: JBool
  ##                       : If set to true, also system-managed jobs will be returned; otherwise only
  ## user-created jobs will be returned. System-managed jobs can neither be
  ## modified nor deleted.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("prettyPrint")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "prettyPrint", valid_578738
  var valid_578739 = query.getOrDefault("oauth_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "oauth_token", valid_578739
  var valid_578740 = query.getOrDefault("$.xgafv")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = newJString("1"))
  if valid_578740 != nil:
    section.add "$.xgafv", valid_578740
  var valid_578741 = query.getOrDefault("pageSize")
  valid_578741 = validateParameter(valid_578741, JInt, required = false, default = nil)
  if valid_578741 != nil:
    section.add "pageSize", valid_578741
  var valid_578742 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = nil)
  if valid_578742 != nil:
    section.add "onBehalfOfContentOwner", valid_578742
  var valid_578743 = query.getOrDefault("alt")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = newJString("json"))
  if valid_578743 != nil:
    section.add "alt", valid_578743
  var valid_578744 = query.getOrDefault("uploadType")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "uploadType", valid_578744
  var valid_578745 = query.getOrDefault("quotaUser")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "quotaUser", valid_578745
  var valid_578746 = query.getOrDefault("pageToken")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "pageToken", valid_578746
  var valid_578747 = query.getOrDefault("includeSystemManaged")
  valid_578747 = validateParameter(valid_578747, JBool, required = false, default = nil)
  if valid_578747 != nil:
    section.add "includeSystemManaged", valid_578747
  var valid_578748 = query.getOrDefault("callback")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "callback", valid_578748
  var valid_578749 = query.getOrDefault("fields")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "fields", valid_578749
  var valid_578750 = query.getOrDefault("access_token")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "access_token", valid_578750
  var valid_578751 = query.getOrDefault("upload_protocol")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "upload_protocol", valid_578751
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578774: Call_YoutubereportingJobsList_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs.
  ## 
  let valid = call_578774.validator(path, query, header, formData, body)
  let scheme = call_578774.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578774.url(scheme.get, call_578774.host, call_578774.base,
                         call_578774.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578774, url, valid)

proc call*(call_578845: Call_YoutubereportingJobsList_578610; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; onBehalfOfContentOwner: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          includeSystemManaged: bool = false; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## youtubereportingJobsList
  ## Lists jobs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer jobs than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   onBehalfOfContentOwner: string
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of
  ## ListReportTypesResponse.next_page_token
  ## returned in response to the previous call to the `ListJobs` method.
  ##   includeSystemManaged: bool
  ##                       : If set to true, also system-managed jobs will be returned; otherwise only
  ## user-created jobs will be returned. System-managed jobs can neither be
  ## modified nor deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578846 = newJObject()
  add(query_578846, "key", newJString(key))
  add(query_578846, "prettyPrint", newJBool(prettyPrint))
  add(query_578846, "oauth_token", newJString(oauthToken))
  add(query_578846, "$.xgafv", newJString(Xgafv))
  add(query_578846, "pageSize", newJInt(pageSize))
  add(query_578846, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578846, "alt", newJString(alt))
  add(query_578846, "uploadType", newJString(uploadType))
  add(query_578846, "quotaUser", newJString(quotaUser))
  add(query_578846, "pageToken", newJString(pageToken))
  add(query_578846, "includeSystemManaged", newJBool(includeSystemManaged))
  add(query_578846, "callback", newJString(callback))
  add(query_578846, "fields", newJString(fields))
  add(query_578846, "access_token", newJString(accessToken))
  add(query_578846, "upload_protocol", newJString(uploadProtocol))
  result = call_578845.call(nil, query_578846, nil, nil, nil)

var youtubereportingJobsList* = Call_YoutubereportingJobsList_578610(
    name: "youtubereportingJobsList", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs",
    validator: validate_YoutubereportingJobsList_578611, base: "/",
    url: url_YoutubereportingJobsList_578612, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsGet_578906 = ref object of OpenApiRestCall_578339
proc url_YoutubereportingJobsGet_578908(protocol: Scheme; host: string; base: string;
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

proc validate_YoutubereportingJobsGet_578907(path: JsonNode; query: JsonNode;
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
  var valid_578923 = path.getOrDefault("jobId")
  valid_578923 = validateParameter(valid_578923, JString, required = true,
                                 default = nil)
  if valid_578923 != nil:
    section.add "jobId", valid_578923
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
  ##   onBehalfOfContentOwner: JString
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
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
  var valid_578924 = query.getOrDefault("key")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "key", valid_578924
  var valid_578925 = query.getOrDefault("prettyPrint")
  valid_578925 = validateParameter(valid_578925, JBool, required = false,
                                 default = newJBool(true))
  if valid_578925 != nil:
    section.add "prettyPrint", valid_578925
  var valid_578926 = query.getOrDefault("oauth_token")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "oauth_token", valid_578926
  var valid_578927 = query.getOrDefault("$.xgafv")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = newJString("1"))
  if valid_578927 != nil:
    section.add "$.xgafv", valid_578927
  var valid_578928 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "onBehalfOfContentOwner", valid_578928
  var valid_578929 = query.getOrDefault("alt")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = newJString("json"))
  if valid_578929 != nil:
    section.add "alt", valid_578929
  var valid_578930 = query.getOrDefault("uploadType")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "uploadType", valid_578930
  var valid_578931 = query.getOrDefault("quotaUser")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "quotaUser", valid_578931
  var valid_578932 = query.getOrDefault("callback")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "callback", valid_578932
  var valid_578933 = query.getOrDefault("fields")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "fields", valid_578933
  var valid_578934 = query.getOrDefault("access_token")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "access_token", valid_578934
  var valid_578935 = query.getOrDefault("upload_protocol")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "upload_protocol", valid_578935
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578936: Call_YoutubereportingJobsGet_578906; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a job.
  ## 
  let valid = call_578936.validator(path, query, header, formData, body)
  let scheme = call_578936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578936.url(scheme.get, call_578936.host, call_578936.base,
                         call_578936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578936, url, valid)

proc call*(call_578937: Call_YoutubereportingJobsGet_578906; jobId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; onBehalfOfContentOwner: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## youtubereportingJobsGet
  ## Gets a job.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   jobId: string (required)
  ##        : The ID of the job to retrieve.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   onBehalfOfContentOwner: string
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578938 = newJObject()
  var query_578939 = newJObject()
  add(query_578939, "key", newJString(key))
  add(query_578939, "prettyPrint", newJBool(prettyPrint))
  add(query_578939, "oauth_token", newJString(oauthToken))
  add(path_578938, "jobId", newJString(jobId))
  add(query_578939, "$.xgafv", newJString(Xgafv))
  add(query_578939, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578939, "alt", newJString(alt))
  add(query_578939, "uploadType", newJString(uploadType))
  add(query_578939, "quotaUser", newJString(quotaUser))
  add(query_578939, "callback", newJString(callback))
  add(query_578939, "fields", newJString(fields))
  add(query_578939, "access_token", newJString(accessToken))
  add(query_578939, "upload_protocol", newJString(uploadProtocol))
  result = call_578937.call(path_578938, query_578939, nil, nil, nil)

var youtubereportingJobsGet* = Call_YoutubereportingJobsGet_578906(
    name: "youtubereportingJobsGet", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs/{jobId}",
    validator: validate_YoutubereportingJobsGet_578907, base: "/",
    url: url_YoutubereportingJobsGet_578908, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsDelete_578940 = ref object of OpenApiRestCall_578339
proc url_YoutubereportingJobsDelete_578942(protocol: Scheme; host: string;
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

proc validate_YoutubereportingJobsDelete_578941(path: JsonNode; query: JsonNode;
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
  var valid_578943 = path.getOrDefault("jobId")
  valid_578943 = validateParameter(valid_578943, JString, required = true,
                                 default = nil)
  if valid_578943 != nil:
    section.add "jobId", valid_578943
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
  ##   onBehalfOfContentOwner: JString
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
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
  var valid_578944 = query.getOrDefault("key")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "key", valid_578944
  var valid_578945 = query.getOrDefault("prettyPrint")
  valid_578945 = validateParameter(valid_578945, JBool, required = false,
                                 default = newJBool(true))
  if valid_578945 != nil:
    section.add "prettyPrint", valid_578945
  var valid_578946 = query.getOrDefault("oauth_token")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "oauth_token", valid_578946
  var valid_578947 = query.getOrDefault("$.xgafv")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = newJString("1"))
  if valid_578947 != nil:
    section.add "$.xgafv", valid_578947
  var valid_578948 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "onBehalfOfContentOwner", valid_578948
  var valid_578949 = query.getOrDefault("alt")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("json"))
  if valid_578949 != nil:
    section.add "alt", valid_578949
  var valid_578950 = query.getOrDefault("uploadType")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "uploadType", valid_578950
  var valid_578951 = query.getOrDefault("quotaUser")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "quotaUser", valid_578951
  var valid_578952 = query.getOrDefault("callback")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "callback", valid_578952
  var valid_578953 = query.getOrDefault("fields")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "fields", valid_578953
  var valid_578954 = query.getOrDefault("access_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "access_token", valid_578954
  var valid_578955 = query.getOrDefault("upload_protocol")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "upload_protocol", valid_578955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578956: Call_YoutubereportingJobsDelete_578940; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a job.
  ## 
  let valid = call_578956.validator(path, query, header, formData, body)
  let scheme = call_578956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578956.url(scheme.get, call_578956.host, call_578956.base,
                         call_578956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578956, url, valid)

proc call*(call_578957: Call_YoutubereportingJobsDelete_578940; jobId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; onBehalfOfContentOwner: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## youtubereportingJobsDelete
  ## Deletes a job.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   jobId: string (required)
  ##        : The ID of the job to delete.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   onBehalfOfContentOwner: string
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578958 = newJObject()
  var query_578959 = newJObject()
  add(query_578959, "key", newJString(key))
  add(query_578959, "prettyPrint", newJBool(prettyPrint))
  add(query_578959, "oauth_token", newJString(oauthToken))
  add(path_578958, "jobId", newJString(jobId))
  add(query_578959, "$.xgafv", newJString(Xgafv))
  add(query_578959, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578959, "alt", newJString(alt))
  add(query_578959, "uploadType", newJString(uploadType))
  add(query_578959, "quotaUser", newJString(quotaUser))
  add(query_578959, "callback", newJString(callback))
  add(query_578959, "fields", newJString(fields))
  add(query_578959, "access_token", newJString(accessToken))
  add(query_578959, "upload_protocol", newJString(uploadProtocol))
  result = call_578957.call(path_578958, query_578959, nil, nil, nil)

var youtubereportingJobsDelete* = Call_YoutubereportingJobsDelete_578940(
    name: "youtubereportingJobsDelete", meth: HttpMethod.HttpDelete,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs/{jobId}",
    validator: validate_YoutubereportingJobsDelete_578941, base: "/",
    url: url_YoutubereportingJobsDelete_578942, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsReportsList_578960 = ref object of OpenApiRestCall_578339
proc url_YoutubereportingJobsReportsList_578962(protocol: Scheme; host: string;
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

proc validate_YoutubereportingJobsReportsList_578961(path: JsonNode;
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
  var valid_578963 = path.getOrDefault("jobId")
  valid_578963 = validateParameter(valid_578963, JString, required = true,
                                 default = nil)
  if valid_578963 != nil:
    section.add "jobId", valid_578963
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
  ##           : Requested page size. Server may return fewer report types than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   onBehalfOfContentOwner: JString
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   createdAfter: JString
  ##               : If set, only reports created after the specified date/time are returned.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of
  ## ListReportsResponse.next_page_token
  ## returned in response to the previous call to the `ListReports` method.
  ##   startTimeAtOrAfter: JString
  ##                     : If set, only reports whose start time is greater than or equal the
  ## specified date/time are returned.
  ##   startTimeBefore: JString
  ##                  : If set, only reports whose start time is smaller than the specified
  ## date/time are returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578964 = query.getOrDefault("key")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "key", valid_578964
  var valid_578965 = query.getOrDefault("prettyPrint")
  valid_578965 = validateParameter(valid_578965, JBool, required = false,
                                 default = newJBool(true))
  if valid_578965 != nil:
    section.add "prettyPrint", valid_578965
  var valid_578966 = query.getOrDefault("oauth_token")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "oauth_token", valid_578966
  var valid_578967 = query.getOrDefault("$.xgafv")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = newJString("1"))
  if valid_578967 != nil:
    section.add "$.xgafv", valid_578967
  var valid_578968 = query.getOrDefault("pageSize")
  valid_578968 = validateParameter(valid_578968, JInt, required = false, default = nil)
  if valid_578968 != nil:
    section.add "pageSize", valid_578968
  var valid_578969 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "onBehalfOfContentOwner", valid_578969
  var valid_578970 = query.getOrDefault("alt")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = newJString("json"))
  if valid_578970 != nil:
    section.add "alt", valid_578970
  var valid_578971 = query.getOrDefault("uploadType")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "uploadType", valid_578971
  var valid_578972 = query.getOrDefault("createdAfter")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "createdAfter", valid_578972
  var valid_578973 = query.getOrDefault("quotaUser")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "quotaUser", valid_578973
  var valid_578974 = query.getOrDefault("pageToken")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "pageToken", valid_578974
  var valid_578975 = query.getOrDefault("startTimeAtOrAfter")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "startTimeAtOrAfter", valid_578975
  var valid_578976 = query.getOrDefault("startTimeBefore")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "startTimeBefore", valid_578976
  var valid_578977 = query.getOrDefault("callback")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "callback", valid_578977
  var valid_578978 = query.getOrDefault("fields")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "fields", valid_578978
  var valid_578979 = query.getOrDefault("access_token")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "access_token", valid_578979
  var valid_578980 = query.getOrDefault("upload_protocol")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "upload_protocol", valid_578980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578981: Call_YoutubereportingJobsReportsList_578960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists reports created by a specific job.
  ## Returns NOT_FOUND if the job does not exist.
  ## 
  let valid = call_578981.validator(path, query, header, formData, body)
  let scheme = call_578981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578981.url(scheme.get, call_578981.host, call_578981.base,
                         call_578981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578981, url, valid)

proc call*(call_578982: Call_YoutubereportingJobsReportsList_578960; jobId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; onBehalfOfContentOwner: string = "";
          alt: string = "json"; uploadType: string = ""; createdAfter: string = "";
          quotaUser: string = ""; pageToken: string = "";
          startTimeAtOrAfter: string = ""; startTimeBefore: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## youtubereportingJobsReportsList
  ## Lists reports created by a specific job.
  ## Returns NOT_FOUND if the job does not exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   jobId: string (required)
  ##        : The ID of the job.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer report types than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   onBehalfOfContentOwner: string
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   createdAfter: string
  ##               : If set, only reports created after the specified date/time are returned.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of
  ## ListReportsResponse.next_page_token
  ## returned in response to the previous call to the `ListReports` method.
  ##   startTimeAtOrAfter: string
  ##                     : If set, only reports whose start time is greater than or equal the
  ## specified date/time are returned.
  ##   startTimeBefore: string
  ##                  : If set, only reports whose start time is smaller than the specified
  ## date/time are returned.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578983 = newJObject()
  var query_578984 = newJObject()
  add(query_578984, "key", newJString(key))
  add(query_578984, "prettyPrint", newJBool(prettyPrint))
  add(query_578984, "oauth_token", newJString(oauthToken))
  add(path_578983, "jobId", newJString(jobId))
  add(query_578984, "$.xgafv", newJString(Xgafv))
  add(query_578984, "pageSize", newJInt(pageSize))
  add(query_578984, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578984, "alt", newJString(alt))
  add(query_578984, "uploadType", newJString(uploadType))
  add(query_578984, "createdAfter", newJString(createdAfter))
  add(query_578984, "quotaUser", newJString(quotaUser))
  add(query_578984, "pageToken", newJString(pageToken))
  add(query_578984, "startTimeAtOrAfter", newJString(startTimeAtOrAfter))
  add(query_578984, "startTimeBefore", newJString(startTimeBefore))
  add(query_578984, "callback", newJString(callback))
  add(query_578984, "fields", newJString(fields))
  add(query_578984, "access_token", newJString(accessToken))
  add(query_578984, "upload_protocol", newJString(uploadProtocol))
  result = call_578982.call(path_578983, query_578984, nil, nil, nil)

var youtubereportingJobsReportsList* = Call_YoutubereportingJobsReportsList_578960(
    name: "youtubereportingJobsReportsList", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/jobs/{jobId}/reports",
    validator: validate_YoutubereportingJobsReportsList_578961, base: "/",
    url: url_YoutubereportingJobsReportsList_578962, schemes: {Scheme.Https})
type
  Call_YoutubereportingJobsReportsGet_578985 = ref object of OpenApiRestCall_578339
proc url_YoutubereportingJobsReportsGet_578987(protocol: Scheme; host: string;
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

proc validate_YoutubereportingJobsReportsGet_578986(path: JsonNode;
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
  var valid_578988 = path.getOrDefault("jobId")
  valid_578988 = validateParameter(valid_578988, JString, required = true,
                                 default = nil)
  if valid_578988 != nil:
    section.add "jobId", valid_578988
  var valid_578989 = path.getOrDefault("reportId")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "reportId", valid_578989
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
  ##   onBehalfOfContentOwner: JString
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
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
  var valid_578990 = query.getOrDefault("key")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "key", valid_578990
  var valid_578991 = query.getOrDefault("prettyPrint")
  valid_578991 = validateParameter(valid_578991, JBool, required = false,
                                 default = newJBool(true))
  if valid_578991 != nil:
    section.add "prettyPrint", valid_578991
  var valid_578992 = query.getOrDefault("oauth_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "oauth_token", valid_578992
  var valid_578993 = query.getOrDefault("$.xgafv")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("1"))
  if valid_578993 != nil:
    section.add "$.xgafv", valid_578993
  var valid_578994 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "onBehalfOfContentOwner", valid_578994
  var valid_578995 = query.getOrDefault("alt")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = newJString("json"))
  if valid_578995 != nil:
    section.add "alt", valid_578995
  var valid_578996 = query.getOrDefault("uploadType")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "uploadType", valid_578996
  var valid_578997 = query.getOrDefault("quotaUser")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "quotaUser", valid_578997
  var valid_578998 = query.getOrDefault("callback")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "callback", valid_578998
  var valid_578999 = query.getOrDefault("fields")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "fields", valid_578999
  var valid_579000 = query.getOrDefault("access_token")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "access_token", valid_579000
  var valid_579001 = query.getOrDefault("upload_protocol")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "upload_protocol", valid_579001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579002: Call_YoutubereportingJobsReportsGet_578985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the metadata of a specific report.
  ## 
  let valid = call_579002.validator(path, query, header, formData, body)
  let scheme = call_579002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579002.url(scheme.get, call_579002.host, call_579002.base,
                         call_579002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579002, url, valid)

proc call*(call_579003: Call_YoutubereportingJobsReportsGet_578985; jobId: string;
          reportId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## youtubereportingJobsReportsGet
  ## Gets the metadata of a specific report.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   jobId: string (required)
  ##        : The ID of the job.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   onBehalfOfContentOwner: string
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   reportId: string (required)
  ##           : The ID of the report to retrieve.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579004 = newJObject()
  var query_579005 = newJObject()
  add(query_579005, "key", newJString(key))
  add(query_579005, "prettyPrint", newJBool(prettyPrint))
  add(query_579005, "oauth_token", newJString(oauthToken))
  add(path_579004, "jobId", newJString(jobId))
  add(query_579005, "$.xgafv", newJString(Xgafv))
  add(query_579005, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579005, "alt", newJString(alt))
  add(query_579005, "uploadType", newJString(uploadType))
  add(query_579005, "quotaUser", newJString(quotaUser))
  add(path_579004, "reportId", newJString(reportId))
  add(query_579005, "callback", newJString(callback))
  add(query_579005, "fields", newJString(fields))
  add(query_579005, "access_token", newJString(accessToken))
  add(query_579005, "upload_protocol", newJString(uploadProtocol))
  result = call_579003.call(path_579004, query_579005, nil, nil, nil)

var youtubereportingJobsReportsGet* = Call_YoutubereportingJobsReportsGet_578985(
    name: "youtubereportingJobsReportsGet", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com",
    route: "/v1/jobs/{jobId}/reports/{reportId}",
    validator: validate_YoutubereportingJobsReportsGet_578986, base: "/",
    url: url_YoutubereportingJobsReportsGet_578987, schemes: {Scheme.Https})
type
  Call_YoutubereportingMediaDownload_579006 = ref object of OpenApiRestCall_578339
proc url_YoutubereportingMediaDownload_579008(protocol: Scheme; host: string;
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

proc validate_YoutubereportingMediaDownload_579007(path: JsonNode; query: JsonNode;
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
  var valid_579009 = path.getOrDefault("resourceName")
  valid_579009 = validateParameter(valid_579009, JString, required = true,
                                 default = nil)
  if valid_579009 != nil:
    section.add "resourceName", valid_579009
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
  var valid_579010 = query.getOrDefault("key")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "key", valid_579010
  var valid_579011 = query.getOrDefault("prettyPrint")
  valid_579011 = validateParameter(valid_579011, JBool, required = false,
                                 default = newJBool(true))
  if valid_579011 != nil:
    section.add "prettyPrint", valid_579011
  var valid_579012 = query.getOrDefault("oauth_token")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "oauth_token", valid_579012
  var valid_579013 = query.getOrDefault("$.xgafv")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = newJString("1"))
  if valid_579013 != nil:
    section.add "$.xgafv", valid_579013
  var valid_579014 = query.getOrDefault("alt")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = newJString("json"))
  if valid_579014 != nil:
    section.add "alt", valid_579014
  var valid_579015 = query.getOrDefault("uploadType")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "uploadType", valid_579015
  var valid_579016 = query.getOrDefault("quotaUser")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "quotaUser", valid_579016
  var valid_579017 = query.getOrDefault("callback")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "callback", valid_579017
  var valid_579018 = query.getOrDefault("fields")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "fields", valid_579018
  var valid_579019 = query.getOrDefault("access_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "access_token", valid_579019
  var valid_579020 = query.getOrDefault("upload_protocol")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "upload_protocol", valid_579020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579021: Call_YoutubereportingMediaDownload_579006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Method for media download. Download is supported
  ## on the URI `/v1/media/{+name}?alt=media`.
  ## 
  let valid = call_579021.validator(path, query, header, formData, body)
  let scheme = call_579021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579021.url(scheme.get, call_579021.host, call_579021.base,
                         call_579021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579021, url, valid)

proc call*(call_579022: Call_YoutubereportingMediaDownload_579006;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## youtubereportingMediaDownload
  ## Method for media download. Download is supported
  ## on the URI `/v1/media/{+name}?alt=media`.
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
  ##   callback: string
  ##           : JSONP
  ##   resourceName: string (required)
  ##               : Name of the media that is being downloaded.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579023 = newJObject()
  var query_579024 = newJObject()
  add(query_579024, "key", newJString(key))
  add(query_579024, "prettyPrint", newJBool(prettyPrint))
  add(query_579024, "oauth_token", newJString(oauthToken))
  add(query_579024, "$.xgafv", newJString(Xgafv))
  add(query_579024, "alt", newJString(alt))
  add(query_579024, "uploadType", newJString(uploadType))
  add(query_579024, "quotaUser", newJString(quotaUser))
  add(query_579024, "callback", newJString(callback))
  add(path_579023, "resourceName", newJString(resourceName))
  add(query_579024, "fields", newJString(fields))
  add(query_579024, "access_token", newJString(accessToken))
  add(query_579024, "upload_protocol", newJString(uploadProtocol))
  result = call_579022.call(path_579023, query_579024, nil, nil, nil)

var youtubereportingMediaDownload* = Call_YoutubereportingMediaDownload_579006(
    name: "youtubereportingMediaDownload", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/media/{resourceName}",
    validator: validate_YoutubereportingMediaDownload_579007, base: "/",
    url: url_YoutubereportingMediaDownload_579008, schemes: {Scheme.Https})
type
  Call_YoutubereportingReportTypesList_579025 = ref object of OpenApiRestCall_578339
proc url_YoutubereportingReportTypesList_579027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubereportingReportTypesList_579026(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists report types.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##           : Requested page size. Server may return fewer report types than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   onBehalfOfContentOwner: JString
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of
  ## ListReportTypesResponse.next_page_token
  ## returned in response to the previous call to the `ListReportTypes` method.
  ##   includeSystemManaged: JBool
  ##                       : If set to true, also system-managed report types will be returned;
  ## otherwise only the report types that can be used to create new reporting
  ## jobs will be returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579028 = query.getOrDefault("key")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "key", valid_579028
  var valid_579029 = query.getOrDefault("prettyPrint")
  valid_579029 = validateParameter(valid_579029, JBool, required = false,
                                 default = newJBool(true))
  if valid_579029 != nil:
    section.add "prettyPrint", valid_579029
  var valid_579030 = query.getOrDefault("oauth_token")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "oauth_token", valid_579030
  var valid_579031 = query.getOrDefault("$.xgafv")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = newJString("1"))
  if valid_579031 != nil:
    section.add "$.xgafv", valid_579031
  var valid_579032 = query.getOrDefault("pageSize")
  valid_579032 = validateParameter(valid_579032, JInt, required = false, default = nil)
  if valid_579032 != nil:
    section.add "pageSize", valid_579032
  var valid_579033 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "onBehalfOfContentOwner", valid_579033
  var valid_579034 = query.getOrDefault("alt")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = newJString("json"))
  if valid_579034 != nil:
    section.add "alt", valid_579034
  var valid_579035 = query.getOrDefault("uploadType")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "uploadType", valid_579035
  var valid_579036 = query.getOrDefault("quotaUser")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "quotaUser", valid_579036
  var valid_579037 = query.getOrDefault("pageToken")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "pageToken", valid_579037
  var valid_579038 = query.getOrDefault("includeSystemManaged")
  valid_579038 = validateParameter(valid_579038, JBool, required = false, default = nil)
  if valid_579038 != nil:
    section.add "includeSystemManaged", valid_579038
  var valid_579039 = query.getOrDefault("callback")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "callback", valid_579039
  var valid_579040 = query.getOrDefault("fields")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "fields", valid_579040
  var valid_579041 = query.getOrDefault("access_token")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "access_token", valid_579041
  var valid_579042 = query.getOrDefault("upload_protocol")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "upload_protocol", valid_579042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579043: Call_YoutubereportingReportTypesList_579025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists report types.
  ## 
  let valid = call_579043.validator(path, query, header, formData, body)
  let scheme = call_579043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579043.url(scheme.get, call_579043.host, call_579043.base,
                         call_579043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579043, url, valid)

proc call*(call_579044: Call_YoutubereportingReportTypesList_579025;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; onBehalfOfContentOwner: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; includeSystemManaged: bool = false;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## youtubereportingReportTypesList
  ## Lists report types.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer report types than requested.
  ## If unspecified, server will pick an appropriate default.
  ##   onBehalfOfContentOwner: string
  ##                         : The content owner's external ID on which behalf the user is acting on. If
  ## not set, the user is acting for himself (his own channel).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results the server should return. Typically,
  ## this is the value of
  ## ListReportTypesResponse.next_page_token
  ## returned in response to the previous call to the `ListReportTypes` method.
  ##   includeSystemManaged: bool
  ##                       : If set to true, also system-managed report types will be returned;
  ## otherwise only the report types that can be used to create new reporting
  ## jobs will be returned.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579045 = newJObject()
  add(query_579045, "key", newJString(key))
  add(query_579045, "prettyPrint", newJBool(prettyPrint))
  add(query_579045, "oauth_token", newJString(oauthToken))
  add(query_579045, "$.xgafv", newJString(Xgafv))
  add(query_579045, "pageSize", newJInt(pageSize))
  add(query_579045, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579045, "alt", newJString(alt))
  add(query_579045, "uploadType", newJString(uploadType))
  add(query_579045, "quotaUser", newJString(quotaUser))
  add(query_579045, "pageToken", newJString(pageToken))
  add(query_579045, "includeSystemManaged", newJBool(includeSystemManaged))
  add(query_579045, "callback", newJString(callback))
  add(query_579045, "fields", newJString(fields))
  add(query_579045, "access_token", newJString(accessToken))
  add(query_579045, "upload_protocol", newJString(uploadProtocol))
  result = call_579044.call(nil, query_579045, nil, nil, nil)

var youtubereportingReportTypesList* = Call_YoutubereportingReportTypesList_579025(
    name: "youtubereportingReportTypesList", meth: HttpMethod.HttpGet,
    host: "youtubereporting.googleapis.com", route: "/v1/reportTypes",
    validator: validate_YoutubereportingReportTypesList_579026, base: "/",
    url: url_YoutubereportingReportTypesList_579027, schemes: {Scheme.Https})
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
