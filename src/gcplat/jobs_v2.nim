
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  Call_JobsCompaniesCreate_578894 = ref object of OpenApiRestCall_578348
proc url_JobsCompaniesCreate_578896(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsCompaniesCreate_578895(path: JsonNode; query: JsonNode;
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
  var valid_578897 = query.getOrDefault("key")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "key", valid_578897
  var valid_578898 = query.getOrDefault("prettyPrint")
  valid_578898 = validateParameter(valid_578898, JBool, required = false,
                                 default = newJBool(true))
  if valid_578898 != nil:
    section.add "prettyPrint", valid_578898
  var valid_578899 = query.getOrDefault("oauth_token")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "oauth_token", valid_578899
  var valid_578900 = query.getOrDefault("$.xgafv")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = newJString("1"))
  if valid_578900 != nil:
    section.add "$.xgafv", valid_578900
  var valid_578901 = query.getOrDefault("alt")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = newJString("json"))
  if valid_578901 != nil:
    section.add "alt", valid_578901
  var valid_578902 = query.getOrDefault("uploadType")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "uploadType", valid_578902
  var valid_578903 = query.getOrDefault("quotaUser")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "quotaUser", valid_578903
  var valid_578904 = query.getOrDefault("callback")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "callback", valid_578904
  var valid_578905 = query.getOrDefault("fields")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "fields", valid_578905
  var valid_578906 = query.getOrDefault("access_token")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "access_token", valid_578906
  var valid_578907 = query.getOrDefault("upload_protocol")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "upload_protocol", valid_578907
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

