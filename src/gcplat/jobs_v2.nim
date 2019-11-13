
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Talent Solution
## version: v2
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
  gcpServiceName = "jobs"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobsCompaniesCreate_579919 = ref object of OpenApiRestCall_579373
proc url_JobsCompaniesCreate_579921(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_JobsCompaniesCreate_579920(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new company entity.
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
  var valid_579922 = query.getOrDefault("key")
  valid_579922 = validateParameter(valid_579922, JString, required = false,
                                 default = nil)
  if valid_579922 != nil:
    section.add "key", valid_579922
  var valid_579923 = query.getOrDefault("prettyPrint")
  valid_579923 = validateParameter(valid_579923, JBool, required = false,
                                 default = newJBool(true))
  if valid_579923 != nil:
    section.add "prettyPrint", valid_579923
  var valid_579924 = query.getOrDefault("oauth_token")
  valid_579924 = validateParameter(valid_579924, JString, required = false,
                                 default = nil)
  if valid_579924 != nil:
    section.add "oauth_token", valid_579924
  var valid_579925 = query.getOrDefault("$.xgafv")
  valid_579925 = validateParameter(valid_579925, JString, required = false,
                                 default = newJString("1"))
  if valid_579925 != nil:
    section.add "$.xgafv", valid_579925
  var valid_579926 = query.getOrDefault("alt")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = newJString("json"))
  if valid_579926 != nil:
    section.add "alt", valid_579926
  var valid_579927 = query.getOrDefault("uploadType")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "uploadType", valid_579927
  var valid_579928 = query.getOrDefault("quotaUser")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "quotaUser", valid_579928
  var valid_579929 = query.getOrDefault("callback")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "callback", valid_579929
  var valid_579930 = query.getOrDefault("fields")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "fields", valid_579930
  var valid_579931 = query.getOrDefault("access_token")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "access_token", valid_579931
  var valid_579932 = query.getOrDefault("upload_protocol")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "upload_protocol", valid_579932
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

proc call*(call_579934: Call_JobsCompaniesCreate_579919; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new company entity.
  ## 
  let valid = call_579934.validator(path, query, header, formData, body)
  let scheme = call_579934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579934.url(scheme.get, call_579934.host, call_579934.base,
                         call_579934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579934, url, valid)

proc call*(call_579935: Call_JobsCompaniesCreate_579919; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsCompaniesCreate
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579936 = newJObject()
  var body_579937 = newJObject()
  add(query_579936, "key", newJString(key))
  add(query_579936, "prettyPrint", newJBool(prettyPrint))
  add(query_579936, "oauth_token", newJString(oauthToken))
  add(query_579936, "$.xgafv", newJString(Xgafv))
  add(query_579936, "alt", newJString(alt))
  add(query_579936, "uploadType", newJString(uploadType))
  add(query_579936, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579937 = body
  add(query_579936, "callback", newJString(callback))
  add(query_579936, "fields", newJString(fields))
  add(query_579936, "access_token", newJString(accessToken))
  add(query_579936, "upload_protocol", newJString(uploadProtocol))
  result = call_579935.call(nil, query_579936, nil, nil, body_579937)

var jobsCompaniesCreate* = Call_JobsCompaniesCreate_579919(
    name: "jobsCompaniesCreate", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/companies",
    validator: validate_JobsCompaniesCreate_579920, base: "/",
    url: url_JobsCompaniesCreate_579921, schemes: {Scheme.Https})
type
  Call_JobsCompaniesList_579644 = ref object of OpenApiRestCall_579373
proc url_JobsCompaniesList_579646(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_JobsCompaniesList_579645(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists all companies associated with a Cloud Talent Solution account.
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
  ##   mustHaveOpenJobs: JBool
  ##                   : Optional. Set to true if the companies request must have open jobs.
  ## 
  ## Defaults to false.
  ## 
  ## If true, at most page_size of companies are fetched, among which
  ## only those with open jobs are returned.
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
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579758 = query.getOrDefault("key")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "key", valid_579758
  var valid_579772 = query.getOrDefault("prettyPrint")
  valid_579772 = validateParameter(valid_579772, JBool, required = false,
                                 default = newJBool(true))
  if valid_579772 != nil:
    section.add "prettyPrint", valid_579772
  var valid_579773 = query.getOrDefault("oauth_token")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "oauth_token", valid_579773
  var valid_579774 = query.getOrDefault("mustHaveOpenJobs")
  valid_579774 = validateParameter(valid_579774, JBool, required = false, default = nil)
  if valid_579774 != nil:
    section.add "mustHaveOpenJobs", valid_579774
  var valid_579775 = query.getOrDefault("$.xgafv")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = newJString("1"))
  if valid_579775 != nil:
    section.add "$.xgafv", valid_579775
  var valid_579776 = query.getOrDefault("pageSize")
  valid_579776 = validateParameter(valid_579776, JInt, required = false, default = nil)
  if valid_579776 != nil:
    section.add "pageSize", valid_579776
  var valid_579777 = query.getOrDefault("alt")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = newJString("json"))
  if valid_579777 != nil:
    section.add "alt", valid_579777
  var valid_579778 = query.getOrDefault("uploadType")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "uploadType", valid_579778
  var valid_579779 = query.getOrDefault("quotaUser")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "quotaUser", valid_579779
  var valid_579780 = query.getOrDefault("pageToken")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "pageToken", valid_579780
  var valid_579781 = query.getOrDefault("callback")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "callback", valid_579781
  var valid_579782 = query.getOrDefault("fields")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "fields", valid_579782
  var valid_579783 = query.getOrDefault("access_token")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "access_token", valid_579783
  var valid_579784 = query.getOrDefault("upload_protocol")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "upload_protocol", valid_579784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579807: Call_JobsCompaniesList_579644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all companies associated with a Cloud Talent Solution account.
  ## 
  let valid = call_579807.validator(path, query, header, formData, body)
  let scheme = call_579807.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579807.url(scheme.get, call_579807.host, call_579807.base,
                         call_579807.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579807, url, valid)

proc call*(call_579878: Call_JobsCompaniesList_579644; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          mustHaveOpenJobs: bool = false; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsCompaniesList
  ## Lists all companies associated with a Cloud Talent Solution account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   mustHaveOpenJobs: bool
  ##                   : Optional. Set to true if the companies request must have open jobs.
  ## 
  ## Defaults to false.
  ## 
  ## If true, at most page_size of companies are fetched, among which
  ## only those with open jobs are returned.
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579879 = newJObject()
  add(query_579879, "key", newJString(key))
  add(query_579879, "prettyPrint", newJBool(prettyPrint))
  add(query_579879, "oauth_token", newJString(oauthToken))
  add(query_579879, "mustHaveOpenJobs", newJBool(mustHaveOpenJobs))
  add(query_579879, "$.xgafv", newJString(Xgafv))
  add(query_579879, "pageSize", newJInt(pageSize))
  add(query_579879, "alt", newJString(alt))
  add(query_579879, "uploadType", newJString(uploadType))
  add(query_579879, "quotaUser", newJString(quotaUser))
  add(query_579879, "pageToken", newJString(pageToken))
  add(query_579879, "callback", newJString(callback))
  add(query_579879, "fields", newJString(fields))
  add(query_579879, "access_token", newJString(accessToken))
  add(query_579879, "upload_protocol", newJString(uploadProtocol))
  result = call_579878.call(nil, query_579879, nil, nil, nil)

var jobsCompaniesList* = Call_JobsCompaniesList_579644(name: "jobsCompaniesList",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/companies",
    validator: validate_JobsCompaniesList_579645, base: "/",
    url: url_JobsCompaniesList_579646, schemes: {Scheme.Https})
type
  Call_JobsJobsCreate_579959 = ref object of OpenApiRestCall_579373
proc url_JobsJobsCreate_579961(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_JobsJobsCreate_579960(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a new job.
  ## 
  ## Typically, the job becomes searchable within 10 seconds, but it may take
  ## up to 5 minutes.
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
  var valid_579966 = query.getOrDefault("alt")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = newJString("json"))
  if valid_579966 != nil:
    section.add "alt", valid_579966
  var valid_579967 = query.getOrDefault("uploadType")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "uploadType", valid_579967
  var valid_579968 = query.getOrDefault("quotaUser")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "quotaUser", valid_579968
  var valid_579969 = query.getOrDefault("callback")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "callback", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("access_token")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "access_token", valid_579971
  var valid_579972 = query.getOrDefault("upload_protocol")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "upload_protocol", valid_579972
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

proc call*(call_579974: Call_JobsJobsCreate_579959; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job.
  ## 
  ## Typically, the job becomes searchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ## 
  let valid = call_579974.validator(path, query, header, formData, body)
  let scheme = call_579974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579974.url(scheme.get, call_579974.host, call_579974.base,
                         call_579974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579974, url, valid)

proc call*(call_579975: Call_JobsJobsCreate_579959; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsJobsCreate
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579976 = newJObject()
  var body_579977 = newJObject()
  add(query_579976, "key", newJString(key))
  add(query_579976, "prettyPrint", newJBool(prettyPrint))
  add(query_579976, "oauth_token", newJString(oauthToken))
  add(query_579976, "$.xgafv", newJString(Xgafv))
  add(query_579976, "alt", newJString(alt))
  add(query_579976, "uploadType", newJString(uploadType))
  add(query_579976, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579977 = body
  add(query_579976, "callback", newJString(callback))
  add(query_579976, "fields", newJString(fields))
  add(query_579976, "access_token", newJString(accessToken))
  add(query_579976, "upload_protocol", newJString(uploadProtocol))
  result = call_579975.call(nil, query_579976, nil, nil, body_579977)

var jobsJobsCreate* = Call_JobsJobsCreate_579959(name: "jobsJobsCreate",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com", route: "/v2/jobs",
    validator: validate_JobsJobsCreate_579960, base: "/", url: url_JobsJobsCreate_579961,
    schemes: {Scheme.Https})
type
  Call_JobsJobsList_579938 = ref object of OpenApiRestCall_579373
proc url_JobsJobsList_579940(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_JobsJobsList_579939(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists jobs by filter.
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
  ##   idsOnly: JBool
  ##          : Optional. If set to `true`, only Job.name, Job.requisition_id and
  ## Job.language_code will be returned.
  ## 
  ## A typical use case is to synchronize job repositories.
  ## 
  ## Defaults to false.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If ids_only is set to true, the maximum allowed page size
  ## is 1000. Otherwise, the maximum allowed page size is 100.
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
  ## * companyName = "companies/123"
  ## * companyName = "companies/123" AND requisitionId = "req-1"
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
  section = newJObject()
  var valid_579941 = query.getOrDefault("key")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "key", valid_579941
  var valid_579942 = query.getOrDefault("prettyPrint")
  valid_579942 = validateParameter(valid_579942, JBool, required = false,
                                 default = newJBool(true))
  if valid_579942 != nil:
    section.add "prettyPrint", valid_579942
  var valid_579943 = query.getOrDefault("oauth_token")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "oauth_token", valid_579943
  var valid_579944 = query.getOrDefault("idsOnly")
  valid_579944 = validateParameter(valid_579944, JBool, required = false, default = nil)
  if valid_579944 != nil:
    section.add "idsOnly", valid_579944
  var valid_579945 = query.getOrDefault("$.xgafv")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = newJString("1"))
  if valid_579945 != nil:
    section.add "$.xgafv", valid_579945
  var valid_579946 = query.getOrDefault("pageSize")
  valid_579946 = validateParameter(valid_579946, JInt, required = false, default = nil)
  if valid_579946 != nil:
    section.add "pageSize", valid_579946
  var valid_579947 = query.getOrDefault("alt")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = newJString("json"))
  if valid_579947 != nil:
    section.add "alt", valid_579947
  var valid_579948 = query.getOrDefault("uploadType")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "uploadType", valid_579948
  var valid_579949 = query.getOrDefault("quotaUser")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "quotaUser", valid_579949
  var valid_579950 = query.getOrDefault("filter")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "filter", valid_579950
  var valid_579951 = query.getOrDefault("pageToken")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "pageToken", valid_579951
  var valid_579952 = query.getOrDefault("callback")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "callback", valid_579952
  var valid_579953 = query.getOrDefault("fields")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "fields", valid_579953
  var valid_579954 = query.getOrDefault("access_token")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "access_token", valid_579954
  var valid_579955 = query.getOrDefault("upload_protocol")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "upload_protocol", valid_579955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579956: Call_JobsJobsList_579938; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs by filter.
  ## 
  let valid = call_579956.validator(path, query, header, formData, body)
  let scheme = call_579956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579956.url(scheme.get, call_579956.host, call_579956.base,
                         call_579956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579956, url, valid)

proc call*(call_579957: Call_JobsJobsList_579938; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; idsOnly: bool = false;
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsJobsList
  ## Lists jobs by filter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   idsOnly: bool
  ##          : Optional. If set to `true`, only Job.name, Job.requisition_id and
  ## Job.language_code will be returned.
  ## 
  ## A typical use case is to synchronize job repositories.
  ## 
  ## Defaults to false.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If ids_only is set to true, the maximum allowed page size
  ## is 1000. Otherwise, the maximum allowed page size is 100.
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
  ## * companyName = "companies/123"
  ## * companyName = "companies/123" AND requisitionId = "req-1"
  ##   pageToken: string
  ##            : Optional. The starting point of a query result.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579958 = newJObject()
  add(query_579958, "key", newJString(key))
  add(query_579958, "prettyPrint", newJBool(prettyPrint))
  add(query_579958, "oauth_token", newJString(oauthToken))
  add(query_579958, "idsOnly", newJBool(idsOnly))
  add(query_579958, "$.xgafv", newJString(Xgafv))
  add(query_579958, "pageSize", newJInt(pageSize))
  add(query_579958, "alt", newJString(alt))
  add(query_579958, "uploadType", newJString(uploadType))
  add(query_579958, "quotaUser", newJString(quotaUser))
  add(query_579958, "filter", newJString(filter))
  add(query_579958, "pageToken", newJString(pageToken))
  add(query_579958, "callback", newJString(callback))
  add(query_579958, "fields", newJString(fields))
  add(query_579958, "access_token", newJString(accessToken))
  add(query_579958, "upload_protocol", newJString(uploadProtocol))
  result = call_579957.call(nil, query_579958, nil, nil, nil)

var jobsJobsList* = Call_JobsJobsList_579938(name: "jobsJobsList",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/jobs",
    validator: validate_JobsJobsList_579939, base: "/", url: url_JobsJobsList_579940,
    schemes: {Scheme.Https})
type
  Call_JobsJobsBatchDelete_579978 = ref object of OpenApiRestCall_579373
proc url_JobsJobsBatchDelete_579980(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_JobsJobsBatchDelete_579979(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a list of Job postings by filter.
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
  var valid_579981 = query.getOrDefault("key")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "key", valid_579981
  var valid_579982 = query.getOrDefault("prettyPrint")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(true))
  if valid_579982 != nil:
    section.add "prettyPrint", valid_579982
  var valid_579983 = query.getOrDefault("oauth_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "oauth_token", valid_579983
  var valid_579984 = query.getOrDefault("$.xgafv")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("1"))
  if valid_579984 != nil:
    section.add "$.xgafv", valid_579984
  var valid_579985 = query.getOrDefault("alt")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("json"))
  if valid_579985 != nil:
    section.add "alt", valid_579985
  var valid_579986 = query.getOrDefault("uploadType")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "uploadType", valid_579986
  var valid_579987 = query.getOrDefault("quotaUser")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "quotaUser", valid_579987
  var valid_579988 = query.getOrDefault("callback")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "callback", valid_579988
  var valid_579989 = query.getOrDefault("fields")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "fields", valid_579989
  var valid_579990 = query.getOrDefault("access_token")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "access_token", valid_579990
  var valid_579991 = query.getOrDefault("upload_protocol")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "upload_protocol", valid_579991
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

proc call*(call_579993: Call_JobsJobsBatchDelete_579978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a list of Job postings by filter.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_JobsJobsBatchDelete_579978; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsJobsBatchDelete
  ## Deletes a list of Job postings by filter.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579995 = newJObject()
  var body_579996 = newJObject()
  add(query_579995, "key", newJString(key))
  add(query_579995, "prettyPrint", newJBool(prettyPrint))
  add(query_579995, "oauth_token", newJString(oauthToken))
  add(query_579995, "$.xgafv", newJString(Xgafv))
  add(query_579995, "alt", newJString(alt))
  add(query_579995, "uploadType", newJString(uploadType))
  add(query_579995, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579996 = body
  add(query_579995, "callback", newJString(callback))
  add(query_579995, "fields", newJString(fields))
  add(query_579995, "access_token", newJString(accessToken))
  add(query_579995, "upload_protocol", newJString(uploadProtocol))
  result = call_579994.call(nil, query_579995, nil, nil, body_579996)

var jobsJobsBatchDelete* = Call_JobsJobsBatchDelete_579978(
    name: "jobsJobsBatchDelete", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:batchDelete",
    validator: validate_JobsJobsBatchDelete_579979, base: "/",
    url: url_JobsJobsBatchDelete_579980, schemes: {Scheme.Https})
type
  Call_JobsJobsDeleteByFilter_579997 = ref object of OpenApiRestCall_579373
proc url_JobsJobsDeleteByFilter_579999(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_JobsJobsDeleteByFilter_579998(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deprecated. Use BatchDeleteJobs instead.
  ## 
  ## Deletes the specified job by filter. You can specify whether to
  ## synchronously wait for validation, indexing, and general processing to be
  ## completed before the response is returned.
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
  var valid_580000 = query.getOrDefault("key")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "key", valid_580000
  var valid_580001 = query.getOrDefault("prettyPrint")
  valid_580001 = validateParameter(valid_580001, JBool, required = false,
                                 default = newJBool(true))
  if valid_580001 != nil:
    section.add "prettyPrint", valid_580001
  var valid_580002 = query.getOrDefault("oauth_token")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "oauth_token", valid_580002
  var valid_580003 = query.getOrDefault("$.xgafv")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = newJString("1"))
  if valid_580003 != nil:
    section.add "$.xgafv", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("uploadType")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "uploadType", valid_580005
  var valid_580006 = query.getOrDefault("quotaUser")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "quotaUser", valid_580006
  var valid_580007 = query.getOrDefault("callback")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "callback", valid_580007
  var valid_580008 = query.getOrDefault("fields")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "fields", valid_580008
  var valid_580009 = query.getOrDefault("access_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "access_token", valid_580009
  var valid_580010 = query.getOrDefault("upload_protocol")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "upload_protocol", valid_580010
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

proc call*(call_580012: Call_JobsJobsDeleteByFilter_579997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated. Use BatchDeleteJobs instead.
  ## 
  ## Deletes the specified job by filter. You can specify whether to
  ## synchronously wait for validation, indexing, and general processing to be
  ## completed before the response is returned.
  ## 
  let valid = call_580012.validator(path, query, header, formData, body)
  let scheme = call_580012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580012.url(scheme.get, call_580012.host, call_580012.base,
                         call_580012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580012, url, valid)

proc call*(call_580013: Call_JobsJobsDeleteByFilter_579997; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsJobsDeleteByFilter
  ## Deprecated. Use BatchDeleteJobs instead.
  ## 
  ## Deletes the specified job by filter. You can specify whether to
  ## synchronously wait for validation, indexing, and general processing to be
  ## completed before the response is returned.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_580014 = newJObject()
  var body_580015 = newJObject()
  add(query_580014, "key", newJString(key))
  add(query_580014, "prettyPrint", newJBool(prettyPrint))
  add(query_580014, "oauth_token", newJString(oauthToken))
  add(query_580014, "$.xgafv", newJString(Xgafv))
  add(query_580014, "alt", newJString(alt))
  add(query_580014, "uploadType", newJString(uploadType))
  add(query_580014, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580015 = body
  add(query_580014, "callback", newJString(callback))
  add(query_580014, "fields", newJString(fields))
  add(query_580014, "access_token", newJString(accessToken))
  add(query_580014, "upload_protocol", newJString(uploadProtocol))
  result = call_580013.call(nil, query_580014, nil, nil, body_580015)

var jobsJobsDeleteByFilter* = Call_JobsJobsDeleteByFilter_579997(
    name: "jobsJobsDeleteByFilter", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:deleteByFilter",
    validator: validate_JobsJobsDeleteByFilter_579998, base: "/",
    url: url_JobsJobsDeleteByFilter_579999, schemes: {Scheme.Https})
type
  Call_JobsJobsHistogram_580016 = ref object of OpenApiRestCall_579373
proc url_JobsJobsHistogram_580018(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_JobsJobsHistogram_580017(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deprecated. Use SearchJobsRequest.histogram_facets instead to make
  ## a single call with both search and histogram.
  ## 
  ## Retrieves a histogram for the given
  ## GetHistogramRequest. This call provides a structured
  ## count of jobs that match against the search query, grouped by specified
  ## facets.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only counts jobs the caller has
  ## permission to search against.
  ## 
  ## For example, use this call to generate the
  ## number of jobs in the U.S. by state.
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
  var valid_580019 = query.getOrDefault("key")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "key", valid_580019
  var valid_580020 = query.getOrDefault("prettyPrint")
  valid_580020 = validateParameter(valid_580020, JBool, required = false,
                                 default = newJBool(true))
  if valid_580020 != nil:
    section.add "prettyPrint", valid_580020
  var valid_580021 = query.getOrDefault("oauth_token")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "oauth_token", valid_580021
  var valid_580022 = query.getOrDefault("$.xgafv")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("1"))
  if valid_580022 != nil:
    section.add "$.xgafv", valid_580022
  var valid_580023 = query.getOrDefault("alt")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = newJString("json"))
  if valid_580023 != nil:
    section.add "alt", valid_580023
  var valid_580024 = query.getOrDefault("uploadType")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "uploadType", valid_580024
  var valid_580025 = query.getOrDefault("quotaUser")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "quotaUser", valid_580025
  var valid_580026 = query.getOrDefault("callback")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "callback", valid_580026
  var valid_580027 = query.getOrDefault("fields")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "fields", valid_580027
  var valid_580028 = query.getOrDefault("access_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "access_token", valid_580028
  var valid_580029 = query.getOrDefault("upload_protocol")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "upload_protocol", valid_580029
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

proc call*(call_580031: Call_JobsJobsHistogram_580016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated. Use SearchJobsRequest.histogram_facets instead to make
  ## a single call with both search and histogram.
  ## 
  ## Retrieves a histogram for the given
  ## GetHistogramRequest. This call provides a structured
  ## count of jobs that match against the search query, grouped by specified
  ## facets.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only counts jobs the caller has
  ## permission to search against.
  ## 
  ## For example, use this call to generate the
  ## number of jobs in the U.S. by state.
  ## 
  let valid = call_580031.validator(path, query, header, formData, body)
  let scheme = call_580031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580031.url(scheme.get, call_580031.host, call_580031.base,
                         call_580031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580031, url, valid)

proc call*(call_580032: Call_JobsJobsHistogram_580016; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsJobsHistogram
  ## Deprecated. Use SearchJobsRequest.histogram_facets instead to make
  ## a single call with both search and histogram.
  ## 
  ## Retrieves a histogram for the given
  ## GetHistogramRequest. This call provides a structured
  ## count of jobs that match against the search query, grouped by specified
  ## facets.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only counts jobs the caller has
  ## permission to search against.
  ## 
  ## For example, use this call to generate the
  ## number of jobs in the U.S. by state.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_580033 = newJObject()
  var body_580034 = newJObject()
  add(query_580033, "key", newJString(key))
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(query_580033, "$.xgafv", newJString(Xgafv))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "uploadType", newJString(uploadType))
  add(query_580033, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580034 = body
  add(query_580033, "callback", newJString(callback))
  add(query_580033, "fields", newJString(fields))
  add(query_580033, "access_token", newJString(accessToken))
  add(query_580033, "upload_protocol", newJString(uploadProtocol))
  result = call_580032.call(nil, query_580033, nil, nil, body_580034)

var jobsJobsHistogram* = Call_JobsJobsHistogram_580016(name: "jobsJobsHistogram",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com",
    route: "/v2/jobs:histogram", validator: validate_JobsJobsHistogram_580017,
    base: "/", url: url_JobsJobsHistogram_580018, schemes: {Scheme.Https})
type
  Call_JobsJobsSearch_580035 = ref object of OpenApiRestCall_579373
proc url_JobsJobsSearch_580037(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_JobsJobsSearch_580036(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs that the caller has
  ## permission to search against.
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
  var valid_580038 = query.getOrDefault("key")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "key", valid_580038
  var valid_580039 = query.getOrDefault("prettyPrint")
  valid_580039 = validateParameter(valid_580039, JBool, required = false,
                                 default = newJBool(true))
  if valid_580039 != nil:
    section.add "prettyPrint", valid_580039
  var valid_580040 = query.getOrDefault("oauth_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "oauth_token", valid_580040
  var valid_580041 = query.getOrDefault("$.xgafv")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("1"))
  if valid_580041 != nil:
    section.add "$.xgafv", valid_580041
  var valid_580042 = query.getOrDefault("alt")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("json"))
  if valid_580042 != nil:
    section.add "alt", valid_580042
  var valid_580043 = query.getOrDefault("uploadType")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "uploadType", valid_580043
  var valid_580044 = query.getOrDefault("quotaUser")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "quotaUser", valid_580044
  var valid_580045 = query.getOrDefault("callback")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "callback", valid_580045
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  var valid_580047 = query.getOrDefault("access_token")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "access_token", valid_580047
  var valid_580048 = query.getOrDefault("upload_protocol")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "upload_protocol", valid_580048
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

proc call*(call_580050: Call_JobsJobsSearch_580035; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs that the caller has
  ## permission to search against.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_JobsJobsSearch_580035; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsJobsSearch
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_580052 = newJObject()
  var body_580053 = newJObject()
  add(query_580052, "key", newJString(key))
  add(query_580052, "prettyPrint", newJBool(prettyPrint))
  add(query_580052, "oauth_token", newJString(oauthToken))
  add(query_580052, "$.xgafv", newJString(Xgafv))
  add(query_580052, "alt", newJString(alt))
  add(query_580052, "uploadType", newJString(uploadType))
  add(query_580052, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580053 = body
  add(query_580052, "callback", newJString(callback))
  add(query_580052, "fields", newJString(fields))
  add(query_580052, "access_token", newJString(accessToken))
  add(query_580052, "upload_protocol", newJString(uploadProtocol))
  result = call_580051.call(nil, query_580052, nil, nil, body_580053)

var jobsJobsSearch* = Call_JobsJobsSearch_580035(name: "jobsJobsSearch",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com",
    route: "/v2/jobs:search", validator: validate_JobsJobsSearch_580036, base: "/",
    url: url_JobsJobsSearch_580037, schemes: {Scheme.Https})
type
  Call_JobsJobsSearchForAlert_580054 = ref object of OpenApiRestCall_579373
proc url_JobsJobsSearchForAlert_580056(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_JobsJobsSearchForAlert_580055(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_580057 = query.getOrDefault("key")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "key", valid_580057
  var valid_580058 = query.getOrDefault("prettyPrint")
  valid_580058 = validateParameter(valid_580058, JBool, required = false,
                                 default = newJBool(true))
  if valid_580058 != nil:
    section.add "prettyPrint", valid_580058
  var valid_580059 = query.getOrDefault("oauth_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "oauth_token", valid_580059
  var valid_580060 = query.getOrDefault("$.xgafv")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = newJString("1"))
  if valid_580060 != nil:
    section.add "$.xgafv", valid_580060
  var valid_580061 = query.getOrDefault("alt")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("json"))
  if valid_580061 != nil:
    section.add "alt", valid_580061
  var valid_580062 = query.getOrDefault("uploadType")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "uploadType", valid_580062
  var valid_580063 = query.getOrDefault("quotaUser")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "quotaUser", valid_580063
  var valid_580064 = query.getOrDefault("callback")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "callback", valid_580064
  var valid_580065 = query.getOrDefault("fields")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "fields", valid_580065
  var valid_580066 = query.getOrDefault("access_token")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "access_token", valid_580066
  var valid_580067 = query.getOrDefault("upload_protocol")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "upload_protocol", valid_580067
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

proc call*(call_580069: Call_JobsJobsSearchForAlert_580054; path: JsonNode;
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
  let valid = call_580069.validator(path, query, header, formData, body)
  let scheme = call_580069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580069.url(scheme.get, call_580069.host, call_580069.base,
                         call_580069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580069, url, valid)

proc call*(call_580070: Call_JobsJobsSearchForAlert_580054; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsJobsSearchForAlert
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_580071 = newJObject()
  var body_580072 = newJObject()
  add(query_580071, "key", newJString(key))
  add(query_580071, "prettyPrint", newJBool(prettyPrint))
  add(query_580071, "oauth_token", newJString(oauthToken))
  add(query_580071, "$.xgafv", newJString(Xgafv))
  add(query_580071, "alt", newJString(alt))
  add(query_580071, "uploadType", newJString(uploadType))
  add(query_580071, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580072 = body
  add(query_580071, "callback", newJString(callback))
  add(query_580071, "fields", newJString(fields))
  add(query_580071, "access_token", newJString(accessToken))
  add(query_580071, "upload_protocol", newJString(uploadProtocol))
  result = call_580070.call(nil, query_580071, nil, nil, body_580072)

var jobsJobsSearchForAlert* = Call_JobsJobsSearchForAlert_580054(
    name: "jobsJobsSearchForAlert", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:searchForAlert",
    validator: validate_JobsJobsSearchForAlert_580055, base: "/",
    url: url_JobsJobsSearchForAlert_580056, schemes: {Scheme.Https})
type
  Call_JobsCompaniesJobsList_580073 = ref object of OpenApiRestCall_579373
proc url_JobsCompaniesJobsList_580075(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "companyName" in path, "`companyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "companyName"),
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

proc validate_JobsCompaniesJobsList_580074(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deprecated. Use ListJobs instead.
  ## 
  ## Lists all jobs associated with a company.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   companyName: JString (required)
  ##              : Required. The resource name of the company that owns the jobs to be listed,
  ## such as, "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `companyName` field"
  var valid_580090 = path.getOrDefault("companyName")
  valid_580090 = validateParameter(valid_580090, JString, required = true,
                                 default = nil)
  if valid_580090 != nil:
    section.add "companyName", valid_580090
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   idsOnly: JBool
  ##          : Optional. If set to `true`, only job ID, job requisition ID and language code will be
  ## returned.
  ## 
  ## A typical use is to synchronize job repositories.
  ## 
  ## Defaults to false.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If ids_only is set to true, the maximum allowed page size
  ## is 1000. Otherwise, the maximum allowed page size is 100.
  ## 
  ## Default is 100 if empty or a number < 1 is specified.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeJobsCount: JBool
  ##                   : Deprecated. Please DO NOT use this field except for small companies.
  ## Suggest counting jobs page by page instead.
  ## 
  ## Optional.
  ## 
  ## Set to true if the total number of open jobs is to be returned.
  ## 
  ## Defaults to false.
  ##   jobRequisitionId: JString
  ##                   : Optional. The requisition ID, also known as posting ID, assigned by the company
  ## to the job.
  ## 
  ## The maximum number of allowable characters is 225.
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
  section = newJObject()
  var valid_580091 = query.getOrDefault("key")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "key", valid_580091
  var valid_580092 = query.getOrDefault("prettyPrint")
  valid_580092 = validateParameter(valid_580092, JBool, required = false,
                                 default = newJBool(true))
  if valid_580092 != nil:
    section.add "prettyPrint", valid_580092
  var valid_580093 = query.getOrDefault("oauth_token")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "oauth_token", valid_580093
  var valid_580094 = query.getOrDefault("idsOnly")
  valid_580094 = validateParameter(valid_580094, JBool, required = false, default = nil)
  if valid_580094 != nil:
    section.add "idsOnly", valid_580094
  var valid_580095 = query.getOrDefault("$.xgafv")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("1"))
  if valid_580095 != nil:
    section.add "$.xgafv", valid_580095
  var valid_580096 = query.getOrDefault("pageSize")
  valid_580096 = validateParameter(valid_580096, JInt, required = false, default = nil)
  if valid_580096 != nil:
    section.add "pageSize", valid_580096
  var valid_580097 = query.getOrDefault("alt")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("json"))
  if valid_580097 != nil:
    section.add "alt", valid_580097
  var valid_580098 = query.getOrDefault("uploadType")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "uploadType", valid_580098
  var valid_580099 = query.getOrDefault("quotaUser")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "quotaUser", valid_580099
  var valid_580100 = query.getOrDefault("includeJobsCount")
  valid_580100 = validateParameter(valid_580100, JBool, required = false, default = nil)
  if valid_580100 != nil:
    section.add "includeJobsCount", valid_580100
  var valid_580101 = query.getOrDefault("jobRequisitionId")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "jobRequisitionId", valid_580101
  var valid_580102 = query.getOrDefault("pageToken")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "pageToken", valid_580102
  var valid_580103 = query.getOrDefault("callback")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "callback", valid_580103
  var valid_580104 = query.getOrDefault("fields")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "fields", valid_580104
  var valid_580105 = query.getOrDefault("access_token")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "access_token", valid_580105
  var valid_580106 = query.getOrDefault("upload_protocol")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "upload_protocol", valid_580106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580107: Call_JobsCompaniesJobsList_580073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated. Use ListJobs instead.
  ## 
  ## Lists all jobs associated with a company.
  ## 
  let valid = call_580107.validator(path, query, header, formData, body)
  let scheme = call_580107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580107.url(scheme.get, call_580107.host, call_580107.base,
                         call_580107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580107, url, valid)

proc call*(call_580108: Call_JobsCompaniesJobsList_580073; companyName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          idsOnly: bool = false; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          includeJobsCount: bool = false; jobRequisitionId: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsCompaniesJobsList
  ## Deprecated. Use ListJobs instead.
  ## 
  ## Lists all jobs associated with a company.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   idsOnly: bool
  ##          : Optional. If set to `true`, only job ID, job requisition ID and language code will be
  ## returned.
  ## 
  ## A typical use is to synchronize job repositories.
  ## 
  ## Defaults to false.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If ids_only is set to true, the maximum allowed page size
  ## is 1000. Otherwise, the maximum allowed page size is 100.
  ## 
  ## Default is 100 if empty or a number < 1 is specified.
  ##   companyName: string (required)
  ##              : Required. The resource name of the company that owns the jobs to be listed,
  ## such as, "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeJobsCount: bool
  ##                   : Deprecated. Please DO NOT use this field except for small companies.
  ## Suggest counting jobs page by page instead.
  ## 
  ## Optional.
  ## 
  ## Set to true if the total number of open jobs is to be returned.
  ## 
  ## Defaults to false.
  ##   jobRequisitionId: string
  ##                   : Optional. The requisition ID, also known as posting ID, assigned by the company
  ## to the job.
  ## 
  ## The maximum number of allowable characters is 225.
  ##   pageToken: string
  ##            : Optional. The starting point of a query result.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580109 = newJObject()
  var query_580110 = newJObject()
  add(query_580110, "key", newJString(key))
  add(query_580110, "prettyPrint", newJBool(prettyPrint))
  add(query_580110, "oauth_token", newJString(oauthToken))
  add(query_580110, "idsOnly", newJBool(idsOnly))
  add(query_580110, "$.xgafv", newJString(Xgafv))
  add(query_580110, "pageSize", newJInt(pageSize))
  add(path_580109, "companyName", newJString(companyName))
  add(query_580110, "alt", newJString(alt))
  add(query_580110, "uploadType", newJString(uploadType))
  add(query_580110, "quotaUser", newJString(quotaUser))
  add(query_580110, "includeJobsCount", newJBool(includeJobsCount))
  add(query_580110, "jobRequisitionId", newJString(jobRequisitionId))
  add(query_580110, "pageToken", newJString(pageToken))
  add(query_580110, "callback", newJString(callback))
  add(query_580110, "fields", newJString(fields))
  add(query_580110, "access_token", newJString(accessToken))
  add(query_580110, "upload_protocol", newJString(uploadProtocol))
  result = call_580108.call(path_580109, query_580110, nil, nil, nil)

var jobsCompaniesJobsList* = Call_JobsCompaniesJobsList_580073(
    name: "jobsCompaniesJobsList", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v2/{companyName}/jobs",
    validator: validate_JobsCompaniesJobsList_580074, base: "/",
    url: url_JobsCompaniesJobsList_580075, schemes: {Scheme.Https})
type
  Call_JobsCompaniesGet_580111 = ref object of OpenApiRestCall_579373
proc url_JobsCompaniesGet_580113(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_JobsCompaniesGet_580112(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves the specified company.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name of the company to retrieve,
  ## such as "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580114 = path.getOrDefault("name")
  valid_580114 = validateParameter(valid_580114, JString, required = true,
                                 default = nil)
  if valid_580114 != nil:
    section.add "name", valid_580114
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
  var valid_580115 = query.getOrDefault("key")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "key", valid_580115
  var valid_580116 = query.getOrDefault("prettyPrint")
  valid_580116 = validateParameter(valid_580116, JBool, required = false,
                                 default = newJBool(true))
  if valid_580116 != nil:
    section.add "prettyPrint", valid_580116
  var valid_580117 = query.getOrDefault("oauth_token")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "oauth_token", valid_580117
  var valid_580118 = query.getOrDefault("$.xgafv")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = newJString("1"))
  if valid_580118 != nil:
    section.add "$.xgafv", valid_580118
  var valid_580119 = query.getOrDefault("alt")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = newJString("json"))
  if valid_580119 != nil:
    section.add "alt", valid_580119
  var valid_580120 = query.getOrDefault("uploadType")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "uploadType", valid_580120
  var valid_580121 = query.getOrDefault("quotaUser")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "quotaUser", valid_580121
  var valid_580122 = query.getOrDefault("callback")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "callback", valid_580122
  var valid_580123 = query.getOrDefault("fields")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "fields", valid_580123
  var valid_580124 = query.getOrDefault("access_token")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "access_token", valid_580124
  var valid_580125 = query.getOrDefault("upload_protocol")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "upload_protocol", valid_580125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580126: Call_JobsCompaniesGet_580111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified company.
  ## 
  let valid = call_580126.validator(path, query, header, formData, body)
  let scheme = call_580126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580126.url(scheme.get, call_580126.host, call_580126.base,
                         call_580126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580126, url, valid)

proc call*(call_580127: Call_JobsCompaniesGet_580111; name: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## jobsCompaniesGet
  ## Retrieves the specified company.
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
  ##       : Required. Resource name of the company to retrieve,
  ## such as "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580128 = newJObject()
  var query_580129 = newJObject()
  add(query_580129, "key", newJString(key))
  add(query_580129, "prettyPrint", newJBool(prettyPrint))
  add(query_580129, "oauth_token", newJString(oauthToken))
  add(query_580129, "$.xgafv", newJString(Xgafv))
  add(query_580129, "alt", newJString(alt))
  add(query_580129, "uploadType", newJString(uploadType))
  add(query_580129, "quotaUser", newJString(quotaUser))
  add(path_580128, "name", newJString(name))
  add(query_580129, "callback", newJString(callback))
  add(query_580129, "fields", newJString(fields))
  add(query_580129, "access_token", newJString(accessToken))
  add(query_580129, "upload_protocol", newJString(uploadProtocol))
  result = call_580127.call(path_580128, query_580129, nil, nil, nil)

var jobsCompaniesGet* = Call_JobsCompaniesGet_580111(name: "jobsCompaniesGet",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesGet_580112, base: "/",
    url: url_JobsCompaniesGet_580113, schemes: {Scheme.Https})
type
  Call_JobsCompaniesPatch_580150 = ref object of OpenApiRestCall_579373
proc url_JobsCompaniesPatch_580152(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_JobsCompaniesPatch_580151(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the specified company. Company names can't be updated. To update a
  ## company name, delete the company and all jobs associated with it, and only
  ## then re-create them.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required during company update.
  ## 
  ## The resource name for a company. This is generated by the service when a
  ## company is created, for example,
  ## "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580153 = path.getOrDefault("name")
  valid_580153 = validateParameter(valid_580153, JString, required = true,
                                 default = nil)
  if valid_580153 != nil:
    section.add "name", valid_580153
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
  ##   updateCompanyFields: JString
  ##                      : Optional but strongly recommended to be provided for the best service
  ## experience.
  ## 
  ## If update_company_fields is provided, only the specified fields in
  ## company are updated. Otherwise all the fields are updated.
  ## 
  ## A field mask to specify the company fields to update. Valid values are:
  ## 
  ## * displayName
  ## * website
  ## * imageUrl
  ## * companySize
  ## * distributorBillingCompanyId
  ## * companyInfoSources
  ## * careerPageLink
  ## * hiringAgency
  ## * hqLocation
  ## * eeoText
  ## * keywordSearchableCustomAttributes
  ## * title (deprecated)
  ## * keywordSearchableCustomFields (deprecated)
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580154 = query.getOrDefault("key")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "key", valid_580154
  var valid_580155 = query.getOrDefault("prettyPrint")
  valid_580155 = validateParameter(valid_580155, JBool, required = false,
                                 default = newJBool(true))
  if valid_580155 != nil:
    section.add "prettyPrint", valid_580155
  var valid_580156 = query.getOrDefault("oauth_token")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "oauth_token", valid_580156
  var valid_580157 = query.getOrDefault("$.xgafv")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = newJString("1"))
  if valid_580157 != nil:
    section.add "$.xgafv", valid_580157
  var valid_580158 = query.getOrDefault("alt")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = newJString("json"))
  if valid_580158 != nil:
    section.add "alt", valid_580158
  var valid_580159 = query.getOrDefault("uploadType")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "uploadType", valid_580159
  var valid_580160 = query.getOrDefault("quotaUser")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "quotaUser", valid_580160
  var valid_580161 = query.getOrDefault("updateCompanyFields")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "updateCompanyFields", valid_580161
  var valid_580162 = query.getOrDefault("callback")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "callback", valid_580162
  var valid_580163 = query.getOrDefault("fields")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "fields", valid_580163
  var valid_580164 = query.getOrDefault("access_token")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "access_token", valid_580164
  var valid_580165 = query.getOrDefault("upload_protocol")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "upload_protocol", valid_580165
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

proc call*(call_580167: Call_JobsCompaniesPatch_580150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified company. Company names can't be updated. To update a
  ## company name, delete the company and all jobs associated with it, and only
  ## then re-create them.
  ## 
  let valid = call_580167.validator(path, query, header, formData, body)
  let scheme = call_580167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580167.url(scheme.get, call_580167.host, call_580167.base,
                         call_580167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580167, url, valid)

proc call*(call_580168: Call_JobsCompaniesPatch_580150; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil;
          updateCompanyFields: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsCompaniesPatch
  ## Updates the specified company. Company names can't be updated. To update a
  ## company name, delete the company and all jobs associated with it, and only
  ## then re-create them.
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
  ##       : Required during company update.
  ## 
  ## The resource name for a company. This is generated by the service when a
  ## company is created, for example,
  ## "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
  ##   body: JObject
  ##   updateCompanyFields: string
  ##                      : Optional but strongly recommended to be provided for the best service
  ## experience.
  ## 
  ## If update_company_fields is provided, only the specified fields in
  ## company are updated. Otherwise all the fields are updated.
  ## 
  ## A field mask to specify the company fields to update. Valid values are:
  ## 
  ## * displayName
  ## * website
  ## * imageUrl
  ## * companySize
  ## * distributorBillingCompanyId
  ## * companyInfoSources
  ## * careerPageLink
  ## * hiringAgency
  ## * hqLocation
  ## * eeoText
  ## * keywordSearchableCustomAttributes
  ## * title (deprecated)
  ## * keywordSearchableCustomFields (deprecated)
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580169 = newJObject()
  var query_580170 = newJObject()
  var body_580171 = newJObject()
  add(query_580170, "key", newJString(key))
  add(query_580170, "prettyPrint", newJBool(prettyPrint))
  add(query_580170, "oauth_token", newJString(oauthToken))
  add(query_580170, "$.xgafv", newJString(Xgafv))
  add(query_580170, "alt", newJString(alt))
  add(query_580170, "uploadType", newJString(uploadType))
  add(query_580170, "quotaUser", newJString(quotaUser))
  add(path_580169, "name", newJString(name))
  if body != nil:
    body_580171 = body
  add(query_580170, "updateCompanyFields", newJString(updateCompanyFields))
  add(query_580170, "callback", newJString(callback))
  add(query_580170, "fields", newJString(fields))
  add(query_580170, "access_token", newJString(accessToken))
  add(query_580170, "upload_protocol", newJString(uploadProtocol))
  result = call_580168.call(path_580169, query_580170, nil, nil, body_580171)

var jobsCompaniesPatch* = Call_JobsCompaniesPatch_580150(
    name: "jobsCompaniesPatch", meth: HttpMethod.HttpPatch,
    host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesPatch_580151, base: "/",
    url: url_JobsCompaniesPatch_580152, schemes: {Scheme.Https})
type
  Call_JobsCompaniesDelete_580130 = ref object of OpenApiRestCall_579373
proc url_JobsCompaniesDelete_580132(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_JobsCompaniesDelete_580131(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified company.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the company to be deleted,
  ## such as, "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580133 = path.getOrDefault("name")
  valid_580133 = validateParameter(valid_580133, JString, required = true,
                                 default = nil)
  if valid_580133 != nil:
    section.add "name", valid_580133
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
  ##   disableFastProcess: JBool
  ##                     : Deprecated. This field is not working anymore.
  ## 
  ## Optional.
  ## 
  ## If set to true, this call waits for all processing steps to complete
  ## before the job is cleaned up. Otherwise, the call returns while some
  ## steps are still taking place asynchronously, hence faster.
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
  var valid_580134 = query.getOrDefault("key")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "key", valid_580134
  var valid_580135 = query.getOrDefault("prettyPrint")
  valid_580135 = validateParameter(valid_580135, JBool, required = false,
                                 default = newJBool(true))
  if valid_580135 != nil:
    section.add "prettyPrint", valid_580135
  var valid_580136 = query.getOrDefault("oauth_token")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "oauth_token", valid_580136
  var valid_580137 = query.getOrDefault("$.xgafv")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = newJString("1"))
  if valid_580137 != nil:
    section.add "$.xgafv", valid_580137
  var valid_580138 = query.getOrDefault("disableFastProcess")
  valid_580138 = validateParameter(valid_580138, JBool, required = false, default = nil)
  if valid_580138 != nil:
    section.add "disableFastProcess", valid_580138
  var valid_580139 = query.getOrDefault("alt")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = newJString("json"))
  if valid_580139 != nil:
    section.add "alt", valid_580139
  var valid_580140 = query.getOrDefault("uploadType")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "uploadType", valid_580140
  var valid_580141 = query.getOrDefault("quotaUser")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "quotaUser", valid_580141
  var valid_580142 = query.getOrDefault("callback")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "callback", valid_580142
  var valid_580143 = query.getOrDefault("fields")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "fields", valid_580143
  var valid_580144 = query.getOrDefault("access_token")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "access_token", valid_580144
  var valid_580145 = query.getOrDefault("upload_protocol")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "upload_protocol", valid_580145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580146: Call_JobsCompaniesDelete_580130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified company.
  ## 
  let valid = call_580146.validator(path, query, header, formData, body)
  let scheme = call_580146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580146.url(scheme.get, call_580146.host, call_580146.base,
                         call_580146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580146, url, valid)

proc call*(call_580147: Call_JobsCompaniesDelete_580130; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; disableFastProcess: bool = false; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## jobsCompaniesDelete
  ## Deletes the specified company.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   disableFastProcess: bool
  ##                     : Deprecated. This field is not working anymore.
  ## 
  ## Optional.
  ## 
  ## If set to true, this call waits for all processing steps to complete
  ## before the job is cleaned up. Otherwise, the call returns while some
  ## steps are still taking place asynchronously, hence faster.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the company to be deleted,
  ## such as, "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580148 = newJObject()
  var query_580149 = newJObject()
  add(query_580149, "key", newJString(key))
  add(query_580149, "prettyPrint", newJBool(prettyPrint))
  add(query_580149, "oauth_token", newJString(oauthToken))
  add(query_580149, "$.xgafv", newJString(Xgafv))
  add(query_580149, "disableFastProcess", newJBool(disableFastProcess))
  add(query_580149, "alt", newJString(alt))
  add(query_580149, "uploadType", newJString(uploadType))
  add(query_580149, "quotaUser", newJString(quotaUser))
  add(path_580148, "name", newJString(name))
  add(query_580149, "callback", newJString(callback))
  add(query_580149, "fields", newJString(fields))
  add(query_580149, "access_token", newJString(accessToken))
  add(query_580149, "upload_protocol", newJString(uploadProtocol))
  result = call_580147.call(path_580148, query_580149, nil, nil, nil)

var jobsCompaniesDelete* = Call_JobsCompaniesDelete_580130(
    name: "jobsCompaniesDelete", meth: HttpMethod.HttpDelete,
    host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesDelete_580131, base: "/",
    url: url_JobsCompaniesDelete_580132, schemes: {Scheme.Https})
type
  Call_JobsComplete_580172 = ref object of OpenApiRestCall_579373
proc url_JobsComplete_580174(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_JobsComplete_580173(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Completes the specified prefix with job keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
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
  ##   scope: JString
  ##        : Optional. The scope of the completion. The defaults is CompletionScope.PUBLIC.
  ##   pageSize: JInt
  ##           : Required. Completion result count.
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
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : Required. The language of the query. This is
  ## the BCP-47 language code, such as "en-US" or "sr-Latn".
  ## For more information, see
  ## [Tags for Identifying Languages](https://tools.ietf.org/html/bcp47).
  ## 
  ## For CompletionType.JOB_TITLE type, only open jobs with same
  ## language_code are returned.
  ## 
  ## For CompletionType.COMPANY_NAME type,
  ## only companies having open jobs with same language_code are
  ## returned.
  ## 
  ## For CompletionType.COMBINED type, only open jobs with same
  ## language_code or companies having open jobs with same
  ## language_code are returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   companyName: JString
  ##              : Optional. If provided, restricts completion to the specified company.
  section = newJObject()
  var valid_580175 = query.getOrDefault("key")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "key", valid_580175
  var valid_580176 = query.getOrDefault("prettyPrint")
  valid_580176 = validateParameter(valid_580176, JBool, required = false,
                                 default = newJBool(true))
  if valid_580176 != nil:
    section.add "prettyPrint", valid_580176
  var valid_580177 = query.getOrDefault("oauth_token")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "oauth_token", valid_580177
  var valid_580178 = query.getOrDefault("$.xgafv")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = newJString("1"))
  if valid_580178 != nil:
    section.add "$.xgafv", valid_580178
  var valid_580179 = query.getOrDefault("scope")
  valid_580179 = validateParameter(valid_580179, JString, required = false, default = newJString(
      "COMPLETION_SCOPE_UNSPECIFIED"))
  if valid_580179 != nil:
    section.add "scope", valid_580179
  var valid_580180 = query.getOrDefault("pageSize")
  valid_580180 = validateParameter(valid_580180, JInt, required = false, default = nil)
  if valid_580180 != nil:
    section.add "pageSize", valid_580180
  var valid_580181 = query.getOrDefault("alt")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = newJString("json"))
  if valid_580181 != nil:
    section.add "alt", valid_580181
  var valid_580182 = query.getOrDefault("uploadType")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "uploadType", valid_580182
  var valid_580183 = query.getOrDefault("quotaUser")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "quotaUser", valid_580183
  var valid_580184 = query.getOrDefault("type")
  valid_580184 = validateParameter(valid_580184, JString, required = false, default = newJString(
      "COMPLETION_TYPE_UNSPECIFIED"))
  if valid_580184 != nil:
    section.add "type", valid_580184
  var valid_580185 = query.getOrDefault("query")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "query", valid_580185
  var valid_580186 = query.getOrDefault("callback")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "callback", valid_580186
  var valid_580187 = query.getOrDefault("languageCode")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "languageCode", valid_580187
  var valid_580188 = query.getOrDefault("fields")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "fields", valid_580188
  var valid_580189 = query.getOrDefault("access_token")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "access_token", valid_580189
  var valid_580190 = query.getOrDefault("upload_protocol")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "upload_protocol", valid_580190
  var valid_580191 = query.getOrDefault("companyName")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "companyName", valid_580191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580192: Call_JobsComplete_580172; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Completes the specified prefix with job keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_JobsComplete_580172; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          scope: string = "COMPLETION_SCOPE_UNSPECIFIED"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          `type`: string = "COMPLETION_TYPE_UNSPECIFIED"; query: string = "";
          callback: string = ""; languageCode: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          companyName: string = ""): Recallable =
  ## jobsComplete
  ## Completes the specified prefix with job keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scope: string
  ##        : Optional. The scope of the completion. The defaults is CompletionScope.PUBLIC.
  ##   pageSize: int
  ##           : Required. Completion result count.
  ## The maximum allowed page size is 10.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   type: string
  ##       : Optional. The completion topic. The default is CompletionType.COMBINED.
  ##   query: string
  ##        : Required. The query used to generate suggestions.
  ##   callback: string
  ##           : JSONP
  ##   languageCode: string
  ##               : Required. The language of the query. This is
  ## the BCP-47 language code, such as "en-US" or "sr-Latn".
  ## For more information, see
  ## [Tags for Identifying Languages](https://tools.ietf.org/html/bcp47).
  ## 
  ## For CompletionType.JOB_TITLE type, only open jobs with same
  ## language_code are returned.
  ## 
  ## For CompletionType.COMPANY_NAME type,
  ## only companies having open jobs with same language_code are
  ## returned.
  ## 
  ## For CompletionType.COMBINED type, only open jobs with same
  ## language_code or companies having open jobs with same
  ## language_code are returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   companyName: string
  ##              : Optional. If provided, restricts completion to the specified company.
  var query_580194 = newJObject()
  add(query_580194, "key", newJString(key))
  add(query_580194, "prettyPrint", newJBool(prettyPrint))
  add(query_580194, "oauth_token", newJString(oauthToken))
  add(query_580194, "$.xgafv", newJString(Xgafv))
  add(query_580194, "scope", newJString(scope))
  add(query_580194, "pageSize", newJInt(pageSize))
  add(query_580194, "alt", newJString(alt))
  add(query_580194, "uploadType", newJString(uploadType))
  add(query_580194, "quotaUser", newJString(quotaUser))
  add(query_580194, "type", newJString(`type`))
  add(query_580194, "query", newJString(query))
  add(query_580194, "callback", newJString(callback))
  add(query_580194, "languageCode", newJString(languageCode))
  add(query_580194, "fields", newJString(fields))
  add(query_580194, "access_token", newJString(accessToken))
  add(query_580194, "upload_protocol", newJString(uploadProtocol))
  add(query_580194, "companyName", newJString(companyName))
  result = call_580193.call(nil, query_580194, nil, nil, nil)

var jobsComplete* = Call_JobsComplete_580172(name: "jobsComplete",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2:complete",
    validator: validate_JobsComplete_580173, base: "/", url: url_JobsComplete_580174,
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
