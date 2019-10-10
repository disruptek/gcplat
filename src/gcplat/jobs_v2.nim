
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
  Call_JobsCompaniesCreate_588994 = ref object of OpenApiRestCall_588450
proc url_JobsCompaniesCreate_588996(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsCompaniesCreate_588995(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new company entity.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_588997 = query.getOrDefault("upload_protocol")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "upload_protocol", valid_588997
  var valid_588998 = query.getOrDefault("fields")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "fields", valid_588998
  var valid_588999 = query.getOrDefault("quotaUser")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "quotaUser", valid_588999
  var valid_589000 = query.getOrDefault("alt")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = newJString("json"))
  if valid_589000 != nil:
    section.add "alt", valid_589000
  var valid_589001 = query.getOrDefault("oauth_token")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "oauth_token", valid_589001
  var valid_589002 = query.getOrDefault("callback")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "callback", valid_589002
  var valid_589003 = query.getOrDefault("access_token")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "access_token", valid_589003
  var valid_589004 = query.getOrDefault("uploadType")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "uploadType", valid_589004
  var valid_589005 = query.getOrDefault("key")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "key", valid_589005
  var valid_589006 = query.getOrDefault("$.xgafv")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = newJString("1"))
  if valid_589006 != nil:
    section.add "$.xgafv", valid_589006
  var valid_589007 = query.getOrDefault("prettyPrint")
  valid_589007 = validateParameter(valid_589007, JBool, required = false,
                                 default = newJBool(true))
  if valid_589007 != nil:
    section.add "prettyPrint", valid_589007
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