proc call*(call_578909: Call_JobsCompaniesCreate_578894; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new company entity.
  ## 
  let valid = call_578909.validator(path, query, header, formData, body)
  let scheme = call_578909.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578909.url(scheme.get, call_578909.host, call_578909.base,
                         call_578909.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578909, url, valid)

proc call*(call_578910: Call_JobsCompaniesCreate_578894; key: string = "";
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
  var query_578911 = newJObject()
  var body_578912 = newJObject()
  add(query_578911, "key", newJString(key))
  add(query_578911, "prettyPrint", newJBool(prettyPrint))
  add(query_578911, "oauth_token", newJString(oauthToken))
  add(query_578911, "$.xgafv", newJString(Xgafv))
  add(query_578911, "alt", newJString(alt))
  add(query_578911, "uploadType", newJString(uploadType))
  add(query_578911, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578912 = body
  add(query_578911, "callback", newJString(callback))
  add(query_578911, "fields", newJString(fields))
  add(query_578911, "access_token", newJString(accessToken))
  add(query_578911, "upload_protocol", newJString(uploadProtocol))
  result = call_578910.call(nil, query_578911, nil, nil, body_578912)

var jobsCompaniesCreate* = Call_JobsCompaniesCreate_578894(
    name: "jobsCompaniesCreate", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/companies",
    validator: validate_JobsCompaniesCreate_578895, base: "/",
    url: url_JobsCompaniesCreate_578896, schemes: {Scheme.Https})
type
  Call_JobsCompaniesList_578619 = ref object of OpenApiRestCall_578348
proc url_JobsCompaniesList_578621(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsCompaniesList_578620(path: JsonNode; query: JsonNode;
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
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578747 = query.getOrDefault("prettyPrint")
  valid_578747 = validateParameter(valid_578747, JBool, required = false,
                                 default = newJBool(true))
  if valid_578747 != nil:
    section.add "prettyPrint", valid_578747
  var valid_578748 = query.getOrDefault("oauth_token")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "oauth_token", valid_578748
  var valid_578749 = query.getOrDefault("mustHaveOpenJobs")
  valid_578749 = validateParameter(valid_578749, JBool, required = false, default = nil)
  if valid_578749 != nil:
    section.add "mustHaveOpenJobs", valid_578749
  var valid_578750 = query.getOrDefault("$.xgafv")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = newJString("1"))
  if valid_578750 != nil:
    section.add "$.xgafv", valid_578750
  var valid_578751 = query.getOrDefault("pageSize")
  valid_578751 = validateParameter(valid_578751, JInt, required = false, default = nil)
  if valid_578751 != nil:
    section.add "pageSize", valid_578751
  var valid_578752 = query.getOrDefault("alt")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = newJString("json"))
  if valid_578752 != nil:
    section.add "alt", valid_578752
  var valid_578753 = query.getOrDefault("uploadType")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "uploadType", valid_578753
  var valid_578754 = query.getOrDefault("quotaUser")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "quotaUser", valid_578754
  var valid_578755 = query.getOrDefault("pageToken")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "pageToken", valid_578755
  var valid_578756 = query.getOrDefault("callback")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "callback", valid_578756
  var valid_578757 = query.getOrDefault("fields")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "fields", valid_578757
  var valid_578758 = query.getOrDefault("access_token")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "access_token", valid_578758
  var valid_578759 = query.getOrDefault("upload_protocol")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "upload_protocol", valid_578759
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578782: Call_JobsCompaniesList_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all companies associated with a Cloud Talent Solution account.
  ## 
  let valid = call_578782.validator(path, query, header, formData, body)
  let scheme = call_578782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578782.url(scheme.get, call_578782.host, call_578782.base,
                         call_578782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578782, url, valid)

proc call*(call_578853: Call_JobsCompaniesList_578619; key: string = "";
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
  var query_578854 = newJObject()
  add(query_578854, "key", newJString(key))
  add(query_578854, "prettyPrint", newJBool(prettyPrint))
  add(query_578854, "oauth_token", newJString(oauthToken))
  add(query_578854, "mustHaveOpenJobs", newJBool(mustHaveOpenJobs))
  add(query_578854, "$.xgafv", newJString(Xgafv))
  add(query_578854, "pageSize", newJInt(pageSize))
  add(query_578854, "alt", newJString(alt))
  add(query_578854, "uploadType", newJString(uploadType))
  add(query_578854, "quotaUser", newJString(quotaUser))
  add(query_578854, "pageToken", newJString(pageToken))
  add(query_578854, "callback", newJString(callback))
  add(query_578854, "fields", newJString(fields))
  add(query_578854, "access_token", newJString(accessToken))
  add(query_578854, "upload_protocol", newJString(uploadProtocol))
  result = call_578853.call(nil, query_578854, nil, nil, nil)

var jobsCompaniesList* = Call_JobsCompaniesList_578619(name: "jobsCompaniesList",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/companies",
    validator: validate_JobsCompaniesList_578620, base: "/",
    url: url_JobsCompaniesList_578621, schemes: {Scheme.Https})
type
  Call_JobsJobsCreate_578934 = ref object of OpenApiRestCall_578348
proc url_JobsJobsCreate_578936(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsCreate_578935(path: JsonNode; query: JsonNode;
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
  var valid_578937 = query.getOrDefault("key")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "key", valid_578937
  var valid_578938 = query.getOrDefault("prettyPrint")
  valid_578938 = validateParameter(valid_578938, JBool, required = false,
                                 default = newJBool(true))
  if valid_578938 != nil:
    section.add "prettyPrint", valid_578938
  var valid_578939 = query.getOrDefault("oauth_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "oauth_token", valid_578939
  var valid_578940 = query.getOrDefault("$.xgafv")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = newJString("1"))
  if valid_578940 != nil:
    section.add "$.xgafv", valid_578940
  var valid_578941 = query.getOrDefault("alt")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = newJString("json"))
  if valid_578941 != nil:
    section.add "alt", valid_578941
  var valid_578942 = query.getOrDefault("uploadType")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "uploadType", valid_578942
  var valid_578943 = query.getOrDefault("quotaUser")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "quotaUser", valid_578943
  var valid_578944 = query.getOrDefault("callback")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "callback", valid_578944
  var valid_578945 = query.getOrDefault("fields")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "fields", valid_578945
  var valid_578946 = query.getOrDefault("access_token")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "access_token", valid_578946
  var valid_578947 = query.getOrDefault("upload_protocol")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "upload_protocol", valid_578947
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

proc call*(call_578949: Call_JobsJobsCreate_578934; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job.
  ## 
  ## Typically, the job becomes searchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ## 
  let valid = call_578949.validator(path, query, header, formData, body)
  let scheme = call_578949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578949.url(scheme.get, call_578949.host, call_578949.base,
                         call_578949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578949, url, valid)

proc call*(call_578950: Call_JobsJobsCreate_578934; key: string = "";
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
  var query_578951 = newJObject()
  var body_578952 = newJObject()
  add(query_578951, "key", newJString(key))
  add(query_578951, "prettyPrint", newJBool(prettyPrint))
  add(query_578951, "oauth_token", newJString(oauthToken))
  add(query_578951, "$.xgafv", newJString(Xgafv))
  add(query_578951, "alt", newJString(alt))
  add(query_578951, "uploadType", newJString(uploadType))
  add(query_578951, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578952 = body
  add(query_578951, "callback", newJString(callback))
  add(query_578951, "fields", newJString(fields))
  add(query_578951, "access_token", newJString(accessToken))
  add(query_578951, "upload_protocol", newJString(uploadProtocol))
  result = call_578950.call(nil, query_578951, nil, nil, body_578952)

var jobsJobsCreate* = Call_JobsJobsCreate_578934(name: "jobsJobsCreate",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com", route: "/v2/jobs",
    validator: validate_JobsJobsCreate_578935, base: "/", url: url_JobsJobsCreate_578936,
    schemes: {Scheme.Https})
type
  Call_JobsJobsList_578913 = ref object of OpenApiRestCall_578348
proc url_JobsJobsList_578915(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsList_578914(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_578916 = query.getOrDefault("key")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "key", valid_578916
  var valid_578917 = query.getOrDefault("prettyPrint")
  valid_578917 = validateParameter(valid_578917, JBool, required = false,
                                 default = newJBool(true))
  if valid_578917 != nil:
    section.add "prettyPrint", valid_578917
  var valid_578918 = query.getOrDefault("oauth_token")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "oauth_token", valid_578918
  var valid_578919 = query.getOrDefault("idsOnly")
  valid_578919 = validateParameter(valid_578919, JBool, required = false, default = nil)
  if valid_578919 != nil:
    section.add "idsOnly", valid_578919
  var valid_578920 = query.getOrDefault("$.xgafv")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = newJString("1"))
  if valid_578920 != nil:
    section.add "$.xgafv", valid_578920
  var valid_578921 = query.getOrDefault("pageSize")
  valid_578921 = validateParameter(valid_578921, JInt, required = false, default = nil)
  if valid_578921 != nil:
    section.add "pageSize", valid_578921
  var valid_578922 = query.getOrDefault("alt")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = newJString("json"))
  if valid_578922 != nil:
    section.add "alt", valid_578922
  var valid_578923 = query.getOrDefault("uploadType")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "uploadType", valid_578923
  var valid_578924 = query.getOrDefault("quotaUser")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "quotaUser", valid_578924
  var valid_578925 = query.getOrDefault("filter")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "filter", valid_578925
  var valid_578926 = query.getOrDefault("pageToken")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "pageToken", valid_578926
  var valid_578927 = query.getOrDefault("callback")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "callback", valid_578927
  var valid_578928 = query.getOrDefault("fields")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "fields", valid_578928
  var valid_578929 = query.getOrDefault("access_token")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "access_token", valid_578929
  var valid_578930 = query.getOrDefault("upload_protocol")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "upload_protocol", valid_578930
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578931: Call_JobsJobsList_578913; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs by filter.
  ## 
  let valid = call_578931.validator(path, query, header, formData, body)
  let scheme = call_578931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578931.url(scheme.get, call_578931.host, call_578931.base,
                         call_578931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578931, url, valid)

proc call*(call_578932: Call_JobsJobsList_578913; key: string = "";
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
  var query_578933 = newJObject()
  add(query_578933, "key", newJString(key))
  add(query_578933, "prettyPrint", newJBool(prettyPrint))
  add(query_578933, "oauth_token", newJString(oauthToken))
  add(query_578933, "idsOnly", newJBool(idsOnly))
  add(query_578933, "$.xgafv", newJString(Xgafv))
  add(query_578933, "pageSize", newJInt(pageSize))
  add(query_578933, "alt", newJString(alt))
  add(query_578933, "uploadType", newJString(uploadType))
  add(query_578933, "quotaUser", newJString(quotaUser))
  add(query_578933, "filter", newJString(filter))
  add(query_578933, "pageToken", newJString(pageToken))
  add(query_578933, "callback", newJString(callback))
  add(query_578933, "fields", newJString(fields))
  add(query_578933, "access_token", newJString(accessToken))
  add(query_578933, "upload_protocol", newJString(uploadProtocol))
  result = call_578932.call(nil, query_578933, nil, nil, nil)

var jobsJobsList* = Call_JobsJobsList_578913(name: "jobsJobsList",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/jobs",
    validator: validate_JobsJobsList_578914, base: "/", url: url_JobsJobsList_578915,
    schemes: {Scheme.Https})
type
  Call_JobsJobsBatchDelete_578953 = ref object of OpenApiRestCall_578348
proc url_JobsJobsBatchDelete_578955(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsBatchDelete_578954(path: JsonNode; query: JsonNode;
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
  var valid_578956 = query.getOrDefault("key")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "key", valid_578956
  var valid_578957 = query.getOrDefault("prettyPrint")
  valid_578957 = validateParameter(valid_578957, JBool, required = false,
                                 default = newJBool(true))
  if valid_578957 != nil:
    section.add "prettyPrint", valid_578957
  var valid_578958 = query.getOrDefault("oauth_token")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "oauth_token", valid_578958
  var valid_578959 = query.getOrDefault("$.xgafv")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = newJString("1"))
  if valid_578959 != nil:
    section.add "$.xgafv", valid_578959
  var valid_578960 = query.getOrDefault("alt")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = newJString("json"))
  if valid_578960 != nil:
    section.add "alt", valid_578960
  var valid_578961 = query.getOrDefault("uploadType")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "uploadType", valid_578961
  var valid_578962 = query.getOrDefault("quotaUser")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "quotaUser", valid_578962
  var valid_578963 = query.getOrDefault("callback")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "callback", valid_578963
  var valid_578964 = query.getOrDefault("fields")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "fields", valid_578964
  var valid_578965 = query.getOrDefault("access_token")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "access_token", valid_578965
  var valid_578966 = query.getOrDefault("upload_protocol")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "upload_protocol", valid_578966
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

proc call*(call_578968: Call_JobsJobsBatchDelete_578953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a list of Job postings by filter.
  ## 
  let valid = call_578968.validator(path, query, header, formData, body)
  let scheme = call_578968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578968.url(scheme.get, call_578968.host, call_578968.base,
                         call_578968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578968, url, valid)

proc call*(call_578969: Call_JobsJobsBatchDelete_578953; key: string = "";
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
  var query_578970 = newJObject()
  var body_578971 = newJObject()
  add(query_578970, "key", newJString(key))
  add(query_578970, "prettyPrint", newJBool(prettyPrint))
  add(query_578970, "oauth_token", newJString(oauthToken))
  add(query_578970, "$.xgafv", newJString(Xgafv))
  add(query_578970, "alt", newJString(alt))
  add(query_578970, "uploadType", newJString(uploadType))
  add(query_578970, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578971 = body
  add(query_578970, "callback", newJString(callback))
  add(query_578970, "fields", newJString(fields))
  add(query_578970, "access_token", newJString(accessToken))
  add(query_578970, "upload_protocol", newJString(uploadProtocol))
  result = call_578969.call(nil, query_578970, nil, nil, body_578971)

var jobsJobsBatchDelete* = Call_JobsJobsBatchDelete_578953(
    name: "jobsJobsBatchDelete", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:batchDelete",
    validator: validate_JobsJobsBatchDelete_578954, base: "/",
    url: url_JobsJobsBatchDelete_578955, schemes: {Scheme.Https})
type
  Call_JobsJobsDeleteByFilter_578972 = ref object of OpenApiRestCall_578348
proc url_JobsJobsDeleteByFilter_578974(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsDeleteByFilter_578973(path: JsonNode; query: JsonNode;
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
  var valid_578975 = query.getOrDefault("key")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "key", valid_578975
  var valid_578976 = query.getOrDefault("prettyPrint")
  valid_578976 = validateParameter(valid_578976, JBool, required = false,
                                 default = newJBool(true))
  if valid_578976 != nil:
    section.add "prettyPrint", valid_578976
  var valid_578977 = query.getOrDefault("oauth_token")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "oauth_token", valid_578977
  var valid_578978 = query.getOrDefault("$.xgafv")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = newJString("1"))
  if valid_578978 != nil:
    section.add "$.xgafv", valid_578978
  var valid_578979 = query.getOrDefault("alt")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = newJString("json"))
  if valid_578979 != nil:
    section.add "alt", valid_578979
  var valid_578980 = query.getOrDefault("uploadType")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "uploadType", valid_578980
  var valid_578981 = query.getOrDefault("quotaUser")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "quotaUser", valid_578981
  var valid_578982 = query.getOrDefault("callback")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "callback", valid_578982
  var valid_578983 = query.getOrDefault("fields")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "fields", valid_578983
  var valid_578984 = query.getOrDefault("access_token")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "access_token", valid_578984
  var valid_578985 = query.getOrDefault("upload_protocol")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "upload_protocol", valid_578985
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

proc call*(call_578987: Call_JobsJobsDeleteByFilter_578972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated. Use BatchDeleteJobs instead.
  ## 
  ## Deletes the specified job by filter. You can specify whether to
  ## synchronously wait for validation, indexing, and general processing to be
  ## completed before the response is returned.
  ## 
  let valid = call_578987.validator(path, query, header, formData, body)
  let scheme = call_578987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578987.url(scheme.get, call_578987.host, call_578987.base,
                         call_578987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578987, url, valid)

proc call*(call_578988: Call_JobsJobsDeleteByFilter_578972; key: string = "";
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
  var query_578989 = newJObject()
  var body_578990 = newJObject()
  add(query_578989, "key", newJString(key))
  add(query_578989, "prettyPrint", newJBool(prettyPrint))
  add(query_578989, "oauth_token", newJString(oauthToken))
  add(query_578989, "$.xgafv", newJString(Xgafv))
  add(query_578989, "alt", newJString(alt))
  add(query_578989, "uploadType", newJString(uploadType))
  add(query_578989, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578990 = body
  add(query_578989, "callback", newJString(callback))
  add(query_578989, "fields", newJString(fields))
  add(query_578989, "access_token", newJString(accessToken))
  add(query_578989, "upload_protocol", newJString(uploadProtocol))
  result = call_578988.call(nil, query_578989, nil, nil, body_578990)

var jobsJobsDeleteByFilter* = Call_JobsJobsDeleteByFilter_578972(
    name: "jobsJobsDeleteByFilter", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:deleteByFilter",
    validator: validate_JobsJobsDeleteByFilter_578973, base: "/",
    url: url_JobsJobsDeleteByFilter_578974, schemes: {Scheme.Https})
type
  Call_JobsJobsHistogram_578991 = ref object of OpenApiRestCall_578348
proc url_JobsJobsHistogram_578993(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsHistogram_578992(path: JsonNode; query: JsonNode;
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
  var valid_578994 = query.getOrDefault("key")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "key", valid_578994
  var valid_578995 = query.getOrDefault("prettyPrint")
  valid_578995 = validateParameter(valid_578995, JBool, required = false,
                                 default = newJBool(true))
  if valid_578995 != nil:
    section.add "prettyPrint", valid_578995
  var valid_578996 = query.getOrDefault("oauth_token")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "oauth_token", valid_578996
  var valid_578997 = query.getOrDefault("$.xgafv")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = newJString("1"))
  if valid_578997 != nil:
    section.add "$.xgafv", valid_578997
  var valid_578998 = query.getOrDefault("alt")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = newJString("json"))
  if valid_578998 != nil:
    section.add "alt", valid_578998
  var valid_578999 = query.getOrDefault("uploadType")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "uploadType", valid_578999
  var valid_579000 = query.getOrDefault("quotaUser")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "quotaUser", valid_579000
  var valid_579001 = query.getOrDefault("callback")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "callback", valid_579001
  var valid_579002 = query.getOrDefault("fields")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "fields", valid_579002
  var valid_579003 = query.getOrDefault("access_token")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "access_token", valid_579003
  var valid_579004 = query.getOrDefault("upload_protocol")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "upload_protocol", valid_579004
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

proc call*(call_579006: Call_JobsJobsHistogram_578991; path: JsonNode;
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
  let valid = call_579006.validator(path, query, header, formData, body)
  let scheme = call_579006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579006.url(scheme.get, call_579006.host, call_579006.base,
                         call_579006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579006, url, valid)

proc call*(call_579007: Call_JobsJobsHistogram_578991; key: string = "";
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
  var query_579008 = newJObject()
  var body_579009 = newJObject()
  add(query_579008, "key", newJString(key))
  add(query_579008, "prettyPrint", newJBool(prettyPrint))
  add(query_579008, "oauth_token", newJString(oauthToken))
  add(query_579008, "$.xgafv", newJString(Xgafv))
  add(query_579008, "alt", newJString(alt))
  add(query_579008, "uploadType", newJString(uploadType))
  add(query_579008, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579009 = body
  add(query_579008, "callback", newJString(callback))
  add(query_579008, "fields", newJString(fields))
  add(query_579008, "access_token", newJString(accessToken))
  add(query_579008, "upload_protocol", newJString(uploadProtocol))
  result = call_579007.call(nil, query_579008, nil, nil, body_579009)

var jobsJobsHistogram* = Call_JobsJobsHistogram_578991(name: "jobsJobsHistogram",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com",
    route: "/v2/jobs:histogram", validator: validate_JobsJobsHistogram_578992,
    base: "/", url: url_JobsJobsHistogram_578993, schemes: {Scheme.Https})
type
  Call_JobsJobsSearch_579010 = ref object of OpenApiRestCall_578348
proc url_JobsJobsSearch_579012(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsSearch_579011(path: JsonNode; query: JsonNode;
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
  var valid_579013 = query.getOrDefault("key")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "key", valid_579013
  var valid_579014 = query.getOrDefault("prettyPrint")
  valid_579014 = validateParameter(valid_579014, JBool, required = false,
                                 default = newJBool(true))
  if valid_579014 != nil:
    section.add "prettyPrint", valid_579014
  var valid_579015 = query.getOrDefault("oauth_token")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "oauth_token", valid_579015
  var valid_579016 = query.getOrDefault("$.xgafv")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = newJString("1"))
  if valid_579016 != nil:
    section.add "$.xgafv", valid_579016
  var valid_579017 = query.getOrDefault("alt")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = newJString("json"))
  if valid_579017 != nil:
    section.add "alt", valid_579017
  var valid_579018 = query.getOrDefault("uploadType")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "uploadType", valid_579018
  var valid_579019 = query.getOrDefault("quotaUser")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "quotaUser", valid_579019
  var valid_579020 = query.getOrDefault("callback")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "callback", valid_579020
  var valid_579021 = query.getOrDefault("fields")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "fields", valid_579021
  var valid_579022 = query.getOrDefault("access_token")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "access_token", valid_579022
  var valid_579023 = query.getOrDefault("upload_protocol")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "upload_protocol", valid_579023
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

proc call*(call_579025: Call_JobsJobsSearch_579010; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs that the caller has
  ## permission to search against.
  ## 
  let valid = call_579025.validator(path, query, header, formData, body)
  let scheme = call_579025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579025.url(scheme.get, call_579025.host, call_579025.base,
                         call_579025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579025, url, valid)

proc call*(call_579026: Call_JobsJobsSearch_579010; key: string = "";
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
  var query_579027 = newJObject()
  var body_579028 = newJObject()
  add(query_579027, "key", newJString(key))
  add(query_579027, "prettyPrint", newJBool(prettyPrint))
  add(query_579027, "oauth_token", newJString(oauthToken))
  add(query_579027, "$.xgafv", newJString(Xgafv))
  add(query_579027, "alt", newJString(alt))
  add(query_579027, "uploadType", newJString(uploadType))
  add(query_579027, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579028 = body
  add(query_579027, "callback", newJString(callback))
  add(query_579027, "fields", newJString(fields))
  add(query_579027, "access_token", newJString(accessToken))
  add(query_579027, "upload_protocol", newJString(uploadProtocol))
  result = call_579026.call(nil, query_579027, nil, nil, body_579028)

var jobsJobsSearch* = Call_JobsJobsSearch_579010(name: "jobsJobsSearch",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com",
    route: "/v2/jobs:search", validator: validate_JobsJobsSearch_579011, base: "/",
    url: url_JobsJobsSearch_579012, schemes: {Scheme.Https})
type
  Call_JobsJobsSearchForAlert_579029 = ref object of OpenApiRestCall_578348
proc url_JobsJobsSearchForAlert_579031(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsSearchForAlert_579030(path: JsonNode; query: JsonNode;
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
  var valid_579032 = query.getOrDefault("key")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "key", valid_579032
  var valid_579033 = query.getOrDefault("prettyPrint")
  valid_579033 = validateParameter(valid_579033, JBool, required = false,
                                 default = newJBool(true))
  if valid_579033 != nil:
    section.add "prettyPrint", valid_579033
  var valid_579034 = query.getOrDefault("oauth_token")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "oauth_token", valid_579034
  var valid_579035 = query.getOrDefault("$.xgafv")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = newJString("1"))
  if valid_579035 != nil:
    section.add "$.xgafv", valid_579035
  var valid_579036 = query.getOrDefault("alt")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = newJString("json"))
  if valid_579036 != nil:
    section.add "alt", valid_579036
  var valid_579037 = query.getOrDefault("uploadType")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "uploadType", valid_579037
  var valid_579038 = query.getOrDefault("quotaUser")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "quotaUser", valid_579038
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579044: Call_JobsJobsSearchForAlert_579029; path: JsonNode;
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
  let valid = call_579044.validator(path, query, header, formData, body)
  let scheme = call_579044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579044.url(scheme.get, call_579044.host, call_579044.base,
                         call_579044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579044, url, valid)

proc call*(call_579045: Call_JobsJobsSearchForAlert_579029; key: string = "";
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
  var query_579046 = newJObject()
  var body_579047 = newJObject()
  add(query_579046, "key", newJString(key))
  add(query_579046, "prettyPrint", newJBool(prettyPrint))
  add(query_579046, "oauth_token", newJString(oauthToken))
  add(query_579046, "$.xgafv", newJString(Xgafv))
  add(query_579046, "alt", newJString(alt))
  add(query_579046, "uploadType", newJString(uploadType))
  add(query_579046, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579047 = body
  add(query_579046, "callback", newJString(callback))
  add(query_579046, "fields", newJString(fields))
  add(query_579046, "access_token", newJString(accessToken))
  add(query_579046, "upload_protocol", newJString(uploadProtocol))
  result = call_579045.call(nil, query_579046, nil, nil, body_579047)

var jobsJobsSearchForAlert* = Call_JobsJobsSearchForAlert_579029(
    name: "jobsJobsSearchForAlert", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:searchForAlert",
    validator: validate_JobsJobsSearchForAlert_579030, base: "/",
    url: url_JobsJobsSearchForAlert_579031, schemes: {Scheme.Https})
type
  Call_JobsCompaniesJobsList_579048 = ref object of OpenApiRestCall_578348
proc url_JobsCompaniesJobsList_579050(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_JobsCompaniesJobsList_579049(path: JsonNode; query: JsonNode;
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
  var valid_579065 = path.getOrDefault("companyName")
  valid_579065 = validateParameter(valid_579065, JString, required = true,
                                 default = nil)
  if valid_579065 != nil:
    section.add "companyName", valid_579065
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
  var valid_579066 = query.getOrDefault("key")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "key", valid_579066
  var valid_579067 = query.getOrDefault("prettyPrint")
  valid_579067 = validateParameter(valid_579067, JBool, required = false,
                                 default = newJBool(true))
  if valid_579067 != nil:
    section.add "prettyPrint", valid_579067
  var valid_579068 = query.getOrDefault("oauth_token")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "oauth_token", valid_579068
  var valid_579069 = query.getOrDefault("idsOnly")
  valid_579069 = validateParameter(valid_579069, JBool, required = false, default = nil)
  if valid_579069 != nil:
    section.add "idsOnly", valid_579069
  var valid_579070 = query.getOrDefault("$.xgafv")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("1"))
  if valid_579070 != nil:
    section.add "$.xgafv", valid_579070
  var valid_579071 = query.getOrDefault("pageSize")
  valid_579071 = validateParameter(valid_579071, JInt, required = false, default = nil)
  if valid_579071 != nil:
    section.add "pageSize", valid_579071
  var valid_579072 = query.getOrDefault("alt")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = newJString("json"))
  if valid_579072 != nil:
    section.add "alt", valid_579072
  var valid_579073 = query.getOrDefault("uploadType")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "uploadType", valid_579073
  var valid_579074 = query.getOrDefault("quotaUser")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "quotaUser", valid_579074
  var valid_579075 = query.getOrDefault("includeJobsCount")
  valid_579075 = validateParameter(valid_579075, JBool, required = false, default = nil)
  if valid_579075 != nil:
    section.add "includeJobsCount", valid_579075
  var valid_579076 = query.getOrDefault("jobRequisitionId")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "jobRequisitionId", valid_579076
  var valid_579077 = query.getOrDefault("pageToken")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "pageToken", valid_579077
  var valid_579078 = query.getOrDefault("callback")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "callback", valid_579078
  var valid_579079 = query.getOrDefault("fields")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "fields", valid_579079
  var valid_579080 = query.getOrDefault("access_token")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "access_token", valid_579080
  var valid_579081 = query.getOrDefault("upload_protocol")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "upload_protocol", valid_579081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579082: Call_JobsCompaniesJobsList_579048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated. Use ListJobs instead.
  ## 
  ## Lists all jobs associated with a company.
  ## 
  let valid = call_579082.validator(path, query, header, formData, body)
  let scheme = call_579082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579082.url(scheme.get, call_579082.host, call_579082.base,
                         call_579082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579082, url, valid)

proc call*(call_579083: Call_JobsCompaniesJobsList_579048; companyName: string;
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
  var path_579084 = newJObject()
  var query_579085 = newJObject()
  add(query_579085, "key", newJString(key))
  add(query_579085, "prettyPrint", newJBool(prettyPrint))
  add(query_579085, "oauth_token", newJString(oauthToken))
  add(query_579085, "idsOnly", newJBool(idsOnly))
  add(query_579085, "$.xgafv", newJString(Xgafv))
  add(query_579085, "pageSize", newJInt(pageSize))
  add(path_579084, "companyName", newJString(companyName))
  add(query_579085, "alt", newJString(alt))
  add(query_579085, "uploadType", newJString(uploadType))
  add(query_579085, "quotaUser", newJString(quotaUser))
  add(query_579085, "includeJobsCount", newJBool(includeJobsCount))
  add(query_579085, "jobRequisitionId", newJString(jobRequisitionId))
  add(query_579085, "pageToken", newJString(pageToken))
  add(query_579085, "callback", newJString(callback))
  add(query_579085, "fields", newJString(fields))
  add(query_579085, "access_token", newJString(accessToken))
  add(query_579085, "upload_protocol", newJString(uploadProtocol))
  result = call_579083.call(path_579084, query_579085, nil, nil, nil)

var jobsCompaniesJobsList* = Call_JobsCompaniesJobsList_579048(
    name: "jobsCompaniesJobsList", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v2/{companyName}/jobs",
    validator: validate_JobsCompaniesJobsList_579049, base: "/",
    url: url_JobsCompaniesJobsList_579050, schemes: {Scheme.Https})
type
  Call_JobsCompaniesGet_579086 = ref object of OpenApiRestCall_578348
proc url_JobsCompaniesGet_579088(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_JobsCompaniesGet_579087(path: JsonNode; query: JsonNode;
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
  var valid_579089 = path.getOrDefault("name")
  valid_579089 = validateParameter(valid_579089, JString, required = true,
                                 default = nil)
  if valid_579089 != nil:
    section.add "name", valid_579089
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
  var valid_579090 = query.getOrDefault("key")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "key", valid_579090
  var valid_579091 = query.getOrDefault("prettyPrint")
  valid_579091 = validateParameter(valid_579091, JBool, required = false,
                                 default = newJBool(true))
  if valid_579091 != nil:
    section.add "prettyPrint", valid_579091
  var valid_579092 = query.getOrDefault("oauth_token")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "oauth_token", valid_579092
  var valid_579093 = query.getOrDefault("$.xgafv")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = newJString("1"))
  if valid_579093 != nil:
    section.add "$.xgafv", valid_579093
  var valid_579094 = query.getOrDefault("alt")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = newJString("json"))
  if valid_579094 != nil:
    section.add "alt", valid_579094
  var valid_579095 = query.getOrDefault("uploadType")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "uploadType", valid_579095
  var valid_579096 = query.getOrDefault("quotaUser")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "quotaUser", valid_579096
  var valid_579097 = query.getOrDefault("callback")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "callback", valid_579097
  var valid_579098 = query.getOrDefault("fields")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "fields", valid_579098
  var valid_579099 = query.getOrDefault("access_token")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "access_token", valid_579099
  var valid_579100 = query.getOrDefault("upload_protocol")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "upload_protocol", valid_579100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579101: Call_JobsCompaniesGet_579086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified company.
  ## 
  let valid = call_579101.validator(path, query, header, formData, body)
  let scheme = call_579101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579101.url(scheme.get, call_579101.host, call_579101.base,
                         call_579101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579101, url, valid)

proc call*(call_579102: Call_JobsCompaniesGet_579086; name: string; key: string = "";
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
  var path_579103 = newJObject()
  var query_579104 = newJObject()
  add(query_579104, "key", newJString(key))
  add(query_579104, "prettyPrint", newJBool(prettyPrint))
  add(query_579104, "oauth_token", newJString(oauthToken))
  add(query_579104, "$.xgafv", newJString(Xgafv))
  add(query_579104, "alt", newJString(alt))
  add(query_579104, "uploadType", newJString(uploadType))
  add(query_579104, "quotaUser", newJString(quotaUser))
  add(path_579103, "name", newJString(name))
  add(query_579104, "callback", newJString(callback))
  add(query_579104, "fields", newJString(fields))
  add(query_579104, "access_token", newJString(accessToken))
  add(query_579104, "upload_protocol", newJString(uploadProtocol))
  result = call_579102.call(path_579103, query_579104, nil, nil, nil)

var jobsCompaniesGet* = Call_JobsCompaniesGet_579086(name: "jobsCompaniesGet",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesGet_579087, base: "/",
    url: url_JobsCompaniesGet_579088, schemes: {Scheme.Https})
type
  Call_JobsCompaniesPatch_579125 = ref object of OpenApiRestCall_578348
proc url_JobsCompaniesPatch_579127(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_JobsCompaniesPatch_579126(path: JsonNode; query: JsonNode;
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
  var valid_579128 = path.getOrDefault("name")
  valid_579128 = validateParameter(valid_579128, JString, required = true,
                                 default = nil)
  if valid_579128 != nil:
    section.add "name", valid_579128
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
  var valid_579129 = query.getOrDefault("key")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "key", valid_579129
  var valid_579130 = query.getOrDefault("prettyPrint")
  valid_579130 = validateParameter(valid_579130, JBool, required = false,
                                 default = newJBool(true))
  if valid_579130 != nil:
    section.add "prettyPrint", valid_579130
  var valid_579131 = query.getOrDefault("oauth_token")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "oauth_token", valid_579131
  var valid_579132 = query.getOrDefault("$.xgafv")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = newJString("1"))
  if valid_579132 != nil:
    section.add "$.xgafv", valid_579132
  var valid_579133 = query.getOrDefault("alt")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = newJString("json"))
  if valid_579133 != nil:
    section.add "alt", valid_579133
  var valid_579134 = query.getOrDefault("uploadType")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "uploadType", valid_579134
  var valid_579135 = query.getOrDefault("quotaUser")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "quotaUser", valid_579135
  var valid_579136 = query.getOrDefault("updateCompanyFields")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "updateCompanyFields", valid_579136
  var valid_579137 = query.getOrDefault("callback")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "callback", valid_579137
  var valid_579138 = query.getOrDefault("fields")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "fields", valid_579138
  var valid_579139 = query.getOrDefault("access_token")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "access_token", valid_579139
  var valid_579140 = query.getOrDefault("upload_protocol")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "upload_protocol", valid_579140
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

proc call*(call_579142: Call_JobsCompaniesPatch_579125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified company. Company names can't be updated. To update a
  ## company name, delete the company and all jobs associated with it, and only
  ## then re-create them.
  ## 
  let valid = call_579142.validator(path, query, header, formData, body)
  let scheme = call_579142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579142.url(scheme.get, call_579142.host, call_579142.base,
                         call_579142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579142, url, valid)

proc call*(call_579143: Call_JobsCompaniesPatch_579125; name: string;
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
  var path_579144 = newJObject()
  var query_579145 = newJObject()
  var body_579146 = newJObject()
  add(query_579145, "key", newJString(key))
  add(query_579145, "prettyPrint", newJBool(prettyPrint))
  add(query_579145, "oauth_token", newJString(oauthToken))
  add(query_579145, "$.xgafv", newJString(Xgafv))
  add(query_579145, "alt", newJString(alt))
  add(query_579145, "uploadType", newJString(uploadType))
  add(query_579145, "quotaUser", newJString(quotaUser))
  add(path_579144, "name", newJString(name))
  if body != nil:
    body_579146 = body
  add(query_579145, "updateCompanyFields", newJString(updateCompanyFields))
  add(query_579145, "callback", newJString(callback))
  add(query_579145, "fields", newJString(fields))
  add(query_579145, "access_token", newJString(accessToken))
  add(query_579145, "upload_protocol", newJString(uploadProtocol))
  result = call_579143.call(path_579144, query_579145, nil, nil, body_579146)

var jobsCompaniesPatch* = Call_JobsCompaniesPatch_579125(
    name: "jobsCompaniesPatch", meth: HttpMethod.HttpPatch,
    host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesPatch_579126, base: "/",
    url: url_JobsCompaniesPatch_579127, schemes: {Scheme.Https})
type
  Call_JobsCompaniesDelete_579105 = ref object of OpenApiRestCall_578348
proc url_JobsCompaniesDelete_579107(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_JobsCompaniesDelete_579106(path: JsonNode; query: JsonNode;
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
  var valid_579108 = path.getOrDefault("name")
  valid_579108 = validateParameter(valid_579108, JString, required = true,
                                 default = nil)
  if valid_579108 != nil:
    section.add "name", valid_579108
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
  var valid_579109 = query.getOrDefault("key")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "key", valid_579109
  var valid_579110 = query.getOrDefault("prettyPrint")
  valid_579110 = validateParameter(valid_579110, JBool, required = false,
                                 default = newJBool(true))
  if valid_579110 != nil:
    section.add "prettyPrint", valid_579110
  var valid_579111 = query.getOrDefault("oauth_token")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "oauth_token", valid_579111
  var valid_579112 = query.getOrDefault("$.xgafv")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = newJString("1"))
  if valid_579112 != nil:
    section.add "$.xgafv", valid_579112
  var valid_579113 = query.getOrDefault("disableFastProcess")
  valid_579113 = validateParameter(valid_579113, JBool, required = false, default = nil)
  if valid_579113 != nil:
    section.add "disableFastProcess", valid_579113
  var valid_579114 = query.getOrDefault("alt")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = newJString("json"))
  if valid_579114 != nil:
    section.add "alt", valid_579114
  var valid_579115 = query.getOrDefault("uploadType")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "uploadType", valid_579115
  var valid_579116 = query.getOrDefault("quotaUser")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "quotaUser", valid_579116
  var valid_579117 = query.getOrDefault("callback")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "callback", valid_579117
  var valid_579118 = query.getOrDefault("fields")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "fields", valid_579118
  var valid_579119 = query.getOrDefault("access_token")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "access_token", valid_579119
  var valid_579120 = query.getOrDefault("upload_protocol")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "upload_protocol", valid_579120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579121: Call_JobsCompaniesDelete_579105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified company.
  ## 
  let valid = call_579121.validator(path, query, header, formData, body)
  let scheme = call_579121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579121.url(scheme.get, call_579121.host, call_579121.base,
                         call_579121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579121, url, valid)

proc call*(call_579122: Call_JobsCompaniesDelete_579105; name: string;
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
  var path_579123 = newJObject()
  var query_579124 = newJObject()
  add(query_579124, "key", newJString(key))
  add(query_579124, "prettyPrint", newJBool(prettyPrint))
  add(query_579124, "oauth_token", newJString(oauthToken))
  add(query_579124, "$.xgafv", newJString(Xgafv))
  add(query_579124, "disableFastProcess", newJBool(disableFastProcess))
  add(query_579124, "alt", newJString(alt))
  add(query_579124, "uploadType", newJString(uploadType))
  add(query_579124, "quotaUser", newJString(quotaUser))
  add(path_579123, "name", newJString(name))
  add(query_579124, "callback", newJString(callback))
  add(query_579124, "fields", newJString(fields))
  add(query_579124, "access_token", newJString(accessToken))
  add(query_579124, "upload_protocol", newJString(uploadProtocol))
  result = call_579122.call(path_579123, query_579124, nil, nil, nil)

var jobsCompaniesDelete* = Call_JobsCompaniesDelete_579105(
    name: "jobsCompaniesDelete", meth: HttpMethod.HttpDelete,
    host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesDelete_579106, base: "/",
    url: url_JobsCompaniesDelete_579107, schemes: {Scheme.Https})
type
  Call_JobsComplete_579147 = ref object of OpenApiRestCall_578348
proc url_JobsComplete_579149(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsComplete_579148(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_579150 = query.getOrDefault("key")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "key", valid_579150
  var valid_579151 = query.getOrDefault("prettyPrint")
  valid_579151 = validateParameter(valid_579151, JBool, required = false,
                                 default = newJBool(true))
  if valid_579151 != nil:
    section.add "prettyPrint", valid_579151
  var valid_579152 = query.getOrDefault("oauth_token")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "oauth_token", valid_579152
  var valid_579153 = query.getOrDefault("$.xgafv")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = newJString("1"))
  if valid_579153 != nil:
    section.add "$.xgafv", valid_579153
  var valid_579154 = query.getOrDefault("scope")
  valid_579154 = validateParameter(valid_579154, JString, required = false, default = newJString(
      "COMPLETION_SCOPE_UNSPECIFIED"))
  if valid_579154 != nil:
    section.add "scope", valid_579154
  var valid_579155 = query.getOrDefault("pageSize")
  valid_579155 = validateParameter(valid_579155, JInt, required = false, default = nil)
  if valid_579155 != nil:
    section.add "pageSize", valid_579155
  var valid_579156 = query.getOrDefault("alt")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = newJString("json"))
  if valid_579156 != nil:
    section.add "alt", valid_579156
  var valid_579157 = query.getOrDefault("uploadType")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "uploadType", valid_579157
  var valid_579158 = query.getOrDefault("quotaUser")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "quotaUser", valid_579158
  var valid_579159 = query.getOrDefault("type")
  valid_579159 = validateParameter(valid_579159, JString, required = false, default = newJString(
      "COMPLETION_TYPE_UNSPECIFIED"))
  if valid_579159 != nil:
    section.add "type", valid_579159
  var valid_579160 = query.getOrDefault("query")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "query", valid_579160
  var valid_579161 = query.getOrDefault("callback")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "callback", valid_579161
  var valid_579162 = query.getOrDefault("languageCode")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "languageCode", valid_579162
  var valid_579163 = query.getOrDefault("fields")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "fields", valid_579163
  var valid_579164 = query.getOrDefault("access_token")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "access_token", valid_579164
  var valid_579165 = query.getOrDefault("upload_protocol")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "upload_protocol", valid_579165
  var valid_579166 = query.getOrDefault("companyName")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "companyName", valid_579166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579167: Call_JobsComplete_579147; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Completes the specified prefix with job keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ## 
  let valid = call_579167.validator(path, query, header, formData, body)
  let scheme = call_579167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579167.url(scheme.get, call_579167.host, call_579167.base,
                         call_579167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579167, url, valid)

proc call*(call_579168: Call_JobsComplete_579147; key: string = "";
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
  var query_579169 = newJObject()
  add(query_579169, "key", newJString(key))
  add(query_579169, "prettyPrint", newJBool(prettyPrint))
  add(query_579169, "oauth_token", newJString(oauthToken))
  add(query_579169, "$.xgafv", newJString(Xgafv))
  add(query_579169, "scope", newJString(scope))
  add(query_579169, "pageSize", newJInt(pageSize))
  add(query_579169, "alt", newJString(alt))
  add(query_579169, "uploadType", newJString(uploadType))
  add(query_579169, "quotaUser", newJString(quotaUser))
  add(query_579169, "type", newJString(`type`))
  add(query_579169, "query", newJString(query))
  add(query_579169, "callback", newJString(callback))
  add(query_579169, "languageCode", newJString(languageCode))
  add(query_579169, "fields", newJString(fields))
  add(query_579169, "access_token", newJString(accessToken))
  add(query_579169, "upload_protocol", newJString(uploadProtocol))
  add(query_579169, "companyName", newJString(companyName))
  result = call_579168.call(nil, query_579169, nil, nil, nil)

var jobsComplete* = Call_JobsComplete_579147(name: "jobsComplete",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2:complete",
    validator: validate_JobsComplete_579148, base: "/", url: url_JobsComplete_579149,
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
