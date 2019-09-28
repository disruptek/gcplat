
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_JobsCompaniesCreate_579965 = ref object of OpenApiRestCall_579421
proc url_JobsCompaniesCreate_579967(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsCompaniesCreate_579966(path: JsonNode; query: JsonNode;
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
  var valid_579968 = query.getOrDefault("upload_protocol")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "upload_protocol", valid_579968
  var valid_579969 = query.getOrDefault("fields")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "fields", valid_579969
  var valid_579970 = query.getOrDefault("quotaUser")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "quotaUser", valid_579970
  var valid_579971 = query.getOrDefault("alt")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = newJString("json"))
  if valid_579971 != nil:
    section.add "alt", valid_579971
  var valid_579972 = query.getOrDefault("oauth_token")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "oauth_token", valid_579972
  var valid_579973 = query.getOrDefault("callback")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "callback", valid_579973
  var valid_579974 = query.getOrDefault("access_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "access_token", valid_579974
  var valid_579975 = query.getOrDefault("uploadType")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "uploadType", valid_579975
  var valid_579976 = query.getOrDefault("key")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "key", valid_579976
  var valid_579977 = query.getOrDefault("$.xgafv")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = newJString("1"))
  if valid_579977 != nil:
    section.add "$.xgafv", valid_579977
  var valid_579978 = query.getOrDefault("prettyPrint")
  valid_579978 = validateParameter(valid_579978, JBool, required = false,
                                 default = newJBool(true))
  if valid_579978 != nil:
    section.add "prettyPrint", valid_579978
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

proc call*(call_579980: Call_JobsCompaniesCreate_579965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new company entity.
  ## 
  let valid = call_579980.validator(path, query, header, formData, body)
  let scheme = call_579980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579980.url(scheme.get, call_579980.host, call_579980.base,
                         call_579980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579980, url, valid)

proc call*(call_579981: Call_JobsCompaniesCreate_579965;
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
  var query_579982 = newJObject()
  var body_579983 = newJObject()
  add(query_579982, "upload_protocol", newJString(uploadProtocol))
  add(query_579982, "fields", newJString(fields))
  add(query_579982, "quotaUser", newJString(quotaUser))
  add(query_579982, "alt", newJString(alt))
  add(query_579982, "oauth_token", newJString(oauthToken))
  add(query_579982, "callback", newJString(callback))
  add(query_579982, "access_token", newJString(accessToken))
  add(query_579982, "uploadType", newJString(uploadType))
  add(query_579982, "key", newJString(key))
  add(query_579982, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579983 = body
  add(query_579982, "prettyPrint", newJBool(prettyPrint))
  result = call_579981.call(nil, query_579982, nil, nil, body_579983)

var jobsCompaniesCreate* = Call_JobsCompaniesCreate_579965(
    name: "jobsCompaniesCreate", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/companies",
    validator: validate_JobsCompaniesCreate_579966, base: "/",
    url: url_JobsCompaniesCreate_579967, schemes: {Scheme.Https})
type
  Call_JobsCompaniesList_579690 = ref object of OpenApiRestCall_579421
proc url_JobsCompaniesList_579692(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsCompaniesList_579691(path: JsonNode; query: JsonNode;
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
  var valid_579804 = query.getOrDefault("upload_protocol")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "upload_protocol", valid_579804
  var valid_579805 = query.getOrDefault("fields")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "fields", valid_579805
  var valid_579806 = query.getOrDefault("pageToken")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "pageToken", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579821 = query.getOrDefault("alt")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = newJString("json"))
  if valid_579821 != nil:
    section.add "alt", valid_579821
  var valid_579822 = query.getOrDefault("oauth_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "oauth_token", valid_579822
  var valid_579823 = query.getOrDefault("callback")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "callback", valid_579823
  var valid_579824 = query.getOrDefault("access_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "access_token", valid_579824
  var valid_579825 = query.getOrDefault("uploadType")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "uploadType", valid_579825
  var valid_579826 = query.getOrDefault("mustHaveOpenJobs")
  valid_579826 = validateParameter(valid_579826, JBool, required = false, default = nil)
  if valid_579826 != nil:
    section.add "mustHaveOpenJobs", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("pageSize")
  valid_579829 = validateParameter(valid_579829, JInt, required = false, default = nil)
  if valid_579829 != nil:
    section.add "pageSize", valid_579829
  var valid_579830 = query.getOrDefault("prettyPrint")
  valid_579830 = validateParameter(valid_579830, JBool, required = false,
                                 default = newJBool(true))
  if valid_579830 != nil:
    section.add "prettyPrint", valid_579830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579853: Call_JobsCompaniesList_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all companies associated with a Cloud Talent Solution account.
  ## 
  let valid = call_579853.validator(path, query, header, formData, body)
  let scheme = call_579853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579853.url(scheme.get, call_579853.host, call_579853.base,
                         call_579853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579853, url, valid)

proc call*(call_579924: Call_JobsCompaniesList_579690; uploadProtocol: string = "";
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
  var query_579925 = newJObject()
  add(query_579925, "upload_protocol", newJString(uploadProtocol))
  add(query_579925, "fields", newJString(fields))
  add(query_579925, "pageToken", newJString(pageToken))
  add(query_579925, "quotaUser", newJString(quotaUser))
  add(query_579925, "alt", newJString(alt))
  add(query_579925, "oauth_token", newJString(oauthToken))
  add(query_579925, "callback", newJString(callback))
  add(query_579925, "access_token", newJString(accessToken))
  add(query_579925, "uploadType", newJString(uploadType))
  add(query_579925, "mustHaveOpenJobs", newJBool(mustHaveOpenJobs))
  add(query_579925, "key", newJString(key))
  add(query_579925, "$.xgafv", newJString(Xgafv))
  add(query_579925, "pageSize", newJInt(pageSize))
  add(query_579925, "prettyPrint", newJBool(prettyPrint))
  result = call_579924.call(nil, query_579925, nil, nil, nil)

var jobsCompaniesList* = Call_JobsCompaniesList_579690(name: "jobsCompaniesList",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/companies",
    validator: validate_JobsCompaniesList_579691, base: "/",
    url: url_JobsCompaniesList_579692, schemes: {Scheme.Https})
type
  Call_JobsJobsCreate_580005 = ref object of OpenApiRestCall_579421
proc url_JobsJobsCreate_580007(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsCreate_580006(path: JsonNode; query: JsonNode;
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
  var valid_580008 = query.getOrDefault("upload_protocol")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "upload_protocol", valid_580008
  var valid_580009 = query.getOrDefault("fields")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "fields", valid_580009
  var valid_580010 = query.getOrDefault("quotaUser")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "quotaUser", valid_580010
  var valid_580011 = query.getOrDefault("alt")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("json"))
  if valid_580011 != nil:
    section.add "alt", valid_580011
  var valid_580012 = query.getOrDefault("oauth_token")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "oauth_token", valid_580012
  var valid_580013 = query.getOrDefault("callback")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "callback", valid_580013
  var valid_580014 = query.getOrDefault("access_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "access_token", valid_580014
  var valid_580015 = query.getOrDefault("uploadType")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "uploadType", valid_580015
  var valid_580016 = query.getOrDefault("key")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "key", valid_580016
  var valid_580017 = query.getOrDefault("$.xgafv")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = newJString("1"))
  if valid_580017 != nil:
    section.add "$.xgafv", valid_580017
  var valid_580018 = query.getOrDefault("prettyPrint")
  valid_580018 = validateParameter(valid_580018, JBool, required = false,
                                 default = newJBool(true))
  if valid_580018 != nil:
    section.add "prettyPrint", valid_580018
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

proc call*(call_580020: Call_JobsJobsCreate_580005; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new job.
  ## 
  ## Typically, the job becomes searchable within 10 seconds, but it may take
  ## up to 5 minutes.
  ## 
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_JobsJobsCreate_580005; uploadProtocol: string = "";
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
  var query_580022 = newJObject()
  var body_580023 = newJObject()
  add(query_580022, "upload_protocol", newJString(uploadProtocol))
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "callback", newJString(callback))
  add(query_580022, "access_token", newJString(accessToken))
  add(query_580022, "uploadType", newJString(uploadType))
  add(query_580022, "key", newJString(key))
  add(query_580022, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580023 = body
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  result = call_580021.call(nil, query_580022, nil, nil, body_580023)

var jobsJobsCreate* = Call_JobsJobsCreate_580005(name: "jobsJobsCreate",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com", route: "/v2/jobs",
    validator: validate_JobsJobsCreate_580006, base: "/", url: url_JobsJobsCreate_580007,
    schemes: {Scheme.Https})
type
  Call_JobsJobsList_579984 = ref object of OpenApiRestCall_579421
proc url_JobsJobsList_579986(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsList_579985(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_579987 = query.getOrDefault("upload_protocol")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "upload_protocol", valid_579987
  var valid_579988 = query.getOrDefault("fields")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "fields", valid_579988
  var valid_579989 = query.getOrDefault("pageToken")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "pageToken", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("callback")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "callback", valid_579993
  var valid_579994 = query.getOrDefault("access_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "access_token", valid_579994
  var valid_579995 = query.getOrDefault("uploadType")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "uploadType", valid_579995
  var valid_579996 = query.getOrDefault("idsOnly")
  valid_579996 = validateParameter(valid_579996, JBool, required = false, default = nil)
  if valid_579996 != nil:
    section.add "idsOnly", valid_579996
  var valid_579997 = query.getOrDefault("key")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "key", valid_579997
  var valid_579998 = query.getOrDefault("$.xgafv")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = newJString("1"))
  if valid_579998 != nil:
    section.add "$.xgafv", valid_579998
  var valid_579999 = query.getOrDefault("pageSize")
  valid_579999 = validateParameter(valid_579999, JInt, required = false, default = nil)
  if valid_579999 != nil:
    section.add "pageSize", valid_579999
  var valid_580000 = query.getOrDefault("prettyPrint")
  valid_580000 = validateParameter(valid_580000, JBool, required = false,
                                 default = newJBool(true))
  if valid_580000 != nil:
    section.add "prettyPrint", valid_580000
  var valid_580001 = query.getOrDefault("filter")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "filter", valid_580001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580002: Call_JobsJobsList_579984; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists jobs by filter.
  ## 
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_JobsJobsList_579984; uploadProtocol: string = "";
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
  var query_580004 = newJObject()
  add(query_580004, "upload_protocol", newJString(uploadProtocol))
  add(query_580004, "fields", newJString(fields))
  add(query_580004, "pageToken", newJString(pageToken))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "callback", newJString(callback))
  add(query_580004, "access_token", newJString(accessToken))
  add(query_580004, "uploadType", newJString(uploadType))
  add(query_580004, "idsOnly", newJBool(idsOnly))
  add(query_580004, "key", newJString(key))
  add(query_580004, "$.xgafv", newJString(Xgafv))
  add(query_580004, "pageSize", newJInt(pageSize))
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  add(query_580004, "filter", newJString(filter))
  result = call_580003.call(nil, query_580004, nil, nil, nil)

var jobsJobsList* = Call_JobsJobsList_579984(name: "jobsJobsList",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/jobs",
    validator: validate_JobsJobsList_579985, base: "/", url: url_JobsJobsList_579986,
    schemes: {Scheme.Https})
type
  Call_JobsJobsBatchDelete_580024 = ref object of OpenApiRestCall_579421
proc url_JobsJobsBatchDelete_580026(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsBatchDelete_580025(path: JsonNode; query: JsonNode;
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
  var valid_580027 = query.getOrDefault("upload_protocol")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "upload_protocol", valid_580027
  var valid_580028 = query.getOrDefault("fields")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "fields", valid_580028
  var valid_580029 = query.getOrDefault("quotaUser")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "quotaUser", valid_580029
  var valid_580030 = query.getOrDefault("alt")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("json"))
  if valid_580030 != nil:
    section.add "alt", valid_580030
  var valid_580031 = query.getOrDefault("oauth_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "oauth_token", valid_580031
  var valid_580032 = query.getOrDefault("callback")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "callback", valid_580032
  var valid_580033 = query.getOrDefault("access_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "access_token", valid_580033
  var valid_580034 = query.getOrDefault("uploadType")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "uploadType", valid_580034
  var valid_580035 = query.getOrDefault("key")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "key", valid_580035
  var valid_580036 = query.getOrDefault("$.xgafv")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("1"))
  if valid_580036 != nil:
    section.add "$.xgafv", valid_580036
  var valid_580037 = query.getOrDefault("prettyPrint")
  valid_580037 = validateParameter(valid_580037, JBool, required = false,
                                 default = newJBool(true))
  if valid_580037 != nil:
    section.add "prettyPrint", valid_580037
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

proc call*(call_580039: Call_JobsJobsBatchDelete_580024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a list of Job postings by filter.
  ## 
  let valid = call_580039.validator(path, query, header, formData, body)
  let scheme = call_580039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580039.url(scheme.get, call_580039.host, call_580039.base,
                         call_580039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580039, url, valid)

proc call*(call_580040: Call_JobsJobsBatchDelete_580024;
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
  var query_580041 = newJObject()
  var body_580042 = newJObject()
  add(query_580041, "upload_protocol", newJString(uploadProtocol))
  add(query_580041, "fields", newJString(fields))
  add(query_580041, "quotaUser", newJString(quotaUser))
  add(query_580041, "alt", newJString(alt))
  add(query_580041, "oauth_token", newJString(oauthToken))
  add(query_580041, "callback", newJString(callback))
  add(query_580041, "access_token", newJString(accessToken))
  add(query_580041, "uploadType", newJString(uploadType))
  add(query_580041, "key", newJString(key))
  add(query_580041, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580042 = body
  add(query_580041, "prettyPrint", newJBool(prettyPrint))
  result = call_580040.call(nil, query_580041, nil, nil, body_580042)

var jobsJobsBatchDelete* = Call_JobsJobsBatchDelete_580024(
    name: "jobsJobsBatchDelete", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:batchDelete",
    validator: validate_JobsJobsBatchDelete_580025, base: "/",
    url: url_JobsJobsBatchDelete_580026, schemes: {Scheme.Https})
type
  Call_JobsJobsDeleteByFilter_580043 = ref object of OpenApiRestCall_579421
proc url_JobsJobsDeleteByFilter_580045(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsDeleteByFilter_580044(path: JsonNode; query: JsonNode;
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
  var valid_580046 = query.getOrDefault("upload_protocol")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "upload_protocol", valid_580046
  var valid_580047 = query.getOrDefault("fields")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "fields", valid_580047
  var valid_580048 = query.getOrDefault("quotaUser")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "quotaUser", valid_580048
  var valid_580049 = query.getOrDefault("alt")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = newJString("json"))
  if valid_580049 != nil:
    section.add "alt", valid_580049
  var valid_580050 = query.getOrDefault("oauth_token")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "oauth_token", valid_580050
  var valid_580051 = query.getOrDefault("callback")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "callback", valid_580051
  var valid_580052 = query.getOrDefault("access_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "access_token", valid_580052
  var valid_580053 = query.getOrDefault("uploadType")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "uploadType", valid_580053
  var valid_580054 = query.getOrDefault("key")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "key", valid_580054
  var valid_580055 = query.getOrDefault("$.xgafv")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("1"))
  if valid_580055 != nil:
    section.add "$.xgafv", valid_580055
  var valid_580056 = query.getOrDefault("prettyPrint")
  valid_580056 = validateParameter(valid_580056, JBool, required = false,
                                 default = newJBool(true))
  if valid_580056 != nil:
    section.add "prettyPrint", valid_580056
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

proc call*(call_580058: Call_JobsJobsDeleteByFilter_580043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated. Use BatchDeleteJobs instead.
  ## 
  ## Deletes the specified job by filter. You can specify whether to
  ## synchronously wait for validation, indexing, and general processing to be
  ## completed before the response is returned.
  ## 
  let valid = call_580058.validator(path, query, header, formData, body)
  let scheme = call_580058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580058.url(scheme.get, call_580058.host, call_580058.base,
                         call_580058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580058, url, valid)

proc call*(call_580059: Call_JobsJobsDeleteByFilter_580043;
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
  var query_580060 = newJObject()
  var body_580061 = newJObject()
  add(query_580060, "upload_protocol", newJString(uploadProtocol))
  add(query_580060, "fields", newJString(fields))
  add(query_580060, "quotaUser", newJString(quotaUser))
  add(query_580060, "alt", newJString(alt))
  add(query_580060, "oauth_token", newJString(oauthToken))
  add(query_580060, "callback", newJString(callback))
  add(query_580060, "access_token", newJString(accessToken))
  add(query_580060, "uploadType", newJString(uploadType))
  add(query_580060, "key", newJString(key))
  add(query_580060, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580061 = body
  add(query_580060, "prettyPrint", newJBool(prettyPrint))
  result = call_580059.call(nil, query_580060, nil, nil, body_580061)

var jobsJobsDeleteByFilter* = Call_JobsJobsDeleteByFilter_580043(
    name: "jobsJobsDeleteByFilter", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:deleteByFilter",
    validator: validate_JobsJobsDeleteByFilter_580044, base: "/",
    url: url_JobsJobsDeleteByFilter_580045, schemes: {Scheme.Https})
type
  Call_JobsJobsHistogram_580062 = ref object of OpenApiRestCall_579421
proc url_JobsJobsHistogram_580064(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsHistogram_580063(path: JsonNode; query: JsonNode;
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
  var valid_580065 = query.getOrDefault("upload_protocol")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "upload_protocol", valid_580065
  var valid_580066 = query.getOrDefault("fields")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "fields", valid_580066
  var valid_580067 = query.getOrDefault("quotaUser")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "quotaUser", valid_580067
  var valid_580068 = query.getOrDefault("alt")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = newJString("json"))
  if valid_580068 != nil:
    section.add "alt", valid_580068
  var valid_580069 = query.getOrDefault("oauth_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "oauth_token", valid_580069
  var valid_580070 = query.getOrDefault("callback")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "callback", valid_580070
  var valid_580071 = query.getOrDefault("access_token")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "access_token", valid_580071
  var valid_580072 = query.getOrDefault("uploadType")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "uploadType", valid_580072
  var valid_580073 = query.getOrDefault("key")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "key", valid_580073
  var valid_580074 = query.getOrDefault("$.xgafv")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = newJString("1"))
  if valid_580074 != nil:
    section.add "$.xgafv", valid_580074
  var valid_580075 = query.getOrDefault("prettyPrint")
  valid_580075 = validateParameter(valid_580075, JBool, required = false,
                                 default = newJBool(true))
  if valid_580075 != nil:
    section.add "prettyPrint", valid_580075
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

proc call*(call_580077: Call_JobsJobsHistogram_580062; path: JsonNode;
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
  let valid = call_580077.validator(path, query, header, formData, body)
  let scheme = call_580077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580077.url(scheme.get, call_580077.host, call_580077.base,
                         call_580077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580077, url, valid)

proc call*(call_580078: Call_JobsJobsHistogram_580062; uploadProtocol: string = "";
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
  var query_580079 = newJObject()
  var body_580080 = newJObject()
  add(query_580079, "upload_protocol", newJString(uploadProtocol))
  add(query_580079, "fields", newJString(fields))
  add(query_580079, "quotaUser", newJString(quotaUser))
  add(query_580079, "alt", newJString(alt))
  add(query_580079, "oauth_token", newJString(oauthToken))
  add(query_580079, "callback", newJString(callback))
  add(query_580079, "access_token", newJString(accessToken))
  add(query_580079, "uploadType", newJString(uploadType))
  add(query_580079, "key", newJString(key))
  add(query_580079, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580080 = body
  add(query_580079, "prettyPrint", newJBool(prettyPrint))
  result = call_580078.call(nil, query_580079, nil, nil, body_580080)

var jobsJobsHistogram* = Call_JobsJobsHistogram_580062(name: "jobsJobsHistogram",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com",
    route: "/v2/jobs:histogram", validator: validate_JobsJobsHistogram_580063,
    base: "/", url: url_JobsJobsHistogram_580064, schemes: {Scheme.Https})
type
  Call_JobsJobsSearch_580081 = ref object of OpenApiRestCall_579421
proc url_JobsJobsSearch_580083(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsSearch_580082(path: JsonNode; query: JsonNode;
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
  var valid_580084 = query.getOrDefault("upload_protocol")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "upload_protocol", valid_580084
  var valid_580085 = query.getOrDefault("fields")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "fields", valid_580085
  var valid_580086 = query.getOrDefault("quotaUser")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "quotaUser", valid_580086
  var valid_580087 = query.getOrDefault("alt")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = newJString("json"))
  if valid_580087 != nil:
    section.add "alt", valid_580087
  var valid_580088 = query.getOrDefault("oauth_token")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "oauth_token", valid_580088
  var valid_580089 = query.getOrDefault("callback")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "callback", valid_580089
  var valid_580090 = query.getOrDefault("access_token")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "access_token", valid_580090
  var valid_580091 = query.getOrDefault("uploadType")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "uploadType", valid_580091
  var valid_580092 = query.getOrDefault("key")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "key", valid_580092
  var valid_580093 = query.getOrDefault("$.xgafv")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = newJString("1"))
  if valid_580093 != nil:
    section.add "$.xgafv", valid_580093
  var valid_580094 = query.getOrDefault("prettyPrint")
  valid_580094 = validateParameter(valid_580094, JBool, required = false,
                                 default = newJBool(true))
  if valid_580094 != nil:
    section.add "prettyPrint", valid_580094
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

proc call*(call_580096: Call_JobsJobsSearch_580081; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for jobs using the provided SearchJobsRequest.
  ## 
  ## This call constrains the visibility of jobs
  ## present in the database, and only returns jobs that the caller has
  ## permission to search against.
  ## 
  let valid = call_580096.validator(path, query, header, formData, body)
  let scheme = call_580096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580096.url(scheme.get, call_580096.host, call_580096.base,
                         call_580096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580096, url, valid)

proc call*(call_580097: Call_JobsJobsSearch_580081; uploadProtocol: string = "";
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
  var query_580098 = newJObject()
  var body_580099 = newJObject()
  add(query_580098, "upload_protocol", newJString(uploadProtocol))
  add(query_580098, "fields", newJString(fields))
  add(query_580098, "quotaUser", newJString(quotaUser))
  add(query_580098, "alt", newJString(alt))
  add(query_580098, "oauth_token", newJString(oauthToken))
  add(query_580098, "callback", newJString(callback))
  add(query_580098, "access_token", newJString(accessToken))
  add(query_580098, "uploadType", newJString(uploadType))
  add(query_580098, "key", newJString(key))
  add(query_580098, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580099 = body
  add(query_580098, "prettyPrint", newJBool(prettyPrint))
  result = call_580097.call(nil, query_580098, nil, nil, body_580099)

var jobsJobsSearch* = Call_JobsJobsSearch_580081(name: "jobsJobsSearch",
    meth: HttpMethod.HttpPost, host: "jobs.googleapis.com",
    route: "/v2/jobs:search", validator: validate_JobsJobsSearch_580082, base: "/",
    url: url_JobsJobsSearch_580083, schemes: {Scheme.Https})
type
  Call_JobsJobsSearchForAlert_580100 = ref object of OpenApiRestCall_579421
proc url_JobsJobsSearchForAlert_580102(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsJobsSearchForAlert_580101(path: JsonNode; query: JsonNode;
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
  var valid_580103 = query.getOrDefault("upload_protocol")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "upload_protocol", valid_580103
  var valid_580104 = query.getOrDefault("fields")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "fields", valid_580104
  var valid_580105 = query.getOrDefault("quotaUser")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "quotaUser", valid_580105
  var valid_580106 = query.getOrDefault("alt")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = newJString("json"))
  if valid_580106 != nil:
    section.add "alt", valid_580106
  var valid_580107 = query.getOrDefault("oauth_token")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "oauth_token", valid_580107
  var valid_580108 = query.getOrDefault("callback")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "callback", valid_580108
  var valid_580109 = query.getOrDefault("access_token")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "access_token", valid_580109
  var valid_580110 = query.getOrDefault("uploadType")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "uploadType", valid_580110
  var valid_580111 = query.getOrDefault("key")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "key", valid_580111
  var valid_580112 = query.getOrDefault("$.xgafv")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = newJString("1"))
  if valid_580112 != nil:
    section.add "$.xgafv", valid_580112
  var valid_580113 = query.getOrDefault("prettyPrint")
  valid_580113 = validateParameter(valid_580113, JBool, required = false,
                                 default = newJBool(true))
  if valid_580113 != nil:
    section.add "prettyPrint", valid_580113
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

proc call*(call_580115: Call_JobsJobsSearchForAlert_580100; path: JsonNode;
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
  let valid = call_580115.validator(path, query, header, formData, body)
  let scheme = call_580115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580115.url(scheme.get, call_580115.host, call_580115.base,
                         call_580115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580115, url, valid)

proc call*(call_580116: Call_JobsJobsSearchForAlert_580100;
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
  var query_580117 = newJObject()
  var body_580118 = newJObject()
  add(query_580117, "upload_protocol", newJString(uploadProtocol))
  add(query_580117, "fields", newJString(fields))
  add(query_580117, "quotaUser", newJString(quotaUser))
  add(query_580117, "alt", newJString(alt))
  add(query_580117, "oauth_token", newJString(oauthToken))
  add(query_580117, "callback", newJString(callback))
  add(query_580117, "access_token", newJString(accessToken))
  add(query_580117, "uploadType", newJString(uploadType))
  add(query_580117, "key", newJString(key))
  add(query_580117, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580118 = body
  add(query_580117, "prettyPrint", newJBool(prettyPrint))
  result = call_580116.call(nil, query_580117, nil, nil, body_580118)

var jobsJobsSearchForAlert* = Call_JobsJobsSearchForAlert_580100(
    name: "jobsJobsSearchForAlert", meth: HttpMethod.HttpPost,
    host: "jobs.googleapis.com", route: "/v2/jobs:searchForAlert",
    validator: validate_JobsJobsSearchForAlert_580101, base: "/",
    url: url_JobsJobsSearchForAlert_580102, schemes: {Scheme.Https})
type
  Call_JobsCompaniesJobsList_580119 = ref object of OpenApiRestCall_579421
proc url_JobsCompaniesJobsList_580121(protocol: Scheme; host: string; base: string;
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

proc validate_JobsCompaniesJobsList_580120(path: JsonNode; query: JsonNode;
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
  var valid_580136 = path.getOrDefault("companyName")
  valid_580136 = validateParameter(valid_580136, JString, required = true,
                                 default = nil)
  if valid_580136 != nil:
    section.add "companyName", valid_580136
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
  var valid_580137 = query.getOrDefault("upload_protocol")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "upload_protocol", valid_580137
  var valid_580138 = query.getOrDefault("fields")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "fields", valid_580138
  var valid_580139 = query.getOrDefault("pageToken")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "pageToken", valid_580139
  var valid_580140 = query.getOrDefault("quotaUser")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "quotaUser", valid_580140
  var valid_580141 = query.getOrDefault("alt")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = newJString("json"))
  if valid_580141 != nil:
    section.add "alt", valid_580141
  var valid_580142 = query.getOrDefault("jobRequisitionId")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "jobRequisitionId", valid_580142
  var valid_580143 = query.getOrDefault("oauth_token")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "oauth_token", valid_580143
  var valid_580144 = query.getOrDefault("callback")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "callback", valid_580144
  var valid_580145 = query.getOrDefault("access_token")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "access_token", valid_580145
  var valid_580146 = query.getOrDefault("uploadType")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "uploadType", valid_580146
  var valid_580147 = query.getOrDefault("idsOnly")
  valid_580147 = validateParameter(valid_580147, JBool, required = false, default = nil)
  if valid_580147 != nil:
    section.add "idsOnly", valid_580147
  var valid_580148 = query.getOrDefault("includeJobsCount")
  valid_580148 = validateParameter(valid_580148, JBool, required = false, default = nil)
  if valid_580148 != nil:
    section.add "includeJobsCount", valid_580148
  var valid_580149 = query.getOrDefault("key")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "key", valid_580149
  var valid_580150 = query.getOrDefault("$.xgafv")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("1"))
  if valid_580150 != nil:
    section.add "$.xgafv", valid_580150
  var valid_580151 = query.getOrDefault("pageSize")
  valid_580151 = validateParameter(valid_580151, JInt, required = false, default = nil)
  if valid_580151 != nil:
    section.add "pageSize", valid_580151
  var valid_580152 = query.getOrDefault("prettyPrint")
  valid_580152 = validateParameter(valid_580152, JBool, required = false,
                                 default = newJBool(true))
  if valid_580152 != nil:
    section.add "prettyPrint", valid_580152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580153: Call_JobsCompaniesJobsList_580119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deprecated. Use ListJobs instead.
  ## 
  ## Lists all jobs associated with a company.
  ## 
  let valid = call_580153.validator(path, query, header, formData, body)
  let scheme = call_580153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580153.url(scheme.get, call_580153.host, call_580153.base,
                         call_580153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580153, url, valid)

proc call*(call_580154: Call_JobsCompaniesJobsList_580119; companyName: string;
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
  var path_580155 = newJObject()
  var query_580156 = newJObject()
  add(query_580156, "upload_protocol", newJString(uploadProtocol))
  add(query_580156, "fields", newJString(fields))
  add(query_580156, "pageToken", newJString(pageToken))
  add(query_580156, "quotaUser", newJString(quotaUser))
  add(query_580156, "alt", newJString(alt))
  add(query_580156, "jobRequisitionId", newJString(jobRequisitionId))
  add(query_580156, "oauth_token", newJString(oauthToken))
  add(query_580156, "callback", newJString(callback))
  add(query_580156, "access_token", newJString(accessToken))
  add(query_580156, "uploadType", newJString(uploadType))
  add(query_580156, "idsOnly", newJBool(idsOnly))
  add(query_580156, "includeJobsCount", newJBool(includeJobsCount))
  add(query_580156, "key", newJString(key))
  add(query_580156, "$.xgafv", newJString(Xgafv))
  add(query_580156, "pageSize", newJInt(pageSize))
  add(query_580156, "prettyPrint", newJBool(prettyPrint))
  add(path_580155, "companyName", newJString(companyName))
  result = call_580154.call(path_580155, query_580156, nil, nil, nil)

var jobsCompaniesJobsList* = Call_JobsCompaniesJobsList_580119(
    name: "jobsCompaniesJobsList", meth: HttpMethod.HttpGet,
    host: "jobs.googleapis.com", route: "/v2/{companyName}/jobs",
    validator: validate_JobsCompaniesJobsList_580120, base: "/",
    url: url_JobsCompaniesJobsList_580121, schemes: {Scheme.Https})
type
  Call_JobsCompaniesGet_580157 = ref object of OpenApiRestCall_579421
proc url_JobsCompaniesGet_580159(protocol: Scheme; host: string; base: string;
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

proc validate_JobsCompaniesGet_580158(path: JsonNode; query: JsonNode;
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
  var valid_580160 = path.getOrDefault("name")
  valid_580160 = validateParameter(valid_580160, JString, required = true,
                                 default = nil)
  if valid_580160 != nil:
    section.add "name", valid_580160
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
  var valid_580161 = query.getOrDefault("upload_protocol")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "upload_protocol", valid_580161
  var valid_580162 = query.getOrDefault("fields")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "fields", valid_580162
  var valid_580163 = query.getOrDefault("quotaUser")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "quotaUser", valid_580163
  var valid_580164 = query.getOrDefault("alt")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("json"))
  if valid_580164 != nil:
    section.add "alt", valid_580164
  var valid_580165 = query.getOrDefault("oauth_token")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "oauth_token", valid_580165
  var valid_580166 = query.getOrDefault("callback")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "callback", valid_580166
  var valid_580167 = query.getOrDefault("access_token")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "access_token", valid_580167
  var valid_580168 = query.getOrDefault("uploadType")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "uploadType", valid_580168
  var valid_580169 = query.getOrDefault("key")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "key", valid_580169
  var valid_580170 = query.getOrDefault("$.xgafv")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("1"))
  if valid_580170 != nil:
    section.add "$.xgafv", valid_580170
  var valid_580171 = query.getOrDefault("prettyPrint")
  valid_580171 = validateParameter(valid_580171, JBool, required = false,
                                 default = newJBool(true))
  if valid_580171 != nil:
    section.add "prettyPrint", valid_580171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580172: Call_JobsCompaniesGet_580157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified company.
  ## 
  let valid = call_580172.validator(path, query, header, formData, body)
  let scheme = call_580172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580172.url(scheme.get, call_580172.host, call_580172.base,
                         call_580172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580172, url, valid)

proc call*(call_580173: Call_JobsCompaniesGet_580157; name: string;
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
  var path_580174 = newJObject()
  var query_580175 = newJObject()
  add(query_580175, "upload_protocol", newJString(uploadProtocol))
  add(query_580175, "fields", newJString(fields))
  add(query_580175, "quotaUser", newJString(quotaUser))
  add(path_580174, "name", newJString(name))
  add(query_580175, "alt", newJString(alt))
  add(query_580175, "oauth_token", newJString(oauthToken))
  add(query_580175, "callback", newJString(callback))
  add(query_580175, "access_token", newJString(accessToken))
  add(query_580175, "uploadType", newJString(uploadType))
  add(query_580175, "key", newJString(key))
  add(query_580175, "$.xgafv", newJString(Xgafv))
  add(query_580175, "prettyPrint", newJBool(prettyPrint))
  result = call_580173.call(path_580174, query_580175, nil, nil, nil)

var jobsCompaniesGet* = Call_JobsCompaniesGet_580157(name: "jobsCompaniesGet",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesGet_580158, base: "/",
    url: url_JobsCompaniesGet_580159, schemes: {Scheme.Https})
type
  Call_JobsCompaniesPatch_580196 = ref object of OpenApiRestCall_579421
proc url_JobsCompaniesPatch_580198(protocol: Scheme; host: string; base: string;
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

proc validate_JobsCompaniesPatch_580197(path: JsonNode; query: JsonNode;
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
  var valid_580199 = path.getOrDefault("name")
  valid_580199 = validateParameter(valid_580199, JString, required = true,
                                 default = nil)
  if valid_580199 != nil:
    section.add "name", valid_580199
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
  var valid_580200 = query.getOrDefault("upload_protocol")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "upload_protocol", valid_580200
  var valid_580201 = query.getOrDefault("fields")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "fields", valid_580201
  var valid_580202 = query.getOrDefault("quotaUser")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "quotaUser", valid_580202
  var valid_580203 = query.getOrDefault("alt")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = newJString("json"))
  if valid_580203 != nil:
    section.add "alt", valid_580203
  var valid_580204 = query.getOrDefault("oauth_token")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "oauth_token", valid_580204
  var valid_580205 = query.getOrDefault("callback")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "callback", valid_580205
  var valid_580206 = query.getOrDefault("access_token")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "access_token", valid_580206
  var valid_580207 = query.getOrDefault("uploadType")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "uploadType", valid_580207
  var valid_580208 = query.getOrDefault("updateCompanyFields")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "updateCompanyFields", valid_580208
  var valid_580209 = query.getOrDefault("key")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "key", valid_580209
  var valid_580210 = query.getOrDefault("$.xgafv")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = newJString("1"))
  if valid_580210 != nil:
    section.add "$.xgafv", valid_580210
  var valid_580211 = query.getOrDefault("prettyPrint")
  valid_580211 = validateParameter(valid_580211, JBool, required = false,
                                 default = newJBool(true))
  if valid_580211 != nil:
    section.add "prettyPrint", valid_580211
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

proc call*(call_580213: Call_JobsCompaniesPatch_580196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified company. Company names can't be updated. To update a
  ## company name, delete the company and all jobs associated with it, and only
  ## then re-create them.
  ## 
  let valid = call_580213.validator(path, query, header, formData, body)
  let scheme = call_580213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580213.url(scheme.get, call_580213.host, call_580213.base,
                         call_580213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580213, url, valid)

proc call*(call_580214: Call_JobsCompaniesPatch_580196; name: string;
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
  var path_580215 = newJObject()
  var query_580216 = newJObject()
  var body_580217 = newJObject()
  add(query_580216, "upload_protocol", newJString(uploadProtocol))
  add(query_580216, "fields", newJString(fields))
  add(query_580216, "quotaUser", newJString(quotaUser))
  add(path_580215, "name", newJString(name))
  add(query_580216, "alt", newJString(alt))
  add(query_580216, "oauth_token", newJString(oauthToken))
  add(query_580216, "callback", newJString(callback))
  add(query_580216, "access_token", newJString(accessToken))
  add(query_580216, "uploadType", newJString(uploadType))
  add(query_580216, "updateCompanyFields", newJString(updateCompanyFields))
  add(query_580216, "key", newJString(key))
  add(query_580216, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580217 = body
  add(query_580216, "prettyPrint", newJBool(prettyPrint))
  result = call_580214.call(path_580215, query_580216, nil, nil, body_580217)

var jobsCompaniesPatch* = Call_JobsCompaniesPatch_580196(
    name: "jobsCompaniesPatch", meth: HttpMethod.HttpPatch,
    host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesPatch_580197, base: "/",
    url: url_JobsCompaniesPatch_580198, schemes: {Scheme.Https})
type
  Call_JobsCompaniesDelete_580176 = ref object of OpenApiRestCall_579421
proc url_JobsCompaniesDelete_580178(protocol: Scheme; host: string; base: string;
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

proc validate_JobsCompaniesDelete_580177(path: JsonNode; query: JsonNode;
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
  var valid_580179 = path.getOrDefault("name")
  valid_580179 = validateParameter(valid_580179, JString, required = true,
                                 default = nil)
  if valid_580179 != nil:
    section.add "name", valid_580179
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
  var valid_580180 = query.getOrDefault("upload_protocol")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "upload_protocol", valid_580180
  var valid_580181 = query.getOrDefault("fields")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "fields", valid_580181
  var valid_580182 = query.getOrDefault("quotaUser")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "quotaUser", valid_580182
  var valid_580183 = query.getOrDefault("alt")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = newJString("json"))
  if valid_580183 != nil:
    section.add "alt", valid_580183
  var valid_580184 = query.getOrDefault("oauth_token")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "oauth_token", valid_580184
  var valid_580185 = query.getOrDefault("callback")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "callback", valid_580185
  var valid_580186 = query.getOrDefault("access_token")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "access_token", valid_580186
  var valid_580187 = query.getOrDefault("uploadType")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "uploadType", valid_580187
  var valid_580188 = query.getOrDefault("key")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "key", valid_580188
  var valid_580189 = query.getOrDefault("$.xgafv")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = newJString("1"))
  if valid_580189 != nil:
    section.add "$.xgafv", valid_580189
  var valid_580190 = query.getOrDefault("disableFastProcess")
  valid_580190 = validateParameter(valid_580190, JBool, required = false, default = nil)
  if valid_580190 != nil:
    section.add "disableFastProcess", valid_580190
  var valid_580191 = query.getOrDefault("prettyPrint")
  valid_580191 = validateParameter(valid_580191, JBool, required = false,
                                 default = newJBool(true))
  if valid_580191 != nil:
    section.add "prettyPrint", valid_580191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580192: Call_JobsCompaniesDelete_580176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified company.
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_JobsCompaniesDelete_580176; name: string;
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
  var path_580194 = newJObject()
  var query_580195 = newJObject()
  add(query_580195, "upload_protocol", newJString(uploadProtocol))
  add(query_580195, "fields", newJString(fields))
  add(query_580195, "quotaUser", newJString(quotaUser))
  add(path_580194, "name", newJString(name))
  add(query_580195, "alt", newJString(alt))
  add(query_580195, "oauth_token", newJString(oauthToken))
  add(query_580195, "callback", newJString(callback))
  add(query_580195, "access_token", newJString(accessToken))
  add(query_580195, "uploadType", newJString(uploadType))
  add(query_580195, "key", newJString(key))
  add(query_580195, "$.xgafv", newJString(Xgafv))
  add(query_580195, "disableFastProcess", newJBool(disableFastProcess))
  add(query_580195, "prettyPrint", newJBool(prettyPrint))
  result = call_580193.call(path_580194, query_580195, nil, nil, nil)

var jobsCompaniesDelete* = Call_JobsCompaniesDelete_580176(
    name: "jobsCompaniesDelete", meth: HttpMethod.HttpDelete,
    host: "jobs.googleapis.com", route: "/v2/{name}",
    validator: validate_JobsCompaniesDelete_580177, base: "/",
    url: url_JobsCompaniesDelete_580178, schemes: {Scheme.Https})
type
  Call_JobsComplete_580218 = ref object of OpenApiRestCall_579421
proc url_JobsComplete_580220(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_JobsComplete_580219(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580221 = query.getOrDefault("upload_protocol")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "upload_protocol", valid_580221
  var valid_580222 = query.getOrDefault("fields")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "fields", valid_580222
  var valid_580223 = query.getOrDefault("quotaUser")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "quotaUser", valid_580223
  var valid_580224 = query.getOrDefault("scope")
  valid_580224 = validateParameter(valid_580224, JString, required = false, default = newJString(
      "COMPLETION_SCOPE_UNSPECIFIED"))
  if valid_580224 != nil:
    section.add "scope", valid_580224
  var valid_580225 = query.getOrDefault("alt")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = newJString("json"))
  if valid_580225 != nil:
    section.add "alt", valid_580225
  var valid_580226 = query.getOrDefault("query")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "query", valid_580226
  var valid_580227 = query.getOrDefault("type")
  valid_580227 = validateParameter(valid_580227, JString, required = false, default = newJString(
      "COMPLETION_TYPE_UNSPECIFIED"))
  if valid_580227 != nil:
    section.add "type", valid_580227
  var valid_580228 = query.getOrDefault("oauth_token")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "oauth_token", valid_580228
  var valid_580229 = query.getOrDefault("callback")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "callback", valid_580229
  var valid_580230 = query.getOrDefault("access_token")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "access_token", valid_580230
  var valid_580231 = query.getOrDefault("uploadType")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "uploadType", valid_580231
  var valid_580232 = query.getOrDefault("key")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "key", valid_580232
  var valid_580233 = query.getOrDefault("$.xgafv")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = newJString("1"))
  if valid_580233 != nil:
    section.add "$.xgafv", valid_580233
  var valid_580234 = query.getOrDefault("languageCode")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "languageCode", valid_580234
  var valid_580235 = query.getOrDefault("pageSize")
  valid_580235 = validateParameter(valid_580235, JInt, required = false, default = nil)
  if valid_580235 != nil:
    section.add "pageSize", valid_580235
  var valid_580236 = query.getOrDefault("companyName")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "companyName", valid_580236
  var valid_580237 = query.getOrDefault("prettyPrint")
  valid_580237 = validateParameter(valid_580237, JBool, required = false,
                                 default = newJBool(true))
  if valid_580237 != nil:
    section.add "prettyPrint", valid_580237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580238: Call_JobsComplete_580218; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Completes the specified prefix with job keyword suggestions.
  ## Intended for use by a job search auto-complete search box.
  ## 
  let valid = call_580238.validator(path, query, header, formData, body)
  let scheme = call_580238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580238.url(scheme.get, call_580238.host, call_580238.base,
                         call_580238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580238, url, valid)

proc call*(call_580239: Call_JobsComplete_580218; uploadProtocol: string = "";
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
  var query_580240 = newJObject()
  add(query_580240, "upload_protocol", newJString(uploadProtocol))
  add(query_580240, "fields", newJString(fields))
  add(query_580240, "quotaUser", newJString(quotaUser))
  add(query_580240, "scope", newJString(scope))
  add(query_580240, "alt", newJString(alt))
  add(query_580240, "query", newJString(query))
  add(query_580240, "type", newJString(`type`))
  add(query_580240, "oauth_token", newJString(oauthToken))
  add(query_580240, "callback", newJString(callback))
  add(query_580240, "access_token", newJString(accessToken))
  add(query_580240, "uploadType", newJString(uploadType))
  add(query_580240, "key", newJString(key))
  add(query_580240, "$.xgafv", newJString(Xgafv))
  add(query_580240, "languageCode", newJString(languageCode))
  add(query_580240, "pageSize", newJInt(pageSize))
  add(query_580240, "companyName", newJString(companyName))
  add(query_580240, "prettyPrint", newJBool(prettyPrint))
  result = call_580239.call(nil, query_580240, nil, nil, nil)

var jobsComplete* = Call_JobsComplete_580218(name: "jobsComplete",
    meth: HttpMethod.HttpGet, host: "jobs.googleapis.com", route: "/v2:complete",
    validator: validate_JobsComplete_580219, base: "/", url: url_JobsComplete_580220,
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