proc call*(call_589009: Call_JobsCompaniesCreate_588994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new company entity.
  ## 
  let valid = call_589009.validator(path, query, header, formData, body)
  let scheme = call_589009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589009.url(scheme.get, call_589009.host, call_589009.base,
                         call_589009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589009, url, valid)

proc call*(call_589010: Call_JobsCompaniesCreate_588994;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsCompaniesCreate
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589011 = newJObject()
  var body_589012 = newJObject()
  add(query_589011, "upload_protocol", newJString(uploadProtocol))
  add(query_589011, "fields", newJString(fields))
  add(query_589011, "quotaUser", newJString(quotaUser))
  add(query_589011, "alt", newJString(alt))
  add(query_589011, "oauth_token", newJString(oauthToken))
  add(query_589011, "callback", newJString(callback))
  add(query_589011, "access_token", newJString(accessToken))
  add(query_589011, "uploadType", newJString(uploadType))
  add(query_589011, "key", newJString(key))
  add(query_589011, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589012 = body
  add(query_589011, "prettyPrint", newJBool(prettyPrint))
  result = call_589010.call(nil, query_589011, nil, nil, body_589012)

var jobsCompaniesCreate* = Call_JobsCompaniesCreate_588994(
    name: "jobsCompaniesCreate", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/companies",
    validator: validate_JobsCompaniesCreate_588995, base: "/",
    url: url_JobsCompaniesCreate_588996, schemes: {Scheme.Https})
type
  Call_JobsCompaniesList_588719 = ref object of OpenApiRestCall_588450
proc url_JobsCompaniesList_588721(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsCompaniesList_588720(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists all companies associated with a Cloud Talent Solution account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   mustHaveOpenJobs: JBool
  ##                   : Optional. Set to true if the companies request must have open jobs.
  ## 
  ## Defaults to false.
  ## 
  ## If true, at most page_size of companies are fetched, among which
  ## only those with open jobs are returned.
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
  var valid_588833 = query.getOrDefault("upload_protocol")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "upload_protocol", valid_588833
  var valid_588834 = query.getOrDefault("fields")
  valid_588834 = validateParameter(valid_588834, JString, required = false,
                                 default = nil)
  if valid_588834 != nil:
    section.add "fields", valid_588834
  var valid_588835 = query.getOrDefault("pageToken")
  valid_588835 = validateParameter(valid_588835, JString, required = false,
                                 default = nil)
  if valid_588835 != nil:
    section.add "pageToken", valid_588835
  var valid_588836 = query.getOrDefault("quotaUser")
  valid_588836 = validateParameter(valid_588836, JString, required = false,
                                 default = nil)
  if valid_588836 != nil:
    section.add "quotaUser", valid_588836
  var valid_588850 = query.getOrDefault("alt")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = newJString("json"))
  if valid_588850 != nil:
    section.add "alt", valid_588850
  var valid_588851 = query.getOrDefault("oauth_token")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "oauth_token", valid_588851
  var valid_588852 = query.getOrDefault("callback")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "callback", valid_588852
  var valid_588853 = query.getOrDefault("access_token")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "access_token", valid_588853
  var valid_588854 = query.getOrDefault("uploadType")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "uploadType", valid_588854
  var valid_588855 = query.getOrDefault("mustHaveOpenJobs")
  valid_588855 = validateParameter(valid_588855, JBool, required = false, default = nil)
  if valid_588855 != nil:
    section.add "mustHaveOpenJobs", valid_588855
  var valid_588856 = query.getOrDefault("key")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "key", valid_588856
  var valid_588857 = query.getOrDefault("$.xgafv")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = newJString("1"))
  if valid_588857 != nil:
    section.add "$.xgafv", valid_588857
  var valid_588858 = query.getOrDefault("pageSize")
  valid_588858 = validateParameter(valid_588858, JInt, required = false, default = nil)
  if valid_588858 != nil:
    section.add "pageSize", valid_588858
  var valid_588859 = query.getOrDefault("prettyPrint")
  valid_588859 = validateParameter(valid_588859, JBool, required = false,
                                 default = newJBool(true))
  if valid_588859 != nil:
    section.add "prettyPrint", valid_588859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588882: Call_JobsCompaniesList_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all companies associated with a Cloud Talent Solution account.
  ## 
  let valid = call_588882.validator(path, query, header, formData, body)
  let scheme = call_588882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588882.url(scheme.get, call_588882.host, call_588882.base,
                         call_588882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588882, url, valid)

proc call*(call_588953: Call_JobsCompaniesList_588719; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          mustHaveOpenJobs: bool = false; key: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## jobsCompaniesList
  ## Lists all companies associated with a Cloud Talent Solution account.
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
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   mustHaveOpenJobs: bool
  ##                   : Optional. Set to true if the companies request must have open jobs.
  ## 
  ## Defaults to false.
  ## 
  ## If true, at most page_size of companies are fetched, among which
  ## only those with open jobs are returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of companies to be returned, at most 100.
  ## Default is 100 if a non-positive number is provided.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588954 = newJObject()
  add(query_588954, "upload_protocol", newJString(uploadProtocol))
  add(query_588954, "fields", newJString(fields))
  add(query_588954, "pageToken", newJString(pageToken))
  add(query_588954, "quotaUser", newJString(quotaUser))
  add(query_588954, "alt", newJString(alt))
  add(query_588954, "oauth_token", newJString(oauthToken))
  add(query_588954, "callback", newJString(callback))
  add(query_588954, "access_token", newJString(accessToken))
  add(query_588954, "uploadType", newJString(uploadType))
  add(query_588954, "mustHaveOpenJobs", newJBool(mustHaveOpenJobs))
  add(query_588954, "key", newJString(key))
  add(query_588954, "$.xgafv", newJString(Xgafv))
  add(query_588954, "pageSize", newJInt(pageSize))
  add(query_588954, "prettyPrint", newJBool(prettyPrint))
  result = call_588953.call(nil, query_588954, nil, nil, nil)

var jobsCompaniesList* = Call_JobsCompaniesList_588719(name: "jobsCompaniesList",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/companies",
    validator: validate_JobsCompaniesList_588720, base: "/",
    url: url_JobsCompaniesList_588721, schemes: {Scheme.Https})
type
  Call_JobsJobsCreate_589034 = ref object of OpenApiRestCall_588450
proc url_JobsJobsCreate_589036(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsCreate_589035(path: JsonNode; query: JsonNode;
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
  var valid_589037 = query.getOrDefault("upload_protocol")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "upload_protocol", valid_589037
  var valid_589038 = query.getOrDefault("fields")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "fields", valid_589038
  var valid_589039 = query.getOrDefault("quotaUser")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "quotaUser", valid_589039
  var valid_589040 = query.getOrDefault("alt")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = newJString("json"))
  if valid_589040 != nil:
    section.add "alt", valid_589040
  var valid_589041 = query.getOrDefault("oauth_token")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "oauth_token", valid_589041
  var valid_589042 = query.getOrDefault("callback")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "callback", valid_589042
  var valid_589043 = query.getOrDefault("access_token")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "access_token", valid_589043
  var valid_589044 = query.getOrDefault("uploadType")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "uploadType", valid_589044
  var valid_589045 = query.getOrDefault("key")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "key", valid_589045
  var valid_589046 = query.getOrDefault("$.xgafv")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = newJString("1"))
  if valid_589046 != nil:
    section.add "$.xgafv", valid_589046
  var valid_589047 = query.getOrDefault("prettyPrint")
  valid_589047 = validateParameter(valid_589047, JBool, required = false,
                                 default = newJBool(true))
  if valid_589047 != nil:
    section.add "prettyPrint", valid_589047
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

proc call*(call_589049: Call_JobsJobsCreate_589034; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job.
  ## 
  ## Typically, the job becomes searchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ## 
  let valid = call_589049.validator(path, query, header, formData, body)
  let scheme = call_589049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589049.url(scheme.get, call_589049.host, call_589049.base,
                         call_589049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589049, url, valid)

proc call*(call_589050: Call_JobsJobsCreate_589034; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsJobsCreate
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589051 = newJObject()
  var body_589052 = newJObject()
  add(query_589051, "upload_protocol", newJString(uploadProtocol))
  add(query_589051, "fields", newJString(fields))
  add(query_589051, "quotaUser", newJString(quotaUser))
  add(query_589051, "alt", newJString(alt))
  add(query_589051, "oauth_token", newJString(oauthToken))
  add(query_589051, "callback", newJString(callback))
  add(query_589051, "access_token", newJString(accessToken))
  add(query_589051, "uploadType", newJString(uploadType))
  add(query_589051, "key", newJString(key))
  add(query_589051, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589052 = body
  add(query_589051, "prettyPrint", newJBool(prettyPrint))
  result = call_589050.call(nil, query_589051, nil, nil, body_589052)

var jobsJobsCreate* = Call_JobsJobsCreate_589034(name: "jobsJobsCreate",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com", route: "/v2/jobs",
    validator: validate_JobsJobsCreate_589035, base: "/", url: url_JobsJobsCreate_589036,
    schemes: {Scheme.Https})
type
  Call_JobsJobsList_589013 = ref object of OpenApiRestCall_588450
proc url_JobsJobsList_589015(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsList_589014(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists jobs by filter.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   idsOnly: JBool
  ##          : Optional. If set to `true`, only Job.name, Job.requisition_id and
  ## Job.language_code will be returned.
  ## 
  ## A typical use case is to synchronize job repositories.
  ## 
  ## Defaults to false.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If ids_only is set to true, the maximum allowed page size
  ## is 1000. Otherwise, the maximum allowed page size is 100.
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
  ## * companyName = "companies/123"
  ## * companyName = "companies/123" AND requisitionId = "req-1"
  section = newJObject()
  var valid_589016 = query.getOrDefault("upload_protocol")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "upload_protocol", valid_589016
  var valid_589017 = query.getOrDefault("fields")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "fields", valid_589017
  var valid_589018 = query.getOrDefault("pageToken")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "pageToken", valid_589018
  var valid_589019 = query.getOrDefault("quotaUser")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "quotaUser", valid_589019
  var valid_589020 = query.getOrDefault("alt")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("json"))
  if valid_589020 != nil:
    section.add "alt", valid_589020
  var valid_589021 = query.getOrDefault("oauth_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "oauth_token", valid_589021
  var valid_589022 = query.getOrDefault("callback")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "callback", valid_589022
  var valid_589023 = query.getOrDefault("access_token")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "access_token", valid_589023
  var valid_589024 = query.getOrDefault("uploadType")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "uploadType", valid_589024
  var valid_589025 = query.getOrDefault("idsOnly")
  valid_589025 = validateParameter(valid_589025, JBool, required = false, default = nil)
  if valid_589025 != nil:
    section.add "idsOnly", valid_589025
  var valid_589026 = query.getOrDefault("key")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "key", valid_589026
  var valid_589027 = query.getOrDefault("$.xgafv")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = newJString("1"))
  if valid_589027 != nil:
    section.add "$.xgafv", valid_589027
  var valid_589028 = query.getOrDefault("pageSize")
  valid_589028 = validateParameter(valid_589028, JInt, required = false, default = nil)
  if valid_589028 != nil:
    section.add "pageSize", valid_589028
  var valid_589029 = query.getOrDefault("prettyPrint")
  valid_589029 = validateParameter(valid_589029, JBool, required = false,
                                 default = newJBool(true))
  if valid_589029 != nil:
    section.add "prettyPrint", valid_589029
  var valid_589030 = query.getOrDefault("filter")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "filter", valid_589030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589031: Call_JobsJobsList_589013; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs by filter.
  ## 
  let valid = call_589031.validator(path, query, header, formData, body)
  let scheme = call_589031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589031.url(scheme.get, call_589031.host, call_589031.base,
                         call_589031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589031, url, valid)

proc call*(call_589032: Call_JobsJobsList_589013; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; idsOnly: bool = false;
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## jobsJobsList
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
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   idsOnly: bool
  ##          : Optional. If set to `true`, only Job.name, Job.requisition_id and
  ## Job.language_code will be returned.
  ## 
  ## A typical use case is to synchronize job repositories.
  ## 
  ## Defaults to false.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If ids_only is set to true, the maximum allowed page size
  ## is 1000. Otherwise, the maximum allowed page size is 100.
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
  ## * companyName = "companies/123"
  ## * companyName = "companies/123" AND requisitionId = "req-1"
  var query_589033 = newJObject()
  add(query_589033, "upload_protocol", newJString(uploadProtocol))
  add(query_589033, "fields", newJString(fields))
  add(query_589033, "pageToken", newJString(pageToken))
  add(query_589033, "quotaUser", newJString(quotaUser))
  add(query_589033, "alt", newJString(alt))
  add(query_589033, "oauth_token", newJString(oauthToken))
  add(query_589033, "callback", newJString(callback))
  add(query_589033, "access_token", newJString(accessToken))
  add(query_589033, "uploadType", newJString(uploadType))
  add(query_589033, "idsOnly", newJBool(idsOnly))
  add(query_589033, "key", newJString(key))
  add(query_589033, "$.xgafv", newJString(Xgafv))
  add(query_589033, "pageSize", newJInt(pageSize))
  add(query_589033, "prettyPrint", newJBool(prettyPrint))
  add(query_589033, "filter", newJString(filter))
  result = call_589032.call(nil, query_589033, nil, nil, nil)

var jobsJobsList* = Call_JobsJobsList_589013(name: "jobsJobsList",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/jobs",
    validator: validate_JobsJobsList_589014, base: "/", url: url_JobsJobsList_589015,
    schemes: {Scheme.Https})
type
  Call_JobsJobsBatchDelete_589053 = ref object of OpenApiRestCall_588450
proc url_JobsJobsBatchDelete_589055(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsBatchDelete_589054(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a list of Job postings by filter.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_589056 = query.getOrDefault("upload_protocol")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "upload_protocol", valid_589056
  var valid_589057 = query.getOrDefault("fields")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "fields", valid_589057
  var valid_589058 = query.getOrDefault("quotaUser")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "quotaUser", valid_589058
  var valid_589059 = query.getOrDefault("alt")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = newJString("json"))
  if valid_589059 != nil:
    section.add "alt", valid_589059
  var valid_589060 = query.getOrDefault("oauth_token")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "oauth_token", valid_589060
  var valid_589061 = query.getOrDefault("callback")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "callback", valid_589061
  var valid_589062 = query.getOrDefault("access_token")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "access_token", valid_589062
  var valid_589063 = query.getOrDefault("uploadType")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "uploadType", valid_589063
  var valid_589064 = query.getOrDefault("key")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "key", valid_589064
  var valid_589065 = query.getOrDefault("$.xgafv")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = newJString("1"))
  if valid_589065 != nil:
    section.add "$.xgafv", valid_589065
  var valid_589066 = query.getOrDefault("prettyPrint")
  valid_589066 = validateParameter(valid_589066, JBool, required = false,
                                 default = newJBool(true))
  if valid_589066 != nil:
    section.add "prettyPrint", valid_589066
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

proc call*(call_589068: Call_JobsJobsBatchDelete_589053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a list of Job postings by filter.
  ## 
  let valid = call_589068.validator(path, query, header, formData, body)
  let scheme = call_589068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589068.url(scheme.get, call_589068.host, call_589068.base,
                         call_589068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589068, url, valid)

proc call*(call_589069: Call_JobsJobsBatchDelete_589053;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsJobsBatchDelete
  ## Deletes a list of Job postings by filter.
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
  var query_589070 = newJObject()
  var body_589071 = newJObject()
  add(query_589070, "upload_protocol", newJString(uploadProtocol))
  add(query_589070, "fields", newJString(fields))
  add(query_589070, "quotaUser", newJString(quotaUser))
  add(query_589070, "alt", newJString(alt))
  add(query_589070, "oauth_token", newJString(oauthToken))
  add(query_589070, "callback", newJString(callback))
  add(query_589070, "access_token", newJString(accessToken))
  add(query_589070, "uploadType", newJString(uploadType))
  add(query_589070, "key", newJString(key))
  add(query_589070, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589071 = body
  add(query_589070, "prettyPrint", newJBool(prettyPrint))
  result = call_589069.call(nil, query_589070, nil, nil, body_589071)

var jobsJobsBatchDelete* = Call_JobsJobsBatchDelete_589053(
    name: "jobsJobsBatchDelete", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:batchDelete",
    validator: validate_JobsJobsBatchDelete_589054, base: "/",
    url: url_JobsJobsBatchDelete_589055, schemes: {Scheme.Https})
type
  Call_JobsJobsDeleteByFilter_589072 = ref object of OpenApiRestCall_588450
proc url_JobsJobsDeleteByFilter_589074(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsDeleteByFilter_589073(path: JsonNode; query: JsonNode;
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
  var valid_589075 = query.getOrDefault("upload_protocol")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "upload_protocol", valid_589075
  var valid_589076 = query.getOrDefault("fields")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "fields", valid_589076
  var valid_589077 = query.getOrDefault("quotaUser")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "quotaUser", valid_589077
  var valid_589078 = query.getOrDefault("alt")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = newJString("json"))
  if valid_589078 != nil:
    section.add "alt", valid_589078
  var valid_589079 = query.getOrDefault("oauth_token")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "oauth_token", valid_589079
  var valid_589080 = query.getOrDefault("callback")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "callback", valid_589080
  var valid_589081 = query.getOrDefault("access_token")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "access_token", valid_589081
  var valid_589082 = query.getOrDefault("uploadType")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "uploadType", valid_589082
  var valid_589083 = query.getOrDefault("key")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "key", valid_589083
  var valid_589084 = query.getOrDefault("$.xgafv")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = newJString("1"))
  if valid_589084 != nil:
    section.add "$.xgafv", valid_589084
  var valid_589085 = query.getOrDefault("prettyPrint")
  valid_589085 = validateParameter(valid_589085, JBool, required = false,
                                 default = newJBool(true))
  if valid_589085 != nil:
    section.add "prettyPrint", valid_589085
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

proc call*(call_589087: Call_JobsJobsDeleteByFilter_589072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated. Use BatchDeleteJobs instead.
  ## 
  ## Deletes the specified job by filter. You can specify whether to
  ## synchronously wait for validation, indexing, and general processing to be
  ## completed before the response is returned.
  ## 
  let valid = call_589087.validator(path, query, header, formData, body)
  let scheme = call_589087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589087.url(scheme.get, call_589087.host, call_589087.base,
                         call_589087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589087, url, valid)

proc call*(call_589088: Call_JobsJobsDeleteByFilter_589072;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsJobsDeleteByFilter
  ## Deprecated. Use BatchDeleteJobs instead.
  ## 
  ## Deletes the specified job by filter. You can specify whether to
  ## synchronously wait for validation, indexing, and general processing to be
  ## completed before the response is returned.
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
  var query_589089 = newJObject()
  var body_589090 = newJObject()
  add(query_589089, "upload_protocol", newJString(uploadProtocol))
  add(query_589089, "fields", newJString(fields))
  add(query_589089, "quotaUser", newJString(quotaUser))
  add(query_589089, "alt", newJString(alt))
  add(query_589089, "oauth_token", newJString(oauthToken))
  add(query_589089, "callback", newJString(callback))
  add(query_589089, "access_token", newJString(accessToken))
  add(query_589089, "uploadType", newJString(uploadType))
  add(query_589089, "key", newJString(key))
  add(query_589089, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589090 = body
  add(query_589089, "prettyPrint", newJBool(prettyPrint))
  result = call_589088.call(nil, query_589089, nil, nil, body_589090)

var jobsJobsDeleteByFilter* = Call_JobsJobsDeleteByFilter_589072(
    name: "jobsJobsDeleteByFilter", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:deleteByFilter",
    validator: validate_JobsJobsDeleteByFilter_589073, base: "/",
    url: url_JobsJobsDeleteByFilter_589074, schemes: {Scheme.Https})
type
  Call_JobsJobsHistogram_589091 = ref object of OpenApiRestCall_588450
proc url_JobsJobsHistogram_589093(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsHistogram_589092(path: JsonNode; query: JsonNode;
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
  var valid_589094 = query.getOrDefault("upload_protocol")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "upload_protocol", valid_589094
  var valid_589095 = query.getOrDefault("fields")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "fields", valid_589095
  var valid_589096 = query.getOrDefault("quotaUser")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "quotaUser", valid_589096
  var valid_589097 = query.getOrDefault("alt")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = newJString("json"))
  if valid_589097 != nil:
    section.add "alt", valid_589097
  var valid_589098 = query.getOrDefault("oauth_token")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "oauth_token", valid_589098
  var valid_589099 = query.getOrDefault("callback")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "callback", valid_589099
  var valid_589100 = query.getOrDefault("access_token")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "access_token", valid_589100
  var valid_589101 = query.getOrDefault("uploadType")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "uploadType", valid_589101
  var valid_589102 = query.getOrDefault("key")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "key", valid_589102
  var valid_589103 = query.getOrDefault("$.xgafv")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = newJString("1"))
  if valid_589103 != nil:
    section.add "$.xgafv", valid_589103
  var valid_589104 = query.getOrDefault("prettyPrint")
  valid_589104 = validateParameter(valid_589104, JBool, required = false,
                                 default = newJBool(true))
  if valid_589104 != nil:
    section.add "prettyPrint", valid_589104
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

proc call*(call_589106: Call_JobsJobsHistogram_589091; path: JsonNode;
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
  let valid = call_589106.validator(path, query, header, formData, body)
  let scheme = call_589106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589106.url(scheme.get, call_589106.host, call_589106.base,
                         call_589106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589106, url, valid)

proc call*(call_589107: Call_JobsJobsHistogram_589091; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  var query_589108 = newJObject()
  var body_589109 = newJObject()
  add(query_589108, "upload_protocol", newJString(uploadProtocol))
  add(query_589108, "fields", newJString(fields))
  add(query_589108, "quotaUser", newJString(quotaUser))
  add(query_589108, "alt", newJString(alt))
  add(query_589108, "oauth_token", newJString(oauthToken))
  add(query_589108, "callback", newJString(callback))
  add(query_589108, "access_token", newJString(accessToken))
  add(query_589108, "uploadType", newJString(uploadType))
  add(query_589108, "key", newJString(key))
  add(query_589108, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589109 = body
  add(query_589108, "prettyPrint", newJBool(prettyPrint))
  result = call_589107.call(nil, query_589108, nil, nil, body_589109)

var jobsJobsHistogram* = Call_JobsJobsHistogram_589091(name: "jobsJobsHistogram",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com",
    route: "/v2/jobs:histogram", validator: validate_JobsJobsHistogram_589092,
    base: "/", url: url_JobsJobsHistogram_589093, schemes: {Scheme.Https})
type
  Call_JobsJobsSearch_589110 = ref object of OpenApiRestCall_588450
proc url_JobsJobsSearch_589112(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsSearch_589111(path: JsonNode; query: JsonNode;
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
  var valid_589113 = query.getOrDefault("upload_protocol")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "upload_protocol", valid_589113
  var valid_589114 = query.getOrDefault("fields")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "fields", valid_589114
  var valid_589115 = query.getOrDefault("quotaUser")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "quotaUser", valid_589115
  var valid_589116 = query.getOrDefault("alt")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = newJString("json"))
  if valid_589116 != nil:
    section.add "alt", valid_589116
  var valid_589117 = query.getOrDefault("oauth_token")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "oauth_token", valid_589117
  var valid_589118 = query.getOrDefault("callback")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "callback", valid_589118
  var valid_589119 = query.getOrDefault("access_token")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "access_token", valid_589119
  var valid_589120 = query.getOrDefault("uploadType")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "uploadType", valid_589120
  var valid_589121 = query.getOrDefault("key")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "key", valid_589121
  var valid_589122 = query.getOrDefault("$.xgafv")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = newJString("1"))
  if valid_589122 != nil:
    section.add "$.xgafv", valid_589122
  var valid_589123 = query.getOrDefault("prettyPrint")
  valid_589123 = validateParameter(valid_589123, JBool, required = false,
                                 default = newJBool(true))
  if valid_589123 != nil:
    section.add "prettyPrint", valid_589123
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

proc call*(call_589125: Call_JobsJobsSearch_589110; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs that the caller has
  ## permission to search against.
  ## 
  let valid = call_589125.validator(path, query, header, formData, body)
  let scheme = call_589125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589125.url(scheme.get, call_589125.host, call_589125.base,
                         call_589125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589125, url, valid)

proc call*(call_589126: Call_JobsJobsSearch_589110; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsJobsSearch
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589127 = newJObject()
  var body_589128 = newJObject()
  add(query_589127, "upload_protocol", newJString(uploadProtocol))
  add(query_589127, "fields", newJString(fields))
  add(query_589127, "quotaUser", newJString(quotaUser))
  add(query_589127, "alt", newJString(alt))
  add(query_589127, "oauth_token", newJString(oauthToken))
  add(query_589127, "callback", newJString(callback))
  add(query_589127, "access_token", newJString(accessToken))
  add(query_589127, "uploadType", newJString(uploadType))
  add(query_589127, "key", newJString(key))
  add(query_589127, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589128 = body
  add(query_589127, "prettyPrint", newJBool(prettyPrint))
  result = call_589126.call(nil, query_589127, nil, nil, body_589128)

var jobsJobsSearch* = Call_JobsJobsSearch_589110(name: "jobsJobsSearch",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com",
    route: "/v2/jobs:search", validator: validate_JobsJobsSearch_589111, base: "/",
    url: url_JobsJobsSearch_589112, schemes: {Scheme.Https})
type
  Call_JobsJobsSearchForAlert_589129 = ref object of OpenApiRestCall_588450
proc url_JobsJobsSearchForAlert_589131(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsSearchForAlert_589130(path: JsonNode; query: JsonNode;
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
  var valid_589132 = query.getOrDefault("upload_protocol")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "upload_protocol", valid_589132
  var valid_589133 = query.getOrDefault("fields")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "fields", valid_589133
  var valid_589134 = query.getOrDefault("quotaUser")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "quotaUser", valid_589134
  var valid_589135 = query.getOrDefault("alt")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = newJString("json"))
  if valid_589135 != nil:
    section.add "alt", valid_589135
  var valid_589136 = query.getOrDefault("oauth_token")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "oauth_token", valid_589136
  var valid_589137 = query.getOrDefault("callback")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "callback", valid_589137
  var valid_589138 = query.getOrDefault("access_token")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "access_token", valid_589138
  var valid_589139 = query.getOrDefault("uploadType")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "uploadType", valid_589139
  var valid_589140 = query.getOrDefault("key")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "key", valid_589140
  var valid_589141 = query.getOrDefault("$.xgafv")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = newJString("1"))
  if valid_589141 != nil:
    section.add "$.xgafv", valid_589141
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589144: Call_JobsJobsSearchForAlert_589129; path: JsonNode;
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
  let valid = call_589144.validator(path, query, header, formData, body)
  let scheme = call_589144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589144.url(scheme.get, call_589144.host, call_589144.base,
                         call_589144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589144, url, valid)

proc call*(call_589145: Call_JobsJobsSearchForAlert_589129;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  var query_589146 = newJObject()
  var body_589147 = newJObject()
  add(query_589146, "upload_protocol", newJString(uploadProtocol))
  add(query_589146, "fields", newJString(fields))
  add(query_589146, "quotaUser", newJString(quotaUser))
  add(query_589146, "alt", newJString(alt))
  add(query_589146, "oauth_token", newJString(oauthToken))
  add(query_589146, "callback", newJString(callback))
  add(query_589146, "access_token", newJString(accessToken))
  add(query_589146, "uploadType", newJString(uploadType))
  add(query_589146, "key", newJString(key))
  add(query_589146, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589147 = body
  add(query_589146, "prettyPrint", newJBool(prettyPrint))
  result = call_589145.call(nil, query_589146, nil, nil, body_589147)

var jobsJobsSearchForAlert* = Call_JobsJobsSearchForAlert_589129(
    name: "jobsJobsSearchForAlert", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:searchForAlert",
    validator: validate_JobsJobsSearchForAlert_589130, base: "/",
    url: url_JobsJobsSearchForAlert_589131, schemes: {Scheme.Https})
type
  Call_JobsCompaniesJobsList_589148 = ref object of OpenApiRestCall_588450
proc url_JobsCompaniesJobsList_589150(protocol: Scheme; host: string; base: string;
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

proc validate_JobsCompaniesJobsList_589149(path: JsonNode; query: JsonNode;
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
  var valid_589165 = path.getOrDefault("companyName")
  valid_589165 = validateParameter(valid_589165, JString, required = true,
                                 default = nil)
  if valid_589165 != nil:
    section.add "companyName", valid_589165
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
  ##   jobRequisitionId: JString
  ##                   : Optional. The requisition ID, also known as posting ID, assigned by the company
  ## to the job.
  ## 
  ## The maximum number of allowable characters is 225.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   idsOnly: JBool
  ##          : Optional. If set to `true`, only job ID, job requisition ID and language code will be
  ## returned.
  ## 
  ## A typical use is to synchronize job repositories.
  ## 
  ## Defaults to false.
  ##   includeJobsCount: JBool
  ##                   : Deprecated. Please DO NOT use this field except for small companies.
  ## Suggest counting jobs page by page instead.
  ## 
  ## Optional.
  ## 
  ## Set to true if the total number of open jobs is to be returned.
  ## 
  ## Defaults to false.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If ids_only is set to true, the maximum allowed page size
  ## is 1000. Otherwise, the maximum allowed page size is 100.
  ## 
  ## Default is 100 if empty or a number < 1 is specified.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589166 = query.getOrDefault("upload_protocol")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "upload_protocol", valid_589166
  var valid_589167 = query.getOrDefault("fields")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "fields", valid_589167
  var valid_589168 = query.getOrDefault("pageToken")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "pageToken", valid_589168
  var valid_589169 = query.getOrDefault("quotaUser")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "quotaUser", valid_589169
  var valid_589170 = query.getOrDefault("alt")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = newJString("json"))
  if valid_589170 != nil:
    section.add "alt", valid_589170
  var valid_589171 = query.getOrDefault("jobRequisitionId")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "jobRequisitionId", valid_589171
  var valid_589172 = query.getOrDefault("oauth_token")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "oauth_token", valid_589172
  var valid_589173 = query.getOrDefault("callback")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "callback", valid_589173
  var valid_589174 = query.getOrDefault("access_token")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "access_token", valid_589174
  var valid_589175 = query.getOrDefault("uploadType")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "uploadType", valid_589175
  var valid_589176 = query.getOrDefault("idsOnly")
  valid_589176 = validateParameter(valid_589176, JBool, required = false, default = nil)
  if valid_589176 != nil:
    section.add "idsOnly", valid_589176
  var valid_589177 = query.getOrDefault("includeJobsCount")
  valid_589177 = validateParameter(valid_589177, JBool, required = false, default = nil)
  if valid_589177 != nil:
    section.add "includeJobsCount", valid_589177
  var valid_589178 = query.getOrDefault("key")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "key", valid_589178
  var valid_589179 = query.getOrDefault("$.xgafv")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = newJString("1"))
  if valid_589179 != nil:
    section.add "$.xgafv", valid_589179
  var valid_589180 = query.getOrDefault("pageSize")
  valid_589180 = validateParameter(valid_589180, JInt, required = false, default = nil)
  if valid_589180 != nil:
    section.add "pageSize", valid_589180
  var valid_589181 = query.getOrDefault("prettyPrint")
  valid_589181 = validateParameter(valid_589181, JBool, required = false,
                                 default = newJBool(true))
  if valid_589181 != nil:
    section.add "prettyPrint", valid_589181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589182: Call_JobsCompaniesJobsList_589148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated. Use ListJobs instead.
  ## 
  ## Lists all jobs associated with a company.
  ## 
  let valid = call_589182.validator(path, query, header, formData, body)
  let scheme = call_589182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589182.url(scheme.get, call_589182.host, call_589182.base,
                         call_589182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589182, url, valid)

proc call*(call_589183: Call_JobsCompaniesJobsList_589148; companyName: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; jobRequisitionId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; idsOnly: bool = false;
          includeJobsCount: bool = false; key: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## jobsCompaniesJobsList
  ## Deprecated. Use ListJobs instead.
  ## 
  ## Lists all jobs associated with a company.
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
  ##   jobRequisitionId: string
  ##                   : Optional. The requisition ID, also known as posting ID, assigned by the company
  ## to the job.
  ## 
  ## The maximum number of allowable characters is 225.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   idsOnly: bool
  ##          : Optional. If set to `true`, only job ID, job requisition ID and language code will be
  ## returned.
  ## 
  ## A typical use is to synchronize job repositories.
  ## 
  ## Defaults to false.
  ##   includeJobsCount: bool
  ##                   : Deprecated. Please DO NOT use this field except for small companies.
  ## Suggest counting jobs page by page instead.
  ## 
  ## Optional.
  ## 
  ## Set to true if the total number of open jobs is to be returned.
  ## 
  ## Defaults to false.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of jobs to be returned per page of results.
  ## 
  ## If ids_only is set to true, the maximum allowed page size
  ## is 1000. Otherwise, the maximum allowed page size is 100.
  ## 
  ## Default is 100 if empty or a number < 1 is specified.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   companyName: string (required)
  ##              : Required. The resource name of the company that owns the jobs to be listed,
  ## such as, "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
  var path_589184 = newJObject()
  var query_589185 = newJObject()
  add(query_589185, "upload_protocol", newJString(uploadProtocol))
  add(query_589185, "fields", newJString(fields))
  add(query_589185, "pageToken", newJString(pageToken))
  add(query_589185, "quotaUser", newJString(quotaUser))
  add(query_589185, "alt", newJString(alt))
  add(query_589185, "jobRequisitionId", newJString(jobRequisitionId))
  add(query_589185, "oauth_token", newJString(oauthToken))
  add(query_589185, "callback", newJString(callback))
  add(query_589185, "access_token", newJString(accessToken))
  add(query_589185, "uploadType", newJString(uploadType))
  add(query_589185, "idsOnly", newJBool(idsOnly))
  add(query_589185, "includeJobsCount", newJBool(includeJobsCount))
  add(query_589185, "key", newJString(key))
  add(query_589185, "$.xgafv", newJString(Xgafv))
  add(query_589185, "pageSize", newJInt(pageSize))
  add(query_589185, "prettyPrint", newJBool(prettyPrint))
  add(path_589184, "companyName", newJString(companyName))
  result = call_589183.call(path_589184, query_589185, nil, nil, nil)

var jobsCompaniesJobsList* = Call_JobsCompaniesJobsList_589148(
    name: "jobsCompaniesJobsList", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v2/{companyName}/jobs",
    validator: validate_JobsCompaniesJobsList_589149, base: "/",
    url: url_JobsCompaniesJobsList_589150, schemes: {Scheme.Https})
type
  Call_JobsCompaniesGet_589186 = ref object of OpenApiRestCall_588450
proc url_JobsCompaniesGet_589188(protocol: Scheme; host: string; base: string;
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

proc validate_JobsCompaniesGet_589187(path: JsonNode; query: JsonNode;
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
  var valid_589189 = path.getOrDefault("name")
  valid_589189 = validateParameter(valid_589189, JString, required = true,
                                 default = nil)
  if valid_589189 != nil:
    section.add "name", valid_589189
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
  var valid_589190 = query.getOrDefault("upload_protocol")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "upload_protocol", valid_589190
  var valid_589191 = query.getOrDefault("fields")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "fields", valid_589191
  var valid_589192 = query.getOrDefault("quotaUser")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "quotaUser", valid_589192
  var valid_589193 = query.getOrDefault("alt")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = newJString("json"))
  if valid_589193 != nil:
    section.add "alt", valid_589193
  var valid_589194 = query.getOrDefault("oauth_token")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "oauth_token", valid_589194
  var valid_589195 = query.getOrDefault("callback")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "callback", valid_589195
  var valid_589196 = query.getOrDefault("access_token")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "access_token", valid_589196
  var valid_589197 = query.getOrDefault("uploadType")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "uploadType", valid_589197
  var valid_589198 = query.getOrDefault("key")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "key", valid_589198
  var valid_589199 = query.getOrDefault("$.xgafv")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = newJString("1"))
  if valid_589199 != nil:
    section.add "$.xgafv", valid_589199
  var valid_589200 = query.getOrDefault("prettyPrint")
  valid_589200 = validateParameter(valid_589200, JBool, required = false,
                                 default = newJBool(true))
  if valid_589200 != nil:
    section.add "prettyPrint", valid_589200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589201: Call_JobsCompaniesGet_589186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified company.
  ## 
  let valid = call_589201.validator(path, query, header, formData, body)
  let scheme = call_589201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589201.url(scheme.get, call_589201.host, call_589201.base,
                         call_589201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589201, url, valid)

proc call*(call_589202: Call_JobsCompaniesGet_589186; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## jobsCompaniesGet
  ## Retrieves the specified company.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Resource name of the company to retrieve,
  ## such as "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
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
  var path_589203 = newJObject()
  var query_589204 = newJObject()
  add(query_589204, "upload_protocol", newJString(uploadProtocol))
  add(query_589204, "fields", newJString(fields))
  add(query_589204, "quotaUser", newJString(quotaUser))
  add(path_589203, "name", newJString(name))
  add(query_589204, "alt", newJString(alt))
  add(query_589204, "oauth_token", newJString(oauthToken))
  add(query_589204, "callback", newJString(callback))
  add(query_589204, "access_token", newJString(accessToken))
  add(query_589204, "uploadType", newJString(uploadType))
  add(query_589204, "key", newJString(key))
  add(query_589204, "$.xgafv", newJString(Xgafv))
  add(query_589204, "prettyPrint", newJBool(prettyPrint))
  result = call_589202.call(path_589203, query_589204, nil, nil, nil)

var jobsCompaniesGet* = Call_JobsCompaniesGet_589186(name: "jobsCompaniesGet",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesGet_589187, base: "/",
    url: url_JobsCompaniesGet_589188, schemes: {Scheme.Https})
type
  Call_JobsCompaniesPatch_589225 = ref object of OpenApiRestCall_588450
proc url_JobsCompaniesPatch_589227(protocol: Scheme; host: string; base: string;
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

proc validate_JobsCompaniesPatch_589226(path: JsonNode; query: JsonNode;
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
  var valid_589228 = path.getOrDefault("name")
  valid_589228 = validateParameter(valid_589228, JString, required = true,
                                 default = nil)
  if valid_589228 != nil:
    section.add "name", valid_589228
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589229 = query.getOrDefault("upload_protocol")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "upload_protocol", valid_589229
  var valid_589230 = query.getOrDefault("fields")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "fields", valid_589230
  var valid_589231 = query.getOrDefault("quotaUser")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "quotaUser", valid_589231
  var valid_589232 = query.getOrDefault("alt")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = newJString("json"))
  if valid_589232 != nil:
    section.add "alt", valid_589232
  var valid_589233 = query.getOrDefault("oauth_token")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "oauth_token", valid_589233
  var valid_589234 = query.getOrDefault("callback")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "callback", valid_589234
  var valid_589235 = query.getOrDefault("access_token")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "access_token", valid_589235
  var valid_589236 = query.getOrDefault("uploadType")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "uploadType", valid_589236
  var valid_589237 = query.getOrDefault("updateCompanyFields")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "updateCompanyFields", valid_589237
  var valid_589238 = query.getOrDefault("key")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "key", valid_589238
  var valid_589239 = query.getOrDefault("$.xgafv")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = newJString("1"))
  if valid_589239 != nil:
    section.add "$.xgafv", valid_589239
  var valid_589240 = query.getOrDefault("prettyPrint")
  valid_589240 = validateParameter(valid_589240, JBool, required = false,
                                 default = newJBool(true))
  if valid_589240 != nil:
    section.add "prettyPrint", valid_589240
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

proc call*(call_589242: Call_JobsCompaniesPatch_589225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified company. Company names can't be updated. To update a
  ## company name, delete the company and all jobs associated with it, and only
  ## then re-create them.
  ## 
  let valid = call_589242.validator(path, query, header, formData, body)
  let scheme = call_589242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589242.url(scheme.get, call_589242.host, call_589242.base,
                         call_589242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589242, url, valid)

proc call*(call_589243: Call_JobsCompaniesPatch_589225; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          updateCompanyFields: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## jobsCompaniesPatch
  ## Updates the specified company. Company names can't be updated. To update a
  ## company name, delete the company and all jobs associated with it, and only
  ## then re-create them.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required during company update.
  ## 
  ## The resource name for a company. This is generated by the service when a
  ## company is created, for example,
  ## "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589244 = newJObject()
  var query_589245 = newJObject()
  var body_589246 = newJObject()
  add(query_589245, "upload_protocol", newJString(uploadProtocol))
  add(query_589245, "fields", newJString(fields))
  add(query_589245, "quotaUser", newJString(quotaUser))
  add(path_589244, "name", newJString(name))
  add(query_589245, "alt", newJString(alt))
  add(query_589245, "oauth_token", newJString(oauthToken))
  add(query_589245, "callback", newJString(callback))
  add(query_589245, "access_token", newJString(accessToken))
  add(query_589245, "uploadType", newJString(uploadType))
  add(query_589245, "updateCompanyFields", newJString(updateCompanyFields))
  add(query_589245, "key", newJString(key))
  add(query_589245, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589246 = body
  add(query_589245, "prettyPrint", newJBool(prettyPrint))
  result = call_589243.call(path_589244, query_589245, nil, nil, body_589246)

var jobsCompaniesPatch* = Call_JobsCompaniesPatch_589225(
    name: "jobsCompaniesPatch", meth: HttpMethod.HttpPatch,
    host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesPatch_589226, base: "/",
    url: url_JobsCompaniesPatch_589227, schemes: {Scheme.Https})
type
  Call_JobsCompaniesDelete_589205 = ref object of OpenApiRestCall_588450
proc url_JobsCompaniesDelete_589207(protocol: Scheme; host: string; base: string;
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

proc validate_JobsCompaniesDelete_589206(path: JsonNode; query: JsonNode;
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
  var valid_589208 = path.getOrDefault("name")
  valid_589208 = validateParameter(valid_589208, JString, required = true,
                                 default = nil)
  if valid_589208 != nil:
    section.add "name", valid_589208
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
  ##   disableFastProcess: JBool
  ##                     : Deprecated. This field is not working anymore.
  ## 
  ## Optional.
  ## 
  ## If set to true, this call waits for all processing steps to complete
  ## before the job is cleaned up. Otherwise, the call returns while some
  ## steps are still taking place asynchronously, hence faster.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589209 = query.getOrDefault("upload_protocol")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "upload_protocol", valid_589209
  var valid_589210 = query.getOrDefault("fields")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "fields", valid_589210
  var valid_589211 = query.getOrDefault("quotaUser")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "quotaUser", valid_589211
  var valid_589212 = query.getOrDefault("alt")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = newJString("json"))
  if valid_589212 != nil:
    section.add "alt", valid_589212
  var valid_589213 = query.getOrDefault("oauth_token")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "oauth_token", valid_589213
  var valid_589214 = query.getOrDefault("callback")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "callback", valid_589214
  var valid_589215 = query.getOrDefault("access_token")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "access_token", valid_589215
  var valid_589216 = query.getOrDefault("uploadType")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "uploadType", valid_589216
  var valid_589217 = query.getOrDefault("key")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "key", valid_589217
  var valid_589218 = query.getOrDefault("$.xgafv")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = newJString("1"))
  if valid_589218 != nil:
    section.add "$.xgafv", valid_589218
  var valid_589219 = query.getOrDefault("disableFastProcess")
  valid_589219 = validateParameter(valid_589219, JBool, required = false, default = nil)
  if valid_589219 != nil:
    section.add "disableFastProcess", valid_589219
  var valid_589220 = query.getOrDefault("prettyPrint")
  valid_589220 = validateParameter(valid_589220, JBool, required = false,
                                 default = newJBool(true))
  if valid_589220 != nil:
    section.add "prettyPrint", valid_589220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589221: Call_JobsCompaniesDelete_589205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified company.
  ## 
  let valid = call_589221.validator(path, query, header, formData, body)
  let scheme = call_589221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589221.url(scheme.get, call_589221.host, call_589221.base,
                         call_589221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589221, url, valid)

proc call*(call_589222: Call_JobsCompaniesDelete_589205; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; disableFastProcess: bool = false;
          prettyPrint: bool = true): Recallable =
  ## jobsCompaniesDelete
  ## Deletes the specified company.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the company to be deleted,
  ## such as, "companies/0000aaaa-1111-bbbb-2222-cccc3333dddd".
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
  ##   disableFastProcess: bool
  ##                     : Deprecated. This field is not working anymore.
  ## 
  ## Optional.
  ## 
  ## If set to true, this call waits for all processing steps to complete
  ## before the job is cleaned up. Otherwise, the call returns while some
  ## steps are still taking place asynchronously, hence faster.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589223 = newJObject()
  var query_589224 = newJObject()
  add(query_589224, "upload_protocol", newJString(uploadProtocol))
  add(query_589224, "fields", newJString(fields))
  add(query_589224, "quotaUser", newJString(quotaUser))
  add(path_589223, "name", newJString(name))
  add(query_589224, "alt", newJString(alt))
  add(query_589224, "oauth_token", newJString(oauthToken))
  add(query_589224, "callback", newJString(callback))
  add(query_589224, "access_token", newJString(accessToken))
  add(query_589224, "uploadType", newJString(uploadType))
  add(query_589224, "key", newJString(key))
  add(query_589224, "$.xgafv", newJString(Xgafv))
  add(query_589224, "disableFastProcess", newJBool(disableFastProcess))
  add(query_589224, "prettyPrint", newJBool(prettyPrint))
  result = call_589222.call(path_589223, query_589224, nil, nil, nil)

var jobsCompaniesDelete* = Call_JobsCompaniesDelete_589205(
    name: "jobsCompaniesDelete", meth: HttpMethod.HttpDelete,
    host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesDelete_589206, base: "/",
    url: url_JobsCompaniesDelete_589207, schemes: {Scheme.Https})
type
  Call_JobsComplete_589247 = ref object of OpenApiRestCall_588450
proc url_JobsComplete_589249(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsComplete_589248(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Completes the specified prefix with job keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   pageSize: JInt
  ##           : Required. Completion result count.
  ## The maximum allowed page size is 10.
  ##   companyName: JString
  ##              : Optional. If provided, restricts completion to the specified company.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589250 = query.getOrDefault("upload_protocol")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "upload_protocol", valid_589250
  var valid_589251 = query.getOrDefault("fields")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "fields", valid_589251
  var valid_589252 = query.getOrDefault("quotaUser")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "quotaUser", valid_589252
  var valid_589253 = query.getOrDefault("scope")
  valid_589253 = validateParameter(valid_589253, JString, required = false, default = newJString(
      "COMPLETION_SCOPE_UNSPECIFIED"))
  if valid_589253 != nil:
    section.add "scope", valid_589253
  var valid_589254 = query.getOrDefault("alt")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = newJString("json"))
  if valid_589254 != nil:
    section.add "alt", valid_589254
  var valid_589255 = query.getOrDefault("query")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "query", valid_589255
  var valid_589256 = query.getOrDefault("type")
  valid_589256 = validateParameter(valid_589256, JString, required = false, default = newJString(
      "COMPLETION_TYPE_UNSPECIFIED"))
  if valid_589256 != nil:
    section.add "type", valid_589256
  var valid_589257 = query.getOrDefault("oauth_token")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "oauth_token", valid_589257
  var valid_589258 = query.getOrDefault("callback")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "callback", valid_589258
  var valid_589259 = query.getOrDefault("access_token")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "access_token", valid_589259
  var valid_589260 = query.getOrDefault("uploadType")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "uploadType", valid_589260
  var valid_589261 = query.getOrDefault("key")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "key", valid_589261
  var valid_589262 = query.getOrDefault("$.xgafv")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = newJString("1"))
  if valid_589262 != nil:
    section.add "$.xgafv", valid_589262
  var valid_589263 = query.getOrDefault("languageCode")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "languageCode", valid_589263
  var valid_589264 = query.getOrDefault("pageSize")
  valid_589264 = validateParameter(valid_589264, JInt, required = false, default = nil)
  if valid_589264 != nil:
    section.add "pageSize", valid_589264
  var valid_589265 = query.getOrDefault("companyName")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "companyName", valid_589265
  var valid_589266 = query.getOrDefault("prettyPrint")
  valid_589266 = validateParameter(valid_589266, JBool, required = false,
                                 default = newJBool(true))
  if valid_589266 != nil:
    section.add "prettyPrint", valid_589266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589267: Call_JobsComplete_589247; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Completes the specified prefix with job keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ## 
  let valid = call_589267.validator(path, query, header, formData, body)
  let scheme = call_589267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589267.url(scheme.get, call_589267.host, call_589267.base,
                         call_589267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589267, url, valid)

proc call*(call_589268: Call_JobsComplete_589247; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = "";
          scope: string = "COMPLETION_SCOPE_UNSPECIFIED"; alt: string = "json";
          query: string = ""; `type`: string = "COMPLETION_TYPE_UNSPECIFIED";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          languageCode: string = ""; pageSize: int = 0; companyName: string = "";
          prettyPrint: bool = true): Recallable =
  ## jobsComplete
  ## Completes the specified prefix with job keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scope: string
  ##        : Optional. The scope of the completion. The defaults is CompletionScope.PUBLIC.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : Required. The query used to generate suggestions.
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
  ##   pageSize: int
  ##           : Required. Completion result count.
  ## The maximum allowed page size is 10.
  ##   companyName: string
  ##              : Optional. If provided, restricts completion to the specified company.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589269 = newJObject()
  add(query_589269, "upload_protocol", newJString(uploadProtocol))
  add(query_589269, "fields", newJString(fields))
  add(query_589269, "quotaUser", newJString(quotaUser))
  add(query_589269, "scope", newJString(scope))
  add(query_589269, "alt", newJString(alt))
  add(query_589269, "query", newJString(query))
  add(query_589269, "type", newJString(`type`))
  add(query_589269, "oauth_token", newJString(oauthToken))
  add(query_589269, "callback", newJString(callback))
  add(query_589269, "access_token", newJString(accessToken))
  add(query_589269, "uploadType", newJString(uploadType))
  add(query_589269, "key", newJString(key))
  add(query_589269, "$.xgafv", newJString(Xgafv))
  add(query_589269, "languageCode", newJString(languageCode))
  add(query_589269, "pageSize", newJInt(pageSize))
  add(query_589269, "companyName", newJString(companyName))
  add(query_589269, "prettyPrint", newJBool(prettyPrint))
  result = call_589268.call(nil, query_589269, nil, nil, nil)

var jobsComplete* = Call_JobsComplete_589247(name: "jobsComplete",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2:complete",
    validator: validate_JobsComplete_589248, base: "/", url: url_JobsComplete_589249,
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
